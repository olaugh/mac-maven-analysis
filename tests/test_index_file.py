from pathlib import Path
import subprocess
import tempfile
import unittest


class IndexFileTests(unittest.TestCase):
    def test_scan_boundary_and_error_frame(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "index_file.h"
#include <assert.h>
#include <string.h>
static MavenErrorContext errors;
static uint8_t data[128];static uint32_t length,record_index;static int missing;
static const char error[]="load";
static const uint8_t *load(const void *name,short volume,uint32_t *size) {
 assert(name==data && volume==0);*size=length;return missing?0:data;
}
static void succeeds(unsigned position) {
 memset(data,0,sizeof data);data[position*4+3]='a';errors.depth=0;
 if(MAVEN_SAVE_ERROR_CONTEXT(&errors))assert(0);
 assert(maven_load_index_and_find_a(data,&record_index,load,&errors,error)==data);
 assert(record_index==position && errors.depth==1);errors.depth=0;
}
static void fails(void) {
 errors.depth=0;
 if(!MAVEN_SAVE_ERROR_CONTEXT(&errors)) {
  maven_load_index_and_find_a(data,&record_index,load,&errors,error);assert(0);
 }
 assert(errors.depth==0 && errors.pending_error==error);
}
int main(void) {
 length=128;succeeds(30);succeeds(5);
 memset(data,0,sizeof data);data[31*4+3]='a';fails(); /* last record skipped */
 memset(data,0,sizeof data);data[4*4+3]='a';fails(); /* below last examined */
 missing=1;fails();missing=0;length=8;fails();
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/index_file.c'),str(root/'reconstruction/error_context.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
