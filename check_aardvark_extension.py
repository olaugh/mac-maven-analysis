#!/usr/bin/env python3
"""
Check if AARDVARK can extend to AARDVARKS.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

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
    while entry < section1_end and len(siblings) < limit:
        node = get_node(entry)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings

# The AARDVARK path ends at entry 103 with letter 'a' and is_word=True
# Path: k range -> r@983 -> a@103 -> v@30 -> d@175 -> r@73 -> a@36 -> a@103

print("Checking AARDVARK final node (a@103):")
node_103 = get_node(103)
print(f"  Node 103: {node_103}")

# Check if node 103 has an 's' child that would make AARDVARKS
child = get_child_entry(node_103)
print(f"  Child entry: {child}")

if child:
    sibs = get_siblings(child)
    print(f"  Child siblings: {[(s['letter'], s['entry'], s['is_word']) for s in sibs]}")

    for s in sibs:
        if s['letter'] == 's':
            print(f"\n  *** Found 's' child! Entry {s['entry']}, is_word={s['is_word']}")
            if s['is_word']:
                print(f"  *** This would make AARDVARKS valid via Section 1!")

# But wait - the Section 1 lookup goes in reverse order
# For AARDVARKS reversed = SKRAVDRAA
# We need to start from 's' range and find 'k'
# Let me check the 's' range for 'k'

print("\n" + "=" * 60)
print("Checking 's' range for SKRAVDRAA path:")

# Parse letter index
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

s_range = letter_ranges['s']
print(f"  's' range: {s_range[0]} to {s_range[1]}")

# Check for 'k' in 's' range
k_in_s = []
for entry_idx in range(s_range[0], s_range[1]):
    node = get_node(entry_idx)
    if node and node['letter'] == 'k':
        k_in_s.append(node)
        print(f"  Found 'k'@{node['entry']}")

if not k_in_s:
    print("  No 'k' entries in 's' range!")
    print("  SKRAVDRAA cannot be found via Section 1 's' range starting point")

# So the issue is:
# - AARDVARK (KRAVDRAA reversed) finds 'r' in 'k' range and traces successfully
# - AARDVARKS (SKRAVDRAA reversed) needs 'k' in 's' range, which doesn't exist

# Let me check if there's a different mechanism for plurals
# Maybe Section 2 handles words ending in 's' differently?

print("\n" + "=" * 60)
print("Checking Section 2 for AARDVARKS:")

section2_end = struct.unpack('>I', data[4:8])[0]

# Find 'a' entries in Section 2 that might lead to AARDVARKS
a_entries = []
for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'a':
        a_entries.append(node)

print(f"  Found {len(a_entries)} 'a' entries in Section 2")

# Try to trace a-a-r-d-v-a-r-k-s from Section 2
def trace_from_section2(word):
    remaining = list(word[1:])
    for start_node in a_entries:
        child = get_child_entry(start_node)
        if not child:
            continue

        current = child
        path = [word[0]]
        success = True

        for target in remaining:
            sibs = get_siblings(current)
            found = None
            for s in sibs:
                if s['letter'] == target:
                    found = s
                    break

            if not found:
                success = False
                break

            path.append(target)

            if len(path) == len(word):
                # Last letter - check word flag
                if found['is_word']:
                    return start_node['entry'], path
                success = False
                break

            child = get_child_entry(found)
            if not child:
                success = False
                break
            current = child

    return None, None

entry, path = trace_from_section2('aardvarks')
if entry:
    print(f"  AARDVARKS found via Section 2 entry {entry}!")
    print(f"  Path: {path}")
else:
    print("  AARDVARKS NOT found in Section 2 either")

# Also check AARDVARK via Section 2
entry2, path2 = trace_from_section2('aardvark')
if entry2:
    print(f"\n  AARDVARK found via Section 2 entry {entry2}")
else:
    print("\n  AARDVARK NOT found in Section 2")
