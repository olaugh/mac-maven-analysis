#!/usr/bin/env python3
"""
Trace word paths starting from the letter index.
The letter index tells us where to start for each letter.
"""

import struct

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
LETTER_INDEX_OFFSET = 0x0010
H1 = 56630  # First DAWG size

with open(DAWG_PATH, 'rb') as f:
    DATA = f.read()

def get_entry(idx):
    """Get entry at index: returns (ptr, flags, letter)"""
    if idx < 0 or idx >= H1:
        return None, None, None
    offset = NODE_BASE + idx * 4
    ptr = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'0x{letter_byte:02x}'
    return ptr, flags, letter

def get_letter_index_entry(letter):
    """Get the letter index entry for a given letter"""
    if not letter.isalpha():
        return None
    idx = ord(letter.lower()) - ord('a')
    offset = LETTER_INDEX_OFFSET + idx * 4
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    return entry_idx, flags, letter_byte

print("=" * 70)
print("Letter Index Analysis")
print("=" * 70)

print("\nLetter Index Table:")
for c in 'abcdefghijklmnopqrstuvwxyz':
    entry_idx, flags, letter_byte = get_letter_index_entry(c)
    # Look at what entry is at that index
    e_ptr, e_flags, e_letter = get_entry(entry_idx)
    print(f"  '{c.upper()}': entry_idx={entry_idx:5d} flags=0x{flags:02x} "
          f"letter=0x{letter_byte:02x}('{chr(letter_byte) if 32 <= letter_byte < 127 else '?'}') "
          f"-> entry has ptr={e_ptr} flags=0x{e_flags:02x} letter='{e_letter}'")

print("\n" + "=" * 70)
print("Testing Different Ptr Interpretations")
print("=" * 70)

# Hypothesis 1: ptr is direct index of first child
# Hypothesis 2: ptr + flags gives child index
# Hypothesis 3: ptr is relative to current position
# Hypothesis 4: ptr is absolute but needs offset adjustment

# Let's trace from the letter 'A' index entry
a_idx, a_flags, a_letter = get_letter_index_entry('a')
print(f"\nStarting from letter 'A': entry index = {a_idx}")

# Get sibling group starting at this index
print("\nSibling group starting at entry", a_idx, ":")
idx = a_idx
siblings = []
while True:
    ptr, flags, letter = get_entry(idx)
    if ptr is None:
        break
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    siblings.append((idx, ptr, flags, letter))
    print(f"  Entry {idx}: ptr={ptr:5d} flags=0x{flags:02x} ({wm:4s} {ls:4s}) letter='{letter}'")
    if flags & 0x01:  # LAST flag
        break
    idx += 1

# For reversed words, these letters might be what comes BEFORE 'A' in words
# So entry with letter 'u' might lead to words like "AQUA" (reversed: AUQA)

print("\n--- Testing: Follow ptr as direct child index ---")
for idx, ptr, flags, letter in siblings[:5]:
    if ptr > 0 and ptr < H1:
        print(f"\nFrom entry {idx} '{letter}' -> ptr={ptr}:")
        # Get children starting at ptr
        child_idx = ptr
        children = []
        for _ in range(5):  # Limit to 5 children
            c_ptr, c_flags, c_letter = get_entry(child_idx)
            if c_ptr is None:
                break
            c_wm = "WORD" if c_flags & 0x80 else ""
            c_ls = "LAST" if c_flags & 0x01 else ""
            children.append((child_idx, c_ptr, c_flags, c_letter))
            print(f"    Entry {child_idx}: ptr={c_ptr:5d} flags=0x{c_flags:02x} ({c_wm:4s} {c_ls:4s}) letter='{c_letter}'")
            if c_flags & 0x01:
                break
            child_idx += 1

print("\n--- Testing: Follow ptr + (flags & 0x7e) ---")
for idx, ptr, flags, letter in siblings[:5]:
    calc_child = ptr + (flags & 0x7e)
    if calc_child > 0 and calc_child < H1:
        print(f"\nFrom entry {idx} '{letter}' -> ptr={ptr} + (flags & 0x7e)={flags & 0x7e} = {calc_child}:")
        c_ptr, c_flags, c_letter = get_entry(calc_child)
        if c_ptr is not None:
            c_wm = "WORD" if c_flags & 0x80 else ""
            c_ls = "LAST" if c_flags & 0x01 else ""
            print(f"    Entry {calc_child}: ptr={c_ptr:5d} flags=0x{c_flags:02x} ({c_wm:4s} {c_ls:4s}) letter='{c_letter}'")

print("\n" + "=" * 70)
print("Analyzing the ptr field distribution")
print("=" * 70)

# Look at ptr values for the first DAWG
ptr_values = []
for i in range(min(1000, H1)):
    ptr, flags, letter = get_entry(i)
    if ptr is not None:
        ptr_values.append(ptr)

print(f"\nPtr value statistics (first 1000 entries):")
print(f"  Min: {min(ptr_values)}")
print(f"  Max: {max(ptr_values)}")
print(f"  Mean: {sum(ptr_values)/len(ptr_values):.1f}")

# How many ptr values point forward vs backward?
forward = sum(1 for i, p in enumerate(ptr_values) if p > i)
backward = sum(1 for i, p in enumerate(ptr_values) if p < i)
equal = sum(1 for i, p in enumerate(ptr_values) if p == i)
print(f"  Forward pointers (ptr > current): {forward}")
print(f"  Backward pointers (ptr < current): {backward}")
print(f"  Equal (ptr == current): {equal}")

# Look for patterns in ptr values
print("\n  Most common ptr values:")
from collections import Counter
ptr_counter = Counter(ptr_values)
for ptr_val, count in ptr_counter.most_common(10):
    print(f"    ptr={ptr_val}: {count} times")

# What if ptr is actually an offset from some base?
print("\n" + "=" * 70)
print("Testing: ptr as sibling group index")
print("=" * 70)

# Build sibling groups
groups = []
current_group = []
for i in range(H1):
    ptr, flags, letter = get_entry(i)
    if ptr is None:
        break
    current_group.append((i, ptr, flags, letter))
    if flags & 0x01:  # LAST
        groups.append(current_group)
        current_group = []

print(f"Found {len(groups)} sibling groups")

# What if ptr points to a sibling GROUP number, not an entry index?
print("\nTesting: entry ptr value == sibling group number?")
for i in range(min(5, len(groups))):
    group = groups[i]
    print(f"\nGroup {i} (entries {group[0][0]}-{group[-1][0]}):")
    for idx, ptr, flags, letter in group[:3]:
        print(f"  Entry {idx} '{letter}': ptr={ptr}")
        if ptr < len(groups):
            target_group = groups[ptr]
            letters = ''.join(e[3] for e in target_group if not e[3].startswith('0x'))
            print(f"    -> Group {ptr} has letters: [{letters}]")

# Actually wait - let me look at the ptr distribution more carefully
# If ptr is a group index, the max ptr should be around 13000 (number of groups)
print(f"\nIf ptr is group index:")
print(f"  Number of groups: {len(groups)}")
print(f"  Max ptr value (first 1000): {max(ptr_values)}")
print(f"  Matches? {max(ptr_values) < len(groups)}")
