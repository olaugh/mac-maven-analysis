#!/usr/bin/env python3
"""
Trace the exact path for AARDVARK with backtracking.
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

def find_all(range_start, target_letter, limit=50):
    """Find all entries with target letter from range_start."""
    results = []
    for entry in range(range_start, min(range_start + 10000, section1_end)):
        node = get_node(entry)
        if node and node['letter'] == target_letter:
            results.append((entry, node))
            if len(results) >= limit:
                break
    return results

def trace_with_backtracking(word):
    """Trace word with backtracking to find all valid paths."""
    reversed_word = word[::-1]
    ending_letter = reversed_word[0]
    remaining = reversed_word[1:]

    range_start, range_end = letter_ranges.get(ending_letter, (0, 0))
    if range_start == 0:
        return []

    paths = []

    def dfs(search_start, letters_left, path):
        if not letters_left:
            # Check if last node has WORD flag
            last_entry = path[-1][0]
            last_node = get_node(last_entry)
            if last_node and last_node['is_word']:
                paths.append(list(path))
            return

        target = letters_left[0]
        rest = letters_left[1:]

        # Find all matches for target
        matches = find_all(search_start, target, limit=20)
        for entry, node in matches:
            path.append((entry, target, node['is_word']))
            child = get_child_entry(node)
            if child:
                dfs(child, rest, path)
            elif not rest:
                # Last letter, check WORD flag
                if node['is_word']:
                    paths.append(list(path))
            path.pop()

    # Start from entries in the ending letter's range
    first_letter = remaining[0] if remaining else None
    if first_letter:
        first_matches = find_all(range_start, first_letter, limit=50)
        for entry, node in first_matches:
            path = [(entry, first_letter, node['is_word'])]
            child = get_child_entry(node)
            if child:
                dfs(child, remaining[1:], path)
            elif len(remaining) == 1:
                if node['is_word']:
                    paths.append(list(path))

    return paths

# Trace AARDVARK
print("Tracing AARDVARK:")
print("=" * 60)
paths = trace_with_backtracking('aardvark')
print(f"Found {len(paths)} valid paths")
for i, path in enumerate(paths[:5]):
    print(f"\nPath {i+1}:")
    for entry, letter, is_word in path:
        print(f"  {letter}@{entry} {'WORD' if is_word else ''}")

# Trace AARDVARKS
print("\n" + "=" * 60)
print("Tracing AARDVARKS:")
print("=" * 60)
paths = trace_with_backtracking('aardvarks')
print(f"Found {len(paths)} valid paths")
if paths:
    for i, path in enumerate(paths[:5]):
        print(f"\nPath {i+1}:")
        for entry, letter, is_word in path:
            print(f"  {letter}@{entry} {'WORD' if is_word else ''}")
else:
    # Show why it fails
    s_range = letter_ranges['s']
    print(f"\ns-range: {s_range[0]} to {s_range[1]}")
    print("Looking for 'k' in s-range:")
    k_matches = find_all(s_range[0], 'k', limit=10)
    if k_matches:
        print(f"  Found 'k' entries: {[e for e, n in k_matches]}")
    else:
        print("  NO 'k' found in s-range")
        print("  This is why AARDVARKS cannot be found via Section 1")

# Test a few more words
print("\n" + "=" * 60)
print("Testing more words:")
for word in ['aa', 'the', 'queen', 'queens', 'book']:
    paths = trace_with_backtracking(word)
    if paths:
        print(f"  '{word}': FOUND ({len(paths)} paths)")
    else:
        print(f"  '{word}': NOT FOUND")
