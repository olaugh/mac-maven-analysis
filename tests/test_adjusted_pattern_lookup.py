from pathlib import Path
import subprocess
import tempfile
import unittest

class AdjustedPatternLookupTests(unittest.TestCase):
    def test_baseline_correction_pointer_semantics_and_word_wrap(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "adjusted_pattern_lookup.h"
#include <assert.h>
#include <stddef.h>
int main(void){uint8_t records[84]={0},counts[128]={0},distribution[128]={0};uint32_t scores[27][8]={{0}},*p;int i;
 MavenPatternEntry entries[]={{(const uint8_t *)"a",0,1},{(const uint8_t *)"aa",0,2}};
 records[55]=20;records[83]=40;for(i=0;i<8;++i)scores[1][i]=(uint32_t)(i*100);
 counts['a']=1;distribution['a']=6;
 assert(maven_lookup_pattern_with_letter_expectation(entries,2,(const uint8_t *)"a",records,&p,7,counts,distribution,scores)==-11&&p==&entries[0].accumulator);
 assert(maven_lookup_pattern_with_letter_expectation(entries,0,(const uint8_t *)"a",records,&p,7,counts,distribution,scores)==-31&&p==NULL);
 assert(maven_lookup_pattern_with_letter_expectation(entries,2,(const uint8_t *)"aa",records,&p,0,NULL,NULL,NULL)==40&&p==&entries[1].accumulator);
 assert(maven_lookup_pattern_with_letter_expectation(entries,2,(const uint8_t *)"",records,&p,0,NULL,NULL,NULL)==0&&p==NULL);
 records[54]=127;records[55]=248;counts['a']=100;distribution['a']=1;
 assert(maven_lookup_pattern_with_letter_expectation(entries,2,(const uint8_t *)"a",records,&p,100,counts,distribution,scores)==-32176);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),*[str(root/'reconstruction'/n) for n in ('adjusted_pattern_lookup.c','pattern_lookup.c','letter_expectation.c')],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
