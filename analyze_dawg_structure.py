#!/usr/bin/env python3
"""
Deep analysis of Maven DAWG structure to understand how words are stored.
Focus on understanding why enumeration produces gibberish.
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

def decode(entry):
    letter = chr(entry & 0xFF) if 0x61 <= (entry & 0xFF) <= 0x7a else None
    is_word = bool(entry & 0x100)
    is_last = bool(entry & 0x200)
    child = entry >> 10
    return letter, is_word, is_last, child

def trace_word(entries, word, start_range):
    """Trace how a known word would be found in the DAWG."""
    print(f"\nTracing '{word}' starting from entry range {start_range}:")

    idx = start_range[0]
    path = []

    for i, target_char in enumerate(word):
        print(f"  Looking for '{target_char}' at position {i}")

        found = False
        search_idx = idx
        siblings_checked = 0

        while search_idx < len(entries):
            entry = entries[search_idx]
            letter, is_word, is_last, child = decode(entry)

            if letter == target_char:
                print(f"    Found '{letter}' at entry {search_idx}, child={child}, is_word={is_word}, is_last={is_last}")
                path.append((search_idx, letter, child))
                found = True

                if i == len(word) - 1:
                    # Last letter
                    if is_word:
                        print(f"  SUCCESS: Word ends with WORD flag!")
                        return True, path
                    else:
                        print(f"  FAIL: Last letter found but no WORD flag")
                        return False, path
                else:
                    # More letters to go
                    if child > 0:
                        idx = child
                        break
                    else:
                        print(f"  FAIL: No child to continue")
                        return False, path

            siblings_checked += 1
            if is_last:
                break
            search_idx += 1

        if not found:
            print(f"    NOT FOUND after checking {siblings_checked} siblings")
            return False, path

    return False, path

def analyze_root_structure(entries, start, count):
    """Analyze the root entry structure."""
    print(f"\n=== Root Structure Analysis (entries {start}-{start+count}) ===")

    roots = {}
    idx = start
    while idx < start + count and idx < len(entries):
        entry = entries[idx]
        letter, is_word, is_last, child = decode(entry)

        if letter:
            roots[letter] = {
                'entry': idx,
                'child': child,
                'is_word': is_word,
                'is_last': is_last
            }
            print(f"  Root '{letter}' at {idx}: child={child}, is_word={is_word}")

        if is_last:
            break
        idx += 1

    return roots

def follow_child_chain(entries, start, depth=5, prefix=""):
    """Follow a child chain and see what words we get."""
    if depth <= 0 or start <= 0 or start >= len(entries):
        return []

    words = []
    idx = start

    while idx < len(entries):
        entry = entries[idx]
        letter, is_word, is_last, child = decode(entry)

        if letter:
            current = prefix + letter
            if is_word:
                words.append(current)

            if child > 0:
                words.extend(follow_child_chain(entries, child, depth-1, current))

        if is_last:
            break
        idx += 1

    return words

def compare_sections(entries):
    """Compare Section 1 and Section 2 structures."""
    print("\n=== Section Comparison ===")

    # Section 1: 0-56629 (reversed)
    # Section 2: 56630-122165 (forward)

    print("\nSection 1 root (reversed dictionary):")
    s1_roots = analyze_root_structure(entries, 4, 26)  # a-z roots

    print("\nSection 2 structure:")
    # Section 2 seems to start differently
    for i in range(56630, 56660):
        entry = entries[i]
        letter, is_word, is_last, child = decode(entry)
        raw = entry
        print(f"  {i}: letter={letter or '?':1s} child={child:6d} is_word={is_word} is_last={is_last}  raw=0x{raw:08x}")

def test_validation_approach(entries):
    """Test the validation approach - does the DAWG validate known words?"""
    print("\n=== Testing Validation ===")

    test_words = ['aa', 'ab', 'ad', 'ae', 'cat', 'act', 'bat', 'the', 'be']

    # Try Section 1 (reversed) - need to reverse the word
    print("\nSection 1 (reversed words - search for reversed input):")
    for word in test_words:
        reversed_word = word[::-1]
        found, path = trace_word(entries, reversed_word, (4, 30))
        print(f"  {word} (as '{reversed_word}'): {'FOUND' if found else 'NOT FOUND'}")

    # Try Section 2 (forward)
    print("\nSection 2 (forward - where do words start?):")
    # Section 2 doesn't have obvious a-z roots at the start
    # Let's see what entries look like

def find_word_starts(entries, section_start, section_end):
    """Try to find where words actually start in a section."""
    print(f"\n=== Finding word starting points in {section_start}-{section_end} ===")

    # Look for entries that could be word starts (single letters with WORD flag)
    potential_starts = []

    for i in range(section_start, min(section_start + 1000, section_end)):
        entry = entries[i]
        letter, is_word, is_last, child = decode(entry)

        # A word start might be a single letter marked as WORD
        if letter and is_word:
            potential_starts.append((i, letter, child))

    print(f"Found {len(potential_starts)} entries with WORD flag")
    for idx, letter, child in potential_starts[:20]:
        print(f"  Entry {idx}: '{letter}' -> {child}")

    return potential_starts

def main():
    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"

    print("Loading DAWG...")
    entries = load_dawg(dawg_path)
    print(f"Loaded {len(entries)} entries")

    # Analyze structure
    compare_sections(entries)

    # Test validation
    test_validation_approach(entries)

    # Find word starts in Section 2
    find_word_starts(entries, 56630, 122165)

    # Try to enumerate from Section 1 roots with validation
    print("\n=== Enumerating from 'a' root (Section 1) ===")
    # Entry 4 is 'a' root with child 10834
    words_from_a = follow_child_chain(entries, 10834, depth=6, prefix='a')
    print(f"Words starting with 'a' (first 30): {words_from_a[:30]}")

    # Check if any of these are real
    real_words = ['aa', 'aah', 'aal', 'aas', 'ab', 'aba', 'abas', 'abb']
    print(f"\nChecking for real words in enumeration:")
    for rw in real_words:
        if rw in words_from_a:
            print(f"  {rw}: FOUND in enumeration")
        else:
            print(f"  {rw}: NOT in enumeration")

if __name__ == "__main__":
    main()
