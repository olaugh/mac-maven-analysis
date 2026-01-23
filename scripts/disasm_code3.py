#!/usr/bin/env python3
"""
Disassemble CODE 3 looking for DAWG access patterns
"""

import struct

with open('/tmp/maven_code_3.bin', 'rb') as f:
    data = f.read()

print("CODE 3 Full Disassembly - DAWG Access Analysis")
print("=" * 70)

def disasm_word(data, i):
    """Disassemble instruction at offset i, return (length, mnemonic)"""
    if i + 2 > len(data):
        return 2, "???"

    word = struct.unpack('>H', data[i:i+2])[0]

    # Common m68k instructions
    if word == 0x4e56:  # LINK
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            return 4, f"LINK A6,#{disp}"
        return 2, "LINK A6,#?"

    if word == 0x4e5e:
        return 2, "UNLK A6"

    if word == 0x4e75:
        return 2, "RTS"

    if word == 0x4e71:
        return 2, "NOP"

    # MOVEQ
    if (word & 0xf100) == 0x7000:
        val = word & 0xff
        if val > 127:
            val = val - 256
        reg = (word >> 9) & 7
        return 2, f"MOVEQ #{val},D{reg}"

    # MOVE.L d(A5),Dn - loading globals
    if (word & 0xf1ff) == 0x202d:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            reg = (word >> 9) & 7
            return 4, f"MOVE.L {disp}(A5),D{reg}  ; global"

    # MOVE.L d(An),Dn
    if (word & 0xf1c0) == 0x2028:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"MOVE.L {disp}(A{areg}),D{dreg}"

    # ADD.L d(An),Dn
    if (word & 0xf1c0) == 0xd0a8:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"ADD.L {disp}(A{areg}),D{dreg}"

    # SUB.L d(An),Dn
    if (word & 0xf1c0) == 0x90a8:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"SUB.L {disp}(A{areg}),D{dreg}"

    # LEA d(A5),An - address of global
    if (word & 0xf1ff) == 0x41ed:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            reg = (word >> 9) & 7
            return 4, f"LEA {disp}(A5),A{reg}  ; addr of global"

    # LEA d(An),Am
    if (word & 0xf1c0) == 0x41e8:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"LEA {disp}(A{areg}),A{dreg}"

    # MOVEA.L d(An),Am
    if (word & 0xf1c0) == 0x2068:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"MOVEA.L {disp}(A{areg}),A{dreg}"

    # MOVE.L Dn,d(Am)
    if (word & 0xf1c0) == 0x2140:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            sreg = word & 7
            areg = (word >> 9) & 7
            return 4, f"MOVE.L D{sreg},{disp}(A{areg})"

    # CMP.L d(An),Dn
    if (word & 0xf1c0) == 0xb0a8:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"CMP.L {disp}(A{areg}),D{dreg}"

    # BRA/BSR/Bcc
    if (word & 0xff00) == 0x6000:  # BRA
        disp = word & 0xff
        if disp == 0:
            disp = struct.unpack('>h', data[i+2:i+4])[0] if i+4 <= len(data) else 0
            return 4, f"BRA.W ${i+4+disp:04x}"
        else:
            if disp > 127:
                disp = disp - 256
            return 2, f"BRA.S ${i+2+disp:04x}"

    if (word & 0xff00) == 0x6100:  # BSR
        disp = word & 0xff
        if disp == 0:
            disp = struct.unpack('>h', data[i+2:i+4])[0] if i+4 <= len(data) else 0
            return 4, f"BSR.W ${i+4+disp:04x}"
        else:
            if disp > 127:
                disp = disp - 256
            return 2, f"BSR.S ${i+2+disp:04x}"

    # Bcc (conditional branches)
    if (word & 0xf000) == 0x6000:
        cc = (word >> 8) & 0xf
        cc_names = ['T','F','HI','LS','CC','CS','NE','EQ','VC','VS','PL','MI','GE','LT','GT','LE']
        disp = word & 0xff
        if disp == 0:
            disp = struct.unpack('>h', data[i+2:i+4])[0] if i+4 <= len(data) else 0
            return 4, f"B{cc_names[cc]}.W ${i+4+disp:04x}"
        else:
            if disp > 127:
                disp = disp - 256
            return 2, f"B{cc_names[cc]}.S ${i+2+disp:04x}"

    # MULU
    if (word & 0xf1c0) == 0xc0c0:
        if i + 4 <= len(data):
            dreg = (word >> 9) & 7
            mode = (word >> 3) & 7
            reg = word & 7
            if mode == 7 and reg == 4:  # Immediate
                imm = struct.unpack('>H', data[i+2:i+4])[0]
                return 4, f"MULU #{imm},D{dreg}"

    # LSL/LSR/ASL/ASR
    if (word & 0xf018) == 0xe008:  # LSR reg
        count = (word >> 9) & 7
        if count == 0:
            count = 8
        size = (word >> 6) & 3
        reg = word & 7
        sizes = ['B', 'W', 'L']
        return 2, f"LSR.{sizes[size]} #{count},D{reg}"

    if (word & 0xf018) == 0xe108:  # LSL reg
        count = (word >> 9) & 7
        if count == 0:
            count = 8
        size = (word >> 6) & 3
        reg = word & 7
        sizes = ['B', 'W', 'L']
        return 2, f"LSL.{sizes[size]} #{count},D{reg}"

    # MOVEM
    if word == 0x48e7:
        if i + 4 <= len(data):
            mask = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"MOVEM.L #${mask:04x},-(SP)"

    if word == 0x4cdf:
        if i + 4 <= len(data):
            mask = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"MOVEM.L (SP)+,#${mask:04x}"

    # JSR (An)
    if (word & 0xffc0) == 0x4e80:
        mode = (word >> 3) & 7
        reg = word & 7
        if mode == 2:
            return 2, f"JSR (A{reg})"
        elif mode == 5:
            if i + 4 <= len(data):
                disp = struct.unpack('>h', data[i+2:i+4])[0]
                return 4, f"JSR {disp}(A{reg})"

    return 2, f"DC.W ${word:04x}"

