#!/usr/bin/env python3
"""
Extract dictionary from Maven's DAWG structure.

Based on analysis in analysis/gaddag_structure.md:
- Two overlapping DAWGs: reversed (Section 1) and forward (Section 2)
- Entry format: 4 bytes [ptr_hi, ptr_lo, flags, letter]
- Flags: bit 7 (0x80) = word marker, bit 0 (0x01) = last sibling
- Child calculation: ptr + (flags & 0x7e)
- Section 1 (entries 0-56,629): Reversed words for hook-BEFORE
- Section 2 (entries 56,630-122,165): Forward words for hook-AFTER

Usage:
    python3 extract_dictionary.py [dawg_file] [output_file]
"""

import struct
import sys
import os

DEFAULT_DAWG = "/Volumes/T7/retrogames/oldmac/share/maven2"
DEFAULT_OUTPUT = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/extracted_words.txt"

# DAWG structure constants
HEADER_SIZE = 16
LETTER_INDEX_OFFSET = 0x10
LETTER_INDEX_SIZE = 26 * 4
NODE_START = 0x410  # Nodes start after header + index + padding

# Node format
FLAG_WORD = 0x80    # This path forms a valid word
FLAG_LAST = 0x01    # Last sibling in group


def read_dawg(filepath):
    """Read DAWG file into memory."""
    with open(filepath, 'rb') as f:
        return f.read()


def get_header(data):
    """Parse DAWG header."""
    return {
        'section1_end': struct.unpack('>I', data[0:4])[0],
        'section2_end': struct.unpack('>I', data[4:8])[0],
        'field3': struct.unpack('>I', data[8:12])[0],
        'field4': struct.unpack('>I', data[12:16])[0],
    }


def get_letter_index(data):
    """Get letter index entries (26 letters a-z)."""
    index = {}
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        letter_char = chr(letter) if 97 <= letter <= 122 else '?'
        index[letter_char] = {
            'ptr': ptr,
            'flags': flags,
            'entry': ptr,  # Entry index to start traversal
        }
    return index


def get_node(data, entry_index):
    """Get node at given entry index."""
    offset = NODE_START + entry_index * 4
    if offset + 4 > len(data):
        return None

    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1

    return {
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter) if 97 <= letter <= 122 else '?',
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'entry': entry_index,
    }


def get_siblings(data, start_entry):
    """Get all siblings starting from given entry."""
    siblings = []
    entry = start_entry

    while True:
        node = get_node(data, entry)
        if node is None or node['letter'] == '?':
            break

        siblings.append(node)

        if node['is_last']:
            break

        entry += 1
        if entry > 200000:  # Safety limit
            break

    return siblings


def get_child_entry(node):
    """Calculate child entry index from node."""
    if node['ptr'] == 0:
        return None  # Terminal node
    # Child calculation: ptr + (flags & 0x7e)
    # flags & 0x7e extracts bits 1-6, giving offset 0-126 in steps of 2
    return node['ptr'] + (node['flags'] & 0x7e)


def extract_words_forward(data, header):
    """Extract words by traversing forward DAWG (Section 2)."""
    words = set()
    letter_index = get_letter_index(data)

    def traverse(entry, prefix, depth=0):
        if depth > 20:
            return

        siblings = get_siblings(data, entry)

        for node in siblings:
            word = prefix + node['letter']

            if node['is_word']:
                words.add(word)

            child = get_child_entry(node)
            if child is not None:
                traverse(child, word, depth + 1)

    # Start from each letter
    for letter in 'abcdefghijklmnopqrstuvwxyz':
        if letter in letter_index:
            entry = letter_index[letter]['entry']
            traverse(entry, letter)

    return words


def extract_words_reversed(data, header):
    """Extract words from reversed DAWG (Section 1), then reverse them."""
    words = set()
    letter_index = get_letter_index(data)

    def traverse(entry, prefix, depth=0):
        if depth > 20:
            return

        siblings = get_siblings(data, entry)

        for node in siblings:
            word = prefix + node['letter']

            if node['is_word']:
                # Reverse the word since this is reversed DAWG
                words.add(word[::-1])

            child = get_child_entry(node)
            if child is not None:
                traverse(child, word, depth + 1)

    # Start from each letter
    for letter in 'abcdefghijklmnopqrstuvwxyz':
        if letter in letter_index:
            entry = letter_index[letter]['entry']
            traverse(entry, letter)

    return words


