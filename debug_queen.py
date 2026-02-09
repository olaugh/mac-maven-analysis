#!/usr/bin/env python3
"""
Debug QUEEN validation - trace the exact path through the DAWG.
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

def main():
    data = load_dawg()
    section2_start = 56630
    section2_end = struct.unpack('>I', data[4:8])[0]

    print("=== Debugging QUEEN validation ===\n")
    word = "queen"

    # Step 1: Find Q entry points in Section 2
    print("Step 1: Finding all Q entry points in Section 2...")
    q_entries = []
    for idx in range(section2_start, section2_end):
        entry = get_entry(data, idx)
        d = decode(entry)
        if d and d['letter'] == 'q':
            q_entries.append((idx, entry, d))

    print(f"Found {len(q_entries)} Q entry points")
    print("\nFirst 20 Q entries and their children:")

    for i, (idx, entry, d) in enumerate(q_entries[:20]):
        child = d['child']
        print(f"\n  Q[{idx}] child={child}")

        # Look at children - find 'u' for QU...
        if child < section2_end:
            print(f"    Siblings at {child}:")
            sib_idx = child
            found_u = None
            for _ in range(30):
                se = get_entry(data, sib_idx)
                sd = decode(se)
                if sd is None:
                    break
                marker = " <-- U!" if sd['letter'] == 'u' else ""
                print(f"      [{sib_idx}] {sd['letter']} eow={sd['eow']} last={sd['last']} child={sd['child']}{marker}")
                if sd['letter'] == 'u':
                    found_u = (sib_idx, se, sd)
                if sd['last']:
                    break
                sib_idx += 1

            # If found U, trace deeper for QUEEN
            if found_u:
                print(f"\n    Found U at {found_u[0]}, tracing QUE...")
                u_child = found_u[2]['child']
                if u_child < section2_end:
                    # Look for E
                    print(f"    Siblings at U's child ({u_child}):")
                    sib_idx = u_child
                    found_e = None
                    for _ in range(30):
                        se = get_entry(data, sib_idx)
                        sd = decode(se)
                        if sd is None:
                            break
                        marker = " <-- E!" if sd['letter'] == 'e' else ""
                        print(f"      [{sib_idx}] {sd['letter']} eow={sd['eow']} last={sd['last']} child={sd['child']}{marker}")
                        if sd['letter'] == 'e':
                            found_e = (sib_idx, se, sd)
                        if sd['last']:
                            break
                        sib_idx += 1

                    if found_e:
                        print(f"\n    Found E at {found_e[0]}, tracing QUEE...")
                        e_child = found_e[2]['child']
                        if e_child < section2_end:
                            print(f"    Siblings at E's child ({e_child}):")
                            sib_idx = e_child
                            found_e2 = None
                            for _ in range(30):
                                se = get_entry(data, sib_idx)
                                sd = decode(se)
                                if sd is None:
                                    break
                                marker = " <-- E!" if sd['letter'] == 'e' else ""
                                print(f"      [{sib_idx}] {sd['letter']} eow={sd['eow']} last={sd['last']} child={sd['child']}{marker}")
                                if sd['letter'] == 'e':
                                    found_e2 = (sib_idx, se, sd)
                                if sd['last']:
                                    break
                                sib_idx += 1

                            if found_e2:
                                print(f"\n    Found second E at {found_e2[0]}, tracing QUEEN...")
                                e2_child = found_e2[2]['child']
                                if e2_child < section2_end:
                                    print(f"    Siblings at second E's child ({e2_child}):")
                                    sib_idx = e2_child
                                    for _ in range(30):
                                        se = get_entry(data, sib_idx)
                                        sd = decode(se)
                                        if sd is None:
                                            break
                                        marker = " <-- N with EOW!" if sd['letter'] == 'n' and sd['eow'] else ""
                                        if sd['letter'] == 'n':
                                            marker = f" <-- N (eow={sd['eow']})"
                                        print(f"      [{sib_idx}] {sd['letter']} eow={sd['eow']} last={sd['last']} child={sd['child']}{marker}")
                                        if sd['letter'] == 'n' and sd['eow']:
                                            print("\n    >>> QUEEN FOUND!")
                                            return
                                        if sd['last']:
                                            break
                                        sib_idx += 1

        # Only trace first few Q entries in detail
        if i >= 5:
            print("\n... (truncated)")
            break

    print("\n=== QUEEN not found via Section 2 traversal ===")
    print("\nLet's check Section 1 (reversed: NEEUQ)...")

    # Try Section 1 - reversed word
    LETTER_INDEX_OFFSET = 0x10
    n_idx = ord('n') - ord('a')
    n_offset = LETTER_INDEX_OFFSET + n_idx * 4
    n_start = (data[n_offset] << 8) | data[n_offset+1]
    o_offset = LETTER_INDEX_OFFSET + (n_idx+1) * 4
    n_end = (data[o_offset] << 8) | data[o_offset+1]

    print(f"\nN range in Section 1: {n_start} - {n_end}")
    print("Looking for N->E->E->U->Q path (reversed QUEEN)...")

    # This would be complex to trace fully, let's just check the N entries
    print("\nFirst 10 N entries:")
    for idx in range(n_start, min(n_start + 10, n_end)):
        entry = get_entry(data, idx)
        d = decode(entry)
        print(f"  [{idx}] {d['letter']} eow={d['eow']} last={d['last']} child={d['child']}")

if __name__ == "__main__":
    main()
