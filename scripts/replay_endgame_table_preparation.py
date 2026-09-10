#!/usr/bin/env python3
"""Replay original CODE39 depth-table construction; Includes CODE43 preprocessing when its entry inputs are captured."""
import argparse,ctypes as C,hashlib,json,struct,subprocess,tempfile
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/endgame-table-preparation-live.json'));a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete'];root=Path(__file__).resolve().parents[1];assert hashlib.sha256((root/'resources/CODE/39_39.bin').read_bytes()).hexdigest()==j['code_sha256']
if j.get('code43_sha256'):assert hashlib.sha256((root/'resources/CODE/43_43.bin').read_bytes()).hexdigest()==j['code43_sha256']
def words(raw):return (C.c_uint16*(len(raw)//4))(*struct.unpack('>'+str(len(raw)//4)+'H',bytes.fromhex(raw)))
def longs(raw):return (C.c_uint32*(len(raw)//8))(*struct.unpack('>'+str(len(raw)//8)+'I',bytes.fromhex(raw)))
cb=C.CFUNCTYPE(None,C.c_void_p);errors=[];depths=[]
with tempfile.TemporaryDirectory() as tmp:
 library=Path(tmp)/'tables.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/endgame_rack_bounds.c'),str(root/'reconstruction/rack_masks.c'),'-o',str(library)],check=True)
 lib=C.CDLL(str(library));fn=lib.maven_prepare_endgame_rack_bounds;wp=C.POINTER(C.c_uint16);lp=C.POINTER(C.c_uint32);fn.argtypes=[wp,wp,wp,C.c_void_p,wp,C.c_uint,wp,lp,lp,cb,C.c_void_p];fn.restype=C.c_uint
 prep=lib.maven_prepare_endgame_mask_scores;prep.argtypes=[lp,lp,C.c_void_p,wp,C.c_uint,wp,wp,wp,cb,C.c_void_p]
 for i,call in enumerate(j['calls']):
  tables={name:words(raw) for name,raw in call['before'].items()};canonical=words(call['canonical_masks']);points=words(call['tile_points']);best=longs(call['best']);second=longs(call['second']);rack=bytes.fromhex(call['sorted_rack'])
  if call.get('score_preparation_input'):
   pre=call['score_preparation_input'];best=longs(pre['best']);second=longs(pre['second']);letter_values=words(pre['letter_values']);occurrences=words(pre['occurrence_masks'])
   prep(best,second,rack,canonical,call['mask_count'],points,letter_values,occurrences,cb(lambda _:errors.append('score diagnostic')),None)
   assert struct.pack('>128I',*best).hex()==call['best'],(i,'prepared best')
   assert struct.pack('>128I',*second).hex()==call['second'],(i,'prepared second')
  depth=fn(tables['a'],tables['b'],tables['error'],rack,canonical,call['mask_count'],points,best,second,cb(lambda _:errors.append('diagnostic')),None);depths.append(depth);assert not errors,(i,errors)
  for name,table in tables.items():
   actual=struct.pack('>1152H',*table).hex();expected=call['after'][name]
   if actual!=expected:
    aa=bytes.fromhex(actual);ee=bytes.fromhex(expected);off=next(k for k,(x,y) in enumerate(zip(aa,ee)) if x!=y);raise AssertionError((i,name,'mask',off//18,'depth',(off%18)//2,aa[off:off+2].hex(),ee[off:off+2].hex()))
print(json.dumps(dict(scope=__doc__,calls=len(j['calls']),convergence_depths=depths,all_table_words_match=True)))
