#!/usr/bin/env python3
"""
Maven Leave Value Evaluator

Interactive REPL for evaluating Scrabble rack leaves using Maven's MUL resources.

Usage:
    python3 leave_eval.py

Then enter leaves like: AEINST, QUU, SATIRE?, etc.
Use ? for blank tiles.
"""

import os
import struct
import readline  # for history/editing in REPL

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

# MUL record format (28 bytes):
#   0-7:   double  - expected turn score (simulation result)
#   8-15:  double  - secondary value (possibly variance)
#   16-19: uint32  - sample count
#   20-23: int32   - unknown
#   24-27: int32   - leave adjustment (centipoints, used at runtime)
RECORD_SIZE = 28

class MULData:
    """Parsed MUL resource data for a single tile type."""
    def __init__(self, tile, records):
        self.tile = tile
        self.records = records  # list of dicts, indexed by count

    def get_leave_value(self, count):
        """Get leave adjustment for having 'count' of this tile."""
        if count < 0 or count >= len(self.records):
            return 0
        return self.records[count]['leave_adj']

    def get_expected_score(self, count):
        """Get expected turn score for having 'count' of this tile."""
        if count < 0 or count >= len(self.records):
            return 0.0
        return self.records[count]['expected_score']


def parse_mul_file(filepath):
    """Parse a MUL resource file into records."""
    with open(filepath, 'rb') as f:
        data = f.read()

    records = []
    num_records = len(data) // RECORD_SIZE

    for i in range(num_records):
        offset = i * RECORD_SIZE
        rec = data[offset:offset + RECORD_SIZE]

        # Parse fields (big-endian for 68000)
        expected_score = struct.unpack('>d', rec[0:8])[0]
        secondary_val = struct.unpack('>d', rec[8:16])[0]
        sample_count = struct.unpack('>I', rec[16:20])[0]
        unknown = struct.unpack('>i', rec[20:24])[0]
        leave_adj = struct.unpack('>i', rec[24:28])[0]

        records.append({
            'count': i,
            'expected_score': expected_score,
            'secondary_val': secondary_val,
            'sample_count': sample_count,
            'unknown': unknown,
            'leave_adj': leave_adj,
        })

    return records


def load_all_mul_resources():
    """Load all MUL resources into a dictionary."""
    mul_data = {}

    # Map directory names to tile characters
    for dirname in os.listdir(RESOURCES_DIR):
        if dirname.startswith('MUL') and not dirname.startswith('._'):
            tile_char = dirname[3:]  # Everything after "MUL"
            if tile_char == '?':
                tile = '?'  # Blank
            elif len(tile_char) == 1 and tile_char.isalpha():
                tile = tile_char.upper()
            else:
                continue

            filepath = os.path.join(RESOURCES_DIR, dirname, '0_0.bin')
            if os.path.exists(filepath):
                try:
                    records = parse_mul_file(filepath)
                    mul_data[tile] = MULData(tile, records)
                except Exception as e:
                    print(f"Warning: Failed to load {dirname}: {e}")

    return mul_data


def count_tiles(leave):
    """Count occurrences of each tile in a leave string."""
    counts = {}
    for char in leave.upper():
        if char == '?' or char.isalpha():
            tile = char if char == '?' else char.upper()
            counts[tile] = counts.get(tile, 0) + 1
    return counts


# Synergy adjustments (centipoints) - approximations based on ESTR patterns
# These modify the raw sum when certain tile combinations are present
# Positive = bonus for having these together, negative = penalty
SYNERGIES = {
    # Q+U synergy: Q is much better with U present
    ('Q', 'U'): 1100,  # ~+11 pts bonus for Q+U together

    # Vowel heavy penalties (from ESTR patterns like "uu", "ii", etc.)
    ('U', 'U'): -200,   # Two U's is worse than sum suggests
    ('I', 'I'): -150,   # Two I's slightly bad
    ('O', 'O'): -100,   # Two O's slightly bad

    # Good consonant combinations
    ('S', 'T'): 50,     # S+T work well together
    ('E', 'R'): 50,     # E+R common ending
    ('I', 'N'): 50,     # I+N common
    ('E', 'D'): 50,     # E+D past tense

    # Awkward combinations
    ('V', 'V'): -300,   # Two V's very bad
    ('W', 'W'): -200,   # Two W's bad
    ('Q', 'Q'): -500,   # Can't happen in standard set, but very bad
}


