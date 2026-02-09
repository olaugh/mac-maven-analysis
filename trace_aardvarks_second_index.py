#!/usr/bin/env python3
"""
Try to trace AARDVARKS using the second letter index at end of file.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    file_size = len(data)
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    section3_end = struct.unpack('>I', data[8:12])[0]
    total_entries = (file_size - NODE_START) // 4

    print(f"File structure:")
    print(f"  Section 1: 0 - {section1_end}")
    print(f"  Section 2: {section1_end} - {section2_end}")
    print(f"  Section 3: {section2_end} - {section3_end}")
    print(f"  Total entries: {total_entries}")

    # Parse second letter index
    index2_start = file_size - 26 * 4
    letter_index2 = {}
    for i in range(26):
        offset = index2_start + i * 4
        b0, b1, b2, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index2[chr(ord('a') + i)] = {
            'entry': entry,
            'b2': b2,
        }

    print(f"\nSecond letter index (at 0x{index2_start:x}):")
    for L in 'aeks':
        idx = letter_index2[L]
        print(f"  {L}: entry={idx['entry']}, b2=0x{idx['b2']:02x}")

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

    # Try tracing AARDVARKS using second index
    print(f"\n{'='*60}")
    print("Trying to trace AARDVARKS from second index 'a' entry...")

    a_entry2 = letter_index2['a']['entry']
    print(f"Second index 'a' entry: {a_entry2}")

    # Check what's at this entry
    node_at_a2 = get_node(a_entry2)
    print(f"Node at {a_entry2}: {node_at_a2}")

    if node_at_a2:
        sibs = get_siblings(a_entry2)
        print(f"Siblings: {[(s['letter'], s['entry']) for s in sibs]}")

    # Maybe the second index works differently - let me check if b2 is part of the entry
    # Try combining entry and b2 as: entry + (b2 >> 1) or entry * 256 + b2
    print(f"\n{'='*60}")
    print("Trying alternative interpretations of second index...")

    a_idx = letter_index2['a']
    entry_variants = [
        a_idx['entry'],
        a_idx['entry'] + a_idx['b2'],
        a_idx['entry'] * 256 + a_idx['b2'],
        (a_idx['entry'] << 8) | a_idx['b2'],
        section1_end + a_idx['entry'],
        section2_end + a_idx['entry'],
        section3_end + a_idx['entry'],
    ]

    for var in entry_variants:
        if 0 <= var < total_entries:
            node = get_node(var)
            if node:
                print(f"  Entry {var}: {node}")

    # Search for AARDVARK path in the entire file
    print(f"\n{'='*60}")
    print("Exhaustive search for any path spelling AARDVARKS...")

    # Find all 'a' entries that could start the word
    # Check if following a-a-r-d-v-a-r-k-s works

    def find_aardvarks():
        """Search entire file for AARDVARKS path."""
        found = []

        for start_entry in range(total_entries):
            node = get_node(start_entry)
            if node is None or node['letter'] != 'a':
                continue

            # Try to trace a-a-r-d-v-a-r-k-s
            path = [('a', start_entry)]
            current = start_entry
            remaining = list('ardvarks')

            for target in remaining:
                node = get_node(current)
                if node is None:
                    break

                child = get_child_entry(node)
                if child is None:
                    break

                sibs = get_siblings(child)
                found_next = None
                for s in sibs:
                    if s['letter'] == target:
                        found_next = s
                        break

                if found_next is None:
                    break

                path.append((target, found_next['entry']))
                current = found_next['entry']

                if len(path) == 9:  # Full word found
                    final_node = get_node(current)
                    if final_node and final_node['is_word']:
                        found.append((start_entry, path))
                        return found  # Return first match

        return found

    print("Searching... (this may take a while)")
    results = find_aardvarks()

    if results:
        for start, path in results:
            print(f"\nFOUND AARDVARKS starting at entry {start}!")
            print(f"Path: {path}")
    else:
        print("\nNo AARDVARKS path found in entire file")

        # Try just AARDVARK (without S)
        print("\nSearching for AARDVARK (without S)...")

        def find_aardvark():
            for start_entry in range(total_entries):
                node = get_node(start_entry)
                if node is None or node['letter'] != 'a':
                    continue

                path = [('a', start_entry)]
                current = start_entry
                remaining = list('ardvark')

                for target in remaining:
                    node = get_node(current)
                    if node is None:
                        break
                    child = get_child_entry(node)
                    if child is None:
                        break
                    sibs = get_siblings(child)
                    found_next = None
                    for s in sibs:
                        if s['letter'] == target:
                            found_next = s
                            break
                    if found_next is None:
                        break
                    path.append((target, found_next['entry']))
                    current = found_next['entry']

                    if len(path) == 8:  # AARDVARK found
                        return [(start_entry, path)]

            return []

        results2 = find_aardvark()
        if results2:
            for start, path in results2:
                print(f"\nFOUND AARDVARK starting at entry {start}!")
                print(f"Path: {path}")
                # Check if final node is_word
                final = get_node(path[-1][1])
                print(f"Final node: {final}")
        else:
            print("No AARDVARK path found either")


if __name__ == "__main__":
    main()
