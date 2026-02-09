#!/usr/bin/env python3
"""
Enumerate words from a single Section 2 entry to understand the structure.
"""

import struct

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

def enumerate_from_entry(data, entry_idx, section1_end, max_words=100):
    """Enumerate words from a single Section 2 entry."""
    words = []

    node = get_node(data, entry_idx, section1_end + 65536)
    if not node:
        return words

    print(f"Starting from entry {entry_idx}: '{node['letter']}' word={node['is_word']} child={node['child']}")

    # Use iterative DFS
    stack = [(node['letter'], node, 0)]  # (prefix, node, depth)

    while stack and len(words) < max_words:
        prefix, current, depth = stack.pop()

        if current['is_word']:
            words.append(prefix)

        if current['child'] > 0 and current['child'] < section1_end and depth < 15:
            children = get_siblings(data, current['child'], section1_end)
            for child in reversed(children):  # Reverse for DFS order
                stack.append((prefix + child['letter'], child, depth + 1))

    return words

def main():
    data, section1_end, section2_end = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}\n")

    # Find the first few Section 2 entries with letter 'a'
    print("--- Finding 'a' entries in Section 2 ---")
    a_entries = []
    for entry_idx in range(section1_end, min(section1_end + 1000, section2_end)):
        node = get_node(data, entry_idx, section2_end)
        if node and node['letter'] == 'a':
            a_entries.append(entry_idx)
            if len(a_entries) >= 10:
                break

    print(f"First 10 'a' entries: {a_entries}\n")

    # Enumerate from the first 'a' entry
    if a_entries:
        entry = a_entries[0]
        print(f"\n=== Words from entry {entry} ===")
        words = enumerate_from_entry(data, entry, section1_end, max_words=100)
        print(f"Found {len(words)} words:")
        for w in sorted(words):
            print(f"  {w}")

        # Try second 'a' entry
        if len(a_entries) > 1:
            entry = a_entries[1]
            print(f"\n=== Words from entry {entry} ===")
            words = enumerate_from_entry(data, entry, section1_end, max_words=100)
            print(f"Found {len(words)} words:")
            for w in sorted(words):
                print(f"  {w}")

    # Also try a 'c' entry to see if we get 'cat'
    print("\n--- Finding 'c' entries ---")
    c_entries = []
    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx, section2_end)
        if node and node['letter'] == 'c':
            c_entries.append(entry_idx)
            if len(c_entries) >= 5:
                break

    if c_entries:
        entry = c_entries[0]
        print(f"\n=== Words from first 'c' entry {entry} ===")
        words = enumerate_from_entry(data, entry, section1_end, max_words=200)
        print(f"Found {len(words)} words:")
        for w in sorted(words)[:50]:
            print(f"  {w}")
        if len(words) > 50:
            print(f"  ... and {len(words) - 50} more")
        if 'cat' in words:
            print("  ** CAT FOUND! **")

if __name__ == "__main__":
    main()
