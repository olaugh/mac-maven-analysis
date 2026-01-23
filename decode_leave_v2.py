#!/usr/bin/env python3
"""
Decode Maven's leave values - try IEEE 754 double format
"""
import struct
import os

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def parse_estr():
    """Parse the ESTR (pattern strings) resource"""
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

def parse_mul_as_doubles(data):
    """Try parsing as 8-byte IEEE 754 doubles"""
    values = []
    for i in range(0, len(data), 8):
        if i + 8 > len(data):
            break
        try:
            # Big-endian double
            val = struct.unpack('>d', data[i:i+8])[0]
            values.append(val)
        except:
            values.append(None)
    return values

def parse_mul_as_pairs(data):
    """Try parsing as pairs of doubles (value + variance maybe?)"""
    values = []
    for i in range(0, len(data), 16):
        if i + 16 > len(data):
            break
        try:
            val1 = struct.unpack('>d', data[i:i+8])[0]
            val2 = struct.unpack('>d', data[i+8:i+16])[0]
            values.append((val1, val2))
        except:
            values.append((None, None))
    return values

def main():
    print("=== Maven Leave Value Analysis v2 ===\n")

    # Parse pattern strings
    patterns = parse_estr()
    print(f"Found {len(patterns)} patterns")

    print("\nSample patterns:")
    for i, p in enumerate(patterns[:20]):
        print(f"  {i:3d}: '{p}'")

    print("\n" + "="*60)
    print("\nMUL resource values (as 8-byte doubles):")

    # Focus on MULa first
    mul_path = os.path.join(RESOURCES_DIR, "MULa", "0_0.bin")
    data = read_file(mul_path)

    print(f"\nMULa ({len(data)} bytes):")

    # Try as pairs
    pairs = parse_mul_as_pairs(data)
    print("\n  As double pairs (value, count?):")
    for i, (v1, v2) in enumerate(pairs):
        if v1 is not None and v2 is not None:
            # Filter out non-sensical values
            if abs(v1) < 1e10 and abs(v2) < 1e10:
                print(f"    {i:2d}: ({v1:10.4f}, {v2:10.4f})")

    # Try offset by 2 (in case header)
    print("\n  Offset by 2 bytes:")
    for i in range(2, min(len(data), 66), 8):
        if i + 8 <= len(data):
            val = struct.unpack('>d', data[i:i+8])[0]
            if abs(val) < 1e10:
                print(f"    offset {i}: {val:.4f}")

    # Look for reasonable leave values (-30 to +30 is typical range)
    print("\n  Scanning for reasonable leave values (-50 to +50):")
    for i in range(0, len(data) - 8):
        try:
            val = struct.unpack('>d', data[i:i+8])[0]
            if -50 < val < 50 and val != 0:
                print(f"    offset {i}: {val:.4f}")
        except:
            pass

    # Also decode EXPR
    print("\n" + "="*60)
    print("\nEXPR resource analysis:")

    expr_dir = os.path.join(RESOURCES_DIR, "EXPR")
    for f in os.listdir(expr_dir):
        if f.endswith('.bin') and not f.startswith('._'):
            data = read_file(os.path.join(expr_dir, f))
            print(f"\n  {f}: {len(data)} bytes")

            # Try as doubles
            print("  As doubles:")
            for i in range(0, min(len(data), 80), 8):
                if i + 8 <= len(data):
                    val = struct.unpack('>d', data[i:i+8])[0]
                    if abs(val) < 1e10:
                        print(f"    offset {i}: {val:.4f}")

    # Final summary with pattern meanings
    print("\n" + "="*60)
    print("\nPattern Categories:")

    categories = {
        'Blanks': [p for p in patterns if p.startswith('?')],
        'Single vowels': [p for p in patterns if p in 'aeiou'],
        'Double+ vowels': [p for p in patterns if p and all(c in 'aeiou' for c in p) and len(p) > 1],
        'Q patterns': [p for p in patterns if 'q' in p],
        'Consonant combos': [p for p in patterns if len(p) > 1 and all(c not in 'aeiou' for c in p)],
        'Suffix patterns': [p for p in patterns if p in ['ing', 'tion', 'ity', 'ery', 'ary']],
    }

    for cat, pats in categories.items():
        if pats:
            print(f"\n  {cat}: {pats[:10]}")

if __name__ == "__main__":
    main()
