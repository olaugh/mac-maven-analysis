#!/usr/bin/env python3
"""Compare every original exhaustive opponent rack and its multiplicity/order."""
import argparse,ctypes as C,json,struct,subprocess
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/opponent-samples-live.json'));a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete']
subprocess.run(['cc','-shared','-fPIC','-std=c99','-Wall','-Wextra','-Werror','reconstruction/opponent_samples.c','-o','.build/opponent-samples.dylib'],check=True)
lib=C.CDLL('.build/opponent-samples.dylib');cbtype=C.CFUNCTYPE(C.c_int16,C.c_void_p,C.c_void_p,C.c_uint32);fn=lib.maven_enumerate_opponent_samples;fn.argtypes=[C.c_void_p,C.c_void_p,C.c_void_p,cbtype,C.c_void_p];fn.restype=C.c_int16
counts=C.create_string_buffer(bytes.fromhex(j['counts']));alphabet=C.create_string_buffer(bytes.fromhex(j['alphabet']));raw=bytes.fromhex(j['choose']);choose=(C.c_uint16*(len(raw)//2))(*struct.unpack('>'+str(len(raw)//2)+'H',raw));actual=[]
def emit(user,rack,weight):
 i=len(actual);actual.append(dict(rack=C.string_at(rack).decode(),weight=weight));assert i<len(j['samples']);return j['samples'][i]['return_word']
cb=cbtype(emit);result=fn(counts,alphabet,choose,cb,None)
assert actual==[{k:s[k] for k in ['rack','weight']} for s in j['samples']]
assert result==j['return_word'];assert counts.raw[:128].hex()==j['counts']
print(json.dumps(dict(scope=__doc__,samples=len(actual),total_weight=sum(x['weight'] for x in actual),all_matched=True),indent=2))
