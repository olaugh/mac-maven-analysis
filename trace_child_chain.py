#!/usr/bin/env python3
"""
Trace the child chain from Section 2 entry to understand word paths.
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

def show_entry(data, entry_idx):
    offset = NODE_START + entry_idx * 4
    b0, b1, flags, letter = data[offset:offset+4]
    ptr = (b0 << 8) | b1
    child = ptr + (flags & 0x7e) if ptr > 0 else 0
    return {
        'entry': entry_idx,
        'letter': chr(letter) if 97 <= letter <= 122 else '?',
        'ptr': ptr,
        'flags': flags,
        'is_word': bool(flags & 0x80),
        'is_last': bool(flags & 0x01),
        'child': child,
    }

def print_siblings(data, start_entry, section_limit, indent=""):
    entry = start_entry
    while entry < section_limit:
        n = show_entry(data, entry)
        word_mark = " [WORD]" if n['is_word'] else ""
        child_info = f" -> child {n['child']}" if n['child'] > 0 and n['child'] < section_limit else ""
        print(f"{indent}Entry {n['entry']}: '{n['letter']}'{word_mark}{child_info}")
        if n['is_last']:
            print(f"{indent}  (LAST)")
            break
        entry += 1
    return entry + 1 if n['is_last'] else entry

def trace_word(data, section1_end, word):
    """Trace how a word would be validated in the DAWG."""
    print(f"\n=== Tracing '{word}' ===")

    # For forward words, check Section 2
    first = word[0]
    rest = word[1:]

    # Find Section 2 entries with this letter
    s2_entries = []
    for entry_idx in range(section1_end, section1_end + 65536):
        n = show_entry(data, entry_idx)
        if n['letter'] == first:
            s2_entries.append(n)

    print(f"Found {len(s2_entries)} Section 2 entries starting with '{first}'")

    # Try each entry
    for s2 in s2_entries[:10]:
        print(f"\nTrying S2 entry {s2['entry']}: child={s2['child']}")
        if s2['child'] > 0:
            result = trace_forward(data, section1_end, s2['child'], rest, first, 1)
            if result:
                print(f"  FOUND via this path!")
                return True

    return False

def trace_forward(data, section1_end, start_entry, remaining, prefix, depth):
    """Trace forward from a child entry."""
    if depth > 10:
        return False

    indent = "  " * depth

    if not remaining:
        # Check if we're at a word end
        n = show_entry(data, start_entry)
        print(f"{indent}At entry {start_entry}: '{n['letter']}' is_word={n['is_word']}")
        return n['is_word']

    target = remaining[0]
    rest = remaining[1:]

    print(f"{indent}Looking for '{target}' in siblings at {start_entry}")

    # Search siblings
    entry = start_entry
    while entry < section1_end:
        n = show_entry(data, entry)
        print(f"{indent}  Entry {n['entry']}: '{n['letter']}'")

        if n['letter'] == target:
            new_prefix = prefix + n['letter']
            print(f"{indent}  MATCH! word so far: '{new_prefix}'")

            if not rest:
                # Last letter
                if n['is_word']:
                    print(f"{indent}  SUCCESS: '{new_prefix}' is a word!")
                    return True
                else:
                    print(f"{indent}  Pattern matched but not a word")
            else:
                # Continue following
                if n['child'] > 0 and n['child'] < section1_end:
                    if trace_forward(data, section1_end, n['child'], rest, new_prefix, depth+1):
                        return True

        if n['is_last']:
            break
        entry += 1

    return False

def main():
    data, section1_end, section2_end = load_dawg("/Volumes/T7/retrogames/oldmac/share/maven2")

    print(f"Section 1: 0-{section1_end}")
    print(f"Section 2: {section1_end}-{section2_end}")

    # Show what entry 7 looks like (this is where 'ao' child points)
    print("\n--- Entry 7 and its siblings ---")
    print_siblings(data, 7, section1_end)

    # Trace some known words
    for word in ['aa', 'ab', 'at', 'cat', 'act']:
        trace_word(data, section1_end, word)

if __name__ == "__main__":
    main()
