#!/usr/bin/env python3
"""Check where the 33 missed words belong (TWL-only? OSW? version difference?)"""

def load_wordlist(filepath):
    words = set()
    with open(filepath) as f:
        for line in f:
            w = line.strip().lower()
            if w:
                words.add(w)
    return words

twl = load_wordlist("lexica/maven_twl.txt")
osw = load_wordlist("lexica/maven_osw.txt")
sowpods = load_wordlist("lexica/maven_sowpods.txt")

missed = ['sneerful', 'ravagement', 'marrons', 'antiozonant', 'forkless',
          'counterthreats', 'trioxid', 'buzzwigs', 'myoelectrical', 'bookers',
          'gelee', 'punitivenesses', 'bindingnesses', 'shmear', 'ultramarathons',
          'interdiffuses', 'crumbliness', 'fireballers', 'flavorist', 'spaceport']

print(f"{'Word':<20} {'In TWL':<8} {'In OSW':<8} {'In SOWPODS':<10} {'Category'}")
print("-" * 60)
for w in missed:
    in_twl = w in twl
    in_osw = w in osw
    in_sp = w in sowpods
    if in_twl and not in_osw:
        cat = "TWL-only"
    elif in_osw and not in_twl:
        cat = "OSW-only"
    elif in_twl and in_osw:
        cat = "Both"
    elif in_sp:
        cat = "SOWPODS-only??"
    else:
        cat = "Not in any??"
    print(f"{w:<20} {'Y' if in_twl else 'N':<8} {'Y' if in_osw else 'N':<8} {'Y' if in_sp else 'N':<10} {cat}")

# Larger test: validate ALL sowpods against S2
import struct
FILEPATH = "/Volumes/T7/retrogames/oldmac/share/maven2"
with open(FILEPATH, 'rb') as f:
    data = f.read()
field2 = struct.unpack('>I', data[4:8])[0]
s2_base = 116 + field2 * 4

def entry(base, idx):
    off = base + idx * 4
    val = struct.unpack('>I', data[off:off+4])[0]
    return val & 0xFF, (val >> 8) & 1, (val >> 9) & 1, val >> 10

def siblings(base, start, max_idx=200000):
    result = []
    idx = start
    while idx < max_idx:
        lb, eow, last, child = entry(base, idx)
        if not (97 <= lb <= 122):
            break
        result.append((chr(lb), eow, child))
        if last:
            break
        idx += 1
        if len(result) > 200:
            break
    return result

def validate_s2(word):
    word = word.lower()
    if len(word) < 2:
        return False
    i = ord(word[0]) - ord('a')
    if i < 0 or i > 25:
        return False
    _, _, _, child = entry(s2_base, 1 + i)
    if child == 0:
        return False
    grp = siblings(s2_base, child)
    return _match(grp, word[1:])

def _match(grp, remaining):
    if not remaining:
        return True
    target = remaining[0]
    for lt, eow, child in grp:
        if lt == target:
            if len(remaining) == 1:
                return eow == 1
            if child == 0:
                return False
            return _match(siblings(s2_base, child), remaining[1:])
    return False

# Test ALL osw words in S2
print("\n" + "=" * 60)
print("Testing ALL OSW words against S2")
osw_found = sum(1 for w in osw if validate_s2(w))
print(f"OSW: {osw_found}/{len(osw)} ({100*osw_found/len(osw):.1f}%)")

# Test ALL twl words in S2
twl_found = sum(1 for w in twl if validate_s2(w))
print(f"TWL: {twl_found}/{len(twl)} ({100*twl_found/len(twl):.1f}%)")

# Test ALL sowpods words in S2
sp_found = sum(1 for w in sowpods if validate_s2(w))
print(f"SOWPODS: {sp_found}/{len(sowpods)} ({100*sp_found/len(sowpods):.1f}%)")

# How many TWL-only are NOT in S2?
twl_only = twl - osw
twl_only_in_s2 = sum(1 for w in twl_only if validate_s2(w))
print(f"\nTWL-only words: {len(twl_only)}")
print(f"TWL-only in S2: {twl_only_in_s2}/{len(twl_only)}")
if twl_only_in_s2 > 0:
    examples = [w for w in sorted(twl_only)[:20] if validate_s2(w)]
    print(f"  Examples: {examples[:10]}")
