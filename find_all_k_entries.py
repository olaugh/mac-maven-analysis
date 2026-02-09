#!/usr/bin/env python3
"""
Find ALL 'k' entries in the DAWG and check which have WORD flag.
Then trace backwards to find what words they represent.
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
    section2_end = struct.unpack('>I', data[4:8])[0]
    section3_end = struct.unpack('>I', data[8:12])[0]
    total_entries = (len(data) - NODE_START) // 4

    print(f"Sections: 1={section1_end}, 2={section2_end}, 3={section3_end}")
    print(f"Total entries in file: {total_entries}")

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

    def get_siblings(start_entry, limit=100):
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

    # Find all 'k' entries with WORD flag (could be end of word ending in K)
    print(f"\n{'='*60}")
    print("Finding 'k' entries with WORD flag...")

    k_word_entries = []
    for entry_idx in range(total_entries):
        node = get_node(entry_idx)
        if node and node['letter'] == 'k' and node['is_word']:
            k_word_entries.append(node)

    print(f"Found {len(k_word_entries)} 'k' entries with WORD flag")

    # For each, check if child has 's' with WORD flag (for plurals)
    print(f"\nChecking which have 's' children (for plurals like AARDVARKS)...")

    k_with_s = []
    for k_node in k_word_entries:
        child = get_child_entry(k_node)
        if child:
            sibs = get_siblings(child)
            for s in sibs:
                if s['letter'] == 's' and s['is_word']:
                    k_with_s.append((k_node, s))
                    break

    print(f"Found {len(k_with_s)} 'k' entries that have 's' children with WORD flag")
    print("\nFirst 20:")
    for k_node, s_node in k_with_s[:20]:
        print(f"  k@{k_node['entry']:6d} -> s@{s_node['entry']:6d}")

    # Now let's trace back from entry 56783 to see what word it makes
    # Actually, let's check if there's a specific pattern we can trace

    print(f"\n{'='*60}")
    print("Checking if any 'k' entry is at end of a->a->r->d->v->a->r path...")

    # For this, we need to build a reverse mapping
    # Find all entries that point TO each k entry
    print("\nBuilding reverse pointer map...")

    # ptr + (flags & 0x7e) = child_entry
    # So we need to find entries where child = k_entry

    pointing_to = {k['entry']: [] for k, s in k_with_s}

    for entry_idx in range(total_entries):
        node = get_node(entry_idx)
        if node:
            child = get_child_entry(node)
            if child in pointing_to:
                pointing_to[child].append(node)

    print(f"Built reverse map for {len(pointing_to)} k entries")

    # Now trace back from each k to see if we can spell r-a-v-d-r-a-a backwards
    print("\nTracing back from 'k' entries to find AARDVARK pattern...")

    def trace_back(entry, path, depth=0):
        """Trace backwards to find what word this k is part of."""
        if depth > 10:
            return []

        results = []

        for entry_idx in range(total_entries):
            node = get_node(entry_idx)
            if node:
                child = get_child_entry(node)
                if child and child <= entry and entry < child + 26:  # rough check
                    # This entry might point to a sibling group containing our entry
                    sibs = get_siblings(child)
                    for sib in sibs:
                        if sib['entry'] == entry:
                            # Found a path!
                            new_path = [node['letter']] + path
                            if len(new_path) >= 8:
                                results.append(new_path)
                            results.extend(trace_back(entry_idx, new_path, depth + 1))
                            break

        return results

    # This is too slow. Let's try a different approach.
    # Check what entries 122193 'k' might represent

    print(f"\n{'='*60}")
    print("Examining entry 122193 (first 'k' in Section 3)...")

    node_122193 = get_node(122193)
    if node_122193:
        print(f"Entry 122193: {node_122193}")
        child = get_child_entry(node_122193)
        if child:
            sibs = get_siblings(child)
            print(f"Children: {[s['letter'] for s in sibs]}")

    # Let's try the ptr value directly
    print(f"\n{'='*60}")
    print("Checking if ptr values directly indicate structure...")

    # The node at 122193 has ptr=4, flags=0x07
    # child = 4 + (0x07 & 0x7e) = 4 + 0x06 = 10
    # Entry 10 is in Section 1 (far in)

    print("\nLooking at low-numbered entries (0-200):")
    for i in range(200):
        node = get_node(i)
        if node:
            child = get_child_entry(node)
            print(f"  {i:3d}: '{node['letter']}' ptr={node['ptr']:4d} flags=0x{node['flags']:02x} child={child} {'[W]' if node['is_word'] else ''} {'[L]' if node['is_last'] else ''}")


if __name__ == "__main__":
    main()
