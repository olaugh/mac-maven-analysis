#!/usr/bin/env python3
"""
Dump Maven DAWG words using the confirmed entry format from QEMU tracing.

Entry format (4 bytes, big-endian):
- Bits 0-7:   Letter (ASCII)
- Bit 8:      End-of-word flag (0x100)
- Bit 9:      Last-sibling flag (0x200)
- Bits 10-31: Child index (>> 10)
"""

import struct
import sys

def load_dawg(filepath):
    """Load DAWG file and parse into entries."""
    with open(filepath, 'rb') as f:
        data = f.read()

    # Parse as big-endian 32-bit entries
    num_entries = len(data) // 4
    entries = []
    for i in range(num_entries):
        entry = struct.unpack('>I', data[i*4:(i+1)*4])[0]
        entries.append(entry)

    return entries

def decode_entry(entry):
    """Decode a DAWG entry into its components."""
    letter = chr(entry & 0xFF) if (entry & 0xFF) >= 0x20 else '?'
    is_word = bool(entry & 0x100)      # Bit 8
    is_last = bool(entry & 0x200)      # Bit 9
    child = entry >> 10                 # Bits 10+
    return letter, is_word, is_last, child

def enumerate_from_node(entries, node_idx, prefix, words, max_depth=20):
    """Recursively enumerate words starting from a node."""
    if max_depth <= 0:
        return

    if node_idx <= 0 or node_idx >= len(entries):
        return

    # Walk all siblings at this level
    idx = node_idx
    while idx < len(entries):
        entry = entries[idx]
        letter, is_word, is_last, child = decode_entry(entry)

        # Skip non-letter entries
        if not letter.isalpha():
            if is_last:
                break
            idx += 1
            continue

        current_word = prefix + letter

        # If this is a valid word ending, record it
        if is_word:
            words.append(current_word)

        # Recurse to children if they exist
        if child > 0:
            enumerate_from_node(entries, child, current_word, words, max_depth - 1)

        # Stop if this is the last sibling
        if is_last:
            break

        idx += 1

def find_section_roots(entries):
    """Try to identify section root entries."""
    print("Analyzing DAWG structure...")
    print(f"Total entries: {len(entries)}")

    # Section boundaries from previous analysis
    section1_end = 56629
    section2_start = 56630
    section2_end = 122165
    section3_start = 122166

    print(f"\nSection 1: entries 0-{section1_end} (reversed words)")
    print(f"Section 2: entries {section2_start}-{section2_end} (forward dictionary)")
    print(f"Section 3: entries {section3_start}+ (additional)")

    return section2_start, section2_end

def dump_section2_words(entries, start, end):
    """Dump all words from Section 2 (forward dictionary)."""
    print(f"\nEnumerating words from Section 2 ({start}-{end})...")

    words = []

    # Find root entries (entries that are starting points for words)
    # These should be at the beginning of the section
    for root_idx in range(start, min(start + 100, end)):
        entry = entries[root_idx]
        letter, is_word, is_last, child = decode_entry(entry)

        if letter.isalpha():
            # This could be a root letter
            if is_word:
                words.append(letter)

            if child > 0:
                enumerate_from_node(entries, child, letter, words)

    return words

def dump_all_words_simple(entries):
    """Simple approach: try to walk from every potential root."""
    print("\nTrying simple enumeration from low-numbered entries...")

    words = set()

    # Try first 1000 entries as potential roots
    for root_idx in range(1, min(1000, len(entries))):
        entry = entries[root_idx]
        letter, is_word, is_last, child = decode_entry(entry)

        if letter.isalpha() and letter.islower():
            if is_word:
                words.add(letter)

            if child > 0:
                word_list = []
                enumerate_from_node(entries, child, letter, word_list, max_depth=15)
                words.update(word_list)

    return sorted(words)

def analyze_entry_patterns(entries, start, count=50):
    """Analyze entry patterns in a range."""
    print(f"\nEntry analysis from {start}:")
    print("-" * 70)

    for i in range(start, min(start + count, len(entries))):
        entry = entries[i]
        letter, is_word, is_last, child = decode_entry(entry)

        flags = []
        if is_word:
            flags.append("WORD")
        if is_last:
            flags.append("LAST")

        flag_str = ",".join(flags) if flags else "-"

        print(f"{i:6d}: {letter} -> {child:6d}  [{flag_str:10s}]  raw=0x{entry:08x}")

def test_known_words(entries):
    """Test if known words can be found by walking the structure."""
    print("\nTesting known word validation...")

    test_words = ["a", "aa", "ab", "cat", "act", "at", "ta", "the", "be"]

    for word in test_words:
        # Try to find this word by walking from various roots
        found = False

        # Try walking from Section 2
        for root_idx in range(56630, 56700):
            entry = entries[root_idx]
            letter, is_word, is_last, child = decode_entry(entry)

            if letter == word[0]:
                # Found starting letter, try to walk the rest
                if len(word) == 1:
                    if is_word:
                        found = True
                        break
                else:
                    # Walk children
                    result = walk_word(entries, child, word[1:])
                    if result:
                        found = True
                        break

        status = "FOUND" if found else "NOT FOUND"
        print(f"  {word}: {status}")

def walk_word(entries, node_idx, remaining):
    """Try to walk a word through the DAWG."""
    if not remaining:
        return True  # Found all letters

    if node_idx <= 0 or node_idx >= len(entries):
        return False

    target = remaining[0]
    idx = node_idx

    while idx < len(entries):
        entry = entries[idx]
        letter, is_word, is_last, child = decode_entry(entry)

        if letter == target:
            if len(remaining) == 1:
                return is_word  # Last letter - must be word ending
            else:
                return walk_word(entries, child, remaining[1:])

        if is_last:
            break
        idx += 1

    return False

def main():
    dawg_path = "/Volumes/T7/retrogames/oldmac/share/maven2"

    print("Loading DAWG...")
    entries = load_dawg(dawg_path)
    print(f"Loaded {len(entries)} entries")

    # Analyze structure
    section2_start, section2_end = find_section_roots(entries)

    # Show some entry patterns
    print("\n=== Section 1 (reversed) sample ===")
    analyze_entry_patterns(entries, 0, 30)

    print("\n=== Section 2 (forward) sample ===")
    analyze_entry_patterns(entries, section2_start, 30)

    # Test known words
    test_known_words(entries)

    # Try to enumerate
    print("\n=== Attempting enumeration ===")
    words = dump_all_words_simple(entries)

    print(f"\nFound {len(words)} potential words")

    # Show sample
    if words:
        print("\nFirst 50 words:")
        for w in words[:50]:
            print(f"  {w}")

        print("\nWords 2-4 letters:")
        short_words = [w for w in words if 2 <= len(w) <= 4]
        for w in sorted(short_words)[:100]:
            print(f"  {w}")

    # Save results
    output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/dawg_dump.txt"
    with open(output_path, 'w') as f:
        for w in words:
            f.write(w + '\n')
    print(f"\nSaved {len(words)} words to {output_path}")

if __name__ == "__main__":
    main()
