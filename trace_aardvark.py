#!/usr/bin/env python3
"""
Trace AARDVARK/AARDVARKS path through Maven's DAWG to find validation bug.

AARDVARK reversed = KRAVDRAA (ends in K, so look up 'k' index)
AARDVARKS reversed = SKRAVDRAA (ends in S, so look up 's' index)
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    # Parse header
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    section3_end = struct.unpack('>I', data[8:12])[0]

    print(f"Header: section1={section1_end}, section2={section2_end}, section3={section3_end}")

    LETTER_INDEX_OFFSET = 0x10
    NODE_START = 0x410

    # Parse letter index
    letter_index = {}
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index[chr(ord('a') + i)] = entry
        print(f"  {chr(ord('a')+i)}: entry={entry}")

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
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'entry': entry_idx,
        }

    def get_child_entry(node):
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def show_siblings(start_entry, limit=50):
        """Show all siblings starting from an entry."""
        print(f"\n  Siblings from entry {start_entry}:")
        entry = start_entry
        count = 0
        while count < limit:
            node = get_node(entry)
            if node is None:
                print(f"    entry {entry}: INVALID")
                break
            child = get_child_entry(node)
            word_mark = " [WORD]" if node['is_word'] else ""
            last_mark = " [LAST]" if node['is_last'] else ""
            print(f"    entry {entry}: '{node['letter']}' ptr={node['ptr']} flags=0x{node['flags']:02x} child={child}{word_mark}{last_mark}")
            if node['is_last']:
                break
            entry += 1
            count += 1

    def find_letter_in_siblings(start_entry, target_letter, section_limit):
        """Find a letter among siblings, return the node if found."""
        entry = start_entry
        seen = set()
        while entry not in seen:
            seen.add(entry)
            if entry >= section_limit:
                return None
            node = get_node(entry)
            if node is None:
                return None
            if node['letter'] == target_letter:
                return node
            if node['is_last']:
                return None
            entry += 1
        return None

    # Trace AARDVARK (reversed = KRAVDRAA)
    print("\n" + "="*60)
    print("Tracing AARDVARK (reversed = KRAVDRAA)")
    print("="*60)

    # Start from 'k' index (last letter of AARDVARK)
    k_start = letter_index['k']
    print(f"\n'k' index points to entry {k_start}")
    show_siblings(k_start)

    # The 'k' index gives us entries for words ending in 'k'
    # We need to find 'r' (second-to-last letter of AARDVARK) among these entries

    # Wait - I think I misunderstand. Let me re-examine.
    # If words are stored reversed, then AARDVARK = KRAVDRAA
    # The letter index for 'k' should point to entries where letter='k'
    # Then we follow children to find 'r', then 'a', etc.

    print("\nLooking for path K->R->A->V->D->R->A->A (AARDVARK reversed)")

    # Step 1: Find 'k' in the k-range - but wait, the index points to WHERE?
    # Let me check what letters are at the k index
    node_at_k = get_node(k_start)
    print(f"\nNode at k_start ({k_start}): {node_at_k}")

    # Hmm, the letter index might work differently. Let me check what the
    # extract_dictionary.py does for validation

    # Actually, looking at the working validation code:
    # - reversed_word = word[::-1]
    # - first_letter = reversed_word[0]  <- This is the LAST letter of original word
    # - start = letter_index[first_letter]
    #
    # So for AARDVARK:
    # - reversed_word = "kravdraa"
    # - first_letter = 'k'
    # - We look for the remaining letters 'r','a','v','d','r','a','a' via children

    # But wait - the index entry might NOT be a sibling group starting point.
    # Let me trace more carefully.

    print("\n" + "="*60)
    print("Alternative interpretation: Index gives letter's range start")
    print("="*60)

    # Compute letter ranges
    letters = 'abcdefghijklmnopqrstuvwxyz'
    letter_ranges = {}
    for i, L in enumerate(letters):
        start = letter_index[L]
        end = letter_index[letters[i+1]] if i < 25 else section1_end
        letter_ranges[L] = (start, end)

    print(f"\n'k' range: {letter_ranges['k']}")
    print(f"'s' range: {letter_ranges['s']}")

    # Show first few entries in k range
    k_range_start, k_range_end = letter_ranges['k']
    print(f"\nFirst 30 entries in 'k' range ({k_range_start} to {k_range_end}):")
    for i in range(min(30, k_range_end - k_range_start)):
        entry = k_range_start + i
        node = get_node(entry)
        if node:
            child = get_child_entry(node)
            print(f"  {entry}: '{node['letter']}' ptr={node['ptr']} flags=0x{node['flags']:02x} child={child} {'[WORD]' if node['is_word'] else ''} {'[LAST]' if node['is_last'] else ''}")

    # Now I need to understand: in a DAWG for reversed words,
    # the k index should have entries for all words ending in K.
    # But are they all 'k' letters, or first letters of reversed suffixes?

    print("\n" + "="*60)
    print("Checking if Section 2 is needed for lookup")
    print("="*60)

    # Section 2 starts at section1_end
    print(f"\nSection 2 starts at entry {section1_end}")
    print(f"First entries in Section 2:")
    for i in range(20):
        entry = section1_end + i
        node = get_node(entry)
        if node:
            child = get_child_entry(node)
            print(f"  {entry}: '{node['letter']}' ptr={node['ptr']} flags=0x{node['flags']:02x} child={child} {'[WORD]' if node['is_word'] else ''} {'[LAST]' if node['is_last'] else ''}")

    # Check 's' index for AARDVARKS
    print("\n" + "="*60)
    print("Checking 's' index for AARDVARKS")
    print("="*60)

    s_range_start, s_range_end = letter_ranges['s']
    print(f"'s' range: {s_range_start} to {s_range_end} ({s_range_end - s_range_start} entries)")

    # For AARDVARKS reversed = SKRAVDRAA
    # We need to find entries where following children gives K->R->A->V->D->R->A->A

    print(f"\nLooking for 'k' children from 's' range entries...")
    found_k_children = []
    for i in range(min(200, s_range_end - s_range_start)):
        entry = s_range_start + i
        node = get_node(entry)
        if node and node['letter'] == 's':
            child = get_child_entry(node)
            if child:
                # Check if child has 'k'
                child_node = get_node(child)
                if child_node:
                    # Look for 'k' in siblings
                    sib_entry = child
                    for _ in range(50):
                        sib = get_node(sib_entry)
                        if sib is None:
                            break
                        if sib['letter'] == 'k':
                            found_k_children.append((entry, child, sib_entry))
                            break
                        if sib['is_last']:
                            break
                        sib_entry += 1

    print(f"Found {len(found_k_children)} 's' entries with 'k' children")
    for s_entry, child_start, k_entry in found_k_children[:10]:
        print(f"  s@{s_entry} -> child@{child_start} -> k@{k_entry}")
        # Continue tracing: k->r->a->v->d->r->a->a
        current = k_entry
        path = ['k']
        remaining = ['r', 'a', 'v', 'd', 'r', 'a', 'a']
        success = True
        for target in remaining:
            node = get_node(current)
            if node is None:
                success = False
                break
            child = get_child_entry(node)
            if child is None:
                success = False
                break
            # Find target in child's siblings
            found = None
            sib = child
            for _ in range(100):
                sib_node = get_node(sib)
                if sib_node is None:
                    break
                if sib_node['letter'] == target:
                    found = sib_node
                    current = sib
                    path.append(target)
                    break
                if sib_node['is_last']:
                    break
                sib += 1
            if found is None:
                success = False
                break

        if success:
            # Check if final node has WORD flag
            final_node = get_node(current)
            word_flag = final_node['is_word'] if final_node else False
            print(f"    Path {'->'.join(path)} completed! WORD={word_flag}")
            if word_flag:
                print(f"    *** AARDVARKS FOUND! ***")


if __name__ == "__main__":
    main()
