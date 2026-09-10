from pathlib import Path
import subprocess
import tempfile
import unittest

class DrawingTextSizeTests(unittest.TestCase):
    def test_full_word_domain(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "drawing_text_size.h"
#include <assert.h>
static int trapped,called;static int16_t result;
static void debug(void *u){(void)u;assert(!called);++trapped;}
static void text_size(void *u,int16_t size){(void)u;result=size;++called;}
int main(void){
 int32_t n;
 for(n=-32768;n<=32767;++n){
  int expected=n==12?10:n==14?12:n==15?13:(n==18||n==20)?14:(n==26||n==28)?24:-123;
  trapped=called=0;
  maven_set_drawing_text_size((int16_t)n,-123,0,debug,text_size);
  assert(called==1 && result==expected && trapped==(expected==-123));
 }
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/drawing_text_size.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
