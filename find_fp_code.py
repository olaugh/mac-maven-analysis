#!/usr/bin/env python3
"""
Find floating-point operations in Maven CODE resources.
This helps identify where leave value calculations might occur.

68000 floating point is typically done via:
1. SANE (Standard Apple Numerics Environment) - A-line traps
2. 68881/68882 FPU instructions (if present)
3. Software emulation routines

SANE trap codes:
- A9EB: FP68K (Pack 4) - basic FP operations
- A9EC: Elems68K (Pack 5) - transcendental functions
"""
import os
import struct

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def find_aline_traps(data):
    """Find A-line trap instructions (0xAxxx)"""
    traps = []
    for i in range(0, len(data) - 1, 2):
        word = struct.unpack('>H', data[i:i+2])[0]
        if (word & 0xF000) == 0xA000:
            traps.append((i, word))
    return traps

def decode_trap(word):
    """Decode common Mac Toolbox traps"""
    trap_names = {
        0xA9EB: "FP68K (SANE Pack 4)",
        0xA9EC: "Elems68K (SANE Pack 5)",
        0xA9A0: "GetResource",
        0xA9A1: "ReleaseResource",
        0xA9A2: "GetNamedResource",
        0xA9A3: "LoadResource",
        0xA9A4: "ReleaseResource",
        0xA128: "RecoverHandle",
        0xA029: "HLock",
        0xA02A: "HUnlock",
        0xA025: "GetHandleSize",
        0xA024: "SetHandleSize",
        0xA122: "NewHandle",
        0xA11E: "NewPtr",
        0xA01F: "DisposePtr",
        0xA023: "DisposeHandle",
        0xA346: "GetRsrcByName",
        0xA9BC: "TickCount",
        0xA31E: "NewDialog",
        0xA982: "DrawString",
        0xA9ED: "Pack6",  # Int'l utilities
        0xA9EE: "Pack7",  # Binary-decimal conversion
    }
    return trap_names.get(word, f"Unknown A-line 0x{word:04X}")

def find_fp_patterns(data):
    """Find potential floating-point code patterns"""
    patterns = []

    # Look for 68881/68882 FPU opcodes (F-line: 0xFxxx)
    for i in range(0, len(data) - 1, 2):
        word = struct.unpack('>H', data[i:i+2])[0]
        if (word & 0xF000) == 0xF000:
            patterns.append((i, 'F-line', word))

    # Look for SANE setup patterns:
    # Typically: MOVE.W #opcode,-(SP) followed by A9EB
    for i in range(0, len(data) - 5, 2):
        word1 = struct.unpack('>H', data[i:i+2])[0]
        # MOVE.W #imm,-(SP) = 0x3F3C
        if word1 == 0x3F3C:
            if i + 4 < len(data):
                imm = struct.unpack('>H', data[i+2:i+4])[0]
                word2 = struct.unpack('>H', data[i+4:i+6])[0]
                if word2 == 0xA9EB:
                    op_name = {
                        0x0000: "FADD",
                        0x0002: "FSUB",
                        0x0004: "FMUL",
                        0x0006: "FDIV",
                        0x0008: "FCMP",
                        0x000A: "FMOVE",
                        0x000C: "FNEG",
                        0x000E: "FABS",
                        0x0010: "F2X",    # Convert to extended
                        0x0012: "X2F",    # Convert from extended
                    }.get(imm & 0x00FF, f"FP_OP_{imm:04X}")
                    patterns.append((i, 'SANE_call', op_name, imm))

    return patterns

def main():
    print("=== Maven Floating-Point Code Analysis ===\n")

    code_dir = os.path.join(RESOURCES_DIR, "CODE")
    if not os.path.exists(code_dir):
        print(f"CODE directory not found: {code_dir}")
        return

    code_files = sorted([f for f in os.listdir(code_dir)
                        if f.endswith('.bin') and not f.startswith('._')],
                       key=lambda x: int(x.split('_')[0]) if x.split('_')[0].isdigit() else 0)

    total_fp_refs = 0
    total_resource_refs = 0

    for filename in code_files:
        filepath = os.path.join(code_dir, filename)
        data = read_file(filepath)

        code_num = filename.split('_')[0]

        # Find A-line traps
        traps = find_aline_traps(data)

        # Count FP and resource traps
        fp_traps = [(off, t) for off, t in traps if t in (0xA9EB, 0xA9EC)]
        resource_traps = [(off, t) for off, t in traps if t in (0xA9A0, 0xA9A1, 0xA9A2, 0xA9A3)]

        # Find SANE call patterns
        fp_patterns = find_fp_patterns(data)
        sane_calls = [p for p in fp_patterns if p[1] == 'SANE_call']

        if fp_traps or sane_calls:
            print(f"\nCODE {code_num} ({len(data)} bytes):")
            print(f"  FP68K traps: {len(fp_traps)}")
            if sane_calls:
                print(f"  SANE operations found:")
                for pattern in sane_calls[:10]:  # Show first 10
                    offset, ptype, op_name, imm = pattern
                    print(f"    offset 0x{offset:04X}: {op_name}")
                if len(sane_calls) > 10:
                    print(f"    ... and {len(sane_calls) - 10} more")

            total_fp_refs += len(fp_traps) + len(sane_calls)

        if resource_traps:
            total_resource_refs += len(resource_traps)

    print(f"\n{'='*60}")
    print(f"Summary:")
    print(f"  Total FP references: {total_fp_refs}")
    print(f"  Total Resource references: {total_resource_refs}")

    # Now find CODE segments with the most FP activity
    print(f"\n{'='*60}")
    print("CODE segments ranked by FP activity:\n")

    fp_by_segment = []
    for filename in code_files:
        filepath = os.path.join(code_dir, filename)
        data = read_file(filepath)
        code_num = filename.split('_')[0]

        traps = find_aline_traps(data)
        fp_traps = [(off, t) for off, t in traps if t in (0xA9EB, 0xA9EC)]
        sane_calls = [p for p in find_fp_patterns(data) if p[1] == 'SANE_call']

        fp_count = len(fp_traps) + len(sane_calls)
        if fp_count > 0:
            fp_by_segment.append((code_num, fp_count, len(data)))

    fp_by_segment.sort(key=lambda x: x[1], reverse=True)
    for code_num, fp_count, size in fp_by_segment[:15]:
        print(f"  CODE {code_num:3s}: {fp_count:4d} FP refs ({size} bytes)")

if __name__ == "__main__":
    main()
