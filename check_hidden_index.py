#!/usr/bin/env python3
"""Check for hidden letter indices or structure in the gap between header and data."""
import struct

FILEPATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
with open(FILEPATH, 'rb') as f:
    data = f.read()

s1_base = 12

def entry(idx):
    off = s1_base + idx * 4
    val = struct.unpack('>I', data[off:off+4])[0]
    lb = val & 0xFF
    return val, chr(lb) if 97 <= lb <= 122 else f'0x{lb:02x}', (val>>8)&1, (val>>9)&1, val>>10

# Check entries 0-60
print("S1 entries 0-60:")
for i in range(61):
    val, lt, eow, last, child = entry(i)
    marker = ""
    if i == 0:
        marker = " <-- sentinel"
    elif 1 <= i <= 26:
        marker = f" <-- letter index ({chr(ord('a')+i-1)})"
    elif 27 <= i <= 52:
        marker = f" <-- could be 2nd index ({chr(ord('a')+i-27)})"
    print(f"  [{i:3d}] val=0x{val:08X} letter='{lt}' eow={eow} last={last} child={child:6d}{marker}")

# Check if entries 27-52 form a valid letter index (a-z with increasing children)
print("\nEntries 27-52 analysis:")
valid_index = True
for i in range(26):
    val, lt, eow, last, child = entry(27 + i)
    expected_letter = chr(ord('a') + i)
    matches = (lt == expected_letter)
    print(f"  [{27+i}] letter='{lt}' (expected '{expected_letter}') match={matches} child={child}")
    if not matches:
        valid_index = False

print(f"\nEntries 27-52 form valid letter index: {valid_index}")

# Also check the header gap area for any other patterns
print("\nBytes 120-200 (hex dump of gap area):")
for offset in range(120, 200, 16):
    hexbytes = ' '.join(f'{data[offset+j]:02x}' for j in range(min(16, 200-offset)))
    print(f"  {offset:4d}: {hexbytes}")
