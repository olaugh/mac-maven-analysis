#!/usr/bin/env python3
"""Read-only CODE37 row table and POOFIER scorer witness. 120-second socket TTL."""
import hashlib,json,struct,time
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from mac_ui import key
from maven_debug_cleanup import cleanup_breakpoints
command('stop');r=Remote();r.sock.settimeout(120);points=set();report={'rows':[]}
def read(a,n):return bytes.fromhex(r.command(f'm{a:x},{n:x}'))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(a):return int.from_bytes(read(a,4),'big')
def add(a):assert r.command(f'Z0,{a:x},2')=='OK';points.add(a)
def clear():
 for a in list(points):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
def run(a):add(a);r.command('c');assert regs()[17]==a;clear()
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904);slot=a5+0xa3a;add(slot);r.command('c',wait=False);key('meta_l-k');r.receive();assert regs()[17]==slot;clear()
 stub=read(slot,6)
 if stub==bytes.fromhex('3f3c0025a9f0'):r.command('s');r.command('s');run(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=long(slot+2)-4;code=Path('resources/CODE/37_37.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 report.update(a5=a5,base=base,code_sha256=hashlib.sha256(code).hexdigest())
 for off in [0x86c,0x910,0xf6c]:add(base+off)
 while True:
  r.command('c');rr=regs();off=rr[17]-base
  if off in [0x86c,0x910]:
   row=rr[5]&65535;report['rows'].append(dict(offset=off,row=row,workspace=read(a5-0x6f2,64).hex(),board=read(a5-0x4302+row*17,17).hex(),premiums=read(a5-0x684e+row*17,17).hex(),table=read(a5-0x60d4,544).hex()))
  else:
   m=read(long(a5-0x2a06),34)
   if m.startswith(b'poofier\0'):
    report['scorer']=dict(move=m.hex(),registers=rr,table=read(a5-0x60d4,544).hex(),workspace=read(a5-0x6f2,64).hex());break
  pc=rr[17];assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
 Path('analysis/toolchain/poofier-multiplier-live.json').write_text(json.dumps(report,indent=2)+'\n');print(report['scorer'])
finally:cleanup_breakpoints(r,points);command('cont')
