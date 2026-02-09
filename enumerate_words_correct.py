#!/usr/bin/env python3
"""
Enumerate all words from Maven's DAWG using correct traversal algorithm.

Based on CODE 15 analysis: recursive DAWG traversal with proper flag checking.

DAWG Format (4 bytes per entry):
- bytes 0-1: ptr (16-bit big-endian base pointer)
- byte 2: flags (0x80 = WORD marker, 0x01 = LAST sibling in group)
- byte 3: letter (ASCII lowercase)

Child calculation: child_entry = ptr + (flags & 0x7e)
Words are stored REVERSED, indexed by LAST letter.
"""

import struct
import sys
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80  # Correct flag for end-of-word
FLAG_LAST = 0x01  # Last sibling in group

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]

# Build letter index
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


def get_entry(entry_idx):
    """Get DAWG entry at given index."""
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    return {
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter),
        'is_word': bool(flags & FLAG_WORD),
        'is_last': bool(flags & FLAG_LAST),
        'entry': entry_idx,
        'child': ptr + (flags & 0x7e) if ptr else None,
    }


def enumerate_sibling_group(start_entry, prefix="", max_depth=15, max_words=None, words=None):
    """
    Enumerate words from a sibling group starting at given entry.

    Respects FLAG_LAST to stay within sibling group boundaries.
    """
    if words is None:
        words = []
    if max_words and len(words) >= max_words:
        return words
    if max_depth <= 0:
        return words

    entry = start_entry
    while entry < section1_end:
        node = get_entry(entry)
        if node is None:
            break

        new_prefix = prefix + node['letter']

        # If WORD flag set, this path represents a valid word
        if node['is_word']:
            words.append(new_prefix)
            if max_words and len(words) >= max_words:
                return words

        # Follow children recursively (children form their own sibling group)
        if node['child']:
            enumerate_sibling_group(node['child'], new_prefix, max_depth - 1, max_words, words)
            if max_words and len(words) >= max_words:
                return words

        # Move to next sibling in THIS group
        if node['is_last']:
            break  # End of this sibling group
        entry += 1

    return words


def enumerate_range(range_start, range_end, prefix="", max_depth=15, max_words=None, words=None):
    """
    Enumerate words from a letter range (multiple sibling groups).

    A range contains consecutive sibling groups - we process each group.
    """
    if words is None:
        words = []
    if max_words and len(words) >= max_words:
        return words

    entry = range_start
    while entry < range_end:
        node = get_entry(entry)
        if node is None:
            entry += 1
            continue

        new_prefix = prefix + node['letter']

        # If WORD flag set, this path represents a valid word
        if node['is_word']:
            words.append(new_prefix)
            if max_words and len(words) >= max_words:
                return words

        # Follow children recursively
        if node['child']:
            enumerate_sibling_group(node['child'], new_prefix, max_depth - 1, max_words, words)
            if max_words and len(words) >= max_words:
                return words

        # Move past this sibling group to next one
        while entry < range_end:
            n = get_entry(entry)
            if n is None or n['is_last']:
                entry += 1
                break
            entry += 1

    return words


def enumerate_words_ending_in(ending_letter, max_words=50000, max_depth=15):
    """
    Enumerate all words ending in the given letter.

    Returns actual words (not reversed paths).
    """
    range_start, range_end = letter_ranges[ending_letter]

    # Get reversed paths from this letter range
    paths = enumerate_range(range_start, range_end, "", max_depth, max_words)

    # Convert to actual words: reverse each path and append ending letter
    words = []
    for path in paths:
        word = path[::-1] + ending_letter
        if len(word) >= 2:  # Only include 2+ letter words
            words.append(word)

    return words


def main():
    print("Maven DAWG Word Enumeration (Correct Algorithm)")
    print("=" * 60)
    print(f"Section 1 ends at: {section1_end}")
    print(f"Section 2 ends at: {section2_end}")
    print()

    all_words = set()

    # Enumerate from each letter range
    for ending in letters:
        print(f"Enumerating words ending in '{ending}'...")
        words = enumerate_words_ending_in(ending, max_words=20000)
        print(f"  Found {len(words)} words")

        all_words.update(words)

        # Show sample
        sample = sorted(words)[:5]
        if sample:
            print(f"  Sample: {sample}")

    print()
    print(f"Total unique words: {len(all_words)}")

    # Word length distribution
    by_length = defaultdict(int)
    for w in all_words:
        by_length[len(w)] += 1

    print("\nWord length distribution:")
    for length in sorted(by_length.keys())[:12]:
        print(f"  {length:2d} letters: {by_length[length]:6d} words")

    # Check specific words
    print("\nSpecific word checks:")
    test_words = ['aa', 'ab', 'aardvark', 'aardvarks', 'queen', 'queens', 'the', 'cat']
    for word in test_words:
        found = word in all_words
        print(f"  {word}: {'FOUND' if found else 'NOT FOUND'}")

    # Save to file
    output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/enumerated_words.txt"
    with open(output_path, 'w') as f:
        for word in sorted(all_words):
            f.write(word + '\n')
    print(f"\nSaved {len(all_words)} words to: {output_path}")


if __name__ == "__main__":
    main()
