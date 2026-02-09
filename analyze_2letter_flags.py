#!/usr/bin/env python3
"""
Analyze 2-letter word bit patterns to find dictionary flags.

Hypothesis: bits 10-11 in DAWG entries might indicate dictionary membership
(e.g., TWL vs SOWPODS).
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410

def load_dawg():
    with open(DAWG_PATH, 'rb') as f:
        return f.read()

def get_entry(data, idx):
    offset = NODE_START + idx * 4
    return struct.unpack('>I', data[offset:offset+4])[0]

def decode(e):
    return {
        'letter': chr(e & 0xFF) if 97 <= (e & 0xFF) <= 122 else '?',
        'eow': (e >> 8) & 1,
        'last': (e >> 9) & 1,
        'bit10': (e >> 10) & 1,
        'bit11': (e >> 11) & 1,
        'child': e >> 10,
    }

def find_2letter_word(data, section2_end, first, second):
    """Find 2-letter word in Section 2 and return its ending entry info."""
    for idx in range(56630, section2_end):
        e = get_entry(data, idx)
        d = decode(e)
        if d['letter'] == first:
            child = d['child']
            if child and child < section2_end:
                for sib in range(child, min(child + 50, section2_end)):
                    se = get_entry(data, sib)
                    sd = decode(se)
                    if sd['letter'] == second and sd['eow']:
                        return (idx, sib, se, sd)
                    if sd['last']:
                        break
    return None

def main():
    data = load_dawg()
    section2_end = struct.unpack('>I', data[4:8])[0]

    # Known TWL 2-letter words
    twl_words = ['ax', 'ox', 'by', 'my', 'be', 'he', 'me', 'we', 'if', 'of',
                 'aa', 'ab', 'ad', 'ae', 'ah', 'am', 'an', 'ar', 'as', 'at',
                 'ba', 'bo', 'do', 'go', 'ha', 'hi', 'ho', 'in', 'is', 'it',
                 'no', 'on', 'or', 'so', 'to', 'up', 'us']

    # Known SOWPODS-only 2-letter words (at time Maven was made ~1990s)
    sowpods_only = ['qi', 'zo', 'ch', 'gi', 'gu', 'ja', 'ko', 'ky', 'po', 'te',
                    'da', 'di', 'ea', 'ee', 'fe', 'io', 'ka', 'ki', 'oo', 'ou',
                    'st', 'ta', 'ti', 'ug', 'um', 'ut', 'wo', 'xu', 'yu']

    print("=== Analyzing 2-letter word bit patterns ===")
    print("\nHypothesis: bits 10-11 indicate dictionary membership")
    print("If QI (SOWPODS-only) has a unique pattern, that's significant\n")

    results = {'twl': [], 'sowpods_only': []}

    print("Searching for TWL words...")
    for word in twl_words:
        result = find_2letter_word(data, section2_end, word[0], word[1])
        if result:
            first_idx, second_idx, entry, d = result
            results['twl'].append((word, d['bit10'], d['bit11'], entry))

    print("Searching for SOWPODS-only words...")
    for word in sowpods_only:
        result = find_2letter_word(data, section2_end, word[0], word[1])
        if result:
            first_idx, second_idx, entry, d = result
            results['sowpods_only'].append((word, d['bit10'], d['bit11'], entry))

    print("\n" + "="*60)
    print("TWL 2-letter words:")
    print("  Word  bit10  bit11  entry")
    print("-" * 40)
    for word, b10, b11, entry in sorted(results['twl']):
        print(f"  {word}    {b10}      {b11}      0x{entry:08x}")

    print("\n" + "="*60)
    print("SOWPODS-only 2-letter words:")
    print("  Word  bit10  bit11  entry")
    print("-" * 40)
    for word, b10, b11, entry in sorted(results['sowpods_only']):
        print(f"  {word}    {b10}      {b11}      0x{entry:08x}")

    # Count patterns
    print("\n" + "="*60)
    print("Pattern summary (bit10, bit11):")
    for cat, items in results.items():
        patterns = {}
        for word, b10, b11, entry in items:
            key = f"{b10}{b11}"
            patterns[key] = patterns.get(key, 0) + 1
        print(f"  {cat}: {patterns}")

    # Specifically look at QI
    print("\n" + "="*60)
    print("QI detailed analysis:")
    qi = find_2letter_word(data, section2_end, 'q', 'i')
    if qi:
        first_idx, second_idx, entry, d = qi
        print(f"  Q index: {first_idx}")
        print(f"  I index: {second_idx}")
        print(f"  I entry: 0x{entry:08x}")
        print(f"  Binary:  {entry:032b}")
        print(f"  Bits 0-7 (letter):  {entry & 0xFF} = '{chr(entry & 0xFF)}'")
        print(f"  Bit 8 (eow):        {(entry >> 8) & 1}")
        print(f"  Bit 9 (last):       {(entry >> 9) & 1}")
        print(f"  Bit 10:             {(entry >> 10) & 1}")
        print(f"  Bit 11:             {(entry >> 11) & 1}")
        print(f"  Bits 10-31 (child): {entry >> 10}")
    else:
        print("  QI not found!")

if __name__ == "__main__":
    main()
