#!/usr/bin/env python3
"""
Compare the two DAWG structures to understand dictionary differences.

Hypothesis: One is TWL, one is SOWPODS. QI should exist in only one.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

def load_dawg():
    with open(DAWG_PATH, 'rb') as f:
        return f.read()

class DAWGReader:
    def __init__(self, data, node_offset, section2_start, section2_end):
        self.data = data
        self.node_offset = node_offset
        self.section2_start = section2_start
        self.section2_end = section2_end

    def get_entry(self, idx):
        offset = self.node_offset + idx * 4
        if offset + 4 > len(self.data):
            return None
        return struct.unpack('>I', self.data[offset:offset+4])[0]

    def decode(self, entry):
        if entry is None:
            return None
        return {
            'letter': chr(entry & 0xFF) if 97 <= (entry & 0xFF) <= 122 else '?',
            'eow': (entry >> 8) & 1,
            'last': (entry >> 9) & 1,
            'child': entry >> 10,
        }

    def find_word_in_section2(self, word):
        """Search Section 2 for forward word."""
        word = word.lower()
        first = word[0]

        # Scan Section 2 for first letter entry point
        for idx in range(self.section2_start, self.section2_end):
            entry = self.get_entry(idx)
            d = self.decode(entry)
            if d and d['letter'] == first:
                # Try to match rest of word
                if self._match_word(d['child'], word[1:]):
                    return True
        return False

    def _match_word(self, start_idx, remaining):
        """Match remaining letters from start_idx."""
        if not remaining:
            return True  # Empty remaining = matched first letter only

        target = remaining[0]
        rest = remaining[1:]

        # Scan siblings at start_idx
        idx = start_idx
        while idx < self.section2_end:
            entry = self.get_entry(idx)
            d = self.decode(entry)
            if d is None:
                break

            if d['letter'] == target:
                if not rest:
                    # This is the last letter - check EOW
                    return d['eow'] == 1
                else:
                    # More letters - follow child
                    if d['child'] and self._match_word(d['child'], rest):
                        return True

            if d['last']:
                break
            idx += 1

        return False


def main():
    data = load_dawg()

    # Main DAWG (structure 1)
    section1_end = struct.unpack('>I', data[0:4])[0]  # 56630
    section2_end = struct.unpack('>I', data[4:8])[0]  # 122166
    field3 = struct.unpack('>I', data[8:12])[0]      # 145476

    main_dawg_end = NODE_START + field3 * 4  # 0x8e520

    # Second structure
    second_start = main_dawg_end
    second_entries = (len(data) - second_start) // 4  # 121961

    print("=== DAWG Comparison ===\n")
    print(f"Structure 1 (main DAWG):")
    print(f"  Node offset: 0x{NODE_START:x}")
    print(f"  Section 1: 0 - {section1_end}")
    print(f"  Section 2: {section1_end} - {section2_end}")
    print(f"  Total entries: {field3}")

    print(f"\nStructure 2 (after main):")
    print(f"  Node offset: 0x{second_start:x}")
    print(f"  Entries: {second_entries}")

    # Create readers for both
    dawg1 = DAWGReader(data, NODE_START, section1_end, section2_end)
    dawg2 = DAWGReader(data, second_start, 0, second_entries)

    # Test words
    # QI - SOWPODS-only (at time Maven was made)
    # ZO - SOWPODS-only
    # Common words that should be in both
    test_words = [
        ('QI', 'SOWPODS-only (historically)'),
        ('ZO', 'SOWPODS-only'),
        ('CH', 'SOWPODS-only'),
        ('GI', 'SOWPODS-only'),
        ('THE', 'common'),
        ('CAT', 'common'),
        ('DOG', 'common'),
        ('BE', 'common'),
        ('AX', 'common'),
        ('AA', 'common'),
        ('QUEEN', 'common'),
        ('QUIZ', 'common'),
    ]

    print("\n=== Word Presence Comparison ===\n")
    print(f"{'Word':<8} {'DAWG1':<8} {'DAWG2':<8} {'Note'}")
    print("-" * 50)

    for word, note in test_words:
        in_dawg1 = dawg1.find_word_in_section2(word)
        in_dawg2 = dawg2.find_word_in_section2(word)
        d1 = 'YES' if in_dawg1 else 'no'
        d2 = 'YES' if in_dawg2 else 'no'
        diff = ' ***' if in_dawg1 != in_dawg2 else ''
        print(f"{word:<8} {d1:<8} {d2:<8} {note}{diff}")

    # Count Q words in each
    print("\n=== Q-word analysis ===")

    def count_q_words(dawg, name):
        count = 0
        for idx in range(dawg.section2_start, dawg.section2_end):
            entry = dawg.get_entry(idx)
            d = dawg.decode(entry)
            if d and d['letter'] == 'q':
                count += 1
        return count

    q1 = count_q_words(dawg1, "DAWG1")
    q2 = count_q_words(dawg2, "DAWG2")
    print(f"Q entry points in DAWG1: {q1}")
    print(f"Q entry points in DAWG2: {q2}")

if __name__ == "__main__":
    main()
