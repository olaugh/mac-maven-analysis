#!/usr/bin/env python3
"""Quick test: enumerate words ending in 'a' only."""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

# Letter index
LETTER_INDEX_OFFSET = 0x10
letter_index = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1 = data[offset:offset+2]
    letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

# Get 'a' range
a_start = letter_index['a']
a_end = letter_index['b']
print(f"'a' range: entries {a_start} to {a_end-1}")


def get_node(entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    return {
        'entry': entry_idx,
        'letter': chr(letter),
        'is_word': bool(flags & FLAG_WORD),
        'is_last': bool(flags & FLAG_LAST),
        'child': ptr + (flags & 0x7e) if ptr else 0,
    }


def enumerate_from_entry(entry_idx, path, ending, max_depth, words, visited):
    if max_depth <= 0 or entry_idx in visited:
        return
    visited.add(entry_idx)

    while entry_idx < section1_end:
        node = get_node(entry_idx)
        if node is None:
            break

        new_path = path + node['letter']

        if node['is_word']:
            word = new_path[::-1] + ending
            if len(word) >= 2:
                words.add(word)
                if len(words) % 1000 == 0:
                    print(f"  Found {len(words)} words...")
                if len(words) >= 50000:
                    return

        if node['child'] > 0 and max_depth > 1:
            enumerate_from_entry(node['child'], new_path, ending, max_depth - 1, words, visited.copy())

        if node['is_last']:
            break
        entry_idx += 1


words = set()
visited = set()
entry = a_start

print("Enumerating words ending in 'a'...")
while entry < a_end and len(words) < 50000:
    enumerate_from_entry(entry, "", "a", 15, words, visited.copy())

    # Move to next sibling group
    node = get_node(entry)
    while entry < a_end:
        n = get_node(entry)
        if n is None or n['is_last']:
            entry += 1
            break
        entry += 1

print(f"\nFound {len(words)} words ending in 'a'")

# Show 2-letter words
two = sorted([w for w in words if len(w) == 2])
print(f"\n2-letter words ending in 'a': {two}")

# Check known words
expected_a = ['aa', 'ba', 'da', 'ea', 'fa', 'ga', 'ha', 'ja', 'ka', 'la', 'ma',
              'na', 'pa', 'ta', 'ya', 'za']  # A subset
found_expected = [w for w in expected_a if w in words]
missing_expected = [w for w in expected_a if w not in words]
print(f"\nExpected found: {found_expected}")
print(f"Expected missing: {missing_expected}")
