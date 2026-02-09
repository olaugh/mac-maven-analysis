#!/usr/bin/env python3
"""
Find QUEEN by tracing NEEUQ (reversed) in Section 1.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
LETTER_INDEX_OFFSET = 0x10

def load_dawg():
    with open(DAWG_PATH, 'rb') as f:
        return f.read()

def get_entry(data, idx):
    offset = NODE_START + idx * 4
    if offset + 4 > len(data):
        return None
    return struct.unpack('>I', data[offset:offset+4])[0]

def decode(entry):
    if entry is None:
        return None
    return {
        'letter': chr(entry & 0xFF) if 97 <= (entry & 0xFF) <= 122 else '?',
        'eow': (entry >> 8) & 1,
        'last': (entry >> 9) & 1,
        'child': entry >> 10,
    }

def get_letter_range(data, letter):
    """Get the range for a letter in Section 1."""
    idx = ord(letter) - ord('a')
    offset = LETTER_INDEX_OFFSET + idx * 4
    start = (data[offset] << 8) | data[offset+1]

    if idx < 25:
        next_offset = LETTER_INDEX_OFFSET + (idx + 1) * 4
        end = (data[next_offset] << 8) | data[next_offset+1]
    else:
        end = 56630  # Section 1 end

    return start, end

def get_siblings(data, start, limit=100):
    """Get all siblings starting from index."""
    siblings = []
    idx = start
    for _ in range(limit):
        entry = get_entry(data, idx)
        d = decode(entry)
        if d is None or d['letter'] == '?':
            break
        siblings.append((idx, d))
        if d['last']:
            break
        idx += 1
    return siblings

def main():
    data = load_dawg()

    print("=== Finding QUEEN (reversed: NEEUQ) in Section 1 ===\n")

    # QUEEN reversed = NEEUQ
    # Start at N range, look for E->E->U->Q path

    n_start, n_end = get_letter_range(data, 'n')
    print(f"N range: {n_start} - {n_end}")

    # The N range contains entries that are the SECOND letter of reversed words
    # starting with N. So for NEEUQ, we look for E at the N range.

    print(f"\nSearching N range for 'e' entries (second letter of NEEUQ)...")

    # Actually, the letter index structure might work differently
    # Let me first understand what's at the N range

    print(f"\nFirst 20 entries at N range:")
    for idx in range(n_start, min(n_start + 20, n_end)):
        entry = get_entry(data, idx)
        d = decode(entry)
        print(f"  [{idx}] {d['letter']} eow={d['eow']} last={d['last']} child={d['child']}")

    # These entries show letters that follow N in reversed words
    # Each entry is a sibling group
    # Let me find 'e' entries

    print(f"\nLooking for 'e' in N range (for N-E... pattern)...")

    for idx in range(n_start, n_end):
        entry = get_entry(data, idx)
        d = decode(entry)

        if d and d['letter'] == 'e':
            print(f"\n  Found E at [{idx}], child={d['child']}")

            # Now look for another E at child (for N-E-E...)
            if d['child'] and d['child'] < 56630:
                siblings = get_siblings(data, d['child'])
                print(f"    Children at {d['child']}:")
                for s_idx, s_d in siblings[:15]:
                    mark = " <-- E!" if s_d['letter'] == 'e' else ""
                    print(f"      [{s_idx}] {s_d['letter']} eow={s_d['eow']} child={s_d['child']}{mark}")

                # Look for E in siblings
                for s_idx, s_d in siblings:
                    if s_d['letter'] == 'e':
                        print(f"\n    Found second E at [{s_idx}], child={s_d['child']}")

                        # Now look for U (for N-E-E-U...)
                        if s_d['child'] and s_d['child'] < 56630:
                            siblings2 = get_siblings(data, s_d['child'])
                            print(f"      Children at {s_d['child']}:")
                            for s2_idx, s2_d in siblings2[:15]:
                                mark = " <-- U!" if s2_d['letter'] == 'u' else ""
                                print(f"        [{s2_idx}] {s2_d['letter']} eow={s2_d['eow']} child={s2_d['child']}{mark}")

                            # Look for U
                            for s2_idx, s2_d in siblings2:
                                if s2_d['letter'] == 'u':
                                    print(f"\n      Found U at [{s2_idx}], child={s2_d['child']}")

                                    # Now look for Q with EOW (for N-E-E-U-Q)
                                    if s2_d['child'] and s2_d['child'] < 56630:
                                        siblings3 = get_siblings(data, s2_d['child'])
                                        print(f"        Children at {s2_d['child']}:")
                                        for s3_idx, s3_d in siblings3[:15]:
                                            mark = ""
                                            if s3_d['letter'] == 'q':
                                                mark = f" <-- Q (eow={s3_d['eow']})"
                                                if s3_d['eow']:
                                                    mark += " *** QUEEN FOUND! ***"
                                            print(f"          [{s3_idx}] {s3_d['letter']} eow={s3_d['eow']} child={s3_d['child']}{mark}")

if __name__ == "__main__":
    main()
