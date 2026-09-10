#!/usr/bin/env python3
"""Replay captured lazy pattern-cache construction with original records."""
import argparse,hashlib,json,subprocess,tempfile
from pathlib import Path

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/pattern-cache-live.json'));a=p.parse_args()
    root=Path(__file__).resolve().parents[1];d=json.loads(a.capture.read_text())
    assert hashlib.sha256((root/'resources/CODE/32_32.bin').read_bytes()).hexdigest()==d['code32_sha256']
    raw=bytes.fromhex(d['raw_records']);assert len(raw)==8*d['record_count']
    arena=bytearray(65536)
    for offset,text in d['strings'].items():
        b=text.encode('ascii')+b'\0';start=32768+int(offset);assert 0<=start and start+len(b)<=len(arena)
        arena[start:start+len(b)]=b
    def array(name,b):return 'static const unsigned char '+name+'[]={'+','.join(map(str,b))+'};\n'
    source='''#include "pattern_cache.h"
#include <assert.h>
#include <stdlib.h>
static int diagnostics;
static void *allocate(void *u,size_t n){(void)u;return malloc(n?n:1);}
static void diagnostic(void *u){(void)u;++diagnostics;}
'''+array('records',raw)+array('strings',arena)+'''int main(void){MavenPatternCache c={0,0};
'''+f'maven_prepare_pattern_cache(&c,records,{d["record_count"]},strings+32768,allocate,diagnostic,0);\nassert(!diagnostics&&c.count=={len(d["entries"])});\n'
    for i,e in enumerate(d['entries']):
        source+=f'assert(c.entries[{i}].letters==strings+{32768+e["string_offset"]}&&c.entries[{i}].accumulator=={e["accumulator"]}u&&c.entries[{i}].table_index=={e["table_index"]});\n'
    source+='free(c.entries);return 0;}\n'
    with tempfile.TemporaryDirectory() as temp:
        src=Path(temp)/'cache.c';src.write_text(source);exe=Path(temp)/'cache'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/pattern_cache.c'),'-o',str(exe)],check=True)
        subprocess.run([str(exe)],check=True,timeout=10)
    print(json.dumps(dict(scope='Native C lazy cache construction compared with original runtime output from captured records/string inputs; successful input domain only',input_records=d['record_count'],entries_matching=len(d['entries']),fields=['borrowed string offset','accumulator','table index'],capture_sha256=hashlib.sha256(a.capture.read_bytes()).hexdigest()),indent=2))
if __name__=='__main__':main()
