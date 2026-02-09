#!/usr/bin/env python3
"""
Correct enumeration of Maven's DAWG based on the working validation logic.

Structure:
- Section 1 stores words REVERSED, indexed by LAST letter
- Letter index gives ranges for each letter
- Within each range, scan sibling groups for target letters
- WORD flag marks valid word endings

For enumeration:
- Start from each letter's range (this is the LAST letter of words)
- DFS through children, collecting letters
- When WORD flag found, reverse the collected path to get the word
"""

import struct
from collections import defaultdict

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]

    # Parse letter index
    LETTER_INDEX_OFFSET = 0x10
    letter_index = {}
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index[chr(ord('a') + i)] = entry

    letters = 'abcdefghijklmnopqrstuvwxyz'
    letter_ranges = {}
    for i, L in enumerate(letters):
        start = letter_index[L]
        end = letter_index[letters[i+1]] if i < 25 else section1_end
        letter_ranges[L] = (start, end)

    def get_node(entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(data):
            return None
        b0, b1, flags, letter = data[offset:offset+4]
        ptr = (b0 << 8) | b1
        if not (97 <= letter <= 122):
            return None
        return {
            'ptr': ptr,
            'flags': flags,
            'letter': chr(letter),
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'entry': entry_idx,
        }

    def get_child_entry(node):
        if node['ptr'] == 0:
            return None
        return node['ptr'] + (node['flags'] & 0x7e)

    def get_siblings(start_entry, limit=100):
        siblings = []
        entry = start_entry
        while entry < section1_end and len(siblings) < limit:
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    def enumerate_from_letter(last_letter, max_words=None):
        """
        Enumerate all words ending with the given letter.

        The letter range contains sibling groups. We scan each group,
        and for each node, check if it's a word end, then follow children.
        Words are stored reversed, so we collect letters and reverse.
        """
        words = set()
        range_start, range_end = letter_ranges[last_letter]
        visited = set()

        def dfs(entry_start, entry_end, suffix, depth):
            """
            DFS through sibling groups, building words in reverse.
            suffix = letters collected so far (will be reversed to get actual word)
            """
            if depth > 15:
                return
            if max_words and len(words) >= max_words:
                return

            entry = entry_start
            while entry < entry_end:
                if max_words and len(words) >= max_words:
                    return
                if entry in visited:
                    entry += 1
                    continue

                visited.add(entry)
                sibs = get_siblings(entry)
                if not sibs:
                    visited.discard(entry)
                    entry += 1
                    continue

                for node in sibs:
                    if max_words and len(words) >= max_words:
                        break

                    # Build reversed word by prepending this letter
                    # (since we're traversing the reversed storage)
                    reversed_word = node['letter'] + suffix

                    # If WORD flag, this reversed path is a valid word
                    if node['is_word'] and len(reversed_word) >= 2:
                        # Reverse to get actual word
                        actual_word = reversed_word[::-1]
                        words.add(actual_word)

                    # Follow children to find longer words
                    child = get_child_entry(node)
                    if child and child < section1_end:
                        dfs(child, section1_end, reversed_word, depth + 1)

                visited.discard(entry)
                entry += len(sibs)

        # Start: the letter range gives us words ending in last_letter
        # The suffix starts as just that letter
        dfs(range_start, range_end, last_letter, 1)

        return words

    # Test with a few letters first
    print("Testing enumeration from specific letter ranges:")
    print("=" * 60)

    for test_letter in ['a', 'e', 'k']:
        print(f"\nWords ending in '{test_letter}':")
        words = enumerate_from_letter(test_letter, max_words=500)
        print(f"  Found {len(words)} words")

        two_letter = sorted([w for w in words if len(w) == 2])
        print(f"  2-letter: {two_letter[:20]}")

        # Check for known words
        if test_letter == 'a':
            known = ['aa', 'ba', 'da', 'fa', 'ha', 'ka', 'la', 'ma', 'na', 'pa', 'ta', 'za']
            found = [w for w in known if w in words]
            print(f"  Known words found: {found}")
        elif test_letter == 'e':
            known = ['ae', 'be', 'he', 'me', 'ne', 'oe', 'pe', 're', 'we', 'ye', 'the']
            found = [w for w in known if w in words]
            print(f"  Known words found: {found}")
        elif test_letter == 'k':
            known = ['aardvark', 'ark', 'ask', 'ink', 'oak']
            found = [w for w in known if w in words]
            print(f"  Known words found: {found}")

        # Sample longer words
        longer = sorted([w for w in words if len(w) >= 5])[:10]
        print(f"  Sample 5+ letter: {longer}")

    # Full enumeration
    print("\n" + "=" * 60)
    print("Full enumeration from all letters:")
    print("=" * 60)

    all_words = set()
    for letter in letters:
        print(f"  Processing '{letter}'...", end=' ', flush=True)
        words = enumerate_from_letter(letter)
        print(f"{len(words)} words")
        all_words.update(words)

    print(f"\nTotal unique words: {len(all_words)}")

    # Statistics
    by_length = defaultdict(int)
    for w in all_words:
        by_length[len(w)] += 1

    print("\nWord length distribution:")
    for length in sorted(by_length.keys())[:15]:
        print(f"  {length:2d} letters: {by_length[length]:6d} words")

    # 2-letter words
    two_letter = sorted([w for w in all_words if len(w) == 2])
    print(f"\n2-letter words ({len(two_letter)}): {two_letter}")

    # Save to file
    output_path = "/Volumes/T7/retrogames/oldmac/maven_re/lexica/dawg_section1_enumerated.txt"
    with open(output_path, 'w') as f:
        for word in sorted(all_words):
            f.write(word + '\n')
    print(f"\nSaved to {output_path}")


if __name__ == "__main__":
    main()
