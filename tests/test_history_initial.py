from pathlib import Path
import json
import subprocess
import tempfile
import unittest


class InitialHistoryTests(unittest.TestCase):
    def test_captured_racks_and_selector(self):
        root=Path(__file__).resolve().parents[1]
        capture=json.loads((root/'analysis/toolchain/save-new-game-live.json').read_text())
        payload=bytes.fromhex(capture['writes'][2]['bytes_hex'])
        source=r'''
#include "history_initial.h"
#include <assert.h>
#include <string.h>
static uint8_t payload[]={PAYLOAD};
int main(void){MavenInitialHistoryState s;unsigned i;
 memset(&s,0x55,sizeof s);maven_restore_initial_history(payload,&s);
 for(i=0;i<sizeof s.board_bytes;i++)assert(!s.board_bytes[i]);
 for(i=0;i<sizeof s.auxiliary_bytes;i++)assert(!s.auxiliary_bytes[i]);
 assert(!strcmp((char *)s.racks[0],"aceekoq"));assert(!strcmp((char *)s.racks[1],"oriaate"));
 assert(s.selected_rack==s.racks[1]&&!s.totals[0]&&!s.totals[1]);
 payload[2]=0x80;maven_restore_initial_history(payload,&s);assert(s.selected_rack==s.racks[0]);
 return 0;}
'''.replace('PAYLOAD',','.join(str(b) for b in payload))
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/history_initial.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
