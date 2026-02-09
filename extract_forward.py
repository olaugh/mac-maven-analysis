#!/usr/bin/env python3
"""
Extract words by forward traversal from all root groups.
"""

import struct
from collections import defaultdict

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        b0, b1, flags, letter_byte = data[offset:offset+4]
        base_ptr = (b0 << 8) | b1
        return {
            'letter': chr(letter_byte) if 97 <= letter_byte <= 122 else None,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    print("Finding root groups...")

    # Find all root groups (sibling group starts not pointed to as children)
    child_targets = set()
    for i in range(section1_end):
        node = get_node(i)
        if node['child'] > 0:
            child_targets.add(node['child'])

    # Find sibling group starts
    group_starts = [0]
    for i in range(section1_end):
        node = get_node(i)
        if node['is_last'] and i + 1 < section1_end:
            group_starts.append(i + 1)

    root_groups = [gs for gs in group_starts if gs not in child_targets]
    print(f"Found {len(root_groups)} root groups")

    # Forward DFS from all roots
    print("Extracting words...")
    words = set()
    max_depth = 20

    for root in root_groups:
        # DFS stack: (entry, word_so_far, depth)
        stack = [(root, '', 0)]

        while stack:
            entry, word, depth = stack.pop()

            if depth > max_depth:
                continue

            # Process all siblings at this level
            current = entry
            seen_in_group = set()

            while current < section1_end and current not in seen_in_group:
                seen_in_group.add(current)
                node = get_node(current)

                if node['letter']:
                    new_word = word + node['letter']

                    # If this node marks a complete word, record it
                    if node['is_word'] and len(new_word) >= 2:
                        words.add(new_word)

                    # Continue to children if they exist
                    if node['child'] > 0 and node['child'] < section1_end:
                        stack.append((node['child'], new_word, depth + 1))

                if node['is_last']:
                    break
                current += 1

        if len(words) % 50000 == 0 and len(words) > 0:
            print(f"  {len(words)} words found...")

    print(f"\nTotal words: {len(words)}")

    # Validation
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
    print(f"  Missing: {sorted(missing)}")
    print(f"  Extra: {len(extra)}")

    # Length distribution
    print(f"\nWord length distribution:")
    by_len = defaultdict(int)
    for w in words:
        by_len[len(w)] += 1
    for length in sorted(by_len.keys())[:15]:
        print(f"  {length}: {by_len[length]}")

    # Check for 'the'
    if 'the' in words:
        print("\n'the' found!")
    else:
        print("\n'the' NOT found!")

    # Save
    output = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/extracted_forward.txt"
    with open(output, 'w') as f:
        for w in sorted(words):
            f.write(w + '\n')
    print(f"\nSaved to {output}")

if __name__ == "__main__":
    main()
