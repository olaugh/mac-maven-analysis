#!/usr/bin/env python3
"""
Enumerate all words from Maven's DAWG structure.

Based on the working validation logic from extract_dictionary.py:
- Section 1 stores reversed words, indexed by LAST letter
- Word "THE" is stored as "EHT" under 'E' index
- WORD flag (0x80) marks valid word endings
- Each letter range contains MULTIPLE sibling groups

Algorithm:
1. For each letter L in index:
   - Scan ALL entries in L's range (not just first sibling group)
   - For each entry with matching letter, check WORD flag and follow children
   - Build reversed words by prepending letters
"""

import struct
import sys
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
OUTPUT_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/lexica"

LETTER_INDEX_OFFSET = 0x10
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01


class DAWGEnumerator:
    def __init__(self, filepath, section_limit=None):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        # Parse header
        self.section1_end = struct.unpack('>I', self.data[0:4])[0]
        self.section2_end = struct.unpack('>I', self.data[4:8])[0]

        if section_limit:
            self.section1_end = min(self.section1_end, section_limit)

        # Parse letter index
        self.letter_index = {}
        for i in range(26):
            offset = LETTER_INDEX_OFFSET + i * 4
            entry = (self.data[offset] << 8) | self.data[offset+1]
            self.letter_index[chr(ord('a') + i)] = entry

        # Compute letter ranges
        letters = 'abcdefghijklmnopqrstuvwxyz'
        self.letter_ranges = {}
        for i, L in enumerate(letters):
            start = self.letter_index[L]
            end = self.letter_index[letters[i+1]] if i < 25 else self.section1_end
            self.letter_ranges[L] = (start, end)

        print(f"DAWG loaded: section1_end={self.section1_end}")

    def get_node(self, entry_idx):
        """Get node at given entry index."""
        if entry_idx >= self.section1_end:
            return None

        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None

        b0, b1, flags, letter = self.data[offset:offset+4]
        ptr = (b0 << 8) | b1

        if not (97 <= letter <= 122):
            return None

        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter),
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
        }

    def get_child_entry(self, node):
        """Calculate child entry index."""
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def enumerate_from_letter(self, last_letter, max_words=None):
        """
        Enumerate all words ending with given letter.

        The letter index points to entries for words ending in that letter.
        We scan all entries in the range, following children to build complete words.
        """
        words = set()
        range_start, range_end = self.letter_ranges[last_letter]

        def traverse(entry_start, entry_end, suffix, depth):
            """Scan range for matching entries, follow children recursively."""
            if depth > 15:
                return
            if max_words and len(words) >= max_words:
                return

            entry = entry_start
            while entry < entry_end:
                if max_words and len(words) >= max_words:
                    return

                node = self.get_node(entry)
                if node is None:
                    entry += 1
                    continue

                # Build word by prepending this letter
                word = node['letter'] + suffix

                # If WORD flag set, this is a valid word
                if node['is_word'] and len(word) >= 2:
                    words.add(word)

                # Follow children to find longer words
                child = self.get_child_entry(node)
                if child is not None and child < self.section1_end:
                    # Children are also in section 1, scan from child
                    traverse(child, self.section1_end, word, depth + 1)

                entry += 1

        # Start: scan the letter's range, building words that end with last_letter
        traverse(range_start, range_end, last_letter, 1)

        return words

    def enumerate_all(self, max_words_per_letter=None):
        """Enumerate all words from all letter indices."""
        all_words = set()

        for letter in 'abcdefghijklmnopqrstuvwxyz':
            print(f"  Processing '{letter}'...", end=' ', flush=True)
            words = self.enumerate_from_letter(letter, max_words_per_letter)
            print(f"{len(words)} words")
            all_words.update(words)

        return sorted(all_words)


def main():
    print("Maven DAWG Enumerator")
    print("=" * 50)

    dawg = DAWGEnumerator(DAWG_PATH)

    # Test with 'a' first
    print("\nTest: Enumerating words ending in 'a'...")
    a_words = dawg.enumerate_from_letter('a', max_words=1000)
    print(f"Found {len(a_words)} words")

    two_letter_a = sorted([w for w in a_words if len(w) == 2])
    print(f"2-letter words ending in 'a': {two_letter_a}")

    # Check known words
    test_words = ['aa', 'ba', 'da', 'fa', 'ha', 'ka', 'la', 'ma', 'na', 'pa', 'ta', 'za']
    found = [w for w in test_words if w in a_words]
    print(f"Test words found: {found}")

    # Sample longer words
    sample_3 = sorted([w for w in a_words if len(w) == 3])[:10]
    print(f"Sample 3-letter: {sample_3}")

    # Full enumeration
    if '--full' in sys.argv:
        print("\n" + "=" * 50)
        print("Full enumeration...")
        all_words = dawg.enumerate_all()

        print(f"\nTotal words: {len(all_words)}")

        by_length = defaultdict(int)
        for w in all_words:
            by_length[len(w)] += 1

        print("\nWord length distribution:")
        for length in sorted(by_length.keys())[:12]:
            print(f"  {length:2d} letters: {by_length[length]:6d} words")

        # 2-letter words
        two_letter = sorted([w for w in all_words if len(w) == 2])
        print(f"\n2-letter words ({len(two_letter)}): {two_letter}")

        # Save
        import os
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        output_path = os.path.join(OUTPUT_DIR, "dawg_enumerated.txt")
        with open(output_path, 'w') as f:
            for word in all_words:
                f.write(word + '\n')
        print(f"\nSaved to {output_path}")


if __name__ == "__main__":
    main()
