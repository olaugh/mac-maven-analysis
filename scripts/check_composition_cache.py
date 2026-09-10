#!/usr/bin/env python3
"""Check live cache consistency at assumed total7; not a call trace."""
import ctypes as C,json,subprocess,tempfile,hashlib
from pathlib import Path
root=Path(__file__).resolve().parents[1];p=root/'analysis/toolchain/composition-cache-live.json';j=json.loads(p.read_text());terminal=(C.c_uint32*8)(*j['terminal_total7']);rows=[]
with tempfile.TemporaryDirectory() as temp:
 library=Path(temp)/'composition.dylib';subprocess.run(['cc','-std=c99','-dynamiclib',str(root/'reconstruction/rack_composition.c'),'-o',str(library)],check=True)
 f=C.CDLL(str(library)).maven_rack_composition;f.argtypes=[C.c_int16]*5+[C.POINTER(C.c_uint32)];f.restype=C.c_uint32
 baseline=f(0,0,*j['pool_key'],7,terminal)
 for index,value in enumerate(j['cache']):
  if not value:continue
  consonants,vowels=divmod(index,8);assert vowels+consonants<=7
  predicted=(f(vowels,consonants,*j['pool_key'],7,terminal)-baseline)&0xffffffff
  rows.append(dict(vowels=vowels,consonants=consonants,original=value,predicted=predicted,matches=value==predicted))
print(json.dumps(dict(scope='Consistency check of nonzero live cache cells against total7 recurrence minus empty baseline. Total/draw input was not captured and is absent from cache key; not direct natural call validation.',all_match=all(r['matches'] for r in rows),entries=rows,capture_sha256=hashlib.sha256(p.read_bytes()).hexdigest()),indent=2))
