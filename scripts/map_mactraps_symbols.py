#!/usr/bin/env python3
"""Decode observed THINK MacTraps project fields and label Maven CODE 34.

This is a decoder for the recovered library, not a general THINK project parser.
Unknown fields are deliberately left uninterpreted.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from extract_resources import parse_rdump


def u16(data, offset):
    assert 0 <= offset <= len(data) - 2
    return int.from_bytes(data[offset:offset + 2], 'big')


def u32(data, offset):
    assert 0 <= offset <= len(data) - 4
    return int.from_bytes(data[offset:offset + 4], 'big')


def decode(path):
    resources = parse_rdump(path)
    zone = resources['ZONE'][0]['data']
    index = resources['INDX'][0]['data']
    symbols = resources['SYMS'][0]['data']
    jumps = resources['CODE'][0]['data']
    code = resources['CODE'][2]['data']
    base = u32(zone, 0)

    def object_at(handle):
        offset = u32(zone, handle * 4) - base
        assert 0 <= offset < len(zone)
        return offset

    def name_at(offset):
        length = zone[offset]
        assert offset + 1 + length <= len(zone)
        return zone[offset + 1:offset + 1 + length].decode('mac_roman')

    assert len(index) % 64 == 0 and len(symbols) % 14 == 0
    units = []
    for pos in range(0, len(index), 64):
        units.append(dict(index=pos // 64,
                          name=name_at(object_at(u32(index, pos)) + 47),
                          jump_table_offset=u32(index, pos + 4),
                          symbols_offset=u32(index, pos + 20),
                          code_offset=u32(index, pos + 24),
                          symbols_size=u16(index, pos + 48),
                          code_size=u16(index, pos + 50)))
    decoded = []
    for pos in range(0, len(symbols), 14):
        obj = object_at(u32(symbols, pos))
        unit = units[u16(zone, obj + 4)]
        assert unit['symbols_offset'] + u32(zone, obj + 6) == pos
        assert unit['symbols_offset'] <= pos < unit['symbols_offset'] + unit['symbols_size']
        assert u16(symbols, pos + 10) == u16(zone, obj + 10)
        if u16(symbols, pos + 10) == 0:
            assert u16(symbols, pos + 12) == u32(zone, obj + 14)
            decoded.append(dict(name=name_at(obj + 26), unit=unit['index'],
                                data_offset=u16(symbols, pos + 12), zone_offset=obj,
                                symbol_record_offset=pos))
            continue
        assert u16(symbols, pos + 10) == 1
        slot = u16(symbols, pos + 12) - 2
        assert slot >= 0 and slot % 8 == 0
        assert slot == u32(zone, obj + 14) - 2
        jump = unit['jump_table_offset'] + slot
        address = unit['code_offset'] + u16(jumps, jump)
        assert unit['code_offset'] <= address <= unit['code_offset'] + unit['code_size']
        decoded.append(dict(name=name_at(obj + 26), unit=unit['index'],
                            code_offset=address, zone_offset=obj,
                            symbol_record_offset=pos, jump_record_offset=jump))
    return units, decoded, code


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--library', type=Path, required=True)
    args = parser.parse_args()
    units, symbols, code = decode(args.library)
    recipe = json.loads((ROOT / 'analysis/toolchain/code34-library-recipe.json').read_text())
    assert hashlib.sha256(code).hexdigest() == recipe['library_sha256']
    maven = (ROOT / 'resources/CODE/34_34.bin').read_bytes()
    entries = json.loads((ROOT / 'analysis/toolchain/jump-table.json').read_text())['entries']
    mapped = []
    starts = sorted(e['resource_offset'] for e in entries if e['code_resource'] == 34)
    for entry in entries:
        if entry['code_resource'] != 34:
            continue
        address = entry['resource_offset']
        end = min([p for p in starts if p > address] + [len(maven)])
        matches = [s for s in symbols if 'code_offset' in s and
                   code[s['code_offset']:s['code_offset'] + end - address] == maven[address:end]]
        assert matches, address
        library_address, = {s['code_offset'] for s in matches}
        names = [s['name'] for s in matches]
        unit = units[matches[0]['unit']]
        library_end = min([s['code_offset'] for s in symbols
                           if s['unit'] == unit['index'] and s.get('code_offset', -1) > library_address]
                          + [unit['code_offset'] + unit['code_size']])
        assert library_end - library_address == end - address
        mapped.append(dict(maven_offset=address, a5_callable_offset=entry['a5_callable_offset'],
                           library_offset=library_address, length=end-address, names=names))
    print(json.dumps(dict(scope='Every Maven entry-to-next-entry interval matches a full library symbol-to-next-symbol interval. Aliases remain ambiguous. Not an independently reproduced linker.',
                          library_sha256=hashlib.sha256(code).hexdigest(),
                          units=units, symbols=symbols, maven_code34_entries=mapped), indent=2))


if __name__ == '__main__':
    main()
