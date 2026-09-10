#!/usr/bin/env python3
"""Capture complete natural CODE36+14d0 pool preparation and board-pattern values."""
import argparse,gzip,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args();command('stop');r=Remote();r.sock.settimeout(60);points=set()
def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
def long(addr):return int.from_bytes(read(addr,4),'big')
def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
def clear():
 for addr in list(points):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;clear()
def save():a.output.write_bytes(gzip.compress((json.dumps(report,separators=(',',':'))+'\n').encode()))
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa';xml=r.command('qXfer:features:read:m68k-core.xml:0,fff');assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
 a5=long(0x904);stub=read(a5+0xa0a,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x113a;code=Path('resources/CODE/36_36.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
 if regs()[17]!=base+0x14d0:run(base+0x14d0)
 caller,pool=struct.unpack('>II',read(regs()[15],8));count=word(a5-0x30fc);assert 0<count<=90
 def state():return {name:read(a5-off,n).hex() for name,off,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('pool_rack',0x824,17),('new_tiles',0x4e2a,2),('row_zero_count',0x4c0e,2),('recorded_rows',0x430c,4),('recorded_columns',0x4308,4)]}
 fixed={name:read(a5-off,n).hex() for name,off,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128)]};fixed['alphabet']=read(long(a5-0x662e),28).hex();fixed['bingo_bonus']=word(a5-0x65aa)
 pattern_count=word(a5-0x2aa2);raw=read(long(a5-0x2aa6),8*pattern_count);stringbase=long(a5-0x2aa0);offsets={int.from_bytes(raw[i*8+2:i*8+4],'big',signed=True) for i in range(1,pattern_count) if int.from_bytes(raw[i*8+4:i*8+6],'big')};strings={}
 for off in offsets:
  data=read(stringbase+off,64);assert b'\0' in data;strings[str(off)]=data.split(b'\0')[0].decode('ascii')
 maximum=max(int.from_bytes(raw[i*8+4:i*8+6],'big') for i in range(1,pattern_count));patterns=dict(record_count=pattern_count,raw_records=raw.hex(),strings=strings,score_records=read(long(a5-0x2a9c),28*(maximum+1)).hex())
 stub=read(a5+0x9da,6);assert stub[:2]==bytes.fromhex('4ef9');base35=int.from_bytes(stub[2:],'big')-0xa48;code35=Path('resources/CODE/35_35.bin').read_bytes();assert read(base35+0xa48,0xcd0-0xa48)==code35[0xa48:0xcd0]
 report=dict(identity_ranges={'36':[[4,len(code)]],'35':[[0xa48,0xcd0]]},scope=__doc__,code_sha256=hashlib.sha256(code).hexdigest(),code35_sha256=hashlib.sha256(code35).hexdigest(),pool_base=pool,count=count,initial_records=read(pool,count*66).hex(),initial=state(),fixed=fixed,patterns=patterns,draw_multiplicity=read(a5-0x72e,16).hex(),total_weight=word(a5-0x730)&65535,per_tile_adjustment=word(a5-0x71e),steps=[])
 arm(base+0x154c);arm(caller)
 while True:
  r.command('c');g=regs();pc=g[17]
  if pc==caller:break
  assert pc==base+0x154c;report['steps'].append(dict(index=g[5]&65535,value=g[0],state=state()))
  assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');arm(pc)
 report.update(final_records=read(pool,count*66).hex(),final=state(),result_pointer=regs()[0],complete=True);save();print('Prepared',count,'replies; pattern calls',len(report['steps']),flush=True)
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;save()
