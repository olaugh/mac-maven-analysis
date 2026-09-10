#!/usr/bin/env python3
"""Construct an eight-unseen-tile test save with a dictionary-generated five-tile placement.
The resulting position has eight possible seven-tile multisets or fewer. The
source save is preserved; this is not a claim of a naturally played game.
"""
import ctypes,gzip,hashlib,json,subprocess
from pathlib import Path
from replay_board_placements import Enumeration,Callback
from replay_opening_generator import Section
ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'analysis/toolchain/late-search-unseenq-live.json.gz'
j=json.loads(gzip.decompress(source.read_bytes()));board=bytearray.fromhex(j['initial']['board'])
raw=bytearray((ROOT/'../../media/maven/session/share/maven-search-unseenq').read_bytes())
assert board[:272]==raw[4:276]
counts=bytearray(128)
for ch in b'aaeeeeiknoqrt':counts[ch]+=1
buffers=[]
def buffer(raw):
 b=ctypes.create_string_buffer(bytes(raw));buffers.append(b);return ctypes.addressof(b)
data=(ROOT/'../../media/maven/session/share/maven2.1').read_bytes();assert hashlib.sha256(data).hexdigest()==j['dictionary_sha256']
base=buffer(data);sections=(Section*(len(j['sections'])+1))()
for i,s in enumerate(j['sections']):sections[i]=Section(base+s['offset'],s['root'])
s=Enumeration();s.sections=sections;s.board=buffer(board)
s.letter_multipliers=buffer(bytes.fromhex(j['fixed']['letter_multipliers']));s.word_multipliers=buffer(bytes.fromhex(j['fixed']['word_multipliers']));ctypes.memmove(s.remaining,bytes(counts),128)
placements=[]
def emit(user,record,remaining):
 p=record.contents;word=bytes(p.word).split(b'\0')[0];left=ctypes.string_at(remaining,128)
 if sum(left)==8:placements.append((word,p.row,p.column,left))
cb=Callback(emit);s.placement=cb
library=ROOT/'.build/enumeration-fixture.dylib'
subprocess.run(['cc','-shared','-fPIC','-O2',*[str(ROOT/f'reconstruction/{x}.c') for x in ['board_placements','board_state','cross_check_letters','dictionary_lookup']],'-o',str(library)],check=True)
api=ctypes.CDLL(str(library));api.maven_enumerate_board_placements.argtypes=[ctypes.POINTER(Enumeration)];api.maven_enumerate_board_placements(ctypes.byref(s))
assert placements
word,row,column,left=placements[0];changed=[]
for k,ch in enumerate(word):
 r,c=row,column+k
 if r>15:r,c=c,r-15
 if not board[17*r+c]:board[17*r+c]=ch;changed.append([r,c,chr(ch)])
assert len(changed)==5
raw[4:276]=board[:272];unseen=bytes(ch for ch,count in enumerate(left) for _ in range(count));raw[284:292]=unseen[:7]+b'\0'
out=ROOT/'../../media/maven/session/share/maven-search-enum8';assert not out.exists();out.write_bytes(raw);out.with_name(out.name+'.idump').write_bytes((out.parent/'maven-search-unseenq.idump').read_bytes())
report=dict(scope=__doc__,source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),sha256=hashlib.sha256(raw).hexdigest(),word=word.decode(),row=row,column=column,changed=changed,unseen=unseen.decode(),rack1=unseen[:7].decode(),synthetic_position=True)
(ROOT/'analysis/toolchain/enumeration-fixture.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