# Disassemble the interesting region (0x90-0x110) where structure access happens
print("\n--- Region 0x90-0x130 (structure field access) ---")
i = 0x90
while i < min(0x130, len(data)):
    length, mnemonic = disasm_word(data, i)
    hex_bytes = data[i:i+length].hex()
    print(f"  {i:04x}: {hex_bytes:<12} {mnemonic}")
    i += length

# Disassemble around the A5-relative accesses
print("\n--- Globals loaded from A5 ---")
print("Key globals found:")
print("  A5-23074 (-0x5A22): loaded multiple times")
print("  A5-15506 (-0x3C92): loaded at 0xb54")
print("  A5-15502 (-0x3C8E): loaded at 0xb5c")
print("  A5-11972 (-0x2EC4): loaded at 0x59a, 0x5f0, 0x604")

print("\n--- Region 0xb50-0xba0 (globals 15506 and 15502) ---")
i = 0xb50
while i < min(0xba0, len(data)):
    length, mnemonic = disasm_word(data, i)
    hex_bytes = data[i:i+length].hex()
    print(f"  {i:04x}: {hex_bytes:<12} {mnemonic}")
    i += length

# Look for any x4 multiplications
print("\n--- Searching for entry size (x4) operations ---")
for i in range(len(data) - 1):
    word = struct.unpack('>H', data[i:i+2])[0]

    # LSL.L #2,Dn
    if (word & 0xf1f8) == 0xe588:
        reg = word & 7
        print(f"  {i:04x}: LSL.L #2,D{reg}")

    # ASL.L #2,Dn
    if (word & 0xf1f8) == 0xe580:
        reg = word & 7
        print(f"  {i:04x}: ASL.L #2,D{reg}")

    # MULU #4,Dn
    if (word & 0xf1c0) == 0xc0fc:
        if i + 4 <= len(data):
            imm = struct.unpack('>H', data[i+2:i+4])[0]
            if imm == 4:
                dreg = (word >> 9) & 7
                print(f"  {i:04x}: MULU #4,D{dreg}")

print("\n--- Summary ---")
print("The structure access at 0xc4-0xce loads/adds offsets 0x10, 0x14, 0x18")
print("These match the DAWG file header offsets!")
print("  0x10 (16): Could be letter index base")
print("  0x14 (20): Could be a size field")
print("  0x18 (24): Could be another size field")
