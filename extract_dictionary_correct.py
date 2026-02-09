#!/usr/bin/env python3
"""
Extract dictionary from Maven's DAWG using correct root structure.

Based on reverse engineering findings:
- Section 1: Reversed DAWG (words stored suffix-first)
- Section 2: Forward DAWG (words stored prefix-first)
- Letter index at offset 0x10 gives 26 entry points (one per letter)
- Node array starts at offset 0x410 (1040)

Node format (4 bytes, big-endian):
- Bytes 0-1: Base pointer (16-bit)
- Byte 2: Flags
  - Bit 7: is_word (this node completes a valid word)
  - Bit 0: is_last (last sibling in group)
  - Bits 1-6: Child offset (added to base pointer)
- Byte 3: Letter (ASCII 'a'-'z' = 97-122)
"""

import struct
from collections import defaultdict

# File offsets
HEADER_START = 0x00
LETTER_INDEX_START = 0x10
NODE_START = 0x410

class DAWGExtractor:
    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        # Parse header
        self.section1_end = struct.unpack('>I', self.data[0:4])[0]
        self.section2_end = struct.unpack('>I', self.data[4:8])[0]

        # Parse letter index (26 entries, 4 bytes each)
        self.letter_index = {}
        for i in range(26):
            offset = LETTER_INDEX_START + i * 4
            entry = struct.unpack('>H', self.data[offset:offset+2])[0]
            letter = chr(ord('a') + i)
            self.letter_index[letter] = entry

        print(f"Section 1: 0 to {self.section1_end-1} ({self.section1_end} nodes)")
        print(f"Section 2: {self.section1_end} to {self.section2_end-1} ({self.section2_end - self.section1_end} nodes)")

    def get_node(self, entry_idx):
        """Get node at entry index."""
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None

        b0, b1, flags, letter_byte = self.data[offset:offset+4]

        if not (97 <= letter_byte <= 122):  # a-z
            return None

        base_ptr = (b0 << 8) | b1
        is_word = (flags & 0x80) != 0
        is_last = (flags & 0x01) != 0
        child_offset = (flags >> 1) & 0x3F  # bits 1-6
        child = base_ptr + child_offset if base_ptr > 0 else 0

        return {
            'letter': chr(letter_byte),
            'is_word': is_word,
            'is_last': is_last,
            'child': child,
            'base_ptr': base_ptr,
            'flags': flags,
            'entry': entry_idx,
        }

    def get_sibling_group(self, start_entry, max_entry=None):
        """Get all siblings starting from start_entry until is_last is set."""
        if max_entry is None:
            max_entry = self.section1_end

        siblings = []
        entry = start_entry
        while entry < max_entry:
            node = self.get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    def extract_section1_words(self):
        """
        Extract words from Section 1 (reversed DAWG).

        The letter index gives entry points for words ENDING with each letter.
        We traverse and build words in reverse.
        """
        words = set()

        for last_letter in 'abcdefghijklmnopqrstuvwxyz':
            root_entry = self.letter_index[last_letter]
            if root_entry == 0 or root_entry >= self.section1_end:
                continue

            # Get root siblings (these are the second-to-last letters of words ending in last_letter)
            root_siblings = self.get_sibling_group(root_entry, self.section1_end)

            # DFS traversal building words in reverse
            # Stack: (current_siblings, sibling_index, word_so_far_reversed)
            stack = [(root_siblings, 0, last_letter)]

            while stack:
                siblings, idx, word_rev = stack.pop()

                if idx >= len(siblings):
                    continue

                node = siblings[idx]
                new_word_rev = node['letter'] + word_rev

                # Push next sibling to process later
                if idx + 1 < len(siblings):
                    stack.append((siblings, idx + 1, word_rev))

                # If this completes a word, record it
                if node['is_word']:
                    word = new_word_rev[::-1]  # Reverse to get actual word
                    words.add(word)

                # If there are children, traverse them
                if node['child'] > 0 and node['child'] < self.section1_end:
                    child_siblings = self.get_sibling_group(node['child'], self.section1_end)
                    if child_siblings:
                        stack.append((child_siblings, 0, new_word_rev))

        return words

    def extract_section2_words(self):
        """
        Extract words from Section 2 (forward DAWG).

        Section 2 nodes use the same format but traverse forward.
        """
        words = set()

        # Section 2 entries are indexed differently - they're direct entries
        # We need to find root entries in Section 2
        section2_roots = defaultdict(list)

        for entry_idx in range(self.section1_end, self.section2_end):
            node = self.get_node(entry_idx)
            if node:
                section2_roots[node['letter']].append(entry_idx)

        # For each root letter, traverse forward
        for first_letter, root_entries in section2_roots.items():
            for root_entry in root_entries:
                node = self.get_node(root_entry)
                if node is None:
                    continue

                # DFS traversal building words forward
                stack = [(node, first_letter)]

                while stack:
                    current, word = stack.pop()

                    if current['is_word']:
                        words.add(word)

                    # Follow child pointer (goes into Section 1)
                    if current['child'] > 0 and current['child'] < self.section1_end:
                        child_siblings = self.get_sibling_group(current['child'], self.section1_end)
                        for child in child_siblings:
                            stack.append((child, word + child['letter']))

        return words

    def extract_all_words(self):
        """Extract all words from both sections."""
        print("\nExtracting from Section 1 (reversed DAWG)...")
        words1 = self.extract_section1_words()
        print(f"  Found {len(words1)} words")

        print("\nExtracting from Section 2 (forward DAWG)...")
        words2 = self.extract_section2_words()
        print(f"  Found {len(words2)} words")

        # Combine (should be the same words, different access patterns)
        all_words = words1 | words2
        print(f"\nTotal unique words: {len(all_words)}")

        return all_words


