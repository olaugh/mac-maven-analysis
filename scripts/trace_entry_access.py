#!/usr/bin/env python3
"""
Trace actual entry access patterns in the CODE to understand ptr calculation
Focus on how the ptr value from an entry is used to navigate to children
"""

import struct

# Load CODE resources
codes = {}
for code_id in [3, 7, 8, 11, 12]:
    try:
        with open(f'/tmp/maven_code_{code_id}.bin', 'rb') as f:
            codes[code_id] = f.read()
    except:
        pass

print("=" * 70)
print("Entry Access and Ptr Field Analysis")
print("=" * 70)

# Looking for patterns where:
# 1. An entry is accessed (4 bytes at base + index*4)
# 2. The ptr field (first 2 bytes) is extracted
# 3. The ptr is used in some calculation to get next index

# Common patterns:
# - MOVE.W (An,Dn.L*4),Dx  ; load ptr from entry
# - MOVE.B 2(An,Dn.L*4),Dx ; load flags
# - MOVE.B 3(An,Dn.L*4),Dx ; load letter

def analyze_code(code_id, data):
    print(f"\n{'=' * 70}")
    print(f"CODE {code_id} Analysis")
    print("=" * 70)

    # Find MOVE.W instructions that might be loading ptr from entry
    for i in range(len(data) - 5):
        word1 = struct.unpack('>H', data[i:i+2])[0]

        # Look for MOVE.W (d,An,Xn),Dn pattern
        # This is: 0011 ddd0 11xx xyyy (where xxx yyy define mode 6)
        if (word1 & 0xf1c0) == 0x30b0:  # MOVE.W with mode 6 src
            ext = struct.unpack('>H', data[i+2:i+4])[0]
            dreg = (word1 >> 9) & 7
            areg = word1 & 7

            xn = (ext >> 12) & 7
            da = (ext >> 15) & 1
            wl = (ext >> 11) & 1
            scale = (ext >> 9) & 3
            disp = ext & 0xff
            if disp > 127:
                disp = disp - 256

            reg_type = 'A' if da else 'D'
            size = 'L' if wl else 'W'
            scale_val = 1 << scale

            if scale_val == 4 and disp == 0:  # x4 scale, zero displacement = ptr field!
                print(f"\n  {i:04x}: MOVE.W (A{areg},{reg_type}{xn}.{size}*4),D{dreg}  ; LOAD PTR FIELD!")

                # Show context - next few instructions
                print("    Following instructions:")
                j = i + 4
                for _ in range(8):
                    if j >= len(data) - 1:
                        break
                    w = struct.unpack('>H', data[j:j+2])[0]
                    hex_str = data[j:j+min(6, len(data)-j)].hex()
                    print(f"      {j:04x}: {hex_str}")
                    j += 2

        # Also look for MOVE.B 2(An,Xn),Dn (flags byte)
        if (word1 & 0xf1c0) == 0x10b0:  # MOVE.B with mode 6 src
            ext = struct.unpack('>H', data[i+2:i+4])[0]
            dreg = (word1 >> 9) & 7
            areg = word1 & 7

            xn = (ext >> 12) & 7
            da = (ext >> 15) & 1
            wl = (ext >> 11) & 1
            scale = (ext >> 9) & 3
            disp = ext & 0xff
            if disp > 127:
                disp = disp - 256

            reg_type = 'A' if da else 'D'
            size = 'L' if wl else 'W'
            scale_val = 1 << scale

            if scale_val == 4 and disp in [2, 3]:  # flags or letter byte
                field = "FLAGS" if disp == 2 else "LETTER"
                print(f"\n  {i:04x}: MOVE.B {disp}(A{areg},{reg_type}{xn}.{size}*4),D{dreg}  ; LOAD {field}!")

                # Show context
                print("    Following instructions:")
                j = i + 4
                for _ in range(6):
                    if j >= len(data) - 1:
                        break
                    hex_str = data[j:j+min(6, len(data)-j)].hex()
                    print(f"      {j:04x}: {hex_str}")
                    j += 2

        # Look for MOVE.L (d,An,Xn),Dn - loading full entry
        if (word1 & 0xf1c0) == 0x20b0:  # MOVE.L with mode 6 src
            ext = struct.unpack('>H', data[i+2:i+4])[0]
            dreg = (word1 >> 9) & 7
            areg = word1 & 7

            xn = (ext >> 12) & 7
            da = (ext >> 15) & 1
            wl = (ext >> 11) & 1
            scale = (ext >> 9) & 3
            disp = ext & 0xff
            if disp > 127:
                disp = disp - 256

            reg_type = 'A' if da else 'D'
            size = 'L' if wl else 'W'
            scale_val = 1 << scale

            if scale_val == 4 and disp == 0:
                print(f"\n  {i:04x}: MOVE.L (A{areg},{reg_type}{xn}.{size}*4),D{dreg}  ; LOAD FULL ENTRY!")

                # Show context
                print("    Following instructions:")
                j = i + 4
                for _ in range(10):
                    if j >= len(data) - 1:
                        break
                    hex_str = data[j:j+min(6, len(data)-j)].hex()
                    print(f"      {j:04x}: {hex_str}")
                    j += 2

for code_id, data in sorted(codes.items()):
    analyze_code(code_id, data)

# Now let's try another approach: look for specific byte sequences
# that match the DAWG traversal pattern
print("\n" + "=" * 70)
print("Looking for AND patterns that extract bits from ptr/flags")
print("=" * 70)

for code_id, data in sorted(codes.items()):
    print(f"\n--- CODE {code_id} ---")
    for i in range(len(data) - 5):
        word = struct.unpack('>H', data[i:i+2])[0]

        # ANDI.W #mask,Dn
        if (word & 0xffc0) == 0x0240:
            dreg = word & 7
            if i + 4 <= len(data):
                mask = struct.unpack('>H', data[i+2:i+4])[0]
                # Interesting masks for ptr/flag extraction
                if mask in [0x7fff, 0x8000, 0x00ff, 0xff00, 0x7e00, 0x007e,
                           0x0001, 0x0080, 0x7ffe, 0xfffe]:
                    print(f"  {i:04x}: ANDI.W #${mask:04x},D{dreg}")

                    # Context
                    start = max(0, i-8)
                    print(f"    Context: {data[start:i+8].hex()}")

        # LSR.W #n,Dn (shift right to extract high bits)
        if (word & 0xf1d8) == 0xe048:  # LSR.W immediate
            count = (word >> 9) & 7
            if count == 0:
                count = 8
            dreg = word & 7
            if count in [1, 7, 8]:  # Interesting shift amounts
                print(f"  {i:04x}: LSR.W #{count},D{dreg}")
                start = max(0, i-6)
                print(f"    Context: {data[start:i+6].hex()}")

# Let's also look at how ptr is combined with something
print("\n" + "=" * 70)
print("Looking for ADD.W Dn,Dm patterns after loading ptr")
print("=" * 70)

for code_id, data in sorted(codes.items()):
    for i in range(len(data) - 5):
        word = struct.unpack('>H', data[i:i+2])[0]

        # ADD.W Dn,Dm
        if (word & 0xf1f0) == 0xd040:
            dreg = (word >> 9) & 7
            sreg = word & 7
            # Check if previous instruction loaded something
            if i >= 4:
                prev_hex = data[i-4:i].hex()
                next_hex = data[i:i+4].hex()
                print(f"  CODE {code_id} @ {i:04x}: ADD.W D{sreg},D{dreg}")
                print(f"    Before: {prev_hex}  After: {next_hex}")
