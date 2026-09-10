from pathlib import Path
import subprocess
import tempfile
import unittest

class WordBoundaryTests(unittest.TestCase):
    def test_contextual_punctuation(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "word_boundary.h"
#include <assert.h>
int main(void){
    uint8_t t[256]={0};unsigned i;t['a']=128;t['Z']=64;t['1']=16;t['2']=16;
    assert(!maven_is_word_separator(1,10,'1',',','2',t));
    assert(maven_is_word_separator(0,10,'1',',','2',t));
    assert(maven_is_word_separator(1,10,'a',',','2',t));
    assert(!maven_is_word_separator(0,10,0,'.','2',t));
    assert(maven_is_word_separator(1,10,'1','.','a',t));
    assert(!maven_is_word_separator(1,10,'a','\'','Z',t));
    assert(!maven_is_word_separator(1,10,'1',0xd5,'2',t));
    assert(maven_is_word_separator(1,10,'a','\'',' ',t));
    assert(maven_is_word_separator(0,10,'a','\'','Z',t));
    for(i=0;i<256;++i)assert(!maven_is_word_separator(10,10,0,(uint8_t)i,0,t));
    assert(!maven_is_word_separator(1,10,0,'-',0,t));
    assert(!maven_is_word_separator(1,10,0,0xca,0,t));
    assert(maven_is_word_separator(1,10,0,' ',0,t));
    assert(!maven_is_word_separator(1,10,0,'Z',0,t));
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/word_boundary.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
