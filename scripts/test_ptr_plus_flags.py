#!/usr/bin/env python3
"""
Test hypothesis: child index = ptr + (flags & 0x7e)
The flags middle bits (1-6) are added to ptr to get the child index.
"""

import struct

DAWG_PATH = '/Volumes/T7/retrogames/oldmac/share/maven2'
NODE_BASE = 0x0410
LETTER_INDEX_OFFSET = 0x0010
H1 = 56630

with open(DAWG_PATH, 'rb') as f:
    DATA = f.read()

def get_entry(idx):
    if idx < 0 or idx >= H1:
        return None, None, None
    offset = NODE_BASE + idx * 4
    ptr = struct.unpack('>H', DATA[offset:offset+2])[0]
    flags = DATA[offset+2]
    letter_byte = DATA[offset+3]
    letter = chr(letter_byte) if 0x61 <= letter_byte <= 0x7a else f'0x{letter_byte:02x}'
    return ptr, flags, letter

def get_letter_index_entry(letter):
    idx = ord(letter.lower()) - ord('a')
    offset = LETTER_INDEX_OFFSET + idx * 4
    entry_idx = struct.unpack('>H', DATA[offset:offset+2])[0]
    return entry_idx

def get_children_index(ptr, flags):
    """Calculate child starting index from ptr and flags"""
    # Hypothesis: children start at ptr + (flags & 0x7e)
    return ptr + (flags & 0x7e)

# Load SOWPODS
try:
    with open('/Volumes/T7/retrogames/oldmac/maven_re/lexica/sowpods2003.txt', 'r') as f:
        sowpods = set(line.strip().upper() for line in f)
except:
    sowpods = set()

print("=" * 70)
print("Testing child_index = ptr + (flags & 0x7e)")
print("=" * 70)

# Trace from letter A
a_start = get_letter_index_entry('a')
print(f"\nLetter 'A' -> entry {a_start}")

ptr, flags, letter = get_entry(a_start)
print(f"Entry {a_start}: ptr={ptr}, flags=0x{flags:02x}, letter='{letter}'")
print(f"  flags & 0x7e = 0x{flags & 0x7e:02x} = {flags & 0x7e}")
print(f"  child_index = {ptr} + {flags & 0x7e} = {get_children_index(ptr, flags)}")

# Show siblings from letter index entry
print("\nSiblings from letter index for A:")
idx = a_start
while True:
    ptr, flags, letter = get_entry(idx)
    if ptr is None:
        break
    child_idx = get_children_index(ptr, flags)
    wm = "WORD" if flags & 0x80 else ""
    ls = "LAST" if flags & 0x01 else ""
    print(f"  Entry {idx}: ptr={ptr:3d} flags=0x{flags:02x} ({wm:4s} {ls:4s}) letter='{letter}' -> children at {child_idx}")

    if flags & 0x01:  # LAST
        break
    idx += 1

# Now let's trace words
print("\n" + "=" * 70)
print("Tracing words with child_index = ptr + (flags & 0x7e)")
print("=" * 70)

def trace_words(start_letter, max_depth=5):
    """Trace all words starting with a letter"""
    words = []

    start_entry = get_letter_index_entry(start_letter)

    def recurse(entry_idx, path, depth):
        if depth > max_depth:
            return

        # Process sibling group starting at entry_idx
        idx = entry_idx
        while True:
            ptr, flags, letter = get_entry(idx)
            if ptr is None:
                break

            if letter.startswith('0x'):
                if flags & 0x01:
                    break
                idx += 1
                continue

            new_path = path + letter

            if flags & 0x80:  # WORD marker
                words.append(new_path.upper())

            # Calculate child index
            child_idx = get_children_index(ptr, flags)

            # Only recurse if ptr > 0 (has children) and within bounds
            if ptr > 0 and child_idx < H1:
                recurse(child_idx, new_path, depth + 1)

            if flags & 0x01:  # LAST sibling
                break
            idx += 1

    recurse(start_entry, start_letter, 2)
    return words

a_words = trace_words('a', max_depth=5)
print(f"\nFound {len(a_words)} words starting with 'A'")

valid_words = [w for w in a_words if w in sowpods]
invalid_words = [w for w in a_words if w not in sowpods]

print(f"Valid SOWPODS words: {len(valid_words)}")
print(f"Invalid: {len(invalid_words)}")

print("\nFirst 40 words found:")
for w in sorted(a_words)[:40]:
    valid = "✓" if w in sowpods else "✗"
    print(f"  {valid} {w}")

# Check 2-letter words
print("\n" + "=" * 70)
print("Two-letter words")
print("=" * 70)

two_letter_a = [w for w in sowpods if len(w) == 2 and w[0] == 'A']
found_2letter = [w for w in a_words if len(w) == 2]

print(f"SOWPODS 2-letter A words: {sorted(two_letter_a)}")
print(f"Found 2-letter A words: {sorted(found_2letter)}")

# Let's also try tracing from other letters
print("\n" + "=" * 70)
print("Testing other starting letters")
print("=" * 70)

for start in 'THEIRS':  # Test with common letters
    words = trace_words(start.lower(), max_depth=4)
    two_letter = [w for w in words if len(w) == 2]
    valid_2 = [w for w in two_letter if w in sowpods]
    print(f"{start}: {len(words)} words, {len(two_letter)} 2-letter ({len(valid_2)} valid)")
    if two_letter:
        print(f"   2-letter: {sorted(two_letter)[:10]}")

# Let's examine the path calculation in detail for a known word
print("\n" + "=" * 70)
print("Detailed trace for 'THE'")
print("=" * 70)

def detailed_trace(target_word):
    """Trace a specific word and show each step"""
    print(f"\nTracing '{target_word}':")
    target = target_word.upper()
    path = target[0].lower()

    entry_idx = get_letter_index_entry(target[0])
    print(f"  Start: letter '{target[0]}' -> entry {entry_idx}")

    for i, next_letter in enumerate(target[1:].lower()):
        print(f"\n  Looking for '{next_letter}' from entry {entry_idx}:")

        # Search siblings
        idx = entry_idx
        found = False
        while True:
            ptr, flags, letter = get_entry(idx)
            if ptr is None:
                print(f"    ERROR: out of bounds at {idx}")
                return

            child_idx = get_children_index(ptr, flags)
            wm = "WORD" if flags & 0x80 else ""
            ls = "LAST" if flags & 0x01 else ""

            if letter == next_letter:
                print(f"    FOUND: entry {idx} letter='{letter}' ptr={ptr} flags=0x{flags:02x} -> children at {child_idx}")
                path += letter
                entry_idx = child_idx
                found = True
                break

            print(f"    Skip: entry {idx} letter='{letter}' ({wm} {ls})")

            if flags & 0x01:
                break
            idx += 1

        if not found:
            print(f"    ERROR: letter '{next_letter}' not found in sibling group")
            return

    print(f"\n  Final path: '{path.upper()}'")
    # Check if last entry has WORD flag
    ptr, flags, letter = get_entry(entry_idx - 1 if entry_idx > 0 else entry_idx)
    # Actually we need to check the entry we ended on
    print(f"  Checking for WORD flag on the path...")

detailed_trace("THE")
detailed_trace("AA")
