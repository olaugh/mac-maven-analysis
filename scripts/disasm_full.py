#!/usr/bin/env python3
"""
Full disassembly of CODE resources with better m68k decoding
Focus on understanding DAWG access patterns
"""

import struct

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

    # MOVE.L d(An),Dn (other address registers)
    if (word & 0xf1c0) == 0x2028:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"MOVE.L {disp}(A{areg}),D{dreg}"

    # MOVE.W d(An),Dn
    if (word & 0xf1c0) == 0x3028:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"MOVE.W {disp}(A{areg}),D{dreg}"

    # MOVE.B d(An),Dn
    if (word & 0xf1c0) == 0x1028:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"MOVE.B {disp}(A{areg}),D{dreg}"

    # ADD.L d(An),Dn
    if (word & 0xf1c0) == 0xd0a8:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"ADD.L {disp}(A{areg}),D{dreg}"

    # ADD.W d(An),Dn
    if (word & 0xf1c0) == 0xd068:
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            dreg = (word >> 9) & 7
            areg = word & 7
            return 4, f"ADD.W {disp}(A{areg}),D{dreg}"

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

    # MOVEA.L Dn,An
    if (word & 0xf1f8) == 0x2040:
        dreg = (word >> 9) & 7
        sreg = word & 7
        return 2, f"MOVEA.L D{sreg},A{dreg}"

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

    # CMP.L Dn,Dm
    if (word & 0xf1f8) == 0xb080:
        dreg = (word >> 9) & 7
        sreg = word & 7
        return 2, f"CMP.L D{sreg},D{dreg}"

    # BRA/BSR/Bcc
    if (word & 0xff00) == 0x6000:  # BRA
        disp = word & 0xff
        if disp == 0:
            if i + 4 <= len(data):
                disp = struct.unpack('>h', data[i+2:i+4])[0]
                return 4, f"BRA.W ${i+4+disp:04x}"
            return 4, "BRA.W ?"
        else:
            if disp > 127:
                disp = disp - 256
            return 2, f"BRA.S ${i+2+disp:04x}"

    if (word & 0xff00) == 0x6100:  # BSR
        disp = word & 0xff
        if disp == 0:
            if i + 4 <= len(data):
                disp = struct.unpack('>h', data[i+2:i+4])[0]
                return 4, f"BSR.W ${i+4+disp:04x}"
            return 4, "BSR.W ?"
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
            if i + 4 <= len(data):
                disp = struct.unpack('>h', data[i+2:i+4])[0]
                return 4, f"B{cc_names[cc]}.W ${i+4+disp:04x}"
            return 4, f"B{cc_names[cc]}.W ?"
        else:
            if disp > 127:
                disp = disp - 256
            return 2, f"B{cc_names[cc]}.S ${i+2+disp:04x}"

    # MULU #imm,Dn
    if (word & 0xf1c0) == 0xc0fc:
        if i + 4 <= len(data):
            dreg = (word >> 9) & 7
            imm = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"MULU #{imm},D{dreg}"

    # MULU Dn,Dm
    if (word & 0xf1c0) == 0xc0c0:
        mode = (word >> 3) & 7
        reg = word & 7
        dreg = (word >> 9) & 7
        if mode == 0:  # Dn
            return 2, f"MULU D{reg},D{dreg}"

    # LSL/LSR/ASL/ASR - register shift
    if (word & 0xf010) == 0xe000:  # Shift register
        ir = (word >> 5) & 1  # 0=count, 1=register
        dr = (word >> 8) & 1  # 0=right, 1=left
        size = (word >> 6) & 3
        if size < 3:
            sizes = ['B', 'W', 'L']
            count_reg = (word >> 9) & 7
            dreg = word & 7
            kind = (word >> 3) & 3
            kinds = ['AS', 'LS', 'ROX', 'RO']
            direction = 'L' if dr else 'R'
            if ir:
                return 2, f"{kinds[kind]}{direction}.{sizes[size]} D{count_reg},D{dreg}"
            else:
                cnt = count_reg if count_reg != 0 else 8
                return 2, f"{kinds[kind]}{direction}.{sizes[size]} #{cnt},D{dreg}"

    # MOVEM
    if word == 0x48e7:
        if i + 4 <= len(data):
            mask = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"MOVEM.L #${mask:04x},-(SP)"

    if word == 0x4cdf:
        if i + 4 <= len(data):
            mask = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"MOVEM.L (SP)+,#${mask:04x}"

    # JSR
    if (word & 0xffc0) == 0x4e80:
        mode = (word >> 3) & 7
        reg = word & 7
        if mode == 2:
            return 2, f"JSR (A{reg})"
        elif mode == 5:
            if i + 4 <= len(data):
                disp = struct.unpack('>h', data[i+2:i+4])[0]
                return 4, f"JSR {disp}(A{reg})"
        elif mode == 7 and reg == 0:  # abs.W
            if i + 4 <= len(data):
                addr = struct.unpack('>H', data[i+2:i+4])[0]
                return 4, f"JSR ${addr:04x}.W"
        elif mode == 7 and reg == 1:  # abs.L
            if i + 6 <= len(data):
                addr = struct.unpack('>I', data[i+2:i+6])[0]
                return 6, f"JSR ${addr:08x}.L"

    # ADD.L Dn,Dm
    if (word & 0xf1f0) == 0xd080:
        dreg = (word >> 9) & 7
        sreg = word & 7
        return 2, f"ADD.L D{sreg},D{dreg}"

    # ADD.L #imm,Dn
    if (word & 0xfff8) == 0x0680:
        if i + 6 <= len(data):
            dreg = word & 7
            imm = struct.unpack('>I', data[i+2:i+6])[0]
            return 6, f"ADD.L #{imm},D{dreg}"

    # AND.L
    if (word & 0xf1f0) == 0xc080:
        dreg = (word >> 9) & 7
        sreg = word & 7
        return 2, f"AND.L D{sreg},D{dreg}"

    # ANDI #imm,Dn
    if (word & 0xffc0) == 0x0200:
        if i + 4 <= len(data):
            dreg = word & 7
            imm = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"ANDI.B #{imm},D{dreg}"
    if (word & 0xffc0) == 0x0240:
        if i + 4 <= len(data):
            dreg = word & 7
            imm = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"ANDI.W #{imm},D{dreg}"
    if (word & 0xffc0) == 0x0280:
        if i + 6 <= len(data):
            dreg = word & 7
            imm = struct.unpack('>I', data[i+2:i+6])[0]
            return 6, f"ANDI.L #{imm},D{dreg}"

    # CLR
    if (word & 0xff00) == 0x4200:
        size = (word >> 6) & 3
        sizes = ['B', 'W', 'L', '?']
        mode = (word >> 3) & 7
        reg = word & 7
        if mode == 0:
            return 2, f"CLR.{sizes[size]} D{reg}"

    # TST
    if (word & 0xff00) == 0x4a00:
        size = (word >> 6) & 3
        sizes = ['B', 'W', 'L', '?']
        mode = (word >> 3) & 7
        reg = word & 7
        if mode == 0:
            return 2, f"TST.{sizes[size]} D{reg}"

    # EXT
    if (word & 0xfff8) == 0x4880:
        reg = word & 7
        return 2, f"EXT.W D{reg}"
    if (word & 0xfff8) == 0x48c0:
        reg = word & 7
        return 2, f"EXT.L D{reg}"

    # ADDQ
    if (word & 0xf100) == 0x5000:
        size = (word >> 6) & 3
        if size < 3:
            sizes = ['B', 'W', 'L']
            data_val = (word >> 9) & 7
            if data_val == 0:
                data_val = 8
            mode = (word >> 3) & 7
            reg = word & 7
            if mode == 0:
                return 2, f"ADDQ.{sizes[size]} #{data_val},D{reg}"
            elif mode == 1:
                return 2, f"ADDQ.{sizes[size]} #{data_val},A{reg}"

    # SUBQ
    if (word & 0xf100) == 0x5100:
        size = (word >> 6) & 3
        if size < 3:
            sizes = ['B', 'W', 'L']
            data_val = (word >> 9) & 7
            if data_val == 0:
                data_val = 8
            mode = (word >> 3) & 7
            reg = word & 7
            if mode == 0:
                return 2, f"SUBQ.{sizes[size]} #{data_val},D{reg}"
            elif mode == 1:
                return 2, f"SUBQ.{sizes[size]} #{data_val},A{reg}"

    # DBcc
    if (word & 0xf0f8) == 0x50c8:
        cc = (word >> 8) & 0xf
        cc_names = ['T','F','HI','LS','CC','CS','NE','EQ','VC','VS','PL','MI','GE','LT','GT','LE']
        reg = word & 7
        if i + 4 <= len(data):
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            return 4, f"DB{cc_names[cc]} D{reg},${i+2+disp:04x}"

    # MOVE.L #imm,Dn
    if (word & 0xf1ff) == 0x203c:
        if i + 6 <= len(data):
            dreg = (word >> 9) & 7
            imm = struct.unpack('>I', data[i+2:i+6])[0]
            return 6, f"MOVE.L #{imm},D{dreg}"

    # MOVE.W #imm,Dn
    if (word & 0xf1ff) == 0x303c:
        if i + 4 <= len(data):
            dreg = (word >> 9) & 7
            imm = struct.unpack('>H', data[i+2:i+4])[0]
            return 4, f"MOVE.W #{imm},D{dreg}"

    return 2, f"DC.W ${word:04x}"

