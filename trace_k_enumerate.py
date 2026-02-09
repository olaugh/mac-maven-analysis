#!/usr/bin/env python3
"""
Trace k-range enumeration step by step to understand the structure.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

# Build letter index
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
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
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

# Start from entry 983 ('r') and trace through to find AARDVARK
print("Tracing from entry 983 ('r') for AARDVARK:")
print("=" * 60)

node_983 = get_node(983)
print(f"Entry 983: {node_983}")
print(f"  ptr = {node_983['ptr']}, flags = 0x{node_983['flags']:02x}")
print(f"  child = ptr + (flags & 0x7e) = {node_983['ptr']} + {node_983['flags'] & 0x7e} = {get_child_entry(node_983)}")

child_983 = get_child_entry(node_983)
if child_983:
    sibs = get_siblings(child_983)
    print(f"\n  Children of 'r' (at {child_983}):")
    for s in sibs:
        print(f"    {s['entry']}: '{s['letter']}' ptr={s['ptr']} {'WORD' if s['is_word'] else ''}")

    # Find 'a' and continue trace for AARDVARK (path is r-a-v-d-r-a-a)
    a_node = None
    for s in sibs:
        if s['letter'] == 'a':
            a_node = s
            break

    if a_node:
        print(f"\n  Following 'a' at entry {a_node['entry']}:")
        a_child = get_child_entry(a_node)
        if a_child:
            a_sibs = get_siblings(a_child)
            print(f"  Children of 'a' (at {a_child}):")
            for s in a_sibs:
                print(f"    {s['entry']}: '{s['letter']}' ptr={s['ptr']} {'WORD' if s['is_word'] else ''}")

            # Find 'v'
            v_node = None
            for s in a_sibs:
                if s['letter'] == 'v':
                    v_node = s
                    break

            if v_node:
                print(f"\n  Following 'v' at entry {v_node['entry']}:")
                v_child = get_child_entry(v_node)
                if v_child:
                    v_sibs = get_siblings(v_child)
                    print(f"  Children of 'v' (at {v_child}):")
                    for s in v_sibs:
                        print(f"    {s['entry']}: '{s['letter']}' ptr={s['ptr']} {'WORD' if s['is_word'] else ''}")

                    # Find 'd'
                    d_node = None
                    for s in v_sibs:
                        if s['letter'] == 'd':
                            d_node = s
                            break

                    if d_node:
                        print(f"\n  Following 'd' at entry {d_node['entry']}:")
                        d_child = get_child_entry(d_node)
                        if d_child:
                            d_sibs = get_siblings(d_child)
                            print(f"  Children of 'd' (at {d_child}):")
                            for s in d_sibs:
                                print(f"    {s['entry']}: '{s['letter']}' ptr={s['ptr']} {'WORD' if s['is_word'] else ''}")

                            # Find 'r'
                            r2_node = None
                            for s in d_sibs:
                                if s['letter'] == 'r':
                                    r2_node = s
                                    break

                            if r2_node:
                                print(f"\n  Following 'r' (second) at entry {r2_node['entry']}:")
                                r2_child = get_child_entry(r2_node)
                                if r2_child:
                                    r2_sibs = get_siblings(r2_child)
                                    print(f"  Children of 'r' (at {r2_child}):")
                                    for s in r2_sibs:
                                        print(f"    {s['entry']}: '{s['letter']}' ptr={s['ptr']} {'WORD' if s['is_word'] else ''}")

                                    # Find 'a'
                                    a2_node = None
                                    for s in r2_sibs:
                                        if s['letter'] == 'a':
                                            a2_node = s
                                            break

                                    if a2_node:
                                        print(f"\n  Following 'a' (second) at entry {a2_node['entry']}:")
                                        a2_child = get_child_entry(a2_node)
                                        if a2_child:
                                            a2_sibs = get_siblings(a2_child)
                                            print(f"  Children of 'a' (at {a2_child}):")
                                            for s in a2_sibs:
                                                print(f"    {s['entry']}: '{s['letter']}' ptr={s['ptr']} {'WORD' if s['is_word'] else ''}")

                                            # Find final 'a'
                                            a3_node = None
                                            for s in a2_sibs:
                                                if s['letter'] == 'a':
                                                    a3_node = s
                                                    break

                                            if a3_node:
                                                print(f"\n  Final 'a' at entry {a3_node['entry']}:")
                                                print(f"    is_word = {a3_node['is_word']}")
                                                if a3_node['is_word']:
                                                    print("    AARDVARK IS VALID!")
                                                else:
                                                    print("    NOT a word ending!")

# Now enumerate all words from entry 983
print("\n" + "=" * 60)
print("Enumerating words starting from entry 983 ('r'):")
print("=" * 60)

def enumerate_from_entry(start_entry, ending_letter, max_words=100):
    """Enumerate words from a specific entry."""
    words = []

    def dfs(entry, path, depth, visited):
        if depth > 15 or len(words) >= max_words:
            return
        if entry in visited:
            return
        visited = visited | {entry}

        node = get_node(entry)
        if node is None:
            return

        new_path = path + node['letter']

        if node['is_word']:
            # Reverse and add ending letter
            word = new_path[::-1] + ending_letter
            words.append(word)

        child = get_child_entry(node)
        if child:
            sibs = get_siblings(child)
            for s in sibs:
                dfs(s['entry'], new_path, depth + 1, visited)

    dfs(start_entry, '', 0, set())
    return words

words_from_983 = enumerate_from_entry(983, 'k', max_words=50)
print(f"Words from entry 983: {len(words_from_983)}")
for w in sorted(words_from_983):
    print(f"  {w}")

# Check if AARDVARK is in there
if 'aardvark' in words_from_983:
    print("\nAARDVARK FOUND!")
else:
    print("\nAARDVARK not in enumerated words")
