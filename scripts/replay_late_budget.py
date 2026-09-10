#!/usr/bin/env python3
"""Compare the late-search workload gate using original table and calibration inputs."""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import tempfile
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/late-budget-live.json'))
a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete'] and j['force']==0
for rid,digest in j['identities'].items():
 assert hashlib.sha256(Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==digest
assert j['calibration']>0 and 8<=j['unseen_total']<=16
assert j['own_blanks']+j['unseen_blanks']<=2
table=(C.c_uint16*54)(*struct.unpack('>54H',bytes.fromhex(j['table'])))
with tempfile.TemporaryDirectory() as temp:
 path=Path(temp)/'gate.dylib'
 subprocess.run(['cc','-shared','-fPIC','-std=c99','-Wall','-Wextra','-Werror',
                 'reconstruction/late_search_budget.c','-o',str(path)],check=True)
 lib=C.CDLL(str(path))
 lib.maven_late_estimated_work.argtypes=[C.c_void_p,C.c_uint,C.c_uint,C.c_uint,C.c_uint32]
 lib.maven_late_estimated_work.restype=C.c_uint32
 lib.maven_late_estimate_exceeds_budget.argtypes=[C.c_uint32]
 quotient=lib.maven_late_estimated_work(table,j['own_blanks'],j['unseen_blanks'],j['unseen_total'],j['calibration'])
 assert quotient==j['quotient'],(quotient,j['quotient'])
 assert bool(lib.maven_late_estimate_exceeds_budget(quotient))==j['heuristic_fallback']
 lib.maven_late_search_decision.argtypes=[C.c_void_p,C.c_uint,C.c_uint,C.c_uint,C.c_uint32,C.c_int,C.POINTER(C.c_uint32)]
 result=C.c_uint32()
 decision=lib.maven_late_search_decision(table,j['own_blanks'],j['unseen_blanks'],j['unseen_total'],j['calibration'],0,C.byref(result))
 assert decision==int(j['heuristic_fallback']) and result.value==quotient
print(json.dumps(dict(scope=__doc__,calibration=j['calibration'],estimate=quotient,
                     heuristic_fallback=j['heuristic_fallback'],all_matched=True)))
