#!/usr/bin/env python3
"""
CORRECT word validation - only follows child pointers, never searches across sibling groups.
"""

import struct

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

class DAWGValidator:
    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        self.section1_end = struct.unpack('>I', self.data[0:4])[0]
        self.section2_end = struct.unpack('>I', self.data[4:8])[0]

        # Parse letter index
        self.letter_index = {}
        for i in range(26):
            offset = 0x10 + i * 4
            b0, b1 = self.data[offset], self.data[offset+1]
            self.letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

        # Build Section 2 index
        self.section2_roots = {chr(ord('a') + i): [] for i in range(26)}
        for idx in range(self.section1_end, self.section2_end):
            node = self._get_node(idx)
            if node and 'a' <= node['letter'] <= 'z':
                self.section2_roots[node['letter']].append(idx)

    def _get_node(self, entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None
        b0, b1, flags, letter = self.data[offset:offset+4]
        if not (97 <= letter <= 122):
            return None
        ptr = (b0 << 8) | b1
        return {
            'letter': chr(letter),
            'is_word': (flags & FLAG_WORD) != 0,
            'is_last': (flags & FLAG_LAST) != 0,
            'child': ptr + (flags & 0x7e) if ptr > 0 else 0,
        }

    def _get_siblings(self, start):
        """Get siblings starting at start, stopping at is_last=True."""
        siblings = []
        entry = start
        while entry < self.section1_end:
            node = self._get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    def validate(self, word):
        """Validate a word using both sections."""
        if len(word) < 2:
            return False
        word = word.lower()
        return self._check_section1(word) or self._check_section2(word)

    def _check_section1(self, word):
        """Check Section 1 (reversed words) - CORRECT algorithm."""
        rev = word[::-1]
        first = rev[0]

        if first not in self.letter_index:
            return False

        # Start at the ROOT of this letter's subtree
        root_entry = self.letter_index[first]
        root_siblings = self._get_siblings(root_entry)

        # Search ONLY in root siblings for the second letter
        return self._search_children(root_siblings, rev[1:])

    def _search_children(self, siblings, remaining):
        """Search for remaining letters by following child pointers ONLY."""
        if not remaining:
            # All letters matched - shouldn't happen at this level
            return True

        target = remaining[0]
        rest = remaining[1:]

        for node in siblings:
            if node['letter'] == target:
                if not rest:
                    # This is the last letter - check is_word
                    return node['is_word']
                else:
                    # More letters to match - follow child pointer
                    if node['child'] and node['child'] < self.section1_end:
                        child_siblings = self._get_siblings(node['child'])
                        if self._search_children(child_siblings, rest):
                            return True
        return False

    def _check_section2(self, word):
        """Check Section 2 (forward words) - CORRECT algorithm."""
        first = word[0]

        for entry_idx in self.section2_roots.get(first, []):
            node = self._get_node(entry_idx)
            if node and self._match_forward_correct(node, word[1:]):
                return True
        return False

    def _match_forward_correct(self, node, remaining):
        """Match remaining letters by following child pointers ONLY."""
        if not remaining:
            return node['is_word']

        child = node['child']
        if not child or child >= self.section1_end:
            return False

        target = remaining[0]
        rest = remaining[1:]

        child_siblings = self._get_siblings(child)
        for sib in child_siblings:
            if sib['letter'] == target:
                if not rest:
                    return sib['is_word']
                else:
                    return self._match_forward_correct(sib, rest)

        return False


def main():
    validator = DAWGValidator("/Volumes/T7/retrogames/oldmac/share/maven2")
    print(f"DAWG loaded: section1={validator.section1_end}, section2={validator.section2_end}")

    print("\n" + "="*60)
    print("Testing with CORRECT validation algorithm")
    print("="*60)

    # Real 2-letter words
    real_words = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
                  'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
                  'by', 'da', 'de', 'di', 'do', 'ed', 'ef', 'eh', 'el', 'em',
                  'en', 'er', 'es', 'et', 'ex', 'fa', 'go', 'gu', 'ha', 'he',
                  'hi', 'hm', 'ho', 'id', 'if', 'in', 'is', 'it', 'jo', 'ka',
                  'ki', 'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu',
                  'my', 'na', 'ne', 'no', 'nu', 'od', 'oe', 'of', 'oh', 'oi',
                  'om', 'on', 'oo', 'op', 'or', 'os', 'ou', 'ow', 'ox', 'oy',
                  'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh', 'si', 'so', 'st',
                  'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um', 'un', 'up', 'ur',
                  'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye', 'yo', 'za']

    # Fake 2-letter words
    fake_words = ['ac', 'af', 'ak', 'ap', 'aq', 'av', 'bb', 'cc', 'dd', 'ff',
                  'gg', 'hh', 'ii', 'jj', 'kk', 'll', 'nn', 'pp', 'qq', 'rr',
                  'ss', 'tt', 'uu', 'vv', 'ww', 'xx', 'yy', 'zz', 'bx', 'qz']

    print("\nTesting REAL 2-letter words:")
    valid_count = 0
    invalid_real = []
    for w in real_words:
        result = validator.validate(w)
        if result:
            valid_count += 1
        else:
            invalid_real.append(w)
    print(f"  {valid_count}/{len(real_words)} validated")
    if invalid_real:
        print(f"  Not found: {invalid_real}")

    print("\nTesting FAKE 2-letter words (should ALL be INVALID):")
    false_positives = []
    for w in fake_words:
        result = validator.validate(w)
        if result:
            false_positives.append(w)
            print(f"  {w}: FALSE POSITIVE!")
        else:
            print(f"  {w}: correctly INVALID")

    print(f"\nSummary:")
    print(f"  Real words validated: {valid_count}/{len(real_words)}")
    print(f"  False positives: {len(false_positives)}/{len(fake_words)}")

    if false_positives:
        print(f"\nFalse positives found: {false_positives}")
        print("(Algorithm still has bugs)")
    else:
        print("\nNo false positives! Algorithm appears correct.")

    # Now test brute force on 2-letter words
    print("\n" + "="*60)
    print("Brute-force 2-letter validation")
    print("="*60)
    all_2letter = []
    for c1 in 'abcdefghijklmnopqrstuvwxyz':
        for c2 in 'abcdefghijklmnopqrstuvwxyz':
            word = c1 + c2
            if validator.validate(word):
                all_2letter.append(word)

    print(f"Found {len(all_2letter)} valid 2-letter words")
    print(f"Expected: ~100-120 for a standard Scrabble dictionary")
    print(f"\nAll 2-letter words found:")
    for i in range(0, len(all_2letter), 20):
        print(f"  {' '.join(all_2letter[i:i+20])}")


if __name__ == "__main__":
    main()
