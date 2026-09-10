#!/usr/bin/env python3
"""Replay natural CODE42 mask-weight calls with exact scratch-count side effects."""
import argparse,ctypes as C,gzip,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-pool-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete'];assert hashlib.sha256((ROOT/'resources/CODE/42_42.bin').read_bytes()).hexdigest()==j['identities']['42']
U8=C.c_uint8;U16=C.c_uint16
class State(C.Structure):_fields_=[('unique_mask',U16),('total',U16),('multiple_letters',U8*28)]
build=ROOT/'.build';build.mkdir(exist_ok=True);library=build/'pool-weights.dylib';subprocess.run(['cc','-std=c99','-shared','-fPIC','-Wall','-Wextra','-Werror',str(ROOT/'reconstruction/pool_weights.c'),'-o',str(library)],check=True);lib=C.CDLL(str(library));lib.maven_count_pool_racks.restype=U16
choose=((U16*8)*17)();flat=struct.unpack('>136H',bytes.fromhex(j['binomial']))
for i in range(17):choose[i][:]=flat[i*8:i*8+8]
for i,c in enumerate(j['weight_calls']):
 state=State();state.unique_mask=c['unique_mask'];state.total=c['total'];state.multiple_letters[:]=bytes.fromhex(c['multiple_letters'])[:28];counts=(U8*128).from_buffer_copy(bytes.fromhex(c['counts']));occ=((U16*8)*128)();flat=struct.unpack('>1024H',bytes.fromhex(c['occurrences']))
 for n in range(128):occ[n][:]=flat[n*8:n*8+8]
 result=lib.maven_count_pool_racks(C.byref(state),counts,U16(c['mask']),occ,choose)
 assert result==c['result'],(i,c['mask'],result,c['result']);assert bytes(counts).hex()==c['final_counts'],(i,'count side effects')
print(json.dumps(dict(scope=__doc__,calls=len(j['weight_calls']),all_weights_and_scratch_state_match=True)))
