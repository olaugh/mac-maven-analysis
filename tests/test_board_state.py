from pathlib import Path
import subprocess
import tempfile
import unittest


class BoardStateTests(unittest.TestCase):
    def test_orientation_boundaries_and_exact_end_conditions(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "board_state.h"
#include <assert.h>
#include <string.h>
int main(void){uint8_t board[544]={0},rack[]={1},empty[]={0};int16_t r,c,rr,cc;unsigned n;
 for(r=1;r<=15;r++)for(c=1;c<=15;c++){
  maven_cross_coordinates(r,c,&rr,&cc);assert(rr==c+15&&cc==r);
  maven_cross_coordinates(rr,cc,&rr,&cc);assert(rr==r&&cc==c);
 }
 maven_cross_coordinates(-32768,32767,&rr,&cc);assert(rr==-32754&&cc==-32768);
 for(n=0;n<=255;n++){
  memset(board,0,sizeof board);memset(board+17,1,n);board[16]=board[272]=1;
  assert(maven_count_board_bytes(board)==(int16_t)n);
  assert(maven_board_at_most_79(board)==(n<=79));assert(maven_board_at_least_86(board)==(n>=86));
  assert(maven_game_end_check(rack,rack,2,board)==(n>=80));
  assert(maven_game_end_check(rack,rack,6,board));assert(!maven_game_end_check(rack,rack,7,board));
  assert(maven_game_end_check(empty,rack,0,board));assert(maven_game_end_check(rack,empty,0,board));
 }
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/board_state.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
