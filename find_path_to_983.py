#!/usr/bin/env python3
"""
Find Section 2 entries that can reach entry 983 (start of AARDVARK path).
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]

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

# The AARDVARK path in Section 1 starts at entry 983 (letter 'r')
# Full path: r@983 -> a@103 -> v@30 -> d@175 -> r@73 -> a@36 -> a@103

# Entry 983 is in Section 1. Let me find what entries point TO it.
# child = ptr + (flags & 0x7e)
# So we need: entry where ptr + (flags & 0x7e) lands in the sibling group containing 983

# First, find what sibling group entry 983 is in
print("Finding sibling group containing entry 983...")
sib_start = None
for check in range(980, 984):
    sibs = get_siblings(check)
    for s in sibs:
        if s['entry'] == 983:
            sib_start = check
            print(f"  Entry 983 is in sibling group starting at {check}")
            print(f"  Siblings: {[(s['letter'], s['entry']) for s in sibs]}")
            break
    if sib_start:
        break

# Now find entries where child points to this sibling group
print(f"\nFinding entries whose children include the 983 sibling group...")
pointing_to_983_area = []
for entry_idx in range(section2_end):  # Search all sections
    node = get_node(entry_idx)
    if node:
        child = get_child_entry(node)
        if child and sib_start and child <= 983 < child + 26:  # rough check
            sibs = get_siblings(child)
            if any(s['entry'] == 983 for s in sibs):
                pointing_to_983_area.append((entry_idx, node['letter'], child))

print(f"Found {len(pointing_to_983_area)} entries pointing to 983's sibling group:")
for entry, letter, child in pointing_to_983_area[:20]:
    section = "S1" if entry < section1_end else "S2"
    print(f"  {section} entry {entry} ('{letter}') -> child {child}")

# Now trace backwards from 983 to find all paths
print("\n" + "=" * 60)
print("Tracing backwards from entry 983...")

# Build reverse map: for each entry, find what entries point to its sibling group
print("Building reverse pointer map...")

reverse_map = {}  # entry -> list of (parent_entry, parent_letter)

for entry_idx in range(section2_end):
    node = get_node(entry_idx)
    if node:
        child = get_child_entry(node)
        if child:
            sibs = get_siblings(child)
            for s in sibs:
                if s['entry'] not in reverse_map:
                    reverse_map[s['entry']] = []
                reverse_map[s['entry']].append((entry_idx, node['letter']))

# Trace backwards from 983
def trace_back(entry, path, depth=0):
    if depth > 10:
        return []

    results = []
    parents = reverse_map.get(entry, [])

    for parent_entry, parent_letter in parents:
        new_path = [(parent_entry, parent_letter)] + path

        if parent_entry >= section1_end:  # In Section 2 or 3
            results.append(new_path)

        # Continue backwards
        results.extend(trace_back(parent_entry, new_path, depth + 1))

    return results

print("Tracing back from r@983...")
paths = trace_back(983, [])
print(f"Found {len(paths)} paths reaching 983 from Section 2/3")

if paths:
    print("\nSample paths:")
    for path in paths[:10]:
        # Reconstruct forward word
        word = ''.join([letter for entry, letter in path])
        print(f"  {path[0][0]}: {''.join([l for e,l in path])} -> r@983")

# Check what word would be formed
# AARDVARK reversed = KRAVDRAA
# So 983 is the 'r' after 'k'
# If we reach 983 via some path, we add 'r' then continue to the rest
print("\n" + "=" * 60)
print("What word could reach 983 as 'r'?")

# The entry at 983 has letter 'r'. In KRAVDRAA:
# K (implied by k-range start) -> R@983 -> A@103 -> V@30 -> ...
# But for forward search, we'd need to reach 983 to get 'r' as a letter

# Let me check what letter would PRECEDE 'r' in a forward search
# that eventually spells AARDVARK
print("\nFor AARDVARK spelled forward (a-a-r-d-v-a-r-k):")
print("  We need entry for 'a' -> child -> 'a' -> child -> 'r'")
print("  The 'r' after 'aa' must be at entry 983? Let's check...")

# No wait, entry 983 is 'r' in the k-range. In the reversed storage,
# it represents the 2nd letter of AARDVARK (reading reversed).
#
# For forward enumeration from Section 2:
# - Section 2 'a' entry has child pointing to Section 1
# - That child area has letters for position 2 of words starting with 'a'
# - For AARDVARK, position 2 is 'a', position 3 is 'r', etc.

# Let me check entry 103 (which is 'a' in the AARDVARK path)
print("\nChecking entry 103 (second 'a' in AARDVARK reversed path):")
node_103 = get_node(103)
print(f"  Entry 103: {node_103}")

# Find what points to 103's sibling group
print("\nFinding entries that point to 103's sibling group...")
sib_103 = None
for check in range(100, 105):
    sibs = get_siblings(check)
    for s in sibs:
        if s['entry'] == 103:
            sib_103 = check
            print(f"  Entry 103 in sibling group starting at {check}")
            print(f"  Siblings: {[(s['letter'], s['entry']) for s in sibs]}")
            break

if sib_103:
    parents_of_103 = reverse_map.get(103, [])
    print(f"  Entries pointing to 103: {parents_of_103[:20]}")
