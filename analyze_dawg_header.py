#!/usr/bin/env python3
"""
Analyze DAWG header and look for dictionary flag structures.

The header has 4 fields:
- section1_end: 56630
- section2_end: 122166
- field3: 145476 (larger than section2_end - what is this?)
- field4: 768
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
LETTER_INDEX_OFFSET = 0x10

def load_dawg():
    with open(DAWG_PATH, 'rb') as f:
        return f.read()

def main():
    data = load_dawg()

    print("=== DAWG Header Analysis ===\n")

    # Header fields
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    field3 = struct.unpack('>I', data[8:12])[0]
    field4 = struct.unpack('>I', data[12:16])[0]

    print(f"Section 1 end: {section1_end:6d}  (0x{section1_end:08x})")
    print(f"Section 2 end: {section2_end:6d}  (0x{section2_end:08x})")
    print(f"Field 3:       {field3:6d}  (0x{field3:08x})")
    print(f"Field 4:       {field4:6d}  (0x{field4:08x})")

    # Calculate sizes
    section1_size = section1_end
    section2_size = section2_end - section1_end
    unknown_size = field3 - section2_end

    print(f"\nSection 1 nodes: {section1_size}")
    print(f"Section 2 nodes: {section2_size}")
    print(f"Unknown region:  {unknown_size} (field3 - section2_end)")

    # Total data size
    node_data_end = NODE_START + field3 * 4
    print(f"\nNode data would end at: 0x{node_data_end:x}")
    print(f"Actual file size: {len(data)} (0x{len(data):x})")

    # Check what's in the "unknown" region between section2_end and field3
    print("\n=== Unknown Region Analysis ===")
    print(f"Region: entries {section2_end} to {field3}")
    print(f"First 20 entries in unknown region:")

    for idx in range(section2_end, min(section2_end + 20, field3)):
        offset = NODE_START + idx * 4
        if offset + 4 <= len(data):
            entry = struct.unpack('>I', data[offset:offset+4])[0]
            letter = entry & 0xFF
            letter_char = chr(letter) if 97 <= letter <= 122 else f'0x{letter:02x}'
            bit8 = (entry >> 8) & 1
            bit9 = (entry >> 9) & 1
            child = entry >> 10
            print(f"  [{idx:6d}] 0x{entry:08x} letter={letter_char} bit8={bit8} bit9={bit9} child={child}")

    # Letter index analysis
    print("\n=== Letter Index Analysis ===")
    print("The flags byte varies by letter - could indicate dictionary info\n")
    print("Letter  Ptr    Flags      Binary")
    print("-" * 45)

    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        raw = data[offset:offset+4]
        b0, b1, flags, letter = raw
        ptr = (b0 << 8) | b1
        letter_char = chr(ord('a') + i)
        print(f"  {letter_char}     {ptr:5d}  0x{flags:02x}  {flags:08b}")

    # Check if there's data after the node array
    print("\n=== Data After Node Array ===")
    node_array_end = NODE_START + field3 * 4
    remaining = len(data) - node_array_end
    print(f"Bytes after node array: {remaining}")

    if remaining > 0:
        print(f"First 64 bytes after node array:")
        for i in range(0, min(64, remaining), 16):
            chunk = data[node_array_end + i : node_array_end + i + 16]
            hex_str = ' '.join(f'{b:02x}' for b in chunk)
            ascii_str = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
            print(f"  {node_array_end + i:06x}: {hex_str}  {ascii_str}")

if __name__ == "__main__":
    main()
