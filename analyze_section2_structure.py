#!/usr/bin/env python3
"""
Analyze Section 2 structure to understand DAWG organization.
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
        'entry': entry_idx,
        'ptr': ptr,
        'flags': flags,
    }

def main():
    data, section1_end, section2_end = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}")
    print(f"Section 2 count: {section2_end - section1_end}")

    # Analyze Section 2 entries
    by_letter = {chr(ord('a') + i): [] for i in range(26)}

    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx)
        if node:
            by_letter[node['letter']].append(node)

    print("\nSection 2 entries by first letter:")
    for letter in 'abcdefghijklmnopqrstuvwxyz':
        entries = by_letter[letter]
        print(f"  {letter}: {len(entries)} entries")

        # Show first few
        for e in entries[:3]:
            child_info = ""
            if e['child'] > 0 and e['child'] < section1_end:
                child_info = f" -> S1[{e['child']}]"
            elif e['child'] >= section1_end:
                child_info = f" -> S2[{e['child']}]"
            print(f"      {e['entry']}: word={e['is_word']}, child={e['child']}{child_info}")
        if len(entries) > 3:
            print(f"      ... ({len(entries)-3} more)")

    # Count unique child pointers
    unique_children = set()
    for letter, entries in by_letter.items():
        for e in entries:
            if e['child'] > 0:
                unique_children.add(e['child'])
    print(f"\nUnique child pointers: {len(unique_children)}")

    # Check Section 2 entries that have is_word flag
    words_in_s2 = [e for letter in by_letter for e in by_letter[letter] if e['is_word']]
    print(f"\nSection 2 entries with is_word: {len(words_in_s2)}")

    # Check if there are sibling groups in Section 2
    print("\n--- Section 2 Sibling Analysis ---")
    entry = section1_end
    groups = 0
    while entry < section2_end:
        node = get_node(data, entry)
        if node is None:
            entry += 1
            continue

        group_size = 1
        check = entry
        while True:
            n = get_node(data, check)
            if n is None or n['is_last']:
                break
            check += 1
            group_size += 1

        if group_size > 1:
            print(f"  Group at {entry}: {group_size} siblings")
            groups += 1

        entry += group_size

    print(f"Total sibling groups > 1: {groups}")

if __name__ == "__main__":
    main()
