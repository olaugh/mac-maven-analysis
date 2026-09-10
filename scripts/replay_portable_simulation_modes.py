#!/usr/bin/env python3
"""Native/wasm owned selector integration with deterministic host inputs (not an original trace)."""
import json,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def position(name):
 j=json.loads((ROOT/f'analysis/toolchain/{name}.json').read_text());s=j['initial'];b=bytes.fromhex(s['board']);v=struct.unpack('>544H',bytes.fromhex(s['values']));p=bytearray(477)
 for r in range(1,16):
  for c in range(1,16):
   k=r*17+c;i=(r-1)*15+c-1;p[i]=b[k];p[i+225]=bool(b[k]) and not v[k]
 p[450:458]=bytes.fromhex(s['rack0']);p[458:466]=bytes.fromhex(j.get('session_saved',{}).get('rack1',s['rack1']));p[474:476]=struct.pack('>H',s['row_zero_count']);return p
positions=[position('session-publication-full-limit-live'),position('session-publication-exhaustive-live-01')]
source=r'''
#include "portable_engine.h"
#include "native_resources.h"
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"line %d: %s\n",__LINE__,#x);exit(1);}}while(0)
static void *allocate(void *u,size_t n){(void)u;return malloc(n);}static void release(void *u,void *p){(void)u;free(p);}
static uint8_t events[4096*8],starts[512*4],clocks[4096*4],output[820];
static unsigned nevents,nstarts,nclocks,event_count,late_calls,end_calls;static uint32_t tick,calibration;
static void put32(uint8_t *p,uint32_t n){p[0]=(uint8_t)(n>>24);p[1]=(uint8_t)(n>>16);p[2]=(uint8_t)(n>>8);p[3]=(uint8_t)n;}
static int ticks(void *u,uint32_t *v){(void)u;REQUIRE(nevents<4096);*v=++tick;put32(events+nevents*8,0);put32(events+nevents++*8+4,*v);return 1;}
static int random_value(void *u,int16_t *v){(void)u;REQUIRE(nevents<4096);*v=0;put32(events+nevents*8,1);put32(events+nevents++*8+4,0);return 1;}
static int begin(void *u,uint32_t *v){(void)u;REQUIRE(nstarts<512);*v=tick;put32(starts+nstarts++*4,*v);return 1;}
static int32_t elapsed(void *u){(void)u;REQUIRE(nclocks<4096);put32(clocks+nclocks++*4,0);return 0;}
static uint32_t calibrate(void *u){(void)u;late_calls++;return calibration;}
static void end_started(void *u){(void)u;end_calls++;}
static void event(void *u,int kind,unsigned candidate,unsigned reply){(void)u;(void)kind;(void)candidate;(void)reply;event_count++;}
static void hex(const uint8_t *p,size_t n){size_t i;putchar('"');for(i=0;i<n;i++)printf("%02x",p[i]);putchar('"');}
static const uint8_t positions[2][477]={POSITIONS};
int main(int argc,char **argv){MavenTableResources resources;MavenAllocator a={NULL,allocate,release};FILE *f;long length;uint8_t *dictionary;unsigned mode,repeat;
 REQUIRE(argc==3&&load_resources(&resources,argv[1]));f=fopen(argv[2],"rb");REQUIRE(f&&!fseek(f,0,SEEK_END));length=ftell(f);rewind(f);dictionary=malloc((size_t)length);REQUIRE(dictionary&&fread(dictionary,1,(size_t)length,f)==(size_t)length);fclose(f);
 for(mode=0;mode<4;mode++){
  MavenPortableEngine *e;MavenPosition p={0},after;MavenCandidateList ranking;MavenSimulationOptions options={0};MavenSimulationResult result;MavenHistoryRuntime runtime={{NULL,ticks,random_value,12345,0},begin};int used;uint32_t estimate;const uint8_t *bytes=positions[mode==2];
  REQUIRE(maven_portable_create(&resources,(MavenBlob){dictionary,(size_t)length},&a,&e)==MAVEN_ENGINE_OK);memcpy(p.letters,bytes,225);memcpy(p.blanks,bytes+225,225);memcpy(p.racks,bytes+450,16);p.row_zero_count=(uint16_t)(bytes[474]*256+bytes[475]);REQUIRE(maven_portable_set_position(e,&p)==MAVEN_ENGINE_OK);REQUIRE(maven_portable_late(e,1,0,&ranking,&used,&estimate)==MAVEN_ENGINE_OK);
  options.lookahead=1;options.sample_limit=1;options.late_enabled=mode!=2;options.endgame_enabled=mode>=2;options.endgame_budget_seconds=0;options.elapsed_seconds=elapsed;options.late_calibration=calibrate;options.endgame_started=end_started;options.event=event;calibration=mode==0?1:4923651;
  for(repeat=0;repeat<2;repeat++){
   uint32_t initial=runtime.random.private_seed;unsigned flags=(options.late_enabled?2:0)+(options.endgame_enabled?4:0);
   nevents=nstarts=nclocks=event_count=late_calls=end_calls=0;tick=0;
   REQUIRE(maven_portable_simulate(e,&options,&runtime,&result)==MAVEN_ENGINE_OK);REQUIRE(result.batches==1&&result.publications==1&&result.status==3);REQUIRE(maven_portable_get_position(e,&after)==MAVEN_ENGINE_OK&&!memcmp(&p,&after,sizeof p));REQUIRE(!maven_portable_history_count(e));
   if(options.late_enabled)REQUIRE(late_calls>0);if(mode==2)REQUIRE(end_calls>0&&nclocks>0);
   memcpy(output,result.entries,460);memcpy(output+460,result.published,340);put32(output+800,result.batches);put32(output+804,result.total_weight);put32(output+808,result.publications);put32(output+812,result.count);put32(output+816,result.status);
   printf("{\"mode\":%u,\"repeat\":%u,\"flags\":%u,\"calibration\":%u,\"initial_seed\":%u,\"final_seed\":%u,\"event_count\":%u,\"late_calls\":%u,\"endgame_calls\":%u,\"position\":",mode,repeat,flags,calibration,initial,runtime.random.private_seed,event_count,late_calls,end_calls);hex(bytes,477);printf(",\"events\":");hex(events,nevents*8);printf(",\"starts\":");hex(starts,nstarts*4);printf(",\"clocks\":");hex(clocks,nclocks*4);printf(",\"result\":");hex(output,sizeof output);printf("}\n");
  }
  maven_portable_destroy(e);
 }
 free(dictionary);free_resources(&resources);return 0;}
'''.replace('POSITIONS',','.join('{'+','.join(map(str,p))+'}' for p in positions))
probe=ROOT/'.build/portable-simulation-modes.c';probe.write_text(source);exe=ROOT/'.build/portable-simulation-modes';names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'scripts'),'-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in names],'-o',str(exe)],check=True)
r=subprocess.run([str(exe),str(ROOT/'resources'),str(ROOT/'../../media/maven/session/share/maven2.1')],check=True,text=True,capture_output=True,timeout=60)
rows=[json.loads(l) for l in r.stdout.splitlines()];data=ROOT/'.build/portable-simulation-modes.json';data.write_text(json.dumps(rows))
# Use the same owned wasm API, replaying only host inputs generated above.
prefix=(ROOT/'scripts/replay_wasm_game.mjs').read_text().split('const history=')[0]
js=prefix+'''
const rows=JSON.parse(fs.readFileSync('.build/portable-simulation-modes.json'));
for(const row of rows){
 if(!row.repeat){write(0,packet);write(1,dictionary);assert.equal(e.maven_port_create(packet.length,dictionary.length),0);write(2,Buffer.from(row.position,'hex'));assert.equal(e.maven_port_position(477),0);assert.equal(e.maven_port_late(1,0),0);}
 const events=Buffer.from(row.events,'hex'),starts=Buffer.from(row.starts,'hex'),clocks=Buffer.from(row.clocks,'hex');write(6,events);write(7,starts);write(5,clocks);
 write(10,Buffer.concat([row.initial_seed,1,row.flags,1,0,row.calibration,events.length/8,starts.length/4,clocks.length/4,0].map(be32)));
 if(row.mode===2&&!row.repeat){
  const config=read(10,40),failed=Buffer.from(config);failed.writeUInt32BE(0,32);write(10,failed);view(11).fill(0x5a);const unchanged=read(11,820),seed=e.maven_port_count(7);
  assert.equal(e.maven_port_simulate(),7,'exhausted host clock is an input error');assert.deepEqual(read(11,820),unchanged);assert.equal(e.maven_port_count(7),seed);assert.equal(e.maven_port_get_position(),0);assert.deepEqual(read(2,477),Buffer.from(row.position,'hex'));write(10,config);
 }
 assert.equal(e.maven_port_simulate(),0);assert.deepEqual(read(11,820),Buffer.from(row.result,'hex'));assert.equal(e.maven_port_count(7),row.final_seed);assert.equal(e.maven_port_count(8),events.length/8);assert.equal(e.maven_port_count(9),starts.length/4);assert.equal(e.maven_port_count(6),clocks.length/4);assert.equal(e.maven_port_count(14),row.event_count);assert.equal(e.maven_port_get_position(),0);assert.deepEqual(read(2,477),Buffer.from(row.position,'hex'));
}
console.log(JSON.stringify({scope:'Native/wasm owned simulation mode integration; deterministic host inputs, not original trace',sessions:rows.length,clock_failure_retry_restores_private_hash:true,late_gate_calls:rows.reduce((n,r)=>n+r.late_calls,0),endgame_calls:rows.reduce((n,r)=>n+r.endgame_calls,0),all_matched:true}));
'''
script=ROOT/'.build/replay-simulation-modes.mjs';script.write_text(js);subprocess.run(['node',str(script)],cwd=ROOT,check=True)
