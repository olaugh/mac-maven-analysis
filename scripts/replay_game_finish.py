#!/usr/bin/env python3
"""Replay original end-of-game rack adjustment, statistics and final record semantics."""
import json,struct,subprocess
from pathlib import Path
j=json.loads(Path('analysis/toolchain/game-finish-tiros-live.json').read_text());assert j['complete'];before=j['initial'];after=j['final'];decl=[]
def array(name,value,kind='uint8_t'):
 if isinstance(value,str):
  raw=bytes.fromhex(value);value=struct.unpack('>'+str(len(raw)//2)+'H',raw) if kind=='uint16_t' else raw
 decl.append('static '+kind+' '+name+'[]={'+','.join(str(v)+'u' for v in value)+'};')
for k in ('rack0','rack1','counts'):array(k,before[k]);array('expected_'+k,after[k])
array('letter_values',j['letter_values'],'uint16_t');array('alphabet',j['alphabet'])
array('totals',before['totals'],'uint32_t');array('expected_totals',after['totals'],'uint32_t')
array('statistics',sum(before['statistics'],[]),'uint32_t');array('expected_statistics',sum(after['statistics'],[]),'uint32_t')
array('records',''.join(x['payload'] for x in j['records']))
source='''#include "game_turn.h"
#include <assert.h>
#include <string.h>
'''+ '\n'.join(decl)+'''
static unsigned n;
static int append(void *u,int tag,const uint8_t *p,size_t length){const uint8_t *expected=records+18*n;(void)u;
 assert(n<2&&tag==3&&length==18);assert(!memcmp(p,expected,2));assert(!strcmp((const char *)p+2,(const char *)expected+2));assert(!memcmp(p+10,expected+10,8));++n;return 1;}
int main(void){MavenApplyState app={0};MavenMoveEvaluation evaluation={0};MavenGameTurn game={0};
 app.placement.letter_values=letter_values;app.placement.counts=counts;app.alphabet=alphabet;
 evaluation.application=&app;game.evaluation=&evaluation;game.racks[0]=rack0;game.racks[1]=rack1;
 memcpy(game.totals,totals,sizeof totals);memcpy(game.statistics,statistics,sizeof statistics);game.selected_side=SELECTED;game.phase=4;game.append=append;
 assert(maven_finish_game(&game)==1&&n==2&&game.phase==5&&game.selected_side==2&&evaluation.rack==0);
 assert(!memcmp(game.totals,expected_totals,sizeof totals)&&!memcmp(game.statistics,expected_statistics,sizeof statistics));
 assert(!memcmp(rack0,expected_rack0,8)&&!memcmp(rack1,expected_rack1,8)&&!memcmp(counts,expected_counts,128));
 return 0;}
'''.replace('SELECTED',str(before['selected_side']))
p=Path('.build/game-finish-probe.c');p.write_text(source);exe=p.with_suffix('')
subprocess.run(['make','-s','all'],check=True)
subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-Ireconstruction',str(p),'reconstruction/game_turn.c','.build/libmaven-reconstruction.a','-o',str(exe)],check=True);subprocess.run([str(exe)],check=True)
print(json.dumps(dict(scope=__doc__,totals=after['totals'],statistic_words=44,record_semantics=2,padding='zero-initialized modern output; original uninitialized suffix bytes excluded',all_matched=True)))
