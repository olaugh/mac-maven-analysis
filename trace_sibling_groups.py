#!/usr/bin/env python3
"""
Trace sibling groups properly using LAST flags.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

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

# Map out all sibling groups from entry 0 to 200
print("Mapping sibling groups from entry 0-200:")
print("=" * 60)

entry = 0
group_id = 0
sibling_group_map = {}  # entry -> (group_start, group_entries)

while entry < 200:
    sibs = get_siblings(entry)
    if not sibs:
        entry += 1
        continue

    group_start = entry
    group_letters = [(s['entry'], s['letter'], s['is_word']) for s in sibs]

    for s in sibs:
        sibling_group_map[s['entry']] = (group_start, sibs)

    print(f"Group {group_id} at {group_start}: {[(e, l) for e, l, w in group_letters]} WORD:{[l for e, l, w in group_letters if w]}")

    entry += len(sibs)
    group_id += 1

# Now trace the AARDVARK path step by step
print("\n" + "=" * 60)
print("Tracing AARDVARK path properly:")
print("=" * 60)

# The path from the summary: k-range → r@983 → a@103 → v@30 → d@175 → r@73 → a@36 → a@103
# This seems wrong. Let me trace it fresh.

# Start: k-range contains entry 983 which is 'r'
# Entry 983 -> child 101 -> sibling group contains 'a' at 103

node_983 = get_node(983)
print(f"\nStep 1: Start at entry 983 ('{node_983['letter']}')")
child_983 = get_child_entry(node_983)
print(f"  Child entry: {child_983}")

group_at_child = sibling_group_map.get(child_983)
if not group_at_child:
    sibs = get_siblings(child_983)
    print(f"  Sibling group at {child_983}: {[(s['entry'], s['letter'], 'WORD' if s['is_word'] else '') for s in sibs]}")
else:
    sibs = group_at_child[1]
    print(f"  Sibling group at {child_983}: {[(s['entry'], s['letter'], 'WORD' if s['is_word'] else '') for s in sibs]}")

# Find 'a' in this group
a_node = None
for s in sibs:
    if s['letter'] == 'a':
        a_node = s
        print(f"\nStep 2: Found 'a' at entry {s['entry']}")
        break

if a_node:
    child_a = get_child_entry(a_node)
    print(f"  Child entry: {child_a}")

    sibs_a = get_siblings(child_a)
    print(f"  Sibling group at {child_a}: {[(s['entry'], s['letter'], 'WORD' if s['is_word'] else '') for s in sibs_a]}")

    # Find 'v'
    v_node = None
    for s in sibs_a:
        if s['letter'] == 'v':
            v_node = s
            print(f"\nStep 3: Found 'v' at entry {s['entry']}")
            break

    if not v_node:
        print(f"  No 'v' found! Available: {[s['letter'] for s in sibs_a]}")
        print("  The path a@103 → v@30 from the summary appears to be WRONG")

# Let me check if the original trace was actually different
# Maybe the validation algorithm works differently

print("\n" + "=" * 60)
print("Re-checking original validation approach:")
print("=" * 60)

# For AARDVARK, reverse is KRAVDRAA
# k-range lookup: find entry in k-range that starts path for "RAVDRAA"
# In k-range, we look for 'r' to start

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
print(f"\nk-range: {k_range}")

# Search for 'r' in k-range
print(f"\nSearching for 'r' in k-range:")
entry = k_range[0]
while entry < k_range[1]:
    sibs = get_siblings(entry)
    if not sibs:
        entry += 1
        continue
    for s in sibs:
        if s['letter'] == 'r':
            print(f"  Found 'r' at {s['entry']}")
    entry += len(sibs)

# It seems 983 is the only 'r' in k-range, and its children don't have the right path

# Let me check simple_trace.py to see how validation actually worked
print("\n" + "=" * 60)
print("Testing validation via DFS (like simple_trace.py):")
print("=" * 60)

def validate_section1(word):
    """Validate word via Section 1 DFS search."""
    reversed_word = word[::-1]
    first_letter = reversed_word[0]
    remaining = list(reversed_word[1:])

    range_start, range_end = letter_ranges.get(first_letter, (0, 0))

    def dfs_find(entry, letters_needed, depth):
        if depth > 20:
            return False
        if not letters_needed:
            # Check if this entry has WORD flag
            node = get_node(entry)
            return node and node['is_word']

        node = get_node(entry)
        if node is None:
            return False

        target = letters_needed[0]
        if node['letter'] != target:
            return False

        child = get_child_entry(node)
        if child is None:
            return len(letters_needed) == 1 and node['is_word']

        # Search children for next letter
        sibs = get_siblings(child)
        for s in sibs:
            if dfs_find(s['entry'], letters_needed[1:], depth + 1):
                return True

        return False

    # Search in the letter range
    entry = range_start
    while entry < range_end:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue
        for s in sibs:
            if dfs_find(s['entry'], remaining, 0):
                return True
        entry += len(sibs)

    return False

# Test
for word in ['aardvark', 'aardvarks', 'aa', 'ab', 'the']:
    result = validate_section1(word)
    print(f"  '{word}': {'FOUND' if result else 'NOT FOUND'}")
