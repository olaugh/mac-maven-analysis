#!/usr/bin/env python3
"""Fresh original late-game ranking through the owned native resource initializer."""
import argparse,gzip,json,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-search-fresh-start-live.json.gz');p.add_argument('--prime-at',action='store_true');a=p.parse_args()
 j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete']
 board=bytes.fromhex(j['initial']['board']);values=struct.unpack('>544H',bytes.fromhex(j['initial']['values']));position=bytearray(477)
 alphabet=b'?abcdefghijklmnopqrstuvwxyz';remaining=[2,9,2,2,4,12,2,3,2,9,1,1,4,2,6,8,2,1,6,4,6,4,2,2,1,2,1]
 for row in range(1,16):
  for col in range(1,16):
   i=(row-1)*15+col-1;k=row*17+col;c=board[k];position[i]=c;position[i+225]=bool(c) and not values[k]
   if c:remaining[alphabet.index(ord('?') if position[i+225] else c)]-=1
 position[450:458]=bytes.fromhex(j['initial']['rack'])
 for c in position[450:458]:
  if c:remaining[alphabet.index(c)]-=1
 # The late algorithm uses only unseen inventory, not the hidden opponent rack.
 position[458]=next(c for c,n in zip(alphabet,remaining) if n>0)
 position[474:476]=struct.pack('>H',j['initial']['row_zero_count'])
 def array(name,data):return 'static const uint8_t '+name+'[]={'+','.join(map(str,data))+'};\n'
 source=r'''
#include "portable_engine.h"
#include "native_resources.h"
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"line %d: %s\n",__LINE__,#x);exit(1);}}while(0)
static void *allocate(void *u,size_t n){(void)u;return malloc(n);}static void release(void *u,void *p){(void)u;free(p);}
'''+array('bytes',position)+array('expected',bytes.fromhex(j['final']['ranking']))+r'''
int main(int argc,char **argv){MavenTableResources r;MavenAllocator a={NULL,allocate,release};MavenPortableEngine *e;MavenBlob d;MavenPosition p={0},after;
 MavenCandidateList out,heuristic;int used;uint32_t estimate;FILE *f;long n;uint8_t *data;unsigned i;
 REQUIRE(argc==3);REQUIRE(load_resources(&r,argv[1]));f=fopen(argv[2],"rb");REQUIRE(f);REQUIRE(!fseek(f,0,SEEK_END));n=ftell(f);REQUIRE(n>0);rewind(f);data=malloc((size_t)n);REQUIRE(data);REQUIRE(fread(data,1,(size_t)n,f)==(size_t)n);fclose(f);d=(MavenBlob){data,(size_t)n};
 REQUIRE(maven_portable_create(&r,d,&a,&e)==MAVEN_ENGINE_OK);free_resources(&r);memset(data,0,(size_t)n);free(data);
 memcpy(p.letters,bytes,225);memcpy(p.blanks,bytes+225,225);memcpy(p.racks,bytes+450,16);p.row_zero_count=(uint16_t)((unsigned)bytes[474]*256+bytes[475]);
 REQUIRE(maven_portable_set_position(e,&p)==MAVEN_ENGINE_OK);
 memset(&out,0x5a,sizeof out);heuristic=out;used=77;estimate=88;
 REQUIRE(maven_portable_late(e,0,0,&out,&used,&estimate)==MAVEN_ENGINE_INVALID);REQUIRE(!memcmp(&out,&heuristic,sizeof out));REQUIRE(used==77&&estimate==88);
 for(i=0;i<3;i++){
  REQUIRE(maven_portable_late(e,1,0,&out,&used,&estimate)==MAVEN_ENGINE_OK);REQUIRE(used==1&&estimate==0);REQUIRE(out.count==RANK_COUNT);REQUIRE(!memcmp(out.moves,expected,sizeof expected));
  REQUIRE(maven_portable_get_position(e,&after)==MAVEN_ENGINE_OK);REQUIRE(!memcmp(&p,&after,sizeof p));
 }
 REQUIRE(maven_portable_heuristic(e,0,0,&heuristic,NULL,NULL)==MAVEN_ENGINE_OK);
 REQUIRE(maven_portable_late(e,0,1,&out,&used,&estimate)==MAVEN_ENGINE_OK);REQUIRE(!used&&estimate>1700);REQUIRE(!memcmp(out.moves,heuristic.moves,sizeof out.moves));REQUIRE(out.count==heuristic.count);
 REQUIRE(maven_portable_late(e,0,4923651,&out,&used,&estimate)==MAVEN_ENGINE_OK);REQUIRE(used==1);
 maven_portable_destroy(e);return 0;}
'''.replace('RANK_COUNT',str(j['final']['ranking_count']))
 if a.prime_at:
  source=source.replace(' memcpy(p.letters,bytes,225);', ' {MavenPosition at={0};at.letters[7*15+7]=97;at.letters[7*15+8]=116;memcpy(at.racks[0],"?abcdef",8);memcpy(at.racks[1],"ghijklm",8);REQUIRE(maven_portable_set_position(e,&at)==MAVEN_ENGINE_OK);REQUIRE(maven_portable_heuristic(e,0,0,&out,NULL,NULL)==MAVEN_ENGINE_OK);} memcpy(p.letters,bytes,225);')
 probe=ROOT/'.build/portable-late-probe.c';probe.write_text(source);exe=ROOT/'.build/portable-late-probe'
 names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
 subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'scripts'),'-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in names],'-o',str(exe)],check=True)
 subprocess.run([str(exe),str(ROOT/'resources'),str(ROOT/'../../media/maven/session/share/maven2.1')],check=True,timeout=60)
 print(json.dumps(dict(scope=__doc__,capture=a.capture.name,prior_AT_search=a.prime_at,ranked=j['final']['ranking_count'],repeated_searches=3,all_matched=True,cpu_gate='zero rejected atomically; calibration1 falls back to independently computed heuristic;4923651 admits late',hidden_opponent='one feasible tile placeholder; late search depends only on unseen counts')))
if __name__=='__main__':main()
