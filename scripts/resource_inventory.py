#!/usr/bin/env python3
"""Inventory a native Mac resource fork; offsets refer to that fork, not RAM."""
import argparse
import hashlib
import json
import struct
from pathlib import Path


def resources(blob):
    def u16(off):
        return struct.unpack_from('>H', blob, off)[0]

    data, rmap, data_len, map_len = struct.unpack_from('>4I', blob)
    if data + data_len > len(blob) or rmap + map_len > len(blob):
        raise ValueError('resource fork bounds are invalid')
    types = rmap + u16(rmap + 24)
    names = rmap + u16(rmap + 26)
    for t in range(u16(types) + 1):
        entry = types + 2 + t * 8
        kind = blob[entry:entry + 4].decode('mac_roman')
        refs = types + u16(entry + 6)
        for n in range(u16(entry + 4) + 1):
            ref = refs + n * 12
            rid = struct.unpack_from('>h', blob, ref)[0]
            name_off = u16(ref + 2)
            name = None
            if name_off != 0xffff:
                p = names + name_off
                name = blob[p + 1:p + 1 + blob[p]].decode('mac_roman')
            p = data + int.from_bytes(blob[ref + 5:ref + 8], 'big')
            length = struct.unpack_from('>I', blob, p)[0]
            if not data <= p < p + 4 + length <= data + data_len:
                raise ValueError(f'invalid bounds: {kind} {rid}')
            yield kind, rid, name, blob[ref + 4], p + 4, blob[p + 4:p + 4 + length]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('application', type=Path)
    parser.add_argument('--compare', type=Path, help='existing extracted resources directory')
    args = parser.parse_args()
    fork = Path(str(args.application) + '/..namedfork/rsrc').read_bytes()
    rows = []
    for kind, rid, name, attrs, off, payload in resources(fork):
        row = dict(type=kind, id=rid, name=name, attributes=attrs, offset=off,
                   size=len(payload), sha256=hashlib.sha256(payload).hexdigest())
        if args.compare and kind == 'CODE':
            old = args.compare / 'CODE' / f'{rid}_{rid}.bin'
            row['matches_existing_extraction'] = old.exists() and old.read_bytes() == payload
        if kind == 'CODE' and rid == 0:
            row['a5_above_below_jt_size_offset'] = struct.unpack_from('>4I', payload)
        if kind in ('ZERO', 'DREL', 'DATA', 'CODE') and rid == 0:
            row['prefix_hex'] = payload[:32].hex()
        rows.append(row)
    print(json.dumps(dict(application=str(args.application.resolve()),
                         data_sha256=hashlib.sha256(args.application.read_bytes()).hexdigest(),
                         resource_sha256=hashlib.sha256(fork).hexdigest(), resources=rows), indent=2))


if __name__ == '__main__':
    main()
