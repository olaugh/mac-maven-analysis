from pathlib import Path
import subprocess
import tempfile
import unittest

class WordNavigationTests(unittest.TestCase):
    def test_scan_order_and_endpoints(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "word_navigation.h"
#include <assert.h>
static int locked,lock_calls,unlock_calls,nread,indices[32];
static const char *text="aa bb";
static void lock(void *u){(void)u;assert(!locked);locked=1;++lock_calls;}
static void unlock(void *u){(void)u;assert(locked);locked=0;++unlock_calls;}
static int16_t length(void *u){(void)u;assert(locked);return 5;}
static uint8_t separator(void *u,int16_t i){
    (void)u;assert(locked && i>=0 && i<=5 && nread<32);
    indices[nread++]=i;return text[i]==' ';
}
int main(void){
    MavenWordNavigationOps ops={0,lock,unlock,length,separator};
    assert(maven_find_word_edge(&ops,0,1)==1);
    assert(nread==2 && indices[0]==1 && indices[1]==2);
    nread=0;assert(maven_find_word_edge(&ops,1,1)==5);
    assert(nread==5 && indices[0]==2 && indices[1]==3 && indices[2]==4 && indices[3]==4 && indices[4]==5);
    nread=0;assert(maven_find_word_edge(&ops,5,-1)==3);
    assert(nread==4 && indices[0]==4 && indices[1]==3 && indices[2]==3 && indices[3]==2);
    nread=0;assert(maven_find_word_edge(&ops,0,-1)==0 && !nread);
    assert(maven_find_word_edge(&ops,5,1)==6 && !nread);
    assert(lock_calls==5 && unlock_calls==5 && !locked);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/word_navigation.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
