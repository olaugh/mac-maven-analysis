#!/usr/bin/env python3
"""
Trace the exact path for AARDVARK in Section 1.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

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
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'entry': entry_idx,
    }

def get_child_entry(node):
    if node['ptr'] == 0:
        return None
    return node['ptr'] + (node['flags'] & 0x7e)

# Trace AARDVARK step by step
# Reversed: KRAVDRAA
# k-range, then find R, A, V, D, R, A, A

print("Tracing AARDVARK (reversed: KRAVDRAA):")
print("=" * 60)

k_range = letter_ranges['k']
print(f"k-range: {k_range[0]} to {k_range[1]}")

# Step 1: Find 'R' in k-range
print("\nStep 1: Find 'R' in k-range")
for entry in range(k_range[0], k_range[1]):
    node = get_node(entry)
    if node and node['letter'] == 'r':
        print(f"  Found 'r' at entry {entry}")
        print(f"    ptr={node['ptr']}, flags=0x{node['flags']:02x}")
        print(f"    child = {get_child_entry(node)}")

        # We'll use entry 983 as it was found in previous traces
        if entry == 983:
            r_node = node
            break

# Step 2: From r@983, find 'A'
print("\nStep 2: Find 'A' from r@983's child")
r_child = get_child_entry(r_node)
print(f"  r@983 child = {r_child}")

for entry in range(r_child, section1_end):
    node = get_node(entry)
    if node and node['letter'] == 'a':
        print(f"  Found 'a' at entry {entry}, WORD={node['is_word']}")
        print(f"    child = {get_child_entry(node)}")
        a_node = node
        a_entry = entry
        break

# Step 3: From a@entry, find 'V'
print("\nStep 3: Find 'V' from a's child")
a_child = get_child_entry(a_node)
print(f"  a@{a_entry} child = {a_child}")

for entry in range(a_child, section1_end):
    node = get_node(entry)
    if node and node['letter'] == 'v':
        print(f"  Found 'v' at entry {entry}")
        print(f"    child = {get_child_entry(node)}")
        v_node = node
        v_entry = entry
        break

# Step 4: From v@entry, find 'D'
print("\nStep 4: Find 'D' from v's child")
v_child = get_child_entry(v_node)
print(f"  v@{v_entry} child = {v_child}")

for entry in range(v_child, section1_end):
    node = get_node(entry)
    if node and node['letter'] == 'd':
        print(f"  Found 'd' at entry {entry}")
        print(f"    child = {get_child_entry(node)}")
        d_node = node
        d_entry = entry
        break

# Step 5: From d@entry, find 'R'
print("\nStep 5: Find 'R' from d's child")
d_child = get_child_entry(d_node)
print(f"  d@{d_entry} child = {d_child}")

for entry in range(d_child, section1_end):
    node = get_node(entry)
    if node and node['letter'] == 'r':
        print(f"  Found 'r' at entry {entry}")
        print(f"    child = {get_child_entry(node)}")
        r2_node = node
        r2_entry = entry
        break

# Step 6: From r@entry, find 'A'
print("\nStep 6: Find 'A' from r's child")
r2_child = get_child_entry(r2_node)
print(f"  r@{r2_entry} child = {r2_child}")

for entry in range(r2_child, section1_end):
    node = get_node(entry)
    if node and node['letter'] == 'a':
        print(f"  Found 'a' at entry {entry}, WORD={node['is_word']}")
        print(f"    child = {get_child_entry(node)}")
        a2_node = node
        a2_entry = entry
        break

# Step 7: From a@entry, find final 'A' with WORD flag
print("\nStep 7: Find final 'A' with WORD flag from a's child")
a2_child = get_child_entry(a2_node)
print(f"  a@{a2_entry} child = {a2_child}")

for entry in range(a2_child, section1_end):
    node = get_node(entry)
    if node and node['letter'] == 'a':
        print(f"  Found 'a' at entry {entry}, WORD={node['is_word']}")
        if node['is_word']:
            print("  --> AARDVARK PATH COMPLETE!")
        a3_node = node
        a3_entry = entry
        break

print("\n" + "=" * 60)
print("COMPLETE PATH for AARDVARK:")
print(f"  k-range -> r@983 -> a@{a_entry} -> v@{v_entry} -> d@{d_entry} -> r@{r2_entry} -> a@{a2_entry} -> a@{a3_entry}")
print(f"  Final 'a' has WORD flag: {a3_node['is_word']}")

# Now trace AARDVARKS
print("\n" + "=" * 60)
print("Tracing AARDVARKS (reversed: SKRAVDRAA):")
print("=" * 60)

s_range = letter_ranges['s']
print(f"s-range: {s_range[0]} to {s_range[1]}")

# Step 1: Find 'K' in s-range
print("\nStep 1: Find 'K' in s-range")
found_k = False
for entry in range(s_range[0], s_range[1]):
    node = get_node(entry)
    if node and node['letter'] == 'k':
        print(f"  Found 'k' at entry {entry}")
        found_k = True
        break

if not found_k:
    print("  NO 'K' FOUND in s-range!")
    print("  AARDVARKS cannot exist because s-range has no 'k' entry")
    print("  (Words ending in 's' have no path starting with 'k' as second-to-last letter)")
