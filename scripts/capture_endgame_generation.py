#!/usr/bin/env python3
"""Capture complete original CODE40 generation for both endgame racks."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);slot=a5+0xa8a;print('Waiting for natural CODE40 generation',flush=True);run(slot);stub=read(slot,6)
 if stub==bytes.fromhex('3f3c0028a9f0'):r.command('s');r.command('s');run(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x9c;code=Path('resources/CODE/40_40.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];run(base+0x9c)
 caller,own,other,output=struct.unpack('>4I',read(regs()[15],16))
 table_pointers={name:long(a5-off) for name,off in [('own_a',0x30f0),('own_b',0x30f4),('own_error',0x30ec),('other_a',0x30e4),('other_b',0x30e8),('other_error',0x30e0)]}
 def state():
  out={name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('sorted_rack',0x3204,8),('canonical_masks',0x3304,256),('tile_points',0x3406,256),('occurrence_masks',0x4c0c,2048),('best',0x58aa,512),('second',0x30d0,512)]}
  out.update(new_tiles=word(a5-0x4e2a),row_zero_count=word(a5-0x4c0e),rows=[word(a5-d) for d in (0x430a,0x430c)],columns=[word(a5-d) for d in (0x4306,0x4308)],mask_count=word(a5-0x3306),ranking=dict(moves=read(a5-0x5a10,340).hex(),count=word(a5-0x30fc),cutoff=long(a5-0xade)),tables={name:read(pointer,2304).hex() for name,pointer in table_pointers.items()})
  return out
 fixed={name:read(a5-off,n).hex() for name,off,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('bit_masks',0x662a,128)]};fixed['alphabet']=read(long(a5-0x662e),28).hex()
 report=dict(scope=__doc__,a5=a5,code_sha256=hashlib.sha256(code).hexdigest(),own=read(own,8).hex(),other=read(other,8).hex(),initial=state(),fixed=fixed,candidates=[])
 source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12;assert read(data_base,len(source))==source;report['dictionary_sha256']=hashlib.sha256(source).hexdigest();report['sections']=[]
 for i in range(16):
  pointer,root=struct.unpack('>II',read(a5-0x2eb8+8*i,8))
  if not root:break
  report['sections'].append(dict(offset=pointer-data_base,root=root))
 sites={base+4:0,base+0x114:1}
 for point in sites:arm(point)
 arm(caller)
 while True:
  r.command('c');g=regs();pc=g[17]
  if pc==caller:break
  assert pc in sites;move=long(g[15]+4);report['candidates'].append(dict(side=sites[pc],move=read(move,34).hex(),new_tiles=word(a5-0x4e2a)))
  assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');arm(pc)
 report.update(final=state(),result_count=regs()[0]&65535,own_moves=read(output,340).hex(),conflicts=read(long(a5-0x30f8),17408).hex(),summaries=[])
 pointer=long(a5-0xae2);seen=set()
 while pointer:
  assert pointer not in seen;seen.add(pointer);assert len(seen)<=266;raw=read(pointer,14);report['summaries'].append(dict(pointer=pointer,raw=raw.hex()));pointer=int.from_bytes(raw[:4],'big')
 report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n');print('Candidates',len(report['candidates']),'own retained',report['result_count'],flush=True)
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
