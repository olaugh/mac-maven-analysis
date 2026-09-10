#!/usr/bin/env python3
"""Replay original SANE expectation calls using the exact integer port."""
import hashlib,json,subprocess,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];path=root/'analysis/toolchain/letter-expectation-live.json';d=json.loads(path.read_text())
assert hashlib.sha256((root/'resources/CODE/32_32.bin').read_bytes()).hexdigest()==d['code32_sha256']
source='#include "letter_expectation.h"\n#include <assert.h>\n#include <stddef.h>\nint main(void){\n'
for c in d['calls']:
 source+='{'+('uint32_t scores[]={'+','.join(str(v)+'u' for v in c['scores'])+'};' if c['scores'] is not None else '')
 source+='assert(maven_letter_expectation('+str(c['total'])+','+str(c['letter_count'])+','+('scores' if c['scores'] is not None else 'NULL')+')=='+str(c['result_bits'])+'u);}\n'
source+='return 0;}\n'
with tempfile.TemporaryDirectory() as temp:
 src=Path(temp)/'expect.c';src.write_text(source);exe=Path(temp)/'expect'
 subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/letter_expectation.c'),'-o',str(exe)],check=True)
 subprocess.run([str(exe)],check=True,timeout=10)
print(json.dumps(dict(scope='Exact integer expectation compared with natural SANE-based original calls; successful observed precision environment only',calls_matching=len(d['calls']),source_identity=d['identity'],capture_sha256=hashlib.sha256(path.read_bytes()).hexdigest()),indent=2))
