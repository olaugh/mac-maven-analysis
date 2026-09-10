#!/usr/bin/env python3
"""Replay original CODE39+4 correction recurrence including selected-mask writes."""
import argparse,ctypes as C,hashlib,json,struct,subprocess,tempfile
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/local-score-corrections-live.json'));a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete'];root=Path(__file__).resolve().parents[1];assert hashlib.sha256((root/'resources/CODE/39_39.bin').read_bytes()).hexdigest()==j['code_sha256']
class State(C.Structure):_fields_=[(name,C.c_void_p) for name in ['own_a','own_b','own_error','other_a','other_b','other_error']]
with tempfile.TemporaryDirectory() as tmp:
 library=Path(tmp)/'corrections.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/endgame_rack_bounds.c'),str(root/'reconstruction/rack_masks.c'),'-o',str(library)],check=True)
 lib=C.CDLL(str(library));fn=lib.maven_endgame_local_score_corrections;fn.restype=None;fn.argtypes=[C.c_void_p,C.c_uint8,C.c_int16,C.c_char_p,C.c_void_p,C.c_uint,C.c_void_p,C.c_int16,C.c_int16,C.c_void_p,C.c_void_p,C.c_void_p,C.c_void_p,C.c_void_p]
 for i,c in enumerate(j['calls']):
  arrays={name:(C.c_uint16*1152)(*struct.unpack('>1152H',bytes.fromhex(value))) for name,value in c['tables'].items()};state=State(*[C.addressof(arrays[name]) for name,_ in State._fields_]);node=bytes.fromhex(c['node']);masks=(C.c_uint16*128)(*struct.unpack('>128H',bytes.fromhex(c['masks'])));best=(C.c_uint32*128)(*struct.unpack('>128I',bytes.fromhex(c['best'])));lower=C.c_int32(c['initial_outputs'][0]);prop=C.c_int32(c['initial_outputs'][1]);mask=C.c_uint16(c['initial_outputs'][2]);diagnostics=[];callback=C.CFUNCTYPE(None,C.c_void_p)(lambda _:diagnostics.append(True))
  fn(C.byref(state),node[25],struct.unpack_from('>h',node,10)[0],bytes.fromhex(c['rack']),masks,c['mask_count'],best,*c['depths'],C.byref(lower),C.byref(prop),C.byref(mask),callback,None)
  actual=[lower.value&0xffffffff,prop.value&0xffffffff,mask.value];assert actual==c['outputs'],(i,actual,c['outputs']);assert not diagnostics,(i,'diagnostics')
print(json.dumps(dict(scope=__doc__,calls=len(j['calls']),all_corrections_and_masks_match=True)))
