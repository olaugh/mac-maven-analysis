#!/usr/bin/env python3
"""
Trace the DAWG structure to understand what entry 484 represents.
"""

import struct

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    section1_end = struct.unpack('>I', data[0:4])[0]
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1 = data[offset], data[offset+1]
        letter_index[chr(ord('a') + i)] = (b0 << 8) | b1
    return data, section1_end, letter_index

def get_node(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0
    return {
        'letter': chr(letter) if 97 <= letter <= 122 else f'0x{letter:02x}',
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': child,
        'entry': entry_idx,
    }

def get_siblings(data, start, limit):
    sibs = []
    entry = start
    while entry < limit:
        node = get_node(data, entry)
        if node is None or node['letter'].startswith('0x'):
            break
        sibs.append(node)
        if node['is_last']:
            break
        entry += 1
    return sibs

def find_parents(data, section1_end, target_entry):
    """Find all nodes whose child pointer leads to the sibling group containing target_entry."""
    # First, find what sibling group target_entry is in
    # (entries are consecutive until is_last=True)

    parents = []
    for entry_idx in range(section1_end):
        node = get_node(data, entry_idx)
        if node and node['child']:
            # Check if child points near target
            child = node['child']
            if child <= target_entry:
                # Get siblings from child
                sibs = get_siblings(data, child, section1_end)
                sib_entries = [s['entry'] for s in sibs]
                if target_entry in sib_entries:
                    parents.append(node)
    return parents

def trace_path_to_entry(data, section1_end, letter_index, target_entry, max_depth=10):
    """Try to find what word path leads to target_entry."""

    # Find immediate parents
    parents = find_parents(data, section1_end, target_entry)

    print(f"\nEntry {target_entry} is a child of {len(parents)} parent nodes:")
    for p in parents[:10]:
        print(f"  Entry {p['entry']}: letter='{p['letter']}', is_word={p['is_word']}")

        # Find grandparents
        grandparents = find_parents(data, section1_end, p['entry'])
        for gp in grandparents[:3]:
            print(f"    <- Entry {gp['entry']}: letter='{gp['letter']}'")

            # Find great-grandparents
            ggps = find_parents(data, section1_end, gp['entry'])
            for ggp in ggps[:2]:
                print(f"      <- Entry {ggp['entry']}: letter='{ggp['letter']}'")

def main():
    data, section1_end, letter_index = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print("="*60)
    print("Understanding the 'c' range structure")
    print("="*60)

    # Show the letter_index for 'c'
    c_start = letter_index['c']
    d_start = letter_index['d']
    print(f"\n'c' range: entries {c_start} to {d_start-1}")

    # Show the FIRST sibling group (the root of the 'c' subtree)
    root_sibs = get_siblings(data, c_start, section1_end)
    print(f"\nRoot sibling group at entry {c_start}:")
    for s in root_sibs:
        print(f"  Entry {s['entry']}: '{s['letter']}' is_word={s['is_word']} is_last={s['is_last']} child={s['child']}")

    # Check entry 472 (the 'a' in root sibling group)
    print("\n" + "="*60)
    print("Tracing entry 472 ('a' from root siblings)")
    print("="*60)
    node_472 = get_node(data, 472)
    print(f"Entry 472: letter='{node_472['letter']}', is_word={node_472['is_word']}, child={node_472['child']}")

    if node_472['child']:
        child_sibs = get_siblings(data, node_472['child'], section1_end)
        print(f"Children of entry 472 (at {node_472['child']}):")
        for s in child_sibs:
            print(f"  Entry {s['entry']}: '{s['letter']}' is_word={s['is_word']} child={s['child']}")

    # Now investigate entry 484
    print("\n" + "="*60)
    print("Investigating entry 484 (the 'problematic' is_word=True 'a')")
    print("="*60)

    node_484 = get_node(data, 484)
    print(f"Entry 484: letter='{node_484['letter']}', is_word={node_484['is_word']}, child={node_484['child']}")

    # What sibling group is 484 in?
    # Walk back to find the start of its sibling group
    sib_start = 484
    while sib_start > 0:
        prev_node = get_node(data, sib_start - 1)
        if prev_node is None or prev_node['is_last']:
            break
        sib_start -= 1

    sibs_of_484 = get_siblings(data, sib_start, section1_end)
    print(f"\nEntry 484's sibling group starts at {sib_start}:")
    for s in sibs_of_484:
        marker = " <-- entry 484" if s['entry'] == 484 else ""
        print(f"  Entry {s['entry']}: '{s['letter']}' is_word={s['is_word']} child={s['child']}{marker}")

    # Find parents of this sibling group
    print("\nFinding parent(s) of this sibling group...")
    trace_path_to_entry(data, section1_end, letter_index, 484)

    # Now let's trace what word path leads here
    # by walking DOWN from the 'c' root
    print("\n" + "="*60)
    print("Correct validation: Only follow child pointers from root")
    print("="*60)

    # For "ac" reversed = "ca"
    # Start at 'c' root (entry 471)
    # Look for 'a' in root siblings -> entry 472 with is_word=False
    print("\nValidating 'ac' correctly:")
    print("  1. Reversed: 'ca'")
    print("  2. First letter 'c' -> root at entry", c_start)
    print("  3. Root siblings:", [f"{s['letter']}" for s in root_sibs])

    a_in_root = None
    for s in root_sibs:
        if s['letter'] == 'a':
            a_in_root = s
            break

    if a_in_root:
        print(f"  4. Found 'a' at entry {a_in_root['entry']}: is_word={a_in_root['is_word']}")
        print(f"  5. Since we need 'a' to be the LAST letter, check is_word")
        print(f"  6. is_word={a_in_root['is_word']} -> {'VALID' if a_in_root['is_word'] else 'INVALID'}")
    else:
        print("  4. 'a' not found in root siblings!")

if __name__ == "__main__":
    main()
