#!/usr/bin/env python3
"""
Manual trace through the DAWG to understand the structure.
Let's trace the word "CAT" which is definitely in any Scrabble dictionary.
"""
import struct

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def dump_hex(data, offset, count=32):
    """Dump hex data at offset"""
    for i in range(0, count, 16):
        addr = offset + i
        bytes_line = data[addr:addr+16]
        hex_str = ' '.join(f'{b:02x}' for b in bytes_line)
        ascii_str = ''.join(chr(b) if 32 <= b < 127 else '.' for b in bytes_line)
        print(f"  {addr:04x}: {hex_str}  {ascii_str}")

def main():
    filepath = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data = read_file(filepath)

    print("=== Manual DAWG Trace ===\n")

    # Get 'C' index entry
    c_idx = 0x10 + (ord('c') - ord('a')) * 4  # 0x18
    print(f"'C' index at offset 0x{c_idx:02x}:")
    dump_hex(data, c_idx, 4)

    b0, b1, b2, b3 = data[c_idx:c_idx+4]
    c_ptr = (b0 << 8) | b1
    print(f"  ptr = 0x{c_ptr:04x} ({c_ptr})")
    print(f"  flags/b2 = 0x{b2:02x}")
    print(f"  letter = '{chr(b3)}' (0x{b3:02x})")

    # Calculate child offset using different interpretations
    print(f"\nChildren of 'C' (different interpretations):")

    # Interpretation 1: ptr is node index, nodes at 0x400
    children_off_1 = 0x400 + c_ptr * 4
    print(f"\n  1. ptr*4 from 0x400: offset 0x{children_off_1:04x}")
    dump_hex(data, children_off_1, 64)

    # Interpretation 2: ptr is byte offset from 0x400
    children_off_2 = 0x400 + c_ptr
    print(f"\n  2. ptr as byte offset from 0x400: offset 0x{children_off_2:04x}")
    dump_hex(data, children_off_2, 64)

    # Interpretation 3: ptr*4 from start
    children_off_3 = c_ptr * 4
    print(f"\n  3. ptr*4 from file start: offset 0x{children_off_3:04x}")
    dump_hex(data, children_off_3, 64)

    # Now let's look for 'A' in the children to trace "CA"
    print("\n\n=== Looking for 'A' (for CA) ===")

    # Scan children for 'A' (0x61)
    print("\nScanning for 'a' (0x61) in children:")
    found_a = []
    for base in [children_off_1, children_off_2, children_off_3]:
        for i in range(50):
            offset = base + i * 4
            if offset >= len(data) - 4:
                break
            if data[offset + 3] == 0x61:  # 'a'
                b0, b1, b2, b3 = data[offset:offset+4]
                ptr = (b0 << 8) | b1
                print(f"  Found 'a' at 0x{offset:04x}: ptr=0x{ptr:04x}, flags=0x{b2:02x}")
                found_a.append((offset, ptr, b2))

    # For each found 'A', look for 'T' (for CAT)
    print("\n\n=== Looking for 'T' (for CAT) ===")

    for a_off, a_ptr, a_flags in found_a:
        print(f"\nFrom 'a' at 0x{a_off:04x} (ptr=0x{a_ptr:04x}):")

        if a_ptr == 0:
            print("  No children (ptr=0)")
            continue

        # Try different child locations
        for offset_calc in [
            ("ptr*4 from 0x400", 0x400 + a_ptr * 4),
            ("ptr as byte from 0x400", 0x400 + a_ptr),
            ("ptr*4 from 0", a_ptr * 4),
        ]:
            name, base = offset_calc
            print(f"\n  {name}: 0x{base:04x}")
            for i in range(30):
                offset = base + i * 4
                if offset >= len(data) - 4:
                    break
                b0, b1, b2, b3 = data[offset:offset+4]
                if b3 == 0x74:  # 't'
                    ptr = (b0 << 8) | b1
                    is_eow = "(EOW)" if b2 & 0x01 else ""
                    print(f"    Found 't' at 0x{offset:04x}: ptr=0x{ptr:04x}, flags=0x{b2:02x} {is_eow}")

    # Alternative: dump around expected locations for "CAT"
    print("\n\n=== Statistical Analysis ===")

    # Count how many nodes have each letter
    letter_nodes = {}
    for offset in range(0x400, len(data) - 4, 4):
        letter = data[offset + 3]
        if 97 <= letter <= 122:
            if letter not in letter_nodes:
                letter_nodes[letter] = []
            letter_nodes[letter].append(offset)

    print("Letter distribution:")
    for letter in sorted(letter_nodes.keys()):
        count = len(letter_nodes[letter])
        char = chr(letter)
        print(f"  '{char}': {count} nodes")

    # For 't', show some samples with EOW flag
    print("\nSample 't' nodes with EOW flag:")
    t_nodes = letter_nodes.get(ord('t'), [])
    eow_t = []
    for offset in t_nodes[:500]:
        flags = data[offset + 2]
        if flags & 0x01:  # EOW
            b0, b1 = data[offset:offset+2]
            ptr = (b0 << 8) | b1
            eow_t.append((offset, ptr, flags))

    for offset, ptr, flags in eow_t[:20]:
        print(f"  0x{offset:04x}: ptr=0x{ptr:04x}, flags=0x{flags:02x}")

if __name__ == "__main__":
    main()
