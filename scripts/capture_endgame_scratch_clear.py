#!/usr/bin/env python3
"""Witness CODE29 clearing the shared best-empty/final-expansion record, read-only."""
import hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from mac_ui import key
from maven_debug_cleanup import cleanup_breakpoints
import time
command('cont');time.sleep(1);command('stop');r=Remote();r.sock.settimeout(60);points=set();report={'clears':[]}
def read(a,n):return bytes.fromhex(r.command(f'm{a:x},{n:x}'))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(a):return int.from_bytes(read(a,4),'big')
def add(a):assert r.command(f'Z0,{a:x},2')=='OK';points.add(a)
def clear():
 for a in list(points):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904);slot=a5+0x86a;add(slot);r.command('c',wait=False);key('meta_l-k');r.receive();assert regs()[17]==slot;clear();stub=read(slot,6)
 if stub==bytes.fromhex('3f3c001da9f0'):
  r.command('s');r.command('s');add(slot);r.command('c');assert regs()[17]==slot;clear();stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=long(slot+2)-0x2c;code=Path('resources/CODE/29_29.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];caller=long(regs()[15]);report.update(a5=a5,base=base,sha256=hashlib.sha256(code).hexdigest())
 for pc in [base+0x70,base+0x7c,caller]:add(pc)
 while True:
  r.command('c');pc=regs()[17]
  if pc==caller:break
  assert pc in [base+0x70,base+0x7c];report['clears'].append(dict(offset=pc-base,record=read(a5-0x5a32,34).hex()))
  assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
 Path('analysis/toolchain/vid-tail-clear-live.json').write_text(json.dumps(report,indent=2)+'\n');print(report)
finally:cleanup_breakpoints(r,points);command('cont')
