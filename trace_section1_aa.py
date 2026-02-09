#!/usr/bin/env python3
"""
Trace Section 1 validation for 'aa' to understand the structure.
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

    # Trace 'aa' validation via Section 1
    # Word 'aa' reversed is 'aa'
    # First letter 'a' -> look in letter_ranges['a']
    # Then find 'a' with is_word=True

    print("=" * 60)
    print("Tracing 'aa' validation via Section 1")
    print("=" * 60)

    a_range = letter_ranges['a']
    print(f"\n'a' range: {a_range[0]} to {a_range[1]}")

    # Scan the range for entries with letter 'a'
    print(f"\nScanning for 'a' entries in 'a' range:")
    a_entries_in_range = []
    for entry_idx in range(a_range[0], a_range[1]):
        node = get_node(entry_idx)
        if node and node['letter'] == 'a':
            a_entries_in_range.append(node)
            child = get_child_entry(node)
            print(f"  Entry {entry_idx}: letter='a', is_word={node['is_word']}, child={child}")

    print(f"\nTotal 'a' entries in 'a' range: {len(a_entries_in_range)}")

    # For 'aa' to validate, we need an 'a' entry where:
    # - The entry itself has is_word=True (for 2-letter word ending in 'a')
    # This is because 'aa' reversed is 'aa', and we're looking for second 'a' with WORD flag

    # Actually wait - the validation logic says:
    # 1. reversed_word[0] = 'a' -> look in 'a' range
    # 2. Look for reversed_word[1:] = 'a' via children
    # So we need to find entries in 'a' range, follow children, find 'a' with is_word=True

    print(f"\n" + "=" * 60)
    print("Following the actual validation logic:")
    print("=" * 60)

    # For 'aa': reversed = 'aa'
    # Search 'a' range for entries, check their children for 'a' with is_word

    print(f"\nScanning 'a' range for paths to 'a' with WORD flag:")
    entry = a_range[0]
    while entry < a_range[1]:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue

        for node in sibs:
            child = get_child_entry(node)
            if child is None or child >= section1_end:
                continue

            # Check children for 'a' with is_word
            child_sibs = get_siblings(child)
            for cs in child_sibs:
                if cs['letter'] == 'a' and cs['is_word']:
                    print(f"  Entry {node['entry']} ('{node['letter']}') -> child {child} -> 'a'@{cs['entry']} WORD!")
                    print(f"    This validates word: {node['letter']}a (reversed: a{node['letter']})")

        entry += len(sibs)

    # Hmm, that's looking for *A words (words ending in A)
    # For 'aa', we need to find the path that gives us 'aa'

    # Let me re-read the validation code logic...
    # _search_section1(entry_start, entry_end, remaining):
    #   if not remaining: return True
    #   target = remaining[0], rest = remaining[1:]
    #   scan siblings for target letter
    #   if found and no more letters and is_word: return True
    #   if found and more letters: follow child

    # For 'aa':
    # - reversed = 'aa'
    # - first_letter = 'a', remaining = 'a'
    # - Scan 'a' range for sibling groups
    # - In each group, look for 'a'
    # - If 'a' found and no more letters (remaining[1:] = ''), check is_word
    # - If is_word=True, return True

    print(f"\n" + "=" * 60)
    print("Correct trace for 'aa':")
    print("=" * 60)

    # For 'aa', remaining after first letter lookup = 'a'
    # We scan sibling groups in 'a' range, looking for letter 'a'
    # When found, if rest is empty and is_word, it's valid

    entry = a_range[0]
    found_aa = False
    while entry < a_range[1]:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue

        for node in sibs:
            if node['letter'] == 'a':
                # Found 'a', check if this is a word end
                # rest = '' (no more letters), so check is_word
                if node['is_word']:
                    print(f"  Found 'a'@{node['entry']} with is_word=True!")
                    print(f"  -> 'aa' is VALID (2-letter word)")
                    found_aa = True

        entry += len(sibs)

    if not found_aa:
        print("  'aa' NOT found in Section 1")

    # Now for 'aardvark': reversed = 'kravdraa'
    # first_letter = 'k', remaining = 'ravdraa'
    # Scan 'k' range for 'r', follow children for 'a', then 'v', etc.

    print(f"\n" + "=" * 60)
    print("Tracing 'aardvark' (reversed = 'kravdraa'):")
    print("=" * 60)

    k_range = letter_ranges['k']
    print(f"\n'k' range: {k_range[0]} to {k_range[1]}")

    # Look for 'r' in 'k' range
    entry = k_range[0]
    r_found = []
    while entry < k_range[1]:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue

        for node in sibs:
            if node['letter'] == 'r':
                r_found.append(node)
                print(f"  Found 'r'@{node['entry']}, child={get_child_entry(node)}")

        entry += len(sibs)

    print(f"\nTotal 'r' entries in 'k' range: {len(r_found)}")

    # Follow each 'r' to find 'a' (for 'avdraa')
    for r_node in r_found:
        child = get_child_entry(r_node)
        if child is None:
            continue

        # Look for 'a' in children
        child_sibs = get_siblings(child)
        for cs in child_sibs:
            if cs['letter'] == 'a':
                print(f"    'r'@{r_node['entry']} -> 'a'@{cs['entry']}")
                # Continue for 'v'...
                a_child = get_child_entry(cs)
                if a_child:
                    a_child_sibs = get_siblings(a_child)
                    for acs in a_child_sibs:
                        if acs['letter'] == 'v':
                            print(f"      -> 'v'@{acs['entry']}")


if __name__ == "__main__":
    main()
