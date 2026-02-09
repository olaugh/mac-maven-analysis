#!/usr/bin/env python3
"""
DAWG validator using CORRECT runtime format from QEMU-verified disassembly.

DAWG base = file + 12  (from CODE 2: LEA 12(A4),A0)
Entry format (32-bit big-endian):
  Bits 0-7:   Letter (ASCII lowercase)
  Bit 8:      End-of-word flag  (ANDI.L #$100)
  Bit 9:      Last-sibling flag (BTST #9)
  Bits 10-31: Child node index  (LSR.L #10)

File header:
  Offset 0: Section 1 boundary (56,630)
  Offset 4: field2 (122,166) -> A5-8588
  Offset 8: field3 (145,476) -> A5-8592
"""

import struct

FILEPATH = "/Volumes/T7/retrogames/oldmac/share/maven2"

class DAWGRuntime:
    def __init__(self, filepath):
        with open(filepath, 'rb') as f:
            self.data = f.read()

        self.s1_boundary = struct.unpack('>I', self.data[0:4])[0]
        self.field2 = struct.unpack('>I', self.data[4:8])[0]
        self.field3 = struct.unpack('>I', self.data[8:12])[0]
        self.field4 = struct.unpack('>I', self.data[12:16])[0]

        self.base = 12  # DAWG base at file offset 12

        print(f"Header: s1_boundary={self.s1_boundary}, field2={self.field2}, "
              f"field3={self.field3}")
        print(f"Entry 0 (sentinel): val=0x{self.field4:08X} = {self.field4}")

    def get_entry(self, index):
        offset = self.base + index * 4
        if offset + 4 > len(self.data):
            return None
        val = struct.unpack('>I', self.data[offset:offset+4])[0]
        letter_byte = val & 0xFF
        return {
            'val': val,
            'letter': chr(letter_byte) if 97 <= letter_byte <= 122 else f'0x{letter_byte:02x}',
            'letter_byte': letter_byte,
            'eow': (val >> 8) & 1,
            'last': (val >> 9) & 1,
            'child': val >> 10,
        }

    def get_siblings(self, start_index, boundary):
        siblings = []
        idx = start_index
        while idx < boundary:
            entry = self.get_entry(idx)
            if entry is None:
                break
            siblings.append((idx, entry))
            if entry['last']:
                break
            idx += 1
            if len(siblings) > 100:  # safety
                print(f"  WARNING: >100 siblings starting at {start_index}")
                break
        return siblings

    def show_letter_index(self):
        print("\nLetter Index (entries 1-26):")
        for i in range(26):
            letter = chr(ord('a') + i)
            entry = self.get_entry(1 + i)
            # Also show raw bytes
            off = self.base + (1 + i) * 4
            b0, b1, b2, b3 = self.data[off:off+4]
            print(f"  {letter}: [{b0:02x} {b1:02x} {b2:02x} {b3:02x}] "
                  f"val=0x{entry['val']:08X} "
                  f"letter='{entry['letter']}' eow={entry['eow']} last={entry['last']} "
                  f"child={entry['child']}")

    def show_first_group(self, letter):
        i = ord(letter) - ord('a')
        li_entry = self.get_entry(1 + i)
        child = li_entry['child']
        # CODE 15 walk_to_child has NO boundary check - use total entry count
        max_entry = len(self.data) // 4
        print(f"\nFirst sibling group for '{letter}' subtree (starting at entry {child}):")
        siblings = self.get_siblings(child, max_entry)
        for idx, entry in siblings:
            print(f"  [{idx:6d}] '{entry['letter']}' eow={entry['eow']} last={entry['last']} "
                  f"child={entry['child']:6d}  val=0x{entry['val']:08X}")
        return siblings

    def validate_s1(self, word):
        word = word.lower()
        if len(word) < 2:
            return False
        # CODE 15 walk_to_child: no boundary check, just follows child pointers
        max_entry = len(self.data) // 4

        rev = word[::-1]
        first = rev[0]
        i = ord(first) - ord('a')
        if i < 0 or i > 25:
            return False

        li_entry = self.get_entry(1 + i)
        child = li_entry['child']
        if child == 0:
            return False

        siblings = self.get_siblings(child, max_entry)
        return self._match_nb(siblings, rev[1:])

    def _match(self, siblings, remaining):
        if not remaining:
            return True

        target = remaining[0]
        rest = remaining[1:]

        for idx, entry in siblings:
            if entry['letter'] == target:
                if not rest:
                    return entry['eow'] == 1
                child = entry['child']
                if child == 0 or child >= self.s1_boundary:
                    return False
                child_siblings = self.get_siblings(child, self.s1_boundary)
                return self._match(child_siblings, rest)

        return False

    def _match_nb(self, siblings, remaining):
        """Match with no boundary check (like CODE 15 walk_to_child)."""
        if not remaining:
            return True
        max_entry = len(self.data) // 4

        target = remaining[0]
        rest = remaining[1:]

        for idx, entry in siblings:
            if entry['letter'] == target:
                if not rest:
                    return entry['eow'] == 1
                child = entry['child']
                if child == 0:
                    return False
                child_siblings = self.get_siblings(child, max_entry)
                return self._match_nb(child_siblings, rest)

        return False

    def trace_word(self, word):
        """Trace the full path through Section 1 for debugging."""
        word = word.lower()
        rev = word[::-1]
        first = rev[0]
        i = ord(first) - ord('a')
        li_entry = self.get_entry(1 + i)
        child = li_entry['child']
        max_entry = len(self.data) // 4

        print(f"\nTracing '{word}' (reversed: '{rev}'):")
        print(f"  Letter index '{first}': child={child}")

        siblings = self.get_siblings(child, max_entry)
        letters_in_group = [e['letter'] for _, e in siblings]
        print(f"  Group at {child}: [{', '.join(letters_in_group)}] ({len(siblings)} entries)")

        for pos, letter in enumerate(rev[1:], 1):
            found = False
            for idx, entry in siblings:
                if entry['letter'] == letter:
                    found = True
                    is_last_letter = (pos == len(rev) - 1)
                    if is_last_letter:
                        print(f"  '{letter}' at [{idx}]: eow={entry['eow']} "
                              f"-> {'VALID' if entry['eow'] else 'NOT a word'}")
                    else:
                        child = entry['child']
                        print(f"  '{letter}' at [{idx}]: child={child}", end="")
                        if child == 0 or child >= self.s1_boundary:
                            print(f" -> DEAD END (child out of range)")
                            return
                        siblings = self.get_siblings(child, max_entry)
                        letters_in_group = [e['letter'] for _, e in siblings]
                        print(f" -> group [{', '.join(letters_in_group)}]")
                    break
            if not found:
                print(f"  '{letter}' NOT FOUND in group")
                return


