#!/usr/bin/env python3
"""Replay late-search priorities, merge anchors, and physical-rack constraints."""
import gzip,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
j=json.loads(gzip.decompress((ROOT/'analysis/toolchain/late-search-live.json.gz').read_bytes()));assert j['complete'];leave=json.loads((ROOT/'analysis/toolchain/late-leave-table-live.json').read_text())
c={x['kind']:x['state'] for x in j['checkpoints'] if not x['kind'].startswith('local')};ready=c['pool_ready'];merged=c['constraints_ready'];decl=[]
def arr(name,v,kind='uint8_t'):
 if isinstance(v,str):v=bytes.fromhex(v)
 if isinstance(v,bytes) and kind!='uint8_t':v=struct.unpack('>'+str(len(v)//{'uint16_t':2,'uint32_t':4}[kind])+{'uint16_t':'H','uint32_t':'I'}[kind],v)
 decl.append('static '+kind+' '+name+'[]={'+','.join(str(x)+('u' if kind=='uint32_t' else '') for x in v)+'};')
def field(state,off,n):g=bytes.fromhex(state['globals']);return g[0x8da-off:0x8da-off+n]
for n,v,k in [('available',ready['counts'],'uint8_t'),('own',j['initial']['rack'],'uint8_t'),('alphabet',j['fixed']['alphabet'],'uint8_t'),('priority',j['priority_order'],'uint8_t'),('letter_values',j['fixed']['letter_values'],'uint16_t'),('board',j['initial']['board'],'uint8_t'),('initial_leaves',field(j['initial'],0x888,256),'uint16_t'),('expected_leaves',field(ready,0x888,256),'uint16_t'),('selected',c['merge_ready']['pool_records'],'uint8_t'),('expected_anchors',c['merge_ready']['anchor_masks'],'uint16_t'),('prepared',merged['pool_records'],'uint8_t'),('choose',bytes.fromhex(j['fixed']['tables'])[:272],'uint16_t'),('occurrences',ready['occurrences'],'uint16_t'),('expected_masks',merged['constraint_masks'],'uint16_t'),('expected_weights',merged['constraint_weights'],'uint16_t'),('pattern_strings',leave['pattern_strings'],'uint8_t'),('score_records',leave['pattern_scores'],'uint8_t')]:arr(n,v,k)
arr('held_u',leave['fixed']['held_u_query'].encode()+b'\0')
decl.append('static MavenPatternEntry entries[]={'+','.join('{pattern_strings+'+str(e['string_offset'])+','+str(e['accumulator'])+'u,'+str(e['table_index'])+'}' for e in leave['lookup_entries'])+'};')
source='''#include "late_setup.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
'''+ '\n'.join(decl)+r'''
#define CHECK(a,b) do{if((a)!=(b)){fprintf(stderr,"%s: %lld != %lld\n",#a,(long long)(a),(long long)(b));exit(1);}}while(0)
static void equal(const char *n,const void *a,const void *b,size_t z){size_t i;for(i=0;i<z;++i)if(((const uint8_t *)a)[i]!=((const uint8_t *)b)[i]){fprintf(stderr,"%s byte %lu: %u != %u\n",n,(unsigned long)i,((const uint8_t *)a)[i],((const uint8_t *)b)[i]);exit(1);}}
int main(void){MavenLatePool p={0};MavenPoolWeights pw={0};MavenLateConstraints constraints={0};uint16_t held,anchors[31],scratch[48];uint8_t distinct[28];unsigned i;
memcpy(p.available,available,128);memcpy(p.letter_values,letter_values,256);memcpy(p.letter_leave,initial_leaves,256);
'''
source+=f'p.unseen_count={int.from_bytes(field(ready,0x82e,2),"big")};\n'
source+='maven_prepare_late_priorities(&p,own,alphabet,priority,entries,sizeof entries/sizeof entries[0],score_records,held_u,&held);equal("letter leaves",p.letter_leave,expected_leaves,256);\n'
for name,off,n in [('aggregate_leave_bits',0x784,4),('per_tile_adjustment',0x71e,2)]:source+=f'CHECK(p.{name},{int.from_bytes(field(ready,off,n),"big",signed=name=="per_tile_adjustment")});\n'
for i,off in enumerate([0x828,0x82c,0x826,0x82a]):source+=f'CHECK(p.priority_letters[{i}],{int.from_bytes(field(ready,off,2),"big")});\n'
source+=f'CHECK(held,{int.from_bytes(field(ready,0x792,2),"big")});p.count=90;memcpy(p.records,selected,sizeof selected);CHECK(maven_late_merge_anchors(anchors,&p,board),1);equal("anchors",anchors,expected_anchors,62);\n'
source+='maven_prepare_pool_weights(&pw,available,alphabet,(uint16_t(*)[8])occurrences,distinct,scratch);\n'
source+='CHECK(maven_late_add_constraint(&constraints,(uint16_t)~((1u<<pw.total)-1),&pw,available,(uint16_t(*)[8])occurrences,(uint16_t(*)[8])choose),1);\n'
for index in [1,3,0,2]:source+=f'if(p.priority_letters[{index}])CHECK(maven_late_add_constraint(&constraints,(uint16_t)~(((1u<<pw.total)-1)&occurrences[p.priority_letters[{index}]*8]),&pw,available,(uint16_t(*)[8])occurrences,(uint16_t(*)[8])choose),1);\n'
source+='memcpy(p.records,prepared,sizeof prepared);for(i=0;i<p.count;++i)if((int8_t)p.records[i][48]>0)CHECK(maven_late_add_constraint(&constraints,(uint16_t)((uint16_t)p.records[i][54]<<8|p.records[i][55]),&pw,available,(uint16_t(*)[8])occurrences,(uint16_t(*)[8])choose),1);\n'
n=int.from_bytes(field(merged,0x80c,2),'big');source+=f'CHECK(constraints.count,{n});equal("masks",constraints.masks,expected_masks,{n*2});equal("weights",constraints.weights,expected_weights,{n*2});\n'
for i,row in enumerate(merged['lists']['baseline']):
 arr(f'list{i}',row['constraints'],'uint16_t');source+=f'{{uint16_t indices[182];CHECK(maven_late_constraint_indices(indices,&constraints,(uint16_t)((uint16_t)p.records[{i}][54]<<8|p.records[{i}][55])),{len(row["constraints"])});equal("constraint list {i}",indices,list{i},sizeof list{i});}}\n'
# Append the list declarations before the function, after initial declarations.
pos=source.index('#define CHECK');source=source[:pos]+'\n'.join(d for d in decl if d.startswith('static uint16_t list'))+'\n'+source[pos:]
source+='return 0;}\n';build=ROOT/'.build';probe=build/'late-setup-probe.c';probe.write_text(source);exe=build/'late-setup-probe';subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{x}.c') for x in ['late_setup','pool_weights','pattern_lookup']],'-o',str(exe)],check=True);subprocess.run([str(exe)],check=True,timeout=30);print(json.dumps(dict(scope=__doc__,constraints=n,reply_lists=90,all_matched=True)))
