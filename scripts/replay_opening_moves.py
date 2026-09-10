#!/usr/bin/env python3
"""Compare complete portable scored-opening stream and preliminary top ten to original."""
import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import struct
import subprocess
from replay_opening_generator import Section, Enumeration
from replay_candidate_ranking import CandidateList
from replay_board_placements import Enumeration as BoardEnumeration

ROOT=Path(__file__).resolve().parents[1]
Diagnostic=ctypes.CFUNCTYPE(None,ctypes.c_void_p)
MoveCallback=ctypes.CFUNCTYPE(None,ctypes.c_void_p,ctypes.c_void_p)
Filter=ctypes.CFUNCTYPE(ctypes.c_int,ctypes.c_void_p,ctypes.c_void_p)
class ScoreInput(ctypes.Structure):
    _fields_=[(name,ctypes.c_void_p) for name in ('board','values','letter_values','word_multipliers','letter_multipliers','letter_class','alphabet')]+[('diagnostic',Diagnostic),('user',ctypes.c_void_p)]
class OpeningMoves(ctypes.Structure):
    _fields_=[('enumeration',Enumeration),('scoring',ScoreInput),('sorted_rack',ctypes.c_void_p),('leave_values',ctypes.c_void_p),('move',MoveCallback),('user',ctypes.c_void_p)]

class BoardMoves(ctypes.Structure):
    _fields_=[('enumeration',BoardEnumeration),('scoring',ScoreInput),('sorted_rack',ctypes.c_void_p),('leave_values',ctypes.c_void_p),('move',MoveCallback),('user',ctypes.c_void_p)]

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/opening-scored-generator-live.json');a=p.parse_args()
    j=json.loads(a.capture.read_text());assert j['complete']
    data=(ROOT/'../../media/maven/session/share/maven2.1').read_bytes();assert hashlib.sha256(data).hexdigest()==j['dictionary_sha256']
    buffers=[]
    def buffer(raw):
        obj=ctypes.create_string_buffer(raw);buffers.append(obj);return ctypes.addressof(obj)
    def words(hex_data):
        raw=bytes.fromhex(hex_data);obj=(ctypes.c_uint16*(len(raw)//2))(*struct.unpack('>'+str(len(raw)//2)+'H',raw));buffers.append(obj);return ctypes.addressof(obj)
    data_pointer=buffer(data);sections=(Section*(len(j['sections'])+1))()
    for i,s in enumerate(j['sections']):sections[i]=Section(data_pointer+s['offset'],s['root'])
    board_mode=j.get("board_mode",False)
    state=BoardMoves() if board_mode else OpeningMoves();state.enumeration.sections=sections
    ctypes.memmove(state.enumeration.remaining,bytes.fromhex(j['counts']),128)
    if board_mode:state.enumeration.board=buffer(bytes.fromhex(j['scoring']['board']))
    else:state.enumeration.vowel_characters=buffer(j['vowel_characters'].encode('ascii'))
    for name in ('letter_multipliers','word_multipliers'):
        address=buffer(bytes.fromhex(j[name]));setattr(state.enumeration,name,address);setattr(state.scoring,name,address)
    for name in ('board','letter_class','alphabet'):setattr(state.scoring,name,buffer(bytes.fromhex(j['scoring'][name])))
    for name in ('values','letter_values'):setattr(state.scoring,name,words(j['scoring'][name]))
    state.leave_values=words(j['scoring']['leave_values']);state.sorted_rack=buffer(j['scoring']['sorted_rack'].encode('ascii'))
    errors=[];diagnostic=Diagnostic(lambda user:errors.append('scorer diagnostic'));state.scoring.diagnostic=diagnostic
    moves=[];emit=MoveCallback(lambda user,move:moves.append(ctypes.string_at(move,34).hex()));state.move=emit
    build=ROOT/'.build';build.mkdir(exist_ok=True);library=build/'opening-moves.dylib'
    sources=('opening_moves','opening_placements','dictionary_lookup','rack_masks','score_move','score_accumulate','candidate_ranking')
    if board_mode:sources=tuple(n for n in sources if n not in ('opening_moves','opening_placements'))+('board_moves','board_placements','board_state','cross_check_letters')
    subprocess.run(['cc','-shared','-fPIC','-O2','-std=c99','-Wall','-Wextra','-Werror',*[str(ROOT/f'reconstruction/{name}.c') for name in sources],'-o',str(library)],check=True)
    api=ctypes.CDLL(str(library));generate=api.maven_generate_board_moves if board_mode else api.maven_generate_opening_moves
    generate.argtypes=[ctypes.POINTER(type(state))]
    generate(ctypes.byref(state));assert not errors,errors
    assert len(moves)==len(j['scored_moves']),(len(moves),len(j['scored_moves']))
    for i,(actual,expected) in enumerate(zip(moves,j['scored_moves'])):assert actual==expected,(i,actual,expected)
    ranking=CandidateList();ctypes.memmove(ranking.moves,bytes.fromhex(j['initial_ranking']['moves']),340)
    ranking.count=j['initial_ranking']['count'];ranking.cutoff_bits=j['initial_ranking']['cutoff_bits']
    api.maven_accept_word_improvement.argtypes=[ctypes.POINTER(CandidateList),ctypes.c_void_p]
    api.maven_insert_ranked_candidate.argtypes=[ctypes.POINTER(CandidateList),ctypes.c_void_p,Filter,ctypes.c_void_p]
    extra=j['extra_filter_pointer'];assert not extra or extra-j['a5']==0xad2
    eligible=Filter(lambda user,move:api.maven_accept_word_improvement(ctypes.byref(ranking),move) if extra else 1)
    for move in moves:api.maven_insert_ranked_candidate(ctypes.byref(ranking),bytes.fromhex(move),eligible,None)
    actual=dict(moves=bytes(ranking.moves).hex(),count=ranking.count,cutoff_bits=ranking.cutoff_bits)
    assert actual==j['final_ranking'],(actual,j['final_ranking'])
    print(json.dumps(dict(scope='Complete placement traversal, scoring, section deduplication, move metadata and preliminary top ten; original leave table and initial exchange seed supplied; final collector reranking excluded',placements=len(j['placements']),scored_moves=len(moves),ranked=ranking.count,all_matched=True)))

if __name__=='__main__':main()
