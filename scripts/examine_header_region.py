#!/usr/bin/env python3
"""
Examine the region between the letter index and node data.
There's 920 bytes (0x78 to 0x410) that might be another index.
"""

import struct

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
LETTER_INDEX_OFFSET = 0x0010

with open(DAWG_PATH, 'rb') as f:
    DATA = f.read()

print("=" * 70)
print("Examining header region in detail")
print("=" * 70)

# First 16 bytes - main header
print("\nMain header (0x00-0x0F):")
for i in range(0, 16, 4):
    val = struct.unpack('>I', DATA[i:i+4])[0]
    print(f"  0x{i:02x}: {DATA[i:i+4].hex()} = {val}")

# Letter index (0x10-0x77)
print("\nLetter index (0x10-0x77):")
for i in range(26):
    offset = 0x10 + i * 4
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter = DATA[offset+3]
    c = chr(ord('A') + i)
    print(f"  {c}: entry_idx={entry_idx:5d} flags=0x{flags:02x} letter=0x{letter:02x}('{chr(letter)}')")

# Region between letter index and node data (0x78-0x40F)
print("\n" + "=" * 70)
print("Mystery region (0x78-0x40F) - 920 bytes")
print("=" * 70)

# First, let's see if it's an extension of the letter index
# Or maybe it's a ptr-to-entry mapping
print("\nFirst 40 entries as 4-byte groups:")
for i in range(40):
    offset = 0x78 + i * 4
    val = struct.unpack('>I', DATA[offset:offset+4])[0]
    b0, b1, b2, b3 = DATA[offset:offset+4]
    # Try different interpretations
    as_2h = struct.unpack('>HH', DATA[offset:offset+4])
    print(f"  {i:3d} @0x{offset:03x}: {DATA[offset:offset+4].hex()} "
          f"u32={val:10d} u16x2=({as_2h[0]:5d},{as_2h[1]:5d}) "
          f"bytes=[{b0:3d},{b1:3d},{b2:3d},{b3:3d}]")

# The pattern at 0x78 onwards looks like it might be another index
# Let's see if these values correlate with entry indices

print("\n" + "=" * 70)
print("Looking for patterns in the mystery region")
print("=" * 70)

# Collect all 16-bit values from 0x78 to 0x410
values_16 = []
for i in range(0x78, 0x410, 2):
    val = struct.unpack('>H', DATA[i:i+2])[0]
    values_16.append(val)

print(f"\nNumber of 16-bit values: {len(values_16)}")
print(f"Range: {min(values_16)} to {max(values_16)}")
print(f"Values > 1000: {sum(1 for v in values_16 if v > 1000)}")
print(f"Values < 100: {sum(1 for v in values_16 if v < 100)}")

# Maybe this is a ptr-to-group or ptr-to-entry mapping table?
# The small ptr values (0-82 range) might index into this table
print("\n" + "=" * 70)
print("Hypothesis: Mystery region is ptr -> entry translation table")
print("=" * 70)

# If ptr=0 means "no children", then indices 1-82 (the ptr range) might map to entries
# Let's see what entries those would give us
print("\nFirst 90 entries of potential translation table (as entry indices):")
for i in range(90):
    offset = 0x78 + i * 2  # Each entry is 2 bytes
    if offset + 2 > 0x410:
        break
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    # Check what's at this entry
    if entry_idx < 56630:
        e_offset = NODE_BASE + entry_idx * 4
        ptr = struct.unpack('>H', DATA[e_offset:e_offset+2])[0]
        flags = DATA[e_offset+2]
        letter = DATA[e_offset+3]
        letter_ch = chr(letter) if 0x61 <= letter <= 0x7a else f'0x{letter:02x}'
        print(f"  idx {i:3d}: entry_idx={entry_idx:5d} -> ptr={ptr:3d} flags=0x{flags:02x} letter='{letter_ch}'")
    else:
        print(f"  idx {i:3d}: entry_idx={entry_idx:5d} (OUT OF RANGE)")

# Let me also check: maybe the table is 4 bytes per entry, giving (entry_start, count) or similar
print("\n" + "=" * 70)
print("Alternative: 4-byte entries in mystery region")
print("=" * 70)

print("\nFirst 40 entries as (entry_idx, count) pairs:")
for i in range(40):
    offset = 0x78 + i * 4
    if offset + 4 > 0x410:
        break
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    second = struct.unpack('>H', DATA[offset+2:offset+4])[0]
    print(f"  idx {i:3d}: entry_idx={entry_idx:5d}, second={second:5d}")

# Count how many 4-byte entries fit in the mystery region
num_4byte = (0x410 - 0x78) // 4
print(f"\nNumber of 4-byte entries that fit: {num_4byte}")
print(f"Number of ptr values seen: 0-82 range = 83 values")
print(f"Close match? {num_4byte}")
