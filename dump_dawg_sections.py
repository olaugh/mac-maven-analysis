#!/usr/bin/env python3
"""
Dump Maven DAWG dictionaries (S1 = TWL, S2 = OSW).

Maven's data fork contains two DAWG sections:
  S1: TWL (Tournament Word List, North American) — 172,233 words
  S2: OSW (Official Scrabble Words, Chambers-based) — 210,643 words

Words in S1 ∩ S2 (129,832) are valid in both dictionaries.
S1-only words (42,401) are TWL-only (not in Chambers).
S2-only words (80,811) are OSW-only (not in TWL).
S1 ∪ S2 = OSWI/SOWPODS (the combined word list).

Entry format: 32-bit big-endian
  bits 0-7:   letter (ASCII lowercase, 0x61-0x7A)
  bit 8:      end-of-word flag
  bit 9:      last-sibling flag
  bits 10-31: child entry index (absolute within section)

File layout:
  offset 0:       header (3 × uint32: boundary, s1_entries, s2_entries)
  offset 12:      S1 data (entry 0 = sentinel, entries 1-26 = letter index)
  offset 488780:  S2 data (same structure as S1)
"""

import struct
import sys
import os

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
LEXICA_DIR = os.path.join(os.path.dirname(__file__), "lexica")


def load_dawg(path=DAWG_PATH):
    with open(path, 'rb') as f:
        data = f.read()

    field1 = struct.unpack('>I', data[0:4])[0]   # 56,630 (boundary)
    field2 = struct.unpack('>I', data[4:8])[0]   # 122,166 (S1 total entries)
    field3 = struct.unpack('>I', data[8:12])[0]  # 145,476 (S2 total entries)

    s1_base = 12
    s2_base = 116 + field2 * 4  # 116 + 488664 = 488780

    print(f"File: {len(data):,} bytes")
    print(f"Header: boundary={field1}, s1_entries={field2}, s2_entries={field3}")
    print(f"S1 base: offset {s1_base}")
    print(f"S2 base: offset {s2_base}")

    return data, field2, field3, s1_base, s2_base


def parse_entry(data, entry_idx, base):
    """Parse a single 32-bit DAWG entry."""
    offset = base + entry_idx * 4
    if offset + 4 > len(data):
        return None
    val = struct.unpack('>I', data[offset:offset + 4])[0]
    letter_byte = val & 0xFF
    if not (0x61 <= letter_byte <= 0x7A):  # not a-z
        return None
    return (chr(letter_byte), bool((val >> 8) & 1), bool((val >> 9) & 1), val >> 10)
    # Returns: (letter, eow, last, child)


def enumerate_section(data, base, max_entries):
    """Enumerate all words from a DAWG section using iterative DFS."""
    words = set()

    # Letter index: entries 1-26 (a=1, b=2, ..., z=26)
    for li in range(26):
        root_entry = parse_entry(data, 1 + li, base)
        if root_entry is None:
            continue
        _, _, _, root_child = root_entry
        if root_child == 0:
            continue

        root_letter = chr(ord('a') + li)

        # Iterative DFS: stack of (entry_index, path_so_far)
        stack = [(root_child, root_letter)]

        while stack:
            idx, path = stack.pop()

            # Walk the sibling group starting at idx
            while True:
                e = parse_entry(data, idx, base)
                if e is None:
                    break

                letter, eow, last, child = e
                new_path = path + letter

                if eow:
                    words.add(new_path)

                if child > 0:
                    stack.append((child, new_path))

                if last:
                    break
                idx += 1

    return words


def load_reference(path):
    """Load a reference word list (uppercase, one per line)."""
    if not os.path.exists(path):
        return None
    with open(path) as f:
        return {line.strip().lower() for line in f if line.strip()}


