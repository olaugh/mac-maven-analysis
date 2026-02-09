#!/usr/bin/env python3
"""
Analyze the full 4-byte letter index entries.
"""

import struct

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]

    print("="*60)
    print("Full letter index (4 bytes per entry)")
    print("="*60)

    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1, b2, b3 = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter = chr(ord('a') + i)
        print(f"{letter}: bytes=[{b0:02x} {b1:02x} {b2:02x} {b3:02x}] entry={entry:5d} extra={b2:3d},{b3:3d}")

    # What if bytes 2-3 are a second entry or flag?
    print("\n" + "="*60)
    print("Interpreting bytes 2-3 as second entry")
    print("="*60)

    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1, b2, b3 = data[offset:offset+4]
        entry1 = (b0 << 8) | b1
        entry2 = (b2 << 8) | b3
        letter = chr(ord('a') + i)
        print(f"{letter}: entry1={entry1:5d} entry2={entry2:5d}")

    # Find all sibling groups that have no parents (roots)
    print("\n" + "="*60)
    print("Finding all root sibling groups")
    print("="*60)

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

    # Build set of all entries pointed to as children
    child_targets = set()
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] > 0:
            child_targets.add(node['child'])

    # Find sibling group starts that are not in child_targets
    root_groups = []
    i = 0
    while i < section1_end:
        if i not in child_targets:
            # This might be a root group start
            # Find the group
            group_start = i
            group_letters = []
            while i < section1_end:
                node = get_node(i)
                if node['letter']:
                    group_letters.append(node['letter'])
                if node['is_last']:
                    break
                i += 1
            root_groups.append((group_start, group_letters))
        i += 1

    print(f"Found {len(root_groups)} root sibling groups")
    for start, letters in root_groups[:20]:
        print(f"  Entry {start}: letters = {''.join(letters[:10])}{'...' if len(letters)>10 else ''}")

    # Check if any root groups contain 'a' at specific positions
    print("\n" + "="*60)
    print("Root groups with 'a'")
    print("="*60)
    for start, letters in root_groups:
        if 'a' in letters:
            a_pos = letters.index('a')
            print(f"  Entry {start}: 'a' at position {a_pos}, group size={len(letters)}")

if __name__ == "__main__":
    main()
