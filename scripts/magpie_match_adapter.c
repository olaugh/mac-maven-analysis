/* Test-only file-loading bridge. The engine and candidate callback are public APIs. */
#include "portable_engine.h"
#include "native_resources.h"
static void *alloc(void *u,size_t n){(void)u;return malloc(n);}
static void dealloc(void *u,void *p){(void)u;free(p);}
MavenPortableEngine *match_create(const char *root,const char *dict){
 MavenTableResources r; MavenPortableEngine *e=NULL; MavenAllocator a={NULL,alloc,dealloc};
 FILE *f; long n; uint8_t *data;
 if(!load_resources(&r,root))return NULL;
 f=fopen(dict,"rb");if(!f){free_resources(&r);return NULL;}
 fseek(f,0,SEEK_END);n=ftell(f);rewind(f);data=malloc((size_t)n);
 if(data&&fread(data,1,(size_t)n,f)==(size_t)n)maven_portable_create(&r,(MavenBlob){data,(size_t)n},&a,&e);
 fclose(f);free(data);free_resources(&r);return e;
}
/* Apply the matched original-ranked move to recover its chosen blank squares.
 * The match runner owns the bag, so it discards this adapter's refill. */
static int tick(void *u,uint32_t *out){uint32_t *n=u;*out=++*n;return 1;}
static int random_word(void *u,int16_t *out){uint32_t *n=u;*out=(int16_t)(++*n*25173u+13849u);return 1;}
int match_apply(MavenPortableEngine *e,unsigned index,MavenPosition *out){
 uint32_t n=0;MavenGameRuntime runtime={&n,tick,random_word,1234567,0};MavenGameResult result;
 int rc=maven_portable_play_ranked(e,index,&runtime,&result);
 return rc?rc:maven_portable_get_position(e,out);
}
typedef struct {const uint32_t *clocks;unsigned count,index,overrun;} MatchClocks;
static int32_t elapsed(void *u){MatchClocks *c=u;if(c->index==c->count){c->overrun=1;return INT32_MAX;}return (int32_t)c->clocks[c->index++];}
int match_endgame(MavenPortableEngine *e,uint32_t seed,int32_t budget,const uint32_t *clocks,unsigned count,MavenCandidateList *out){
 MatchClocks c={clocks,count,0,0};MavenEndgameOptions options={&c,elapsed,NULL,seed,budget};unsigned iterations;
 int rc=maven_portable_endgame(e,&options,out,&iterations);if(rc)return rc;
 return c.overrun||c.index!=c.count?100:0;
}

/* Read-only baseline for the live recorder's lifecycle guard. No state injection. */
int match_initial_workspace(const char *root,uint8_t out[64]){
 MavenTableResources r;MavenEngineTables *t;int ok;
 if(!load_resources(&r,root))return 0;
 t=malloc(sizeof *t);if(!t){free_resources(&r);return 0;}
 ok=maven_initialize_engine_tables(t,&r)==MAVEN_TABLES_OK;
 if(ok)memcpy(out,t->globals+MAVEN_GLOBAL_BYTES-0x6f2,64);
 free(t);free_resources(&r);return ok;
}
