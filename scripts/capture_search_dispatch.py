#!/usr/bin/env python3
"""Observe the next naturally entered heuristic, late-game, or endgame search."""
import argparse,hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--endgame-only',action='store_true');a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=int.from_bytes(read(0x904,4),'big');entries={a5+0x852:(28,0x11a),a5+0x89a:(30,0x14e),a5+0x9fa:(36,0x6de),a5+0xa0a:(36,0x113a),a5+0xa1a:(36,0x1810)}
 if a.endgame_only:entries={a5+0x89a:(30,0x14e)}
 for slot in entries:arm(slot)
 print('Waiting for any original search dispatch',flush=True);r.command('c');slot=regs()[17];assert slot in entries;clear();rid,offset=entries[slot];stub=read(slot,6)
 if stub==struct.pack('>3H',0x3f3c,rid,0xa9f0):
  r.command('s');r.command('s');arm(slot);r.command('c');assert regs()[17]==slot;clear();stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-offset;code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 arm(base+offset);r.command('c');assert regs()[17]==base+offset;clear()
 report=dict(code_resource=rid,offset=offset,a5=a5,base=base,code_sha256=hashlib.sha256(code).hexdigest(),registers=regs(),stack=read(regs()[15],32).hex(),board=read(a5-0x4302,544).hex(),values=read(a5-0x40e2,1088).hex(),rack0=read(a5-0x3c9a,8).hex(),rack1=read(a5-0x3ca2,8).hex())
 a.output.write_text(json.dumps(report,indent=2)+'\n');print(f'Paused at CODE{rid}+{offset:x}',flush=True)
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
