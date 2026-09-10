from pathlib import Path
import subprocess
import tempfile
import unittest

class ScoreAccumulateTests(unittest.TestCase):
    def test_main_cross_bingo_blank_and_signed_word_product(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "score_accumulate.h"
#include <assert.h>
#include <string.h>
static uint8_t board[544],wm[544],lm[544],classification[128];
static uint16_t values[544],letters[128];static int diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
int main(void){uint8_t move[34]="aortae";unsigned i;MavenScoreScan r;
 MavenScoreInput s={board,values,letters,wm,lm,classification,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz",diagnostic,0};
 memset(wm,1,sizeof wm);memset(lm,1,sizeof lm);memset(classification,128,sizeof classification);
 for(i=0;i<128;i++)letters[i]=100;
 move[32]=8;move[33]=7;wm[144]=2;
 r=maven_accumulate_move_score(move,(const uint8_t *)"oriaate",&s);
 assert(r.score_bits==1200&&r.new_tiles==6&&!diagnostics);
 /* Cross word adds existing value plus letter premium, then word premium. */
 board[7*17+8]='b';values[7*17+8]=300;
 r=maven_accumulate_move_score(move,(const uint8_t *)"oriaate",&s);assert(r.score_bits==2000);
 memset(board,0,sizeof board);strcpy((char *)move,"abcdefg");
 r=maven_accumulate_move_score(move,(const uint8_t *)"abcdefg",&s);assert(r.score_bits==6400&&r.new_tiles==7);
 /* Blank allocation is recorded; value adjustment is a later CODE32 phase. */
 r=maven_accumulate_move_score(move,(const uint8_t *)"?bcdefg",&s);assert(r.score_bits==6400&&r.initial_blanks==1&&r.remaining_blanks==0&&r.missing_letters[0]=='a');
 /* Existing blank coordinates retain the most recent two in reverse order. */
 board[143]='a';board[144]='b';board[145]='c';values[143]=values[144]=values[145]=0;
 r=maven_accumulate_move_score(move,(const uint8_t *)"defg",&s);assert(r.zero_value_column[0]==9&&r.zero_value_column[1]==8&&r.new_tiles==4&&r.score_bits==400);
 memset(board,0,sizeof board);memset(wm,1,sizeof wm);move[0]='a';move[1]=0;letters['a']=20000;lm[143]=2;
 r=maven_accumulate_move_score(move,(const uint8_t *)"a",&s);assert(r.score_bits==(uint32_t)(int32_t)-25536);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/score_accumulate.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
