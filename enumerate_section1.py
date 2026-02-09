#!/usr/bin/env python3
"""
Enumerate words from Section 1 by traversing letter ranges.
Words are stored REVERSED, so we collect path letters and reverse at the end.

For AARDVARK:
  - k-range starts the search (last letter is 'k')
  - Path: r@983 → a@103 → v@30 → d@175 → r@73 → a@36 → a@103 (WORD)
  - Letters collected: r, a, v, d, r, a, a = "ravdraa"
  - Reversed: "aardvar" + ending letter 'k' = "aardvark"
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

# Build letter index
LETTER_INDEX_OFFSET = 0x10
letter_index = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1, flags, letter = data[offset:offset+4]
    entry = (b0 << 8) | b1
    letter_index[chr(ord('a') + i)] = entry

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
    ptr = (b0 << 8) | b1
    if not (97 <= letter <= 122):
        return None
    return {
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter),
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'entry': entry_idx,
    }

def get_child_entry(node):
    if node['ptr'] == 0:
        return None
    return node['ptr'] + (node['flags'] & 0x7e)

def get_siblings(start_entry, limit=50):
    siblings = []
    entry = start_entry
    while len(siblings) < limit:
        node = get_node(entry)
        if node is None:
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings

def enumerate_words_for_letter(ending_letter, max_words=10000):
    """Enumerate words ending in the given letter."""
    words = []
    range_start, range_end = letter_ranges[ending_letter]

    def dfs(entry, path, depth, visited):
        if depth > 20 or len(words) >= max_words:
            return
        if entry in visited:
            return
        visited = visited | {entry}

        node = get_node(entry)
        if node is None:
            return

        # Add this letter to path
        new_path = path + node['letter']

        # If this node marks a word, record it
        if node['is_word']:
            # Reverse the path and append the ending letter
            word = new_path[::-1] + ending_letter
            words.append(word)

        # Continue to children
        child = get_child_entry(node)
        if child:
            sibs = get_siblings(child)
            for s in sibs:
                dfs(s['entry'], new_path, depth + 1, visited)

    # Start from entries in the letter's range
    entry = range_start
    while entry < range_end and len(words) < max_words:
        sibs = get_siblings(entry)
        if not sibs:
            entry += 1
            continue
        for s in sibs:
            dfs(s['entry'], '', 0, set())
        entry += len(sibs)

    return words

# Test with 'k' to find AARDVARK
print("Testing enumeration from k-range (words ending in 'k'):")
print("=" * 60)

k_words = enumerate_words_for_letter('k', max_words=500)
print(f"Found {len(k_words)} words ending in 'k'")

# Check for aardvark
aardvark_matches = [w for w in k_words if 'aardvark' in w.lower()]
print(f"AARDVARK matches: {aardvark_matches}")

# Show sample words
print("\nSample words ending in 'k':")
for w in sorted(k_words)[:20]:
    print(f"  {w}")

# Now test with 's' to find AARDVARKS
print("\n" + "=" * 60)
print("Testing enumeration from s-range (words ending in 's'):")
print("=" * 60)

s_words = enumerate_words_for_letter('s', max_words=1000)
print(f"Found {len(s_words)} words ending in 's'")

# Check for aardvarks
aardvarks_matches = [w for w in s_words if 'aardvark' in w.lower()]
print(f"AARDVARKS matches: {aardvarks_matches}")

# Show words starting with 'a'
a_words_s = sorted([w for w in s_words if w.startswith('a')])
print(f"\nWords starting with 'a' and ending in 's': {len(a_words_s)}")
for w in a_words_s[:30]:
    print(f"  {w}")

# Full test for common words
print("\n" + "=" * 60)
print("Testing known words:")
print("=" * 60)

test_words = ['aa', 'ab', 'the', 'cat', 'aardvark', 'aardvarks', 'queen', 'queens']
for word in test_words:
    ending = word[-1]
    words = enumerate_words_for_letter(ending, max_words=50000)
    if word in words:
        print(f"  '{word}': FOUND")
    else:
        # Check partial matches
        matches = [w for w in words if word in w]
        if matches:
            print(f"  '{word}': not exact, but found: {matches[:5]}")
        else:
            print(f"  '{word}': NOT FOUND")
