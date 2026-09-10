from pathlib import Path
import subprocess
import tempfile
import unittest

class TextFilterTests(unittest.TestCase):
    def test_ascii_removal_and_in_place_copy(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "text_filter.h"
#include <assert.h>
#include <string.h>
int main(void) {
    uint8_t b[256],out[256];unsigned i;
    const uint8_t *digits=(const uint8_t *)"0123456789";
    strcpy((char *)b," -32x7.68 ");
    assert(maven_filter_ascii(b,b,digits)==1);
    assert(!strcmp((char *)b,"32768"));
    assert(maven_filter_ascii(b,out,digits)==0);
    assert(!strcmp((char *)out,"32768"));
    for(i=1;i<128;++i)b[i-1]=(uint8_t)i;b[127]=0;
    assert(maven_filter_ascii(b,b,digits)==1);
    assert(!strcmp((char *)b,"0123456789"));
    strcpy((char *)b,"x");assert(maven_filter_ascii(b,b,digits)==1 && b[0]==0);
    assert(maven_filter_ascii(b,b,digits)==0);
    strcpy((char *)b,"CAT? xyz!");
    assert(maven_filter_ascii(b,b,(const uint8_t *)"?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")==1);
    assert(!strcmp((char *)b,"CAT?xyz"));
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/text_filter.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
