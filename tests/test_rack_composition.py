from pathlib import Path
import subprocess
import tempfile
import unittest

class RackCompositionTests(unittest.TestCase):
    def test_weighted_recurrence_truncation_and_overflow(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "rack_composition.h"
#include "rack_balance.h"
#include <assert.h>
static uint32_t table[]={100,400,900};
static uint32_t evaluate(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t n){(void)u;return maven_rack_composition(v,c,pv,pc,n,table);}
static void diagnostic(void *u){(void)u;assert(0);}
int main(void){uint32_t terminal[]={100,400,900};MavenRackBalanceCache cache={{0},0,0,0,evaluate,diagnostic};
 assert(maven_rack_balance_cached(&cache,1,0,2,1,1)==(uint32_t)(int32_t)-100);
 assert(maven_rack_composition(1,0,2,1,2,terminal)==200);
 assert(maven_rack_composition(0,0,2,1,2,terminal)==300);
 assert(maven_rack_composition(1,1,0,0,2,terminal)==400);
 assert(maven_rack_composition(0,0,0,0,1,terminal)==250);
 assert(maven_rack_composition(0,0,-5,0,1,terminal)==250);
 terminal[0]=UINT32_MAX;terminal[1]=0;
 assert(maven_rack_composition(0,0,1,1,1,terminal)==0);
 terminal[0]=0;terminal[1]=0x7fffffff;
 assert(maven_rack_composition(0,0,0,2,1,terminal)==UINT32_MAX);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/rack_composition.c'),str(root/'reconstruction/rack_balance.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
