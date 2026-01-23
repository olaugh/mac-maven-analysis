#!/usr/bin/env python3
"""
Reverse engineer the structure by finding word markers and working backwards.
"""

import struct

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
LETTER_INDEX_OFFSET = 0x0010
H1 = 56630

with open(DAWG_PATH, 'rb') as f:
    DATA = f.read()

def get_entry(idx):
    if idx < 0 or idx >= H1:
        return None, None, None
    offset = NODE_BASE + idx * 4
    ptr = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'0x{letter_byte:02x}'
    return ptr, flags, letter

def get_raw_entry(idx):
    """Get raw 4 bytes"""
    if idx < 0 or idx >= H1:
        return None
    offset = NODE_BASE + idx * 4
    return DATA[offset:offset+4]

# Load SOWPODS
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods = set(line.strip().upper() for line in f)
except:
    sowpods = set()

print("=" * 70)
print("Reverse Engineering DAWG Structure")
print("=" * 70)

# Find all entries with WORD flag (0x80)
word_entries = []
for i in range(H1):
    ptr, flags, letter = get_entry(i)
    if flags & 0x80:
        word_entries.append((i, ptr, flags, letter))

print(f"Found {len(word_entries)} entries with WORD flag")

# What letters have WORD flags?
from collections import Counter
word_letters = Counter(e[3] for e in word_entries if not e[3].startswith('0x'))
print(f"\nLetters with WORD flags (top 10):")
for letter, count in word_letters.most_common(10):
    print(f"  '{letter}': {count}")

# Let's look at the relationship between entry indices and letter index entries
print("\n" + "=" * 70)
print("Letter Index Entry Analysis")
print("=" * 70)

print("\nLetter index entries point to these entry indices:")
letter_to_entry = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    c = chr(ord('a') + i)
    letter_to_entry[c] = entry_idx
    print(f"  '{c}' -> entry {entry_idx}")

# The entries go in increasing order: 169, 282, 471, 574, 651, ...
# What's between these indices?

print("\nGaps between letter index entries:")
entries_sorted = sorted(letter_to_entry.items(), key=lambda x: x[1])
for i in range(1, len(entries_sorted)):
    prev_letter, prev_idx = entries_sorted[i-1]
    curr_letter, curr_idx = entries_sorted[i]
    gap = curr_idx - prev_idx
    print(f"  {prev_letter} ({prev_idx}) to {curr_letter} ({curr_idx}): gap = {gap}")

# Maybe the letter index entry for 'A' (169) means:
# "Paths starting with A use entries in the range before 282 (B's entry)"

print("\n" + "=" * 70)
print("Testing: Letter index defines entry ranges")
print("=" * 70)

# For letter 'A': entries 169 to 281 (before B's 282)
# For letter 'B': entries 282 to 470 (before C's 471)
# etc.

print("\nExamining entries in A's range (169-281):")
a_start, a_end = 169, 281
for i in range(a_start, min(a_start + 20, a_end + 1)):
    ptr, flags, letter = get_entry(i)
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    print(f"  Entry {i}: ptr={ptr:3d} flags=0x{flags:02x} ({wm:4s} {ls:4s}) letter='{letter}'")

# Check what ptr values are in A's range
print("\nPtr values in A's range:")
a_ptrs = []
for i in range(a_start, a_end + 1):
    ptr, flags, letter = get_entry(i)
    a_ptrs.append(ptr)
print(f"  Range: {min(a_ptrs)} to {max(a_ptrs)}")
print(f"  Unique values: {len(set(a_ptrs))}")
print(f"  Most common: {Counter(a_ptrs).most_common(5)}")

# NEW HYPOTHESIS: What if the structure encodes each letter's subtree sequentially?
# Letter A owns entries 0-168, and letter index points to the ROOT for that letter?

print("\n" + "=" * 70)
print("NEW HYPOTHESIS: Entries 0 to letter_index[A]-1 are for A")
print("=" * 70)

# Entries 0 to 168 might be the complete subtree for words starting with A
print(f"\nEntries 0 to {letter_to_entry['a']-1} might be subtree for 'A'")

# Look at structure of entries 0-168
a_subtree_end = letter_to_entry['a']
print(f"\nFirst 30 entries (potential A subtree root):")
for i in range(min(30, a_subtree_end)):
    ptr, flags, letter = get_entry(i)
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    print(f"  Entry {i}: ptr={ptr:3d} flags=0x{flags:02x} ({wm:4s} {ls:4s}) letter='{letter}'")

# Count sibling groups in first part
groups_before_a = 0
for i in range(a_subtree_end):
    ptr, flags, letter = get_entry(i)
    if flags & 0x01:  # LAST
        groups_before_a += 1
print(f"\nSibling groups in entries 0-{a_subtree_end-1}: {groups_before_a}")

# What if ptr refers to a sibling group within THIS subtree?
# And we need to add the base offset for the letter?

print("\n" + "=" * 70)
print("Testing: ptr indexes into local subtree groups")
print("=" * 70)

# Build groups for the A subtree
a_groups = []
current_start = 0
for i in range(a_subtree_end):
    ptr, flags, letter = get_entry(i)
    if flags & 0x01:
        a_groups.append((current_start, i))
        current_start = i + 1

print(f"A subtree has {len(a_groups)} sibling groups")
print(f"Max ptr in A's range: {max(a_ptrs)}")
print(f"This is close to {len(a_groups)} groups - MATCH!")

# If ptr=5 means "group 5 within A's subtree", then:
# Entry 0 is in group 0, points to group 4 (ptr=4)
# Let's trace!

def get_a_group(group_idx):
    if group_idx >= len(a_groups):
        return []
    start, end = a_groups[group_idx]
    entries = []
    for i in range(start, end + 1):
        ptr, flags, letter = get_entry(i)
        entries.append((i, ptr, flags, letter))
    return entries

print("\nA subtree groups 0-10:")
for gidx in range(min(10, len(a_groups))):
    entries = get_a_group(gidx)
    letters = ''.join(e[3] for e in entries if not e[3].startswith('0x'))
    words = sum(1 for e in entries if e[2] & 0x80)
    print(f"  Group {gidx} (entries {a_groups[gidx][0]}-{a_groups[gidx][1]}): [{letters}] words={words}")

# Now trace from entry 169 (letter index A) treating its ptr as group index
print("\nTracing from letter index A (entry 169):")
ptr, flags, letter = get_entry(169)
print(f"Entry 169: ptr={ptr} flags=0x{flags:02x} letter='{letter}'")
print(f"Children at group {ptr}:")
children = get_a_group(ptr)
for i, p, f, l in children:
    print(f"  Entry {i}: '{l}' ptr={p} {'WORD' if f & 0x80 else ''}")
