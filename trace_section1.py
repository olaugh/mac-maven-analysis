#!/usr/bin/env python3
"""
Trace Section 1 structure more carefully.
Find QUEEN (NEEUQ) and understand the sibling group organization.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
LETTER_INDEX_OFFSET = 0x10
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

def get_siblings(data, start, limit=50):
    """Get sibling group starting at index."""
    siblings = []
    idx = start
    for _ in range(limit):
        if idx >= SECTION1_END:
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

def search_path(data, start, letters, depth=0, path=[]):
    """Search for path matching letters. Returns list of (idx, letter, eow) tuples."""
    if not letters:
        return path if path and path[-1][2] else None  # Must end with EOW

    target = letters[0]
    rest = letters[1:]

    siblings = get_siblings(data, start)

    for idx, d in siblings:
        if d['letter'] == target:
            new_path = path + [(idx, d['letter'], d['eow'])]
            if not rest:
                # Last letter - check EOW
                if d['eow']:
                    return new_path
            else:
                # More letters - follow child
                if d['child'] and d['child'] < SECTION1_END:
                    result = search_path(data, d['child'], rest, depth + 1, new_path)
                    if result:
                        return result
    return None

def main():
    data = load_dawg()

    print("=== Section 1 Structure Analysis ===\n")

    # First, let's understand the letter index structure
    print("Letter index entries (first letter -> start of range):")
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        raw = data[offset:offset+4]
        start = (raw[0] << 8) | raw[1]
        flags = raw[2]
        letter = chr(ord('a') + i)
        print(f"  {letter}: start={start:5d} flags=0x{flags:02x}")

    # The letter index gives us starting points for reversed words beginning with each letter
    # But these might not be contiguous ranges - they might point to sibling groups

    print("\n" + "="*60)
    print("Testing word lookups in Section 1:")

    test_words = [
        ('the', 'EHT'),
        ('cat', 'TAC'),
        ('dog', 'GOD'),
        ('queen', 'NEEUQ'),
        ('seen', 'NEES'),
        ('been', 'NEEB'),
        ('keen', 'NEEK'),
        ('teen', 'NEET'),
        ('green', 'NEERG'),
        ('quiz', 'ZIUQ'),
        ('qi', 'IQ'),
    ]

    for word, reversed_word in test_words:
        first_letter = reversed_word[0].lower()

        # Get start for first letter
        idx = ord(first_letter) - ord('a')
        offset = LETTER_INDEX_OFFSET + idx * 4
        start = (data[offset] << 8) | data[offset+1]

        # Search for remaining letters
        remaining = reversed_word[1:].lower()

        result = search_path(data, start, remaining)

        if result:
            print(f"\n  {word.upper()} (reversed: {reversed_word}) - FOUND")
            for r_idx, r_letter, r_eow in result:
                eow_mark = " [EOW]" if r_eow else ""
                print(f"    [{r_idx}] {r_letter}{eow_mark}")
        else:
            print(f"\n  {word.upper()} (reversed: {reversed_word}) - NOT FOUND")

            # Debug: show what's at the start
            siblings = get_siblings(data, start)
            print(f"    First letter '{first_letter}' range starts at {start}")
            print(f"    Available letters: {[d['letter'] for _, d in siblings[:10]]}")

    # Deep trace for QUEEN
    print("\n" + "="*60)
    print("Deep trace for QUEEN (NEEUQ):\n")

    n_idx = ord('n') - ord('a')
    offset = LETTER_INDEX_OFFSET + n_idx * 4
    n_start = (data[offset] << 8) | data[offset+1]

    print(f"N starts at {n_start}")
    n_siblings = get_siblings(data, n_start)
    print(f"Siblings at N start: {[(idx, d['letter']) for idx, d in n_siblings]}")

    # Look for E in N siblings
    for idx, d in n_siblings:
        if d['letter'] == 'e':
            print(f"\n  Found E at [{idx}], child={d['child']}")
            e_siblings = get_siblings(data, d['child'])
            print(f"  E's children: {[(i, dd['letter']) for i, dd in e_siblings]}")

            # Look for another E
            for idx2, d2 in e_siblings:
                if d2['letter'] == 'e':
                    print(f"\n    Found 2nd E at [{idx2}], child={d2['child']}")
                    e2_siblings = get_siblings(data, d2['child'])
                    print(f"    2nd E's children: {[(i, dd['letter']) for i, dd in e2_siblings]}")

                    # Look for U
                    for idx3, d3 in e2_siblings:
                        if d3['letter'] == 'u':
                            print(f"\n      Found U at [{idx3}], child={d3['child']}")
                            u_siblings = get_siblings(data, d3['child'])
                            print(f"      U's children: {[(i, dd['letter'], 'EOW' if dd['eow'] else '') for i, dd in u_siblings]}")

                            # Look for Q with EOW
                            for idx4, d4 in u_siblings:
                                if d4['letter'] == 'q' and d4['eow']:
                                    print(f"\n        QUEEN FOUND! Q at [{idx4}] with EOW")

if __name__ == "__main__":
    main()
