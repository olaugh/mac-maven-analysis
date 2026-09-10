#!/usr/bin/env python3
"""Compare portable opening placement order and restored rack counts to original trace."""
import ctypes
import hashlib
import json
from pathlib import Path
import subprocess
import argparse

ROOT=Path(__file__).resolve().parents[1]
class Section(ctypes.Structure):
    _fields_=[('records',ctypes.c_void_p),('root_index',ctypes.c_int32)]
class Placement(ctypes.Structure):
    _fields_=[('word',ctypes.c_ubyte*16),('row',ctypes.c_ubyte),('column',ctypes.c_ubyte),('adjustment_bits',ctypes.c_uint32),('section',ctypes.c_int16)]
Callback=ctypes.CFUNCTYPE(None,ctypes.c_void_p,ctypes.POINTER(Placement),ctypes.c_void_p)
class Enumeration(ctypes.Structure):
    _fields_=[('sections',ctypes.POINTER(Section)),('remaining',ctypes.c_ubyte*128),('vowel_characters',ctypes.c_void_p),('letter_multipliers',ctypes.c_void_p),('word_multipliers',ctypes.c_void_p),('placement',Callback),('user',ctypes.c_void_p)]

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/opening-generator-live.json');a=parser.parse_args()
    capture=json.loads(a.capture.read_text());assert capture['complete']
    data=(ROOT/'../../media/maven/session/share/maven2.1').read_bytes();assert hashlib.sha256(data).hexdigest()==capture['dictionary_sha256']
    source=ctypes.create_string_buffer(data);sections=(Section*(len(capture['sections'])+1))()
    for i,s in enumerate(capture['sections']):sections[i]=Section(ctypes.addressof(source)+s['offset'],s['root'])
    state=Enumeration();state.sections=sections
    ctypes.memmove(state.remaining,bytes.fromhex(capture['counts']),128)
    buffers=[]
    for field in ('vowel_characters','letter_multipliers','word_multipliers'):
        raw=capture[field].encode('ascii') if field=='vowel_characters' else bytes.fromhex(capture[field])
        buffer=ctypes.create_string_buffer(raw);buffers.append(buffer);setattr(state,field,ctypes.addressof(buffer))
    placements=[]
    def emit(user,pointer,remaining):
        p=pointer.contents
        placements.append(dict(word=bytes(p.word).split(b'\0')[0].decode('ascii'),row=p.row,column=p.column,adjustment_bits=p.adjustment_bits,section=p.section,remaining_counts=ctypes.string_at(remaining,128).hex()))
    callback=Callback(emit);state.placement=callback
    build=ROOT/'.build';build.mkdir(exist_ok=True);lib=build/'opening-placements.dylib'
    subprocess.run(['cc','-shared','-fPIC','-O2','-std=c99','-Wall','-Wextra','-Werror',str(ROOT/'reconstruction/opening_placements.c'),'-o',str(lib)],check=True)
    api=ctypes.CDLL(str(lib));api.maven_enumerate_opening_placements.argtypes=[ctypes.POINTER(Enumeration)]
    api.maven_enumerate_opening_placements(ctypes.byref(state))
    assert len(placements)==len(capture['placements']),(len(placements),len(capture['placements']))
    for i,(actual,expected) in enumerate(zip(placements,capture['placements'])):assert actual==expected,(i,actual,expected)
    assert bytes(state.remaining).hex()==capture['final_counts']
    print(json.dumps(dict(scope='Opening placement stream before evaluation/exclusion; full order, word, coordinates, adjustment and remaining counts',placements=len(placements),all_matched=True)))

if __name__=='__main__':main()
