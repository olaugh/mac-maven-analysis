"""Independent exhaustive legality oracle, distinct from anchor-based recovered traversal."""
import collections
import ctypes
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

ROOT=Path(__file__).resolve().parents[1]
WORDS={'aa','ab','ba','bb','aaa','aab','aba','abb','baa','bab','bba','bbb','aabb','abab','baba'}
class Section(ctypes.Structure):
    _fields_=[('records',ctypes.c_void_p),('root_index',ctypes.c_int32)]
class Placement(ctypes.Structure):
    _fields_=[('word',ctypes.c_ubyte*16),('row',ctypes.c_ubyte),('column',ctypes.c_ubyte),('section',ctypes.c_int16)]
Callback=ctypes.CFUNCTYPE(None,ctypes.c_void_p,ctypes.POINTER(Placement),ctypes.c_void_p)
class Enumeration(ctypes.Structure):
    _fields_=[('sections',ctypes.POINTER(Section)),('board',ctypes.c_void_p),('letter_multipliers',ctypes.c_void_p),('word_multipliers',ctypes.c_void_p),('remaining',ctypes.c_ubyte*128),('row_anchor_masks',ctypes.c_void_p),('placement',Callback),('user',ctypes.c_void_p)]

def dictionary(words):
    trie={}
    for word in words:
        node=trie
        for letter in word:node=node.setdefault(letter,{})
        node['']=True
    nodes=[0x200]
    def pack(node):
        letters=sorted(k for k in node if k)
        if not letters:return 0
        base=len(nodes);nodes.extend([0]*len(letters))
        for i,letter in enumerate(letters):
            child=node[letter]
            nodes[base+i]=ord(letter)|(0x100 if '' in child else 0)|(0x200 if i==len(letters)-1 else 0)|(pack(child)<<10)
        return base
    root=pack(trie)
    return struct.pack('>'+str(len(nodes))+'I',*nodes),root

def board_with(word,row=8,column=8):
    board=bytearray(544)
    for i,letter in enumerate(word):
        board[row*17+column+i]=ord(letter)
        board[(column+i+15)*17+row]=ord(letter)
    return board

def exhaustive(board,rack):
    results=set()
    for row in range(1,31):
        for column in range(1,16):
            for word in WORDS:
                if column+len(word)>16 or board[row*17+column-1] or board[row*17+column+len(word)]:continue
                available=collections.Counter(rack);used=0;touches=False;valid=True
                for i,letter in enumerate(word):
                    col=column+i;cell=row*17+col;old=board[cell]
                    if old:
                        if old!=ord(letter):valid=False;break
                        touches=True;continue
                    used+=1
                    if available[letter]:available[letter]-=1
                    elif available['?']:available['?']-=1
                    else:valid=False;break
                    cross_row,cross_col=(col+15,row) if row<16 else (col,row-15)
                    start=cross_col
                    while board[cross_row*17+start-1]:start-=1
                    end=cross_col+1
                    while board[cross_row*17+end]:end+=1
                    crossing=bytes(board[cross_row*17+start:cross_row*17+cross_col])+letter.encode()+bytes(board[cross_row*17+cross_col+1:cross_row*17+end])
                    if len(crossing)>1:
                        touches=True
                        if crossing.decode() not in WORDS:valid=False;break
                if valid and used and touches:results.add((word,row,column))
    return results

class BoardPlacementTests(unittest.TestCase):
    def test_complete_sets_against_exhaustive_word_placement(self):
        with tempfile.TemporaryDirectory() as tmp:
            lib=Path(tmp)/'board.dylib'
            sources=['board_placements','board_state','cross_check_letters','dictionary_lookup']
            subprocess.run(['cc','-shared','-fPIC','-std=c99','-Wall','-Wextra','-Werror',*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(lib)],check=True)
            api=ctypes.CDLL(str(lib));api.maven_enumerate_board_placements.argtypes=[ctypes.POINTER(Enumeration)]
            raw,root=dictionary(WORDS);data=ctypes.create_string_buffer(raw);sections=(Section*2)(Section(ctypes.addressof(data),root),Section())
            premiums=bytearray(544)
            for row in range(1,31):
                for col in range(1,16):premiums[row*17+col]=1
            multiplier=ctypes.create_string_buffer(bytes(premiums))
            for word,row,col in [('ab',8,8),('aba',1,1),('bb',15,14),('aabb',7,5)]:
                for rack in ('ab','a?','??','abb'):
                    board=board_with(word,row,col);board_buffer=ctypes.create_string_buffer(bytes(board));state=Enumeration()
                    state.sections=sections;state.board=ctypes.addressof(board_buffer);state.letter_multipliers=state.word_multipliers=ctypes.addressof(multiplier)
                    for tile,count in collections.Counter(rack).items():state.remaining[ord(tile)]=count
                    initial=bytes(state.remaining);actual=[]
                    def emit(user,pointer,remaining):
                        p=pointer.contents;actual.append((bytes(p.word).split(b'\0')[0].decode(),p.row,p.column))
                    callback=Callback(emit);state.placement=callback
                    api.maven_enumerate_board_placements(ctypes.byref(state))
                    expected=exhaustive(board,rack)
                    self.assertEqual(set(actual),expected,(word,row,col,rack,'extra',set(actual)-expected,'missing',expected-set(actual)))
                    self.assertEqual(len(actual),len(set(actual)),(word,rack,'duplicate placements'))
                    self.assertEqual(bytes(state.remaining),initial)
                    self.assertEqual(board_buffer.raw[:544],bytes(board))
