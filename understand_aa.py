#!/usr/bin/env python3
"""
Deeply understand how AA validation works to find what's different about AARDVARK.
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

    # Trace AA exactly
    print("=" * 60)
    print("Tracing AA validation:")
    print("=" * 60)

    # AA validates via Section 2 entry 56675
    print("\nStep 1: Find 'a' entry in Section 2")
    print("  Entry 56675 was identified as working for 'aa'")

    node_56675 = get_node(56675)
    print(f"\n  Node 56675: {node_56675}")
    print(f"    letter: '{node_56675['letter']}'")
    print(f"    ptr: {node_56675['ptr']}")
    print(f"    flags: 0x{node_56675['flags']:02x}")
    print(f"    is_word: {node_56675['is_word']}")

    child = get_child_entry(node_56675)
    print(f"    child_entry: ptr({node_56675['ptr']}) + (flags & 0x7e)({node_56675['flags'] & 0x7e}) = {child}")

    print("\nStep 2: Look for second 'a' at child entry")
    sibs = get_siblings(child)
    print(f"  Siblings at {child}: {[(s['letter'], s['entry'], s['is_word']) for s in sibs]}")

    # Found: [('a', 179, True)]
    # Entry 179 has letter 'a' with is_word=True
    # This makes AA valid!

    a_node = sibs[0] if sibs and sibs[0]['letter'] == 'a' else None
    if a_node:
        print(f"\n  Found 'a' at {a_node['entry']}: {a_node}")
        print(f"    is_word = {a_node['is_word']} -> AA IS VALID!")

    # Now let's see what comes after AA
    if a_node:
        print("\nStep 3: What words extend AA?")
        aa_child = get_child_entry(a_node)
        print(f"  Child of 'aa': {aa_child}")
        if aa_child:
            aa_sibs = get_siblings(aa_child)
            print(f"  Siblings: {[(s['letter'], s['entry'], s['is_word']) for s in aa_sibs]}")
            # These would be valid 3rd letters after AA

            # Check for 'r' (for AAR*)
            for s in aa_sibs:
                if s['letter'] == 'r':
                    print(f"\n  Found 'r' at {s['entry']}: {s}")
                    r_child = get_child_entry(s)
                    print(f"    Child: {r_child}")
                    if r_child:
                        r_sibs = get_siblings(r_child)
                        print(f"    Siblings: {[(x['letter'], x['entry'], x['is_word']) for x in r_sibs]}")

                        # Check for 'd' (for AARD*)
                        for x in r_sibs:
                            if x['letter'] == 'd':
                                print(f"\n  Found 'd' at {x['entry']}: {x}")

    # Let's also check: how many 'a' entries in Section 2 have children with 'a'?
    print("\n" + "=" * 60)
    print("Finding all Section 2 'a' entries that lead to 'aa'...")

    aa_starts = []
    for entry_idx in range(section1_end, section2_end):
        node = get_node(entry_idx)
        if node and node['letter'] == 'a':
            child = get_child_entry(node)
            if child:
                sibs = get_siblings(child)
                for s in sibs:
                    if s['letter'] == 'a' and s['is_word']:
                        aa_starts.append(entry_idx)
                        break

    print(f"Found {len(aa_starts)} Section 2 'a' entries that validate 'aa'")
    print(f"First 10: {aa_starts[:10]}")

    # Check longest words starting from entry 56675
    print("\n" + "=" * 60)
    print("Finding longest words starting from 56675...")

    def enumerate_words(start_entry, max_depth=12):
        words = []

        def dfs(entry, word, depth):
            if depth > max_depth or len(words) > 500:
                return

            node = get_node(entry)
            if node is None:
                return

            current_word = word + node['letter']

            if node['is_word'] and len(current_word) >= 2:
                words.append(current_word)

            child = get_child_entry(node)
            if child:
                sibs = get_siblings(child)
                for s in sibs:
                    dfs(s['entry'], current_word, depth + 1)

        dfs(start_entry, '', 0)
        return words

    words_from_56675 = enumerate_words(56675, max_depth=15)
    print(f"Found {len(words_from_56675)} words starting from 56675")

    # Sort by length
    by_length = {}
    for w in words_from_56675:
        n = len(w)
        if n not in by_length:
            by_length[n] = []
        by_length[n].append(w)

    print("\nDistribution:")
    for length in sorted(by_length.keys()):
        sample = by_length[length][:5]
        print(f"  {length} letters: {len(by_length[length])} words - {sample}...")

    # Check if AARDVARK-related words exist
    aard_words = [w for w in words_from_56675 if w.startswith('aar')]
    print(f"\nWords starting with 'aar': {aard_words}")


if __name__ == "__main__":
    main()
