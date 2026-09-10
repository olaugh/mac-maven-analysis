#!/usr/bin/env python3
"""Replay one combined move using natural scoring inputs and restore outputs."""
import argparse,hashlib,json,struct,subprocess,tempfile
from pathlib import Path

def main():
    root=Path(__file__).resolve().parents[1]
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path);a=p.parse_args()
    score_path=root/'analysis/toolchain/move-score-live.json';restore_path=root/'analysis/toolchain/game-restore-live.json'
    if a.capture:score_path=a.capture
    score=json.loads(score_path.read_text());restore=json.loads(restore_path.read_text())
    assert hashlib.sha256((root/'resources/CODE/32_32.bin').read_bytes()).hexdigest()==score['code32_sha256']
    for identity in restore['identities']:
        rid=identity['code_resource'];assert hashlib.sha256((root/f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==identity['sha256']
    if a.capture:assert hashlib.sha256((root/'resources/CODE/31_31.bin').read_bytes()).hexdigest()==score['application_code31_sha256']
    initial=score['initial'];final=score['application_state'] if a.capture else restore['state'];arrays=[]
    for name,data in initial.items():
        raw=bytes.fromhex(data);isword=name in ('values','letter_values');elements=struct.unpack('>'+str(len(raw)//2)+'H',raw) if isword else raw
        arrays.append('static '+('uint16_t' if isword else 'uint8_t')+' '+name+'[]={'+','.join(map(str,elements))+'};')
    for name in (('board','values','undo','counts') if a.capture else ('board','values','undo')):
        raw=bytes.fromhex(final[name]);isword=name=='values';elements=struct.unpack('>544H',raw) if isword else raw
        arrays.append('static const '+('uint16_t' if isword else 'uint8_t')+' expected_'+name+'[]={'+','.join(map(str,elements))+'};')
    source='''#include "apply_move.h"
#include "rack_counts.h"
#include <assert.h>
#include <string.h>
static int diagnostics;static void diagnostic(void *u){(void)u;++diagnostics;}
'''+ '\n'.join(arrays)+'''
int main(void){uint8_t counts[128]={0},undo[33]={0};
 MavenApplyState s={{board,values,counts,letter_values,word_multipliers,undo,diagnostic,0},letter_multipliers,letter_class,alphabet,0,0,{0,0},{0,0},0,0};
 maven_count_rack(counts,alphabet,rack);maven_apply_move_without_evaluation(move,rack,&s);
 assert(!diagnostics && !strcmp((char *)rack,"i"));
 assert(!memcmp(board,expected_board,sizeof board));assert(!memcmp(values,expected_values,sizeof values));
 assert(!memcmp(undo,expected_undo,sizeof undo));assert(s.row_zero_count==0&&s.new_tiles==6);
 return 0;}
'''
    if a.capture:
        source=source.replace('return 0;}', 'assert(!memcmp(counts,expected_counts,sizeof counts));return 0;}')
    sources=['apply_move.c','score_move.c','score_accumulate.c','place_letters.c','move_finalize.c','board_state.c','rack_counts.c']
    with tempfile.TemporaryDirectory() as temp:
        src=Path(temp)/'apply.c';src.write_text(source);exe=Path(temp)/'apply'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),*[str(root/'reconstruction'/x) for x in sources],'-o',str(exe)],check=True)
        subprocess.run([str(exe)],check=True,timeout=10)
    print(json.dumps(dict(scope=('Direct original application boundary capture from a constructed save fixture.' if a.capture else 'Integrated non-evaluation C move replay. Natural scoring inputs and separate post-restore board/value/undo capture for the same AORTAE move. Final refill/history/player totals excluded; no claim of single-call boundary trace.'),board_bytes_matching=544,value_words_matching=544,undo_bytes_matching=33,residual_rack='i',new_tiles=6,row_zero_count=0,score_capture_sha256=hashlib.sha256(score_path.read_bytes()).hexdigest(),restore_capture_sha256=None if a.capture else hashlib.sha256(restore_path.read_bytes()).hexdigest(),counts_match=True if a.capture else None),indent=2))
if __name__=='__main__':main()
