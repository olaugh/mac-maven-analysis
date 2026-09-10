#!/usr/bin/env python3
"""Observe natural CODE36 pool generation and CODE42 mask weights; no injected calls."""
import argparse,hashlib,json,re,struct,gzip
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--entry',type=Path,default=Path('analysis/toolchain/late-search-dispatch-02-live.json'));p.add_argument('--output',type=Path,required=True);a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def disarm(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def clear():
 for addr in list(points):disarm(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
def save():
 data=(json.dumps(report,separators=(',',':'))+'\n').encode()
 if a.output.suffix=='.gz':data=gzip.compress(data)
 a.output.write_bytes(data)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 entry=json.loads(a.entry.read_text());a5=long(0x904);base=entry['base'];assert a5==entry['a5'];assert regs()[17]==base+0x1810
 code=Path('resources/CODE/36_36.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 report=dict(scope=__doc__,entry=entry,identities={'36':hashlib.sha256(code).hexdigest()},candidates=[],weight_calls=[],checkpoints=[])
 def state():
  n=word(a5-0x30fc);assert 0<=n<=90
  return dict(count=n,base=long(a5-0x30dc),records=read(long(a5-0x30dc),n*66).hex(),counts=read(a5-0x5ab2,128).hex(),used=read(a5-0x317c,128).hex(),occurrences=read(a5-0x4c0c,2048).hex(),sorted=read(a5-0x3204,17).hex(),globals=read(a5-0x8da,0x260).hex(),cache=read(a5-0x8d6,64).hex())
 run(base+0x1b2c)
 stub=read(a5+0xa92,6);assert stub[:2]==bytes.fromhex('4ef9');base42=int.from_bytes(stub[2:],'big')-4;code42=Path('resources/CODE/42_42.bin').read_bytes();assert read(base42+4,len(code42)-4)==code42[4:];report['identities']['42']=hashlib.sha256(code42).hexdigest()
 fp=regs()[14];report['leave_values']=read(a5-0x440c,256).hex();report['fixed']={name:read(a5-off,n).hex() for name,off,n in [('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128)]};report['fixed']['alphabet']=read(long(a5-0x662e),28).hex()
 report.update(pool=read(a5-0x824,17).hex(),unseen_counts=read(fp-0xa4,128).hex(),distinct=read(fp-0xe6,32).hex(),binomial=read(a5-0x65a8,17*16).hex(),letter_values=read(a5-0x6bee,256).hex(),row_flags=read(a5-0x6d2,32).hex(),initial=state(),weights_setup=dict(unique_mask=word(a5-0x684)&65535,total=word(a5-0x682),multiple_letters=read(a5-0x6a0,32).hex()))
 save()
 sites={base+0x6de:'select_pool',base+0x4da:'merge_pool',base+0x1b3c:'selected_pool',base+0x1cb2:'merged_pool',base+0x1d4e:'prepared_pool',base+0x1efe:'finish',base42+0xa8:'weight'}
 for site in sites:arm(site)
 while True:
  r.command('c');g=regs();pc=g[17];assert pc in sites;kind=sites[pc]
  if kind in ('select_pool','merge_pool'):
   move=long(g[15]+4);report['candidates'].append(dict(kind=kind,move=read(move,34).hex(),new_tiles=word(a5-0x4e2a),used=read(a5-0x317c,128).hex()))
   if len(report['candidates'])%250==0:print('Pool candidates',len(report['candidates']),flush=True)
  elif kind=='weight':
   caller,counts,mask=struct.unpack('>IIH',read(g[15],10));call=dict(mask=mask,counts=read(counts,128).hex(),unique_mask=word(a5-0x684)&65535,total=word(a5-0x682),multiple_letters=read(a5-0x6a0,32).hex(),occurrences=read(a5-0x4c0c,2048).hex());disarm(pc);arm(caller);r.command('c');assert regs()[17]==caller;disarm(caller);arm(pc);call['result']=regs()[0]&65535;call['final_counts']=read(counts,128).hex();report['weight_calls'].append(call);continue
  else:
   report['checkpoints'].append(dict(kind=kind,state=state()));print(kind,len(report['candidates']),len(report['weight_calls']),flush=True);save()
   if kind=='finish':break
  disarm(pc);r.command('s');arm(pc)
 report['complete']=True;save()
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;save()
