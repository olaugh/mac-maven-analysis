from pathlib import Path
import subprocess
import tempfile
import unittest

class MaskSupersetTests(unittest.TestCase):
    def test_superset_membership_generation_and_duplicate_masks(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "mask_supersets.h"
#include <assert.h>
int main(void){uint16_t values[128]={0},masks[7]={1,2,4,8,16,32,64};uint32_t stamps[128]={0};unsigned i;
 maven_add_to_mask_supersets(values,stamps,1,masks,5,-1);
 for(i=0;i<128;i++)assert(values[i]==((i&5)==5?65535:0));
 maven_add_to_mask_supersets(values,stamps,1,masks,5,10);
 for(i=0;i<128;i++)assert(values[i]==((i&5)==5?65535:0));
 maven_add_to_mask_supersets(values,stamps,2,masks,5,2);
 for(i=0;i<128;i++)assert(values[i]==((i&5)==5?1:0));
 for(i=0;i<7;i++)masks[i]=i<3?0:2;
 maven_add_to_mask_supersets(values,stamps,3,masks,0,7);
 assert(values[0]==7&&values[2]==7&&values[4]==0);
 /* Matching initial generation prevents traversal even with different masks. */
 masks[0]=4;maven_add_to_mask_supersets(values,stamps,3,masks,0,7);assert(values[4]==0);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/mask_supersets.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
