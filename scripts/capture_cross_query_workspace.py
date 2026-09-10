#!/usr/bin/env python3
"""Observe CODE37 crossing-query output and its overlap with row scoring flags."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--calls',type=int,default=1000);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(180);points=set();report={'scope':__doc__,'calls':[],'complete':False}
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def text(addr,limit=64):
 b=read(addr,limit);assert 0 in b;return b.split(b'\0')[0]
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
def save():a.output.write_text(json.dumps(report,indent=2)+'\n')
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);slot=a5+0xa3a;print('Waiting for normal board generation',flush=True);stub=read(slot,6)
 if stub[:2]!=bytes.fromhex('4ef9'):run(slot);stub=read(slot,6)
 if stub==bytes.fromhex('3f3c0025a9f0'):r.command('s');r.command('s');run(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-4;code=Path('resources/CODE/37_37.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12;assert read(data_base,len(source))==source
 report.update(a5=a5,code_sha256=hashlib.sha256(code).hexdigest(),dictionary_sha256=hashlib.sha256(source).hexdigest());spill=None
 for index in range(a.calls):
  run(base+0x3ce);sp=regs()[15];caller=long(sp);pointer=long(sp+4);allowed=long(sp+8);prefix=text(pointer,17);suffix=text(pointer+len(prefix)+1,17)
  event=dict(prefix=prefix.decode(),suffix=suffix.decode(),allowed=text(allowed,27).decode(),before=read(a5-0x6f2,64).hex())
  run(caller);assert regs()[0]==a5-0x6f2;after=read(a5-0x6f2,64);event.update(after=after.hex(),output=after.split(b'\0')[0].decode());report['calls'].append(event)
  if len(event['output'])>=32 and spill is None:spill=index;report['first_overlap']=index;print('Observed overlap',index,len(event['output']),flush=True)
  if index%20==0:save()
  if spill is not None and index>=spill+3:report['complete']=True;break
 save();print('Captured',len(report['calls']),'crossing queries',flush=True)
finally:
 report['cleanup']=cleanup_breakpoints(r,points);save()
