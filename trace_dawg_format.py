#!/usr/bin/env python3
"""
Trace the exact DAWG format by examining raw bytes and comparing interpretations.

Goal: Determine the correct byte layout and pointer calculation.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]

# Letter index
LETTER_INDEX_OFFSET = 0x10
letter_index = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1 = data[offset:offset+2]
    letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

print("Letter index (Section 1 start points):")
for letter in 'abcdefghij':
    print(f"  '{letter}': entry {letter_index[letter]}")
print()


def get_raw_bytes(entry_idx):
    """Get raw 4 bytes for entry."""
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    return data[offset:offset+4]


def interpret_my_way(b0, b1, b2, b3):
    """My original interpretation: ptr(16) + flags(8) + letter(8)"""
    ptr = (b0 << 8) | b1
    flags = b2
    letter = chr(b3) if 97 <= b3 <= 122 else '?'
    is_word = bool(flags & 0x80)
    is_last = bool(flags & 0x01)
    child = ptr + (flags & 0x7e) if ptr else 0
    return {
        'letter': letter,
        'ptr': ptr,
        'flags': flags,
        'is_word': is_word,
        'is_last': is_last,
        'child': child,
    }


def interpret_code15_way(b0, b1, b2, b3):
    """CODE 15's 32-bit interpretation: entry >> 10 for child"""
    entry = (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
    letter = chr(b3) if 97 <= b3 <= 122 else '?'
    is_word = bool(entry & 0x100)  # bit 8
    is_last = bool(entry & 0x200)  # bit 9
    child = entry >> 10
    return {
        'letter': letter,
        'raw': entry,
        'is_word': is_word,
        'is_last': is_last,
        'child': child,
    }


print("Comparing interpretations for sample entries:")
print("=" * 80)

# Look at first few entries
for entry_idx in [0, 1, 2, 100, 200, letter_index['a'], letter_index['a']+1]:
    raw = get_raw_bytes(entry_idx)
    if raw:
        b0, b1, b2, b3 = raw
        mine = interpret_my_way(b0, b1, b2, b3)
        code15 = interpret_code15_way(b0, b1, b2, b3)

        print(f"Entry {entry_idx}:")
        print(f"  Raw bytes: {b0:02x} {b1:02x} {b2:02x} {b3:02x}")
        print(f"  My interp:    letter='{mine['letter']}' ptr={mine['ptr']} "
              f"flags={mine['flags']:02x} child={mine['child']} "
              f"is_word={mine['is_word']} is_last={mine['is_last']}")
        print(f"  CODE15 interp: letter='{code15['letter']}' child={code15['child']} "
              f"is_word={code15['is_word']} is_last={code15['is_last']}")
        print()

# Now let's trace word "AA" through my interpretation
print("=" * 80)
print("Tracing word 'AA' through DAWG:")
print()

# AA reversed = AA, start at 'a' range
a_start = letter_index['a']
a_end = letter_index['b']
print(f"'a' range in Section 1: entries {a_start} to {a_end-1}")

# Look for 'a' with is_word flag in this range
print(f"\nSearching for second 'a' (with is_word=True) in a-range:")
found_entries = []
for entry_idx in range(a_start, min(a_start + 100, a_end)):
    raw = get_raw_bytes(entry_idx)
    if raw:
        b0, b1, b2, b3 = raw
        node = interpret_my_way(b0, b1, b2, b3)
        if node['letter'] == 'a':
            found_entries.append((entry_idx, node))
            print(f"  Entry {entry_idx}: letter='a' is_word={node['is_word']} "
                  f"is_last={node['is_last']} child={node['child']}")

print()
print("=" * 80)
print("Section 2 analysis:")
print()

# Look at a few Section 2 entries
print("First 20 Section 2 entries:")
for entry_idx in range(section1_end, section1_end + 20):
    raw = get_raw_bytes(entry_idx)
    if raw:
        b0, b1, b2, b3 = raw
        node = interpret_my_way(b0, b1, b2, b3)
        print(f"  Entry {entry_idx}: letter='{node['letter']}' ptr={node['ptr']} "
              f"flags={node['flags']:02x} child={node['child']} "
              f"is_word={node['is_word']} is_last={node['is_last']}")

print()
print("=" * 80)
print("Key observation: Where do Section 2 children point?")
print()

# Sample Section 2 entries and check where their children point
sec2_sample = []
for entry_idx in range(section1_end, min(section1_end + 100, section2_end)):
    raw = get_raw_bytes(entry_idx)
    if raw:
        b0, b1, b2, b3 = raw
        node = interpret_my_way(b0, b1, b2, b3)
        if node['child'] > 0:
            sec2_sample.append((entry_idx, node))

print("Section 2 entries with children:")
for entry_idx, node in sec2_sample[:20]:
    child = node['child']
    in_sec1 = child < section1_end
    in_sec2 = section1_end <= child < section2_end
    where = "Section 1" if in_sec1 else ("Section 2" if in_sec2 else "INVALID")
    print(f"  Entry {entry_idx} '{node['letter']}' -> child {child} ({where})")

# Count where all Section 2 children point
sec1_count = 0
sec2_count = 0
invalid_count = 0
for entry_idx in range(section1_end, section2_end):
    raw = get_raw_bytes(entry_idx)
    if raw:
        b0, b1, b2, b3 = raw
        node = interpret_my_way(b0, b1, b2, b3)
        if node['child'] > 0:
            if node['child'] < section1_end:
                sec1_count += 1
            elif node['child'] < section2_end:
                sec2_count += 1
            else:
                invalid_count += 1

print(f"\nSection 2 child pointer destinations:")
print(f"  To Section 1: {sec1_count}")
print(f"  To Section 2: {sec2_count}")
print(f"  Invalid: {invalid_count}")
