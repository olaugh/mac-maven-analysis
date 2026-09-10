#!/usr/bin/env python3
"""Replay original CODE39 mask arithmetic from its prepared nine-word table rows."""
import argparse,ctypes as C,hashlib,json,struct,subprocess,tempfile
from collections import Counter
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/endgame-rack-bounds-live.json'));a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete'];root=Path(__file__).resolve().parents[1];assert hashlib.sha256((root/'resources/CODE/39_39.bin').read_bytes()).hexdigest()==j['code_sha256']
class State(C.Structure):_fields_=[(name,C.c_void_p) for name in ['own_a','own_b','own_error','other_a','other_b','other_error']]
with tempfile.TemporaryDirectory() as tmp:
 library=Path(tmp)/'rack-bounds.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/endgame_rack_bounds.c'),str(root/'reconstruction/rack_masks.c'),'-o',str(library)],check=True)
 lib=C.CDLL(str(library));own=lib.maven_bound_own_rack;paired=lib.maven_bound_paired_racks;out=C.POINTER(C.c_int16);own.argtypes=[C.c_void_p,C.c_int16,out,out];paired.argtypes=[C.c_void_p,C.c_int16,C.c_int16,out,out];own.restype=paired.restype=C.c_int16
 for i,call in enumerate(j['calls']):
  arrays={name:(C.c_uint16*(128*9))(*struct.unpack('>1152H',bytes.fromhex(value))) for name,value in call['tables'].items()};state=State(*[C.addressof(arrays[name]) for name,_ in State._fields_]);positive=C.c_int16();negative=C.c_int16();args=[C.byref(state),call['own']]+([call['other']] if call['kind']=='paired' else [])+[C.byref(positive),C.byref(negative)];result=(paired if call['kind']=='paired' else own)(*args)&65535
  assert (result,positive.value,negative.value)==(call['result'],call['positive'],call['negative']),(i,(result,positive.value,negative.value),call['result'],call['positive'],call['negative'])
print(json.dumps(dict(scope=__doc__,calls=len(j['calls']),kinds=dict(Counter(c['kind'] for c in j['calls'])),all_results_and_corrections_match=True)))
