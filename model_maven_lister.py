#!/usr/bin/env python3
"""
Model Maven's word lister exactly to find AARDVARKS.
Step through the search methodically.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]
section3_end = struct.unpack('>I', data[8:12])[0]

print(f"Sections: 1 ends at {section1_end}, 2 ends at {section2_end}, 3 ends at {section3_end}")

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

def get_siblings(start_entry, limit=100):
    """Get siblings INCLUDING going past LAST flag if needed."""
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

# Maven's word lister might work differently
# Let me check if Section 2 entries directly spell out words

print("\n" + "=" * 60)
print("Analyzing Section 2 structure for word listing")
print("=" * 60)

# Get first few entries and trace forward
print("\nFirst 20 Section 2 entries:")
for i in range(20):
    entry_idx = section1_end + i
    node = get_node(entry_idx)
    if node:
        child = get_child_entry(node)
        print(f"  {entry_idx}: '{node['letter']}' ptr={node['ptr']} child={child} {'WORD' if node['is_word'] else ''}")

# Maven might DFS from Section 2 entries to enumerate words
# Let me enumerate words starting from a specific Section 2 'a' entry

def enumerate_from_section2_entry(start_entry, max_depth=15, max_words=100):
    """Enumerate words by DFS from a Section 2 entry."""
    words = []

    def dfs(entry, word, depth):
        if depth > max_depth or len(words) >= max_words:
            return

        node = get_node(entry)
        if node is None:
            return

        current_word = word + node['letter']

        if node['is_word'] and len(current_word) >= 2:
            words.append(current_word)

        child = get_child_entry(node)
        if child:
            # Get all siblings at child position
            sibs = get_siblings(child)
            for s in sibs:
                dfs(s['entry'], current_word, depth + 1)

    dfs(start_entry, '', 0)
    return words

# Find Section 2 'a' entries and enumerate
print("\n" + "=" * 60)
print("Enumerating from Section 2 'a' entries:")
print("=" * 60)

a_entries_s2 = []
for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'a':
        a_entries_s2.append(entry_idx)

print(f"Found {len(a_entries_s2)} 'a' entries in Section 2")

# Try a few and look for AARDVARK patterns
all_words = set()
for i, entry in enumerate(a_entries_s2[:100]):  # First 100 'a' entries
    words = enumerate_from_section2_entry(entry, max_depth=12, max_words=200)
    all_words.update(words)

    # Check for aardvark
    aardvark_words = [w for w in words if 'aardvark' in w.lower()]
    if aardvark_words:
        print(f"  Entry {entry}: FOUND {aardvark_words}")

print(f"\nTotal words from first 100 'a' entries: {len(all_words)}")

# Check if any words are real
two_letter = sorted([w for w in all_words if len(w) == 2])
print(f"2-letter words: {two_letter[:30]}")

# Check for known words
known = ['aa', 'ab', 'ad', 'the', 'cat', 'aardvark', 'aardvarks']
for w in known:
    if w in all_words:
        print(f"  '{w}': FOUND")
    else:
        print(f"  '{w}': not found")

# Now let's try a completely different approach:
# What if the word lister uses Section 3 or the area after Section 3?

print("\n" + "=" * 60)
print("Checking Section 3 and beyond:")
print("=" * 60)

# Section 3 entries
print(f"\nFirst 20 Section 3 entries (starting at {section2_end}):")
for i in range(20):
    entry_idx = section2_end + i
    node = get_node(entry_idx)
    if node:
        child = get_child_entry(node)
        print(f"  {entry_idx}: '{node['letter']}' ptr={node['ptr']} child={child} {'WORD' if node['is_word'] else ''}")

# Let's try enumerating from Section 3 'a' entries
a_entries_s3 = []
for entry_idx in range(section2_end, section3_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'a':
        a_entries_s3.append(entry_idx)

print(f"\nFound {len(a_entries_s3)} 'a' entries in Section 3")

s3_words = set()
for entry in a_entries_s3[:50]:
    words = enumerate_from_section2_entry(entry, max_depth=12, max_words=100)
    s3_words.update(words)

    aardvark_words = [w for w in words if 'aardvark' in w.lower()]
    if aardvark_words:
        print(f"  Section 3 Entry {entry}: FOUND {aardvark_words}")

print(f"\nTotal words from Section 3 'a' entries: {len(s3_words)}")

# Check for known words in Section 3
for w in known:
    if w in s3_words:
        print(f"  '{w}': FOUND in Section 3")
