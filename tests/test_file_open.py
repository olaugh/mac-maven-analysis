from pathlib import Path
import subprocess
import tempfile
import unittest


class FileOpenTests(unittest.TestCase):
    def test_create_retry_and_error_precedence(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "file_open.h"
#include <assert.h>
#include <string.h>
static int mode,opens,n;static char calls[32];static uint8_t name[]={1,'x'},app[]={1,'m'};
static void event(char c){calls[n++]=c;calls[n]=0;}
static int16_t open_file(void *u,const uint8_t *p,int16_t v,int16_t *r){(void)u;assert(p==name&&v==-2);event('o');*r=7;++opens;return mode==1&&opens==1?-43:mode==4?-54:0;}
static int16_t truncate_file(void *u,int16_t r,uint32_t size){(void)u;assert(r==7&&!size);event('t');return mode==2?-36:0;}
static int16_t info(void *u,const uint8_t *p,int16_t v,uint8_t *f){(void)u;(void)f;assert(p==app&&!v);event('i');return -43;}
static int16_t create(void *u,const uint8_t *p,int16_t v,uint32_t creator,uint32_t type){(void)u;assert(p==name&&v==-2&&creator==0x54455354&&type==0x54455854);event('c');return mode==2?-48:0;}
int main(void){
 MavenFileOpenOps ops={0,open_file,truncate_file,info,create};uint8_t scratch[16]={0,0,0,0,'T','E','S','T'};int16_t ref;
 const char *expected[]={"ot","oicot","otic","o","oico"};int16_t errors[]={0,0,-48,0,-54};
 for(mode=0;mode<5;mode++) {n=0;opens=0;calls[0]=0;assert(maven_open_or_create_file(name,-2,&ref,mode!=3,0x54455854,app,scratch,&ops)==errors[mode]);assert(!strcmp(calls,expected[mode]));}
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/file_open.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
