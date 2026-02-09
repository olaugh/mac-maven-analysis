#!/usr/bin/env python3
"""
Analyze DAWG section boundaries more carefully.

Header values:
  0x00: 56630 (Section 1 end)
  0x04: 122166 (Section 2 end)
  0x08: 145476 (Section 3 end?)
  0x0C: 768 (unknown)

File size: 1,070,788 bytes
Node start: 0x410 = 1040 bytes
Max entries: (1070788 - 1040) / 4 = 267437

Let's examine what's in each section.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]
section3_end = struct.unpack('>I', data[8:12])[0]
unknown = struct.unpack('>I', data[12:16])[0]

max_entries = (len(data) - NODE_START) // 4

print("DAWG Section Analysis")
print("=" * 60)
print(f"File size: {len(data):,} bytes")
print(f"Node start: 0x{NODE_START:X}")
print(f"Max possible entries: {max_entries:,}")
print()
print(f"Section 1: entries 0 to {section1_end-1} ({section1_end:,} entries)")
print(f"Section 2: entries {section1_end} to {section2_end-1} ({section2_end - section1_end:,} entries)")
print(f"Section 3?: entries {section2_end} to {section3_end-1} ({section3_end - section2_end:,} entries)")
print(f"Unknown at 0x0C: {unknown}")
print()


def get_node(entry_idx):
    """Get DAWG node at entry index."""
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        # Check if it's valid data at all
        raw = struct.unpack('>I', data[offset:offset+4])[0]
        return {'raw': raw, 'letter': None, 'invalid': True}
    ptr = (b0 << 8) | b1
    return {
        'entry': entry_idx,
        'letter': chr(letter),
        'ptr': ptr,
        'flags': flags,
        'is_word': bool(flags & 0x80),
        'is_last': bool(flags & 0x01),
        'child': ptr + (flags & 0x7e) if ptr else 0,
    }


print("Examining Section 1 sample entries:")
for entry_idx in [0, 100, 1000, 10000, 50000, section1_end-1]:
    node = get_node(entry_idx)
    if node and not node.get('invalid'):
        print(f"  {entry_idx:6d}: '{node['letter']}' ptr={node['ptr']:5d} "
              f"flags={node['flags']:02X} child={node['child']:5d} "
              f"word={node['is_word']} last={node['is_last']}")

print()
print("Examining Section 2 sample entries:")
for entry_idx in [section1_end, section1_end + 100, section1_end + 1000, section2_end - 1]:
    node = get_node(entry_idx)
    if node and not node.get('invalid'):
        print(f"  {entry_idx:6d}: '{node['letter']}' ptr={node['ptr']:5d} "
              f"flags={node['flags']:02X} child={node['child']:5d} "
              f"word={node['is_word']} last={node['is_last']}")

print()
print("Examining Section 3 entries (if valid):")
for entry_idx in [section2_end, section2_end + 100, section2_end + 1000, section3_end - 1]:
    node = get_node(entry_idx)
    if node:
        if node.get('invalid'):
            print(f"  {entry_idx:6d}: INVALID (raw=0x{node['raw']:08X})")
        else:
            print(f"  {entry_idx:6d}: '{node['letter']}' ptr={node['ptr']:5d} "
                  f"flags={node['flags']:02X} child={node['child']:5d} "
                  f"word={node['is_word']} last={node['is_last']}")

print()
print("Examining entries beyond Section 3:")
for entry_idx in [section3_end, section3_end + 100, section3_end + 1000]:
    node = get_node(entry_idx)
    if node:
        if node.get('invalid'):
            print(f"  {entry_idx:6d}: INVALID (raw=0x{node['raw']:08X})")
        else:
            print(f"  {entry_idx:6d}: '{node['letter']}' ptr={node['ptr']:5d} "
                  f"flags={node['flags']:02X} child={node['child']:5d} "
                  f"word={node['is_word']} last={node['is_last']}")

# Check if Section 3 has different structure
print()
print("=" * 60)
print("Section 3 structure analysis:")

# Count valid letter entries vs invalid in Section 3
valid_count = 0
invalid_count = 0
letter_dist = {}

for entry_idx in range(section2_end, min(section3_end, section2_end + 10000)):
    node = get_node(entry_idx)
    if node:
        if node.get('invalid'):
            invalid_count += 1
        else:
            valid_count += 1
            letter_dist[node['letter']] = letter_dist.get(node['letter'], 0) + 1

print(f"  Valid letter entries: {valid_count}")
print(f"  Invalid entries: {invalid_count}")
if letter_dist:
    print(f"  Letter distribution (top 10): {dict(sorted(letter_dist.items(), key=lambda x: -x[1])[:10])}")

# Check child pointer destinations in Section 3
print()
print("Section 3 child pointer analysis:")
to_sec1 = 0
to_sec2 = 0
to_sec3 = 0
to_beyond = 0

for entry_idx in range(section2_end, min(section3_end, section2_end + 5000)):
    node = get_node(entry_idx)
    if node and not node.get('invalid') and node['child'] > 0:
        child = node['child']
        if child < section1_end:
            to_sec1 += 1
        elif child < section2_end:
            to_sec2 += 1
        elif child < section3_end:
            to_sec3 += 1
        else:
            to_beyond += 1

print(f"  Children pointing to Section 1: {to_sec1}")
print(f"  Children pointing to Section 2: {to_sec2}")
print(f"  Children pointing to Section 3: {to_sec3}")
print(f"  Children pointing beyond: {to_beyond}")
