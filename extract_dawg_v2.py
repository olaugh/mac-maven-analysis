#!/usr/bin/env python3
"""
Extract dictionary from Maven's DAWG structure - v2

Corrected implementation based on CODE 5, 7, 11, 21 analysis:

File Structure:
- DAWG1 at 0x0 - 0x8e520: SOWPODS (combined TWL+OSW dictionary)
- DAWG2 at 0x8e520+: OSW (British dictionary only)

DAWG Node Format (4 bytes):
- Bytes 0-1: ptr (big-endian 16-bit)
- Byte 2: flags
    - Bit 7 (0x80): Word marker
    - Bit 0 (0x01): Last sibling in group
    - Bits 1-6: Offset added to ptr for child calculation
- Byte 3: letter (ASCII lowercase a-z)

Child Calculation: child_entry = ptr + (flags & 0x7e)

Dictionary Differentiation:
- SOWPODS words = all words in DAWG1
- OSW words = all words in DAWG2
- TWL words = SOWPODS - OSW (words in SOWPODS but not OSW)

Usage:
    python3 extract_dawg_v2.py                     # Extract and enumerate
    python3 extract_dawg_v2.py --validate FILE    # Validate reference wordlist
    python3 extract_dawg_v2.py --compare          # Show TWL-only and OSW-only words
"""

import struct
import sys
import os
from collections import defaultdict

DEFAULT_DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
OUTPUT_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/lexica"

# DAWG1 (SOWPODS) structure
DAWG1_HEADER_OFFSET = 0x0
DAWG1_LETTER_INDEX = 0x10
DAWG1_NODE_START = 0x410  # Nodes start after header + index + padding

# DAWG2 (OSW) structure - determined from analysis
DAWG2_OFFSET = 0x8e520
DAWG2_LETTER_INDEX = DAWG2_OFFSET + 0x10
DAWG2_NODE_START = DAWG2_OFFSET + 0x410

# Node flag bits
FLAG_WORD = 0x80    # Valid word marker
FLAG_LAST = 0x01    # Last sibling in group


