#!/usr/bin/env python3
"""Replay original CODE36+18c local pool refinement from complete CODE37 streams."""
import argparse,ctypes as C,gzip,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-local-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete'];assert hashlib.sha256((ROOT/'resources/CODE/36_36.bin').read_bytes()).hexdigest()==j['code36_sha256']
U8=C.c_uint8;U16=C.c_uint16;U32=C.c_uint32;I16=C.c_int16
class Pool(C.Structure):
 _fields_=[('records',(U8*66)*90),('count',U16),('cutoff_bits',U32),('column_cache',I16*16),('unseen_count',U16),('aggregate_leave_bits',U32),('letter_leave',U16*128),('letter_values',U16*128),('per_tile_adjustment',I16),('priority_letters',U8*4),('distinct_letters',U8*28),('available',U8*128)]
build=ROOT/'.build';library=build/'late-pool-select.dylib';subprocess.run(['cc','-std=c99','-shared','-fPIC','-Wall','-Wextra','-Werror',str(ROOT/'reconstruction/late_pool_select.c'),'-o',str(library)],check=True);lib=C.CDLL(str(library));choose=((U16*8)*17)();flat=struct.unpack('>136H',bytes.fromhex(j['fixed']['binomial']))
for i in range(17):choose[i][:]=flat[i*8:i*8+8]
for call_index,c in enumerate(j['calls']):
 s=Pool();initial=c['initial'];enumeration=c['enumeration'];g=bytes.fromhex(initial['globals'])
 def field(off,n):return g[0x8da-off:0x8da-off+n]
 s.count=initial['pool_count'];s.cutoff_bits=int.from_bytes(field(0x780,4),'big');s.unseen_count=int.from_bytes(field(0x82e,2),'big');s.aggregate_leave_bits=int.from_bytes(field(0x784,4),'big');s.per_tile_adjustment=int.from_bytes(field(0x71e,2),'big',signed=True);s.letter_leave[:]=struct.unpack('>128H',field(0x888,256));s.letter_values[:]=struct.unpack('>128H',bytes.fromhex(j['fixed']['letter_values']));s.priority_letters[:]=[int.from_bytes(field(o,2),'big') for o in (0x828,0x82c,0x826,0x82a)];s.available[:]=bytes.fromhex(enumeration['counts'])
 alphabet=bytes.fromhex(j['fixed']['alphabet']).split(b'\0')[0];letters=bytes(x for x in alphabet if s.available[x]);s.distinct_letters[:len(letters)]=letters
 raw=bytes.fromhex(initial['pool_records']);C.memmove(s.records,raw,len(raw));assert s.count==90
 for i,pointer in enumerate(struct.unpack('>16I',bytes.fromhex(initial['column_cache']))):
  offset=pointer-initial['pool_base'];s.column_cache[i]=offset//66 if offset>=0 and offset%66==0 and offset<90*66 else -1
 occ=((U16*8)*128)();flat=struct.unpack('>1024H',bytes.fromhex(enumeration['occurrences']))
 for i in range(128):occ[i][:]=flat[i*8:i*8+8]
 bitmap=(U8*(1<<s.unseen_count))(*([255]*(1<<s.unseen_count)));board=(U8*544).from_buffer_copy(bytes.fromhex(enumeration['board']))
 for candidate in c['candidates']:
  move=(U8*34).from_buffer_copy(bytes.fromhex(candidate['move']));used=(U8*128).from_buffer_copy(bytes.fromhex(candidate['used']));lib.maven_refine_late_pool_reply(C.byref(s),move,U16(candidate['new_tiles']),used,board,occ,choose,bitmap)
 expected=bytes.fromhex(c['final']['pool_records']);actual=bytes(s.records)[:len(expected)];differences=[(i//66,i%66,x,y) for i,(x,y) in enumerate(zip(actual,expected)) if x!=y];assert not differences,(call_index,differences[:20])
 for i,pointer in enumerate(struct.unpack('>16I',bytes.fromhex(c['final']['column_cache']))):
  offset=pointer-c['final']['pool_base'];slot=offset//66 if offset>=0 and offset%66==0 and offset<90*66 else -1
  assert s.column_cache[i]==slot,(call_index,i,s.column_cache[i],slot)
print(json.dumps(dict(scope=__doc__,calls=len(j['calls']),callbacks=sum(len(c['candidates']) for c in j['calls']),all_records_and_column_cache_match=True)))
