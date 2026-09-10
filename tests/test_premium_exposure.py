from pathlib import Path
import subprocess
import tempfile
import unittest

class PremiumExposureTests(unittest.TestCase):
    def test_directions_occupancy_and_both_board_halves(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "premium_exposure.h"
#include <assert.h>
#include <string.h>
static int errors;static void diagnostic(void *u){(void)u;++errors;}
int main(void){uint8_t board[544]={0},wm[544],lm[544],classes[128]={0},records[80]={0},move[34]={0};int cell;
 MavenPremiumExposureInput in={board,wm,lm,classes,records,diagnostic,0};
 memset(wm,1,544);memset(lm,1,544);classes['a']=128;move[0]='a';move[32]=8;move[33]=8;cell=8*17+8;
 records[0]='a';records[2]=2;records[3]=17;records[4]='a';records[5]=1;records[6]=3;records[7]=23;
 wm[cell-17]=2;lm[cell+17]=3;
 assert(maven_adjacent_premium_penalty(move,&in)==(uint32_t)-40);
 board[cell-34]='b';assert(maven_adjacent_premium_penalty(move,&in)==(uint32_t)-23);
 board[cell-17]='b';assert(maven_adjacent_premium_penalty(move,&in)==0);
 memset(board,0,544);board[cell+34]='b';assert(maven_adjacent_premium_penalty(move,&in)==(uint32_t)-17);
 board[cell]='a';assert(maven_adjacent_premium_penalty(move,&in)==0);
 board[cell]='b';assert(maven_adjacent_premium_penalty(move,&in)==0&&errors==1);
 memset(board,0,544);move[32]=1;cell=17+8;lm[cell+17]=3;
 assert(maven_adjacent_premium_penalty(move,&in)==(uint32_t)-23);
 move[32]=16;cell=16*17+8;lm[cell+17]=3;
 assert(maven_adjacent_premium_penalty(move,&in)==(uint32_t)-23);
 move[32]=30;cell=30*17+8;wm[cell-17]=2;
 assert(maven_adjacent_premium_penalty(move,&in)==(uint32_t)-17);
 move[32]=0;assert(maven_adjacent_premium_penalty(move,&in)==0);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/premium_exposure.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
