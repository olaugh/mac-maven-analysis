from pathlib import Path
import subprocess
import tempfile
import unittest

class ClipboardTests(unittest.TestCase):
    def test_count_refresh_and_failed_export(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "clipboard_sync.h"
#include <assert.h>
static int calls;static int16_t count=3;
static int16_t get_count(void *u){(void)u;calls=calls*10+1;return count;}
static int16_t import_text(void *u){(void)u;calls=calls*10+2;count=4;return -1;}
static int32_t zero(void *u){(void)u;calls=calls*10+3;return 0x1234ffff;}
static int16_t export_text(void *u){(void)u;calls=calls*10+4;return -1;}
int main(void){
 MavenClipboardOps ops={0,get_count,import_text,zero,export_text};
 MavenClipboardState s={3,0};
 maven_import_changed_clipboard(&s,&ops);assert(calls==1 && s.cached_count==3);
 calls=0;s.cached_count=2;maven_import_changed_clipboard(&s,&ops);
 assert(calls==121 && s.cached_count==4);
 calls=0;maven_export_dirty_clipboard(&s,&ops);assert(!calls);
 s.dirty=-1;maven_export_dirty_clipboard(&s,&ops);
 assert(calls==34 && s.cached_count==-1 && s.dirty==0);
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/clipboard_sync.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
