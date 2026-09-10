#!/usr/bin/env python3
"""Owned resource-initialized search/commit/refill/save versus a newly played original BURIN turn."""
import json,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
j=json.loads((ROOT/'analysis/toolchain/turn-commit-burin-fresh-live.json').read_text());assert j['complete'];before=j['turn']['initial'];after=j['turn']['final'];refill=j['turn']['refills'][0]
def position(s):
 b=bytes.fromhex(s['board']);v=struct.unpack('>544H',bytes.fromhex(s['values']));p=bytearray(477)
 for row in range(1,16):
  for col in range(1,16):
   k=row*17+col;i=(row-1)*15+col-1;p[i]=b[k];p[i+225]=bool(b[k]) and not v[k]
 p[450:458]=bytes.fromhex(s['rack0']);p[458:466]=bytes.fromhex(s['rack1']);p[466:474]=struct.pack('>II',*s['totals']);p[474:476]=struct.pack('>H',s['row_zero_count']);p[476]=s['selected_side'];return p
# API computes private draws; external callbacks validate their intervening
# expected seed progression and consume only Toolbox/tick events.
events=refill['events'];seed=refill['private_seed'];external=[]
for event in events:
 if event['kind']=='private_random':
  seed=(seed>>1)+((((seed>>4)^seed)&1)<<30);assert seed==event['value']
 else:external.append((0 if event['kind']=='ticks' else 1,event['value']))
def array(name,values,kind='uint8_t'):
 return 'static const '+kind+' '+name+'[]={'+','.join(str(v)+('u' if kind=='uint32_t' else '') for v in values)+'};\n'
