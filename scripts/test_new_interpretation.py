#!/usr/bin/env python3
"""
New interpretation:
- Entries 0 to letter_index[A]-1 are SHARED/DEEPER level nodes
- Entries from letter_index[A] to letter_index[B]-1 are SECOND letters for A-words
- ptr indexes into the shared groups (entries 0-168)

So to spell "AUK":
- Start with A (implicit from letter index)
- Entry 169 'u' is the second letter, WORD flag means "AU" is a word
- Entry 169's ptr=6 points to group 6 (entry 10 'k')
- 'k' is the third letter, making "AUK"
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

# Load SOWPODS
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods = set(line.strip().upper() for line in f)
except:
    sowpods = set()

# Build shared groups (entries 0 to letter_index[A]-1)
first_letter_entry = get_letter_index_entry('a')  # 169
shared_groups = []
current_start = 0
for i in range(first_letter_entry):
    ptr, flags, letter = get_entry(i)
    if flags & 0x01:
        shared_groups.append((current_start, i))
        current_start = i + 1

print("=" * 70)
print("New Interpretation Test")
print("=" * 70)
print(f"\nShared nodes: entries 0-{first_letter_entry-1}")
print(f"Shared groups: {len(shared_groups)}")

# Get all groups globally
all_groups = []
current_start = 0
for i in range(H1):
    ptr, flags, letter = get_entry(i)
    if flags is None:
        break
    if flags & 0x01:
        all_groups.append((current_start, i))
        current_start = i + 1

print(f"Total groups in DAWG: {len(all_groups)}")

def get_group_entries(groups_list, group_idx):
    if group_idx >= len(groups_list):
        return []
    start, end = groups_list[group_idx]
    entries = []
    for idx in range(start, end + 1):
        ptr, flags, letter = get_entry(idx)
        entries.append((idx, ptr, flags, letter))
    return entries

# Test the interpretation
print("\n" + "=" * 70)
print("Testing: Trace 'AUK'")
print("=" * 70)

# Step 1: A is the first letter (from letter index)
a_entry = get_letter_index_entry('a')
print(f"Letter 'A' -> start at entry {a_entry}")

# Step 2: Look for 'u' in entries starting at a_entry
print("\nSearching for 'u' in A's second-letter entries:")
idx = a_entry
while idx < get_letter_index_entry('b'):  # Until B's range
    ptr, flags, letter = get_entry(idx)
    if letter == 'u':
        print(f"  Found 'u' at entry {idx}: ptr={ptr} flags=0x{flags:02x}")
        wm = "WORD" if flags & 0x80 else ""
        print(f"    {wm}")

        # Step 3: Follow ptr to find 'k'
        print(f"\n  Following ptr={ptr} to shared group {ptr}:")
        children = get_group_entries(shared_groups, ptr)
        for e_idx, e_ptr, e_flags, e_letter in children:
            e_wm = "WORD" if e_flags & 0x80 else ""
            print(f"    Entry {e_idx}: '{e_letter}' ptr={e_ptr} {e_wm}")
            if e_letter == 'k':
                print(f"    FOUND 'k' -> AUK!")
    if flags & 0x01:  # Only check until LAST sibling of 'u' group
        idx += 1
    else:
        idx += 1
    if idx > a_entry + 120:  # Safety limit
        break

# Now let's trace all 2-letter A-words
print("\n" + "=" * 70)
print("Tracing all 2-letter words starting with A")
print("=" * 70)

# The entries from a_entry to b_entry-1 are second letters
# If an entry has WORD flag, it's a 2-letter word
b_entry = get_letter_index_entry('b')
two_letter_a = []
for idx in range(a_entry, b_entry):
    ptr, flags, letter = get_entry(idx)
    if letter.startswith('0x'):
        continue
    if flags & 0x80:  # WORD flag
        word = 'A' + letter.upper()
        two_letter_a.append(word)

print(f"\nFound {len(two_letter_a)} 2-letter A-words in DAWG:")
print(f"  {sorted(two_letter_a)}")

print(f"\nSOWPODS 2-letter A-words:")
sowpods_2a = [w for w in sowpods if len(w) == 2 and w[0] == 'A']
print(f"  {sorted(sowpods_2a)}")

# Check overlap
found_set = set(two_letter_a)
sowpods_set = set(sowpods_2a)
print(f"\nMatch: {sorted(found_set & sowpods_set)}")
print(f"In DAWG but not SOWPODS: {sorted(found_set - sowpods_set)}")
print(f"In SOWPODS but not DAWG: {sorted(sowpods_set - found_set)}")

# Now let's trace 3-letter words
print("\n" + "=" * 70)
print("Tracing 3-letter words starting with A")
print("=" * 70)

three_letter_a = []
for idx in range(a_entry, b_entry):
    ptr, flags, letter = get_entry(idx)
    if letter.startswith('0x'):
        continue
    if ptr == 0:
        continue  # No children

    second_letter = letter.upper()

    # Get children from shared groups
    if ptr < len(shared_groups):
        children = get_group_entries(shared_groups, ptr)
        for e_idx, e_ptr, e_flags, e_letter in children:
            if e_letter.startswith('0x'):
                continue
            if e_flags & 0x80:  # WORD at third position
                word = 'A' + second_letter + e_letter.upper()
                three_letter_a.append(word)

print(f"Found {len(three_letter_a)} 3-letter A-words in DAWG:")
for w in sorted(three_letter_a)[:30]:
    valid = "✓" if w in sowpods else "✗"
    print(f"  {valid} {w}")

# Check validity
valid_3 = [w for w in three_letter_a if w in sowpods]
print(f"\nValid SOWPODS matches: {len(valid_3)} out of {len(three_letter_a)}")

# If this interpretation is correct, we should find words like AAH, AAL, AAS
print("\n" + "=" * 70)
print("Testing specific known words")
print("=" * 70)

def trace_word(word):
    """Trace a word through the structure"""
    word = word.upper()
    if len(word) < 2:
        return False

    first_letter = word[0].lower()
    start_entry = get_letter_index_entry(first_letter)

    # Next letter entry (or end of DAWG for Z)
    if first_letter == 'z':
        end_entry = H1
    else:
        next_letter = chr(ord(first_letter) + 1)
        end_entry = get_letter_index_entry(next_letter)

    # Find second letter
    for idx in range(start_entry, end_entry):
        ptr, flags, letter = get_entry(idx)
        if letter == word[1].lower():
            print(f"  {word[0]}->{word[1]}: entry {idx} ptr={ptr} {'WORD' if flags & 0x80 else ''}")

            if len(word) == 2:
                return bool(flags & 0x80)

            # Find third letter in shared groups
            if ptr < len(shared_groups):
                children = get_group_entries(shared_groups, ptr)
                for e_idx, e_ptr, e_flags, e_letter in children:
                    if e_letter == word[2].lower():
                        print(f"  {word[1]}->{word[2]}: entry {e_idx} ptr={e_ptr} {'WORD' if e_flags & 0x80 else ''}")

                        if len(word) == 3:
                            return bool(e_flags & 0x80)

                        # Fourth letter - need to follow e_ptr
                        # This might require recursive lookup into deeper shared groups
                        return None  # Can't trace further yet

    return False

for test_word in ['AA', 'AB', 'AH', 'AUK', 'AAH', 'AAL', 'AAS', 'THE']:
    print(f"\nTracing '{test_word}':")
    result = trace_word(test_word)
    print(f"  Result: {result}")
