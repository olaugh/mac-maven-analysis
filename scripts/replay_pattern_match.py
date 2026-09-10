#!/usr/bin/env python3
"""Replay an original rack/board pattern-matcher invocation in native C."""
import argparse,hashlib,json,struct,subprocess,tempfile
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/pattern-match-live.json'));a=p.parse_args()
root=Path(__file__).resolve().parents[1];d=json.loads(a.capture.read_text())
assert hashlib.sha256((root/'resources/CODE/35_35.bin').read_bytes()).hexdigest()==d['code35_sha256']
def array(name,b,word=False):
 values=struct.unpack('>'+str(len(b)//2)+'H',b) if word else b
 return 'static '+('uint16_t' if word else 'uint8_t')+' '+name+'[]={'+','.join(map(str,values))+'};\n'
arena=bytearray(65536)
for offset,text in d['strings'].items():
 b=text.encode('ascii')+b'\0';start=32768+int(offset);assert 0<=start and start+len(b)<=len(arena);arena[start:start+len(b)]=b
source='#include "pattern_match.h"\n#include <assert.h>\n#include <string.h>\nstatic int errors;static void diagnostic(void *u){(void)u;++errors;}\n'
source+=array('records',bytes.fromhex(d['raw_records']))+array('strings',arena)+array('score_records',bytes.fromhex(d['score_records']))
for name,hexdata in d['initial'].items():source+=array(name,bytes.fromhex(hexdata),name in ('values','letter_values'))
source+=array('expected_counts',bytes.fromhex(d['final_counts']))
source+='int main(void){int16_t ids['+str(d['record_count'])+'],weights['+str(d['record_count'])+'];MavenPatternMatchInput in={records,strings+32768,score_records,board,values,letter_values,counts,'+str(d['record_count'])+',diagnostic,0};\n'
source+='MavenPatternMatchResult result=maven_match_patterns(&in,'+str(d['mode'])+',ids,weights);\nassert(!errors&&result.total_bits=='+str(d['result_bits'])+'u);assert(!memcmp(counts,expected_counts,sizeof counts));\n'
if d.get('matched_records') is not None:
 expected=d['matched_records'];source+='assert(result.count=='+str(len(expected))+');\n'
 for i,e in enumerate(expected):source+='assert(ids['+str(i)+']=='+str(e['id'])+'&&weights['+str(i)+']=='+str(e['weight'])+');\n'
 source+='assert(ids[result.count]==0&&weights[result.count]==0);\n'
if d['record_ids'] is not None:
 source+='assert(result.count=='+str(len(d['record_ids'])-1)+');\n'
 for i,v in enumerate(d['record_ids']):source+='assert(ids['+str(i)+']=='+str(v)+');\n'
 if d['weights'] is not None:
  for i,v in enumerate(d['weights']):source+='assert(weights['+str(i)+']=='+str(v)+');\n'
source+='return 0;}\n'
with tempfile.TemporaryDirectory() as temp:
 src=Path(temp)/'match.c';src.write_text(source);exe=Path(temp)/'match'
 subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/pattern_match.c'),'-o',str(exe)],check=True)
 subprocess.run([str(exe)],check=True,timeout=10)
print(json.dumps(dict(scope='Native C pattern matcher compared with original total and all128 count bytes; record outputs compared only if observed in capture',mode=d['mode'],result_bits=d['result_bits'],counts_match=True,observed_records=len(d['matched_records']) if d.get('matched_records') is not None else None,capture_sha256=hashlib.sha256(a.capture.read_bytes()).hexdigest()),indent=2))
