#!/usr/bin/env python3
"""Replay a complete original CODE3 rollout batch using recovered selectors and computed refills with observed external inputs."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/rollout-batch-live.json');parser.add_argument('--captures',type=Path,nargs='+');parser.add_argument('--exhaustive',type=Path);parser.add_argument('--ranking-capture',type=Path);parser.add_argument('--opponent-draw',type=Path);parser.add_argument('--session',action='store_true');a=parser.parse_args()
    captures=[json.loads(path.read_text()) for path in (a.captures or [a.capture])]
    assert all(x['complete'] for x in captures)
    publications=[];publication_offset=0
    for capture in captures:
        for publication in capture.get('publications',[]):
            publications.append(dict(publication,event_index=publication['event_index']+publication_offset))
        publication_offset+=len(capture['events'])
    j=captures[0]
    batches=[(x['opponent_sample'],x['weight']) for x in captures]
    draw=json.loads(a.opponent_draw.read_text()) if a.opponent_draw else None
    if draw:
        assert len(captures)==1 and not a.exhaustive
        assert draw['sample_callback']['rack'].split('00')[0]==j['opponent_sample'].encode().hex()
        assert draw['sample_callback']['weight']==j['weight']==1
        assert draw['final']['board']==j['initial']['board']
        assert draw['initial']['values']==j['initial']['values']
        assert draw['initial']['rack0']==j['initial']['rack0']
        assert draw['initial']['rack1']==j['initial']['rack1']
        assert draw['final']['private_seed']==j['refills'][0]['private_seed']
    previous=j
    for next_capture in captures[1:]:
        for key in ('a5','candidate_count','fixed','sections','pattern_records','pattern_strings','pattern_scores','dictionary_sha256','code_sha256','code31_sha256'):
            assert next_capture[key]==j[key],key
        assert previous['final_config']==next_capture['config'],'batch candidate accumulator continuity'
        assert previous['final']==next_capture['initial'],'batch engine state continuity'
        event_offset=len(j['events'])
        for refill in next_capture['refills']:refill['event_index']+=event_offset
        j['events'].extend(next_capture['events']);j['refills'].extend(next_capture['refills'])
        previous=next_capture
    j['final']=previous['final'];j['final_config']=previous['final_config']
    session_tail=previous.get('session_tail') if a.session else None
    if a.session:
        assert (a.exhaustive or draw) and session_tail and [e['kind'] for e in session_tail]==['before_restore','board_racks_restored','leave_rebuilt','returned']
        assert j['initial']['board']==previous['session_saved']['board']
        assert j['initial']['values']==previous['session_saved']['values']
        j['final']=session_tail[-1]['state']
    data_path=ROOT/'../../media/maven/session/share/maven2.1'
    assert hashlib.sha256(data_path.read_bytes()).hexdigest()==j['dictionary_sha256']
    assert hashlib.sha256((ROOT/'resources/CODE/3_3.bin').read_bytes()).hexdigest()==j['code_sha256']
    declarations=[]
    def array(name,values,kind='uint8_t'):
        declarations.append('static '+kind+' '+name+'[]={'+','.join(str(v)+('u' if kind=='uint32_t' else '') for v in values)+'};')
    def rawarray(name,raw,kind='uint8_t'):
        code={'uint16_t':'H','uint32_t':'I','int16_t':'h'}.get(kind)
        values=struct.unpack('>'+str(len(raw)//struct.calcsize(code))+code,raw) if code else raw
        array(name,values,kind)
    for name in ('board','values','counts','undo','rack','balance_entries'):
        kind='uint16_t' if name=='values' else 'uint32_t' if name=='balance_entries' else 'uint8_t'
        rawarray(name,bytes.fromhex(j['initial'][name]),kind);rawarray('expected_'+name,bytes.fromhex(j['final'][name]),kind)
    for name,data in j['fixed'].items():
        if name in ('opening_scores','letter_scores','composition_scores'):
            if name=='opening_scores':array(name,data,'uint32_t')
            else:
                rows=[row+[0]*(8-len(row)) for row in data]
                declarations.append('static uint32_t '+name+'[][8]={'+','.join('{'+','.join(str(v)+'u' for v in row)+'}' for row in rows)+'};')
        elif name in ('vowel_characters','unseen_q_query','held_u_query'):
            rawarray(name,data.encode('ascii')+b'\0')
        else:
            kind='uint16_t' if name in ('letter_values','small_pool_scores','q_with_unseen_u','q_without_held_u') else 'uint8_t'
            rawarray(name,bytes.fromhex(data),kind)
    for name in ('pattern_records','pattern_strings','pattern_scores'):rawarray(name,bytes.fromhex(j[name]))
    if a.exhaustive:
        enumeration=json.loads(a.exhaustive.read_text());assert enumeration['complete']
        assert batches==[(x['rack'],x['weight']) for x in enumeration['samples']]
        rawarray('binomial_choose',bytes.fromhex(enumeration['choose']),'uint16_t')
    if a.ranking_capture:
        final_ranking=json.loads(a.ranking_capture.read_text())['calls'][-1]
        assert final_ranking['entries']==j['final_config'][48:]
        rawarray('expected_ranking',bytes.fromhex(final_ranking['output']))
    config=bytes.fromhex(j['config']);reply_plies=struct.unpack_from('>h',config,8)[0]
    assert not struct.unpack_from('>h',config,22)[0],'UI simulation capture integration is still pending'
    assert not struct.unpack_from('>h',config,18)[0] or j.get('late_calls'),'Late mode requires original selector traces'
    assert not struct.unpack_from('>h',config,20)[0] or j.get('endgame_calls'),'Endgame mode requires original search clock traces'
    array('rollout_entries',config[24:]);array('expected_entries',bytes.fromhex(j['final_config'])[24:])
    rawarray('rack0',bytes.fromhex(j['initial']['rack0']));rawarray('rack1',bytes.fromhex(j['initial']['rack1']))
    rawarray('initial_selected',bytes.fromhex(j['initial']['selected_move']))
    array('opponent_sample',j['opponent_sample'].encode()+b'\0')
    for name,kind in [('tile_points','uint16_t'),('mask_generations','uint32_t'),('occurrence_masks','uint16_t')]:rawarray(name,bytes.fromhex(j['initial'][name]),kind)
    kinds=['candidate_applied','candidate_refilled','reply_selected','reply_applied','reply_refilled','candidate_restored']
    declarations.append('typedef struct {unsigned kind,candidate,reply;uint8_t board[544],racks[2][8],counts[128],undo[33],selected[34],entries['+str(46*j['candidate_count'])+'];uint16_t values[544];int16_t counter,new_tiles,rows[2],columns[2];int side;} Event;')
    def nums(values):return '{'+','.join(str(v) for v in values)+'}'
    events=[]
    for event in j['events']:
        st=event['state'];side=0 if st['selected_rack_pointer']==j['a5']-0x3c9a else 1
        assert st['selected_rack_pointer'] in (j['a5']-0x3c9a,j['a5']-0x3ca2)
        events.append('{'+','.join([str(kinds.index(event['kind'])),str(event['candidate']),str(event['reply']),nums(bytes.fromhex(st['board'])),'{'+nums(bytes.fromhex(st['rack0']))+','+nums(bytes.fromhex(st['rack1']))+'}',nums(bytes.fromhex(st['counts'])),nums(bytes.fromhex(st['undo'])),nums(bytes.fromhex(st['selected_move'])),nums(bytes.fromhex(event['candidate_entries'])),nums(struct.unpack('>544H',bytes.fromhex(st['values']))),str(st['row_zero_count']),str(st['new_tiles']),nums(st['recorded_row']),nums(st['recorded_column']),str(side)])+'}')
    declarations.append('static const Event events[]={'+','.join(events)+'};')
    assert j['lookup_entries'],'Replay requires an original prepared cache'
    declarations.append('static MavenPatternEntry entries[]={'+','.join('{pattern_strings+'+str(e['string_offset'])+','+str(e['accumulator'])+'u,'+str(e['table_index'])+'}' for e in j['lookup_entries'])+'};')
    if j.get('refills'):
        assert hashlib.sha256((ROOT/'resources/CODE/31_31.bin').read_bytes()).hexdigest()==j['code31_sha256']
        refill_rows=[];random_rows=[]
        if draw:
            for event in draw['events']:
                random_rows.append('{'+str(['private_random','toolbox_random','ticks'].index(event['kind']))+','+str(event['value'])+'u}')
            for key in ('board','rack0','rack1','sample'):array('draw_before_'+key,bytes.fromhex(draw['sample_before'][key]))
            array('draw_expected_sample',bytes.fromhex(draw['final']['rack']))
            array('draw_expected_bag',bytes.fromhex(draw['final']['bag_workspace']))
        for refill in j['refills']:
            start=len(random_rows)
            for event in refill['events']:
                random_rows.append('{'+str(['private_random','toolbox_random','ticks'].index(event['kind']))+','+str(event['value'])+'u}')
            bag=bytes.fromhex(refill['bag']);final=refill['final']
            refill_rows.append('{'+','.join([str(refill['event_index']),str(refill['rack_side']),str(refill['private_seed'])+'u',str(refill['stack_ticks'])+'u',str(final['private_seed'])+'u',str(len(bag)),str(start),str(len(refill['events'])),nums(bag),nums(bytes.fromhex(final['bag_workspace'])),nums(bytes.fromhex(final['rack']))])+'}')
        declarations.append('typedef struct {unsigned event_index,side;uint32_t seed,ticks,final_seed;unsigned length,start,count;uint8_t bag[128],final_bag[128],rack[8];} Refill;')
        declarations.append('static const Refill refills[]={'+','.join(refill_rows)+'};')
        declarations.append('static const struct {unsigned kind;uint32_t value;} random_events[]={'+','.join(random_rows)+'};')
    if j.get('late_calls'):
        f=j['search_fixed']
        for name,key,kind in [('late_bit_masks','bit_masks','uint32_t'),('late_rows','row_flags','uint8_t'),('late_tables','late_tables','uint16_t'),('late_priority','priority','uint8_t')]:rawarray(name,bytes.fromhex(f[key]),kind)
        for name,key in [('late_q_query','search_q_query'),('late_blank_query','search_blank_query'),('late_exchange_q','exchange_q_string')]:rawarray(name,f[key].encode()+b'\0')
        for call in j['late_calls']:assert call['force']==0
    if j.get('endgame_calls'):
        fixed=j['search_fixed']
        for name,kind in [('bit_masks','uint32_t'),('hash_table','uint32_t'),('row_flags','uint8_t')]:rawarray('endgame_'+name,bytes.fromhex(fixed[name]),kind)
        clock_rows=[];call_rows=[]
        for call in j['endgame_calls']:
            start=len(clock_rows)
            clock_rows.extend('{'+str(x['ticks'])+'u,'+str(x['result'])+'u}' for x in call['elapsed'])
            call_rows.append('{'+','.join(str(x)+'u' for x in [call['event_index'],call['side'],call['budget'],call['reserve'],call.get('start_ticks',0),start,len(call['elapsed'])])+'}')
        declarations.append('static const struct EndCall {unsigned event_index,side,budget,reserve,start_ticks,clock_start,clock_count;} end_calls[]={'+','.join(call_rows)+'};')
        declarations.append('static const struct {uint32_t ticks,result;} end_clocks[]={'+','.join(clock_rows)+'};')
    session_callback=''
    if a.session:
        checks=[]
        fields=[('board','board','uint8_t'),('values','values','uint16_t'),('rack0','rack0','uint8_t'),('rack1','rack1','uint8_t'),('counts','counts','uint8_t'),('undo','undo','uint8_t'),('leave_values','observed_session->leaves->values','uint16_t'),('tile_points','observed_session->leaves->tile_points','uint16_t'),('canonical_masks','observed_session->leaves->canonical_masks','uint16_t'),('occurrence_masks','observed_session->leaves->occurrence_masks','uint16_t'),('mask_generations','observed_session->leaves->mask_generations','uint32_t')]
        for i,phase in enumerate(session_tail[:3]):
            body=[]
            for key,expr,kind in fields:
                name=f'session_{i}_{key}';rawarray(name,bytes.fromhex(phase['state'][key]),kind)
                body.append(f'if(!check("{phase["kind"]} {key}",{expr},{name},sizeof {name}))failed=1;')
            body.append(f'if(observed_session->leaves->generation!={phase["state"]["generation"]}u)failed=1;')
            checks.append(f'case {i}: '+''.join(body)+'break;')
        session_callback='static MavenSimulationSession *observed_session;static unsigned session_phase;\nstatic void session_checkpoint(void *u,const char *phase){(void)u;if(!strcmp(phase,"started"))return;switch(session_phase++){'+''.join(checks)+'default:failed=1;}}\n'
        if publications:
            checks=[]
            for i,publication in enumerate(publications):
                rawarray(f'published_{i}',bytes.fromhex(publication['moves']))
                rawarray(f'published_entries_{i}',bytes.fromhex(publication['entries']))
                checks.append(f'case {i}: if(count!={publication["count"]}||event_index!={publication["event_index"]}||!check("published ranking",moves,published_{i},sizeof published_{i})||!check("published accumulators",rollout_entries,published_entries_{i},sizeof published_entries_{i}))failed=1;break;')
            session_callback+='static unsigned publication_index;static void session_publish(void *u,const uint8_t *moves,unsigned count){(void)u;switch(publication_index++){'+''.join(checks)+'default:failed=1;}}\n'
    source='''#include "heuristic_search.h"
#include "rollout_search.h"
#include "simulation_search.h"
#include "simulation_session.h"
#include "random_opponent.h"
#include "search_dispatch.h"
#include "rack_refill.h"
#include "remaining_tiles.h"
#include "board_state.h"
#include <stdlib.h>
#include "rack_composition.h"
#include <stdio.h>
#include <string.h>
static int diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
static int check(const char *name,const void *actual,const void *expected,size_t size){
 const unsigned char *a=actual,*e=expected;size_t i;
 for(i=0;i<size;++i)if(a[i]!=e[i]){fprintf(stderr,"%s byte %lu: %u != %u\\n",name,(unsigned long)i,a[i],e[i]);return 0;}return 1;}
#define CHECK(a,b) do{if((a)!=(b)){fprintf(stderr,"%s: %lld != %lld\\n",#a,(long long)(a),(long long)(b));return 1;}}while(0)
'''+ '\n'.join(declarations)+'''
static uint32_t composition(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t total){(void)u;return maven_rack_composition(v,c,pv,pc,total,composition_scores[total]);}
static MavenApplyState app;static MavenRolloutSearch rollout;static MavenHeuristicSearch search;static MavenSearchDispatch dispatch;static MavenLateSearch late_engine;
static unsigned event_index;static int failed;
static void select_move(void *u,int side,uint8_t *move){(void)u;dispatch.heuristic=&search;memcpy(dispatch.selected_move,rollout.selected_move,34);if(!maven_select_best_move(&dispatch,rollout.racks[side],rollout.racks[1-side])){failed=1;return;}memcpy(move,dispatch.selected_move,34);}
static void refill(void *u,int side){const Event *e=&events[event_index];(void)u;if(e->kind!=MAVEN_ROLLOUT_CANDIDATE_REFILLED&&e->kind!=MAVEN_ROLLOUT_REPLY_REFILLED){failed=1;return;}memcpy(rollout.racks[side],e->racks[side],8);memset(board,0,17);}
static void observe(void *u,MavenRolloutEvent kind,unsigned candidate,unsigned reply){const Event *e=&events[event_index];(void)u;
 if(event_index>=sizeof events/sizeof events[0]){failed=1;return;}
 if(kind!=e->kind||candidate!=e->candidate||(kind>=MAVEN_ROLLOUT_REPLY_SELECTED&&reply!=e->reply)){fprintf(stderr,"event header %u\\n",event_index);failed=1;}
 if(!check("board",board,e->board,sizeof board)||!check("values",values,e->values,sizeof values)||!check("rack0",rack0,e->racks[0],8)||!check("rack1",rack1,e->racks[1],8)||!check("counts",counts,e->counts,128)||!check("undo",undo,e->undo,33)||!check("selected",rollout.selected_move,e->selected,34)||!check("entries",rollout_entries,e->entries,sizeof rollout_entries)){fprintf(stderr,"event %u kind %u candidate %u reply %u\\n",event_index,kind,candidate,reply);failed=1;}
 if(app.row_zero_count!=e->counter||app.new_tiles!=e->new_tiles||memcmp(app.recorded_row,e->rows,4)||memcmp(app.recorded_column,e->columns,4)||rollout.selected_side!=e->side){fprintf(stderr,"event scalar %u counter %d/%d tiles %d/%d rows %d,%d/%d,%d cols %d,%d/%d,%d side %d/%d\\n",event_index,app.row_zero_count,e->counter,app.new_tiles,e->new_tiles,app.recorded_row[0],app.recorded_row[1],e->rows[0],e->rows[1],app.recorded_column[0],app.recorded_column[1],e->columns[0],e->columns[1],rollout.selected_side,e->side);failed=1;}
 ++event_index;}
int main(int argc,char **argv){MavenRackBalanceCache balance={0};MavenMoveEvaluation state={0};MavenLeaveTable leaves={0};MavenCandidateList ranking={0};MavenDictionarySection sections[17]={{0,0}};uint8_t *data;FILE *file;long size;
 (void)late_engine;if(argc!=2)return 2;file=fopen(argv[1],"rb");if(!file)return 2;fseek(file,0,SEEK_END);size=ftell(file);rewind(file);data=malloc((size_t)size);if(!data||fread(data,1,(size_t)size,file)!=(size_t)size)return 2;fclose(file);
 app.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};app.letter_multipliers=letter_multipliers;app.letter_class=letter_class;app.alphabet=alphabet;
 balance.evaluate_composition=composition;balance.diagnostic=diagnostic;memcpy(balance.entries,balance_entries,sizeof balance_entries);
 state.application=&app;state.rack=rack0;state.distribution=distribution;state.vowel_characters=vowel_characters;
 state.premium=(MavenPremiumExposureInput){board,word_multipliers,letter_multipliers,letter_class,penalties,diagnostic,0};state.balance=&balance;
 state.lookup_entries=entries;state.lookup_count=sizeof entries/sizeof entries[0];
 state.patterns=(MavenPatternMatchInput){pattern_records,pattern_strings,pattern_scores,board,values,letter_values,counts,PATTERN_COUNT,diagnostic,0};
 state.opening_scores=opening_scores;state.small_pool_scores=small_pool_scores;state.q_with_unseen_u=q_with_unseen_u;state.q_without_held_u=q_without_held_u;state.unseen_q_query=unseen_q_query;state.held_u_query=held_u_query;state.letter_scores=letter_scores;
'''.replace('PATTERN_COUNT',str(j['pattern_record_count']))
    if a.session:source=source.replace('int main(int argc',session_callback+'int main(int argc')
    if j.get('interrupted'):
        assert a.session and draw and j['events'][-1]['kind']=='reply_refilled'
        source=source.replace('int main(int argc','static int cancelled(void *u){(void)u;return event_index==sizeof events/sizeof events[0];}\nint main(int argc')
    if j.get('endgame_calls'):
        before=source.index('static void select_move(');after=source.index('static void refill(',before)
        source=source[:before]+r'''static MavenEndgameGeneration end_generation;static MavenEndgameTree end_tree;static MavenEndgameNode end_nodes[8192];static MavenEndgameSearch end_search;static unsigned end_call_index,end_clock_index;
static int32_t end_elapsed(void *u){const struct EndCall *call=&end_calls[end_call_index];uint32_t bits;int32_t result;(void)u;
if(end_clock_index>=sizeof end_clocks/sizeof end_clocks[0]){failed=1;return INT32_MAX;}
bits=end_clocks[end_clock_index].ticks-call->start_ticks+30;result=(int32_t)(bits<=INT32_MAX?(int64_t)bits:(int64_t)bits-INT64_C(4294967296))/60;
if((uint32_t)result!=end_clocks[end_clock_index].result)failed=1;++end_clock_index;return result;}
static void select_move(void *u,int side,uint8_t *move){uint8_t selected_counts[128]={0},unseen[128]={0};int16_t total;int use_end;(void)u;
maven_count_rack(selected_counts,app.alphabet,rollout.racks[side]);total=maven_count_unseen_tiles(unseen,distribution,board,values,selected_counts,app.alphabet);use_end=maven_choose_search_kind(total,dispatch.endgame_enabled,dispatch.late_enabled)==MAVEN_SEARCH_ENDGAME;
if(use_end){const struct EndCall *call;if(end_call_index>=sizeof end_calls/sizeof end_calls[0]){failed=1;return;}call=&end_calls[end_call_index];if(call->event_index!=event_index||call->side!=(unsigned)side||call->clock_start!=end_clock_index)failed=1;end_search.reserve_control=(int16_t)call->reserve;dispatch.endgame_budget_seconds=(int32_t)call->budget;}
dispatch.heuristic=&search;memcpy(dispatch.selected_move,rollout.selected_move,34);if(!maven_select_best_move(&dispatch,rollout.racks[side],rollout.racks[1-side])){failed=1;return;}memcpy(move,dispatch.selected_move,34);
if(use_end){const struct EndCall *call=&end_calls[end_call_index++];if(end_clock_index!=call->clock_start+call->clock_count)failed=1;}}
''' +source[after:]
        source=source.replace('#include "remaining_tiles.h"','#include "remaining_tiles.h"\n#include "rack_counts.h"')
    if j.get('refills'):
        old=source[source.index('static void refill('):source.index('static void observe(')]
        source=source.replace(old,r'''static unsigned refill_index,random_index;static uint32_t private_seed;
static uint32_t random_input(unsigned kind){uint32_t value;if(random_index>=sizeof random_events/sizeof random_events[0]){failed=1;return kind==2?random_index++:0;}if(random_events[random_index].kind!=kind){fprintf(stderr,"random kind %u\n",random_index);failed=1;}value=random_events[random_index++].value;if(kind==0&&maven_private_random_next(&private_seed)!=value){fprintf(stderr,"private random mismatch\n");failed=1;}return value;}
static uint32_t private_random(void *u){(void)u;return random_input(0);}
static int16_t toolbox_random(void *u){uint16_t value;(void)u;value=(uint16_t)random_input(1);return value<32768?(int16_t)value:(int16_t)((int32_t)value-65536);}
static uint32_t ticks(void *u){(void)u;return random_input(2);}
static void refill(void *u,int side){uint8_t bag[128];uint32_t length;const Refill *f;MavenRefillOps ops={0,private_random,toolbox_random,ticks};(void)u;
if(refill_index>=sizeof refills/sizeof refills[0]){failed=1;return;}f=&refills[refill_index++];
if(f->event_index!=event_index||f->side!=(unsigned)side||f->start!=random_index){fprintf(stderr,"refill header %u\n",refill_index);failed=1;}
length=maven_collect_remaining_tiles(bag,distribution,board,values,rack0,rack1,alphabet);if(length!=f->length||!check("bag",bag,f->bag,length)){failed=1;return;}
if(refill_index==1)private_seed=f->seed;else if(private_seed!=f->seed){fprintf(stderr,"private seed continuity\n");failed=1;}
maven_refill_rack_from_bag(rollout.racks[side],bag,length,board,f->ticks,&ops);
if(random_index!=f->start+f->count||private_seed!=f->final_seed||!check("refilled rack",rollout.racks[side],f->rack,8)||!check("refill bag",bag,f->final_bag,length)){fprintf(stderr,"refill result %u\n",refill_index);failed=1;}
}
''')
    if draw:
        source=source.replace('if(refill_index==1)private_seed=f->seed;else if(private_seed!=f->seed)', 'if(private_seed!=f->seed)')
    for name in ('row_zero_count','new_tiles'):source+=f'app.{name}={j["initial"][name]};\n'
    for name in ('recorded_row','recorded_column'):
        for i,v in enumerate(j['initial'][name]):source+=f'app.{name}[{i}]={v};\n'
    for name in ('vowels','consonants'):source+=f'balance.pool_{name}={j["initial"]["balance_pool_"+name]};\n'
    for i,section in enumerate(j['sections']):source+=f'sections[{i}]=(MavenDictionarySection){{data+{section["offset"]},{section["root"]}u}};\n'
    source+='leaves.alphabet=alphabet;leaves.vowel_characters=vowel_characters;leaves.distribution=distribution;leaves.letter_values=letter_values;leaves.letter_scores=letter_scores;leaves.q_with_unseen_u=q_with_unseen_u;leaves.q_without_held_u=q_without_held_u;leaves.held_u_query=held_u_query;leaves.patterns=entries;leaves.pattern_count=sizeof entries/sizeof entries[0];leaves.score_records=pattern_scores;leaves.balance=&balance;\n'
    source+='memcpy(leaves.tile_points,tile_points,sizeof tile_points);memcpy(leaves.mask_generations,mask_generations,sizeof mask_generations);memcpy(leaves.occurrence_masks,occurrence_masks,sizeof occurrence_masks);\n'
    source+=f'leaves.generation={j["initial"]["generation"]}u;ranking.cutoff_bits={j["initial"]["ranking"]["cutoff_bits"]}u;\n'
    source+='search.sections=sections;search.evaluation=&state;search.leaves=&leaves;search.result=&ranking;search.opponent_rack=rack1;search.word_deduplication=0;\n'
    source+=f'rollout.application=&app;rollout.racks[0]=rack0;rollout.racks[1]=rack1;rollout.entries=rollout_entries;rollout.count={j["candidate_count"]};rollout.reply_plies={reply_plies};rollout.selected_side={0 if j["initial"]["selected_rack_pointer"]==j["a5"]-0x3c9a else 1};\n'
    source+='rollout.select=select_move;rollout.refill=refill;rollout.observe=observe;memcpy(rollout.selected_move,initial_selected,34);\n'
    if j.get('late_calls'):
        source+='late_engine.application=&app;late_engine.leaves=&leaves;late_engine.patterns=state.patterns;late_engine.sections=sections;late_engine.bit_masks=late_bit_masks;late_engine.choose=(const uint16_t(*)[8])late_tables;late_engine.priority_order=late_priority;late_engine.q_query=late_q_query;late_engine.blank_query=late_blank_query;late_engine.exchange_q_string=late_exchange_q;late_engine.row_flags=late_rows;search.row_flags=late_rows;late_engine.bingo_bonus=5000;dispatch.late=&late_engine;dispatch.late_enabled=1;\n'
        source+=f'late_engine.leave_offset={j["search_fixed"]["leave_offset"]};\n'
        for name,off,size in [('normal_bag',0x6114,20),('held_q_bag',0x6100,20),('reply_q_bag',0x60ec,20),('normal_empty_bag',0x6394,128),('held_q_no_u',0x6314,128),('held_q_with_u',0x6214,128),('blank_adjustment',0x6494,128),('opponent_held_q',0x6294,128)]:source+=f'memcpy(late_engine.value.{name},late_tables+{(0x65a8-off)//2},{size});\n'
        source+='late_engine.value.normal_before_matrix=late_tables[(0x65a8-0x6316)/2];late_engine.value.with_u_before_matrix=late_tables[(0x65a8-0x6216)/2];\n'
    if j.get('endgame_calls'):
        assert j['search_fixed']['capacity']==8192
        source+='end_generation.application=&app;end_generation.sections=sections;end_generation.bit_masks=endgame_bit_masks;end_generation.row_flags=endgame_row_flags;search.row_flags=endgame_row_flags;end_generation.bingo_bonus=5000;end_tree.nodes=end_nodes;end_tree.capacity=8192;end_tree.diagnostic=diagnostic;end_search.leaf.generation=&end_generation;end_search.leaf.tree=&end_tree;end_search.leaf.hash_table=endgame_hash_table;end_search.letter_values=letter_values;end_search.elapsed_seconds=end_elapsed;dispatch.endgame=&end_search;dispatch.endgame_enabled=1;\n'
    if draw and not a.session:
        source+='uint8_t drawn_sample[8],draw_bag[128];MavenRefillOps draw_ops={0,private_random,toolbox_random,ticks};memcpy(board,draw_before_board,544);memcpy(rack0,draw_before_rack0,8);memcpy(rack1,draw_before_rack1,8);memcpy(drawn_sample,draw_before_sample,8);\n'
        source+=f'private_seed={draw["initial"]["private_seed"]}u;CHECK(maven_draw_random_opponent(drawn_sample,rack1,rack0,draw_bag,distribution,board,values,alphabet,{draw["initial"]["stack_ticks"]}u,&draw_ops),{len(bytes.fromhex(draw["initial"]["bag"]))});CHECK(random_index,{len(draw["events"])});CHECK(private_seed,{draw["final"]["private_seed"]}u);\n'
        source+='if(!check("draw sample",drawn_sample,draw_expected_sample,8)||!check("draw bag",draw_bag,draw_expected_bag,sizeof draw_expected_bag))return 1;\n'
    if a.session and draw:
        source=source.replace('int main(int argc',f'static uint32_t draw_stack_ticks(void *u){{(void)u;return {draw["initial"]["stack_ticks"]}u;}}\nint main(int argc')
        source+='memcpy(board,draw_before_board,544);memcpy(rack0,draw_before_rack0,8);memcpy(rack1,draw_before_rack1,8);\n'
        source+=f'private_seed={draw["initial"]["private_seed"]}u;\n'
        source+='MavenSimulationSession session={0};session.rollout=&rollout;session.leaves=&leaves;session.distribution=distribution;session.checkpoint=session_checkpoint;observed_session=&session;session.random=(MavenRefillOps){0,private_random,toolbox_random,ticks};session.stack_ticks=draw_stack_ticks;memcpy(session.sample,draw_before_sample,8);\n'
        if j.get('interrupted'):
            source+='rollout.cancelled=cancelled;CHECK(maven_begin_simulation_session(&session),1);CHECK(maven_step_simulation_session(&session),MAVEN_SIMULATION_CANCELLED);CHECK(session.batches,0);CHECK(session.total_weight,0);CHECK(session_phase,3);\n'
        else:
            source+=f'session.limit_bits={previous["controlled_mutation"]["first_candidate_weight"]}u;CHECK(maven_begin_simulation_session(&session),1);CHECK(maven_step_simulation_session(&session),MAVEN_SIMULATION_LIMIT);CHECK(session.batches,1);CHECK(session_phase,3);\n'
        source+='if(!check("draw sample",session.sample,draw_expected_sample,8)||!check("draw bag",session.bag,draw_expected_bag,sizeof draw_expected_bag))return 1;\n'
    elif a.session:
        source+='MavenSimulationSession session={0};session.rollout=&rollout;session.leaves=&leaves;session.distribution=distribution;session.choose=(const uint16_t (*)[8])binomial_choose;session.checkpoint=session_checkpoint;observed_session=&session;(void)opponent_sample;\n'
        source+=f'CHECK(maven_begin_simulation_session(&session),1);CHECK(maven_run_exhaustive_session(&session),MAVEN_SIMULATION_EXHAUSTED);CHECK(session.batches,{len(batches)});CHECK(session.total_weight,{sum(x[1] for x in batches)}u);CHECK(session_phase,3);\n'
    elif a.exhaustive:
        source+='MavenExhaustiveSimulation simulation={0};simulation.rollout=&rollout;simulation.distribution=distribution;simulation.choose=(const uint16_t (*)[8])binomial_choose;(void)opponent_sample;\n'
        source+=f'CHECK(maven_simulate_all_opponent_racks(&simulation),1);CHECK(simulation.batches,{len(batches)});CHECK(simulation.total_weight,{sum(x[1] for x in batches)}u);\n'
        if a.ranking_capture:source+='if(!check("final sampled ranking",simulation.ranked,expected_ranking,sizeof expected_ranking))return 1;\n'
    else:
        for i,(sample,weight) in enumerate(batches):
            argument=('drawn_sample' if draw else 'opponent_sample') if i==0 else '(const uint8_t[])'+nums(sample.encode()+b'\0')
            source+=f'maven_run_rollout_batch(&rollout,{argument},{weight}u);\n'
    if a.ranking_capture and not a.exhaustive:source+='uint8_t final_sampled[64][34];maven_rank_sampled_candidates(rollout_entries,rollout.count,final_sampled[0]);if(!check("final sampled ranking",final_sampled,expected_ranking,sizeof expected_ranking))return 1;\n'
    source+='CHECK(diagnostics,0);CHECK(failed,0);CHECK(event_index,sizeof events/sizeof events[0]);\n'
    if a.session and publications:
        source=source.replace('observed_session=&session;', 'observed_session=&session;session.publish=session_publish;')
        source+=f'CHECK(publication_index,{len(publications)});\n'
    if j.get('endgame_calls'):source+='CHECK(end_call_index,sizeof end_calls/sizeof end_calls[0]);CHECK(end_clock_index,sizeof end_clocks/sizeof end_clocks[0]);\n'
    if j.get('refills'):source+='CHECK(refill_index,sizeof refills/sizeof refills[0]);CHECK(random_index,sizeof random_events/sizeof random_events[0]);\n'
    source+='if(!check("final entries",rollout_entries,expected_entries,sizeof rollout_entries))return 1;\n'
    for name in ('board','values','counts','undo'):
        source+=f'if(!check("{name}",{name},expected_{name},sizeof {name}))return 1;\n'
    source+='(void)opponent_sample;(void)expected_rack;(void)rack;(void)expected_balance_entries;free(data);return 0;}\n'
    build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'rollout-probe.c';probe.write_text(source);exe=build/'rollout-probe'
    sources=['move_evaluation','apply_move','board_state','move_finalize','score_move','score_accumulate','place_letters','rack_counts','remaining_tiles','undo_move','premium_exposure','rack_balance','rack_composition','pattern_match','pattern_lookup','letter_expectation']
    sources+=['random_opponent','simulation_session','simulation_restore','simulation_search','opponent_samples','rack_refill','rollout_search','heuristic_search','leave_table','adjusted_pattern_lookup','rack_masks','exchange_candidates','candidate_ranking','opening_moves','opening_placements','board_moves','board_placements','cross_check_letters','dictionary_lookup']
    sources+=['search_dispatch','late_search_budget','search_policy','endgame_search','endgame_leaf','endgame_tree','endgame_generation','endgame_move_cache','endgame_rack_bounds','reply_bounds','local_replies','late_search','late_preparation','late_pool_select','late_setup','late_ranking','late_reply_value','pool_weights']
    subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(exe)],check=True)
    subprocess.run([str(exe),str(data_path)],check=True,timeout=30)
    print(json.dumps(dict(scope='Complete CODE3 rollout computation with recovered enabled reply searches, application and weighted totals; original external-input boundaries documented separately',computed_opponent_draw=bool(draw),reconstructed_refills=len(j.get('refills',[])),external_inputs=('Toolbox random and clock ticks; private seed supplied once before opponent draw' if draw else 'Toolbox random and clock ticks; private seed supplied once at batch entry') if j.get('refills') else 'Recorded refill outcomes',endgame_calls=len(j.get('endgame_calls',[])),late_calls=len(j.get('late_calls',[])),exhaustive=bool(a.exhaustive),complete_session=bool(a.session),publications_compared=len(publications) if a.session else 0,interrupted=bool(j.get('interrupted')),batches=len(batches),candidates=j['candidate_count'],reply_plies=reply_plies,events=len(j['events']),all_matched=True)))

if __name__=='__main__':main()
