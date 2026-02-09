#!/usr/bin/env python3
"""
Stream enumeration of Maven DAWG - writes words directly to file.
Uses depth-limited traversal to avoid memory explosion.
"""

import struct
import sys

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01
MAX_WORD_LENGTH = 15

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

def get_node(data, entry_idx, section_limit):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0
    return {
        'letter': chr(letter),
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': child if child < section_limit else 0,
    }

def enumerate_section1_recursive(data, section1_end, entry, prefix, outfile, count):
    """Recursively enumerate from an entry in Section 1."""
    if len(prefix) > MAX_WORD_LENGTH:
        return count

    node = get_node(data, entry, section1_end)
    if node is None:
        return count

    path = prefix + node['letter']

    if node['is_word']:
        # Reverse to get actual word (Section 1 stores reversed)
        word = path[::-1]
        outfile.write(word + '\n')
        count[0] += 1
        if count[0] % 10000 == 0:
            print(f"  {count[0]} words found...", flush=True)

    if node['child'] > 0 and node['child'] < section1_end:
        # Enumerate children
        child_entry = node['child']
        while child_entry < section1_end:
            child = get_node(data, child_entry, section1_end)
            if child is None:
                break
            enumerate_section1_recursive(data, section1_end, child_entry, path, outfile, count)
            if child['is_last']:
                break
            child_entry += 1

    return count

def enumerate_section1(data, section1_end, letter_index, outfile):
    """Enumerate Section 1 (reversed words)."""
    letters = 'abcdefghijklmnopqrstuvwxyz'
    count = [0]

    for i, L in enumerate(letters):
        range_start = letter_index[L]
        range_end = letter_index[letters[i+1]] if i < 25 else section1_end

        print(f"  Processing '{L}' range {range_start}-{range_end}...", flush=True)

        # Walk through sibling groups in this range
        entry = range_start
        while entry < range_end:
            node = get_node(data, entry, range_end)
            if node is None:
                entry += 1
                continue

            # Enumerate from this node
            enumerate_section1_recursive(data, section1_end, entry, L, outfile, count)

            # Move to next sibling group
            while entry < range_end:
                n = get_node(data, entry, range_end)
                if n is None or n['is_last']:
                    entry += 1
                    break
                entry += 1

    return count[0]

def enumerate_section2_recursive(data, section1_end, entry, prefix, outfile, count):
    """Recursively enumerate from an entry following into Section 1."""
    if len(prefix) > MAX_WORD_LENGTH:
        return

    node = get_node(data, entry, section1_end)
    if node is None:
        return

    path = prefix + node['letter']

    if node['is_word']:
        outfile.write(path + '\n')
        count[0] += 1
        if count[0] % 10000 == 0:
            print(f"  {count[0]} words found...", flush=True)

    if node['child'] > 0 and node['child'] < section1_end:
        child_entry = node['child']
        while child_entry < section1_end:
            child = get_node(data, child_entry, section1_end)
            if child is None:
                break
            enumerate_section2_recursive(data, section1_end, child_entry, path, outfile, count)
            if child['is_last']:
                break
            child_entry += 1

def enumerate_section2(data, section1_end, section2_end, outfile):
    """Enumerate Section 2 (forward words)."""
    count = [0]

    for entry_idx in range(section1_end, section2_end):
        node = get_node(data, entry_idx, section2_end)
        if node is None:
            continue

        first_letter = node['letter']

        # Single letter word (rare)
        if node['is_word'] and node['child'] == 0:
            outfile.write(first_letter + '\n')
            count[0] += 1

        # Follow children
        if node['child'] > 0 and node['child'] < section1_end:
            child_entry = node['child']
            while child_entry < section1_end:
                child = get_node(data, child_entry, section1_end)
                if child is None:
                    break
                enumerate_section2_recursive(data, section1_end, child_entry, first_letter, outfile, count)
                if child['is_last']:
                    break
                child_entry += 1

        if entry_idx % 5000 == 0 and entry_idx > section1_end:
            print(f"  Processed {entry_idx - section1_end}/{section2_end - section1_end} S2 entries, {count[0]} words", flush=True)

    return count[0]

def main():
    print("="*60)
    print("Maven DAWG Stream Enumeration")
    print("="*60)

    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data, section1_end, section2_end, letter_index = load_dawg(dawg_path)

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}")

    # Output file
    out_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_stream_enum.txt"

    # Enumerate Section 1 first (reversed words)
    print("\n--- Section 1 (reversed words) ---")
    with open(out_path, 'w') as f:
        s1_count = enumerate_section1(data, section1_end, letter_index, f)
    print(f"Section 1 complete: {s1_count} words")

    # Enumerate Section 2 (forward words) - append
    print("\n--- Section 2 (forward words) ---")
    with open(out_path, 'a') as f:
        s2_count = enumerate_section2(data, section1_end, section2_end, f)
    print(f"Section 2 complete: {s2_count} words")

    print(f"\nTotal written: {s1_count + s2_count}")

    # Deduplicate
    print("\nDeduplicating...")
    with open(out_path, 'r') as f:
        words = set(line.strip() for line in f)
    print(f"Unique words: {len(words)}")

    # Save deduplicated
    final_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/maven_extracted.txt"
    with open(final_path, 'w') as f:
        for w in sorted(words):
            f.write(w + '\n')
    print(f"Saved to {final_path}")

    # Verify
    test = ['aa', 'ab', 'cat', 'act', 'the', 'be', 'at', 'ta', 'queen', 'aardvark']
    print("\nVerification:")
    for w in test:
        print(f"  {w}: {'FOUND' if w in words else 'MISSING'}")

    # Stats
    by_len = {}
    for w in words:
        by_len[len(w)] = by_len.get(len(w), 0) + 1
    print("\nLength distribution:")
    for l in sorted(by_len.keys())[:15]:
        print(f"  {l}: {by_len[l]}")

if __name__ == "__main__":
    main()
