"""Replay the recorded original-runtime success trace through compiled C."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest


class FileAccessCheckTests(unittest.TestCase):
    def test_recorded_startup_trace(self):
        root=Path(__file__).resolve().parents[1]
        trace=json.loads((root/'analysis/toolchain/file-check-live.json').read_text())
        self.assertEqual([r['operation'] for r in trace['calls']],
                         ['FSOpen','GetEOF','FSRead','FSWrite','SetEOF','FSClose'])
        self.assertTrue(all(r['result']==0 for r in trace['calls']))
        self.assertEqual(trace['calls'][2]['count'],1)
        self.assertEqual(trace['calls'][3]['count'],1)
        name=trace['filename'].encode('mac_roman')
        encoded=bytes([len(name)])+name
        prelude='''#include "file_access_check.h"
#include <assert.h>
#include <string.h>
static int step;
'''
        prelude+='static const uint8_t expected_name[] = {'+','.join(map(str,encoded))+'};\n'
        prelude+=f'#define REF {trace["calls"][0]["file_refnum"]}\n'
        prelude+=f'#define VOLUME ({trace["volume_reference"]})\n'
        prelude+=f'#define LENGTH {trace["calls"][1]["original_eof"]}\n'
        prelude+=f'#define BYTE_VALUE {int(trace["calls"][2]["buffer_hex"],16)}\n'
        source=prelude+r'''
static int16_t open_file(const uint8_t *name,int16_t volume,int16_t *file) {
    assert(step++==0 && volume==VOLUME);
    assert(memcmp(name,expected_name,sizeof expected_name)==0);
    *file=REF; return 0;
}
static int16_t get_eof(int16_t file,int32_t *length) {
    assert(step++==1 && file==REF); *length=LENGTH; return 0;
}
static int16_t read_file(int16_t file,int32_t *count,void *buffer) {
    assert(step++==2 && file==REF && *count==1);
    *(uint8_t *)buffer=BYTE_VALUE; return 0;
}
static int16_t write_file(int16_t file,int32_t *count,const void *buffer) {
    assert(step++==3 && file==REF && *count==1);
    assert(*(const uint8_t *)buffer==BYTE_VALUE); return 0;
}
static int16_t set_eof(int16_t file,int32_t length) {
    assert(step++==4 && file==REF && length==LENGTH); return 0;
}
static int16_t close_file(int16_t file) {
    assert(step++==5 && file==REF); return 0;
}
int main(void) {
    const MavenFileOperations ops={open_file,get_eof,read_file,write_file,set_eof,close_file};
    int16_t result=maven_check_file_access(expected_name,VOLUME,&ops);
    assert(result==0 && step==6); return 0;
}
'''
        self.assertEqual(trace['return_value'],0)
        with tempfile.TemporaryDirectory() as temp:
            path=Path(temp)/'replay.c';path.write_text(source)
            exe=Path(temp)/'replay'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror',
                            '-I',str(root/'reconstruction'),str(path),
                            str(root/'reconstruction/file_access_check.c'),
                            '-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True)


if __name__=='__main__':
    unittest.main()
