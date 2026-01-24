#!/usr/bin/env python3
"""
Extract dictionary from Maven's DAWG structure.

The DAWG is a bidirectional structure optimized for cross-check computation:
- Section 1 (entries 0-56,629): Reversed words for hook-BEFORE checks
- Section 2 (entries 56,630-122,165): Forward entry points reusing Section 1

The structure is NOT suitable for direct word enumeration because:
1. WORD flags mark valid affixes for cross-checking, not complete words
2. Paths through the structure don't map directly to word letter sequences
3. The structure is optimized for "what letter can precede/follow X" queries

This script validates reference words against the DAWG to extract the dictionary.

Usage:
    python3 extract_dictionary.py [dawg_file] [reference_file] [output_file]
"""

import struct
import sys
import os

DEFAULT_DAWG = "/Volumes/T7/retrogames/oldmac/share/maven2"
DEFAULT_REFERENCE = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt"
DEFAULT_OUTPUT = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/extracted_words.txt"

# DAWG structure constants
HEADER_SIZE = 16
LETTER_INDEX_OFFSET = 0x10
NODE_START = 0x410  # Nodes start after header + index + padding
SECTION1_END = 56630

# Node format
FLAG_WORD = 0x80    # Valid affix marker (not necessarily complete word)
FLAG_LAST = 0x01    # Last sibling in group


class DAWGReader:
    """Reader for Maven's DAWG dictionary structure."""

    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        self.header = self._parse_header()
        self.letter_index = self._parse_letter_index()
        self.letter_ranges = self._compute_ranges()
        self.section2_index = self._build_section2_index()

    def _parse_header(self):
        return {
            'section1_end': struct.unpack('>I', self.data[0:4])[0],
            'section2_end': struct.unpack('>I', self.data[4:8])[0],
            'field3': struct.unpack('>I', self.data[8:12])[0],
            'field4': struct.unpack('>I', self.data[12:16])[0],
        }

    def _parse_letter_index(self):
        index = {}
        for i in range(26):
            offset = LETTER_INDEX_OFFSET + i * 4
            b0, b1, flags, letter = self.data[offset:offset+4]
            entry = (b0 << 8) | b1
            letter_char = chr(ord('a') + i)
            index[letter_char] = {
                'entry': entry,
                'flags': flags,
            }
        return index

    def _compute_ranges(self):
        letters = 'abcdefghijklmnopqrstuvwxyz'
        ranges = {}
        for i, L in enumerate(letters):
            start = self.letter_index[L]['entry']
            end = self.letter_index[letters[i+1]]['entry'] if i < 25 else SECTION1_END
            ranges[L] = (start, end)
        return ranges

    def _build_section2_index(self):
        """Build index of Section 2 entries grouped by first letter."""
        index = {chr(ord('a') + i): [] for i in range(26)}
        section2_end = self.header['section2_end']
        for entry_idx in range(SECTION1_END, section2_end):
            node = self.get_node(entry_idx)
            if node and 'a' <= node['letter'] <= 'z':
                index[node['letter']].append(entry_idx)
        return index

    def get_node(self, entry_idx):
        """Get node at given entry index."""
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None

        b0, b1, flags, letter = self.data[offset:offset+4]
        ptr = (b0 << 8) | b1

        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter) if 97 <= letter <= 122 else '?',
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'entry': entry_idx,
        }

    def get_siblings(self, start_entry, limit=500):
        """Get all siblings starting from given entry."""
        siblings = []
        entry = start_entry

        while entry < SECTION1_END and len(siblings) < limit:
            node = self.get_node(entry)
            if node is None or node['letter'] == '?':
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1

        return siblings

    def get_child_entry(self, node):
        """Calculate child entry index from node."""
        if node['ptr'] == 0:
            return None
        # Child = ptr + (flags & 0x7e)
        return node['ptr'] + (node['flags'] & 0x7e)

    def validate_word(self, word):
        """
        Validate a word exists in the DAWG.

        Checks both sections:
        - Section 1: Reversed words (THE -> EHT)
        - Section 2: Forward entry points for words not found in Section 1
        """
        if len(word) < 2:
            return False

        word = word.lower()

        # Method 1: Check Section 1 with reversed word
        if self._check_section1(word):
            return True

        # Method 2: Check Section 2 with forward word
        if self._check_section2(word):
            return True

        return False

    def _check_section1(self, word):
        """Check reversed word in Section 1."""
        reversed_word = word[::-1]
        first = reversed_word[0]

        if first not in self.letter_ranges:
            return False

        range_start, range_end = self.letter_ranges[first]
        return self._search_section1(range_start, range_end, reversed_word[1:])

    def _search_section1(self, entry_start, entry_end, remaining):
        """Search Section 1 for remaining letters."""
        if not remaining:
            return True

        target = remaining[0]
        rest = remaining[1:]

        entry = entry_start
        while entry < entry_end:
            sibs = self.get_siblings(entry)
            if not sibs:
                break

            for node in sibs:
                if node['letter'] == target:
                    if not rest:
                        if node['is_word']:
                            return True
                    else:
                        child = self.get_child_entry(node)
                        if child and child < SECTION1_END:
                            if self._search_section1(child, SECTION1_END, rest):
                                return True

            entry += len(sibs)

        return False

    def _check_section2(self, word):
        """Check forward word starting from Section 2."""
        first = word[0]

        # Use pre-built index for fast lookup
        for entry_idx in self.section2_index.get(first, []):
            node = self.get_node(entry_idx)
            if node and self._match_forward(node, word[1:]):
                return True

        return False

    def _match_forward(self, node, remaining):
        """Match remaining letters by following children."""
        if not remaining:
            return node['is_word']

        child = self.get_child_entry(node)
        if not child:
            return False

        target = remaining[0]
        rest = remaining[1:]

        sibs = self.get_siblings(child)
        for s in sibs:
            if s['letter'] == target:
                if not rest:
                    if s['is_word']:
                        return True
                else:
                    if self._match_forward(s, rest):
                        return True

        return False


def extract_dictionary(dawg_path, reference_path, output_path):
    """Extract dictionary by validating reference words against DAWG."""

    print(f"Loading DAWG from: {dawg_path}")
    dawg = DAWGReader(dawg_path)
    print(f"  Header: section1_end={dawg.header['section1_end']}, section2_end={dawg.header['section2_end']}")

    print(f"\nLoading reference from: {reference_path}")
    with open(reference_path) as f:
        reference_words = [line.strip().lower() for line in f if line.strip()]
    print(f"  Loaded {len(reference_words)} reference words")

    print("\nValidating words against DAWG...")
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

    # Show samples
    two_letter = sorted([w for w in validated if len(w) == 2])
    print(f"\n2-letter words ({len(two_letter)}): {two_letter[:30]}...")

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
        print("Please provide a reference wordlist (e.g., SOWPODS)")
        sys.exit(1)

    extract_dictionary(dawg_path, reference_path, output_path)


if __name__ == "__main__":
    main()
