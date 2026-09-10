"""Instruction-domain checks using the saved original character table."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest


class CharacterNormalizationTests(unittest.TestCase):
    def test_full_word_domain_and_in_place_byte_copy(self):
        root = Path(__file__).resolve().parents[1]
        evidence = json.loads((root/'analysis/toolchain/character-table-fingerprint.json').read_text())
        table = bytes.fromhex(evidence['table_hex'])
        source = '#include "character_normalization.h"\n#include <assert.h>\n'
        source += 'static const uint8_t table[256]={' + ','.join(map(str, table)) + '};\n'
        source += r'''
int main(void) {
    int32_t n;
    uint8_t bytes[256];
    /* The word result retains its high byte, even for non-character inputs. */
    for (n=-32768;n<=32767;++n) {
        unsigned low=(uint16_t)n & 255u;
        int16_t expected=(int16_t)n;
        if (low>=65 && low<=90) expected=(int16_t)(n ^ 32);
        assert(maven_lowercase_character((int16_t)n,table)==expected);
    }
    for (n=1;n<=255;++n) bytes[n-1]=(uint8_t)n;
    bytes[255]=0;
    assert(maven_copy_lowercase(bytes,bytes,table)==bytes);
    for (n=1;n<=255;++n)
        assert(bytes[n-1]==(n>=65 && n<=90 ? n+32 : n));
    assert(bytes[255]==0);
    bytes[0]=0; bytes[1]=42;
    assert(maven_copy_lowercase(bytes,bytes,table)==bytes && bytes[1]==42);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src = Path(temp)/'test.c'; src.write_text(source)
            exe = Path(temp)/'test'
            subprocess.run(['cc', '-std=c99', '-Wall', '-Wextra', '-Werror',
                            '-I', str(root/'reconstruction'), str(src),
                            str(root/'reconstruction/character_normalization.c'),
                            '-o', str(exe)], check=True)
            subprocess.run([str(exe)], check=True, timeout=10)


if __name__ == '__main__':
    unittest.main()
