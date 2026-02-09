#!/usr/bin/env python3
"""
Analyze the DAWG header structure more thoroughly.

CODE 15 references an array at A5-11960 that contains section start positions.
The header at the beginning of the DAWG file likely contains this array.

DAWG file structure hypothesis:
  0x00-0x03: Section 1 end (56630)
  0x04-0x07: Section 2 end (122166)
  0x08-0x0F: Unknown
  0x10-0x7F: Letter index (26 entries × 4 bytes = 104 bytes to 0x78)
  0x78-0x410: Additional tables or arrays?

Let's examine what else is in the header.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

print("DAWG Header Analysis")
print("=" * 60)

# First 8 bytes: section boundaries
section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]
print(f"Section 1 ends at: {section1_end}")
print(f"Section 2 ends at: {section2_end}")
print()

# Bytes 8-15
print("Bytes 0x08-0x0F:")
for i in range(8, 16, 4):
    val = struct.unpack('>I', data[i:i+4])[0]
    print(f"  0x{i:02X}: {val} (0x{val:08X})")
print()

# Letter index at 0x10
print("Letter index (0x10-0x77):")
LETTER_INDEX_OFFSET = 0x10
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    # The full 4 bytes
    b0, b1, b2, b3 = data[offset:offset+4]
    entry = (b0 << 8) | b1
    extra = (b2 << 8) | b3
    letter = chr(ord('a') + i)
    print(f"  '{letter}' @ 0x{offset:02X}: entry={entry:5d}, extra=0x{extra:04X} ({b2:02X} {b3:02X})")

print()

# What's between letter index and node start?
# Letter index ends at 0x10 + 26*4 = 0x10 + 0x68 = 0x78
# Node start is at 0x410
# Gap: 0x78 to 0x410 = 920 bytes

print("Gap analysis (0x78 to 0x410):")
gap_start = 0x78
gap_end = NODE_START
gap_size = gap_end - gap_start
print(f"  Size: {gap_size} bytes (0x{gap_size:X})")

# Look for potential arrays in the gap
# If CODE 15 uses an array of section pointers, they'd be 4-byte values

# Check if there are meaningful 4-byte values
print(f"\nPotential 4-byte entries in gap:")
interesting_entries = []
for offset in range(gap_start, gap_end, 4):
    val = struct.unpack('>I', data[offset:offset+4])[0]
    # Check if it could be a valid DAWG entry index
    if 0 < val < section2_end:
        interesting_entries.append((offset, val))
        if len(interesting_entries) <= 30:
            in_sec1 = "S1" if val < section1_end else "S2"
            print(f"  0x{offset:03X}: {val:6d} ({in_sec1})")

print(f"\n  Total entries pointing to valid indices: {len(interesting_entries)}")

# Look for patterns - maybe lexicon-specific start points
print("\nLooking for lexicon markers...")

# Check for ASCII text that might indicate lexicon names
for offset in range(gap_start, gap_end - 4):
    chunk = data[offset:offset+4]
    if all(32 <= b <= 126 for b in chunk):
        text = chunk.decode('ascii')
        if text.strip():
            print(f"  0x{offset:03X}: '{text}'")

# Also examine the extra 2 bytes in letter index entries
print("\nLetter index extra bytes analysis:")
extra_bytes = []
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b2, b3 = data[offset+2:offset+4]
    extra_bytes.append((chr(ord('a') + i), b2, b3))

# Are the extra bytes meaningful?
print("  Unique flag patterns:")
seen = set()
for letter, b2, b3 in extra_bytes:
    if (b2, b3) not in seen:
        seen.add((b2, b3))
        print(f"    0x{b2:02X} 0x{b3:02X}")

# Could they be secondary entries?
print("\n  If extra bytes are entry indices:")
for letter, b2, b3 in extra_bytes[:5]:
    entry2 = (b2 << 8) | b3
    if 0 < entry2 < section2_end:
        in_sec = "S1" if entry2 < section1_end else "S2"
        print(f"    '{letter}': secondary entry = {entry2} ({in_sec})")
