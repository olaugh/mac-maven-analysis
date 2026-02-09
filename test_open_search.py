#!/usr/bin/env python3
"""
Test if DAWG search is meant to search from child entry to section1_end
(not just within sibling groups).
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

# Build letter index for Section 1
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

def search_open_range(range_start, range_end, remaining, depth=0, verbose=False, path=""):
    """Search from range_start to range_end, NOT limited to sibling groups."""
    indent = "  " * depth

    if not remaining:
        return True, path

    target = remaining[0]
    rest = remaining[1:]

    # Search ALL entries from range_start to range_end
    for entry in range(range_start, range_end):
        node = get_node(entry)
        if node is None:
            continue

        if node['letter'] == target:
            new_path = f"{path} -> {target}@{entry}"
            if verbose:
                print(f"{indent}Found '{target}' at {entry}")

            if not rest:
                if node['is_word']:
                    if verbose:
                        print(f"{indent}  WORD flag set!")
                    return True, new_path
            else:
                child = get_child_entry(node)
                if verbose:
                    print(f"{indent}  Child entry: {child}")
                if child:
                    # Search from child to section1_end
                    result, final_path = search_open_range(child, section1_end, rest, depth + 1, verbose, new_path)
                    if result:
                        return True, final_path

    return False, path

def check_section1_open(word, verbose=False):
    """Check reversed word in Section 1 with open-range search."""
    reversed_word = word[::-1]
    first = reversed_word[0]

    if first not in letter_ranges:
        return False, ""

    range_start, range_end = letter_ranges[first]
    if verbose:
        print(f"\nChecking Section 1 for '{word}' (reversed: '{reversed_word}')")
        print(f"First letter '{first}' range: {range_start} to {range_end}")

    return search_open_range(range_start, range_end, reversed_word[1:], verbose=verbose, path=f"[{first}-range]")

# Test words with open-range search
test_words = ['aa', 'ab', 'ad', 'the', 'cat', 'aardvark', 'aardvarks', 'queen', 'queens']

print("Testing with OPEN-RANGE search (from child to section1_end):")
print("=" * 60)

for word in test_words:
    result, path = check_section1_open(word)
    status = "FOUND" if result else "NOT FOUND"
    print(f"  '{word}': {status}")

# Now test more words to see if this gives sensible results
print("\n" + "=" * 60)
print("Testing common words:")
print("=" * 60)

common_words = ['dog', 'cat', 'bat', 'rat', 'mat', 'sat', 'hat', 'fat',
                'book', 'cook', 'look', 'hook', 'took', 'nook',
                'tree', 'free', 'flee', 'knee', 'glee', 'thee',
                'word', 'lord', 'ford', 'cord', 'herd', 'bird']

found_count = 0
not_found = []
for word in common_words:
    result, path = check_section1_open(word)
    if result:
        found_count += 1
    else:
        not_found.append(word)

print(f"Found: {found_count}/{len(common_words)}")
print(f"Not found: {not_found}")

# Let's enumerate some words from k-range to see what we get
print("\n" + "=" * 60)
print("Enumerating words from k-range using open search:")
print("=" * 60)

def enumerate_open(range_start, range_end, ending_letter, max_words=100, max_depth=12):
    """Enumerate words by DFS with open-range search."""
    words = []

    def dfs(entry_start, entry_end, path, depth):
        if depth > max_depth or len(words) >= max_words:
            return

        for entry in range(entry_start, min(entry_end, entry_start + 100)):  # Limit scan
            node = get_node(entry)
            if node is None:
                continue

            new_path = path + node['letter']

            if node['is_word']:
                # Reverse and add ending letter
                word = new_path[::-1] + ending_letter
                words.append(word)
                if len(words) >= max_words:
                    return

            child = get_child_entry(node)
            if child:
                dfs(child, section1_end, new_path, depth + 1)

    dfs(range_start, range_end, '', 0)
    return words

k_range = letter_ranges['k']
k_words = enumerate_open(k_range[0], k_range[1], 'k', max_words=50)
print(f"Words ending in 'k': {len(k_words)}")
for w in sorted(k_words)[:20]:
    print(f"  {w}")

if 'aardvark' in k_words:
    print("\nAARDVARK FOUND in enumeration!")
else:
    print("\nAARDVARK not in enumeration")
