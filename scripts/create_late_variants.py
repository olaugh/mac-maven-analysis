#!/usr/bin/env python3
"""Construct separate late-search test saves for held Q and blank boundaries."""
import hashlib,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];directory=root/'../../media/maven/session/share';source=directory/'maven-search-q16';raw=source.read_bytes();assert len(raw)==304 and raw[:4]==bytes.fromhex('0000012c');reports=[]
for name,replacement,make_real_q in [('heldq',('s','q'),False),('heldq-nou',('u','q'),False),('ownblank',('s','?'),True),('poolblank',None,True)]:
 b=bytearray(raw);rack=bytearray(b[4+272:4+280]);assert rack==b'bcinrsu\0'
 if replacement:rack[rack.index(ord(replacement[0]))]=ord(replacement[1]);rack[:7]=bytes(sorted(rack[:7]));b[4+272:4+280]=rack
 if make_real_q:b[4+296:4+300]=bytes([8,6,0,0])
 out=directory/('maven-search-'+name);assert not out.exists();out.write_bytes(b);out.with_name(out.name+'.idump').write_bytes(source.with_name(source.name+'.idump').read_bytes());reports.append(dict(name=out.name,sha256=hashlib.sha256(b).hexdigest(),rack=rack[:-1].decode(),make_board_q_7_7_real=make_real_q,rack_replacement=replacement))
(root/'analysis/toolchain/late-variant-fixtures.json').write_text(json.dumps(dict(scope=__doc__,synthetic_position=True,source_sha256=hashlib.sha256(raw).hexdigest(),variants=reports),indent=2)+'\n');print(json.dumps(reports,indent=2))
