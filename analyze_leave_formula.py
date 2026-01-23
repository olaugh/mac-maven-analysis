#!/usr/bin/env python3
"""
Analyze the relationship between MUL resource fields to determine leave value formula.

Based on CODE 32 analysis:
- 28-byte records per tile copy count
- Offset 0-7: IEEE 754 double (expected turn score with N copies)
- Offset 24-27: Signed int (loaded at instruction 0x156A)

The formula must explain why:
- Blank should be +25 points (not -5.15)
- Many tiles should have negative leave values
- Values should vary significantly across tiles

Hypothesis: Leave = offset0_double - 10.5 (baseline score)
Or: Leave = offset24_int / 100 is a delta, not the full value
"""
import struct
import os

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def decode_mul_record(data, offset):
    """Decode a 28-byte MUL record"""
    if offset + 28 > len(data):
        return None

    chunk = data[offset:offset+28]

    # Offset 0-7: double (expected score)
    d1 = struct.unpack('>d', chunk[0:8])[0]

    # Offset 8-15: secondary double (often garbage or unused)
    d2 = struct.unpack('>d', chunk[8:16])[0]

    # Offset 16-19: unsigned int (sample count)
    count = struct.unpack('>I', chunk[16:20])[0]

    # Offset 20-23: signed int (unknown)
    int1 = struct.unpack('>i', chunk[20:24])[0]

    # Offset 24-27: signed int (leave adjustment - used by CODE 32)
    int2 = struct.unpack('>i', chunk[24:28])[0]

    return {
        'expected_score': d1,
        'd2': d2,
        'sample_count': count,
        'int1': int1,
        'leave_adj': int2
    }

