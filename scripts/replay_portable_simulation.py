#!/usr/bin/env python3
"""Original simulation sessions from owned resources, position and external inputs."""
import argparse,json,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--mode',choices=['exhaustive','limit','cancel'],default='exhaustive');args=parser.parse_args()
def load(name):return json.loads((ROOT/f'analysis/toolchain/{name}.json').read_text())
def fixture(mode):
 captures=[load(f'session-publication-exhaustive-live-{i:02}') for i in range(1,6)] if mode=='exhaustive' else [load(f"session-publication-{'full-limit' if mode=='limit' else 'cancel'}-live")]
 assert all(c['complete'] for c in captures)
 j=captures[0];initial=dict(j['initial']);refills=[r for c in captures for r in c['refills']]
 if mode!='exhaustive':
  d=load(f"session-publication-{'draw' if mode=='limit' else 'cancel-draw'}-live");refills.insert(0,dict(private_seed=d['initial']['private_seed'],stack_ticks=d['initial']['stack_ticks'],events=d['events'],final=d['final']));initial['rack1']=j['session_saved']['rack1']
 seed=refills[0]['private_seed'];first=seed;external=[];starts=[]
 for refill in refills:
  assert refill['private_seed']==seed;starts.append(refill['stack_ticks'])
  for event in refill['events']:
   if event['kind']=='private_random':seed=(seed>>1)+((((seed>>4)^seed)&1)<<30);assert seed==event['value']
   else:external.extend([0 if event['kind']=='ticks' else 1,event['value']&0xffffffff])
  assert seed==refill['final']['private_seed']
 publications=[p for c in captures for p in c['publications']];config=bytes.fromhex(j['config'])
 return dict(mode=mode,initial=initial,first=first,seed=seed,external=external,starts=starts,publications=publications,moves=b''.join(config[24+46*i:58+46*i] for i in range(10)),entries=bytes.fromhex(captures[-1]['final_config'])[24:],events=sum(len(c['events']) for c in captures))
cases=[fixture(m) for m in (['exhaustive','cancel'] if args.mode=='cancel' else [args.mode])]
initial=cases[0]['initial'];b=bytes.fromhex(initial['board']);v=struct.unpack('>544H',bytes.fromhex(initial['values']));letters=bytes(b[r*17+c] for r in range(1,16) for c in range(1,16));blanks=bytes(int(bool(b[r*17+c]) and not v[r*17+c]) for r in range(1,16) for c in range(1,16))
def array(name,values,kind='uint8_t'):return 'static const '+kind+' '+name+'[]={'+','.join(str(v)+('u' if kind=='uint32_t' else '') for v in values)+'};\n'
source=r'''
#include "portable_engine.h"
#include "native_resources.h"
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"line %d: %s\n",__LINE__,#x);exit(1);}}while(0)
static void *allocate(void *u,size_t n){(void)u;return malloc(n);}static void release(void *u,void *p){(void)u;free(p);}
typedef struct {const uint32_t *events,*starts;const uint8_t *moves,*entries,*publications;unsigned nevents,nstarts,npubs,event_count,batches,weight,status,exhaustive,cancel_event;uint32_t first_seed,final_seed;} Case;
'''+array('letters',letters)+array('blanks',blanks)+array('own',bytes.fromhex(initial['rack0']))+array('other',bytes.fromhex(initial['rack1']))
for i,c in enumerate(cases):
 for key,data,kind in [('events',c['external'],'uint32_t'),('starts',c['starts'],'uint32_t'),('moves',c['moves'],'uint8_t'),('entries',c['entries'],'uint8_t'),('publications',b''.join(bytes.fromhex(p['moves']) for p in c['publications']),'uint8_t')]:source+=array(f'{key}{i}',data,kind)
