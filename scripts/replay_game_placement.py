#!/usr/bin/env python3
"""Compare reconstructed placement with a naturally restored saved game.

This is a placement-only replay, not full restore: final rack refill and
counts refresh occur after placement and are deliberately not asserted.
"""
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import tempfile


def main():
    root=Path(__file__).resolve().parents[1]
    save_path=root/'analysis/toolchain/save-new-game-live.json'
    restore_path=root/'analysis/toolchain/game-restore-live.json'
    save=json.loads(save_path.read_text());restore=json.loads(restore_path.read_text())
    assert save['name']==restore['name'] and restore['return_value']==1
    assert save['complete_loaded_code_matches']
    for ident in restore['identities']:
        rid=ident['code_resource']
        assert hashlib.sha256((root/f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==ident['sha256']
    assert restore['code22_sha256']==save['code22_sha256']==hashlib.sha256((root/'resources/CODE/22_22.bin').read_bytes()).hexdigest()
    state=restore['state'];payload=bytes.fromhex(save['writes'][8]['bytes_hex'])
    byte=C.c_uint8;word=C.c_uint16;bp=C.POINTER(byte);wp=C.POINTER(word)
    diagnostic=C.CFUNCTYPE(None,C.c_void_p)
    class State(C.Structure):
        _fields_=[('board',bp),('values',wp),('counts',bp),('letter_values',wp),('premium_codes',bp),('undo',bp),('diagnostic',diagnostic),('user',C.c_void_p)]
    class Result(C.Structure):
        _fields_=[('undo_end',C.c_int16),('special_score',C.c_int16)]
    board=(byte*544)();values=(word*544)();counts=(byte*128)();undo=(byte*33)();premium=(byte*544)()
    letters=(word*128)(*struct.unpack('>128H',bytes.fromhex(state['letter_values'])))
    move=(byte*len(payload)).from_buffer_copy(payload);rack=C.create_string_buffer(payload[36:44])
    alphabet=C.create_string_buffer(b'?abcdefghijklmnopqrstuvwxyz');diagnostics=[]
    callback=diagnostic(lambda _:diagnostics.append(True))
    placement=State(board,values,counts,letters,premium,undo,callback,None)
    undo[0]=payload[32]
    with tempfile.TemporaryDirectory() as temp:
        library=Path(temp)/'placement.dylib'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',*[str(root/'reconstruction'/x) for x in ('place_letters.c','board_state.c','rack_counts.c','move_finalize.c')],'-o',str(library)],check=True)
        lib=C.CDLL(str(library));lib.maven_count_rack.argtypes=[bp,C.c_void_p,C.c_void_p]
        lib.maven_count_rack(counts,alphabet,rack)
        lib.maven_place_move_letters.argtypes=[bp,C.POINTER(State)];lib.maven_place_move_letters.restype=Result
        result=lib.maven_place_move_letters(move,C.byref(placement))
        lib.maven_finish_move_rack.argtypes=[bp,C.c_int16,C.c_void_p,bp,C.c_void_p,diagnostic,C.c_void_p]
        lib.maven_finish_move_rack(undo,result.undo_end,rack,counts,alphabet,callback,None)
    assert not diagnostics
    assert bytes(board)==bytes.fromhex(state['board'])
    assert struct.pack('>544H',*values)==bytes.fromhex(state['values'])
    assert bytes(undo)==bytes.fromhex(state['undo'])
    assert rack.value==b'i'
    report=dict(scope='Placement and undo/rack-finalization replay using captured move and live letter-value table; zero initial board from tag-1 semantics. Synthetic premium table; special score not checked. No claim for full restore, final racks/counts, scoring prelude or boundary cleanup.',
                board_bytes_matching=544,value_words_matching=544,undo_bytes_matching=33,
                placement_residual_rack=rack.value.decode(),natural_final_racks=[bytes.fromhex(state[k]).split(b'\0')[0].decode() for k in ('rack0','rack1')],
                natural_final_totals=state['totals'],save_capture_sha256=hashlib.sha256(save_path.read_bytes()).hexdigest(),restore_capture_sha256=hashlib.sha256(restore_path.read_bytes()).hexdigest())
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
