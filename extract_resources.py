#!/usr/bin/env python3
"""
Extract resources from Maven's .rdump file (DeRez format)
"""
import re
import os
import struct

def parse_rdump(filepath):
    """Parse a ResEdit .rdump file and extract resources"""
    resources = {}

    with open(filepath, 'r') as f:
        content = f.read()

    # Pattern to match resource definitions
    # data 'TYPE' (ID, attributes...) { ... };
    pattern = r"data\s+'([^']+)'\s*\(([^)]+)\)\s*\{([^}]+)\}"

    for match in re.finditer(pattern, content, re.DOTALL):
        res_type = match.group(1)
        res_info = match.group(2)
        res_data = match.group(3)

        # Parse resource ID
        parts = res_info.split(',')
        res_id = int(parts[0].strip())

        # Extract name if present
        name_match = re.search(r'"([^"]*)"', res_info)
        res_name = name_match.group(1) if name_match else None

        # Parse hex data
        hex_pattern = r'\$"([0-9A-Fa-f\s]+)"'
        hex_data = b''
        for hex_match in re.finditer(hex_pattern, res_data):
            hex_str = re.sub(r'\s+', '', hex_match.group(1))
            hex_data += bytes.fromhex(hex_str)

        if res_type not in resources:
            resources[res_type] = {}
        resources[res_type][res_id] = {
            'name': res_name,
            'data': hex_data,
            'info': res_info
        }

    return resources

def save_resources(resources, output_dir):
    """Save extracted resources to files"""
    os.makedirs(output_dir, exist_ok=True)

    for res_type, res_dict in resources.items():
        type_dir = os.path.join(output_dir, res_type.replace(' ', '_'))
        os.makedirs(type_dir, exist_ok=True)

        for res_id, res_data in res_dict.items():
            name = res_data['name'] or str(res_id)
            # Clean filename
            name = re.sub(r'[^\w\-_.]', '_', name)
            # Truncate long names
            if len(name) > 50:
                name = name[:50]
            filename = f"{res_id}_{name}.bin"
            filepath = os.path.join(type_dir, filename)

            with open(filepath, 'wb') as f:
                f.write(res_data['data'])

            print(f"Saved {res_type} {res_id}: {len(res_data['data'])} bytes -> {filepath}")

def main():
    rdump_path = "/Volumes/T7/retrogames/oldmac/share/maven2.1.rdump"
    output_dir = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

    print(f"Parsing {rdump_path}...")
    resources = parse_rdump(rdump_path)

    print(f"\nFound resource types:")
    for res_type, res_dict in sorted(resources.items()):
        total_size = sum(len(r['data']) for r in res_dict.values())
        print(f"  {res_type}: {len(res_dict)} resource(s), {total_size} bytes total")

    print(f"\nSaving to {output_dir}...")
    save_resources(resources, output_dir)

    # Summary of CODE resources
    if 'CODE' in resources:
        print(f"\nCODE resources (executable):")
        for res_id, res_data in sorted(resources['CODE'].items()):
            print(f"  CODE {res_id}: {len(res_data['data'])} bytes")

if __name__ == "__main__":
    main()
