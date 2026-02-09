#!/usr/bin/env python3
"""
Look at the actual entries in detail.
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
            'raw': f'{b0:02x} {b1:02x} {flags:02x} {letter_byte:02x}',
            'letter': chr(letter_byte) if 97 <= letter_byte <= 122 else f'0x{letter_byte:02x}',
            'base_ptr': base_ptr,
            'flags': flags,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    print("="*60)
    print("Entries 0-50 (before letter ranges)")
    print("="*60)
    for i in range(51):
        node = get_node(i)
        marker = "*" if node['is_word'] else " "
        last = "L" if node['is_last'] else " "
        print(f"{i:4d}: [{node['raw']}] '{node['letter']}' {marker}{last} base={node['base_ptr']:4d} child={node['child']:4d}")

    print("\n" + "="*60)
    print("Entries 165-185 (around 'a' index = 169)")
    print("="*60)
    for i in range(165, 186):
        node = get_node(i)
        marker = "*" if node['is_word'] else " "
        last = "L" if node['is_last'] else " "
        extra = " <-- 'a' index" if i == 169 else ""
        print(f"{i:4d}: [{node['raw']}] '{node['letter']}' {marker}{last} base={node['base_ptr']:4d} child={node['child']:4d}{extra}")

    print("\n" + "="*60)
    print("Looking for entry with letter='a' and is_word=True near roots")
    print("="*60)
    for i in range(200):
        node = get_node(i)
        if node['letter'] == 'a' and node['is_word']:
            print(f"Entry {i}: 'a' is_word=True, base={node['base_ptr']}, child={node['child']}")

    print("\n" + "="*60)
    print("Entries 278-290 (around 'b' index = 282)")
    print("="*60)
    for i in range(278, 291):
        node = get_node(i)
        marker = "*" if node['is_word'] else " "
        last = "L" if node['is_last'] else " "
        extra = " <-- 'b' index" if i == 282 else ""
        print(f"{i:4d}: [{node['raw']}] '{node['letter']}' {marker}{last} base={node['base_ptr']:4d} child={node['child']:4d}{extra}")

    # Trace what the letter index actually represents
    print("\n" + "="*60)
    print("Letter index entries - what letter is at each position?")
    print("="*60)
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        entry = struct.unpack('>H', data[offset:offset+2])[0]
        letter_index[chr(ord('a') + i)] = entry
        node = get_node(entry)
        print(f"Index '{chr(ord('a')+i)}' -> entry {entry:4d} which has letter='{node['letter']}'")

if __name__ == "__main__":
    main()
