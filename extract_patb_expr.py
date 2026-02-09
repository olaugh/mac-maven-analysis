#!/usr/bin/env python3
"""Extract PATB and EXPR resources from Mac resource fork."""

import struct
import os

RSRC_FILE = "/Volumes/T7/retrogames/oldmac/maven_re/traces/memory_dumps/maven2_rsrc.bin"
PATB_OUT = "/Volumes/T7/retrogames/oldmac/maven_re/resources/PATB/0_entries.bin"
EXPR_OUT = "/Volumes/T7/retrogames/oldmac/maven_re/resources/EXPR/0_full.bin"

with open(RSRC_FILE, "rb") as f:
    data = f.read()

print(f"Resource fork size: {len(data)} bytes")

# Parse resource fork header
data_offset = struct.unpack(">I", data[0:4])[0]
map_offset = struct.unpack(">I", data[4:8])[0]
data_length = struct.unpack(">I", data[8:12])[0]
map_length = struct.unpack(">I", data[12:16])[0]

print(f"Data offset: {data_offset}")
print(f"Map offset: {map_offset}")
print(f"Data length: {data_length}")
print(f"Map length: {map_length}")

# Parse resource map
# map_offset+24 = type list offset (relative to map)
# map_offset+26 = name list offset (relative to map)
type_list_offset_rel = struct.unpack(">H", data[map_offset + 24 : map_offset + 26])[0]
name_list_offset_rel = struct.unpack(">H", data[map_offset + 26 : map_offset + 28])[0]

type_list_abs = map_offset + type_list_offset_rel
print(f"\nType list at absolute offset: {type_list_abs}")

# Type list: first 2 bytes = count-1
num_types_minus1 = struct.unpack(">H", data[type_list_abs : type_list_abs + 2])[0]
num_types = num_types_minus1 + 1
print(f"Number of resource types: {num_types}")

# Iterate type entries
targets = {b"PATB": None, b"EXPR": None}
pos = type_list_abs + 2

for i in range(num_types):
    res_type = data[pos : pos + 4]
    res_count_minus1 = struct.unpack(">H", data[pos + 4 : pos + 6])[0]
    ref_list_offset_rel = struct.unpack(">H", data[pos + 6 : pos + 8])[0]
    res_count = res_count_minus1 + 1

    if res_type in targets:
        print(f"\nFound type '{res_type.decode()}': {res_count} resource(s), ref_list_offset={ref_list_offset_rel}")
        # ref_list_offset is relative to type list start
        ref_list_abs = type_list_abs + ref_list_offset_rel

        for j in range(res_count):
            ref_pos = ref_list_abs + j * 12
            res_id = struct.unpack(">H", data[ref_pos : ref_pos + 2])[0]
            res_name_offset = struct.unpack(">h", data[ref_pos + 2 : ref_pos + 4])[0]
            res_attrs = data[ref_pos + 4]
            # 3-byte data offset (relative to resource data start)
            res_data_offset = (data[ref_pos + 5] << 16) | (data[ref_pos + 6] << 8) | data[ref_pos + 7]

            # Read resource data: first 4 bytes = length, then data
            abs_data_pos = data_offset + res_data_offset
            res_length = struct.unpack(">I", data[abs_data_pos : abs_data_pos + 4])[0]
            res_data = data[abs_data_pos + 4 : abs_data_pos + 4 + res_length]

            print(f"  Resource ID={res_id}, attrs=0x{res_attrs:02X}, data_offset={res_data_offset}, length={res_length}")

            if res_type == b"PATB":
                targets[b"PATB"] = res_data
            elif res_type == b"EXPR":
                # Keep the largest EXPR if there are multiple
                if targets[b"EXPR"] is None or len(res_data) > len(targets[b"EXPR"]):
                    targets[b"EXPR"] = res_data

    pos += 8

# Save PATB
if targets[b"PATB"] is not None:
    patb_data = targets[b"PATB"]
    os.makedirs(os.path.dirname(PATB_OUT), exist_ok=True)
    with open(PATB_OUT, "wb") as f:
        f.write(patb_data)
    print(f"\nPATB saved to {PATB_OUT}")
    print(f"PATB size: {len(patb_data)} bytes")
    print(f"PATB entries (size/8): {len(patb_data) // 8}")

    # Hex dump first 128 bytes
    print(f"\nFirst 128 bytes of PATB (hex dump):")
    dump_len = min(128, len(patb_data))
    for offset in range(0, dump_len, 16):
        hex_bytes = " ".join(f"{patb_data[offset + i]:02X}" if offset + i < dump_len else "  "
                             for i in range(16))
        ascii_chars = "".join(
            chr(patb_data[offset + i]) if 32 <= patb_data[offset + i] < 127 else "."
            for i in range(16) if offset + i < dump_len
        )
        print(f"  {offset:04X}: {hex_bytes}  {ascii_chars}")
else:
    print("\nPATB resource NOT found!")

# Save EXPR
if targets[b"EXPR"] is not None:
    expr_data = targets[b"EXPR"]
    os.makedirs(os.path.dirname(EXPR_OUT), exist_ok=True)
    with open(EXPR_OUT, "wb") as f:
        f.write(expr_data)
    print(f"\nEXPR saved to {EXPR_OUT}")
    print(f"EXPR size: {len(expr_data)} bytes")
else:
    print("\nEXPR resource NOT found!")
