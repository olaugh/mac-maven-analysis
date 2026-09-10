from pathlib import Path
import subprocess
import tempfile
import unittest

class LeaveTableTests(unittest.TestCase):
    def test_pattern_subset_values_and_endgame_duplicate_masks(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "leave_table.h"
#include <assert.h>
#include <string.h>
static uint32_t balance(void *u,int16_t a,int16_t b,int16_t c,int16_t d,int16_t e){(void)u;(void)a;(void)b;(void)c;(void)d;(void)e;return 0;}
static unsigned bits(unsigned x){unsigned n=0;while(x){n+=x&1;x>>=1;}return n;}
int main(void){MavenLeaveTable s={0};MavenRackBalanceCache cache={0};uint8_t unseen[128]={0},distribution[128]={0},records[112]={0};uint16_t values[128]={0},qtable[40]={0};uint32_t letter_scores[27][8]={{0}};unsigned mask,i;
 MavenPatternEntry patterns[]={{(const uint8_t *)"a",3,1},{(const uint8_t *)"ab",3,2},{(const uint8_t *)"c",3,3}};
 records[28+27]=123;records[56+26]=0xff;records[56+27]=6;records[84+27]=50;
 distribution['?']=2;for(i='a';i<='z';++i)distribution[i]=1;
 unseen['a']=20;cache.evaluate_composition=balance;
 s.sorted_rack=(const uint8_t *)"abcdefg";s.alphabet=(const uint8_t *)"?abcdefghijklmnopqrstuvwxyz";s.vowel_characters=(const uint8_t *)"aeiou";s.unseen_counts=unseen;s.distribution=distribution;s.letter_values=values;s.letter_scores=letter_scores;s.q_with_unseen_u=qtable;s.q_without_held_u=qtable;s.held_u_query=(const uint8_t *)"qu";s.patterns=patterns;s.pattern_count=3;s.score_records=records;s.balance=&cache;s.generation=10;
 memset(s.tile_points,0x5a,sizeof s.tile_points);maven_prepare_leave_table(&s);assert(s.mask_count==128&&s.started_generation==11&&s.generation==14);
 for(mask=0;mask<128;++mask){int expected=123*(7-(int)bits(mask));if(mask&1)expected+=123;if((mask&3)==3)expected-=250;if(mask&4)expected+=50;assert(s.values[mask]==(uint16_t)expected);assert(s.canonical_masks[127-mask]==(int16_t)mask);assert(s.tile_points[mask]==0x5a5a);}
 s.sorted_rack=(const uint8_t *)"aaabbcc";unseen['a']=7;for(i='a';i<='z';++i)values[i]=100;
 maven_prepare_leave_table(&s);assert(s.mask_count==36);
 for(i=0;i<(unsigned)s.mask_count;++i){mask=(unsigned)s.canonical_masks[i];unsigned a=mask&7,b=mask&24,c=mask&96;assert(a==0||a==4||a==6||a==7);assert(b==0||b==16||b==24);assert(c==0||c==64||c==96);assert(s.tile_points[mask]==100*bits(mask));assert(s.values[mask]==(mask?(uint16_t)(-700-200*(int)bits(mask)):1400));}
 return 0;}
'''
        with tempfile.TemporaryDirectory() as tmp:
            src=Path(tmp)/'test.c';src.write_text(source);exe=Path(tmp)/'test'
            names=['leave_table','adjusted_pattern_lookup','pattern_lookup','rack_masks','letter_expectation','rack_balance']
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(root/'reconstruction'),str(src),*[str(root/f'reconstruction/{n}.c') for n in names],'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
