#!/usr/bin/env python3
"""Replay a natural composition calculation through reconstructed C."""
import argparse,ctypes as C,hashlib,json,subprocess,tempfile
from pathlib import Path

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True);a=p.parse_args()
    root=Path(__file__).resolve().parents[1];j=json.loads(a.capture.read_text());source=(root/'resources/CODE/32_32.bin').read_bytes()
    assert hashlib.sha256(source).hexdigest()==j['code32_sha256']
    assert hashlib.sha256(source[0xdb0:0xefa]).hexdigest()==j['verified_range_sha256']
    raw=bytes.fromhex(j['raw_table']);terminal=[int.from_bytes(raw[24+28*i:28+28*i],'big') for i in range(j['args'][4]+1)]
    assert terminal==j['terminal_scores'];values=(C.c_uint32*len(terminal))(*terminal)
    with tempfile.TemporaryDirectory() as temp:
        library=Path(temp)/'composition.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/rack_composition.c'),'-o',str(library)],check=True)
        lib=C.CDLL(str(library));lib.maven_rack_composition.argtypes=[C.c_int16]*5+[C.POINTER(C.c_uint32)];lib.maven_rack_composition.restype=C.c_uint32
        result=lib.maven_rack_composition(*j['args'],values)
    assert result==j['result_bits'],(result,j['result_bits'])
    print(json.dumps(dict(scope='One natural composition recurrence replay using original terminal table; cache/blank wrapper and table initialization excluded',args=j['args'],result_bits=result,result_matches=True,capture_sha256=hashlib.sha256(a.capture.read_bytes()).hexdigest()),indent=2))
if __name__=='__main__':main()
