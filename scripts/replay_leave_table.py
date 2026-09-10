#!/usr/bin/env python3
"""Replay original CODE32 heuristic leave preparation, including cache stamps."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess
ROOT=Path(__file__).resolve().parents[1]
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/leave-table-live.json');a=p.parse_args()
    j=json.loads(a.capture.read_text());assert j['complete'] and not j['exchange']
    assert hashlib.sha256((ROOT/'resources/CODE/32_32.bin').read_bytes()).hexdigest()==j['code_sha256']
    declarations=[]
    def array(name,values,kind='uint8_t'):
        declarations.append('static '+kind+' '+name+'[]={'+','.join(str(v)+('u' if kind=='uint32_t' else '') for v in values)+'};')
    def raw(name,h,kind='uint8_t'):
        b=bytes.fromhex(h);code={'uint16_t':'H','uint32_t':'I','int16_t':'h'}.get(kind)
        array(name,struct.unpack('>'+str(len(b)//struct.calcsize(code))+code,b) if code else b,kind)
    kinds={'values':'uint16_t','leave_values':'uint16_t','tile_points':'uint16_t','canonical_masks':'int16_t','occurrence_masks':'uint16_t','mask_generations':'uint32_t','balance_entries':'uint32_t'}
    fields=['board','values','counts','unseen_counts','leave_values','tile_points','canonical_masks','occurrence_masks','mask_generations','balance_entries']
    for name in fields:
        raw(name,j['initial'][name],kinds.get(name,'uint8_t'));raw('expected_'+name,j['final'][name],kinds.get(name,'uint8_t'))
    for name in ['letter_values','distribution','alphabet','q_with_unseen_u','q_without_held_u']:
        raw(name,j['fixed'][name],'uint16_t' if name in ['letter_values','q_with_unseen_u','q_without_held_u'] else 'uint8_t')
    for name in (['vowel_characters','held_u_query','search_q_query','search_blank_query'] if j.get('late') else ['vowel_characters','held_u_query']):
        array(name,j['fixed'][name].encode()+b'\0')
    for name in ['letter_scores','composition_scores']:
        declarations.append('static uint32_t '+name+'[][8]={'+','.join('{'+','.join(str(v)+'u' for v in row)+'}' for row in j['fixed'][name])+'};')
    for name in ['pattern_strings','pattern_scores']:raw(name,j[name])
    assert j['lookup_entries']
    declarations.append('static MavenPatternEntry entries[]={'+','.join('{pattern_strings+'+str(e['string_offset'])+','+str(e['accumulator'])+'u,'+str(e['table_index'])+'}' for e in j['lookup_entries'])+'};')
    array('expected_stamps',j['final_lookup_accumulators'],'uint32_t')
    source='''#include "leave_table.h"
#include "rack_composition.h"
#include "remaining_tiles.h"
#include "rack_counts.h"
#include <stdio.h>
#include <string.h>
static int diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
static int check(const char *name,const void *actual,const void *expected,size_t size){const unsigned char *a=actual,*e=expected;size_t i;for(i=0;i<size;++i)if(a[i]!=e[i]){fprintf(stderr,"%s byte %lu: %u != %u\\n",name,(unsigned long)i,a[i],e[i]);return 0;}return 1;}
#define CHECK(a,b) do{if((a)!=(b)){fprintf(stderr,"%s: %lld != %lld\\n",#a,(long long)(a),(long long)(b));return 1;}}while(0)
'''+ '\n'.join(declarations)+'''
static uint32_t composition(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t total){(void)u;return maven_rack_composition(v,c,pv,pc,total,composition_scores[total]);}
int main(void){MavenLeaveTable s={0};MavenRackBalanceCache b={0};uint8_t sorted[8];unsigned i;
 b.evaluate_composition=composition;b.diagnostic=diagnostic;memcpy(b.entries,balance_entries,sizeof balance_entries);
 s.alphabet=alphabet;s.vowel_characters=vowel_characters;s.unseen_counts=unseen_counts;s.distribution=distribution;s.letter_values=letter_values;s.letter_scores=letter_scores;s.q_with_unseen_u=q_with_unseen_u;s.q_without_held_u=q_without_held_u;s.held_u_query=held_u_query;s.patterns=entries;s.pattern_count=sizeof entries/sizeof entries[0];s.score_records=pattern_scores;s.balance=&b;
 maven_rack_from_counts(sorted,counts,alphabet);s.sorted_rack=sorted;
 maven_count_unseen_tiles(unseen_counts,distribution,board,values,counts,alphabet);
 memcpy(s.values,leave_values,sizeof leave_values);memcpy(s.canonical_masks,canonical_masks,sizeof canonical_masks);memcpy(s.tile_points,tile_points,sizeof tile_points);memcpy(s.occurrence_masks,occurrence_masks,sizeof occurrence_masks);memcpy(s.mask_generations,mask_generations,sizeof mask_generations);
'''
    source+=f's.generation={j["initial"]["generation"]}u;b.pool_vowels={j["initial"]["balance_pool_vowels"]};b.pool_consonants={j["initial"]["balance_pool_consonants"]};\n'
    source+=('maven_prepare_search_leave_table(&s,search_q_query,search_blank_query);' if j.get('late') else 'maven_prepare_leave_table(&s);')+'CHECK(diagnostics,0);\n'
    for name,field in [('leave_values','values'),('tile_points','tile_points'),('occurrence_masks','occurrence_masks'),('mask_generations','mask_generations'),('canonical_masks','canonical_masks')]:
        source+=f'if(!check("{name}",s.{field},expected_{name},sizeof expected_{name}))return 1;\n'
    for name in ['board','values','counts']:source+=f'if(!check("{name}",{name},expected_{name},sizeof {name}))return 1;\n'
    source+='if(!check("unseen_counts",unseen_counts,expected_unseen_counts,sizeof unseen_counts)||!check("balance_entries",b.entries,expected_balance_entries,sizeof balance_entries))return 1;\n'
    for name in ['generation','started_generation','mask_count']:source+=f'CHECK(s.{name},{j["final"][name]}u);\n'
    for name in ['vowels','consonants']:source+=f'CHECK(b.pool_{name},{j["final"]["balance_pool_"+name]});\n'
    source+='for(i=0;i<sizeof expected_stamps/sizeof expected_stamps[0];++i)CHECK(entries[i].accumulator,expected_stamps[i]);return 0;}\n'
    build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'leave-table-probe.c';probe.write_text(source);exe=build/'leave-table-probe'
    names=['leave_table','adjusted_pattern_lookup','pattern_lookup','rack_masks','letter_expectation','rack_balance','rack_composition','remaining_tiles','rack_counts']
    subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{n}.c') for n in names],'-o',str(exe)],check=True)
    subprocess.run([str(exe)],check=True,timeout=30)
    print(json.dumps(dict(scope='Full CODE32 '+('late-search' if j.get('late') else 'heuristic')+' leave-table preparation including all128 words, canonical masks, occurrence masks, cache stamps and balance state',canonical_masks=j['final']['mask_count'],all_matched=True)))
if __name__=='__main__':main()
