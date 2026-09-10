from pathlib import Path
import subprocess
import tempfile
import unittest

class DialogKeyEventTests(unittest.TestCase):
    def test_branch_and_tab_contracts(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "dialog_key_event.h"
#include <assert.h>
static int16_t def,active;
static int got,activated,focused,selected,keys,debugged;
static int16_t default_item(void *u){(void)u;return def;}
static int16_t active_item(void *u){(void)u;return active;}
static int16_t header(void *u){(void)u;return 4;}
static void get(void *u,int16_t n,MavenDialogItem *out){
    (void)u;got=got*10+n;out->type=n==2 ? 16 : 4;out->handle=n;
}
static void activate(void *u,uintptr_t h,int16_t v){(void)u;assert(h==(uintptr_t)def && v==10);++activated;}
static void debug(void *u){(void)u;++debugged;}
static void focus(void *u,int16_t n){(void)u;focused=n;}
static void select_all(void *u){(void)u;assert(focused==2);++selected;}
static void key(void *u,const void *e,int16_t flag){(void)u;assert(e && flag==0);++keys;}
int main(void){
    MavenDialogKeyOps ops={0,default_item,active_item,header,get,activate,debug,focus,select_all,key};
    def=1;active=0;maven_dialog_key_event(&ops,13,&ops);assert(activated==1 && got==1 && !keys);
    def=0;maven_dialog_key_event(&ops,3,&ops);assert(!keys);
    maven_dialog_key_event(&ops,13,&ops);assert(keys==1);
    active=-1;maven_dialog_key_event(&ops,'a',&ops);assert(keys==1);
    active=2;got=0;maven_dialog_key_event(&ops,9,&ops);
    assert(got==412 && focused==2 && selected==1 && !debugged);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/dialog_key_event.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
