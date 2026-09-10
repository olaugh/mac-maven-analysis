#!/usr/bin/env python3
"""Compare a saved Maven character table with recovered THINK library sources.

Uses a saved RAM snapshot, not a live debugger session. Requires complete
loaded CODE 23 and CODE 52 identities before attributing its table to Maven.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re


def digest(data):
    return hashlib.sha256(data).hexdigest()


def source_table(path):
    source = path.read_bytes().decode('mac_roman')
    body = source.split('char __ctype[256] = {', 1)[1].split('}', 1)[0]
    values = dict(__CNTL=1, __WHIT=2, __SPAC=4, __PUNC=8, __DIGT=16,
                  __XDIG=32, __UPPR=64, __LOWR=128, __UPPX=96, __LOWX=160)
    tokens = re.findall(r'__[A-Z]+', body)
    assert len(tokens) == 128
    return bytes(values[token] for token in tokens) + bytes(128)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--snapshot', type=Path, required=True)
    parser.add_argument('--toolchains', type=Path, required=True)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    ram = args.snapshot.read_bytes()
    a5 = int.from_bytes(ram[0x904:0x908], 'big')
    assert 0x428 <= a5 <= len(ram)-4
    identities = []
    for rid in (23, 52):
        data = next((root/'resources/CODE').glob(f'{rid}_*.bin')).read_bytes()
        address = ram.find(data)
        assert address >= 0, f'Complete CODE {rid} absent'
        identities.append(dict(resource=rid, address=address, sha256=digest(data)))
    table = ram[a5-0x428:a5-0x328]
    comparisons = []
    for version, relative in [('5', 'installed/C Libraries/sources/ctype.c'),
                              ('6', 'installed/THINK C/Standard Libraries/C sources/ctype.c')]:
        path = args.toolchains/f'think-c-{version}'/relative
        expected = source_table(path)
        assert expected == table
        comparisons.append(dict(distribution=f'THINK C {version}',
                                source_sha256=digest(path.read_bytes()),
                                all_256_bytes_match=True))
    print(json.dumps(dict(scope='Saved snapshot table and static code identity; no natural call trace or unique compiler-version identification.',
                          snapshot_sha256=digest(ram), a5=a5,
                          table_a5_offset=-0x428, table_hex=table.hex(),
                          table_sha256=digest(table), code_identities=identities,
                          uppercase_bytes=[i for i,v in enumerate(table) if v & 64],
                          comparisons=comparisons), indent=2))


if __name__ == '__main__':
    main()
