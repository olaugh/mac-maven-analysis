#!/usr/bin/env python3
"""
Brute force enumeration of short words by validating all letter combinations.
This is slow but guaranteed to find all valid words up to a given length.
"""

import struct
import itertools
import sys

NODE_START = 0x410
SECTION1_END = 56630
FLAG_WORD = 0x80
FLAG_LAST = 0x01

class DAWGValidator:
    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        self.section1_end = struct.unpack('>I', self.data[0:4])[0]
        self.section2_end = struct.unpack('>I', self.data[4:8])[0]

        # Parse letter index
        self.letter_index = {}
        self.letter_ranges = {}
        letters = 'abcdefghijklmnopqrstuvwxyz'
        for i in range(26):
            offset = 0x10 + i * 4
            b0, b1 = self.data[offset], self.data[offset+1]
            entry = (b0 << 8) | b1
            self.letter_index[letters[i]] = entry
            start = entry
            end = self.letter_index.get(letters[i-1], 0) if i > 0 else 0
            # Compute ranges
        for i, L in enumerate(letters):
            start = self.letter_index[L]
            end = self.letter_index[letters[i+1]] if i < 25 else self.section1_end
            self.letter_ranges[L] = (start, end)

        # Pre-build Section 2 index
        self.section2_index = {c: [] for c in letters}
        for idx in range(self.section1_end, self.section2_end):
            node = self._get_node(idx)
            if node and node['letter'] in self.section2_index:
                self.section2_index[node['letter']].append(idx)

    def _get_node(self, entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None
        b0, b1, flags, letter = self.data[offset:offset+4]
        if not (97 <= letter <= 122):
            return None
        ptr = (b0 << 8) | b1
        return {
            'letter': chr(letter),
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
        }

    def _get_siblings(self, start):
        siblings = []
        entry = start
        while entry < self.section1_end:
            node = self._get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    def validate(self, word):
        """Validate a word using both sections."""
        if len(word) < 2:
            return False
        return self._check_section1(word) or self._check_section2(word)

    def _check_section1(self, word):
        """Check Section 1 (reversed words)."""
        rev = word[::-1]
        first = rev[0]
        if first not in self.letter_ranges:
            return False

        start, end = self.letter_ranges[first]
        return self._search_s1(start, end, rev[1:])

    def _search_s1(self, start, end, remaining):
        if not remaining:
            return True

        target = remaining[0]
        rest = remaining[1:]

        entry = start
        while entry < end:
            sibs = self._get_siblings(entry)
            if not sibs:
                break

            for node in sibs:
                if node['letter'] == target:
                    if not rest:
                        if node['is_word']:
                            return True
                    else:
                        child = node['child']
                        if child and child < self.section1_end:
                            if self._search_s1(child, self.section1_end, rest):
                                return True

            entry += len(sibs)

        return False

    def _check_section2(self, word):
        """Check Section 2 (forward words)."""
        first = word[0]
        for idx in self.section2_index.get(first, []):
            node = self._get_node(idx)
            if node and self._match_forward(node, word[1:]):
                return True
        return False

    def _match_forward(self, node, remaining):
        if not remaining:
            return node['is_word']

        child = node['child']
        if not child:
            return False

        target = remaining[0]
        rest = remaining[1:]

        sibs = self._get_siblings(child)
        for sib in sibs:
            if sib['letter'] == target:
                return self._match_forward(sib, rest)

        return False


def generate_combinations(length):
    """Generate all lowercase letter combinations of given length."""
    return (''.join(combo) for combo in itertools.product('abcdefghijklmnopqrstuvwxyz', repeat=length))


def main():
    print("="*60)
    print("Brute Force Short Word Extraction")
    print("="*60)

    validator = DAWGValidator("/Volumes/T7/retrogames/oldmac/share/maven2")
    print(f"DAWG loaded: section1={validator.section1_end}, section2={validator.section2_end}")

    all_words = set()

    # Process each length
    for length in range(2, 8):  # 2 to 7 letters
        count = 26 ** length
        print(f"\nLength {length}: testing {count:,} combinations...", flush=True)

        valid = []
        tested = 0
        for word in generate_combinations(length):
            if validator.validate(word):
                valid.append(word)
            tested += 1
            if tested % 100000 == 0:
                print(f"  {tested:,}/{count:,} tested, {len(valid)} valid", flush=True)

        print(f"  Found {len(valid)} valid {length}-letter words")
        all_words.update(valid)

        # Show some examples
        if valid:
            print(f"  Examples: {', '.join(valid[:20])}")

    print(f"\nTotal: {len(all_words)} words (2-7 letters)")

    # Save
    out = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_brute_force.txt"
    with open(out, 'w') as f:
        for w in sorted(all_words):
            f.write(w + '\n')
    print(f"Saved to {out}")

if __name__ == "__main__":
    main()
