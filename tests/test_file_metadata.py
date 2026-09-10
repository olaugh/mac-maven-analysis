from pathlib import Path
import subprocess
import tempfile
import unittest


class FileMetadataTests(unittest.TestCase):
    def test_wire_layout_error_outputs_and_wrap(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "file_metadata.h"
#include <assert.h>
static int calls,mode;
static int16_t get(void *user,uint8_t *p,uint8_t async) {
    unsigned i;
    assert(user==&calls && !async);
    ++calls;
    for(i=0;i<122;i++)
        assert(p[i]==(i>=18 && i<=21 ? (uint8_t)(0x12345678u >> (8*(21-i))) : 0));
    if(mode==0) { p[76]=0xde;p[77]=0xad;p[78]=0xbe;p[79]=0xef;return 0; }
    if(mode==1) return -43;
    /* Distinct logical lengths must not enter the physical-size sum. */
    p[57]=11;p[67]=23;
    p[58]=0xff;p[59]=0xff;p[60]=0xff;p[61]=0xf0;
    p[71]=0x30;
    return -36;
}
int main(void) {
    MavenFileMetadataOps ops={&calls,get};uint32_t result=0;
    assert(!maven_file_modification_time(0x12345678,&result,&ops));
    assert(result==0xdeadbeef && calls==1);
    mode=1;assert(maven_file_modification_time(0x12345678,&result,&ops)==-43);
    assert(!result && calls==2);
    mode=2;assert(maven_file_physical_size(0x12345678,&result,&ops)==-36);
    assert(result==0x20 && calls==3);
    mode=1;assert(maven_file_physical_size(0x12345678,&result,&ops)==-43);
    assert(!result && calls==4);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror',
                            '-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/file_metadata.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
