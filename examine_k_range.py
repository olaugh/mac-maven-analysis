#!/usr/bin/env python3
"""
Examine the k-range structure in detail to understand how to enumerate.
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

k_range = letter_ranges['k']
print(f"k-range: {k_range[0]} to {k_range[1]} ({k_range[1] - k_range[0]} entries)")

# What are the top-level sibling groups in k-range?
print("\nTop-level sibling groups in k-range:")
entry = k_range[0]
group_count = 0
while entry < k_range[1] and group_count < 30:
    sibs = get_siblings(entry)
    if not sibs:
        entry += 1
        continue

    # Show group
    group_letters = [s['letter'] for s in sibs]
    word_letters = [s['letter'] for s in sibs if s['is_word']]
    print(f"  Group at {entry}: {group_letters} (WORD: {word_letters})")

    entry += len(sibs)
    group_count += 1

# For validation, the k-range is used to find words ending in 'k'
# The letters in k-range represent the SECOND-TO-LAST letter
# Wait - but the trace showed r@983 as first step, with 983 being IN k-range

# Let me check entry 983 specifically
print("\n" + "=" * 60)
print("Checking entry 983 (from AARDVARK trace):")
node_983 = get_node(983)
print(f"  Entry 983: {node_983}")
print(f"  In k-range? {k_range[0]} <= 983 < {k_range[1]}: {k_range[0] <= 983 < k_range[1]}")

# What sibling group is 983 in?
for start in range(980, 984):
    sibs = get_siblings(start)
    for s in sibs:
        if s['entry'] == 983:
            print(f"  983 is in sibling group starting at {start}")
            print(f"  Siblings: {[(ss['letter'], ss['entry'], 'WORD' if ss['is_word'] else '') for ss in sibs]}")
            break

# For AARDVARK (KRAVDRAA reversed):
# K = ending letter (indexed by k-range)
# RAVDRAA = path through k-range's structure
#
# The k-range should give us entry points where each entry's letter
# represents the second-to-last letter of words ending in 'k'

# So for words ending in 'k', the structure is:
# - Find the second-to-last letter in k-range top-level entries
# - Then recursively find remaining letters

print("\n" + "=" * 60)
print("Understanding the enumeration for 'k' words:")
print("=" * 60)

# The first sibling group in k-range should have all possible
# second-to-last letters of words ending in 'k'

first_group = get_siblings(k_range[0])
print(f"\nFirst sibling group (entry {k_range[0]}):")
print(f"  Letters: {[s['letter'] for s in first_group]}")
print(f"  WORD flags: {[(s['letter'], s['is_word']) for s in first_group]}")

# If any has WORD=True, that means the 2-letter word exists
# e.g., if 'a' has WORD=True, then "ak" is a word

# For AARDVARK, we need to find 'r' (second to last letter)
r_entries = [s for s in first_group if s['letter'] == 'r']
if r_entries:
    print(f"\n  'r' entry: {r_entries[0]}")
    r_node = r_entries[0]
    r_child = get_child_entry(r_node)
    print(f"  'r' child entry: {r_child}")

    if r_child:
        r_child_sibs = get_siblings(r_child)
        print(f"  'r' children: {[(s['letter'], s['is_word']) for s in r_child_sibs]}")

        # These children represent third-to-last letters of words ending in 'rk'
        # For AARDVARK, third-to-last is 'a'
        a_entries = [s for s in r_child_sibs if s['letter'] == 'a']
        if a_entries:
            print(f"\n  Following 'a' after 'r':")
            a_node = a_entries[0]
            a_child = get_child_entry(a_node)
            print(f"    'a' child entry: {a_child}")

            if a_child:
                a_child_sibs = get_siblings(a_child)
                print(f"    'a' children: {[(s['letter'], s['is_word']) for s in a_child_sibs]}")

                # Continue for 'v' (fourth-to-last)
                v_entries = [s for s in a_child_sibs if s['letter'] == 'v']
                if v_entries:
                    print(f"\n  Following 'v' after 'ar':")
                    v_node = v_entries[0]
                    v_child = get_child_entry(v_node)
                    print(f"    'v' child entry: {v_child}")

                    if v_child:
                        v_child_sibs = get_siblings(v_child)
                        print(f"    'v' children: {[(s['letter'], s['is_word']) for s in v_child_sibs]}")

# This should show us how KRAVDRAA is stored and how to enumerate
