#!/usr/bin/env python3
"""Compare C adjacent-premium penalties with observed original subrange outputs."""
import hashlib,json,subprocess,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];path=root/'analysis/toolchain/premium-exposure-live.json';d=json.loads(path.read_text())
assert hashlib.sha256((root/'resources/CODE/35_35.bin').read_bytes()).hexdigest()==d['code35_sha256']
source='#include "premium_exposure.h"\n#include <assert.h>\nstatic void diagnostic(void *u){(void)u;assert(0);}\n'
for i,call in enumerate(d['calls']):
 for name,hexdata in call['initial'].items():source+='static uint8_t '+name+str(i)+'[]={'+','.join(map(str,bytes.fromhex(hexdata)))+'};\n'
source+='int main(void){\n'
for i,call in enumerate(d['calls']):
 source+='{MavenPremiumExposureInput in={'+','.join(name+str(i) for name in ['board','word_multipliers','letter_multipliers','letter_class','penalties'])+',diagnostic,0};assert(maven_adjacent_premium_penalty(move'+str(i)+',&in)=='+str(call['result_bits'])+'u);}\n'
source+='return 0;}\n'
with tempfile.TemporaryDirectory() as temp:
 src=Path(temp)/'exposure.c';src.write_text(source);exe=Path(temp)/'exposure'
 subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/premium_exposure.c'),'-o',str(exe)],check=True)
 subprocess.run([str(exe)],check=True,timeout=10)
print(json.dumps(dict(scope='Original adjacent-premium subrange outputs compared with C using original board and20-record penalty table; only observed branches runtime-verified',calls_matching=len(d['calls']),nonzero=sum(c['result_bits']!=0 for c in d['calls']),capture_sha256=hashlib.sha256(path.read_bytes()).hexdigest()),indent=2))
