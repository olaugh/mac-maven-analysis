#!/usr/bin/env python3
"""Capture natural CODE36 local pool refinement, including CODE37 generation inputs."""
import argparse,gzip,hashlib,json,re,struct
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
def remove(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def clear():
 for addr in list(points):remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);stub=read(a5+0xa32,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x548;code=Path('resources/CODE/37_37.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 def state():
  out={name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('sorted_rack',0x3204,17),('occurrences',0x4c0c,2048),('globals',0x8da,0x260),('column_cache',0x8d6,64),('leave_values',0x440c,256),('row_flags',0x6d2,32)]}
  out.update(new_tiles=word(a5-0x4e2a),row_zero_count=word(a5-0x4c0e),rows=[word(a5-d) for d in (0x430a,0x430c)],columns=[word(a5-d) for d in (0x4306,0x4308)])
  out.update(pool_count=word(a5-0x30fc),pool_base=long(a5-0x30dc),pool_records=read(long(a5-0x30dc),word(a5-0x30fc)*66).hex())
  return out
 fixed={name:read(a5-off,n).hex() for name,off,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('bit_masks',0x662a,128)]};fixed['alphabet']=read(long(a5-0x662e),28).hex();fixed['bingo_bonus']=word(a5-0x65aa);fixed['binomial']=read(a5-0x65a8,17*16).hex()
 stub36=read(a5+0xa0a,6);assert stub36[:2]==bytes.fromhex('4ef9');base36=int.from_bytes(stub36[2:],'big')-0x113a;code36=Path('resources/CODE/36_36.bin').read_bytes();assert read(base36+4,len(code36)-4)==code36[4:]
 report=dict(code36_sha256=hashlib.sha256(code36).hexdigest(),scope=__doc__,a5=a5,code_sha256=hashlib.sha256(code).hexdigest(),fixed=fixed,calls=[])
 source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12;assert read(data_base,len(source))==source;report['dictionary_sha256']=hashlib.sha256(source).hexdigest();report['sections']=[]
 for i in range(16):
  pointer,root=struct.unpack('>II',read(a5-0x2eb8+8*i,8))
  if not root:break
  report['sections'].append(dict(offset=pointer-data_base,root=root))
 for i in range(a.count):
  print('Waiting for local-reply call',i+1,flush=True);run(base+0x548);caller,move,own,callback,other=struct.unpack('>5I',read(regs()[15],20));call=dict(same_rack=own==other,own_pointer=own,other_pointer=other,move=read(move,34).hex(),own=read(own,8).hex(),other=read(other,17).hex(),callback=callback,initial=state(),candidates=[])
  run(base+0x7b6);call['enumeration']=state();call['row_masks']=read(long(regs()[15]+4),62).hex()
  arm(callback);arm(caller)
  while True:
   r.command('c');g=regs();pc=g[17]
   if pc==caller:break
   assert pc==callback;call['candidates'].append(dict(move=read(long(g[15]+4),34).hex(),new_tiles=word(a5-0x4e2a),used=read(a5-0x317c,128).hex(),inherited_a2=g[10]))
   remove(pc);r.command('s');arm(pc)
  clear();call.update(final=state(),final_own=read(own,8).hex(),final_other=read(other,17).hex());report['calls'].append(call);a.output.write_bytes(gzip.compress((json.dumps(report,separators=(',',':'))+'\n').encode()));print('Captured',len(call['candidates']),'replies',flush=True)
 report['complete']=True;a.output.write_bytes(gzip.compress((json.dumps(report,separators=(',',':'))+'\n').encode()))
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;a.output.write_bytes(gzip.compress((json.dumps(report,separators=(',',':'))+'\n').encode()))
