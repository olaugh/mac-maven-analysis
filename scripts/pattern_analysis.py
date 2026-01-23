#!/usr/bin/env python3
"""
Pattern analysis - look for structure in consecutive entries
"""

import struct
from collections import Counter

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
H1 = 56630
H2 = 122166

with open(DAWG_PATH, 'rb') as f:
    DATA = f.read()

def get_entry(idx):
    offset = NODE_BASE + idx * 4
    ptr = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'0x{letter_byte:02x}'
    return ptr, flags, letter

print("=" * 60)
print("Consecutive Entry Pattern Analysis")
print("=" * 60)

# Look at sibling groups and see what patterns emerge
# Maybe the DAWG stores words in a TRIE-like manner
# where consecutive entries at the same "level" are siblings

def find_sibling_groups():
    """Find all sibling groups (entries until LAST flag)"""
    groups = []
    current_group = []

    for i in range(H1):
        ptr, flags, letter = get_entry(i)
        current_group.append((i, ptr, flags, letter))

        if flags & 0x01:  # LAST flag
            groups.append(current_group)
            current_group = []

    return groups

groups = find_sibling_groups()
print(f"Found {len(groups)} sibling groups")

# Analyze group sizes
sizes = Counter(len(g) for g in groups)
print("\nGroup size distribution:")
for size, count in sorted(sizes.items())[:15]:
    print(f"  Size {size}: {count} groups")

# Look at specific groups
print("\n--- First 10 sibling groups ---")
for i, group in enumerate(groups[:10]):
    letters = ''.join(e[3] for e in group if not e[3].startswith('0x'))
    ptrs = [e[1] for e in group]
    words_in_group = sum(1 for e in group if e[2] & 0x80)
    print(f"Group {i} (entries {group[0][0]}-{group[-1][0]}): [{letters}] ptrs={ptrs[:5]}... words={words_in_group}")

# What if the structure is: letter index -> sibling group containing first letters
# then ptr tells us which sibling group to jump to?

print("\n" + "=" * 60)
print("Ptr as Sibling Group Index")
print("=" * 60)

# If ptr is an index into the sibling groups array
# ptr=4 would mean "jump to sibling group 4"

print("\nFirst 10 sibling groups by index:")
for i, group in enumerate(groups[:10]):
    start_entry = group[0][0]
    letters = ''.join(e[3] for e in group if not e[3].startswith('0x'))
    print(f"  Group {i} (starts at entry {start_entry}): [{letters}]")

# Check: does ptr=4 point to group 4?
print("\nGroup 4 details:")
if len(groups) > 4:
    g4 = groups[4]
    for idx, ptr, flags, letter in g4:
        wm = "WORD" if flags & 0x80 else ""
        print(f"  Entry {idx}: '{letter}' ptr={ptr} flags=0x{flags:02x} {wm}")

# Let's trace with this interpretation
print("\n" + "=" * 60)
print("Testing ptr-as-group-index interpretation")
print("=" * 60)

def get_group_by_ptr(ptr):
    """Get sibling group at index ptr"""
    if ptr < len(groups):
        return groups[ptr]
    return None

# Start from letter A (group at letter_index['a'])
# Letter index points to entry 169
# What group is entry 169 in?

print("Finding group containing entry 169 (letter A)...")
for i, group in enumerate(groups):
    if any(e[0] == 169 for e in group):
        print(f"Entry 169 is in group {i}")
        for idx, ptr, flags, letter in group:
            wm = "WORD" if flags & 0x80 else ""
            print(f"  Entry {idx}: '{letter}' ptr={ptr} flags=0x{flags:02x} {wm}")
        break

# Now let's try: for each entry in that group, ptr tells us the next group
print("\nTracing from 'a' entry (if ptr=group index):")
for i, group in enumerate(groups):
    for idx, ptr, flags, letter in group:
        if idx == 171 and letter == 'a':  # AA entry
            print(f"Entry 171 'a': ptr={ptr}")
            next_group = get_group_by_ptr(ptr)
            if next_group:
                letters = ''.join(e[3] for e in next_group if not e[3].startswith('0x'))
                print(f"  ptr={ptr} -> Group {ptr}: [{letters}]")

# Actually, let's check if groups are indexed by their FIRST ENTRY index
# So ptr would be the starting entry index of a group, not the group number
print("\n" + "=" * 60)
print("Testing ptr-as-entry-index (group start)")
print("=" * 60)

# Build map: entry index -> group
entry_to_group = {}
for i, group in enumerate(groups):
    for entry in group:
        entry_to_group[entry[0]] = i
    # Map first entry of group to group itself
    entry_to_group[f"start_{group[0][0]}"] = group

# For entry 171 'a' ptr=5, what's at entry 5?
print("Entry 171 'a' has ptr=5")
print(f"Entry 5: {get_entry(5)}")

# What group starts at entry 5?
for i, group in enumerate(groups):
    if group[0][0] == 5:
        letters = ''.join(e[3] for e in group if not e[3].startswith('0x'))
        print(f"Group starting at entry 5: [{letters}]")
        break

# What if ptr + (flags & 0x7e) gives group start?
# Entry 171: ptr=5, flags=0xfe -> 5 + 126 = 131
# What group starts near 131?
target = 131
print(f"\nLooking for group starting near entry {target}:")
for i, group in enumerate(groups):
    if abs(group[0][0] - target) <= 5:
        letters = ''.join(e[3] for e in group if not e[3].startswith('0x'))
        print(f"  Group {i} starts at {group[0][0]}: [{letters}]")
