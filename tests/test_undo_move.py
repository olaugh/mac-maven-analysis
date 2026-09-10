from pathlib import Path
import subprocess
import tempfile
import unittest


class UndoMoveTests(unittest.TestCase):
    def test_paired_cells_saved_rack_and_row_zero(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "undo_move.h"
#include <assert.h>
#include <string.h>
static int diagnostics;static void diagnostic(void *u){(void)u;++diagnostics;}
int main(void){uint8_t board[544],undo[33]={8,7,8,255,'a','b','c',0},rack[16];uint16_t values[544];int16_t counter=3;unsigned i;
 MavenMoveUndo s={board,values,undo,&counter,diagnostic,0};
 memset(board,1,sizeof board);for(i=0;i<544;i++)values[i]=123;
 maven_undo_move(rack,&s);assert(!strcmp((char *)rack,"abc")&&counter==3&&!diagnostics);
 for(i=0;i<544;i++){int cleared=i==8*17+7||i==8*17+8||i==22*17+8||i==23*17+8;assert(board[i]==!cleared);assert(values[i]==(cleared?0:123));}
 memset(undo,0,sizeof undo);undo[1]=255;memcpy(undo+2,"abcdefg",8);counter=-32768;board[0]='x';
 maven_undo_move(rack,&s);assert(counter==32767&&!strcmp((char *)rack,"abcdefg")&&!diagnostics);
 for(i=0;i<17;i++)assert(!board[i]);
 undo[1]=0;board[0]='x';undo[2]=0;maven_undo_move(rack,&s);assert(diagnostics==2&&!rack[0]);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            *[str(root/'reconstruction'/p) for p in ['undo_move.c','board_state.c']],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
