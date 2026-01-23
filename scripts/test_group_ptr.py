#!/usr/bin/env python3
"""
Test hypothesis: ptr field is a sibling group INDEX, not an entry index.
To find children, we need to look up which entries belong to that group.
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

# Build sibling groups list
print("Building sibling groups...")
groups = []
current_group_start = 0
for i in range(H1):
    ptr, flags, letter = get_entry(i)
    if ptr is None:
        break
    if flags & 0x01:  # LAST flag - end of group
        groups.append((current_group_start, i))  # (start, end) inclusive
        current_group_start = i + 1

print(f"Found {len(groups)} sibling groups")

# Create a lookup from group index to entry range
def get_group_entries(group_idx):
    """Get all entries in a sibling group"""
    if group_idx < 0 or group_idx >= len(groups):
        return []
    start, end = groups[group_idx]
    entries = []
    for idx in range(start, end + 1):
        ptr, flags, letter = get_entry(idx)
        entries.append((idx, ptr, flags, letter))
    return entries

print("\n" + "=" * 70)
print("Testing: ptr as group index")
print("=" * 70)

# Test: trace the word "AA"
# In a reversed DAWG: AA = AA (palindrome)
# Start from letter 'A' -> entry 169

a_start = get_letter_index_entry('a')
print(f"\nLetter 'A' points to entry {a_start}")

# Entry 169 is part of which group?
for gidx, (gstart, gend) in enumerate(groups):
    if gstart <= a_start <= gend:
        print(f"Entry {a_start} is in group {gidx} (entries {gstart}-{gend})")
        break

# Show the group containing entry 169
print("\nGroup containing entry 169:")
a_group_entries = get_group_entries(gidx)
for idx, ptr, flags, letter in a_group_entries:
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    print(f"  Entry {idx}: ptr={ptr:2d} flags=0x{flags:02x} ({wm:4s} {ls:4s}) letter='{letter}'")

    # If ptr > 0, look up that group
    if ptr > 0 and ptr < len(groups):
        child_entries = get_group_entries(ptr)
        letters = ''.join(e[3] for e in child_entries if not e[3].startswith('0x'))
        print(f"       -> ptr={ptr} points to group {ptr}: entries {groups[ptr][0]}-{groups[ptr][1]} letters=[{letters}]")

print("\n" + "=" * 70)
print("Tracing paths from 'A'")
print("=" * 70)

def trace_word(start_letter, max_depth=4, current_path=""):
    """Trace all paths from a starting letter up to max_depth"""
    words = []

    def recurse(group_idx, path, depth):
        if depth > max_depth:
            return

        entries = get_group_entries(group_idx)
        for idx, ptr, flags, letter in entries:
            if letter.startswith('0x'):
                continue
            new_path = path + letter

            if flags & 0x80:  # WORD marker
                words.append(new_path)

            if ptr > 0 and ptr < len(groups) and depth < max_depth:
                recurse(ptr, new_path, depth + 1)

    # Find starting group from letter index
    start_entry = get_letter_index_entry(start_letter)
    for gidx, (gstart, gend) in enumerate(groups):
        if gstart <= start_entry <= gend:
            recurse(gidx, start_letter, 1)
            break

    return words

# Trace from 'A'
print("\nTracing paths from 'A' (max depth 4)...")
a_words = trace_word('a', max_depth=4)
print(f"Found {len(a_words)} word markers")
print("First 30 'words' found:")
for w in sorted(a_words)[:30]:
    # These are reversed, so reverse them for display
    print(f"  {w} (reversed: {w[::-1]})")

# Load SOWPODS to check
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods = set(line.strip().upper() for line in f)

    valid_count = sum(1 for w in a_words if w[::-1].upper() in sowpods)
    print(f"\nValid SOWPODS words (reversed): {valid_count} out of {len(a_words)}")
except:
    pass

print("\n" + "=" * 70)
print("Let's also check: are there gaps in group indices?")
print("=" * 70)

# What group indices are actually used as ptr values?
used_groups = set()
for i in range(min(5000, H1)):
    ptr, flags, letter = get_entry(i)
    if ptr is not None:
        used_groups.add(ptr)

print(f"Unique ptr values in first 5000 entries: {len(used_groups)}")
print(f"Range: {min(used_groups)} to {max(used_groups)}")
print(f"Total groups: {len(groups)}")

# Check for gaps
all_ptrs = sorted(used_groups)
gaps = []
for i in range(1, len(all_ptrs)):
    if all_ptrs[i] - all_ptrs[i-1] > 1:
        gaps.append((all_ptrs[i-1], all_ptrs[i]))
print(f"Gaps in ptr values: {len(gaps)}")
if gaps:
    print(f"First few gaps: {gaps[:5]}")