def analyze_tile(letter, data):
    """Analyze all records for a tile"""
    records = []
    for i in range(0, len(data) - 27, 28):
        rec = decode_mul_record(data, i)
        if rec and not (rec['expected_score'] != rec['expected_score']):  # Not NaN
            records.append((i // 28, rec))
    return records

def main():
    print("=" * 70)
    print("MUL LEAVE VALUE FORMULA ANALYSIS")
    print("=" * 70)

    # Standard tile distribution
    tile_counts = {
        'a': 9, 'b': 2, 'c': 2, 'd': 4, 'e': 12, 'f': 2, 'g': 3, 'h': 2,
        'i': 9, 'j': 1, 'k': 1, 'l': 4, 'm': 2, 'n': 6, 'o': 8, 'p': 2,
        'q': 1, 'r': 6, 's': 4, 't': 6, 'u': 4, 'v': 2, 'w': 2, 'x': 1,
        'y': 2, 'z': 1, '?': 2
    }

    # Known expected leave values (from Quackle/literature, rough values)
    expected_leaves = {
        '?': 25.0,   # Blank is most valuable
        's': 8.0,    # S is very valuable
        'x': 4.0,    # X is valuable
        'z': 3.0,    # Z is decent
        'e': 2.0,    # Vowels vary
        'a': 0.0,    # A is neutral
        'i': -1.0,   # I slightly negative
        'u': -4.0,   # U is bad
        'o': -1.0,   # O slightly negative
        'v': -6.0,   # V is bad
        'w': -3.0,   # W is bad
        'q': -15.0,  # Q is terrible
    }

    print("\n" + "-" * 70)
    print("Record 0 (having 1 copy of tile) for each tile type")
    print("-" * 70)
    print(f"{'Tile':>5} {'Exp.Score':>10} {'LeaveAdj':>10} {'Adj/100':>10} {'Score-10.5':>10}")
    print("-" * 70)

    all_results = []

    for letter in '?abcdefghijklmnopqrstuvwxyz':
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)
        records = analyze_tile(letter, data)

        if not records:
            continue

        # Record 0 = having 1 copy of this tile
        _, rec = records[0]

        display = 'BLANK' if letter == '?' else letter.upper()
        exp_score = rec['expected_score']
        leave_adj = rec['leave_adj']
        adj_points = leave_adj / 100.0  # centipoints to points
        score_minus_baseline = exp_score - 10.5  # Subtract average turn score

        all_results.append({
            'tile': display,
            'letter': letter,
            'expected_score': exp_score,
            'leave_adj': leave_adj,
            'adj_points': adj_points,
            'diff_baseline': score_minus_baseline
        })

        print(f"{display:>5} {exp_score:>10.3f} {leave_adj:>10} {adj_points:>10.2f} {score_minus_baseline:>10.2f}")

    print("\n" + "=" * 70)
    print("FORMULA HYPOTHESIS TESTING")
    print("=" * 70)

    # Test hypothesis 1: Leave = expected_score - 10.5
    print("\nHypothesis 1: Leave = expected_score - 10.5 (baseline)")
    print("-" * 50)
    for r in all_results[:10]:
        h1_leave = r['expected_score'] - 10.5
        expected = expected_leaves.get(r['letter'], '?')
        match = "?" if expected == '?' else ("OK" if abs(h1_leave - expected) < 5 else "BAD")
        print(f"  {r['tile']:>5}: {h1_leave:>+8.2f}  (expected ~{expected})")

    # Test hypothesis 2: Leave = leave_adj / 100
    print("\nHypothesis 2: Leave = leave_adj / 100 (centipoints)")
    print("-" * 50)
    for r in all_results[:10]:
        h2_leave = r['leave_adj'] / 100.0
        expected = expected_leaves.get(r['letter'], '?')
        match = "?" if expected == '?' else ("OK" if abs(h2_leave - expected) < 5 else "BAD")
        print(f"  {r['tile']:>5}: {h2_leave:>+8.2f}  (expected ~{expected})")

    # Test hypothesis 3: Leave = expected_score - leave_adj/100
    print("\nHypothesis 3: Leave = expected_score - leave_adj/100")
    print("-" * 50)
    for r in all_results[:10]:
        h3_leave = r['expected_score'] - (r['leave_adj'] / 100.0)
        expected = expected_leaves.get(r['letter'], '?')
        print(f"  {r['tile']:>5}: {h3_leave:>+8.2f}  (expected ~{expected})")

    # Test hypothesis 4: Leave = expected_score + leave_adj/100 - 21
    print("\nHypothesis 4: Leave = expected_score + leave_adj/100 - 21 (double baseline)")
    print("-" * 50)
    for r in all_results[:10]:
        h4_leave = r['expected_score'] + (r['leave_adj'] / 100.0) - 21.0
        expected = expected_leaves.get(r['letter'], '?')
        print(f"  {r['tile']:>5}: {h4_leave:>+8.2f}  (expected ~{expected})")

    # Look at first 3 records for blank to understand progression
    print("\n" + "=" * 70)
    print("BLANK (?) - Multiple copy counts")
    print("=" * 70)

    mul_path = os.path.join(RESOURCES_DIR, "MUL?", "0_0.bin")
    if os.path.exists(mul_path):
        data = read_file(mul_path)
        records = analyze_tile('?', data)

        print(f"{'Copies':>6} {'Exp.Score':>10} {'SampleCnt':>10} {'Int1':>10} {'LeaveAdj':>10}")
        print("-" * 50)
        for idx, rec in records[:5]:
            copies = idx + 1
            print(f"{copies:>6} {rec['expected_score']:>10.3f} {rec['sample_count']:>10} {rec['int1']:>10} {rec['leave_adj']:>10}")

    # Look at S tile (known to be valuable)
    print("\n" + "=" * 70)
    print("S TILE - Multiple copy counts")
    print("=" * 70)

    mul_path = os.path.join(RESOURCES_DIR, "MULs", "0_0.bin")
    if os.path.exists(mul_path):
        data = read_file(mul_path)
        records = analyze_tile('s', data)

        print(f"{'Copies':>6} {'Exp.Score':>10} {'SampleCnt':>10} {'Int1':>10} {'LeaveAdj':>10}")
        print("-" * 50)
        for idx, rec in records[:5]:
            copies = idx + 1
            print(f"{copies:>6} {rec['expected_score']:>10.3f} {rec['sample_count']:>10} {rec['int1']:>10} {rec['leave_adj']:>10}")

    # Look at Q tile (known to be bad)
    print("\n" + "=" * 70)
    print("Q TILE - Should be negative leave")
    print("=" * 70)

    mul_path = os.path.join(RESOURCES_DIR, "MULq", "0_0.bin")
    if os.path.exists(mul_path):
        data = read_file(mul_path)
        records = analyze_tile('q', data)

        print(f"{'Copies':>6} {'Exp.Score':>10} {'SampleCnt':>10} {'Int1':>10} {'LeaveAdj':>10}")
        print("-" * 50)
        for idx, rec in records[:3]:
            copies = idx + 1
            print(f"{copies:>6} {rec['expected_score']:>10.3f} {rec['sample_count']:>10} {rec['int1']:>10} {rec['leave_adj']:>10}")

    # Summary sorted by expected leave
    print("\n" + "=" * 70)
    print("ALL TILES - Sorted by expected_score")
    print("=" * 70)

    sorted_results = sorted(all_results, key=lambda x: x['expected_score'], reverse=True)
    print(f"{'Tile':>5} {'Exp.Score':>10} {'LeaveAdj':>10} {'Adj/100':>10}")
    print("-" * 40)
    for r in sorted_results:
        print(f"{r['tile']:>5} {r['expected_score']:>10.3f} {r['leave_adj']:>10} {r['adj_points']:>10.2f}")

if __name__ == "__main__":
    main()
