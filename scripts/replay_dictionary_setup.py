#!/usr/bin/env python3
"""Replay dictionary-table installation against natural debugger evidence."""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--data-file',type=Path,required=True)
    p.add_argument('--capture',type=Path,required=True)
    args=p.parse_args();capture=json.loads(args.capture.read_text());data=args.data_file.read_bytes()
    digest=lambda b:hashlib.sha256(b).hexdigest()
    assert digest(data)==capture['data_sha256']
    assert capture['caller']['code_resource']==2 and capture['caller']['complete_loaded_code_matches']
    assert digest(Path('resources/CODE/2_2.bin').read_bytes())==capture['caller']['sha256']
    class State(C.Structure):
        _fields_=[('roots',C.c_uint32*2),('tables',C.c_void_p*2)]
    diagnostic=C.CFUNCTYPE(None,C.c_void_p);calls=[]
    callback=diagnostic(lambda _:calls.append('diagnostic'))
    with tempfile.TemporaryDirectory() as tmp:
        libpath=Path(tmp)/'setup.dylib'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',
                        'reconstruction/dictionary_setup.c','reconstruction/dictionary_tables.c','reconstruction/whole_file.c',
                        'reconstruction/error_context.c','-o',str(libpath)],check=True)
        lib=C.CDLL(str(libpath));fn=lib.maven_install_dictionary
        fn.argtypes=[C.c_void_p,C.POINTER(State),diagnostic,C.c_void_p];fn.restype=None
        buffer=C.create_string_buffer(data);state=State();fn(buffer,C.byref(state),callback,None)
        offsets=[ptr-C.addressof(buffer) for ptr in state.tables]
        records=[C.string_at(ptr+4*root,4).hex() for ptr,root in zip(state.tables,state.roots)]
    observed=capture['dictionary_setup']
    assert list(state.roots)==observed['roots']
    assert offsets==[ptr-capture['return_pointer'] for ptr in observed['tables']]
    assert records==observed['root_records_hex'] and not calls
    print(json.dumps(dict(scope='C table-installation replay against natural setup return; load-error and diagnostic paths not live-verified',
                         matches=True,roots=list(state.roots),table_offsets=offsets,root_records_hex=records,
                         diagnostics=len(calls),capture_sha256=digest(args.capture.read_bytes()),
                         source_sha256=digest(Path('reconstruction/dictionary_tables.c').read_bytes())),indent=2))

if __name__=='__main__':main()
