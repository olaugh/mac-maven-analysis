#!/usr/bin/env python3
"""Rebuild the observed MacTraps segment from names and library metadata.

Models ordered selection of symbol intervals only. Does not implement general
THINK linking, references, relocations, or dependency closure. No Maven code or
byte-range recipe is read. The selected names were recovered from Maven.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
from map_mactraps_symbols import decode


def link(library, selection, jump_table):
    units, symbols, code = decode(library)
    assert hashlib.sha256(code).hexdigest() == selection['library_sha256']
    selected = []
    for name in selection['symbols']:
        symbol, = [s for s in symbols if s['name'] == name and 'code_offset' in s]
        selected.append(symbol)
    assert len({s['code_offset'] for s in selected}) == len(selected)
    entries = [e for e in jump_table['entries'] if e['code_resource'] == selection['code_resource']]
    first = entries[0]['index']
    assert [e['index'] for e in entries] == list(range(first, first + len(entries)))
    assert len(entries) == len(selected)
    result = bytearray(struct.pack('>HH', first * 8, len(entries)))
    placements = []
    for symbol in sorted(selected, key=lambda s: s['code_offset']):
        unit = units[symbol['unit']]
        start = symbol['code_offset']
        end = min([s['code_offset'] for s in symbols if s['unit'] == symbol['unit']
                   and s.get('code_offset', -1) > start]
                  + [unit['code_offset'] + unit['code_size']])
        placements.append(dict(name=symbol['name'], output_offset=len(result),
                               library_offset=start, length=end-start))
        result.extend(code[start:end])
    # Validate placement independently of byte-content validation.
    assert sorted(p['output_offset'] for p in placements) == sorted(e['resource_offset'] for e in entries)
    digest = hashlib.sha256(result).hexdigest()
    assert digest == selection['expected_output_sha256']
    return bytes(result), dict(bytes=len(result), sha256=digest, placements=placements,
                              scope=__doc__.strip())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--library', type=Path, required=True)
    parser.add_argument('--selection', type=Path, required=True)
    parser.add_argument('--jump-table', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    result, report = link(args.library, json.loads(args.selection.read_text()),
                          json.loads(args.jump_table.read_text()))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(result)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
