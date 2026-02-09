#!/usr/bin/env python3
"""
Search for specific words in the DAWG structure.
"""

import struct
from collections import defaultdict

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        b0, b1, flags, letter_byte = data[offset:offset+4]
        base_ptr = (b0 << 8) | b1
        return {
            'letter': chr(letter_byte) if 97 <= letter_byte <= 122 else None,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    # Letter index
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        entry = struct.unpack('>H', data[offset:offset+2])[0]
        letter_index[chr(ord('a') + i)] = entry

    def find_word_forward(word, start_entry):
        """Try to find word starting from start_entry (forward traversal)."""
        entry = start_entry
        path = []

        for target_letter in word:
            # Search siblings for target letter
            found = False
            while entry < section1_end:
                node = get_node(entry)
                if node['letter'] == target_letter:
                    path.append((entry, node))
                    if len(path) == len(word):
                        # Check if final node is a word
                        return path, node['is_word']
                    # Go to children
                    entry = node['child']
                    found = True
                    break
                if node['is_last']:
                    break
                entry += 1

            if not found:
                return path, False

        return path, False

    def find_word_reversed(word, start_entry):
        """Try to find word reversed starting from start_entry."""
        return find_word_forward(word[::-1], start_entry)

    # Try to find "THE"
    print("="*60)
    print("Searching for 'THE'")
    print("="*60)

    # Forward from each letter's index
    for letter in ['t', 'h', 'e']:
        start = letter_index[letter]
        path, is_word = find_word_forward('the', start)
        print(f"\nForward from '{letter}' index ({start}): found={is_word}")
        if path:
            for entry, node in path:
                print(f"  Entry {entry}: '{node['letter']}' is_word={node['is_word']}")

    # Try reversed
    for letter in ['t', 'h', 'e']:
        start = letter_index[letter]
        path, is_word = find_word_reversed('the', start)
        print(f"\nReversed from '{letter}' index ({start}): found={is_word}")
        if path:
            for entry, node in path:
                print(f"  Entry {entry}: '{node['letter']}' is_word={node['is_word']}")

    # Try from entry 0
    print("\n" + "="*60)
    print("Searching from entry 0")
    print("="*60)

    for word in ['the', 'cat', 'dog', 'aa', 'ab', 'ax']:
        path, is_word = find_word_forward(word, 0)
        print(f"\n'{word}' forward from 0: found={is_word}")
        if path:
            for entry, node in path[:5]:
                print(f"  Entry {entry}: '{node['letter']}' is_word={node['is_word']}")

    # Search all root groups for 't' starting words
    print("\n" + "="*60)
    print("Finding root groups that can start 'THE'")
    print("="*60)

    # Find all root groups (entries not pointed to as children)
    child_targets = set()
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] > 0:
            child_targets.add(node['child'])

    # Find groups with 't' as first sibling
    for i in range(section1_end):
        if i in child_targets:
            continue
        node = get_node(i)
        if node['letter'] == 't':
            # This is a root 't', try to find 'the' from here
            path, is_word = find_word_forward('the', i)
            if is_word:
                print(f"\nFound 'THE' from root entry {i}!")
                for entry, n in path:
                    print(f"  Entry {entry}: '{n['letter']}' is_word={n['is_word']}")
                break
            elif path and len(path) >= 2:
                # Show near misses
                path_letters = ''.join(n['letter'] for _, n in path)
                if path_letters == 'the':
                    print(f"\nNear miss from entry {i}: path='the' but is_word={is_word}")

if __name__ == "__main__":
    main()
