#!/usr/bin/env python3
"""
Analyze what is_word means in Section 2 entries.
"""

import struct

NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

def load_dawg(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    section1_end = struct.unpack('>I', data[0:4])[0]
    section2_end = struct.unpack('>I', data[4:8])[0]
    return data, section1_end, section2_end

def get_node(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0
    return {
        'letter': chr(letter) if 97 <= letter <= 122 else '?',
        'is_word': (flags & FLAG_WORD) != 0,
        'is_last': (flags & FLAG_LAST) != 0,
        'child': child,
        'entry': entry_idx,
    }

def main():
    data, section1_end, section2_end = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print("="*60)
    print("Analyzing Section 2 entry structure")
    print("="*60)

    # Count Section 2 entries by letter and is_word status
    by_letter = {}
    for idx in range(section1_end, section2_end):
        node = get_node(data, idx)
        if node and 'a' <= node['letter'] <= 'z':
            L = node['letter']
            if L not in by_letter:
                by_letter[L] = {'total': 0, 'is_word_true': 0, 'is_word_false': 0}
            by_letter[L]['total'] += 1
            if node['is_word']:
                by_letter[L]['is_word_true'] += 1
            else:
                by_letter[L]['is_word_false'] += 1

    print("\nSection 2 entry distribution:")
    print("-"*60)
    print(f"{'Letter':<8} {'Total':>8} {'is_word=T':>12} {'is_word=F':>12}")
    print("-"*60)
    for L in sorted(by_letter.keys()):
        info = by_letter[L]
        print(f"{L:<8} {info['total']:>8} {info['is_word_true']:>12} {info['is_word_false']:>12}")

    # Key question: what do Section 2 entries with is_word=False look like?
    # vs is_word=True?
    print("\n" + "="*60)
    print("Sample Section 2 'a' entries")
    print("="*60)

    a_entries_true = []
    a_entries_false = []
    for idx in range(section1_end, section2_end):
        node = get_node(data, idx)
        if node and node['letter'] == 'a':
            if node['is_word']:
                a_entries_true.append(node)
            else:
                a_entries_false.append(node)

    print(f"\n'a' with is_word=True ({len(a_entries_true)} total, showing 10):")
    for n in a_entries_true[:10]:
        print(f"  Entry {n['entry']}: child={n['child']}")

    print(f"\n'a' with is_word=False ({len(a_entries_false)} total, showing 10):")
    for n in a_entries_false[:10]:
        print(f"  Entry {n['entry']}: child={n['child']}")

    # Theory: Section 2 is_word=True means you can form a word starting
    # with just this letter plus its children.
    # Let's check if 'a' entries with is_word=True lead to known 2-letter words

    print("\n" + "="*60)
    print("Checking Section 2 for 2-letter word structure")
    print("="*60)

    # For each Section 2 'a' entry, check its children
    # If child has letter 'a' with is_word=True, that's AA
    # If child has letter 'b' with is_word=True, that's AB
    # etc.

    print("\nSection 2 paths that could be 2-letter words starting with 'a':")

    def get_siblings(data, start, limit):
        sibs = []
        entry = start
        while entry < limit:
            node = get_node(data, entry)
            if node is None or node['letter'] == '?':
                break
            sibs.append(node)
            if node['is_last']:
                break
            entry += 1
        return sibs

    two_letter_found = set()
    for s2_entry in a_entries_true + a_entries_false:
        if s2_entry['child'] and s2_entry['child'] < section1_end:
            children = get_siblings(data, s2_entry['child'], section1_end)
            for c in children:
                if c['is_word']:
                    word = 'a' + c['letter']
                    two_letter_found.add(word)

    print(f"\nFound {len(two_letter_found)} potential 2-letter words starting with 'a':")
    print(f"  {sorted(two_letter_found)}")

    # Compare to expected list
    real_2letter_a = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an', 'ar', 'as', 'at', 'aw', 'ax', 'ay']
    fake_2letter_a = ['ac', 'af', 'aj', 'ak', 'ao', 'ap', 'aq', 'au', 'av', 'az']

    print(f"\nExpected real 2-letter 'a' words: {real_2letter_a}")
    print(f"Expected fake 2-letter 'a' words: {fake_2letter_a}")

    false_positives = [w for w in two_letter_found if w in fake_2letter_a]
    false_negatives = [w for w in real_2letter_a if w not in two_letter_found]

    print(f"\nFalse positives (found but shouldn't be): {false_positives}")
    print(f"False negatives (missing but should be): {false_negatives}")


if __name__ == "__main__":
    main()
