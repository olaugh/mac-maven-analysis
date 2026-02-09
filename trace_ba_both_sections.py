#!/usr/bin/env python3
"""Trace 'BA' through both sections."""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]

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


def get_siblings(start):
    sibs = []
    entry = start
    limit = section2_end if start >= section1_end else section1_end
    while entry < limit:
        node = get_node(entry)
        if node is None:
            break
        sibs.append(node)
        if node['is_last']:
            break
        entry += 1
    return sibs


# Try validating 'BA' via Section 2
print("Validating 'BA' via SECTION 2:")
print("Looking for 'B' entries in Section 2...")

b_entries = []
for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'b':
        b_entries.append(entry_idx)

print(f"Found {len(b_entries)} 'b' entries in Section 2")
print()

# For each B entry, look for 'a' child with is_word=True
for b_entry in b_entries[:20]:
    b_node = get_node(b_entry)
    if b_node['child'] == 0:
        continue

    # Look at children
    children = get_siblings(b_node['child'])
    for c in children:
        if c['letter'] == 'a':
            print(f"B entry {b_entry} -> child {c['entry']}: "
                  f"letter='a', is_word={c['is_word']}")
            if c['is_word']:
                print(f"  -> FOUND: BA is valid via Section 2!")

print()
print("=" * 60)

# Also check: what about validating via combined approach?
# The extract_dictionary validation checks BOTH sections

# Let me trace the actual validation function
print("Testing extract_dictionary's validation approach:")
print()


def validate_section1(word):
    """Original Section 1 validation."""
    reversed_word = word[::-1]
    first = reversed_word[0]
    remaining = reversed_word[1:]

    range_start = letter_index[first]
    range_end = letter_index[chr(ord(first) + 1)] if first != 'z' else section1_end

    def search(start, end, letters):
        if not letters:
            return True
        target = letters[0]
        rest = letters[1:]
        entry = start
        while entry < end:
            sibs = get_siblings(entry)
            for s in sibs:
                if s['letter'] == target:
                    if not rest:
                        return s['is_word']
                    if s['child']:
                        if search(s['child'], section1_end, rest):
                            return True
            entry += len(sibs)
        return False

    return search(range_start, range_end, remaining)


def validate_section2(word):
    """Section 2 validation."""
    first = word[0]
    remaining = word[1:]

    # Find all entries in Section 2 starting with first letter
    for entry_idx in range(section1_end, section2_end):
        node = get_node(entry_idx)
        if node and node['letter'] == first:
            if match_forward(node, remaining):
                return True
    return False


def match_forward(node, remaining):
    if not remaining:
        return node['is_word']
    if node['child'] == 0:
        return False
    target = remaining[0]
    rest = remaining[1:]
    sibs = get_siblings(node['child'])
    for s in sibs:
        if s['letter'] == target:
            if not rest:
                return s['is_word']
            if match_forward(s, rest):
                return True
    return False


test_words = ['ba', 'fa', 'ha', 'ja', 'ka', 'aa', 'ab', 'cat']
print("Word   | Section 1 | Section 2 | Combined")
print("-" * 50)
for word in test_words:
    s1 = validate_section1(word)
    s2 = validate_section2(word)
    combined = s1 or s2
    print(f"{word:6} | {str(s1):9} | {str(s2):9} | {combined}")