class DAWGExtractor:
    """Extract words from Maven's DAWG dictionary."""

    def __init__(self, filepath, node_start, letter_index_offset, max_entries=None):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        self.node_start = node_start
        self.letter_index_offset = letter_index_offset

        # Parse header to get section boundaries
        header_offset = node_start - 0x410
        self.section1_end = struct.unpack('>I', self.data[header_offset:header_offset+4])[0]
        self.section2_end = struct.unpack('>I', self.data[header_offset+4:header_offset+8])[0]

        if max_entries:
            self.section1_end = min(self.section1_end, max_entries)
            self.section2_end = min(self.section2_end, max_entries)

        # Parse letter index
        self.letter_index = self._parse_letter_index()

    def _parse_letter_index(self):
        """Parse the 26-entry letter index."""
        index = {}
        for i in range(26):
            offset = self.letter_index_offset + i * 4
            if offset + 4 > len(self.data):
                break
            b0, b1, flags, letter = self.data[offset:offset+4]
            entry = (b0 << 8) | b1
            letter_char = chr(ord('a') + i)
            index[letter_char] = {
                'entry': entry,
                'flags': flags,
                'raw_letter': letter,
            }
        return index

    def get_node(self, entry_idx):
        """Get node at given entry index."""
        offset = self.node_start + entry_idx * 4
        if offset + 4 > len(self.data):
            return None

        b0, b1, flags, letter = self.data[offset:offset+4]
        ptr = (b0 << 8) | b1

        # Valid letters are a-z (0x61-0x7a)
        if not (97 <= letter <= 122):
            return None

        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter),
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'entry': entry_idx,
        }

    def get_child_entry(self, node):
        """Calculate child entry index using correct formula."""
        if node['ptr'] == 0:
            return None
        # Child = ptr + (flags & 0x7e)
        return node['ptr'] + (node['flags'] & 0x7e)

    def get_sibling_group(self, start_entry, max_siblings=200):
        """Get all siblings in a group starting from given entry."""
        siblings = []
        entry = start_entry

        while len(siblings) < max_siblings:
            node = self.get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1

        return siblings

    def enumerate_section1(self, max_words=None):
        """
        Enumerate words from Section 1 (reversed storage).

        Section 1 stores words with letters reversed, indexed by LAST letter.
        To find word "THE", look up 'E' in index, find path E-H-T.
        """
        words = []

        def traverse(entry, suffix, depth=0):
            """DFS traversal, building words by prepending letters."""
            if depth > 20:
                return
            if max_words and len(words) >= max_words:
                return

            siblings = self.get_sibling_group(entry)

            for node in siblings:
                if max_words and len(words) >= max_words:
                    return

                # Build word so far (prepending this letter)
                word_so_far = node['letter'] + suffix

                # If WORD flag set, this forms a valid word
                if node['is_word'] and len(word_so_far) >= 2:
                    words.append(word_so_far)

                # Follow children if any
                child = self.get_child_entry(node)
                if child is not None and child < self.section1_end:
                    traverse(child, word_so_far, depth + 1)

        # Start from each letter's index entry
        for letter in 'abcdefghijklmnopqrstuvwxyz':
            if max_words and len(words) >= max_words:
                break
            if letter not in self.letter_index:
                continue

            start_entry = self.letter_index[letter]['entry']
            if start_entry > 0:
                # Words indexed under this letter END with this letter
                traverse(start_entry, letter, 0)

        return words

    def enumerate_section2(self, max_words=None):
        """
        Enumerate words from Section 2 (forward storage).

        Section 2 entries provide forward access to words.
        Children point back into Section 1.
        """
        words = []

        def traverse(entry, prefix, depth=0):
            """DFS traversal, building words by appending letters."""
            if depth > 20:
                return
            if max_words and len(words) >= max_words:
                return

            siblings = self.get_sibling_group(entry)

            for node in siblings:
                if max_words and len(words) >= max_words:
                    return

                word_so_far = prefix + node['letter']

                if node['is_word'] and len(word_so_far) >= 2:
                    words.append(word_so_far)

                child = self.get_child_entry(node)
                if child is not None:
                    traverse(child, word_so_far, depth + 1)

        # Scan Section 2 for root entries
        for entry_idx in range(self.section1_end, min(self.section2_end, self.section1_end + 10000)):
            if max_words and len(words) >= max_words:
                break
            node = self.get_node(entry_idx)
            if node and node['is_word']:
                # This is a valid 1-letter prefix that forms words
                child = self.get_child_entry(node)
                if child:
                    traverse(child, node['letter'], 1)

        return words

    def validate_word(self, word):
        """Check if a word exists in the DAWG."""
        if len(word) < 2:
            return False

        word = word.lower()

        # Check Section 1 (reversed)
        if self._validate_reversed(word):
            return True

        # Check Section 2 (forward)
        if self._validate_forward(word):
            return True

        return False

    def _validate_reversed(self, word):
        """Validate word using Section 1 (reversed storage)."""
        reversed_word = word[::-1]
        first_letter = reversed_word[0]

        if first_letter not in self.letter_index:
            return False

        start_entry = self.letter_index[first_letter]['entry']
        if start_entry == 0:
            return False

        return self._search_path(start_entry, reversed_word[1:], self.section1_end)

    def _validate_forward(self, word):
        """Validate word using Section 2 (forward storage)."""
        first_letter = word[0]

        # Scan Section 2 for matching first letter
        for entry_idx in range(self.section1_end, self.section2_end):
            node = self.get_node(entry_idx)
            if node and node['letter'] == first_letter:
                if self._match_path(node, word[1:]):
                    return True

        return False

    def _search_path(self, start_entry, remaining, max_entry):
        """Search for remaining letters starting from given entry."""
        if not remaining:
            # No more letters - check if current position is valid word ending
            siblings = self.get_sibling_group(start_entry)
            # We matched all letters if we got here via successful path
            return True

        target = remaining[0]
        rest = remaining[1:]

        siblings = self.get_sibling_group(start_entry)

        for node in siblings:
            if node['letter'] == target:
                if not rest:
                    # Last letter - check word flag
                    return node['is_word']
                else:
                    # More letters - follow child
                    child = self.get_child_entry(node)
                    if child is not None and child < max_entry:
                        if self._search_path(child, rest, max_entry):
                            return True

        return False

    def _match_path(self, start_node, remaining):
        """Match remaining letters following children from start_node."""
        if not remaining:
            return start_node['is_word']

        child = self.get_child_entry(start_node)
        if child is None:
            return False

        target = remaining[0]
        rest = remaining[1:]

        siblings = self.get_sibling_group(child)

        for node in siblings:
            if node['letter'] == target:
                if not rest:
                    return node['is_word']
                else:
                    if self._match_path(node, rest):
                        return True

        return False


def extract_sowpods(filepath=DEFAULT_DAWG_PATH, max_words=None):
    """Extract SOWPODS dictionary from DAWG1."""
    print("Extracting SOWPODS from DAWG1...")
    dawg = DAWGExtractor(filepath, DAWG1_NODE_START, DAWG1_LETTER_INDEX)

    print(f"  Section 1 end: {dawg.section1_end}")
    print(f"  Section 2 end: {dawg.section2_end}")

    words = dawg.enumerate_section1(max_words)
    words = sorted(set(words))

    print(f"  Extracted {len(words)} unique words")
    return words, dawg


