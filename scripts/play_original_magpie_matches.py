#!/usr/bin/env python3
"""Magpie picks human moves; original Maven Kibitz plays the other side.
Every normal original search is compared byte-for-byte with the owned C engine.
Positions are imported through original files. Host owns seeded bag/deals, not
original UI move-entry, refill, simulation, or history lifecycle.
"""
import argparse,ctypes as C,gzip,hashlib,json,random,signal,struct,time,traceback
from pathlib import Path
from play_magpie_matches import ROOT,MAG,Position,Ranking,CALL,build,cgp,magpie,rawmove
from original_match_search import OriginalSearch,write_fixture
from qmp_session import command

class StopBatch(Exception):pass

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--games',type=int,default=20);p.add_argument('--seed',type=int,default=9102026);p.add_argument('--output',type=Path,required=True);p.add_argument('--build',action='store_true');p.add_argument('--max-seconds',type=int,default=3600);p.add_argument('--stop-file',type=Path);p.add_argument('--pause-on-exit',action='store_true');p.add_argument('--ui-delay-scale',type=float,default=1.0,help='Scale Open waits and key delays; keys retain a 40 ms minimum');p.add_argument('--heartbeat-file',type=Path,help='Rewritten at every original debugger stop, including each endgame clock read');a=p.parse_args()
 if not 0 < a.ui_delay_scale <= 1:p.error('--ui-delay-scale must be in (0, 1]')
 def stop_signal(signum,frame):raise StopBatch('signal_'+str(signum))
 signal.signal(signal.SIGTERM,stop_signal)
 signal.signal(signal.SIGINT,stop_signal)
 if a.build:build()
 api=C.CDLL(str(ROOT/'.build/magpie-match.dylib'));api.match_create.argtypes=[C.c_char_p,C.c_char_p];api.match_create.restype=C.c_void_p
 api.maven_portable_destroy.argtypes=[C.c_void_p];api.maven_portable_set_position.argtypes=[C.c_void_p,C.POINTER(Position)];api.maven_portable_heuristic.argtypes=[C.c_void_p,C.c_int,C.c_int16,C.POINTER(Ranking),CALL,C.c_void_p];api.match_apply.argtypes=[C.c_void_p,C.c_uint,C.POINTER(Position)]
 api.maven_portable_late.argtypes=[C.c_void_p,C.c_int,C.c_uint32,C.POINTER(Ranking),C.POINTER(C.c_int),C.POINTER(C.c_uint32)]
 api.match_endgame.argtypes=[C.c_void_p,C.c_uint32,C.c_int32,C.POINTER(C.c_uint32),C.c_uint,C.POINTER(Ranking)]
 engine=api.match_create(str(ROOT/'resources').encode(),str(ROOT/'../../media/maven/session/share/maven2.1').encode());assert engine
 beats=dict(count=0)
 def heartbeat(event):
  beats['count']+=1
  if a.heartbeat_file:
   temporary=a.heartbeat_file.with_suffix('.tmp');temporary.write_text(json.dumps(dict(time=time.time(),event=event,stops=beats['count']))+'\n');temporary.replace(a.heartbeat_file)
 original=OriginalSearch(ui_delay_scale=a.ui_delay_scale,progress=heartbeat);counts=[2,9,2,2,4,12,2,3,2,9,1,1,4,2,6,8,2,1,6,4,6,4,2,2,1,2,1];alphabet='?ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 report=dict(scope=__doc__,ui_delay_scale=a.ui_delay_scale,key_delay_seconds=original.key_delay,heartbeat_file=str(a.heartbeat_file) if a.heartbeat_file else None,seed=a.seed,requested_games=a.games,completed_games=0,positions=0,ranked_records=0,issues=[],games=[],started=time.time(),max_seconds=a.max_seconds,magpie_leaves='CSW21.klv2',magpie_only_selects_human_moves=True,original_executable_compared=True,files={})
 for path in [MAG/'bin/magpie',MAG/'data/lexica/NWLMAVEN.kwg',MAG/'data/lexica/NWLMAVEN.wmp',MAG/'data/lexica/NWLMAVEN.klv2',ROOT/'.build/magpie-match.dylib',ROOT/'scripts/play_original_magpie_matches.py',ROOT/'scripts/original_match_search.py',ROOT/'scripts/mac_ui.py']:
  report['files'][str(path.resolve())]=hashlib.sha256(path.read_bytes()).hexdigest()
 def save():
  report['elapsed_seconds']=time.time()-report['started'];temporary=a.output.with_suffix('.tmp');temporary.write_text(json.dumps(report,indent=2)+'\n');temporary.replace(a.output)
 a.output.parent.mkdir(parents=True,exist_ok=True)
 try:
  api.match_initial_workspace.argtypes=[C.c_char_p,C.POINTER(C.c_uint8)]
  initial_workspace=(C.c_uint8*64)();assert api.match_initial_workspace(str(ROOT/'resources').encode(),initial_workspace)
  report['fresh_state_guard']=original.require_fresh_workspace(bytes(initial_workspace))
  with gzip.open(a.output.with_suffix('.positions.jsonl.gz'),'wt') as log:
   for game in range(a.games):
    rng=random.Random(a.seed+game);bag=list(''.join(c*n for c,n in zip(alphabet,counts)));rng.shuffle(bag);racks=[[bag.pop() for _ in range(7)] for _ in range(2)];board=['']*225;scores=[0,0];zero=0;turn=0
    while turn<200 and zero<(2 if sum(bool(c) for c in board)>79 else 6) and all(racks):
     if a.stop_file and a.stop_file.exists():raise StopBatch('stop_requested')
     if time.time()-report['started']>a.max_seconds:raise StopBatch('time_limit')
     side=turn%2;current=[racks[side],racks[1-side]];position_cgp=cgp(board,current,[scores[side],scores[1-side]],zero)
     name=write_fixture(board,current,[scores[side],scores[1-side]])
     capture=original.search(name);init=capture['initial'];pos=Position();pos.zero=init['zero'];bb=bytes.fromhex(init['board']);vv=struct.unpack('>544H',bytes.fromhex(init['values']))
     for i,ch in enumerate(board):
      row,col=divmod(i,15);k=(row+1)*17+col+1;pos.letters[i]=bb[k];pos.blanks[i]=int(bool(bb[k]) and vv[k]==0)
      assert pos.letters[i]==(ord(ch.lower()) if ch else 0),('original file board mismatch',i,ch,bb[k])
      assert pos.blanks[i]==int(bool(ch) and ch.islower()),('original blank mismatch',i,ch,vv[k])
     for j,field in enumerate(['rack','opponent']):
      b=bytes.fromhex(init[field]);assert sorted(b.split(b'\0')[0].decode().upper())==sorted(current[j]),(field,b,current[j])
      C.memmove(pos.racks[j],b,8)
     pos.scores[0]=scores[side]*100;pos.scores[1]=scores[1-side]*100
     assert api.maven_portable_set_position(engine,C.byref(pos))==0
     candidates=[]
     @CALL
     def callback(u,phase,mode,raw):candidates.append(dict(phase=phase,mode=mode,move=bytes(raw[:34]).hex()))
     ranking=Ranking()
     if capture['kind']=='heuristic':status=api.maven_portable_heuristic(engine,int(init['dedup']),init['offset'],C.byref(ranking),callback,None)
     elif capture['kind']=='late':
      used=C.c_int();estimate=C.c_uint32();status=api.maven_portable_late(engine,1,0,C.byref(ranking),C.byref(used),C.byref(estimate))
     else:
      clocks=(C.c_uint32*len(capture['clocks']))(*capture['clocks']);status=api.match_endgame(engine,capture['seed'],capture['budget'],clocks,len(clocks),C.byref(ranking))
     assert status==0,(capture['kind'],status)
     actual=b''.join(bytes(x) for x in ranking.moves);expected=bytes.fromhex(capture['moves']);diff=[dict(byte=i,original=b,reconstruction=x) for i,(b,x) in enumerate(zip(expected,actual)) if b!=x]
     matched=not diff and ranking.count==capture['count'] and (capture['kind']!='heuristic' or ranking.cutoff==capture['cutoff']);report['positions']+=1;report['ranked_records']+=capture['count'];record=dict(game=game,turn=turn,cgp=position_cgp,bag=''.join(bag),original=capture,reconstruction=dict(moves=actual.hex(),count=ranking.count,cutoff=ranking.cutoff,candidates=candidates),matched=matched)
     if not matched:
      issue=dict(game=game,turn=turn,cgp=position_cgp,differences=diff,original_count=capture['count'],reconstructed_count=ranking.count);report['issues'].append(issue);log.write(json.dumps(record)+'\n');log.flush();save();raise AssertionError(('Original/reconstruction disagreement',issue))
     if side==game%2:
      chosen=magpie(position_cgp,1)[0];record['player']='magpie'
     else:
      chosen=rawmove(expected[:34]) if capture['count'] else dict(exchange='',score=0,equity=0)
      record['player']='original_maven'
      if 'exchange' not in chosen:
       after=Position();assert api.match_apply(engine,0,C.byref(after))==0
       # Preserve exactly the blank assignment chosen by Maven's move applier.
       chars=[]
       for i,ch in enumerate(chosen['word']):
        k=(chosen['row']+(i if chosen['vertical'] else 0))*15+chosen['col']+(0 if chosen['vertical'] else i)
        assert after.letters[k]==ord(ch.lower())
        chars.append(ch.lower() if after.blanks[k] else ch)
       chosen['word']=''.join(chars)
     record['chosen']=chosen;log.write(json.dumps(record)+'\n');log.flush()
     if 'exchange' in chosen:
      ex=list(chosen['exchange']);assert not ex or len(bag)>=7
      for ch in ex:racks[side].remove(ch)
      for _ in ex:racks[side].append(bag.pop())
      bag.extend(ex);rng.shuffle(bag);zero+=1
     else:
      for i,ch in enumerate(chosen['word']):
       k=(chosen['row']+(i if chosen['vertical'] else 0))*15+chosen['col']+(0 if chosen['vertical'] else i)
       if not board[k]:racks[side].remove('?' if ch.islower() else ch);board[k]=ch
      scores[side]+=int(chosen['score']);zero=0
      while len(racks[side])<7 and bag:racks[side].append(bag.pop())
     turn+=1;save();print(json.dumps(dict(game=game,turn=turn,matched=True,kind=capture['kind'],records=capture['count'],elapsed=round(report['elapsed_seconds'],1))),flush=True)
    assert turn<200
    report['completed_games']+=1;report['games'].append(dict(game=game,turns=turn,scores_before_final_adjustment=scores,remaining_racks=racks,bag=len(bag)));save()
  report['complete']=True
 except StopBatch as exc:report['complete']=False;report['stop_reason']=str(exc)
 except Exception as exc:report['failure']=str(exc);report['traceback']=traceback.format_exc();raise
 finally:
  api.maven_portable_destroy(engine);save();command('stop' if a.pause_on_exit else 'cont')
if __name__=='__main__':main()
