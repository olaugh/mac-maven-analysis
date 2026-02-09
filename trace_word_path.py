#!/usr/bin/env python3
"""
Trace how words are found/validated in the DAWG.
Understand the exact path through the structure.
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

    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1 = data[offset], data[offset+1]
        letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

    return data, section1_end, section2_end, letter_index

def get_node(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    return {
        'entry': entry_idx,
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter) if 97 <= letter <= 122 else '?',
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
        'raw': f"{b0:02x}{b1:02x}{flags:02x}{letter:02x}",
    }

def trace_word_section1(data, section1_end, letter_index, word):
    """Trace a word through Section 1 (reversed)."""
    reversed_word = word[::-1]
    print(f"\n=== Tracing '{word}' (reversed: '{reversed_word}') in Section 1 ===")

    # Get range for first letter (last letter of original word)
    first = reversed_word[0]
    letters = 'abcdefghijklmnopqrstuvwxyz'
    idx = ord(first) - ord('a')
    start = letter_index[first]
    end = letter_index[letters[idx+1]] if idx < 25 else section1_end

    print(f"Starting at range for '{first}': entries {start}-{end}")

    # Walk the structure
    return _trace_from_range(data, section1_end, start, end, reversed_word[1:], first, 1)

def _trace_from_range(data, section1_end, start, end, remaining, path, depth):
    """Recursively trace through the structure."""
    indent = "  " * depth

    if not remaining:
        print(f"{indent}Reached end of pattern at path '{path}'")
        return True

    target = remaining[0]
    rest = remaining[1:]

    print(f"{indent}Looking for '{target}' in range {start}-{min(start+20, end)}...")

    # Walk siblings
    entry = start
    siblings_checked = 0
    while entry < end and siblings_checked < 100:
        node = get_node(data, entry)
        if node is None or node['letter'] == '?':
            break

        if node['letter'] == target:
            new_path = path + node['letter']
            print(f"{indent}FOUND '{target}' at entry {entry}: word={node['is_word']}, child={node['child']}, raw={node['raw']}")

            if not rest:
                # Last letter
                if node['is_word']:
                    print(f"{indent}SUCCESS: '{new_path[::-1]}' is a valid word!")
                    return True
                else:
                    print(f"{indent}FAIL: Pattern matched but no WORD flag")
                    # Continue looking for other matches
            else:
                # More letters to go
                if node['child'] > 0 and node['child'] < section1_end:
                    if _trace_from_range(data, section1_end, node['child'], section1_end, rest, new_path, depth+1):
                        return True
                else:
                    print(f"{indent}No valid child to continue")

        siblings_checked += 1
        if node['is_last']:
            break
        entry += 1

    print(f"{indent}'{target}' not found in this range (checked {siblings_checked} siblings)")
    return False

def scan_section2_for_word(data, section1_end, section2_end, word):
    """Scan Section 2 for a word starting point."""
    print(f"\n=== Scanning Section 2 for '{word}' ===")

    first = word[0]
    rest = word[1:]

    # Scan Section 2 for entries starting with this letter
    matches = []
    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx)
        if node and node['letter'] == first:
            matches.append((entry_idx, node))

    print(f"Found {len(matches)} entries starting with '{first}' in Section 2")

    for entry_idx, node in matches[:10]:  # Check first 10
        print(f"\n  Entry {entry_idx}: letter={node['letter']}, word={node['is_word']}, child={node['child']}")

        if len(word) == 1:
            if node['is_word']:
                print(f"    SUCCESS: Single letter word!")
                return True
        else:
            if node['child'] > 0:
                # Follow child and look for rest of word
                if _trace_forward(data, section1_end, section2_end, node['child'], rest, first, 2):
                    return True

    return False

def _trace_forward(data, section1_end, section2_end, start, remaining, path, depth):
    """Trace forward from an entry."""
    indent = "  " * depth

    if not remaining:
        return True

    target = remaining[0]
    rest = remaining[1:]

    print(f"{indent}Looking for '{target}' starting at {start}...")

    # Determine section boundary
    section_end = section1_end if start < section1_end else section2_end

    entry = start
    siblings_checked = 0
    while entry < section_end and siblings_checked < 50:
        node = get_node(data, entry)
        if node is None or node['letter'] == '?':
            break

        if node['letter'] == target:
            new_path = path + node['letter']
            print(f"{indent}FOUND '{target}' at {entry}: word={node['is_word']}, child={node['child']}")

            if not rest:
                if node['is_word']:
                    print(f"{indent}SUCCESS: '{new_path}' is valid!")
                    return True
                else:
                    print(f"{indent}Pattern matched but no WORD flag")
            else:
                if node['child'] > 0:
                    if _trace_forward(data, section1_end, section2_end, node['child'], rest, new_path, depth+1):
                        return True

        siblings_checked += 1
        if node['is_last']:
            break
        entry += 1

    return False

def main():
    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data, section1_end, section2_end, letter_index = load_dawg(dawg_path)

    print(f"DAWG: section1_end={section1_end}, section2_end={section2_end}")

    # Test words
    test_words = ['aa', 'cat', 'act', 'the', 'be', 'at', 'ta', 'queen']

    for word in test_words:
        print("\n" + "="*60)
        found1 = trace_word_section1(data, section1_end, letter_index, word)
        found2 = scan_section2_for_word(data, section1_end, section2_end, word)
        print(f"\nResult for '{word}': Section1={found1}, Section2={found2}")

if __name__ == "__main__":
    main()
