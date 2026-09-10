#!/usr/bin/env python3
"""Replay evaluated human application, CODE8 display callback and statistics."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/turn-commit-tiores-live.json');a=parser.parse_args()
    j=json.loads(a.capture.read_text());assert j['complete']
    assert hashlib.sha256((ROOT/'resources/CODE/35_35.bin').read_bytes()).hexdigest()==j['code_sha256']
    assert j['scored_move_callback_pointer']
    assert hashlib.sha256((ROOT/'resources/CODE/8_8.bin').read_bytes()).hexdigest()==j['display_supplement']['code8_sha256']
    turn=j['turn'];collector_final=j['final'];final=turn['application_return']
    j['final']={**collector_final,**{k:final[k] for k in ('board','values','counts','undo','row_zero_count','new_tiles','recorded_row','recorded_column')},'rack':final['rack0']}
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
    for name in ('move','pattern_records','pattern_strings','pattern_scores'):rawarray(name,bytes.fromhex(j[name]))
    rawarray('display',bytes.fromhex(j['display_supplement']['display']))
    rawarray('display_classes',bytes.fromhex(j['display_supplement']['classes']))
    for phase in ('before','after'):
        rawarray('callback_'+phase,bytes.fromhex(next(x['move'] for x in j['scored_callbacks'] if x['phase']==phase)))
    array('expected_features',final['features'],'uint32_t')
    array('statistics',turn['application_entry']['statistics'][0],'uint32_t')
    array('expected_statistics',turn['statistics_return']['statistics'][0],'uint32_t')
    expected=j['contributions'];array('expected_ids',[r['id'] for r in expected]+[0],'int16_t');array('expected_weights',[r['weight'] for r in expected]+[0],'int16_t')
    assert j['lookup_entries'],'Replay requires an original prepared cache'
    declarations.append('static MavenPatternEntry entries[]={'+','.join('{pattern_strings+'+str(e['string_offset'])+','+str(e['accumulator'])+'u,'+str(e['table_index'])+'}' for e in j['lookup_entries'])+'};')
    source='''#include "evaluated_application.h"
#include "display_move_score.h"
#include "move_statistics.h"
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
static int callback_count;
static void scored(void *u,uint8_t move[34]){
 if(!check("callback input",move,callback_before,34))++diagnostics;
 maven_score_display_move(u,move);
 if(!check("callback output",move,callback_after,34))++diagnostics;
 ++callback_count;
}
static uint32_t composition(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t total){(void)u;return maven_rack_composition(v,c,pv,pc,total,composition_scores[total]);}
int main(void){MavenApplyState app={0};MavenRackBalanceCache balance={0};MavenMoveEvaluation state={0};MavenMoveEvaluationResult result;MavenAppliedMove workspace={{0},0};uint32_t features[22];MavenDisplayMoveScore display_score;int16_t ids[4096],weights[4096];
 app.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};app.letter_multipliers=letter_multipliers;app.letter_class=letter_class;app.alphabet=alphabet;
 balance.evaluate_composition=composition;balance.diagnostic=diagnostic;memcpy(balance.entries,balance_entries,sizeof balance_entries);
 state.application=&app;state.rack=rack;state.distribution=distribution;state.vowel_characters=vowel_characters;
 state.premium=(MavenPremiumExposureInput){board,word_multipliers,letter_multipliers,letter_class,penalties,diagnostic,0};state.balance=&balance;
 state.lookup_entries=entries;state.lookup_count=sizeof entries/sizeof entries[0];
 state.patterns=(MavenPatternMatchInput){pattern_records,pattern_strings,pattern_scores,board,values,letter_values,counts,PATTERN_COUNT,diagnostic,0};
 state.opening_scores=opening_scores;state.small_pool_scores=small_pool_scores;state.q_with_unseen_u=q_with_unseen_u;state.q_without_held_u=q_without_held_u;state.unseen_q_query=unseen_q_query;state.held_u_query=held_u_query;state.letter_scores=letter_scores;
'''.replace('PATTERN_COUNT',str(j['pattern_record_count']))
    for name in ('row_zero_count','new_tiles'):source+=f'app.{name}={j["initial"][name]};\n'
    for name in ('recorded_row','recorded_column'):
        for i,v in enumerate(j['initial'][name]):source+=f'app.{name}[{i}]={v};\n'
    for name in ('vowels','consonants'):source+=f'balance.pool_{name}={j["initial"]["balance_pool_"+name]};\n'
    source+='display_score=(MavenDisplayMoveScore){&app,display,display_classes,rack};app.scored_move=scored;app.callback_user=&display_score;\n'
    source+='result=maven_apply_evaluated_move(move,&state,features,ids,weights,&workspace);CHECK(diagnostics,0);CHECK(callback_count,2);\n'
    source+='if(!check("features",features,expected_features,sizeof features))return 1;\n'
    source+='maven_add_move_statistics(features,statistics);if(!check("statistics",statistics,expected_statistics,sizeof statistics))return 1;\n'
    source+=f'CHECK(result.total_bits,{j["result_bits"]}u);CHECK(result.record_count,{len(expected)});\n'
    source+='if(!check("ids",ids,expected_ids,sizeof expected_ids)||!check("weights",weights,expected_weights,sizeof expected_weights))return 1;\n'
    for name in ('board','values','counts','undo','rack'):
        source+=f'if(!check("{name}",{name},expected_{name},sizeof {name}))return 1;\n'
    source+='if(!check("balance_entries",balance.entries,expected_balance_entries,sizeof balance_entries))return 1;\n'
    for name in ('vowels','consonants'):source+=f'CHECK(balance.pool_{name},{j["final"]["balance_pool_"+name]});\n'
    for name in ('row_zero_count','new_tiles'):source+=f'CHECK(app.{name},{j["final"][name]});\n'
    for name in ('recorded_row','recorded_column'):
        for i,v in enumerate(j['final'][name]):source+=f'CHECK(app.{name}[{i}],{v});\n'
    source+='return 0;}\n'
    build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'turn-commit-probe.c';probe.write_text(source);exe=build/'turn-commit-probe'
    sources=['evaluated_application','evaluation_features','display_move_score','move_statistics','move_evaluation','apply_move','board_state','move_finalize','score_move','score_accumulate','place_letters','rack_counts','remaining_tiles','undo_move','premium_exposure','rack_balance','rack_composition','pattern_match','pattern_lookup','letter_expectation']
    subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(exe)],check=True)
    subprocess.run([str(exe)],check=True,timeout=30)
    print(json.dumps(dict(scope='Evaluated application with computed collector, CODE8 display callback, board/value/rack/count/undo/scorer/cache,22 feature words and22 accumulated statistic words; prepared engine tables supplied; refill/save excluded',contributions=len(expected),result_bits=j['result_bits'],all_matched=True)))

if __name__=='__main__':main()
