#!/usr/bin/env python3
"""Capture original CODE39 table preparation after its CODE43 score preprocessing."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=4);a=p.parse_args()
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
 a5=long(0x904);stub=read(a5+0xa5a,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x190;code=Path('resources/CODE/39_39.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 stub43=read(a5+0xaaa,6);assert stub43[:2]==bytes.fromhex('4ef9');base43=int.from_bytes(stub43[2:],'big')-0x1dc;code43=Path('resources/CODE/43_43.bin').read_bytes();assert read(base43+4,len(code43)-4)==code43[4:]
 entry=json.loads(Path('analysis/toolchain/endgame-search-dispatch-live.json').read_text());finish=int.from_bytes(bytes.fromhex(entry['stack'])[:4],'big');report=dict(scope=__doc__,code_sha256=hashlib.sha256(code).hexdigest(),code43_sha256=hashlib.sha256(code43).hexdigest(),calls=[])
 for i in range(a.count):
  arm(base+0x190);arm(finish);r.command('c');g=regs();pc=g[17];clear()
  if pc==finish:report['solver_completed']=True;break
  assert pc==base+0x190
  pre_scores={name:read(a5-off,n).hex() for name,off,n in [('best',0x58aa,512),('second',0x30d0,512),('letter_values',0x6bee,256),('occurrence_masks',0x4c0c,2048)]}
  arm(base+0x1cc);r.command('c');g=regs();assert g[17]==base+0x1cc;clear();frame=g[14];caller=long(frame+4);side=word(frame+8);rack=read(long(frame+10),8).hex();offsets={'a':0x30f0 if side else 0x30e4,'b':0x30f4 if side else 0x30e8,'error':0x30ec if side else 0x30e0};pointers={name:long(a5-off) for name,off in offsets.items()}
  call=dict(side=side,rack=rack,sorted_rack=read(a5-0x3204,8).hex(),canonical_masks=read(a5-0x3304,256).hex(),mask_count=word(a5-0x3306),tile_points=read(a5-0x3406,256).hex(),best=read(a5-0x58aa,512).hex(),second=read(a5-0x30d0,512).hex(),before={name:read(pointer,128*18).hex() for name,pointer in pointers.items()})
  call['score_preparation_input']=pre_scores
  arm(caller);r.command('c');assert regs()[17]==caller;clear();call['after']={name:read(pointer,128*18).hex() for name,pointer in pointers.items()};report['calls'].append(call);print(i+1,'side',side,'rack',rack,flush=True)
 report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n')
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
