#!/usr/bin/env python3
"""Replay original crossing queries into one retained64-byte output/row-flag workspace."""
import ctypes as C, hashlib,json,struct,subprocess,tempfile
from pathlib import Path
j=json.loads(Path('analysis/toolchain/cross-query-at-overlap-live.json').read_text());assert j['complete']
dictionary=Path('../../media/maven/session/share/maven2.1').read_bytes();assert hashlib.sha256(dictionary).hexdigest()==j['dictionary_sha256']
class Section(C.Structure):_fields_=[('records',C.c_void_p),('root_index',C.c_int32)]
with tempfile.TemporaryDirectory() as tmp:
 libpath=Path(tmp)/'cross.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib','reconstruction/cross_check_letters.c','reconstruction/dictionary_lookup.c','-o',str(libpath)],check=True)
 lib=C.CDLL(str(libpath));f=lib.maven_cross_check_letters;f.argtypes=[C.POINTER(Section),*[C.c_void_p]*4];f.restype=C.c_size_t
 blob=C.create_string_buffer(dictionary);roots=struct.unpack_from('>II',dictionary,4);sections=(Section*3)(Section(C.addressof(blob)+12,roots[0]),Section(C.addressof(blob)+116+4*roots[0],roots[1]),Section())
 output=C.create_string_buffer(bytes.fromhex(j['calls'][0]['before']),64)
 for index,event in enumerate(j['calls']):
  assert output.raw.hex()==event['before'],(index,'retained input')
  args=[C.create_string_buffer(event[k].encode()) for k in ('prefix','suffix','allowed')]
  count=f(sections,*args,output)
  assert count==len(event['output']) and output.raw.hex()==event['after'],(index,'output')
 assert j['calls'][j['first_overlap']]['after'][64:72]=='74767700'
 assert output.raw[32:36]==b'tvw\0'
print(json.dumps(dict(scope=__doc__,queries=len(j['calls']),first_overlap=j['first_overlap'],overlap_bytes='74767700',all64_bytes_matched=True,retained_after_short_queries=True)))
