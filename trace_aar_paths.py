#!/usr/bin/env python3
"""
Trace the a->a->r paths found in Section 2 to see what words they form.
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

    # Trace entry 56784
    print("=" * 60)
    print("Tracing from entry 56784 (has a->a->r path)")
    print("=" * 60)

    def enumerate_words(start_entry, prefix="", max_words=100):
        words = []

        def dfs(entry, word):
            if len(words) >= max_words:
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
                    dfs(s['entry'], current_word)

        dfs(start_entry, prefix)
        return words

    entry_56784 = get_node(56784)
    print(f"Entry 56784: {entry_56784}")

    # Get children
    child = get_child_entry(entry_56784)
    print(f"Child: {child}")
    if child:
        sibs = get_siblings(child)
        print(f"Children: {[(s['letter'], s['entry']) for s in sibs]}")

        # Find 'a' in children
        a_sib = next((s for s in sibs if s['letter'] == 'a'), None)
        if a_sib:
            print(f"\nFollowing 'a' at {a_sib['entry']}:")
            a_child = get_child_entry(a_sib)
            if a_child:
                a_sibs = get_siblings(a_child)
                print(f"  Children of 'a': {[(s['letter'], s['entry']) for s in a_sibs]}")

                # Find 'r' in a's children
                r_sib = next((s for s in a_sibs if s['letter'] == 'r'), None)
                if r_sib:
                    print(f"\n  Following 'r' at {r_sib['entry']}:")
                    r_child = get_child_entry(r_sib)
                    if r_child:
                        r_sibs = get_siblings(r_child)
                        print(f"    Children of 'r': {[(s['letter'], s['entry']) for s in r_sibs]}")

    # Enumerate all words from 56784
    print(f"\nEnumerating all words from 56784:")
    words = enumerate_words(56784, "", max_words=200)
    print(f"Found {len(words)} words")

    # Group by prefix
    by_prefix = {}
    for w in words:
        prefix = w[:3] if len(w) >= 3 else w
        if prefix not in by_prefix:
            by_prefix[prefix] = []
        by_prefix[prefix].append(w)

    print("\nWords grouped by 3-letter prefix:")
    for prefix in sorted(by_prefix.keys()):
        print(f"  {prefix}: {by_prefix[prefix][:10]}")

    # Same for entry 56827
    print("\n" + "=" * 60)
    print("Tracing from entry 56827 (has a->a->r path)")
    print("=" * 60)

    entry_56827 = get_node(56827)
    print(f"Entry 56827: {entry_56827}")

    child = get_child_entry(entry_56827)
    print(f"Child: {child}")
    if child:
        sibs = get_siblings(child)
        print(f"Children: {[(s['letter'], s['entry']) for s in sibs]}")

        a_sib = next((s for s in sibs if s['letter'] == 'a'), None)
        if a_sib:
            print(f"\nFollowing 'a' at {a_sib['entry']}:")
            a_child = get_child_entry(a_sib)
            if a_child:
                a_sibs = get_siblings(a_child)
                print(f"  Children of 'a': {[(s['letter'], s['entry']) for s in a_sibs]}")

    words2 = enumerate_words(56827, "", max_words=200)
    print(f"\nFound {len(words2)} words")

    by_prefix2 = {}
    for w in words2:
        prefix = w[:3] if len(w) >= 3 else w
        if prefix not in by_prefix2:
            by_prefix2[prefix] = []
        by_prefix2[prefix].append(w)

    print("\nWords grouped by 3-letter prefix:")
    for prefix in sorted(by_prefix2.keys()):
        print(f"  {prefix}: {by_prefix2[prefix][:10]}")

    # Check for AARDVARK variants
    print("\n" + "=" * 60)
    print("Checking for AARDVARK-like patterns in all words found:")
    all_words = set(words + words2)
    aard_words = [w for w in all_words if w.startswith('aar')]
    print(f"Words starting with 'aar': {sorted(aard_words)}")


if __name__ == "__main__":
    main()
