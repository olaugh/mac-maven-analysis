#!/usr/bin/env python3
"""
Enumerate words from Maven DAWG by walking ALL sibling groups.

Key insight: Each letter range contains MULTIPLE sibling groups (trees).
We must enumerate from ALL groups, not just the first one.
"""

import struct

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

def get_siblings(data, start_entry):
    """Get all siblings in a group starting at start_entry."""
    siblings = []
    entry = start_entry
    while entry < SECTION1_END:
        node = get_node(data, entry)
        if node is None:
            break
        siblings.append((entry, node))
        if node['is_last']:
            break
        entry += 1
    return siblings

def enumerate_from_all_groups(data, range_start, range_end, prefix, words, depth=0):
    """
    Enumerate words by walking ALL sibling groups in a range.
    """
    if depth > 15:
        return

    entry = range_start
    groups_processed = 0

    while entry < range_end and groups_processed < 5000:
        siblings = get_siblings(data, entry)
        if not siblings:
            break

        # Process this sibling group
        for sib_entry, node in siblings:
            current_word = prefix + node['letter']

            if node['is_word']:
                words.add(current_word)

            # Recurse to children
            if node['child'] > 0 and node['child'] < SECTION1_END:
                enumerate_from_all_groups(data, node['child'], SECTION1_END,
                                          current_word, words, depth + 1)

        # Move to next sibling group
        entry += len(siblings)
        groups_processed += 1

def enumerate_section1(data, letter_index):
    """Enumerate all words from Section 1."""
    words = set()
    letters = 'abcdefghijklmnopqrstuvwxyz'

    for i, L in enumerate(letters):
        range_start = letter_index[L]
        range_end = letter_index[letters[i+1]] if i < 25 else SECTION1_END

        print(f"Processing '{L}' range {range_start}-{range_end}...", end=" ", flush=True)

        # Enumerate from all groups in this range
        enumerate_from_all_groups(data, range_start, range_end, L, words)

        print(f"{len(words)} total words so far")

    # Words are reversed in Section 1
    return set(w[::-1] for w in words)

def enumerate_section2(data, section1_end, section2_end):
    """Enumerate words from Section 2."""
    words = set()

    print(f"Processing Section 2 ({section1_end}-{section2_end})...", flush=True)

    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx)
        if node is None:
            continue

        prefix = node['letter']

        if node['is_word'] and node['child'] == 0:
            # Single letter word (unlikely)
            words.add(prefix)

        if node['child'] > 0:
            # Follow children to build words
            _enumerate_forward(data, node['child'], section2_end, prefix, words, 0)

    return words

def _enumerate_forward(data, start, section_end, prefix, words, depth):
    """Enumerate forward from an entry."""
    if depth > 15:
        return

    entry = start
    limit = SECTION1_END if start < SECTION1_END else section_end

    siblings = get_siblings(data, entry) if start < SECTION1_END else []

    if not siblings:
        # Just process as single entry for Section 2 targets
        node = get_node(data, start)
        if node:
            siblings = [(start, node)]

    for sib_entry, node in siblings:
        current = prefix + node['letter']

        if node['is_word']:
            words.add(current)

        if node['child'] > 0:
            _enumerate_forward(data, node['child'], section_end, current, words, depth + 1)

def main():
    print("="*60)
    print("Maven DAWG Full Enumeration (All Sibling Groups)")
    print("="*60)

    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data, section1_end, section2_end, letter_index = load_dawg(dawg_path)

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}")

    print("\n--- Section 1 Enumeration ---")
    s1_words = enumerate_section1(data, letter_index)
    print(f"Section 1 total: {len(s1_words)} words")

    print("\n--- Section 2 Enumeration ---")
    s2_words = enumerate_section2(data, section1_end, section2_end)
    print(f"Section 2 total: {len(s2_words)} words")

    all_words = s1_words | s2_words
    print(f"\nCombined total: {len(all_words)} unique words")

    # Verify
    test = ['aa', 'ab', 'cat', 'act', 'at', 'ta', 'the', 'be', 'queen', 'aardvark', 'zymurgy']
    print("\nVerifying known words:")
    for w in test:
        print(f"  {w}: {'FOUND' if w in all_words else 'MISSING'}")

    # Length distribution
    by_len = {}
    for w in all_words:
        by_len[len(w)] = by_len.get(len(w), 0) + 1
    print("\nLength distribution:")
    for l in sorted(by_len.keys())[:10]:
        print(f"  {l} letters: {by_len[l]}")

    # 2-letter words
    two = sorted(w for w in all_words if len(w) == 2)
    print(f"\n2-letter words ({len(two)}): {', '.join(two[:50])}")

    # Save
    out = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_full_enum.txt"
    with open(out, 'w') as f:
        for w in sorted(all_words):
            f.write(w + '\n')
    print(f"\nSaved to {out}")

if __name__ == "__main__":
    main()
