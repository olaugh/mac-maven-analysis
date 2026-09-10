#!/usr/bin/env python3
"""Replay natural score inputs through the complete reconstructed scorer."""
import argparse,hashlib,json,struct,subprocess,tempfile
from pathlib import Path

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True);a=p.parse_args()
    root=Path(__file__).resolve().parents[1];j=json.loads(a.capture.read_text());initial=j['initial'];expected=j['result']
    assert hashlib.sha256((root/'resources/CODE/32_32.bin').read_bytes()).hexdigest()==j['code32_sha256']
    arrays=[]
    for name,data in initial.items():
        raw=bytes.fromhex(data);isword=name in ('values','letter_values')
        elements=struct.unpack('>'+str(len(raw)//2)+'H',raw) if isword else raw
        arrays.append('static const '+('uint16_t' if isword else 'uint8_t')+' '+name+'[]={'+','.join(map(str,elements))+'};')
    remaining=bytes.fromhex(expected['remaining_rack']).split(b'\0')[0]+b'\0'
    arrays.append('static const uint8_t expected_rack[]={'+','.join(map(str,remaining))+'};')
    source='''#include "score_move.h"
#include <assert.h>
#include <string.h>
static int diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
'''+ '\n'.join(arrays)+'''
int main(void){uint8_t rest[16];MavenScoreInput input={board,values,letter_values,word_multipliers,letter_multipliers,letter_class,alphabet,diagnostic,0};
 MavenScoreScan r=maven_score_move(move,rack,rest,&input);
 assert(!diagnostics && !strcmp((const char *)rest,(const char *)expected_rack));
'''+f"assert(r.score_bits==UINT32_C({expected['score_bits']})&&r.new_tiles=={expected['new_tiles']});\n"+''.join(f"assert(r.zero_value_{axis}[{i}]=={value});\n" for axis in ('row','column') for i,value in enumerate(expected['zero_value_'+axis]))+'return 0;}\n'
    with tempfile.TemporaryDirectory() as temp:
        src=Path(temp)/'score.c';src.write_text(source);exe=Path(temp)/'score'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/score_move.c'),str(root/'reconstruction/score_accumulate.c'),'-o',str(exe)],check=True)
        subprocess.run([str(exe)],check=True,timeout=10)
    print(json.dumps(dict(scope='Complete scorer C replay from one natural invocation and actual tables; only branches exercised by captured move are runtime-verified',score_bits=expected['score_bits'],new_tiles=expected['new_tiles'],remaining_rack=remaining[:-1].decode(),recorded_coordinates_match=True,capture_sha256=hashlib.sha256(a.capture.read_bytes()).hexdigest()),indent=2))
if __name__=='__main__':main()
