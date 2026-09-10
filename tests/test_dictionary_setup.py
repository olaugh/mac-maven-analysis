from pathlib import Path
import subprocess
import tempfile
import unittest


class DictionarySetupTests(unittest.TestCase):
    def test_diagnostic_reloads_and_load_error(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "dictionary_setup.h"
#include <assert.h>
static uint8_t data[160];static MavenDictionaryTables state;
static MavenErrorContext errors;static int diagnostics;
static void diagnostic(void *user) {
 assert(user==data);++diagnostics;
 assert(state.roots[0]==1 && state.roots[1]==2);
 assert(state.tables[0]==data+12 && state.tables[1]==data+120);
 /* Original second check re-reads globals after the diagnostic returns. */
 if(diagnostics==1)state.roots[1]=3;
}
static int16_t fail_open(void *u,const uint8_t *n,int16_t v,int16_t *r) {
 (void)u;(void)r;assert(n==data && v==0);return -43;
}
int main(void) {
 MavenWholeFileOps ops={0,fail_open,0,0,0,0,0,0};
 data[7]=1;data[11]=2;data[135]='a';
 maven_install_dictionary(data,&state,diagnostic,data);
 assert(diagnostics==1 && state.roots[1]==3);
 errors.depth=0;
 if(!MAVEN_SAVE_ERROR_CONTEXT(&errors)) {
  maven_load_dictionary(data,&state,&ops,&errors,data,diagnostic,data);assert(0);
 }
 assert(errors.depth==0 && errors.pending_error==data && diagnostics==1);
 assert(state.roots[1]==3); /* load failure did not overwrite prior globals */
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            *[str(root/'reconstruction'/p) for p in ['dictionary_setup.c','dictionary_tables.c','whole_file.c','error_context.c']],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
