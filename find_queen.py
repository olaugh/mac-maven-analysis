#!/usr/bin/env python3
"""
Exhaustively search for QUEEN in the DAWG.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

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

def find_path(data, start, letters, depth=0):
    """Find path matching letters starting from index."""
    if not letters:
        return []

    target = letters[0]
    rest = letters[1:]

    siblings = get_siblings(data, start)

    for idx, d in siblings:
        if d['letter'] == target:
            if not rest:
                # Last letter - need EOW flag
                if d['eow']:
                    return [(idx, d)]
                else:
                    return None  # Found letter but no EOW
            else:
                # More letters - follow child
                if d['child']:
                    sub_path = find_path(data, d['child'], rest, depth + 1)
                    if sub_path is not None:
                        return [(idx, d)] + sub_path

    return None

def main():
    data = load_dawg()
    section1_end = 56630
    section2_end = struct.unpack('>I', data[4:8])[0]

    print("=== Exhaustive QUEEN search ===\n")

    # Method 1: Search Section 2 (forward)
    print("Method 1: Search all Q entries in Section 2 for Q-U-E-E-N path")

    found = False
    for idx in range(section1_end, section2_end):
        entry = get_entry(data, idx)
        d = decode(entry)
        if d and d['letter'] == 'q' and d['child']:
            # Try to find U-E-E-N from child
            path = find_path(data, d['child'], 'ueen')
            if path:
                print(f"\n  QUEEN found starting at Q[{idx}]!")
                print(f"    Q[{idx}] -> child={d['child']}")
                for p_idx, p_d in path:
                    print(f"    {p_d['letter'].upper()}[{p_idx}] eow={p_d['eow']} -> child={p_d['child']}")
                found = True
                break

    if not found:
        print("  Not found via Section 2 Q entries")

    # Method 2: Search Section 1 (reversed: NEEUQ)
    print("\n\nMethod 2: Search Section 1 for reversed NEEUQ")

    LETTER_INDEX_OFFSET = 0x10
    n_idx = ord('n') - ord('a')
    n_offset = LETTER_INDEX_OFFSET + n_idx * 4
    n_start = (data[n_offset] << 8) | data[n_offset+1]

    # The letter index points to continuation nodes
    # For N, we look for E (second-to-last letter of QUEEN reversed)
    print(f"  N range starts at: {n_start}")
    print(f"  Looking for path: N-range -> E -> E -> U -> Q(eow)")

    # Actually need to understand the structure better
    # Let's just scan the entire Section 1 for patterns
    print("\n  Scanning Section 1 for E-E-U-Q pattern...")

    # Find all E entries that might lead to E-U-Q
    for idx in range(0, section1_end):
        entry = get_entry(data, idx)
        d = decode(entry)
        if d and d['letter'] == 'e' and d['child']:
            # Look for E-U-Q at child
            e_path = find_path(data, d['child'], 'euq')
            if e_path:
                print(f"\n  E-E-U-Q pattern found at [{idx}]!")
                # Now find what points to this E
                print(f"    E[{idx}] -> E-U-Q path")
                for p_idx, p_d in e_path:
                    eow_mark = " (EOW!)" if p_d['eow'] else ""
                    print(f"      {p_d['letter'].upper()}[{p_idx}] child={p_d['child']}{eow_mark}")

                # This E at idx should be reachable from N range
                # Look for who points to idx
                print(f"\n    Looking for entries with child near {idx}...")
                for check_idx in range(0, section1_end):
                    e2 = get_entry(data, check_idx)
                    d2 = decode(e2)
                    if d2 and d2['child'] == idx:
                        print(f"      [{check_idx}] {d2['letter']} points to {idx}")

                found = True
                break

    if not found:
        print("  E-E-U-Q pattern not found in Section 1")

    # Method 3: Just find any N that leads to Q with EOW via E-E-U
    print("\n\nMethod 3: Brute force - find Q with EOW that has U parent")

    print("  Looking for Q entries with EOW flag...")
    q_eow_entries = []
    for idx in range(0, section2_end):
        entry = get_entry(data, idx)
        d = decode(entry)
        if d and d['letter'] == 'q' and d['eow']:
            q_eow_entries.append((idx, d))

    print(f"  Found {len(q_eow_entries)} Q entries with EOW")
    for idx, d in q_eow_entries[:10]:
        print(f"    Q[{idx}] eow=1 child={d['child']}")

        # Find what points to this Q
        # Check nearby entries
        for check_idx in range(max(0, idx-50), min(section2_end, idx)):
            e2 = get_entry(data, check_idx)
            d2 = decode(e2)
            if d2 and d2['child'] <= idx < d2['child'] + 30:
                siblings = get_siblings(data, d2['child'])
                for s_idx, s_d in siblings:
                    if s_idx == idx:
                        print(f"      <- [{check_idx}] {d2['letter']} (child={d2['child']})")
                        break

if __name__ == "__main__":
    main()