def main():
    dawg = DAWGRuntime(FILEPATH)
    dawg.show_letter_index()

    # Show first groups for a few letters
    for letter in ['a', 't', 'c', 'z']:
        dawg.show_first_group(letter)

    # Trace some words
    print("\n" + "="*60)
    print("Tracing specific words")
    print("="*60)
    for word in ['aa', 'cat', 'at', 'ta', 'no', 'on', 'ax', 'za', 'qi']:
        dawg.trace_word(word)

    # Test validation
    print("\n" + "="*60)
    print("Testing Section 1 validation")
    print("="*60)

    test_words = ['aa', 'ab', 'ad', 'at', 'ax', 'ba', 'be', 'bi', 'bo', 'by',
                  'cat', 'dog', 'the', 'is', 'it', 'no', 'on', 'to', 'ta',
                  'qi', 'xi', 'xu', 'za', 'ox', 'ax', 'ex']
    for word in test_words:
        result = dawg.validate_s1(word)
        print(f"  {word}: {'VALID' if result else 'not found'}")

    # Brute force 2-letter
    print("\n" + "="*60)
    print("Brute-force 2-letter words (Section 1)")
    print("="*60)

    real_2letter = set(['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
                    'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
                    'by', 'da', 'de', 'di', 'do', 'ed', 'ef', 'eh', 'el', 'em',
                    'en', 'er', 'es', 'et', 'ex', 'fa', 'go', 'gu', 'ha', 'he',
                    'hi', 'hm', 'ho', 'id', 'if', 'in', 'is', 'it', 'jo', 'ka',
                    'ki', 'la', 'li', 'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu',
                    'my', 'na', 'ne', 'no', 'nu', 'od', 'oe', 'of', 'oh', 'oi',
                    'om', 'on', 'oo', 'op', 'or', 'os', 'ou', 'ow', 'ox', 'oy',
                    'pa', 'pe', 'pi', 'po', 'qi', 're', 'sh', 'si', 'so', 'st',
                    'ta', 'te', 'ti', 'to', 'ug', 'uh', 'um', 'un', 'up', 'ur',
                    'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye', 'yo', 'za'])

    fake_2letter = set(['ac', 'af', 'ak', 'ap', 'aq', 'av', 'bb', 'cc', 'dd'])

    found = []
    for c1 in 'abcdefghijklmnopqrstuvwxyz':
        for c2 in 'abcdefghijklmnopqrstuvwxyz':
            word = c1 + c2
            if dawg.validate_s1(word):
                found.append(word)

    found_set = set(found)

    print(f"Total 2-letter words found: {len(found)}")
    print(f"Real words found: {len(found_set & real_2letter)}/{len(real_2letter)}")
    if real_2letter - found_set:
        print(f"Real words missed: {sorted(real_2letter - found_set)}")
    print(f"Fake words matched (false positives): {sorted(found_set & fake_2letter)}")
    extra = found_set - real_2letter
    print(f"Extra words (not in reference list): {len(extra)}")
    if extra and len(extra) <= 50:
        print(f"  {sorted(extra)}")
    elif extra:
        print(f"  First 50: {sorted(extra)[:50]}")


if __name__ == '__main__':
    main()
