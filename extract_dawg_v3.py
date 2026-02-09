#!/usr/bin/env python3
"""
Extract dictionary from Maven's DAWG structure - v3

Corrected based on actual header analysis:

Header at 0x0 (16 bytes, 4 big-endian 32-bit words):
  Word 0: 56630  - Section 1 end (reversed words)
  Word 1: 122166 - Section 2 end
  Word 2: 145476 - Section 3 end (total DAWG1 entries)
  Word 3: 768    - Unknown (padding?)

Letter index: 0x10 - 0x7F (26 entries, 4 bytes each)
Node data: 0x410 onwards (4 bytes per node)

Node format (4 bytes):
  Bytes 0-1: ptr (big-endian 16-bit)
  Byte 2: flags
    - Bit 7 (0x80): Word end marker
    - Bit 0 (0x01): Last sibling
    - Bits 1-6: Added to ptr for child calculation
  Byte 3: letter (ASCII lowercase)

Child calculation: child_entry = ptr + (flags & 0x7e)
"""

import struct
import sys
from collections import defaultdict

DEFAULT_DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
OUTPUT_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/lexica"

FLAG_WORD = 0x80
FLAG_LAST = 0x01


class DAWGExtractor:
    def __init__(self, filepath=DEFAULT_DAWG_PATH, max_entries=None):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        # Parse header
        self.section1_end = struct.unpack('>I', self.data[0:4])[0]
        self.section2_end = struct.unpack('>I', self.data[4:8])[0]
        self.section3_end = struct.unpack('>I', self.data[8:12])[0]
        self.header_word3 = struct.unpack('>I', self.data[12:16])[0]

        if max_entries:
            self.section1_end = min(self.section1_end, max_entries)
            self.section2_end = min(self.section2_end, max_entries)
            self.section3_end = min(self.section3_end, max_entries)

        self.letter_index_offset = 0x10
        self.node_start = 0x410

        # Parse letter index
        self.letter_index = {}
        for i in range(26):
            offset = self.letter_index_offset + i * 4
            b0, b1, flags, letter = self.data[offset:offset+4]
            entry = (b0 << 8) | b1
            self.letter_index[chr(ord('a') + i)] = entry

        print(f"DAWG loaded:")
        print(f"  Section 1: 0 - {self.section1_end} ({self.section1_end} entries)")
        print(f"  Section 2: {self.section1_end} - {self.section2_end} ({self.section2_end - self.section1_end} entries)")
        print(f"  Section 3: {self.section2_end} - {self.section3_end} ({self.section3_end - self.section2_end} entries)")

    def get_node(self, entry_idx):
        """Get node at given entry index."""
        offset = self.node_start + entry_idx * 4
        if offset + 4 > len(self.data):
            return None

        b0, b1, flags, letter = self.data[offset:offset+4]
        ptr = (b0 << 8) | b1

        if not (97 <= letter <= 122):  # a-z only
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
        """Calculate child entry index."""
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def enumerate_words(self, max_words=None, section_limit=None):
        """
        Enumerate all words from Section 1 (reversed storage).

        Words are stored reversed, indexed by last letter.
        For word "THE": look up 'E', traverse E->H->T with word marker.
        """
        words = set()  # Use set to avoid duplicates
        visited = set()  # Cycle detection

        if section_limit is None:
            section_limit = self.section1_end

        def traverse(entry, suffix, depth=0):
            if depth > 20:  # Max word length
                return
            if max_words and len(words) >= max_words:
                return
            if entry in visited:
                return

            visited.add(entry)

            # Get all siblings at this position
            siblings = []
            current = entry
            seen_in_group = set()

            while len(siblings) < 100:  # Safety limit for sibling group
                if current in seen_in_group:
                    break
                seen_in_group.add(current)

                node = self.get_node(current)
                if node is None:
                    break
                siblings.append(node)
                if node['is_last']:
                    break
                current += 1

            for node in siblings:
                if max_words and len(words) >= max_words:
                    return

                # Build word by prepending this letter to suffix
                word = node['letter'] + suffix

                if node['is_word'] and len(word) >= 2:
                    words.add(word)

                # Follow children
                child = self.get_child_entry(node)
                if child is not None and child < section_limit:
                    traverse(child, word, depth + 1)

            visited.discard(entry)  # Allow revisit via different path

        # Start traversal from each letter's root
        for letter in 'abcdefghijklmnopqrstuvwxyz':
            if max_words and len(words) >= max_words:
                break

            start = self.letter_index.get(letter, 0)
            if start > 0:
                print(f"  Traversing from '{letter}' (entry {start})...")
                traverse(start, letter, 0)
                print(f"    Words so far: {len(words)}")

        return sorted(words)

    def validate_word(self, word):
        """Check if word exists in the DAWG."""
        if len(word) < 2:
            return False

        word = word.lower()
        reversed_word = word[::-1]

        # Start from last letter's index
        first_letter = reversed_word[0]
        start = self.letter_index.get(first_letter, 0)
        if start == 0:
            return False

        current = start
        for i, target in enumerate(reversed_word[1:], 1):
            # Find target letter among siblings
            found = False
            seen = set()

            while current not in seen:
                seen.add(current)
                node = self.get_node(current)
                if node is None:
                    break

                if node['letter'] == target:
                    # Found the letter
                    if i == len(reversed_word) - 1:
                        # Last letter - check word marker
                        return node['is_word']
                    else:
                        # More letters - follow child
                        child = self.get_child_entry(node)
                        if child is None:
                            return False
                        current = child
                        found = True
                        break

                if node['is_last']:
                    break
                current += 1

            if not found and i < len(reversed_word) - 1:
                return False

        return False


def main():
    import os

    print("Maven DAWG Extractor v3")
    print("=" * 40)

    dawg = DAWGExtractor(DEFAULT_DAWG_PATH)

    # Test some known words first
    test_words = ['aa', 'ab', 'qi', 'za', 'ax', 'xi', 'xu', 'ox', 'ex',
                  'the', 'cat', 'dog', 'queen', 'zax', 'qat', 'hmm', 'cwm']

    print("\nTesting known words:")
    for word in test_words:
        result = dawg.validate_word(word)
        print(f"  {word}: {'FOUND' if result else 'missing'}")

    # Small extraction test first
    print("\n" + "=" * 40)
    print("Extracting words (limited to 10000)...")
    words = dawg.enumerate_words(max_words=10000)

    print(f"\nExtracted {len(words)} words")

    # Statistics
    by_length = defaultdict(int)
    for w in words:
        by_length[len(w)] += 1

    print("\nWord length distribution:")
    for length in sorted(by_length.keys())[:10]:
        print(f"  {length:2d} letters: {by_length[length]:5d} words")

    # 2-letter words
    two_letter = sorted([w for w in words if len(w) == 2])
    print(f"\n2-letter words ({len(two_letter)}):")
    print(f"  {two_letter[:50]}")

    # Save if running full extraction
    if '--full' in sys.argv:
        print("\n" + "=" * 40)
        print("Running full extraction...")
        dawg2 = DAWGExtractor(DEFAULT_DAWG_PATH)
        all_words = dawg2.enumerate_words()

        os.makedirs(OUTPUT_DIR, exist_ok=True)
        output_path = os.path.join(OUTPUT_DIR, "dawg_extracted.txt")
        with open(output_path, 'w') as f:
            for word in all_words:
                f.write(word + '\n')
        print(f"Saved {len(all_words)} words to {output_path}")


if __name__ == "__main__":
    main()
