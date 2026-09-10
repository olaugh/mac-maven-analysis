#!/usr/bin/env python3
"""Trace completed natural CODE30 tree operations, paused at a verified solver entry."""
import argparse,gzip,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--entry',type=Path,default=Path('analysis/toolchain/endgame-search-dispatch-live.json'));p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=128);p.add_argument('--resume',action='store_true');p.add_argument('--kinds');a=p.parse_args()
command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big')
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def save():
 raw=(json.dumps(report,indent=2)+'\n').encode()
 if a.output.suffix=='.gz':a.output.write_bytes(gzip.compress(raw))
 else:a.output.write_bytes(raw)
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
 xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 entry=json.loads(a.entry.read_text());a5=long(0x904);assert a5==entry['a5'];base=entry['base'];code=Path('resources/CODE/30_30.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 if not a.resume:assert regs()[17]==base+0x14e
 outer_return=int.from_bytes(bytes.fromhex(entry['stack'])[:4],'big');pool=long(a5-0x2ecc);capacity=long(a5-0x2ec8);assert 1<capacity<32768
 def snapshot():return dict(nodes=read(pool,32*capacity).hex(),current_pointer=long(a5-0xad2),free_head=word(a5-0xace))
 sites={0xf8:'reset',0x8be:'select',0x924:'bounds',0x9c6:'prune',0xac6:'sweep',0xaf8:'mark',0xb46:'allocate',0xbbc:'prepend',0xc22:'add_move',0xcd2:'expand_move'}
 if a.kinds:sites={off:kind for off,kind in sites.items() if kind in a.kinds.split(',')}
 report=dict(scope=__doc__,entry=entry,pool=pool,capacity=capacity,calls=[],code_sha256=hashlib.sha256(code).hexdigest(),solver_completed=False)
 for i in range(a.count):
  for off in sites:arm(base+off)
  arm(outer_return);r.command('c');g=regs();pc=g[17];clear()
  if pc==outer_return:report['solver_completed']=True;break
  off=pc-base;assert off in sites;return_address=long(g[15]);call=dict(kind=sites[off],offset=off,stack=read(g[15],32).hex(),before=snapshot())
  if off==0xc22:call.update(move=read(long(g[15]+4),34).hex(),board=read(a5-0x4302,544).hex())
  if off==0xcd2:call.update(move_before=read(long(g[15]+4),34).hex(),board=read(a5-0x4302,544).hex())
  arm(return_address);r.command('c');assert regs()[17]==return_address;clear();call['result']=regs()[0];after=snapshot()
  if after['nodes']==call['before']['nodes']:after['nodes']='unchanged'
  call['after']=after
  if off==0xcd2:call['move_after']=read(int.from_bytes(bytes.fromhex(call['stack'])[4:8],'big'),34).hex()
  report['calls'].append(call);print(i+1,call['kind'],flush=True)
 report['complete']=True;save()
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;save()
