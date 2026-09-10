#!/usr/bin/env python3
"""Controlled diagnosis only: captured state injection is not standalone acceptance."""
import argparse,gzip,json,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--flags',action='store_true');p.add_argument('--isolated',action='store_true');p.add_argument('--pool-state',action='store_true');p.add_argument('--values',action='store_true');p.add_argument('--sentinel',action='store_true');p.add_argument('--prime-at',action='store_true');p.add_argument('--omit-mask-transfer',action='store_true');p.add_argument('--capture',type=Path);p.add_argument('--log-prefix',default='burr');args=p.parse_args()
j=json.loads(gzip.decompress((args.capture or ROOT/'analysis/toolchain/late-search-live.json.gz').read_bytes()));initial=j['initial'];b=bytes.fromhex(initial['board']);v=struct.unpack('>544H',bytes.fromhex(initial['values']));position=bytearray(477)
for r in range(1,16):
 for c in range(1,16):
  i=(r-1)*15+c-1;k=r*17+c;position[i]=b[k];position[i+225]=bool(b[k]) and not v[k]
position[450:458]=bytes.fromhex(initial['rack']);position[458]=ord('e');position[474:476]=struct.pack('>H',initial['row_zero_count'])
def array(name,data):return 'static const uint8_t '+name+'[]={'+','.join(map(str,data))+'};\n'
s=(ROOT/'reconstruction/portable_engine.c').read_text();needle='  s->row_flags = g - 0x6d2;';assert s.count(needle)==1
s=s.replace('static uint16_t read16(', 'static void debug_checkpoint(void *,const char *,const MavenLateSearch *);\nstatic uint16_t read16(',1)
inject='s->checkpoint=debug_checkpoint;'
if args.sentinel:inject+='e->leaves.occurrence_masks[123][0]=65535;' 
if args.values:inject+=array('captured_values',bytes.fromhex(initial['values']))+'for(unsigned vi=0;vi<544;vi++)e->values[vi]=(uint16_t)(captured_values[2*vi]*256+captured_values[2*vi+1]);'
if args.flags:inject+=array('captured_flags',bytes.fromhex(initial['row_flags']))+'memcpy(e->tables.globals+MAVEN_GLOBAL_BYTES-0x6d2,captured_flags,32);'
if args.pool_state:
 ready=j['checkpoints'][0]['state'];inject+=array('captured_pool',bytes.fromhex(ready['pool_records']))+'memcpy(s->baseline.records,captured_pool,sizeof captured_pool);'
 for i,ptr in enumerate(struct.unpack('>16I',bytes.fromhex(ready['column_cache']))):
  off=ptr-ready['pool_base'];slot=off//66 if 0<=off<90*66 and off%66==0 else -1;inject+=f's->baseline.column_cache[{i}]={slot};'
