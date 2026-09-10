#!/usr/bin/env python3
"""Search for a constructed legal one-Q no-move endgame; preserve all tile counts.

Consumes six non-Q rack tiles in one dictionary-generated placement. The
remaining Q is assigned to player0, with seven tiles for player1 and no bag.
The no-move claim is exploratory until checked in the original executable.
"""
import ctypes as C,gzip,hashlib,json,subprocess
from collections import Counter
from pathlib import Path
from replay_board_placements import Enumeration,Callback
from replay_opening_generator import Section
root=Path(__file__).resolve().parents[1];share=root/'../../media/maven/session/share';source=share/'maven-search-end7';raw=bytearray(source.read_bytes());j=json.loads(gzip.decompress((root/'analysis/toolchain/endgame-seven-search-live.json.gz').read_bytes()));board=bytes.fromhex(j['initial']['board']);assert board[:272]==raw[4:276]
held=Counter(bytes(raw[276:284]).split(b'\0')[0]+bytes(raw[284:292]).split(b'\0')[0]);assert held[ord('q')]==1;held[ord('q')]-=1
keep=[]
def buf(data):
 b=C.create_string_buffer(bytes(data));keep.append(b);return C.addressof(b)
data=(share/'maven2.1').read_bytes();assert hashlib.sha256(data).hexdigest()==j['dictionary_sha256'];base=buf(data);sections=(Section*(len(j['sections'])+1))()
for i,s in enumerate(j['sections']):sections[i]=Section(base+s['offset'],s['root'])
library=root/'.build/no-move-fixture.dylib';subprocess.run(['cc','-shared','-fPIC','-O2',*[str(root/f'reconstruction/{x}.c') for x in ['board_placements','board_state','cross_check_letters','dictionary_lookup']],'-o',str(library)],check=True);lib=C.CDLL(str(library));lib.maven_enumerate_board_placements.argtypes=[C.POINTER(Enumeration)]
def enumerate_on(board,counts,emit):
 e=Enumeration();e.sections=sections;e.board=buf(board);e.letter_multipliers=buf(bytes.fromhex(j['fixed']['letter_multipliers']));e.word_multipliers=buf(bytes.fromhex(j['fixed']['word_multipliers']));C.memmove(e.remaining,bytes(counts),128);cb=Callback(emit);e.placement=cb;lib.maven_enumerate_board_placements(C.byref(e))
placements=[];counts=bytearray(128)
for tile,count in held.items():counts[tile]=count

def emit(_,record,left):
 p=record.contents;remaining=C.string_at(left,128)
 if sum(remaining)==7:placements.append((bytes(p.word).split(b'\0')[0],p.row,p.column,remaining))
enumerate_on(board,counts,emit);attempts=0;chosen=None
for word,row,col,left in placements:
 candidate=bytearray(board);changed=[]
 for i,ch in enumerate(word):
  r,c=row,col+i
  if r>15:r,c=c,r-15
  if not candidate[17*r+c]:candidate[17*r+c]=candidate[17*(c+15)+r]=ch;changed.append([r,c,chr(ch)])
 assert len(changed)==6
 qcount=bytearray(128);qcount[ord('q')]=1;found=[]
 enumerate_on(candidate,qcount,lambda _,record,left:found.append(1));attempts+=1
 if not found:chosen=(word,row,col,left,candidate,changed);break
report=dict(scope=__doc__,source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),placements_considered=attempts,candidates=len(placements),found=bool(chosen),synthetic_position=True)
if chosen:
 word,row,col,left,candidate,changed=chosen;other=bytes(ch for ch,n in enumerate(left) for _ in range(n));raw[4:276]=candidate[:272];raw[276:284]=b'q\0\0\0\0\0\0\0';raw[284:292]=other+b'\0';out=share/'maven-search-nomove';assert not out.exists();out.write_bytes(raw);out.with_name(out.name+'.idump').write_bytes(source.with_name(source.name+'.idump').read_bytes());report.update(word=word.decode(),row=row,column=col,changed=changed,own='q',other=other.decode(),sha256=hashlib.sha256(raw).hexdigest())
(root/'analysis/toolchain/no-move-fixture.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
