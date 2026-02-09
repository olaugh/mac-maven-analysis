#!/usr/bin/env python3
"""
Complete trace of KRAVDRAA (AARDVARK reversed) path in Section 1.
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

    # Parse letter index and ranges
    LETTER_INDEX_OFFSET = 0x10
    letter_index = {}
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index[chr(ord('a') + i)] = entry

    letters = 'abcdefghijklmnopqrstuvwxyz'
    letter_ranges = {}
    for i, L in enumerate(letters):
        start = letter_index[L]
        end = letter_index[letters[i+1]] if i < 25 else section1_end
        letter_ranges[L] = (start, end)

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
        while entry < section1_end and len(siblings) < limit:
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    def find_letter_in_range(range_start, range_end, target):
        """Find all entries with target letter in the given range."""
        found = []
        entry = range_start
        while entry < range_end:
            sibs = get_siblings(entry)
            if not sibs:
                entry += 1
                continue
            for node in sibs:
                if node['letter'] == target:
                    found.append(node)
            entry += len(sibs)
        return found

    # Complete trace for KRAVDRAA
    print("=" * 60)
    print("Complete trace for KRAVDRAA (AARDVARK reversed)")
    print("=" * 60)

    k_range = letter_ranges['k']
    print(f"\nStep 1: Find 'r' in 'k' range {k_range}")
    r_nodes = find_letter_in_range(k_range[0], k_range[1], 'r')
    print(f"  Found {len(r_nodes)} 'r' entries")

    for r_node in r_nodes:
        print(f"\nPath starting from r@{r_node['entry']}:")
        child = get_child_entry(r_node)
        if not child:
            print("  No child")
            continue

        # Find 'a' in children
        sibs = get_siblings(child)
        for a_node in sibs:
            if a_node['letter'] != 'a':
                continue

            print(f"  r@{r_node['entry']} -> a@{a_node['entry']}")
            a_child = get_child_entry(a_node)
            if not a_child:
                print("    No child for a")
                continue

            # Find 'v' in a's children
            a_sibs = get_siblings(a_child)
            for v_node in a_sibs:
                if v_node['letter'] != 'v':
                    continue

                print(f"    -> v@{v_node['entry']}")
                v_child = get_child_entry(v_node)
                if not v_child:
                    print("      No child for v")
                    continue

                # Find 'd' in v's children
                v_sibs = get_siblings(v_child)
                for d_node in v_sibs:
                    if d_node['letter'] != 'd':
                        continue

                    print(f"      -> d@{d_node['entry']}")
                    d_child = get_child_entry(d_node)
                    if not d_child:
                        print("        No child for d")
                        continue

                    # Find 'r' in d's children
                    d_sibs = get_siblings(d_child)
                    for r2_node in d_sibs:
                        if r2_node['letter'] != 'r':
                            continue

                        print(f"        -> r@{r2_node['entry']}")
                        r2_child = get_child_entry(r2_node)
                        if not r2_child:
                            print("          No child for r")
                            continue

                        # Find 'a' in r's children
                        r2_sibs = get_siblings(r2_child)
                        for a2_node in r2_sibs:
                            if a2_node['letter'] != 'a':
                                continue

                            print(f"          -> a@{a2_node['entry']}")
                            a2_child = get_child_entry(a2_node)
                            if not a2_child:
                                print("            No child for a")
                                continue

                            # Find final 'a' with WORD flag
                            a2_sibs = get_siblings(a2_child)
                            for a3_node in a2_sibs:
                                if a3_node['letter'] != 'a':
                                    continue

                                print(f"            -> a@{a3_node['entry']} is_word={a3_node['is_word']}")
                                if a3_node['is_word']:
                                    print(f"\n*** KRAVDRAA FOUND! AARDVARK is valid! ***")

    # Also check for SKRAVDRAA (AARDVARKS reversed)
    print("\n" + "=" * 60)
    print("Checking SKRAVDRAA (AARDVARKS reversed)")
    print("=" * 60)

    s_range = letter_ranges['s']
    print(f"\nStep 1: Find 'k' in 's' range {s_range}")
    k_nodes = find_letter_in_range(s_range[0], s_range[1], 'k')
    print(f"  Found {len(k_nodes)} 'k' entries in 's' range")

    if not k_nodes:
        print("  No 'k' in 's' range - AARDVARKS path would not start in Section 1 's' range")

    # Maybe AARDVARKS is found differently - let's check if AARDVARK has an 's' child
    print("\n" + "=" * 60)
    print("Checking if AARDVARK has 's' extension")
    print("=" * 60)

    # We found KRAVDRAA paths ending at some 'a' node
    # Check if those final 'a' nodes have 's' children that would make AARDVARKS

    # Let me trace more systematically
    def trace_word_section1(word):
        """Trace a word through Section 1 (reversed)."""
        reversed_word = word[::-1]
        first = reversed_word[0]
        remaining = reversed_word[1:]

        range_start, range_end = letter_ranges.get(first, (0, 0))
        if range_start == 0:
            return None

        def search(entry_start, entry_end, letters):
            if not letters:
                return []  # Found the path

            target = letters[0]
            rest = letters[1:]

            results = []
            entry = entry_start
            while entry < entry_end:
                sibs = get_siblings(entry)
                if not sibs:
                    entry += 1
                    continue

                for node in sibs:
                    if node['letter'] == target:
                        if not rest:
                            # Last letter - check WORD flag
                            if node['is_word']:
                                results.append(node)
                        else:
                            child = get_child_entry(node)
                            if child and child < section1_end:
                                sub_results = search(child, section1_end, rest)
                                results.extend(sub_results)

                entry += len(sibs)

            return results

        return search(range_start, range_end, remaining)

    print("\nTracing 'aardvark' via trace_word_section1:")
    result = trace_word_section1('aardvark')
    if result:
        print(f"  FOUND! Final nodes: {[(r['entry'], r['is_word']) for r in result]}")
    else:
        print("  NOT FOUND")

    print("\nTracing 'aardvarks' via trace_word_section1:")
    result = trace_word_section1('aardvarks')
    if result:
        print(f"  FOUND! Final nodes: {[(r['entry'], r['is_word']) for r in result]}")
    else:
        print("  NOT FOUND")

    # Test with known words
    print("\n" + "=" * 60)
    print("Testing Section 1 trace with known words:")
    print("=" * 60)

    test_words = ['aa', 'ab', 'the', 'cat', 'aardvark', 'queen', 'qi']
    for word in test_words:
        result = trace_word_section1(word)
        status = "FOUND" if result else "not found"
        print(f"  '{word}': {status}")


if __name__ == "__main__":
    main()
