#!/usr/bin/env python3
"""Read original tag0 restoration and subsequent normal Open boundaries."""
import argparse,hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--kibitz-rebuild',action='store_true');a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(120);points=set();report={}
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def run(addr):
 assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr);r.command('c');assert regs()[17]==addr
 assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def resolve(slot,rid,offset):
 run(slot);stub=read(slot,6)
 if stub==bytes.fromhex(f'3f3c{rid:04x}a9f0'):
  r.command('s');r.command('s');run(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-offset
 code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 report.setdefault('identities',{})[str(rid)]=hashlib.sha256(code).hexdigest();run(base+offset);return base
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904)
 def state():
  d={k:read(a5-off,n).hex() for k,off,n in [('board',0x4302,544),('values',0x40e2,1088),('rack0',0x3c9a,8),('rack1',0x3ca2,8),('counts',0x5ab2,128),('undo',0xaca,33),('letter_values',0x6bee,256)]}
  d['totals']=[long(a5-0x3c8e),long(a5-0x3c92)];d['selected_pointer']=long(a5-0x3c8a);return d
 report={'scope':__doc__,'a5':a5,'complete':False,'events':[]}
 print('Waiting for normal saved-game Open',flush=True)
 base22=resolve(a5+0x5aa,22,0x2cc);caller=long(regs()[15]);nameptr=long(regs()[15]+6)
 report['name']=read(nameptr+1,read(nameptr,1)[0]).decode('mac_roman')
 base7=resolve(a5+0x162,7,4);run(base7+0x3c)
 sp=regs()[15];tag=int.from_bytes(read(sp+8,2),'big',signed=True);assert tag==0,tag
 payload=long(sp+4);report['payload']=read(payload,300).hex();report['initial']=state()
 for addr,name in [(base7+0x2e6,'tag0_return'),(base7+0x10,'history_return'),(caller,'open_return')]:
  run(addr);report['events'].append({'kind':name,'state':state()});print(name,flush=True)
 if a.kibitz_rebuild:
  print('Waiting for ordinary Kibitz board rebuild',flush=True)
  base20=resolve(a5+0x3fa,20,0x4e);rebuild_caller=long(regs()[15])
  report['display_board']=read(a5-0x2894,289).hex();report['previous_display_board']=read(a5-0x2773,289).hex();report['force_board_refresh']=int.from_bytes(read(a5-0x2652,2),'big',signed=True)
  report['letter_class']=read(a5-0x428,128).hex()
  report['events'].append({'kind':'rebuild_entry','state':state()})
  run(rebuild_caller);report['events'].append({'kind':'rebuild_return','state':state()});print('rebuild_return',flush=True)
 report['complete']=True
finally:
 cleanup=cleanup_breakpoints(r,points)
 if report:report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
