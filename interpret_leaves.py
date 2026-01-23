#!/usr/bin/env python3
"""
Interpret Maven's leave values based on resource analysis.

Based on our analysis:
1. ESTR contains 130 pattern strings (?, ??, a, aa, aaa, etc.)
2. MUL resources contain floating-point data
3. EXPR contains additional experience/leave data

The MUL resources appear to store 8-byte IEEE doubles with additional metadata.
The structure seems to be: [8-byte double][2-byte data][8-byte double][2-byte data][4-byte count][4-byte count]
That's 28 bytes per entry.

Let's try to correlate patterns with values.
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
        val = struct.unpack('>d', data[offset:offset+8])[0]
        if val != val:  # NaN
            return None
        return val
    except:
        return None

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

def extract_doubles_at_offsets(data, offsets):
    """Extract doubles at specific offsets"""
    results = []
    for off in offsets:
        val = try_double(data, off)
        results.append(val)
    return results

def main():
    print("=== Maven Leave Value Interpretation ===\n")

    patterns = parse_estr()
    print(f"Found {len(patterns)} patterns in ESTR\n")

    # Group patterns by first letter to match with MUL resources
    patterns_by_letter = {}
    for p in patterns:
        if p.startswith('?'):
            key = '?'
        else:
            key = p[0]
        if key not in patterns_by_letter:
            patterns_by_letter[key] = []
        patterns_by_letter[key].append(p)

    print("Patterns by first letter:")
    for letter in sorted(patterns_by_letter.keys()):
        pats = patterns_by_letter[letter]
        print(f"  {letter}: {len(pats)} patterns - {pats[:3]}...")

    print("\n" + "="*60)
    print("Extracting leave values from MUL resources...")
    print("="*60)

    # For each letter, extract values from the corresponding MUL resource
    # Based on analysis, values appear at offsets 0, 10, 28, 38, 56, 66, 84, 94...
    # Pattern: 0, +10, +18, +10, +18, +10, +18, +10...
    value_offsets = [0, 10, 28, 38, 56, 66, 84, 94, 112, 122, 140, 150]

    all_leave_values = {}

    for letter in sorted(patterns_by_letter.keys()):
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)
        pats = patterns_by_letter[letter]

        print(f"\n{letter.upper() if letter != '?' else 'BLANK'}:")

        # Extract values at known offsets
        values = extract_doubles_at_offsets(data, value_offsets)

        # Pair patterns with values
        for i, (pat, val) in enumerate(zip(pats, values)):
            if val is not None and -100 < val < 100:
                # The values are all around 10-11 which doesn't match typical leaves
                # They might be base values or parameters, not direct leave values
                # Let's compute a "difference from baseline" as a heuristic
                baseline = 10.9  # approximate average
                adjusted = val - baseline

                all_leave_values[pat] = adjusted
                print(f"    '{pat:8s}': raw={val:+8.3f}  adjusted={adjusted:+7.3f}")
            else:
                print(f"    '{pat:8s}': --no valid value--")

    # Print summary of interpretations
    print("\n" + "="*60)
    print("INTERPRETATION:")
    print("="*60)
    print("""
The MUL values appear to be parameters for a statistical model,
not direct leave values. The raw values cluster around 10-11,
which suggests they might be:

1. Base contribution values that get combined
2. Parameters for a polynomial or lookup table
3. Mean values from simulation that need further processing

For typical Scrabble leave values, we'd expect:
- Blank: ~+25 to +30
- S: ~+8 to +10
- Common letters (E,T,R): ~0 to +3
- Q (without U): ~-10 or worse
- V, X, Z: ~-3 to -5

The adjusted values (raw - 10.9) give a rough ordering but
don't match the typical magnitude of leave values.
""")

    # Show adjusted values sorted
    print("\nAdjusted single-letter leaves (sorted):")
    single_letter = {k: v for k, v in all_leave_values.items() if len(k) == 1}
    for pat, val in sorted(single_letter.items(), key=lambda x: x[1], reverse=True):
        letter = 'BLANK' if pat == '?' else pat.upper()
        print(f"    {letter:5s}: {val:+7.3f}")

if __name__ == "__main__":
    main()
