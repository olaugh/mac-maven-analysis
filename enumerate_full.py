#!/usr/bin/env python3
"""
Enumerate words from Maven's DAWG using correct validation (searches all sibling groups).

The key insight: each letter range contains MULTIPLE sibling groups.
A word is valid if ANY matching entry in the range has the WORD flag set.
"""

import struct
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01
SECTION1_END = 56630

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section2_end = struct.unpack('>I', data[4:8])[0]

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
    end = letter_index[letters[i+1]] if i < 25 else SECTION1_END
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
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter),
        'is_word': bool(flags & FLAG_WORD),
        'is_last': bool(flags & FLAG_LAST),
        'child': ptr + (flags & 0x7e) if ptr else None,
    }


def get_siblings(start_entry, limit=500):
    """Get one sibling group starting at entry."""
    siblings = []
    entry = start_entry
    max_entry = min(start_entry + limit, section2_end)

    while entry < max_entry:
        node = get_node(entry)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings


def validate_section1(word):
    """Validate word using Section 1 (reversed word, search all sibling groups)."""
    if len(word) < 2:
        return False

    reversed_word = word[::-1]
    first = reversed_word[0]
    remaining = reversed_word[1:]

    if first not in letter_ranges:
        return False

    range_start, range_end = letter_ranges[first]
    return search_all_groups(range_start, range_end, remaining)


def search_all_groups(range_start, range_end, remaining):
    """Search all sibling groups in range for remaining letters."""
    if not remaining:
        return True

    target = remaining[0]
    rest = remaining[1:]

    entry = range_start
    while entry < range_end:
        sibs = get_siblings(entry)
        if not sibs:
            break

        for node in sibs:
            if node['letter'] == target:
                if not rest:
                    # Last letter - check WORD flag
                    if node['is_word']:
                        return True
                else:
                    # More letters to match - recurse via child
                    child = node['child']
                    if child and child < SECTION1_END:
                        if search_all_groups(child, SECTION1_END, rest):
                            return True

        entry += len(sibs)

    return False


# Build Section 2 index for forward validation
print("Building Section 2 index...")
section2_index = {chr(ord('a') + i): [] for i in range(26)}
for entry_idx in range(SECTION1_END, section2_end):
    node = get_node(entry_idx)
    if node and 'a' <= node['letter'] <= 'z':
        section2_index[node['letter']].append(entry_idx)
print(f"  Section 2 has {sum(len(v) for v in section2_index.values())} entries")


def validate_section2(word):
    """Validate word using Section 2 (forward word)."""
    if len(word) < 2:
        return False

    first = word[0]
    remaining = word[1:]

    for entry_idx in section2_index.get(first, []):
        node = get_node(entry_idx)
        if node and match_forward(node, remaining):
            return True

    return False


def match_forward(node, remaining):
    """Match remaining letters by following children."""
    if not remaining:
        return node['is_word']

    child = node['child']
    if not child:
        return False

    target = remaining[0]
    rest = remaining[1:]

    sibs = get_siblings(child)
    for s in sibs:
        if s['letter'] == target:
            if not rest:
                if s['is_word']:
                    return True
            else:
                if match_forward(s, rest):
                    return True

    return False


def validate_word(word):
    """Full validation using both sections."""
    word = word.lower()
    return validate_section1(word) or validate_section2(word)


# Test validation
print("\nValidation tests:")
test_words = ['aa', 'ab', 'ba', 'the', 'cat', 'aardvark', 'zz', 'xyz']
for word in test_words:
    s1 = validate_section1(word)
    s2 = validate_section2(word)
    result = s1 or s2
    print(f"  {word}: S1={s1}, S2={s2}, valid={result}")

# Enumerate 2-letter words
print("\n" + "=" * 60)
print("Enumerating 2-letter words:")
two_letter = []
for a in letters:
    for b in letters:
        word = a + b
        if validate_word(word):
            two_letter.append(word)

print(f"Found {len(two_letter)} valid 2-letter words")
print(f"  {sorted(two_letter)}")

# Compare with expected
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

found_set = set(two_letter)
expected_set = set(expected_2letter)
in_both = found_set & expected_set
only_found = found_set - expected_set
only_expected = expected_set - found_set

print(f"\nComparison with SOWPODS 2-letter words ({len(expected_2letter)}):")
print(f"  In both: {len(in_both)}")
print(f"  Only in DAWG (false positives): {len(only_found)}")
print(f"  Only in expected (missing): {len(only_expected)}")

if only_found:
    print(f"\n  False positives: {sorted(only_found)[:30]}")
if only_expected:
    print(f"\n  Missing words: {sorted(only_expected)[:30]}")
