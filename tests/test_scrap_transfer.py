from pathlib import Path
import subprocess
import tempfile
import unittest

class ScrapTransferTests(unittest.TestCase):
    def test_size_gate_second_read_and_unlock(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "scrap_transfer.h"
#include <assert.h>
static int calls;static int32_t first,second;static uint8_t data;
static int32_t get(void *u,uintptr_t h){(void)u;++calls;assert(h==(calls==1?0:123));return calls==1?first:second;}
static const uint8_t *lock(void *u,uintptr_t h){(void)u;assert(h==123 && calls++==0);return &data;}
static int32_t put(void *u,uint32_t n,const uint8_t *p){(void)u;assert(calls++==1 && n==65535 && p==&data);return -123;}
static void unlock(void *u,uintptr_t h){(void)u;assert(calls++==2 && h==123);}
int main(void){
 MavenScrapTransferOps o={0,get,lock,put,unlock};MavenTextScrap s={9,123};
 first=32001;assert(maven_import_text_scrap(&s,&o)==-501 && calls==1 && s.length==0);
 calls=0;first=-102;assert(maven_import_text_scrap(&s,&o)==-102 && calls==1 && s.length==0);
 calls=0;first=32000;second=32000;assert(!maven_import_text_scrap(&s,&o) && calls==2 && s.length==32000);
 calls=0;first=0;second=-101;assert(maven_import_text_scrap(&s,&o)==-101 && s.length==0);
 calls=0;first=1;second=65537;assert(!maven_import_text_scrap(&s,&o) && s.length==1);
 calls=0;s.length=65535;assert(maven_export_text_scrap(&s,&o)==-123 && calls==3 && s.length==65535);
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/scrap_transfer.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
