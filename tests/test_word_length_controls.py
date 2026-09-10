"""Replay captured field strings through the reconstructed caller and parser."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

class WordLengthControlTests(unittest.TestCase):
    def test_integrated_captured_queries(self):
        root=Path(__file__).resolve().parents[1]
        captures=[json.loads(p.read_text()) for p in [root/'analysis/toolchain'/f'length-controls-live-{name}.json' for name in ('default','overflow','inverted')]]
        self.assertEqual(len(captures),3)
        table=bytes.fromhex(captures[0]['calls'][0]['character_classes_hex'])
        source=r'''
#include "word_length_controls.h"
#include <assert.h>
#include <string.h>
typedef struct {int calls; const char *low; const char *high;} Fields;
static void read_field(void *user,int16_t item,uint8_t text[256]) {
    Fields *f=user;
    assert(item==(f->calls==0 ? 11 : 13));
    strcpy((char *)text,f->calls++==0 ? f->low : f->high);
}
'''
        source+='static const uint8_t table[256]={'+','.join(map(str,table))+'};\n'
        source+='int main(void) { int16_t low,high,error; Fields f;\n'
        source+='MavenLengthControlOps ops={&f,read_field,table,&error};\n'
        for capture in captures:
            calls=capture['calls']
            self.assertTrue(all(c['character_classes_hex']==table.hex() for c in calls))
            self.assertEqual(calls[0]['errno_after'],calls[1]['errno_before'])
            strings=[json.dumps(bytes.fromhex(c['text_hex']).decode('ascii')) for c in calls]
            source+=f'f.calls=0; f.low={strings[0]}; f.high={strings[1]}; error={calls[0]["errno_before"]};\n'
            source+='low=99; high=99; maven_read_word_length_controls(&ops,&low,&high);\n'
            source+=f'assert(f.calls==2 && low=={capture["limits"][0]} && high=={capture["limits"][1]} && error=={calls[1]["errno_after"]});\n'
        source+='return 0;}\n'
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/word_length_controls.c'),str(root/'reconstruction/decimal_scan.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
