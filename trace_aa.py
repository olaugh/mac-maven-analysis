#!/usr/bin/env python3
"""
Trace how 'AA' is found in the DAWG.
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
            'entry': entry_idx,
        }

    # Entry 10756 points to 174 giving 'aa'
    print("="*60)
    print("Analyzing entry 10756 -> 174 ('aa')")
    print("="*60)

    node_10756 = get_node(10756)
    node_174 = get_node(174)

    print(f"\nEntry 10756: {node_10756}")
    print(f"Entry 174: {node_174}")

    # Who points to 10756?
    print("\n" + "="*60)
    print("Who points to entry 10756?")
    print("="*60)

    for i in range(section1_end):
        node = get_node(i)
        if node['child'] == 10756:
            print(f"  Entry {i}: letter='{node['letter']}' child={node['child']}")

    # What's the letter index say about 'a'?
    print("\n" + "="*60)
    print("Letter index around 'a'")
    print("="*60)

    a_index_offset = 0x10  # 'a' is first letter
    a_entry = struct.unpack('>H', data[a_index_offset:a_index_offset+2])[0]
    print(f"Letter index 'a' = entry {a_entry}")

    # Show entries around 10756
    print("\n" + "="*60)
    print("Entries around 10756")
    print("="*60)
    for i in range(10750, 10765):
        node = get_node(i)
        marker = "*" if node['is_word'] else " "
        last = "L" if node['is_last'] else " "
        print(f"{i}: '{node['letter']}' {marker}{last} child={node['child']}")

    # Try to find all 2-letter words by scanning for entries where:
    # - The entry has a letter
    # - Its child has is_word=True
    print("\n" + "="*60)
    print("Finding all 2-letter words by structure")
    print("="*60)

    two_letter = set()
    for i in range(section1_end):
        node = get_node(i)
        if node['letter'] and node['child'] > 0 and node['child'] < section1_end:
            child = get_node(node['child'])
            if child['letter'] and child['is_word']:
                word = node['letter'] + child['letter']
                two_letter.add(word)

    print(f"Found {len(two_letter)} potential 2-letter words")
    print(f"Sample: {sorted(two_letter)[:30]}")

    # Check against known
    known = {'aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
             'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
             'by', 'za'}

    found = known & two_letter
    missing = known - two_letter
    print(f"\nKnown found: {len(found)}")
    print(f"Missing: {missing}")

if __name__ == "__main__":
    main()
