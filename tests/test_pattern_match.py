from pathlib import Path
import subprocess
import tempfile
import unittest

class PatternMatchTests(unittest.TestCase):
    def test_multisets_links_blank_adjustment_q_and_word_outputs(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "pattern_match.h"
#include <assert.h>
#include <string.h>
static void diagnostic(void *u){(void)u;assert(0);}
static void putlong(uint8_t *p,uint32_t x){p[0]=(uint8_t)(x>>24);p[1]=(uint8_t)(x>>16);p[2]=(uint8_t)(x>>8);p[3]=(uint8_t)x;}
int main(void){
 uint8_t records[48]={0},scores[112]={0},board[544]={0},counts[128]={0},saved[128];
 uint16_t values[544]={0},letters[128]={0};int16_t ids[6],weights[6];
 const uint8_t strings[]="aa\0qz\0z\0";
 MavenPatternMatchInput in={records,strings,scores,board,values,letters,counts,6,diagnostic,0};
 MavenPatternMatchResult r;
 /* record1 rack aa; record2 anchored q/z, whose record4 link requires
    the square to its right empty; record3 anchored z. record5 is unused. */
 records[8+5]=1;
 records[16+1]=4;records[16+3]=3;records[16+5]=2;records[16+6]=8;records[16+7]=8;
 records[24+3]=6;records[24+5]=3;records[24+6]=9;records[24+7]=8;
 records[32+7]=1;
 putlong(scores+28+24,70000u);putlong(scores+56+24,301u);putlong(scores+84+24,(uint32_t)-301);
 counts['a']=2;memcpy(saved,counts,128);board[8*17+8]='q';board[9*17+8]='z';values[8*17+8]=1000;values[9*17+8]=1000;letters['q']=100;letters['z']=100;
 r=maven_match_patterns(&in,0,ids,weights);
 assert(r.count==3&&r.total_bits==69849u);assert(ids[0]==1&&ids[1]==2&&ids[2]==3&&ids[3]==0);
 assert(weights[0]==4464&&weights[1]==150&&weights[2]==-301&&weights[3]==0);assert(!memcmp(counts,saved,128));
 r=maven_match_patterns(&in,1,0,0);assert(r.count==2&&r.total_bits==(uint32_t)-151);
 /* Blank values reduce magnitude; blank Q takes this branch before halving. */
 values[8*17+8]=0;values[9*17+8]=0;
 r=maven_match_patterns(&in,1,ids,weights);assert(r.count==2&&r.total_bits==0&&weights[0]==101&&weights[1]==-101);
 letters['q']=200;letters['z']=200;
 r=maven_match_patterns(&in,1,ids,weights);assert(r.total_bits==0&&weights[0]==0&&weights[1]==0);
 board[8*17+9]='a';r=maven_match_patterns(&in,1,ids,weights);assert(r.count==1&&ids[0]==3);
 /* A failed multiset match restores the count of the failing letter too. */
 counts['a']=1;memcpy(saved,counts,128);r=maven_match_patterns(&in,0,ids,weights);assert(r.count==1&&!memcmp(counts,saved,128));
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/pattern_match.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
