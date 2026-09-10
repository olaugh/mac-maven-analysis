#!/usr/bin/env python3
"""Read immutable late-search constants and a complete CODE35 identity difference report."""
import hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
command('stop');r=Remote();r.sock.settimeout(60)
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def long(addr):return int.from_bytes(read(addr,4),'big')
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa';a5=long(0x904);g=struct.unpack('>18I',bytes.fromhex(r.command('g')))
 def text(pointer):return read(pointer,128).split(b'\0')[0].decode('ascii')
 j=dict(a5=a5,pc=g[17],priority_order=text(long(a5-0x8da)),held_u_query=text(long(a5-0x6c40)),blank_query=text(long(a5-0x6c3c)),memory_estimates=read(a5-0x8aa,18*6).hex())
 stub=read(a5+0x9da,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0xa48;source=Path('resources/CODE/35_35.bin').read_bytes();actual=read(base+4,len(source)-4);diffs=[i+4 for i,(x,y) in enumerate(zip(source[4:],actual)) if x!=y];runs=[]
 for i in diffs:
  if runs and i==runs[-1][-1]+1:runs[-1].append(i)
  else:runs.append([i])
 j['code35']=dict(source_sha256=hashlib.sha256(source).hexdigest(),runtime_body_sha256=hashlib.sha256(actual).hexdigest(),differences=[dict(offset=run[0],source=source[run[0]:run[-1]+1].hex(),runtime=actual[run[0]-4:run[-1]-3].hex()) for run in runs],matcher_exact=actual[0xa48-4:0xcd0-4]==source[0xa48:0xcd0])
 Path('analysis/toolchain/late-constants-live.json').write_text(json.dumps(j,indent=2)+'\n');print(json.dumps(j,indent=2))
finally:r.close()
