#!/usr/bin/env python3
"""Map exact ordered byte blocks between Maven CODE 34 and THINK MacTraps.

This measures byte correspondence, not semantic reconstruction completeness.
"""
import argparse
from difflib import SequenceMatcher
import hashlib
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from extract_resources import parse_rdump


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--library',type=Path,required=True)
    args=parser.parse_args()
    root=Path(__file__).resolve().parents[1]
    maven=(root/'resources/CODE/34_34.bin').read_bytes()
    library=parse_rdump(args.library)['CODE'][2]['data']
    blocks=[];covered=set()
    for a,b,n in SequenceMatcher(None,maven,library,autojunk=False).get_matching_blocks():
        if n<16 or a<4:continue
        assert maven[a:a+n]==library[b:b+n]
        blocks.append(dict(maven_start=a,library_start=b,length=n))
        covered.update(range(a,a+n))
    gaps=[];pos=4
    while pos<len(maven):
        if pos in covered:pos+=1;continue
        start=pos
        while pos<len(maven) and pos not in covered:pos+=1
        needle=maven[start:pos]
        occurrences=[i for i in range(len(library)-len(needle)+1)
                     if library[i:i+len(needle)]==needle]
        gaps.append(dict(start=start,end=pos,bytes_hex=needle.hex(),
                         short_exact_occurrences=occurrences))
    print(json.dumps(dict(maven_code_resource=34,maven_sha256=hashlib.sha256(maven).hexdigest(),
                         library_code_resource=2,library_sha256=hashlib.sha256(library).hexdigest(),
                         library_rdump_sha256=hashlib.sha256(args.library.read_bytes()).hexdigest(),
                         minimum_block_bytes=16,exact_bytes=len(covered),bytes_after_header=len(maven)-4,
                         blocks=blocks,gaps=gaps,
                         scope='Ordered exact byte correspondence. Gaps are not automatically relocations; no unique release or decompilation-completeness claim'),indent=2))


if __name__=='__main__':main()
