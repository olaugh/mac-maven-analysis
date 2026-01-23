#!/usr/bin/env python3
"""
Analyze DAWG access patterns in CODE resources
Focus on understanding how the ptr field is used to navigate
"""

import struct

# Load all CODE resources
codes = {}
for code_id in [3, 7, 8, 11, 12]:
    try:
        with open(f'/tmp/maven_code_{code_id}.bin', 'rb') as f:
            codes[code_id] = f.read()
    except:
        pass

print("=" * 70)
print("DAWG Access Pattern Analysis")
print("=" * 70)

# Key insight: the DAWG header structure matches offsets 0x10, 0x14, 0x18
# which contain the values 56630, 122166, 145476

# The globals are:
# A5-23074: probably pointer to DAWG data
# A5-15506, A5-15502: probably DAWG sizes (56630, 65536)

# Let's look for patterns that combine ptr with something else

def find_instruction_patterns(data, code_id):
    """Find specific instruction sequences"""
    patterns = []

    for i in range(len(data) - 6):
        # Look for sequences involving: load, add, shift, access

        # Pattern: load word, then shift or multiply
        word = struct.unpack('>H', data[i:i+2])[0]

        # MOVE.W d(An),Dn followed by shift or mask
        if (word & 0xf1c0) == 0x3028:  # MOVE.W d(An),Dn
            areg = word & 7
            dreg = (word >> 9) & 7
            if i + 4 <= len(data):
                disp = struct.unpack('>h', data[i+2:i+4])[0]
                # Check next instruction
                if i + 6 <= len(data):
                    next_word = struct.unpack('>H', data[i+4:i+6])[0]
                    # Is it a shift or mask?
                    if (next_word & 0xf000) == 0xe000:  # Shift
                        patterns.append((i, f"MOVE.W {disp}(A{areg}),D{dreg} + shift"))
                    elif (next_word & 0xff00) == 0x0200:  # ANDI.B
                        patterns.append((i, f"MOVE.W {disp}(A{areg}),D{dreg} + ANDI.B"))
                    elif (next_word & 0xff00) == 0x0240:  # ANDI.W
                        patterns.append((i, f"MOVE.W {disp}(A{areg}),D{dreg} + ANDI.W"))

        # Look for byte access (reading flags byte)
        if (word & 0xf1c0) == 0x1028:  # MOVE.B d(An),Dn
            areg = word & 7
            dreg = (word >> 9) & 7
            if i + 4 <= len(data):
                disp = struct.unpack('>h', data[i+2:i+4])[0]
                # Offset 2 or 3 from base would be flags or letter
                if disp in [0, 1, 2, 3]:
                    patterns.append((i, f"MOVE.B {disp}(A{areg}),D{dreg}  ; entry field access"))

        # Look for (An,Dn) indexed addressing - common for array access
        # This is (d8,An,Xn) mode: 0x30 or higher with extension word

    return patterns

for code_id, data in codes.items():
    print(f"\n--- CODE {code_id} ---")
    patterns = find_instruction_patterns(data, code_id)
    for off, desc in patterns[:20]:
        hex_context = data[off:off+8].hex()
        print(f"  0x{off:04x}: {hex_context}  {desc}")

# Let's look at specific areas more carefully
print("\n" + "=" * 70)
print("Detailed Hex Analysis of DAWG Access Areas")
print("=" * 70)

code3 = codes.get(3)
if code3:
    # The area at 0x1a2 appears to be a function accessing DAWG header
    print("\n--- CODE 3 function at 0x1a2 (DAWG header access) ---")
    print("Raw hex dump:")
    for off in range(0x1a2, min(0x1e0, len(code3)), 16):
        hex_line = ' '.join(f'{code3[off+j]:02x}' for j in range(min(16, len(code3)-off)))
        print(f"  {off:04x}: {hex_line}")

    print("\nManual decode:")
    print("  1a2: 4e56 0000      LINK A6,#0")
    print("  1a6: 2f0c           MOVE.L A4,-(SP)")
    print("  1a8: 286e 0008      MOVEA.L 8(A6),A4  ; get parameter")
    print("  1ac: 202c 0010      MOVE.L 16(A4),D0  ; load field at offset 0x10")
    print("  1b0: d0ac 0014      ADD.L 20(A4),D0   ; add field at offset 0x14")
    print("  1b4: 222d a5de      MOVE.L -23074(A5),D1  ; load global (DAWG base?)")
    print("  1b8: d2ad a5e2      ADD.L -23070(A5),D1   ; add another global")
    print("  1bc: d2ad a5e6      ADD.L -23066(A5),D1   ; add yet another")
    print("  1c0: d0ac 0018      ADD.L 24(A4),D0   ; add field at offset 0x18")
    print("  1c4: b280           CMP.L D0,D1")
    print("  1c6: 6c10           BGE.S $1d8        ; branch if D1 >= D0")

    print("\n  This function computes:")
    print("    D0 = (A4)+0x10 + (A4)+0x14 + (A4)+0x18")
    print("    D1 = A5[-23074] + A5[-23070] + A5[-23066]")
    print("    Compare D0 to D1")
    print("  The DAWG header has values at 0x10=56630, 0x14=122166, 0x18=145476")
    print("  So D0 = 56630 + 122166 + 145476 = 324272")
    print("  This is used for bounds checking!")

