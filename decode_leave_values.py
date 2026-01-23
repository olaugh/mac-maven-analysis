#!/usr/bin/env python3
"""
Decode Maven's leave value heuristics from the ESTR and MUL resources.

The leave values represent how good it is to keep certain tile combinations
after making a play. Higher values = better tiles to keep.

ESTR resource: Contains pattern strings
MUL* resources: Contains floating point values for each pattern
"""
import struct
import os

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def decode_80bit_float(data):
    """
    Decode Macintosh 80-bit extended precision float.
    Format: 1 sign, 15 exponent, 64 mantissa (no hidden bit)
    """
    if len(data) != 10:
        return None

    # Unpack as big-endian
    exp_sign = struct.unpack('>H', data[0:2])[0]
    mantissa = struct.unpack('>Q', data[2:10])[0]

    sign = (exp_sign >> 15) & 1
    exponent = exp_sign & 0x7FFF

    if exponent == 0:
        # Zero or denormal
        if mantissa == 0:
            return 0.0
        # Denormal - simplified handling
        return 0.0

    if exponent == 0x7FFF:
        # Infinity or NaN
        if mantissa == 0:
            return float('inf') if sign == 0 else float('-inf')
        return float('nan')

    # Normal number
    # Bias is 16383 for 80-bit extended
    actual_exp = exponent - 16383

    # Prevent overflow for very large/small exponents
    if actual_exp > 1000 or actual_exp < -1000:
        return float('inf') if actual_exp > 0 else 0.0

    # The mantissa in 80-bit has an explicit integer bit
    # so we don't add 1.0 like in IEEE 754
    try:
        frac = mantissa / (2**63)
        value = frac * (2 ** actual_exp)
        if sign:
            value = -value
        return value
    except (OverflowError, ValueError):
        return float('nan')

def parse_estr():
    """Parse the ESTR (pattern strings) resource"""
    estr_path = os.path.join(RESOURCES_DIR, "ESTR", "0_pattern_strings.bin")
    data = read_file(estr_path)

    patterns = []
    current = ""

    for byte in data:
        if byte == 0:  # Null terminator
            if current:
                patterns.append(current)
            current = ""
        else:
            current += chr(byte)

    if current:
        patterns.append(current)

    return patterns

def parse_mul_resource(letter):
    """Parse a MUL resource for a specific letter"""
    if letter == '?':
        filename = "0_0.bin"
    else:
        filename = "0_0.bin"

    mul_dir = f"MUL{letter}"
    mul_path = os.path.join(RESOURCES_DIR, mul_dir, filename)

    if not os.path.exists(mul_path):
        return None

    data = read_file(mul_path)

    # Each entry is 16 bytes: 10-byte float + 6 bytes unknown
    # Based on the 224-byte size, that's 14 entries per resource
    values = []

    # Try different interpretations
    # Interpretation 1: 10-byte floats followed by 4-byte integers
    for i in range(0, len(data), 16):
        if i + 16 > len(data):
            break

        float_bytes = data[i:i+10]
        extra_bytes = data[i+10:i+16]

        value = decode_80bit_float(float_bytes)
        extra = struct.unpack('>HHH', extra_bytes) if len(extra_bytes) == 6 else (0, 0, 0)

        values.append({
            'value': value,
            'extra': extra,
            'raw': data[i:i+16].hex()
        })

    return values

def main():
    print("=== Maven Leave Value Analysis ===\n")

    # Parse pattern strings
    patterns = parse_estr()
    print(f"Found {len(patterns)} patterns in ESTR resource:")
    for i, p in enumerate(patterns[:30]):
        print(f"  {i:3d}: '{p}'")
    if len(patterns) > 30:
        print(f"  ... and {len(patterns) - 30} more")

    print("\n" + "="*50)

    # Parse MUL resources
    print("\nMUL resource values (80-bit floats):")

    for letter in ['?', 'a', 'e', 'i', 'o', 's', 't']:
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")

        if os.path.exists(mul_path):
            values = parse_mul_resource(letter)
            print(f"\n  MUL{letter}:")
            for i, v in enumerate(values[:5]):
                if v['value'] is not None:
                    print(f"    {i}: {v['value']:.6f}  (raw: {v['raw'][:20]}...)")

    print("\n" + "="*50)

    # Parse EXPR resource
    print("\nEXPR (experience) resource:")
    expr_path = os.path.join(RESOURCES_DIR, "EXPR")
    if os.path.exists(expr_path):
        for f in os.listdir(expr_path):
            if f.endswith('.bin'):
                data = read_file(os.path.join(expr_path, f))
                print(f"  {f}: {len(data)} bytes")

                # Try to decode as 80-bit floats
                print("  Sample values:")
                for i in range(0, min(len(data), 60), 10):
                    if i + 10 <= len(data):
                        val = decode_80bit_float(data[i:i+10])
                        print(f"    offset {i}: {val:.6f}")

    # Create summary of leave patterns with typical values
    print("\n" + "="*50)
    print("\nLeave Value Summary:")
    print("-"*50)

    # Common patterns and their likely meanings
    pattern_explanations = {
        '?': 'Blank tile',
        'aeiou': 'All vowels',
        'ee': 'Double E',
        's': 'Single S (good for hooks)',
        'ss': 'Double S',
        'ing': 'ING combo',
        'tion': 'TION suffix',
        'qu': 'QU combo',
    }

    print("\nPattern interpretations:")
    for pattern, meaning in pattern_explanations.items():
        if pattern in patterns:
            idx = patterns.index(pattern)
            print(f"  '{pattern}' (idx {idx}): {meaning}")

if __name__ == "__main__":
    main()
