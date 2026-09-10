from pathlib import Path
import subprocess
import tempfile
import unittest


class SaveRecordTests(unittest.TestCase):
    def test_wire_bytes_ignored_errors_and_restore_order(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "save_record.h"
#include <assert.h>
static int stage,mode;static uint8_t payload[]={9,8,7,6,0x12,0x34};
static int16_t write_record(void *u,int16_t f,int32_t *n,const uint8_t *p) {
 (void)u;assert(f==7);
 if(stage==0){assert(*n==2 && p[0]==(mode?255:0) && p[1]==(mode?254:1));stage=1;}
 else if(stage==2){assert(*n==2 && p[0]==(mode?128:0) && p[1]==(mode?1:6));stage=3;}
 else {assert(stage==4 && p==payload && *n==(mode?-32767:6));assert(p[4]==(mode?0x12:0) && p[5]==(mode?0x34:0));stage=5;}
 *n=0;return -36; /* failure and short count do not stop later operations */
}
static int32_t size(void *u,uintptr_t h){(void)u;assert(h==42&&stage==1);stage=2;return mode?0x18001:6;}
static uint8_t *lock(void *u,uintptr_t h){(void)u;assert(h==42&&stage==3);stage=4;return payload;}
static void unlock(void *u,uintptr_t h){(void)u;assert(h==42&&stage==5);assert(payload[4]==(mode?0x12:0));stage=6;}
int main(void){MavenSaveRecordOps ops={0,write_record,size,lock,unlock};
 for(mode=0;mode<2;mode++){stage=0;maven_write_save_record(mode?-2:1,42,7,&ops);assert(stage==6&&payload[4]==0x12&&payload[5]==0x34);}return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/save_record.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
