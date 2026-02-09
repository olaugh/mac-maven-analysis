#!/usr/bin/env python3
"""
Validate using the RUNTIME format interpretation of DAWG entries.

Runtime format (from CODE 15 decompilation):
- Bits 0-7: letter
- Bit 8: is_word (checked with ANDI #$100)
- Bit 9: is_last (checked with BTST #9)
- Bits 10+: child index (entry >> 10)
"""

import struct

NODE_START = 0x410

class RuntimeDAWGValidator:
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

    def _get_entry_32(self, entry_idx):
        """Read entry as 32-bit big-endian value."""
        offset = NODE_START + entry_idx * 4
        if offset + 4 > len(self.data):
            return None
        return struct.unpack('>I', self.data[offset:offset+4])[0]

    def _parse_runtime(self, entry_32):
        """Parse using runtime format."""
        if entry_32 is None:
            return None
        letter = entry_32 & 0xFF
        if not (97 <= letter <= 122):
            return None
        return {
            'letter': chr(letter),
            'is_word': (entry_32 >> 8) & 1,  # Bit 8
            'is_last': (entry_32 >> 9) & 1,  # Bit 9
            'child': entry_32 >> 10,         # Bits 10+
        }

    def _get_siblings_runtime(self, start):
        """Get siblings using runtime format."""
        siblings = []
        entry_idx = start
        while entry_idx < self.section1_end:
            entry_32 = self._get_entry_32(entry_idx)
            node = self._parse_runtime(entry_32)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry_idx += 1
        return siblings

    def validate_section1(self, word):
        """Validate using Section 1 (reversed) with runtime format."""
        if len(word) < 2:
            return False
        word = word.lower()
        rev = word[::-1]
        first = rev[0]

        if first not in self.letter_index:
            return False

        root_entry = self.letter_index[first]
        root_siblings = self._get_siblings_runtime(root_entry)

        return self._match_runtime(root_siblings, rev[1:])

    def _match_runtime(self, siblings, remaining):
        if not remaining:
            return True

        target = remaining[0]
        rest = remaining[1:]

        for node in siblings:
            if node['letter'] == target:
                if not rest:
                    return node['is_word'] == 1
                else:
                    child = node['child']
                    if child and child < self.section1_end:
                        child_siblings = self._get_siblings_runtime(child)
                        if self._match_runtime(child_siblings, rest):
                            return True
        return False


def main():
    validator = RuntimeDAWGValidator("/Volumes/T7/retrogames/oldmac/share/maven2")
    print(f"DAWG: section1={validator.section1_end}, section2={validator.section2_end}")

    # First check some specific entries
    print("\n" + "="*60)
    print("Checking key entries with runtime format")
    print("="*60)

    for entry_idx in [106, 472, 484]:
        entry_32 = validator._get_entry_32(entry_idx)
        node = validator._parse_runtime(entry_32)
        print(f"\nEntry {entry_idx}: 0x{entry_32:08x}")
        if node:
            print(f"  letter='{node['letter']}', is_word={node['is_word']}, is_last={node['is_last']}, child={node['child']}")

    # Test validation
    print("\n" + "="*60)
    print("Testing 2-letter words with runtime format")
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

    print("\nTesting REAL 2-letter words:")
    valid_count = 0
    invalid = []
    for w in real_2letter:
        if validator.validate_section1(w):
            valid_count += 1
        else:
            invalid.append(w)
    print(f"  Valid: {valid_count}/{len(real_2letter)}")
    if invalid:
        print(f"  Missing: {invalid[:20]}...")

    print("\nTesting FAKE 2-letter words:")
    false_positives = []
    for w in fake_2letter:
        if validator.validate_section1(w):
            false_positives.append(w)
    print(f"  False positives: {len(false_positives)}/{len(fake_2letter)}")
    if false_positives:
        print(f"  Incorrectly validated: {false_positives}")

    # Brute force
    print("\n" + "="*60)
    print("Brute-force all 2-letter combos with runtime format")
    print("="*60)

    all_2letter = []
    for c1 in 'abcdefghijklmnopqrstuvwxyz':
        for c2 in 'abcdefghijklmnopqrstuvwxyz':
            if validator.validate_section1(c1 + c2):
                all_2letter.append(c1 + c2)

    print(f"Found {len(all_2letter)} valid 2-letter words")
    print(f"Words: {all_2letter}")


if __name__ == "__main__":
    main()
