#!/usr/bin/env python3
"""Observe ordinary Escape cancellation of an active simulation and its restoration.

Requires a paused original simulation with its CODE3+c58 stack frame alive.
Keyboard input is ordinary QMP input; all guest memory operations are reads.
"""
import argparse,hashlib,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(180);points=set();report={}
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def remove(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904);stub=read(a5+0xba,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x2c6
 code=Path('resources/CODE/3_3.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 frame=regs()[14]
 for _ in range(20):
  if long(frame+4)==base+0x2c0:break
  frame=long(frame);assert frame
 else:raise AssertionError('active CODE3+c58 frame not found')
 caller=long(frame+4);config=long(a5-0x2ec4);count=word(config+12)
 def state():
  out={name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('rack0',0x3c9a,8),('rack1',0x3ca2,8),('counts',0x5ab2,128),('undo',0xaca,33),('leave_values',0x440c,256),('tile_points',0x3406,256),('canonical_masks',0x3304,256),('occurrence_masks',0x4c0c,2048)]}
  out.update(selected_pointer=long(a5-0x3c8a),depth=word(a5-0x5c7a),pending_error=long(a5-0x5dde),cancel_error=long(a5-0x6c54),row_zero_count=word(a5-0x4c0e),new_tiles=word(a5-0x4e2a),config=read(config,24+46*count).hex())
  return out
 saved={name:read(frame-off,n).hex() for name,off,n in [('board',0x220,544),('values',0x660,1088),('rack0',0x668,8),('rack1',0x670,8)]};saved['selected_pointer']=long(frame-0x674)
 report=dict(scope=__doc__,a5=a5,code_base=base,code_sha256=hashlib.sha256(code).hexdigest(),frame=frame,caller=caller,saved=saved,initial=state(),events=[],complete=False)
 sites={base+0xd44:'exception_caught',base+0xd86:'before_restore',base+0xdd6:'board_racks_restored',base+0xde2:'leave_rebuilt',caller:'returned'}
 for addr in sites:arm(addr)
 r.command('c',wait=False)
 command('human-monitor-command',{'command-line':'sendkey esc 100'})
 while True:
  r.receive();g=regs();pc=g[17];assert pc in sites,(hex(pc),sites)
  report['events'].append(dict(kind=sites[pc],state=state()));a.output.write_text(json.dumps(report,indent=2)+'\n');print(sites[pc],flush=True)
  if pc==caller:break
  remove(pc);r.command('s');arm(pc);r.command('c',wait=False)
 report['complete']=True;report['final']=state()
finally:
 cleanup=cleanup_breakpoints(r,points)
 if report:report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
