/* Freestanding research bridge for the recovered late search. Numeric
 * arrays use wasm little endian; dictionary/move/pattern records retain BE. */
#include "late_search.h"
#include "rack_composition.h"
#include <stddef.h>
#include <string.h>
static MavenLateSearch search;
static MavenApplyState application;
static MavenLeaveTable leaves;
static MavenRackBalanceCache balance;
static uint8_t board[544],counts[128],undo[33],row_flags[32],own[8];
static uint16_t values[544],letter_values[128];
static uint8_t word_multipliers[544],letter_multipliers[544],letter_class[128],alphabet[28],dictionary[1200000];
static uint32_t bit_masks[32],section_spec[17][2];
static MavenDictionarySection sections[17];
static uint16_t tables[648],q_with_unseen_u[5],q_without_held_u[35];
static uint32_t letter_scores[27][8],composition_scores[8][8];
static uint8_t distribution[128],vowels[16],held_u_query[16],q_query[16],blank_query[16],priority[28];
static uint8_t pattern_strings[64000],pattern_scores[64000],match_records[64000],match_strings[64000],match_scores[64000];
static uint32_t entry_spec[4096][3];
static MavenPatternEntry entries[4096];
static unsigned entry_count,match_count,match_string_origin,checkpoint_count;
void *memset(void *p,int c,size_t n){uint8_t *s=p;while(n--)*s++=(uint8_t)c;return p;}
void *memcpy(void *to,const void *from,size_t n){uint8_t *d=to;const uint8_t *s=from;while(n--)*d++=*s++;return to;}
void *memmove(void *to,const void *from,size_t n){uint8_t *d=to;const uint8_t *s=from;if(d<s)while(n--)*d++=*s++;else{d+=n;s+=n;while(n--)*--d=*--s;}return to;}
int memcmp(const void *a,const void *b,size_t n){const unsigned char *x=a,*y=b;while(n--){if(*x!=*y)return *x-*y;++x;++y;}return 0;}
char *strcpy(char *to,const char *from){char *d=to;while((*d++=*from++)){}return to;}
size_t strlen(const char *p){const char *s=p;while(*p)++p;return (size_t)(p-s);}
int strcmp(const char *a,const char *b){while(*a&&*a==*b){++a;++b;}return (unsigned char)*a-(unsigned char)*b;}
char *strchr(const char *s,int c){do{if((unsigned char)*s==(unsigned char)c)return (char *)s;}while(*s++);return NULL;}

static void diagnostic(void *u){(void)u;__builtin_trap();}
static uint32_t composition(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t total){(void)u;return maven_rack_composition(v,c,pv,pc,total,composition_scores[total]);}
static void checkpoint(void *u,const char *stage,const MavenLateSearch *s){(void)u;(void)stage;(void)s;++checkpoint_count;}
void *maven_late_buffer(unsigned id){switch(id){
 case 0:return board;case 1:return values;case 2:return letter_values;case 3:return word_multipliers;case 4:return letter_multipliers;case 5:return letter_class;case 6:return alphabet;case 7:return own;case 8:return undo;case 9:return counts;case 10:return row_flags;case 11:return bit_masks;case 12:return dictionary;case 13:return section_spec;
 case 14:return leaves.values;case 15:return leaves.tile_points;case 16:return leaves.occurrence_masks;case 17:return leaves.mask_generations;case 18:return leaves.canonical_masks;case 19:return balance.entries;
 case 20:return tables;case 21:return distribution;case 22:return q_with_unseen_u;case 23:return q_without_held_u;case 24:return vowels;case 25:return held_u_query;case 26:return q_query;case 27:return blank_query;case 28:return priority;case 29:return letter_scores;case 30:return composition_scores;
 case 31:return pattern_strings;case 32:return pattern_scores;case 33:return entry_spec;case 34:return match_records;case 35:return match_strings;case 36:return match_scores;
 case 37:return search.baseline.records;case 38:return search.baseline.letter_leave;case 39:return search.baseline.column_cache;case 40:return search.occurrence_masks;case 41:return search.ranking.moves;case 42:return search.local.records;case 43:return search.constraints.masks;case 44:return search.constraints.weights;case 45:return search.conflict_map;default:__builtin_trap();}}
