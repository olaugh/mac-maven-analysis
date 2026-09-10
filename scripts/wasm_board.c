/* Freestanding research bridge for valid captured ASCII moves. This is not
 * an untrusted-input parser or a full game/UI runtime. Memory words use wasm
 * little-endian order; callers decode original big-endian captures first. */
#include "apply_move.h"
#include "score_move.h"
#include "rack_counts.h"
#include "undo_move.h"
#include <stddef.h>
static uint8_t board[544],word_multipliers[544],letter_multipliers[544],letter_class[128],alphabet[28],move[34],rack[8],undo[33],counts[128],remaining[16];
static uint16_t values[544],letter_values[128];
static MavenApplyState state;
static MavenScoreScan score;
void *memset(void *p,int c,size_t n){uint8_t *s=p;while(n--)*s++=(uint8_t)c;return p;}
void *memcpy(void *to,const void *from,size_t n){uint8_t *d=to;const uint8_t *s=from;while(n--)*d++=*s++;return to;}
char *strcpy(char *to,const char *from){char *d=to;while((*d++=*from++)){}return to;}
size_t strlen(const char *p){const char *s=p;while(*p)++p;return (size_t)(p-s);}
static void diagnostic(void *u){(void)u;__builtin_trap();}
void *maven_board_buffer(unsigned id){
 switch(id){case 0:return board;case 1:return values;case 2:return letter_values;
 case 3:return word_multipliers;case 4:return letter_multipliers;case 5:return letter_class;
 case 6:return alphabet;case 7:return move;case 8:return rack;case 9:return undo;
 case 10:return counts;case 11:return remaining;default:__builtin_trap();}
}
void maven_board_reset(void){
 memset(&state,0,sizeof state);memset(&score,0,sizeof score);
 memset(board,0,sizeof board);memset(values,0,sizeof values);memset(letter_values,0,sizeof letter_values);
 memset(word_multipliers,0,sizeof word_multipliers);memset(letter_multipliers,0,sizeof letter_multipliers);
 memset(letter_class,0,sizeof letter_class);memset(alphabet,0,sizeof alphabet);memset(move,0,sizeof move);memset(rack,0,sizeof rack);
 memset(undo,0,sizeof undo);memset(counts,0,sizeof counts);memset(remaining,0,sizeof remaining);
 state.placement=(MavenLetterPlacement){board,values,counts,letter_values,word_multipliers,undo,diagnostic,0};
 state.letter_multipliers=letter_multipliers;state.letter_class=letter_class;state.alphabet=alphabet;
}
uint32_t maven_board_score(void){
 MavenScoreInput input={board,values,letter_values,word_multipliers,letter_multipliers,letter_class,alphabet,diagnostic,0};
 score=maven_score_move(move,rack,remaining,&input);return score.score_bits;
}
void maven_board_prepare_counts(void){maven_count_rack(counts,alphabet,rack);}
void maven_board_apply(void){maven_apply_move_without_evaluation(move,rack,&state);}
void maven_board_set_counter(int counter){state.row_zero_count=(int16_t)counter;}
void maven_board_undo(void){MavenMoveUndo s={board,values,undo,&state.row_zero_count,diagnostic,0};maven_undo_move(rack,&s);}
int maven_board_result(unsigned id){
 switch(id){case 0:return score.new_tiles;case 1:return score.zero_value_row[0];
 case 2:return score.zero_value_row[1];case 3:return score.zero_value_column[0];
 case 4:return score.zero_value_column[1];case 5:return state.new_tiles;
 case 6:return state.row_zero_count;default:__builtin_trap();}
}
