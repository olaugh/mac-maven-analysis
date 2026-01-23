#!/usr/bin/env python3
"""
Extract single-tile leave values from MUL resources.
The first non-zero leave value in each MUL file should be the single-tile leave.
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
        # Check for NaN
        if val != val:
            return None
        return val
    except:
        return None

def is_meaningful_leave(val):
    """Check if value is a meaningful leave (not zero, not huge)"""
    if val is None:
        return False
    try:
        return -50 < val < 50 and abs(val) > 0.001 and val == val  # not NaN
    except:
        return False

def main():
    print("=== Single Tile Leave Values ===")
    print("(Extracted from MUL resources - first significant double in each)")
    print()

    tile_leaves = {}

    for letter in '?abcdefghijklmnopqrstuvwxyz':
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)

        # Find first meaningful leave value (try offset 0 first, then scan)
        first_leave = None
        first_offset = None

        # First try offset 0 (most likely location)
        val = try_double(data, 0)
        if is_meaningful_leave(val):
            first_leave = val
            first_offset = 0
        else:
            # Scan for first meaningful value
            for i in range(0, min(len(data) - 7, 100), 1):
                val = try_double(data, i)
                if is_meaningful_leave(val):
                    first_leave = val
                    first_offset = i
                    break

        display_letter = 'BLANK' if letter == '?' else letter.upper()
        tile_leaves[display_letter] = first_leave

        if first_leave is not None:
            print(f"  {display_letter:5s}: {first_leave:>8.3f}  (offset {first_offset})")
        else:
            print(f"  {display_letter:5s}: --no value found--")

    print()
    print("="*50)
    print("Summary by value (best to worst):")
    print("="*50)

    # Sort by value (higher = better to keep)
    sorted_tiles = sorted(
        [(k, v) for k, v in tile_leaves.items() if v is not None],
        key=lambda x: x[1],
        reverse=True
    )

    print()
    print("BEST TILES TO KEEP:")
    for tile, val in sorted_tiles[:10]:
        print(f"  {tile:5s}: {val:>+8.3f}")

    print()
    print("WORST TILES TO KEEP:")
    for tile, val in sorted_tiles[-10:]:
        print(f"  {tile:5s}: {val:>+8.3f}")

    # Also extract multiple values per letter to show patterns
    print()
    print("="*50)
    print("All significant values per tile (first 5):")
    print("="*50)

    for letter in '?aeioustrnlxqzv':
        mul_dir = f"MUL{letter}"
        mul_path = os.path.join(RESOURCES_DIR, mul_dir, "0_0.bin")
        if not os.path.exists(mul_path):
            continue

        data = read_file(mul_path)
        display_letter = 'BLANK' if letter == '?' else letter.upper()

        values = []
        for i in range(0, min(len(data) - 7, 160), 1):
            val = try_double(data, i)
            if is_meaningful_leave(val):
                # Avoid duplicates from overlapping reads
                if not values or abs(val - values[-1][1]) > 0.001:
                    values.append((i, val))

        print(f"\n  {display_letter}:")
        for offset, val in values[:8]:
            print(f"    offset {offset:3d}: {val:>+10.4f}")

if __name__ == "__main__":
    main()
