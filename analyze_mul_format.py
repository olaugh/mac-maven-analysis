#!/usr/bin/env python3
"""
Analyze MUL resource format to determine if values are floating point or fixed-point.
"""
import struct
import os

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def try_ieee_double(data, offset):
    """Decode as IEEE 754 double (big-endian)"""
    if offset + 8 > len(data):
        return None
    return struct.unpack('>d', data[offset:offset+8])[0]

def try_80bit_float(data, offset):
    """Decode as 80-bit extended precision float"""
    if offset + 10 > len(data):
        return None

    exp_sign = struct.unpack('>H', data[offset:offset+2])[0]
    mantissa = struct.unpack('>Q', data[offset+2:offset+10])[0]

    sign = (exp_sign >> 15) & 1
    exponent = exp_sign & 0x7FFF

    if exponent == 0:
        return 0.0
    if exponent == 0x7FFF:
        return float('nan')

    actual_exp = exponent - 16383
    if abs(actual_exp) > 1000:
        return float('inf') if actual_exp > 0 else 0.0

    try:
        frac = mantissa / (2**63)
        value = frac * (2 ** actual_exp)
        return -value if sign else value
    except:
        return float('nan')

def try_fixed_point(data, offset, scale=100):
    """Decode as fixed-point integer (value * scale)"""
    if offset + 2 > len(data):
        return None
    val = struct.unpack('>h', data[offset:offset+2])[0]  # signed 16-bit
    return val / scale

def try_fixed_point_32(data, offset, scale=1000):
    """Decode as 32-bit fixed-point integer"""
    if offset + 4 > len(data):
        return None
    val = struct.unpack('>i', data[offset:offset+4])[0]  # signed 32-bit
    return val / scale

def analyze_mul_file(filepath):
    """Analyze a MUL resource file"""
    data = read_file(filepath)
    print(f"\n{'='*60}")
    print(f"File: {filepath}")
    print(f"Size: {len(data)} bytes")

    print("\n--- Interpretation 1: 8-byte IEEE doubles ---")
    print("(Leave values typically range from -30 to +30)")
    doubles = []
    for i in range(0, len(data), 8):
        val = try_ieee_double(data, i)
        if val is not None:
            # Check if it's a reasonable leave value
            reasonable = "✓" if -50 < val < 50 else "?"
            doubles.append(val)
            print(f"  offset {i:3d}: {val:>15.6f} {reasonable}")

    print("\n--- Interpretation 2: Pairs of 8-byte doubles (value, count/weight?) ---")
    for i in range(0, len(data), 16):
        val1 = try_ieee_double(data, i)
        val2 = try_ieee_double(data, i+8)
        if val1 is not None and val2 is not None:
            r1 = "✓" if -50 < val1 < 50 else "?"
            r2 = "✓" if -50 < val2 < 50 else "?"
            print(f"  offset {i:3d}: ({val1:>12.4f} {r1}, {val2:>12.4f} {r2})")

    print("\n--- Interpretation 3: 10-byte extended + 6-byte data ---")
    for i in range(0, len(data), 16):
        val = try_80bit_float(data, i)
        if val is not None and i + 16 <= len(data):
            extra = data[i+10:i+16]
            extra_hex = extra.hex()
            r = "✓" if -50 < val < 50 else "?"
            print(f"  offset {i:3d}: {val:>15.6f} {r}  extra: {extra_hex}")

    print("\n--- Interpretation 4: 16-bit fixed point (x100) ---")
    for i in range(0, min(len(data), 64), 2):
        val = try_fixed_point(data, i, 100)
        if val is not None:
            reasonable = "✓" if -50 < val < 50 else ""
            print(f"  offset {i:3d}: {val:>10.2f} {reasonable}")

    print("\n--- Interpretation 5: 32-bit fixed point (x1000) ---")
    for i in range(0, min(len(data), 64), 4):
        val = try_fixed_point_32(data, i, 1000)
        if val is not None:
            reasonable = "✓" if -50 < val < 50 else ""
            print(f"  offset {i:3d}: {val:>15.3f} {reasonable}")

    # Also look for patterns in the raw data
    print("\n--- Raw hex pattern analysis ---")
    for i in range(0, min(len(data), 160), 16):
        chunk = data[i:i+16]
        hex_str = ' '.join(f'{b:02x}' for b in chunk)
        print(f"  {i:3d}: {hex_str}")

    return doubles

def main():
    print("=== MUL Resource Format Analysis ===")
    print("Trying to determine if leave values are floating point or fixed-point")

    # Analyze several MUL files
    for letter in ['a', 'e', 's', '?']:
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if os.path.exists(mul_path):
            analyze_mul_file(mul_path)

    # Also analyze EXPR
    expr_dir = os.path.join(RESOURCES_DIR, "EXPR")
    if os.path.exists(expr_dir):
        for f in os.listdir(expr_dir):
            if f.endswith('.bin') and not f.startswith('._'):
                print(f"\n{'='*60}")
                print(f"EXPR file: {f}")
                data = read_file(os.path.join(expr_dir, f))
                print(f"Size: {len(data)} bytes")

                print("\nAs IEEE doubles:")
                for i in range(0, min(len(data), 96), 8):
                    val = try_ieee_double(data, i)
                    if val is not None:
                        r = "✓" if -50 < val < 50 else "?"
                        print(f"  offset {i:3d}: {val:>15.6f} {r}")

if __name__ == "__main__":
    main()
