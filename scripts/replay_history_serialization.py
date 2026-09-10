#!/usr/bin/env python3
"""Compare the bounded whole-file serializer with an original Save trace."""
import argparse,ctypes as C,hashlib,json,subprocess,tempfile
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True);a=p.parse_args()
j=json.loads(a.capture.read_text());assert j['complete_loaded_code_matches'] and all(x['error']==0 for x in j['results'])
wire=b''.join(bytes.fromhex(x['bytes_hex']) for x in j['writes'])
class Record(C.Structure):_fields_=[('tag',C.c_int8),('length',C.c_uint16),('payload',C.c_void_p)]
with tempfile.TemporaryDirectory() as tmp:
 libpath=Path(tmp)/'history.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib','reconstruction/history_records.c','-o',str(libpath)],check=True)
 lib=C.CDLL(str(libpath));decode=lib.maven_decode_history_records;decode.argtypes=[C.c_void_p,C.c_size_t,C.POINTER(Record),C.c_size_t,C.POINTER(C.c_size_t)];decode.restype=C.c_int
 encode=lib.maven_encode_history_records;encode.argtypes=[C.POINTER(Record),C.c_size_t,C.c_void_p,C.c_size_t,C.POINTER(C.c_size_t)];encode.restype=C.c_int
 source=C.create_string_buffer(wire);records=(Record*32767)();count=C.c_size_t();assert decode(source,len(wire),records,len(records),C.byref(count))==0
 required=C.c_size_t();assert encode(records,count.value,None,0,C.byref(required))==2 and required.value==len(wire)
 output=C.create_string_buffer(len(wire));assert encode(records,count.value,output,len(wire),C.byref(required))==0
 assert output.raw==wire and source.raw[:-1]==wire
print(json.dumps(dict(scope=__doc__,records=count.value,bytes=len(wire),all_matched=True,wire_sha256=hashlib.sha256(wire).hexdigest())))
