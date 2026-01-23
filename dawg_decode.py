#!/usr/bin/env python3
"""
Decode Maven's DAWG format by trying multiple interpretations

Based on observations:
- File header contains sizes/counts
- Letter index at 0x10-0x77
- DAWG data starts at 0x400
- 4 bytes per node: [b0 b1 b2 b3] where b3 is the letter

Hypothesis: The 24-bit value (b0<<16 | b1<<8 | b2) encodes:
- Child pointer in some bits
- End-of-word flag
- Possibly last-sibling flag
"""
import struct
import sys
from collections import defaultdict

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def decode_node_v1(b0, b1, b2, b3):
    """Interpretation 1: ptr=b0b1, flags=b2, letter=b3"""
    return {
        'ptr': (b0 << 8) | b1,
        'flags': b2,
        'letter': b3,
        'eow': (b2 & 0x01) != 0,
        'last': (b2 & 0x02) != 0
    }

def decode_node_v2(b0, b1, b2, b3):
    """Interpretation 2: 24-bit value split differently
    Maybe: high bits of b2 are part of pointer, low bits are flags
    """
    ptr_part = (b0 << 8) | b1
    flag_part = b2 & 0x07  # low 3 bits as flags
    ptr_ext = (b2 >> 3)    # high 5 bits extend pointer
    full_ptr = (ptr_part << 5) | ptr_ext
    return {
        'ptr': full_ptr,
        'flags': flag_part,
        'letter': b3,
        'eow': (flag_part & 0x01) != 0,
        'last': (flag_part & 0x02) != 0
    }

def decode_node_v3(b0, b1, b2, b3):
    """Interpretation 3: b2 is entirely part of 24-bit pointer
    eow might be encoded in pointer bits or in letter high bit
    """
    ptr = (b0 << 16) | (b1 << 8) | b2
    letter_code = b3 & 0x7f
    eow = (b3 & 0x80) != 0
    return {
        'ptr': ptr,
        'flags': 0,
        'letter': letter_code,
        'eow': eow,
        'last': False  # need to determine differently
    }

def decode_node_v4(b0, b1, b2, b3):
    """Interpretation 4: Like v1 but with different bit meanings
    Maybe bit 0 of flags is 'has children', not 'end of word'
    And 'end of word' is signaled by having ptr=0
    """
    ptr = (b0 << 8) | b1
    return {
        'ptr': ptr,
        'flags': b2,
        'letter': b3,
        'eow': ptr == 0,  # terminal node = end of word
        'last': (b2 & 0x02) != 0
    }

def validate_words(data, decode_func, test_words=['aa', 'ab', 'ad', 'ae', 'at', 'ax', 'ay']):
    """Try to validate known 2-letter words using given decode function"""
    found = []

    DAWG_START = 0x400

    # Get the 'A' index entry
    a_idx = 0x10
    b0, b1, b2, b3 = data[a_idx:a_idx+4]
    a_ptr = (b0 << 8) | b1

    # Find children of 'A'
    a_children_offset = DAWG_START + a_ptr * 4

    print(f"Checking 2-letter words starting with A:")
    print(f"  'A' index at 0x{a_idx:02x}: ptr=0x{a_ptr:04x}")
    print(f"  Children start at 0x{a_children_offset:04x}")

    # Scan children
    offset = a_children_offset
    for i in range(30):  # Check up to 30 siblings
        if offset >= len(data) - 4:
            break
        b0, b1, b2, b3 = data[offset:offset+4]
        node = decode_func(b0, b1, b2, b3)

        if not (97 <= node['letter'] <= 122):  # Not a-z
            break

        letter = chr(node['letter'])
        word = 'a' + letter

        if node['eow']:
            found.append(word)
            print(f"    0x{offset:04x}: '{letter}' -> '{word}' VALID (ptr=0x{node['ptr']:04x}, flags=0x{node['flags']:02x})")
        else:
            print(f"    0x{offset:04x}: '{letter}' -> '{word}' not eow (ptr=0x{node['ptr']:04x}, flags=0x{node['flags']:02x})")

        offset += 4

    # Compare with expected
    expected = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an', 'ar', 'as', 'at', 'aw', 'ax', 'ay']
    matched = [w for w in found if w in expected]
    print(f"\n  Found: {found}")
    print(f"  Expected subset: {expected[:10]}...")
    print(f"  Matched: {matched}")

    return len(matched), found

def main():
    filepath = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data = read_file(filepath)

    print("Testing different DAWG decode interpretations:\n")

    decoders = [
        ("V1: ptr=b0b1, flags=b2, letter=b3, eow=bit0", decode_node_v1),
        ("V2: ptr=b0b1+(b2>>3), flags=b2&7, eow=bit0", decode_node_v2),
        ("V3: ptr=24bit, eow=letter_bit7", decode_node_v3),
        ("V4: ptr=b0b1, eow=(ptr==0)", decode_node_v4),
    ]

    best_score = 0
    best_decoder = None

    for name, decoder in decoders:
        print(f"=== {name} ===")
        try:
            score, found = validate_words(data, decoder)
            if score > best_score:
                best_score = score
                best_decoder = (name, decoder)
        except Exception as e:
            print(f"  Error: {e}")
        print()

    if best_decoder:
        print(f"\nBest decoder: {best_decoder[0]} with {best_score} matches")

        # Try to extract all 2-letter words with best decoder
        print("\n=== Extracting all 2-letter words with best decoder ===")
        decoder = best_decoder[1]
        DAWG_START = 0x400

        all_2letter = []
        for first_letter_idx in range(26):
            idx_offset = 0x10 + first_letter_idx * 4
            b0, b1, b2, b3 = data[idx_offset:idx_offset+4]
            ptr = (b0 << 8) | b1
            first_letter = chr(ord('a') + first_letter_idx)

            children_offset = DAWG_START + ptr * 4

            offset = children_offset
            for i in range(30):
                if offset >= len(data) - 4:
                    break
                b0, b1, b2, b3 = data[offset:offset+4]
                node = decoder(b0, b1, b2, b3)

                if not (97 <= node['letter'] <= 122):
                    break

                if node['eow']:
                    word = first_letter + chr(node['letter'])
                    all_2letter.append(word)

                offset += 4

        print(f"Found {len(all_2letter)} 2-letter words:")
        print(sorted(all_2letter))

if __name__ == "__main__":
    main()
