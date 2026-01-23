#!/usr/bin/env python3
"""
Analyze letter index structure at 0x0010-0x0077
"""

import struct

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
LETTER_INDEX_OFFSET = 0x0010

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
print("Letter Index Analysis")
print("=" * 60)

print("\nRaw letter index bytes (26 x 4 bytes at 0x0010):")
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1, b2, b3 = DATA[offset:offset+4]
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    expected_letter = chr(ord('a') + i)
    actual_letter = chr(b3) if 0x61 <= b3 <= 0x7a else f'0x{b3:02x}'

    # What entry is at that index?
    e_ptr, e_flags, e_letter = get_entry(entry_idx)

    print(f"{expected_letter.upper()}: bytes=[{b0:02x} {b1:02x} {b2:02x} {b3:02x}] entry={entry_idx} "
          f"actual_letter='{actual_letter}' entry_at_{entry_idx}='{e_letter}'")

# The letter index seems to store:
# - Entry index (2 bytes big-endian)
# - Some flags (1 byte)
# - The letter itself (1 byte)
# But the entry at that index may NOT be that letter!

print("\n" + "=" * 60)
print("What entries ACTUALLY contain 'a', 'b', 'c' etc?")
print("=" * 60)

# Find first occurrence of each letter
first_occurrence = {}
for i in range(56630):  # First DAWG
    _, _, letter = get_entry(i)
    if letter not in first_occurrence and letter.isalpha():
        first_occurrence[letter] = i

print("First occurrence of each letter:")
for letter in 'abcdefghijklmnopqrstuvwxyz':
    idx = first_occurrence.get(letter, "NOT FOUND")
    print(f"  '{letter}': entry {idx}")

# Maybe letter index is NOT pointing to entries containing that letter
# but to some other structure

print("\n" + "=" * 60)
print("Alternative: Letter index as root entry for GADDAG paths")
print("=" * 60)

# In a GADDAG, you start from any letter and can go both ways
# Letter index might point to the ROOT of all paths containing that letter

# Let's look at what's around entry 169 (the A index entry)
print("\nEntries 165-180:")
for i in range(165, 181):
    ptr, flags, letter = get_entry(i)
    wm = "W" if flags & 0x80 else " "
    ls = "L" if flags & 0x01 else " "
    print(f"  {i}: ptr={ptr} flags=0x{flags:02x} ({wm}{ls}) '{letter}'")

# Entry 169 is 'u', entry 170 is 'm', entry 171 is 'a'
# These might be letters that PRECEDE 'A' in words:
# - UA (words like AQUA reversed partial)
# - MA (words like DRAMA reversed partial)
# - AA (the word AA itself)

print("\n" + "=" * 60)
print("Hypothesis: Letter index = reversed prefix letters")
print("=" * 60)

# If entry 169 'u' is part of A's index, it might mean "words with A preceded by U"
# Let's see what ptr values these have

print("A index entries (169-170 based on letter index):")
for i in range(169, 172):
    ptr, flags, letter = get_entry(i)
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    print(f"  Entry {i}: '{letter}' ptr={ptr} flags=0x{flags:02x} {wm} {ls}")

# Entry 169 'u' has WORD flag - this might mean AU is a word
# Entry 170 'm' is LAST with ptr=0 - this might be AM terminal
# But wait, AM and AU are 2-letter words!

print("\n--- Checking if these represent 2-letter words ---")
# AU is a valid word
# AM is a valid word
# So the A index might list all letters that can FOLLOW A in 2-letter words

try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        words = set(line.strip().upper() for line in f)

    two_letter_a = [w for w in words if len(w) == 2 and w[0] == 'A']
    print(f"2-letter words starting with A: {two_letter_a}")

    # Second letters in A_ words
    second_letters = sorted(set(w[1].lower() for w in two_letter_a))
    print(f"Second letters: {second_letters}")

except:
    pass

# Actually let me reconsider the entry format
# Maybe the 4 bytes are: [something][letter] not [ptr][flags][letter]

print("\n" + "=" * 60)
print("Checking entry byte interpretation")
print("=" * 60)

print("Entry 0 raw bytes:")
offset = NODE_BASE
print(f"  Bytes: [{DATA[offset]:02x} {DATA[offset+1]:02x} {DATA[offset+2]:02x} {DATA[offset+3]:02x}]")
print(f"  As >H,B,B: ptr={struct.unpack('>H', DATA[offset:offset+2])[0]}, flags={DATA[offset+2]}, letter={chr(DATA[offset+3])}")
print(f"  As <H,B,B: ptr={struct.unpack('<H', DATA[offset:offset+2])[0]}, flags={DATA[offset+2]}, letter={chr(DATA[offset+3])}")
