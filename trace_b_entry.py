#!/usr/bin/env python3
"""Trace a specific B entry to understand traversal."""

import struct

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
NODE_START = 0x410
FLAG_WORD = 0x80
FLAG_LAST = 0x01

with open(DAWG_PATH, 'rb') as f:
    data = f.read()

section1_end = struct.unpack('>I', data[0:4])[0]
section2_end = struct.unpack('>I', data[4:8])[0]


def get_node(entry_idx):
    offset = NODE_START + entry_idx * 4
    if offset + 4 > len(data):
        return None
    b0, b1, flags, letter = data[offset:offset+4]
    if not (97 <= letter <= 122):
        return None
    ptr = (b0 << 8) | b1
    return {
        'entry': entry_idx,
        'letter': chr(letter),
        'is_word': bool(flags & FLAG_WORD),
        'is_last': bool(flags & FLAG_LAST),
        'child': ptr + (flags & 0x7e) if ptr else 0,
    }


# Find first 'b' entry in Section 2 that validates 'BA'
print("Finding 'b' entry that validates 'ba'...")

for entry_idx in range(section1_end, section2_end):
    node = get_node(entry_idx)
    if node and node['letter'] == 'b' and node['child'] > 0:
        # Check children for 'a' with is_word=True
        child = node['child']
        while child < section1_end:
            c = get_node(child)
            if c is None:
                break
            if c['letter'] == 'a' and c['is_word']:
                print(f"\nFound valid BA path:")
                print(f"  B entry: {entry_idx}")
                print(f"    letter='b', is_word={node['is_word']}, is_last={node['is_last']}")
                print(f"    child={node['child']}")
                print(f"  A entry: {child}")
                print(f"    letter='a', is_word={c['is_word']}, is_last={c['is_last']}")
                print(f"    child={c['child']}")

                # Now let's trace what the sibling group looks like
                print(f"\n  Sibling group at {node['child']}:")
                sib_entry = node['child']
                for i in range(10):  # Show first 10
                    s = get_node(sib_entry)
                    if s is None:
                        break
                    print(f"    {sib_entry}: '{s['letter']}' is_word={s['is_word']} is_last={s['is_last']}")
                    if s['is_last']:
                        print(f"    (end of sibling group)")
                        break
                    sib_entry += 1

                # Let's enumerate words from this B entry manually
                print(f"\n  Manual enumeration from B@{entry_idx}:")
                words = []

                def enum_from(node, prefix, depth):
                    if depth > 10 or len(words) > 20:
                        return
                    new_prefix = prefix + node['letter']
                    if node['is_word'] and len(new_prefix) >= 2:
                        words.append(new_prefix)
                    if node['child'] > 0 and depth < 5:
                        c_entry = node['child']
                        while c_entry < section1_end:
                            cn = get_node(c_entry)
                            if cn is None:
                                break
                            enum_from(cn, new_prefix, depth + 1)
                            if cn['is_last']:
                                break
                            c_entry += 1

                enum_from(node, "", 0)
                print(f"    Words found: {sorted(words)}")

                # Stop after first example
                break
        else:
            continue
        break
