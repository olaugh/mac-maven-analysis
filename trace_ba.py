#!/usr/bin/env python3
"""Trace why 'ba' isn't being found in enumeration."""

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


# For 'ba' (word ending in 'a'):
# Reversed: 'ab'
# Start in 'a' range, look for 'b' with is_word=True

a_start = letter_index['a']
a_end = letter_index['b']
print(f"'a' range: entries {a_start} to {a_end-1}")
print()

# Search for 'b' entries in 'a' range
print("Searching for 'b' entries in 'a' range:")
b_entries = []
entry = a_start
while entry < a_end:
    node = get_node(entry)
    if node:
        if node['letter'] == 'b':
            b_entries.append(node)
            print(f"  Entry {node['entry']}: '{node['letter']}' "
                  f"is_word={node['is_word']} child={node['child']}")
        if node['is_last']:
            entry += 1
        else:
            entry += 1
    else:
        entry += 1

print(f"\nFound {len(b_entries)} 'b' entries")
print(f"Entries with is_word=True: {[e['entry'] for e in b_entries if e['is_word']]}")

# Now let's validate 'ba' the way validation does it
print("\n" + "=" * 60)
print("Validating 'ba' via Section 1:")
print("Reversed: 'ab'")
print(f"Starting in 'a' range: {a_start} to {a_end-1}")


def get_siblings(start):
    sibs = []
    entry = start
    while entry < section1_end:
        node = get_node(entry)
        if node is None:
            break
        sibs.append(node)
        if node['is_last']:
            break
        entry += 1
    return sibs


def search_range(start, end, target_letter):
    """Search all sibling groups in range for target letter."""
    entry = start
    results = []
    while entry < end:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue
        for s in sibs:
            if s['letter'] == target_letter:
                results.append(s)
        entry += len(sibs)
    return results


# Search for 'b' in 'a' range
b_matches = search_range(a_start, a_end, 'b')
print(f"\nFound {len(b_matches)} 'b' entries in 'a' range:")
for m in b_matches[:10]:
    print(f"  Entry {m['entry']}: is_word={m['is_word']}, child={m['child']}")

# Any with is_word=True?
word_matches = [m for m in b_matches if m['is_word']]
print(f"\n'b' entries with is_word=True: {len(word_matches)}")
for m in word_matches[:5]:
    print(f"  Entry {m['entry']}")

if word_matches:
    print("\n'BA' should be valid!")
else:
    print("\n'BA' validation would fail from 'a' range.")
    print("Let's check the 'b' range for comparison...")

    # Check 'b' range for 'a'
    b_start = letter_index['b']
    b_end = letter_index['c']
    print(f"\n'b' range: entries {b_start} to {b_end-1}")

    a_matches = search_range(b_start, b_end, 'a')
    print(f"Found {len(a_matches)} 'a' entries in 'b' range:")
    for m in a_matches[:10]:
        print(f"  Entry {m['entry']}: is_word={m['is_word']}, child={m['child']}")

    a_word_matches = [m for m in a_matches if m['is_word']]
    print(f"\n'a' entries with is_word=True: {len(a_word_matches)}")
    for m in a_word_matches[:5]:
        print(f"  Entry {m['entry']}")
