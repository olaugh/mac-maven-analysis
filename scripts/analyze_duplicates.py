#!/usr/bin/env python3
"""
Analyze why there are duplicate letters (like multiple 'a' entries) in a letter's range.
This might reveal the actual structure.
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

def get_letter_index_entry(letter):
    idx = ord(letter.lower()) - ord('a')
    offset = LETTER_INDEX_OFFSET + idx * 4
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    return entry_idx

# Build shared groups
first_letter_entry = get_letter_index_entry('a')
shared_groups = []
current_start = 0
for i in range(first_letter_entry):
    ptr, flags, letter = get_entry(i)
    if flags & 0x01:
        shared_groups.append((current_start, i))
        current_start = i + 1

def get_group_entries(group_idx):
    if group_idx >= len(shared_groups):
        return []
    start, end = shared_groups[group_idx]
    return [(idx, *get_entry(idx)) for idx in range(start, end + 1)]

print("=" * 70)
print("Analyzing Duplicate Letters in A's Range")
print("=" * 70)

a_start = get_letter_index_entry('a')
b_start = get_letter_index_entry('b')

# Group all entries by letter
from collections import defaultdict
letter_entries = defaultdict(list)
for idx in range(a_start, b_start):
    ptr, flags, letter = get_entry(idx)
    if not letter.startswith('0x'):
        letter_entries[letter].append((idx, ptr, flags))

print(f"\nEntries in A's range ({a_start}-{b_start-1}):")
for letter in sorted(letter_entries.keys()):
    entries = letter_entries[letter]
    print(f"\n  Letter '{letter}': {len(entries)} entries")
    for idx, ptr, flags in entries[:5]:  # Show first 5
        wm = "WORD" if flags & 0x80 else ""
        ls = "LAST" if flags & 0x01 else ""
        # What children does this lead to?
        if ptr < len(shared_groups):
            children = get_group_entries(ptr)
            child_letters = ''.join(e[3] for e in children if not e[3].startswith('0x'))
        else:
            child_letters = "?"
        print(f"    Entry {idx}: ptr={ptr:2d} flags=0x{flags:02x} ({wm:4s}{ls:4s}) -> children=[{child_letters}]")
    if len(entries) > 5:
        print(f"    ... and {len(entries)-5} more")

# Maybe the multiple 'a' entries are for different contexts?
# Let's see what paths lead to each one
print("\n" + "=" * 70)
print("Analyzing: What distinguishes multiple 'a' entries?")
print("=" * 70)

a_entries = letter_entries['a']
print(f"\nAll 'a' entries ({len(a_entries)}):")
for idx, ptr, flags in a_entries:
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    # Children
    if ptr < len(shared_groups):
        children = get_group_entries(ptr)
        child_letters = ''.join(e[3] for e in children if not e[3].startswith('0x'))
        child_word_count = sum(1 for e in children if e[2] & 0x80)
    else:
        child_letters = "?"
        child_word_count = 0

    print(f"  Entry {idx}: ptr={ptr:2d} flags=0x{flags:02x} ({wm:4s}{ls:4s}) "
          f"-> group {ptr} [{child_letters}] (words:{child_word_count})")

# What if each 'a' entry represents a different suffix pattern?
# E.g., one 'a' is for AA*, another for EA*, another for IA*?

print("\n" + "=" * 70)
print("Hypothesis: Entries are grouped by preceding letter")
print("=" * 70)

# Look at the sibling groups within A's range
print("\nSibling groups in A's range:")
a_range_groups = []
current_start = a_start
for idx in range(a_start, b_start):
    ptr, flags, letter = get_entry(idx)
    if flags & 0x01:  # LAST
        a_range_groups.append((current_start, idx))
        current_start = idx + 1

print(f"Number of sibling groups: {len(a_range_groups)}")

print("\nFirst 15 groups:")
for gidx, (gstart, gend) in enumerate(a_range_groups[:15]):
    entries = []
    for idx in range(gstart, gend + 1):
        ptr, flags, letter = get_entry(idx)
        entries.append((letter, flags & 0x80))
    letters = ''.join(f"{l}{'*' if w else ''}" for l, w in entries)
    print(f"  Group {gidx} (entries {gstart}-{gend}): [{letters}]")

# Interesting! Each sibling group might represent continuations from a specific node
# The first sibling group starting at entry 169 is: u* m
# This might mean: continuations of A are {u, m}
# Where u is a word (AU) and m is not a word (AM... wait, AM IS a word!)

# Let me check if the WORD flags are incorrect or if the structure is different

print("\n" + "=" * 70)
print("Checking if first sibling group matches A's children")
print("=" * 70)

first_group_start, first_group_end = a_range_groups[0]
print(f"\nFirst group for A (entries {first_group_start}-{first_group_end}):")
for idx in range(first_group_start, first_group_end + 1):
    ptr, flags, letter = get_entry(idx)
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    print(f"  Entry {idx}: '{letter}' ptr={ptr} flags=0x{flags:02x} ({wm}{ls})")

# This should represent: AU (word), AM (word?)
# But SOWPODS shows: AA, AB, AD, AE, AG, AH, AI, AL, AM, AN, AR, AS, AT, AW, AX, AY
# Clearly the structure is NOT a simple forward trie

# What if this is a SUFFIX structure instead?
# Entry 169 'u' might mean: words ENDING with AU
# Entry 170 'm' might mean: words ENDING with AM

print("\n" + "=" * 70)
print("Hypothesis: This is a REVERSED DAWG (suffix structure)")
print("=" * 70)

# In a reversed DAWG:
# - We lookup words by their REVERSED spelling
# - Entry 169 'u' with WORD flag under 'A' means: "UA" reversed = "AU" is a word?
# Wait that doesn't make sense either

# Let me check what 2-letter words end with A
print("\nSOWPODS 2-letter words ending with A:")
sowpods_2a_end = [w for w in ['AA', 'AB', 'AD', 'AE', 'AG', 'AH', 'AI', 'AL', 'AM', 'AN', 'AR', 'AS', 'AT', 'AW', 'AX', 'AY', 'BA', 'DA', 'EA', 'FA', 'GI', 'GO', 'HA', 'KA', 'LA', 'MA', 'NA', 'PA', 'TA', 'YA', 'ZA'] if w.endswith('A')]
print(f"  Ending with A: {sowpods_2a_end}")

# Actually from SOWPODS: BA, DA, EA, FA, HA, KA, LA, MA, NA, PA, TA, YA, ZA
# Hmm, 'u' doesn't match any...

# Let me try: the letter index entry for A tells us where to find
# paths that INCLUDE A somewhere (not necessarily at the start)

print("\n" + "=" * 70)
print("Final attempt: Look at raw entry sequence")
print("=" * 70)

# Dump the first 50 entries linearly
print("\nFirst 50 entries (0-49):")
for idx in range(50):
    ptr, flags, letter = get_entry(idx)
    wm = "W" if flags & 0x80 else " "
    ls = "L" if flags & 0x01 else " "
    mid_flags = (flags >> 1) & 0x3f
    print(f"  {idx:3d}: ptr={ptr:2d} flags=[{wm}{ls}|0x{mid_flags:02x}] letter='{letter}'")
