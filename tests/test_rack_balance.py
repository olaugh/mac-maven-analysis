from pathlib import Path
import subprocess
import tempfile
import unittest

class RackBalanceTests(unittest.TestCase):
    def test_cache_key_zero_sentinel_and_blank_policies(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "rack_balance.h"
#include <assert.h>
#include <string.h>
static int calls,diagnostics,total_seen,zero;
static void diagnostic(void *u){(void)u;++diagnostics;}
static uint32_t composition(void *u,int16_t v,int16_t c,int16_t pv,int16_t pc,int16_t total){
 (void)u;(void)pv;(void)pc;++calls;total_seen=total;return zero?0:(uint32_t)(v*100+c*10+total);}
int main(void){MavenRackBalanceCache s={{0},0,0,0,composition,diagnostic};uint32_t result;
 result=maven_rack_balance_cached(&s,2,1,20,30,7);assert(result==210&&calls==2&&total_seen==7);
 result=maven_rack_balance_cached(&s,2,1,20,30,0);assert(result==210&&calls==2); /* draws not in key */
 assert(!maven_rack_balance_cached(&s,0,0,99,99,0)&&s.pool_vowels==20&&calls==2);
 maven_rack_balance_cached(&s,2,1,21,30,0);assert(calls==4&&total_seen==3);
 zero=1;maven_rack_balance_cached(&s,1,1,21,30,0);maven_rack_balance_cached(&s,1,1,21,30,0);assert(calls==8);
 zero=0;memset(s.entries,0,sizeof s.entries);
 result=maven_rack_balance_with_blanks(&s,1,1,2,21,30,2);assert(result==310);
 result=maven_rack_balance_with_blanks(&s,1,1,1,21,30,2);assert(result==165);
 result=maven_rack_balance_with_blanks(&s,1,1,3,21,30,2);assert(result==110);
 maven_rack_balance_cached(&s,1,1,21,30,-1);assert(diagnostics==1);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/rack_balance.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
