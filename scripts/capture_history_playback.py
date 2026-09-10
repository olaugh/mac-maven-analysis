#!/usr/bin/env python3
"""Capture normal Open's recursive history playback, complete refills and external inputs."""
import argparse,hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--history-name');a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(180);points=set();report={}
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
def loaded(slot,rid,offset):
 stub=read(slot,6);assert stub[:2]==bytes.fromhex('4ef9'),(rid,stub.hex())
 base=int.from_bytes(stub[2:],'big')-offset;code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()
 assert read(base+4,len(code)-4)==code[4:];report.setdefault('identities',{})[str(rid)]=hashlib.sha256(code).hexdigest();return base
def resolve(slot,rid,offset):
 run(slot);stub=read(slot,6)
 if stub==bytes.fromhex(f'3f3c{rid:04x}a9f0'):
  r.command('s');r.command('s');run(slot)
 base=loaded(slot,rid,offset);run(base+offset);return base
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904);report={'scope':__doc__,'a5':a5,'complete':False,'events':[],'refills':[]}
 print('Waiting for history navigation' if a.history_name else 'Waiting for normal saved-game Open',flush=True)
 if a.history_name:b7=resolve(a5+0x162,7,4)
 else:b22=resolve(a5+0x5aa,22,0x2cc)
 b31=None
 def state():
  d={k:read(a5-off,n).hex() for k,off,n in [('board',0x4302,544),('values',0x40e2,1088),('rack0',0x3c9a,8),('rack1',0x3ca2,8),('counts',0x5ab2,128),('undo',0xaca,33)]}
  d.update(totals=[long(a5-0x3c8e),long(a5-0x3c92)],selected_pointer=long(a5-0x3c8a),row_zero_count=word(a5-0x4c0e),new_tiles=word(a5-0x4e2a),recorded_row=[word(a5-x) for x in (0x430a,0x430c)],recorded_column=[word(a5-x) for x in (0x4306,0x4308)])
  return d
 caller=long(regs()[15])
 if a.history_name:
  name=a.history_name;report['target_index']=word(regs()[15]+4);report['history_navigation']=True
 else:
  nameptr=long(regs()[15]+6);name=read(nameptr+1,read(nameptr,1)[0]).decode('mac_roman')
 source=Path('../../media/maven/session/share')/name;wire=source.read_bytes()
 report.update(name=name,file_sha256=hashlib.sha256(wire).hexdigest(),wire=wire.hex())
 parsed=[];offset=0
 while offset<len(wire):
  tag,n=struct.unpack_from('>hh',wire,offset);assert n>=0;parsed.append((tag,wire[offset+4:offset+4+n]));offset+=4+n
 assert offset==len(wire)
 if not a.history_name:run(b22+0x430)
 table=long(long(long(a5-0x213e)+0xca))
 for i,(tag,payload) in enumerate(parsed):
  assert read(table+6*i,1)[0]==tag&255
  assert read(long(long(table+6*i+2)),len(payload))==payload
 report['initial']=state();report['fixed']={k:read(a5-off,n).hex() for k,off,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('distribution',0x6aee,128)]};report['fixed']['alphabet']=read(long(a5-0x662e),28).hex()
 if not a.history_name:b7=resolve(a5+0x162,7,4)
 sites={b7+0x2e6:'record_return',b7+0x10:'history_return'};refill_offsets=[0x7e0,0x7f4,0x810,0x824,0x82c,0x852,0x866,0x86c,0x8b4]
 for addr in sites:arm(addr)
 arm(a5+0x962)
 while True:
  r.command('c');g=regs();pc=g[17];assert pc in points
  if pc==a5+0x962:
   clear();b31=loaded(a5+0x962,31,0x7e0);run(b31+0x7e0);g=regs();pc=g[17]
   for addr in sites:arm(addr)
   for off in refill_offsets:arm(b31+off)
  if pc in sites:
   if pc==b7+0x10:report['history_return']=state();break
   frame=g[14];index=word(frame+14);tag=word(frame+12);payload=long(frame+8)
   assert 0<=index<len(parsed) and tag==parsed[index][0] and read(payload,len(parsed[index][1]))==parsed[index][1]
   report['events'].append({'index':index,'tag':tag,'state':state()});print('record',index,'tag',tag,flush=True)
  else:
   off=pc-b31
   if off==0x7e0:
    rackptr=long(g[15]+4);assert rackptr in (a5-0x3c9a,a5-0x3ca2)
    refill={'record_event_index':len(report['events']),'side':0 if rackptr==a5-0x3c9a else 1,'private_seed':long(a5-0xdc4),'events':[]};report['refills'].append(refill)
   elif off==0x7f4:
    frame=g[14];length=g[0];assert length<=127;refill.update(bag=read(frame-0x80,length).hex(),stack_ticks=long(frame-0x84))
   elif off==0x8b4:refill['final']={'rack':read(rackptr,8).hex(),'private_seed':long(a5-0xdc4),'bag_workspace':read(frame-0x80,length).hex()}
   else:
    if off in (0x810,0x852):event={'kind':'ticks','value':long(frame-(0x84 if off==0x810 else 0x88))}
    elif off in (0x824,0x866):event={'kind':'private_random','value':g[0]}
    else:event={'kind':'toolbox_random','value':g[0]&65535}
    refill['events'].append(event)
  assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');arm(pc)
 clear();run(caller);report['navigation_return' if a.history_name else 'open_return']=state();report['complete']=True;print('Complete history playback',flush=True)
finally:
 cleanup=cleanup_breakpoints(r,points)
 if report:report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
