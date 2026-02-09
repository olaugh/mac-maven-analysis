#!/usr/bin/env python3
"""
Enumerate by scanning consecutive sibling groups from child position.
"""

import struct
from collections import defaultdict

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

def get_sibling_group(start_entry):
    """Get one sibling group starting at entry."""
    siblings = []
    entry = start_entry
    while entry < section1_end:
        node = get_node(entry)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings

def scan_groups_from(start_entry, max_groups=50):
    """Scan consecutive sibling groups starting from entry."""
    all_nodes = []
    entry = start_entry
    groups_seen = 0

    while entry < section1_end and groups_seen < max_groups:
        group = get_sibling_group(entry)
        if not group:
            break
        all_nodes.extend(group)
        groups_seen += 1
        entry += len(group)

    return all_nodes

def enumerate_ending_in(ending_letter, max_words=10000, max_depth=12, max_scan_groups=20):
    """Enumerate words by scanning multiple sibling groups."""
    words = []
    range_start, range_end = letter_ranges[ending_letter]

    seen_paths = set()

    def dfs(search_start, path, depth):
        if depth > max_depth or len(words) >= max_words:
            return

        # Scan groups from search_start
        candidates = scan_groups_from(search_start, max_groups=max_scan_groups)

        for node in candidates:
            new_path = path + node['letter']
            path_key = new_path

            if path_key in seen_paths:
                continue
            seen_paths.add(path_key)

            if node['is_word']:
                word = new_path[::-1] + ending_letter
                if len(word) >= 2:
                    words.append(word)

            child = get_child_entry(node)
            if child and depth < max_depth:
                dfs(child, new_path, depth + 1)

    # Start from the letter range
    dfs(range_start, '', 0)
    return words

# Test
print("Testing group-based enumeration:")
print("=" * 60)

# Small test first
for ending in ['k']:
    print(f"\nEnumerating words ending in '{ending}'...")
    words = enumerate_ending_in(ending, max_words=500, max_depth=10, max_scan_groups=10)
    print(f"  Found {len(words)} words")

    if 'aardvark' in words:
        print("  AARDVARK FOUND!")
    else:
        # Show what 8-letter words we found
        eight_letter = [w for w in words if len(w) == 8]
        print(f"  8-letter words: {eight_letter[:20]}")

    # Show length distribution
    by_len = defaultdict(int)
    for w in words:
        by_len[len(w)] += 1
    print(f"  By length: {dict(sorted(by_len.items()))}")

    # Show samples by length
    for length in [2, 3, 4, 5]:
        sample = [w for w in words if len(w) == length][:5]
        if sample:
            print(f"  {length}-letter: {sample}")

# Now check if our validation logic works
print("\n" + "=" * 60)
print("Verification using open-range search (known working):")
print("=" * 60)

def validate_word(word):
    """Validate using open-range search from child to section1_end."""
    reversed_word = word[::-1]
    first = reversed_word[0]
    remaining = reversed_word[1:]

    range_start, range_end = letter_ranges.get(first, (0, 0))

    def search(search_start, letters_left):
        if not letters_left:
            return True

        target = letters_left[0]
        rest = letters_left[1:]

        for entry in range(search_start, section1_end):
            node = get_node(entry)
            if node and node['letter'] == target:
                if not rest:
                    if node['is_word']:
                        return True
                else:
                    child = get_child_entry(node)
                    if child and search(child, rest):
                        return True
        return False

    return search(range_start, remaining)

test_words = ['aa', 'ab', 'the', 'cat', 'aardvark', 'aardvarks', 'queen', 'queens']
for word in test_words:
    result = validate_word(word)
    print(f"  '{word}': {'VALID' if result else 'INVALID'}")
