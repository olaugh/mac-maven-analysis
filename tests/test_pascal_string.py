from pathlib import Path
import subprocess
import tempfile
import unittest

class PascalStringTests(unittest.TestCase):
    def test_all_lengths_and_embedded_zero(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "pascal_string.h"
#include <assert.h>
#include <string.h>
int main(void) {
    uint8_t buffer[258], original[258]; unsigned length,i;
    for(length=0;length<=255;++length) {
        for(i=0;i<258;++i)buffer[i]=(uint8_t)(i*17);
        buffer[0]=(uint8_t)length; memcpy(original,buffer,sizeof buffer);
        assert(maven_pascal_to_c(buffer)==buffer);
        for(i=0;i<length;++i) assert(buffer[i]==original[i+1]);
        assert(buffer[length]==0);
        for(i=length+1;i<258;++i) assert(buffer[i]==original[i]);
        /* sprintf("%s") also writes the trailing NUL beyond the payload. */
        for(i=0;i<length;++i)original[i]='A';
        original[length]=0;memset(buffer,0xaa,sizeof buffer);
        assert(maven_c_to_pascal(buffer,original)==buffer);
        assert(buffer[0]==length && buffer[length+1]==0);
        for(i=1;i<=length;++i)assert(buffer[i]=='A');
        for(i=length+2;i<258;++i)assert(buffer[i]==0xaa);
    }
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/pascal_string.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
