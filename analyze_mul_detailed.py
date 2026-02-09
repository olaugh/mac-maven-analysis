#!/usr/bin/env python3
"""
Detailed analysis of MUL resource record format.

Tests multiple hypotheses:
1. Current: 8 records × 28 bytes (8B double + 8B double + 4B uint32 + 4B int32 + 4B int32)
2. SANE: 8 records × 28 bytes (10B SANE ext + 10B SANE ext + 4B int32 + 4B int32)
3. Hybrid: 8 records × 28 bytes (8B double + 10B SANE ext + 4B int32 + 2B int16 + 4B int32)
"""
import struct
import os

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def decode_ieee_double(data):
    """Big-endian IEEE 754 double."""
    return struct.unpack('>d', data)[0]

def decode_sane_extended(data):
    """10-byte SANE extended precision (big-endian)."""
    if len(data) != 10:
        return None
    exp_sign = struct.unpack('>H', data[0:2])[0]
    mantissa = struct.unpack('>Q', data[2:10])[0]
    sign = (exp_sign >> 15) & 1
    exponent = exp_sign & 0x7FFF
    if exponent == 0:
        return 0.0
    if exponent == 0x7FFF:
        return float('inf') if mantissa == 0 else float('nan')
    actual_exp = exponent - 16383
    if actual_exp > 1000:
        return float('inf')
    if actual_exp < -1000:
        return 0.0
    try:
        frac = mantissa / (2**63)
        value = frac * (2 ** actual_exp)
        return -value if sign else value
    except (OverflowError, ValueError):
        return float('nan')

def is_reasonable(val, low=-100, high=100):
    """Check if value is in reasonable leave-value range."""
    if val is None:
        return False
    try:
        return low < val < high
    except:
        return False

def analyze_record_28byte_current(data, idx):
    """Current hypothesis: 8B dbl + 8B dbl + 4B uint32 + 4B int32 + 4B int32"""
    off = idx * 28
    rec = data[off:off+28]
    d1 = decode_ieee_double(rec[0:8])
    d2 = decode_ieee_double(rec[8:16])
    u1 = struct.unpack('>I', rec[16:20])[0]
    i1 = struct.unpack('>i', rec[20:24])[0]
    i2 = struct.unpack('>i', rec[24:28])[0]
    return {'double1': d1, 'double2': d2, 'uint32': u1, 'int32_1': i1, 'int32_2': i2}

def analyze_record_28byte_sane(data, idx):
    """SANE hypothesis: 10B ext + 10B ext + 4B int32 + 4B int32"""
    off = idx * 28
    rec = data[off:off+28]
    s1 = decode_sane_extended(rec[0:10])
    s2 = decode_sane_extended(rec[10:20])
    i1 = struct.unpack('>i', rec[20:24])[0]
    i2 = struct.unpack('>i', rec[24:28])[0]
    return {'sane1': s1, 'sane2': s2, 'int32_1': i1, 'int32_2': i2}

def analyze_record_28byte_hybrid(data, idx):
    """Hybrid: 8B dbl + 10B SANE ext + 4B uint32 + 2B pad + 4B int32"""
    off = idx * 28
    rec = data[off:off+28]
    d1 = decode_ieee_double(rec[0:8])
    s1 = decode_sane_extended(rec[8:18])
    u1 = struct.unpack('>I', rec[18:22])[0]
    i1 = struct.unpack('>i', rec[24:28])[0]
    return {'double1': d1, 'sane1': s1, 'uint32': u1, 'int32': i1}

def analyze_record_28byte_v4(data, idx):
    """V4: 8B dbl + 8B dbl + 4B uint32 + 4B int32 + 4B int32 (same as current but check all int interpretations)"""
    off = idx * 28
    rec = data[off:off+28]
    d1 = decode_ieee_double(rec[0:8])
    d2 = decode_ieee_double(rec[8:16])
    u1 = struct.unpack('>I', rec[16:20])[0]
    i1 = struct.unpack('>i', rec[20:24])[0]
    i2 = struct.unpack('>i', rec[24:28])[0]
    # Also try reading the middle bytes differently
    u2 = struct.unpack('>I', rec[20:24])[0]
    return {'double1': d1, 'double2': d2, 'field3_uint': u1, 'field4_int': i1, 'field4_uint': u2, 'field5_adj': i2}


