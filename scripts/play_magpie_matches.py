#!/usr/bin/env python3
"""Seeded MAGPIE vs reconstructed Maven games; retain every position and discrepancy.
Not an original-executable oracle. Uses MAGPIE CSW21 leaves with Maven lexicon.
"""
import argparse,ctypes as C,gzip,hashlib,json,random,re,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]; MAG=ROOT/'../../magpie-pr-619'
class Position(C.Structure):
 _fields_=[('letters',C.c_uint8*225),('blanks',C.c_uint8*225),('racks',(C.c_uint8*8)*2),('scores',C.c_uint32*2),('zero',C.c_uint16),('side',C.c_uint8)]
class Ranking(C.Structure):
 _fields_=[('moves',(C.c_uint8*34)*10),('count',C.c_uint16),('cutoff',C.c_uint32)]
CALL=C.CFUNCTYPE(None,C.c_void_p,C.c_int,C.c_int,C.POINTER(C.c_uint8))
def build():
 names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
 subprocess.run(['cc','-shared','-fPIC','-O2','-std=c99','-I'+str(ROOT/'scripts'),'-I'+str(ROOT/'reconstruction'),str(ROOT/'scripts/magpie_match_adapter.c'),*[str(ROOT/f'reconstruction/{n}.c') for n in names],'-o',str(ROOT/'.build/magpie-match.dylib')],check=True)
def cgp(board,racks,scores,zero):
 rows=[]
 for y in range(15):
  row='';empty=0
  for c in board[y*15:y*15+15]:
   if not c:empty+=1
   else:
    if empty:row+=str(empty);empty=0
    row+=c
  if empty:row+=str(empty)
  rows.append(row)
 return '/'.join(rows)+' '+ '/'.join(''.join(r) for r in racks)+' '+ '/'.join(map(str,scores))+' '+str(zero)
def magpie(c, limit=100000):
 cmd=f'cgp {c} -lex NWLMAVEN -numplays {limit}\ng\nshmoves {limit}\n'
 p=subprocess.run([str(MAG/'bin/magpie'),'set','-mode','sync','-savesettings','false','-hr','false','-shwithmoves','false'],input=cmd,text=True,capture_output=True,cwd=MAG,timeout=30)
 assert p.returncode==0 and '(error' not in p.stderr+p.stdout,(p.stderr,p.stdout[:600])
 lines=p.stdout.split('Showing 15 of')[-1].splitlines() if 'Showing 15 of' in p.stdout else p.stdout.splitlines()
 moves=[]
 for line in lines:
  m=re.match(r'\s*(\d+):\s+(.*?)\s+(-?\d+)\s+(-?\d+(?:\.\d+)?)\s*$',line)
  if not m:continue
  n,desc,score,eq=m.groups();parts=desc.split();coord=parts[0]
  if re.fullmatch(r'(?:\d+[A-O]|[A-O]\d+)',coord):
   word=parts[1].replace('(','').replace(')',''); vert=coord[0].isalpha()
   row=int(coord[1:] if vert else coord[:-1])-1;col=ord(coord[0] if vert else coord[-1])-65
   move=dict(row=row,col=col,vertical=vert,word=word)
  elif coord.lower().startswith('(exch'):
   move=dict(exchange=parts[1].rstrip(')'))
  elif coord.lower() in ('pass','(pass)'):move=dict(exchange='')
  else:raise AssertionError(desc)
  moves.append(dict(move,score=int(score),equity=float(eq),ordinal=int(n)))
 # Short lists can be printed twice (automatic output then explicit shmoves).
 moves=list({m['ordinal']:m for m in moves}.values());assert moves and len(moves)<100000
 return moves

def key(m,board):
 if 'exchange' in m:return ('exchange',''.join(sorted(m['exchange'].upper())))
 cells=[]
 for i,c in enumerate(m['word']):
  y=m['row']+(i if m['vertical'] else 0);x=m['col']+(0 if m['vertical'] else i);k=y*15+x
  assert 0<=y<15 and 0<=x<15,m
  if not board[k]:cells.append((k,c.upper()))
 return tuple(cells)
