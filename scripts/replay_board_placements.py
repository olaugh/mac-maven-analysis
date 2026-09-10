#!/usr/bin/env python3
"""Compare entire occupied-board placement order to an original CODE37 call."""
import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import subprocess
from replay_opening_generator import Section

ROOT=Path(__file__).resolve().parents[1]
class Placement(ctypes.Structure):
    _fields_=[('word',ctypes.c_ubyte*16),('row',ctypes.c_ubyte),('column',ctypes.c_ubyte),('section',ctypes.c_int16)]
Callback=ctypes.CFUNCTYPE(None,ctypes.c_void_p,ctypes.POINTER(Placement),ctypes.c_void_p)
class Enumeration(ctypes.Structure):
    _fields_=[('sections',ctypes.POINTER(Section)),('board',ctypes.c_void_p),('letter_multipliers',ctypes.c_void_p),('word_multipliers',ctypes.c_void_p),('remaining',ctypes.c_ubyte*128),('row_anchor_masks',ctypes.c_void_p),('placement',Callback),('user',ctypes.c_void_p)]

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/board-generator-live.json');a=parser.parse_args()
    j=json.loads(a.capture.read_text());assert j['complete'] and j['board_mode']
    data=(ROOT/'../../media/maven/session/share/maven2.1').read_bytes();assert hashlib.sha256(data).hexdigest()==j['dictionary_sha256']
    buffers=[]
    def buffer(raw):
        b=ctypes.create_string_buffer(raw);buffers.append(b);return ctypes.addressof(b)
    source=buffer(data);sections=(Section*(len(j['sections'])+1))()
    for i,s in enumerate(j['sections']):sections[i]=Section(source+s['offset'],s['root'])
    state=Enumeration();state.sections=sections;state.board=buffer(bytes.fromhex(j['scoring']['board']))
    state.letter_multipliers=buffer(bytes.fromhex(j['letter_multipliers']));state.word_multipliers=buffer(bytes.fromhex(j['word_multipliers']))
    ctypes.memmove(state.remaining,bytes.fromhex(j['counts']),128)
    placements=[]
    def emit(user,record,remaining):
        p=record.contents;placements.append(dict(word=bytes(p.word).split(b'\0')[0].decode('ascii'),row=p.row,column=p.column,adjustment_bits=0,section=p.section,remaining_counts=ctypes.string_at(remaining,128).hex()))
    callback=Callback(emit);state.placement=callback
    build=ROOT/'.build';build.mkdir(exist_ok=True);library=build/'board-placements.dylib'
    sources=['board_placements','board_state','cross_check_letters','dictionary_lookup']
    subprocess.run(['cc','-shared','-fPIC','-O2','-std=c99','-Wall','-Wextra','-Werror',*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(library)],check=True)
    api=ctypes.CDLL(str(library));api.maven_enumerate_board_placements.argtypes=[ctypes.POINTER(Enumeration)]
    api.maven_enumerate_board_placements(ctypes.byref(state))
    assert len(placements)==len(j['placements']),(len(placements),len(j['placements']))
    for i,(actual,expected) in enumerate(zip(placements,j['placements'])):assert actual==expected,(i,actual,expected)
    assert bytes(state.remaining).hex()==j['final_counts']
    print(json.dumps(dict(scope='Complete occupied-board placement stream before section deduplication/scoring/ranking',placements=len(placements),all_matched=True)))

if __name__=='__main__':main()
