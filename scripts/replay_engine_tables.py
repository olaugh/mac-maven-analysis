#!/usr/bin/env python3
"""Initialize native engine tables from resources and compare original live tables."""
import json,struct,subprocess,hashlib
from pathlib import Path
sources=['engine_tables','score_statistics','global_initializer']
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-Ireconstruction','scripts/engine_tables_probe.c',*[f'reconstruction/{s}.c' for s in sources],'-o','.build/engine-tables-probe'],check=True)
out=subprocess.run(['.build/engine-tables-probe','resources'],text=True,capture_output=True,check=True);t=json.loads(out.stdout)
j=json.loads(Path('analysis/toolchain/heuristic-search-live.json').read_text())
for k,v in j['fixed'].items():
 if k in ('vowel_characters','unseen_q_query','held_u_query'):expected=(v+'\0').encode().hex()
 elif k=='opening_scores':expected=b''.join(struct.pack('>I',x) for x in v[:8]).hex()
 elif k in ('letter_scores','composition_scores'):
  # Only counts0..row are meaningful in each captured composition table.
  actual=bytes.fromhex(t[k]);rows=[list(struct.unpack_from('>8I',actual,i*32)) for i in range(len(v))]
  assert all(row[:len(want)]==want for row,want in zip(rows,v)),k;continue
 else:expected=v
 assert t[k]==expected,k
for k in ('pattern_records','pattern_scores'):assert t[k]==j[k],k
assert j['pattern_strings'].startswith(t['pattern_strings'])
Path('analysis/toolchain/resource-initialized-tables.json').write_text(json.dumps(t,indent=2)+'\n')
print(json.dumps(dict(scope=__doc__,pattern_records=t['pattern_count'],score_records=t['score_count'],all_matched=True,initialization='DATA/ZERO/DREL and score resources; no live memory or prepared caches',opening_slots=8,excluded='garbage captured beyond FRST allocation and ESTR allocation')))
