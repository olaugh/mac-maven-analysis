from pathlib import Path
import subprocess
import tempfile
import unittest

class CandidateEligibilityTests(unittest.TestCase):
    def test_duplicate_replacement_callback_order_and_board_edges(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "candidate_ranking.h"
#include <assert.h>
#include <string.h>
static int calls;
static int duplicate(void *u,const uint8_t *m){++calls;return maven_accept_word_improvement(u,m);}
static int reject(void *u,const uint8_t *m){(void)u;(void)m;++calls;return 0;}
static void move(uint8_t *m,char letter,unsigned rank){memset(m,0,34);m[0]=(uint8_t)letter;m[18]=(uint8_t)(rank>>8);m[19]=(uint8_t)rank;}
int main(void){MavenCandidateList list={0};uint8_t m[34],board[544]={0};int i;
 for(i=0;i<10;++i){move(m,(char)('a'+i),(unsigned)(100-i));assert(maven_insert_ranked_candidate(&list,m,duplicate,&list));}
 assert(list.count==10&&calls==10&&list.cutoff_bits==91);
 move(m,'z',91);assert(!maven_insert_ranked_candidate(&list,m,duplicate,&list)&&calls==10);
 move(m,'a',99);assert(!maven_insert_ranked_candidate(&list,m,duplicate,&list)&&calls==11);
 move(m,'f',101);assert(maven_insert_ranked_candidate(&list,m,duplicate,&list)&&calls==12);
 assert(list.count==10&&list.moves[0][0]=='f'&&list.moves[1][0]=='a'&&list.moves[9][0]=='j');
 move(m,'z',102);assert(maven_insert_ranked_candidate(&list,m,duplicate,&list));assert(list.count==10&&list.moves[9][0]=='i'&&list.cutoff_bits==92);
 move(m,'x',0);m[32]=16;m[33]=7;board[16*17+7]='a';board[15*17+8]='b';
 calls=0;assert(maven_candidate_is_eligible(m,board,1,0,0));
 board[17*17+8]='c';assert(!maven_candidate_is_eligible(m,board,1,reject,0)&&calls==0);
 assert(!maven_candidate_is_eligible(m,board,2,reject,0)&&calls==1);
 memset(board,0,sizeof board);m[32]=30;board[31*17+7]='x';assert(maven_candidate_is_eligible(m,board,1,0,0));
 board[29*17+7]='y';assert(!maven_candidate_is_eligible(m,board,1,0,0));
 m[32]=15;assert(maven_candidate_is_eligible(m,board,1,0,0));
 return 0;}
'''
        with tempfile.TemporaryDirectory() as tmp:
            src=Path(tmp)/'test.c';src.write_text(source);exe=Path(tmp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=undefined,address','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/candidate_ranking.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
