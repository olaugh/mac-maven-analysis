#!/usr/bin/env python3
"""Replay every CODE36+6de pool-selection callback through its retained90 records."""
import argparse,ctypes as C,gzip,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-pool-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()))
assert hashlib.sha256((ROOT/'resources/CODE/36_36.bin').read_bytes()).hexdigest()==j['identities']['36']
U8=C.c_uint8;U16=C.c_uint16;U32=C.c_uint32;I16=C.c_int16
class Pool(C.Structure):
 _fields_=[('records',(U8*66)*90),('count',U16),('cutoff_bits',U32),('column_cache',I16*16),('unseen_count',U16),('aggregate_leave_bits',U32),('letter_leave',U16*128),('letter_values',U16*128),('per_tile_adjustment',I16),('priority_letters',U8*4),('distinct_letters',U8*28),('available',U8*128)]
build=ROOT/'.build';build.mkdir(exist_ok=True);libpath=build/'late-pool-select.dylib';subprocess.run(['cc','-std=c99','-shared','-fPIC','-Wall','-Wextra','-Werror',str(ROOT/'reconstruction/late_pool_select.c'),'-o',str(libpath)],check=True);lib=C.CDLL(str(libpath));s=Pool();initial=j['initial'];globals=bytes.fromhex(initial['globals'])
def field(offset,n):return globals[0x8da-offset:0x8da-offset+n]
s.count=initial['count'];assert s.count==0;s.cutoff_bits=int.from_bytes(field(0x780,4),'big');s.unseen_count=int.from_bytes(field(0x82e,2),'big');s.aggregate_leave_bits=int.from_bytes(field(0x784,4),'big');s.per_tile_adjustment=int.from_bytes(field(0x71e,2),'big',signed=True)
s.letter_leave[:]=struct.unpack('>128H',field(0x888,256));s.letter_values[:]=struct.unpack('>128H',bytes.fromhex(j['letter_values']));s.priority_letters[:]=[int.from_bytes(field(o,2),'big') for o in (0x828,0x82c,0x826,0x82a)];s.distinct_letters[:]=bytes.fromhex(j['distinct'])[:28];s.available[:]=bytes.fromhex(initial['counts'])
for i,pointer in enumerate(struct.unpack('>16I',bytes.fromhex(initial['cache']))):
 offset=pointer-initial['base'];s.column_cache[i]=offset//66 if offset>=0 and offset%66==0 and offset<90*66 else -1
calls=[c for c in j['candidates'] if c['kind']=='select_pool']
for c in calls:lib.maven_select_late_pool_reply(C.byref(s),(U8*34).from_buffer_copy(bytes.fromhex(c['move'])),U16(c['new_tiles']),(U8*128).from_buffer_copy(bytes.fromhex(c['used'])))
expected=next(c['state'] for c in j['checkpoints'] if c['kind']=='selected_pool');assert s.count==expected['count'];records=bytes.fromhex(expected['records']);differences=[]
# Initial unused stack bytes are not defined by this collector. Compare every
# field it writes, including all34 move bytes, and its cache/cutoff outputs.
defined=list(range(4,8))+list(range(14,50))+list(range(58,65))
for i in range(s.count):
 for k in defined:
  if s.records[i][k]!=records[i*66+k]:differences.append((i,k,s.records[i][k],records[i*66+k]))
assert not differences,differences[:15]
for i,pointer in enumerate(struct.unpack('>16I',bytes.fromhex(expected['cache']))):
 offset=pointer-expected['base'];slot=offset//66 if offset>=0 and offset%66==0 and offset<90*66 else -1
 assert s.column_cache[i]==slot,(i,s.column_cache[i],slot)
expected_globals=bytes.fromhex(expected['globals']);assert s.cutoff_bits==int.from_bytes(expected_globals[0x8da-0x780:0x8da-0x77c],'big')
print(json.dumps(dict(scope=__doc__,callbacks=len(calls),retained=s.count,rejected_over_seven=sum(c['new_tiles']>7 for c in calls),all_defined_fields_and_cache_match=True)))

# The second pool pass receives the selected records, with the exact explicit
# mask/multiplicity initialization between CODE36+1b5a and1b86.
for i in range(s.count):
 s.records[i][:]=records[i*66:(i+1)*66]
 s.records[i][50:54]=[0]*4;s.records[i][54:56]=[255]*2;s.records[i][56:58]=[0]*2
choose=((U16*8)*17)();flat=struct.unpack('>136H',bytes.fromhex(j['binomial']))
for i in range(17):choose[i][:]=flat[i*8:i*8+8]
occ=((U16*8)*128)();flat=struct.unpack('>1024H',bytes.fromhex(initial['occurrences']))
for i in range(128):occ[i][:]=flat[i*8:i*8+8]
board=bytes.fromhex(j['entry']['board']);board_and_values=board+bytes.fromhex(j['entry']['values']);bitmap=(U8*(1<<s.unseen_count))(*([255]*(1<<s.unseen_count)))
merge_calls=[c for c in j['candidates'] if c['kind']=='merge_pool']
for c in merge_calls:
 raw=bytes.fromhex(c['move']);end=raw[32]*17+raw[33]+len(raw.split(b'\0')[0]);inherited=(U8*4).from_buffer_copy(board_and_values[end+61:end+65]);used=(U8*128).from_buffer_copy(bytes.fromhex(c['used']))
 lib.maven_merge_late_pool_reply(C.byref(s),(U8*34).from_buffer_copy(raw),U16(c['new_tiles']),used,(U8*544).from_buffer_copy(board),occ,choose,bitmap,inherited)
expected=next(c['state'] for c in j['checkpoints'] if c['kind']=='merged_pool');records=bytes.fromhex(expected['records']);differences=[]
for i in range(s.count):
 for k in range(66):
  if s.records[i][k]!=records[i*66+k]:differences.append((i,k,s.records[i][k],records[i*66+k]))
assert not differences,differences[:20]
print(json.dumps(dict(scope='CODE36 second pool pass',callbacks=len(merge_calls),all66_byte_records_match=True)))
