#!/usr/bin/env python3
"""
Investigate the 26-entry gap between S1 and S2, and test longer word validation.
"""

import struct

FILEPATH = "/Volumes/T7/retrogames/oldmac/share/maven2"

with open(FILEPATH, 'rb') as f:
    data = f.read()

field2 = struct.unpack('>I', data[4:8])[0]  # 122,166
s1_base = 12
s2_base = 116 + field2 * 4  # 488,780

def read_entry(base, index):
    offset = base + index * 4
    if offset + 4 > len(data):
        return None
    val = struct.unpack('>I', data[offset:offset + 4])[0]
    lb = val & 0xFF
    return {
        'val': val,
        'letter': chr(lb) if 97 <= lb <= 122 else f'0x{lb:02x}',
        'letter_byte': lb,
        'eow': (val >> 8) & 1,
        'last': (val >> 9) & 1,
        'child': val >> 10,
    }

# Check gap entries: S1 entries 122,166 to 122,191
print("=" * 60)
print("Gap entries between S1 and S2 (S1 entries 122,166 - 122,191)")
print("=" * 60)
for i in range(26):
    entry = read_entry(s1_base, field2 + i)
    off = s1_base + (field2 + i) * 4
    b0, b1, b2, b3 = data[off:off + 4]
    print(f"  [{field2+i}] [{b0:02x} {b1:02x} {b2:02x} {b3:02x}] "
          f"letter='{entry['letter']}' eow={entry['eow']} last={entry['last']} "
          f"child={entry['child']}")

# Check entries just before gap
print("\n" + "=" * 60)
print("Last entries of S1 (before gap)")
print("=" * 60)
for i in range(5):
    idx = field2 - 5 + i
    entry = read_entry(s1_base, idx)
    print(f"  [{idx}] letter='{entry['letter']}' eow={entry['eow']} last={entry['last']} child={entry['child']}")

# Check tail entries after S2
print("\n" + "=" * 60)
print("Tail entries after S2")
print("=" * 60)
field3 = struct.unpack('>I', data[8:12])[0]  # 145,476
s2_end_offset = s2_base + field3 * 4
print(f"S2 base: {s2_base}, S2 end: {s2_end_offset}, File size: {len(data)}")
print(f"Tail bytes: {len(data) - s2_end_offset}")

for i in range(min(26, (len(data) - s2_end_offset) // 4)):
    off = s2_end_offset + i * 4
    val = struct.unpack('>I', data[off:off + 4])[0]
    lb = val & 0xFF
    letter = chr(lb) if 97 <= lb <= 122 else f'0x{lb:02x}'
    eow = (val >> 8) & 1
    last = (val >> 9) & 1
    child = val >> 10
    print(f"  [S2+{field3+i}] val=0x{val:08X} letter='{letter}' eow={eow} last={last} child={child}")

# Validate longer words against S2 (forward dictionary)
print("\n" + "=" * 60)
print("Testing longer words in S2 (forward dictionary)")
print("=" * 60)

def get_siblings(base, start, max_idx):
    siblings = []
    idx = start
    while idx < max_idx:
        entry = read_entry(base, idx)
        if entry is None or not (97 <= entry['letter_byte'] <= 122):
            break
        siblings.append(entry)
        if entry['last']:
            break
        idx += 1
        if len(siblings) > 200:
            break
    return siblings

def match_fwd(base, siblings, remaining, max_idx):
    if not remaining:
        return True
    target = remaining[0]
    for entry in siblings:
        if entry['letter'] == target:
            if len(remaining) == 1:
                return entry['eow'] == 1
            child = entry['child']
            if child == 0:
                return False
            return match_fwd(base, get_siblings(base, child, max_idx), remaining[1:], max_idx)
    return False

def validate_s2(word):
    word = word.lower()
    i = ord(word[0]) - ord('a')
    li = read_entry(s2_base, 1 + i)
    if li['child'] == 0:
        return False
    siblings = get_siblings(s2_base, li['child'], 200000)
    return match_fwd(s2_base, siblings, word[1:], 200000)

def validate_s1(word):
    word = word.lower()
    rev = word[::-1]
    i = ord(rev[0]) - ord('a')
    li = read_entry(s1_base, 1 + i)
    if li['child'] == 0:
        return False
    max_idx = len(data) // 4
    siblings = get_siblings(s1_base, li['child'], max_idx)
    return match_fwd(s1_base, siblings, rev[1:], max_idx)

test_words = ['cat', 'dog', 'the', 'queen', 'aardvark', 'zymurgy',
              'scrabble', 'maven', 'hello', 'world', 'apple', 'quixotic',
              'aa', 'aah', 'aahed', 'aardvark', 'ab', 'aba', 'abaci',
              'xyz', 'qqq', 'asdf']

print(f"\n{'Word':<15} {'S1(rev)':<10} {'S2(fwd)':<10}")
print("-" * 35)
for word in test_words:
    s1 = validate_s1(word)
    s2 = validate_s2(word)
    print(f"{word:<15} {'YES' if s1 else 'no':<10} {'YES' if s2 else 'no':<10}")

# Load reference and test random sample of longer words
print("\n" + "=" * 60)
print("Testing random sample of reference words")
print("=" * 60)
with open("lexica/maven_sowpods.txt") as f:
    sowpods = [line.strip().lower() for line in f if line.strip()]

import random
random.seed(42)
sample = random.sample(sowpods, min(200, len(sowpods)))

s1_correct = 0
s2_correct = 0
both_correct = 0
neither = []
for word in sample:
    s1 = validate_s1(word)
    s2 = validate_s2(word)
    if s1:
        s1_correct += 1
    if s2:
        s2_correct += 1
    if s1 or s2:
        both_correct += 1
    else:
        neither.append(word)

print(f"Sample size: {len(sample)}")
print(f"S1 found: {s1_correct}/{len(sample)} ({100*s1_correct/len(sample):.1f}%)")
print(f"S2 found: {s2_correct}/{len(sample)} ({100*s2_correct/len(sample):.1f}%)")
print(f"S1|S2 found: {both_correct}/{len(sample)} ({100*both_correct/len(sample):.1f}%)")
if neither:
    print(f"Not found in either ({len(neither)}): {neither[:20]}")