void maven_late_initialize(void){
 memset(&search,0,sizeof search);memset(&application,0,sizeof application);memset(&leaves,0,sizeof leaves);memset(&balance,0,sizeof balance);
 application.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};application.letter_multipliers=letter_multipliers;application.letter_class=letter_class;application.alphabet=alphabet;
 balance.evaluate_composition=composition;balance.diagnostic=diagnostic;
 leaves.alphabet=alphabet;leaves.vowel_characters=vowels;leaves.distribution=distribution;leaves.letter_values=letter_values;leaves.letter_scores=letter_scores;leaves.q_with_unseen_u=q_with_unseen_u;leaves.q_without_held_u=q_without_held_u;leaves.held_u_query=held_u_query;leaves.patterns=entries;leaves.score_records=pattern_scores;leaves.balance=&balance;
 search.exchange_q_string=q_query;
 search.application=&application;search.leaves=&leaves;search.sections=sections;search.bit_masks=bit_masks;search.choose=(const uint16_t(*)[8])tables;search.priority_order=priority;search.q_query=q_query;search.blank_query=blank_query;search.row_flags=row_flags;search.bingo_bonus=5000;search.own_rack=own;search.force=1;search.checkpoint=checkpoint;
}
void maven_late_set(unsigned id,int32_t value){switch(id){
 case 0:application.row_zero_count=(int16_t)value;break;case 1:application.new_tiles=(int16_t)value;break;case 2:application.recorded_row[0]=(int16_t)value;break;case 3:application.recorded_row[1]=(int16_t)value;break;case 4:application.recorded_column[0]=(int16_t)value;break;case 5:application.recorded_column[1]=(int16_t)value;break;
 case 6:leaves.generation=(uint32_t)value;break;case 7:leaves.started_generation=(uint32_t)value;break;case 8:balance.pool_vowels=value;break;case 9:balance.pool_consonants=value;break;case 10:entry_count=(unsigned)value;break;case 11:match_count=(unsigned)value;break;case 12:match_string_origin=(unsigned)value;break;case 13:search.baseline_token=(uint32_t)value;break;case 14:search.local_token=(uint32_t)value;break;case 15:search.value.main_triple=(uint16_t)value;break;default:__builtin_trap();}}
uint32_t maven_late_get(unsigned id){switch(id){case 0:return search.ranking.count;case 1:return checkpoint_count;case 2:return leaves.generation;case 3:return leaves.started_generation;case 4:return leaves.mask_count;case 5:return search.constraints.count;default:__builtin_trap();}}
unsigned maven_late_run(void){unsigned i;
 if(entry_count>4096||match_count>8000||match_string_origin>=64000)__builtin_trap();
 for(i=0;i<entry_count;++i){if(entry_spec[i][0]>=64000)__builtin_trap();entries[i]=(MavenPatternEntry){pattern_strings+entry_spec[i][0],entry_spec[i][1],(int16_t)entry_spec[i][2]};}
 leaves.pattern_count=(int16_t)entry_count;
 for(i=0;i<17;++i){if(section_spec[i][0]>=sizeof dictionary)__builtin_trap();sections[i]=(MavenDictionarySection){dictionary+section_spec[i][0],section_spec[i][1]};if(!section_spec[i][1])break;}if(i==17)__builtin_trap();
 search.patterns=(MavenPatternMatchInput){match_records,match_strings+match_string_origin,match_scores,board,values,letter_values,counts,(int16_t)match_count,diagnostic,0};
 memcpy(search.value.normal_bag,tables+(0x65a8-0x6114)/2,20);memcpy(search.value.held_q_bag,tables+(0x65a8-0x6100)/2,20);memcpy(search.value.reply_q_bag,tables+(0x65a8-0x60ec)/2,20);
 memcpy(search.value.normal_empty_bag,tables+(0x65a8-0x6394)/2,128);memcpy(search.value.held_q_no_u,tables+(0x65a8-0x6314)/2,128);memcpy(search.value.held_q_with_u,tables+(0x65a8-0x6214)/2,128);memcpy(search.value.blank_adjustment,tables+(0x65a8-0x6494)/2,128);
 memcpy(search.value.opponent_held_q,tables+(0x65a8-0x6294)/2,128);
 search.value.normal_before_matrix=tables[(0x65a8-0x6316)/2];search.value.with_u_before_matrix=tables[(0x65a8-0x6216)/2];checkpoint_count=0;return (unsigned)maven_search_late_game(&search);
}
