#!/usr/bin/env python3
"""Extract inline setjmp/longjmp bytes from recovered headers; search Maven."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--header',type=Path,required=True)
    p.add_argument('--code-dir',type=Path,default=Path('resources/CODE'))
    args=p.parse_args()
    original=args.header.read_bytes()
    text=re.sub(r'/\*.*?\*/','',original.decode('mac_roman'),flags=re.S)
    arrays=re.findall(r'\b(?:int|void)\s+(setjmp|longjmp)\([^;{}]*\)\s*=\s*\{([^}]+)\}',text,re.S)
    assert [name for name,body in arrays]==['setjmp','setjmp','longjmp','longjmp']
    # Labels correspond to the explicitly inspected preprocessor branches in
    # this distribution's header. Preserve its hash to identify that evidence.
    labels=['setjmp_without_mc68881','setjmp_with_mc68881',
            'longjmp_without_int_4','longjmp_with_int_4']
    results=[]
    for label,(name,body) in zip(labels,arrays):
        words=[int(x,16) for x in re.findall(r'0x([0-9a-fA-F]+)',body)]
        needle=struct.pack('>'+str(len(words))+'H',*words)
        hits=[]
        for file in sorted(args.code_dir.glob('*.bin')):
            data=file.read_bytes()
            for offset in range(4,len(data)-len(needle)+1,2):
                if data[offset:offset+len(needle)]==needle:
                    hits.append(dict(code_resource=int(file.stem.split('_')[0]),
                                     resource_offset=offset,
                                     code_sha256=hashlib.sha256(data).hexdigest()))
        results.append(dict(header_branch=label,bytes_hex=needle.hex(),matches=hits))
    print(json.dumps(dict(header_sha256=hashlib.sha256(original).hexdigest(),
                         scope='Exact aligned instruction bytes, not unique version attribution',
                         fingerprints=results),indent=2))


if __name__=='__main__':
    main()
