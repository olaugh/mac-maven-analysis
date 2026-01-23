#!/usr/bin/env python3
"""
Find resource loading patterns in Maven CODE resources.
Looking for where MUL and EXPR resources are loaded.

Resource type codes (big-endian ASCII):
- 'MULa' = 0x4D554C61
- 'MUL?' = 0x4D554C3F
- 'EXPR' = 0x45585052
- 'ESTR' = 0x45535452

The GetResource trap (A9A0) typically has the resource type pushed as a long,
followed by the resource ID as a word.
"""
import os
import struct

RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def ascii_to_hex(s):
    """Convert 4-char ASCII to hex"""
    return ''.join(f'{ord(c):02X}' for c in s)

def find_resource_type_patterns(data, res_types):
    """Find resource type patterns in code"""
    found = []

    for res_type in res_types:
        # Convert to bytes (big-endian)
        type_bytes = res_type.encode('ascii')
        type_val = struct.unpack('>I', type_bytes)[0]

        # Search for the type as a 32-bit value
        for i in range(len(data) - 4):
            val = struct.unpack('>I', data[i:i+4])[0]
            if val == type_val:
                # Check context - might be MOVE.L #type instruction or data
                if i >= 2:
                    prev_word = struct.unpack('>H', data[i-2:i])[0]
                    # MOVE.L #imm,-(SP) = 2F3C or similar
                    if prev_word == 0x2F3C:
                        found.append((i-2, res_type, 'MOVE.L #type,-(SP)', i))
                    else:
                        found.append((i, res_type, 'data reference', i))
                else:
                    found.append((i, res_type, 'data reference', i))

    return found

def find_getresource_patterns(data):
    """Find GetResource (A9A0) calls and their parameters"""
    calls = []

    for i in range(len(data) - 10):
        word = struct.unpack('>H', data[i:i+2])[0]
        if word == 0xA9A0:  # GetResource
            # Look backwards for the resource type
            # Pattern: MOVE.L #type,-(SP); MOVE.W #id,-(SP); A9A0

            # Find the type (should be 6-10 bytes before)
            for back in range(6, 20, 2):
                if i - back >= 2:
                    prev = struct.unpack('>H', data[i-back:i-back+2])[0]
                    if prev == 0x2F3C:  # MOVE.L #imm,-(SP)
                        type_val = struct.unpack('>I', data[i-back+2:i-back+6])[0]
                        try:
                            type_str = struct.pack('>I', type_val).decode('ascii')
                            # Check if it's a valid resource type (printable ASCII)
                            if all(32 <= ord(c) <= 126 for c in type_str):
                                calls.append((i, type_str, i-back))
                                break
                        except:
                            pass

    return calls

def main():
    print("=== Resource Loading Pattern Analysis ===\n")

    code_dir = os.path.join(RESOURCES_DIR, "CODE")
    if not os.path.exists(code_dir):
        print(f"CODE directory not found")
        return

    # Resource types we're looking for
    res_types = ['MULa', 'MULb', 'MULc', 'MULd', 'MULe', 'MULi', 'MULo',
                 'MULs', 'MULt', 'MUL?', 'EXPR', 'ESTR', 'DAWG', 'DICT',
                 'HIST', 'CFIG', 'VCBa', 'VCBe']

    print("Looking for resource type patterns:")
    for rt in res_types[:10]:
        hex_val = ascii_to_hex(rt)
        print(f"  '{rt}' = 0x{hex_val}")
    print()

    code_files = sorted([f for f in os.listdir(code_dir)
                        if f.endswith('.bin') and not f.startswith('._')],
                       key=lambda x: int(x.split('_')[0]) if x.split('_')[0].isdigit() else 0)

    all_found = []

    for filename in code_files:
        filepath = os.path.join(code_dir, filename)
        data = read_file(filepath)
        code_num = filename.split('_')[0]

        # Find GetResource calls
        calls = find_getresource_patterns(data)
        if calls:
            print(f"\nCODE {code_num}:")
            for offset, res_type, type_offset in calls:
                print(f"  GetResource at 0x{offset:04X}: type='{res_type}'")
                all_found.append((code_num, offset, res_type))

        # Also find direct type references
        type_refs = find_resource_type_patterns(data, res_types)
        for offset, res_type, context, type_off in type_refs:
            if not any(a[2] == res_type and a[0] == code_num for a in all_found):
                print(f"  Type ref at 0x{offset:04X}: '{res_type}' ({context})")
                all_found.append((code_num, offset, res_type))

    print("\n" + "="*60)
    print("Summary of resource type references:")
    print("="*60)

    # Group by resource type
    by_type = {}
    for code_num, offset, res_type in all_found:
        if res_type not in by_type:
            by_type[res_type] = []
        by_type[res_type].append((code_num, offset))

    for res_type in sorted(by_type.keys()):
        refs = by_type[res_type]
        print(f"\n'{res_type}': {len(refs)} references")
        for code_num, offset in refs[:5]:
            print(f"    CODE {code_num} at 0x{offset:04X}")
        if len(refs) > 5:
            print(f"    ... and {len(refs)-5} more")

if __name__ == "__main__":
    main()
