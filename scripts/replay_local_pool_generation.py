#!/usr/bin/env python3
"""Replay original CODE37 local-pool masks, apply/enumerate/undo and raw callbacks."""
import argparse,gzip,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-local-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete'];data_path=ROOT/'../../media/maven/session/share/maven2.1';assert hashlib.sha256(data_path.read_bytes()).hexdigest()==j['dictionary_sha256'];assert hashlib.sha256((ROOT/'resources/CODE/37_37.bin').read_bytes()).hexdigest()==j['code_sha256']
decl=[];checks=[]
def array(name,raw,kind='uint8_t'):
 if isinstance(raw,str):raw=bytes.fromhex(raw)
 if kind=='uint16_t':raw=struct.unpack('>'+str(len(raw)//2)+'H',raw)
 if kind=='uint32_t':raw=struct.unpack('>'+str(len(raw)//4)+'I',raw)
 decl.append('static '+kind+' '+name+'[]={'+','.join(str(v)+('u' if kind=='uint32_t' else '') for v in raw)+'};')
for name,raw in j['fixed'].items():
 if name in ('bingo_bonus','binomial'):continue
 array(name,raw,'uint16_t' if name=='letter_values' else 'uint32_t' if name=='bit_masks' else 'uint8_t')
fields=['board','values','counts','undo','sorted_rack','leave_values','row_flags']
for i,c in enumerate(j['calls']):
 prefix=f'c{i}_'
 for stage in ['initial','enumeration','final']:
  for name in fields:array(prefix+stage+'_'+name,c[stage][name],'uint16_t' if name in ['values','leave_values'] else 'uint8_t')
 for name in ['move','own','other','final_own','final_other']:array(prefix+name,c[name])
 array(prefix+'occurrences',c['initial']['occurrences'],'uint16_t')
 array(prefix+'row_masks',c['row_masks'],'uint16_t')
 decl.append('static const struct Candidate '+prefix+'candidates[]={'+','.join('{'+str(x['new_tiles'])+',{'+','.join(map(str,bytes.fromhex(x['move'])))+'}}' for x in c['candidates'])+'};')
source=r'''#include "local_replies.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct Candidate {int new_tiles;uint8_t move[34];};
'''+ '\n'.join(decl)+r'''
static MavenLocalReplies local;static MavenApplyState app;static unsigned candidate_index,candidate_count;static const struct Candidate *expected;static int diagnostics,failed,call_index;
static void diagnostic(void *u){(void)u;++diagnostics;}
static int check(const char *name,const void *actual,const void *expected_data,size_t size){const uint8_t *a=actual,*b=expected_data;size_t i;for(i=0;i<size;++i)if(a[i]!=b[i]){fprintf(stderr,"call %d %s byte %lu: %u != %u\n",call_index,name,(unsigned long)i,a[i],b[i]);return 0;}return 1;}
static void candidate(void *u,const uint8_t move[34]){(void)u;if(candidate_index>=candidate_count){failed=1;return;}if(app.new_tiles!=expected[candidate_index].new_tiles||!check("candidate",move,expected[candidate_index].move,34)){fprintf(stderr,"candidate %u\n",candidate_index);failed=1;}++candidate_index;}
#define CHECK(a,b) do{if((a)!=(b)){fprintf(stderr,"call %d %s: %lld != %lld\n",call_index,#a,(long long)(a),(long long)(b));exit(1);}}while(0)
static void ready(void *u){(void)u;
switch(call_index){
'''
for i,c in enumerate(j['calls']):
 prefix=f'c{i}_';source+=f'case {i}:\n'
 for name,actual in [('board','app.placement.board'),('values','app.placement.values'),('counts','app.placement.counts'),('undo','app.placement.undo')]:source+=f'if(!check("enumeration {name}",{actual},{prefix}enumeration_{name},sizeof {prefix}enumeration_{name}))exit(1);\n'
 source+=f'if(!check("row_masks",local.row_masks,{prefix}row_masks,sizeof {prefix}row_masks))exit(1);\n'
 # The original sorted rack is prepared inside +7b6, after this checkpoint.
 for name in ['row_zero_count','new_tiles']:source+=f'CHECK(app.{name},{c["enumeration"][name]});\n'
 source+='break;\n'
source+='}}\nint main(int argc,char **argv){uint8_t *data;MavenDictionarySection sections[17]={{0,0}};FILE *file;long size;\nif(argc!=2)return 2;file=fopen(argv[1],"rb");if(!file)return 2;fseek(file,0,SEEK_END);size=ftell(file);rewind(file);data=malloc((size_t)size);if(!data||fread(data,1,(size_t)size,file)!=(size_t)size)return 2;fclose(file);\n'
for i,sec in enumerate(j['sections']):source+=f'sections[{i}]=(MavenDictionarySection){{data+{sec["offset"]},{sec["root"]}u}};\n'
for i,c in enumerate(j['calls']):
 prefix=f'c{i}_';other_argument=prefix+('own' if c.get('same_rack',c['callback']==j['a5']+0x892) else 'other');source+=f'call_index={i};candidate_index=0;candidate_count={len(c["candidates"])};expected={prefix}candidates;\n'
 source+=f'app.placement=(MavenLetterPlacement){{{prefix}initial_board,{prefix}initial_values,{prefix}initial_counts,letter_values,word_multipliers,{prefix}initial_undo,diagnostic,0}};app.letter_multipliers=letter_multipliers;app.letter_class=letter_class;app.alphabet=alphabet;\nlocal.application=&app;local.sections=sections;local.bit_masks=bit_masks;local.leave_values={prefix}initial_leave_values;local.bingo_bonus={j["fixed"]["bingo_bonus"]}u;local.row_flags={prefix}initial_row_flags;local.ready=ready;local.candidate=candidate;\n'
 source+=f'memcpy(local.sorted_rack,{prefix}initial_sorted_rack,8);\n'
 for name in ['row_zero_count','new_tiles']:source+=f'app.{name}={c["initial"][name]};\n'
 for name,src in [('recorded_row','rows'),('recorded_column','columns')]:
  for k,v in enumerate(c['initial'][src]):source+=f'app.{name}[{k}]={v};\n'
 source+=f'maven_generate_local_pool_replies(&local,{prefix}move,{prefix}own,{other_argument},{prefix}initial_sorted_rack,(const uint16_t (*)[8]){prefix}occurrences);CHECK(diagnostics,0);CHECK(failed,0);CHECK(candidate_index,candidate_count);\n'
 for name in ['board','values','counts','undo','leave_values','row_flags']:source+=f'if(!check("final {name}",{prefix}initial_{name},{prefix}final_{name},sizeof {prefix}final_{name}))return 1;\n'
 for name in ['own','other']:source+=f'if(!check("final {name}",{prefix}{name},{prefix}final_{name},sizeof {prefix}final_{name}))return 1;\n'
 source+=f'if(!check("sorted rack",{prefix}initial_sorted_rack,{prefix}final_sorted_rack,17))return 1;\n'
 for name in ['row_zero_count','new_tiles']:source+=f'CHECK(app.{name},{c["final"][name]});\n'
 for name,src in [('recorded_row','rows'),('recorded_column','columns')]:
  for k,v in enumerate(c['final'][src]):source+=f'CHECK(app.{name}[{k}],{v});\n'
 source+=f'(void){prefix}enumeration_sorted_rack;(void){prefix}enumeration_leave_values;(void){prefix}enumeration_row_flags;\n'
source+='free(data);return 0;}\n'
build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'local-pool-generation-probe.c';probe.write_text(source);exe=build/'local-pool-generation-probe'
sources=['local_replies','board_state','apply_move','place_letters','move_finalize','undo_move','board_moves','board_placements','rack_counts','rack_masks','score_move','score_accumulate','dictionary_lookup','cross_check_letters']
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{name}.c') for name in sources],'-o',str(exe)],check=True)
subprocess.run([str(exe),str(data_path)],check=True,timeout=30)
print(json.dumps(dict(scope=__doc__,calls=len(j['calls']),candidates=sum(len(c['candidates']) for c in j['calls']),all_masks_records_and_state_match=True)))
