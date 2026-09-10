from pathlib import Path
import subprocess
import tempfile
import unittest

class SmartQuoteTests(unittest.TestCase):
    def test_context_decisions(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "smart_quotes.h"
#include <assert.h>
int main(void) {
    uint8_t table[256]={0};unsigned c;table[' ']=4;
    assert(maven_smart_quote('"',0,'x',table)==0xd2);
    assert(maven_smart_quote('\'',0,'x',table)==0xd4);
    assert(maven_smart_quote('"',1,'x',table)==0xd3);
    assert(maven_smart_quote('\'',1,'x',table)==0xd5);
    for(c=0;c<256;++c) {
        int open=c==' ' || c=='(' || c=='[' || c=='{' || c=='<' || c==0xca;
        assert(maven_smart_quote('"',1,(uint8_t)c,table)==(open || c==0xd4 ? 0xd2 : 0xd3));
        assert(maven_smart_quote('\'',1,(uint8_t)c,table)==(open || c==0xd2 ? 0xd4 : 0xd5));
        if(c!='"' && c!='\'')assert(maven_smart_quote((uint8_t)c,0,0,table)==c);
    }
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/smart_quotes.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
