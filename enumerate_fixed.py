#!/usr/bin/env python3
"""
Fixed DAWG enumeration - children point to SINGLE sibling groups, not ranges.
"""

import struct
import sys

NODE_START = 0x410
SECTION1_END = 56630
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1 = data[offset], data[offset+1]
        letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

    return data, section1_end, section2_end, letter_index

def get_node(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    return {
        'letter': chr(letter),
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
    }

def enumerate_sibling_group(data, start_entry, prefix, words, depth, visited):
    """
    Enumerate words from a SINGLE sibling group starting at start_entry.
    Children point to single sibling groups, not ranges.
    """
    if depth > 15:
        return
    if start_entry >= SECTION1_END or start_entry < 0:
        return

    # Track to avoid infinite loops
    state = (start_entry, prefix)
    if state in visited:
        return
    visited.add(state)

    entry = start_entry
    while entry < SECTION1_END:
        node = get_node(data, entry)
        if node is None:
            break

        current = prefix + node['letter']

        if node['is_word']:
            words.add(current)

        # Recurse to child's sibling group
        if node['child'] > 0 and node['child'] < SECTION1_END:
            enumerate_sibling_group(data, node['child'], current, words, depth + 1, visited)

        if node['is_last']:
            break
        entry += 1

def enumerate_range(data, range_start, range_end, first_letter, words):
    """
    Enumerate words from a letter range by walking ALL sibling groups.
    """
    entry = range_start
    groups = 0
    visited = set()

    while entry < range_end:
        # Find the sibling group starting at 'entry'
        node = get_node(data, entry)
        if node is None:
            entry += 1
            continue

        # Count siblings in this group
        group_size = 1
        check = entry
        while check < range_end:
            n = get_node(data, check)
            if n is None:
                break
            if n['is_last']:
                break
            check += 1
            group_size += 1

        # Enumerate this sibling group
        enumerate_sibling_group(data, entry, first_letter, words, 1, visited)

        # Move to next sibling group
        entry += group_size
        groups += 1

    return groups

def enumerate_section1(data, letter_index):
    """Enumerate Section 1 (reversed words)."""
    words = set()
    letters = 'abcdefghijklmnopqrstuvwxyz'

    for i, L in enumerate(letters):
        range_start = letter_index[L]
        range_end = letter_index[letters[i+1]] if i < 25 else SECTION1_END

        groups = enumerate_range(data, range_start, range_end, L, words)
        print(f"'{L}': {range_end - range_start} entries, {groups} groups, {len(words)} words total", flush=True)

    # Reverse the words (Section 1 stores reversed)
    return set(w[::-1] for w in words)

def enumerate_section2(data, section1_end, section2_end):
    """Enumerate Section 2 (forward words)."""
    words = set()
    visited = set()

    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx)
        if node is None:
            continue

        prefix = node['letter']

        if node['is_word']:
            words.add(prefix)

        if node['child'] > 0:
            enumerate_sibling_group(data, node['child'], prefix, words, 1, visited)

    return words

def main():
    print("="*60)
    print("Maven DAWG Fixed Enumeration")
    print("="*60)

    data, section1_end, section2_end, letter_index = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print(f"Section 1: 0-{section1_end}, Section 2: {section1_end}-{section2_end}\n")

    print("--- Section 1 ---")
    s1 = enumerate_section1(data, letter_index)
    print(f"\nSection 1: {len(s1)} words")

    print("\n--- Section 2 ---")
    s2 = enumerate_section2(data, section1_end, section2_end)
    print(f"Section 2: {len(s2)} words")

    all_words = s1 | s2
    print(f"\nTotal: {len(all_words)} unique words")

    # Verify
    test = ['aa', 'ab', 'cat', 'act', 'at', 'ta', 'the', 'be', 'queen', 'aardvark']
    print("\nVerifying:")
    for w in test:
        print(f"  {w}: {'FOUND' if w in all_words else 'MISSING'}")

    # Stats
    by_len = {}
    for w in all_words:
        by_len[len(w)] = by_len.get(len(w), 0) + 1
    print("\nLength distribution:")
    for l in sorted(by_len.keys())[:10]:
        print(f"  {l}: {by_len[l]}")

    two = sorted(w for w in all_words if len(w) == 2)
    print(f"\n2-letter ({len(two)}): {', '.join(two[:30])}")

    # Save
    out = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_enum_fixed.txt"
    with open(out, 'w') as f:
        for w in sorted(all_words):
            f.write(w + '\n')
    print(f"\nSaved to {out}")

if __name__ == "__main__":
    main()
