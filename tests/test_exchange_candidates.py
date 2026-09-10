from pathlib import Path
import subprocess
import tempfile
import unittest

class ExchangeCandidateTests(unittest.TestCase):
    def test_masks_metadata_wrapping_stale_text_and_count_truncation(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "exchange_candidates.h"
#include "rack_masks.h"
#include <assert.h>
#include <string.h>
static int emitted,lookups;static uint16_t retained;
static int16_t value(void *u,uint8_t letter){(void)u;assert(letter==(uint8_t)('g'-lookups));++lookups;return (int16_t)((letter-'a'+1)*100);}
static void diagnostic(void *u){(void)u;assert(!"unexpected diagnostic");}
static int32_t word32(const uint8_t *p){uint32_t n=(uint32_t)p[0]<<24|(uint32_t)p[1]<<16|(uint32_t)p[2]<<8|p[3];return n<0x80000000u?(int32_t)n:(int32_t)((int64_t)n-4294967296LL);}
static void emit(void *u,const uint8_t *m){int kept=127-emitted,i,n=0,sum=0;char expected[8];(void)u;
 for(i=0;i<7;++i)if(!(kept&(1<<i))){expected[n++]=(char)('a'+i);sum+=(i+1)*100;}expected[n]=0;
 assert(!strcmp((const char *)m,expected));assert(!word32(m+16));assert(word32(m+20)==kept*10-100);assert(word32(m+24)==800-2*sum/13);
 assert(!m[28]&&!m[29]&&!m[30]&&m[31]==kept&&!m[32]&&!m[33]);if(kept==119)assert(m[2]=='c');
 ++emitted;retained=10;}
static int bits(unsigned n){int total=0;while(n){total+=(int)(n&1);n>>=1;}return total;}
int main(void){int16_t masks[128];uint16_t leaves[128],occurrences[128][8];MavenExchangeCandidates s={0};unsigned i;
 memset(occurrences,0x5a,sizeof occurrences);maven_build_occurrence_masks((const uint8_t *)"aaabbcc",occurrences);assert(occurrences['a'][0]==126&&occurrences['a'][2]==123&&occurrences['c'][1]==63&&occurrences['z'][0]==0x5a5a);
 for(i=0;i<128;++i){unsigned d=maven_canonical_mask_difference(127,(uint16_t)i,(const uint8_t *)"aaabbcc",diagnostic,0);unsigned wanted=127^i;
 assert(bits(d&7)==bits(wanted&7)&&bits(d&24)==bits(wanted&24)&&bits(d&96)==bits(wanted&96));if(d&7)assert(d&4);if(d&24)assert(d&16);if(d&96)assert(d&64);}
 assert(maven_merge_mask_carry(2,2,0)==3&&maven_merge_mask_carry(2,2,2)==2&&maven_merge_mask_carry(0,4,1)==5);
 for(i=0;i<128;++i){masks[i]=(int16_t)(127-i);leaves[i]=(uint16_t)(i*10);}
 s.rack=(const uint8_t *)"gfedcba";s.sorted_rack=(const uint8_t *)"abcdefg";s.canonical_masks=masks;s.mask_count=128;s.leave_values=leaves;s.leave_offset=-100;s.unseen_total=20;s.opening=1;s.opening_score_zero=1000;s.opening_score_five=200;s.adjusted_letter_value=value;s.candidate=emit;s.diagnostic=diagnostic;s.retained_count=&retained;
 maven_generate_exchange_candidates(&s);assert(emitted==128&&lookups==7&&retained==1);return 0;}
'''
        with tempfile.TemporaryDirectory() as tmp:
            src=Path(tmp)/'test.c';src.write_text(source);exe=Path(tmp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/exchange_candidates.c'),str(root/'reconstruction/rack_masks.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
