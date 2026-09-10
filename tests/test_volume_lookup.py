from pathlib import Path
import subprocess
import tempfile
import unittest


class VolumeLookupTests(unittest.TestCase):
    def test_legacy_comparison_and_enumeration(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "volume_lookup.h"
#include "pascal_string.h"
#include <assert.h>
#include <string.h>
static int calls,fail;
static int16_t get(void *u,uint8_t *p,uint8_t *name,uint8_t async) {
 unsigned i;(void)u;assert(!async);
 if (!calls) for(i=0;i<80;i++) assert(p[i]==(i==18?0x12:i==19?0x34:i==20?0x56:i==21?0x78:i==29?1:0));
 ++calls;
 if(fail) return -35;
 assert(p[28]==0 && p[29]==calls);
 name[0]=3;name[1]=calls==1?'x':'a';name[2]='b';name[3]='z';
 p[22]=0xff;p[23]=0xfe;return 0;
}
int main(void) {
 unsigned n,i;uint8_t a[256]={0},b[256]={0};
 for(n=0;n<256;n++) {
  memset(a,0,sizeof a);memset(b,0,sizeof b);a[0]=b[0]=(uint8_t)n;
  assert(!maven_pascal_mismatch(a,b));
  for(i=1;i<=n;i++) {
   b[i]=1;assert(maven_pascal_mismatch(a,b)==(n<128 && i<n));b[i]=0;
  }
  b[0]=(uint8_t)(n+1);assert(maven_pascal_mismatch(a,b)==1);
 }
 { uint8_t wanted[]={3,'a','b','c'};int16_t ref=123;
   MavenVolumeLookupOps ops={0,get};
   assert(!maven_find_volume(wanted,0x12345678,&ref,&ops));assert(ref==-2 && calls==2);
   calls=0;fail=1;ref=123;
   assert(maven_find_volume(wanted,0x12345678,&ref,&ops)==-35);assert(ref==123 && calls==1);
 }
 return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/pascal_string.c'),str(root/'reconstruction/volume_lookup.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
