#!/usr/bin/env python3
"""
Decode specific m68k instruction sequences to understand DAWG access.
Focus on the regions that access entries.
"""

import struct

# Load CODE 3 which has the most DAWG-related code
with open('/tmp/maven_code_3.bin', 'rb') as f:
    code3 = f.read()

print("=" * 70)
print("Manual m68k Decoding - DAWG Access Patterns")
print("=" * 70)

# Let's decode the bytes around interesting areas

def decode_bytes(data, start, length=32, label=""):
    """Decode bytes showing hex and attempting m68k interpretation"""
    print(f"\n{label} (0x{start:04x} - 0x{start+length:04x}):")
    print("  Hex dump:")
    for off in range(start, min(start + length, len(data)), 8):
        hex_str = ' '.join(f'{data[off+j]:02x}' for j in range(min(8, len(data)-off)))
        print(f"    {off:04x}: {hex_str}")

# The area at 0x0e9d (from earlier output) had indexed access with x4 scale
print("\n" + "=" * 70)
print("Area 0x0e9d - indexed x4 access")
print("=" * 70)
decode_bytes(code3, 0x0e90, 48)

# Let me decode this manually
# At 0x0e9d: indexed access with x4 scale: (0,A0,D3.L*4)
# This means: access memory at A0 + D3*4 + 0

print("\nManual decode of 0x0e9d area:")
offset = 0x0e9d
# Look at the two words at this offset
word1 = struct.unpack('>H', code3[offset:offset+2])[0]
word2 = struct.unpack('>H', code3[offset+2:offset+4])[0]
print(f"  {offset:04x}: {word1:04x} {word2:04x}")
print(f"  word1 = 0x{word1:04x} = {word1:016b}")

# Parse as MOVE instruction with indexed addressing
# MOVE.x <ea>,Dn has format: 00ss ddd mmm mmm sss
# where ss=size, ddd=dest reg, mmm mmm sss=source ea mode
opcode = (word1 >> 12) & 0xf
size_bits = (word1 >> 12) & 3
dest_reg = (word1 >> 9) & 7
dest_mode = (word1 >> 6) & 7
src_mode = (word1 >> 3) & 7
src_reg = word1 & 7

print(f"  opcode nibble: {opcode:x}")
print(f"  dest_mode: {dest_mode}, dest_reg: {dest_reg}")
print(f"  src_mode: {src_mode}, src_reg: {src_reg}")

# If src_mode = 6, it's (d8,An,Xn) which requires extension word
if src_mode == 6:
    ext = word2
    xn = (ext >> 12) & 7
    da = (ext >> 15) & 1
    wl = (ext >> 11) & 1
    scale = (ext >> 9) & 3
    disp = ext & 0xff
    if disp > 127:
        disp = disp - 256
    print(f"  Extension word: 0x{ext:04x}")
    print(f"    index reg: {'A' if da else 'D'}{xn}")
    print(f"    size: {'L' if wl else 'W'}")
    print(f"    scale: {1 << scale}")
    print(f"    displacement: {disp}")

# Now let's look at what CODE resources do with the values after loading
print("\n" + "=" * 70)
print("Tracing typical entry access sequence")
print("=" * 70)

# Common pattern would be:
# 1. Load entry: MOVE.L (An,Dn.L*4),Dm
# 2. Extract ptr: AND or shift
# 3. Extract flags: shift or AND
# 4. Use ptr for next access

# Let's search for byte sequences that match MOVE.L indexed
print("\nSearching for MOVE.L (An,Dn.L*4),Dm patterns:")
for i in range(len(code3) - 3):
    word1 = struct.unpack('>H', code3[i:i+2])[0]

    # MOVE.L has opcode 0010 = 2
    if (word1 >> 12) != 2:
        continue

    # Source mode 6 = indexed
    src_mode = (word1 >> 3) & 7
    if src_mode != 6:
        continue

    # Check extension word for *4 scale
    ext = struct.unpack('>H', code3[i+2:i+4])[0]
    scale = (ext >> 9) & 3
    if scale == 2:  # *4
        da = (ext >> 15) & 1
        xn = (ext >> 12) & 7
        wl = (ext >> 11) & 1
        disp = ext & 0xff
        src_reg = word1 & 7
        dest_reg = (word1 >> 9) & 7

        print(f"\n  {i:04x}: MOVE.L ({disp},A{src_reg},{'A' if da else 'D'}{xn}.{'L' if wl else 'W'}*4),D{dest_reg}")

        # Show following instructions
        print("    Following instructions:")
        j = i + 4
        for _ in range(5):
            if j >= len(code3) - 1:
                break
            w = struct.unpack('>H', code3[j:j+2])[0]
            print(f"      {j:04x}: {w:04x}")

            # Common operations on loaded value:
            # SWAP (4840-4847)
            if (w & 0xfff8) == 0x4840:
                print(f"            = SWAP D{w & 7}")
            # LSR.W #n,Dn
            elif (w & 0xf1f8) == 0xe048:
                cnt = (w >> 9) & 7
                if cnt == 0:
                    cnt = 8
                print(f"            = LSR.W #{cnt},D{w & 7}")
            # ANDI.W #imm,Dn
            elif (w & 0xff00) == 0x0240:
                j2 = struct.unpack('>H', code3[j+2:j+4])[0]
                print(f"            = ANDI.W #${j2:04x},D{w & 7}")
                j += 2
            # ANDI.L #imm,Dn
            elif (w & 0xff00) == 0x0280:
                j2 = struct.unpack('>I', code3[j+2:j+6])[0]
                print(f"            = ANDI.L #${j2:08x},D{w & 7}")
                j += 4

            j += 2

# Also search for MOVE.W indexed
print("\n" + "=" * 70)
print("Searching for MOVE.W (An,Dn.L*4),Dm patterns (loading ptr only):")
print("=" * 70)

for i in range(len(code3) - 3):
    word1 = struct.unpack('>H', code3[i:i+2])[0]

    # MOVE.W has opcode 0011 = 3
    if (word1 >> 12) != 3:
        continue

    # Source mode 6 = indexed
    src_mode = (word1 >> 3) & 7
    if src_mode != 6:
        continue

    # Check extension word for *4 scale
    ext = struct.unpack('>H', code3[i+2:i+4])[0]
    scale = (ext >> 9) & 3
    disp = ext & 0xff
    if disp > 127:
        disp = disp - 256

    if scale == 2 and disp == 0:  # *4 scale, 0 displacement = ptr field
        da = (ext >> 15) & 1
        xn = (ext >> 12) & 7
        wl = (ext >> 11) & 1
        src_reg = word1 & 7
        dest_reg = (word1 >> 9) & 7

        print(f"\n  {i:04x}: MOVE.W (A{src_reg},{'A' if da else 'D'}{xn}.{'L' if wl else 'W'}*4),D{dest_reg}  ; Load ptr field")

        # Show context
        print("    Following instructions (first 8):")
        j = i + 4
        for _ in range(8):
            if j >= len(code3) - 1:
                break
            w = struct.unpack('>H', code3[j:j+2])[0]
            print(f"      {j:04x}: {w:04x}")
            j += 2
