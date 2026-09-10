#!/usr/bin/env python3
"""Replay a complete original late-game search with all stages computed natively."""
import argparse,gzip,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-search-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete'];leave=json.loads((ROOT/'analysis/toolchain/late-leave-table-live.json').read_text());prep=json.loads(gzip.decompress((ROOT/'analysis/toolchain/late-preparation-live.json.gz').read_bytes()))
assert hashlib.sha256((ROOT/'resources/CODE/36_36.bin').read_bytes()).hexdigest()==j['identities']['36']
source_dict=ROOT/'../../media/maven/session/share/maven2.1';data=source_dict.read_bytes();assert hashlib.sha256(data).hexdigest()==j['dictionary_sha256']
decl=[]
def arr(name,v,kind='uint8_t'):
 if isinstance(v,str):v=bytes.fromhex(v)
 if isinstance(v,bytes) and kind!='uint8_t':
  code={'uint16_t':'H','uint32_t':'I','int16_t':'h'}[kind];v=struct.unpack('>'+str(len(v)//struct.calcsize(code))+code,v)
 decl.append('static '+kind+' '+name+'[]={'+','.join(str(x)+('u' if kind=='uint32_t' else '') for x in v)+'};')
def field(state,off,n):g=bytes.fromhex(state['globals']);return g[0x8da-off:0x8da-off+n]
for name in ('board','values','counts','undo','rack','leave','tile_points','occurrences','mask_generations','canonical_masks','balance_entries','row_flags'):
 arr(name,j['initial'][name],{'values':'uint16_t','leave':'uint16_t','tile_points':'uint16_t','occurrences':'uint16_t','mask_generations':'uint32_t','canonical_masks':'int16_t','balance_entries':'uint32_t'}.get(name,'uint8_t'))
for name in ('letter_values','word_multipliers','letter_multipliers','letter_class','bit_masks','alphabet'):arr(name,j['fixed'][name],{'letter_values':'uint16_t','bit_masks':'uint32_t'}.get(name,'uint8_t'))
arr('exchange_q_string',j['exchange_q_string']);arr('priority',j['priority_order']);arr('tables',j['fixed']['tables'],'uint16_t')
for name in ('distribution','q_with_unseen_u','q_without_held_u'):arr(name,leave['fixed'][name],'uint8_t' if name=='distribution' else 'uint16_t')
for name in ('vowel_characters','held_u_query','search_q_query','search_blank_query'):arr(name,leave['fixed'][name].encode()+b'\0')
for name in ('letter_scores','composition_scores'):decl.append('static uint32_t '+name+'[][8]={'+','.join('{'+','.join(str(v)+'u' for v in row)+'}' for row in leave['fixed'][name])+'};')
arr('pattern_strings',leave['pattern_strings']);arr('pattern_scores',leave['pattern_scores'])
stamps=j['initial']['lookup_stamps']
assert not stamps or len(stamps)==len(leave['lookup_entries'])
# A fresh startup lazily creates this cache during the search; its stamps
# start at zero. Older captures entered with a previously prepared cache.
decl.append('static MavenPatternEntry entries[]={'+','.join('{pattern_strings+'+str(e['string_offset'])+','+str(stamps[i] if stamps else 0)+'u,'+str(e['table_index'])+'}' for i,e in enumerate(leave['lookup_entries']))+'};')
arr('match_records',prep['patterns']['raw_records']);arr('match_scores',prep['patterns']['score_records']);strings=prep['patterns']['strings'];minimum=min(0,*map(int,strings));maximum=max(int(off)+len(text)+1 for off,text in strings.items());blob=bytearray(maximum-minimum)
for off,text in strings.items():blob[int(off)-minimum:int(off)-minimum+len(text)]=text.encode()
arr('match_strings',bytes(blob))
ready=j['checkpoints'][0]['state'];arr('initial_pool',ready['pool_records']);arr('initial_letter_leave',field(j['initial'],0x888,256),'uint16_t')
for i,c in enumerate(j['checkpoints']):
 if c['kind']=='local_finished' and c['state']['registers'][3]==0:continue
 s=c['state']
 for name in ('board','values','rack','ranking','pool_records','local_records','leave','tile_points','constraint_masks','constraint_weights','occurrences','undo'):
  arr(f'expected{i}_{name}',s[name],{'values':'uint16_t','leave':'uint16_t','tile_points':'uint16_t','constraint_masks':'uint16_t','constraint_weights':'uint16_t','occurrences':'uint16_t'}.get(name,'uint8_t'))
for name in ('board','values','rack','ranking'):arr('final_'+name,j['final'][name],'uint16_t' if name=='values' else 'uint8_t')
source='''#include "late_search.h"
#include "rack_composition.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
'''+ '\n'.join(decl)+r'''
static MavenLateSearch search;static MavenApplyState app;static MavenLeaveTable leaves;static MavenRackBalanceCache balance;static MavenDictionarySection sections[17];static unsigned checkpoint_index;static int diagnostics;
#define CHECK(a,b) do{if((a)!=(b)){fprintf(stderr,"%s: %lld != %lld\n",#a,(long long)(a),(long long)(b));exit(1);}}while(0)
static void equal(const char *n,const void *a,const void *b,size_t z){size_t i;for(i=0;i<z;++i)if(((const uint8_t *)a)[i]!=((const uint8_t *)b)[i]){fprintf(stderr,"%s byte %lu: %u != %u\n",n,(unsigned long)i,((const uint8_t *)a)[i],((const uint8_t *)b)[i]);exit(1);}}
static void records(const char *name,const uint8_t *actual,const uint8_t *expected,unsigned count,int defined_only){unsigned i,k;for(i=0;i<count;++i)for(k=0;k<66;++k){if(k<4||(k>=50&&k<54))continue;if(defined_only&&!((k>=4&&k<8)||(k>=14&&k<50)||(k>=58&&k<65)))continue;if(actual[i*66+k]!=expected[i*66+k]){fprintf(stderr,"%s record %u byte %u: %u != %u\n",name,i,k,actual[i*66+k],expected[i*66+k]);exit(1);}}}
static void diagnostic(void *u){(void)u;++diagnostics;}
static uint32_t composition(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t total){(void)u;return maven_rack_composition(v,c,pv,pc,total,composition_scores[total]);}
static void checkpoint(void *u,const char *name,const MavenLateSearch *s){(void)u;printf("Stage %u %s\n",checkpoint_index,name);fflush(stdout);switch(checkpoint_index++){
'''
seq=0
for i,c in enumerate(j['checkpoints']):
 if c['kind']=='local_finished' and c['state']['registers'][3]==0:continue
 s=c['state'];kind=c['kind'];source+=f'case {seq}:CHECK(strcmp(name,"{kind}"),0);\n';seq+=1
 for name in ('board','values','rack'):source+=f'equal("{kind} {name}",{name},expected{i}_{name},sizeof {name});\n'
 if kind in ('pool_selected','merge_ready','pool_merged','pool_prepared','constraints_ready','leaves_ready'):
  source+=f'CHECK(s->baseline.count,{s["ranking_count"]});records("{kind}",(const uint8_t*)s->baseline.records,expected{i}_pool_records,s->baseline.count,{int(kind in ("pool_selected","merge_ready"))});\n'
 if kind in ('leaves_ready','pass_ranked','own_ranked','local_finished'):
  source+=f'equal("leaves",s->leaves->values,expected{i}_leave,256);equal("tile points",s->leaves->tile_points,expected{i}_tile_points,256);\n'
 if kind in ('pass_ranked','own_ranked','local_begin','local_finished'):
  source+=f'CHECK(s->ranking.count,{s["ranking_count"]});equal("{kind} ranking",s->ranking.moves,expected{i}_ranking,340);\n'
 if kind=='local_finished':source+=f'records("{kind} local",(const uint8_t*)s->local.records,expected{i}_local_records,90,0);\n'
 if kind=='constraints_ready':
  n=int.from_bytes(field(s,0x80c,2),'big');source+=f'CHECK(s->constraints.count,{n});equal("constraint masks",s->constraints.masks,expected{i}_constraint_masks,{2*n});equal("constraint weights",s->constraints.weights,expected{i}_constraint_weights,{2*n});\n'
 source+='break;\n'
source+=f'case {seq}:CHECK(strcmp(name,"complete"),0);break;default:exit(1);}}}}\n'
source+='int main(void){FILE *f;unsigned char *dictionary;long size;unsigned i;\n'
source+=f'f=fopen({json.dumps(str(source_dict))},"rb");CHECK(f!=NULL,1);fseek(f,0,SEEK_END);size=ftell(f);rewind(f);dictionary=malloc((size_t)size);CHECK(fread(dictionary,1,(size_t)size,f),(size_t)size);fclose(f);\n'
for i,section in enumerate(j['sections']):source+=f'sections[{i}]=(MavenDictionarySection){{dictionary+{section["offset"]},{section["root"]}u}};\n'
source+='app.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};app.letter_multipliers=letter_multipliers;app.letter_class=letter_class;app.alphabet=alphabet;\n'
for name in ('new_tiles','row_zero_count'):source+=f'app.{name}={j["initial"][name]};\n'
for name in ('recorded_row','recorded_column'):
 for i,v in enumerate(j['initial'][name]):source+=f'app.{name}[{i}]={v};\n'
source+='balance.evaluate_composition=composition;balance.diagnostic=diagnostic;memcpy(balance.entries,balance_entries,sizeof balance_entries);\n'
source+=f'balance.pool_vowels={j["initial"]["balance_pool_vowels"]};balance.pool_consonants={j["initial"]["balance_pool_consonants"]};leaves.generation={j["initial"]["generation"]}u;leaves.started_generation={j["initial"]["started_generation"]}u;\n'
source+='leaves.alphabet=alphabet;leaves.vowel_characters=vowel_characters;leaves.distribution=distribution;leaves.letter_values=letter_values;leaves.letter_scores=letter_scores;leaves.q_with_unseen_u=q_with_unseen_u;leaves.q_without_held_u=q_without_held_u;leaves.held_u_query=held_u_query;leaves.patterns=entries;leaves.pattern_count=sizeof entries/sizeof entries[0];leaves.score_records=pattern_scores;leaves.balance=&balance;memcpy(leaves.values,leave,256);memcpy(leaves.tile_points,tile_points,256);memcpy(leaves.canonical_masks,canonical_masks,256);memcpy(leaves.mask_generations,mask_generations,512);memcpy(leaves.occurrence_masks,occurrences,2048);\n'
source+=f'search.leave_offset={j["initial"].get("leave_offset",0)};search.exchange_q_string=exchange_q_string;\n'
source+='search.application=&app;search.leaves=&leaves;search.sections=sections;search.bit_masks=bit_masks;search.choose=(const uint16_t(*)[8])tables;search.priority_order=priority;search.q_query=search_q_query;search.blank_query=search_blank_query;search.row_flags=row_flags;search.bingo_bonus=5000;search.own_rack=rack;search.force=1;search.checkpoint=checkpoint;memcpy(search.baseline.records,initial_pool,sizeof initial_pool);memcpy(search.baseline.letter_leave,initial_letter_leave,256);memcpy(search.occurrence_masks,occurrences,2048);\n'
source+=f'search.baseline_token={ready["pool_base"]}u;search.local_token={ready["local_base"]}u;search.value.main_triple={j["initial"]["main_triple"]};\n'
for i,pointer in enumerate(struct.unpack('>16I',bytes.fromhex(ready['column_cache']))):
 off=pointer-ready['pool_base'];slot=off//66 if off>=0 and off%66==0 and off<90*66 else -1;source+=f'search.baseline.column_cache[{i}]={slot};\n'
source+=f'search.patterns=(MavenPatternMatchInput){{match_records,match_strings+{-minimum},match_scores,board,values,letter_values,counts,{prep["patterns"]["record_count"]},diagnostic,0}};\n'
for name,off,n in [('normal_bag',0x6114,10),('held_q_bag',0x6100,10),('reply_q_bag',0x60ec,10),('normal_empty_bag',0x6394,64),('held_q_no_u',0x6314,64),('held_q_with_u',0x6214,64),('blank_adjustment',0x6494,64),('opponent_held_q',0x6294,64)]:source+=f'memcpy(search.value.{name},tables+{(0x65a8-off)//2},{2*n});\n'
source+='search.value.normal_before_matrix=tables[(0x65a8-0x6316)/2];search.value.with_u_before_matrix=tables[(0x65a8-0x6216)/2];\n'
source+=f'CHECK(maven_search_late_game(&search),1);CHECK(diagnostics,0);CHECK(checkpoint_index,{seq+1});CHECK(search.ranking.count,{j["final"]["ranking_count"]});\n'
for name in ('board','values','rack'):source+=f'equal("final {name}",{name},final_{name},sizeof {name});\n'
source+='equal("final ranking",search.ranking.moves,final_ranking,340);for(i=0;i<search.ranking.count;++i)printf("%u %s\\n",i+1,search.ranking.moves[i]);free(dictionary);return 0;}\n'
build=ROOT/'.build';probe=build/'late-search-probe.c';probe.write_text(source);exe=build/'late-search-probe';names=['exchange_candidates','cross_check_letters','late_search','late_setup','late_preparation','late_pool_select','late_ranking','late_reply_value','pool_weights','leave_table','adjusted_pattern_lookup','pattern_lookup','letter_expectation','rack_balance','rack_composition','local_replies','board_moves','board_placements','dictionary_lookup','score_move','score_accumulate','rack_masks','apply_move','place_letters','move_finalize','undo_move','board_state','rack_counts','remaining_tiles','pattern_match','reply_bounds','candidate_ranking','endgame_move_cache'];subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-Wno-unused-variable','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{n}.c') for n in names],'-o',str(exe)],check=True);subprocess.run([str(exe)],check=True,timeout=180);print(json.dumps(dict(scope=__doc__,checkpoints=seq+1,final_moves=j['final']['ranking_count'],all_matched=True)))
