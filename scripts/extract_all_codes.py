#!/usr/bin/env python3
"""
Extract ALL CODE resources from Maven.
"""

import struct
import os

def extract_codes():
    # Read AppleDouble resource fork
    with open('/Volumes/T7/retrogames/oldmac/share/._maven2', 'rb') as f:
        data = f.read()

    # Parse AppleDouble header
    magic = struct.unpack('>I', data[0:4])[0]
    if magic != 0x00051607:
        raise ValueError("Not AppleDouble format")

    num_entries = struct.unpack('>H', data[24:26])[0]

    # Find resource fork entry
    offset = 26
    rsrc_offset = 0
    for i in range(num_entries):
        entry_id = struct.unpack('>I', data[offset:offset+4])[0]
        entry_offset = struct.unpack('>I', data[offset+4:offset+8])[0]
        entry_length = struct.unpack('>I', data[offset+8:offset+12])[0]
        if entry_id == 2:
            rsrc_offset = entry_offset
        offset += 12

    rsrc = data[rsrc_offset:]

    # Parse resource fork
    data_off = struct.unpack('>I', rsrc[0:4])[0]
    map_off = struct.unpack('>I', rsrc[4:8])[0]

    rmap = rsrc[map_off:]
    type_list_off = struct.unpack('>H', rmap[24:26])[0]
    type_list = rmap[type_list_off:]
    num_types = struct.unpack('>H', type_list[0:2])[0] + 1

    # Find CODE type
    off = 2
    code_resources = []
    for i in range(num_types):
        res_type = type_list[off:off+4].decode('macroman', errors='replace')
        num_res = struct.unpack('>H', type_list[off+4:off+6])[0] + 1
        ref_off = struct.unpack('>H', type_list[off+6:off+8])[0]

        if res_type == 'CODE':
            ref_list = type_list[ref_off:]
            for j in range(num_res):
                res_id = struct.unpack('>h', ref_list[j*12:j*12+2])[0]
                data_off_bytes = ref_list[j*12+5:j*12+8]
                res_data_off = (data_off_bytes[0] << 16) | (data_off_bytes[1] << 8) | data_off_bytes[2]
                res_data = rsrc[data_off + res_data_off:]
                res_size = struct.unpack('>I', res_data[0:4])[0]
                code_data = res_data[4:4+res_size]
                code_resources.append((res_id, code_data))
        off += 8

    return code_resources

def main():
    codes = extract_codes()
    codes.sort(key=lambda x: x[0])  # Sort by ID

    output_dir = '/tmp'
    total_size = 0

    print(f"Extracting {len(codes)} CODE resources...")
    for res_id, data in codes:
        output_file = f'{output_dir}/maven_code_{res_id}.bin'
        with open(output_file, 'wb') as f:
            f.write(data)
        print(f"  CODE {res_id:3d}: {len(data):6d} bytes -> {output_file}")
        total_size += len(data)

    print(f"\nTotal: {len(codes)} CODE resources, {total_size} bytes")

    # Also create a summary file
    summary_file = '/Volumes/T7/retrogames/oldmac/maven_re/analysis/code_summary.md'
    with open(summary_file, 'w') as f:
        f.write("# Maven CODE Resources Summary\n\n")
        f.write(f"Total CODE resources: {len(codes)}\n")
        f.write(f"Total code size: {total_size:,} bytes\n\n")
        f.write("| ID | Size (bytes) | Notes |\n")
        f.write("|----|-------------|-------|\n")

        for res_id, data in codes:
            f.write(f"| {res_id} | {len(data):,} | |\n")

    print(f"\nSummary written to: {summary_file}")

if __name__ == '__main__':
    main()
