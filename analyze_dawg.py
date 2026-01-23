#!/usr/bin/env python3
"""
Analyze Maven's DAWG structure in detail
"""
import struct

def main():
    filepath = "/Volumes/T7/retrogames/oldmac/share/maven2"
    with open(filepath, 'rb') as f:
        data = f.read()

    print(f"File size: {len(data)} bytes")
    print(f"Size in 4-byte nodes: {len(data) // 4}")

    # Analyze header
    print("\n=== HEADER (0x00-0x0F) ===")
    for i in range(0, 16, 4):
        val = struct.unpack('>I', data[i:i+4])[0]
        print(f"  0x{i:02x}: 0x{val:08x} ({val})")

    # Analyze letter index (0x10-0x7F)
    print("\n=== LETTER INDEX (0x10-0x77) ===")
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1, b2, b3 = data[offset:offset+4]
        ptr16 = (b0 << 8) | b1
        letter = chr(ord('a') + i)
        print(f"  '{letter}' at 0x{offset:02x}: ptr=0x{ptr16:04x} ({ptr16}), "
              f"b2=0x{b2:02x} ({b2}), char=0x{b3:02x} ('{chr(b3)}')")

    # Analyze first DAWG nodes (0x400+)
    print("\n=== DAWG DATA START (0x400-0x500) ===")
    dawg_start = 0x400

    # Look for patterns
    print("\nFirst 64 entries:")
    for i in range(64):
        offset = dawg_start + i * 4
        b0, b1, b2, b3 = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        flags = b2
        letter = b3

        # Interpret letter
        if 97 <= letter <= 122:
            char = chr(letter)
        elif letter == 63:
            char = '?'
        elif letter == 0:
            char = '\\0'
        else:
            char = f'\\x{letter:02x}'

        # Interpret flags
        is_eow = '(EOW)' if flags & 0x01 else ''
        is_last = '(LAST)' if flags & 0x02 else ''

        print(f"  [{i:3d}] 0x{offset:04x}: ptr=0x{ptr:04x} flags=0x{flags:02x} '{char}' {is_eow} {is_last}")

    # Try to understand pointer encoding
    print("\n=== POINTER ANALYSIS ===")

    # Collect all unique pointer values
    ptr_values = {}
    for i in range((len(data) - dawg_start) // 4):
        offset = dawg_start + i * 4
        b0, b1 = data[offset:offset+2]
        ptr = (b0 << 8) | b1
        if ptr not in ptr_values:
            ptr_values[ptr] = 0
        ptr_values[ptr] += 1

    print(f"Unique pointer values: {len(ptr_values)}")
    print("Most common pointers:")
    for ptr, count in sorted(ptr_values.items(), key=lambda x: -x[1])[:20]:
        print(f"  0x{ptr:04x}: {count} times")

    # Check if pointers are reasonable byte offsets
    print("\n=== CHECKING POINTER INTERPRETATIONS ===")

    # Get some sample pointers and see what they point to
    sample_offsets = [0x418, 0x41c, 0x420, 0x450, 0x480]
    for src_offset in sample_offsets:
        b0, b1, b2, b3 = data[src_offset:src_offset+4]
        ptr = (b0 << 8) | b1
        letter = chr(b3) if 97 <= b3 <= 122 else f'\\x{b3:02x}'

        print(f"\nSource 0x{src_offset:04x}: ptr=0x{ptr:04x}, letter='{letter}'")

        # Try different interpretations of the pointer
        # 1. Direct byte offset from file start
        if ptr < len(data):
            target = data[ptr:ptr+4]
            print(f"  As byte offset from 0: {target.hex() if len(target)==4 else 'out of range'}")

        # 2. Node index (multiply by 4) from file start
        target_off = ptr * 4
        if target_off < len(data):
            target = data[target_off:target_off+4]
            t3 = target[3] if len(target) == 4 else 0
            tchar = chr(t3) if 97 <= t3 <= 122 else f'\\x{t3:02x}'
            print(f"  As node index from 0 (*4): 0x{target_off:04x} -> {target.hex()} (letter: '{tchar}')")

        # 3. Byte offset from DAWG start
        target_off = dawg_start + ptr
        if target_off < len(data):
            target = data[target_off:target_off+4]
            t3 = target[3] if len(target) == 4 else 0
            tchar = chr(t3) if 97 <= t3 <= 122 else f'\\x{t3:02x}'
            print(f"  As byte offset from 0x400: 0x{target_off:04x} -> {target.hex()} (letter: '{tchar}')")

        # 4. Node index from DAWG start
        target_off = dawg_start + ptr * 4
        if target_off < len(data):
            target = data[target_off:target_off+4]
            t3 = target[3] if len(target) == 4 else 0
            tchar = chr(t3) if 97 <= t3 <= 122 else f'\\x{t3:02x}'
            print(f"  As node index from 0x400 (*4): 0x{target_off:04x} -> {target.hex()} (letter: '{tchar}')")

    # Check for word "AA" (valid Scrabble word)
    print("\n=== LOOKING FOR 'AA' ===")
    # 'A' index entry points somewhere, then we need to find 'A' child
    a_entry = data[0x10:0x14]
    a_ptr = (a_entry[0] << 8) | a_entry[1]
    print(f"'A' index entry: ptr=0x{a_ptr:04x}")

    # Try node index interpretation from DAWG start
    a_children_offset = dawg_start + a_ptr * 4
    print(f"Children of 'A' at offset 0x{a_children_offset:04x}:")
    for i in range(10):
        offset = a_children_offset + i * 4
        if offset >= len(data):
            break
        b0, b1, b2, b3 = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        flags = b2
        letter = chr(b3) if 97 <= b3 <= 122 else f'\\x{b3:02x}'
        eow = '*' if flags & 0x01 else ''
        last = '!' if flags & 0x02 else ''
        print(f"    0x{offset:04x}: ptr=0x{ptr:04x} flags=0x{flags:02x} '{letter}'{eow}{last}")

if __name__ == "__main__":
    main()
