#!/usr/bin/env python3
"""Capture natural CODE27 reply bounds with conflict matrix and CODE39 boundary calls."""
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
def remove(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def clear():
 for addr in list(points):remove(addr)
def summaries():
 pointer=long(a5-0xae2);result=[];seen=set()
 while pointer:
  assert pointer not in seen;seen.add(pointer);assert len(result)<266
  raw=read(pointer,14);result.append(dict(pointer=pointer,raw=raw.hex()));pointer=int.from_bytes(raw[:4],'big')
 return result
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);bases={};identities=[]
 for rid,slot,off in [(27,0x82a,0x26),(39,0xa6a,0x68c),(43,0xaa2,4)]:
  stub=read(a5+slot,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-off;code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];bases[rid]=base;identities.append(dict(code_resource=rid,sha256=hashlib.sha256(code).hexdigest()))
 target=bases[27]+0x26;callback_sites={bases[39]+0x68c:'paired',bases[39]+0x51a:'own'}
 outer=json.loads(Path('analysis/toolchain/endgame-search-dispatch-live.json').read_text());finish=int.from_bytes(bytes.fromhex(outer['stack'])[:4],'big')
 report=dict(scope=__doc__,identities=identities,a5=a5,calls=[])
 for i in range(a.count):
  arm(target);arm(finish);r.command('c');pc=regs()[17];clear()
  if pc==finish:report['solver_completed']=True;break
  assert pc==target;stack=regs()[15];caller=long(stack);move,upper,lower,empty,compatible=struct.unpack('>5I',read(stack+4,20))
  call=dict(move=read(move,34).hex(),upper=long(upper),lower=long(lower),board=read(a5-0x4302,544).hex(),tile_points=read(a5-0x3406,256).hex(),matrix=read(long(a5-0x30f8),8*544*4).hex(),bit_masks=read(a5-0x662a,128).hex(),summaries=summaries(),mask_calls=[])
  call['mask_tables']={name:read(long(a5-offset),128*18).hex() for name,offset in [('own_a',0x30f0),('own_b',0x30f4),('own_error',0x30ec),('other_a',0x30e4),('other_b',0x30e8),('other_error',0x30e0)]}
  arm(caller)
  for point in callback_sites:arm(point)
  while True:
   r.command('c');g=regs();pc=g[17]
   if pc==caller:break
   assert pc in callback_sites;kind=callback_sites[pc];sp=g[15];ret=long(sp);own=word(sp+4)
   if kind=='paired':other=word(sp+6);positive=long(sp+8);negative=long(sp+12)
   else:other=None;positive=long(sp+6);negative=long(sp+10)
   remove(pc);arm(ret);r.command('c');assert regs()[17]==ret;remove(ret)
   call['mask_calls'].append(dict(kind=kind,own=own,other=other,result=regs()[0]&65535,positive=word(positive),negative=word(negative)));arm(pc)
  clear();call['result']=dict(pruned=regs()[0]&65535,upper=long(upper),lower=long(lower),empty=word(empty),compatible=word(compatible),summaries=summaries(),groups=read(a5-0x680,48).hex())
  report['calls'].append(call);print(i+1,'mask calls',len(call['mask_calls']),flush=True)
 report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n')
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