def extract_all_words(data):
    """Try multiple extraction strategies and combine results."""
    header = get_header(data)
    print(f"Header: section1_end={header['section1_end']}, section2_end={header['section2_end']}")

    words = set()

    # Try forward extraction
    print("Extracting from forward traversal...")
    forward_words = extract_words_forward(data, header)
    print(f"  Found {len(forward_words)} words")
    words.update(forward_words)

    # Try reversed extraction
    print("Extracting from reversed traversal...")
    reversed_words = extract_words_reversed(data, header)
    print(f"  Found {len(reversed_words)} words")
    words.update(reversed_words)

    return words


def validate_words(words, reference_file=None):
    """Validate extracted words against reference if available."""
    # Known valid 2-letter words from SOWPODS
    valid_2letter = {
        'aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
        'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
        'by', 'ch', 'da', 'de', 'di', 'do', 'ea', 'ed', 'ee', 'ef',
        'eh', 'el', 'em', 'en', 'er', 'es', 'et', 'ex', 'fa', 'fe',
        'fy', 'gi', 'go', 'gu', 'ha', 'he', 'hi', 'hm', 'ho', 'id',
        'if', 'in', 'io', 'is', 'it', 'ja', 'jo', 'ka', 'ki', 'ko',
        'ky', 'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu',
        'my', 'na', 'ne', 'no', 'nu', 'ny', 'ob', 'od', 'oe', 'of',
        'oh', 'oi', 'ok', 'om', 'on', 'oo', 'op', 'or', 'os', 'ou',
        'ow', 'ox', 'oy', 'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh',
        'si', 'so', 'st', 'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um',
        'un', 'up', 'ur', 'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya',
        'ye', 'yo', 'yu', 'za', 'zo'
    }

    extracted_2letter = {w for w in words if len(w) == 2}

    print(f"\n2-letter word validation:")
    print(f"  Extracted: {len(extracted_2letter)}")
    print(f"  Reference valid: {len(valid_2letter)}")

    matched = extracted_2letter & valid_2letter
    missing = valid_2letter - extracted_2letter
    extra = extracted_2letter - valid_2letter

    print(f"  Matched: {len(matched)}")
    print(f"  Missing: {len(missing)}")
    if missing:
        print(f"    {sorted(missing)[:20]}...")
    print(f"  Extra (may be valid): {len(extra)}")
    if extra:
        print(f"    {sorted(extra)[:20]}...")

    return len(matched) / len(valid_2letter) if valid_2letter else 0


def main():
    dawg_file = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_DAWG
    output_file = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_OUTPUT

    print(f"Reading DAWG from: {dawg_file}")
    data = read_dawg(dawg_file)
    print(f"File size: {len(data)} bytes")

    words = extract_all_words(data)

    # Sort and deduplicate
    words = sorted(words)

    print(f"\nTotal unique words extracted: {len(words)}")

    # Show statistics
    by_length = {}
    for w in words:
        n = len(w)
        by_length[n] = by_length.get(n, 0) + 1

    print("\nWord length distribution:")
    for length in sorted(by_length.keys())[:15]:
        print(f"  {length:2d} letters: {by_length[length]:6d} words")

    # Validate
    score = validate_words(set(words))
    print(f"\nValidation score: {score:.1%}")

    # Save to file
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, 'w') as f:
        for word in words:
            f.write(word + '\n')
    print(f"\nSaved {len(words)} words to: {output_file}")

    # Show samples
    print("\nSample words:")
    print(f"  2-letter: {[w for w in words if len(w) == 2][:20]}")
    print(f"  3-letter: {[w for w in words if len(w) == 3][:20]}")
    print(f"  7-letter: {[w for w in words if len(w) == 7][:10]}")


if __name__ == "__main__":
    main()