# Look for indexed array access patterns
print("\n" + "=" * 70)
print("Searching for Indexed Access Patterns (An,Dn.x)")
print("=" * 70)

for code_id, data in codes.items():
    print(f"\n--- CODE {code_id} ---")
    for i in range(len(data) - 3):
        word = struct.unpack('>H', data[i:i+2])[0]

        # Mode 6: (d8,An,Xn) has format: xxxx xxx1 10xx x xxx
        # Extension word has format: Xn/W/L/scale/disp8
        mode = (word >> 3) & 7
        reg = word & 7

        # Check for mode 6 (Address Register Indirect with Index)
        if mode == 6:
            if i + 4 <= len(data):
                ext = struct.unpack('>H', data[i+2:i+4])[0]
                # Extension word: D/A, Xn, W/L, Scale, 0, Disp8
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

                # This is interesting if scale is 2 (x4) for entry access
                if scale == 2:  # x4
                    op = (word >> 12) & 0xf
                    print(f"  {i:04x}: indexed access with x4 scale: ({disp},A{reg},{reg_type}{xn}.{size}*4)")

# Let's also search for the constant 0x22 (34) which appears in the code
# and might be an entry size
print("\n" + "=" * 70)
print("Searching for Entry Size Constants")
print("=" * 70)

for code_id, data in codes.items():
    found = []
    for i in range(len(data) - 3):
        word = struct.unpack('>H', data[i:i+2])[0]

        # MULU #xx,Dn
        if (word & 0xf1c0) == 0xc0fc:
            if i + 4 <= len(data):
                imm = struct.unpack('>H', data[i+2:i+4])[0]
                dreg = (word >> 9) & 7
                if imm in [4, 34, 0x22]:
                    found.append((i, f"MULU #{imm},D{dreg}"))

        # MOVE.W #xx,Dn or similar with small constants
        if (word & 0xf1ff) == 0x303c:  # MOVE.W #imm,Dn
            if i + 4 <= len(data):
                imm = struct.unpack('>H', data[i+2:i+4])[0]
                dreg = (word >> 9) & 7
                if imm in [4, 34, 0x22]:
                    found.append((i, f"MOVE.W #{imm},D{dreg}"))

    if found:
        print(f"\n--- CODE {code_id} ---")
        for off, desc in found:
            print(f"  {off:04x}: {desc}")

# One more thing: let's look at the DAWG file header more carefully
print("\n" + "=" * 70)
print("DAWG File Header Analysis")
print("=" * 70)

with open('/Volumes/T7/retrogames/oldmac/share/maven2', 'rb') as f:
    dawg = f.read()

print("Header bytes (first 32 bytes):")
for i in range(0, 32, 4):
    val = struct.unpack('>I', dawg[i:i+4])[0]
    print(f"  {i:04x}: {dawg[i:i+4].hex()}  = {val}")

print("\nInterpretation:")
print("  0x00: 0x0000DD36 = 56630  (first DAWG size in entries)")
print("  0x04: 0x0001DD36 = 122166 (second DAWG start/cumulative?)")
print("  0x08: 0x00023844 = 145476 (third value)")
print("  0x0c: 0x00000300 = 768    (fourth value)")
print("  0x10: Letter index starts here (26 x 4 bytes)")
print("\nNode data starts at 0x0410 (1040 bytes)")
print("  Entry 0 at 0x0410")
print("  Entry N at 0x0410 + N*4")
