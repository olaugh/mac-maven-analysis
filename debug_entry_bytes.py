#!/usr/bin/env python3
"""
Debug: examine raw bytes of specific entries to understand structure.
"""

import struct

NODE_START = 0x410

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    return data, section1_end, section2_end

def show_entry(data, entry_idx, label=""):
    offset = NODE_START + entry_idx * 4
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    child1 = ptr + (flags & 0x7e) if ptr > 0 else 0  # My formula

    print(f"{label}Entry {entry_idx} (offset 0x{offset:x}):")
    print(f"  Raw bytes: {b0:02x} {b1:02x} {flags:02x} {letter:02x}")
    print(f"  ptr = 0x{ptr:04x} ({ptr})")
    print(f"  flags = 0x{flags:02x} (word={bool(flags&0x80)}, last={bool(flags&0x01)})")
    print(f"  letter = '{chr(letter)}' (0x{letter:02x})")
    print(f"  child (ptr + flags&0x7e) = {child1}")

def main():
    data, section1_end, section2_end = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}\n")

    # Look at Section 2 entry 56656 (first 'a' with is_word=True)
    show_entry(data, 56656, "S2 ")

    # Look at its child in Section 1
    print()
    show_entry(data, 97, "S1 child ")

    # Look at siblings of the child
    print("\n--- Siblings at entry 97 ---")
    for i in range(97, min(107, section1_end)):
        show_entry(data, i, "  ")
        # Check if last
        offset = NODE_START + i * 4
        flags = data[offset + 2]
        if flags & 0x01:
            print("  (LAST)")
            break
        print()

    # Let's also check entry 56632 which should be first Section 2 entry
    print("\n--- First Section 2 entry ---")
    show_entry(data, 56630, "S2 first ")

    # Check if Section 2 entries are organized differently
    print("\n--- First 10 Section 2 entries ---")
    for i in range(56630, 56640):
        show_entry(data, i, f"S2[{i}] ")
        print()

    # Also check letter index in header
    print("\n--- Letter Index (header 0x10-0x70) ---")
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        print(f"  {chr(ord('a')+i)}: entry={entry}, flags=0x{flags:02x}, letter=0x{letter:02x}")

if __name__ == "__main__":
    main()
