#!/usr/bin/env python3
"""
Analyze root entries in Section 2 and Section 3.

Hypothesis: Section 2 and Section 3 are different lexicons (SOWPODS vs TWL).
Each section has entry points for words starting with each letter.

If we can understand how these map to words, we can enumerate correctly.
"""

import struct
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]
section3_end = struct.unpack('>I', data[8:12])[0]


def get_node(entry_idx):
    """Get DAWG node at entry index."""
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
        'ptr': ptr,
        'flags': flags,
        'is_word': bool(flags & 0x80),
        'is_last': bool(flags & 0x01),
        'child': ptr + (flags & 0x7e) if ptr else 0,
    }


def count_entries_by_letter(start, end):
    """Count entries by first letter in a section."""
    counts = defaultdict(list)
    for entry_idx in range(start, end):
        node = get_node(entry_idx)
        if node:
            counts[node['letter']].append(entry_idx)
    return counts


print("Root entry analysis")
print("=" * 60)

# Section 2 analysis
print("\nSection 2 entries by letter:")
sec2_entries = count_entries_by_letter(section1_end, section2_end)
sec2_total = 0
for letter in 'abcdefghijklmnopqrstuvwxyz':
    count = len(sec2_entries.get(letter, []))
    sec2_total += count
    if count > 0:
        entries = sec2_entries[letter][:5]
        print(f"  '{letter}': {count:5d} entries (first: {entries})")
print(f"  Total: {sec2_total}")

# Section 3 analysis
print("\nSection 3 entries by letter:")
sec3_entries = count_entries_by_letter(section2_end, section3_end)
sec3_total = 0
for letter in 'abcdefghijklmnopqrstuvwxyz':
    count = len(sec3_entries.get(letter, []))
    sec3_total += count
    if count > 0:
        entries = sec3_entries[letter][:5]
        print(f"  '{letter}': {count:5d} entries (first: {entries})")
print(f"  Total: {sec3_total}")

# Let's trace a word like "CAT" through both sections
print("\n" + "=" * 60)
print("Tracing 'CAT' through Section 2:")

# Find 'C' entries in Section 2
c_entries = sec2_entries.get('c', [])
print(f"Found {len(c_entries)} 'c' entries in Section 2")

# For each C entry, try to find path to A then T
cat_paths = []
for c_entry in c_entries[:20]:  # Check first 20
    c_node = get_node(c_entry)
    if not c_node or c_node['child'] == 0:
        continue

    # Look for 'a' in children
    child_entry = c_node['child']
    while True:
        a_node = get_node(child_entry)
        if a_node is None:
            break
        if a_node['letter'] == 'a':
            # Found 'a', now look for 't' in its children
            if a_node['child'] > 0:
                t_entry = a_node['child']
                while True:
                    t_node = get_node(t_entry)
                    if t_node is None:
                        break
                    if t_node['letter'] == 't':
                        if t_node['is_word']:
                            cat_paths.append((c_entry, child_entry, t_entry))
                            print(f"  FOUND: C@{c_entry} -> A@{child_entry} -> T@{t_entry} (is_word=True)")
                        break
                    if t_node['is_last']:
                        break
                    t_entry += 1
            break
        if a_node['is_last']:
            break
        child_entry += 1

print(f"\nTotal 'CAT' paths found: {len(cat_paths)}")

# Now let's understand why enumeration fails
# Try enumerating short words from a single C entry
print("\n" + "=" * 60)
print("Enumerating 2-3 letter words starting with 'C' from Section 2:")

def enumerate_short_words(start_entry, first_letter, max_len=3):
    """Enumerate words up to max_len starting from entry."""
    words = []

    def traverse(entry_idx, path, depth):
        if depth > max_len - 1:  # -1 because first letter already in path
            return

        node = get_node(entry_idx)
        if node is None:
            return

        new_path = path + node['letter']

        # If is_word and path is complete enough, record it
        if node['is_word'] and len(new_path) >= 2:
            words.append(new_path)

        # Follow children if we haven't reached max length
        if depth < max_len - 1 and node['child'] > 0:
            # Traverse all siblings at child level
            child_entry = node['child']
            while True:
                child_node = get_node(child_entry)
                if child_node is None:
                    break
                traverse(child_entry, new_path, depth + 1)
                if child_node['is_last']:
                    break
                child_entry += 1

    # For each C entry, enumerate short words
    c_node = get_node(start_entry)
    if c_node and c_node['child'] > 0:
        # Start with first letter
        path = first_letter

        # If this entry has is_word, it's a 1-letter word (unlikely)
        if c_node['is_word']:
            words.append(path)

        # Traverse children
        child_entry = c_node['child']
        while True:
            child_node = get_node(child_entry)
            if child_node is None:
                break
            traverse(child_entry, path, 1)
            if child_node['is_last']:
                break
            child_entry += 1

    return words

# Try first few C entries
all_c_words = set()
for c_entry in c_entries[:10]:
    words = enumerate_short_words(c_entry, 'c', max_len=3)
    all_c_words.update(words)
    if words:
        print(f"  Entry {c_entry}: {len(words)} words, sample: {sorted(words)[:10]}")

print(f"\nUnique 2-3 letter words starting with 'c': {sorted(all_c_words)}")

# Check against known C words
known_c_words = ['ch']  # 2-letter words starting with C in SOWPODS
for word in known_c_words:
    found = word in all_c_words
    print(f"  '{word}': {'FOUND' if found else 'NOT FOUND'}")
