#!/usr/bin/env python3
"""
Enumerate words from Maven DAWG using BFS with visited tracking.
This avoids the infinite recursion problem caused by shared suffixes.
"""

import struct
from collections import deque

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()

    # Parse header
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    # Parse letter index
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1 = data[offset], data[offset+1]
        entry = (b0 << 8) | b1
        letter_index[chr(ord('a') + i)] = entry

    return data, section1_end, section2_end, letter_index

def get_node(data, entry_idx, section_end):
    if entry_idx >= section_end:
        return None
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

def enumerate_section1_bfs(data, section1_end, letter_index):
    """
    Enumerate words from Section 1 using BFS.
    Section 1 stores REVERSED words.
    """
    words = set()

    letters = 'abcdefghijklmnopqrstuvwxyz'

    # Process each starting letter (which is the LAST letter of actual word)
    for start_letter in letters:
        start_entry = letter_index[start_letter]

        # Get range for this letter
        next_idx = ord(start_letter) - ord('a') + 1
        end_entry = letter_index[letters[next_idx]] if next_idx < 26 else section1_end

        # BFS queue: (entry_idx, prefix_so_far)
        queue = deque()

        # Add initial siblings
        idx = start_entry
        while idx < end_entry:
            node = get_node(data, idx, section1_end)
            if node is None:
                break

            prefix = start_letter + node['letter']

            if node['is_word']:
                # This is a valid reversed word - reverse it
                words.add(prefix[::-1])

            if node['child'] > 0 and node['child'] < section1_end:
                queue.append((node['child'], prefix))

            if node['is_last']:
                break
            idx += 1

        # BFS exploration with depth limit
        visited = set()
        while queue:
            entry_idx, prefix = queue.popleft()

            if len(prefix) > 15:  # Word length limit
                continue

            # Process siblings at this entry
            idx = entry_idx
            sibling_count = 0
            while idx < section1_end and sibling_count < 100:
                state = (idx, len(prefix))
                if state in visited:
                    break
                visited.add(state)

                node = get_node(data, idx, section1_end)
                if node is None:
                    break

                new_prefix = prefix + node['letter']

                if node['is_word']:
                    words.add(new_prefix[::-1])

                if node['child'] > 0 and node['child'] < section1_end:
                    queue.append((node['child'], new_prefix))

                if node['is_last']:
                    break
                idx += 1
                sibling_count += 1

    return words

def enumerate_section2_bfs(data, section1_end, section2_end):
    """
    Enumerate words starting from Section 2 (forward dictionary).
    Section 2 entries point into Section 1 for suffixes.
    """
    words = set()
    visited = set()

    # BFS queue: (entry_idx, prefix_so_far, in_section1)
    queue = deque()

    # Start from all Section 2 entries
    for start_idx in range(section1_end, section2_end):
        node = get_node(data, start_idx, section2_end)
        if node is None:
            continue

        prefix = node['letter']

        if node['is_word']:
            words.add(prefix)

        if node['child'] > 0:
            queue.append((node['child'], prefix))

    # BFS with visited tracking
    while queue:
        entry_idx, prefix = queue.popleft()

        if len(prefix) > 15:
            continue

        # Determine section boundary
        section_end = section1_end if entry_idx < section1_end else section2_end

        idx = entry_idx
        sibling_count = 0
        while idx < section_end and sibling_count < 100:
            state = (idx, len(prefix))
            if state in visited:
                break
            visited.add(state)

            node = get_node(data, idx, section_end)
            if node is None:
                break

            new_prefix = prefix + node['letter']

            if node['is_word']:
                words.add(new_prefix)

            if node['child'] > 0:
                queue.append((node['child'], new_prefix))

            if node['is_last']:
                break
            idx += 1
            sibling_count += 1

    return words

def main():
    print("=" * 60)
    print("Maven DAWG Enumeration (BFS, No References)")
    print("=" * 60)

    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data, section1_end, section2_end, letter_index = load_dawg(dawg_path)

    print(f"Section 1 ends at: {section1_end}")
    print(f"Section 2 ends at: {section2_end}")
    print(f"Letter index a={letter_index['a']}, z={letter_index['z']}")

    print("\n--- Enumerating Section 1 (reversed words) ---")
    section1_words = enumerate_section1_bfs(data, section1_end, letter_index)
    print(f"Section 1: {len(section1_words)} words")

    print("\n--- Enumerating Section 2 (forward) ---")
    section2_words = enumerate_section2_bfs(data, section1_end, section2_end)
    print(f"Section 2: {len(section2_words)} words")

    all_words = section1_words | section2_words
    print(f"\nTotal unique words: {len(all_words)}")

    # Verify known words
    print("\nChecking known words:")
    test = ['aa', 'ab', 'cat', 'act', 'at', 'ta', 'the', 'be', 'queen', 'aardvark']
    for w in test:
        print(f"  {w}: {'FOUND' if w in all_words else 'MISSING'}")

    # Length distribution
    print("\nLength distribution:")
    by_len = {}
    for w in all_words:
        by_len[len(w)] = by_len.get(len(w), 0) + 1
    for l in sorted(by_len.keys())[:12]:
        print(f"  {l} letters: {by_len[l]}")

    # Show 2-letter words
    two_letter = sorted(w for w in all_words if len(w) == 2)
    print(f"\n2-letter words ({len(two_letter)}): {', '.join(two_letter)}")

    # Save
    output = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_enumerated_bfs.txt"
    with open(output, 'w') as f:
        for w in sorted(all_words):
            f.write(w + '\n')
    print(f"\nSaved to {output}")

if __name__ == "__main__":
    main()
