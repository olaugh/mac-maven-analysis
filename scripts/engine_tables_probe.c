#include "engine_tables.h"
#include "native_resources.h"
static void hex(const void *data,size_t n,unsigned width){
 size_t i;if(width==1){const uint8_t *p=data;for(i=0;i<n;i++)printf("%02x",p[i]);}
 else if(width==2){const uint16_t *p=data;for(i=0;i<n;i++)printf("%04x",p[i]);}
 else{const uint32_t *p=data;for(i=0;i<n;i++)printf("%08x",p[i]);}
}
#define FIELD(name,member,count,width) do{printf("\"%s\":\"",name);hex(t->member,count,width);printf("\",\n");}while(0)
int main(int argc,char **argv){
 MavenTableResources resources;MavenEngineTables *t;int status;
 if(argc!=2||!load_resources(&resources,argv[1]))return 2;
 t=malloc(sizeof *t);if(!t){free_resources(&resources);return 3;}
 status=maven_initialize_engine_tables(t,&resources);free_resources(&resources);if(status){fprintf(stderr,"table initialization: %d\n",status);free(t);return 4;}
 puts("{");FIELD("letter_values",letter_values,128,2);FIELD("word_multipliers",word_multipliers,544,1);FIELD("letter_multipliers",letter_multipliers,544,1);
 FIELD("letter_class",classes,128,1);FIELD("distribution",distribution,128,1);FIELD("penalties",penalties,80,1);FIELD("small_pool_scores",small_pool,17,2);
 FIELD("q_with_unseen_u",q_with_u,5,2);FIELD("q_without_held_u",q_without_u,35,2);FIELD("alphabet",alphabet,28,1);FIELD("display_order",display_order,28,1);
 FIELD("vowel_characters",vowels,6,1);FIELD("unseen_q_query",q_query,2,1);FIELD("held_u_query",u_query,3,1);FIELD("opening_scores",opening,8,4);
 FIELD("letter_scores",letter_scores,27*8,4);FIELD("composition_scores",composition_scores,8*8,4);
 FIELD("pattern_records",patterns,(size_t)t->pattern_count*8,1);FIELD("pattern_strings",strings,t->string_bytes,1);FIELD("pattern_scores",scores,t->score_count*28,1);
 printf("\"pattern_count\":%d,\"score_count\":%zu}\n",t->pattern_count,t->score_count);free(t);return 0;
}
