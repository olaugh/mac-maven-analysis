#!/usr/bin/env python3
"""Replay saved game-search captures without a VM, preserving search sequence."""
import argparse,ctypes as C,gzip,json,struct
from play_magpie_matches import ROOT,Position,Ranking,CALL,build

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('capture');p.add_argument('--build',action='store_true');a=p.parse_args()
 if a.build:build()
 api=C.CDLL(str(ROOT/'.build/magpie-match.dylib'));api.match_create.argtypes=[C.c_char_p,C.c_char_p];api.match_create.restype=C.c_void_p
 api.maven_portable_destroy.argtypes=[C.c_void_p];api.maven_portable_set_position.argtypes=[C.c_void_p,C.POINTER(Position)];api.maven_portable_heuristic.argtypes=[C.c_void_p,C.c_int,C.c_int16,C.POINTER(Ranking),CALL,C.c_void_p]
 api.maven_portable_late.argtypes=[C.c_void_p,C.c_int,C.c_uint32,C.POINTER(Ranking),C.POINTER(C.c_int),C.POINTER(C.c_uint32)]
 api.match_endgame.argtypes=[C.c_void_p,C.c_uint32,C.c_int32,C.POINTER(C.c_uint32),C.c_uint,C.POINTER(Ranking)];api.match_apply.argtypes=[C.c_void_p,C.c_uint,C.POINTER(Position)]
 e=api.match_create(str(ROOT/'resources').encode(),str(ROOT/'../../media/maven/session/share/maven2.1').encode());assert e
 kinds={};records=0;positions=0
 try:
  for line in gzip.open(a.capture,'rt'):
   row=json.loads(line);cap=row['original'];initial=cap['initial'];p=Position();board=bytes.fromhex(initial['board']);values=struct.unpack('>544H',bytes.fromhex(initial['values']));p.zero=initial['zero']
   for i in range(225):y,x=divmod(i,15);k=(y+1)*17+x+1;p.letters[i]=board[k];p.blanks[i]=int(bool(board[k]) and not values[k])
   for i,f in enumerate(['rack','opponent']):C.memmove(p.racks[i],bytes.fromhex(initial[f]),8)
   scores=row['cgp'].split()[2].split('/');p.scores[0]=int(scores[0])*100;p.scores[1]=int(scores[1])*100
   assert api.maven_portable_set_position(e,C.byref(p))==0
   out=Ranking();kind=cap['kind'];kinds[kind]=kinds.get(kind,0)+1
   if kind=='heuristic':
    @CALL
    def observe(*args):pass
    rc=api.maven_portable_heuristic(e,int(initial['dedup']),initial['offset'],C.byref(out),observe,None)
   elif kind=='late':
    used=C.c_int();estimate=C.c_uint32();rc=api.maven_portable_late(e,1,0,C.byref(out),C.byref(used),C.byref(estimate))
   else:
    clocks=(C.c_uint32*len(cap['clocks']))(*cap['clocks']);rc=api.match_endgame(e,cap['seed'],cap['budget'],clocks,len(clocks),C.byref(out))
   actual=b''.join(bytes(x) for x in out.moves);expected=bytes.fromhex(cap['moves'])
   assert rc==0 and out.count==cap['count'] and actual==expected,(row['game'],row['turn'],kind,rc,[(i,x,y) for i,(x,y) in enumerate(zip(actual,expected)) if x!=y][:20])
   if kind=='heuristic':assert out.cutoff==cap['cutoff']
   if row.get('player')=='original_maven' and 'exchange' not in row['chosen']:
    after=Position();assert api.match_apply(e,0,C.byref(after))==0
   positions+=1;records+=out.count
 finally:api.maven_portable_destroy(e)
 print(json.dumps(dict(all_matched=True,positions=positions,ranked_records=records,kinds=kinds,scope=__doc__)))
if __name__=='__main__':main()
