#!/usr/bin/env python3
"""Read the inherited A2 pointer at the first extra reconstructed merge reply."""
import json,struct,hashlib,time
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from mac_ui import key
from maven_debug_cleanup import cleanup_breakpoints
command('cont');time.sleep(.5);command('stop');r=Remote();r.sock.settimeout(60);points=set();report={}
def read(a,n):return bytes.fromhex(r.command(f'm{a:x},{n:x}'))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(a):return int.from_bytes(read(a,4),'big')
def add(a):assert r.command(f'Z0,{a:x},2')=='OK';points.add(a)
def clear():
 for a in list(points):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
def run(a):add(a);r.command('c');assert regs()[17]==a;clear()
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa';a5=long(0x904);slot=a5+0xa1a;add(slot);r.command('c',wait=False);key('meta_l-k');r.receive();clear();st=read(slot,6)
 if st==bytes.fromhex('3f3c0024a9f0'):r.command('s');r.command('s');run(slot);st=read(slot,6)
 assert st[:2]==bytes.fromhex('4ef9');base=int.from_bytes(st[2:],'big')-0x1810
 code=Path('resources/CODE/36_36.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];report['code_sha256']=hashlib.sha256(code).hexdigest()
 for hit in range(300):
  run(base+0x594);g=regs();move=read(g[11],34)
  if move[:8]==b'retread\0' and move[30:34].hex()=='07e80c09':
   end=a5-0x4302+move[32]*17+move[33]+7
   report.update(hit=hit,registers=g,a5=a5,base=base,move=move.hex(),a2=g[10],predicted_a2=end,inherited=read(g[10]+61,4).hex(),predicted_inherited=read(end+61,4).hex(),used=read(a5-0x317c,128).hex(),priority_globals=read(a5-0x82c,8).hex(),a2_relative_board=g[10]-(a5-0x4302),stack=read(g[15],40).hex())
   run(base+0x61a);report['skip_confirmed']=True;break
  r.command('s')
 else:raise AssertionError('target not observed')
finally:
 report['cleanup']=cleanup_breakpoints(r,points);Path('analysis/toolchain/magpie-ebon-fastpath-live.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report),flush=True)
