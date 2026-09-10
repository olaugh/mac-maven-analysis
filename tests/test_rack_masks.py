from pathlib import Path
import subprocess
import tempfile
import unittest

class RackMasksTests(unittest.TestCase):
    def test_descending_search_diagnostic_and_signed_mask(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "rack_masks.h"
#include <assert.h>
#include <string.h>
static int errors;static void diagnostic(void *u){(void)u;++errors;}
int main(void){int16_t masks[]={127,85,7,3,0,-1,-32768};uint32_t bits[]={1,2,4,8,16,32,64};uint8_t out[8];int i;
 for(i=0;i<7;++i)assert(maven_mask_is_listed(masks,7,masks[i]));
 assert(!maven_mask_is_listed(masks,7,86)&&!maven_mask_is_listed(masks,0,0));
 assert(maven_rack_from_mask(out,(const uint8_t *)"aabcdef",bits,85,masks,7,diagnostic,0)==out&&!strcmp((char *)out,"abdf"));
 maven_rack_from_mask(out,(const uint8_t *)"aabcdef",bits,2,masks,7,diagnostic,0);assert(errors==1&&!strcmp((char *)out,"a"));
 bits[0]=0x80000000u;maven_rack_from_mask(out,(const uint8_t *)"a",bits,-1,masks,7,diagnostic,0);assert(!strcmp((char *)out,"a"));
 maven_rack_from_mask(out,(const uint8_t *)"a",bits,0,masks,7,diagnostic,0);assert(!out[0]);return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/rack_masks.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
