#!/usr/bin/env python3
"""
Analyze Maven DAWG header and pointer structure
"""

import struct
from collections import defaultdict

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410

with open(DAWG_PATH, 'rb') as f:
    DATA = f.read()

print("=" * 60)
print("Header Analysis")
print("=" * 60)

# Header values
h1 = struct.unpack('>I', DATA[0:4])[0]
h2 = struct.unpack('>I', DATA[4:8])[0]
h3 = struct.unpack('>I', DATA[8:12])[0]
h4 = struct.unpack('>I', DATA[12:16])[0]

print(f"h1 = {h1} (0x{h1:08x})")
print(f"h2 = {h2} (0x{h2:08x})")
print(f"h3 = {h3} (0x{h3:08x})")
print(f"h4 = {h4} (0x{h4:08x})")

print(f"\nh2 - h1 = {h2 - h1} (second section size)")
print(f"h3 - h2 = {h3 - h2}")
print(f"Total entries: {h3} at 4 bytes each = {h3 * 4} bytes")
print(f"Actual node data size: {len(DATA) - NODE_BASE}")

# Check if h3 represents total entries
actual_entries = (len(DATA) - NODE_BASE) // 4
print(f"Actual entry count: {actual_entries}")

print("\n" + "=" * 60)
print("Alternative Child Formulas")
print("=" * 60)

def get_entry(idx):
    offset = NODE_BASE + idx * 4
    ptr = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'[0x{letter_byte:02x}]'
    return ptr, flags, letter

# Try different child formulas on entry 192 ('a' for AA -> AAH)
# Entry 192: 'a' ptr=4 flags=0x90 -> should lead to 'h' at entry 20
print("\nTesting formulas on entry 192 (AA -> AAH):")
ptr, flags, letter = get_entry(192)
print(f"Entry 192: '{letter}' ptr={ptr} flags=0x{flags:02x}")

formulas = [
    ("ptr + (flags & 0x7e)", ptr + (flags & 0x7e)),
    ("ptr + (flags & 0x7f)", ptr + (flags & 0x7f)),
    ("ptr + ((flags >> 1) & 0x3f)", ptr + ((flags >> 1) & 0x3f)),
    ("ptr * 2", ptr * 2),
    ("ptr * 4", ptr * 4),
    ("ptr + flags", ptr + flags),
    ("(ptr << 7) | (flags >> 1)", (ptr << 7) | (flags >> 1)),
]

for name, value in formulas:
    if value < actual_entries:
        _, _, child_letter = get_entry(value)
        print(f"  {name} = {value} -> '{child_letter}'")
    else:
        print(f"  {name} = {value} -> out of range")

# The original formula ptr + (flags & 0x7e) = 4 + 16 = 20 -> 'h' works!
print("\nFormula ptr + (flags & 0x7e) correctly gives entry 20 ('h')")

# Let's check if maybe there are TWO different formulas for two sections
print("\n" + "=" * 60)
print("Checking Pointer Ranges by Section")
print("=" * 60)

# First section (0 to h1-1)
ptr_range_1 = []
for i in range(min(h1, 10000)):  # Sample
    p, f, l = get_entry(i)
    if p > 0:
        child = p + (f & 0x7e)
        ptr_range_1.append((p, child))

if ptr_range_1:
    min_ptr_1 = min(p for p, c in ptr_range_1)
    max_ptr_1 = max(p for p, c in ptr_range_1)
    min_child_1 = min(c for p, c in ptr_range_1)
    max_child_1 = max(c for p, c in ptr_range_1)
    print(f"First section (sampled {len(ptr_range_1)} entries):")
    print(f"  ptr range: {min_ptr_1} - {max_ptr_1}")
    print(f"  child range: {min_child_1} - {max_child_1}")

# Second section (h1 to h2-1)
ptr_range_2 = []
for i in range(h1, min(h2, h1 + 10000)):  # Sample
    p, f, l = get_entry(i)
    if p > 0:
        child = p + (f & 0x7e)
        ptr_range_2.append((p, child))

if ptr_range_2:
    min_ptr_2 = min(p for p, c in ptr_range_2)
    max_ptr_2 = max(p for p, c in ptr_range_2)
    min_child_2 = min(c for p, c in ptr_range_2)
    max_child_2 = max(c for p, c in ptr_range_2)
    print(f"\nSecond section (sampled {len(ptr_range_2)} entries):")
    print(f"  ptr range: {min_ptr_2} - {max_ptr_2}")
    print(f"  child range: {min_child_2} - {max_child_2}")

# Check if second section children are all within first section
in_first = sum(1 for p, c in ptr_range_2 if c < h1)
in_second = sum(1 for p, c in ptr_range_2 if h1 <= c < h2)
out_of_range = sum(1 for p, c in ptr_range_2 if c >= h2)
print(f"\nSecond section children point to:")
print(f"  First section (0-{h1-1}): {in_first}")
print(f"  Second section ({h1}-{h2-1}): {in_second}")
print(f"  Out of range: {out_of_range}")

# Maybe second section uses different formula?
print("\n" + "=" * 60)
print("Testing if second section has different semantics")
print("=" * 60)

# Let's look at some second section entries more carefully
print("\nSample second section entries with high ptr:")
high_ptr_entries = []
for i in range(h1, min(h2, h1 + 1000)):
    p, f, l = get_entry(i)
    if p > 100:  # High ptr value
        high_ptr_entries.append((i, p, f, l))

for idx, p, f, l in high_ptr_entries[:10]:
    child = p + (f & 0x7e)
    child_p, child_f, child_l = get_entry(child) if child < actual_entries else (0, 0, '?')
    wm = "WORD" if f & 0x80 else ""
    print(f"  Entry {idx}: '{l}' ptr={p} flags=0x{f:02x} -> child {child} = '{child_l}' {wm}")
