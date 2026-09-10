from pathlib import Path
import subprocess
import tempfile
import unittest

class CrossWordPossibleTests(unittest.TestCase):
    def test_queries_early_success_and_transient_cell_cleanup(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "cross_word_possible.h"
#include "board_state.h"
#include <assert.h>
#include <string.h>
static int calls,success;static uint8_t *active_board;
static int32_t contains(void *u,const uint8_t *word){(void)u;++calls;assert(active_board[8*17+8]==0);assert(!strcmp((const char *)word,calls==1?"cat":"cot"));return success&&calls==2;}
static void diagnostic(void *u){(void)u;assert(0);}
int main(void){uint8_t board[544]={0},before[544];int16_t available[128]={0};int16_t r,c;
 board[7*17+8]='c';board[9*17+8]='t';maven_cross_coordinates(7,8,&r,&c);board[r*17+c]='c';maven_cross_coordinates(9,8,&r,&c);board[r*17+c]='t';
 memcpy(before,board,544);available['a']=1;available['o']=-1;active_board=board;success=1;
 assert(maven_cross_word_possible(available,(const uint8_t *)"aox",8,8,board,contains,diagnostic,0)==1&&calls==2&&!memcmp(before,board,544));
 calls=0;success=0;assert(maven_cross_word_possible(available,(const uint8_t *)"aox",8,8,board,contains,diagnostic,0)==0&&calls==2&&!memcmp(before,board,544));
 calls=0;available['a']=available['o']=0;assert(maven_cross_word_possible(available,(const uint8_t *)"aox",8,8,board,contains,diagnostic,0)==0&&calls==0&&!memcmp(before,board,544));
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/cross_word_possible.c'),str(root/'reconstruction/board_state.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
