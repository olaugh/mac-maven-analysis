#!/usr/bin/env python3
"""
Enumerate words from Maven's DAWG by exhaustive generation and validation.

For short words (2-7 letters), we can generate all possible combinations
and validate each against the DAWG.

For longer words, this becomes infeasible, so we'd need a reference lexicon.
"""

import struct
import itertools
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]

# Build letter index
LETTER_INDEX_OFFSET = 0x10
letter_index = {}
for i in range(26):
    offset = LETTER_INDEX_OFFSET + i * 4
    b0, b1 = data[offset:offset+2]
    letter_index[chr(ord('a') + i)] = (b0 << 8) | b1


def get_entry(entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    return {
        'ptr': ptr,
        'flags': flags,
        'letter': chr(letter),
        'is_word': bool(flags & FLAG_WORD),
        'child': ptr + (flags & 0x7e) if ptr else None,
    }


def validate_word(word):
    """Validate a word using open search from letter range."""
    if len(word) < 2:
        return False

    word = word.lower()
    reversed_word = word[::-1]
    first = reversed_word[0]
    remaining = reversed_word[1:]

    range_start = letter_index.get(first, 0)

    def search(search_start, letters_left):
        if not letters_left:
            return True

        target = letters_left[0]
        rest = letters_left[1:]

        for entry in range(search_start, section1_end):
            e = get_entry(entry)
            if e and e['letter'] == target:
                if not rest:
                    return e['is_word']
                child = e['child']
                if child and search(child, rest):
                    return True
        return False

    return search(range_start, remaining)


def enumerate_short_words(max_length=5):
    """Enumerate all valid words up to max_length by brute force."""
    letters = 'abcdefghijklmnopqrstuvwxyz'
    words = []

    for length in range(2, max_length + 1):
        print(f"Checking {length}-letter combinations...")
        count = 0
        for combo in itertools.product(letters, repeat=length):
            word = ''.join(combo)
            if validate_word(word):
                words.append(word)
                count += 1
        print(f"  Found {count} valid {length}-letter words")

    return words


def main():
    print("Maven DAWG Word Enumeration (Validated)")
    print("=" * 60)

    # Quick validation test
    print("\nValidation sanity check:")
    test_words = ['aa', 'ab', 'ba', 'zz', 'xyz', 'the', 'cat', 'aardvark']
    for word in test_words:
        result = validate_word(word)
        print(f"  {word}: {'VALID' if result else 'INVALID'}")

    # Enumerate 2-letter words (26^2 = 676 candidates)
    print("\n" + "=" * 60)
    print("Enumerating 2-letter words (676 candidates)...")
    two_letter = []
    letters = 'abcdefghijklmnopqrstuvwxyz'
    for a in letters:
        for b in letters:
            word = a + b
            if validate_word(word):
                two_letter.append(word)

    print(f"Found {len(two_letter)} valid 2-letter words:")
    print(f"  {sorted(two_letter)}")

    # Enumerate 3-letter words (26^3 = 17576 candidates)
    print("\n" + "=" * 60)
    print("Enumerating 3-letter words (17576 candidates)...")
    three_letter = []
    for combo in itertools.product(letters, repeat=3):
        word = ''.join(combo)
        if validate_word(word):
            three_letter.append(word)

    print(f"Found {len(three_letter)} valid 3-letter words")
    print(f"  Sample: {sorted(three_letter)[:30]}")

    # Save 2 and 3 letter words
    output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/short_words_enumerated.txt"
    all_short = sorted(set(two_letter + three_letter))
    with open(output_path, 'w') as f:
        for w in all_short:
            f.write(w + '\n')
    print(f"\nSaved {len(all_short)} short words to: {output_path}")


if __name__ == "__main__":
    main()
