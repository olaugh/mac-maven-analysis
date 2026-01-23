#!/usr/bin/env python3
"""
Decode Maven MUL values as SANE 80-bit extended precision.

SANE (Standard Apple Numerics Environment) used 80-bit extended:
- 1 bit sign
- 15 bits exponent (bias 16383)
- 64 bits mantissa (explicit integer bit)

Total: 10 bytes per value

If MUL resources are 224 bytes, that's 22 values per resource (with 4 bytes left over).
"""
import struct
import os
import math

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def decode_sane_extended(data):
    """
    Decode 10-byte SANE extended precision float.
    Format: [sign:1][exponent:15][mantissa:64]
    """
    if len(data) != 10:
        return None

    # First 2 bytes: sign and exponent
    exp_sign = struct.unpack('>H', data[0:2])[0]
    # Next 8 bytes: mantissa
    mantissa = struct.unpack('>Q', data[2:10])[0]

    sign = (exp_sign >> 15) & 1
    exponent = exp_sign & 0x7FFF

    # Special cases
    if exponent == 0:
        if mantissa == 0:
            return 0.0
        # Denormalized - treat as zero for simplicity
        return 0.0

    if exponent == 0x7FFF:
        if mantissa == 0:
            return float('-inf') if sign else float('inf')
        return float('nan')

    # Normal number
    # SANE extended has explicit integer bit (bit 63 of mantissa)
    # So we don't add implicit 1 like IEEE
    actual_exp = exponent - 16383

    # Prevent overflow
    if actual_exp > 1000:
        return float('inf')
    if actual_exp < -1000:
        return 0.0

    try:
        # Mantissa is 64-bit with explicit integer bit
        frac = mantissa / (2**63)
        value = frac * (2 ** actual_exp)
        return -value if sign else value
    except (OverflowError, ValueError):
        return float('nan')

def parse_estr():
    """Parse pattern strings"""
    estr_path = os.path.join(RESOURCES_DIR, "ESTR", "0_pattern_strings.bin")
    data = read_file(estr_path)
    patterns = []
    current = ""
    for byte in data:
        if byte == 0:
            if current:
                patterns.append(current)
            current = ""
        else:
            current += chr(byte)
    if current:
        patterns.append(current)
    return patterns

def main():
    print("=== SANE 80-bit Extended Precision Decoding ===\n")

    patterns = parse_estr()
    print(f"Found {len(patterns)} patterns")

    # Group patterns by starting letter
    patterns_by_letter = {}
    for p in patterns:
        key = '?' if p.startswith('?') else p[0]
        if key not in patterns_by_letter:
            patterns_by_letter[key] = []
        patterns_by_letter[key].append(p)

    print("\n" + "="*60)
    print("Decoding MUL resources as 10-byte SANE extended values:")
    print("="*60)

    for letter in ['?', 'a', 'e', 'i', 's', 'q', 'x', 'z']:
        mul_path = os.path.join(RESOURCES_DIR, f"MUL{letter}", "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)
        pats = patterns_by_letter.get(letter, [])

        display = 'BLANK' if letter == '?' else letter.upper()
        print(f"\nMUL{letter} ({len(data)} bytes = {len(data)//10} values if 10-byte):")

        # Decode as 10-byte values
        values = []
        for i in range(0, len(data) - 9, 10):
            val = decode_sane_extended(data[i:i+10])
            values.append((i, val))

        # Show values paired with patterns
        for i, (offset, val) in enumerate(values):
            if val is not None and -1000 < val < 1000:
                pat = pats[i] if i < len(pats) else "???"
                print(f"    [{i:2d}] offset {offset:3d}: {val:>12.4f}  pattern='{pat}'")
            elif i < 5:  # Show first few even if weird
                print(f"    [{i:2d}] offset {offset:3d}: {val}  (out of range)")

    # Now try decoding with 12-byte entries (10-byte float + 2-byte count)
    print("\n" + "="*60)
    print("Alternative: 12-byte entries (10-byte float + 2-byte count):")
    print("="*60)

    for letter in ['a', 's', 'q']:
        mul_path = os.path.join(RESOURCES_DIR, f"MUL{letter}", "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)
        pats = patterns_by_letter.get(letter, [])

        display = letter.upper()
        print(f"\nMUL{letter}:")

        for i in range(0, min(len(data) - 11, 120), 12):
            val = decode_sane_extended(data[i:i+10])
            count = struct.unpack('>H', data[i+10:i+12])[0]
            idx = i // 12
            if val is not None and -1000 < val < 1000:
                pat = pats[idx] if idx < len(pats) else "???"
                print(f"    [{idx:2d}] {val:>12.4f}  count={count:5d}  pattern='{pat}'")

    # Try yet another format: pairs of extended values
    print("\n" + "="*60)
    print("Alternative: 20-byte entries (two 10-byte floats):")
    print("="*60)

    for letter in ['a', 's']:
        mul_path = os.path.join(RESOURCES_DIR, f"MUL{letter}", "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)
        pats = patterns_by_letter.get(letter, [])

        print(f"\nMUL{letter}:")

        for i in range(0, min(len(data) - 19, 120), 20):
            val1 = decode_sane_extended(data[i:i+10])
            val2 = decode_sane_extended(data[i+10:i+20])
            idx = i // 20
            if val1 is not None and val2 is not None:
                pat = pats[idx] if idx < len(pats) else "???"
                if -1000 < val1 < 1000 and -1000 < val2 < 1000:
                    print(f"    [{idx:2d}] ({val1:>10.4f}, {val2:>10.4f})  pattern='{pat}'")

if __name__ == "__main__":
    main()
