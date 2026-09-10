/* Freestanding research bridge for validated original Maven data. This is a
 * trusted-input engine interface, not a parser for arbitrary uploaded files.
 * Table words use native wasm little-endian; raw move/DAWG records stay BE. */
#include "heuristic_search.h"
#include "evaluated_application.h"
#include "display_move_score.h"
#include "move_statistics.h"
#include "board_state.h"
#include "pattern_cache.h"
#include "rack_composition.h"
#include <stddef.h>
#include <string.h>
static uint8_t board[544],word_multipliers[544],letter_multipliers[544],letter_class[128],alphabet[28],rack[8],opponent[8],undo[33],counts[128],distribution[128],vowels[32],q_query[8],u_query[8];
static uint16_t values[544],letter_values[128],small_pool[17],q_with_u[5],q_without_u[35];
static uint32_t opening[16],letter_scores[27][8],composition_scores[8][8];
static uint8_t pattern_records[32768],pattern_strings[65536],pattern_scores[65536],dictionary[1200000];
static uint32_t section_spec[17][2],pattern_stamps[4096];
static MavenDictionarySection sections[17];
static MavenPatternEntry pattern_storage[4096];
static MavenPatternCache patterns;
static MavenApplyState application;
static MavenRackBalanceCache balance;
static MavenMoveEvaluation evaluation;
static MavenLeaveTable leaves;
static MavenCandidateList ranking;
static MavenHeuristicSearch search;
static uint8_t trace[100000][38];
static uint32_t trace_count;
static uint8_t applied_move[34],display[289],display_classes[256],callback_moves[4][68];
static uint32_t features[22],statistics[22],applied_records,callback_count;
static int16_t applied_ids[4096],applied_weights[4096];
static MavenAppliedMove applied_workspace;
static MavenDisplayMoveScore display_score;
void *memset(void *p,int c,size_t n){uint8_t *s=p;while(n--)*s++=(uint8_t)c;return p;}
void *memcpy(void *to,const void *from,size_t n){uint8_t *d=to;const uint8_t *s=from;while(n--)*d++=*s++;return to;}
void *memmove(void *to,const void *from,size_t n){uint8_t *d=to;const uint8_t *s=from;if(d<s)while(n--)*d++=*s++;else{d+=n;s+=n;while(n--)*--d=*--s;}return to;}
int memcmp(const void *a,const void *b,size_t n){const unsigned char *x=a,*y=b;while(n--){if(*x!=*y)return *x-*y;++x;++y;}return 0;}
char *strcpy(char *to,const char *from){char *d=to;while((*d++=*from++)){}return to;}
size_t strlen(const char *p){const char *s=p;while(*p)++p;return (size_t)(p-s);}
int strcmp(const char *a,const char *b){while(*a&&*a==*b){++a;++b;}return (unsigned char)*a-(unsigned char)*b;}
char *strchr(const char *s,int c){do{if((unsigned char)*s==(unsigned char)c)return (char *)s;}while(*s++);return NULL;}
static void diagnostic(void *u){(void)u;__builtin_trap();}
static void *allocate(void *u,size_t size){(void)u;if(size>sizeof pattern_storage)__builtin_trap();return pattern_storage;}
static uint32_t composition(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t total){(void)u;return maven_rack_composition(v,c,pv,pc,total,composition_scores[total]);}
static void candidate(void *u,int phase,const uint8_t *move){uint8_t *out;int16_t mode;(void)u;if(trace_count==100000)__builtin_trap();out=trace[trace_count++];mode=move[32]?maven_count_new_move_tiles(move,board):0;out[0]=(uint8_t)phase;out[1]=0;out[2]=(uint8_t)((uint16_t)mode>>8);out[3]=(uint8_t)mode;memcpy(out+4,move,34);}
void *maven_engine_buffer(unsigned id){switch(id){
 case 0:return board;case 1:return values;case 2:return letter_values;case 3:return word_multipliers;case 4:return letter_multipliers;case 5:return letter_class;case 6:return alphabet;case 7:return rack;case 8:return opponent;case 9:return undo;case 10:return counts;case 11:return distribution;case 12:return vowels;case 13:return opening;case 14:return small_pool;case 15:return q_with_u;case 16:return q_without_u;case 17:return q_query;case 18:return u_query;case 19:return letter_scores;case 20:return composition_scores;case 21:return pattern_records;case 22:return pattern_strings;case 23:return pattern_scores;case 24:return dictionary;case 25:return section_spec;case 26:return balance.entries;case 27:return leaves.mask_generations;case 28:return leaves.occurrence_masks;case 29:return leaves.tile_points;case 30:return leaves.values;case 31:return leaves.canonical_masks;case 32:return ranking.moves;case 33:return trace;case 34:return pattern_stamps;case 35:return applied_move;case 36:return features;case 37:return applied_ids;case 38:return applied_weights;case 39:return display;case 40:return display_classes;case 41:return callback_moves;case 42:return statistics;default:__builtin_trap();}}
