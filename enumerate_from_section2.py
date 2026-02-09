#!/usr/bin/env python3
"""
Enumerate words from Maven DAWG using Section 2 as entry points.

Section 2 contains forward word entry points (a-z) that point into Section 1 children.
This approach avoids the complexity of walking reversed words in Section 1.
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

    return data, section1_end, section2_end

def get_node(data, entry_idx, section_limit):
    """Get node at entry index."""
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None

    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):  # Not a-z
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
    """Get all siblings in a group starting at start_entry."""
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

def enumerate_from_node(data, node, prefix, words, section1_end, depth, max_depth=15):
    """Recursively enumerate words from a node."""
    if depth > max_depth:
        return

    current = prefix + node['letter']

    if node['is_word']:
        words.add(current)

    if node['child'] > 0:
        children = get_siblings(data, node['child'], section1_end)
        for child_node in children:
            enumerate_from_node(data, child_node, current, words, section1_end, depth + 1, max_depth)

def enumerate_section2(data, section1_end, section2_end):
    """Enumerate words starting from Section 2 entries."""
    words = set()

    print(f"Processing Section 2 entries ({section1_end} to {section2_end})...")

    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx, section2_end)
        if node is None:
            continue

        first_letter = node['letter']

        # Single letter word (rare)
        if node['is_word'] and node['child'] == 0:
            words.add(first_letter)

        # Follow children to enumerate words
        if node['child'] > 0 and node['child'] < section1_end:
            children = get_siblings(data, node['child'], section1_end)
            for child_node in children:
                enumerate_from_node(data, child_node, first_letter, words, section1_end, 1)

    return words

def main():
    print("="*60)
    print("Maven DAWG Enumeration from Section 2")
    print("="*60)

    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data, section1_end, section2_end = load_dawg(dawg_path)

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}")

    words = enumerate_section2(data, section1_end, section2_end)
    print(f"\nEnumerated {len(words)} words")

    # Verify known words
    test = ['aa', 'ab', 'cat', 'act', 'the', 'be', 'at', 'ta', 'queen', 'aardvark', 'zymurgy']
    print("\nVerifying known words:")
    for w in test:
        print(f"  {w}: {'FOUND' if w in words else 'MISSING'}")

    # Length distribution
    by_len = {}
    for w in words:
        by_len[len(w)] = by_len.get(len(w), 0) + 1
    print("\nLength distribution:")
    for l in sorted(by_len.keys())[:15]:
        print(f"  {l} letters: {by_len[l]}")

    # 2-letter words
    two = sorted(w for w in words if len(w) == 2)
    print(f"\n2-letter words ({len(two)}): {', '.join(two[:50])}")

    # 7-letter words
    seven = sorted(w for w in words if len(w) == 7)
    print(f"\n7-letter words ({len(seven)}): {', '.join(seven[:30])}")

    # Save
    out = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_section2_enum.txt"
    with open(out, 'w') as f:
        for w in sorted(words):
            f.write(w + '\n')
    print(f"\nSaved to {out}")

if __name__ == "__main__":
    main()