def calculate_synergies(counts):
    """
    Calculate synergy adjustments based on tile combinations.
    Returns (adjustment, breakdown) where adjustment is centipoints
    and breakdown is a list of (description, value) tuples.
    """
    adjustment = 0
    breakdown = []
    tiles_present = set(counts.keys())

    # Pair synergies
    for (tile1, tile2), bonus in SYNERGIES.items():
        if tile1 == tile2:
            # Same tile - check if count >= 2
            if tile1 in counts and counts[tile1] >= 2:
                adjustment += bonus
                breakdown.append((f"{tile1}{tile1}", bonus))
        else:
            # Different tiles - check if both present
            if tile1 in tiles_present and tile2 in tiles_present:
                adjustment += bonus
                breakdown.append((f"{tile1}+{tile2}", bonus))

    # Vowel/consonant balance (from ESTR patterns)
    vowels = set('AEIOU')
    good_consonants = set('LNRST')  # "lnrtsu" pattern (minus U which is vowel)
    bad_consonants = set('FHKWVY')   # "fhkwvy" pattern

    vowel_count = sum(counts.get(v, 0) for v in vowels)
    total_tiles = sum(counts.values())

    # Vowel-heavy penalties (from "aeiou", "aeio" patterns)
    distinct_vowels = len([v for v in vowels if v in tiles_present])
    if distinct_vowels >= 5:
        penalty = -400  # All 5 vowels present
        adjustment += penalty
        breakdown.append(("5 vowels", penalty))
    elif distinct_vowels >= 4:
        penalty = -200  # 4 different vowels
        adjustment += penalty
        breakdown.append(("4 vowels", penalty))

    # Vowel ratio penalties (too vowel-heavy)
    if total_tiles >= 3:
        vowel_ratio = vowel_count / total_tiles
        if vowel_ratio > 0.6:
            penalty = -300  # More than 60% vowels
            adjustment += penalty
            breakdown.append(("vowel-heavy", penalty))
        elif vowel_ratio < 0.2 and total_tiles >= 4:
            penalty = -200  # Less than 20% vowels (consonant-heavy)
            adjustment += penalty
            breakdown.append(("consonant-heavy", penalty))

    # Good consonant bonus (having LNRST)
    good_cons_count = sum(1 for c in good_consonants if c in tiles_present)
    if good_cons_count >= 4:
        bonus = 150  # 4+ of the power consonants
        adjustment += bonus
        breakdown.append(("power consonants", bonus))
    elif good_cons_count >= 3:
        bonus = 75
        adjustment += bonus
        breakdown.append(("good consonants", bonus))

    # Bad consonant penalty (having FHKWVY cluster)
    bad_cons_count = sum(counts.get(c, 0) for c in bad_consonants)
    if bad_cons_count >= 3:
        penalty = -250
        adjustment += penalty
        breakdown.append(("awkward consonants", penalty))
    elif bad_cons_count >= 2:
        penalty = -100
        adjustment += penalty
        breakdown.append(("weak consonants", penalty))

    return adjustment, breakdown


def evaluate_leave(leave, mul_data, verbose=True):
    """
    Evaluate a leave string and return the total value.

    Returns value in centipoints.
    Sign convention: positive = good leave, negative = bad leave
    """
    counts = count_tiles(leave)
    total_centipoints = 0
    total_expected = 0.0

    details = []

    for tile, count in sorted(counts.items()):
        if tile in mul_data:
            md = mul_data[tile]
            leave_adj = md.get_leave_value(count)
            expected = md.get_expected_score(count)

            # Raw value directly represents leave quality:
            # Positive = good tile to keep, Negative = bad tile to keep
            intuitive_value = leave_adj

            details.append({
                'tile': tile,
                'count': count,
                'raw_adj': leave_adj,
                'value_centipoints': intuitive_value,
                'value_points': intuitive_value / 100.0,
                'expected_score': expected,
            })

            total_centipoints += intuitive_value
            total_expected += expected
        else:
            details.append({
                'tile': tile,
                'count': count,
                'raw_adj': None,
                'value_centipoints': 0,
                'value_points': 0.0,
                'expected_score': 0.0,
                'error': 'No MUL data'
            })

    # Calculate synergy adjustments
    synergy_adj, synergy_breakdown = calculate_synergies(counts)

    if verbose:
        print(f"\nLeave: {leave.upper()}")
        print("-" * 60)
        print(f"{'Tile':<6} {'Count':<6} {'Raw':<10} {'Points':<10} {'Exp.Score':<10}")
        print("-" * 60)
        for d in details:
            if d.get('error'):
                print(f"{d['tile']:<6} {d['count']:<6} {'N/A':<10} {'N/A':<10} {'N/A':<10}")
            else:
                print(f"{d['tile']:<6} {d['count']:<6} {d['raw_adj']:<10} {d['value_points']:>+9.2f} {d['expected_score']:>9.2f}")
        print("-" * 60)
        print(f"{'Tiles':<6} {'':<6} {'':<10} {total_centipoints/100:>+9.2f} {total_expected:>9.2f}")
        if synergy_breakdown:
            for desc, val in synergy_breakdown:
                print(f"  {desc:<18} {val:<10} {val/100:>+9.2f}")
            print("-" * 60)
            print(f"{'TOTAL':<6} {'':<6} {'':<10} {(total_centipoints + synergy_adj)/100:>+9.2f}")
        print()

    return total_centipoints + synergy_adj, details