void maven_engine_initialize(int record_count){unsigned i;
 memset(&application,0,sizeof application);memset(&balance,0,sizeof balance);memset(&leaves,0,sizeof leaves);memset(&ranking,0,sizeof ranking);memset(&patterns,0,sizeof patterns);memset(&search,0,sizeof search);memset(&evaluation,0,sizeof evaluation);
 application.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};application.letter_multipliers=letter_multipliers;application.letter_class=letter_class;application.alphabet=alphabet;
 balance.evaluate_composition=composition;balance.diagnostic=diagnostic;
 maven_prepare_pattern_cache(&patterns,pattern_records,(int16_t)record_count,pattern_strings,allocate,diagnostic,0);
 for(i=0;i<17;++i){sections[i].records=dictionary+section_spec[i][0];sections[i].root_index=section_spec[i][1];if(!section_spec[i][1])break;}if(i==17)__builtin_trap();
 evaluation.application=&application;evaluation.rack=rack;evaluation.distribution=distribution;evaluation.vowel_characters=vowels;
 evaluation.premium=(MavenPremiumExposureInput){board,word_multipliers,letter_multipliers,letter_class,0,diagnostic,0};
 evaluation.balance=&balance;evaluation.lookup_entries=patterns.entries;evaluation.lookup_count=patterns.count;
 evaluation.patterns=(MavenPatternMatchInput){pattern_records,pattern_strings,pattern_scores,board,values,letter_values,counts,(int16_t)record_count,diagnostic,0};
 evaluation.opening_scores=opening;evaluation.small_pool_scores=small_pool;evaluation.q_with_unseen_u=q_with_u;evaluation.q_without_held_u=q_without_u;evaluation.unseen_q_query=q_query;evaluation.held_u_query=u_query;evaluation.letter_scores=letter_scores;
 leaves.alphabet=alphabet;leaves.vowel_characters=vowels;leaves.distribution=distribution;leaves.letter_values=letter_values;leaves.letter_scores=letter_scores;leaves.q_with_unseen_u=q_with_u;leaves.q_without_held_u=q_without_u;leaves.held_u_query=u_query;leaves.patterns=patterns.entries;leaves.pattern_count=patterns.count;leaves.score_records=pattern_scores;leaves.balance=&balance;
 search.sections=sections;search.evaluation=&evaluation;search.leaves=&leaves;search.result=&ranking;search.opponent_rack=opponent;search.candidate=candidate;
}
/* Premium penalty bytes have their own buffer because all80 bytes are inputs. */
static uint8_t penalties[80];
void *maven_engine_penalties(void){return penalties;}
void maven_engine_set(unsigned id,int32_t value){switch(id){case 0:application.row_zero_count=(int16_t)value;break;case 1:application.new_tiles=(int16_t)value;break;case 2:application.recorded_row[0]=(int16_t)value;break;case 3:application.recorded_row[1]=(int16_t)value;break;case 4:application.recorded_column[0]=(int16_t)value;break;case 5:application.recorded_column[1]=(int16_t)value;break;case 6:balance.pool_vowels=value;break;case 7:balance.pool_consonants=value;break;case 8:leaves.generation=(uint32_t)value;break;case 9:ranking.cutoff_bits=(uint32_t)value;break;case 10:search.leave_offset=(int16_t)value;break;case 11:search.word_deduplication=value;break;default:__builtin_trap();}}
uint32_t maven_engine_get(unsigned id){switch(id){case 0:return (uint32_t)application.row_zero_count;case 1:return (uint32_t)application.new_tiles;case 2:return (uint32_t)application.recorded_row[0];case 3:return (uint32_t)application.recorded_row[1];case 4:return (uint32_t)application.recorded_column[0];case 5:return (uint32_t)application.recorded_column[1];case 6:return (uint32_t)balance.pool_vowels;case 7:return (uint32_t)balance.pool_consonants;case 8:return leaves.generation;case 9:return ranking.cutoff_bits;case 10:return ranking.count;case 11:return trace_count;case 12:return (uint32_t)patterns.count;case 13:return (uint32_t)leaves.mask_count;case 14:return applied_records;case 15:return callback_count;default:__builtin_trap();}}
void maven_engine_run(void){int i;trace_count=0;evaluation.premium.penalties=penalties;for(i=0;i<patterns.count;++i)patterns.entries[i].accumulator=pattern_stamps[i];maven_search_heuristic_moves(&search);for(i=0;i<patterns.count;++i)pattern_stamps[i]=patterns.entries[i].accumulator;}

static void scored_display(void *u,uint8_t move[34]){
 if(callback_count>=4)__builtin_trap();
 memcpy(callback_moves[callback_count],move,34);
 maven_score_display_move(u,move);
 memcpy(callback_moves[callback_count]+34,move,34);++callback_count;
}
uint32_t maven_engine_apply(void){
 MavenMoveEvaluationResult result;int i;
 if(evaluation.patterns.record_count+40>4096)__builtin_trap();
 callback_count=0;memset(&applied_workspace,0,sizeof applied_workspace);
 evaluation.premium.penalties=penalties;
 for(i=0;i<patterns.count;++i)patterns.entries[i].accumulator=pattern_stamps[i];
 display_score=(MavenDisplayMoveScore){&application,display,display_classes,rack};
 application.scored_move=scored_display;application.callback_user=&display_score;
 result=maven_apply_evaluated_move(applied_move,&evaluation,features,applied_ids,applied_weights,&applied_workspace);
 application.scored_move=0;application.callback_user=0;
 maven_add_move_statistics(features,statistics);applied_records=(uint32_t)result.record_count;
 for(i=0;i<patterns.count;++i)pattern_stamps[i]=patterns.entries[i].accumulator;
 return result.total_bits;
}
