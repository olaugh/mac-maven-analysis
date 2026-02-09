#!/usr/bin/env python3
"""
Simple trace with cycle detection.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

# Parse letter index
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

def get_siblings(start_entry, limit=100):
    siblings = []
    entry = start_entry
    while entry < section1_end and len(siblings) < limit:
        node = get_node(entry)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings

def trace_section1(word, verbose=False):
    """Trace word via Section 1 (reversed storage)."""
    reversed_word = word[::-1]
    first = reversed_word[0]
    remaining = list(reversed_word[1:])

    range_start, range_end = letter_ranges.get(first, (0, 0))
    if range_start == 0:
        return False

    visited = set()
    call_count = [0]
    max_calls = 100000

    def search(entry_start, entry_end, letters, depth):
        call_count[0] += 1
        if call_count[0] > max_calls:
            return False
        if depth > 20:
            return False

        if not letters:
            return True  # Found all letters

        target = letters[0]
        rest = letters[1:]

        entry = entry_start
        while entry < entry_end:
            if entry in visited:
                entry += 1
                continue
            visited.add(entry)

            sibs = get_siblings(entry)
            if not sibs:
                entry += 1
                continue

            for node in sibs:
                if node['letter'] == target:
                    if not rest:
                        # Last letter - check WORD flag
                        if node['is_word']:
                            if verbose:
                                print(f"  Found final '{target}'@{node['entry']} with WORD")
                            return True
                    else:
                        child = get_child_entry(node)
                        if child and child < section1_end:
                            if verbose:
                                print(f"  Found '{target}'@{node['entry']} -> child {child}")
                            if search(child, section1_end, rest, depth + 1):
                                return True

            visited.discard(entry)
            entry += len(sibs)

        return False

    result = search(range_start, range_end, remaining, 0)
    if verbose:
        print(f"  Total calls: {call_count[0]}")
    return result

# Test
test_words = ['aa', 'ab', 'the', 'cat', 'aardvark', 'aardvarks', 'queen', 'qi']
print("Testing Section 1 trace:")
for word in test_words:
    result = trace_section1(word, verbose=True)
    print(f"  '{word}': {'FOUND' if result else 'not found'}\n")
