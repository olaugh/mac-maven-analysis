#!/usr/bin/env python3
"""Replay complete original CODE30 search, all iterations and final rankings."""
import argparse,gzip,hashlib,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/endgame-search-live.json.gz');p.add_argument('--prefix',action='store_true');a=p.parse_args();j=json.loads(gzip.decompress(a.capture.read_bytes()));assert a.prefix or j['complete'];data_path=ROOT/'../../media/maven/session/share/maven2.1';assert hashlib.sha256(data_path.read_bytes()).hexdigest()==j['dictionary_sha256']
for ident in j['identities']:assert hashlib.sha256((ROOT/f'resources/CODE/{ident["code_resource"]}_{ident["code_resource"]}.bin').read_bytes()).hexdigest()==ident['sha256']
out=bytearray()
def word(v):out.extend(struct.pack('>H',v&65535))
def number(v):out.extend(struct.pack('>I',v&0xffffffff))
def raw(v):out.extend(bytes.fromhex(v))
def snapshot(s):
 for name in ['board','values','counts','undo','sorted_rack','canonical_masks','tile_points','occurrence_masks','best','second','row_flags','upper_scores','lower_scores','best_empty_move']:raw(s[name])
 for n in ['new_tiles','row_zero_count']:word(s[n])
 for n in ['rows','columns']:
  for v in s[n]:word(v)
 word(s['mask_count']);raw(s['ranking']['moves']);word(s['ranking']['count']);number(s['ranking']['cutoff'])
 for side in ['own','other']:
  for kind in ['a','b','error']:raw(s['tables'][side+'_'+kind])
 raw(s['nodes']);word(s['free_head']);word(s['current']);number(s['propagation_correction']);word(s['propagation_mask']);raw(s['conflicts']);word(len(s['summaries']))
 for summ in s['summaries']:out.extend(bytes.fromhex(summ['raw'])[4:])
word(j['capacity']);word(len(j['iterations']))
for name in ['letter_values','word_multipliers','letter_multipliers','letter_class','bit_masks','hash_table','alphabet']:raw(j['fixed'][name])
word(j['fixed']['bingo_bonus']);word(len(j['sections']))
for sec in j['sections']:number(sec['offset']);number(sec['root'])
for name in ['own','other','final_own','final_other']:raw(j.get(name,j[name.removeprefix('final_')]))
number(j['budget']);word(j['initial']['reserve_control']);number(j.get('start_ticks',0));word(len(j['elapsed']))
for clock in j['elapsed']:number(clock['result']);number(clock['ticks'])
for leaf in j['leaf_entries']:word(leaf['current']);raw(leaf['own']);raw(leaf['other']);raw(leaf['board'])
snapshot(j['initial'])
for state in j['iterations']:
 snapshot(state)
 for name in ['next_frontier','optimistic','alternative','guaranteed','initial_reserve']:word(state[name])
if not a.prefix:
 if 'before_ranking' in j:snapshot(j['before_ranking'])
 snapshot(j['final'])
build=ROOT/'.build';build.mkdir(exist_ok=True);fixture=build/'endgame-search-fixture.bin';fixture.write_bytes(out);exe=build/'endgame-search-probe'
sources=['endgame_search','endgame_leaf','endgame_tree','endgame_generation','endgame_move_cache','endgame_rack_bounds','reply_bounds','candidate_ranking','local_replies','board_state','apply_move','place_letters','move_finalize','undo_move','board_moves','board_placements','rack_counts','rack_masks','score_move','score_accumulate','dictionary_lookup','cross_check_letters']
subprocess.run(['cc','-std=c99','-O1','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(ROOT/'reconstruction'),str(ROOT/'scripts/endgame_search_probe.c'),*[str(ROOT/f'reconstruction/{name}.c') for name in sources],'-o',str(exe)],check=True)
subprocess.run([str(exe),str(fixture),str(data_path),*(['--prefix'] if a.prefix else [])],check=True,timeout=90)
print(json.dumps(dict(scope='Completed original iteration prefix only; no final result claimed' if a.prefix else __doc__,iterations=len(j['iterations']),clock_reads=len(j['elapsed']),prefix_only=a.prefix,ranked_moves=None if a.prefix else j['final']['ranking']['count'],all_recorded_nodes_and_workspaces_match=True,final_rankings_match=not a.prefix)))
