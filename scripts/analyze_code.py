#!/usr/bin/env python3
"""
Analyze Maven CODE resources for DAWG access patterns
"""

import struct

def disasm_simple(data, offset=0):
    """Very simple m68k disassembler for common patterns"""
    results = []
    i = 0
    while i < len(data) - 1:
        word = struct.unpack('>H', data[i:i+2])[0]

        # Common instructions
        if word == 0x4e56:  # LINK
            disp = struct.unpack('>h', data[i+2:i+4])[0] if i+4 <= len(data) else 0
            results.append((offset+i, f"LINK A6,#{disp}"))
            i += 4
        elif word == 0x4e5e:  # UNLK
            results.append((offset+i, "UNLK A6"))
            i += 2
        elif word == 0x4e75:  # RTS
            results.append((offset+i, "RTS"))
            i += 2
        elif (word & 0xf000) == 0x7000:  # MOVEQ
            val = word & 0xff
            reg = (word >> 9) & 7
            results.append((offset+i, f"MOVEQ #{val},D{reg}"))
            i += 2
        elif (word & 0xffc0) == 0x2040:  # MOVEA.L to An
            reg = (word >> 9) & 7
            results.append((offset+i, f"MOVEA.L ...,A{reg}"))
            i += 2
        elif word == 0x48e7:  # MOVEM.L regs,-(SP)
            mask = struct.unpack('>H', data[i+2:i+4])[0] if i+4 <= len(data) else 0
            results.append((offset+i, f"MOVEM.L #{mask:04x},-(SP)"))
            i += 4
        elif word == 0x4cee:  # MOVEM.L (d,An),regs
            results.append((offset+i, "MOVEM.L (d,A6),regs"))
            i += 6
        elif word == 0x4cdf:  # MOVEM.L (SP)+,regs
            mask = struct.unpack('>H', data[i+2:i+4])[0] if i+4 <= len(data) else 0
            results.append((offset+i, f"MOVEM.L (SP)+,#{mask:04x}"))
            i += 4
        else:
            i += 2

    return results

# Load CODE files that contain 0x0410
code_files = {
    3: '/tmp/maven_code_3.bin',
    7: '/tmp/maven_code_7.bin',
    8: '/tmp/maven_code_8.bin',
    11: '/tmp/maven_code_11.bin',
    12: '/tmp/maven_code_12.bin',
}

print("=" * 60)
print("Searching for DAWG-related constants in CODE")
print("=" * 60)

for code_id, path in code_files.items():
    with open(path, 'rb') as f:
        data = f.read()

    print(f"\n--- CODE {code_id} ({len(data)} bytes) ---")

    # Search for 0x0410 (DAWG node base)
    for i in range(len(data) - 1):
        if data[i:i+2] == b'\x04\x10':
            # Show context
            start = max(0, i - 20)
            end = min(len(data), i + 20)
            print(f"  0x0410 at offset 0x{i:x}")
            print(f"  Context: {data[start:end].hex()}")

    # Search for 0xDD36 (56630 - first DAWG size)
    for i in range(len(data) - 1):
        if data[i:i+2] == b'\xdd\x36':
            start = max(0, i - 20)
            end = min(len(data), i + 20)
            print(f"  0xDD36 (56630) at offset 0x{i:x}")
            print(f"  Context: {data[start:end].hex()}")

    # Search for word access patterns: A5 relative addressing
    # Move from (d,A5) patterns: 2x2d, 3x2d (for x=0-7, d>0)
    a5_accesses = []
    for i in range(len(data) - 3):
        word = struct.unpack('>H', data[i:i+2])[0]
        # Check for d(A5) addressing mode patterns
        if (word & 0xf1ff) == 0x202d:  # MOVE.L d(A5),Dn
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            reg = (word >> 9) & 7
            if abs(disp) > 100:  # Significant displacement
                a5_accesses.append((i, f"MOVE.L {disp}(A5),D{reg}"))

    if a5_accesses:
        print(f"  A5-relative accesses (globals): {len(a5_accesses)}")
        for off, inst in a5_accesses[:10]:
            print(f"    0x{off:x}: {inst}")

print("\n" + "=" * 60)
print("Detailed analysis of CODE 11 (largest with 0x0410)")
print("=" * 60)

with open('/tmp/maven_code_11.bin', 'rb') as f:
    data = f.read()

# Find all occurrences of 0x0410
offsets_0410 = []
for i in range(len(data) - 1):
    if data[i:i+2] == b'\x04\x10':
        offsets_0410.append(i)

print(f"Found 0x0410 at offsets: {[hex(o) for o in offsets_0410]}")

# Show disassembly around each occurrence
for off in offsets_0410:
    print(f"\n--- Around offset 0x{off:x} ---")
    start = max(0, off - 30)
    end = min(len(data), off + 30)
    print(f"Hex: {data[start:end].hex()}")

    # Try to interpret as instructions
    # The 0x0410 might be part of an immediate value or address

    # Check if it's an immediate load
    if off >= 2:
        prev_word = struct.unpack('>H', data[off-2:off])[0]
        if (prev_word & 0xf1ff) == 0x203c:  # MOVE.L #imm,Dn
            print(f"  MOVE.L #0x0410xxxx,D{(prev_word>>9)&7}")
        elif (prev_word & 0xfff8) == 0x41f8:  # LEA.L addr.W,An
            print(f"  LEA.L 0x0410.W,A{prev_word&7}")

# Also check for multiplication by 4 (entry size)
print("\n--- Searching for x4 multiplication (entry size) ---")
for i in range(len(data) - 3):
    word = struct.unpack('>H', data[i:i+2])[0]
    # ASL.L #2,Dn (shift left 2 = multiply by 4)
    if (word & 0xf1f8) == 0xe580:
        reg = word & 7
        count = (word >> 9) & 7
        if count == 2:
            print(f"  ASL.L #2,D{reg} at 0x{i:x}")
    # LSL.L #2,Dn
    if (word & 0xf1f8) == 0xe588:
        reg = word & 7
        count = (word >> 9) & 7
        if count == 2:
            print(f"  LSL.L #2,D{reg} at 0x{i:x}")
