#!/usr/bin/env python3
"""
Enumerate words by traversing forward from letter index
"""

import struct
from collections import defaultdict

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
H1 = 56630
H2 = 122166

with open(DAWG_PATH, 'rb') as f:
    DATA = f.read()

def get_entry(idx):
    offset = NODE_BASE + idx * 4
    ptr = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'[0x{letter_byte:02x}]'
    return ptr, flags, letter

def get_child(idx):
    ptr, flags, _ = get_entry(idx)
    if ptr == 0:
        return None
    return ptr + (flags & 0x7e)

def get_sibling_group(start_idx, max_idx=H2):
    siblings = []
    j = start_idx
    while j < max_idx:
        ptr, flags, letter = get_entry(j)
        siblings.append((j, ptr, flags, letter))
        if flags & 0x01:
            break
        j += 1
    return siblings

# Read letter index
letter_index = {}
for i in range(26):
    offset = 0x0010 + i * 4
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    letter = chr(ord('a') + i)
    letter_index[letter] = entry_idx

print("=" * 60)
print("Forward Word Enumeration")
print("=" * 60)

def enumerate_words_from(start_idx, prefix, max_depth=15, max_words=1000):
    """Enumerate all words reachable from start_idx"""
    words = []

    def recurse(idx, current_word, depth):
        if depth > max_depth or len(words) >= max_words:
            return

        siblings = get_sibling_group(idx)
        for entry_idx, ptr, flags, letter in siblings:
            if letter.startswith('['):  # Non-letter
                continue

            new_word = current_word + letter

            if flags & 0x80:  # WORD marker
                words.append(new_word)

            if ptr > 0 and len(words) < max_words:
                child = get_child(entry_idx)
                if child and child < H2:
                    recurse(child, new_word, depth + 1)

    recurse(start_idx, prefix, 0)
    return words

# Enumerate from each letter
print("\nEnumerating from letter index (first DAWG)...")
all_words_1 = []

for letter in 'abcdefghijklmnopqrstuvwxyz':
    start = letter_index[letter]
    words = enumerate_words_from(start, letter, max_words=500)
    all_words_1.extend(words)
    print(f"  {letter.upper()}: {len(words)} words from entry {start}")

print(f"\nTotal words enumerated from first DAWG: {len(all_words_1)}")

# Sample words
print("\nSample words from first DAWG:")
sample = sorted(set(all_words_1))[:30]
for w in sample:
    print(f"  {w}")

# Check against SOWPODS
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods = set(line.strip().upper() for line in f)

    valid = [w for w in all_words_1 if w.upper() in sowpods]
    print(f"\nValid SOWPODS words: {len(valid)}/{len(all_words_1)}")
    print("Valid sample:", valid[:20])
except Exception as e:
    print(f"Error loading SOWPODS: {e}")

# Look for RETINAS patterns
print("\n" + "=" * 60)
print("Searching for RETINA* patterns")
print("=" * 60)

retina_words = [w for w in all_words_1 if 'retin' in w.lower()]
print(f"Words containing 'retin': {retina_words}")

etinas_words = [w for w in all_words_1 if 'etinas' in w.lower()]
print(f"Words containing 'etinas': {etinas_words}")

# Try starting from 'r' specifically with more depth
print("\n--- Deep enumeration from R ---")
r_start = letter_index['r']
r_words = enumerate_words_from(r_start, 'r', max_depth=20, max_words=2000)
print(f"Words from R: {len(r_words)}")

ret_words = [w for w in r_words if w.startswith('ret')]
print(f"Words starting with 'ret': {ret_words[:20]}")

retin_words = [w for w in r_words if w.startswith('retin')]
print(f"Words starting with 'retin': {retin_words}")
