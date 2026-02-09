#!/usr/bin/env python3
"""
Enumerate all words from Maven DAWG using the correct file format.

File format (4 bytes per entry):
- bytes 0-1: ptr (16-bit big-endian)
- byte 2:    flags (bit 7=0x80: is_word, bit 0=0x01: is_last)
- byte 3:    letter (ASCII lowercase)

Child calculation: child_entry = ptr + (flags & 0x7e)

Structure:
- Section 1 (entries 0-56,629): Reversed words, roots at entries 4-29 (a-z by last letter)
- Section 2 (entries 56,630-122,165): Forward entry points
- Section 3 (entries 122,166+): Additional entries (second lexicon?)
"""

import struct
import sys

# Constants
NODE_START = 0x410  # Offset where nodes begin in file
SECTION1_END = 56630
SECTION2_END = 122166

FLAG_WORD = 0x80
FLAG_LAST = 0x01

class DAWGEnumerator:
    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        # Parse header
        self.section1_end = struct.unpack('>I', self.data[0:4])[0]
        self.section2_end = struct.unpack('>I', self.data[4:8])[0]

        print(f"DAWG Header: section1_end={self.section1_end}, section2_end={self.section2_end}")

        # Build letter index from header
        self.letter_index = {}
        for i in range(26):
            offset = 0x10 + i * 4
            b0, b1, flags, letter = self.data[offset:offset+4]
            entry = (b0 << 8) | b1
            self.letter_index[chr(ord('a') + i)] = entry

        print(f"Letter index: a={self.letter_index['a']}, z={self.letter_index['z']}")

    def get_node(self, entry_idx):
        """Get node at entry index."""
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None

        b0, b1, flags, letter = self.data[offset:offset+4]
        ptr = (b0 << 8) | b1

        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter) if 97 <= letter <= 122 else None,
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
        }

    def enumerate_section1(self, max_words=None):
        """
        Enumerate words from Section 1 (reversed structure).

        Section 1 stores reversed words. The letter index points to ranges
        for each ending letter. We enumerate by walking from each root.
        """
        words = set()

        # For each starting letter (which is the LAST letter of the word)
        for start_letter in 'abcdefghijklmnopqrstuvwxyz':
            start_entry = self.letter_index[start_letter]

            # Get the range for this letter
            next_letter_idx = ord(start_letter) - ord('a') + 1
            if next_letter_idx < 26:
                end_entry = self.letter_index[chr(ord('a') + next_letter_idx)]
            else:
                end_entry = self.section1_end

            # Enumerate from this range
            self._enumerate_from_range(start_entry, end_entry, start_letter, words, max_words)

            if max_words and len(words) >= max_words:
                break

        # Words are stored reversed, so reverse them
        return set(w[::-1] for w in words)

    def _enumerate_from_range(self, start, end, prefix, words, max_words, depth=0):
        """Enumerate words starting from a range of entries."""
        if depth > 20:  # Prevent infinite recursion
            return

        if max_words and len(words) >= max_words:
            return

        entry_idx = start
        while entry_idx < end and entry_idx < self.section1_end:
            node = self.get_node(entry_idx)
            if node is None or node['letter'] is None:
                break

            current = prefix + node['letter']

            # If this is a word ending, record it
            if node['is_word']:
                words.add(current)
                if max_words and len(words) >= max_words:
                    return

            # If there are children, recurse
            if node['child'] > 0 and node['child'] < self.section1_end:
                self._enumerate_from_range(
                    node['child'],
                    self.section1_end,
                    current,
                    words,
                    max_words,
                    depth + 1
                )

            # Move to next sibling
            if node['is_last']:
                break
            entry_idx += 1

    def enumerate_section2(self, max_words=None):
        """
        Enumerate words from Section 2 (forward structure).

        Section 2 has forward entry points that use Section 1 for suffixes.
        """
        words = set()

        # Scan Section 2 for entry points
        for entry_idx in range(self.section1_end, self.section2_end):
            node = self.get_node(entry_idx)
            if node is None or node['letter'] is None:
                continue

            # This is a starting letter
            prefix = node['letter']

            if node['is_word']:
                words.add(prefix)

            # Follow children (which go into Section 1)
            if node['child'] > 0:
                self._enumerate_forward(node['child'], prefix, words, max_words)

            if max_words and len(words) >= max_words:
                break

        return words

    def _enumerate_forward(self, start, prefix, words, max_words, depth=0):
        """Enumerate forward from an entry, following into Section 1."""
        if depth > 20:
            return

        if max_words and len(words) >= max_words:
            return

        entry_idx = start
        while entry_idx < self.section2_end:
            node = self.get_node(entry_idx)
            if node is None or node['letter'] is None:
                break

            current = prefix + node['letter']

            if node['is_word']:
                words.add(current)
                if max_words and len(words) >= max_words:
                    return

            if node['child'] > 0:
                self._enumerate_forward(node['child'], current, words, max_words, depth + 1)

            if node['is_last']:
                break
            entry_idx += 1


def main():
    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"

    print("=" * 60)
    print("Maven DAWG Enumeration (No Reference Lists)")
    print("=" * 60)

    enumerator = DAWGEnumerator(dawg_path)

    # First, test with a small sample
    print("\n--- Testing with small sample ---")
    sample_words = enumerator.enumerate_section1(max_words=100)
    print(f"Section 1 sample (first 100): {len(sample_words)} words")

    # Show some samples
    sorted_sample = sorted(sample_words)
    print("Sample words:", sorted_sample[:30])

    # Check for known words
    test_words = ['aa', 'ab', 'cat', 'act', 'the', 'and', 'be', 'at']
    print("\nChecking for known words in sample:")
    for w in test_words:
        status = "FOUND" if w in sample_words else "not in sample"
        print(f"  {w}: {status}")

    # Now enumerate fully
    print("\n--- Full Section 1 enumeration ---")
    section1_words = enumerator.enumerate_section1()
    print(f"Section 1 total: {len(section1_words)} words")

    print("\n--- Full Section 2 enumeration ---")
    section2_words = enumerator.enumerate_section2()
    print(f"Section 2 total: {len(section2_words)} words")

    # Combine
    all_words = section1_words | section2_words
    print(f"\nCombined total: {len(all_words)} unique words")

    # Verify known words
    print("\nVerifying known words:")
    for w in test_words:
        status = "FOUND" if w in all_words else "MISSING"
        print(f"  {w}: {status}")

    # Word length distribution
    print("\nWord length distribution:")
    by_length = {}
    for w in all_words:
        l = len(w)
        by_length[l] = by_length.get(l, 0) + 1
    for l in sorted(by_length.keys()):
        print(f"  {l} letters: {by_length[l]} words")

    # Save results
    output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_enumerated.txt"
    with open(output_path, 'w') as f:
        for w in sorted(all_words):
            f.write(w + '\n')
    print(f"\nSaved {len(all_words)} words to {output_path}")

    # Show some 2-letter and 3-letter words
    two_letter = sorted([w for w in all_words if len(w) == 2])
    three_letter = sorted([w for w in all_words if len(w) == 3])[:50]

    print(f"\nAll 2-letter words ({len(two_letter)}):")
    print("  " + ", ".join(two_letter))

    print(f"\nFirst 50 3-letter words:")
    print("  " + ", ".join(three_letter))


if __name__ == "__main__":
    main()
