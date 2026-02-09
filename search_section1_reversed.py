#!/usr/bin/env python3
"""
Search Section 1 for reversed words properly.
Section 1 stores words reversed, indexed by last letter.
So AARDVARK (last letter K) is stored as KRAVDRAA starting from the K range.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]

    # Parse letter index
    LETTER_INDEX_OFFSET = 0x10
    letter_index = {}
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index[chr(ord('a') + i)] = entry

    # Compute letter ranges
    letters = 'abcdefghijklmnopqrstuvwxyz'
    letter_ranges = {}
    for i, L in enumerate(letters):
        start = letter_index[L]
        end = letter_index[letters[i+1]] if i < 25 else section1_end
        letter_ranges[L] = (start, end)

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        if not (97 <= letter <= 122):
            return None
        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter),
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'entry': entry_idx,
        }

    def get_child_entry(node):
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def get_siblings(start_entry, limit=100):
        siblings = []
        entry = start_entry
        while entry < section1_end and len(siblings) < limit:
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    # AARDVARK reversed = KRAVDRAA
    # Last letter of AARDVARK is K
    # So look in K range for entries, then trace R-A-V-D-R-A-A

    print("=" * 60)
    print("Searching Section 1 for KRAVDRAA (AARDVARK reversed)")
    print("=" * 60)

    k_range = letter_ranges['k']
    print(f"\nK range: {k_range[0]} to {k_range[1]}")

    # Check what letters are in the K range
    print(f"\nLetters in K range:")
    entry = k_range[0]
    sibling_groups = []
    while entry < k_range[1]:
        sibs = get_siblings(entry)
        if sibs:
            sibling_groups.append((entry, [s['letter'] for s in sibs]))
            entry += len(sibs)
        else:
            entry += 1

    print(f"Found {len(sibling_groups)} sibling groups")
    for start, letters in sibling_groups[:10]:
        print(f"  Entry {start}: {letters}")

    # The issue: entries in K range don't start with 'k'
    # The letter range is about the SECOND-TO-LAST letter!

    # Let me reconsider: if AARDVARK ends in K and is stored reversed as KRAVDRAA...
    # The letter index for 'k' gives entries where the letter at position 1 from end is 'k'
    # That would be words like *K (2-letter), *XK (3-letter), etc.

    # Actually, let me trace how THE validation would work:
    # THE reversed = EHT
    # Look up 'e' in index (last letter of THE)
    # Then traverse E->H->T

    print("\n" + "=" * 60)
    print("Testing: validate THE via Section 1 reversed")
    print("=" * 60)

    # THE reversed = EHT
    # Start from 'e' range, look for 'h' then 't'
    e_range = letter_ranges['e']
    print(f"\nE range: {e_range[0]} to {e_range[1]}")

    # Check entries in E range
    entry = e_range[0]
    found_the = False
    while entry < e_range[1]:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue

        # Look for 'h' in this group
        for s in sibs:
            if s['letter'] == 'h':
                print(f"\n  Found 'h' at entry {s['entry']}")
                child = get_child_entry(s)
                if child:
                    child_sibs = get_siblings(child)
                    print(f"    Child siblings: {[c['letter'] for c in child_sibs]}")

                    # Look for 't' with WORD flag
                    for c in child_sibs:
                        if c['letter'] == 't' and c['is_word']:
                            print(f"    Found 't' with WORD flag at {c['entry']} - THE is valid!")
                            found_the = True
                            break

        entry += len(sibs)

    if not found_the:
        print("  THE not found via this method")

    # Now understand: the letter index seems to NOT be for the last letter
    # Let me check what 'e' index actually contains

    print("\n" + "=" * 60)
    print("What does the E index actually contain?")
    print("=" * 60)

    entry = e_range[0]
    print(f"\nFirst entries in E range ({e_range[0]} to {e_range[1]}):")
    for i in range(20):
        node = get_node(e_range[0] + i)
        if node:
            child = get_child_entry(node)
            print(f"  {e_range[0]+i}: '{node['letter']}' child={child} {'WORD' if node['is_word'] else ''}")

    # Ah! The entries in E range don't have letter 'e'!
    # The letter index doesn't point to entries with that letter.
    # It's organized differently.

    # Let me search for all entries with letter 'e' to understand
    print("\n" + "=" * 60)
    print("Finding all Section 1 entries with letter 'e'")
    print("=" * 60)

    e_entries = []
    for entry_idx in range(section1_end):
        node = get_node(entry_idx)
        if node and node['letter'] == 'e':
            e_entries.append(node)

    print(f"Found {len(e_entries)} entries with letter 'e' in Section 1")
    print(f"Entry indices: {[e['entry'] for e in e_entries[:30]]}...")

    # Check distribution
    ranges = {'a': 0, 'e': 0, 'k': 0, 's': 0, 'other': 0}
    for e in e_entries:
        idx = e['entry']
        for L, (start, end) in letter_ranges.items():
            if start <= idx < end:
                if L in ranges:
                    ranges[L] += 1
                else:
                    ranges['other'] += 1
                break

    print(f"\n'e' entries by letter range:")
    for L, count in ranges.items():
        print(f"  {L} range: {count}")


if __name__ == "__main__":
    main()
