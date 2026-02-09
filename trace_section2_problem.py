#!/usr/bin/env python3
"""
Investigate why Section 2 is producing false positives.
"""

import struct

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1 = data[offset], data[offset+1]
        letter_index[chr(ord('a') + i)] = (b0 << 8) | b1
    return data, section1_end, section2_end, letter_index

def get_node(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0
    return {
        'letter': chr(letter) if 97 <= letter <= 122 else f'0x{letter:02x}',
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': child,
        'entry': entry_idx,
    }

def get_siblings(data, start, limit):
    sibs = []
    entry = start
    while entry < limit:
        node = get_node(data, entry)
        if node is None or node['letter'].startswith('0x'):
            break
        sibs.append(node)
        if node['is_last']:
            break
        entry += 1
    return sibs

def main():
    data, section1_end, section2_end, letter_index = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print("="*60)
    print("Investigating Section 2 -> Section 1 child sharing")
    print("="*60)

    # Find Section 2 'a' entries
    print(f"\nSection 2 'a' entries that lead to 'c' children:")
    print("-"*60)

    for idx in range(section1_end, section2_end):
        node = get_node(data, idx)
        if node and node['letter'] == 'a' and node['child']:
            # Check if children include 'c' with is_word=True
            child = node['child']
            if child < section1_end:
                sibs = get_siblings(data, child, section1_end)
                for s in sibs:
                    if s['letter'] == 'c' and s['is_word']:
                        print(f"\nSection 2 entry {idx}: 'a' with child={child}")
                        print(f"  Child siblings: {[sib['letter'] for sib in sibs]}")
                        print(f"  'c' at entry {s['entry']} has is_word=True")

                        # Now check: is this 'c' entry ALSO used by Section 1 paths?
                        print(f"\n  Entry {s['entry']} in Section 1 context:")
                        print(f"    Letter range for 'c': {letter_index['c']} to {letter_index['d']}")

                        # What reversed words use this entry?
                        # Entry 106 would be in the children of some node in the 'a' range
                        # for reversed words ending in 'a'

    print("\n" + "="*60)
    print("Looking at entry 106 specifically")
    print("="*60)

    node_106 = get_node(data, 106)
    print(f"\nEntry 106: {node_106}")

    # Find what nodes have entry 106 as a child
    print("\nNodes whose children include entry 106:")
    for idx in range(section1_end):
        node = get_node(data, idx)
        if node and node['child']:
            sibs = get_siblings(data, node['child'], section1_end)
            if any(s['entry'] == 106 for s in sibs):
                print(f"  Entry {idx}: letter='{node['letter']}' is_word={node['is_word']}")

    # Also check Section 2
    print("\nSection 2 nodes whose children include entry 106:")
    for idx in range(section1_end, section2_end):
        node = get_node(data, idx)
        if node and node['child']:
            sibs = get_siblings(data, node['child'], section1_end)
            if any(s['entry'] == 106 for s in sibs):
                print(f"  Entry {idx}: letter='{node['letter']}' is_word={node['is_word']}")

    # Check the 'a' letter range in Section 1
    print("\n" + "="*60)
    print("Checking Section 1 'a' range for entry 106")
    print("="*60)

    a_start = letter_index['a']
    a_end = letter_index['b']
    print(f"'a' range: {a_start} to {a_end}")

    # Get root siblings
    root_sibs = get_siblings(data, a_start, section1_end)
    print(f"Root siblings at {a_start}: {[s['letter'] for s in root_sibs]}")

    # Check if any of these have children that include entry 106
    for s in root_sibs:
        if s['child']:
            child_sibs = get_siblings(data, s['child'], section1_end)
            if any(cs['entry'] == 106 for cs in child_sibs):
                print(f"\n  '{s['letter']}' at entry {s['entry']} -> children include entry 106")
                print(f"    Children: {[(cs['letter'], cs['entry'], cs['is_word']) for cs in child_sibs]}")

    # The 'c' at entry 106 - what word does it represent?
    # If the 'a' range represents reversed words ending in 'a'...
    # And entry 106 is 'c' with is_word=True...
    # That means there are reversed words like "C-?-...-A" where after 'c' we're done

    print("\n" + "="*60)
    print("Key question: What does is_word=True mean at entry 106?")
    print("="*60)
    print("""
In Section 1, the 'a' range stores reversed words ending in 'a'.
Entry 106 ('c') is a child of some node in the 'a' range.

If we reach entry 106 via Section 1 (reversed), the path is:
  'a' (reversed word ends with 'a')
  -> (some letter)
  -> ...
  -> 'c' at entry 106

But if we reach entry 106 via Section 2 (forward), the path is:
  Section 2 'a' entry -> child -> 'c' at entry 106
  = Forward word 'AC'

The is_word flag at entry 106 was set based on Section 1 semantics,
NOT Section 2 semantics!

This is why Section 2 produces false positives - it's reusing Section 1
nodes whose is_word flags have different meanings.
""")

    # Let's verify: trace what Section 1 path uses entry 106
    print("Tracing Section 1 paths that use entry 106...")

    # Find nodes whose child sibling group contains entry 106
    for entry_idx in range(section1_end):
        node = get_node(data, entry_idx)
        if node and node['child']:
            child_sibs = get_siblings(data, node['child'], section1_end)
            for cs in child_sibs:
                if cs['entry'] == 106:
                    # Found a parent of entry 106
                    # Now trace back further to find the full path
                    print(f"\n  Entry {entry_idx} ('{node['letter']}') -> entry 106 ('c')")

                    # Find grandparent
                    for gp_idx in range(section1_end):
                        gp = get_node(data, gp_idx)
                        if gp and gp['child']:
                            gp_children = get_siblings(data, gp['child'], section1_end)
                            if any(c['entry'] == entry_idx for c in gp_children):
                                print(f"    Entry {gp_idx} ('{gp['letter']}') -> entry {entry_idx} ('{node['letter']}')")
                                break


if __name__ == "__main__":
    main()
