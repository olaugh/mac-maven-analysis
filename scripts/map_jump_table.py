#!/usr/bin/env python3
"""Map every CODE 0 entry to validated resource-relative entry coordinates."""
import argparse
import hashlib
import json
import struct
from pathlib import Path


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--code-dir', type=Path, default=Path('resources/CODE'))
    args = p.parse_args()
    code0 = (args.code_dir/'0_0.bin').read_bytes()
    above, below, size, offset = struct.unpack_from('>4I', code0)
    assert size % 8 == 0 and len(code0) == size + 16
    rows = []
    for index in range(size//8):
        entry, push, segment, trap = struct.unpack_from('>4H',code0,16+8*index)
        assert push == 0x3f3c and trap == 0xa9f0
        code = (args.code_dir/f'{segment}_{segment}.bin').read_bytes()
        resource_offset = entry + 4  # Segment header is excluded by the loader's offset.
        assert resource_offset < len(code)
        rows.append(dict(index=index, a5_record_offset=offset+index*8,
                         a5_callable_offset=offset+index*8+2,
                         code_resource=segment, resource_offset=resource_offset,
                         entry_prefix_hex=code[resource_offset:resource_offset+16].hex()))
    print(json.dumps(dict(code0_sha256=hashlib.sha256(code0).hexdigest(),
                          above_a5=above,below_a5=below,entries=rows),indent=2))


if __name__ == '__main__':
    main()
