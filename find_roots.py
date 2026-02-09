#!/usr/bin/env python3
"""
Find who points to entries with is_word=True for known 2-letter words.
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
            'base_ptr': base_ptr,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    # Build reverse index: who points to each entry?
    print("Building parent map...")
    parents = defaultdict(list)
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] > 0 and node['child'] < section1_end:
            parents[node['child']].append(i)

    # Find all entries with 'a' and is_word=True
    print("\n" + "="*60)
    print("Entries with 'a' and is_word=True (potential 'AA' endings)")
    print("="*60)

    a_word_entries = []
    for i in range(section1_end):
        node = get_node(i)
        if node['letter'] == 'a' and node['is_word']:
            a_word_entries.append(i)
            parent_list = parents.get(i, [])
            print(f"Entry {i}: 'a' is_word=True, parents={parent_list[:5]}{'...' if len(parent_list) > 5 else ''}")

    # For each 'a' is_word entry, trace back to find path
    print("\n" + "="*60)
    print("Tracing paths to 'a' is_word entries")
    print("="*60)

    for a_entry in a_word_entries[:5]:  # First 5
        print(f"\nEntry {a_entry} ('a' is_word=True):")

        # BFS backwards to find roots
        visited = {a_entry}
        queue = [(a_entry, ['a'])]
        paths_found = []

        while queue and len(paths_found) < 3:
            entry, path = queue.pop(0)

            # Who points to this entry as a child?
            for parent in parents.get(entry, []):
                if parent in visited:
                    continue
                visited.add(parent)

                p_node = get_node(parent)
                if p_node['letter']:
                    new_path = [p_node['letter']] + path

                    # Check if parent is a root (entry 0-169 for 'a')
                    if len(new_path) <= 5:
                        queue.append((parent, new_path))

                    if len(new_path) == 2:
                        # This could be a 2-letter word path
                        word = ''.join(new_path)
                        paths_found.append((parent, word))
                        print(f"  Path: entry {parent} -> {a_entry}, word = '{word}'")

    # Let's check what entry 0 looks like and trace forward
    print("\n" + "="*60)
    print("Forward trace from entry 0")
    print("="*60)

    def trace_words(start, prefix, depth, max_depth=4):
        if depth > max_depth:
            return []

        words = []
        entry = start
        seen = set()

        while entry < section1_end and entry not in seen:
            seen.add(entry)
            node = get_node(entry)

            if node['letter'] is None:
                break

            word = prefix + node['letter']

            if node['is_word']:
                words.append(word)

            if node['child'] > 0 and node['child'] < section1_end:
                words.extend(trace_words(node['child'], word, depth + 1, max_depth))

            if node['is_last']:
                break
            entry += 1

        return words

    # Trace from a few starting points
    for start in [0, 169, 282]:
        words = trace_words(start, '', 0, 3)
        print(f"\nFrom entry {start}: {len(words)} words found")
        print(f"  Sample: {words[:20]}")

    # Check if there's a true root
    print("\n" + "="*60)
    print("Looking for the REAL root structure")
    print("="*60)

    # Entries that are NOT pointed to by anyone (potential roots)
    all_children = set()
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] > 0:
            all_children.add(node['child'])

    roots = [i for i in range(min(200, section1_end)) if i not in all_children]
    print(f"Entries 0-199 not pointed to by anyone: {roots[:30]}")

if __name__ == "__main__":
    main()