def validate_against_known(words):
    """Check extraction against known 2-letter words."""
    known_2letter = {
        'aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
        'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
        'by', 'da', 'de', 'di', 'do', 'ed', 'ef', 'eh', 'el', 'em',
        'en', 'er', 'es', 'et', 'ex', 'fa', 'go', 'gu', 'ha', 'he',
        'hi', 'hm', 'ho', 'id', 'if', 'in', 'is', 'it', 'jo', 'ka',
        'ki', 'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu',
        'my', 'na', 'ne', 'no', 'nu', 'od', 'oe', 'of', 'oh', 'oi',
        'om', 'on', 'oo', 'op', 'or', 'os', 'ou', 'ow', 'ox', 'oy',
        'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh', 'si', 'so', 'st',
        'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um', 'un', 'up', 'ur',
        'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye', 'yo', 'za'
    }

    fake_2letter = {'ac', 'af', 'ak', 'ap', 'aq', 'av', 'bb', 'cc', 'dd'}

    extracted_2letter = {w for w in words if len(w) == 2}

    print("\n" + "=" * 60)
    print("Validation against known 2-letter words")
    print("=" * 60)

    found = known_2letter & extracted_2letter
    missing = known_2letter - extracted_2letter
    extra = extracted_2letter - known_2letter
    false_pos = fake_2letter & extracted_2letter

    print(f"Known 2-letter words found: {len(found)}/{len(known_2letter)}")
    if missing:
        print(f"Missing: {sorted(missing)}")

    print(f"\nFalse positives from fake list: {len(false_pos)}/{len(fake_2letter)}")
    if false_pos:
        print(f"  {sorted(false_pos)}")

    print(f"\nExtra 2-letter combinations found: {len(extra)}")
    if extra and len(extra) <= 50:
        print(f"  {sorted(extra)}")
    elif extra:
        print(f"  (too many to list)")

    return len(found), len(missing), len(extra)


def main():
    extractor = DAWGExtractor("/Volumes/T7/retrogames/oldmac/share/maven2")

    # Show letter index
    print("\n" + "=" * 60)
    print("Letter Index")
    print("=" * 60)
    for letter in 'abcdefghijklmnopqrstuvwxyz':
        entry = extractor.letter_index[letter]
        print(f"  {letter}: entry {entry}")

    # Extract words
    words = extractor.extract_all_words()

    # Validate
    validate_against_known(words)

    # Show word length distribution
    print("\n" + "=" * 60)
    print("Word length distribution")
    print("=" * 60)
    length_dist = defaultdict(int)
    for w in words:
        length_dist[len(w)] += 1
    for length in sorted(length_dist.keys()):
        print(f"  {length} letters: {length_dist[length]} words")

    # Save to file
    output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/extracted_correct.txt"
    with open(output_path, 'w') as f:
        for word in sorted(words):
            f.write(word + '\n')
    print(f"\nSaved {len(words)} words to {output_path}")

    # Show some sample words
    print("\n" + "=" * 60)
    print("Sample words by length")
    print("=" * 60)
    by_length = defaultdict(list)
    for w in words:
        by_length[len(w)].append(w)

    for length in [2, 3, 4, 5, 10, 15]:
        if length in by_length:
            sample = sorted(by_length[length])[:10]
            print(f"  {length}-letter: {', '.join(sample)}...")


if __name__ == "__main__":
    main()
