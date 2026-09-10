from pathlib import Path
import subprocess
import tempfile
import unittest

class OpeningPlacementTests(unittest.TestCase):
    def test_blank_consumption_order_columns_adjustments_and_restoration(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "opening_placements.h"
#include <assert.h>
#include <string.h>
static int emitted;static const char *words[]={"aa","aa","ab","ab","ba","ba"};
static unsigned penalties[]={2,1,1,1,1,0};
static void put(uint8_t *p,unsigned n){p[0]=(uint8_t)(n>>24);p[1]=(uint8_t)(n>>16);p[2]=(uint8_t)(n>>8);p[3]=(uint8_t)n;}
static void emit(void *u,const MavenOpeningPlacement *p,const uint8_t *remaining){(void)u;
 assert(emitted<6);assert(!strcmp((const char *)p->word,words[emitted]));assert(p->row==8&&p->column==7+emitted%2&&p->section==0);
 assert(p->adjustment_bits==0u-penalties[emitted]);assert(!remaining['a']&&!remaining['?']);++emitted;}
int main(void){uint8_t data[24]={0},letters[544]={0},words_table[544]={0};MavenDictionarySection sections[]={{data,1},{0,0}};MavenOpeningEnumeration state={0};
 put(data+4,(3u<<10)|'a');put(data+8,(5u<<10)|0x200|'b');put(data+12,0x100|'a');put(data+16,0x300|'b');put(data+20,0x300|'a');
 state.sections=sections;state.remaining['a']=1;state.remaining['?']=1;state.vowel_characters=(const uint8_t *)"aeiou";state.letter_multipliers=letters;state.word_multipliers=words_table;state.placement=emit;
 letters[7*17+7]=2;words_table[9*17+8]=3;maven_enumerate_opening_placements(&state);
 assert(emitted==6&&state.remaining['a']==1&&state.remaining['?']==1);return 0;}
'''
        with tempfile.TemporaryDirectory() as tmp:
            src=Path(tmp)/'test.c';src.write_text(source);exe=Path(tmp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/opening_placements.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