s=s.replace(needle,needle+inject)
if args.isolated:s=re.sub(r'maven_search_late_game_shared\(s, e->tables.globals \+ MAVEN_GLOBAL_BYTES -\s*0x6f2\)', 'maven_search_late_game(s)',s)
s+=r'''
#include "native_resources.h"
static void dump(const char *name,const void *data,size_t n,unsigned width){size_t i;printf("\"%s\":\"",name);for(i=0;i<n;i++){if(width==1)printf("%02x",((const uint8_t*)data)[i]);else printf("%04x",((const uint16_t*)data)[i]);}printf("\",");}
static void debug_checkpoint(void *u,const char *phase,const MavenLateSearch *s){(void)u;
 printf("{\"stage\":\"%s\",",phase);dump("pool_records",s->baseline.records,90*66,1);dump("local_records",s->local.records,90*66,1);dump("ranking",s->ranking.moves,340,1);dump("leave",s->leaves->values,128,2);dump("tile_points",s->leaves->tile_points,128,2);dump("board",s->application->placement.board,544,1);dump("values",s->application->placement.values,544,2);dump("current_move",s->current_move,34,1);dump("row_flags",s->row_flags,32,1);dump("fallback",s->ranker.fallback_cache,32,2);dump("constraint_weights",s->constraints.weights,180,2);dump("letter_leave",s->baseline.letter_leave,128,2);printf("\"pool_count\":%u,\"local_count\":%u}\n",s->baseline.count,s->local.count);
}
static void *allocate(void *u,size_t n){(void)u;return malloc(n);}static void release(void *u,void *p){(void)u;free(p);}
int main(void){MavenPortableEngine *e;MavenTableResources resources;MavenAllocator a={NULL,allocate,release};MavenPosition p={0};MavenCandidateList out;int used;uint32_t estimate;FILE *f;long n;uint8_t *data;
POSITION
if(!load_resources(&resources,"resources"))return 1;f=fopen("../../media/maven/session/share/maven2.1","rb");if(!f)return 1;fseek(f,0,SEEK_END);n=ftell(f);rewind(f);data=malloc(n);if(fread(data,1,n,f)!=(size_t)n)return 1;fclose(f);
if(maven_portable_create(&resources,(MavenBlob){data,(size_t)n},&a,&e))return 1;memcpy(p.letters,position,225);memcpy(p.blanks,position+225,225);memcpy(p.racks,position+450,16);p.row_zero_count=(uint16_t)(position[474]*256+position[475]);if(maven_portable_set_position(e,&p)||maven_portable_late(e,1,0,&out,&used,&estimate))return 1;maven_portable_destroy(e);free_resources(&resources);free(data);return 0;}
'''.replace('POSITION',array('position',position))
if args.prime_at:
 s=s.replace('memcpy(p.letters,position,225);', '{MavenPosition at={0};at.letters[7*15+7]=97;at.letters[7*15+8]=116;memcpy(at.racks[0],"?abcdef",8);memcpy(at.racks[1],"ghijklm",8);if(maven_portable_set_position(e,&at)||maven_portable_heuristic(e,0,0,&out,NULL,NULL))return 1;}memcpy(p.letters,position,225);')
build=ROOT/'.build';probe=build/f'{args.log_prefix}-state-probe.c';exe=build/f'{args.log_prefix}-state-probe';probe.write_text(s)
names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text());names.remove('portable_engine')
units=[f'reconstruction/{n}.c' for n in names]
if args.omit_mask_transfer:
 late=(ROOT/'reconstruction/late_search.c').read_text();line='    memcpy(leaves->occurrence_masks, s->occurrence_masks, sizeof s->occurrence_masks);'
 assert late.count(line)==1;control=build/'burr-control-late.c';control.write_text(late.replace(line,''));units[units.index('reconstruction/late_search.c')]=str(control)
subprocess.run(['cc','-O1','-g','-fsanitize=address,undefined','-Ireconstruction','-Iscripts',str(probe),*units,'-o',str(exe)],cwd=ROOT,check=True)
r=subprocess.run([str(exe)],cwd=ROOT,text=True,capture_output=True,check=True,timeout=90)
label='-'.join(k for k,v in vars(args).items() if v and k not in ('capture','log_prefix')) or 'fresh';(build/f'{args.log_prefix}-state-{label}.jsonl').write_text(r.stdout);rows=[json.loads(l) for l in r.stdout.splitlines()]
expected=[c for c in j['checkpoints'] if not(c['kind']=='local_finished' and c['state']['registers'][3]==0)];assert len(rows)==len(expected)+1
for actual,expected in zip(rows,expected):
 assert actual['stage']==expected['kind'];diffs={}
 for k in ['ranking','pool_records','local_records','leave','tile_points','board','values','row_flags']:
  x=bytes.fromhex(actual[k]);y=bytes.fromhex(expected['state'][k]);indices=[i for i,(a,b) in enumerate(zip(x,y)) if a!=b and not(k.endswith('records') and (i%66<4 or 50<=i%66<54))]
  if indices:diffs[k]={'bytes':len(indices),'first':indices[:6]}
 print(actual['stage'],diffs)
a=bytes.fromhex(rows[-1]['ranking']);b=bytes.fromhex(j['final']['ranking']);print('FINAL',[(i,x,y) for i,(x,y) in enumerate(zip(a,b)) if x!=y]);print('log',build/f'{args.log_prefix}-state-{label}.jsonl')
