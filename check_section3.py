#!/usr/bin/env python3
"""
Check if AARDVARK/AARDVARKS exists in Section 3.
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

    print(f"Sections: 1={section1_end}, 2={section2_end}, 3={section3_end}")

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        if not (97 <= letter <= 122):
            return None
        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter),
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'entry': entry_idx,
        }

    def get_child_entry(node):
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def get_siblings(start_entry, limit=100):
        siblings = []
        entry = start_entry
        while len(siblings) < limit:
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    # Check Section 3 structure
    print(f"\n{'='*60}")
    print(f"Section 3: entries {section2_end} to {section3_end}")
    print(f"{'='*60}")

    print("\nFirst 50 entries in Section 3:")
    for i in range(50):
        entry = section2_end + i
        node = get_node(entry)
        if node:
            child = get_child_entry(node)
            print(f"  {entry}: '{node['letter']}' ptr={node['ptr']:5d} flags=0x{node['flags']:02x} child={child} {'[W]' if node['is_word'] else ''} {'[L]' if node['is_last'] else ''}")

    # Find 'a' entries in Section 3
    print(f"\n{'='*60}")
    print("'a' entries in Section 3:")
    a_entries = []
    for entry_idx in range(section2_end, section3_end):
        node = get_node(entry_idx)
        if node and node['letter'] == 'a':
            a_entries.append(node)

    print(f"Found {len(a_entries)} 'a' entries")
    print("\nFirst 30:")
    for node in a_entries[:30]:
        child = get_child_entry(node)
        # Check what letters the child has
        child_letters = []
        if child:
            sibs = get_siblings(child)
            child_letters = [s['letter'] for s in sibs]
        print(f"  Entry {node['entry']}: child={child} -> {child_letters}")

    # Search for path a->a->r->d->v->a->r->k in Section 3
    print(f"\n{'='*60}")
    print("Searching for AARDVARK path from Section 3 'a' entries...")

    for start_node in a_entries:
        child = get_child_entry(start_node)
        if child is None:
            continue

        sibs = get_siblings(child)
        for s in sibs:
            if s['letter'] == 'a':
                # Found 'a' -> 'a', continue to 'r'
                a_child = get_child_entry(s)
                if a_child is None:
                    continue
                a_sibs = get_siblings(a_child)
                for s2 in a_sibs:
                    if s2['letter'] == 'r':
                        # Found 'a' -> 'a' -> 'r', continue to 'd'
                        r_child = get_child_entry(s2)
                        if r_child is None:
                            continue
                        r_sibs = get_siblings(r_child)
                        for s3 in r_sibs:
                            if s3['letter'] == 'd':
                                # Found path! Check deeper
                                d_child = get_child_entry(s3)
                                print(f"\n  Found a->a->r->d at Section3 entry {start_node['entry']}")
                                print(f"    Path: a@{start_node['entry']} -> a@{s['entry']} -> r@{s2['entry']} -> d@{s3['entry']}")
                                if d_child:
                                    d_sibs = get_siblings(d_child)
                                    print(f"    After 'd': {[x['letter'] for x in d_sibs]}")

                                    # Continue: v->a->r->k
                                    for s4 in d_sibs:
                                        if s4['letter'] == 'v':
                                            v_child = get_child_entry(s4)
                                            if v_child:
                                                v_sibs = get_siblings(v_child)
                                                for s5 in v_sibs:
                                                    if s5['letter'] == 'a':
                                                        a2_child = get_child_entry(s5)
                                                        if a2_child:
                                                            a2_sibs = get_siblings(a2_child)
                                                            for s6 in a2_sibs:
                                                                if s6['letter'] == 'r':
                                                                    r2_child = get_child_entry(s6)
                                                                    if r2_child:
                                                                        r2_sibs = get_siblings(r2_child)
                                                                        for s7 in r2_sibs:
                                                                            if s7['letter'] == 'k':
                                                                                print(f"    *** FOUND AARDVARK path! k@{s7['entry']} is_word={s7['is_word']}")
                                                                                k_child = get_child_entry(s7)
                                                                                if k_child:
                                                                                    k_sibs = get_siblings(k_child)
                                                                                    for s8 in k_sibs:
                                                                                        if s8['letter'] == 's':
                                                                                            print(f"    *** FOUND AARDVARKS! s@{s8['entry']} is_word={s8['is_word']}")


if __name__ == "__main__":
    main()
