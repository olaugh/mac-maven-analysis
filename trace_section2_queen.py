#!/usr/bin/env python3
"""
Trace Section 2 entry points for QUEEN more carefully.
Section 2 contains forward entry points that reference back into Section 1.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
SECTION1_END = 56630

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

def get_siblings(data, start, limit=100, max_idx=None):
    """Get sibling group starting at index."""
    if max_idx is None:
        max_idx = SECTION1_END + 70000  # Allow Section 2

    siblings = []
    idx = start
    for _ in range(limit):
        if idx >= max_idx:
            break
        entry = get_entry(data, idx)
        d = decode(entry)
        if d is None or d['letter'] == '?':
            break
        siblings.append((idx, d))
        if d['last']:
            break
        idx += 1
    return siblings

def trace_word(data, start_idx, word, section2_end):
    """Trace a word starting from an entry point."""
    word = word.lower()

    print(f"\n  Tracing '{word}' from entry [{start_idx}]:")

    current = start_idx
    for i, letter in enumerate(word):
        siblings = get_siblings(data, current, max_idx=section2_end)

        found = None
        for idx, d in siblings:
            if d['letter'] == letter:
                found = (idx, d)
                break

        if found is None:
            print(f"    [{current}] looking for '{letter}': NOT FOUND")
            print(f"      Available: {[d['letter'] for _, d in siblings[:15]]}")
            return False

        idx, d = found
        is_last = i == len(word) - 1
        eow_status = f" EOW={d['eow']}" if is_last else ""
        print(f"    [{idx}] '{letter}'{eow_status} -> child={d['child']}")

        if is_last:
            if d['eow']:
                print(f"    SUCCESS - word found!")
                return True
            else:
                print(f"    FAILED - no EOW flag on final letter")
                return False

        if not d['child']:
            print(f"    FAILED - no child pointer")
            return False

        current = d['child']

    return False

def main():
    data = load_dawg()
    section2_end = struct.unpack('>I', data[4:8])[0]

    print("=== Section 2 Entry Point Analysis for Q words ===\n")

    # Find all Q entry points in Section 2
    print("Finding Q entry points in Section 2...")
    q_entries = []
    for idx in range(SECTION1_END, section2_end):
        entry = get_entry(data, idx)
        d = decode(entry)
        if d and d['letter'] == 'q':
            q_entries.append((idx, d))

    print(f"Found {len(q_entries)} Q entry points\n")

    # For each Q entry, show what's at its child and try to trace QUEEN
    print("Analyzing Q entry points:")

    queen_starts = []
    for idx, d in q_entries:
        child = d['child']
        if child:
            siblings = get_siblings(data, child, max_idx=section2_end)
            letters = [dd['letter'] for _, dd in siblings]

            # Check if 'u' is available (for QU...)
            has_u = 'u' in letters
            marker = " <- has U!" if has_u else ""

            if has_u:
                queen_starts.append((idx, d))
                print(f"\n  Q[{idx}] child={child} -> letters: {letters}{marker}")

                # Try to trace QUEEN from this entry
                # First letter is Q at idx, need to check if child leads to U-E-E-N
                u_idx = None
                for sib_idx, sib_d in siblings:
                    if sib_d['letter'] == 'u':
                        u_idx = (sib_idx, sib_d)
                        break

                if u_idx:
                    sib_idx, sib_d = u_idx
                    print(f"    U at [{sib_idx}], child={sib_d['child']}")

                    if sib_d['child']:
                        # Look for E at U's child
                        u_siblings = get_siblings(data, sib_d['child'], max_idx=section2_end)
                        u_letters = [dd['letter'] for _, dd in u_siblings]
                        print(f"      U's children: {u_letters}")

                        for e_idx, e_d in u_siblings:
                            if e_d['letter'] == 'e':
                                print(f"      E at [{e_idx}], child={e_d['child']}")

                                if e_d['child']:
                                    # Look for E at first E's child
                                    e_siblings = get_siblings(data, e_d['child'], max_idx=section2_end)
                                    e_letters = [dd['letter'] for _, dd in e_siblings]
                                    print(f"        E's children: {e_letters}")

                                    for e2_idx, e2_d in e_siblings:
                                        if e2_d['letter'] == 'e':
                                            print(f"        2nd E at [{e2_idx}], child={e2_d['child']}")

                                            if e2_d['child']:
                                                # Look for N with EOW at second E's child
                                                e2_siblings = get_siblings(data, e2_d['child'], max_idx=section2_end)
                                                e2_letters = [(dd['letter'], dd['eow']) for _, dd in e2_siblings]
                                                print(f"          2nd E's children: {e2_letters}")

                                                for n_idx, n_d in e2_siblings:
                                                    if n_d['letter'] == 'n':
                                                        print(f"          N at [{n_idx}], eow={n_d['eow']}")
                                                        if n_d['eow']:
                                                            print(f"\n  *** QUEEN FOUND! ***")

    # Test specific common words
    print("\n" + "="*60)
    print("Testing specific words with full trace:\n")

    test_words = ['qi', 'quiz', 'queen', 'quiet', 'quay', 'the', 'cat']

    for word in test_words:
        first_letter = word[0]

        # Find entry point for first letter
        for idx in range(SECTION1_END, section2_end):
            entry = get_entry(data, idx)
            d = decode(entry)
            if d and d['letter'] == first_letter:
                if trace_word(data, idx, word, section2_end):
                    break

if __name__ == "__main__":
    main()
