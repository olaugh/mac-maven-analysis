#!/usr/bin/env python3
"""
Properly traverse Maven's DAWG using the identified structure:
- ptr = bytes 0-1 (16-bit child pointer, node index)
- flags = byte 2 (bit 0 = EOW, bit 1 = LAST sibling)
- letter = byte 3

The key insight: siblings are contiguous until LAST flag is set.
"""
import struct
import sys

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def get_node(data, offset):
    """Get node at byte offset"""
    if offset >= len(data) - 4:
        return None
    b0, b1, b2, b3 = data[offset:offset+4]
    if not (97 <= b3 <= 122 or b3 == 63):  # a-z or ?
        return None
    return {
        'ptr': (b0 << 8) | b1,  # child pointer (node index)
        'flags': b2,
        'letter': chr(b3),
        'eow': (b2 & 0x01) != 0,
        'last': (b2 & 0x02) != 0,
        'offset': offset
    }

def traverse_dawg(data, dawg_base=0x400):
    """
    Extract all words from the DAWG.

    Structure:
    - Letter index at 0x10-0x77 (26 entries)
    - Each index entry points to first child (node index)
    - Siblings are contiguous; traverse until 'last' flag
    - Child pointer points to first child node (node index from dawg_base)
    """
    words = []

    def get_children(ptr):
        """Get all children starting at given pointer (node index)"""
        if ptr == 0:
            return []

        offset = dawg_base + ptr * 4
        children = []

        while True:
            node = get_node(data, offset)
            if node is None:
                break

            children.append(node)

            if node['last']:
                break

            offset += 4

        return children

    max_words = [100000]  # Limit to avoid infinite loops

    def dfs(ptr, prefix, depth=0):
        """Depth-first search from a node pointer"""
        if depth > 20 or len(words) >= max_words[0]:
            return

        children = get_children(ptr)

        for child in children:
            if len(words) >= max_words[0]:
                return
            new_prefix = prefix + child['letter']

            if child['eow']:
                words.append(new_prefix)

            if child['ptr'] > 0:
                dfs(child['ptr'], new_prefix, depth + 1)

    # Read letter index and traverse from each root
    for i in range(26):
        idx_offset = 0x10 + i * 4
        b0, b1, b2, b3 = data[idx_offset:idx_offset+4]
        root_ptr = (b0 << 8) | b1
        first_letter = chr(ord('a') + i)

        if root_ptr > 0:
            dfs(root_ptr, first_letter, 0)

    return words

def main():
    filepath = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data = read_file(filepath)

    print(f"File size: {len(data)} bytes")
    print(f"Traversing DAWG...")

    # Try different base offsets
    for base in [0x400, 0x300, 0x100, 0x000]:
        print(f"\n=== Trying DAWG base = 0x{base:04x} ===")
        words = traverse_dawg(data, dawg_base=base)

        # Sort and deduplicate
        words = sorted(set(words))

        print(f"Extracted {len(words)} unique words")

        # Show 2-letter words
        two_letter = [w for w in words if len(w) == 2]
        print(f"2-letter words ({len(two_letter)}): {two_letter[:30]}")

        # Show some 3-letter words
        three_letter = [w for w in words if len(w) == 3]
        print(f"3-letter words ({len(three_letter)}): {three_letter[:20]}...")

        # Check for known valid words
        test_words = ['aa', 'ab', 'ad', 'ae', 'cat', 'dog', 'the', 'zax', 'qi']
        found = [w for w in test_words if w in words]
        print(f"Found test words: {found}")

        # Stop if we found a reasonable word list
        if len(two_letter) > 50 and 'aa' in two_letter:
            print("\nSaving full word list...")
            output_path = f"/Volumes/T7/retrogames/oldmac/maven_re/wordlist_base{base:04x}.txt"
            with open(output_path, 'w') as f:
                for word in words:
                    f.write(word + '\n')
            print(f"Saved {len(words)} words to {output_path}")
            break

if __name__ == "__main__":
    main()
