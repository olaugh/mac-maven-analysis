from pathlib import Path
import subprocess
import tempfile
import unittest

class MoveEvaluationTests(unittest.TestCase):
    def test_apply_evaluate_undo_restoration_and_optional_records(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "move_evaluation.h"
#include <assert.h>
#include <string.h>
static void diagnostic(void *u){(void)u;assert(!"unexpected diagnostic");}
static uint32_t zero_composition(void *u,int16_t a,int16_t b,int16_t c,int16_t d,int16_t e){(void)u;(void)a;(void)b;(void)c;(void)d;(void)e;return 0;}
int main(void){uint8_t board[544]={0},counts[128]={0},undo[33]={0},rack[8]="abcdefg",move[34]={0};
 uint8_t distribution[128]={0},premiums[544]={0},classes[128]={0},penalties[80]={0},records[8]={0},strings[1]={0},score_records[28]={0};
 uint16_t values[544]={0},letter_values[128]={0},small[17]={0},qu[5]={0},no_u[35]={0};uint32_t opening[16]={0},expectations[27][8]={{0}};
 const uint8_t *alphabet=(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz";
 MavenApplyState apply={0};MavenRackBalanceCache cache={0};MavenMoveEvaluation s={0};MavenMoveEvaluationResult result;
 int16_t ids[42],weights[42],expected[]={-32,-1,-2,-8,-9,-10,-11,-12,0};int i,r,c;
 for(i='a';i<='z';++i){distribution[i]=3;letter_values[i]=100;classes[i]=128;}distribution['?']=2;
 for(r=1;r<=30;++r)for(c=1;c<=15;++c)premiums[r*17+c]=1;
 apply.placement=(MavenLetterPlacement){board,values,counts,letter_values,premiums,undo,diagnostic,0};
 apply.letter_multipliers=premiums;apply.letter_class=classes;apply.alphabet=alphabet;apply.row_zero_count=3;
 cache.evaluate_composition=zero_composition;cache.diagnostic=diagnostic;
 s.application=&apply;s.rack=rack;s.distribution=distribution;s.vowel_characters=(const uint8_t *)"aeiou";
 s.premium=(MavenPremiumExposureInput){board,premiums,premiums,classes,penalties,diagnostic,0};s.balance=&cache;
 s.patterns=(MavenPatternMatchInput){records,strings,score_records,board,values,letter_values,counts,1,diagnostic,0};
 s.opening_scores=opening;s.small_pool_scores=small;s.q_with_unseen_u=qu;s.q_without_held_u=no_u;s.unseen_q_query=(const uint8_t *)"q";s.held_u_query=(const uint8_t *)"qu";s.letter_scores=expectations;
 memcpy(move,"ab",3);move[32]=8;move[33]=7;
 for(i=0;i<42;++i)ids[i]=weights[i]=123;
 result=maven_evaluate_move(move,&s,ids,weights);assert(result.total_bits==0&&result.record_count==8);
 for(i=0;i<9;++i){assert(ids[i]==expected[i]);assert(weights[i]==0);}
 assert(ids[9]==123&&weights[9]==123);assert(!strcmp((const char *)rack,"abcdefg"));
 for(i=0;i<544;++i)assert(!board[i]&&!values[i]);for(i='a';i<='z';++i)assert(counts[i]==(i<='g'));
 assert(apply.row_zero_count==0&&cache.pool_vowels==15&&cache.pool_consonants==58);
 result=maven_evaluate_move(move,&s,0,0);assert(result.total_bits==0&&result.record_count==8);assert(!strcmp((const char *)rack,"abcdefg"));return 0;}
'''
        sources=['move_evaluation','apply_move','board_state','move_finalize','score_move','score_accumulate','place_letters','rack_counts','remaining_tiles','undo_move','premium_exposure','rack_balance','pattern_match','pattern_lookup','letter_expectation']
        with tempfile.TemporaryDirectory() as tmp:
            src=Path(tmp)/'test.c';src.write_text(source);exe=Path(tmp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(root/'reconstruction'),str(src),*[str(root/f'reconstruction/{s}.c') for s in sources],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
