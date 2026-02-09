#!/usr/bin/env python3
"""
Check what's after Section 3 in the DAWG file.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    section3_end = struct.unpack('>I', data[8:12])[0]
    total_entries = (len(data) - NODE_START) // 4

    print(f"File size: {len(data)} bytes")
    print(f"Sections: 1={section1_end}, 2={section2_end}, 3={section3_end}")
    print(f"Section 3 ends at byte offset: {NODE_START + section3_end * 4} = 0x{NODE_START + section3_end * 4:x}")
    print(f"Total data entries: {total_entries}")
    print(f"Entries after Section 3: {total_entries - section3_end}")

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter) if 97 <= letter <= 122 else f'0x{letter:02x}',
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'entry': entry_idx,
            'raw_letter': letter,
        }

    # Check entries around section3_end
    print(f"\n{'='*60}")
    print(f"Entries around Section 3 end ({section3_end}):")
    for i in range(-5, 50):
        entry = section3_end + i
        if entry >= 0:
            node = get_node(entry)
            if node:
                print(f"  {entry:6d}: '{node['letter']}' (0x{node['raw_letter']:02x}) ptr={node['ptr']:5d} flags=0x{node['flags']:02x} {'[W]' if node['is_word'] else ''} {'[L]' if node['is_last'] else ''}")

    # Check for a second header
    print(f"\n{'='*60}")
    print("Checking if Section 4 has its own header...")

    section4_start_offset = NODE_START + section3_end * 4
    print(f"Section 4 starts at byte 0x{section4_start_offset:x}")

    # Read potential header
    if section4_start_offset + 16 <= len(data):
        h0 = struct.unpack('>I', data[section4_start_offset:section4_start_offset+4])[0]
        h1 = struct.unpack('>I', data[section4_start_offset+4:section4_start_offset+8])[0]
        h2 = struct.unpack('>I', data[section4_start_offset+8:section4_start_offset+12])[0]
        h3 = struct.unpack('>I', data[section4_start_offset+12:section4_start_offset+16])[0]
        print(f"First 16 bytes as header: {h0}, {h1}, {h2}, {h3}")

    # Count entries in potential second DAWG
    section4_entries = total_entries - section3_end
    print(f"\nPotential Section 4 size: {section4_entries} entries")

    # Check if there's a letter index
    if section4_start_offset + 0x410 <= len(data):
        print(f"\nLetter index at offset 0x10 from Section 4 start:")
        for i in range(26):
            offset = section4_start_offset + 0x10 + i * 4
            if offset + 4 <= len(data):
                b0, b1, flags, letter = data[offset:offset+4]
                entry = (b0 << 8) | b1
                print(f"  {chr(ord('a')+i)}: entry={entry:5d} flags=0x{flags:02x} letter=0x{letter:02x}")

    # Find 'a' entries in Section 4+
    print(f"\n{'='*60}")
    print("Finding 'a' entries after Section 3...")

    a_entries = []
    for entry_idx in range(section3_end, min(section3_end + 50000, total_entries)):
        node = get_node(entry_idx)
        if node and node['letter'] == 'a':
            a_entries.append(node)

    print(f"Found {len(a_entries)} 'a' entries in first 50k after Section 3")

    # Try to trace AARDVARK from these
    def get_child_entry(node):
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def get_siblings(start_entry, limit=100):
        siblings = []
        entry = start_entry
        while len(siblings) < limit:
            node = get_node(entry)
            if node is None or not (97 <= node['raw_letter'] <= 122):
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    print(f"\nSearching for AARDVARK path from Section 4 'a' entries...")

    for start_node in a_entries[:1000]:
        child = get_child_entry(start_node)
        if child is None:
            continue

        sibs = get_siblings(child)
        for s in sibs:
            if s['letter'] == 'a':
                a_child = get_child_entry(s)
                if a_child:
                    a_sibs = get_siblings(a_child)
                    for s2 in a_sibs:
                        if s2['letter'] == 'r':
                            r_child = get_child_entry(s2)
                            if r_child:
                                r_sibs = get_siblings(r_child)
                                for s3 in r_sibs:
                                    if s3['letter'] == 'd':
                                        print(f"\n  Found a->a->r->d starting at {start_node['entry']}")
                                        print(f"    Path: {start_node['entry']} -> {s['entry']} -> {s2['entry']} -> {s3['entry']}")
                                        # Continue: v->a->r->k
                                        d_child = get_child_entry(s3)
                                        if d_child:
                                            d_sibs = get_siblings(d_child)
                                            for s4 in d_sibs:
                                                if s4['letter'] == 'v':
                                                    print(f"    -> v@{s4['entry']}")
                                                    v_child = get_child_entry(s4)
                                                    if v_child:
                                                        v_sibs = get_siblings(v_child)
                                                        for s5 in v_sibs:
                                                            if s5['letter'] == 'a':
                                                                print(f"    -> a@{s5['entry']}")
                                                                a2_child = get_child_entry(s5)
                                                                if a2_child:
                                                                    a2_sibs = get_siblings(a2_child)
                                                                    for s6 in a2_sibs:
                                                                        if s6['letter'] == 'r':
                                                                            print(f"    -> r@{s6['entry']}")
                                                                            r2_child = get_child_entry(s6)
                                                                            if r2_child:
                                                                                r2_sibs = get_siblings(r2_child)
                                                                                for s7 in r2_sibs:
                                                                                    if s7['letter'] == 'k':
                                                                                        print(f"    -> k@{s7['entry']} WORD={s7['is_word']}")
                                                                                        if s7['is_word']:
                                                                                            print(f"    *** AARDVARK FOUND! ***")


if __name__ == "__main__":
    main()
