#!/usr/bin/env python3
"""
Analyze the DAWG root structure - what's before the letter ranges?
"""

import struct

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    print("="*60)
    print("DAWG File Header")
    print("="*60)
    print(f"Section 1 end: {section1_end}")
    print(f"Section 2 end: {section2_end}")
    print(f"Field 3: {struct.unpack('>I', data[8:12])[0]}")
    print(f"Field 4: {struct.unpack('>I', data[12:16])[0]}")

    # Parse letter index
    print("\n" + "="*60)
    print("Letter Index (at offset 0x10)")
    print("="*60)

    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1, b2, b3 = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter = chr(ord('a') + i)
        letter_index[letter] = entry
        print(f"{letter}: entry {entry:5d} (bytes: {b0:02x} {b1:02x} {b2:02x} {b3:02x})")

    # What's before the 'a' range?
    first_letter_entry = letter_index['a']
    print(f"\nFirst letter ('a') starts at entry {first_letter_entry}")
    print(f"Entries 0 to {first_letter_entry - 1} are BEFORE the letter ranges")

    print("\n" + "="*60)
    print(f"Entries 0-{min(first_letter_entry, 30)} (before 'a' range)")
    print("="*60)

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        return {
            'bytes': f'{b0:02x} {b1:02x} {flags:02x} {letter:02x}',
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter) if 97 <= letter <= 122 else f'0x{letter:02x}',
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
        }

    for i in range(min(first_letter_entry + 5, 180)):
        node = get_node(i)
        marker = ""
        if i == letter_index.get('a'):
            marker = " <-- 'a' range starts"
        print(f"Entry {i:3d}: [{node['bytes']}] letter='{node['letter']}' "
              f"is_word={int(node['is_word'])} is_last={int(node['is_last'])} "
              f"ptr={node['ptr']:4d} child={node['child']:4d}{marker}")

    # Check what entries 0-168 are children of
    print("\n" + "="*60)
    print("Who are the parents of entries 0-10?")
    print("="*60)

    # Find nodes whose children include entries 0-10
    for target in range(11):
        parents = []
        for i in range(section1_end):
            node = get_node(i)
            if node['child'] == target or (node['ptr'] and node['ptr'] <= target < node['child'] + 20):
                # Check if target is in this node's children range
                child_start = node['child']
                if child_start == target:
                    parents.append((i, node))
        if parents:
            print(f"\nEntry {target} is child of:")
            for idx, p in parents[:5]:
                print(f"  Entry {idx}: letter='{p['letter']}' ptr={p['ptr']} child={p['child']}")

    # Check Section 2 root structure
    print("\n" + "="*60)
    print("Section 2 roots (first 20 entries)")
    print("="*60)

    for i in range(section1_end, min(section1_end + 20, section2_end)):
        node = get_node(i)
        print(f"Entry {i}: [{node['bytes']}] letter='{node['letter']}' "
              f"is_word={int(node['is_word'])} child={node['child']}")


if __name__ == "__main__":
    main()
