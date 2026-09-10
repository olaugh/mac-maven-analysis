from pathlib import Path
import subprocess
import tempfile
import unittest

class PatternCacheTests(unittest.TestCase):
    def test_filter_sort_diagnostics_and_reuse(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "pattern_cache.h"
#include <assert.h>
#include <stdlib.h>
#include <string.h>
static int allocations,errors;
static void *alloc(void *u,size_t n){(void)u;++allocations;return malloc(n?n:1);}
static void diagnostic(void *u){(void)u;++errors;}
int main(void){
 const uint8_t strings[]="zz\0ab\0a\0bb\0ba\0ab";
 uint8_t records[64]={0};MavenPatternCache c={0,0};int i;
 int offsets[]={0,0,3,6,8,11,14,3};
 for(i=0;i<8;++i){records[i*8+3]=(uint8_t)offsets[i];records[i*8+5]=(uint8_t)(i+1);}
 records[6*8+6]=1;records[7*8+5]=0;
 maven_prepare_pattern_cache(&c,records,8,strings,alloc,diagnostic,0);
 assert(allocations==1&&errors==1&&c.count==5);
 assert(!strcmp((char *)c.entries[0].letters,"a"));
 assert(!strcmp((char *)c.entries[1].letters,"ab"));
 assert(!strcmp((char *)c.entries[2].letters,"ba"));
 assert(!strcmp((char *)c.entries[3].letters,"bb"));
 assert(!strcmp((char *)c.entries[4].letters,"zz"));
 assert(c.entries[0].table_index==4&&c.entries[4].table_index==2);
 for(i=0;i<c.count;++i)assert(c.entries[i].accumulator==0);
 c.entries[0].accumulator=123;
 maven_prepare_pattern_cache(&c,records,8,strings,alloc,diagnostic,0);
 assert(allocations==1&&errors==1&&c.entries[0].accumulator==123);free(c.entries);
 c.entries=0;c.count=0;records[6*8+6]=0;
 maven_prepare_pattern_cache(&c,records,8,strings,alloc,diagnostic,0);
 assert(c.count==6&&errors==3);free(c.entries);
 c.entries=0;c.count=0;
 maven_prepare_pattern_cache(&c,records,1,strings,alloc,diagnostic,0);
 assert(c.count==0);free(c.entries);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/pattern_cache.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
