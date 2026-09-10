#!/usr/bin/env python3
"""Original continued-game file load/save/history-selection through the owned engine."""
import json,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
j=json.loads((ROOT/'analysis/toolchain/history-continued-end6-live.json').read_text());assert j['complete'];wire=bytes.fromhex(j['wire']);final=j['open_return'];refills=j['refills'];seed=refills[0]['private_seed'];initial_seed=seed;external=[];starts=[]
for refill in refills:
 assert refill['private_seed']==seed;starts.append(refill['stack_ticks'])
 for event in refill['events']:
  if event['kind']=='private_random':seed=(seed>>1)+((((seed>>4)^seed)&1)<<30);assert seed==event['value']
  else:external.append((0 if event['kind']=='ticks' else 1,event['value']))
 assert seed==refill['final']['private_seed']
def array(name,values,kind='uint8_t'):return 'static const '+kind+' '+name+'[]={'+','.join(str(v)+('u' if kind=='uint32_t' else '') for v in values)+'};\n'
def primary(s):
 b=bytes.fromhex(s['board']);v=struct.unpack('>544H',bytes.fromhex(s['values']));return bytes(b[r*17+c] for r in range(1,16) for c in range(1,16)),bytes(int(bool(b[r*17+c]) and not v[r*17+c]) for r in range(1,16) for c in range(1,16))
letters,blanks=primary(final)
source=r'''
#include "portable_engine.h"
#include "native_resources.h"
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"line %d: %s\n",__LINE__,#x);exit(1);}}while(0)
static int fail_alloc,fail_input;static unsigned allocations,releases;
static void *allocate(void *u,size_t n){(void)u;if(fail_alloc)return NULL;allocations++;return malloc(n);}static void release(void *u,void *p){(void)u;releases++;free(p);}
'''+array('wire',wire)+array('letters',letters)+array('blanks',blanks)+array('starts',starts,'uint32_t')+array('totals',final['totals'],'uint32_t')+r'''
static const uint32_t events[][2]={EVENTS};static unsigned cursor,refill_cursor;
static int ticks(void *u,uint32_t *v){(void)u;if(fail_input)return 0;REQUIRE(cursor<sizeof events/sizeof events[0]&&events[cursor][0]==0);*v=events[cursor++][1];return 1;}
static int random_value(void *u,int16_t *v){(void)u;if(fail_input)return 0;REQUIRE(cursor<sizeof events/sizeof events[0]&&events[cursor][0]==1);*v=(int16_t)events[cursor++][1];return 1;}
static int begin(void *u,uint32_t *v){(void)u;if(fail_input)return 0;REQUIRE(refill_cursor<sizeof starts/sizeof starts[0]);*v=starts[refill_cursor++];return 1;}
int main(int argc,char **argv){MavenTableResources r;MavenAllocator a={NULL,allocate,release};MavenPortableEngine *e;MavenBlob d;MavenPosition p,after;MavenHistoryRuntime runtime={{NULL,ticks,random_value,SEEDu,0},begin};FILE *f;long n;uint8_t *data,output[4096],broken[sizeof wire];size_t length;
 REQUIRE(argc==3&&load_resources(&r,argv[1]));f=fopen(argv[2],"rb");REQUIRE(f);REQUIRE(!fseek(f,0,SEEK_END));n=ftell(f);rewind(f);data=malloc((size_t)n);REQUIRE(data&&fread(data,1,(size_t)n,f)==(size_t)n);fclose(f);d=(MavenBlob){data,(size_t)n};REQUIRE(maven_portable_create(&r,d,&a,&e)==MAVEN_ENGINE_OK);free_resources(&r);free(data);
 fail_alloc=1;REQUIRE(maven_portable_load(e,wire,sizeof wire,&runtime)==MAVEN_ENGINE_ALLOCATION);fail_alloc=0;REQUIRE(maven_portable_get_position(e,&p)==MAVEN_ENGINE_NO_POSITION);
 fail_input=1;REQUIRE(maven_portable_load(e,wire,sizeof wire,&runtime)==MAVEN_ENGINE_EXTERNAL);fail_input=0;REQUIRE(runtime.random.private_seed==SEEDu&&maven_portable_history_count(e)==0);REQUIRE(maven_portable_get_position(e,&p)==MAVEN_ENGINE_NO_POSITION);
 REQUIRE(maven_portable_load(e,wire,sizeof wire,&runtime)==MAVEN_ENGINE_OK);
 REQUIRE(cursor==sizeof events/sizeof events[0]&&refill_cursor==sizeof starts/sizeof starts[0]);REQUIRE(runtime.random.private_seed==FINAL_SEEDu);
 REQUIRE(maven_portable_get_position(e,&p)==MAVEN_ENGINE_OK);REQUIRE(!memcmp(p.letters,letters,225)&&!memcmp(p.blanks,blanks,225));REQUIRE(!memcmp(p.score_bits,totals,sizeof totals));REQUIRE(!p.racks[0][0]&&!p.racks[1][0]&&p.side==2);
 REQUIRE(maven_portable_history_count(e)==33);REQUIRE(maven_portable_save(e,output,sizeof output,&length)==MAVEN_ENGINE_OK&&length==sizeof wire&&!memcmp(output,wire,length));
 memcpy(broken,wire,sizeof wire);broken[2]=0x7f;REQUIRE(maven_portable_load(e,broken,sizeof broken,&runtime)==MAVEN_ENGINE_INVALID);REQUIRE(maven_portable_get_position(e,&after)==MAVEN_ENGINE_OK&&!memcmp(&after,&p,sizeof p));REQUIRE(maven_portable_history_count(e)==33);
 /* Record26 is the first move following the retained branch snapshot24 and
  * marker25. Selecting it needs no refill and restores its recorded racks. */
 fail_input=1;REQUIRE(maven_portable_history_select(e,26,&runtime)==MAVEN_ENGINE_OK);fail_input=0;
 REQUIRE(maven_portable_get_position(e,&p)==MAVEN_ENGINE_OK&&p.side==0);REQUIRE(!strcmp((char *)p.racks[0],"bcinrsu"));REQUIRE(!strcmp((char *)p.racks[1],"eeirdna"));REQUIRE(maven_portable_history_count(e)==33);
 REQUIRE(maven_portable_save(e,output,sizeof output,&length)==MAVEN_ENGINE_OK);REQUIRE(maven_portable_history_count(e)==35);REQUIRE(!memcmp(output,wire,sizeof wire));
 maven_portable_destroy(e);REQUIRE(allocations==releases);return 0;}
'''.replace('EVENTS',','.join('{'+str(k)+','+str(v)+'u}' for k,v in external)).replace('FINAL_SEED',str(seed)).replace('SEED',str(initial_seed))
probe=ROOT/'.build/portable-history-probe.c';probe.write_text(source);exe=ROOT/'.build/portable-history-probe';names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'scripts'),'-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in names],'-o',str(exe)],check=True)
subprocess.run([str(exe),str(ROOT/'resources'),str(ROOT/'../../media/maven/session/share/maven2.1')],check=True,timeout=60)
print(json.dumps(dict(scope=__doc__,external_events=len(external),refills=len(refills),original_records=33,retained_branch_records=35,all_matched=True,allocation_and_callback_failures_atomic=True)))
