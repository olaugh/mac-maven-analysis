from pathlib import Path
import subprocess
import tempfile
import unittest

class BoardHelpersTests(unittest.TestCase):
    def test_move_count_and_left_scan_contract(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "board_state.h"
#include <assert.h>
#include <string.h>
int main(void){uint8_t board[544]={0},move[34]="abcd";
 move[32]=8;move[33]=7;board[143]='x';board[145]='c';
 assert(maven_count_new_move_tiles(move,board)==2);
 board[143]=board[145]=0;assert(maven_count_new_move_tiles(move,board)==4);
 memcpy(board+140,"abc",3);
 assert(maven_word_start_before(board,8,7)==board+140);
 assert(maven_word_start_before(board,8,8)==board+144);
 /* The supplied cell is not tested: its occupied value is irrelevant. */
 board[144]='z';assert(maven_word_start_before(board,8,8)==board+144);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/board_state.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
