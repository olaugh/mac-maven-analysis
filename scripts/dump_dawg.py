#!/usr/bin/env python3
"""
Dump Maven DAWG contents and search for patterns
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

def find_group_start(idx):
    """Find first entry of sibling group containing idx"""
    j = idx
    while j > 0:
        _, prev_flags, _ = get_entry(j - 1)
        if prev_flags & 0x01:
            break
        j -= 1
    return j

# Build parent map
print("Building parent map...")
parent_map = defaultdict(list)
for i in range(H2):
    ptr, flags, letter = get_entry(i)
    if ptr > 0:
        child = get_child(i)
        if child and child < H2:
            parent_map[child].append(i)

print(f"Parent map has {len(parent_map)} entries")

def trace_back(idx, max_depth=15):
    """Trace all paths leading to this entry"""
    def recurse(current_idx, depth, path):
        if depth > max_depth:
            return [path]

        _, _, letter = get_entry(current_idx)
        new_path = [letter] + path

        group_start = find_group_start(current_idx)
        if group_start not in parent_map:
            return [new_path]

        results = []
        for parent_idx in parent_map[group_start][:10]:  # Limit branching
            results.extend(recurse(parent_idx, depth + 1, new_path))
        return results if results else [new_path]

    return recurse(idx, 0, [])

print("\n" + "=" * 60)
print("Searching for ETINAS suffix pattern")
print("=" * 60)

# Find entries with 's' that are WORD endpoints
# and trace backwards to find -ETINAS patterns

s_word_entries = []
for i in range(H2):
    ptr, flags, letter = get_entry(i)
    if letter == 's' and (flags & 0x80):  # 's' with WORD marker
        s_word_entries.append(i)

print(f"Found {len(s_word_entries)} 's' WORD entries")

# For each, trace back and look for -ETINAS pattern
etinas_patterns = []
print("\nSearching for -ETINAS patterns...")

for s_idx in s_word_entries:
    paths = trace_back(s_idx, max_depth=10)
    for path in paths:
        word = ''.join(path)
        if word.endswith('etinas') or 'etinas' in word:
            etinas_patterns.append((s_idx, word, path))
        # Also check for variations
        if 'tinas' in word or 'inas' in word:
            if len(word) >= 6:
                etinas_patterns.append((s_idx, word, path))

print(f"Found {len(etinas_patterns)} potential -ETINAS patterns")
for idx, word, path in etinas_patterns[:20]:
    print(f"  Entry {idx}: {word}")

# Search for any word containing 'etin' or 'tina' or 'inas'
print("\n" + "=" * 60)
print("Searching for RETIN* patterns in all WORD entries")
print("=" * 60)

all_word_entries = []
for i in range(H2):
    ptr, flags, letter = get_entry(i)
    if flags & 0x80:  # WORD marker
        all_word_entries.append(i)

print(f"Total WORD entries: {len(all_word_entries)}")

# Sample and trace back
retin_words = []
print("\nTracing sample of WORD entries looking for RETIN patterns...")

for word_idx in all_word_entries[:5000]:  # Sample
    paths = trace_back(word_idx, max_depth=12)
    for path in paths:
        word = ''.join(path)
        if 'retin' in word.lower() or 'tinas' in word.lower():
            retin_words.append((word_idx, word))
            break  # One match per entry is enough

print(f"Found {len(retin_words)} words containing 'retin' or 'tinas':")
for idx, word in retin_words[:30]:
    print(f"  Entry {idx}: {word}")

# Also dump some actual word paths to see the structure
print("\n" + "=" * 60)
print("Sample of extracted words")
print("=" * 60)

sample_words = []
for word_idx in all_word_entries[:200]:
    paths = trace_back(word_idx, max_depth=10)
    for path in paths[:1]:  # Just first path
        word = ''.join(path)
        if len(word) >= 3 and len(word) <= 8:
            sample_words.append(word)

print(f"Sample words from DAWG (3-8 letters):")
# Sort and show unique
unique_words = sorted(set(sample_words))[:50]
for word in unique_words:
    print(f"  {word}")

# Verify these are real words
print("\n--- Verifying against SOWPODS ---")
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods = set(line.strip().upper() for line in f)

    valid = sum(1 for w in unique_words if w.upper() in sowpods)
    print(f"Valid SOWPODS words: {valid}/{len(unique_words)}")

    invalid = [w for w in unique_words if w.upper() not in sowpods]
    if invalid:
        print(f"Invalid: {invalid[:10]}")
except:
    pass
