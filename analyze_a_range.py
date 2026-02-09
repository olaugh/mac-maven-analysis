#!/usr/bin/env python3
"""Analyze what's in the 'a' range."""

import struct
from collections import Counter

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

LETTER_INDEX_OFFSET = 0x10
letter_index = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1 = data[offset:offset+2]
    letter_index[chr(ord('a') + i)] = (b0 << 8) | b1


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


a_start = letter_index['a']
a_end = letter_index['b']
print(f"'a' range: entries {a_start} to {a_end-1} ({a_end - a_start} entries)")
print()

# Collect all letters in 'a' range
letters_in_range = Counter()
word_letters = Counter()

for entry in range(a_start, a_end):
    node = get_node(entry)
    if node:
        letters_in_range[node['letter']] += 1
        if node['is_word']:
            word_letters[node['letter']] += 1

print("Letters in 'a' range:")
for letter, count in sorted(letters_in_range.items()):
    word_count = word_letters.get(letter, 0)
    print(f"  '{letter}': {count:3d} entries, {word_count:3d} with is_word=True")

print()
print(f"Total entries: {sum(letters_in_range.values())}")
print(f"Unique letters: {len(letters_in_range)}")
print()

# What 2-letter words ending in 'a' CAN we form?
print("Possible 2-letter words ending in 'a' (from entries with is_word=True):")
words = []
for entry in range(a_start, a_end):
    node = get_node(entry)
    if node and node['is_word']:
        # This entry's letter + 'a' = word
        word = node['letter'] + 'a'
        words.append(word)

words = sorted(set(words))
print(f"  {words}")
print()

# Compare with expected SOWPODS 2-letter words ending in 'a'
expected_a = ['aa', 'ba', 'da', 'ea', 'fa', 'ha', 'ja', 'ka', 'la', 'ma',
              'na', 'pa', 'ta', 'ya', 'za']
found = set(words)
expected = set(expected_a)

print(f"Expected (SOWPODS): {sorted(expected)}")
print(f"Found: {sorted(found)}")
print(f"Missing: {sorted(expected - found)}")
print(f"Extra: {sorted(found - expected)}")
