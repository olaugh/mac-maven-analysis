#!/usr/bin/env python3
"""
Analyze the second letter index at the end of maven2.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    file_size = len(data)
    print(f"File size: {file_size} bytes (0x{file_size:x})")

    # The letter index appears to be at the very end
    # Let me find where the 'a' entry starts
    # Looking for pattern: XX XX XX 61 (where 61 = 'a')

    # The end of file shows entries like:
    # 00 b7 cc 61 - 'a'
    # 01 34 2c 62 - 'b'
    # ...
    # 08 e0 ee 7a - 'z'

    # The 'z' entry is at offset 0x1056c0 (file_size - 4)
    # So the index starts at approximately file_size - 26*4 = file_size - 104

    index_end = file_size
    index_start = file_size - 26 * 4

    print(f"\nPotential second letter index:")
    print(f"  Start: 0x{index_start:x}")
    print(f"  End: 0x{index_end:x}")

    # Parse this index
    print("\nSecond letter index entries:")
    for i in range(26):
        offset = index_start + i * 4
        b0, b1, b2, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        print(f"  {chr(ord('a')+i)}: entry=0x{entry:04x} ({entry:6d}), b2=0x{b2:02x}, stored_letter='{chr(letter)}'")

    # Compare with first letter index at 0x10
    print("\n" + "="*60)
    print("Comparing with first letter index at 0x10:")
    LETTER_INDEX_OFFSET = 0x10

    for i in range(26):
        offset1 = LETTER_INDEX_OFFSET + i * 4
        offset2 = index_start + i * 4

        b0_1, b1_1, b2_1, letter_1 = data[offset1:offset1+4]
        b0_2, b1_2, b2_2, letter_2 = data[offset2:offset2+4]

        entry1 = (b0_1 << 8) | b1_1
        entry2 = (b0_2 << 8) | b1_2

        letter = chr(ord('a') + i)
        print(f"  {letter}: index1={entry1:5d} (0x{entry1:04x})  index2={entry2:6d} (0x{entry2:05x})")

    # The second index has much larger entry values
    # They might be byte offsets into the file, not entry indices

    # Let me check if the second index points to node data in the file
    print("\n" + "="*60)
    print("Checking second index as byte offsets...")

    for i in range(26):
        offset = index_start + i * 4
        b0, b1, b2, letter = data[offset:offset+4]
        byte_offset = (b0 << 8) | b1

        # Read data at that offset
        if byte_offset < len(data) - 4:
            sample = data[byte_offset:byte_offset+8]
            print(f"  {chr(ord('a')+i)}: offset=0x{byte_offset:04x} -> {sample.hex()}")

    # Actually, looking at the values, entry2 for 'a' is 0x00b7cc
    # This is 75,468 which is larger than the node start offset
    # But the first index 'a' entry is 169

    # Wait - the second index might use a DIFFERENT byte-per-entry calculation
    # or the entries might be absolute byte offsets

    print("\n" + "="*60)
    print("Interpreting second index as direct byte offsets into node data...")

    NODE_START = 0x410
    section1_end = struct.unpack('>I', data[0:4])[0]

    for i in range(26):
        offset = index_start + i * 4
        b0, b1, b2, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1

        # Calculate entry index from byte offset
        # Maybe: entry_index = entry / 4?
        possible_idx1 = entry
        possible_idx2 = entry // 4

        # Or maybe it's an entry number in a different section
        print(f"  {chr(ord('a')+i)}: raw=0x{entry:05x} ({entry}), /4={entry//4}, b2=0x{b2:02x}")

    # Let's check what's at b2 values - they might be significant
    print("\n" + "="*60)
    print("Analyzing second index structure patterns...")

    # Count unique b2 values
    b2_values = []
    for i in range(26):
        offset = index_start + i * 4
        b0, b1, b2, letter = data[offset:offset+4]
        b2_values.append(b2)

    from collections import Counter
    b2_counts = Counter(b2_values)
    print(f"b2 value distribution: {dict(b2_counts)}")

    # The b2 values look like they might be part of a 3-byte entry number
    print("\n" + "="*60)
    print("Interpreting as 24-bit entry numbers (3 bytes):")

    for i in range(26):
        offset = index_start + i * 4
        b0, b1, b2, letter = data[offset:offset+4]
        entry_24bit = (b0 << 16) | (b1 << 8) | b2

        print(f"  {chr(ord('a')+i)}: entry=0x{entry_24bit:06x} ({entry_24bit:8d})")


if __name__ == "__main__":
    main()
