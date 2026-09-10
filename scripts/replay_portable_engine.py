#!/usr/bin/env python3
"""Original candidate/ranking differential from resources and public position only."""
import argparse,json,struct,subprocess,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/heuristic-search-live.json');args=p.parse_args()
 j=json.loads(args.capture.read_text());assert j['complete']
 board=bytes.fromhex(j['initial']['board']);values=struct.unpack('>544H',bytes.fromhex(j['initial']['values']))
 letters=[];blanks=[]
 for row in range(1,16):
  for col in range(1,16):
   i=row*17+col;letters.append(board[i]);blanks.append(int(bool(board[i]) and not values[i]))
 def array(name,data):return 'static const uint8_t '+name+'[]={'+','.join(map(str,data))+'};\n'
 declarations=array('letters',letters)+array('blanks',blanks)+array('own',bytes.fromhex(j['initial']['rack']))+array('opponent',bytes.fromhex(j['opponent_rack']))
 declarations+=array('expected',b''.join(bytes([c['phase'],c['mode']])+bytes.fromhex(c['move']) for c in j['candidates']))
 declarations+=array('ranked',bytes.fromhex(j['final']['ranking']['moves']))
 source=r'''
#include "portable_engine.h"
#include "dictionary_validate.h"
#include "native_resources.h"
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"failed line %d: %s\n",__LINE__,#x);exit(1);}}while(0)
static unsigned allocated,released,fail_at,attempts,emitted;
static void *allocate(void *u,size_t n){void *p;(void)u;if(++attempts==fail_at)return NULL;p=malloc(n);if(p)++allocated;return p;}
static void release(void *u,void *p){(void)u;++released;free(p);}
'''+declarations+r'''
static void observe(void *u,int phase,int mode,const uint8_t *move){const uint8_t *want;(void)u;
 REQUIRE(emitted<sizeof expected/36);want=expected+36*emitted;
 if(phase!=want[0]||mode!=want[1]||memcmp(move,want+2,34)){
  unsigned i;fprintf(stderr,"candidate %u phase %d/%d mode %d/%d\n",emitted,phase,want[0],mode,want[1]);
  for(i=0;i<34;i++)if(move[i]!=want[2+i])fprintf(stderr,"byte %u: %u/%u\n",i,move[i],want[2+i]);exit(1);
 }++emitted;
}
int main(int argc,char **argv){
 MavenTableResources resources;MavenBlob dictionary={0};MavenAllocator allocator={NULL,allocate,release};MavenPortableEngine *engine=NULL;
 MavenPosition position={0},before,invalid,after;MavenCandidateList result;MavenDictionarySection sections[3];FILE *f;long size;uint8_t *data;unsigned i;
 REQUIRE(argc==3);REQUIRE(load_resources(&resources,argv[1]));f=fopen(argv[2],"rb");REQUIRE(f);REQUIRE(!fseek(f,0,SEEK_END));size=ftell(f);REQUIRE(size>0);rewind(f);
 data=malloc((size_t)size);REQUIRE(data);REQUIRE(fread(data,1,(size_t)size,f)==(size_t)size);fclose(f);dictionary=(MavenBlob){data,(size_t)size};
 REQUIRE(maven_validate_dictionary(data,dictionary.size,sections));
 /* Truncation, out-of-range root, bad letter, cycle, and unterminated root. */
 REQUIRE(!maven_validate_dictionary(data,dictionary.size-1,sections));
 {const size_t offsets[]={4,12+257*4+3,12+257*4,12+((size_t)sections[0].root_index+25)*4+2};
  for(i=0;i<sizeof offsets/sizeof offsets[0];i++){uint8_t old=data[offsets[i]];data[offsets[i]]=i==3?(uint8_t)(old&~2u):255;
   REQUIRE(!maven_validate_dictionary(data,dictionary.size,sections));data[offsets[i]]=old;}}
 for(i=1;i<=2;i++){attempts=allocated=released=0;fail_at=i;REQUIRE(maven_portable_create(&resources,dictionary,&allocator,&engine)==MAVEN_ENGINE_ALLOCATION);REQUIRE(!engine);REQUIRE(allocated==released);}
 attempts=allocated=released=fail_at=0;REQUIRE(maven_portable_create(&resources,dictionary,&allocator,&engine)==MAVEN_ENGINE_OK);
 free_resources(&resources);memset(data,0,dictionary.size);free(data);
 REQUIRE(maven_portable_heuristic(engine,1,0,&result,NULL,NULL)==MAVEN_ENGINE_NO_POSITION);
 memcpy(position.letters,letters,225);memcpy(position.blanks,blanks,225);memcpy(position.racks[0],own,8);memcpy(position.racks[1],opponent,8);
 position.row_zero_count=ROW_ZERO;
 REQUIRE(maven_portable_set_position(engine,&position)==MAVEN_ENGINE_OK);REQUIRE(maven_portable_get_position(engine,&before)==MAVEN_ENGINE_OK);
 invalid=position;invalid.racks[0][0]=255;REQUIRE(maven_portable_set_position(engine,&invalid)==MAVEN_ENGINE_INVALID);
 invalid=position;memset(invalid.racks[0],'?',8);REQUIRE(maven_portable_set_position(engine,&invalid)==MAVEN_ENGINE_INVALID);
 invalid=position;invalid.blanks[0]=2;REQUIRE(maven_portable_set_position(engine,&invalid)==MAVEN_ENGINE_INVALID);
 for(i=0;i<3;i++){
  emitted=0;REQUIRE(maven_portable_heuristic(engine,DEDUP,OFFSET,&result,observe,NULL)==MAVEN_ENGINE_OK);
  REQUIRE(emitted==sizeof expected/36);REQUIRE(result.count==RANK_COUNT);REQUIRE(result.cutoff_bits==CUTOFFu);REQUIRE(!memcmp(result.moves,ranked,sizeof ranked));
  REQUIRE(maven_portable_get_position(engine,&after)==MAVEN_ENGINE_OK);REQUIRE(!memcmp(&before,&after,sizeof before));
 }
 maven_portable_destroy(engine);REQUIRE(allocated==released);return 0;
}
'''
 for key,value in dict(ROW_ZERO=j['initial']['row_zero_count'],DEDUP=int(bool(j['extra_filter_pointer'])),OFFSET=j['leave_offset'],RANK_COUNT=j['final']['ranking']['count'],CUTOFF=j['final']['ranking']['cutoff_bits']).items():source=source.replace(key,str(value))
 build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'portable-engine-probe.c';probe.write_text(source);exe=build/'portable-engine-probe'
 names=re.findall(r'reconstruction/(\w+)\.c',(ROOT/'scripts/build_wasm_portable.sh').read_text())
 subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'scripts'),'-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in names],'-o',str(exe)],check=True)
 subprocess.run([str(exe),str(ROOT/'resources'),str(ROOT/'../../media/maven/session/share/maven2.1')],check=True,timeout=60)
 print(json.dumps(dict(scope=__doc__,capture=args.capture.name,candidates=len(j['candidates']),repeated_searches=3,all_matched=True,allocation_failures=2,malformed_dictionary_cases=5,initialization='resources and dictionary; no captured tables, section roots, caches, counts or mirrored board')))
if __name__=='__main__':main()
