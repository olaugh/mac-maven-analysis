from pathlib import Path
import subprocess
import tempfile
import unittest


class RackCountTests(unittest.TestCase):
    def test_alphabet_scope_order_and_byte_overflow(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "rack_counts.h"
#include <assert.h>
#include <string.h>
int main(void){uint8_t counts[128],out[400],rack[300];unsigned n;
 const uint8_t *alphabet=(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz";
 memset(counts,9,sizeof counts);maven_count_rack(counts,alphabet,(const uint8_t *)"oriaate?");
 assert(counts['a']==2&&counts['?']==1&&counts['!']==9&&counts['z']==0);
 maven_rack_from_counts(out,counts,alphabet);assert(!strcmp((char *)out,"?aaeiort"));
 for(n=0;n<=256;n++){memset(rack,'a',n);rack[n]=0;maven_count_rack(counts,alphabet,rack);
  assert(counts['a']==(uint8_t)n);maven_rack_from_counts(out,counts,alphabet);
  assert(strlen((char *)out)==(n<128?n:0));}
 counts['a']=2;counts['b']=1;maven_rack_from_counts(out,counts,(const uint8_t *)"ba");assert(!strcmp((char *)out,"baa"));
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/rack_counts.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