def show_tile_table(mul_data):
    """Show leave values for all tiles at count=1."""
    print("\nSingle-Tile Leave Values (count=1)")
    print("-" * 50)
    print(f"{'Tile':<6} {'Raw Adj':<12} {'Points':<12} {'Exp.Score':<12}")
    print("-" * 50)

    tiles = sorted(mul_data.keys(), key=lambda t: (t == '?', t))
    for tile in tiles:
        md = mul_data[tile]
        if len(md.records) > 1:
            raw = md.records[1]['leave_adj']
            points = raw / 100.0  # raw value = leave quality (positive = good)
            exp = md.records[1]['expected_score']
            print(f"{tile:<6} {raw:<12} {points:>+11.2f} {exp:>11.2f}")
    print()


def show_tile_detail(tile, mul_data):
    """Show all counts for a specific tile."""
    tile = tile.upper()
    if tile not in mul_data:
        print(f"No data for tile '{tile}'")
        return

    md = mul_data[tile]
    print(f"\nMUL data for tile '{tile}'")
    print("-" * 70)
    print(f"{'Count':<6} {'Raw Adj':<12} {'Points':<10} {'Exp.Score':<12} {'Samples':<12}")
    print("-" * 70)

    for rec in md.records:
        points = rec['leave_adj'] / 100.0  # raw value = leave quality
        print(f"{rec['count']:<6} {rec['leave_adj']:<12} {points:>+9.2f} {rec['expected_score']:>11.2f} {rec['sample_count']:>11}")
    print()


def compare_leaves(leaves, mul_data):
    """Compare multiple leaves side by side."""
    results = []
    for leave in leaves:
        total, _ = evaluate_leave(leave, mul_data, verbose=False)
        results.append((leave.upper(), total / 100.0))

    print("\nLeave Comparison")
    print("-" * 40)
    results.sort(key=lambda x: -x[1])  # Sort by value, best first
    for leave, points in results:
        print(f"  {leave:<12} {points:>+8.2f} pts")
    print()


def best_tiles(mul_data, n=10):
    """Show the N best and worst single tiles."""
    tiles = []
    for tile, md in mul_data.items():
        if len(md.records) > 1:
            raw = md.records[1]['leave_adj']
            tiles.append((tile, raw / 100.0))

    tiles.sort(key=lambda x: -x[1])

    print(f"\nTop {n} Best Tiles to Keep:")
    print("-" * 30)
    for tile, pts in tiles[:n]:
        print(f"  {tile:<4} {pts:>+8.2f} pts")

    print(f"\nTop {n} Worst Tiles to Keep:")
    print("-" * 30)
    for tile, pts in tiles[-n:]:
        print(f"  {tile:<4} {pts:>+8.2f} pts")
    print()


def repl(mul_data):
    """Interactive REPL for leave evaluation."""
    print("\n" + "=" * 60)
    print("Maven Leave Value Evaluator")
    print("=" * 60)
    print("\nCommands:")
    print("  <leave>       Evaluate a leave (e.g., AEINST, Q, SATIRE?)")
    print("  cmp A B C     Compare multiple leaves")
    print("  table         Show all single-tile values")
    print("  best          Show best/worst tiles")
    print("  detail X      Show all counts for tile X")
    print("  help          Show this help")
    print("  /q            Exit")
    print("\nUse ? for blank tiles. Single letters like Q are evaluated as leaves.")
    print()

    while True:
        try:
            line = input("leave> ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nGoodbye!")
            break

        if not line:
            continue

        parts = line.split()
        cmd = parts[0].lower()

        # Check if input looks like a leave (only letters and ?)
        # If so, evaluate it even if it matches a command name
        is_leave = all(c.isalpha() or c == '?' for c in line.replace(' ', ''))

        if cmd in ('quit', 'exit') and not is_leave:
            print("Goodbye!")
            break
        elif cmd == '/q':  # Use /q for quick quit
            print("Goodbye!")
            break
        elif cmd == 'help' and not is_leave:
            print("\nCommands:")
            print("  <leave>       Evaluate a leave (e.g., AEINST, QUU, SATIRE?)")
            print("  cmp A B C     Compare multiple leaves")
            print("  table         Show all single-tile values")
            print("  best          Show best/worst tiles")
            print("  detail X      Show all counts for tile X")
            print("  /q or quit    Exit")
            print()
        elif cmd == 'table' and len(parts) == 1:
            show_tile_table(mul_data)
        elif cmd == 'best' and len(parts) == 1:
            best_tiles(mul_data)
        elif cmd == 'cmp' and len(parts) > 1:
            compare_leaves(parts[1:], mul_data)
        elif cmd == 'detail' and len(parts) > 1:
            show_tile_detail(parts[1], mul_data)
        else:
            # Treat as a leave to evaluate
            evaluate_leave(line, mul_data)


def main():
    print("Loading MUL resources...")
    mul_data = load_all_mul_resources()
    print(f"Loaded {len(mul_data)} tile types")

    if not mul_data:
        print("Error: No MUL data found!")
        return

    repl(mul_data)


if __name__ == "__main__":
    main()
