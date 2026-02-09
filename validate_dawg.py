#!/usr/bin/env python3
"""
Validate words against Maven DAWG using the correct traversal algorithm.
Based on dynamic trace analysis of CODE 15.
"""

import struct

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    entries = []
    for i in range(len(data) // 4):
        entry = struct.unpack('>I', data[i*4:(i+1)*4])[0]
        entries.append(entry)
    return entries

def validate_word_section1(entries, word):
    """
    Validate word using Section 1 (reversed dictionary).
    Word must be reversed before searching.
    """
    reversed_word = word[::-1]

    # Section 1 roots are at entries 4-29 (a-z), indexed by last letter
    last_letter = reversed_word[0]
    if not last_letter.isalpha():
        return False

    root_idx = 4 + (ord(last_letter.lower()) - ord('a'))
    if root_idx < 4 or root_idx > 29:
        return False

    entry = entries[root_idx]
    child = entry >> 10

    if len(reversed_word) == 1:
        # Single letter - check if root has WORD flag
        return bool(entry & 0x100)

    # Walk remaining letters
    return walk_dawg(entries, child, reversed_word[1:])

def validate_word_section2(entries, word):
    """
    Validate word using Section 2 (forward dictionary).
    Section 2 starts at entry 56630.
    """
    # Section 2 has a more complex structure - need to find the right entry point
    # Let's try walking from the beginning

    # Actually, looking at the structure, Section 2 might not have simple roots
    # It might be indexed differently

    # Try a different approach: search for the word by scanning
    return walk_dawg_scan(entries, 56630, 122165, word)

def walk_dawg(entries, start_idx, remaining_word):
    """Walk DAWG from start_idx looking for remaining_word."""
    if not remaining_word:
        return True  # All letters matched

    if start_idx <= 0 or start_idx >= len(entries):
        return False

    target = remaining_word[0].lower()
    idx = start_idx

    # Walk sibling chain
    while idx < len(entries):
        entry = entries[idx]
        letter = chr(entry & 0xFF)
        is_word = bool(entry & 0x100)
        is_last = bool(entry & 0x200)
        child = entry >> 10

        if letter == target:
            if len(remaining_word) == 1:
                # Last letter - must have WORD flag
                return is_word
            else:
                # More letters to go - must have child
                if child > 0:
                    return walk_dawg(entries, child, remaining_word[1:])
                else:
                    return False

        if is_last:
            break
        idx += 1

    return False

def walk_dawg_scan(entries, start, end, word):
    """Scan a section looking for a word. Brute force approach."""
    if not word:
        return False

    # Look for the first letter anywhere in the section
    target = word[0].lower()

    for idx in range(start, end):
        entry = entries[idx]
        letter = chr(entry & 0xFF)

        if letter == target:
            child = entry >> 10

            if len(word) == 1:
                if entry & 0x100:
                    return True
            elif child > 0:
                if walk_dawg(entries, child, word[1:]):
                    return True

    return False

def validate_word_combined(entries, word):
    """Try both sections to validate a word."""
    # Try Section 1 (reversed)
    if validate_word_section1(entries, word):
        return "Section 1"

    # Try Section 2 (forward) - scan approach
    if walk_dawg_scan(entries, 56630, 122165, word):
        return "Section 2"

    return None

def main():
    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"

    print("Loading DAWG...")
    entries = load_dawg(dawg_path)
    print(f"Loaded {len(entries)} entries")

    # Test words
    test_words = [
        # 2-letter words
        'aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
        'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
        'by', 'da', 'de', 'do', 'ed', 'ef', 'eh', 'el', 'em', 'en',
        # 3-letter words
        'cat', 'act', 'bat', 'tab', 'the', 'and', 'for', 'are', 'but',
        'not', 'you', 'all', 'can', 'her', 'was', 'one', 'our', 'out',
        # Invalid words
        'xyz', 'qqq', 'asdf', 'zzzz',
        # Longer real words
        'queen', 'aardvark', 'testing', 'computer'
    ]

    print("\n=== Word Validation Results ===\n")

    valid_count = 0
    for word in test_words:
        result = validate_word_combined(entries, word)
        status = f"VALID ({result})" if result else "INVALID"
        print(f"  {word:12s}: {status}")
        if result:
            valid_count += 1

    print(f"\n{valid_count}/{len(test_words)} words validated")

    # If validation works, try validating a reference word list
    print("\n=== Validating Reference Word List ===")

    try:
        # Try TWL98 if available
        with open('lexica/TWL98.txt', 'r') as f:
            reference_words = [line.strip().lower() for line in f if line.strip()]

        print(f"Loaded {len(reference_words)} reference words")

        valid_words = []
        for word in reference_words:
            if validate_word_combined(entries, word):
                valid_words.append(word)

        print(f"Validated {len(valid_words)}/{len(reference_words)} words")

        # Save validated words
        with open('lexica/dawg_validated.txt', 'w') as f:
            for w in sorted(valid_words):
                f.write(w + '\n')
        print(f"Saved to lexica/dawg_validated.txt")

    except FileNotFoundError:
        print("No reference word list found")

if __name__ == "__main__":
    main()
