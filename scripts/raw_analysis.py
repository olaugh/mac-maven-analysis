#!/usr/bin/env python3
"""
Raw byte analysis of Maven DAWG
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
    return ptr, flags, letter_byte

print("=" * 60)
print("Raw Byte Analysis")
print("=" * 60)

# Analyze ptr field more carefully
# Maybe it's not a direct pointer but an encoded value

ptr_distribution = Counter()
flags_distribution = Counter()

for i in range(H1):
    ptr, flags, letter = get_entry(i)
    ptr_distribution[ptr] += 1
    flags_distribution[flags] += 1

print("\nMost common ptr values:")
for ptr, count in ptr_distribution.most_common(20):
    print(f"  ptr={ptr}: {count} times")

print("\nMost common flags values:")
for flags, count in flags_distribution.most_common(20):
    print(f"  flags=0x{flags:02x}: {count} times")

# Look at entries with ptr=0 (terminal) vs ptr>0 (has children)
terminal_count = ptr_distribution[0]
nonterminal_count = sum(c for p, c in ptr_distribution.items() if p > 0)
print(f"\nTerminal entries (ptr=0): {terminal_count}")
print(f"Non-terminal entries (ptr>0): {nonterminal_count}")

print("\n" + "=" * 60)
print("Examining low-numbered entries (shared suffix pool?)")
print("=" * 60)

print("\nEntries 0-50:")
for i in range(51):
    ptr, flags, letter_byte = get_entry(i)
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'0x{letter_byte:02x}'
    wm = "W" if flags & 0x80 else " "
    ls = "L" if flags & 0x01 else " "

    # Decode flags bits
    bits = f"{flags:08b}"

    print(f"  {i:3d}: ptr={ptr:4d} flags={bits} ({wm}{ls}) '{letter}'")

# Maybe the first 2 bytes aren't a simple pointer
# Let's check if high byte and low byte have different meanings
print("\n" + "=" * 60)
print("Analyzing ptr as two separate bytes")
print("=" * 60)

high_byte_dist = Counter()
low_byte_dist = Counter()

for i in range(H1):
    offset = NODE_BASE + i * 4
    high_byte = DATA[offset]
    low_byte = DATA[offset + 1]
    high_byte_dist[high_byte] += 1
    low_byte_dist[low_byte] += 1

print("\nMost common high bytes (ptr >> 8):")
for val, count in high_byte_dist.most_common(10):
    print(f"  0x{val:02x}: {count} times")

print("\nMost common low bytes (ptr & 0xff):")
for val, count in low_byte_dist.most_common(10):
    print(f"  0x{val:02x}: {count} times")

# What if the structure uses the ptr differently?
# Let's see what combinations exist for entries with WORD marker
print("\n" + "=" * 60)
print("WORD entries analysis")
print("=" * 60)

word_entries = []
for i in range(H1):
    ptr, flags, letter_byte = get_entry(i)
    if flags & 0x80:
        letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'0x{letter_byte:02x}'
        word_entries.append((i, ptr, flags, letter))

print(f"Total WORD entries: {len(word_entries)}")

# Group by ptr value
word_by_ptr = Counter()
for i, ptr, flags, letter in word_entries:
    word_by_ptr[ptr] += 1

print("\nWORD entries by ptr value:")
for ptr, count in word_by_ptr.most_common(15):
    print(f"  ptr={ptr}: {count} WORD entries")

# What letters appear with ptr=0 and WORD flag?
print("\nTerminal WORD entries (ptr=0):")
terminal_words = [(i, f, l) for i, p, f, l in word_entries if p == 0]
print(f"  Count: {len(terminal_words)}")

letter_count = Counter(l for i, f, l in terminal_words)
print("  By letter:", dict(letter_count.most_common(10)))