def disasm_region(data, start, end, label=""):
    """Disassemble a region of code"""
    if label:
        print(f"\n--- {label} ---")
    i = start
    while i < min(end, len(data)):
        length, mnemonic = disasm_word(data, i)
        hex_bytes = data[i:i+length].hex()
        print(f"  {i:04x}: {hex_bytes:<12} {mnemonic}")
        i += length

# Load CODE 3
with open('/tmp/maven_code_3.bin', 'rb') as f:
    code3 = f.read()

print("=" * 70)
print("CODE 3 Disassembly - DAWG Access Analysis")
print("=" * 70)

# The header access pattern at 0x90-0x130 is crucial
print("\nThis region accesses structure fields at offsets 0x10, 0x14, 0x18")
print("which match the DAWG file header positions!")
disasm_region(code3, 0x80, 0x140, "Structure Header Access (0x80-0x140)")

# Look at the globals loading area
disasm_region(code3, 0x1a0, 0x220, "Globals Loading (0x1a0-0x220)")

# Area around A5-11972 access
disasm_region(code3, 0x580, 0x620, "DAWG Access Area 1 (0x580-0x620)")

# Area with A5-15506 and A5-15502
disasm_region(code3, 0xb40, 0xba0, "DAWG Access Area 2 (0xb40-0xba0)")

