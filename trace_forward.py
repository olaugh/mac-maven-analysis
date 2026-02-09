#!/usr/bin/env python3
"""
Try forward traversal from letter index to understand the structure.
"""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01
SECTION1_END = 56630

def main():
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]

    # Parse letter index
    LETTER_INDEX_OFFSET = 0x10
    letter_index = {}
    for i in range(26):
        offset = LETTER_INDEX_OFFSET + i * 4
        b0, b1, flags, letter = data[offset:offset+4]
        entry = (b0 << 8) | b1
        letter_index[chr(ord('a') + i)] = {
            'entry': entry,
            'flags': flags,
            'letter': chr(letter) if 97 <= letter <= 122 else '?'
        }

    print("Letter index entries:")
    for L in 'abcdefghijklmnopqrstuvwxyz':
        idx = letter_index[L]
        print(f"  {L}: entry={idx['entry']:4d}, flags=0x{idx['flags']:02x}, stored_letter={idx['letter']}")

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

    def get_siblings(start_entry, limit=50):
        siblings = []
        entry = start_entry
        while len(siblings) < limit:
            node = get_node(entry)
            if node is None:
                break
            siblings.append(node)
            if node['is_last']:
                break
            entry += 1
        return siblings

    # The index stores LETTERS as the 4th byte - not just position
    # Let me check if the index entry IS the sibling group for that letter
    print(f"\n{'='*60}")
    print("Interpreting index entries as sibling group starts...")

    for L in 'aeks':
        idx = letter_index[L]
        entry = idx['entry']
        sibs = get_siblings(entry)
        print(f"\n'{L}' index (entry {entry}): {[s['letter'] for s in sibs]}")
        for s in sibs[:5]:
            child = get_child_entry(s)
            if child:
                child_sibs = get_siblings(child)
                print(f"    {s['letter']}@{s['entry']} -> {[c['letter'] for c in child_sibs[:10]]}")

    # Attempt DFS from 'a' entry to enumerate words
    print(f"\n{'='*60}")
    print("DFS enumeration from 'a' index entry...")

    words = set()
    max_words = 500

    def dfs(entry, prefix, depth=0):
        if depth > 15:
            return
        if len(words) >= max_words:
            return

        sibs = get_siblings(entry)
        for node in sibs:
            if len(words) >= max_words:
                return

            word = prefix + node['letter']

            if node['is_word'] and len(word) >= 2:
                words.add(word)

            child = get_child_entry(node)
            if child and child < SECTION1_END:
                dfs(child, word, depth + 1)

    # Start from 'a' index entry
    a_entry = letter_index['a']['entry']
    print(f"Starting DFS from entry {a_entry}")

    # Actually, the index entry IS the sibling group for words starting with that letter
    # So we pass empty prefix and start from the index entry
    sibs = get_siblings(a_entry)
    for node in sibs:
        if len(words) >= max_words:
            break
        word = node['letter']  # First letter
        if node['is_word'] and len(word) >= 2:
            words.add(word)
        child = get_child_entry(node)
        if child and child < SECTION1_END:
            dfs(child, word, 1)

    print(f"\nFound {len(words)} words starting with DFS from 'a'")

    # Check results
    two_letter = sorted([w for w in words if len(w) == 2])
    three_letter = sorted([w for w in words if len(w) == 3])[:30]
    print(f"2-letter: {two_letter}")
    print(f"3-letter (sample): {three_letter}")

    # Check for known words
    known = ['aa', 'ab', 'ad', 'ae', 'aardvark', 'aardvarks']
    for w in known:
        if w in words:
            print(f"  '{w}': FOUND")
        else:
            print(f"  '{w}': not found")

    # Also show words starting with 'aa'
    aa_words = sorted([w for w in words if w.startswith('aa')])[:20]
    print(f"\nWords starting with 'aa': {aa_words}")


if __name__ == "__main__":
    main()
