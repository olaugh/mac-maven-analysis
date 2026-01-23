#!/usr/bin/env python3
"""
Count words in each DAWG section
In a DAWG, word count = number of entries with WORD marker (0x80 flag)
"""

import struct

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
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'[0x{letter_byte:02x}]'
    return ptr, flags, letter

print("=" * 60)
print("Word Count Analysis")
print("=" * 60)

# Count WORD markers in each section
word_count_1 = 0
word_count_2 = 0

for i in range(H1):
    _, flags, _ = get_entry(i)
    if flags & 0x80:
        word_count_1 += 1

for i in range(H1, H2):
    _, flags, _ = get_entry(i)
    if flags & 0x80:
        word_count_2 += 1

print(f"\nFirst DAWG (entries 0-{H1-1}):")
print(f"  Total entries: {H1}")
print(f"  WORD markers: {word_count_1}")

print(f"\nSecond DAWG (entries {H1}-{H2-1}):")
print(f"  Total entries: {H2 - H1}")
print(f"  WORD markers: {word_count_2}")

print(f"\nTotal WORD markers: {word_count_1 + word_count_2}")

# Compare to SOWPODS
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods_count = sum(1 for _ in f)
    print(f"\nSOWPODS 2003 word count: {sowpods_count}")
except:
    pass

# Additional analysis: count by letter
print("\n" + "=" * 60)
print("WORD markers by letter")
print("=" * 60)

letter_words_1 = {}
letter_words_2 = {}

for i in range(H1):
    _, flags, letter = get_entry(i)
    if flags & 0x80:
        letter_words_1[letter] = letter_words_1.get(letter, 0) + 1

for i in range(H1, H2):
    _, flags, letter = get_entry(i)
    if flags & 0x80:
        letter_words_2[letter] = letter_words_2.get(letter, 0) + 1

print("\nFirst DAWG (top 10 ending letters):")
for letter, count in sorted(letter_words_1.items(), key=lambda x: -x[1])[:10]:
    print(f"  '{letter}': {count}")

print("\nSecond DAWG (top 10 ending letters):")
for letter, count in sorted(letter_words_2.items(), key=lambda x: -x[1])[:10]:
    print(f"  '{letter}': {count}")

# Words ending in 'S' are very common (plurals)
print(f"\nWords ending in 's':")
print(f"  First DAWG: {letter_words_1.get('s', 0)}")
print(f"  Second DAWG: {letter_words_2.get('s', 0)}")
