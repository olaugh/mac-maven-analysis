from pathlib import Path
import subprocess
import tempfile
import unittest

class RemainingTilesTests(unittest.TestCase):
    def test_blank_row_zero_edges_and_wrapped_counts(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "remaining_tiles.h"
#include <assert.h>
#include <string.h>
int main(void){uint8_t distribution[128]={0},board[544]={0},out[256];uint16_t values[544]={0};
 distribution['?']=2;distribution['a']=5;distribution['b']=2;
 board[0]='a'; /* row-zero zero value still consumes literal a */
 board[18]='a'; /* ordinary zero value consumes blank */
 board[19]='a';values[19]=100;
 board[16]='b';board[272]='b'; /* outside scanned columns/rows */
 assert(maven_collect_remaining_tiles(out,distribution,board,values,(const uint8_t *)"a",(const uint8_t *)"b",(const uint8_t *)"?ab")==4);
 assert(!strcmp((char *)out,"?aab"));
 memset(distribution,0,sizeof distribution);memset(board,0,sizeof board);
 assert(!maven_collect_remaining_tiles(out,distribution,board,values,(const uint8_t *)"a",(const uint8_t *)"",(const uint8_t *)"?ab"));
 distribution['b']=128;
 assert(!maven_collect_remaining_tiles(out,distribution,board,values,(const uint8_t *)"",(const uint8_t *)"",(const uint8_t *)"b"));
 distribution['b']=127;
 assert(maven_collect_remaining_tiles(out,distribution,board,values,(const uint8_t *)"",(const uint8_t *)"",(const uint8_t *)"b")==127);
 {uint8_t counts[128]={0},unseen[128];memset(board,0,sizeof board);memset(distribution,0,sizeof distribution);
 distribution['a']=5;distribution['?']=2;distribution['b']=1;distribution['!']=9;
 board[17]='a';values[17]=100;board[33]='a';values[33]=0;board[272]='b';counts['a']=2;counts['b']=2;
 assert(maven_count_unseen_tiles(unseen,distribution,board,values,counts,(const uint8_t *)"?ab")==3);
 assert(unseen['a']==2&&unseen['?']==1&&unseen['b']==0&&unseen['!']==9);}
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/remaining_tiles.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
