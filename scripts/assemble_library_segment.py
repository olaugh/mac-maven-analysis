#!/usr/bin/env python3
"""Assemble a fingerprinted library segment using an explicit selection recipe.

Does not read Maven's CODE bytes. The recipe is post-hoc evidence, not an
implementation of the original linker's symbol selection or relocation rules.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys
import struct
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from extract_resources import parse_rdump


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--library',type=Path,required=True)
    p.add_argument('--recipe',type=Path,required=True)
    p.add_argument('--jump-table',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();recipe=json.loads(args.recipe.read_text())
    library=parse_rdump(args.library)['CODE'][recipe['library_code_resource']]['data']
    assert hashlib.sha256(library).hexdigest()==recipe['library_sha256']
    jump=json.loads(args.jump_table.read_text())
    entries=[e for e in jump['entries'] if e['code_resource']==recipe['maven_code_resource']]
    assert entries
    first=entries[0]['index']
    assert [e['index'] for e in entries]==list(range(first,first+len(entries)))
    result=bytearray(struct.pack('>HH',first*8,len(entries)));last=0
    for item in recipe['ranges']:
        start=item['library_start'];length=item['length']
        assert item['maven_start']==len(result)
        assert start>=last and length>0 and start+length<=len(library)
        result.extend(library[start:start+length]);last=start+length
    digest=hashlib.sha256(result).hexdigest()
    assert digest==recipe['expected_output_sha256']
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_bytes(result)
    print(json.dumps(dict(bytes=len(result),sha256=digest,ordered_ranges=len(recipe['ranges']),
                         scope=recipe['scope']),indent=2))


if __name__=='__main__':main()
