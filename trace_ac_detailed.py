#!/usr/bin/env python3
"""
Detailed trace of why "ac" validates when it shouldn't be a word.
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
        'letter': chr(letter) if 97 <= letter <= 122 else f'0x{letter:02x}',
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
        'ptr': ptr,
        'flags': flags,
        'entry': entry_idx,
        'raw': f'{b0:02x} {b1:02x} {flags:02x} {letter:02x}',
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

def trace_section1(data, section1_end, letter_index, word):
    """Trace word through Section 1 (reversed)."""
    print(f"\n{'='*60}")
    print(f"SECTION 1 TRACE: '{word}' (reversed: '{word[::-1]}')")
    print(f"{'='*60}")

    rev = word[::-1]
    first = rev[0]
    rest = rev[1:]

    letters = 'abcdefghijklmnopqrstuvwxyz'
    idx = ord(first) - ord('a')
    range_start = letter_index[first]
    range_end = letter_index[letters[idx+1]] if idx < 25 else section1_end

    print(f"First letter '{first}' range: entries {range_start} to {range_end}")
    print(f"Looking for: '{rest}' (remaining letters after first)")

    return search_s1_verbose(data, section1_end, range_start, range_end, rest, first, 0)

def search_s1_verbose(data, section1_end, start, end, remaining, path, depth):
    indent = "  " * depth

    if not remaining:
        print(f"{indent}=> Reached end of pattern at path '{path}' - need to check is_word")
        # This shouldn't happen for a 2-letter word - we should be checking is_word on the last letter
        return False

    target = remaining[0]
    rest = remaining[1:]

    print(f"{indent}Searching entries {start}-{end} for letter '{target}'")

    entry = start
    sibling_group = 0
    while entry < end:
        sibs = get_siblings(data, entry, end)
        if not sibs:
            break

        sibling_group += 1
        print(f"{indent}  Sibling group {sibling_group} at entry {entry}: {[s['letter'] for s in sibs]}")

        for node in sibs:
            if node['letter'] == target:
                print(f"{indent}    MATCH: entry {node['entry']}, raw=[{node['raw']}]")
                print(f"{indent}           is_word={node['is_word']}, is_last={node['is_last']}, child={node['child']}")

                if not rest:
                    # This is the final letter
                    if node['is_word']:
                        print(f"{indent}    => VALID: is_word=True on final letter!")
                        return True
                    else:
                        print(f"{indent}    => Pattern matched but is_word=False")
                        # Continue looking for other matches
                else:
                    if node['child'] > 0 and node['child'] < section1_end:
                        if search_s1_verbose(data, section1_end, node['child'], section1_end, rest, path + node['letter'], depth + 1):
                            return True

        entry += len(sibs)

    print(f"{indent}No valid match found in this range")
    return False

def trace_section2(data, section1_end, section2_end, word):
    """Trace word through Section 2 (forward)."""
    print(f"\n{'='*60}")
    print(f"SECTION 2 TRACE: '{word}' (forward)")
    print(f"{'='*60}")

    first = word[0]
    rest = word[1:]

    print(f"Section 2 range: entries {section1_end} to {section2_end}")
    print(f"Looking for starting letter '{first}', then '{rest}'")

    # Find all entries in Section 2 that start with our letter
    matches = []
    for idx in range(section1_end, section2_end):
        node = get_node(data, idx)
        if node and node['letter'] == first:
            matches.append((idx, node))

    print(f"Found {len(matches)} entries starting with '{first}'")

    for idx, node in matches[:20]:  # Limit to first 20 for readability
        print(f"\n  Entry {idx}: raw=[{node['raw']}]")
        print(f"    is_word={node['is_word']}, child={node['child']}")

        if match_forward_verbose(data, section1_end, node, rest, first, 1):
            return True

    if len(matches) > 20:
        print(f"\n  ... and {len(matches) - 20} more entries (not shown)")

    return False

def match_forward_verbose(data, section1_end, node, remaining, path, depth):
    indent = "  " * depth

    if not remaining:
        if node['is_word']:
            print(f"{indent}=> VALID: is_word=True at end of pattern!")
            return True
        else:
            print(f"{indent}=> Pattern matched but is_word=False")
            return False

    child = node['child']
    if not child or child >= section1_end:
        print(f"{indent}No valid child pointer")
        return False

    target = remaining[0]
    rest = remaining[1:]

    sibs = get_siblings(data, child, section1_end)
    print(f"{indent}Children at {child}: {[s['letter'] for s in sibs]}")

    for sib in sibs:
        if sib['letter'] == target:
            print(f"{indent}  Match '{target}' at entry {sib['entry']}: is_word={sib['is_word']}")
            return match_forward_verbose(data, section1_end, sib, rest, path + sib['letter'], depth + 1)

    return False

def main():
    data, section1_end, section2_end, letter_index = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print(f"DAWG: section1_end={section1_end}, section2_end={section2_end}")

    # Test words
    test_words = ['ac', 'aa', 'ab', 'at', 'bb']

    for word in test_words:
        s1_result = trace_section1(data, section1_end, letter_index, word)
        s2_result = trace_section2(data, section1_end, section2_end, word)

        print(f"\n*** FINAL RESULT for '{word}': Section1={s1_result}, Section2={s2_result}")
        print(f"    Combined: {'VALID' if (s1_result or s2_result) else 'INVALID'}")

if __name__ == "__main__":
    main()
