#!/usr/bin/env python3
"""
Parse Maven's DAWG (Directed Acyclic Word Graph) dictionary structure

Based on analysis of the maven2 data fork:
- The file starts with letter index offsets
- Each node contains: offset to next sibling, character, end-of-word flag
"""
import struct
import sys

def parse_dawg(filepath, output_file=None):
    """Parse Maven's DAWG structure and extract all words"""

    with open(filepath, 'rb') as f:
        data = f.read()

    print(f"File size: {len(data)} bytes")

    # The DAWG appears to start with a header containing offsets for each letter
    # Format: 4 bytes per entry: 2 bytes offset, 1 byte unknown, 1 byte char
    # Let's first understand the structure by examining the header

    # First 4 bytes seem to be size info
    size1 = struct.unpack('>H', data[0:2])[0]
    size2 = struct.unpack('>H', data[2:4])[0]
    size3 = struct.unpack('>H', data[4:6])[0]

    print(f"Header values: {size1:04x} {size2:04x} {size3:04x}")

    # The actual letter index starts at offset 0x0C
    # Let's look at the pattern
    letter_index = {}

    # Try to understand the node format by looking at known patterns
    # Looking at the hex dump, entries seem to be:
    # 2 bytes: offset/pointer, 1 byte: flags, 1 byte: letter (lowercase ASCII)

    # Let's scan for the letter index at the start
    # Pattern observed: XX XX YY ZZ where ZZ is a letter (0x61-0x7a for a-z)

    print("\nLooking for letter index entries (format: offset flags letter):")

    offset = 0x0C  # Skip initial header
    found_letters = set()

    # Find all 26 letters in the index
    for i in range(26):
        letter = chr(ord('a') + i)
        # Search for this letter in the early part of the file
        for pos in range(0, min(0x200, len(data) - 4), 4):
            if data[pos + 3:pos + 4] == letter.encode('ascii'):
                entry_offset = struct.unpack('>H', data[pos:pos+2])[0]
                flags = data[pos + 2]
                print(f"  '{letter}' at file pos 0x{pos:04x}: offset=0x{entry_offset:04x}, flags=0x{flags:02x}")
                letter_index[letter] = (pos, entry_offset, flags)
                break

    print(f"\nFound {len(letter_index)} letters in index")

    # Now let's try to traverse the DAWG to extract words
    # The DAWG structure seems to use:
    # - High bit of first byte may indicate "last sibling"
    # - Low bits of offset point to first child
    # - Certain flags indicate "end of word"

    words = []

    def get_node(offset):
        """Get node at given offset"""
        if offset >= len(data) - 4:
            return None
        raw = struct.unpack('>I', data[offset:offset+4])[0]
        # Node format appears to be:
        # bits 0-15: child pointer
        # bits 16-23: flags (end-of-word, has-sibling, etc)
        # bits 24-31: letter code
        child_ptr = (raw >> 8) & 0xFFFF
        flags = (raw >> 24)
        letter = raw & 0xFF
        return {
            'child': child_ptr,
            'flags': flags,
            'letter': chr(letter) if 32 <= letter < 127 else f'\\x{letter:02x}',
            'raw': raw,
            'offset': offset
        }

    # Alternative interpretation:
    # Each 4-byte entry: 24-bit offset, 8-bit letter
    # Let's try another approach based on the hex dump pattern

    def parse_entry(offset):
        """Parse a 4-byte DAWG entry"""
        if offset >= len(data) - 4:
            return None
        b0, b1, b2, b3 = data[offset], data[offset+1], data[offset+2], data[offset+3]
        # Observed pattern: entries end with letter byte (0x61-0x7a or 0x3f for '?')
        letter = b3
        # First 3 bytes seem to be offset and flags
        ptr = (b0 << 8) | b1
        flags = b2
        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter) if 32 <= letter < 127 else f'\\x{letter:02x}',
            'is_eow': (flags & 0x80) != 0,  # Guess: high bit = end of word
            'offset': offset
        }

    # Scan and display first 50 entries
    print("\nFirst 100 DAWG entries:")
    for i in range(100):
        offset = i * 4
        entry = parse_entry(offset)
        if entry:
            eow = '*' if entry['is_eow'] else ' '
            print(f"  {offset:04x}: ptr=0x{entry['ptr']:04x} flags=0x{entry['flags']:02x} letter='{entry['letter']}'{eow}")

    # Try to extract some words by following the structure
    print("\n\nAttempting word extraction...")

    # The DAWG is actually stored differently - let me analyze the structure more
    # Looking at offset 0x400+ area where there's actual word data

    # Find a pattern for word boundaries
    print("\nSearching for common word patterns...")

    # Let's look for "THE" as it's a common word
    for i in range(len(data) - 10):
        if data[i:i+3] == b'THE' or data[i:i+3] == b'the':
            print(f"Found 'the' at offset 0x{i:04x}")
            # Show context
            start = max(0, i - 8)
            end = min(len(data), i + 12)
            print(f"  Context: {data[start:end].hex()}")
            break

    # Actually this DAWG format is likely using a different encoding
    # Let me check if it's using the standard DAWG format:
    # Each node = (letter, is_end, child_offset, sibling_offset)

    # Count unique letters in file at position 3 of each 4-byte group
    letter_counts = {}
    for i in range(0, len(data) - 4, 4):
        letter = data[i + 3]
        if 97 <= letter <= 122:  # a-z
            letter_counts[chr(letter)] = letter_counts.get(chr(letter), 0) + 1

    print("\nLetter frequencies at position 3 of 4-byte entries:")
    for letter in sorted(letter_counts.keys()):
        print(f"  {letter}: {letter_counts[letter]}")

    total_nodes = sum(letter_counts.values())
    print(f"\nTotal apparent DAWG nodes: {total_nodes}")

    return words

def main():
    filepath = "/Volumes/T7/retrogames/oldmac/share/maven2"
    print(f"Parsing DAWG from {filepath}\n")
    words = parse_dawg(filepath)

    if words:
        print(f"\nExtracted {len(words)} words")
        print("First 50 words:", words[:50])

if __name__ == "__main__":
    main()
