#!/usr/bin/env python3
"""
Enumerate words from Section 1 by DFS, reversing paths since words are stored reversed.
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
    letter_index = []
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index.append(entry)

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

    # Enumerate from all starting points
    words = set()
    visited = set()
    max_words = 5000

    def dfs(entry, path, depth=0):
        if depth > 15:
            return
        if len(words) >= max_words:
            return
        if entry in visited:
            return

        visited.add(entry)

        # Process all siblings at this entry
        current = entry
        siblings_processed = 0
        while siblings_processed < 50:
            node = get_node(current)
            if node is None:
                break

            # Add letter to path (prepend since words are reversed)
            new_path = node['letter'] + path

            # If WORD flag, this is a valid word end
            if node['is_word'] and len(new_path) >= 2:
                words.add(new_path)

            # Follow child to go deeper
            child = get_child_entry(node)
            if child is not None and child < section1_end:
                dfs(child, new_path, depth + 1)

            if node['is_last']:
                break
            current += 1
            siblings_processed += 1

        visited.discard(entry)

    # Start DFS from each letter index entry
    print("Enumerating words from letter index entries...")
    for i, start_entry in enumerate(letter_index):
        if len(words) >= max_words:
            break
        letter = chr(ord('a') + i)
        print(f"  Starting from '{letter}' entry {start_entry}...")
        dfs(start_entry, '', 0)
        print(f"    Words so far: {len(words)}")

    print(f"\nTotal words found: {len(words)}")

    # Check results
    two_letter = sorted([w for w in words if len(w) == 2])
    print(f"\n2-letter words ({len(two_letter)}): {two_letter[:50]}")

    # Check for known words
    known = ['aa', 'ab', 'ad', 'the', 'cat', 'dog', 'aardvark']
    print("\nKnown words check:")
    for w in known:
        if w in words:
            print(f"  '{w}': FOUND")
        else:
            print(f"  '{w}': not found")

    # Show sample words by length
    by_length = {}
    for w in words:
        n = len(w)
        if n not in by_length:
            by_length[n] = []
        by_length[n].append(w)

    print("\nSample words by length:")
    for length in sorted(by_length.keys())[:10]:
        sample = sorted(by_length[length])[:5]
        print(f"  {length} letters: {sample}")


if __name__ == "__main__":
    main()
