#!/usr/bin/env python3
"""
Trace what word(s) actually use entry 106 with is_word=True.
"""

import struct

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    section1_end = struct.unpack('>I', data[0:4])[0]
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1 = data[offset], data[offset+1]
        letter_index[chr(ord('a') + i)] = (b0 << 8) | b1
    return data, section1_end, letter_index

def get_node(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0
    return {
        'letter': chr(letter) if 97 <= letter <= 122 else '?',
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': child,
        'entry': entry_idx,
    }

def get_siblings(data, start, limit):
    sibs = []
    entry = start
    while entry < limit:
        node = get_node(data, entry)
        if node is None or node['letter'] == '?':
            break
        sibs.append(node)
        if node['is_last']:
            break
        entry += 1
    return sibs

def trace_back(data, section1_end, letter_index, target_entry, max_depth=5):
    """Find all paths that lead to target_entry."""

    # Build reverse index: for each entry, who are its parents?
    # (nodes whose child sibling group contains this entry)
    parents = {}  # entry -> list of parent entries

    for idx in range(section1_end):
        node = get_node(data, idx)
        if node and node['child']:
            sibs = get_siblings(data, node['child'], section1_end)
            for s in sibs:
                if s['entry'] not in parents:
                    parents[s['entry']] = []
                parents[s['entry']].append(idx)

    # Also, find which entries are roots (reachable from letter_index)
    roots = {}
    for letter, start in letter_index.items():
        sibs = get_siblings(data, start, section1_end)
        for s in sibs:
            roots[s['entry']] = letter

    # Now DFS from target back to roots
    paths = []

    def dfs(entry, path, depth):
        if depth > max_depth:
            return

        if entry in roots:
            # Reached a root
            paths.append([roots[entry]] + path)
            return

        if entry in parents:
            for parent in parents[entry]:
                parent_node = get_node(data, parent)
                dfs(parent, [parent_node['letter']] + path, depth + 1)

    target_node = get_node(data, target_entry)
    dfs(target_entry, [target_node['letter']], 0)

    return paths

def main():
    data, section1_end, letter_index = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print("="*60)
    print("Tracing what word paths use entry 106 (the 'c' with is_word=True)")
    print("="*60)

    node_106 = get_node(data, 106)
    print(f"\nEntry 106: letter='{node_106['letter']}', is_word={node_106['is_word']}")

    paths = trace_back(data, section1_end, letter_index, 106)

    print(f"\nFound {len(paths)} paths leading to entry 106:")
    print("(Remember: Section 1 stores REVERSED words)")

    # Group by length
    by_length = {}
    for p in paths:
        n = len(p)
        if n not in by_length:
            by_length[n] = []
        by_length[n].append(p)

    for length in sorted(by_length.keys()):
        print(f"\n{length}-letter paths (showing up to 20):")
        for p in by_length[length][:20]:
            reversed_path = ''.join(p)
            forward_word = reversed_path[::-1]
            print(f"  {reversed_path} -> (forward) '{forward_word}'")
        if len(by_length[length]) > 20:
            print(f"  ... and {len(by_length[length]) - 20} more")

    # The key insight: entry 106 has is_word=True, which means
    # at least ONE of these paths represents a complete word.
    # Let's see which 2-letter reversed paths exist

    print("\n" + "="*60)
    print("2-letter paths (where the 'c' at entry 106 has is_word=True)")
    print("="*60)

    two_letter = [p for p in paths if len(p) == 2]
    if two_letter:
        for p in two_letter:
            reversed_path = ''.join(p)
            forward_word = reversed_path[::-1]
            print(f"  '{reversed_path}' reversed -> '{forward_word}'")
            print(f"    If is_word=True here, '{forward_word}' should be a word")
    else:
        print("  No 2-letter paths found!")
        print("  This means 'AC' cannot be valid based on entry 106")

    # Check some known 3-letter words
    print("\n" + "="*60)
    print("Checking 3-letter paths for known words like ACE, ACT")
    print("="*60)

    three_letter = [p for p in paths if len(p) == 3]
    for p in three_letter[:30]:
        reversed_path = ''.join(p)
        forward_word = reversed_path[::-1]
        print(f"  '{reversed_path}' -> '{forward_word}'")


if __name__ == "__main__":
    main()
