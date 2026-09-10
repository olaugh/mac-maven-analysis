#!/usr/bin/env python3
"""Replay complete CODE36+14d0 preparation with native pattern scoring and apply/undo."""
import argparse,gzip,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-preparation-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete'];assert hashlib.sha256((ROOT/'resources/CODE/36_36.bin').read_bytes()).hexdigest()==j['code_sha256']
decl=[]
def array(name,raw,kind='uint8_t'):
 if isinstance(raw,str):raw=bytes.fromhex(raw)
 if kind=='uint16_t':raw=struct.unpack('>'+str(len(raw)//2)+'H',raw)
 decl.append('static '+kind+' '+name+'[]={'+','.join(map(str,raw))+'};')
for name in ('board','values','counts','undo','pool_rack'):array(name,j['initial'][name],'uint16_t' if name=='values' else 'uint8_t');array('expected_'+name,j['final'][name],'uint16_t' if name=='values' else 'uint8_t')
for name,raw in j['fixed'].items():
 if name!='bingo_bonus':array(name,raw,'uint16_t' if name=='letter_values' else 'uint8_t')
array('initial_records',j['initial_records']);array('expected_records',j['final_records']);array('draw_multiplicity',j['draw_multiplicity'],'uint16_t');array('pattern_records',j['patterns']['raw_records']);array('score_records',j['patterns']['score_records'])
strings=j['patterns']['strings'];minimum=min(0,*map(int,strings));maximum=max(int(off)+len(text)+1 for off,text in strings.items());stringbytes=bytearray(maximum-minimum)
for off,text in strings.items():stringbytes[int(off)-minimum:int(off)-minimum+len(text)]=text.encode()
array('pattern_strings',bytes(stringbytes))
for i,step in enumerate(j['steps']):
 for name in ('board','values','counts','undo','pool_rack'):array(f'step{i}_{name}',step['state'][name],'uint16_t' if name=='values' else 'uint8_t')
source='''#include "late_preparation.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
'''+ '\n'.join(decl)+r'''
static MavenLatePool pool;static MavenApplyState app;static MavenLatePreparation preparation;static unsigned steps;static int diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
static void check(const char *name,const void *a,const void *b,size_t n){size_t i;for(i=0;i<n;++i)if(((const uint8_t *)a)[i]!=((const uint8_t *)b)[i]){fprintf(stderr,"%s byte %lu: %u != %u\n",name,(unsigned long)i,((const uint8_t *)a)[i],((const uint8_t *)b)[i]);exit(1);}}
#define CHECK(a,b) do{if((a)!=(b)){fprintf(stderr,"%s: %lld != %lld\n",#a,(long long)(a),(long long)(b));exit(1);}}while(0)
static void pattern(void *u,unsigned index,uint32_t value){(void)u;switch(steps){
'''
def scalars(raw):
 return {'new_tiles':int.from_bytes(bytes.fromhex(raw['new_tiles']),'big',signed=True),'row_zero_count':int.from_bytes(bytes.fromhex(raw['row_zero_count']),'big',signed=True),'recorded_row[0]':struct.unpack('>2h',bytes.fromhex(raw['recorded_rows']))[1],'recorded_row[1]':struct.unpack('>2h',bytes.fromhex(raw['recorded_rows']))[0],'recorded_column[0]':struct.unpack('>2h',bytes.fromhex(raw['recorded_columns']))[1],'recorded_column[1]':struct.unpack('>2h',bytes.fromhex(raw['recorded_columns']))[0]}
for i,step in enumerate(j['steps']):
 source+=f'case {i}:CHECK(index,{step["index"]});CHECK(value,{step["value"]}u);\n'
 for name in ('board','values','counts','undo','pool_rack'):source+=f'check("step{i} {name}",{name},step{i}_{name},sizeof step{i}_{name});\n'
 for name,v in scalars(step['state']).items():source+=f'CHECK(app.{name},{v});\n'
 source+='break;\n'
source+='default:exit(1);}++steps;}\nint main(void){\n'
source+='app.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};app.letter_multipliers=letter_multipliers;app.letter_class=letter_class;app.alphabet=alphabet;\n'
for name,v in scalars(j['initial']).items():source+=f'app.{name}={v};\n'
source+=f'pool.count={j["count"]};pool.per_tile_adjustment={j["per_tile_adjustment"]};memcpy(pool.records,initial_records,sizeof initial_records);preparation.pool=&pool;preparation.application=&app;preparation.pool_rack=pool_rack;preparation.bingo_bonus={j["fixed"]["bingo_bonus"]};preparation.serialized_record_base={j["pool_base"]}u;preparation.total_weight={j["total_weight"]};memcpy(preparation.draw_multiplicity,draw_multiplicity,sizeof draw_multiplicity);preparation.pattern_value=pattern;\n'
source+=f'preparation.patterns=(MavenPatternMatchInput){{pattern_records,pattern_strings+{-minimum},score_records,board,values,letter_values,counts,{j["patterns"]["record_count"]},diagnostic,0}};\n'
source+=f'maven_prepare_late_pool_replies(&preparation);CHECK(diagnostics,0);CHECK(steps,{len(j["steps"])});check("records",pool.records,expected_records,sizeof expected_records);\n'
for name in ('board','values','counts','undo','pool_rack'):source+=f'check("final {name}",{name},expected_{name},sizeof expected_{name});\n'
for name,v in scalars(j['final']).items():source+=f'CHECK(app.{name},{v});\n'
source+='return 0;}\n'
build=ROOT/'.build';probe=build/'late-preparation-probe.c';probe.write_text(source);exe=build/'late-preparation-probe';sources=['late_preparation','apply_move','place_letters','move_finalize','undo_move','board_state','rack_counts','score_move','score_accumulate','pattern_match'];subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(exe)],check=True);subprocess.run([str(exe)],check=True,timeout=30);print(json.dumps(dict(scope=__doc__,replies=j['count'],pattern_calls=len(j['steps']),all_records_pattern_values_and_application_state_match=True)))
