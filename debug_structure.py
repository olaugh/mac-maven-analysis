#!/usr/bin/env python3
"""
Debug the DAWG structure - trace specific words.
"""

import struct

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]

    # Letter index
    letter_index = {}
    for i in range(26):
        offset = 0x10 + i * 4
        entry = struct.unpack('>H', data[offset:offset+2])[0]
        letter_index[chr(ord('a') + i)] = entry
        print(f"{chr(ord('a')+i)}: entry {entry}")

    def get_node_raw(entry_idx):
        offset = NODE_START + entry_idx * 4
        b0, b1, flags, letter_byte = data[offset:offset+4]
        base_ptr = (b0 << 8) | b1
        return {
            'raw': f'{b0:02x} {b1:02x} {flags:02x} {letter_byte:02x}',
            'letter': chr(letter_byte) if 97 <= letter_byte <= 122 else f'0x{letter_byte:02x}',
            'base_ptr': base_ptr,
            'flags': flags,
            'is_word': (flags & 0x80) != 0,
            'is_last': (flags & 0x01) != 0,
            'child_offset': (flags >> 1) & 0x3F,
            'child': base_ptr + ((flags >> 1) & 0x3F) if base_ptr > 0 else 0,
        }

    print("\n" + "="*60)
    print("Tracing 'AA' (reversed = 'AA')")
    print("="*60)

    # For 'AA': last letter is 'a', look up 'a' in index
    a_entry = letter_index['a']
    print(f"\nLetter index 'a' -> entry {a_entry}")

    # Show siblings starting at a_entry
    print(f"\nSiblings at entry {a_entry}:")
    for i in range(10):
        node = get_node_raw(a_entry + i)
        print(f"  Entry {a_entry + i}: [{node['raw']}] letter='{node['letter']}' "
              f"is_word={int(node['is_word'])} is_last={int(node['is_last'])} "
              f"base={node['base_ptr']} child={node['child']}")
        if node['is_last']:
            print("  (is_last set)")
            break

    # Look for 'a' in those siblings (second letter of 'AA' reversed)
    print(f"\nLooking for 'a' sibling at entry {a_entry}...")
    entry = a_entry
    for i in range(30):
        node = get_node_raw(entry + i)
        if node['letter'] == 'a':
            print(f"  Found 'a' at entry {entry + i}: is_word={node['is_word']}")
            if node['is_word']:
                print("  -> 'AA' is a valid word!")
            else:
                print("  -> 'AA' NOT marked as word")
            break
        if node['is_last']:
            print(f"  Reached is_last at entry {entry + i}, 'a' not found")
            break

    print("\n" + "="*60)
    print("Tracing 'ZA' (reversed = 'AZ')")
    print("="*60)

    # For 'ZA': last letter is 'a', need to find 'z' path
    print(f"\nLetter index 'a' -> entry {a_entry}")
    print("Looking for 'z' in root siblings...")

    entry = a_entry
    z_node = None
    for i in range(200):
        node = get_node_raw(entry + i)
        if node['letter'] == 'z':
            z_node = node
            print(f"  Found 'z' at entry {entry + i}: is_word={node['is_word']} child={node['child']}")
            break
        if node['is_last']:
            print(f"  Reached is_last at entry {entry + i}")
            break

    if z_node and z_node['is_word']:
        print("  -> 'ZA' is a valid word!")

    print("\n" + "="*60)
    print("What does is_word actually mean?")
    print("="*60)

    # Count is_word=True in first 100 entries
    word_count = 0
    for i in range(100):
        node = get_node_raw(i)
        if node['is_word']:
            word_count += 1
            print(f"  Entry {i}: letter='{node['letter']}' is_word=True")

    print(f"\nEntries with is_word=True in first 100: {word_count}")

    # Check specific known 2-letter words
    print("\n" + "="*60)
    print("Checking specific 2-letter words")
    print("="*60)

    for word in ['aa', 'ab', 'ba', 'za', 'ax', 'ox']:
        rev = word[::-1]
        last = word[-1]
        root = letter_index[last]
        print(f"\n'{word}' (reversed='{rev}'): root for '{last}' = entry {root}")

        # Find first letter of reversed word
        target = rev[0]
        entry = root
        found = False
        for i in range(200):
            node = get_node_raw(entry + i)
            if node['letter'] == target:
                print(f"  Found '{target}' at entry {entry + i}: is_word={node['is_word']}")
                found = True
                if len(word) == 2 and node['is_word']:
                    print(f"  -> '{word}' IS valid!")
                elif len(word) == 2:
                    print(f"  -> '{word}' NOT marked as valid")
                break
            if node['is_last']:
                break
        if not found:
            print(f"  '{target}' not found in siblings")


if __name__ == "__main__":
    main()
