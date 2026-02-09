#!/usr/bin/env python3
"""
Correct validation using proper sibling group boundaries.
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

def get_sibling_group(start_entry, limit=500):
    """Get ONLY the sibling group - stop at LAST flag."""
    siblings = []
    entry = start_entry

    while len(siblings) < limit:
        node = get_node(entry)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:  # STOP at LAST flag
            break
        entry += 1

    return siblings

def search_section1_correct(range_start, range_end, remaining, depth=0, verbose=False, path=""):
    """Search Section 1 with CORRECT sibling group handling."""
    indent = "  " * depth

    if not remaining:
        return True, path

    target = remaining[0]
    rest = remaining[1:]

    entry = range_start
    while entry < range_end:
        sibs = get_sibling_group(entry)
        if not sibs:
            entry += 1
            continue

        for node in sibs:
            if node['letter'] == target:
                new_path = f"{path} -> {target}@{node['entry']}"
                if verbose:
                    print(f"{indent}Found '{target}' at {node['entry']}")

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
                        # CORRECT: Only search within the sibling group at child
                        child_sibs = get_sibling_group(child)
                        if verbose:
                            print(f"{indent}  Child sibling group: {[(s['letter'], s['entry']) for s in child_sibs]}")

                        # Search ONLY within this sibling group
                        for cs in child_sibs:
                            if cs['letter'] == rest[0]:
                                if len(rest) == 1:
                                    if cs['is_word']:
                                        if verbose:
                                            print(f"{indent}    Found '{rest[0]}' at {cs['entry']} with WORD flag!")
                                        return True, f"{new_path} -> {rest[0]}@{cs['entry']}"
                                else:
                                    # Recurse for remaining letters
                                    cc = get_child_entry(cs)
                                    if cc:
                                        result, final_path = search_section1_correct(
                                            cc, cc + 500, rest[1:], depth + 2, verbose,
                                            f"{new_path} -> {rest[0]}@{cs['entry']}"
                                        )
                                        if result:
                                            return True, final_path

        entry += len(sibs)

    return False, path

def check_section1_correct(word, verbose=False):
    """Check reversed word in Section 1 with CORRECT sibling handling."""
    reversed_word = word[::-1]
    first = reversed_word[0]

    if first not in letter_ranges:
        return False, ""

    range_start, range_end = letter_ranges[first]
    if verbose:
        print(f"\nChecking Section 1 for '{word}' (reversed: '{reversed_word}')")
        print(f"First letter '{first}' range: {range_start} to {range_end}")

    return search_section1_correct(range_start, range_end, reversed_word[1:], verbose=verbose, path=f"[{first}-range]")

# Test words
test_words = ['aa', 'ab', 'ad', 'the', 'cat', 'aardvark', 'aardvarks', 'queen', 'queens']

print("Testing with CORRECT sibling group handling:")
print("=" * 60)

for word in test_words:
    result, path = check_section1_correct(word)
    status = "FOUND" if result else "NOT FOUND"
    print(f"  '{word}': {status}")

# Verbose test for AARDVARK
print("\n" + "=" * 60)
print("Verbose trace for AARDVARK:")
print("=" * 60)
check_section1_correct('aardvark', verbose=True)

# Verbose test for AA
print("\n" + "=" * 60)
print("Verbose trace for AA:")
print("=" * 60)
check_section1_correct('aa', verbose=True)
