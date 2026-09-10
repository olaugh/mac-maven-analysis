#!/usr/bin/env python3
"""Capture complete CODE30 search, restored iteration states, clocks and final rankings."""
import argparse,gzip,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--entry',type=Path,default=Path('analysis/toolchain/endgame-search-dispatch-02-live.json'));p.add_argument('--wait',action='store_true');p.add_argument('--save-every',type=int,default=1);a=p.parse_args();assert a.save_every>0
command('stop');r=Remote();r.sock.settimeout(180);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def save():
 # Atomic replacement keeps every saved prefix readable during long captures.
 temporary=a.output.with_name(a.output.name+'.partial')
 temporary.write_bytes(gzip.compress((json.dumps(report,indent=2)+'\n').encode(),compresslevel=1))
 temporary.replace(a.output)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);bases={};identities=[]
 if a.wait:
  slot=a5+0x89a;arm(slot);print('Waiting for natural endgame selector entry',flush=True);r.command('c');assert regs()[17]==slot;clear();stub=read(slot,6)
  if stub==bytes.fromhex('3f3c001ea9f0'):
   r.command('s');r.command('s');arm(slot);r.command('c');assert regs()[17]==slot;clear();stub=read(slot,6)
  assert stub[:2]==bytes.fromhex('4ef9');target=int.from_bytes(stub[2:],'big');arm(target);r.command('c');assert regs()[17]==target;clear()
 for rid,slot,off in [(30,0x89a,0x14e)]:
  stub=read(a5+slot,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-off;code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];bases[rid]=base;identities.append(dict(code_resource=rid,sha256=hashlib.sha256(code).hexdigest()))
 base=bases[30];pool=long(a5-0x2ecc);capacity=long(a5-0x2ec8)
 def snapshot():
  out={name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('sorted_rack',0x3204,8),('canonical_masks',0x3304,256),('tile_points',0x3406,256),('occurrence_masks',0x4c0c,2048),('best',0x58aa,512),('second',0x30d0,512),('row_flags',0x6d2,32),('upper_scores',0x650,40),('lower_scores',0x628,40),('best_empty_move',0x5a32,34),('leave_values',0x440c,256),('letter_values',0x6bee,256)]}
  out.update(new_tiles=word(a5-0x4e2a),row_zero_count=word(a5-0x4c0e),rows=[word(a5-d) for d in (0x430a,0x430c)],columns=[word(a5-d) for d in (0x4306,0x4308)],mask_count=word(a5-0x3306),ranking=dict(moves=read(a5-0x5a10,340).hex(),count=word(a5-0x30fc),cutoff=long(a5-0xade)),tables={name:read(long(a5-off),2304).hex() for name,off in [('own_a',0x30f0),('own_b',0x30f4),('own_error',0x30ec),('other_a',0x30e4),('other_b',0x30e8),('other_error',0x30e0)]},nodes=read(pool,32*capacity).hex(),free_head=word(a5-0xace),current=(long(a5-0xad2)-pool)//32,propagation_correction=long(a5-0xad6),propagation_mask=word(a5-0xad8),conflicts=read(long(a5-0x30f8),17408).hex())
  out.update(bingo_bonus=word(a5-0x65aa),reserve_control=word(a5-0xacc),rack0=read(a5-0x3c9a,8).hex(),rack1=read(a5-0x3ca2,8).hex())
  out['summaries']=[];pointer=long(a5-0xae2);seen=set()
  while pointer:
   assert pointer not in seen;seen.add(pointer);assert len(seen)<=266;raw=read(pointer,14);out['summaries'].append(dict(pointer=pointer,raw=raw.hex()));pointer=int.from_bytes(raw[:4],'big')
  return out
 fixed={name:read(a5-off,n).hex() for name,off,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('bit_masks',0x662a,128),('hash_table',0x468,64)]};fixed['alphabet']=read(long(a5-0x662e),28).hex();fixed['bingo_bonus']=word(a5-0x65aa)
 report=dict(scope=__doc__,a5=a5,pool=pool,capacity=capacity,identities=identities,fixed=fixed,calls=[],hash_entry_seed=long(a5-0xdc4))
 source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12;assert read(data_base,len(source))==source;report['dictionary_sha256']=hashlib.sha256(source).hexdigest();report['sections']=[]
 for i in range(16):
  pointer,root=struct.unpack('>II',read(a5-0x2eb8+8*i,8))
  if not root:break
  report['sections'].append(dict(offset=pointer-data_base,root=root))
 assert regs()[17]==base+0x14e;caller,own,budget=struct.unpack('>3I',read(regs()[15],12));other=a5-0x3ca2 if own==a5-0x3c9a else a5-0x3c9a
 report.update(own_pointer=own,other_pointer=other,own=read(own,8).hex(),other=read(other,8).hex(),budget=budget,initial=snapshot(),iterations=[],elapsed=[],leaf_entries=[],collections=[])
 sites={base+0x174:'start_clock',base+0x33a:'leaf_entry',base+0x344:'leaf_return',base+0x45a:'iteration',base+0x472:'elapsed',base+0x4c4:'ranking',base+0xb4e:'before_collection',base+0xb66:'marked_for_collection',base+0xb74:'after_collection'}
 for site in sites:arm(site)
 arm(caller);verified=False
 print('Running complete original endgame search',flush=True)
 while True:
  r.command('c');g=regs();pc=g[17]
  if pc==caller:break
  assert pc in sites;kind=sites[pc]
  if kind=='start_clock':report['start_ticks']=long(g[14]-0x6e2)
  elif kind=='leaf_entry':
   current_own=long(g[14]+8);current_other=g[12];report['leaf_entries'].append(dict(current=(long(a5-0xad2)-pool)//32,own=read(current_own,8).hex(),other=read(current_other,8).hex(),board=read(a5-0x4302,544).hex()))
  elif kind=='leaf_return' and not verified:
   report['initialized_hash_table']=read(a5-0x468,64).hex()
   report['hash_after_seed']=long(a5-0xdc4)
   for rid,slot,off in [(45,0xaf2,0x2b8),(29,0x86a,0x2c),(37,0xa32,0x548),(39,0xa52,4),(40,0xa8a,0x9c),(43,0xaa2,4),(27,0x82a,0x26),(53,0xd72,4)]:
    stub=read(a5+slot,6);assert stub[:2]==bytes.fromhex('4ef9');code_base=int.from_bytes(stub[2:],'big')-off;code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(code_base+4,len(code)-4)==code[4:];report['identities'].append(dict(code_resource=rid,sha256=hashlib.sha256(code).hexdigest()))
   verified=True
  elif kind=='iteration':
   state=snapshot();state.update(next_frontier=(long(g[14]-0x676)-pool)//32,optimistic=(long(g[14]-0x67a)-pool)//32,alternative=0 if not long(g[14]-0x682) else (long(g[14]-0x682)-pool)//32,guaranteed=0 if not long(g[14]-0x67e) else (long(g[14]-0x67e)-pool)//32,initial_reserve=word(g[14]-0x6de));report['iterations'].append(state);print('iteration',len(report['iterations']),'free',state['free_head'],'frontier',state['next_frontier'],flush=True)
   if len(report['iterations'])%a.save_every==0:save()
  elif kind=='elapsed':report['elapsed'].append(dict(result=g[0],ticks=long(0x16a)))
  elif kind=='ranking':report['before_ranking']=snapshot()
  elif kind in ('before_collection','marked_for_collection','after_collection'):
   report['collections'].append(dict(kind=kind,state=snapshot()));print(kind,len(report['collections']),flush=True);save()
  assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');arm(pc)
 clear();report.update(final=snapshot(),result_pointer=regs()[0],final_own=read(own,8).hex(),final_other=read(other,8).hex(),complete=True);save();print('Completed',len(report['iterations']),'iterations',flush=True)

finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;save()
