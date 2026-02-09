#!/usr/bin/env python3
"""
Find dictionary flags by comparing OSW-only vs TWL-only words.

Known test cases:
- QUACKLE: OSW-only
- HMM, HM, MM: TWL-only
- QI: Was OSW-only in 2000 (added to TWL in 2006)

If we find different flag patterns between these groups, we've found the dictionary indicator.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
SECTION1_END = 56630
LETTER_INDEX_OFFSET = 0x10

def load_dawg():
    with open(DAWG_PATH, 'rb') as f:
        return f.read()

data = load_dawg()
section2_end = struct.unpack('>I', data[4:8])[0]

def get_node(entry_idx):
    offset = NODE_START + entry_idx * 4
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    return {
        'entry': entry_idx,
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter) if 97 <= letter <= 122 else '?',
        'is_word': (flags & 0x80) != 0,
        'is_last': (flags & 0x01) != 0,
        'raw_bytes': data[offset:offset+4],
    }

def get_child(node):
    if node['ptr'] == 0:
        return None
    return node['ptr'] + (node['flags'] & 0x7e)

def get_siblings(start_entry, limit=100):
    siblings = []
    entry = start_entry
    while entry < section2_end and len(siblings) < limit:
        node = get_node(entry)
        if node['letter'] == '?':
            break
        siblings.append(node)
        if node['is_last']:
            break
        entry += 1
    return siblings

# Letter ranges for Section 1
letter_ranges = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    start = (data[offset] << 8) | data[offset+1]
    if i < 25:
        end = (data[offset+4] << 8) | data[offset+5]
    else:
        end = SECTION1_END
    letter_ranges[chr(ord('a') + i)] = (start, end)

# Section 2 index
section2_index = {chr(ord('a') + i): [] for i in range(26)}
for entry_idx in range(SECTION1_END, section2_end):
    node = get_node(entry_idx)
    if 'a' <= node['letter'] <= 'z':
        section2_index[node['letter']].append(entry_idx)

def find_word_section1(word):
    """Find word in Section 1 (reversed). Returns final node or None."""
    reversed_word = word[::-1].lower()
    first = reversed_word[0]

    if first not in letter_ranges:
        return None

    range_start, range_end = letter_ranges[first]
    return search_section1(range_start, range_end, reversed_word[1:])

def search_section1(entry_start, entry_end, remaining):
    if not remaining:
        return True  # Found but need the actual node

    target = remaining[0]
    rest = remaining[1:]

    entry = entry_start
    while entry < entry_end:
        sibs = get_siblings(entry)
        if not sibs:
            break

        for node in sibs:
            if node['letter'] == target:
                if not rest:
                    if node['is_word']:
                        return node  # Return the actual ending node
                else:
                    child = get_child(node)
                    if child and child < SECTION1_END:
                        result = search_section1(child, SECTION1_END, rest)
                        if result:
                            return result

        entry += len(sibs)

    return None

def find_word_section2(word):
    """Find word in Section 2 (forward). Returns final node or None."""
    word = word.lower()
    first = word[0]

    for entry_idx in section2_index.get(first, []):
        node = get_node(entry_idx)
        result = match_forward(node, word[1:])
        if result:
            return result
    return None

def match_forward(node, remaining):
    if not remaining:
        if node['is_word']:
            return node
        return None

    child = get_child(node)
    if not child:
        return None

    target = remaining[0]
    rest = remaining[1:]

    sibs = get_siblings(child)
    for s in sibs:
        if s['letter'] == target:
            if not rest:
                if s['is_word']:
                    return s
            else:
                result = match_forward(s, rest)
                if result:
                    return result
    return None

def find_word(word):
    """Find word in either section. Returns (section, node) or (None, None)."""
    # Try Section 1 first
    result = find_word_section1(word)
    if result and result is not True:
        return ('Section1', result)

    # Try Section 2
    result = find_word_section2(word)
    if result:
        return ('Section2', result)

    return (None, None)

print("=== Finding Dictionary Flags ===\n")

# Test words grouped by dictionary
osw_only = ['quackle', 'gie', 'gies', 'gi', 'ch']  # OSW-only
twl_only = ['hmm', 'hm', 'mm', 'brr', 'brrr', 'grr', 'shh']  # TWL-only
both = ['the', 'cat', 'dog', 'queen', 'quiz', 'aa', 'ax']  # In both

print("OSW-only words:")
for word in osw_only:
    section, node = find_word(word)
    if node:
        print(f"  {word.upper()}: {section} entry={node['entry']} flags=0x{node['flags']:02x} ({node['flags']:08b})")
        print(f"    raw_bytes={node['raw_bytes'].hex()} ptr={node['ptr']} is_word={node['is_word']}")
    else:
        print(f"  {word.upper()}: NOT FOUND")

print("\nTWL-only words:")
for word in twl_only:
    section, node = find_word(word)
    if node:
        print(f"  {word.upper()}: {section} entry={node['entry']} flags=0x{node['flags']:02x} ({node['flags']:08b})")
        print(f"    raw_bytes={node['raw_bytes'].hex()} ptr={node['ptr']} is_word={node['is_word']}")
    else:
        print(f"  {word.upper()}: NOT FOUND")

print("\nWords in both dictionaries:")
for word in both:
    section, node = find_word(word)
    if node:
        print(f"  {word.upper()}: {section} entry={node['entry']} flags=0x{node['flags']:02x} ({node['flags']:08b})")
        print(f"    raw_bytes={node['raw_bytes'].hex()} ptr={node['ptr']} is_word={node['is_word']}")
    else:
        print(f"  {word.upper()}: NOT FOUND")

# Now analyze QI specifically
print("\n\n=== QI Analysis ===")
section, node = find_word('qi')
if node:
    print(f"QI found in {section}")
    print(f"  Entry: {node['entry']}")
    print(f"  Flags: 0x{node['flags']:02x} ({node['flags']:08b})")
    print(f"  Raw bytes: {node['raw_bytes'].hex()}")
    print(f"  ptr={node['ptr']} is_word={node['is_word']} is_last={node['is_last']}")

    # Analyze flags byte in detail
    flags = node['flags']
    print(f"\n  Flags byte breakdown:")
    print(f"    Bit 7 (0x80): {(flags >> 7) & 1} - is_word")
    print(f"    Bit 6 (0x40): {(flags >> 6) & 1}")
    print(f"    Bit 5 (0x20): {(flags >> 5) & 1}")
    print(f"    Bit 4 (0x10): {(flags >> 4) & 1}")
    print(f"    Bit 3 (0x08): {(flags >> 3) & 1}")
    print(f"    Bit 2 (0x04): {(flags >> 2) & 1}")
    print(f"    Bit 1 (0x02): {(flags >> 1) & 1}")
    print(f"    Bit 0 (0x01): {flags & 1} - is_last")

# Collect all flags from found words and look for patterns
print("\n\n=== Flag Pattern Analysis ===")
all_results = []

for word in osw_only + twl_only + both:
    section, node = find_word(word)
    if node:
        category = 'OSW' if word in osw_only else ('TWL' if word in twl_only else 'BOTH')
        all_results.append((word, category, node['flags']))

print("\nAll found words with flags:")
print(f"{'Word':<12} {'Category':<6} {'Flags':<6} {'Binary'}")
print("-" * 40)
for word, category, flags in sorted(all_results, key=lambda x: x[1]):
    print(f"{word.upper():<12} {category:<6} 0x{flags:02x}   {flags:08b}")

# Check if any specific bit correlates with dictionary
print("\n\nBit correlation with dictionary:")
for bit in range(8):
    osw_has_bit = sum(1 for w, c, f in all_results if c == 'OSW' and (f >> bit) & 1)
    osw_total = sum(1 for w, c, f in all_results if c == 'OSW')
    twl_has_bit = sum(1 for w, c, f in all_results if c == 'TWL' and (f >> bit) & 1)
    twl_total = sum(1 for w, c, f in all_results if c == 'TWL')
    both_has_bit = sum(1 for w, c, f in all_results if c == 'BOTH' and (f >> bit) & 1)
    both_total = sum(1 for w, c, f in all_results if c == 'BOTH')

    if osw_total > 0 and twl_total > 0:
        print(f"  Bit {bit}: OSW={osw_has_bit}/{osw_total} TWL={twl_has_bit}/{twl_total} BOTH={both_has_bit}/{both_total}")
