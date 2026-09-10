from pathlib import Path
import subprocess
import tempfile
import unittest

class ApplyMoveTests(unittest.TestCase):
    def test_blank_placement_callback_copy_and_row_zero(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "apply_move.h"
#include "rack_counts.h"
#include <assert.h>
#include <string.h>
static uint8_t board[544],counts[128],wm[544],lm[544],cls[128],undo[33];static uint16_t values[544],letters[128];static int diagnostics,callbacks;
static void diagnostic(void *u){(void)u;++diagnostics;}
static void scored(void *u,uint8_t *copy){(void)u;assert(!board[143]);assert(copy[16]==0&&copy[17]==0&&copy[18]==0&&copy[19]==100);copy[0]='z';++callbacks;}
int main(void){uint8_t move[34]="aa",rack[8]="a?i";unsigned i;
 MavenApplyState s={{board,values,counts,letters,wm,undo,diagnostic,0},lm,cls,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz",5,77,{4,5},{6,7},scored,0};
 memset(wm,1,sizeof wm);memset(lm,1,sizeof lm);memset(cls,128,sizeof cls);for(i=0;i<128;i++)letters[i]=100;
 move[32]=8;move[33]=7;maven_count_rack(counts,s.alphabet,rack);
 maven_apply_move_without_evaluation(move,rack,&s);
 assert(!diagnostics&&callbacks==1&&!strcmp((char *)rack,"i")&&s.row_zero_count==0&&s.new_tiles==2);
 assert(board[143]=='a'&&board[144]=='a'&&board[382]=='a'&&board[399]=='a');
 assert(!values[143]&&!values[382]&&values[144]==100&&values[399]==100);
 assert(undo[0]==8&&undo[1]==7&&undo[2]==8&&undo[3]==255&&!strcmp((char *)undo+4,"a?i"));
 /* Row-zero exchange branch: no scorer/callback, wraps counter, keeps scorer fields. */
 strcpy((char *)move,"i");move[32]=0;s.row_zero_count=32767;
 maven_apply_move_without_evaluation(move,rack,&s);
 assert(s.row_zero_count==-32768&&s.new_tiles==2&&callbacks==1&&!rack[0]);
 assert(board[0]=='i'&&!board[1]&&board[143]=='a'&&undo[0]==0&&undo[1]==255&&!strcmp((char *)undo+2,"i"));
 return 0;}
'''
        sources=['apply_move.c','score_move.c','score_accumulate.c','place_letters.c','move_finalize.c','board_state.c','rack_counts.c']
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),*[str(root/'reconstruction'/x) for x in sources],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
