#!/usr/bin/env python3
"""Trace naturally reached CODE39 own/paired rack-bound arithmetic."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=32);a=p.parse_args()
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
 a5=long(0x904);stub=read(a5+0xa6a,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x68c;code=Path('resources/CODE/39_39.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 sites={base+0x51a:'own',base+0x68c:'paired'};entry=json.loads(Path('analysis/toolchain/endgame-search-dispatch-live.json').read_text());finish=int.from_bytes(bytes.fromhex(entry['stack'])[:4],'big')
 report=dict(scope=__doc__,code_sha256=hashlib.sha256(code).hexdigest(),calls=[])
 for i in range(a.count):
  for point in sites:arm(point)
  arm(finish);r.command('c');g=regs();pc=g[17];clear()
  if pc==finish:report['solver_completed']=True;break
  assert pc in sites;kind=sites[pc];sp=g[15];caller=long(sp);own=word(sp+4)
  if kind=='paired':other=word(sp+6);positive=long(sp+8);negative=long(sp+12)
  else:other=None;positive=long(sp+6);negative=long(sp+10)
  call=dict(kind=kind,own=own,other=other,tables={name:read(long(a5-offset),128*18).hex() for name,offset in [('own_a',0x30f0),('own_b',0x30f4),('own_error',0x30ec),('other_a',0x30e4),('other_b',0x30e8),('other_error',0x30e0)]})
  arm(caller);r.command('c');assert regs()[17]==caller;clear();call.update(result=regs()[0]&65535,positive=word(positive),negative=word(negative));report['calls'].append(call);print(i+1,kind,own,other,flush=True)
 report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n')
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
