#!/usr/bin/env python3
"""Rebuild the observed history branch with a computed snapshot and bounded storage."""
import ctypes as C,json,subprocess,tempfile,hashlib
from pathlib import Path
j=json.loads(Path('analysis/toolchain/history-navigation-end6-live.json').read_text());st=j['navigation_return']
saved=json.loads(Path('analysis/toolchain/save-continued-end6-live.json').read_text());expected=b''.join(bytes.fromhex(w['bytes_hex']) for w in saved['writes'])
# The first24 records are the retained original branch. Use the immutable
# original Save trace: the shared guest file can be autosaved during later play.
original=b''.join(bytes.fromhex(w['bytes_hex']) for w in saved['writes'][:3*24])
class Record(C.Structure):_fields_=[('tag',C.c_int8),('length',C.c_uint16),('payload',C.c_void_p)]
class Store(C.Structure):_fields_=[('records',C.POINTER(Record)),('count',C.c_size_t),('record_capacity',C.c_size_t),('bytes',C.c_void_p),('used',C.c_size_t),('byte_capacity',C.c_size_t)]
with tempfile.TemporaryDirectory() as tmp:
 path=Path(tmp)/'store.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib','reconstruction/history_records.c','reconstruction/history_store.c','-o',str(path)],check=True)
 lib=C.CDLL(str(path));load=lib.maven_history_store_load;load.argtypes=[C.POINTER(Store),C.c_void_p,C.c_size_t];load.restype=C.c_int
 snap=lib.maven_history_store_snapshot;snap.argtypes=[C.POINTER(Store),*[C.c_void_p]*5];snap.restype=C.c_int
 append=lib.maven_history_store_append;append.argtypes=[C.POINTER(Store),C.c_int8,C.c_void_p,C.c_size_t];append.restype=C.c_int
 encode=lib.maven_encode_history_records;encode.argtypes=[C.POINTER(Record),C.c_size_t,C.c_void_p,C.c_size_t,C.POINTER(C.c_size_t)];encode.restype=C.c_int
 records=(Record*64)();arena=C.create_string_buffer(8192);store=Store(records,0,64,C.addressof(arena),0,len(arena));source=C.create_string_buffer(original)
 assert load(C.byref(store),source,len(original))==0 and store.count==24
 # Capacity failures preserve both the history and its byte arena.
 before=arena.raw;used=store.used;store.record_capacity=25
 board=C.create_string_buffer(bytes.fromhex(st['board']));values=(C.c_uint16*544)(*[int(st['values'][i:i+4],16) for i in range(0,len(st['values']),4)])
 # CODE7+492 uses the selected next record's original racks after replay.
 selected=bytes.fromhex(saved['writes'][3*22+2]['bytes_hex'])
 rack0=C.create_string_buffer(selected[36:44]);rack1=C.create_string_buffer(selected[44:52]);totals=(C.c_uint32*2)(*st['totals'])
 assert snap(C.byref(store),board,values,rack0,rack1,totals)==2 and store.count==24 and store.used==used and arena.raw==before
 store.record_capacity=64
 assert snap(C.byref(store),board,values,rack0,rack1,totals)==0 and store.count==26
 for i in range(26,33):
  group=saved['writes'][3*i:3*i+3];tag=int.from_bytes(bytes.fromhex(group[0]['bytes_hex']),'big',signed=True);p=bytes.fromhex(group[2]['bytes_hex']);buffer=C.create_string_buffer(p)
  assert append(C.byref(store),tag,buffer,len(p))==0
 output=C.create_string_buffer(len(expected));length=C.c_size_t()
 assert encode(records,store.count,output,len(output),C.byref(length))==0
 assert output.raw==expected,[(i,x,y) for i,(x,y) in enumerate(zip(output.raw,expected)) if x!=y][:30]
 # Full payload capacity and in-place compaction preserve exact wire bytes.
 wire=bytes.fromhex('0002000361626300040000');tight=C.create_string_buffer(3);small=(Record*3)();state=Store(small,0,3,C.addressof(tight),0,3);raw=C.create_string_buffer(wire)
 assert load(C.byref(state),raw,len(wire))==0 and state.used==3 and state.count==2
 assert append(C.byref(state),4,None,0)==0 and state.used==3
 output=C.create_string_buffer(len(wire)+4)
 assert encode(small,3,output,len(output),C.byref(length))==0 and output.raw==wire+bytes.fromhex('00040000')
 arena2=C.create_string_buffer(wire,len(wire));small2=(Record*2)();state2=Store(small2,0,2,C.addressof(arena2),0,len(arena2))
 assert load(C.byref(state2),arena2,len(wire))==0 and state2.used==3
 output=C.create_string_buffer(len(wire));assert encode(small2,2,output,len(output),C.byref(length))==0 and output.raw==wire
print(json.dumps(dict(scope=__doc__,original_records=24,computed_snapshot_and_marker=True,total_records=33,bytes=len(expected),preserved_old_future=True,capacity_failure_atomic=True,all_matched=True,wire_sha256=hashlib.sha256(expected).hexdigest())))
