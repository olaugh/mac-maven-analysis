from pathlib import Path
import subprocess
import tempfile
import unittest


class WholeFileTests(unittest.TestCase):
    def test_short_read_and_error_ownership(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "whole_file.h"
#include <assert.h>
#include <string.h>
static char logbuf[32];static unsigned n;static int mode;static uint8_t buffer[5];
static void logcall(char c){logbuf[n++]=c;logbuf[n]=0;}
static int16_t open_file(void *u,const uint8_t *p,int16_t v,int16_t *r){(void)u;assert(p[0]==1&&v==-2);logcall('o');*r=7;return mode==1?-1:0;}
static int16_t eof(void *u,int16_t r,uint32_t *l){(void)u;assert(r==7);logcall('e');*l=4;return mode==2?-2:0;}
static uint8_t *alloc(void *u,uint32_t l){(void)u;assert(l==5);logcall('a');memset(buffer,0,5);return mode==3?0:buffer;}
static int16_t read_file(void *u,int16_t r,uint32_t *l,uint8_t *p){(void)u;assert(r==7&&*l==4&&p==buffer);logcall('r');memcpy(p,"abcd",4);if(mode==5)*l=2;return mode==4?-4:0;}
static uint32_t size(void *u,uint8_t *p){(void)u;assert(p==buffer);logcall('s');return 5;}
static int16_t close_file(void *u,int16_t r){(void)u;assert(r==7);logcall('c');return mode==6?-6:0;}
static void dispose(void *u,uint8_t *p){(void)u;assert(p==buffer);logcall('d');}
int main(void){
 MavenWholeFileOps ops={0,open_file,eof,alloc,read_file,size,close_file,dispose};uint8_t name[]={1,'x'};
 const char *expected[]={"oearsc","o","oe","oea","oeard","oearsd","oearscd"};
 for(mode=0;mode<7;mode++) {uint32_t length=99;uint8_t *p;n=0;logbuf[0]=0;p=maven_read_whole_file(name,-2,&length,&ops);
  assert(!strcmp(logbuf,expected[mode]));assert((p!=0)==(mode==0));
  if(!mode)assert(!memcmp(p,"abcd\0",5));if(mode==5)assert(length==2);
 }
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/whole_file.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