# Look for all x4 multiplications or entry access patterns
print("\n" + "=" * 70)
print("Searching for Entry Access Patterns (x4 or shift by 2)")
print("=" * 70)

for i in range(len(code3) - 1):
    word = struct.unpack('>H', code3[i:i+2])[0]

    # LSL.L #2,Dn (multiply by 4)
    if (word & 0xf1f8) == 0xe588:
        count = (word >> 9) & 7
        if count == 0:
            count = 8
        if count == 2:
            reg = word & 7
            print(f"  {i:04x}: LSL.L #2,D{reg}  ; multiply by 4")
            disasm_region(code3, max(0, i-16), i+16, f"Context around {i:04x}")

    # ASL.L #2,Dn
    if (word & 0xf1f8) == 0xe580:
        count = (word >> 9) & 7
        if count == 0:
            count = 8
        if count == 2:
            reg = word & 7
            print(f"  {i:04x}: ASL.L #2,D{reg}  ; multiply by 4")
            disasm_region(code3, max(0, i-16), i+16, f"Context around {i:04x}")

    # MULU #4,Dn
    if (word & 0xf1c0) == 0xc0fc:
        if i + 4 <= len(code3):
            imm = struct.unpack('>H', code3[i+2:i+4])[0]
            if imm == 4:
                dreg = (word >> 9) & 7
                print(f"  {i:04x}: MULU #4,D{dreg}")
                disasm_region(code3, max(0, i-16), i+16, f"Context around {i:04x}")

# Now search for ANDI patterns that might mask flag bits
print("\n" + "=" * 70)
print("Searching for Flag Masking Patterns (ANDI)")
print("=" * 70)

for i in range(len(code3) - 3):
    word = struct.unpack('>H', code3[i:i+2])[0]

    # ANDI.B #imm,Dn or ANDI.W #imm,Dn
    if (word & 0xff00) == 0x0200 or (word & 0xff00) == 0x0240:
        imm = struct.unpack('>H', code3[i+2:i+4])[0]
        if imm in [0x01, 0x7e, 0x7f, 0x80, 0xfe, 0xff]:
            dreg = word & 7
            size = 'B' if (word & 0xff00) == 0x0200 else 'W'
            print(f"  {i:04x}: ANDI.{size} #${imm:02x},D{dreg}")
            disasm_region(code3, max(0, i-20), i+20, f"Context around {i:04x}")

print("\n" + "=" * 70)
print("Summary of Key Globals")
print("=" * 70)
print("A5-23074 (-0x5A22): Main DAWG data pointer?")
print("A5-15506 (-0x3C92): DAWG 1 size or pointer?")
print("A5-15502 (-0x3C8E): DAWG 2 size or pointer?")
print("A5-11972 (-0x2EC4): Another DAWG-related pointer?")
print("\nDAWG file header at offsets:")
print("  0x10: field accessed in code")
print("  0x14: field accessed in code")
print("  0x18: field accessed in code")
