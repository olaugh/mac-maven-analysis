#!/usr/bin/env python3
"""
Correlate ESTR patterns with MUL values.
The ESTR contains pattern strings, and MUL resources contain leave values for those patterns.
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

def try_double(data, offset):
    """Decode as IEEE 754 double (big-endian)"""
    if offset + 8 > len(data):
        return None
    try:
        val = struct.unpack('>d', data[offset:offset+8])[0]
        if val != val:  # NaN check
            return None
        return val
    except:
        return None

def extract_meaningful_values(data, max_values=20):
    """Extract meaningful leave values from MUL data"""
    values = []
    i = 0
    while i < len(data) - 7 and len(values) < max_values:
        val = try_double(data, i)
        if val is not None and -100 < val < 100 and abs(val) > 0.001:
            # Check if this is a unique value (not overlapping with previous)
            if not values or i >= values[-1][0] + 8:
                values.append((i, val))
        i += 1
    return values

def main():
    print("=== Pattern-Value Correlation Analysis ===")
    print()

    # Parse all patterns
    patterns = parse_estr()
    print(f"Total patterns in ESTR: {len(patterns)}")
    print()

    # Categorize patterns
    categories = {
        'blanks': [],
        'single_letter': [],
        'multiples': [],
        'q_patterns': [],
        'word_fragments': [],
        'letter_groups': [],
        'other': []
    }

    for p in patterns:
        if p.startswith('?'):
            categories['blanks'].append(p)
        elif len(p) == 1:
            categories['single_letter'].append(p)
        elif len(set(p)) == 1 and len(p) > 1:
            categories['multiples'].append(p)
        elif 'q' in p and 'u' not in p:
            categories['q_patterns'].append(p)
        elif len(p) >= 3 and all(c.islower() for c in p):
            # Could be word fragment or letter group
            # If it contains common suffixes like 'ing', 'ery', etc., it's a fragment
            if any(frag in p for frag in ['in', 'ly', 'ty', 'su', 'tu', 'ry', 'oy', 'el', 'ss']):
                categories['word_fragments'].append(p)
            else:
                categories['letter_groups'].append(p)
        else:
            categories['other'].append(p)

    print("Pattern categories:")
    for cat, pats in categories.items():
        print(f"  {cat}: {len(pats)} patterns")
        if pats:
            print(f"    Examples: {pats[:5]}")
    print()

    # Show Q patterns specifically (these should have penalties)
    print("="*60)
    print("Q patterns (without U) - should have negative leave values:")
    print("="*60)
    for p in categories['q_patterns']:
        print(f"  '{p}'")

    # Show letter groups
    print()
    print("="*60)
    print("Letter group patterns:")
    print("="*60)
    for p in patterns[-15:]:  # Last patterns tend to be groups
        print(f"  '{p}'")

    # Now try to match patterns to values
    print()
    print("="*60)
    print("Attempting pattern-value correlation:")
    print("="*60)

    # The MUL files might be per first-letter or contain all values
    # Let's look at a global perspective

    # Check if there's a master MUL file or if we need to combine them
    all_mul_values = {}

    for letter in '?abcdefghijklmnopqrstuvwxyz':
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if os.path.exists(mul_path):
            data = read_file(mul_path)
            values = extract_meaningful_values(data)
            all_mul_values[letter] = values

    # Now try to find patterns that match each letter's MUL
    print()
    for letter in '?aeioqsxz':  # Focus on interesting letters
        display = 'BLANK' if letter == '?' else letter.upper()
        print(f"\n{display}:")

        # Find patterns containing this letter
        letter_patterns = [p for p in patterns if letter in p]
        print(f"  Patterns containing '{letter}': {len(letter_patterns)}")
        for p in letter_patterns[:8]:
            print(f"    '{p}'")

        # Show MUL values
        if letter in all_mul_values:
            print(f"  MUL{letter} values:")
            for off, val in all_mul_values[letter][:8]:
                print(f"    offset {off:3d}: {val:>+10.4f}")

    # Try to figure out the mapping
    print()
    print("="*60)
    print("Hypothesis: Each MUL entry corresponds to a specific pattern")
    print("="*60)

    # For 'a', the patterns are: a, aa, aaa, aaaa, aaaaa, plus combos
    a_patterns = [p for p in patterns if p[0] == 'a'] if patterns else []
    print(f"\nPatterns starting with 'a': {len(a_patterns)}")
    for i, p in enumerate(a_patterns[:15]):
        print(f"  {i}: '{p}'")

    if 'a' in all_mul_values:
        print(f"\nMULa has {len(all_mul_values['a'])} significant values")
        # Try to correlate
        for i, (off, val) in enumerate(all_mul_values['a'][:len(a_patterns)]):
            if i < len(a_patterns):
                print(f"  Pattern '{a_patterns[i]:8s}' -> value: {val:>+10.4f}")

    # Do same for Q (should have penalties for Q without U)
    print()
    print("="*60)
    print("Q analysis (Q without U should be penalized):")
    print("="*60)

    q_patterns = [p for p in patterns if 'q' in p]
    print(f"\nPatterns with 'q': {q_patterns}")

    if 'q' in all_mul_values:
        print(f"\nMULq values:")
        for off, val in all_mul_values['q']:
            print(f"  offset {off:3d}: {val:>+10.4f}")

if __name__ == "__main__":
    main()
