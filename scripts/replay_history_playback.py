#!/usr/bin/env python3
"""Replay original saved-history traversal with computed placement, scores and refills."""
import argparse,hashlib,json,struct,subprocess
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True);p.add_argument('--next-capture',type=Path);args=p.parse_args();j=json.loads(args.capture.read_text());assert j['complete']
targets=[j.get('target_index')];final=j.get('navigation_return',j.get('open_return'))
if args.next_capture:
 nxt=json.loads(args.next_capture.read_text());assert nxt['complete'] and nxt['history_navigation']
 assert nxt['wire']==j['wire'] and nxt['fixed']==j['fixed'] and nxt['a5']==j['a5']
 assert nxt['initial']==j.get('navigation_return',j.get('open_return'))
 assert nxt['refills'][0]['private_seed']==j['refills'][-1]['final']['private_seed']
 offset=len(j['events'])
 for f in nxt['refills']:f['record_event_index']+=offset
 j['events'].extend(nxt['events']);j['refills'].extend(nxt['refills']);targets.append(nxt['target_index']);final=nxt['navigation_return']
for rid,digest in j['identities'].items():assert hashlib.sha256(Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==digest
wire=bytes.fromhex(j['wire']);assert hashlib.sha256(wire).hexdigest()==j['file_sha256']
def nums(values):return '{'+','.join(str(x)+'u' for x in values)+'}'
decl=[]
def array(name,hexdata,kind='uint8_t'):
 b=bytes.fromhex(hexdata) if isinstance(hexdata,str) else hexdata
 vals=struct.unpack('>'+str(len(b)//2)+'H',b) if kind=='uint16_t' else b
 decl.append(f'static {kind} {name}[]={nums(vals)};')
array('wire',wire)
array('display_order',Path('resources/prfs/0_0.bin').read_bytes()[0x312:0x312+28])
for key in ('board','values','rack0','rack1','counts','undo'):array(key,j['initial'][key],'uint16_t' if key=='values' else 'uint8_t')
for key,value in j['fixed'].items():array(key,value,'uint16_t' if key=='letter_values' else 'uint8_t')
for key in ('board','values','rack0','rack1','counts','undo'):array('final_'+key,final[key],'uint16_t' if key=='values' else 'uint8_t')
checks=[]
for i,event in enumerate(j['events']):
 st=event['state'];body=[f'REQUIRE(index=={event["index"]} && tag=={event["tag"]});']
 for key in ('board','values','rack0','rack1','counts','undo'):
  array(f'expected_{i}_{key}',st[key],'uint16_t' if key=='values' else 'uint8_t');body.append(f'REQUIRE(!memcmp({key},expected_{i}_{key},sizeof {key}));')
 body.extend([f'REQUIRE(history.totals[0]=={st["totals"][0]}u && history.totals[1]=={st["totals"][1]}u);',f'REQUIRE(history.selected_side=={0 if st["selected_pointer"]==j["a5"]-0x3c9a else 1});'])
 for key in ('row_zero_count','new_tiles'):body.append(f'REQUIRE(app.{key}=={st[key]});')
 for key in ('recorded_row','recorded_column'):
  for n,v in enumerate(st[key]):body.append(f'REQUIRE(app.{key}[{n}]=={v});')
 checks.append(f'case {i}: '+''.join(body)+'break;')
random=[];refills=[]
for f in j['refills']:
 start=len(random)
 for e in f['events']:random.append((['private_random','toolbox_random','ticks'].index(e['kind']),e['value']))
 final=f['final'];bag=bytes.fromhex(f['bag']);refills.append('{'+','.join([str(f['record_event_index']),str(f['side']),str(f['private_seed'])+'u',str(f['stack_ticks'])+'u',str(final['private_seed'])+'u',str(len(bag)),str(start),str(len(f['events'])),nums(bag),nums(bytes.fromhex(final['bag_workspace'])),nums(bytes.fromhex(final['rack']))])+'}')
decl.append('static const struct {unsigned kind;uint32_t value;} random_events[]={'+','.join('{'+str(k)+','+str(v)+'u}' for k,v in random)+'};')
decl.append('static const struct Refill {unsigned event_index,side;uint32_t seed,ticks,final_seed;unsigned length,start,count;uint8_t bag[128],final_bag[128],rack[8];} refills[]={'+','.join(refills)+'};')
source='''#include "history_playback.h"
#include "rack_refill.h"
#include "remaining_tiles.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"line %d event %u refill %u: %s\\n",__LINE__,event_index,refill_index,#x);exit(1);}}while(0)
static MavenApplyState app;static MavenHistoryPlayback history;
static unsigned event_index,refill_index,random_index;static uint32_t private_seed;
'''+ '\n'.join(decl)+'''
static void diagnostic(void *u){(void)u;REQUIRE(0);}
static uint32_t input(unsigned kind){uint32_t value;REQUIRE(random_index<sizeof random_events/sizeof random_events[0]);REQUIRE(random_events[random_index].kind==kind);value=random_events[random_index++].value;if(!kind)REQUIRE(maven_private_random_next(&private_seed)==value);return value;}
static uint32_t private_random(void *u){(void)u;return input(0);}
static int16_t toolbox_random(void *u){uint32_t v;(void)u;v=input(1);return v<32768?(int16_t)v:(int16_t)((int32_t)v-65536);}
static uint32_t ticks(void *u){(void)u;return input(2);}
static int refill(void *u,unsigned side){uint8_t bag[128];uint32_t length;const struct Refill *f;MavenRefillOps ops={0,private_random,toolbox_random,ticks};(void)u;
REQUIRE(refill_index<sizeof refills/sizeof refills[0]);f=&refills[refill_index++];REQUIRE(f->event_index==event_index&&f->side==side&&f->start==random_index);
REQUIRE(private_seed==f->seed);length=maven_collect_remaining_tiles(bag,distribution,board,values,rack0,rack1,alphabet);REQUIRE(length==f->length&&!memcmp(bag,f->bag,length));
maven_refill_rack_from_bag(history.racks[side],bag,length,board,f->ticks,&ops);
REQUIRE(random_index==f->start+f->count&&private_seed==f->final_seed);REQUIRE(!memcmp(history.racks[side],f->rack,8)&&!memcmp(bag,f->final_bag,length));return 1;}
static void checkpoint(void *u,size_t index,int tag){(void)u;switch(event_index){'''+''.join(checks)+'''default:REQUIRE(0);}++event_index;}
int main(void){MavenHistoryRecord records[1024];size_t count=0;
app.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};app.letter_multipliers=letter_multipliers;app.letter_class=letter_class;app.alphabet=alphabet;
history.display_order=display_order;history.application=&app;history.racks[0]=rack0;history.racks[1]=rack1;history.refill=refill;history.checkpoint=checkpoint;
'''
for key in ('row_zero_count','new_tiles'):source+=f'app.{key}={j["initial"][key]};\n'
for key in ('recorded_row','recorded_column'):
 for i,v in enumerate(j['initial'][key]):source+=f'app.{key}[{i}]={v};\n'
for i,v in enumerate(j['initial']['totals']):source+=f'history.totals[{i}]={v}u;\n'
source+=f'history.selected_side={0 if j["initial"]["selected_pointer"]==j["a5"]-0x3c9a else 1};private_seed={j["refills"][0]["private_seed"]}u;\n'
source+='REQUIRE(maven_decode_history_records(wire,sizeof wire,records,1024,&count)==MAVEN_HISTORY_OK);history.records=records;history.count=count;REQUIRE(maven_restore_history_index(&history,TARGET_INDEX)==MAVEN_PLAYBACK_OK);REQUIRE(event_index==sizeof((int[]){'+','.join('0' for _ in j['events'])+'})/sizeof(int));REQUIRE(refill_index==sizeof refills/sizeof refills[0]);REQUIRE(random_index==sizeof random_events/sizeof random_events[0]);REQUIRE(history.selected_side==0);return 0;}\n'
source=source.replace('REQUIRE(maven_restore_history_index(&history,TARGET_INDEX)==MAVEN_PLAYBACK_OK);',''.join(f'REQUIRE(maven_restore_history_index(&history,{target if target is not None else "count-1"})==MAVEN_PLAYBACK_OK);' for target in targets))
source=source.replace('return 0;}\n',''.join(f'REQUIRE(!memcmp({key},final_{key},sizeof {key}));' for key in ('board','values','rack0','rack1','counts','undo'))+'return 0;}\n')
Path('.build/history-playback-probe.c').write_text(source)
sources=['history_playback','history_records','history_snapshot','apply_move','score_move','score_accumulate','place_letters','move_finalize','board_state','rack_counts','rack_refill','remaining_tiles']
subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-Ireconstruction','.build/history-playback-probe.c',*[f'reconstruction/{x}.c' for x in sources],'-o','.build/history-playback-probe'],check=True)
subprocess.run(['.build/history-playback-probe'],check=True)
print(json.dumps(dict(scope=__doc__,consecutive_restores=len(targets),records=len(j['events']),refills=len(j['refills']),external_inputs=len(random),all_matched=True)))
