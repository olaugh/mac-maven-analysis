#!/usr/bin/env python3
"""
Extract words by finding is_word=True entries and backtracking.
"""

import struct
from collections import defaultdict

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        b0, b1, flags, letter_byte = data[offset:offset+4]
        base_ptr = (b0 << 8) | b1
        return {
            'letter': chr(letter_byte) if 97 <= letter_byte <= 122 else None,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    print("Building parent map...")

    # Build child -> parents map
    parents = defaultdict(list)
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] > 0 and node['child'] < section1_end:
            parents[node['child']].append(i)

    # Also build sibling start -> members map
    # (needed because parent points to sibling group start, not individual)
    def get_sibling_group_start(entry):
        """Find start of sibling group containing entry."""
        for i in range(entry - 1, -1, -1):
            node = get_node(i)
            if node['is_last']:
                return i + 1
        return 0

    # For each entry, find its sibling group start
    sibling_starts = {}
    current_start = 0
    for i in range(section1_end):
        sibling_starts[i] = current_start
        node = get_node(i)
        if node['is_last']:
            current_start = i + 1

    # Find all word-ending entries
    print("Finding word-ending entries...")
    word_entries = []
    for i in range(section1_end):
        node = get_node(i)
        if node['is_word'] and node['letter']:
            word_entries.append(i)

    print(f"Found {len(word_entries)} is_word=True entries")

    # Backtrack from each word entry to find all words
    print("Backtracking to find words...")
    words = set()
    max_depth = 20

    for word_entry in word_entries:  # Process all
        node = get_node(word_entry)
        letter = node['letter']

        # BFS backwards, collecting all paths
        # Each path item: (entry, accumulated_word)
        paths = [(word_entry, letter)]
        found_words = []

        for _ in range(max_depth):
            new_paths = []
            for entry, word in paths:
                # Find sibling group start for this entry
                group_start = sibling_starts[entry]

                # Who points to this group start?
                parent_entries = parents.get(group_start, [])

                if not parent_entries:
                    # This is a root - word is complete
                    if len(word) >= 2:
                        found_words.append(word[::-1])  # Reverse since we built backwards
                else:
                    for parent in parent_entries:
                        p_node = get_node(parent)
                        if p_node['letter']:
                            new_paths.append((parent, word + p_node['letter']))

            if not new_paths:
                break
            paths = new_paths

        words.update(found_words)

        if len(words) % 10000 == 0:
            print(f"  Found {len(words)} words so far...")

    print(f"\nTotal words: {len(words)}")

    # Check 2-letter words
    known_2 = {'aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
               'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
               'by', 'da', 'de', 'di', 'do', 'ed', 'ef', 'eh', 'el', 'em',
               'en', 'er', 'es', 'et', 'ex', 'fa', 'go', 'gu', 'ha', 'he',
               'hi', 'hm', 'ho', 'id', 'if', 'in', 'is', 'it', 'jo', 'ka',
               'ki', 'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu',
               'my', 'na', 'ne', 'no', 'nu', 'od', 'oe', 'of', 'oh', 'oi',
               'om', 'on', 'oo', 'op', 'or', 'os', 'ou', 'ow', 'ox', 'oy',
               'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh', 'si', 'so', 'st',
               'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um', 'un', 'up', 'ur',
               'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye', 'yo', 'za'}

    extracted_2 = {w for w in words if len(w) == 2}
    found = known_2 & extracted_2
    missing = known_2 - extracted_2
    extra = extracted_2 - known_2

    print(f"\n2-letter validation:")
    print(f"  Found: {len(found)}/{len(known_2)}")
    print(f"  Missing: {sorted(missing)[:20]}")
    print(f"  Extra: {len(extra)}")
    if extra:
        print(f"  Sample extra: {sorted(extra)[:20]}")

    # Save
    output = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/extracted_backtrack.txt"
    with open(output, 'w') as f:
        for w in sorted(words):
            f.write(w + '\n')
    print(f"\nSaved to {output}")

if __name__ == "__main__":
    main()
