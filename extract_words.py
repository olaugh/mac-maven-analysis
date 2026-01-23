#!/usr/bin/env python3
"""
Extract words from Maven's DAWG dictionary

DAWG Structure (based on reverse engineering):
- File starts at offset 0x00
- Bytes 0x00-0x0F: Header (size info)
- Bytes 0x10-0x7F: Letter index (26 entries + padding)
- Bytes 0x400+: DAWG data starts here

Each 4-byte DAWG entry:
  - Bytes 0-1: Child pointer (big-endian 16-bit, multiply by 4 for offset)
  - Byte 2: Flags (bit 7 = end of word, other bits = ?)
  - Byte 3: Letter (ASCII lowercase a-z, or '?' for blank)

Navigation:
  - ptr = 0 means no children
  - Siblings are consecutive entries
  - First non-letter byte (or end of file) terminates siblings
"""
import struct
import sys

# DAWG data offset - after header padding
DAWG_OFFSET = 0x400

def read_dawg(filepath):
    """Read DAWG file and return raw data"""
    with open(filepath, 'rb') as f:
        return f.read()

def get_node(data, offset):
    """Parse a single DAWG node at the given offset"""
    if offset >= len(data) - 4:
        return None

    b0, b1, b2, b3 = data[offset:offset+4]
    ptr = (b0 << 8) | b1  # Big-endian pointer
    flags = b2
    letter = b3

    # Valid letters are a-z (0x61-0x7a) and ? (0x3f for blank)
    if not (97 <= letter <= 122 or letter == 63):
        return None

    return {
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter),
        'is_eow': (flags & 0x80) != 0,
        'offset': offset
    }

def extract_words_from_dawg(data, start_offset=0x10, dawg_base=DAWG_OFFSET):
    """
    Extract all words from the DAWG

    Args:
        data: Raw file bytes
        start_offset: Offset of letter index
        dawg_base: Base offset for DAWG data
    """
    words = []

    def traverse(offset, prefix):
        """Recursively traverse DAWG and collect words"""
        if offset >= len(data) - 4:
            return

        while True:
            node = get_node(data, offset)
            if node is None:
                break

            new_prefix = prefix + node['letter']

            if node['is_eow']:
                words.append(new_prefix)

            # Visit children if pointer is non-zero
            if node['ptr'] != 0:
                # Pointer appears to be absolute byte offset divided by 4?
                # Or it could be a direct offset
                child_offset = node['ptr'] * 4  # Try multiplying by 4
                if child_offset < len(data):
                    traverse(child_offset, new_prefix)

            offset += 4

    # Read letter index and start traversal for each letter
    for i in range(26):
        idx_offset = start_offset + i * 4
        node = get_node(data, idx_offset)
        if node:
            letter = chr(ord('a') + i)
            print(f"Processing letter '{letter}' at index offset 0x{idx_offset:04x}, "
                  f"ptr=0x{node['ptr']:04x}, flags=0x{node['flags']:02x}")

            # The pointer in the index seems to point directly into the DAWG
            # Let's try different interpretations
            child_offset = node['ptr'] * 4
            if child_offset < len(data) and child_offset >= 0x400:
                traverse(child_offset, letter)

    return words

def extract_words_v2(data):
    """
    Alternative approach: scan the entire DAWG and reconstruct words

    This approach uses the observation that each node contains its letter,
    and we can trace paths through the DAWG.
    """
    words = []
    visited = set()

    # Build adjacency structure
    # node_offset -> (letter, is_eow, children_offsets)
    nodes = {}

    # First pass: identify all valid nodes
    offset = 0x400  # Start after header
    while offset < len(data) - 4:
        node = get_node(data, offset)
        if node:
            child_offset = node['ptr'] * 4 if node['ptr'] > 0 else None
            nodes[offset] = {
                'letter': node['letter'],
                'is_eow': node['is_eow'],
                'child': child_offset,
                'ptr': node['ptr']
            }
        offset += 4

    print(f"Found {len(nodes)} valid DAWG nodes")

    # Find root nodes (nodes at index positions)
    root_offsets = []
    for i in range(26):
        idx_offset = 0x10 + i * 4
        if idx_offset < len(data) - 4:
            b0, b1 = data[idx_offset:idx_offset+2]
            ptr = (b0 << 8) | b1
            child_offset = ptr * 4
            if child_offset in nodes:
                root_offsets.append((chr(ord('a') + i), child_offset))
                print(f"Root '{chr(ord('a') + i)}' -> offset 0x{child_offset:04x}")

    def dfs(offset, prefix, depth=0):
        """Depth-first traversal of DAWG"""
        if depth > 20:  # Prevent infinite loops
            return
        if offset not in nodes:
            return

        # Process this node and siblings
        current = offset
        while current in nodes:
            node = nodes[current]
            new_prefix = prefix + node['letter']

            if node['is_eow']:
                words.append(new_prefix)

            if node['child'] and node['child'] in nodes:
                dfs(node['child'], new_prefix, depth + 1)

            # Move to sibling
            current += 4
            # Stop if we hit a non-valid node
            if current not in nodes:
                break

    # Traverse from each root
    for letter, offset in root_offsets:
        print(f"Traversing from '{letter}' at 0x{offset:04x}")
        dfs(offset, '')

    return words

def main():
    filepath = "/Volumes/T7/retrogames/oldmac/share/maven2"
    print(f"Reading {filepath}...")
    data = read_dawg(filepath)
    print(f"File size: {len(data)} bytes\n")

    # Try first method
    print("=== Method 1: Following letter index ===")
    words1 = extract_words_from_dawg(data)
    print(f"Extracted {len(words1)} words")
    if words1:
        print(f"Sample words: {sorted(words1)[:30]}")
        print(f"Longest words: {sorted(words1, key=len, reverse=True)[:10]}")

    # Try alternative method
    print("\n=== Method 2: Full DAWG scan ===")
    words2 = extract_words_v2(data)
    print(f"Extracted {len(words2)} words")
    if words2:
        print(f"Sample words: {sorted(words2)[:30]}")
        print(f"Longest words: {sorted(words2, key=len, reverse=True)[:10]}")

    # Save to file
    all_words = sorted(set(words1 + words2))
    if all_words:
        output_path = "/Volumes/T7/retrogames/oldmac/maven_re/wordlist.txt"
        with open(output_path, 'w') as f:
            for word in all_words:
                f.write(word + '\n')
        print(f"\nSaved {len(all_words)} words to {output_path}")

if __name__ == "__main__":
    main()
