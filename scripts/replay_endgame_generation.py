#!/usr/bin/env python3
"""Replay the complete original CODE40 two-rack generation and table pipeline."""
import argparse,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/endgame-generation-live.json');a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete'];data_path=ROOT/'../../media/maven/session/share/maven2.1';assert hashlib.sha256(data_path.read_bytes()).hexdigest()==j['dictionary_sha256'];assert hashlib.sha256((ROOT/'resources/CODE/40_40.bin').read_bytes()).hexdigest()==j['code_sha256']
declarations=[]
def array(name,raw,kind='uint8_t'):
 if isinstance(raw,str):raw=bytes.fromhex(raw)
 if kind=='uint16_t':raw=struct.unpack('>'+str(len(raw)//2)+'H',raw)
 if kind=='uint32_t':raw=struct.unpack('>'+str(len(raw)//4)+'I',raw)
 declarations.append('static '+kind+' '+name+'[]={'+','.join(str(v)+('u' if kind=='uint32_t' else '') for v in raw)+'};')
for name in ['board','values','counts','undo','sorted_rack','canonical_masks','tile_points','occurrence_masks','best','second']:
 kind='uint16_t' if name in ['values','canonical_masks','tile_points','occurrence_masks'] else 'uint32_t' if name in ['best','second'] else 'uint8_t'
 array(name,j['initial'][name],kind);array('expected_'+name,j['final'][name],kind)
for name,raw in j['fixed'].items():array(name,raw,'uint16_t' if name=='letter_values' else 'uint32_t' if name=='bit_masks' else 'uint8_t')
for name,raw in j['initial']['tables'].items():array(name,raw,'uint16_t');array('expected_'+name,j['final']['tables'][name],'uint16_t')
array('own',j['own']);array('other',j['other']);array('expected_own_moves',j['own_moves']);array('expected_ranking',j['final']['ranking']['moves']);array('expected_conflicts',j['conflicts'],'uint32_t')
declarations.append('static const struct {int side,new_tiles;uint8_t move[34];} candidates[]={'+','.join('{'+str(c['side'])+','+str(c['new_tiles'])+',{'+','.join(map(str,bytes.fromhex(c['move'])))+'}}' for c in j['candidates'])+'};')
array('expected_summaries',b''.join(bytes.fromhex(s['raw'])[4:] for s in j['summaries']))
source=r'''#include "endgame_generation.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
'''+ '\n'.join(declarations)+r'''
static MavenEndgameGeneration state;static MavenApplyState app;static unsigned candidate_index;static int diagnostics,failed;
static void diagnostic(void *u){(void)u;++diagnostics;}
static int check(const char *name,const void *actual,const void *expected,size_t size){const uint8_t *a=actual,*b=expected;size_t i;for(i=0;i<size;++i)if(a[i]!=b[i]){fprintf(stderr,"%s byte %lu: %u != %u\n",name,(unsigned long)i,a[i],b[i]);return 0;}return 1;}
static void candidate(void *u,int side,const uint8_t move[34]){(void)u;if(candidate_index>=sizeof candidates/sizeof candidates[0]){failed=1;return;}if(side!=candidates[candidate_index].side||app.new_tiles!=candidates[candidate_index].new_tiles||!check("candidate",move,candidates[candidate_index].move,34)){fprintf(stderr,"candidate %u side %d\n",candidate_index,side);failed=1;}++candidate_index;}
#define CHECK(a,b) do{if((a)!=(b)){fprintf(stderr,"%s: %lld != %lld\n",#a,(long long)(a),(long long)(b));return 1;}}while(0)
int main(int argc,char **argv){uint8_t *data;uint8_t output[10][34];MavenDictionarySection sections[17]={{0,0}};FILE *file;long size;unsigned count,index=0;int16_t link;
if(argc!=2)return 2;file=fopen(argv[1],"rb");if(!file)return 2;fseek(file,0,SEEK_END);size=ftell(file);rewind(file);data=malloc((size_t)size);if(!data||fread(data,1,(size_t)size,file)!=(size_t)size)return 2;fclose(file);
app.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};app.letter_multipliers=letter_multipliers;app.letter_class=letter_class;app.alphabet=alphabet;
state.application=&app;state.sections=sections;state.bingo_bonus=50;state.bit_masks=bit_masks;state.candidate=candidate;
memcpy(state.sorted_rack,sorted_rack,8);memcpy(state.occurrence_masks,occurrence_masks,sizeof occurrence_masks);
'''
for name in ['row_zero_count','new_tiles']:source+=f'app.{name}={j["initial"][name]};\n'
for name,src in [('recorded_row','rows'),('recorded_column','columns')]:
 for i,value in enumerate(j['initial'][src]):source+=f'app.{name}[{i}]={value};\n'
source+=f'state.ranking.cutoff_bits={j["initial"]["ranking"]["cutoff"]}u;\n'
for i,section in enumerate(j['sections']):source+=f'sections[{i}]=(MavenDictionarySection){{data+{section["offset"]},{section["root"]}u}};\n'
for side,prefix in enumerate(['own','other']):
 for k,name in enumerate(['a','b','error']):source+=f'memcpy(state.tables[{side}][{k}],{prefix}_{name},sizeof {prefix}_{name});\n'
source+='count=maven_prepare_endgame_candidates(&state,own,other,output);CHECK(diagnostics,0);CHECK(failed,0);CHECK(candidate_index,sizeof candidates/sizeof candidates[0]);\n'
source+=f'CHECK(count,{j["result_count"]});CHECK(state.ranking.count,{j["final"]["ranking"]["count"]});CHECK(state.ranking.cutoff_bits,{j["final"]["ranking"]["cutoff"]}u);CHECK(state.mask_count,{j["final"]["mask_count"]});\n'
for actual,expected in [('output','expected_own_moves'),('state.ranking.moves','expected_ranking'),('state.conflicts','expected_conflicts')]+[(name,'expected_'+name) for name in ['board','values','counts','undo']]+[('state.'+name,'expected_'+name) for name in ['sorted_rack','canonical_masks','tile_points','occurrence_masks']]+[('state.cache.'+name,'expected_'+name) for name in ['best','second']]:source+=f'if(!check("{actual}",{actual},{expected},sizeof {expected}))return 1;\n'
for side,prefix in enumerate(['own','other']):
 for k,name in enumerate(['a','b','error']):source+=f'if(!check("{prefix}_{name}",state.tables[{side}][{k}],expected_{prefix}_{name},sizeof expected_{prefix}_{name}))return 1;\n'
for name in ['row_zero_count','new_tiles']:source+=f'CHECK(app.{name},{j["final"][name]});\n'
for name,src in [('recorded_row','rows'),('recorded_column','columns')]:
 for i,value in enumerate(j['final'][src]):source+=f'CHECK(app.{name}[{i}],{value});\n'
source+=r'''
for(link=state.cache.first;link>=0;link=state.cache.replies[link].next){MavenReplySummary *s=&state.cache.replies[link];uint8_t bytes[10]={(uint8_t)(s->score_bits>>24),(uint8_t)(s->score_bits>>16),(uint8_t)(s->score_bits>>8),(uint8_t)s->score_bits,s->emptied_rack,s->kept_mask,s->row,s->column,s->length,s->identifier};if(index*10>=sizeof expected_summaries||!check("reply summary",bytes,expected_summaries+10*index,10))return 1;++index;}
CHECK(index,sizeof expected_summaries/10);
(void)canonical_masks;(void)tile_points;(void)best;(void)second;free(data);return 0;}
'''
build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'endgame-generation-probe.c';probe.write_text(source);exe=build/'endgame-generation-probe'
sources=['board_state','endgame_generation','endgame_move_cache','endgame_rack_bounds','reply_bounds','board_moves','board_placements','rack_counts','rack_masks','candidate_ranking','score_move','score_accumulate','dictionary_lookup','cross_check_letters']
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{name}.c') for name in sources],'-o',str(exe)],check=True)
subprocess.run([str(exe),str(data_path)],check=True,timeout=30)
print(json.dumps(dict(scope=__doc__,candidates=len(j['candidates']),own_count=j['result_count'],reply_summaries=len(j['summaries']),all_records_tables_maps_and_state_match=True)))
