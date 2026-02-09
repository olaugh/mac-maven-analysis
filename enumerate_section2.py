#!/usr/bin/env python3
"""
Enumerate words from Maven's DAWG Section 2.

Section 2 provides forward word entries. Following children yields the word
in forward order (no reversal needed).

Algorithm:
1. For each entry in Section 2 with letter L:
   - L is the first letter
2. Follow children (staying within sibling groups), collecting letters
3. When is_word=True, the collected path is a valid word
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
section2_end = struct.unpack('>I', data[4:8])[0]

print(f"Section 1: 0 to {section1_end-1}")
print(f"Section 2: {section1_end} to {section2_end-1}")


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


def enumerate_from_node(node, prefix, max_depth, words, max_words):
    """Enumerate words starting from a node, following sibling groups."""
    if len(words) >= max_words:
        return

    # Add this node's letter to prefix
    new_prefix = prefix + node['letter']

    # If is_word, record this word
    if node['is_word'] and len(new_prefix) >= 2:
        words.add(new_prefix)
        if len(words) >= max_words:
            return

    # Follow children if not at max depth
    if node['child'] > 0 and max_depth > 0:
        # Get siblings at child position
        child_entry = node['child']
        limit = section2_end if child_entry >= section1_end else section1_end

        while child_entry < limit and len(words) < max_words:
            child_node = get_node(child_entry)
            if child_node is None:
                break

            enumerate_from_node(child_node, new_prefix, max_depth - 1, words, max_words)

            if child_node['is_last']:
                break
            child_entry += 1


# Collect Section 2 entries by first letter
print("\nCollecting Section 2 entries...")
sec2_by_letter = defaultdict(list)
for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node:
        sec2_by_letter[node['letter']].append(entry_idx)

for letter in 'abcdef':
    print(f"  '{letter}': {len(sec2_by_letter[letter])} entries")
print()

# Enumerate words
print("Enumerating words from Section 2...")
all_words = set()
max_words = 300000

for letter in 'abcdefghijklmnopqrstuvwxyz':
    entries = sec2_by_letter[letter]
    letter_words = set()

    for entry_idx in entries:
        if len(all_words) >= max_words:
            break

        node = get_node(entry_idx)
        if node:
            enumerate_from_node(node, "", 15, letter_words, max_words - len(all_words))

    all_words.update(letter_words)

    # Show progress
    two = sorted([w for w in letter_words if len(w) == 2])
    three = sorted([w for w in letter_words if len(w) == 3])[:10]
    print(f"  '{letter}': {len(letter_words):,} words, 2-letter: {two[:10]}")

print()
print(f"Total words: {len(all_words):,}")

# Word length distribution
by_length = defaultdict(int)
for w in all_words:
    by_length[len(w)] += 1

print("\nWord length distribution:")
for length in sorted(by_length.keys())[:15]:
    print(f"  {length:2d} letters: {by_length[length]:6,d}")

# Known word verification
print("\nKnown word verification:")
test_words = ['aa', 'ab', 'ba', 'fa', 'ha', 'cat', 'the', 'queen', 'aardvark']
for word in test_words:
    print(f"  {word}: {'FOUND' if word in all_words else 'NOT FOUND'}")

# 2-letter analysis
two_letter = sorted([w for w in all_words if len(w) == 2])
print(f"\n2-letter words ({len(two_letter)}):")
print(f"  {two_letter}")

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

found = set(two_letter)
expected = set(expected_2letter)
print(f"\nComparison with SOWPODS:")
print(f"  Found: {len(found)}")
print(f"  Expected: {len(expected)}")
print(f"  Overlap: {len(found & expected)}")
print(f"  Missing: {sorted(expected - found)[:20]}")
print(f"  Extra: {sorted(found - expected)[:20]}")

# Save
output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/section2_enumerated.txt"
with open(output_path, 'w') as f:
    for word in sorted(all_words):
        f.write(word + '\n')
print(f"\nSaved to: {output_path}")
