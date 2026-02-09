#!/usr/bin/env python3
"""
Simple extraction from Section 1 reversed DAWG.
"""

import struct
from collections import defaultdict

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    print(f"Section 1: {section1_end} nodes")
    print(f"Section 2: {section2_end - section1_end} nodes")

    # Letter index
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        entry = struct.unpack('>H', data[offset:offset+2])[0]
        letter_index[chr(ord('a') + i)] = entry

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter_byte = data[offset:offset+4]
        if not (97 <= letter_byte <= 122):
            return None
        base_ptr = (b0 << 8) | b1
        return {
            'letter': chr(letter_byte),
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    def get_siblings(start, limit):
        siblings = []
        entry = start
        seen = set()
        while entry < limit and entry not in seen:
            seen.add(entry)
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
            if len(siblings) > 100:  # Safety limit
                break
        return siblings

    # Extract from Section 1 using iterative DFS with depth limit
    words = set()
    max_depth = 20

    for last_letter in 'abcdefghijklmnopqrstuvwxyz':
        root_entry = letter_index[last_letter]
        if root_entry == 0 or root_entry >= section1_end:
            continue

        # Stack: (entry, word_reversed, depth)
        stack = [(root_entry, last_letter, 0)]
        visited = set()

        while stack:
            entry, word_rev, depth = stack.pop()

            if depth > max_depth:
                continue

            state = (entry, word_rev)
            if state in visited:
                continue
            visited.add(state)

            siblings = get_siblings(entry, section1_end)

            for node in siblings:
                new_word = node['letter'] + word_rev

                if node['is_word']:
                    word = new_word[::-1]
                    if len(word) >= 2:
                        words.add(word)

                if node['child'] > 0 and node['child'] < section1_end:
                    stack.append((node['child'], new_word, depth + 1))

        print(f"  After '{last_letter}': {len(words)} words")

    print(f"\nTotal: {len(words)} words")

    # Validate 2-letter
    known_2 = {'aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
               'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
               'by', 'da', 'de', 'di', 'do', 'ed', 'ef', 'eh', 'el', 'em',
               'en', 'er', 'es', 'et', 'ex', 'fa', 'go', 'gu', 'ha', 'he',
               'hi', 'hm', 'ho', 'id', 'if', 'in', 'is', 'it', 'jo', 'ka',
               'ki', 'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu',
               'my', 'na', 'ne', 'no', 'nu', 'od', 'oe', 'of', 'oh', 'oi',
               'om', 'on', 'oo', 'op', 'or', 'os', 'ou', 'ow', 'ox', 'oy',
               'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh', 'si', 'so', 'st',
               'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um', 'un', 'up', 'ur',
               'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye', 'yo', 'za'}

    extracted_2 = {w for w in words if len(w) == 2}
    found = known_2 & extracted_2
    missing = known_2 - extracted_2
    extra = extracted_2 - known_2

    print(f"\n2-letter validation:")
    print(f"  Found: {len(found)}/{len(known_2)}")
    print(f"  Missing: {len(missing)} - {sorted(missing)[:20]}")
    print(f"  Extra: {len(extra)}")

    # Save
    with open("/Volumes/T7/retrogames/oldmac/maven_re/lexica/extracted_simple.txt", 'w') as f:
        for w in sorted(words):
            f.write(w + '\n')

if __name__ == "__main__":
    main()
