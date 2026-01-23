#!/usr/bin/env python3
"""
Maven DAWG Analysis Script
Analyzes the two-DAWG dictionary structure in maven2
"""

import struct
import sys
from collections import defaultdict

# Configuration
DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
H1 = 56630   # End of first DAWG
H2 = 122166  # End of second DAWG

def load_dawg():
    with open(DAWG_PATH, 'rb') as f:
        return f.read()

DATA = load_dawg()

def get_entry(idx):
    """Get entry at index: returns (ptr, flags, letter)"""
    offset = NODE_BASE + idx * 4
    ptr = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'[0x{letter_byte:02x}]'
    return ptr, flags, letter

def get_child(idx):
    """Calculate child index using ptr + (flags & 0x7e)"""
    ptr, flags, _ = get_entry(idx)
    if ptr == 0:
        return None
    return ptr + (flags & 0x7e)

def get_sibling_group(start_idx, max_idx=H2):
    """Get all entries in sibling group starting at start_idx"""
    siblings = []
    j = start_idx
    while j < max_idx:
        ptr, flags, letter = get_entry(j)
        siblings.append((j, ptr, flags, letter))
        if flags & 0x01:  # LAST flag
            break
        j += 1
    return siblings

def find_group_start(idx):
    """Find the first entry of the sibling group containing idx"""
    j = idx
    while j > 0:
        _, prev_flags, _ = get_entry(j - 1)
        if prev_flags & 0x01:  # Previous is LAST, so j is start
            break
        j -= 1
    return j

def build_parent_map():
    """Build reverse map: sibling_group_start -> list of parent entries"""
    parent_map = defaultdict(list)
    for i in range(H2):
        ptr, flags, letter = get_entry(i)
        if ptr > 0:
            child = get_child(i)
            if child and child < H2:
                parent_map[child].append(i)
    return parent_map

def trace_word_forward(word, start_range=H1, end_range=H2):
    """Try to find forward word paths in given range"""
    paths = []
    word = word.lower()

    for start_idx in range(start_range, end_range):
        ptr, flags, letter = get_entry(start_idx)
        if letter != word[0] or ptr == 0:
            continue

        # Try to trace the word
        path = [(start_idx, word[0])]
        current_child = get_child(start_idx)

        for next_letter in word[1:]:
            if not current_child or current_child >= H2:
                break

            # Find next_letter in siblings
            found = False
            siblings = get_sibling_group(current_child)
            for idx, p, f, l in siblings:
                if l == next_letter:
                    path.append((idx, l))
                    current_child = get_child(idx) if p > 0 else None
                    found = True
                    break

            if not found:
                break

        if len(path) == len(word):
            # Check if last entry has WORD marker
            last_idx = path[-1][0]
            _, flags, _ = get_entry(last_idx)
            if flags & 0x80:
                paths.append(path)

    return paths

def trace_back_from_entry(idx, parent_map, max_depth=10):
    """Trace backwards from an entry to find all paths to it"""
    def recurse(current_idx, depth):
        if depth > max_depth:
            return [[]]

        group_start = find_group_start(current_idx)

        if group_start not in parent_map:
            return [[(current_idx, get_entry(current_idx)[2])]]

        all_paths = []
        for parent_idx in parent_map[group_start]:
            parent_paths = recurse(parent_idx, depth + 1)
            for path in parent_paths:
                _, _, letter = get_entry(current_idx)
                all_paths.append(path + [(current_idx, letter)])

        return all_paths if all_paths else [[(current_idx, get_entry(current_idx)[2])]]

    return recurse(idx, 0)

