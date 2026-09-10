#!/usr/bin/env python3
"""Capture a complete natural CODE36 search at stage boundaries, without injected calls."""
import argparse,gzip,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--coverage',action='store_true');p.add_argument('--output',type=Path,required=True);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def disarm(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def save():a.output.write_bytes(gzip.compress(json.dumps(report,separators=(',',':')).encode()))
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);slot=a5+0xa1a
 arm(slot);print('Waiting for natural full late search',flush=True);r.command('c');assert regs()[17]==slot;disarm(slot);stub=read(slot,6)
 if stub==bytes.fromhex('3f3c0024a9f0'):
  r.command('s');r.command('s');arm(slot);r.command('c');assert regs()[17]==slot;disarm(slot);stub=read(slot,6)
 assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x1810;raw=Path('resources/CODE/36_36.bin').read_bytes();assert read(base+4,len(raw)-4)==raw[4:]
 arm(base+0x1810);r.command('c');g=regs();assert g[17]==base+0x1810;disarm(g[17]);caller=long(g[15]);rack=long(g[15]+4)
 report=dict(coverage=[],scope=__doc__,a5=a5,base=base,caller=caller,rack_pointer=rack,force=word(g[15]+8),identities={'36':hashlib.sha256(raw).hexdigest()},checkpoints=[])
 def verify_code(rid,slot_offset,entry_offset):
  st=read(a5+slot_offset,6);assert st[:2]==bytes.fromhex('4ef9'),(rid,st.hex());address=int.from_bytes(st[2:],'big')-entry_offset
  original=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();actual=read(address+4,len(original)-4);expected=bytearray(original)
  if rid==32:
   known=next(x for x in json.loads(Path('analysis/toolchain/floating-trap-rewrites-live.json').read_text())['resources'] if x['code_resource']==32);assert known['source_sha256']==hashlib.sha256(original).hexdigest()
   for change in known['differences']:assert expected[change['offset']]==change['original'];expected[change['offset']]=change['live']
  elif rid==35:
   known=json.loads(Path('analysis/toolchain/late-constants-live.json').read_text())['code35'];assert known['source_sha256']==hashlib.sha256(original).hexdigest()
   for change in known['differences']:
    off=change['offset'];before=bytes.fromhex(change['source']);after=bytes.fromhex(change['runtime']);assert expected[off:off+len(before)]==before;expected[off:off+len(before)]=after
  assert actual in (original[4:],bytes(expected[4:])),rid
  report['identities'][str(rid)]=dict(source_sha256=hashlib.sha256(original).hexdigest(),runtime_body_sha256=hashlib.sha256(actual).hexdigest(),identity='source' if actual==original[4:] else 'exact_prior_SANE_rewrite_fingerprint')
 def state():
  s={name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('unseen_counts',0x31fc,128),('used',0x317c,128),('leave',0x440c,256),('tile_points',0x3406,256),('occurrences',0x4c0c,2048),('mask_generations',0x4e20,512),('canonical_masks',0x3304,256),('balance_entries',0xa98,256),('globals',0x8da,0x260),('column_cache',0x8d6,64),('ranking',0x5a10,340),('row_flags',0x6d2,32)]}
  s.update(leave_offset=word(a5-0x5ab4),rack=read(rack,8).hex(),sorted=read(a5-0x3204,17).hex(),pool_rack=read(a5-0x824,17).hex(),row_zero_count=word(a5-0x4c0e),new_tiles=word(a5-0x4e2a),recorded_row=[word(a5-d) for d in (0x430a,0x430c)],recorded_column=[word(a5-d) for d in (0x4306,0x4308)],main_triple=word(a5-0x5bc2),ranking_count=word(a5-0x30fc),mask_count=word(a5-0x3306),generation=long(a5-0x4e24),started_generation=long(a5-0x4e28),balance_pool_vowels=long(a5-0x998),balance_pool_consonants=long(a5-0x994),lookup_stamps=[long(long(a5-0x98c)+10*i+4) for i in range(word(a5-0x97e))])
  return s
 report['initial']=state();report['fixed']={name:read(a5-off,n).hex() for name,off,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('tables',0x65a8,0x510),('bit_masks',0x662a,128)]};report['fixed']['alphabet']=read(long(a5-0x662e),28).hex();report['priority_order']=read(long(a5-0x8da),28).hex();report['exchange_q_string']=read(a5-0x710,8).hex()
 source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12;assert read(data_base,len(source))==source;report['dictionary_sha256']=hashlib.sha256(source).hexdigest();report['sections']=[]
 for i in range(16):
  pointer,root=struct.unpack('>II',read(a5-0x2eb8+i*8,8))
  if not root:break
  report['sections'].append(dict(offset=pointer-data_base,root=root))
 sites={0x1b34:'pool_ready',0x1b3c:'pool_selected',0x1ca6:'merge_ready',0x1cb2:'pool_merged',0x1d4e:'pool_prepared',0x1efe:'constraints_ready',0x1f0c:'leaves_ready',0x204c:'pass_ranked',0x2068:'own_ranked',0x2080:'local_begin',0x21a0:'local_generated',0x2368:'local_finished'}
 coverage_sites={}
 if a.coverage:
  for off in (0x93a,0xa4c,0xaae,0xab8,0xbba,0xc0c,0xc5c,0xc84,0xd88,0xe98,0xee8,0xf2a,0xf50,0xf5a,0xf88,0xfc8,0x1046,0x1078,0x10c2,0x10e6):
   coverage_sites[base+off]=f'36:{off:04x}';arm(base+off)
 # 0x21a0 is checked against the disassembly before use below.
 sites.pop(0x21a0)
 for off in sites:arm(base+off)
 arm(caller);fp=None;save()
 while True:
  r.command('c');g=regs();pc=g[17]
  if pc==caller:report['final']=state();break
  if pc in coverage_sites:
   report['coverage'].append(coverage_sites.pop(pc));disarm(pc);continue
  off=pc-base;assert off in sites
  if off==0x1b3c:
   for spec in [(31,0x942,0x184),(32,0x99a,0xefa),(37,0xa3a,4),(42,0xa92,4)]:verify_code(*spec)
   if a.coverage:
    b32=int.from_bytes(read(a5+0x99a,6)[2:],'big')-0xefa
    for offset in (0xb34,0xb46,0xb68,0xb8a):coverage_sites[b32+offset]=f'32:{offset:04x}';arm(b32+offset)
  if off==0x1d4e:verify_code(35,0x9da,0xa48)
  if off==0x1efe:verify_code(43,0xaba,0x314)
  fp=g[14];s=state();s.update(registers=g,pool_base=fp-0x1860,local_base=fp-0x2f94,pool_records=read(fp-0x1860,90*66).hex(),local_records=read(fp-0x2f94,90*66).hex(),anchor_masks=read(fp-0x32a6,62).hex(),constraint_masks=read(fp-0x3268,362).hex(),constraint_weights=read(fp-0x30fe,362).hex(),current_move=read(fp-0x12c,34).hex())
  if off in (0x1efe,0x1f0c,0x204c,0x2068,0x2080,0x2368):
   s['conflicts']=read(long(a5-0x30f8),17408).hex()
   # Flatten constraints while retaining the original guest tokens in records.
   s['lists']={}
   for label,ptr in [('baseline',long(a5-0x790)),('local',long(a5-0x78c))]:
    rows=[];seen=set()
    while ptr:
     assert ptr not in seen and len(seen)<100;seen.add(ptr);rec=read(ptr,66);cp=int.from_bytes(rec[50:54],'big');indices=[]
     if cp:
      for i in range(190):
       index=word(cp+2*i);indices.append(index)
       if not index:break
      else:raise AssertionError('unterminated constraint list')
     rows.append(dict(pointer=ptr,record=rec.hex(),constraints=indices));ptr=int.from_bytes(rec[:4],'big')
    s['lists'][label]=rows
  report['checkpoints'].append(dict(kind=sites[off],offset=off,state=s));save();print(sites[off],'rank count',s['ranking_count'],flush=True)
  disarm(pc);r.command('s');arm(pc)
 report['complete']=True;save();print('Complete late search',report['final']['ranking_count'],flush=True)
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;save()
