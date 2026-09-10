#!/usr/bin/env python3
"""Replay a natural undo helper invocation through reconstructed C."""
import argparse,ctypes as C,hashlib,json,struct,subprocess,tempfile
from pathlib import Path

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True);a=p.parse_args()
    root=Path(__file__).resolve().parents[1];j=json.loads(a.capture.read_text());before=j['initial'];after=j['result']
    assert hashlib.sha256((root/'resources/CODE/31_31.bin').read_bytes()).hexdigest()==j['code31_sha256']
    byte=C.c_uint8;word=C.c_uint16
    def array(name):return (byte*len(bytes.fromhex(before[name]))).from_buffer_copy(bytes.fromhex(before[name]))
    board=array('board');undo=array('undo');rack=array('rack');values=(word*544)(*struct.unpack('>544H',bytes.fromhex(before['values'])));counter=C.c_int16(before['row_zero_count'])
    callback=C.CFUNCTYPE(None,C.c_void_p);diagnostics=[];diagnostic=callback(lambda _:diagnostics.append(True))
    class State(C.Structure):_fields_=[('board',C.POINTER(byte)),('values',C.POINTER(word)),('undo',C.POINTER(byte)),('row_zero_count',C.POINTER(C.c_int16)),('diagnostic',callback),('user',C.c_void_p)]
    state=State(board,values,undo,C.pointer(counter),diagnostic,None)
    with tempfile.TemporaryDirectory() as temp:
        library=Path(temp)/'undo.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/undo_move.c'),str(root/'reconstruction/board_state.c'),'-o',str(library)],check=True)
        lib=C.CDLL(str(library));lib.maven_undo_move.argtypes=[C.POINTER(byte),C.POINTER(State)];lib.maven_undo_move(rack,C.byref(state))
    assert not diagnostics
    assert bytes(board).hex()==after['board'];assert struct.pack('>544H',*values).hex()==after['values']
    assert bytes(rack).hex()==after['rack'];assert bytes(undo).hex()==after['undo']
    assert counter.value==after['row_zero_count'] and before['counts']==after['counts']
    print(json.dumps(dict(scope='One natural undo helper replay; full board/value/rack/workspace and counter match. Count table unchanged in original. Does not establish UI Undo/history orchestration.',board_bytes_matching=544,value_words_matching=544,rack=bytes(rack).split(b'\0')[0].decode(),row_zero_count=counter.value,counts_unchanged=True,capture_sha256=hashlib.sha256(a.capture.read_bytes()).hexdigest()),indent=2))
if __name__=='__main__':main()
