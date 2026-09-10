#!/usr/bin/env python3
"""Observe an entire naturally requested CODE38 exhaustive simulation enumeration."""
import argparse,hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(180);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def add(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def remove(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):
 add(addr);r.command('c');assert regs()[17]==addr;remove(addr)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa';a5=long(0x904);slot=a5+0xa42
 print('Waiting for original exhaustive-enumeration call',flush=True);run(slot);stub=read(slot,6)
 if stub==bytes.fromhex('3f3c0026a9f0'):
  r.command('s');r.command('s');run(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x46
 code=Path('resources/CODE/38_38.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 run(base+0x46);caller,callback=struct.unpack('>II',read(regs()[15],8));config=long(a5-0x2ec4);count=int.from_bytes(read(config+12,2),'big');assert 0<count<=64
 def state():return dict(board=read(a5-0x4302,544).hex(),values=read(a5-0x40e2,1088).hex(),rack0=read(a5-0x3c9a,8).hex(),rack1=read(a5-0x3ca2,8).hex(),config=read(config,24+46*count).hex())
 report=dict(scope=__doc__,a5=a5,base=base,code_sha256=hashlib.sha256(code).hexdigest(),initial=state(),samples=[])
 run(base+0x6e);frame=regs()[14];report.update(counts=read(frame-0x80,128).hex(),unseen_total=regs()[7]&65535,alphabet=read(long(a5-0x662e),28).hex(),choose=read(a5-0x65a8,18*16).hex())
 add(base+0x12a);add(base+0x12c);add(caller)
 while True:
  r.command('c');rr=regs();pc=rr[17];assert pc in points
  if pc==caller:break
  if pc==base+0x12a:
   rackptr,weight=struct.unpack('>II',read(rr[15],8));rack=read(rackptr,8).split(b'\0')[0].decode();report['samples'].append(dict(rack=rack,weight=weight,before=state()));print('sample',len(report['samples']),rack,weight,flush=True)
  else:report['samples'][-1].update(return_word=rr[0]&65535,after=state())
  assert len(report['samples'])<=5000
  remove(pc);r.command('s');add(pc)
 report.update(final=state(),return_word=regs()[0]&65535,complete=True)
 a.output.write_text(json.dumps(report,indent=2)+'\n');print('Enumeration complete',len(report['samples']),flush=True)
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals() and a.output.exists():report['breakpoint_cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
