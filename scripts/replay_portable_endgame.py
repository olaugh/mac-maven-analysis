#!/usr/bin/env python3
"""Original endgame ranking from resources, board/racks, RNG seed and clock events."""
import argparse,gzip,json,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def main():
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/endgame-search-owned-fresh-live.json.gz');a=parser.parse_args()
 j=json.loads(gzip.decompress(a.capture.read_bytes()));assert j['complete']
 b=bytes.fromhex(j['initial']['board']);v=struct.unpack('>544H',bytes.fromhex(j['initial']['values']));letters=[];blanks=[]
 for row in range(1,16):
  for col in range(1,16):
   i=row*17+col;letters.append(b[i]);blanks.append(int(bool(b[i]) and not v[i]))
 table=struct.unpack('>16I',bytes.fromhex(j.get('initialized_hash_table',j['fixed']['hash_table'])))
 seed=((table[0]<<1)&0x7fffffff)|(((table[0]>>30)^(table[0]>>3))&1)
 if int(j['fixed']['hash_table'][:8],16)==0:assert seed==j['hash_entry_seed']
 state=seed
 for value in table:
  state=(state>>1)+((((state>>4)^state)&1)*0x40000000);assert state==value
 def array(name,data,kind='uint8_t'):return 'static const '+kind+' '+name+'[]={'+','.join(str(x)+('u' if kind=='uint32_t' else '') for x in data)+'};\n'
 source=r'''
#include "portable_engine.h"
#include "hash_initializer.h"
#include "native_resources.h"
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"line %d: %s\n",__LINE__,#x);exit(1);}}while(0)
static void *allocate(void *u,size_t n){(void)u;return malloc(n);}static void release(void *u,void *p){(void)u;free(p);}
static unsigned clock_index,polls,cancel_at;
'''+array('letters',letters)+array('blanks',blanks)+array('own',bytes.fromhex(j['own']))+array('other',bytes.fromhex(j['other']))+array('expected',bytes.fromhex(j['final']['ranking']['moves']))+array('clocks',[x['result'] for x in j['elapsed']] or [0],'uint32_t')+array('hash_words',table,'uint32_t')+r'''
static int32_t elapsed(void *u){(void)u;REQUIRE(clock_index<CLOCK_COUNT);return (int32_t)clocks[clock_index++];}
static int cancel(void *u){(void)u;return cancel_at&&++polls==cancel_at;}
int main(int argc,char **argv){MavenTableResources r;MavenAllocator a={NULL,allocate,release};MavenPortableEngine *e;MavenBlob d;MavenPosition p={0},after;
 MavenCandidateList out,previous;MavenEndgameOptions options={NULL,elapsed,cancel,SEEDu,BUDGET};unsigned iterations,i;FILE *f;long n;uint8_t *data;
 uint32_t hash[16]={0},state=SEEDu;REQUIRE(maven_initialize_hash_table(hash,&state));REQUIRE(!memcmp(hash,hash_words,sizeof hash));
 {uint32_t before=state;REQUIRE(maven_initialize_hash_table(hash,&state));REQUIRE(state==before);memset(hash,0,sizeof hash);state=0;REQUIRE(!maven_initialize_hash_table(hash,&state));REQUIRE(!hash[0]&&!state);}
 REQUIRE(argc==3);REQUIRE(load_resources(&r,argv[1]));f=fopen(argv[2],"rb");REQUIRE(f);REQUIRE(!fseek(f,0,SEEK_END));n=ftell(f);REQUIRE(n>0);rewind(f);data=malloc((size_t)n);REQUIRE(data);REQUIRE(fread(data,1,(size_t)n,f)==(size_t)n);fclose(f);d=(MavenBlob){data,(size_t)n};
 REQUIRE(maven_portable_create(&r,d,&a,&e)==MAVEN_ENGINE_OK);free_resources(&r);memset(data,0,(size_t)n);free(data);
 memcpy(p.letters,letters,225);memcpy(p.blanks,blanks,225);memcpy(p.racks[0],own,8);memcpy(p.racks[1],other,8);p.row_zero_count=ROW_ZERO;
 REQUIRE(maven_portable_set_position(e,&p)==MAVEN_ENGINE_OK);
 for(i=1;i<=2;i++){
  memset(&out,0x5a,sizeof out);previous=out;iterations=1234;clock_index=polls=0;cancel_at=i;
  REQUIRE(maven_portable_endgame(e,&options,&out,&iterations)==MAVEN_ENGINE_CANCELLED);REQUIRE(!memcmp(&out,&previous,sizeof out));REQUIRE(iterations==1234);
  REQUIRE(maven_portable_get_position(e,&after)==MAVEN_ENGINE_OK);REQUIRE(!memcmp(&p,&after,sizeof p));
 }
 cancel_at=0;
 for(i=0;i<3;i++){
  clock_index=0;REQUIRE(maven_portable_endgame(e,&options,&out,&iterations)==MAVEN_ENGINE_OK);
  REQUIRE(iterations==ITERATIONS);REQUIRE(clock_index==CLOCK_COUNT);REQUIRE(out.count==RANK_COUNT);
  if(memcmp(out.moves,expected,sizeof expected)){unsigned k;for(k=0;k<sizeof expected;k++)if(((uint8_t*)out.moves)[k]!=expected[k])fprintf(stderr,"ranking byte %u: %u/%u\n",k,((uint8_t*)out.moves)[k],expected[k]);return 1;}
  REQUIRE(maven_portable_get_position(e,&after)==MAVEN_ENGINE_OK);REQUIRE(!memcmp(&p,&after,sizeof p));
 }
 maven_portable_destroy(e);return 0;}
'''
 for key,value in dict(CLOCK_COUNT=len(j['elapsed']),SEED=seed,BUDGET=j['budget'],ROW_ZERO=j['initial']['row_zero_count'],ITERATIONS=len(j['iterations']),RANK_COUNT=j['final']['ranking']['count']).items():source=source.replace(key,str(value))
 probe=ROOT/'.build/portable-endgame-probe.c';probe.write_text(source);exe=ROOT/'.build/portable-endgame-probe'
 names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
 subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'scripts'),'-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in names],'-o',str(exe)],check=True)
 subprocess.run([str(exe),str(ROOT/'resources'),str(ROOT/'../../media/maven/session/share/maven2.1')],check=True,timeout=90)
 print(json.dumps(dict(scope=__doc__,capture=a.capture.name,ranked=j['final']['ranking']['count'],iterations=len(j['iterations']),repeated_searches=3,cancellation_cases=2,all_matched=True,private_seed=seed,seed_source='observed entry seed' if not int(j['fixed']['hash_table'][:8],16) else 'inverse of observed CODE4 sequence')))
if __name__=='__main__':main()
