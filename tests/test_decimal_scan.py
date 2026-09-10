import json
from pathlib import Path
import subprocess
import tempfile
import unittest


class DecimalScanTests(unittest.TestCase):
    def test_decimal_boundaries_failure_and_field_width(self):
        root=Path(__file__).resolve().parents[1]
        table=bytes.fromhex(json.loads((root/'analysis/toolchain/character-table-fingerprint.json').read_text())['table_hex'])
        source='#include "decimal_scan.h"\n#include <assert.h>\n#include <string.h>\n'
        source+='static const uint8_t table[256]={'+','.join(map(str,table))+'};\n'
        source+=r'''
static void check(const char *text,int status,int value,int error) {
    int16_t actual=123,err=7;
    assert(maven_scan_decimal_word((const uint8_t *)text,&actual,&err,table)==status);
    assert(actual==value && err==error);
}
int main(void) {
    char wide[32770];
    check("",-1,123,7); check(" \t\r\n",-1,123,7);
    check("+",-1,123,7); check("-",-1,123,7);
    check("+x",0,123,7); check("x",0,123,7);
    check("  -12tail",1,-12,7); check("0x10",1,0,7);
    check("32767",1,32767,7); check("32768",1,32767,34);
    check("-32768",1,-32768,7); check("-32769",1,-32768,34);
    check("4294967296",1,32767,34); check("-4294967296",1,-32768,34);
    check("9999999999999999999999999999",1,32767,34);
    check("\20012",0,123,7);
    memset(wide,'0',32767); wide[32767]='9'; wide[32768]=0;
    check(wide,1,0,7); /* Default field width stops before the 9. */
    wide[0]='-'; wide[32766]='8'; check(wide,1,-8,7);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c'; src.write_text(source); exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/decimal_scan.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
