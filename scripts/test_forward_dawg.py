#!/usr/bin/env python3
"""
Test hypothesis: This might be a FORWARD DAWG, not reversed.
The letter index for 'A' gives letters that can FOLLOW 'A'.
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

# Build sibling groups
groups = []
current_group_start = 0
for i in range(H1):
    ptr, flags, letter = get_entry(i)
    if ptr is None:
        break
    if flags & 0x01:
        groups.append((current_group_start, i))
        current_group_start = i + 1

print(f"Built {len(groups)} sibling groups")

def get_group_entries(group_idx):
    if group_idx < 0 or group_idx >= len(groups):
        return []
    start, end = groups[group_idx]
    entries = []
    for idx in range(start, end + 1):
        ptr, flags, letter = get_entry(idx)
        entries.append((idx, ptr, flags, letter))
    return entries

# Load SOWPODS
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods = set(line.strip().upper() for line in f)
except:
    sowpods = set()

print("\n" + "=" * 70)
print("Testing Forward DAWG (no reversal)")
print("=" * 70)

# For letter 'A', the letter index gives us the group containing second letters
a_entry = get_letter_index_entry('a')
print(f"\nLetter 'A' -> entry {a_entry}")

# Find which group this entry is in
a_group = -1
for gidx, (gstart, gend) in enumerate(groups):
    if gstart <= a_entry <= gend:
        a_group = gidx
        break

print(f"Entry {a_entry} is in group {a_group}")

# Actually, the letter index might point to the FIRST entry of the group
# Let's check what the first entries of groups look like
print("\nFirst few groups and their first entries:")
for gidx in range(min(10, len(groups))):
    start, end = groups[gidx]
    entries = get_group_entries(gidx)
    letters = ''.join(e[3] for e in entries if not e[3].startswith('0x'))
    print(f"  Group {gidx} (entries {start}-{end}): [{letters}]")

# Now let's trace words properly
# The letter index entry for 'A' is 169
# We want to build "A" + <letters at that entry/group>

print("\n" + "=" * 70)
print("Building words starting with 'A'")
print("=" * 70)

def trace_words_forward(start_letter, max_depth=5):
    """Trace words in forward direction"""
    words = []

    start_entry = get_letter_index_entry(start_letter)

    # Find group containing start_entry
    start_group = -1
    for gidx, (gstart, gend) in enumerate(groups):
        if gstart <= start_entry <= gend:
            start_group = gidx
            break

    if start_group < 0:
        return words

    def recurse(group_idx, path, depth):
        if depth > max_depth:
            return

        entries = get_group_entries(group_idx)
        for idx, ptr, flags, letter in entries:
            if letter.startswith('0x'):
                continue

            new_path = path + letter

            if flags & 0x80:  # WORD marker
                words.append(new_path.upper())

            # Follow ptr to children
            if ptr > 0 and ptr < len(groups):
                recurse(ptr, new_path, depth + 1)

    # The first letter is the starting letter itself
    # Then we traverse from its group
    recurse(start_group, start_letter, 2)

    return words

a_words = trace_words_forward('a', max_depth=5)
print(f"\nFound {len(a_words)} words starting with 'A'")

# Check against SOWPODS
valid_words = [w for w in a_words if w in sowpods]
invalid_words = [w for w in a_words if w not in sowpods]

print(f"Valid SOWPODS words: {len(valid_words)}")
print(f"Invalid words: {len(invalid_words)}")

print("\nFirst 30 valid words found:")
for w in sorted(valid_words)[:30]:
    print(f"  {w}")

print("\nFirst 20 invalid 'words' found:")
for w in sorted(invalid_words)[:20]:
    print(f"  {w} (not in SOWPODS)")

# Let's also check specific 2-letter words starting with A
print("\n" + "=" * 70)
print("Two-letter words starting with A")
print("=" * 70)

two_letter_a = [w for w in sowpods if len(w) == 2 and w[0] == 'A']
print(f"SOWPODS has {len(two_letter_a)} 2-letter words starting with A:")
print(f"  {sorted(two_letter_a)}")

found_2letter = [w for w in a_words if len(w) == 2]
print(f"\nDAWG found {len(found_2letter)} 2-letter words starting with A:")
print(f"  {sorted(found_2letter)}")

# Check overlap
found_set = set(found_2letter)
sowpods_2a_set = set(two_letter_a)
print(f"\nOverlap: {sorted(found_set & sowpods_2a_set)}")
print(f"In DAWG but not SOWPODS: {sorted(found_set - sowpods_2a_set)}")
print(f"In SOWPODS but not DAWG: {sorted(sowpods_2a_set - found_set)}")
