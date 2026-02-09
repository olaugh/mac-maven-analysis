#!/usr/bin/env python3
"""
Validate using CORRECTED bit positions:
- is_word = bit 0 of flags byte (not bit 7!)
- is_last = bit 1 of flags byte (not bit 0!)
- child offset = bits 2-6 or 2-7 of flags byte
"""

import struct

NODE_START = 0x410

class CorrectedDAWGValidator:
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

    def _get_node(self, entry_idx):
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None
        b0, b1, flags, letter = self.data[offset:offset+4]
        if not (97 <= letter <= 122):
            return None

        ptr = (b0 << 8) | b1

        # CORRECTED bit positions:
        is_word = (flags & 0x01) != 0   # Bit 0 = is_word
        is_last = (flags & 0x02) != 0   # Bit 1 = is_last
        # Child offset uses remaining bits (2-7)
        child_offset = (flags >> 2) & 0x3F  # 6 bits
        child = ptr + child_offset if ptr > 0 else 0

        return {
            'letter': chr(letter),
            'is_word': is_word,
            'is_last': is_last,
            'child': child,
            'flags': flags,
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

    def validate_section1(self, word):
        if len(word) < 2:
            return False
        word = word.lower()
        rev = word[::-1]
        first = rev[0]

        if first not in self.letter_index:
            return False

        root_entry = self.letter_index[first]
        root_siblings = self._get_siblings(root_entry)

        return self._match(root_siblings, rev[1:])

    def _match(self, siblings, remaining):
        if not remaining:
            return True

        target = remaining[0]
        rest = remaining[1:]

        for node in siblings:
            if node['letter'] == target:
                if not rest:
                    return node['is_word']
                else:
                    child = node['child']
                    if child and child < self.section1_end:
                        child_siblings = self._get_siblings(child)
                        if self._match(child_siblings, rest):
                            return True
        return False


def main():
    validator = CorrectedDAWGValidator("/Volumes/T7/retrogames/oldmac/share/maven2")
    print(f"DAWG: section1={validator.section1_end}, section2={validator.section2_end}")

    # Check specific entries
    print("\n" + "="*60)
    print("Checking key entries with CORRECTED bit positions")
    print("="*60)

    for entry_idx in [106, 472, 484]:
        node = validator._get_node(entry_idx)
        offset = NODE_START + entry_idx * 4
        b0, b1, flags, letter = validator.data[offset:offset+4]
        print(f"\nEntry {entry_idx}: bytes=[{b0:02x} {b1:02x} {flags:02x} {letter:02x}]")
        print(f"  flags binary: {flags:08b}")
        print(f"  is_word (bit 0): {node['is_word']}")
        print(f"  is_last (bit 1): {node['is_last']}")
        print(f"  child: {node['child']}")

    # Test validation
    print("\n" + "="*60)
    print("Testing 2-letter words")
    print("="*60)

    real_2letter = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
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

    fake_2letter = ['ac', 'af', 'ak', 'ap', 'aq', 'av', 'bb', 'cc', 'dd']

    print("\nTesting REAL 2-letter words (Section 1 only):")
    valid_count = 0
    invalid = []
    for w in real_2letter:
        if validator.validate_section1(w):
            valid_count += 1
        else:
            invalid.append(w)
    print(f"  Valid: {valid_count}/{len(real_2letter)}")
    if len(invalid) > 20:
        print(f"  Missing: {invalid[:20]}... and {len(invalid)-20} more")
    elif invalid:
        print(f"  Missing: {invalid}")

    print("\nTesting FAKE 2-letter words:")
    false_positives = []
    for w in fake_2letter:
        if validator.validate_section1(w):
            false_positives.append(w)
    print(f"  False positives: {len(false_positives)}/{len(fake_2letter)}")
    if false_positives:
        print(f"  Incorrectly validated: {false_positives}")
    else:
        print("  No false positives!")

    # Brute force
    print("\n" + "="*60)
    print("Brute-force all 2-letter combos")
    print("="*60)

    all_2letter = []
    for c1 in 'abcdefghijklmnopqrstuvwxyz':
        for c2 in 'abcdefghijklmnopqrstuvwxyz':
            if validator.validate_section1(c1 + c2):
                all_2letter.append(c1 + c2)

    print(f"Found {len(all_2letter)} valid 2-letter words")

    # Compare to known list
    real_set = set(real_2letter)
    found_set = set(all_2letter)

    print(f"\nMatching known words: {len(found_set & real_set)}/{len(real_2letter)}")
    print(f"Extra words found: {len(found_set - real_set)}")
    if found_set - real_set:
        print(f"  {sorted(found_set - real_set)}")


if __name__ == "__main__":
    main()
