#!/usr/bin/env python3
"""
Debug which validation method finds AARDVARK.
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

def get_siblings(start_entry, limit=500):
    siblings = []
    entry = start_entry
    while entry < section1_end and len(siblings) < limit:
        node = get_node(entry)
        if node is None or node['letter'] == '?':
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings

def search_section1_verbose(range_start, range_end, remaining, depth=0, path=""):
    """Search Section 1 with verbose output."""
    indent = "  " * depth

    if not remaining:
        return True, path

    target = remaining[0]
    rest = remaining[1:]

    entry = range_start
    while entry < range_end:
        sibs = get_siblings(entry)
        if not sibs:
            break

        for node in sibs:
            if node['letter'] == target:
                new_path = f"{path} -> {target}@{node['entry']}"
                print(f"{indent}Found '{target}' at {node['entry']}")

                if not rest:
                    if node['is_word']:
                        print(f"{indent}  WORD flag set! Path complete: {new_path}")
                        return True, new_path
                    else:
                        print(f"{indent}  No WORD flag at end")
                else:
                    child = get_child_entry(node)
                    print(f"{indent}  Child entry: {child}")
                    if child and child < section1_end:
                        result, final_path = search_section1_verbose(child, section1_end, rest, depth + 1, new_path)
                        if result:
                            return True, final_path

        entry += len(sibs)

    return False, path

def check_section1_verbose(word):
    """Check reversed word in Section 1 with verbose output."""
    reversed_word = word[::-1]
    first = reversed_word[0]

    if first not in letter_ranges:
        return False, ""

    range_start, range_end = letter_ranges[first]
    print(f"\nChecking Section 1 for '{word}' (reversed: '{reversed_word}')")
    print(f"First letter '{first}' range: {range_start} to {range_end}")
    print(f"Looking for remaining letters: {reversed_word[1:]}")

    return search_section1_verbose(range_start, range_end, reversed_word[1:], path=f"[{first}-range]")

# Build Section 2 index
section2_index = {chr(ord('a') + i): [] for i in range(26)}
for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node and 'a' <= node['letter'] <= 'z':
        section2_index[node['letter']].append(entry_idx)

def match_forward_verbose(node, remaining, depth=0, path=""):
    """Match remaining letters by following children with verbose output."""
    indent = "  " * depth

    if not remaining:
        if node['is_word']:
            print(f"{indent}WORD flag set! Path complete: {path}")
            return True, path
        else:
            print(f"{indent}No WORD flag")
            return False, path

    child = get_child_entry(node)
    if not child:
        return False, path

    target = remaining[0]
    rest = remaining[1:]

    sibs = get_siblings(child)
    for s in sibs:
        if s['letter'] == target:
            new_path = f"{path} -> {target}@{s['entry']}"
            print(f"{indent}Found '{target}' at {s['entry']}")

            if not rest:
                if s['is_word']:
                    print(f"{indent}  WORD flag set! Path complete: {new_path}")
                    return True, new_path
                else:
                    print(f"{indent}  No WORD flag")
            else:
                result, final_path = match_forward_verbose(s, rest, depth + 1, new_path)
                if result:
                    return True, final_path

    return False, path

def check_section2_verbose(word):
    """Check forward word starting from Section 2 with verbose output."""
    first = word[0]

    print(f"\nChecking Section 2 for '{word}'")
    print(f"Trying {len(section2_index.get(first, []))} '{first}' entries in Section 2...")

    count = 0
    for entry_idx in section2_index.get(first, []):
        node = get_node(entry_idx)
        if not node:
            continue

        count += 1
        if count > 50:
            print("  (stopped after 50 entries)")
            break

        # Try this entry
        result, path = match_forward_verbose(node, word[1:], path=f"S2:{first}@{entry_idx}")
        if result:
            return True, path

    return False, ""

# Test AARDVARK
print("=" * 70)
print("Testing AARDVARK validation:")
print("=" * 70)

result1, path1 = check_section1_verbose('aardvark')
print(f"\nSection 1 result: {'FOUND' if result1 else 'NOT FOUND'}")

result2, path2 = check_section2_verbose('aardvark')
print(f"\nSection 2 result: {'FOUND' if result2 else 'NOT FOUND'}")

# Test AARDVARKS
print("\n" + "=" * 70)
print("Testing AARDVARKS validation:")
print("=" * 70)

result1s, path1s = check_section1_verbose('aardvarks')
print(f"\nSection 1 result: {'FOUND' if result1s else 'NOT FOUND'}")

result2s, path2s = check_section2_verbose('aardvarks')
print(f"\nSection 2 result: {'FOUND' if result2s else 'NOT FOUND'}")
