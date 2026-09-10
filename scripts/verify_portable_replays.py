#!/usr/bin/env python3
"""Build portable modules and rerun preserved original-runtime comparisons.

No emulator is launched and no original media is modified. Each constituent
report retains its own scope; success is not full-application verification.
"""
import argparse
from datetime import datetime,timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--dictionary',type=Path,default=ROOT/'../../media/maven/session/share/maven2.1')
    p.add_argument('--output',type=Path,default=ROOT/'analysis/toolchain/portable-verification.json')
    a=p.parse_args();dictionary=a.dictionary.resolve()
    assert hashlib.sha256(dictionary.read_bytes()).hexdigest()=='2619382321bca5b52967b3515d15b0592a8e1f641bce92f65edcf06ba10edb19'
    def source_fingerprints():
        paths=[ROOT/'Makefile']
        for directory in ('reconstruction','scripts','tests'):
            paths.extend(p for p in (ROOT/directory).rglob('*') if p.is_file() and p.suffix in ('.c','.h','.py','.mjs','.sh'))
        return {str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(paths)}
    sources=source_fingerprints()
    reports=[];started=datetime.now(timezone.utc).isoformat()
    def run(command,parse=True):
        began=time.monotonic();r=subprocess.run(command,cwd=ROOT,text=True,capture_output=True,timeout=120)
        if r.returncode:
            sys.stdout.write(r.stdout);sys.stderr.write(r.stderr);raise subprocess.CalledProcessError(r.returncode,command)
        report=json.loads(r.stdout) if parse else {'stdout_tail':r.stdout[-2000:],'stderr_tail':r.stderr[-2000:]}
        reports.append(dict(command=command,seconds=round(time.monotonic()-began,3),report=report));print('PASS '+' '.join(command[:3]),flush=True)
    run(['make','check'],False)
    run([sys.executable,'scripts/replay_engine_tables.py'])
    run([sys.executable,'scripts/replay_cross_query_workspace.py'])
    run([sys.executable,'scripts/replay_shared_board_workspace.py'])
    run(['sh','scripts/build_wasm_portable.sh'],False)
    for script in ('game','history'):
        run([sys.executable,f'scripts/replay_portable_{script}.py'])
    for mode in ('exhaustive','limit','cancel'):
        run([sys.executable,'scripts/replay_portable_simulation.py','--mode',mode])
    run([sys.executable,'scripts/replay_portable_simulation_modes.py'])
    run(['node','scripts/replay_wasm_game.mjs'])
    run(['node','scripts/replay_wasm_portable_simulation.mjs'])
    run([sys.executable,'scripts/replay_portable_late.py','--capture','analysis/toolchain/late-search-live.json.gz','--prime-at'])
    run(['node','scripts/replay_wasm_portable.mjs','late-search-live','--prime-at'])
    run([sys.executable,'scripts/replay_portable_late.py','--capture','analysis/toolchain/magpie-ebon-late-live.json.gz'])
    run(['node','scripts/replay_wasm_portable.mjs','magpie-ebon-late-live','--late'])
    run([sys.executable,'scripts/replay_portable_engine.py','--capture','analysis/toolchain/poofier-cold-search-live.json'])
    run(['node','scripts/replay_wasm_portable.mjs','poofier-cold-search-live'])
    run([sys.executable,'scripts/replay_portable_endgame.py','--capture','analysis/toolchain/vid-tail-search-live.json.gz'])
    run(['node','scripts/replay_wasm_portable.mjs','vid-tail-search-live','--endgame'])
    run([sys.executable,'scripts/replay_original_magpie_matches.py','--build','analysis/toolchain/poofier-continuous-diagnostic.positions.jsonl.gz'])
    run([sys.executable,'scripts/replay_portable_late.py'])
    run(['node','scripts/replay_wasm_portable.mjs','late-search-fresh-start-live'])
    run([sys.executable,'scripts/replay_portable_endgame.py'])
    run(['node','scripts/replay_wasm_portable.mjs','endgame-search-owned-fresh-live'])
    run([sys.executable,'scripts/replay_late_search.py','--capture','analysis/toolchain/late-search-fresh-start-live.json.gz'],False)
    for script in ('turn_commit','game_turn'):
        run([sys.executable,f'scripts/replay_{script}.py','--capture','analysis/toolchain/turn-commit-burin-fresh-live.json'])
    for capture in ('heuristic-search-live','heuristic-search-live-02','heuristic-search-live-03'):
        run([sys.executable,'scripts/replay_portable_engine.py','--capture',f'analysis/toolchain/{capture}.json'])
        run(['node','scripts/replay_wasm_portable.mjs',capture])
    for script in ('turn_commit','game_turn','game_finish','history_store'):
        run([sys.executable,f'scripts/replay_{script}.py'])
    for script in ('save_records','history_serialization'):
        run([sys.executable,f'scripts/replay_{script}.py','--capture','analysis/toolchain/save-continued-end6-live.json'])
    run([sys.executable,'scripts/replay_history_playback.py','--capture','analysis/toolchain/history-continued-end6-live.json'])
    for name in ('query','board','rack_math','engine','endgame','late','simulation'):run(['sh',f'scripts/build_wasm_{name}.sh'],False)
    for capture in ('move-score-live','blank-move-score-live','two-blank-same-live','two-blank-different-live'):
        run([sys.executable,'scripts/replay_move_score.py','--capture',f'analysis/toolchain/{capture}.json'])
        run([sys.executable,'scripts/replay_apply_move.py',*(['--capture',f'analysis/toolchain/{capture}.json'] if capture!='move-score-live' else [])])
        run(['node','scripts/replay_wasm_board.mjs',capture])
    for script,captures in [('move_undo',['move-undo-live']),('rack_refill',['rack-refill-live']),('rack_composition',['rack-composition-live','rack-composition-baseline-live']),('pattern_match',['pattern-match-live','pattern-match-traced-live','pattern-match-second-position-live','pattern-match-multiple-rack-live','pattern-match-third-position-live'])]:
        for capture in captures:run([sys.executable,f'scripts/replay_{script}.py','--capture',f'analysis/toolchain/{capture}.json'])
    for script in ('pattern_cache','pattern_lookup','premium_exposure','letter_expectation'):run([sys.executable,f'scripts/replay_{script}.py'])
    run(['node','scripts/replay_wasm_query.mjs',str(dictionary)])
    run(['node','scripts/replay_wasm_rack_math.mjs'])
    run([sys.executable,'scripts/replay_opponent_samples.py'])
    run([sys.executable,'scripts/replay_simulation_setup.py'])
    run([sys.executable,'scripts/replay_simulation_restore.py'])
    run(['node','scripts/replay_wasm_simulation_restore.mjs'])
    for kind,draw in [('full-limit','draw'),('cancel','cancel-draw')]:
        capture=f'session-publication-{kind}-live';inputs=f'session-publication-{draw}-live'
        run([sys.executable,'scripts/replay_rollout.py','--capture',f'analysis/toolchain/{capture}.json','--opponent-draw',f'analysis/toolchain/{inputs}.json','--session'])
        run(['node','scripts/replay_wasm_simulation.mjs',capture,'--opponent-draw',inputs,'--session'])
    publications=[f'session-publication-exhaustive-live-{i:02}' for i in range(1,6)]
    run([sys.executable,'scripts/replay_rollout.py','--captures',*[f'analysis/toolchain/{name}.json' for name in publications],'--exhaustive','analysis/toolchain/opponent-samples-live.json','--session'])
    run(['node','scripts/replay_wasm_simulation.mjs',*publications,'--session'])
    run([sys.executable,'scripts/replay_leave_table.py','--capture','analysis/toolchain/simulation-exit-leaves-live.json'])
    run([sys.executable,'scripts/replay_rack_refill.py','--capture','analysis/toolchain/opponent-random-draw-02-live.json'])
    for capture in ('candidate-top10-filter-live','candidate-top10-eligibility-live','candidate-sampled-live','candidate-exhaustive-ranking-live','candidate-endgame-ranking-live','candidate-late-ranking-live'):
        run([sys.executable,'scripts/replay_candidate_ranking.py','--capture',f'analysis/toolchain/{capture}.json'])
    for capture in ('opening-generator-live','opening-scored-generator-live'):
        run([sys.executable,'scripts/replay_opening_generator.py','--capture',f'analysis/toolchain/{capture}.json'])
    for capture in ('opening-scored-generator-live','board-generator-live'):
        run([sys.executable,'scripts/replay_opening_moves.py','--capture',f'analysis/toolchain/{capture}.json'])
    run([sys.executable,'scripts/replay_board_placements.py'])
    run([sys.executable,'scripts/replay_leave_table.py'])
    run([sys.executable,'scripts/replay_exchange_candidates.py'])
    for i in range(1,17):
        capture='move-evaluation-live'+(f'-{i:02}' if i>1 else '')
        run([sys.executable,'scripts/replay_move_evaluation.py','--capture',f'analysis/toolchain/{capture}.json'])
    for capture in ('heuristic-search-live','heuristic-search-live-02','heuristic-search-live-03'):
        run([sys.executable,'scripts/replay_heuristic_search.py','--capture',f'analysis/toolchain/{capture}.json'])
        run(['node','scripts/replay_wasm_engine.mjs',capture])
    for capture in ('rollout-batch-live','rollout-batch-refills-live'):
        run([sys.executable,'scripts/replay_rollout.py','--capture',f'analysis/toolchain/{capture}.json'])
    run([sys.executable,'scripts/replay_rollout.py','--captures',*[f'analysis/toolchain/rollout-exhaustive-live-{i:02}.json' for i in range(1,6)],'--exhaustive','analysis/toolchain/opponent-samples-live.json','--ranking-capture','analysis/toolchain/candidate-exhaustive-ranking-02-live.json'])
    run(['node','scripts/replay_wasm_simulation.mjs'])
    run([sys.executable,'scripts/replay_rollout.py','--captures',*[f'analysis/toolchain/session-exhaustive-live-{i:02}.json' for i in range(1,6)],'--exhaustive','analysis/toolchain/opponent-samples-live.json','--session'])
    run(['node','scripts/replay_wasm_simulation.mjs',*[f'session-exhaustive-live-{i:02}' for i in range(1,6)],'--session'])
    run([sys.executable,'scripts/replay_rollout.py','--capture','analysis/toolchain/session-random-limit-live.json','--opponent-draw','analysis/toolchain/session-random-draw-live.json','--session'])
    run(['node','scripts/replay_wasm_simulation.mjs','session-random-limit-live','--opponent-draw','session-random-draw-live','--session'])
    run([sys.executable,'scripts/replay_rollout.py','--capture','analysis/toolchain/session-reply-cancel-live.json','--opponent-draw','analysis/toolchain/session-cancel-draw-live-02.json','--session'])
    run(['node','scripts/replay_wasm_simulation.mjs','session-reply-cancel-live','--opponent-draw','session-cancel-draw-live-02','--session'])
    run(['sh','scripts/build_wasm_history.sh'],False)
    run(['node','scripts/replay_wasm_turn.mjs'])
    run(['node','scripts/replay_wasm_turn.mjs','turn-commit-burin-fresh-live'])
    run(['node','scripts/replay_wasm_history_playback.mjs','history-continued-end6-live'])
    run([sys.executable,'scripts/replay_history_snapshot.py','--capture','analysis/toolchain/history-snapshot-rebuild-live.json'])
    run(['node','scripts/replay_wasm_history.mjs'])
    run([sys.executable,'scripts/replay_history_playback.py','--capture','analysis/toolchain/history-playback-end6-live.json','--next-capture','analysis/toolchain/history-navigation-end6-live.json'])
    run(['node','scripts/replay_wasm_history_playback.mjs','history-playback-end6-live','history-navigation-end6-live'])
    run([sys.executable,'scripts/replay_rollout.py','--capture','analysis/toolchain/rollout-endgame-live.json','--ranking-capture','analysis/toolchain/candidate-endgame-ranking-live.json'])
    run(['node','scripts/replay_wasm_simulation.mjs','rollout-endgame-live'])
    run([sys.executable,'scripts/replay_rollout.py','--capture','analysis/toolchain/rollout-late-live.json','--ranking-capture','analysis/toolchain/candidate-late-ranking-live.json'])
    run(['node','scripts/replay_wasm_simulation.mjs','rollout-late-live'])
    run([sys.executable,'scripts/replay_rollout.py','--capture','analysis/toolchain/rollout-random-late-live.json','--opponent-draw','analysis/toolchain/opponent-random-draw-02-live.json','--ranking-capture','analysis/toolchain/candidate-random-late-ranking-live.json'])
    run(['node','scripts/replay_wasm_simulation.mjs','rollout-random-late-live','--opponent-draw','opponent-random-draw-02-live','--ranking','candidate-random-late-ranking-live'])
    for script,captures in [
        ('endgame_tree',['endgame-tree-live.json.gz','endgame-tree-bounds-live.json.gz']),
        ('reply_bounds',['reply-bounds-live.json','reply-bounds-live-02.json','reply-bounds-live-03.json']),
        ('endgame_rack_bounds',['endgame-rack-bounds-live.json']),
        ('endgame_table_preparation',['endgame-table-preparation-live.json','endgame-table-full-preparation-live.json']),
        ('endgame_generation',['endgame-generation-live.json']),
        ('local_replies',['local-replies-03-live.json','local-replies-04-live.json']),
        ('local_score_corrections',['local-score-corrections-live.json']),
        ('endgame_leaf',['endgame-leaf-live.json.gz','endgame-leaf-403-fresh-live.json.gz']),
        ('endgame_search',['endgame-multiple-collection-search-live.json.gz','endgame-gc-seven-search-live.json.gz','endgame-blank-seven-search-live.json.gz','endgame-no-move-search-live.json.gz','endgame-deep-seven-search-live.json.gz','endgame-seven-search-live.json.gz','endgame-search-live.json.gz','endgame-simulation-search-live.json.gz',*[f'endgame-simulation-search-{i:02}-live.json.gz' for i in range(2,12)]])]:
        for capture in captures:run([sys.executable,f'scripts/replay_{script}.py','--capture',f'analysis/toolchain/{capture}'])
    for capture in ['endgame-multiple-collection-search-live','endgame-gc-seven-search-live','endgame-blank-seven-search-live','endgame-no-move-search-live','endgame-deep-seven-search-live','endgame-seven-search-live','endgame-search-live','endgame-simulation-search-live',*[f'endgame-simulation-search-{i:02}-live' for i in range(2,12)]]:run(['node','scripts/replay_wasm_endgame.mjs',capture])
    run([sys.executable,'scripts/replay_endgame_collection.py','--capture','analysis/toolchain/endgame-multiple-collection-search-live.json.gz'])
    for capture in ('late-budget-live','late-budget-controlled-live'):
        run([sys.executable,'scripts/replay_late_budget.py','--capture',f'analysis/toolchain/{capture}.json'])
    run(['node','scripts/replay_wasm_late_budget.mjs'])
    for name in ('pool_board','pool_weights','late_reply_value','late_ranking'):
        run([sys.executable,f'scripts/replay_{name}.py'])
    run([sys.executable,'scripts/replay_late_pool_select.py'],False)
    for name in ('late_local','local_pool_generation','late_preparation','late_setup'):
        run([sys.executable,f'scripts/replay_{name}.py'])
    run([sys.executable,'scripts/replay_leave_table.py','--capture','analysis/toolchain/late-leave-table-live.json'])
    run([sys.executable,'scripts/replay_endgame_collection.py','--capture','analysis/toolchain/endgame-gc-seven-search-live.json.gz'])
    run([sys.executable,'scripts/replay_simulation_restore.py','--capture','analysis/toolchain/simulation-limit-controlled-live.json'])
    run(['node','scripts/replay_wasm_simulation_restore.mjs','simulation-limit-controlled-live'])
    for capture in ('late-search-live','late-search-unseenq-live','late-search-q16-live','late-search-heldq-live','late-search-heldq-nou-live','late-search-ownblank-live','late-search-poolblank-live','late-search-q16-coverage-live'):
        run([sys.executable,'scripts/replay_late_search.py','--capture',f'analysis/toolchain/{capture}.json.gz'],False)
        run(['node','scripts/replay_wasm_late.mjs',capture])
    assert source_fingerprints()==sources,'Source changed during verification; do not publish a mixed-source checkpoint'
    result=dict(source_sha256=sources,scope=__doc__.strip(),started_utc=started,completed_utc=datetime.now(timezone.utc).isoformat(),commands_passed=len(reports),dictionary_sha256=hashlib.sha256(dictionary.read_bytes()).hexdigest(),results=reports)
    a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(commands_passed=len(reports),report=str(a.output)),indent=2))
if __name__=='__main__':main()
