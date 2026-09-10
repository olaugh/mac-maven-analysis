#!/usr/bin/env python3
"""Observe the unmodified force0 CPU-calibrated late-search gate through its decision."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,required=True)
parser.add_argument('--controlled-calibration',type=int,help='Override the gate input D4 after natural calibration; explicitly controlled evidence')
args=parser.parse_args()
if args.controlled_calibration is not None:assert 0<args.controlled_calibration<=0xffffffff
command('stop');remote=Remote();remote.sock.settimeout(180);points=set();report={}
def read(address,length):
 return b''.join(bytes.fromhex(remote.command(f'm{address+i:x},{min(2048,length-i):x}')) for i in range(0,length,2048))
def registers():return struct.unpack('>18I',bytes.fromhex(remote.command('g')))
def long(address):return int.from_bytes(read(address,4),'big')
def word(address):return int.from_bytes(read(address,2),'big',signed=True)
def arm(address):assert remote.command(f'Z0,{address:x},2')=='OK';points.add(address)
def remove(address):assert remote.command(f'z0,{address:x},2')=='OK';points.remove(address)
def run_to(address):
 arm(address);remote.command('c');assert registers()[17]==address;remove(address)
try:
 remote.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 a5=long(0x904);slot=a5+0xa1a
 print('Waiting for natural late-search entry; enable Late Analyzer in Simulate',flush=True)
 run_to(slot);stub=read(slot,6)
 if stub==bytes.fromhex('3f3c0024a9f0'):
  remote.command('s');remote.command('s');run_to(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');entry=int.from_bytes(stub[2:],'big');base=entry-0x1810
 run_to(entry);regs=registers();assert word(regs[15]+8)==0,'requires original force0 call'
 code=Path('resources/CODE/36_36.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 report=dict(scope=__doc__,a5=a5,base=base,identities={'36':hashlib.sha256(code).hexdigest()},force=0,complete=False)
 run_to(base+0x1842);regs=registers();frame=regs[14]
 report['measured_calibration']=regs[4]
 report['controlled_input']=args.controlled_calibration is not None
 if args.controlled_calibration is not None:
  changed=list(regs);changed[4]=args.controlled_calibration
  assert remote.command('G'+struct.pack('>18I',*changed).hex())=='OK'
  regs=registers();assert regs==tuple(changed)

 stub=read(a5+0x692,6);assert stub[:2]==bytes.fromhex('4ef9');base9=int.from_bytes(stub[2:],'big')-0xee
 code9=Path('resources/CODE/9_9.bin').read_bytes();assert read(base9+4,len(code9)-4)==code9[4:]
 report['identities']['9']=hashlib.sha256(code9).hexdigest()
 report.update(calibration=regs[4],own_blanks=read(a5-0x5a73,1)[0],unseen_blanks=read(frame-0x65,1)[0],unseen_total=word(a5-0x82e),table=read(a5-0x89a,108).hex())
 run_to(base+0x187e);report['quotient']=registers()[0]
 for address in (base+0x1886,base+0x189a):arm(address)
 remote.command('c');pc=registers()[17];assert pc in points
 report.update(heuristic_fallback=pc==base+0x1886,decision_offset=pc-base,complete=True)
 print(json.dumps({key:value for key,value in report.items() if key!='table'},indent=2),flush=True)
finally:
 cleanup=cleanup_breakpoints(remote,points)
 if report:
  report['cleanup']=cleanup;args.output.write_text(json.dumps(report,indent=2)+'\n')
