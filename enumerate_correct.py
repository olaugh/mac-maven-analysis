#!/usr/bin/env python3
"""
Correct enumeration from Maven's DAWG Section 1.

Based on validation trace:
- Section 1 stores reversed words indexed by LAST letter
- Each letter range contains suffixes for words ending in that letter
- Traversal builds the REVERSED word (minus the last letter)
- When is_word=True, reverse the path and append the range letter

For "CAT":
- t-range contains entries for words ending in 't'
- Entry 1770 has 'a', is_word=True, meaning "at" is valid (path "a" + range "t")
- Entry 1770's child 69 leads to 'c' at entry 106, is_word=True
- Path "ac" reversed = "ca", + range "t" = "cat"

The key insight: each sibling GROUP represents a different word prefix.
We must stay within sibling groups when traversing.
"""

import struct
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

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
        'is_word': bool(flags & FLAG_WORD),
        'is_last': bool(flags & FLAG_LAST),
        'child': ptr + (flags & 0x7e) if ptr else 0,
    }


def get_sibling_group(start_entry):
    """Get one sibling group starting at entry."""
    siblings = []
    entry = start_entry
    while entry < section1_end:
        node = get_node(entry)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings


def enumerate_from_group(start_entry, ending_letter, path="", max_depth=15, words=None):
    """
    Enumerate words from a sibling group.

    path: letters collected so far (in reverse order)
    ending_letter: the letter range we're in (last letter of words)
    """
    if words is None:
        words = set()
    if max_depth <= 0:
        return words

    siblings = get_sibling_group(start_entry)

    for node in siblings:
        # Extend path with this letter
        new_path = path + node['letter']

        # If is_word, we have a valid word
        if node['is_word']:
            # Reverse path and append ending letter
            word = new_path[::-1] + ending_letter
            if len(word) >= 2:
                words.add(word)

        # Follow children for longer words
        if node['child'] > 0 and max_depth > 1:
            enumerate_from_group(node['child'], ending_letter, new_path,
                               max_depth - 1, words)

    return words


def enumerate_range(range_start, range_end, ending_letter, max_depth=15):
    """Enumerate all words from a letter range."""
    words = set()
    entry = range_start

    # The range contains multiple sibling groups
    # Each group represents different word paths
    while entry < range_end:
        group = get_sibling_group(entry)
        if not group:
            entry += 1
            continue

        # Process this group
        enumerate_from_group(entry, ending_letter, "", max_depth, words)

        # Move past this group to next
        entry += len(group)

    return words


print("DAWG Word Enumeration - Correct Algorithm")
print("=" * 60)
print()

all_words = set()

for ending in letters:
    range_start, range_end = letter_ranges[ending]
    words = enumerate_range(range_start, range_end, ending, max_depth=15)
    all_words.update(words)

    two_letter = sorted([w for w in words if len(w) == 2])
    three_letter = sorted([w for w in words if len(w) == 3])[:10]

    print(f"Words ending in '{ending}': {len(words):,} total")
    if two_letter:
        print(f"  2-letter: {two_letter}")
    if three_letter:
        print(f"  3-letter sample: {three_letter}")
    print()

print("=" * 60)
print(f"Total unique words: {len(all_words):,}")

# Word length distribution
by_length = defaultdict(int)
for w in all_words:
    by_length[len(w)] += 1

print("\nWord length distribution:")
for length in sorted(by_length.keys())[:15]:
    print(f"  {length:2d} letters: {by_length[length]:6,d} words")

# Check known words
print("\nKnown word verification:")
test_words = ['aa', 'ab', 'at', 'cat', 'the', 'queen', 'aardvark', 'zymurgy']
for word in test_words:
    found = word in all_words
    print(f"  {word}: {'FOUND' if found else 'NOT FOUND'}")

# 2-letter word comparison
two_letter_found = sorted([w for w in all_words if len(w) == 2])
expected_2letter = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
                    'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
                    'by', 'ch', 'da', 'de', 'di', 'do', 'ea', 'ed', 'ee', 'ef',
                    'eh', 'el', 'em', 'en', 'er', 'es', 'et', 'ex', 'fa', 'fe',
                    'gi', 'go', 'gu', 'ha', 'he', 'hi', 'hm', 'ho', 'id', 'if',
                    'in', 'io', 'is', 'it', 'ja', 'jo', 'ka', 'ki', 'ko', 'ky',
                    'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu', 'my',
                    'na', 'ne', 'no', 'nu', 'ny', 'ob', 'od', 'oe', 'of', 'oh',
                    'oi', 'ok', 'om', 'on', 'oo', 'op', 'or', 'os', 'ou', 'ow',
                    'ox', 'oy', 'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh', 'si',
                    'so', 'st', 'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um', 'un',
                    'up', 'ur', 'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye',
                    'yo', 'yu', 'za', 'zo']

found_set = set(two_letter_found)
expected_set = set(expected_2letter)
overlap = found_set & expected_set
extra = found_set - expected_set
missing = expected_set - found_set

print(f"\n2-letter word comparison:")
print(f"  Found: {len(two_letter_found)}")
print(f"  Expected (SOWPODS): {len(expected_2letter)}")
print(f"  Overlap: {len(overlap)}")
print(f"  Extra: {len(extra)}")
print(f"  Missing: {len(missing)}")

if extra:
    print(f"\n  Extra words (not in SOWPODS): {sorted(extra)[:30]}")
if missing:
    print(f"\n  Missing words: {sorted(missing)[:30]}")

# Save results
output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/enumerated_correct.txt"
with open(output_path, 'w') as f:
    for word in sorted(all_words):
        f.write(word + '\n')
print(f"\nSaved {len(all_words):,} words to: {output_path}")
