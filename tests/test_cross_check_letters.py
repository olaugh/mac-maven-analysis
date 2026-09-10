from pathlib import Path
import subprocess
import tempfile
import unittest

class CrossCheckLetterTests(unittest.TestCase):
    def test_prefix_leaf_missing_suffix_and_section_order(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "cross_check_letters.h"
#include <assert.h>
#include <string.h>
static void put(uint8_t *p,unsigned n){p[0]=(uint8_t)(n>>24);p[1]=(uint8_t)(n>>16);p[2]=(uint8_t)(n>>8);p[3]=(uint8_t)n;}
int main(void){uint8_t data[24]={0},out[16];MavenDictionarySection sections[]={{data,1},{data,1},{0,0}};
 put(data+4,(3u<<10)|'a');put(data+8,(5u<<10)|0x200|'b');put(data+12,0x100|'a');put(data+16,0x300|'b');put(data+20,0x300|'a');
 assert(maven_prefix_children(sections,(const uint8_t *)"")==1);assert(maven_prefix_children(sections,(const uint8_t *)"a")==3);
 assert(maven_prefix_children(sections,(const uint8_t *)"aa")==0);assert(maven_prefix_children(sections,(const uint8_t *)"ac")==-1);assert(maven_prefix_children(sections,(const uint8_t *)"aax")==-1);
 assert(maven_cross_check_letters(sections,(const uint8_t *)"a",(const uint8_t *)"",(const uint8_t *)"abz",out)==4&&!strcmp((const char *)out,"abab"));
 assert(maven_cross_check_letters(sections,(const uint8_t *)"",(const uint8_t *)"a",(const uint8_t *)"abz",out)==4&&!strcmp((const char *)out,"abab"));
 assert(maven_cross_check_letters(sections,(const uint8_t *)"",(const uint8_t *)"b",(const uint8_t *)"abz",out)==2&&!strcmp((const char *)out,"aa"));
 assert(maven_cross_check_letters(sections,(const uint8_t *)"aa",(const uint8_t *)"",(const uint8_t *)"abz",out)==0&&!out[0]);
 assert(maven_cross_check_letters(sections,(const uint8_t *)"",(const uint8_t *)"",(const uint8_t *)"abz",out)==0&&!out[0]);
 assert(maven_cross_check_letters(sections,(const uint8_t *)"a",(const uint8_t *)"",(const uint8_t *)"",out)==0&&!out[0]);return 0;}
'''
        with tempfile.TemporaryDirectory() as tmp:
            src=Path(tmp)/'test.c';src.write_text(source);exe=Path(tmp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/cross_check_letters.c'),str(root/'reconstruction/dictionary_lookup.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
