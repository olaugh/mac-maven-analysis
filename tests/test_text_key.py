from pathlib import Path
import subprocess
import tempfile
import unittest

class TextKeyTests(unittest.TestCase):
    def test_operation_order_and_return_values(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "text_key.h"
#include <assert.h>
#include <string.h>
static int steps,handled;
static int16_t nav(void *u,uint8_t c,const void *e){(void)u;(void)c;assert(e);steps=steps*10+1;return handled;}
static void del(void *u){(void)u;steps=steps*10+2;}
static void insert(void *u,const uint8_t *s,uint32_t n){(void)u;assert(n==4 && !memcmp(s,"    ",4));steps=steps*10+3;}
static uint8_t quote(void *u,uint8_t c){(void)u;assert(c=='"');steps=steps*10+4;return 0xd2;}
static void key(void *u,int16_t c){(void)u;assert(c==-46);steps=steps*10+5;}
int main(void){
    MavenTextKeyOps ops={0,nav,del,insert,quote,key};
    const uint8_t *spaces=(const uint8_t *)"    ";
    assert(maven_text_key(&ops,9,0,0,&ops,spaces)==1 && steps==123);
    steps=0;assert(maven_text_key(&ops,27,0,0,&ops,spaces)==1 && steps==12);
    steps=0;assert(maven_text_key(&ops,'"',0,0,&ops,spaces)==1 && steps==145);
    steps=0;assert(maven_text_key(&ops,'"',0x100,0,&ops,spaces)==0 && steps==1);
    steps=0;assert(maven_text_key(&ops,'"',0,1,&ops,spaces)==0 && steps==1);
    steps=0;handled=1;assert(maven_text_key(&ops,9,0,0,&ops,spaces)==0 && steps==1);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/text_key.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
