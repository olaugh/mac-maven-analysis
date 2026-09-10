#!/usr/bin/env python3
"""Capture complete natural CODE45 endgame leaf expansion and phase checkpoints."""
import argparse,gzip,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=2);p.add_argument('--skip',type=int,default=0);p.add_argument('--fresh-search',action='store_true');p.add_argument('--trace-bounds',action='store_true');a=p.parse_args()
requested_leaf=a.skip+1
command('stop');r=Remote();r.sock.settimeout(180);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def save():a.output.write_bytes(gzip.compress((json.dumps(report,indent=2)+'\n').encode()))
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);bases={};identities=[]
 fresh_caller=None
 if a.fresh_search:
  assert a.skip>=1,'fresh search warms the first leaf; target must be later'
  slot=a5+0x89a;arm(slot);print('Waiting for fresh original endgame search',flush=True);r.command('c');assert regs()[17]==slot;clear();stub=read(slot,6)
  if stub==bytes.fromhex('3f3c001ea9f0'):
   r.command('s');r.command('s');arm(slot);r.command('c');assert regs()[17]==slot;clear();stub=read(slot,6)
  assert stub[:2]==bytes.fromhex('4ef9');target=int.from_bytes(stub[2:],'big');arm(target);r.command('c');assert regs()[17]==target;clear();fresh_caller=long(regs()[15])
  arm(target-0x14e+0x344);r.command('c');assert regs()[17]==target-0x14e+0x344;clear()
  a.skip-=1

 for rid,slot,off in [(45,0xaf2,0x2b8),(30,0x89a,0x14e),(29,0x86a,0x2c),(37,0xa32,0x548),(39,0xa52,4),(40,0xa8a,0x9c),(43,0xaa2,4),(27,0x82a,0x26),(53,0xd72,4)]:
  stub=read(a5+slot,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-off;code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:];bases[rid]=base;identities.append(dict(code_resource=rid,sha256=hashlib.sha256(code).hexdigest()))
 base=bases[45];pool=long(a5-0x2ecc);capacity=long(a5-0x2ec8)
 def snapshot():
  out={name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('sorted_rack',0x3204,8),('canonical_masks',0x3304,256),('tile_points',0x3406,256),('occurrence_masks',0x4c0c,2048),('best',0x58aa,512),('second',0x30d0,512),('row_flags',0x6d2,32),('upper_scores',0x650,40),('lower_scores',0x628,40),('best_empty_move',0x5a32,34)]}
  out.update(new_tiles=word(a5-0x4e2a),row_zero_count=word(a5-0x4c0e),rows=[word(a5-d) for d in (0x430a,0x430c)],columns=[word(a5-d) for d in (0x4306,0x4308)],mask_count=word(a5-0x3306),ranking=dict(moves=read(a5-0x5a10,340).hex(),count=word(a5-0x30fc),cutoff=long(a5-0xade)),tables={name:read(long(a5-off),2304).hex() for name,off in [('own_a',0x30f0),('own_b',0x30f4),('own_error',0x30ec),('other_a',0x30e4),('other_b',0x30e8),('other_error',0x30e0)]},nodes=read(pool,32*capacity).hex(),free_head=word(a5-0xace),current=(long(a5-0xad2)-pool)//32,propagation_correction=long(a5-0xad6),propagation_mask=word(a5-0xad8),conflicts=read(long(a5-0x30f8),17408).hex())
  out['summaries']=[];pointer=long(a5-0xae2);seen=set()
  while pointer:
   assert pointer not in seen;seen.add(pointer);assert len(seen)<=266;raw=read(pointer,14);out['summaries'].append(dict(pointer=pointer,raw=raw.hex()));pointer=int.from_bytes(raw[:4],'big')
  return out
 fixed={name:read(a5-off,n).hex() for name,off,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('bit_masks',0x662a,128),('hash_table',0x468,64)]};fixed['alphabet']=read(long(a5-0x662e),28).hex();fixed['bingo_bonus']=word(a5-0x65aa)
 report=dict(requested_leaf=requested_leaf,fresh_search=a.fresh_search,scope=__doc__,a5=a5,pool=pool,capacity=capacity,identities=identities,fixed=fixed,calls=[])
 source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12;assert read(data_base,len(source))==source;report['dictionary_sha256']=hashlib.sha256(source).hexdigest();report['sections']=[]
 for i in range(16):
  pointer,root=struct.unpack('>II',read(a5-0x2eb8+8*i,8))
  if not root:break
  report['sections'].append(dict(offset=pointer-data_base,root=root))
 entry=json.loads(Path('analysis/toolchain/endgame-search-dispatch-live.json').read_text());finish=fresh_caller if fresh_caller is not None else int.from_bytes(bytes.fromhex(entry['stack'])[:4],'big');sites={base+0x2e8:'generation',base+0x3f4:'candidates',base+0x3fc:'replies',base+0x404:'continuations'}
 for i in range(a.count+a.skip):
  leaf_number=i+1+int(a.fresh_search)
  arm(base+0x2b8)
  if not a.skip:arm(finish)
  if i%50==0 or i>=a.skip:print('Waiting for leaf',leaf_number,flush=True)
  r.command('c');g=regs();clear()
  if i<a.skip:
   assert g[17]==base+0x2b8;r.command('s');continue
  if a.skip:
   report['fixed']['letter_values']=read(a5-0x6bee,256).hex();report['fixed']['bingo_bonus']=word(a5-0x65aa)
  if g[17]==finish:report['solver_completed']=True;break
  assert g[17]==base+0x2b8;caller,own,other=struct.unpack('>3I',read(g[15],12));call=dict(leaf_number=leaf_number,own=read(own,8).hex(),other=read(other,8).hex(),initial=snapshot(),phases=[])
  for site in sites:arm(site)
  candidate_return=None;bound_return=None;bound_pointers=None
  if a.trace_bounds:arm(base+4);arm(bases[27]+0x26);call['candidates']=[]
  arm(caller)
  while True:
   r.command('c');g=regs();pc=g[17]
   if pc==caller:break
   if a.trace_bounds and pc==base+4:
    candidate_return,move_pointer=struct.unpack('>2I',read(g[15],8))
    candidate=dict(move=read(move_pointer,34).hex(),new_tiles=word(a5-0x4e2a),upper_before=read(a5-0x650,40).hex(),lower_before=read(a5-0x628,40).hex(),free_before=word(a5-0xace))
    if not call['candidates']:call['bounds_initial']=snapshot()
    call['candidates'].append(candidate);arm(candidate_return)
   elif a.trace_bounds and pc==bases[27]+0x26:
    bound_return,_,up,lo,emp,comp=struct.unpack('>6I',read(g[15],24));bound_pointers=(up,lo,emp,comp);arm(bound_return)
   elif a.trace_bounds and pc==bound_return:
    up,lo,emp,comp=bound_pointers;candidate['reply_result']=dict(upper=long(up),lower=long(lo),empty=word(emp),compatible=word(comp),pruned=g[0]&65535)
    assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);bound_return=None
    r.command('s');continue
   elif a.trace_bounds and pc==candidate_return:
    candidate.update(upper_after=read(a5-0x650,40).hex(),lower_after=read(a5-0x628,40).hex(),free_after=word(a5-0xace))
    assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);candidate_return=None
    r.command('s');continue
   else:
    assert pc in sites;call['phases'].append(dict(name=sites[pc],state=snapshot()));print('leaf',leaf_number,sites[pc],flush=True)
   assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');arm(pc)
  clear();call.update(final=snapshot(),final_own=read(own,8).hex(),final_other=read(other,8).hex());report['calls'].append(call);print('leaf',leaf_number,'finished',flush=True);save()
 report['complete']=True;save()
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;save()