def extract_osw(filepath=DEFAULT_DAWG_PATH, max_words=None):
    """Extract OSW dictionary from DAWG2."""
    print("Extracting OSW from DAWG2...")

    # Check if DAWG2 exists at expected offset
    with open(filepath, 'rb') as f:
        f.seek(DAWG2_OFFSET)
        header = f.read(16)

    if len(header) < 16:
        print("  DAWG2 not found at expected offset")
        return [], None

    dawg = DAWGExtractor(filepath, DAWG2_NODE_START, DAWG2_LETTER_INDEX)

    print(f"  Section 1 end: {dawg.section1_end}")
    print(f"  Section 2 end: {dawg.section2_end}")

    words = dawg.enumerate_section1(max_words)
    words = sorted(set(words))

    print(f"  Extracted {len(words)} unique words")
    return words, dawg


def validate_reference(filepath=DEFAULT_DAWG_PATH, reference_path=None):
    """Validate a reference wordlist against the DAWG."""
    if reference_path is None:
        reference_path = os.path.join(OUTPUT_DIR, "../lexica/sowpods2003.txt")

    if not os.path.exists(reference_path):
        print(f"Reference file not found: {reference_path}")
        return

    print(f"Loading reference: {reference_path}")
    with open(reference_path) as f:
        ref_words = [line.strip().lower() for line in f if line.strip()]
    print(f"  Loaded {len(ref_words)} reference words")

    dawg = DAWGExtractor(filepath, DAWG1_NODE_START, DAWG1_LETTER_INDEX)

    print("\nValidating words...")
    found = []
    missing = []

    for i, word in enumerate(ref_words):
        if i % 25000 == 0:
            print(f"  Progress: {i}/{len(ref_words)}")

        if dawg.validate_word(word):
            found.append(word)
        else:
            missing.append(word)

    print(f"\nResults:")
    print(f"  Found: {len(found)} ({100*len(found)/len(ref_words):.1f}%)")
    print(f"  Missing: {len(missing)} ({100*len(missing)/len(ref_words):.1f}%)")

    print(f"\nSample missing 2-letter: {[w for w in missing if len(w) == 2][:20]}")
    print(f"Sample missing 3-letter: {[w for w in missing if len(w) == 3][:20]}")

    return found, missing


def compare_dictionaries(filepath=DEFAULT_DAWG_PATH, max_words=50000):
    """Compare SOWPODS and OSW to find TWL-only words."""
    sowpods, _ = extract_sowpods(filepath, max_words)
    osw, _ = extract_osw(filepath, max_words)

    sowpods_set = set(sowpods)
    osw_set = set(osw)

    twl_only = sowpods_set - osw_set  # In SOWPODS but not OSW
    osw_only = osw_set - sowpods_set  # In OSW but not SOWPODS (shouldn't exist)
    common = sowpods_set & osw_set

    print(f"\nDictionary comparison:")
    print(f"  SOWPODS words: {len(sowpods_set)}")
    print(f"  OSW words: {len(osw_set)}")
    print(f"  Common words: {len(common)}")
    print(f"  TWL-only: {len(twl_only)}")
    print(f"  OSW-only: {len(osw_only)}")

    # Known TWL-only test words
    twl_test = ['hmm', 'hm', 'mm', 'brr', 'brrr', 'grr']
    for word in twl_test:
        in_sowpods = word in sowpods_set
        in_osw = word in osw_set
        status = "TWL-only" if in_sowpods and not in_osw else "Both" if in_sowpods and in_osw else "Neither"
        print(f"  {word}: SOWPODS={in_sowpods}, OSW={in_osw} -> {status}")

    return {
        'sowpods': sowpods_set,
        'osw': osw_set,
        'twl_only': twl_only,
        'osw_only': osw_only,
        'common': common,
    }


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--validate':
        ref_path = sys.argv[2] if len(sys.argv) > 2 else None
        validate_reference(DEFAULT_DAWG_PATH, ref_path)
    elif len(sys.argv) > 1 and sys.argv[1] == '--compare':
        compare_dictionaries(DEFAULT_DAWG_PATH)
    else:
        # Default: enumerate and save
        sowpods, dawg = extract_sowpods(DEFAULT_DAWG_PATH)

        # Statistics
        by_length = defaultdict(int)
        for w in sowpods:
            by_length[len(w)] += 1

        print(f"\nWord length distribution:")
        for length in sorted(by_length.keys())[:12]:
            print(f"  {length:2d} letters: {by_length[length]:6d} words")

        # 2-letter words
        two_letter = sorted([w for w in sowpods if len(w) == 2])
        print(f"\n2-letter words ({len(two_letter)}):")
        print(f"  {two_letter}")

        # Test words
        test_words = ['aa', 'ab', 'qi', 'the', 'cat', 'dog', 'zax', 'hmm', 'qat']
        print(f"\nTest words:")
        for w in test_words:
            print(f"  {w}: {'FOUND' if w in sowpods else 'missing'}")

        # Save to file
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        output_path = os.path.join(OUTPUT_DIR, "sowpods_extracted.txt")
        with open(output_path, 'w') as f:
            for word in sowpods:
                f.write(word + '\n')
        print(f"\nSaved {len(sowpods)} words to {output_path}")


if __name__ == "__main__":
    main()
