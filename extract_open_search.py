#!/usr/bin/env python3
"""
Extract dictionary using open search validation.
This version searches from the letter range start to section1_end,
allowing cross-range matches.
"""

import struct
import sys
import os

DEFAULT_DAWG = "/Volumes/T7/retrogames/oldmac/share/maven2"
DEFAULT_REFERENCE = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt"
DEFAULT_OUTPUT = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/open_validated.txt"

HEADER_SIZE = 16
LETTER_INDEX_OFFSET = 0x10
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01


class OpenDAWGReader:
    """Reader using open search validation."""

    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        self.section1_end = struct.unpack('>I', self.data[0:4])[0]
        self.section2_end = struct.unpack('>I', self.data[4:8])[0]
        self.letter_ranges = self._build_letter_ranges()

    def _build_letter_ranges(self):
        letter_index = {}
        for i in range(26):
            offset = LETTER_INDEX_OFFSET + i * 4
            b0, b1, flags, letter = self.data[offset:offset+4]
            entry = (b0 << 8) | b1
            letter_index[chr(ord('a') + i)] = entry

        letters = 'abcdefghijklmnopqrstuvwxyz'
        ranges = {}
        for i, L in enumerate(letters):
            start = letter_index[L]
            end = letter_index[letters[i+1]] if i < 25 else self.section1_end
            ranges[L] = (start, end)
        return ranges

    def get_node(self, entry_idx):
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
            'entry': entry_idx,
        }

    def get_child_entry(self, node):
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def validate_word(self, word):
        """Validate using open search (from range start to section1_end)."""
        if len(word) < 2:
            return False

        word = word.lower()
        reversed_word = word[::-1]
        first = reversed_word[0]

        if first not in self.letter_ranges:
            return False

        range_start, _ = self.letter_ranges[first]
        return self._open_search(range_start, reversed_word[1:])

    def _open_search(self, search_start, remaining):
        """Search from search_start to section1_end for remaining letters."""
        if not remaining:
            return True

        target = remaining[0]
        rest = remaining[1:]

        for entry in range(search_start, self.section1_end):
            node = self.get_node(entry)
            if node and node['letter'] == target:
                if not rest:
                    if node['is_word']:
                        return True
                else:
                    child = self.get_child_entry(node)
                    if child and self._open_search(child, rest):
                        return True

        return False


def extract_dictionary(dawg_path, reference_path, output_path):
    """Extract dictionary using open search validation."""

    print(f"Loading DAWG from: {dawg_path}")
    dawg = OpenDAWGReader(dawg_path)
    print(f"  Section 1 ends at: {dawg.section1_end}")

    print(f"\nLoading reference from: {reference_path}")
    with open(reference_path) as f:
        reference_words = [line.strip().lower() for line in f if line.strip()]
    print(f"  Loaded {len(reference_words)} reference words")

    print("\nValidating words...")
    validated = []
    total = len(reference_words)

    for i, word in enumerate(reference_words):
        if i % 20000 == 0:
            print(f"  Progress: {i}/{total} ({100*i//total}%)")

        if dawg.validate_word(word):
            validated.append(word)

    print(f"\nValidation complete!")
    print(f"  Reference words: {len(reference_words)}")
    print(f"  Found in DAWG: {len(validated)}")
    print(f"  Match rate: {100*len(validated)/len(reference_words):.1f}%")

    # Statistics
    by_length = {}
    for w in validated:
        n = len(w)
        by_length[n] = by_length.get(n, 0) + 1

    print("\nWord length distribution:")
    for length in sorted(by_length.keys())[:12]:
        print(f"  {length:2d} letters: {by_length[length]:6d} words")

    # Save
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w') as f:
        for word in sorted(validated):
            f.write(word + '\n')
    print(f"\nSaved {len(validated)} words to: {output_path}")

    # Check specific words
    print("\nSpecific words check:")
    for word in ['aa', 'aardvark', 'aardvarks', 'the', 'queen', 'queens']:
        if word in validated:
            print(f"  {word}: FOUND")
        else:
            print(f"  {word}: NOT FOUND")

    return validated


def main():
    dawg_path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_DAWG
    reference_path = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_REFERENCE
    output_path = sys.argv[3] if len(sys.argv) > 3 else DEFAULT_OUTPUT

    if not os.path.exists(dawg_path):
        print(f"Error: DAWG file not found: {dawg_path}")
        sys.exit(1)

    if not os.path.exists(reference_path):
        print(f"Error: Reference file not found: {reference_path}")
        sys.exit(1)

    extract_dictionary(dawg_path, reference_path, output_path)


if __name__ == "__main__":
    main()
