#!/usr/bin/env python3
"""
Enumerate words from Maven's DAWG using CODE 15's exact interpretation.

Based on static analysis of CODE 15 disassembly (recursive_pattern_match at 0x0272):

DAWG Entry Format (32-bit big-endian):
  Bits 0-7:   Letter (ASCII lowercase)
  Bit 8:      End-of-word flag (0x100)
  Bit 9:      Last-sibling flag (0x200)
  Bits 10-31: Child node index (entry >> 10)

The key insight: Section 2 provides forward entry points, and following
children through Section 1 yields forward words (not reversed).
"""

import struct
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

# Flags as seen by CODE 15 (32-bit interpretation)
FLAG_END_OF_WORD = 0x100  # Bit 8
FLAG_LAST_SIBLING = 0x200  # Bit 9
CHILD_SHIFT = 10  # Child index = entry >> 10

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

# Section boundaries from header
section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]

print(f"DAWG structure:")
print(f"  Section 1: entries 0 to {section1_end-1}")
print(f"  Section 2: entries {section1_end} to {section2_end-1}")
print()


def get_entry_32bit(entry_idx):
    """Get DAWG entry as 32-bit big-endian value (CODE 15's view)."""
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    # Read as 32-bit big-endian
    entry = struct.unpack('>I', data[offset:offset+4])[0]
    letter = entry & 0xFF
    if not (97 <= letter <= 122):  # a-z
        return None
    return {
        'entry_idx': entry_idx,
        'raw': entry,
        'letter': chr(letter),
        'is_end_of_word': bool(entry & FLAG_END_OF_WORD),
        'is_last': bool(entry & FLAG_LAST_SIBLING),
        'child': entry >> CHILD_SHIFT,
    }


def enumerate_from_entry(start_entry, prefix="", max_depth=15, max_words=None, words=None):
    """
    Enumerate words starting from a DAWG entry.

    Follows CODE 15's traversal: iterate siblings, recurse via children,
    record word when end-of-word flag is set.
    """
    if words is None:
        words = []
    if max_words and len(words) >= max_words:
        return words
    if max_depth <= 0:
        return words

    entry_idx = start_entry
    while True:
        node = get_entry_32bit(entry_idx)
        if node is None:
            break

        new_prefix = prefix + node['letter']

        # Check end-of-word flag (bit 8)
        if node['is_end_of_word']:
            words.append(new_prefix)
            if max_words and len(words) >= max_words:
                return words

        # Follow child (entry >> 10)
        if node['child'] > 0:
            enumerate_from_entry(node['child'], new_prefix, max_depth - 1, max_words, words)
            if max_words and len(words) >= max_words:
                return words

        # Check last sibling flag (bit 9)
        if node['is_last']:
            break
        entry_idx += 1

    return words


def find_section2_roots():
    """Find all root entries in Section 2 (first letter of words)."""
    roots = defaultdict(list)
    entry_idx = section1_end

    while entry_idx < section2_end:
        node = get_entry_32bit(entry_idx)
        if node:
            roots[node['letter']].append(entry_idx)
        entry_idx += 1

    return roots


print("Finding Section 2 root entries...")
section2_roots = find_section2_roots()
total_roots = sum(len(v) for v in section2_roots.values())
print(f"  Found {total_roots} root entries across {len(section2_roots)} letters")
print()

# Sample some Section 2 entries to understand structure
print("Sample Section 2 entries:")
for letter in 'cat':
    entries = section2_roots.get(letter, [])[:3]
    for entry_idx in entries:
        node = get_entry_32bit(entry_idx)
        if node:
            print(f"  Entry {entry_idx}: '{node['letter']}' "
                  f"EOW={node['is_end_of_word']} "
                  f"LAST={node['is_last']} "
                  f"child={node['child']}")
print()

# Enumerate words starting from Section 2
print("Enumerating words from Section 2 roots...")
all_words = set()

for letter in 'abcdefghijklmnopqrstuvwxyz':
    roots = section2_roots.get(letter, [])
    letter_words = []

    for root_entry in roots:
        node = get_entry_32bit(root_entry)
        if node:
            # Start with this letter, follow children
            prefix = node['letter']

            # If this root has end-of-word, it's a 1-letter "word" (unlikely in Scrabble)
            if node['is_end_of_word']:
                letter_words.append(prefix)

            # Follow children
            if node['child'] > 0:
                enumerate_from_entry(node['child'], prefix, max_depth=15,
                                    max_words=50000, words=letter_words)

    all_words.update(letter_words)
    if letter_words:
        sample = sorted(letter_words)[:5]
        print(f"  '{letter}': {len(letter_words)} words, sample: {sample}")

print()
print(f"Total unique words enumerated: {len(all_words)}")

# Word length distribution
by_length = defaultdict(int)
for w in all_words:
    by_length[len(w)] += 1

print("\nWord length distribution:")
for length in sorted(by_length.keys())[:12]:
    print(f"  {length:2d} letters: {by_length[length]:6d} words")

# Check specific known words
print("\nKnown word checks:")
test_words = ['aa', 'ab', 'cat', 'the', 'queen', 'aardvark', 'zymurgy']
for word in test_words:
    found = word in all_words
    print(f"  {word}: {'FOUND' if found else 'NOT FOUND'}")

# Check for 2-letter words
two_letter = sorted([w for w in all_words if len(w) == 2])
print(f"\n2-letter words found ({len(two_letter)}):")
print(f"  {two_letter[:50]}")

# Compare with expected SOWPODS 2-letter words
expected_2letter = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
                    'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
                    'by', 'ch', 'da', 'de', 'di', 'do', 'ea', 'ed', 'ee', 'ef',
                    'eh', 'el', 'em', 'en', 'er', 'es', 'et', 'ex', 'fa', 'fe',
                    'fy', 'gi', 'go', 'gu', 'ha', 'he', 'hi', 'hm', 'ho', 'id',
                    'if', 'in', 'io', 'is', 'it', 'ja', 'jo', 'ka', 'ki', 'ko',
                    'ky', 'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu',
                    'my', 'na', 'ne', 'no', 'nu', 'ny', 'ob', 'od', 'oe', 'of',
                    'oh', 'oi', 'ok', 'om', 'on', 'oo', 'op', 'or', 'os', 'ou',
                    'ow', 'ox', 'oy', 'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh',
                    'si', 'so', 'st', 'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um',
                    'un', 'up', 'ur', 'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya',
                    'ye', 'yo', 'yu', 'za', 'zo']

found_set = set(two_letter)
expected_set = set(expected_2letter)
in_both = found_set & expected_set
only_found = found_set - expected_set
only_expected = expected_set - found_set

print(f"\nComparison with SOWPODS 2-letter words:")
print(f"  Expected: {len(expected_set)}")
print(f"  Found: {len(found_set)}")
print(f"  Overlap: {len(in_both)}")
if only_found:
    print(f"  Extra (not in SOWPODS): {sorted(only_found)[:20]}")
if only_expected:
    print(f"  Missing (in SOWPODS): {sorted(only_expected)[:20]}")

# Save enumerated words
output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/code15_enumerated.txt"
with open(output_path, 'w') as f:
    for word in sorted(all_words):
        f.write(word + '\n')
print(f"\nSaved {len(all_words)} words to: {output_path}")
