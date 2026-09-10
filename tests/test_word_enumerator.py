"""Instruction-derived enumeration contracts, including recursive restoration."""
from pathlib import Path
import subprocess
import tempfile
import unittest


class WordEnumeratorTests(unittest.TestCase):
    def test_enumeration_constraints_and_restoration(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "word_enumerator.h"
#include <assert.h>
#include <string.h>
static uint8_t records[24];
static MavenDictionarySection sections[3];
static MavenWordEnumeration s;
static char emitted[8][32];
static int emitted_count;
static void put(unsigned i,uint32_t value) {
    records[i*4]=(uint8_t)(value>>24); records[i*4+1]=(uint8_t)(value>>16);
    records[i*4+2]=(uint8_t)(value>>8); records[i*4+3]=(uint8_t)value;
}
static void append(void *user,const uint8_t *word) {
    (void)user; assert(emitted_count<8);
    strcpy(emitted[emitted_count++],(const char *)word);
}
static void reset(void) {
    memset(&s,0,sizeof s);memset(emitted,0,sizeof emitted);emitted_count=0;
    s.sections=sections;s.minimum_length=2;s.maximum_length=2;
    s.prefix=(const uint8_t *)"";s.suffix=(const uint8_t *)"";
    s.required_letters=(const uint8_t *)"";s.append_word=append;
    s.available['a']=1;s.available['?']=1;
}
static void restored(void) {
    assert(s.length==0 && s.blanks_used==0 && s.available['?']==1);
    assert(s.available['a']==1);
    assert(s.occurrences['a']==0 && s.occurrences['t']==0);
}
int main(void) {
    /* a, aa, at, ta; two identical sections exercise duplicate suppression. */
    put(1,(3u<<10)|0x100u|'a');put(2,(5u<<10)|0x200u|'t');
    put(3,0x100u|'a');put(4,0x300u|'t');put(5,0x300u|'a');
    sections[0].records=records;sections[0].root_index=1;
    sections[1]=sections[0];sections[2].root_index=0;
    reset();maven_enumerate_section(&s);restored();
    assert(emitted_count==3 && s.result_count==3);
    assert(!strcmp(emitted[0],"aa") && !strcmp(emitted[1],"at") && !strcmp(emitted[2],"ta"));
    s.current_section=1;maven_enumerate_section(&s);restored();
    assert(emitted_count==3 && s.result_count==3);

    reset();s.prefix=(const uint8_t *)"a?";s.suffix=(const uint8_t *)"t";
    s.suffix_length=1;s.required_counts['?']=1;
    maven_enumerate_section(&s);restored();
    assert(emitted_count==1 && !strcmp(emitted[0],"at"));

    reset();s.required_letters=(const uint8_t *)"t";s.required_counts['t']=2;
    maven_enumerate_section(&s);restored();assert(emitted_count==0);

    reset();s.available['a']=2;s.required_counts['?']=1;
    maven_enumerate_section(&s);
    assert(emitted_count==2 && !strcmp(emitted[0],"at") && !strcmp(emitted[1],"ta"));
    assert(s.available['a']==2 && s.available['?']==1 && s.blanks_used==0);
    /* No alternate blank path is tried for aa when two real A tiles exist. */

    reset();s.result_count=999;maven_enumerate_section(&s);restored();
    assert(emitted_count==1 && s.result_count==1000 && !strcmp(emitted[0],"aa"));
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror',
                            '-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/word_enumerator.c'),
                            str(root/'reconstruction/dictionary_lookup.c'),
                            '-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)


if __name__=='__main__':unittest.main()
