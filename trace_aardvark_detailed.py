#!/usr/bin/env python3
"""
Detailed trace of AARDVARK path through Section 2 -> Section 1.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
SECTION1_END = 56630
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    section3_end = struct.unpack('>I', data[8:12])[0]

    print(f"Sections: 1={section1_end}, 2={section2_end}, 3={section3_end}")

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

    def find_word_from_section2(word, verbose=True):
        """
        Find a word starting from Section 2 entries.
        """
        first = word[0]
        remaining = word[1:]

        if verbose:
            print(f"\nSearching for '{word}' in Section 2...")

        # Find all first-letter entries in Section 2
        start_entries = []
        for entry_idx in range(section1_end, section2_end):
            node = get_node(entry_idx)
            if node and node['letter'] == first:
                start_entries.append(node)

        if verbose:
            print(f"  Found {len(start_entries)} '{first}' entries in Section 2")

        # Try each entry
        for start_node in start_entries:
            child = get_child_entry(start_node)
            if child is None:
                continue

            current = child
            path = [(start_node['entry'], first)]
            match = True

            for i, target in enumerate(remaining):
                sibs = get_siblings(current)

                found = None
                for s in sibs:
                    if s['letter'] == target:
                        found = s
                        break

                if found is None:
                    match = False
                    break

                path.append((found['entry'], target))

                if i == len(remaining) - 1:
                    # Last letter
                    if found['is_word']:
                        if verbose:
                            print(f"  FOUND at Section2 entry {start_node['entry']}")
                            print(f"  Path: {path}")
                        return True, path
                    else:
                        match = False
                        break

                child = get_child_entry(found)
                if child is None:
                    match = False
                    break
                current = child

        return False, []

    # Test words
    test_words = ['aa', 'ab', 'aardvark', 'aardvarks', 'queen', 'qi', 'za']

    print("=" * 60)
    print("Testing word lookups via Section 2")
    print("=" * 60)

    for word in test_words:
        found, path = find_word_from_section2(word, verbose=True)
        print(f"  '{word}': {'FOUND' if found else 'NOT FOUND'}")
        print()

    # Detailed trace for AARDVARK
    print("\n" + "=" * 60)
    print("Detailed trace for 'aardvark'")
    print("=" * 60)

    word = "aardvark"
    first = word[0]
    remaining = word[1:]  # 'ardvark'

    # Find 'a' entries in Section 2 that might lead to 'a'
    print(f"\nLooking for 'a' entries in Section 2 where child group has 'a'...")

    for entry_idx in range(section1_end, section2_end):
        node = get_node(entry_idx)
        if node and node['letter'] == 'a':
            child = get_child_entry(node)
            if child:
                sibs = get_siblings(child)
                letters = [s['letter'] for s in sibs]
                if 'a' in letters:
                    print(f"  Entry {entry_idx}: child={child}, siblings={letters}")

                    # Try to trace 'a'->'r'->'d'...
                    a_node = next((s for s in sibs if s['letter'] == 'a'), None)
                    if a_node:
                        a_child = get_child_entry(a_node)
                        if a_child:
                            a_sibs = get_siblings(a_child)
                            a_letters = [s['letter'] for s in a_sibs]
                            if 'r' in a_letters:
                                print(f"    -> 'a'@{a_node['entry']} -> child={a_child}, sibs={a_letters}")

                                r_node = next((s for s in a_sibs if s['letter'] == 'r'), None)
                                if r_node:
                                    r_child = get_child_entry(r_node)
                                    if r_child:
                                        r_sibs = get_siblings(r_child)
                                        r_letters = [s['letter'] for s in r_sibs]
                                        if 'd' in r_letters:
                                            print(f"    -> 'r'@{r_node['entry']} -> child={r_child}, sibs={r_letters}")

                                            d_node = next((s for s in r_sibs if s['letter'] == 'd'), None)
                                            if d_node:
                                                d_child = get_child_entry(d_node)
                                                if d_child:
                                                    d_sibs = get_siblings(d_child)
                                                    d_letters = [s['letter'] for s in d_sibs]
                                                    if 'v' in d_letters:
                                                        print(f"    -> 'd'@{d_node['entry']} -> child={d_child}, sibs={d_letters}")

                                                        v_node = next((s for s in d_sibs if s['letter'] == 'v'), None)
                                                        if v_node:
                                                            v_child = get_child_entry(v_node)
                                                            if v_child:
                                                                v_sibs = get_siblings(v_child)
                                                                v_letters = [s['letter'] for s in v_sibs]
                                                                if 'a' in v_letters:
                                                                    print(f"    -> 'v'@{v_node['entry']} -> child={v_child}, sibs={v_letters}")

                                                                    a2_node = next((s for s in v_sibs if s['letter'] == 'a'), None)
                                                                    if a2_node:
                                                                        a2_child = get_child_entry(a2_node)
                                                                        if a2_child:
                                                                            a2_sibs = get_siblings(a2_child)
                                                                            a2_letters = [s['letter'] for s in a2_sibs]
                                                                            if 'r' in a2_letters:
                                                                                print(f"    -> 'a'@{a2_node['entry']} -> child={a2_child}, sibs={a2_letters}")

                                                                                r2_node = next((s for s in a2_sibs if s['letter'] == 'r'), None)
                                                                                if r2_node:
                                                                                    r2_child = get_child_entry(r2_node)
                                                                                    if r2_child:
                                                                                        r2_sibs = get_siblings(r2_child)
                                                                                        r2_letters = [s['letter'] for s in r2_sibs]
                                                                                        if 'k' in r2_letters:
                                                                                            print(f"    -> 'r'@{r2_node['entry']} -> child={r2_child}, sibs={r2_letters}")

                                                                                            k_node = next((s for s in r2_sibs if s['letter'] == 'k'), None)
                                                                                            if k_node:
                                                                                                print(f"    -> 'k'@{k_node['entry']} is_word={k_node['is_word']}")
                                                                                                if k_node['is_word']:
                                                                                                    print(f"    *** AARDVARK FOUND! ***")

                                                                                                # Check for 's' continuation
                                                                                                k_child = get_child_entry(k_node)
                                                                                                if k_child:
                                                                                                    k_sibs = get_siblings(k_child)
                                                                                                    k_letters = [s['letter'] for s in k_sibs]
                                                                                                    print(f"    -> 'k'@{k_node['entry']} -> child={k_child}, sibs={k_letters}")
                                                                                                    if 's' in k_letters:
                                                                                                        s_node = next((s for s in k_sibs if s['letter'] == 's'), None)
                                                                                                        if s_node:
                                                                                                            print(f"    -> 's'@{s_node['entry']} is_word={s_node['is_word']}")
                                                                                                            if s_node['is_word']:
                                                                                                                print(f"    *** AARDVARKS FOUND! ***")


if __name__ == "__main__":
    main()
