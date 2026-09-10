#!/usr/bin/env python3
"""Compare tag0 saved-board reconstruction with the original enum8 tag0 return.

Board/value/rack/score fields are compared; UI, history traversal and refills
are outside this component check. Racks here contain seven tiles, so no stale
bytes follow their terminators. Host malformed-input tests are separate.
"""
import argparse,ctypes as C,json,struct,subprocess,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--capture',type=Path,default=root/'analysis/toolchain/history-snapshot-live.json');args=parser.parse_args()
j=json.loads(args.capture.read_text());assert j['complete']
for rid,digest in j['identities'].items():
 import hashlib
 assert hashlib.sha256((root/f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==digest
save=(root/'../../media/maven/session/share/maven-search-enum8').read_bytes()
assert struct.unpack_from('>hh',save)==(0,300) and len(save)==304 and save[4:].hex()==j['payload']
p=(C.c_uint8*300).from_buffer_copy(save[4:]);board=(C.c_uint8*544)();values=(C.c_uint16*544)();racks=((C.c_uint8*8)*2)();totals=(C.c_uint32*2)();side=C.c_int(-1)
letters=(C.c_uint16*128)(*struct.unpack('>128H',bytes.fromhex(j['initial']['letter_values'])))
C.memmove(board,bytes.fromhex(j['initial']['board']),544)
for i in range(2):C.memmove(racks[i],bytes.fromhex(j['initial'][f'rack{i}']),8)
with tempfile.TemporaryDirectory() as tmp:
 libpath=Path(tmp)/'snapshot.dylib'
 subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib','reconstruction/history_snapshot.c','reconstruction/display_board.c','reconstruction/history_records.c','-o',str(libpath)],cwd=root,check=True)
 lib=C.CDLL(str(libpath));lib.maven_restore_history_snapshot.argtypes=[C.POINTER(C.c_uint8),C.c_size_t,C.POINTER(C.c_uint8),C.POINTER(C.c_uint16),C.POINTER(C.c_uint8*8),C.POINTER(C.c_uint32),C.POINTER(C.c_int),C.POINTER(C.c_uint16)]
 assert lib.maven_restore_history_snapshot(p,300,board,values,racks,totals,C.byref(side),letters)==1
 for name,actual in [('board',bytes(board)),('values',struct.pack('>544H',*values)),('rack0',bytes(racks[0])),('rack1',bytes(racks[1]))]:
  expected=bytes.fromhex(j['events'][0]['state'][name]);assert actual==expected,(name,[(i,x,y) for i,(x,y) in enumerate(zip(actual,expected)) if x!=y][:12])
 assert side.value==0 and list(totals)==j['events'][0]['state']['totals']
 if 'display_board' in j:
  display=(C.c_uint8*289).from_buffer_copy(bytes.fromhex(j['display_board']));previous=(C.c_uint8*289).from_buffer_copy(bytes.fromhex(j['previous_display_board']));classes=(C.c_uint8*128).from_buffer_copy(bytes.fromhex(j['letter_class']))
  assert lib.maven_rebuild_display_board(display,previous,j['force_board_refresh'],classes,letters,board,values)==1
  final=j['events'][-1];assert final['kind']=='rebuild_return'
  assert bytes(board).hex()==final['state']['board']
  assert struct.pack('>544H',*values).hex()==final['state']['values']
 class Record(C.Structure):_fields_=[('tag',C.c_int8),('length',C.c_uint16),('payload',C.POINTER(C.c_uint8))]
 wire=(C.c_uint8*len(save)).from_buffer_copy(save);record=Record();count=C.c_size_t()
 lib.maven_decode_history_records.argtypes=[C.POINTER(C.c_uint8),C.c_size_t,C.POINTER(Record),C.c_size_t,C.POINTER(C.c_size_t)]
 assert lib.maven_decode_history_records(wire,len(save),C.byref(record),1,C.byref(count))==0
 assert count.value==1 and record.tag==0 and record.length==300 and C.string_at(record.payload,record.length)==save[4:]

print(json.dumps(dict(scope=__doc__,original_fields=['board','values','rack0','rack1','totals','selected_side'],display_rebuild_compared='display_board' in j,all_matched=True)))
