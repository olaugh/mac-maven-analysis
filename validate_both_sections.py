#!/usr/bin/env python3
"""
Validate words using BOTH Section 1 and Section 2 of the Maven DAWG.

From QEMU-verified disassembly:
  DAWG base = file + 12 (CODE 2: LEA 12(A4),A0)
  S2 base = file + 116 + field2*4 (CODE 2)
  Entry: letter=bits 0-7, eow=bit 8, last=bit 9, child=bits 10-31

From CODE 5:
  Section 1 size = 56,630 (A5-15506)
  Section 2 size = 65,536 (A5-15502)
  Lexicon modes: 1=TWL, 2=OSW, 3=SOWPODS
"""

import struct

FILEPATH = "/Volumes/T7/retrogames/oldmac/share/maven2"


def read_entry(data, base, index):
    offset = base + index * 4
    if offset + 4 > len(data):
        return None
    val = struct.unpack('>I', data[offset:offset + 4])[0]
    lb = val & 0xFF
    return {
        'val': val,
        'letter': chr(lb) if 97 <= lb <= 122 else None,
        'eow': (val >> 8) & 1,
        'last': (val >> 9) & 1,
        'child': val >> 10,
    }


def get_siblings(data, base, start, max_entries):
    siblings = []
    idx = start
    while idx < max_entries:
        entry = read_entry(data, base, idx)
        if entry is None or entry['letter'] is None:
            break
        siblings.append(entry)
        if entry['last']:
            break
        idx += 1
        if len(siblings) > 200:
            break
    return siblings


def match_word(data, base, siblings, remaining, max_entries):
    if not remaining:
        return True
    target = remaining[0]
    rest = remaining[1:]
    for entry in siblings:
        if entry['letter'] == target:
            if not rest:
                return entry['eow'] == 1
            child = entry['child']
            if child == 0:
                return False
            child_siblings = get_siblings(data, base, child, max_entries)
            return match_word(data, base, child_siblings, rest, max_entries)
    return False


def validate_s1(data, base, word, max_entries):
    """Validate word in Section 1 (reversed words)."""
    word = word.lower()
    if len(word) < 2:
        return False
    rev = word[::-1]
    i = ord(rev[0]) - ord('a')
    if i < 0 or i > 25:
        return False
    li_entry = read_entry(data, base, 1 + i)
    child = li_entry['child']
    if child == 0:
        return False
    siblings = get_siblings(data, base, child, max_entries)
    return match_word(data, base, siblings, rev[1:], max_entries)


def validate_s2(data, s2_base, word, max_entries):
    """Validate word in Section 2 (forward words)."""
    word = word.lower()
    if len(word) < 2:
        return False
    first = word[0]
    i = ord(first) - ord('a')
    if i < 0 or i > 25:
        return False
    li_entry = read_entry(data, s2_base, 1 + i)
    if li_entry is None or li_entry['letter'] is None:
        return False
    child = li_entry['child']
    if child == 0:
        return False
    siblings = get_siblings(data, s2_base, child, max_entries)
    return match_word(data, s2_base, siblings, word[1:], max_entries)


def load_wordlist(filepath):
    words = set()
    with open(filepath) as f:
        for line in f:
            w = line.strip().lower()
            if w:
                words.add(w)
    return words


