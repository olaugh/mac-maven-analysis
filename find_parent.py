#!/usr/bin/env python3
"""
Find parent of sibling group containing entry 10756.
"""

import struct

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
            'base_ptr': base_ptr,
            'flags': flags,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    # Find start of sibling group containing 10756
    # Go backwards until we find is_last or entry 0
    print("Finding sibling group containing 10756...")

    sibling_start = 10756
    for i in range(10756 - 1, -1, -1):
        node = get_node(i)
        if node['is_last']:
            sibling_start = i + 1
            break

    print(f"Sibling group starts at entry {sibling_start}")

    # Show the group
    print(f"\nSibling group {sibling_start}-?:")
    for i in range(sibling_start, sibling_start + 20):
        node = get_node(i)
        marker = "*" if node['is_word'] else " "
        last = "L" if node['is_last'] else " "
        print(f"  {i}: '{node['letter']}' {marker}{last} child={node['child']}")
        if node['is_last']:
            break

    # Who points to sibling_start?
    print(f"\nWho has child = {sibling_start}?")
    parents = []
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] == sibling_start:
            parents.append((i, node))
            if len(parents) <= 10:
                print(f"  Entry {i}: '{node['letter']}' child={node['child']}")

    print(f"Total parents: {len(parents)}")

    # Trace full path from first parent
    if parents:
        parent_entry, parent_node = parents[0]
        print(f"\nTracing back from parent entry {parent_entry}...")

        path = [parent_node['letter']]
        current = parent_entry

        for depth in range(10):
            # Find who points to current's sibling group
            group_start = current
            for i in range(current - 1, -1, -1):
                node = get_node(i)
                if node['is_last']:
                    group_start = i + 1
                    break

            # Find parent of group_start
            found_parent = False
            for i in range(section1_end):
                node = get_node(i)
                if node['child'] == group_start:
                    path.insert(0, node['letter'])
                    current = i
                    found_parent = True
                    print(f"  Level {depth}: entry {i} ('{node['letter']}') -> group {group_start}")
                    break

            if not found_parent:
                print(f"  No parent found for group {group_start}")
                break

        print(f"\nPath to 10756: {''.join(filter(None, path))}")

if __name__ == "__main__":
    main()
