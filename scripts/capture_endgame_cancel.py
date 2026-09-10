#!/usr/bin/env python3
"""Observe ordinary Escape inside scaled endgame search and its outer session cleanup."""
import argparse, hashlib, json, struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--force-poll',action='store_true');a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(180);points=set();report={}
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def remove(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;remove(addr)
def frame_for(frame,caller):
 for _ in range(30):
  if long(frame+4)==caller:return frame
  frame=long(frame);assert frame
 raise AssertionError('caller frame missing')
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904);stub=read(a5+0xba,6);assert stub[:2]==bytes.fromhex('4ef9');base3=int.from_bytes(stub[2:],'big')-0x2c6
 code3=Path('resources/CODE/3_3.bin').read_bytes();assert read(base3+4,len(code3)-4)==code3[4:]
 print('Waiting for original End Analyzer search',flush=True)
 slot=a5+0x89a;run(slot);stub=read(slot,6)
 if stub==bytes.fromhex('3f3c001ea9f0'):
  r.command('s');r.command('s');run(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');entry=int.from_bytes(stub[2:],'big');base30=entry-0x14e;run(entry)
 code30=Path('resources/CODE/30_30.bin').read_bytes();assert read(base30+4,len(code30)-4)==code30[4:]
 frame=frame_for(regs()[14],base3+0x2c0);config=long(a5-0x2ec4);count=word(config+12);caller=long(regs()[15])
 def snapshot():
  out={name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('rack0',0x3c9a,8),('rack1',0x3ca2,8),('counts',0x5ab2,128),('undo',0xaca,33),('letter_values',0x6bee,256),('leave_values',0x440c,256),('tile_points',0x3406,256),('canonical_masks',0x3304,256),('occurrence_masks',0x4c0c,2048),('selected_move',0x5a32,34)]}
  out.update(bingo_bonus=word(a5-0x65aa),row_zero_count=word(a5-0x4c0e),new_tiles=word(a5-0x4e2a),selected_pointer=long(a5-0x3c8a),depth=word(a5-0x5c7a),pending_error=long(a5-0x5dde),cancel_error=long(a5-0x6c54),config=read(config,24+46*count).hex())
  return out
 saved={name:read(frame-off,n).hex() for name,off,n in [('board',0x220,544),('values',0x660,1088),('rack0',0x668,8),('rack1',0x670,8)]};saved['selected_pointer']=long(frame-0x674)
 report=dict(scope=__doc__,a5=a5,identities={'3':hashlib.sha256(code3).hexdigest(),'30':hashlib.sha256(code30).hexdigest()},initial=snapshot(),saved=saved,events=[],complete=False)
 run(base30+0x848);endframe=frame_for(regs()[14],caller)
 report['endgame_saved']={name:read(endframe-off,n).hex() for name,off,n in [('board',0x232,544),('values',0x672,1088),('own',0xa,8),('other',0x12,8)]}
 report['at_poll']=snapshot()
 report['poll_timing']={'ticks':long(0x16a),'deadline':long(a5-0x5c72),'callback':long(a5-0x5c76)}
 if a.force_poll:
  assert r.command(f'M{a5-0x5c72:x},4:00000000')=='OK'
  report['controlled_mutation']={'address':a5-0x5c72,'before':report['poll_timing']['deadline'],'after':0,'purpose':'make the existing poll callback due; ordinary Escape supplies cancellation'}
 a.output.write_text(json.dumps(report,indent=2)+'\n')
 print('At endgame poll; sending Escape',flush=True)
 sites={base30+0x58e:'endgame_exception',base30+0x5a4:'endgame_unscaled',base30+0x5e0:'endgame_position_restored',base3+0xd44:'session_exception',base3+0xd86:'before_restore',base3+0xdd6:'board_racks_restored',base3+0xde2:'leave_rebuilt',base3+0x2c0:'returned'}
 for addr in sites:arm(addr)
 command('human-monitor-command',{'command-line':'sendkey esc 1000'});r.command('c',wait=False)
 while True:
  r.receive();pc=regs()[17];assert pc in sites,(hex(pc),sites)
  report['events'].append(dict(kind=sites[pc],state=snapshot()));print(sites[pc],flush=True)
  a.output.write_text(json.dumps(report,indent=2)+'\n')
  if pc==base3+0x2c0:break
  remove(pc);r.command('s');arm(pc);r.command('c',wait=False)
 report['complete']=True
finally:
 cleanup=cleanup_breakpoints(r,points)
 if report:report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
