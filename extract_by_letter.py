#!/usr/bin/env python3
"""
Extract words using letter index as starting points.
The letter index should give efficient access to words by first letter.
"""

import struct
from collections import defaultdict

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter_byte = data[offset:offset+4]
        base_ptr = (b0 << 8) | b1
        return {
            'letter': chr(letter_byte) if 97 <= letter_byte <= 122 else None,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    # Parse letter index
    letter_ranges = {}
    prev_entry = 0
    for i in range(26):
        offset = 0x10 + i * 4
        entry = struct.unpack('>H', data[offset:offset+2])[0]
        letter = chr(ord('a') + i)
        letter_ranges[letter] = entry
        if i > 0:
            prev_letter = chr(ord('a') + i - 1)
            # The previous letter's range goes from its entry to this entry - 1
            pass
        prev_entry = entry

    print("Letter index entries:")
    for letter in 'abcdefghijklmnopqrstuvwxyz':
        print(f"  {letter}: {letter_ranges[letter]}")

    # Maybe the letter index is for Section 2?
    # Section 2 starts at section1_end
    print(f"\nSection 2 range: {section1_end} to {section2_end}")

    # Try extracting from Section 2 which might be simpler
    print("\n" + "="*60)
    print("Extracting from Section 2 (forward DAWG)")
    print("="*60)

    words = set()

    def extract_from_entry(start_entry, prefix, depth, visited):
        """DFS extraction with cycle detection."""
        if depth > 20:
            return
        if start_entry in visited:
            return
        visited.add(start_entry)

        entry = start_entry
        while section1_end <= entry < section2_end:
            node = get_node(entry)
            if node is None or node['letter'] is None:
                break

            word = prefix + node['letter']

            if node['is_word'] and len(word) >= 2:
                words.add(word)

            # Section 2 children point into Section 1
            if node['child'] > 0 and node['child'] < section1_end:
                # Follow into Section 1
                extract_section1(node['child'], word, depth + 1, set())

            if node['is_last']:
                break
            entry += 1

    def extract_section1(start_entry, prefix, depth, visited):
        """Extract from Section 1."""
        if depth > 20:
            return
        if start_entry in visited:
            return
        visited.add(start_entry)

        entry = start_entry
        while 0 <= entry < section1_end:
            node = get_node(entry)
            if node is None or node['letter'] is None:
                break

            word = prefix + node['letter']

            if node['is_word'] and len(word) >= 2:
                words.add(word)

            if node['child'] > 0 and node['child'] < section1_end:
                extract_section1(node['child'], word, depth + 1, visited.copy())

            if node['is_last']:
                break
            entry += 1

    # Start from each entry in Section 2
    for entry in range(section1_end, min(section1_end + 10000, section2_end)):
        node = get_node(entry)
        if node and node['letter']:
            extract_from_entry(entry, '', 0, set())

        if len(words) % 10000 == 0 and len(words) > 0:
            print(f"  {len(words)} words...")

    print(f"\nTotal words from Section 2 start: {len(words)}")

    # Validation
    known_2 = {'aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
               'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
               'by', 'za'}

    extracted_2 = {w for w in words if len(w) == 2}
    found = known_2 & extracted_2
    print(f"\n2-letter found: {len(found)}/{len(known_2)}")
    print(f"  Found: {sorted(found)[:20]}")

    # Check for common words
    for test in ['the', 'cat', 'dog', 'aa', 'ab', 'za']:
        if test in words:
            print(f"  '{test}': FOUND")
        else:
            print(f"  '{test}': missing")

    # Save
    if words:
        output = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/extracted_section2.txt"
        with open(output, 'w') as f:
            for w in sorted(words):
                f.write(w + '\n')
        print(f"\nSaved {len(words)} words to {output}")

if __name__ == "__main__":
    main()
