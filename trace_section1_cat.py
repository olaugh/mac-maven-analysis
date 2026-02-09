#!/usr/bin/env python3
"""
Trace 'cat' validation through Section 1 (as reversed 'tac').
"""

import struct

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    # Parse letter index
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1 = data[offset], data[offset+1]
        letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

    return data, section1_end, section2_end, letter_index

def show_entry(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0
    return {
        'entry': entry_idx,
        'letter': chr(letter) if 97 <= letter <= 122 else '?',
        'ptr': ptr,
        'flags': flags,
        'is_word': bool(flags & 0x80),
        'is_last': bool(flags & 0x01),
        'child': child,
    }

def get_siblings(data, start, section_limit):
    sibs = []
    entry = start
    while entry < section_limit:
        n = show_entry(data, entry)
        if n['letter'] == '?':
            break
        sibs.append(n)
        if n['is_last']:
            break
        entry += 1
    return sibs

def trace_section1(data, section1_end, letter_index, word):
    """Trace word through Section 1 (stores reversed words)."""
    reversed_word = word[::-1]
    print(f"\n=== Tracing '{word}' (reversed: '{reversed_word}') in Section 1 ===")

    # Get letter range for first letter of reversed word
    first = reversed_word[0]
    rest = reversed_word[1:]

    letters = 'abcdefghijklmnopqrstuvwxyz'
    idx = ord(first) - ord('a')
    range_start = letter_index[first]
    range_end = letter_index[letters[idx+1]] if idx < 25 else section1_end

    print(f"Letter '{first}' range: {range_start}-{range_end}")

    return search_section1(data, section1_end, range_start, range_end, rest, first, 1)

def search_section1(data, section1_end, range_start, range_end, remaining, prefix, depth):
    """Search Section 1 for remaining letters."""
    indent = "  " * depth

    if not remaining:
        print(f"{indent}Reached end of pattern. Checking if word...")
        return True  # Pattern matched

    target = remaining[0]
    rest = remaining[1:]

    print(f"{indent}Looking for '{target}' in range {range_start}-{min(range_start+20, range_end)}...")

    # Walk through sibling groups in the range
    entry = range_start
    groups_checked = 0
    while entry < range_end and groups_checked < 50:
        sibs = get_siblings(data, entry, range_end)
        if not sibs:
            break

        print(f"{indent}  Group at {entry}: {[s['letter'] for s in sibs]}")

        for node in sibs:
            if node['letter'] == target:
                new_prefix = prefix + node['letter']
                print(f"{indent}  FOUND '{target}' at entry {node['entry']}: is_word={node['is_word']}, child={node['child']}")

                if not rest:
                    # Last letter - check if it's a word
                    if node['is_word']:
                        print(f"{indent}  SUCCESS: '{new_prefix[::-1]}' (reversed from '{new_prefix}') is a word!")
                        return True
                    else:
                        print(f"{indent}  Pattern matched but not a word (is_word=False)")
                else:
                    # More letters - follow child
                    if node['child'] > 0 and node['child'] < section1_end:
                        if search_section1(data, section1_end, node['child'], section1_end, rest, new_prefix, depth+1):
                            return True

        entry += len(sibs)
        groups_checked += 1

    print(f"{indent}'{target}' not found in checked groups")
    return False

def main():
    data, section1_end, section2_end, letter_index = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}")

    # Test words
    for word in ['cat', 'tac', 'act', 'the', 'be', 'queen']:
        result = trace_section1(data, section1_end, letter_index, word)
        print(f"Result: {'FOUND' if result else 'NOT FOUND'}")

if __name__ == "__main__":
    main()