source+='static const Case cases[]={'+','.join('{'+','.join([f'events{i}',f'starts{i}',f'moves{i}',f'entries{i}',f'publications{i}',*[str(x)+'u' for x in [len(c['external'])//2,len(c['starts']),len(c['publications']),c['events'],0 if c['mode']=='cancel' else 5 if c['mode']=='exhaustive' else 1,0 if c['mode']=='cancel' else 8 if c['mode']=='exhaustive' else 1,{'exhaustive':2,'limit':3,'cancel':4}[c['mode']],int(c['mode']=='exhaustive'),8 if c['mode']=='cancel' else 0,c['first'],c['seed']]]])+'}' for i,c in enumerate(cases))+'};\n'
source+=r'''
static const Case *test;static unsigned cursor,refill_cursor,publication_cursor,event_count;static int cancel_now,fail_input;
static int ticks(void *u,uint32_t *v){(void)u;if(fail_input)return 0;REQUIRE(cursor<test->nevents&&test->events[2*cursor]==0);*v=test->events[2*cursor++ +1];return 1;}
static int random_value(void *u,int16_t *v){(void)u;if(fail_input)return 0;REQUIRE(cursor<test->nevents&&test->events[2*cursor]==1);*v=(int16_t)test->events[2*cursor++ +1];return 1;}
static int begin(void *u,uint32_t *v){(void)u;if(fail_input)return 0;REQUIRE(refill_cursor<test->nstarts);*v=test->starts[refill_cursor++];return 1;}
static int cancel(void *u){(void)u;return cancel_now||(test->cancel_event&&event_count>=test->cancel_event);}
static void publish(void *u,const uint8_t *moves,unsigned n){(void)u;if(fail_input)return;REQUIRE(n==10&&publication_cursor<test->npubs);REQUIRE(event_count==publication_cursor*90);REQUIRE(!memcmp(moves,test->publications+340*publication_cursor,340));publication_cursor++;}
static void event(void *u,int kind,unsigned candidate,unsigned reply){(void)u;(void)kind;(void)candidate;(void)reply;event_count++;}
int main(int argc,char **argv){MavenTableResources r;MavenAllocator a={NULL,allocate,release};MavenPortableEngine *e;MavenBlob d;MavenPosition p={0},after;MavenCandidateList ranking;MavenSimulationOptions options={0};MavenSimulationResult result,sentinel;MavenHistoryRuntime runtime={{NULL,ticks,random_value,1,0},begin};FILE *f;long n;uint8_t *data;int used;uint32_t estimate;unsigned i;
 REQUIRE(argc==3&&load_resources(&r,argv[1]));f=fopen(argv[2],"rb");REQUIRE(f);REQUIRE(!fseek(f,0,SEEK_END));n=ftell(f);rewind(f);data=malloc((size_t)n);REQUIRE(data&&fread(data,1,(size_t)n,f)==(size_t)n);fclose(f);d=(MavenBlob){data,(size_t)n};REQUIRE(maven_portable_create(&r,d,&a,&e)==MAVEN_ENGINE_OK);free_resources(&r);free(data);
 memcpy(p.letters,letters,225);memcpy(p.blanks,blanks,225);memcpy(p.racks[0],own,8);memcpy(p.racks[1],other,8);p.row_zero_count=ROW_ZERO;REQUIRE(maven_portable_set_position(e,&p)==MAVEN_ENGINE_OK);
 REQUIRE(maven_portable_late(e,1,0,&ranking,&used,&estimate)==MAVEN_ENGINE_OK);REQUIRE(ranking.count==10);
 options.lookahead=1;options.sample_limit=1;options.cancel_requested=cancel;options.publish=publish;options.event=event;
 for(i=0;i<sizeof cases/sizeof cases[0];i++){
  test=cases+i;REQUIRE(!memcmp(ranking.moves,test->moves,340));options.exhaustive=(int)test->exhaustive;
  if(i)REQUIRE(runtime.random.private_seed==test->first_seed);else runtime.random.private_seed=test->first_seed;
  cursor=refill_cursor=publication_cursor=event_count=0;cancel_now=1;
  REQUIRE(maven_portable_simulate(e,&options,&runtime,&result)==MAVEN_ENGINE_CANCELLED);REQUIRE(!cursor&&!refill_cursor&&!publication_cursor&&runtime.random.private_seed==test->first_seed);REQUIRE(result.status==4&&!result.batches&&!result.publications);
  cancel_now=0;fail_input=1;memset(&result,0x5a,sizeof result);sentinel=result;
  REQUIRE(maven_portable_simulate(e,&options,&runtime,&result)==MAVEN_ENGINE_EXTERNAL);REQUIRE(!memcmp(&result,&sentinel,sizeof result)&&runtime.random.private_seed==test->first_seed);
  REQUIRE(maven_portable_get_position(e,&after)==MAVEN_ENGINE_OK&&!memcmp(&after,&p,sizeof p));
  fail_input=0;cursor=refill_cursor=publication_cursor=event_count=0;
  REQUIRE(maven_portable_simulate(e,&options,&runtime,&result)==(test->cancel_event?MAVEN_ENGINE_CANCELLED:MAVEN_ENGINE_OK));
  REQUIRE(cursor==test->nevents&&refill_cursor==test->nstarts&&publication_cursor==test->npubs&&event_count==test->event_count);REQUIRE(runtime.random.private_seed==test->final_seed);
  REQUIRE(result.count==10&&result.status==test->status&&result.batches==test->batches&&result.total_weight==test->weight&&result.publications==test->npubs);
  REQUIRE(!memcmp(result.entries,test->entries,460));REQUIRE(!memcmp(result.published,test->publications+(test->npubs-1)*340,340));
  REQUIRE(maven_portable_get_position(e,&after)==MAVEN_ENGINE_OK&&!memcmp(&after,&p,sizeof p));REQUIRE(!maven_portable_history_count(e));memcpy(ranking.moves,result.published,340);
 }
 maven_portable_destroy(e);return 0;}
'''.replace('ROW_ZERO',str(initial['row_zero_count']))
probe=ROOT/'.build/portable-simulation-probe.c';probe.write_text(source);exe=ROOT/'.build/portable-simulation-probe';names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'scripts'),'-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in names],'-o',str(exe)],check=True)
subprocess.run([str(exe),str(ROOT/'resources'),str(ROOT/'../../media/maven/session/share/maven2.1')],check=True,timeout=60)
print(json.dumps(dict(scope=__doc__,mode=args.mode,sessions=len(cases),external_events=sum(len(c['external'])//2 for c in cases),refills=sum(len(c['starts']) for c in cases),publications=sum(len(c['publications']) for c in cases),all_matched=True,pre_start_cancel=True,callback_failure_atomic=True)))