def main():
    with open(FILEPATH, 'rb') as f:
        data = f.read()

    s1_boundary = struct.unpack('>I', data[0:4])[0]   # 56,630
    field2 = struct.unpack('>I', data[4:8])[0]         # 122,166
    field3 = struct.unpack('>I', data[8:12])[0]        # 145,476

    s1_base = 12
    s2_base = 116 + field2 * 4  # From CODE 2

    print(f"File size: {len(data)} bytes")
    print(f"Header: s1_boundary={s1_boundary}, field2={field2}, field3={field3}")
    print(f"S1 base: file+{s1_base}")
    print(f"S2 base: file+{s2_base}")
    print(f"S2 entry count (field3-field2): {field3 - field2}")

    # Examine S2 header
    print("\n" + "=" * 60)
    print("Section 2 Header (entries 0-26)")
    print("=" * 60)
    s2_entry0 = read_entry(data, s2_base, 0)
    if s2_entry0:
        print(f"  Entry 0 (sentinel): val=0x{s2_entry0['val']:08X}")

    print("\n  S2 Letter Index:")
    for i in range(26):
        entry = read_entry(data, s2_base, 1 + i)
        off = s2_base + (1 + i) * 4
        if off + 4 <= len(data):
            b0, b1, b2, b3 = data[off:off + 4]
            if entry and entry['letter']:
                print(f"    {chr(ord('a')+i)}: [{b0:02x} {b1:02x} {b2:02x} {b3:02x}] "
                      f"letter='{entry['letter']}' eow={entry['eow']} last={entry['last']} "
                      f"child={entry['child']}")
            else:
                print(f"    {chr(ord('a')+i)}: [{b0:02x} {b1:02x} {b2:02x} {b3:02x}] (non-letter)")

    # Use generous max entries for traversal (CODE 15 has no boundary check)
    s1_max = len(data) // 4
    s2_max = 200000  # generous for S2

    # S2 first groups for a couple letters
    print("\n" + "=" * 60)
    print("S2 first sibling groups")
    print("=" * 60)
    for letter in ['a', 'c', 't']:
        i = ord(letter) - ord('a')
        li = read_entry(data, s2_base, 1 + i)
        if li and li['letter'] and li['child'] > 0:
            print(f"\n  '{letter}' subtree (child={li['child']}):")
            siblings = get_siblings(data, s2_base, li['child'], s2_max)
            for entry in siblings:
                print(f"    '{entry['letter']}' eow={entry['eow']} last={entry['last']} child={entry['child']}")

    # Brute-force 2-letter words in both sections
    print("\n" + "=" * 60)
    print("Brute-force 2-letter words")
    print("=" * 60)

    s1_found = set()
    s2_found = set()
    for c1 in 'abcdefghijklmnopqrstuvwxyz':
        for c2 in 'abcdefghijklmnopqrstuvwxyz':
            word = c1 + c2
            if validate_s1(data, s1_base, word, s1_max):
                s1_found.add(word)
            if validate_s2(data, s2_base, word, s2_max):
                s2_found.add(word)

    combined = s1_found | s2_found
    both = s1_found & s2_found

    print(f"S1 only: {len(s1_found - s2_found)} words")
    print(f"S2 only: {len(s2_found - s1_found)} words")
    print(f"Both:    {len(both)} words")
    print(f"Total:   {len(combined)} words")

    # Load reference lists
    print("\n" + "=" * 60)
    print("Comparison with reference lists")
    print("=" * 60)

    sowpods = load_wordlist("lexica/maven_sowpods.txt")
    twl = load_wordlist("lexica/maven_twl.txt")
    osw = load_wordlist("lexica/maven_osw.txt")

    sowpods_2l = {w for w in sowpods if len(w) == 2}
    twl_2l = {w for w in twl if len(w) == 2}
    osw_2l = {w for w in osw if len(w) == 2}

    print(f"\nReference 2-letter counts: SOWPODS={len(sowpods_2l)}, TWL={len(twl_2l)}, OSW={len(osw_2l)}")

    for label, found in [("S1", s1_found), ("S2", s2_found), ("S1+S2", combined)]:
        print(f"\n  {label} ({len(found)} words):")
        for ref_name, ref_set in [("SOWPODS", sowpods_2l), ("TWL", twl_2l), ("OSW", osw_2l)]:
            matched = found & ref_set
            missed = ref_set - found
            extra = found - ref_set
            print(f"    vs {ref_name}: {len(matched)}/{len(ref_set)} matched, "
                  f"{len(missed)} missed, {len(extra)} extra")

    # Show S1 words sorted
    print(f"\nS1 words ({len(s1_found)}): {' '.join(sorted(s1_found))}")
    print(f"\nS2 words ({len(s2_found)}): {' '.join(sorted(s2_found))}")
    print(f"\nS1 extra vs SOWPODS: {' '.join(sorted(s1_found - sowpods_2l))}")
    print(f"S2 extra vs SOWPODS: {' '.join(sorted(s2_found - sowpods_2l))}")
    print(f"\nSOWPODS missed by S1+S2: {' '.join(sorted(sowpods_2l - combined))}")

    # Check if S1=TWL and S2=OSW (or vice versa)
    print("\n" + "=" * 60)
    print("Section-to-lexicon mapping analysis")
    print("=" * 60)
    twl_only = twl_2l - osw_2l
    osw_only = osw_2l - twl_2l
    s1_only = s1_found - s2_found
    s2_only = s2_found - s1_found

    print(f"TWL-only 2-letter words ({len(twl_only)}): {' '.join(sorted(twl_only))}")
    print(f"OSW-only 2-letter words ({len(osw_only)}): {' '.join(sorted(osw_only))}")
    print(f"S1-only found ({len(s1_only)}): {' '.join(sorted(s1_only))}")
    print(f"S2-only found ({len(s2_only)}): {' '.join(sorted(s2_only))}")
    print(f"TWL-only in S1: {len(twl_only & s1_found)}/{len(twl_only)}")
    print(f"TWL-only in S2: {len(twl_only & s2_found)}/{len(twl_only)}")
    print(f"OSW-only in S1: {len(osw_only & s1_found)}/{len(osw_only)}")
    print(f"OSW-only in S2: {len(osw_only & s2_found)}/{len(osw_only)}")


if __name__ == '__main__':
    main()
