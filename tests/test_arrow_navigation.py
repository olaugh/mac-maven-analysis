from pathlib import Path
import subprocess
import tempfile
import unittest

class ArrowNavigationTests(unittest.TestCase):
    def test_modifier_precedence_and_selection_updates(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "arrow_navigation.h"
#include <assert.h>
static int16_t a,b;static int locks,unlocks,edges,selects;
static int16_t start(void *u){(void)u;return a;}
static int16_t end(void *u){(void)u;return b;}
static void select_range(void *u,int32_t x,int32_t y){(void)u;a=(int16_t)x;b=(int16_t)y;++selects;}
static void lock(void *u){(void)u;++locks;}
static void unlock(void *u){(void)u;++unlocks;}
static uint8_t sep(void *u,int16_t p){(void)u;(void)p;return 0;}
static int16_t edge(void *u,int16_t p,int16_t d){(void)u;++edges;return p+2*d;}
int main(void){
 MavenArrowOps o={0,start,end,select_range,lock,unlock,sep,edge};
 a=5;b=8;assert(!maven_arrow_navigation(&o,28,0) && a==5 && b==5);
 a=5;b=8;assert(!maven_arrow_navigation(&o,29,0) && a==8 && b==8);
 a=5;b=8;assert(maven_arrow_navigation(&o,28,0x200) && a==4 && b==8);
 a=5;b=8;assert(maven_arrow_navigation(&o,29,0x200) && a==5 && b==9);
 a=5;b=8;assert(!maven_arrow_navigation(&o,29,0x100) && a==32767 && b==32767);
 a=5;b=8;assert(maven_arrow_navigation(&o,28,0xb00) && a==0 && b==8 && edges==0);
 a=5;b=8;assert(maven_arrow_navigation(&o,28,0xa00) && a==3 && b==11);
 assert(locks==1 && unlocks==1 && edges==2);
 a=5;b=8;assert(maven_arrow_navigation(&o,29,0xa00) && a==3 && b==11);
 assert(locks==2 && unlocks==2 && edges==4);
 a=5;b=8;assert(maven_arrow_navigation(&o,29,0x800) && a==11 && b==11);
 selects=0;assert(!maven_arrow_navigation(&o,'a',0) && !selects);
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/arrow_navigation.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
