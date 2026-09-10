from pathlib import Path
import json
import subprocess
import tempfile
import unittest


class MoveFinalizeTests(unittest.TestCase):
    def test_boundaries_and_natural_undo_record(self):
        root=Path(__file__).resolve().parents[1]
        capture=json.loads((root/'analysis/toolchain/game-restore-live.json').read_text())
        expected=bytes.fromhex(capture['state']['undo'])
        source=r'''
#include "move_finalize.h"
#include <assert.h>
#include <string.h>
static unsigned diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
static const uint8_t expected[]={EXPECTED};
int main(void){unsigned i;uint16_t values[544];uint8_t undo[33]={8,7,8,9,10,11,12};
 uint8_t rack[32]="oriaate",counts[128]={0};
 for(i=0;i<544;i++)values[i]=(uint16_t)(i+1);
 maven_clear_recorded_move_values(values,8,6,8,13);
 for(i=0;i<544;i++)assert(values[i]==((i==142||i==149||i==365||i==484)?0:i+1));
 /* Reverse orientation follows exactly the same cell pairing. */
 for(i=0;i<544;i++)values[i]=(uint16_t)(i+1);
 maven_clear_recorded_move_values(values,21,8,28,8);
 for(i=0;i<544;i++)assert(values[i]==((i==142||i==149||i==365||i==484)?0:i+1));
 counts['i']=1;
 maven_finish_move_rack(undo,7,rack,counts,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz",diagnostic,0);
 assert(!memcmp(undo,expected,33)&&!strcmp((char *)rack,"i")&&!diagnostics);
 /* Exactly 31 triggers the original returning diagnostic; storage fits. */
 memset(rack,'a',24);rack[24]=0;
 maven_finish_move_rack(undo,7,rack,counts,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz",diagnostic,0);
 assert(diagnostics==1 && undo[7]==255 && undo[32]==0 && !strcmp((char *)rack,"i"));
 return 0;}
'''.replace('EXPECTED',','.join(str(x) for x in expected))
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),*[str(root/'reconstruction'/x) for x in ('move_finalize.c','board_state.c','rack_counts.c')],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