def main():
    data, s1_entries, s2_entries, s1_base, s2_base = load_dawg()

    print("\nEnumerating S1...")
    s1_words = enumerate_section(data, s1_base, s1_entries)
    print(f"  S1 words: {len(s1_words):,}")

    print("\nEnumerating S2...")
    s2_words = enumerate_section(data, s2_base, s2_entries)
    print(f"  S2 words: {len(s2_words):,}")

    # Length distribution
    print("\nLength distribution:")
    max_len = max(max(len(w) for w in s1_words), max(len(w) for w in s2_words))
    print(f"  {'Len':<5} {'S1':>8} {'S2':>8} {'Both':>8} {'S1only':>8} {'S2only':>8}")
    print(f"  {'-'*5} {'-'*8} {'-'*8} {'-'*8} {'-'*8} {'-'*8}")
    for length in range(2, min(max_len + 1, 16)):
        s1_at = {w for w in s1_words if len(w) == length}
        s2_at = {w for w in s2_words if len(w) == length}
        both = s1_at & s2_at
        print(f"  {length:<5} {len(s1_at):>8,} {len(s2_at):>8,} "
              f"{len(both):>8,} {len(s1_at - s2_at):>8,} {len(s2_at - s1_at):>8,}")

    # S1 vs S2 comparison
    common = s1_words & s2_words
    s1_only = s1_words - s2_words
    s2_only = s2_words - s1_words

    print(f"\nS1 vs S2:")
    print(f"  Common:  {len(common):>8,}")
    print(f"  S1 only: {len(s1_only):>8,}")
    print(f"  S2 only: {len(s2_only):>8,}")
    total = len(s1_words | s2_words)
    print(f"  Overlap: {len(common)/total*100:.1f}%")

    # Cross-reference with TWL98 and SOWPODS
    twl = load_reference(os.path.join(LEXICA_DIR, "TWL98.txt"))
    sowpods = load_reference(os.path.join(LEXICA_DIR, "sowpods2003.txt"))

    if twl:
        print(f"\nTWL98 reference: {len(twl):,} words")
        print(f"  S1 ∩ TWL:  {len(s1_words & twl):>8,}  ({len(s1_words & twl)/len(twl)*100:.1f}% of TWL)")
        print(f"  S2 ∩ TWL:  {len(s2_words & twl):>8,}  ({len(s2_words & twl)/len(twl)*100:.1f}% of TWL)")
        print(f"  S1 \\ TWL:  {len(s1_words - twl):>8,}  (in S1 but not TWL)")
        print(f"  TWL \\ S1:  {len(twl - s1_words):>8,}  (in TWL but not S1)")

        # Show S1-only words that ARE in TWL (confirms S1 = TWL)
        s1_only_in_twl = s1_only & twl
        s1_only_not_twl = s1_only - twl
        print(f"\n  S1-only words ({len(s1_only):,} total):")
        print(f"    In TWL:     {len(s1_only_in_twl):>8,}")
        print(f"    Not in TWL: {len(s1_only_not_twl):>8,}")
        if s1_only_not_twl:
            examples = sorted(s1_only_not_twl)[:20]
            print(f"    S1-only, not-TWL examples: {', '.join(examples)}")

    if sowpods:
        print(f"\nSOWPODS reference: {len(sowpods):,} words")
        print(f"  S1 ∩ SOWPODS:  {len(s1_words & sowpods):>8,}  ({len(s1_words & sowpods)/len(sowpods)*100:.1f}% of SOWPODS)")
        print(f"  S2 ∩ SOWPODS:  {len(s2_words & sowpods):>8,}  ({len(s2_words & sowpods)/len(sowpods)*100:.1f}% of SOWPODS)")
        print(f"  S2 \\ SOWPODS:  {len(s2_words - sowpods):>8,}  (in S2 but not SOWPODS)")
        print(f"  SOWPODS \\ S2:  {len(sowpods - s2_words):>8,}  (in SOWPODS but not S2)")

        # Show S2-only words that ARE in SOWPODS (confirms S2 = SOWPODS subset)
        s2_only_in_sowpods = s2_only & sowpods
        s2_only_not_sowpods = s2_only - sowpods
        print(f"\n  S2-only words ({len(s2_only):,} total):")
        print(f"    In SOWPODS:     {len(s2_only_in_sowpods):>8,}")
        print(f"    Not in SOWPODS: {len(s2_only_not_sowpods):>8,}")
        if s2_only_not_sowpods:
            examples = sorted(s2_only_not_sowpods)[:20]
            print(f"    S2-only, not-SOWPODS examples: {', '.join(examples)}")

    if twl and sowpods:
        # OSW = SOWPODS minus TWL (words legal internationally but not in NA)
        osw_only = sowpods - twl
        print(f"\n  OSW-only (SOWPODS \\ TWL): {len(osw_only):,} words")
        print(f"  S2-only ∩ OSW-only: {len(s2_only & osw_only):>8,}")
        print(f"  S2-only = OSW-only? {s2_only == osw_only}")

        # What about words in neither reference?
        all_ref = twl | sowpods
        s1_mystery = s1_words - all_ref
        s2_mystery = s2_words - all_ref
        print(f"\n  Words in neither TWL nor SOWPODS:")
        print(f"    S1: {len(s1_mystery):,}")
        print(f"    S2: {len(s2_mystery):,}")
        if s1_mystery:
            examples = sorted(s1_mystery)[:20]
            print(f"    S1 mystery examples: {', '.join(examples)}")
        if s2_mystery:
            examples = sorted(s2_mystery)[:20]
            print(f"    S2 mystery examples: {', '.join(examples)}")

    # S1-only examples
    if s1_only:
        examples = sorted(s1_only)
        print(f"\n  S1-only examples (first 30):")
        for w in examples[:30]:
            in_twl = " [TWL]" if (twl and w in twl) else ""
            in_sowpods = " [SOWPODS]" if (sowpods and w in sowpods) else ""
            print(f"    {w}{in_twl}{in_sowpods}")
        if len(examples) > 30:
            print(f"    ... and {len(examples) - 30} more")

    # S2-only examples
    if s2_only:
        examples = sorted(s2_only)
        print(f"\n  S2-only examples (first 30):")
        for w in examples[:30]:
            in_twl = " [TWL]" if (twl and w in twl) else ""
            in_sowpods = " [SOWPODS]" if (sowpods and w in sowpods) else ""
            print(f"    {w}{in_twl}{in_sowpods}")
        if len(examples) > 30:
            print(f"    ... and {len(examples) - 30} more")

    # Write output files
    os.makedirs(LEXICA_DIR, exist_ok=True)
    s1_out = os.path.join(LEXICA_DIR, "s1_words.txt")
    s2_out = os.path.join(LEXICA_DIR, "s2_words.txt")

    with open(s1_out, 'w') as f:
        for w in sorted(s1_words):
            f.write(w + '\n')
    print(f"\nWrote {len(s1_words):,} words to {s1_out}")

    with open(s2_out, 'w') as f:
        for w in sorted(s2_words):
            f.write(w + '\n')
    print(f"Wrote {len(s2_words):,} words to {s2_out}")


if __name__ == "__main__":
    main()
