#!/usr/bin/env python3
"""
Test validation of specific words to understand DAWG behavior.
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
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    return {
        'letter': chr(letter),
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
        'entry': entry_idx,
    }

def get_siblings(data, start, limit):
    sibs = []
    entry = start
    while entry < limit:
        node = get_node(data, entry)
        if node is None:
            break
        sibs.append(node)
        if node['is_last']:
            break
        entry += 1
    return sibs

def trace_validation(data, section1_end, letter_index, word, verbose=True):
    """Trace word validation through Section 1."""
    rev = word[::-1]
    first = rev[0]
    rest = rev[1:]

    letters = 'abcdefghijklmnopqrstuvwxyz'
    idx = ord(first) - ord('a')
    range_start = letter_index[first]
    range_end = letter_index[letters[idx+1]] if idx < 25 else section1_end

    if verbose:
        print(f"\n=== Tracing '{word}' (reversed: '{rev}') ===")
        print(f"Letter '{first}' range: {range_start}-{range_end}")

    return search_s1(data, section1_end, range_start, range_end, rest, first, verbose, word)

def search_s1(data, section1_end, start, end, remaining, path, verbose, word):
    if not remaining:
        if verbose:
            print(f"  Pattern fully matched at path '{path}'")
        return True

    target = remaining[0]
    rest = remaining[1:]

    entry = start
    while entry < end:
        sibs = get_siblings(data, entry, end)
        if not sibs:
            break

        for node in sibs:
            if node['letter'] == target:
                new_path = path + node['letter']
                if verbose:
                    print(f"  Found '{target}' at entry {node['entry']}: is_word={node['is_word']}, child={node['child']}")

                if not rest:
                    if node['is_word']:
                        if verbose:
                            print(f"  SUCCESS: '{word}' is valid (path: {new_path})")
                        return True
                    else:
                        if verbose:
                            print(f"  Pattern matched but is_word=False")
                else:
                    if node['child'] > 0 and node['child'] < section1_end:
                        if search_s1(data, section1_end, node['child'], section1_end, rest, new_path, verbose, word):
                            return True

        entry += len(sibs)

    return False

def main():
    data, section1_end, section2_end, letter_index = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    # Test real vs fake 2-letter words
    real_words = ['aa', 'ab', 'ad', 'ae', 'at', 'be', 'my']
    fake_words = ['ac', 'af', 'ak', 'ap', 'aq', 'av', 'bb', 'cc']

    print("Testing REAL 2-letter words:")
    for w in real_words:
        result = trace_validation(data, section1_end, letter_index, w, verbose=False)
        print(f"  {w}: {'VALID' if result else 'INVALID'}")

    print("\nTesting FAKE 2-letter words (should be INVALID):")
    for w in fake_words:
        result = trace_validation(data, section1_end, letter_index, w, verbose=True)
        print(f"  Result: {'VALID' if result else 'INVALID'}")

if __name__ == "__main__":
    main()
