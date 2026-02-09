#!/usr/bin/env python3
"""
Analyze Section 2 structure more carefully.
Find what makes it work for validation.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01
SECTION1_END = 56630

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    print(f"Section 1: 0 - {section1_end}")
    print(f"Section 2: {section1_end} - {section2_end}")

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

    def get_siblings(start_entry, limit=50):
        siblings = []
        entry = start_entry
        while len(siblings) < limit:
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    # Section 2 'a' entries that successfully validated words
    print(f"\n{'='*60}")
    print("Analyzing Section 2 'a' entries that work for validation...")

    # We know AA works via Section 2 entry 56675
    # Let's look at that entry and understand the pattern
    entry_56675 = get_node(56675)
    print(f"\nEntry 56675 (validates 'aa'): {entry_56675}")
    child = get_child_entry(entry_56675)
    print(f"  Child entry: {child}")
    if child:
        sibs = get_siblings(child)
        print(f"  Child siblings: {[s['letter'] for s in sibs]}")
        for s in sibs:
            print(f"    {s['letter']}@{s['entry']}: is_word={s['is_word']}")

    # Entry 56744 validates 'ab'
    entry_56744 = get_node(56744)
    print(f"\nEntry 56744 (validates 'ab'): {entry_56744}")
    child = get_child_entry(entry_56744)
    print(f"  Child entry: {child}")
    if child:
        sibs = get_siblings(child)
        print(f"  Child siblings: {[s['letter'] for s in sibs]}")
        for s in sibs:
            print(f"    {s['letter']}@{s['entry']}: is_word={s['is_word']}")

    # Now let's find ALL Section 2 entries that could start AARDVARK
    # We need 'a' entries where child has 'a' with child that has 'r'...
    print(f"\n{'='*60}")
    print("Searching for Section 2 'a' entries with deep paths...")

    # Build index of 'a' entries in Section 2
    a_entries = []
    for entry_idx in range(section1_end, section2_end):
        node = get_node(entry_idx)
        if node and node['letter'] == 'a':
            a_entries.append(node)

    print(f"Found {len(a_entries)} 'a' entries in Section 2")

    # For each, check maximum depth
    def find_max_depth(start_node, max_depth=10):
        """Find maximum traversable depth from this node."""
        def dfs(entry, depth):
            if depth >= max_depth:
                return depth
            node = get_node(entry)
            if node is None:
                return depth
            child = get_child_entry(node)
            if child is None:
                return depth
            sibs = get_siblings(child)
            if not sibs:
                return depth
            max_d = depth
            for s in sibs:
                d = dfs(s['entry'], depth + 1)
                if d > max_d:
                    max_d = d
            return max_d

        return dfs(start_node['entry'], 0)

    # Find entries with depth >= 8 (AARDVARK length)
    print("\nSection 2 'a' entries with traversal depth >= 8:")
    deep_entries = []
    for a_node in a_entries:
        depth = find_max_depth(a_node, max_depth=10)
        if depth >= 8:
            deep_entries.append((a_node, depth))

    print(f"Found {len(deep_entries)} entries with depth >= 8")

    # Show first few
    for a_node, depth in deep_entries[:20]:
        print(f"  Entry {a_node['entry']}: depth={depth}")
        # Try to trace AARDVARK
        child = get_child_entry(a_node)
        if child:
            sibs = get_siblings(child)
            letters = [s['letter'] for s in sibs]
            print(f"    -> {letters[:15]}")
            if 'a' in letters:
                a2 = next(s for s in sibs if s['letter'] == 'a')
                a2_child = get_child_entry(a2)
                if a2_child:
                    a2_sibs = get_siblings(a2_child)
                    a2_letters = [s['letter'] for s in a2_sibs]
                    print(f"    -> a -> {a2_letters[:15]}")
                    if 'r' in a2_letters:
                        print(f"    *** Has a->a->r path! ***")

    # Let's search ALL of Section 2 and Section 3 for entries that could be AARDVARK
    print(f"\n{'='*60}")
    print("Exhaustive search for AARDVARK path...")

    section3_end = struct.unpack('>I', data[8:12])[0]
    total_entries = (len(data) - NODE_START) // 4

    # Search in Section 2, 3, and beyond
    for section_name, start, end in [
        ("Section 2", section1_end, section2_end),
        ("Section 3", section2_end, section3_end),
        ("After Section 3", section3_end, min(section3_end + 30000, total_entries)),
    ]:
        print(f"\nSearching {section_name}...")
        found = 0

        for entry_idx in range(start, end):
            node = get_node(entry_idx)
            if node is None or node['letter'] != 'a':
                continue

            # Try to trace a-a-r-d-v-a-r-k
            def trace_path(entry, path_letters):
                if not path_letters:
                    return True, entry
                target = path_letters[0]
                node = get_node(entry)
                if node is None:
                    return False, None
                child = get_child_entry(node)
                if child is None:
                    return False, None
                sibs = get_siblings(child)
                for s in sibs:
                    if s['letter'] == target:
                        if len(path_letters) == 1:
                            return True, s['entry']
                        success, final = trace_path(s['entry'], path_letters[1:])
                        if success:
                            return True, final
                return False, None

            success, final_entry = trace_path(node['entry'], list('ardvark'))
            if success:
                final_node = get_node(final_entry)
                print(f"  Found path at entry {entry_idx}! Final node: {final_node}")
                found += 1
                if found >= 5:
                    break

        if found == 0:
            print(f"  No AARDVARK path found in {section_name}")


if __name__ == "__main__":
    main()
