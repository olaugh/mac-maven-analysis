#!/usr/bin/env python3
"""
Check entry 103 raw bytes and child calculation.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

def dump_entry(entry_idx):
    offset = NODE_START + entry_idx * 4
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1

    print(f"Entry {entry_idx} at offset 0x{offset:x}:")
    print(f"  Raw bytes: {b0:02x} {b1:02x} {flags:02x} {letter:02x}")
    print(f"  ptr (b0<<8 | b1) = {ptr} (0x{ptr:04x})")
    print(f"  flags = 0x{flags:02x} ({flags:08b})")
    print(f"    bit 7 (WORD):  {(flags >> 7) & 1}")
    print(f"    bits 1-6:      {(flags >> 1) & 0x3f} = {(flags & 0x7e)}")
    print(f"    bit 0 (LAST):  {flags & 1}")
    print(f"  letter = {letter} ('{chr(letter)}' if ASCII)")
    print(f"  child = ptr + (flags & 0x7e) = {ptr} + {flags & 0x7e} = {ptr + (flags & 0x7e)}")
    print()

# Check entries around 103
for entry in [101, 102, 103, 104, 105]:
    dump_entry(entry)

# Check entry 20 (where 103 points to)
print("=" * 60)
print("Entry 20 (child of 103):")
dump_entry(20)

# Check entries 20-35 to see the sibling group
print("=" * 60)
print("Entries 20-35:")
for entry in range(20, 36):
    offset = NODE_START + entry * 4
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    is_word = (flags >> 7) & 1
    is_last = flags & 1
    child = ptr + (flags & 0x7e)
    if 97 <= letter <= 122:
        print(f"  {entry}: '{chr(letter)}' ptr={ptr} flags=0x{flags:02x} child={child} {'WORD' if is_word else ''} {'LAST' if is_last else ''}")

# Check entry 30 (supposed 'v' in AARDVARK path)
print("=" * 60)
print("Entry 30 (supposed 'v' in AARDVARK path):")
dump_entry(30)

# Maybe the path from the summary was wrong?
# Let me search for entry with 'v' that could follow from 'a' at 103

print("=" * 60)
print("Looking for 'v' entries that could be reached from somewhere...")

# Check what ptr values in entries 0-200 would lead to child containing entry 30
for check_entry in range(0, 200):
    offset = NODE_START + check_entry * 4
    if offset + 4 > len(data):
        continue
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        continue
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e)
    # Check if 30 could be in sibling group starting at child
    if child <= 30 < child + 26:  # rough check
        print(f"  Entry {check_entry} ('{chr(letter)}') ptr={ptr} child={child} might reach 30")
