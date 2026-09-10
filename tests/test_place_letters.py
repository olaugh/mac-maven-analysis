from pathlib import Path
import json
import subprocess
import tempfile
import unittest


class PlaceLettersTests(unittest.TestCase):
    def test_saved_move_and_existing_tile_blank(self):
        root=Path(__file__).resolve().parents[1]
        j=json.loads((root/'analysis/toolchain/save-new-game-live.json').read_text())
        payload=bytes.fromhex(j['writes'][8]['bytes_hex'])
        source=r'''
#include "place_letters.h"
#include "rack_counts.h"
#include <assert.h>
#include <string.h>
static uint8_t board[544],counts[128],premium[544],undo[33];static uint16_t values[544],letters[128];static int diagnostics;
static void diagnostic(void *u){(void)u;diagnostics++;}
static uint8_t move[]={PAYLOAD};
int main(void){unsigned i;uint8_t rack[16];MavenPlacementResult r;
 MavenLetterPlacement s={board,values,counts,letters,premium,undo,diagnostic,0};
 for(i=0;i<128;i++)letters[i]=(uint16_t)(i+100);
 maven_count_rack(counts,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz",move+36);undo[0]=8;premium[8*17+7]=3;
 r=maven_place_move_letters(move,&s);assert(r.undo_end==7 && r.special_score==1400 && !diagnostics);
 for(i=0;i<6;i++){unsigned a=8*17+7+i,b=(22+i)*17+8;assert(board[a]==move[i]&&board[b]==move[i]);assert(values[a]==letters[move[i]]&&values[b]==values[a]);assert(undo[i+1]==7+i);}
 maven_rack_from_counts(rack,counts,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz");assert(!strcmp((char *)rack,"i"));
 /* Existing tiles consume no rack letters; a new missing letter consumes blank. */
 memset(counts,0,sizeof counts);counts['?']=1;move[0]='a';move[1]='b';move[2]=0;
 board[8*17+8]=board[23*17+8]=0;diagnostics=0;
 r=maven_place_move_letters(move,&s);assert(r.undo_end==2 && undo[1]==8 && !counts['?']&&!diagnostics);
 return 0;}
'''.replace('PAYLOAD',','.join(str(b) for b in payload))
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            *[str(root/'reconstruction'/p) for p in ['place_letters.c','board_state.c','rack_counts.c']],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
