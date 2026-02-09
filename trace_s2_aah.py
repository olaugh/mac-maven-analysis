#!/usr/bin/env python3
"""Quick trace of why 'aah' and 'aahed' aren't found in S2."""
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

def siblings(base, start):
    result = []
    idx = start
    while True:
        lb, eow, last, child = entry(base, idx)
        if not (97 <= lb <= 122):
            break
        result.append((idx, chr(lb), eow, last, child))
        if last:
            break
        idx += 1
    return result

# Trace "aah" in S2
print("Tracing 'aah' in S2:")
_, _, _, a_child = entry(s2_base, 1)  # letter index 'a'
print(f"  'a' LI child = {a_child}")
grp = siblings(s2_base, a_child)
print(f"  First group ({len(grp)} entries):")
for idx, lt, eow, last, child in grp:
    if lt == 'a':
        print(f"    [{idx}] '{lt}' eow={eow} last={last} child={child}  <-- follow this")
        grp2 = siblings(s2_base, child)
        print(f"  Group at {child} ({len(grp2)} entries):")
        for idx2, lt2, eow2, last2, child2 in grp2:
            marker = " <-- need 'h' with eow=1" if lt2 == 'h' else ""
            print(f"    [{idx2}] '{lt2}' eow={eow2} last={last2} child={child2}{marker}")
            if lt2 == 'h':
                # Follow 'h' child for 'aahe*'
                grp3 = siblings(s2_base, child2)
                print(f"  Group at {child2} ({len(grp3)} entries) [for 'aah*']:")
                for idx3, lt3, eow3, last3, child3 in grp3:
                    print(f"    [{idx3}] '{lt3}' eow={eow3} last={last3} child={child3}")
        break

# Test: is "aah" found in S2 when checking the correct path?
print("\n\nAlso check 'cat' trace in S2:")
_, _, _, c_child = entry(s2_base, 3)  # letter index 'c'
print(f"  'c' LI child = {c_child}")
grp = siblings(s2_base, c_child)
for idx, lt, eow, last, child in grp:
    if lt == 'a':
        print(f"  'a' at [{idx}] child={child}")
        grp2 = siblings(s2_base, child)
        for idx2, lt2, eow2, last2, child2 in grp2:
            if lt2 == 't':
                print(f"    't' at [{idx2}] eow={eow2} child={child2}  {'VALID!' if eow2 else 'not a word'}")
