#!/usr/bin/env python3
"""
Trace how "CAT" validates through the DAWG.

The validation code works. Let's trace exactly what path it takes.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]

# Letter index
LETTER_INDEX_OFFSET = 0x10
letter_index = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1 = data[offset:offset+2]
    letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

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
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    return {
        'entry': entry_idx,
        'letter': chr(letter),
        'ptr': ptr,
        'flags': flags,
        'is_word': bool(flags & FLAG_WORD),
        'is_last': bool(flags & FLAG_LAST),
        'child': ptr + (flags & 0x7e) if ptr else 0,
    }


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


def validate_section1_trace(word):
    """Trace validation through Section 1 (reversed word)."""
    print(f"\n{'='*60}")
    print(f"Validating '{word}' via SECTION 1 (reversed)")
    print(f"{'='*60}")

    reversed_word = word[::-1]
    print(f"Reversed: '{reversed_word}'")

    first = reversed_word[0]
    remaining = reversed_word[1:]

    range_start, range_end = letter_ranges[first]
    print(f"Starting in '{first}' range: entries {range_start} to {range_end-1}")

    def search_trace(search_start, search_end, letters_left, depth=0):
        indent = "  " * depth
        print(f"{indent}Searching for '{letters_left}' in entries {search_start}-{search_end}")

        if not letters_left:
            return True

        target = letters_left[0]
        rest = letters_left[1:]

        entry = search_start
        group_num = 0
        while entry < search_end:
            sibs = get_siblings(entry)
            if not sibs:
                break

            print(f"{indent}  Group {group_num} at entry {entry}: {len(sibs)} siblings")

            for node in sibs:
                if node['letter'] == target:
                    print(f"{indent}    Found '{target}' at entry {node['entry']}, "
                          f"is_word={node['is_word']}, child={node['child']}")

                    if not rest:
                        if node['is_word']:
                            print(f"{indent}    -> WORD FLAG SET - VALID!")
                            return True
                        else:
                            print(f"{indent}    -> No word flag, continuing...")
                    else:
                        if node['child'] and node['child'] < section1_end:
                            if search_trace(node['child'], section1_end, rest, depth + 1):
                                return True

            entry += len(sibs)
            group_num += 1

        print(f"{indent}Not found in this range")
        return False

    result = search_trace(range_start, range_end, remaining)
    print(f"\nResult: {'VALID' if result else 'INVALID'}")
    return result


def validate_section2_trace(word):
    """Trace validation through Section 2 (forward word)."""
    print(f"\n{'='*60}")
    print(f"Validating '{word}' via SECTION 2 (forward)")
    print(f"{'='*60}")

    first = word[0]
    remaining = word[1:]

    # Find entries in Section 2 starting with first letter
    print(f"Looking for '{first}' entries in Section 2 (entries {section1_end} to {section2_end-1})")

    first_entries = []
    for entry_idx in range(section1_end, section2_end):
        node = get_node(entry_idx)
        if node and node['letter'] == first:
            first_entries.append(entry_idx)

    print(f"Found {len(first_entries)} entries starting with '{first}'")

    for i, entry_idx in enumerate(first_entries[:5]):  # Try first 5
        print(f"\nTrying entry {entry_idx}:")
        node = get_node(entry_idx)
        print(f"  Root: {node}")

        def match_forward_trace(start_node, letters_left, depth=1):
            indent = "  " * depth
            print(f"{indent}Matching '{letters_left}' from child={start_node['child']}")

            if not letters_left:
                if start_node['is_word']:
                    print(f"{indent}-> WORD FLAG SET - VALID!")
                    return True
                else:
                    print(f"{indent}-> No word flag")
                    return False

            if start_node['child'] == 0:
                print(f"{indent}-> No children")
                return False

            target = letters_left[0]
            rest = letters_left[1:]

            sibs = get_siblings(start_node['child'])
            print(f"{indent}  Siblings at {start_node['child']}: {[s['letter'] for s in sibs]}")

            for s in sibs:
                if s['letter'] == target:
                    print(f"{indent}  Found '{target}' at {s['entry']}, is_word={s['is_word']}")
                    if not rest:
                        if s['is_word']:
                            print(f"{indent}  -> WORD FLAG SET - VALID!")
                            return True
                    else:
                        if match_forward_trace(s, rest, depth + 1):
                            return True

            return False

        if match_forward_trace(node, remaining):
            return True

    print("\nResult: INVALID (not found in Section 2)")
    return False


# Trace CAT
print("TRACING 'CAT'")
print("=" * 60)

s1_result = validate_section1_trace('cat')
s2_result = validate_section2_trace('cat')

print(f"\n{'='*60}")
print(f"FINAL RESULT for 'cat':")
print(f"  Section 1: {'VALID' if s1_result else 'INVALID'}")
print(f"  Section 2: {'VALID' if s2_result else 'INVALID'}")
print(f"  Combined: {'VALID' if (s1_result or s2_result) else 'INVALID'}")

# Also trace AA and AB for comparison
for word in ['aa', 'ab']:
    print(f"\n\n{'#'*60}")
    print(f"# TRACING '{word.upper()}'")
    print(f"{'#'*60}")
    s1 = validate_section1_trace(word)
    # s2 = validate_section2_trace(word)
    print(f"\nResult for '{word}': Section 1 = {'VALID' if s1 else 'INVALID'}")
