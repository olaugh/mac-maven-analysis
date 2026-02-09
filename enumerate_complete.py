#!/usr/bin/env python3
"""
Complete enumeration of Maven DAWG by traversing both sections.

Section 1: Contains reversed words. Enumerate paths where is_word=True,
           then reverse the string to get the actual word.
Section 2: Contains forward word entry points. Enumerate directly.

The key insight is that a word is valid when is_word=True at the END
of the path through the DAWG.
"""

import struct
import sys

NODE_START = 0x410
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

def get_node(data, entry_idx, section_limit):
    """Get node at entry index."""
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None

    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        return None

    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0

    return {
        'letter': chr(letter),
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': child if child < section_limit else 0,
        'entry': entry_idx,
    }

def get_siblings(data, start_entry, section_limit):
    """Get all siblings starting at start_entry."""
    siblings = []
    entry = start_entry
    while entry < section_limit:
        node = get_node(data, entry, section_limit)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings

def enumerate_section1(data, section1_end, letter_index):
    """
    Enumerate Section 1 (reversed words).

    Walk each letter range, collecting paths where is_word=True.
    The collected strings are reversed relative to actual words.
    """
    words = set()
    letters = 'abcdefghijklmnopqrstuvwxyz'

    for i, L in enumerate(letters):
        range_start = letter_index[L]
        range_end = letter_index[letters[i+1]] if i < 25 else section1_end

        # Use iterative DFS with explicit stack
        # Stack: (entry, prefix, visited_in_path)
        entry = range_start
        while entry < range_end:
            sibs = get_siblings(data, entry, range_end)
            if not sibs:
                entry += 1
                continue

            for node in sibs:
                prefix = L + node['letter']
                stack = [(node, prefix)]

                while stack:
                    curr, path = stack.pop()

                    if curr['is_word']:
                        # This is a valid word ending - reverse to get actual word
                        words.add(path[::-1])

                    if curr['child'] > 0 and curr['child'] < section1_end and len(path) < 16:
                        children = get_siblings(data, curr['child'], section1_end)
                        for child in children:
                            stack.append((child, path + child['letter']))

            entry += len(sibs)

        if (i + 1) % 5 == 0:
            print(f"  Processed through '{L}', {len(words)} words so far", flush=True)

    return words

def enumerate_section2(data, section1_end, section2_end):
    """
    Enumerate Section 2 (forward words).

    Section 2 entries are starting letters that point into Section 1 for children.
    Words found here are stored in forward order.
    """
    words = set()

    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx, section2_end)
        if node is None:
            continue

        first_letter = node['letter']

        # Check if this single-letter entry is a word (rare)
        if node['is_word'] and node['child'] == 0:
            words.add(first_letter)

        # Follow children
        if node['child'] > 0 and node['child'] < section1_end:
            # Use iterative DFS
            stack = [(node['child'], first_letter)]

            while stack:
                child_entry, prefix = stack.pop()
                children = get_siblings(data, child_entry, section1_end)

                for child in children:
                    new_prefix = prefix + child['letter']

                    if child['is_word']:
                        words.add(new_prefix)

                    if child['child'] > 0 and child['child'] < section1_end and len(new_prefix) < 16:
                        stack.append((child['child'], new_prefix))

        if entry_idx % 10000 == 0:
            print(f"  Processed Section 2 entry {entry_idx}, {len(words)} words so far", flush=True)

    return words

def main():
    print("="*60)
    print("Maven DAWG Complete Enumeration")
    print("="*60)

    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data, section1_end, section2_end, letter_index = load_dawg(dawg_path)

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}")

    print("\n--- Section 1 Enumeration (reversed words) ---")
    s1_words = enumerate_section1(data, section1_end, letter_index)
    print(f"Section 1: {len(s1_words)} words")

    print("\n--- Section 2 Enumeration (forward words) ---")
    s2_words = enumerate_section2(data, section1_end, section2_end)
    print(f"Section 2: {len(s2_words)} words")

    all_words = s1_words | s2_words
    print(f"\nCombined: {len(all_words)} unique words")

    # Only in S1
    only_s1 = s1_words - s2_words
    only_s2 = s2_words - s1_words
    print(f"Only in Section 1: {len(only_s1)}")
    print(f"Only in Section 2: {len(only_s2)}")

    # Verify known words
    test = ['aa', 'ab', 'cat', 'act', 'the', 'be', 'at', 'ta', 'queen', 'aardvark', 'zymurgy']
    print("\nVerifying known words:")
    for w in test:
        in_s1 = w in s1_words
        in_s2 = w in s2_words
        print(f"  {w}: S1={in_s1}, S2={in_s2}")

    # Length distribution
    by_len = {}
    for w in all_words:
        by_len[len(w)] = by_len.get(len(w), 0) + 1
    print("\nLength distribution:")
    for l in sorted(by_len.keys())[:15]:
        print(f"  {l} letters: {by_len[l]}")

    # 2-letter words
    two = sorted(w for w in all_words if len(w) == 2)
    print(f"\n2-letter words ({len(two)}): {', '.join(two[:50])}")

    # 7-letter words
    seven = sorted(w for w in all_words if len(w) == 7)
    print(f"\n7-letter words ({len(seven)}): {', '.join(seven[:30])}")

    # Save
    out = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_complete_enum.txt"
    with open(out, 'w') as f:
        for w in sorted(all_words):
            f.write(w + '\n')
    print(f"\nSaved to {out}")

if __name__ == "__main__":
    main()
