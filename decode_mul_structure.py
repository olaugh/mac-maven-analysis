#!/usr/bin/env python3
"""
Decode MUL resource with discovered structure:
Each entry appears to be 28 bytes:
  - 8-byte IEEE double (leave value)
  - 2-byte unknown
  - 8-byte IEEE double (secondary value)
  - 2-byte unknown
  - 4-byte count (positive)
  - 4-byte count (possibly negative/signed)
"""
import struct
import os

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def try_double(data, offset):
    """Decode as IEEE 754 double (big-endian)"""
    if offset + 8 > len(data):
        return None
    try:
        return struct.unpack('>d', data[offset:offset+8])[0]
    except:
        return None

def is_reasonable_leave(val):
    """Check if value is in typical leave value range"""
    if val is None:
        return False
    try:
        return -50 < val < 50 and not (val != val)  # not NaN
    except:
        return False

def decode_28byte_entries(data):
    """Try 28-byte entry structure"""
    entries = []
    for i in range(0, len(data) - 27, 28):
        d1 = try_double(data, i)
        unk1 = struct.unpack('>H', data[i+8:i+10])[0]
        d2 = try_double(data, i+10)
        unk2 = struct.unpack('>H', data[i+18:i+20])[0]
        count1 = struct.unpack('>I', data[i+20:i+24])[0]
        count2 = struct.unpack('>i', data[i+24:i+28])[0]  # signed

        entries.append({
            'value1': d1,
            'unk1': unk1,
            'value2': d2,
            'unk2': unk2,
            'count1': count1,
            'count2': count2
        })
    return entries

def decode_shifted_structure(data):
    """
    Try decoding with structure:
    - 8-byte double
    - 2-byte data
    - 8-byte double
    - 2-byte data
    - 4-byte int
    - 4-byte int
    Total: 28 bytes
    """
    results = []
    for i in range(0, len(data) - 27, 28):
        chunk = data[i:i+28]

        # Parse the 28-byte chunk
        val1 = struct.unpack('>d', chunk[0:8])[0]
        unk1 = chunk[8:10].hex()
        val2 = struct.unpack('>d', chunk[10:18])[0]
        unk2 = chunk[18:20].hex()
        int1 = struct.unpack('>I', chunk[20:24])[0]
        int2 = struct.unpack('>i', chunk[24:28])[0]

        results.append((val1, unk1, val2, unk2, int1, int2))
    return results

def try_variable_structure(data):
    """
    Try to find doubles at various alignments
    """
    print("\n  Scanning for valid doubles at all offsets:")
    found = []
    for i in range(len(data) - 7):
        val = try_double(data, i)
        if is_reasonable_leave(val):
            found.append((i, val))

    for i, val in found:
        print(f"    offset {i:3d}: {val:>12.6f}")
    return found

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

def main():
    print("=== MUL Resource Structure Decoding ===")

    # Load patterns for context
    patterns = parse_estr()
    print(f"\nLoaded {len(patterns)} patterns from ESTR")

    # Analyze MUL files
    for letter in ['a', 'e', 'i', 's', '?']:
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)
        print(f"\n{'='*60}")
        print(f"MUL{letter}: {len(data)} bytes")

        # Find all valid leave values
        found_doubles = try_variable_structure(data)

        # Count non-zero bytes to estimate data size
        non_zero_end = len(data)
        for i in range(len(data) - 1, -1, -1):
            if data[i] != 0:
                non_zero_end = i + 1
                break
        print(f"\n  Non-zero data ends at offset {non_zero_end}")

        # Group consecutive found doubles (they should be 10 bytes apart in 28-byte structure)
        print("\n  Looking for patterns in double locations:")
        if len(found_doubles) >= 2:
            for i in range(len(found_doubles) - 1):
                off1, val1 = found_doubles[i]
                off2, val2 = found_doubles[i+1]
                diff = off2 - off1
                print(f"    {off1:3d} -> {off2:3d}: diff={diff:3d}  ({val1:>10.4f}, {val2:>10.4f})")

    # Now let's try a simpler approach - just decode all reasonable doubles
    print("\n" + "="*60)
    print("Combined leave values across all MUL files:")
    print("="*60)

    all_values = []
    for letter in 'abcdefghijklmnopqrstuvwxyz?':
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)

        # Find all valid doubles
        letter_values = []
        for i in range(len(data) - 7):
            val = try_double(data, i)
            if is_reasonable_leave(val) and val != 0:
                letter_values.append((i, val))

        if letter_values:
            print(f"\n  MUL{letter}: {len(letter_values)} values")
            for off, val in letter_values[:8]:  # Show first 8
                print(f"    offset {off:3d}: {val:>10.4f}")
            all_values.extend([(letter, off, val) for off, val in letter_values])

    print(f"\n\nTotal leave values found: {len(all_values)}")

    # Show value distribution
    values_only = [v for _, _, v in all_values]
    if values_only:
        print(f"  Range: {min(values_only):.4f} to {max(values_only):.4f}")
        print(f"  Mean: {sum(values_only)/len(values_only):.4f}")

if __name__ == "__main__":
    main()
