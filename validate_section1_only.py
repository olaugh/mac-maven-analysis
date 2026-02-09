#!/usr/bin/env python3
"""
Test validation using ONLY Section 1 (reversed words) with correct algorithm.
"""

import struct

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

class Section1Validator:
    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        self.section1_end = struct.unpack('>I', self.data[0:4])[0]

        # Parse letter index
        self.letter_index = {}
        for i in range(26):
            offset = 0x10 + i * 4
            b0, b1 = self.data[offset], self.data[offset+1]
            self.letter_index[chr(ord('a') + i)] = (b0 << 8) | b1

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
        """Validate word using ONLY Section 1 (reversed)."""
        if len(word) < 2:
            return False
        word = word.lower()
        rev = word[::-1]
        first = rev[0]

        if first not in self.letter_index:
            return False

        # Get ROOT siblings for this letter
        root_entry = self.letter_index[first]
        root_siblings = self._get_siblings(root_entry)

        # Match remaining letters
        return self._match(root_siblings, rev[1:])

    def _match(self, siblings, remaining):
        if not remaining:
            # This shouldn't happen - we always have at least 1 remaining letter
            return True

        target = remaining[0]
        rest = remaining[1:]

        for node in siblings:
            if node['letter'] == target:
                if not rest:
                    # This is the final letter - check is_word
                    return node['is_word']
                else:
                    # More letters - follow child
                    if node['child'] and node['child'] < self.section1_end:
                        child_siblings = self._get_siblings(node['child'])
                        if self._match(child_siblings, rest):
                            return True
        return False


def main():
    validator = Section1Validator("/Volumes/T7/retrogames/oldmac/share/maven2")
    print(f"Section 1 ends at entry {validator.section1_end}")

    print("\n" + "="*60)
    print("Testing Section 1 ONLY (correct algorithm)")
    print("="*60)

    # Standard 2-letter word list (OSW)
    real_2letter = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
                    'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
                    'by', 'da', 'de', 'di', 'do', 'ea', 'ed', 'ee', 'ef', 'eh',
                    'el', 'em', 'en', 'er', 'es', 'et', 'ex', 'fa', 'fy', 'gi',
                    'go', 'gu', 'ha', 'he', 'hi', 'hm', 'ho', 'id', 'if', 'in',
                    'io', 'is', 'it', 'ja', 'jo', 'ka', 'ki', 'ko', 'ky', 'la',
                    'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu', 'my', 'na',
                    'ne', 'no', 'nu', 'ny', 'ob', 'od', 'oe', 'of', 'oh', 'oi',
                    'om', 'on', 'oo', 'op', 'or', 'os', 'ou', 'ow', 'ox', 'oy',
                    'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh', 'si', 'so', 'st',
                    'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um', 'un', 'up', 'ur',
                    'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye', 'yo', 'za',
                    'zo']

    print("\nTesting known 2-letter words:")
    valid_count = 0
    invalid = []
    for w in real_2letter:
        if validator.validate(w):
            valid_count += 1
        else:
            invalid.append(w)

    print(f"  Valid: {valid_count}/{len(real_2letter)}")
    if invalid:
        print(f"  NOT found (false negatives): {invalid}")

    # Test fake words
    fake_2letter = ['ac', 'af', 'aj', 'ak', 'ao', 'ap', 'aq', 'au', 'av', 'az',
                    'bb', 'bc', 'bd', 'bf', 'bg', 'bh', 'bj', 'bk', 'bl', 'bm',
                    'bn', 'bp', 'bq', 'br', 'bs', 'bt', 'bu', 'bv', 'bw', 'bx',
                    'cc', 'dd', 'ff', 'gg', 'hh', 'ii', 'jj', 'kk', 'll', 'nn',
                    'pp', 'qq', 'rr', 'ss', 'tt', 'uu', 'vv', 'ww', 'xx', 'yy', 'zz']

    print("\nTesting known FAKE 2-letter words:")
    false_positives = []
    for w in fake_2letter:
        if validator.validate(w):
            false_positives.append(w)

    print(f"  False positives: {len(false_positives)}/{len(fake_2letter)}")
    if false_positives:
        print(f"  Incorrectly validated: {false_positives}")
    else:
        print("  SUCCESS: No false positives!")

    # Brute force all 2-letter combinations
    print("\n" + "="*60)
    print("Brute-force 2-letter validation (Section 1 only)")
    print("="*60)

    all_2letter = []
    for c1 in 'abcdefghijklmnopqrstuvwxyz':
        for c2 in 'abcdefghijklmnopqrstuvwxyz':
            word = c1 + c2
            if validator.validate(word):
                all_2letter.append(word)

    print(f"Found {len(all_2letter)} valid 2-letter words")

    # Check against reference
    real_set = set(real_2letter)
    found_set = set(all_2letter)

    extra = found_set - real_set
    missing = real_set - found_set

    print(f"\nComparison to reference list:")
    print(f"  Extra (false positives): {len(extra)}")
    if extra:
        print(f"    {sorted(extra)}")
    print(f"  Missing (false negatives): {len(missing)}")
    if missing:
        print(f"    {sorted(missing)}")


if __name__ == "__main__":
    main()
