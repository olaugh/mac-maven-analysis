#!/usr/bin/env python3
"""
Properly enumerate words using the validation approach that works.

The approach:
1. For each ending letter (a-z), enumerate from its Section 1 range
2. Collect letter paths by DFS
3. Reverse the paths and prepend the ending letter
4. Filter to only paths where final node has WORD flag
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
section2_end = struct.unpack('>I', data[4:8])[0]

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

def enumerate_words_ending_in(ending_letter, max_words=50000, max_depth=15):
    """Enumerate words ending in the given letter using open-range search."""
    words = []
    range_start, range_end = letter_ranges[ending_letter]

    visited_global = set()  # Track visited paths to avoid duplicates

    def dfs(search_start, path, depth):
        if depth > max_depth or len(words) >= max_words:
            return

        # Scan from search_start towards section1_end
        for entry in range(search_start, min(search_start + 5000, section1_end)):
            node = get_node(entry)
            if node is None:
                continue

            # Build new path
            new_path = path + node['letter']
            path_key = (search_start, new_path)

            if path_key in visited_global:
                continue
            visited_global.add(path_key)

            # If WORD flag, this is a valid word
            if node['is_word']:
                # Reverse path and append ending letter
                word = new_path[::-1] + ending_letter
                if len(word) >= 2:
                    words.append(word)
                    if len(words) >= max_words:
                        return

            # Continue to children
            child = get_child_entry(node)
            if child:
                dfs(child, new_path, depth + 1)

    # Start from the letter range
    dfs(range_start, '', 0)
    return words

# Test with a few letters
print("Testing word enumeration:")
print("=" * 60)

for ending in ['a', 'd', 'e', 'k', 's', 't']:
    print(f"\nEnumerating words ending in '{ending}'...")
    words = enumerate_words_ending_in(ending, max_words=5000)
    print(f"  Found {len(words)} words")

    # Check some known words
    if ending == 'k':
        aardvark = 'aardvark' in words
        print(f"  'aardvark' in words: {aardvark}")
    elif ending == 's':
        aardvarks = 'aardvarks' in words
        print(f"  'aardvarks' in words: {aardvarks}")
        if not aardvarks:
            # Check what words we got starting with 'a'
            a_words = [w for w in words if w.startswith('a')][:20]
            print(f"  Sample 'a' words: {a_words}")

    # Show length distribution
    by_len = defaultdict(int)
    for w in words:
        by_len[len(w)] += 1
    print(f"  By length: {dict(sorted(by_len.items())[:8])}")

    # Show samples
    sample = sorted(words)[:10]
    print(f"  First 10: {sample}")
