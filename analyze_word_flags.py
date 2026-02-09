#!/usr/bin/env python3
"""
Analyze what WORD flags mean in different sections.
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

# Load reference words for comparison
reference_words = set()
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt') as f:
        for line in f:
            reference_words.add(line.strip().lower())
except:
    pass

print(f"Loaded {len(reference_words)} reference words")

# Check 2-letter words that should have WORD flags
print("\n" + "=" * 60)
print("Checking 2-letter word flags:")
print("=" * 60)

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

# For each ending letter, find entries with WORD flag in first position
print("\nSection 1 two-letter word patterns (ending letter -> second-to-last with WORD):")
for ending in letters:
    range_start, range_end = letter_ranges[ending]
    word_entries = []

    for entry in range(range_start, min(range_start + 200, range_end)):
        node = get_node(entry)
        if node and node['is_word']:
            word_entries.append(node['letter'])

    if word_entries:
        # These are second-to-last letters for words ending in 'ending'
        implied_words = [f"{L}{ending}" for L in word_entries]
        # Check which are in SOWPODS
        valid = [w for w in implied_words if w in reference_words]
        invalid = [w for w in implied_words if w not in reference_words]
        print(f"  {ending}-range: {len(word_entries)} WORD entries")
        print(f"    Valid 2-letter: {valid[:10]}")
        if invalid:
            print(f"    INVALID 2-letter: {invalid[:10]}")

# Check if "AA" is found correctly
print("\n" + "=" * 60)
print("Verifying 'AA' path:")
print("=" * 60)

a_range = letter_ranges['a']
print(f"a-range: {a_range}")

for entry in range(a_range[0], min(a_range[0] + 50, a_range[1])):
    node = get_node(entry)
    if node and node['letter'] == 'a' and node['is_word']:
        print(f"  Entry {entry} is 'a' with WORD flag -> 'AA' is valid")
        break

# Now trace a path that SHOULD work
print("\n" + "=" * 60)
print("Tracing 'THE' (reversed 'EHT'):")
print("=" * 60)

e_range = letter_ranges['e']
print(f"e-range: {e_range}")

# Find 'h' in e-range
for entry in range(e_range[0], e_range[1]):
    node = get_node(entry)
    if node and node['letter'] == 'h':
        print(f"  Found 'h' at {entry}")
        child = get_child_entry(node)
        print(f"    child = {child}")
        if child:
            # Find 't' in children
            for c_entry in range(child, min(child + 100, section1_end)):
                c_node = get_node(c_entry)
                if c_node and c_node['letter'] == 't':
                    print(f"    Found 't' at {c_entry}, WORD={c_node['is_word']}")
                    if c_node['is_word']:
                        print("    -> 'THE' path found!")
                    break
        break
