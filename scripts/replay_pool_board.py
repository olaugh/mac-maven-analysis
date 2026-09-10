#!/usr/bin/env python3
"""Replay CODE37's full13-tile-pool candidate stream before CODE36 selection."""
import argparse,gzip,json,hashlib,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/late-pool-live.json.gz');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));prior=json.loads((ROOT/'analysis/toolchain/endgame-generation-live.json').read_text());data_path=ROOT/'../../media/maven/session/share/maven2.1';assert hashlib.sha256(data_path.read_bytes()).hexdigest()==prior['dictionary_sha256'];calls=[c for c in j['candidates'] if c['kind']=='select_pool'];assert any(c['kind']=='selected_pool' for c in j['checkpoints'])
# This trace has no mask below128, so the seven-tile leave table is never read.
assert all(int.from_bytes(bytes.fromhex(c['move'])[30:32],'big')>=128 for c in calls)
decl=[]
def array(name,raw,kind='uint8_t'):
 if isinstance(raw,str):raw=bytes.fromhex(raw)
 if kind=='uint16_t' and isinstance(raw,bytes):raw=struct.unpack('>'+str(len(raw)//2)+'H',raw)
 decl.append('static '+kind+' '+name+'[]={'+','.join(map(str,raw))+'};')
array('board',j['entry']['board']);array('values',j['entry']['values'],'uint16_t');array('letter_values',j['letter_values'],'uint16_t');array('pool',j['pool']);array('counts',j['initial']['counts']);array('row_flags',j['row_flags']);array('occurrences',j['initial']['occurrences'],'uint16_t')
for name in ('word_multipliers','letter_multipliers','letter_class','alphabet'):array(name,prior['fixed'][name])
array('expected',b''.join(bytes.fromhex(c['move']) for c in calls));array('expected_used',b''.join(bytes.fromhex(c['used']) for c in calls));array('expected_tiles',[c['new_tiles'] for c in calls],'uint16_t')
source='''#include "board_moves.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
'''+ '\n'.join(decl)+r'''
static MavenBoardMoves moves;static MavenScoreScan score;static unsigned index_;static int failed,diagnostics;
static void diagnostic(void *u){(void)u;++diagnostics;}
static void visit(void *u,const uint8_t move[34]){unsigned i;(void)u;
 if(index_>=sizeof expected_tiles/sizeof expected_tiles[0]){failed=1;return;}
 for(i=0;i<34;++i)if(move[i]!=expected[index_*34+i]){if(!failed)fprintf(stderr,"candidate %u byte %u: %u != %u word %s\n",index_,i,move[i],expected[index_*34+i],move);failed=1;}
 if(score.new_tiles!=expected_tiles[index_])failed=1;
 for(i=0;i<128;++i)if(((i=='?'||(i>='a'&&i<='z'))?counts[i]-score.remaining_counts[i]:0)!=expected_used[index_*128+i]){if(!failed)fprintf(stderr,"used %u letter %u\n",index_,i);failed=1;}
 ++index_;}
int main(int argc,char **argv){FILE *f;long size;uint8_t *data;MavenDictionarySection sections[17]={{0,0}};uint16_t leave[128]={0};
 if(argc!=2)return 2;f=fopen(argv[1],"rb");if(!f)return 2;fseek(f,0,SEEK_END);size=ftell(f);rewind(f);data=malloc((size_t)size);if(!data||fread(data,1,(size_t)size,f)!=(size_t)size)return 2;fclose(f);
 moves.enumeration.sections=sections;moves.enumeration.board=board;moves.enumeration.letter_multipliers=letter_multipliers;moves.enumeration.word_multipliers=word_multipliers;memcpy(moves.enumeration.remaining,counts,128);
 moves.scoring=(MavenScoreInput){board,values,letter_values,word_multipliers,letter_multipliers,letter_class,alphabet,diagnostic,0};moves.sorted_rack=pool;moves.leave_values=leave;moves.move=visit;
'''
for i,s in enumerate(prior['sections']):source+=f'sections[{i}]=(MavenDictionarySection){{data+{s["offset"]},{s["root"]}u}};\n'
source+='''maven_generate_pool_board_moves(&moves,5000,&score,row_flags,(const uint16_t (*)[8])occurrences);
if(failed||diagnostics||index_!=sizeof expected_tiles/sizeof expected_tiles[0]){fprintf(stderr,"failed=%d diagnostics=%d count=%u expected=%lu\\n",failed,diagnostics,index_,(unsigned long)(sizeof expected_tiles/sizeof expected_tiles[0]));return 1;}free(data);return 0;}
'''
build=ROOT/'.build';build.mkdir(exist_ok=True);probe=build/'pool-board-probe.c';probe.write_text(source);exe=build/'pool-board-probe';sources=['board_moves','board_placements','board_state','score_move','score_accumulate','dictionary_lookup','cross_check_letters','rack_masks'];subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(probe),*[str(ROOT/f'reconstruction/{s}.c') for s in sources],'-o',str(exe)],check=True);subprocess.run([str(exe),str(data_path)],check=True,timeout=30);print(json.dumps(dict(scope=__doc__,candidates=len(calls),full_records_used_counts_scores_match=True)))
