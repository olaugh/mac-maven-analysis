#!/usr/bin/env python3
"""Resume a verified paused CODE11 end dispatch and capture final rack adjustments."""
import argparse,json,hashlib,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(60);points=set();report={}
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
def loaded(slot,rid,off):
 assert read(slot,2)==bytes.fromhex('4ef9');base=long(slot+2)-off;code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];return base
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904);b11=loaded(a5+0x1a2,11,0x1168);assert regs()[17]==b11+0x10ae
 def state():
  out={k:read(a5-off,n).hex() for k,off,n in [('board',0x4302,544),('values',0x40e2,1088),('rack0',0x3c9a,8),('rack1',0x3ca2,8),('counts',0x5ab2,128)]}
  out.update(totals=[long(a5-0x3c8e),long(a5-0x3c92)],statistics=[list(struct.unpack('>22I',read(a5-off,88))) for off in (0x5b68,0x5b10)],selected_side=2 if not long(a5-0x3c8a) else 0 if long(a5-0x3c8a)==a5-0x3c9a else 1,phase=word(a5-0x219c));return out
 report={'scope':__doc__,'complete':False,'initial':state(),'letter_values':read(a5-0x6bee,256).hex(),'alphabet':read(long(a5-0x662e),28).hex(),'records':[]}
 slot=a5+0x15a;run(slot)
 if read(slot,6)==bytes.fromhex('3f3c0007a9f0'):r.command('s');r.command('s');run(slot)
 b7=loaded(slot,7,0x3a4);run(b7+0x3a4);caller=long(regs()[15]);assert caller==b11+0x10b2
 for addr in (b7+0x80c,caller):arm(addr)
 while True:
  r.command('c');g=regs();pc=g[17];assert pc in points
  if pc==caller:break
  sp=g[15];tag=read(sp+18,1)[0];size=long(sp+14);payload=long(sp+10);assert tag==3 and size==18
  report['records'].append({'tag':tag,'payload':read(payload,size).hex()})
  assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');arm(pc)
 clear();report['finish_return']=state();run(b11+0x10de);report['final']=state();report['complete']=True
 report['identities']={str(i):hashlib.sha256(Path(f'resources/CODE/{i}_{i}.bin').read_bytes()).hexdigest() for i in (7,11)}
 print(json.dumps({'totals':report['final']['totals'],'records':len(report['records']),'complete':True}),flush=True)
finally:
 report['cleanup']=cleanup_breakpoints(r,points);a.output.write_text(json.dumps(report,indent=2)+'\n')
