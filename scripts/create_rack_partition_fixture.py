#!/usr/bin/env python3
"""Repartition existing rack tiles in a new disposable test save, preserving board and bag.

This constructs a test fixture, not a naturally played position. The original
save and metadata are never overwritten. Load and search via ordinary Mac UI.
"""
import argparse
from collections import Counter
import hashlib,json
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source',required=True);p.add_argument('--name',required=True);p.add_argument('--own',required=True);p.add_argument('--other',required=True);a=p.parse_args()
root=Path(__file__).resolve().parents[1];share=root/'../../media/maven/session/share'
assert all('/' not in x and x.startswith('maven-search-') for x in [a.source,a.name])
source=share/a.source;raw=bytearray(source.read_bytes());before=[bytes(raw[i:i+8]).split(b'\0')[0] for i in (276,284)]
own=a.own.encode('ascii');other=a.other.encode('ascii');assert len(own)<=7 and len(other)<=7
assert Counter(own+other)==Counter(b''.join(before))
for offset,rack in [(276,own),(284,other)]:raw[offset:offset+8]=(rack+b'\0').ljust(8,b'\0')
out=share/a.name;assert not out.exists();metadata=out.with_name(out.name+'.idump');assert not metadata.exists()
out.write_bytes(raw);metadata.write_bytes(source.with_name(source.name+'.idump').read_bytes())
report=dict(scope=__doc__,source=a.source,name=a.name,source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),sha256=hashlib.sha256(raw).hexdigest(),own=a.own,other=a.other,synthetic_position=True)
(root/'analysis/toolchain'/f'{a.name}-fixture.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
