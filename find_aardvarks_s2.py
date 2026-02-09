#!/usr/bin/env python3
"""
Search ALL Section 2 'a' entries for AARDVARK and AARDVARKS.
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

def search_word_from_entry(start_entry, word):
    """Search for a specific word starting from a Section 2 entry."""
    node = get_node(start_entry)
    if node is None or node['letter'] != word[0]:
        return False, []

    path = [(start_entry, word[0])]
    remaining = word[1:]
    current = start_entry

    for target in remaining:
        node = get_node(current)
        if node is None:
            return False, path

        child = get_child_entry(node)
        if child is None:
            return False, path

        sibs = get_siblings(child)
        found = None
        for s in sibs:
            if s['letter'] == target:
                found = s
                break

        if found is None:
            return False, path

        path.append((found['entry'], target))
        current = found['entry']

    # Check if final letter has WORD flag
    final_node = get_node(current)
    if final_node and final_node['is_word']:
        return True, path
    return False, path

# Get all 'a' entries in Section 2
a_entries = []
for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'a':
        a_entries.append(entry_idx)

print(f"Searching {len(a_entries)} 'a' entries in Section 2...")

# Search for AARDVARK and AARDVARKS
for word in ['aardvark', 'aardvarks']:
    print(f"\nSearching for '{word}':")
    found_count = 0
    for entry in a_entries:
        success, path = search_word_from_entry(entry, word)
        if success:
            print(f"  FOUND at entry {entry}!")
            print(f"  Path: {path}")
            found_count += 1
            if found_count >= 3:
                break

    if found_count == 0:
        # Show partial paths that got furthest
        best_path = []
        best_entry = None
        for entry in a_entries[:1000]:
            success, path = search_word_from_entry(entry, word)
            if len(path) > len(best_path):
                best_path = path
                best_entry = entry

        if best_path:
            print(f"  Not found. Best partial path ({len(best_path)}/{len(word)} letters):")
            print(f"  Entry {best_entry}: {best_path}")
            # Check why it stopped
            if len(best_path) < len(word):
                last_entry = best_path[-1][0]
                node = get_node(last_entry)
                if node:
                    child = get_child_entry(node)
                    if child:
                        sibs = get_siblings(child)
                        print(f"  Available next letters: {[s['letter'] for s in sibs]}")
                        print(f"  Needed: '{word[len(best_path)]}'")

# Also search Section 3
print("\n" + "=" * 60)
print("Searching Section 3...")

section3_end = struct.unpack('>I', data[8:12])[0]
a_entries_s3 = []
for entry_idx in range(section2_end, section3_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'a':
        a_entries_s3.append(entry_idx)

print(f"Searching {len(a_entries_s3)} 'a' entries in Section 3...")

for word in ['aardvark', 'aardvarks']:
    print(f"\nSearching for '{word}':")
    found_count = 0
    for entry in a_entries_s3:
        success, path = search_word_from_entry(entry, word)
        if success:
            print(f"  FOUND at entry {entry}!")
            print(f"  Path: {path}")
            found_count += 1
            if found_count >= 3:
                break

    if found_count == 0:
        print(f"  Not found in Section 3")
