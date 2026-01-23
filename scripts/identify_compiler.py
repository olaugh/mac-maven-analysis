#!/usr/bin/env python3
"""
Identify compiler used for Maven based on code patterns.
Classic Mac compilers: THINK C, MPW C, CodeWarrior
"""

import struct

# Load CODE resources
codes = {}
for code_id in [0, 1, 3, 7, 8, 11, 12]:
    try:
        with open(f'/tmp/maven_code_{code_id}.bin', 'rb') as f:
            codes[code_id] = f.read()
    except:
        pass

print("=" * 70)
print("Compiler Identification Analysis")
print("=" * 70)

# CODE 0 is the jump table - check its structure
if 0 in codes:
    code0 = codes[0]
    print(f"\nCODE 0 (jump table): {len(code0)} bytes")
    print("First 32 bytes:")
    for i in range(0, min(32, len(code0)), 8):
        hex_str = ' '.join(f'{code0[i+j]:02x}' for j in range(min(8, len(code0)-i)))
        print(f"  {i:04x}: {hex_str}")

# Check function prologue patterns
print("\n" + "=" * 70)
print("Function Prologue Patterns")
print("=" * 70)

# Common patterns:
# THINK C: LINK A6,#-n; MOVEM.L regs,-(SP)
# MPW C: LINK A6,#-n; MOVEM.L regs,-(SP) (similar but different reg choices)
# CodeWarrior: Various, often uses A5 for globals

for code_id, data in sorted(codes.items()):
    if code_id == 0:
        continue

    print(f"\n--- CODE {code_id} ---")

    # Count LINK A6 instructions (0x4E56)
    link_count = 0
    link_offsets = []
    for i in range(len(data) - 3):
        if data[i:i+2] == b'\x4e\x56':
            link_count += 1
            disp = struct.unpack('>h', data[i+2:i+4])[0]
            link_offsets.append((i, disp))

    print(f"  LINK A6 count: {link_count}")
    if link_offsets:
        print(f"  First 5 LINK offsets: {link_offsets[:5]}")

    # Check what follows LINK - MOVEM pattern
    movem_after_link = 0
    for off, disp in link_offsets[:20]:
        if off + 6 < len(data):
            next_word = struct.unpack('>H', data[off+4:off+6])[0]
            # MOVEM.L regs,-(SP) = 0x48E7
            if next_word == 0x48e7:
                movem_after_link += 1

    print(f"  LINK followed by MOVEM.L: {movem_after_link} of first 20")

    # Check for A5-relative globals (THINK C and MPW both use A5 for globals)
    a5_refs = 0
    for i in range(len(data) - 3):
        word = struct.unpack('>H', data[i:i+2])[0]
        # MOVE.L d(A5),Dn = 0x202D, 0x222D, etc.
        if (word & 0xf1ff) == 0x202d:
            a5_refs += 1
        # LEA d(A5),An = 0x41ED, 0x43ED, etc.
        if (word & 0xf1ff) == 0x41ed:
            a5_refs += 1

    print(f"  A5-relative references: {a5_refs}")

    # Check for trap calls (A-line instructions 0xAxxx)
    trap_calls = []
    for i in range(len(data) - 1):
        word = struct.unpack('>H', data[i:i+2])[0]
        if (word & 0xf000) == 0xa000:
            trap_calls.append((i, word))

    print(f"  Toolbox trap calls: {len(trap_calls)}")
    if trap_calls[:5]:
        print(f"  First 5 traps: {[(hex(t[0]), hex(t[1])) for t in trap_calls[:5]]}")

# Look for compiler-specific strings in the binary
print("\n" + "=" * 70)
print("Searching for Compiler Signatures")
print("=" * 70)

# Combine all CODE resources
all_code = b''.join(codes.values())

# Known signatures
signatures = [
    b'THINK',
    b'Symantec',
    b'MPW',
    b'Metrowerks',
    b'CodeWarrior',
    b'Apple',
    b'Copyright',
    b'(c)',
    b'Brian Sheppard',  # Maven author
    b'Maven',
]

for sig in signatures:
    if sig in all_code:
        pos = all_code.find(sig)
        context = all_code[max(0, pos-20):pos+len(sig)+20]
        print(f"Found '{sig.decode('ascii', errors='replace')}' at {pos}")
        print(f"  Context: {context}")

# Check CODE 1 for startup code pattern
if 1 in codes:
    code1 = codes[1]
    print(f"\n--- CODE 1 Analysis (startup/main) ---")
    print(f"Size: {len(code1)} bytes")
    print("First 64 bytes:")
    for i in range(0, min(64, len(code1)), 16):
        hex_str = ' '.join(f'{code1[i+j]:02x}' for j in range(min(16, len(code1)-i)))
        ascii_str = ''.join(chr(code1[i+j]) if 32 <= code1[i+j] < 127 else '.' for j in range(min(16, len(code1)-i)))
        print(f"  {i:04x}: {hex_str}  {ascii_str}")

# Analyze register usage patterns
print("\n" + "=" * 70)
print("Register Usage Analysis")
print("=" * 70)

if 3 in codes:
    code3 = codes[3]

    # Count register usage in addressing modes
    d_regs = [0] * 8
    a_regs = [0] * 8

    for i in range(len(code3) - 1):
        word = struct.unpack('>H', code3[i:i+2])[0]

        # Data register direct (mode 000)
        reg = word & 7
        mode = (word >> 3) & 7
        if mode == 0:
            d_regs[reg] += 1
        elif mode == 1:
            a_regs[reg] += 1

    print("Data register frequency:")
    for i, count in enumerate(d_regs):
        print(f"  D{i}: {count}")

    print("\nAddress register frequency:")
    for i, count in enumerate(a_regs):
        print(f"  A{i}: {count}")

# Stack frame analysis
print("\n" + "=" * 70)
print("Stack Frame Analysis")
print("=" * 70)

if 3 in codes:
    code3 = codes[3]

    # Find all LINK instructions and their frame sizes
    frames = []
    for i in range(len(code3) - 3):
        if code3[i:i+2] == b'\x4e\x56':
            disp = struct.unpack('>h', code3[i+2:i+4])[0]
            frames.append((i, disp))

    print(f"Functions with stack frames: {len(frames)}")
    print("Frame sizes:")
    sizes = [f[1] for f in frames]
    from collections import Counter
    for size, count in Counter(sizes).most_common(10):
        print(f"  {size} bytes: {count} functions")
