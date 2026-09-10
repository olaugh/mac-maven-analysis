#!/usr/bin/env python3
"""Replay complete CODE36+113a rankings, including weighted reply allocation."""
import argparse,ctypes as C,gzip,hashlib,json,struct,subprocess
from pathlib import Path
from late_replay_support import Value,decode_value,U8,U16,U32
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-ranking-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete'];assert hashlib.sha256((ROOT/'resources/CODE/36_36.bin').read_bytes()).hexdigest()==j['code_sha256']
class CandidateList(C.Structure):_fields_=[('moves',(U8*34)*10),('count',U16),('cutoff_bits',U32)]
class Group(C.Structure):_fields_=[('valid',U16),('bits',U32)]
class Conflicts(C.Structure):_fields_=[('board',C.POINTER(U8)),('matrix',C.POINTER(U32*544)),('bits',C.POINTER(U32)),('groups',Group*8)]
class Reply(C.Structure):pass
Reply._fields_=[('record',U8*66),('constraints',C.POINTER(U16)),('next',C.POINTER(Reply))]
Observer=C.CFUNCTYPE(None,C.c_void_p,C.POINTER(U8),C.POINTER(U8),U32)
class Ranking(C.Structure):
 _fields_=[('value',C.POINTER(Value)),('ranking',C.POINTER(CandidateList)),('conflicts',C.POINTER(Conflicts))]+[(n,C.POINTER(Reply)) for n in ('baseline','local','fallback_reply')]+[('weights',C.POINTER(U16)),('weight_count',U16),('total_weight',U16),('local_cutoff_bits',U32),('minimum_reply_score_bits',U32),('fallback_cache',(U32*2)*8),('word_deduplication',C.c_int),('valuation',Observer),('user',C.c_void_p)]
build=ROOT/'.build';build.mkdir(exist_ok=True);library=build/'late-ranking.dylib';sources=['late_ranking','late_reply_value','candidate_ranking','reply_bounds'];subprocess.run(['cc','-std=c99','-shared','-fPIC','-Wall','-Wextra','-Werror',*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(library)],check=True);lib=C.CDLL(str(library))
board=(U8*544).from_buffer_copy(bytes.fromhex(j['board']));bits=(U32*32)(*struct.unpack('>32I',bytes.fromhex(j['bit_masks'])));matrix=((U32*544)*8)();flat=struct.unpack('>4352I',bytes.fromhex(j['conflicts']))
for i in range(8):matrix[i][:]=flat[i*544:(i+1)*544]
all_values=0
for call_index,call in enumerate(j['calls']):
 value=decode_value(call['initial']);ranking=CandidateList();C.memmove(ranking.moves,bytes.fromhex(call['initial']['ranking']),340);ranking.count=int(call['initial']['ranking_count'],16)
 # Full-list cutoff equals slot9's rank; initial shorter lists do not consult it.
 if ranking.count==10:ranking.cutoff_bits=sum(struct.unpack('>3I',bytes(ranking.moves[9])[16:28]))&0xffffffff
 conflicts=Conflicts(board,matrix,bits);state=Ranking();state.value=C.pointer(value);state.ranking=C.pointer(ranking);state.conflicts=C.pointer(conflicts);g=bytes.fromhex(call['initial']['globals'])
 def glob(off,n=4):return int.from_bytes(g[0x8da-off:0x8da-off+n],'big')
 state.total_weight=glob(0x730,2);state.local_cutoff_bits=glob(0x780);state.minimum_reply_score_bits=glob(0x714)
 flat=struct.unpack('>16I',g[0x8da-0x77c:0x8da-0x77c+64])
 for i in range(8):state.fallback_cache[i][:]=flat[i*2:i*2+2]
 refs=[];by_pointer={}
 for entries,field in [(call['first'],'baseline'),(call['second'],'local')]:
  previous=None
  for e in entries:
   reply=Reply();reply.record[:]=bytes.fromhex(e['raw']);constraints=(U16*len(e['constraints']))(*e['constraints']);reply.constraints=constraints;refs.extend([reply,constraints]);by_pointer[e['pointer']]=reply
   if previous is None:setattr(state,field,C.pointer(reply))
   else:previous.next=C.pointer(reply)
   previous=reply
 state.fallback_reply=C.pointer(by_pointer[call['tail']]);weights_raw=bytes.fromhex(call['weights']);weights=(U16*(len(weights_raw)//2))(*struct.unpack('>'+str(len(weights_raw)//2)+'H',weights_raw));state.weights=weights;state.weight_count=len(weights)
 observed=[]
 @Observer
 def observer(user,move,reply,result):observed.append((bytes(move[:34]),bytes(reply[:66]),result))
 state.valuation=observer;move=(U8*34).from_buffer_copy(bytes.fromhex(call['move']));assert lib.maven_rank_late_move(C.byref(state),move)==1
 expected=[(bytes.fromhex(e['move_after']),bytes.fromhex(e['reply']),e['result']) for e in call['evaluations']]
 assert observed==expected,(call_index,'valuation stream mismatch',len(observed),len(expected))
 assert bytes(move).hex()==call['move_after'],(call_index,'move',bytes(move).hex(),call['move_after'])
 assert bytes(ranking.moves).hex()==call['final']['ranking'],(call_index,'ranking')
 assert ranking.count==int(call['final']['ranking_count'],16)
 output_groups=b''.join(struct.pack('>HI',x.valid,x.bits) for x in conflicts.groups);assert output_groups.hex()==call['final']['conflict_groups']
 final_g=bytes.fromhex(call['final']['globals']);assert state.minimum_reply_score_bits==int.from_bytes(final_g[0x8da-0x714:0x8da-0x710],'big')
 assert b''.join(struct.pack('>2I',*row) for row in state.fallback_cache)==final_g[0x8da-0x77c:0x8da-0x77c+64]
 all_values+=len(observed)
print(json.dumps(dict(scope=__doc__,rankings=len(j['calls']),reply_values=all_values,all_moves_rankings_weights_cache_and_conflicts_match=True)))
