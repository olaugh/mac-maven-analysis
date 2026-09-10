#!/usr/bin/env python3
"""Capture natural CODE39+4 local-score bound corrections."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=16);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);stub=read(a5+0xa52,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-4;code=Path('resources/CODE/39_39.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 entry=json.loads(Path('analysis/toolchain/endgame-search-dispatch-live.json').read_text());finish=int.from_bytes(bytes.fromhex(entry['stack'])[:4],'big')
 report=dict(scope=__doc__,code_sha256=hashlib.sha256(code).hexdigest(),calls=[])
 for i in range(a.count):
  arm(base+4);arm(finish);r.command('c');g=regs();pc=g[17];clear()
  if pc==finish:report['solver_completed']=True;break
  assert pc==base+4;sp=g[15];caller,node,rack,d1,d2,out1,out2,outmask=struct.unpack('>IIIhhIII',read(sp,28))
  call=dict(node=read(node,32).hex(),rack=read(rack,8).hex(),depths=[d1,d2],initial_outputs=[long(out1),long(out2),word(outmask)],masks=read(a5-0x3304,256).hex(),mask_count=word(a5-0x3306),best=read(a5-0x58aa,512).hex(),tables={name:read(long(a5-offset),128*18).hex() for name,offset in [('own_a',0x30f0),('own_b',0x30f4),('own_error',0x30ec),('other_a',0x30e4),('other_b',0x30e8),('other_error',0x30e0)]})
  arm(caller);r.command('c');assert regs()[17]==caller;clear();call['outputs']=[long(out1),long(out2),word(outmask)];report['calls'].append(call);print(i+1,call['depths'],call['outputs'],flush=True)
 report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n')
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
