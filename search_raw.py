#!/usr/bin/env python3
"""
Search raw bytes for AARDVARK patterns and analyze the lexicon filtering mechanism.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    print(f"File size: {len(data)} bytes")

    # Search for consecutive letters of 'aardvark' (as ASCII)
    pattern = b'aardvark'
    print(f"\nSearching for raw ASCII '{pattern.decode()}'...")
    pos = data.find(pattern)
    if pos >= 0:
        print(f"  Found at offset 0x{pos:x}")
    else:
        print(f"  Not found as raw ASCII")

    # Search for reversed pattern
    rev_pattern = b'kravdraa'
    print(f"\nSearching for reversed '{rev_pattern.decode()}'...")
    pos = data.find(rev_pattern)
    if pos >= 0:
        print(f"  Found at offset 0x{pos:x}")
    else:
        print(f"  Not found")

    # The DAWG stores letters in the 4th byte of each node
    # So we should search for the pattern in letter bytes

    section1_end = struct.unpack('>I', data[0:4])[0]
    total_entries = (len(data) - NODE_START) // 4

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter) if 97 <= letter <= 122 else None,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'entry': entry_idx,
        }

    # Extract all letters
    print(f"\nBuilding letter sequence from nodes...")
    letters = []
    for i in range(total_entries):
        node = get_node(i)
        if node and node['letter']:
            letters.append((i, node['letter']))

    letter_str = ''.join([l for i, l in letters])
    print(f"Total nodes with valid letters: {len(letters)}")

    # Search for consecutive aardvark letters
    target = 'aardvark'
    print(f"\nSearching for consecutive '{target}' in letter sequence...")
    for i in range(len(letters) - len(target) + 1):
        window = ''.join([letters[i+j][1] for j in range(len(target))])
        if window == target:
            entries = [letters[i+j][0] for j in range(len(target))]
            print(f"  Found at entries {entries}")

    # Search reversed
    target_rev = 'kravdraa'
    print(f"\nSearching for consecutive '{target_rev}' in letter sequence...")
    for i in range(len(letters) - len(target_rev) + 1):
        window = ''.join([letters[i+j][1] for j in range(len(target_rev))])
        if window == target_rev:
            entries = [letters[i+j][0] for j in range(len(target_rev))]
            print(f"  Found at entries {entries}")

    # Now check if these are connected via child pointers
    # A proper DAWG word would have connected nodes

    # Let's check entry 179 which validates 'aa'
    print(f"\n{'='*60}")
    print("Checking validation patterns for known words...")

    def get_child_entry(node):
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    # Trace 'aa' - should be at 179
    node_179 = get_node(179)
    print(f"\nEntry 179: {node_179}")
    if node_179:
        child = get_child_entry(node_179)
        print(f"  Child: {child}")
        if child:
            child_node = get_node(child)
            print(f"  Child node: {child_node}")

    # Check dictionary mode flags - maybe AARDVARK only exists in OSW mode?
    # The CODE resources have filtering logic at A5-24244

    # Let me analyze the patterns in the raw data near the first entries
    print(f"\n{'='*60}")
    print("Analyzing structure of first 100 nodes...")

    for i in range(100):
        node = get_node(i)
        if node:
            child = get_child_entry(node)
            child_str = f"-> {child}" if child else "-> None"
            print(f"  {i:3d}: {node['letter'] or '?'} ptr={node['ptr']:4d} flags=0x{node['flags']:02x} {child_str:12} {'W' if node['is_word'] else ' '} {'L' if node['is_last'] else ' '}")


if __name__ == "__main__":
    main()
