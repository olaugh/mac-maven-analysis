#!/usr/bin/env python3
"""Compare original pattern lookup scores and accumulator pointers with C."""
import hashlib,json,subprocess,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];path=root/'analysis/toolchain/pattern-lookup-live.json';d=json.loads(path.read_text())
assert hashlib.sha256((root/'resources/CODE/32_32.bin').read_bytes()).hexdigest()==d['code32_sha256']
source='#include "pattern_lookup.h"\n#include <assert.h>\n#include <stddef.h>\n'
source+='static uint8_t records[]={'+','.join(map(str,bytes.fromhex(d['score_records'])))+'};\n'
source+='static MavenPatternEntry entries[]={'+','.join('{(const uint8_t *)'+json.dumps(e['letters'])+','+str(e['accumulator'])+'u,'+str(e['table_index'])+'}' for e in d['entries'])+'};\nint main(void){uint32_t *p;\n'
for c in d['calls']:
 source+='assert(maven_lookup_pattern(entries,'+str(len(d['entries']))+', (const uint8_t *)'+json.dumps(c['letters'])+',records,&p)=='+str(c['score'])+');\n'
 source+='assert(p=='+('NULL' if c['entry_index'] is None else '&entries['+str(c['entry_index'])+'].accumulator')+');\n'
source+='return 0;}\n'
with tempfile.TemporaryDirectory() as temp:
 src=Path(temp)/'lookup.c';src.write_text(source);exe=Path(temp)/'lookup'
 subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/pattern_lookup.c'),'-o',str(exe)],check=True)
 subprocess.run([str(exe)],check=True,timeout=10)
print(json.dumps(dict(scope='Natural original pattern lookup replay; all scores and mutable-entry identities compared',calls_matching=len(d['calls']),hits=sum(c['entry_index'] is not None for c in d['calls']),capture_sha256=hashlib.sha256(path.read_bytes()).hexdigest()),indent=2))
