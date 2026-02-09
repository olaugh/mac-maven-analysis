#!/usr/bin/env python3
"""
Debug backtracking to see why we're getting so few words.
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

    # Build parent map
    parents = defaultdict(list)
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] > 0 and node['child'] < section1_end:
            parents[node['child']].append(i)

    # Find sibling group starts
    sibling_starts = {}
    current_start = 0
    for i in range(section1_end):
        sibling_starts[i] = current_start
        node = get_node(i)
        if node['is_last']:
            current_start = i + 1

    # Pick a few word entries and trace them in detail
    word_entries = []
    for i in range(section1_end):
        node = get_node(i)
        if node['is_word'] and node['letter']:
            word_entries.append(i)

    print(f"Total is_word entries: {len(word_entries)}")

    # Trace first 5 in detail
    for word_entry in word_entries[:5]:
        node = get_node(word_entry)
        print(f"\n{'='*60}")
        print(f"Word entry {word_entry}: letter='{node['letter']}'")
        print(f"{'='*60}")

        # Trace back
        entry = word_entry
        path = [node['letter']]

        for depth in range(15):
            group_start = sibling_starts[entry]
            parent_list = parents.get(group_start, [])

            print(f"  Depth {depth}: entry {entry} -> group {group_start}, parents: {parent_list[:5]}{'...' if len(parent_list)>5 else ''}")

            if not parent_list:
                print(f"  -> REACHED ROOT, word = '{(''.join(path[::-1]))}'")
                break

            # Take first parent
            parent = parent_list[0]
            p_node = get_node(parent)
            if p_node['letter']:
                path.append(p_node['letter'])
            entry = parent

    # Check path lengths
    print(f"\n{'='*60}")
    print("Path length distribution")
    print(f"{'='*60}")

    path_lengths = defaultdict(int)
    root_reached = 0
    max_depth = 50

    for word_entry in word_entries[:1000]:
        node = get_node(word_entry)
        entry = word_entry
        depth = 0

        for depth in range(max_depth):
            group_start = sibling_starts[entry]
            parent_list = parents.get(group_start, [])

            if not parent_list:
                root_reached += 1
                path_lengths[depth] += 1
                break

            entry = parent_list[0]
        else:
            path_lengths['exceeded'] += 1

    print(f"Root reached: {root_reached}/1000")
    for length, count in sorted(path_lengths.items(), key=lambda x: (isinstance(x[0], str), x[0])):
        print(f"  Length {length}: {count}")

if __name__ == "__main__":
    main()
