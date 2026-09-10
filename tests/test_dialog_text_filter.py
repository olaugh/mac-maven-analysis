from pathlib import Path
import subprocess
import tempfile
import unittest

class DialogTextFilterTests(unittest.TestCase):
    def test_filter_side_effect_order(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "dialog_text_filter.h"
#include <assert.h>
#include <string.h>
typedef struct {int stage; const char *input; const char *expected;} Fixture;
static void read_field(void *user,int16_t item,uint8_t text[256]) {
    Fixture *f=user;assert(f->stage++==0 && item==11);
    strcpy((char *)text,f->input);
}
static void beep(void *user,int16_t duration) {
    Fixture *f=user;assert(f->stage++==1 && duration==15);
}
static void rewrite(void *user,int16_t item,const uint8_t *text) {
    Fixture *f=user;assert(f->stage++==2 && item==11);
    assert(!strcmp((const char *)text,f->expected));
}
static int event_stage;
static const int16_t items[6]={2,3,4,5,11,13};
static void dispatch(void *user,const void *event) {
    (void)user; assert(event && event_stage++==0);
}
static void read_event_field(void *user,int16_t item,uint8_t text[256]) {
    (void)user; assert(event_stage>=1 && event_stage<=6);
    assert(item==items[event_stage-1]); ++event_stage;
    strcpy((char *)text,item<6 ? "CAT?" : "15");
}
int main(void) {
    Fixture f={0,"32768","32768"};
    MavenDialogFilterOps ops={&f,read_field,beep,rewrite};
    const uint8_t *allowed=(const uint8_t *)"0123456789";
    maven_filter_dialog_field(&ops,11,allowed);assert(f.stage==1);
    f.stage=0;f.input="x";f.expected="";
    maven_filter_dialog_field(&ops,11,allowed);assert(f.stage==3);
    f.stage=0;f.input="-12a";f.expected="12";
    maven_filter_dialog_field(&ops,11,allowed);assert(f.stage==3);
    f.stage=0;f.input="";
    maven_filter_dialog_field(&ops,11,allowed);assert(f.stage==1);
    ops.read_field=read_event_field;
    event_stage=0;
    maven_word_list_text_event(&ops,dispatch,&f,
        (const uint8_t *)"?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",allowed);
    assert(event_stage==7);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/dialog_text_filter.c'),str(root/'reconstruction/text_filter.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
