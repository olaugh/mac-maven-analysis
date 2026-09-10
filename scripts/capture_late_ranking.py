#!/usr/bin/env python3
"""Capture natural complete CODE36+113a rankings and every CODE36+91e reply valuation."""
import argparse,gzip,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=16);a=p.parse_args();command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
def save():a.output.write_bytes(gzip.compress((json.dumps(report,separators=(',',':'))+'\n').encode()))
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa';xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);stub=read(a5+0xa0a,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x113a;code=Path('resources/CODE/36_36.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 report=dict(scope=__doc__,a5=a5,base=base,code_sha256=hashlib.sha256(code).hexdigest(),calls=[])
 def state():return {name:read(a5-off,n).hex() for name,off,n in [('globals',0x8da,0x260),('counts',0x5ab2,128),('used',0x317c,128),('leave',0x440c,256),('tile_points',0x3406,256),('tables',0x65a8,0x510),('conflict_groups',0x680,48),('ranking',0x5a10,340),('ranking_count',0x30fc,2),('main_triple',0x5bc2,2),('new_tiles',0x4e2a,2)]}
 def replies(head):
  out=[];seen=set()
  while head:
   assert head not in seen and len(seen)<100;seen.add(head);raw=read(head,66);pointer=int.from_bytes(raw[50:54],'big');constraints=[]
   if pointer:
    for i in range(100):
     value=word(pointer+2*i);constraints.append(value)
     if value==0:break
    else:raise AssertionError('unterminated constraints')
   out.append(dict(pointer=head,raw=raw.hex(),constraints=constraints));head=int.from_bytes(raw[:4],'big')
  return out
 for index in range(a.count):
  run(base+0x113a);g=regs();caller,move=struct.unpack('>II',read(g[15],8));count=word(a5-0x80c);call=dict(move=read(move,34).hex(),initial=state(),weights=read(long(a5-0x810),2*count).hex(),first=replies(long(a5-0x790)),second=replies(long(a5-0x78c)),tail=long(a5-0x788),evaluations=[])
  if index==0:
   report['board']=read(a5-0x4302,544).hex();report['values']=read(a5-0x40e2,1088).hex();report['conflicts']=read(long(a5-0x30f8),17408).hex();report['bit_masks']=read(a5-0x662a,128).hex()
   st=read(a5+0xaa2,6);assert st[:2]==bytes.fromhex('4ef9');b=int.from_bytes(st[2:],'big')-4;raw=Path('resources/CODE/43_43.bin').read_bytes();assert read(b+4,len(raw)-4)==raw[4:];report['code43_sha256']=hashlib.sha256(raw).hexdigest()
  while True:
   arm(caller);arm(base+0x91e);r.command('c');g=regs();clear()
   if g[17]==caller:break
   assert g[17]==base+0x91e;ret,mv,reply=struct.unpack('>III',read(g[15],12));evaluation=dict(move=read(mv,34).hex(),reply=read(reply,66).hex(),initial=state());run(ret);evaluation.update(result=regs()[0],move_after=read(mv,34).hex(),final=state());call['evaluations'].append(evaluation)
  call.update(move_after=read(move,34).hex(),final=state());report['calls'].append(call);save();print('Rank',index+1,'valuations',len(call['evaluations']),flush=True)
 report['complete']=True;save()
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;save()
