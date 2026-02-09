#!/usr/bin/env python3
"""
Analyze the data after the main DAWG - possibly a second dictionary.

File structure:
- Header: 16 bytes (0x00-0x0F)
- Letter index: 104 bytes (0x10-0x77)
- Padding: to 0x410
- Main DAWG: 145476 * 4 = 581904 bytes
- Unknown data: 487844 bytes
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

def load_dawg():
    with open(DAWG_PATH, 'rb') as f:
        return f.read()

def main():
    data = load_dawg()

    # Main structure info
    field3 = struct.unpack('>I', data[8:12])[0]  # 145476
    main_dawg_end = NODE_START + field3 * 4  # 0x8e520

    print(f"=== Second Structure Analysis ===\n")
    print(f"Main DAWG ends at: 0x{main_dawg_end:x}")
    print(f"File size: {len(data)} (0x{len(data):x})")
    print(f"Remaining bytes: {len(data) - main_dawg_end}")

    # Check if this looks like another DAWG structure
    second_start = main_dawg_end
    print(f"\n=== Checking for second header at 0x{second_start:x} ===")

    # Read potential header
    if second_start + 16 <= len(data):
        h1 = struct.unpack('>I', data[second_start:second_start+4])[0]
        h2 = struct.unpack('>I', data[second_start+4:second_start+8])[0]
        h3 = struct.unpack('>I', data[second_start+8:second_start+12])[0]
        h4 = struct.unpack('>I', data[second_start+12:second_start+16])[0]
        print(f"  Potential header values:")
        print(f"    [0-3]:  {h1:10d} (0x{h1:08x})")
        print(f"    [4-7]:  {h2:10d} (0x{h2:08x})")
        print(f"    [8-11]: {h3:10d} (0x{h3:08x})")
        print(f"    [12-15]:{h4:10d} (0x{h4:08x})")

    # Actually, those first bytes looked like node entries
    # Let me analyze them as a node array directly
    print(f"\n=== Analyzing as node array (no header) ===")
    print("First 30 'nodes' interpreted as entries:")

    for i in range(30):
        offset = second_start + i * 4
        if offset + 4 <= len(data):
            entry = struct.unpack('>I', data[offset:offset+4])[0]
            letter = entry & 0xFF
            letter_char = chr(letter) if 97 <= letter <= 122 else f'0x{letter:02x}'
            bit8 = (entry >> 8) & 1
            bit9 = (entry >> 9) & 1
            child = entry >> 10
            print(f"  [{i:4d}] 0x{entry:08x} letter={letter_char:4s} eow={bit8} last={bit9} child={child:6d}")

    # Look for structure - is this a second complete DAWG?
    # Count how many valid-looking letter entries there are
    print(f"\n=== Statistical analysis ===")

    valid_letters = 0
    eow_entries = 0
    last_entries = 0
    total_entries = (len(data) - second_start) // 4

    for i in range(total_entries):
        offset = second_start + i * 4
        if offset + 4 <= len(data):
            entry = struct.unpack('>I', data[offset:offset+4])[0]
            letter = entry & 0xFF
            if 97 <= letter <= 122:
                valid_letters += 1
            if (entry >> 8) & 1:
                eow_entries += 1
            if (entry >> 9) & 1:
                last_entries += 1

    print(f"Total entries: {total_entries}")
    print(f"Valid letters (a-z): {valid_letters} ({100*valid_letters/total_entries:.1f}%)")
    print(f"EOW flag set: {eow_entries}")
    print(f"Last flag set: {last_entries}")

    # Check if there's a letter index somewhere
    # Try finding 'a' (0x61) at expected positions in a potential index
    print(f"\n=== Looking for letter index patterns ===")

    # Standard letter index would have 26 entries of 4 bytes each
    # Each entry ends with the letter (a=0x61, b=0x62, etc.)
    for search_offset in [second_start, second_start + 16, second_start + 0x10]:
        matches = 0
        for i in range(26):
            offset = search_offset + i * 4
            if offset + 4 <= len(data):
                raw = data[offset:offset+4]
                if len(raw) >= 4 and raw[3] == ord('a') + i:
                    matches += 1
        if matches > 10:
            print(f"  Found {matches}/26 letter matches at offset 0x{search_offset:x}")

    # Maybe it's a different structure - bitmask for TWL words?
    # Each bit could indicate if a word is in TWL
    print(f"\n=== Alternative hypothesis: bitmask array ===")
    print("If this is a bitmask for ~250k words, we'd need ~31KB")
    print(f"We have {len(data) - second_start} bytes = enough for {(len(data) - second_start) * 8} bits")

    # Try interpreting first part as a different DAWG format
    print(f"\n=== Byte-level analysis of first 128 bytes ===")
    for i in range(0, 128, 16):
        offset = second_start + i
        chunk = data[offset:offset+16]
        hex_str = ' '.join(f'{b:02x}' for b in chunk)
        ascii_str = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
        print(f"  {offset:06x}: {hex_str}  {ascii_str}")

if __name__ == "__main__":
    main()
