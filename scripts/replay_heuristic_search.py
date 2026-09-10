#!/usr/bin/env python3
"""Replay a complete original CODE28 heuristic search through the assembled C engine."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/heuristic-search-live.json');a=parser.parse_args()
    j=json.loads(a.capture.read_text());assert j['complete'] and j['search']
    data_path=ROOT/'../../media/maven/session/share/maven2.1'
    assert hashlib.sha256(data_path.read_bytes()).hexdigest()==j['dictionary_sha256']
    assert j['search_callback']==j['a5']+0x842
    assert j['extra_filter_pointer'] in (0,j['a5']+0xad2)
    assert hashlib.sha256((ROOT/'resources/CODE/32_32.bin').read_bytes()).hexdigest()==j['code_sha256']
    assert j['scored_move_callback_pointer']==0,'Additional scored-copy callback is not supplied by this replay'
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
    expected=j['candidates']
    array('expected_moves',b''.join(bytes.fromhex(r['move']) for r in expected))
    array('expected_phases',[r['phase'] for r in expected],'int16_t')
    array('expected_modes',[r['mode'] for r in expected],'int16_t')
    rawarray('expected_ranking',bytes.fromhex(j['final']['ranking']['moves']))
    rawarray('opponent_rack',bytes.fromhex(j['opponent_rack']))
    for name,kind in [('tile_points','uint16_t'),('mask_generations','uint32_t'),('occurrence_masks','uint16_t')]:
        rawarray(name,bytes.fromhex(j['initial'][name]),kind)
    for name,kind in [('leave_values','uint16_t'),('canonical_masks','int16_t'),('mask_generations','uint32_t')]:
        rawarray('expected_'+name,bytes.fromhex(j['final'][name]),kind)
    array('expected_pattern_stamps',j['final_lookup_accumulators'],'uint32_t')
    assert j['lookup_entries'],'Replay requires an original prepared cache'
    declarations.append('static MavenPatternEntry entries[]={'+','.join('{pattern_strings+'+str(e['string_offset'])+','+str(e['accumulator'])+'u,'+str(e['table_index'])+'}' for e in j['lookup_entries'])+'};')
    source='''#include "heuristic_search.h"
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
static unsigned emitted;static int failed;
static void candidate(void *u,int phase,const uint8_t *move){MavenApplyState *app=u;int mode=move[32]?maven_count_new_move_tiles(move,app->placement.board):0;
 if(emitted>=sizeof expected_phases/sizeof expected_phases[0]||phase!=expected_phases[emitted]||mode!=expected_modes[emitted]||!check("candidate",move,expected_moves+34*emitted,34)){fprintf(stderr,"candidate index %u phase %d mode %d\\n",emitted,phase,mode);failed=1;}++emitted;}
int main(int argc,char **argv){MavenApplyState app={0};MavenRackBalanceCache balance={0};MavenMoveEvaluation state={0};MavenHeuristicSearch search={0};MavenLeaveTable leaves={0};MavenCandidateList ranking={0};MavenDictionarySection sections[17]={{0,0}};unsigned i;uint8_t *data;FILE *file;long size;
 if(argc!=2)return 2;file=fopen(argv[1],"rb");if(!file)return 2;fseek(file,0,SEEK_END);size=ftell(file);rewind(file);data=malloc((size_t)size);if(!data||fread(data,1,(size_t)size,file)!=(size_t)size)return 2;fclose(file);
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
    for i,section in enumerate(j['sections']):source+=f'sections[{i}]=(MavenDictionarySection){{data+{section["offset"]},{section["root"]}u}};\n'
    source+='leaves.alphabet=alphabet;leaves.vowel_characters=vowel_characters;leaves.distribution=distribution;leaves.letter_values=letter_values;leaves.letter_scores=letter_scores;leaves.q_with_unseen_u=q_with_unseen_u;leaves.q_without_held_u=q_without_held_u;leaves.held_u_query=held_u_query;leaves.patterns=entries;leaves.pattern_count=sizeof entries/sizeof entries[0];leaves.score_records=pattern_scores;leaves.balance=&balance;\n'
    source+='memcpy(leaves.tile_points,tile_points,sizeof tile_points);memcpy(leaves.mask_generations,mask_generations,sizeof mask_generations);memcpy(leaves.occurrence_masks,occurrence_masks,sizeof occurrence_masks);\n'
    source+=f'leaves.generation={j["initial"]["generation"]}u;ranking.cutoff_bits={j["initial"]["ranking"]["cutoff_bits"]}u;\n'
    source+='search.sections=sections;search.evaluation=&state;search.leaves=&leaves;search.result=&ranking;search.opponent_rack=opponent_rack;search.candidate=candidate;search.user=&app;\n'
    source+=f'search.leave_offset={j["leave_offset"]};search.word_deduplication={int(bool(j["extra_filter_pointer"]))};\n'
    source+='maven_search_heuristic_moves(&search);CHECK(diagnostics,0);CHECK(failed,0);CHECK(emitted,sizeof expected_phases/sizeof expected_phases[0]);\n'
    source+='if(!check("ranking",ranking.moves,expected_ranking,sizeof expected_ranking))return 1;\n'
    source+=f'CHECK(ranking.count,{j["final"]["ranking"]["count"]});CHECK(ranking.cutoff_bits,{j["final"]["ranking"]["cutoff_bits"]}u);\n'
    for name in ('board','values','counts','undo','rack'):
        source+=f'if(!check("{name}",{name},expected_{name},sizeof {name}))return 1;\n'
    source+='if(!check("balance_entries",balance.entries,expected_balance_entries,sizeof balance_entries))return 1;\n'
    for name in ('vowels','consonants'):source+=f'CHECK(balance.pool_{name},{j["final"]["balance_pool_"+name]});\n'
    for name in ('row_zero_count','new_tiles'):source+=f'CHECK(app.{name},{j["final"][name]});\n'
    for name in ('recorded_row','recorded_column'):
        for i,v in enumerate(j['final'][name]):source+=f'CHECK(app.{name}[{i}],{v});\n'
    for name,field in [('leave_values','values'),('canonical_masks','canonical_masks'),('mask_generations','mask_generations')]:source+=f'if(!check("{name}",leaves.{field},expected_{name},sizeof expected_{name}))return 1;\n'
    source+='for(i=0;i<sizeof expected_pattern_stamps/sizeof expected_pattern_stamps[0];++i)CHECK(entries[i].accumulator,expected_pattern_stamps[i]);free(data);return 0;}\n'
    build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'heuristic-search-probe.c';probe.write_text(source);exe=build/'heuristic-search-probe'
    sources=['move_evaluation','apply_move','board_state','move_finalize','score_move','score_accumulate','place_letters','rack_counts','remaining_tiles','undo_move','premium_exposure','rack_balance','rack_composition','pattern_match','pattern_lookup','letter_expectation']
    sources+=['heuristic_search','leave_table','adjusted_pattern_lookup','rack_masks','exchange_candidates','candidate_ranking','opening_moves','opening_placements','board_moves','board_placements','cross_check_letters','dictionary_lookup']
    subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(exe)],check=True)
    subprocess.run([str(exe),str(data_path)],check=True,timeout=30)
    print(json.dumps(dict(scope='Complete heuristic search: leave construction, exchange/pass, placement, scoring, candidate insertion and full collector reranking; every callback and final list/state',candidates=len(expected),ranked=j['final']['ranking']['count'],all_matched=True)))

if __name__=='__main__':main()
