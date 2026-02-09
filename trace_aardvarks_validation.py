#!/usr/bin/env python3
"""
Trace AARDVARKS validation through Maven's DAWG step by step.
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

    # Parse header
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    print(f"Header: section1={section1_end}, section2={section2_end}")

    # Parse letter index
    LETTER_INDEX_OFFSET = 0x10
    letter_index = {}
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index[chr(ord('a') + i)] = entry

    # Compute letter ranges
    letters = 'abcdefghijklmnopqrstuvwxyz'
    letter_ranges = {}
    for i, L in enumerate(letters):
        start = letter_index[L]
        end = letter_index[letters[i+1]] if i < 25 else SECTION1_END
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

    def get_siblings(start_entry, limit=500):
        siblings = []
        entry = start_entry
        while entry < SECTION1_END and len(siblings) < limit:
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    # Trace AARDVARKS
    word = "aardvarks"
    reversed_word = word[::-1]  # "skravdraa"
    print(f"\n{'='*60}")
    print(f"Tracing: '{word}' -> reversed: '{reversed_word}'")
    print(f"{'='*60}")

    first = reversed_word[0]  # 's'
    remaining = reversed_word[1:]  # 'kravdraa'

    range_start, range_end = letter_ranges[first]
    print(f"\nFirst letter '{first}' range: {range_start} to {range_end} ({range_end - range_start} entries)")

    # Show entries in this range
    print(f"\nEntries in '{first}' range:")
    entry = range_start
    sib_group_count = 0
    while entry < range_end:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue
        sib_group_count += 1
        letters_in_group = [s['letter'] for s in sibs]
        has_target = remaining[0] in letters_in_group if remaining else False
        print(f"  Group {sib_group_count} at {entry}: {letters_in_group} {'<-- has k!' if has_target else ''}")
        entry += len(sibs)

    # Now search for 'k' in the s range
    print(f"\n{'='*60}")
    print(f"Searching for '{remaining[0]}' in '{first}' range...")

    target = remaining[0]  # 'k'

    entry = range_start
    found_paths = []
    while entry < range_end:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue

        for node in sibs:
            if node['letter'] == target:
                child = get_child_entry(node)
                print(f"  Found '{target}' at entry {node['entry']}, child={child}, flags=0x{node['flags']:02x}, is_word={node['is_word']}")
                found_paths.append((node, child))

        entry += len(sibs)

    print(f"\nFound {len(found_paths)} paths with '{target}'")

    # Follow each path for remaining letters 'ravdraa'
    if found_paths:
        print(f"\n{'='*60}")
        print(f"Following paths for remaining: '{remaining[1:]}'")

        for node, child in found_paths:
            if child is None:
                print(f"  Path from entry {node['entry']}: No child")
                continue

            print(f"\n  Starting from entry {node['entry']} -> child {child}")
            path_remaining = remaining[1:]  # 'ravdraa'
            current_entry = child
            path = [remaining[0]]
            success = True

            for target_letter in path_remaining:
                sibs = get_siblings(current_entry)
                print(f"    Looking for '{target_letter}' in siblings at {current_entry}: {[s['letter'] for s in sibs]}")

                found = None
                for s in sibs:
                    if s['letter'] == target_letter:
                        found = s
                        break

                if found is None:
                    print(f"    NOT FOUND - path ends here")
                    success = False
                    break

                path.append(target_letter)
                child = get_child_entry(found)
                print(f"    Found '{target_letter}' at {found['entry']}, is_word={found['is_word']}, child={child}")

                if len(path) == len(reversed_word):
                    # Last letter - check word flag
                    if found['is_word']:
                        print(f"    *** WORD FLAG SET - '{word}' IS VALID! ***")
                    else:
                        print(f"    No word flag on final letter")
                    break

                if child is None:
                    print(f"    No more children")
                    success = False
                    break

                current_entry = child

    # Also check Section 2 for AARDVARKS
    print(f"\n{'='*60}")
    print(f"Checking Section 2 for '{word}'")
    print(f"{'='*60}")

    first_fwd = word[0]  # 'a'

    # Find all 'a' entries in Section 2
    a_entries = []
    for entry_idx in range(SECTION1_END, section2_end):
        node = get_node(entry_idx)
        if node and node['letter'] == first_fwd:
            a_entries.append(node)

    print(f"\nFound {len(a_entries)} entries starting with '{first_fwd}' in Section 2")
    print(f"First 20:")
    for node in a_entries[:20]:
        child = get_child_entry(node)
        print(f"  Entry {node['entry']}: '{node['letter']}' child={child} is_word={node['is_word']}")

    # Try to follow path 'a' -> 'a' -> 'r' -> 'd' -> 'v' -> 'a' -> 'r' -> 'k' -> 's'
    print(f"\nTrying to trace 'aardvarks' from Section 2 'a' entries...")

    remaining_fwd = word[1:]  # 'ardvarks'

    for start_node in a_entries[:50]:  # Check first 50
        child = get_child_entry(start_node)
        if child is None:
            continue

        # Try to match remaining
        current = child
        path = ['a']
        match = True

        for target in remaining_fwd:
            sibs = get_siblings(current)
            found = None
            for s in sibs:
                if s['letter'] == target:
                    found = s
                    break

            if found is None:
                match = False
                break

            path.append(target)
            if len(path) == len(word):
                if found['is_word']:
                    print(f"  Entry {start_node['entry']}: FOUND! Path: {''.join(path)} WORD=True")
                break

            child = get_child_entry(found)
            if child is None:
                match = False
                break
            current = child


if __name__ == "__main__":
    main()