def rawmove(raw):
 row,col=raw[32:34];word=raw[:16].split(b'\0')[0].decode('ascii').upper()
 m=dict(row=(col-1 if row>15 else row-1),col=(row-16 if row>15 else col-1),vertical=row>15,word=word) if row else dict(exchange=word)
 return dict(m,score=int.from_bytes(raw[16:20],'big',signed=True)/100,equity=sum(int.from_bytes(raw[i:i+4],'big',signed=True) for i in (16,20,24))/100,raw=raw.hex())
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--games',type=int,default=100);p.add_argument('--seed',type=int,default=9102026);p.add_argument('--output',type=Path,required=True);p.add_argument('--build',action='store_true');a=p.parse_args()
 if a.build:build()
 api=C.CDLL(str(ROOT/'.build/magpie-match.dylib'));api.match_create.argtypes=[C.c_char_p,C.c_char_p];api.match_create.restype=C.c_void_p
 api.maven_portable_destroy.argtypes=[C.c_void_p];api.maven_portable_set_position.argtypes=[C.c_void_p,C.POINTER(Position)];api.maven_portable_heuristic.argtypes=[C.c_void_p,C.c_int,C.c_int16,C.POINTER(Ranking),CALL,C.c_void_p]
 counts=[2,9,2,2,4,12,2,3,2,9,1,1,4,2,6,8,2,1,6,4,6,4,2,2,1,2,1];alphabet='?ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 report=dict(scope=__doc__,seed=a.seed,requested_games=a.games,completed_games=0,positions=0,placement_comparisons=0,issues=[],games=[],started=time.time(),original_executable_compared=False,magpie_leaves='CSW21.klv2',dictionary_sha256=hashlib.sha256((ROOT/'../../media/maven/session/share/maven2.1').read_bytes()).hexdigest())
 a.output.parent.mkdir(parents=True,exist_ok=True)
 with gzip.open(a.output.with_suffix('.positions.jsonl.gz'),'wt') as log:
  for game in range(a.games):
   rng=random.Random(a.seed+game);bag=list(''.join(c*n for c,n in zip(alphabet,counts)));rng.shuffle(bag);racks=[[bag.pop() for _ in range(7)] for _ in range(2)];board=['']*225;scores=[0,0];zero=0;turn=0
   engines=[api.match_create(str(ROOT/'resources').encode(),str(ROOT/'../../media/maven/session/share/maven2.1').encode()) for _ in range(2)];assert all(engines)
   try:
    while turn<200 and zero<6 and all(racks):
     side=turn%2;current=[racks[side],racks[1-side]];c=cgp(board,current,[scores[side],scores[1-side]],zero);mm=magpie(c);mp={}
     for m in mm:mp.setdefault(key(m,board),[]).append(m)
     pos=Position();pos.zero=zero
     for i,c0 in enumerate(board):
      if c0:pos.letters[i]=ord(c0.lower());pos.blanks[i]=int(c0.islower())
     for j,r in enumerate(current):
      for i,c0 in enumerate(r):pos.racks[j][i]=ord(c0.lower())
     pos.scores[0]=scores[side]*100;pos.scores[1]=scores[1-side]*100
     assert api.maven_portable_set_position(engines[side],C.byref(pos))==0
     candidates=[]
     @CALL
     def callback(u,phase,mode,raw):candidates.append(dict(rawmove(bytes(raw[:34])),phase=phase,mode=mode))
     ranking=Ranking();status=api.maven_portable_heuristic(engines[side],0,0,C.byref(ranking),callback,None);assert status==0,status
     ranked=[rawmove(bytes(x)) for x in ranking.moves[:ranking.count]]
     mismatches=[];seen=set()
     for m in candidates:
      k=key(m,board);seen.add(k)
      if 'exchange' in m:continue
      report['placement_comparisons']+=1
      if k not in mp:mismatches.append(dict(kind='maven_move_absent_magpie',move=m))
      elif m['score']!=max(x['score'] for x in mp[k]):mismatches.append(dict(kind='score_difference',move=m,magpie=mp[k]))
     # Maven's opening generator deliberately compresses placements; later evaluation
     # expands only finalists. Compare missing full placement sets after opening.
     missing=[v[0] for k,v in mp.items() if k not in seen and k and k[0]!='exchange'] if any(board) else []
     if missing:mismatches.append(dict(kind='magpie_placements_absent_maven',count=len(missing),examples=missing[:10]))
     chosen=mm[0] if side==game%2 else (next((x for x in mp.get(key(ranked[0],board),[]) if x['score']==ranked[0]['score']),None) if ranked else dict(exchange='',score=0,equity=0))
     record=dict(game=game,turn=turn,cgp=c,bag=''.join(bag),magpie_top=mm[:10],maven_top=ranked,candidates=len(candidates),magpie_moves=len(mm),issues=mismatches,chosen=chosen)
     log.write(json.dumps(record)+'\n');log.flush();report['positions']+=1
     if mismatches:report['issues'].append(dict(game=game,turn=turn,cgp=c,issues=mismatches))
     if chosen is None:raise AssertionError(('unplayable Maven choice',record))
     if 'exchange' in chosen:
      ex=list(chosen['exchange']);assert not ex or len(bag)>=7
      for ch in ex:racks[side].remove(ch)
      for _ in ex:racks[side].append(bag.pop())
      bag.extend(ex);rng.shuffle(bag);zero+=1
     else:
      for i,ch in enumerate(chosen['word']):
       k=(chosen['row']+(i if chosen['vertical'] else 0))*15+chosen['col']+(0 if chosen['vertical'] else i)
       if not board[k]:racks[side].remove('?' if ch.islower() else ch);board[k]=ch
      scores[side]+=chosen['score'];zero=0
      while len(racks[side])<7 and bag:racks[side].append(bag.pop())
     turn+=1
    assert turn<200
    report['completed_games']+=1;report['games'].append(dict(game=game,turns=turn,scores_before_final_adjustment=scores,remaining_racks=racks,bag=len(bag)))
   finally:
    for e in engines:api.maven_portable_destroy(e)
   report['elapsed_seconds']=time.time()-report['started'];a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:report[k] for k in ['completed_games','positions','placement_comparisons','elapsed_seconds']}),flush=True)
 report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n')
if __name__=='__main__':main()
