#!/usr/bin/env python3
"""
Extract CODE resources from Mac resource fork
"""

import struct

RSRC_PATH = '/tmp/maven2_rsrc.bin'

with open(RSRC_PATH, 'rb') as f:
    data = f.read()

print("=" * 60)
print("Mac Resource Fork Parser")
print("=" * 60)

# Resource fork header (256 bytes)
# Offset 0: Data offset (4 bytes)
# Offset 4: Map offset (4 bytes)
# Offset 8: Data length (4 bytes)
# Offset 12: Map length (4 bytes)

data_offset = struct.unpack('>I', data[0:4])[0]
map_offset = struct.unpack('>I', data[4:8])[0]
data_length = struct.unpack('>I', data[8:12])[0]
map_length = struct.unpack('>I', data[12:16])[0]

print(f"Data offset: 0x{data_offset:x}")
print(f"Map offset: 0x{map_offset:x}")
print(f"Data length: {data_length}")
print(f"Map length: {map_length}")

# Resource map structure (at map_offset)
# +0: Copy of resource header (16 bytes)
# +16: Handle to next resource map (4 bytes)
# +20: File reference number (2 bytes)
# +22: Resource fork attributes (2 bytes)
# +24: Offset from map start to type list (2 bytes)
# +26: Offset from map start to name list (2 bytes)
# +28: Number of types minus 1 (2 bytes)
# Then type list starts

map_data = data[map_offset:]
type_list_offset = struct.unpack('>H', map_data[24:26])[0]
name_list_offset = struct.unpack('>H', map_data[26:28])[0]
num_types = struct.unpack('>H', map_data[28:30])[0] + 1

print(f"\nType list offset: {type_list_offset}")
print(f"Name list offset: {name_list_offset}")
print(f"Number of types: {num_types}")

# Type list entry structure (8 bytes each):
# +0: Type (4 bytes, e.g., 'CODE')
# +4: Number of resources of this type minus 1 (2 bytes)
# +6: Offset from type list start to reference list (2 bytes)

print("\n--- Resource Types ---")
type_list = map_data[type_list_offset:]
code_resources = []

for i in range(num_types):
    entry_offset = i * 8
    res_type = type_list[entry_offset:entry_offset+4].decode('ascii', errors='replace')
    num_resources = struct.unpack('>H', type_list[entry_offset+4:entry_offset+6])[0] + 1
    ref_offset = struct.unpack('>H', type_list[entry_offset+6:entry_offset+8])[0]

    print(f"  Type '{res_type}': {num_resources} resources, ref at offset {ref_offset}")

    if res_type == 'CODE':
        # Parse reference list for CODE resources
        # Reference list entry (12 bytes each):
        # +0: Resource ID (2 bytes)
        # +2: Offset from name list to name (2 bytes), or -1 if no name
        # +4: Resource attributes (1 byte)
        # +5: Offset from data start to data (3 bytes)
        # +8: Handle (4 bytes, reserved)

        ref_list = type_list[ref_offset:]
        for j in range(num_resources):
            ref_entry = ref_list[j*12:(j+1)*12]
            res_id = struct.unpack('>H', ref_entry[0:2])[0]
            name_offset = struct.unpack('>h', ref_entry[2:4])[0]  # signed
            res_attr = ref_entry[4]
            data_off = struct.unpack('>I', b'\x00' + ref_entry[5:8])[0]  # 3 bytes

            # Get actual data
            actual_data_offset = data_offset + data_off
            res_length = struct.unpack('>I', data[actual_data_offset:actual_data_offset+4])[0]
            res_data = data[actual_data_offset+4:actual_data_offset+4+res_length]

            code_resources.append((res_id, res_length, res_data))
            print(f"    CODE {res_id}: {res_length} bytes at 0x{actual_data_offset:x}")

print("\n" + "=" * 60)
print("CODE Resources Analysis")
print("=" * 60)

# Save CODE resources
for res_id, res_length, res_data in code_resources:
    output_path = f'/tmp/maven_code_{res_id}.bin'
    with open(output_path, 'wb') as f:
        f.write(res_data)
    print(f"Saved CODE {res_id} ({res_length} bytes) to {output_path}")

# Look for patterns related to DAWG/dictionary access in CODE segments
print("\n--- Searching for DAWG-related patterns ---")

for res_id, res_length, res_data in code_resources:
    # Search for the letter index offset (0x0010)
    if b'\x00\x10' in res_data:
        pos = res_data.find(b'\x00\x10')
        print(f"CODE {res_id}: Found 0x0010 at offset 0x{pos:x}")

    # Search for the node base offset (0x0410)
    if b'\x04\x10' in res_data:
        pos = res_data.find(b'\x04\x10')
        print(f"CODE {res_id}: Found 0x0410 at offset 0x{pos:x}")

    # Search for 56630 (0xDD36) - first DAWG size
    if b'\xdd\x36' in res_data:
        pos = res_data.find(b'\xdd\x36')
        print(f"CODE {res_id}: Found 0xDD36 (56630) at offset 0x{pos:x}")
