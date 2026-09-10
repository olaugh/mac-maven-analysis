from pathlib import Path
import subprocess
import tempfile
import unittest

class ScoreMoveTests(unittest.TestCase):
    def test_blank_selection_and_remaining_rack(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "score_move.h"
#include <assert.h>
#include <string.h>
static uint8_t board[544],wm[544],lm[544],cls[128];static uint16_t values[544],letters[128];static int diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
int main(void){uint8_t move[34]="aaa",rest[16]="untouched";unsigned i;MavenScoreScan r;
 MavenScoreInput s={board,values,letters,wm,lm,cls,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz",diagnostic,0};
 memset(wm,1,sizeof wm);memset(lm,1,sizeof lm);memset(cls,128,sizeof cls);for(i=0;i<128;i++)letters[i]=100;
 r=maven_score_move(move,0,rest,&s);assert(!r.score_bits&&!strcmp((char *)rest,"untouched"));
 move[32]=8;move[33]=7;lm[143]=3;lm[144]=1;lm[145]=2;
 r=maven_score_move(move,(const uint8_t *)"aa?i",rest,&s);
 assert(r.score_bits==500&&r.zero_value_column[1]==8&&!strcmp((char *)rest,"i"));
 r=maven_score_move(move,(const uint8_t *)"a??i",rest,&s);
 assert(r.score_bits==300&&r.zero_value_column[1]==8&&r.zero_value_column[0]==9&&!strcmp((char *)rest,"i"));
 /* Equal costs keep the earliest two candidates. */
 memset(lm,1,sizeof lm);r=maven_score_move(move,(const uint8_t *)"a??",rest,&s);
 assert(r.score_bits==100&&r.zero_value_column[1]==7&&r.zero_value_column[0]==8);
 strcpy((char *)move,"aba");lm[143]=3;
 r=maven_score_move(move,(const uint8_t *)"a??z",rest,&s);
 assert(r.score_bits==300&&r.zero_value_column[1]==8&&r.zero_value_column[0]==9&&!strcmp((char *)rest,"z"));
 /* One blank: cross-word exposure makes the first a more expensive. */
 strcpy((char *)move,"aa");memset(lm,1,sizeof lm);board[126]='b';values[126]=100;
 r=maven_score_move(move,(const uint8_t *)"a?",rest,&s);
 assert(r.score_bits==300&&r.zero_value_column[1]==8&&!diagnostics);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/score_move.c'),str(root/'reconstruction/score_accumulate.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