source=r'''
#include "portable_engine.h"
#include "history_records.h"
#include "native_resources.h"
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"line %d: %s\n",__LINE__,#x);exit(1);}}while(0)
static void *allocate(void *u,size_t n){(void)u;return malloc(n);}static void release(void *u,void *p){(void)u;free(p);}
'''+array('before_bytes',position(before))+array('after_bytes',position(after))+array('expected_move',bytes.fromhex(j['move']))+array('features',after['features'],'uint32_t')+r'''
static const uint32_t events[][2]={EVENTS};static unsigned cursor;static int fail;
static int ticks(void *u,uint32_t *v){(void)u;if(fail)return 0;REQUIRE(cursor<sizeof events/sizeof events[0]);REQUIRE(events[cursor][0]==0);*v=events[cursor++][1];return 1;}
static int random_value(void *u,int16_t *v){(void)u;if(fail)return 0;REQUIRE(cursor<sizeof events/sizeof events[0]);REQUIRE(events[cursor][0]==1);*v=(int16_t)events[cursor++][1];return 1;}
static void decode(MavenPosition *p,const uint8_t *b){memset(p,0,sizeof *p);memcpy(p->letters,b,225);memcpy(p->blanks,b+225,225);memcpy(p->racks,b+450,16);for(unsigned i=0;i<2;i++)p->score_bits[i]=(uint32_t)b[466+4*i]<<24|(uint32_t)b[467+4*i]<<16|(uint32_t)b[468+4*i]<<8|b[469+4*i];p->row_zero_count=(uint16_t)((unsigned)b[474]*256+b[475]);p->side=b[476];}
int main(int argc,char **argv){MavenTableResources r;MavenAllocator a={NULL,allocate,release};MavenPortableEngine *e;MavenBlob d;MavenPosition p,expected,actual;MavenCandidateList ranking;MavenGameResult result,unchanged;MavenGameRuntime runtime={NULL,ticks,random_value,SEEDu,STACKu};FILE *f;long n;uint8_t *data,wire[4096],previous_wire[4096];size_t length,previous_length,count;MavenHistoryRecord records[16];unsigned index;int used;uint32_t estimate;
 REQUIRE(argc==3&&load_resources(&r,argv[1]));f=fopen(argv[2],"rb");REQUIRE(f);REQUIRE(!fseek(f,0,SEEK_END));n=ftell(f);rewind(f);data=malloc((size_t)n);REQUIRE(data&&fread(data,1,(size_t)n,f)==(size_t)n);fclose(f);d=(MavenBlob){data,(size_t)n};REQUIRE(maven_portable_create(&r,d,&a,&e)==MAVEN_ENGINE_OK);free_resources(&r);free(data);
 decode(&p,before_bytes);decode(&expected,after_bytes);REQUIRE(maven_portable_set_position(e,&p)==MAVEN_ENGINE_OK);
 REQUIRE(maven_portable_late(e,1,0,&ranking,&used,&estimate)==MAVEN_ENGINE_OK);
 for(index=0;index<ranking.count;index++)if(!strcmp((const char *)ranking.moves[index],"burin")&&ranking.moves[index][32]==17&&ranking.moves[index][33]==2)break;
 REQUIRE(index<ranking.count);REQUIRE(maven_portable_save(e,previous_wire,sizeof previous_wire,&previous_length)==MAVEN_ENGINE_OK);
 memset(&result,0x5a,sizeof result);unchanged=result;fail=1;
 REQUIRE(maven_portable_play_ranked(e,index,&runtime,&result)==MAVEN_ENGINE_EXTERNAL);REQUIRE(!memcmp(&result,&unchanged,sizeof result));REQUIRE(runtime.private_seed==SEEDu);
 REQUIRE(maven_portable_get_position(e,&actual)==MAVEN_ENGINE_OK&&!memcmp(&actual,&p,sizeof p));
 REQUIRE(maven_portable_save(e,wire,sizeof wire,&length)==MAVEN_ENGINE_OK&&length==previous_length&&!memcmp(wire,previous_wire,length));
 fail=0;cursor=0;REQUIRE(maven_portable_play_ranked(e,index,&runtime,&result)==MAVEN_ENGINE_OK);
 REQUIRE(cursor==sizeof events/sizeof events[0]);REQUIRE(runtime.private_seed==FINAL_SEEDu);
 REQUIRE(maven_portable_get_position(e,&actual)==MAVEN_ENGINE_OK);REQUIRE(!memcmp(&actual,&expected,sizeof actual));
 REQUIRE(!memcmp(result.move,expected_move,34));REQUIRE(!memcmp(result.features,features,sizeof features));REQUIRE(!memcmp(result.statistics[0],features,sizeof features));REQUIRE(result.evaluation_bits==EVALUATIONu);REQUIRE(result.phase==2&&result.selected_side==1&&result.history_records==3);
 REQUIRE(maven_portable_play_ranked(e,index,&runtime,&result)==MAVEN_ENGINE_INVALID);
 memset(wire,0x5a,sizeof wire);REQUIRE(maven_portable_save(e,wire,1,&length)==MAVEN_ENGINE_CAPACITY);REQUIRE(wire[0]==0x5a);
 REQUIRE(maven_portable_save(e,wire,sizeof wire,&length)==MAVEN_ENGINE_OK);REQUIRE(maven_decode_history_records(wire,length,records,16,&count)==MAVEN_HISTORY_OK&&count==3&&records[2].tag==2);REQUIRE(!memcmp(records[2].payload,expected_move,34));
 maven_portable_destroy(e);return 0;}
'''.replace('EVENTS',','.join('{'+str(k)+','+str(v)+'u}' for k,v in external)).replace('FINAL_SEED',str(refill['final']['private_seed'])).replace('SEED',str(refill['private_seed'])).replace('STACK',str(refill['stack_ticks'])).replace('EVALUATION',str(j['result_bits']))
probe=ROOT/'.build/portable-game-probe.c';probe.write_text(source);exe=ROOT/'.build/portable-game-probe';names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'scripts'),'-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in names],'-o',str(exe)],check=True)
subprocess.run([str(exe),str(ROOT/'resources'),str(ROOT/'../../media/maven/session/share/maven2.1')],check=True,timeout=60)
print(json.dumps(dict(scope=__doc__,external_events=len(external),all_matched=True,failed_callback_atomic=True,computed_display=True)))
