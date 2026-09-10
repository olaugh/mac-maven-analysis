#!/usr/bin/env python3
"""Read-only original multiplicity calls during the baseline reply merge."""
import gzip,hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from mac_ui import key
from maven_debug_cleanup import cleanup_breakpoints
command('cont');command('stop');r=Remote();r.sock.settimeout(60);points=set();out=Path('analysis/toolchain/magpie-ebon-multiplicity-live.json.gz');report={'calls':[]}
def read(a,n):return b''.join(bytes.fromhex(r.command(f'm{a+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(a):return int.from_bytes(read(a,4),'big')
def add(a):assert r.command(f'Z0,{a:x},2')=='OK';points.add(a)
def clear():
 for a in list(points):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
def run(a):add(a);r.command('c');assert regs()[17]==a;clear()
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa';a5=long(0x904);slot=a5+0xa1a;add(slot);r.command('c',wait=False);key('meta_l-k');r.receive();assert regs()[17]==slot;clear();stub=read(slot,6)
 if stub==bytes.fromhex('3f3c0024a9f0'):r.command('s');r.command('s');run(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x1810;code=Path('resources/CODE/36_36.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];report['code_sha256']=hashlib.sha256(code).hexdigest()
 run(base+0x1ca6);report['a5']=a5;report['base']=base
 while True:
  add(base+4);add(base+0x1cb2);r.command('c');g=regs();clear()
  if g[17]==base+0x1cb2:break
  assert g[17]==base+4;caller,ptr,tag=struct.unpack('>IIH',read(g[15],10));call=dict(move=read(ptr,34).hex(),tag=tag,used=read(a5-0x317c,128).hex(),new_tiles=int.from_bytes(read(a5-0x4e2a,2),'big'))
  run(caller);call['result']=regs()[0]&65535;report['calls'].append(call)
  if len(report['calls'])%100==0:print('calls',len(report['calls']),flush=True)
 report['complete']=True
finally:
 report['cleanup']=cleanup_breakpoints(r,points);out.write_bytes(gzip.compress(json.dumps(report).encode()));print('saved',len(report['calls']),flush=True)