def main():
    # Reference leave values (known from previous analysis, centipoints)
    known_adj = {
        '?': [None, 2440, None, None, None, None, None, None],  # blank
        's': [None, 721, None, None, None, None, None, None],
        'e': [None, 299, None, None, None, None, None, None],
        'a': [None, 220, None, None, None, None, None, None],
        'q': [None, -879, None, None, None, None, None, None],
    }

    for letter in ['?', 'a', 'e', 's', 'q', 'x', 'z', 'b', 'v']:
        mul_path = os.path.join(RESOURCES_DIR, f"MUL{letter}", "0_0.bin")
        if not os.path.exists(mul_path):
            continue
        data = read_file(mul_path)
        display = 'BLANK' if letter == '?' else letter.upper()
        print(f"\n{'='*80}")
        print(f"MUL{letter} ({display}) - {len(data)} bytes = 8 records × 28 bytes")
        print(f"{'='*80}")

        print(f"\n  {'Rec':>3} | {'d1 (IEEE)':>12} | {'d2 (IEEE)':>12} | {'uint32':>10} | {'int32_1':>10} | {'adj (i32)':>10}")
        print(f"  {'---':>3}-+-{'-'*12}-+-{'-'*12}-+-{'-'*10}-+-{'-'*10}-+-{'-'*10}")
        for i in range(8):
            r = analyze_record_28byte_current(data, i)
            d1_ok = "✓" if is_reasonable(r['double1']) else " "
            d2_ok = "✓" if is_reasonable(r['double2']) else " "
            adj = r['int32_2']
            print(f"  [{i}] | {r['double1']:>11.4f}{d1_ok} | {r['double2']:>11.4f}{d2_ok} | {r['uint32']:>10d} | {r['int32_1']:>10d} | {adj:>10d}")

        # Now try SANE interpretation
        print(f"\n  SANE hypothesis:")
        print(f"  {'Rec':>3} | {'s1 (SANE)':>12} | {'s2 (SANE)':>12} | {'int32_1':>10} | {'adj (i32)':>10}")
        print(f"  {'---':>3}-+-{'-'*12}-+-{'-'*12}-+-{'-'*10}-+-{'-'*10}")
        for i in range(8):
            r = analyze_record_28byte_sane(data, i)
            s1_ok = "✓" if is_reasonable(r['sane1']) else " "
            s2_ok = "✓" if is_reasonable(r['sane2']) else " "
            print(f"  [{i}] | {r['sane1']:>11.4f}{s1_ok} | {r['sane2']:>11.4f}{s2_ok} | {r['int32_1']:>10d} | {r['int32_2']:>10d}")

        # Raw hex dump of first 2 records
        print(f"\n  Raw hex (records 0-1):")
        for i in range(min(2, len(data) // 28)):
            off = i * 28
            rec = data[off:off+28]
            print(f"  [{i}] {rec.hex()}")
            print(f"      [0:8]={rec[0:8].hex()} [8:16]={rec[8:16].hex()} [16:20]={rec[16:20].hex()} [20:24]={rec[20:24].hex()} [24:28]={rec[24:28].hex()}")

    # Special analysis: check if field at [8:16] makes sense as SANE at [8:18]
    print(f"\n\n{'='*80}")
    print(f"Testing SANE interpretation of bytes [8:18] (10-byte window):")
    print(f"{'='*80}")
    for letter in ['?', 'a', 'e', 's', 'q']:
        mul_path = os.path.join(RESOURCES_DIR, f"MUL{letter}", "0_0.bin")
        if not os.path.exists(mul_path):
            continue
        data = read_file(mul_path)
        display = 'BLANK' if letter == '?' else letter.upper()
        print(f"\n  MUL{letter} ({display}):")
        for i in range(8):
            off = i * 28
            # Try SANE at offset 8 (bytes 8-17 of record)
            sane_val = decode_sane_extended(data[off+8:off+18])
            # What's left at bytes 18-27: 10 bytes
            remaining = data[off+18:off+28]
            # Try reading remaining as: uint32 + int16 + int32
            if len(remaining) >= 10:
                u1 = struct.unpack('>I', remaining[0:4])[0]
                h1 = struct.unpack('>h', remaining[4:6])[0]
                i1 = struct.unpack('>i', remaining[6:10])[0]
                sane_ok = "✓" if is_reasonable(sane_val) else " "
                print(f"  [{i}] SANE[8:18]={sane_val:>11.4f}{sane_ok}  remaining: uint32={u1:>10d} int16={h1:>6d} int32={i1:>10d}")

    # Check all records across all letters for consistency of field 3 (uint32) as sample count
    print(f"\n\n{'='*80}")
    print(f"Field consistency check across all MUL resources:")
    print(f"{'='*80}")
    print(f"\n  Check if field3 (offset 16-19) looks like a sample count:")
    for letter in '?abcdefghijklmnopqrstuvwxyz':
        mul_path = os.path.join(RESOURCES_DIR, f"MUL{letter}", "0_0.bin")
        if not os.path.exists(mul_path):
            continue
        data = read_file(mul_path)
        display = 'BLANK' if letter == '?' else letter.upper()
        counts = []
        for i in range(8):
            off = i * 28
            u1 = struct.unpack('>I', data[off+16:off+20])[0]
            counts.append(u1)
        # Check if monotonically reasonable (lower counts have larger tile counts)
        print(f"  MUL{letter} ({display}): {counts}")

if __name__ == "__main__":
    main()
