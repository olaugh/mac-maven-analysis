from pathlib import Path
import subprocess
import tempfile
import unittest

class EvaluationFeatureTests(unittest.TestCase):
    def test_slots_thresholds_and_signed_inputs(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "evaluation_features.h"
#include <assert.h>
#include <string.h>
static int16_t vowel(void *u,int16_t c){(void)u;return strchr("aeiou",c)!=0;}
static int16_t matches(void *u,int16_t id){(void)u;return id==1||id==-1;}
int main(void){uint8_t counts[128]={0};uint32_t f[22];MavenEvaluationBefore b;uint16_t ids[]={1,2,65535,0},weights[]={5,90,65534};int i;
 counts['a']=3;counts['e']=3;counts['s']=2;counts['q']=1;counts['?']=1;
 b=maven_prepare_evaluation_features(f,counts,7,vowel,0);
 assert(f[16]==2&&f[15]==0&&f[18]==1&&f[17]==0);
 counts['q']=counts['?']=0;
 maven_finish_evaluation_features(f,&b,counts,5000,77,(const uint8_t *)"",-1,ids,weights,matches,0);
 assert(f[0]==1&&f[3]==5000&&f[5]==5000&&f[6]==1&&f[7]==5000&&f[8]==5000);
 assert(f[12]==UINT32_MAX&&f[13]==1&&f[14]==3&&f[19]==1&&f[20]==1&&f[21]==0);
 for(i=0;i<4;i++){int occupancy[]={29,30,77,86};
  b=maven_prepare_evaluation_features(f,counts,6,vowel,0);
  maven_finish_evaluation_features(f,&b,counts,6000,occupancy[i],(const uint8_t *)"",0,ids,weights,matches,0);
  assert(f[i+1]==6000&&f[5]==0&&f[6]==0);
 }
 memset(counts,0,sizeof counts);counts['b']=2;counts['c']=2;counts['d']=2;counts['q']=255;
 b=maven_prepare_evaluation_features(f,counts,7,vowel,0);assert(f[15]==3&&f[17]==0&&b.q==-1);
 counts['q']=0;b=maven_prepare_evaluation_features(f,counts,7,vowel,0);assert(f[17]==1);
 {uint8_t records[16]={0};records[6]=1;
 assert(maven_evaluation_record_flag_clear(records,2,-1)==1);
 assert(maven_evaluation_record_flag_clear(records,2,0)==0);
 assert(maven_evaluation_record_flag_clear(records,2,1)==1);
 assert(maven_evaluation_record_flag_clear(records,2,2)==0);
 assert(maven_evaluation_record_flag_set(records,2,0)==0);
 records[14]=1;assert(maven_evaluation_record_flag_set(records,2,1)==1);
 assert(maven_evaluation_record_flag_set(records,2,-1)==0);}
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/evaluation_features.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
