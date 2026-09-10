from pathlib import Path
import subprocess
import tempfile
import unittest

class PatternLookupTests(unittest.TestCase):
    def test_prefixes_zero_score_pointer_and_big_endian_value(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "pattern_lookup.h"
#include <assert.h>
#include <stddef.h>
int main(void){uint8_t records[84]={0};uint32_t *p;MavenPatternEntry e[]={{(const uint8_t *)"a",0,1},{(const uint8_t *)"aa",0,0},{(const uint8_t *)"b",0,2}};
 records[54]=255;records[55]=254;records[82]=1;records[83]=44;
 assert(maven_lookup_pattern(e,3,(const uint8_t *)"a",records,&p)==-2&&p==&e[0].accumulator);
 *p=42;assert(e[0].accumulator==42);
 assert(maven_lookup_pattern(e,3,(const uint8_t *)"aa",records,&p)==0&&p==&e[1].accumulator);
 assert(maven_lookup_pattern(e,3,(const uint8_t *)"b",records,&p)==300&&p==&e[2].accumulator);
 assert(maven_lookup_pattern(e,3,(const uint8_t *)"ab",records,&p)==0&&p==NULL);
 assert(maven_lookup_pattern(e,0,(const uint8_t *)"a",records,&p)==0&&p==NULL);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/pattern_lookup.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
