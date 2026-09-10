from pathlib import Path
import subprocess
import tempfile
import unittest

class MoveStatisticsTests(unittest.TestCase):
    def test_exact_normalized_fields_and_signed_rounding(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "move_statistics.h"
#include <assert.h>
int main(void){uint32_t input[22],out[22],sum[22];unsigned i;
 for(i=0;i<22;i++){input[i]=250;sum[i]=UINT32_MAX;}
 input[0]=3;input[14]=(uint32_t)(int32_t)-185;
 maven_normalize_move_statistics(out,input,2);
 for(i=0;i<22;i++){
  if(i==0)assert(out[i]==3);
  else if(i==14)assert(out[i]==(uint32_t)(int32_t)-61);
  else if((i>=1&&i<=5)||(i>=7&&i<=12))assert(out[i]==1);
  else assert(out[i]==250);
 }
 input[1]=(uint32_t)(int32_t)-250;maven_normalize_move_statistics(out,input,2);assert(out[1]==0);
 maven_add_move_statistics(input,sum);for(i=0;i<22;i++)assert(sum[i]==input[i]-1);
 maven_add_move_statistics(sum,sum);for(i=0;i<22;i++)assert(sum[i]==2*(input[i]-1));
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/move_statistics.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
