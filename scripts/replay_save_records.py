#!/usr/bin/env python3
"""Replay captured natural save payloads through the reconstructed writer."""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True)
    args=p.parse_args();j=json.loads(args.capture.read_text());assert j['complete_loaded_code_matches']
    assert all(x['error']==0 for x in j['results'])
    write=C.CFUNCTYPE(C.c_int16,C.c_void_p,C.c_int16,C.POINTER(C.c_int32),C.c_void_p)
    size=C.CFUNCTYPE(C.c_int32,C.c_void_p,C.c_size_t)
    lock=C.CFUNCTYPE(C.c_void_p,C.c_void_p,C.c_size_t)
    unlock=C.CFUNCTYPE(None,C.c_void_p,C.c_size_t)
    class Ops(C.Structure):_fields_=[('user',C.c_void_p),('write',write),('size',size),('lock',lock),('unlock',unlock)]
    rows=[];mutation=iter(j['tag1_mutations'])
    with tempfile.TemporaryDirectory() as temp:
        libpath=Path(temp)/'save.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib','reconstruction/save_record.c','-o',str(libpath)],check=True)
        lib=C.CDLL(str(libpath));fn=lib.maven_write_save_record;fn.argtypes=[C.c_int8,C.c_size_t,C.c_int16,C.POINTER(Ops)];fn.restype=None
        for i in range(0,len(j['writes']),3):
            group=j['writes'][i:i+3];tag=int.from_bytes(bytes.fromhex(group[0]['bytes_hex']),'big',signed=True)
            payload=bytearray.fromhex(group[2]['bytes_hex']);before=after=None
            if tag==1:
                before=bytes.fromhex(next(mutation)['word_hex']);after=bytes.fromhex(next(mutation)['word_hex']);payload[4:6]=before
            buffer=C.create_string_buffer(bytes(payload));emitted=[];unlocked=[]
            def emit(u,f,n,ptr):emitted.append(C.string_at(ptr,n[0]));return 0
            def release(u,h):unlocked.append(C.string_at(C.addressof(buffer)+4,2) if tag==1 else b'')
            ops=Ops(None,write(emit),size(lambda u,h:len(payload)),lock(lambda u,h:C.addressof(buffer)),unlock(release))
            fn(tag,1,group[0]['reference'],C.byref(ops))
            assert emitted==[bytes.fromhex(x['bytes_hex']) for x in group]
            if tag==1:assert unlocked==[b'\0\0'] and C.string_at(C.addressof(buffer)+4,2)==after==before
            rows.append(dict(tag=tag,length=len(payload),all_write_bytes_match=True,restoration_matches=tag!=1 or before==after))
    print(json.dumps(dict(scope='C record-writer replay from captured payloads and original tag-1 pre-save word; not full save orchestration',records=rows,
                         capture_sha256=hashlib.sha256(args.capture.read_bytes()).hexdigest(),source_sha256=hashlib.sha256(Path('reconstruction/save_record.c').read_bytes()).hexdigest()),indent=2))

if __name__=='__main__':main()
