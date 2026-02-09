#!/usr/bin/env python3
"""
Check entries 108 (k) and 113 (s) for AARDVARK/AARDVARKS word flags.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

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

# Check entries around 103
print("Sibling group containing entry 103:")
for entry in range(100, 120):
    node = get_node(entry)
    if node:
        child = get_child_entry(node)
        print(f"  {entry}: '{node['letter']}' ptr={node['ptr']} flags=0x{node['flags']:02x} child={child} {'WORD' if node['is_word'] else ''} {'LAST' if node['is_last'] else ''}")

# Specifically check 108 (k) and 113 (s)
print("\n" + "=" * 60)
print("Entry 108 (potential AARDVARK ending 'k'):")
node_108 = get_node(108)
print(f"  {node_108}")
if node_108:
    print(f"  is_word = {node_108['is_word']} -> {'AARDVARK would be valid!' if node_108['is_word'] else 'NOT a word ending'}")

print("\nEntry 113 (potential AARDVARKS ending 's'):")
node_113 = get_node(113)
print(f"  {node_113}")
if node_113:
    print(f"  is_word = {node_113['is_word']} -> {'AARDVARKS would be valid!' if node_113['is_word'] else 'NOT a word ending'}")

# Wait - but the AARDVARK path ended at a@103, not k@108
# Let me trace the full path again to understand

print("\n" + "=" * 60)
print("Re-tracing AARDVARK Section 1 path:")

# Section 1 reverse: KRAVDRAA
# Path found was: k-range → r@983 → a@103 → v@30 → d@175 → r@73 → a@36 → a@103

# But that means we go:
# k-range (start) -> find 'r' -> find 'a' -> find 'v' -> find 'd' -> find 'r' -> find 'a' -> find 'a' (WORD)

# For AARDVARK forward: a-a-r-d-v-a-r-k
# Last letter is 'k', so Section 1 uses k-range
# Reversed: k-r-a-v-d-r-a-a

# Hmm, the path I traced went: r@983 -> a@103 -> v@30 -> d@175 -> r@73 -> a@36 -> a@103
# That spells RAVDRAA backwards = AARDVAR (7 letters)!
# Missing the 'K' at the start

# Let me re-trace from k-range properly
print("\nProper trace from k-range:")

# k-range: 956 to 1006
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

k_range = letter_ranges['k']
print(f"k-range: {k_range}")

# The k-range gives us words ending in 'k'
# For AARDVARK: last letter is 'k', so start here
# We then look for remaining letters: R-A-V-D-R-A-A (AARDVARK reversed minus K)

# But wait - the k-range doesn't contain 'k' entries, it contains entries for
# looking up words ending in 'k'. Let me check what's there.

print("\nk-range entries:")
entry = k_range[0]
while entry < k_range[1]:
    sibs = get_siblings(entry)
    if sibs:
        letters_in_group = [(s['letter'], s['entry'], s['is_word']) for s in sibs]
        print(f"  Entry {entry}: {letters_in_group}")
        entry += len(sibs)
    else:
        entry += 1

# Look for 'r' in k-range (first letter of RAVDRAA = remaining letters of KRAVDRAA)
print("\nLooking for 'r' in k-range to start RAVDRAA trace:")
entry = k_range[0]
while entry < k_range[1]:
    sibs = get_siblings(entry)
    for s in sibs:
        if s['letter'] == 'r':
            print(f"  Found 'r' at {s['entry']}, child={get_child_entry(s)}")
    entry += len(sibs) if sibs else 1

# OK so the structure is:
# k-range contains entries for second-to-last letters of words ending in 'k'
# Find 'r' (second to last of AARDVARK) -> follow children for remaining letters

# For AARDVARK (KRAVDRAA reversed):
# 1. K is the last letter (index gives range)
# 2. R is second to last (find in k-range)
# 3. A is third to last (find in r's children)
# ... etc until first letter
# 4. Final letter has WORD flag

# So entry 103's 'a' with WORD=True marks the FIRST letter 'A' of AARDVARK!
# The path ends at the first letter of the actual word.

# For AARDVARKS:
# S is last letter, so use s-range
# But s-range doesn't have 'k' (second to last of AARDVARKS)
# That's why AARDVARKS isn't found!

print("\n" + "=" * 60)
print("Understanding the structure:")
print("  - k-range contains entries for words ending in 'k'")
print("  - For AARDVARK: find RAVDRAA path in k-range, ending at 'a' with WORD flag")
print("  - Entry 103 is the final 'a' with WORD=True (first letter of AARDVARK)")
print("")
print("  - s-range contains entries for words ending in 's'")
print("  - For AARDVARKS: would need KRAVDRAA path in s-range")
print("  - But s-range doesn't have 'k' to start the path")
print("  - That's why AARDVARKS is NOT in the DAWG structure!")
