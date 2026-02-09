#!/usr/bin/env python3
"""
Search for AARDVARK via Section 2 (forward lookup).
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]

print(f"Section 1 ends at: {section1_end}")
print(f"Section 2 ends at: {section2_end}")
print(f"Section 2 range: {section1_end} to {section2_end}")

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

# Find all 'a' entries in Section 2
print("\nFinding 'a' entries in Section 2...")
a_entries_s2 = []
for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'a':
        a_entries_s2.append(entry_idx)

print(f"Found {len(a_entries_s2)} 'a' entries in Section 2")

# For each 'a' entry, try to trace AARDVARK (a-a-r-d-v-a-r-k)
def trace_word(start_entry, word):
    """Trace a word from a starting entry."""
    node = get_node(start_entry)
    if not node or node['letter'] != word[0]:
        return None, []

    path = [(start_entry, word[0])]
    current = start_entry

    for target in word[1:]:
        node = get_node(current)
        if not node:
            return None, path

        child = get_child_entry(node)
        if not child:
            return None, path

        sibs = get_siblings(child)
        found = None
        for s in sibs:
            if s['letter'] == target:
                found = s
                break

        if not found:
            return None, path

        path.append((found['entry'], target))
        current = found['entry']

    # Check WORD flag
    final = get_node(current)
    if final and final['is_word']:
        return True, path
    return False, path

# Search for AARDVARK
print("\n" + "=" * 60)
print("Searching for AARDVARK via Section 2 'a' entries:")
print("=" * 60)

found_aardvark = False
best_path = []

for a_entry in a_entries_s2:
    result, path = trace_word(a_entry, 'aardvark')
    if result:
        print(f"FOUND AARDVARK at entry {a_entry}!")
        print(f"  Path: {path}")
        found_aardvark = True
        break
    elif len(path) > len(best_path):
        best_path = path
        best_entry = a_entry

if not found_aardvark:
    print("AARDVARK not found in Section 2")
    if best_path:
        print(f"Best partial path ({len(best_path)}/8 letters) from entry {best_entry}:")
        print(f"  {best_path}")

        # Show what's available at the failure point
        last_entry = best_path[-1][0]
        node = get_node(last_entry)
        child = get_child_entry(node)
        if child:
            sibs = get_siblings(child)
            needed = 'aardvark'[len(best_path)]
            print(f"  Needed: '{needed}'")
            print(f"  Available: {[s['letter'] for s in sibs]}")

# Search for AARDVARKS
print("\n" + "=" * 60)
print("Searching for AARDVARKS via Section 2 'a' entries:")
print("=" * 60)

found_aardvarks = False
best_path_s = []

for a_entry in a_entries_s2:
    result, path = trace_word(a_entry, 'aardvarks')
    if result:
        print(f"FOUND AARDVARKS at entry {a_entry}!")
        print(f"  Path: {path}")
        found_aardvarks = True
        break
    elif len(path) > len(best_path_s):
        best_path_s = path
        best_entry_s = a_entry

if not found_aardvarks:
    print("AARDVARKS not found in Section 2")
    if best_path_s:
        print(f"Best partial path ({len(best_path_s)}/9 letters) from entry {best_entry_s}:")
        print(f"  {best_path_s}")

# Test some simple words to verify Section 2 works
print("\n" + "=" * 60)
print("Testing simple words via Section 2:")
print("=" * 60)

for word in ['aa', 'ab', 'ad', 'ax']:
    for a_entry in a_entries_s2[:100]:
        result, path = trace_word(a_entry, word)
        if result:
            print(f"  '{word}': FOUND at entry {a_entry}, path={path}")
            break
    else:
        print(f"  '{word}': NOT FOUND")

# Look at a specific Section 2 'a' entry and its structure
print("\n" + "=" * 60)
print("Examining first few Section 2 'a' entries:")
print("=" * 60)

for a_entry in a_entries_s2[:5]:
    node = get_node(a_entry)
    child = get_child_entry(node)
    print(f"\nEntry {a_entry} ('{node['letter']}'): ptr={node['ptr']} child={child} {'WORD' if node['is_word'] else ''}")

    if child:
        sibs = get_siblings(child)
        print(f"  Children: {[(s['letter'], s['entry'], 'WORD' if s['is_word'] else '') for s in sibs]}")

        # Look for 'a' child (for words starting with 'aa')
        aa_entries = [s for s in sibs if s['letter'] == 'a']
        for aa in aa_entries:
            aa_child = get_child_entry(aa)
            if aa_child:
                aa_sibs = get_siblings(aa_child)
                print(f"    'a' child at {aa['entry']}, its children: {[(s['letter'], s['entry']) for s in aa_sibs[:10]]}")