def analyze_retinas():
    """Main analysis for RETINAS word"""
    print("=" * 60)
    print("RETINAS Analysis")
    print("=" * 60)

    # Check word list
    try:
        with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
            words = set(line.strip().upper() for line in f)
        print(f"\nRETINAS in SOWPODS: {'RETINAS' in words}")
        print(f"RETINA in SOWPODS: {'RETINA' in words}")
    except:
        print("Could not load word list")

    parent_map = build_parent_map()
    print(f"\nBuilt parent map with {len(parent_map)} entries")

    # Find T entries that have I->N children
    print("\n--- Finding T -> I -> N paths ---")
    t_in_paths = []

    for t_idx in range(H2):
        t_ptr, t_flags, t_letter = get_entry(t_idx)
        if t_letter != 't' or t_ptr == 0:
            continue

        t_child = get_child(t_idx)
        if not t_child or t_child >= H2:
            continue

        # Look for 'i' in children
        for i_idx, i_ptr, i_flags, i_letter in get_sibling_group(t_child):
            if i_letter == 'i' and i_ptr > 0:
                i_child = get_child(i_idx)
                if not i_child or i_child >= H2:
                    continue

                # Look for 'n' in i's children
                for n_idx, n_ptr, n_flags, n_letter in get_sibling_group(i_child):
                    if n_letter == 'n':
                        t_in_paths.append((t_idx, i_idx, n_idx))
                        break

    print(f"Found {len(t_in_paths)} T -> I -> N paths")

    # For first few, trace back to find what leads to T
    print("\n--- Tracing back from T -> I -> N entries ---")
    for t_idx, i_idx, n_idx in t_in_paths[:5]:
        print(f"\nT@{t_idx} -> I@{i_idx} -> N@{n_idx}")

        # What points to T's sibling group?
        t_group = find_group_start(t_idx)
        print(f"  T's group starts at {t_group}")

        if t_group in parent_map:
            parents = parent_map[t_group][:5]
            print(f"  Parents: {parents}")

            for p_idx in parents[:2]:
                p_ptr, p_flags, p_letter = get_entry(p_idx)
                print(f"    Parent@{p_idx}: '{p_letter}'")

                # What points to parent's group?
                p_group = find_group_start(p_idx)
                if p_group in parent_map:
                    grandparents = parent_map[p_group][:3]
                    for gp_idx in grandparents:
                        _, _, gp_letter = get_entry(gp_idx)
                        print(f"      Grandparent@{gp_idx}: '{gp_letter}'")
        else:
            print(f"  No parents found for T's group")

    # Try different approach: search for ANITER (RETINA reversed) in first DAWG
    print("\n--- Searching for ANITER (RETINA reversed) ---")
    aniter_paths = trace_word_forward('aniter', 0, H1)
    print(f"Found {len(aniter_paths)} ANITER paths in first DAWG")
    for path in aniter_paths[:3]:
        print(f"  {[f'{l}@{i}' for i, l in path]}")

    # Search for RETINA forward in second DAWG
    print("\n--- Searching for RETINA (forward) ---")
    retina_paths = trace_word_forward('retina', H1, H2)
    print(f"Found {len(retina_paths)} RETINA paths in second DAWG")

    retina_1st = trace_word_forward('retina', 0, H1)
    print(f"Found {len(retina_1st)} RETINA paths in first DAWG")

def analyze_structure():
    """General structure analysis"""
    print("=" * 60)
    print("DAWG Structure Analysis")
    print("=" * 60)

    # Count entries by section
    print(f"\nFirst DAWG: entries 0 - {H1-1}")
    print(f"Second DAWG: entries {H1} - {H2-1}")

    # Letter distribution
    letter_counts_1 = defaultdict(int)
    letter_counts_2 = defaultdict(int)

    for i in range(H1):
        _, _, letter = get_entry(i)
        letter_counts_1[letter] += 1

    for i in range(H1, H2):
        _, _, letter = get_entry(i)
        letter_counts_2[letter] += 1

    print("\nLetter distribution (first 10):")
    print("First DAWG:", dict(sorted(letter_counts_1.items())[:10]))
    print("Second DAWG:", dict(sorted(letter_counts_2.items())[:10]))

    # Ptr distribution
    ptr_counts = defaultdict(int)
    for i in range(H1):
        ptr, _, _ = get_entry(i)
        ptr_counts[ptr] += 1

    print("\nMost common ptr values in first DAWG:")
    for ptr, count in sorted(ptr_counts.items(), key=lambda x: -x[1])[:10]:
        print(f"  ptr={ptr}: {count}")

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'structure':
        analyze_structure()
    else:
        analyze_retinas()
