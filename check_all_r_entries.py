#!/usr/bin/env python3
"""
Check all 'r' entries in k-range to find AARDVARK path.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

LETTER_INDEX_OFFSET = 0x10
letter_index = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1, flags, letter = data[offset:offset+4]
    entry = (b0 << 8) | b1
    letter_index[chr(ord('a') + i)] = entry

letters = 'abcdefghijklmnopqrstuvwxyz'
letter_ranges = {}
for i, L in enumerate(letters):
    start = letter_index[L]
    end = letter_index[letters[i+1]] if i < 25 else section1_end
    letter_ranges[L] = (start, end)

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
        'is_word': (flags & 0x80) != 0,
        'is_last': (flags & 0x01) != 0,
        'entry': entry_idx,
    }

def get_child_entry(node):
    if node['ptr'] == 0:
        return None
    return node['ptr'] + (node['flags'] & 0x7e)

def get_siblings(start_entry, limit=50):
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

# Find ALL 'r' entries in k-range
k_range = letter_ranges['k']
print(f"k-range: {k_range}")

r_entries = []
entry = k_range[0]
while entry < k_range[1]:
    sibs = get_siblings(entry)
    if not sibs:
        entry += 1
        continue
    for s in sibs:
        if s['letter'] == 'r':
            r_entries.append(s['entry'])
    entry += len(sibs)

print(f"\n'r' entries in k-range: {r_entries}")

# For each 'r' entry, try to trace AVDRAA path
# AARDVARK reversed = KRAVDRAA
# After 'r' (second-to-last), we need: a, v, d, r, a, a

target_path = ['a', 'v', 'd', 'r', 'a', 'a']

for r_entry in r_entries:
    print(f"\n" + "=" * 60)
    print(f"Tracing from 'r' at entry {r_entry}:")

    r_node = get_node(r_entry)
    print(f"  r@{r_entry}: ptr={r_node['ptr']} flags=0x{r_node['flags']:02x}")

    child = get_child_entry(r_node)
    if child is None:
        print("  No children")
        continue

    print(f"  Child entry: {child}")
    sibs = get_siblings(child)
    print(f"  Children: {[(s['letter'], s['entry']) for s in sibs]}")

    # Look for 'a' (first in target_path)
    a_entries = [s for s in sibs if s['letter'] == 'a']
    if not a_entries:
        print("  No 'a' child - cannot continue")
        continue

    for a_node in a_entries:
        print(f"\n  Trying 'a' at entry {a_node['entry']}:")
        a_child = get_child_entry(a_node)
        if a_child is None:
            print("    No children for 'a'")
            continue

        a_sibs = get_siblings(a_child)
        print(f"    'a' children: {[(s['letter'], s['entry']) for s in a_sibs]}")

        # Look for 'v'
        v_entries = [s for s in a_sibs if s['letter'] == 'v']
        if not v_entries:
            print("    No 'v' child")
            continue

        for v_node in v_entries:
            print(f"\n    Found 'v' at entry {v_node['entry']}:")
            v_child = get_child_entry(v_node)
            if v_child is None:
                print("      No children for 'v'")
                continue

            v_sibs = get_siblings(v_child)
            print(f"      'v' children: {[(s['letter'], s['entry']) for s in v_sibs]}")

            # Look for 'd'
            d_entries = [s for s in v_sibs if s['letter'] == 'd']
            if not d_entries:
                print("      No 'd' child")
                continue

            for d_node in d_entries:
                print(f"\n      Found 'd' at entry {d_node['entry']}:")
                d_child = get_child_entry(d_node)
                if d_child is None:
                    print("        No children for 'd'")
                    continue

                d_sibs = get_siblings(d_child)
                print(f"        'd' children: {[(s['letter'], s['entry']) for s in d_sibs]}")

                # Look for 'r'
                r2_entries = [s for s in d_sibs if s['letter'] == 'r']
                if not r2_entries:
                    print("        No 'r' child")
                    continue

                for r2_node in r2_entries:
                    print(f"\n        Found 'r' at entry {r2_node['entry']}:")
                    r2_child = get_child_entry(r2_node)
                    if r2_child is None:
                        print("          No children for 'r'")
                        continue

                    r2_sibs = get_siblings(r2_child)
                    print(f"          'r' children: {[(s['letter'], s['entry']) for s in r2_sibs]}")

                    # Look for 'a'
                    a2_entries = [s for s in r2_sibs if s['letter'] == 'a']
                    if not a2_entries:
                        print("          No 'a' child")
                        continue

                    for a2_node in a2_entries:
                        print(f"\n          Found 'a' at entry {a2_node['entry']}:")
                        a2_child = get_child_entry(a2_node)
                        if a2_child is None:
                            print("            No children for final 'a'")
                            # Check if this 'a' has WORD flag
                            if a2_node['is_word']:
                                print("            BUT this 'a' has WORD flag - 7 letter word!")
                            continue

                        a2_sibs = get_siblings(a2_child)
                        print(f"            'a' children: {[(s['letter'], s['entry'], 'WORD' if s['is_word'] else '') for s in a2_sibs]}")

                        # Look for final 'a' with WORD flag
                        a3_entries = [s for s in a2_sibs if s['letter'] == 'a']
                        for a3_node in a3_entries:
                            if a3_node['is_word']:
                                print(f"\n            FOUND! Final 'a' at {a3_node['entry']} with WORD flag")
                                print(f"            AARDVARK path: r@{r_entry} -> a@{a_node['entry']} -> v@{v_node['entry']} -> d@{d_node['entry']} -> r@{r2_node['entry']} -> a@{a2_node['entry']} -> a@{a3_node['entry']}")
