# Resolved: gcmulti iteration403 disagreement

The reconstruction used the wrong column of the opponent rack table in
`maven_bound_own_rack`. The corrected native search matches all549 original
iteration checkpoints, including all8192 nodes and documented workspaces,
and the final ranking. Freestanding wasm takes549 iterations and matches
final nodes, workspaces and ranking. Wasm does not compare every intermediate
iteration. No original machine code or captured expected results were patched.

## Cause and evidence

CODE39+0558 and +0564 load a word at offset0x8ee from the opposing A table.
Each mask row is18 bytes, so0x8ee is127 * 18: full mask, depth **zero**.
The reconstruction incorrectly selected depth eight, sixteen bytes later.
The own-rack A/B/error terms in this helper still use depth eight.

At leaf403, the board and racks NOS/CQ are identical to the preserved long
trace. Opposing table values are13 at depth zero and10 at depth eight:
CQ is worth13 points, whereas the recurrence projects leaving the Q.
The helper is used when no cached opposing reply is compatible with the
candidate. For its first candidate, SNAB (24 points, kept mask0x7a), the
original reports upper59/lower56; the broken C reported53/50. In this branch
the opponent rack total contributes twice, explaining the six-point error.
The difference changes pruning and allocates two extra nodes; the failing
wasm run took550 iterations. The three garbage collections were already
correct and required no changes.

The fix is in `reconstruction/endgame_rack_bounds.c`: select
`other_a[127][0]`, with the decoded machine offset documented beside it.

## Fresh original captures

- `endgame-leaf-403-fresh-live.json.gz`: complete leaf, generation/candidates/
  replies/continuations/return snapshots. Before the fix, generation matches
  and candidates diverge. Afterward, all five boundaries match.
- `endgame-leaf-403-bounds-live.json.gz`: a second fresh search captures the
  same board/racks plus145 candidate visits and110 actual reply-bound calls.
  The first call records59/56, no compatible reply and no prune.
- Both validate the original ROM, loaded CODE resource bytes and dictionary.
  The debugger only reads memory and controls breakpoints/execution. Search
  starts through normal Open/Kibitz. Absolute allocation indices differ from
  the earlier capture, so compare each run against its own captured state.
- The older `endgame-leaf-403-live.json.gz` remains an incomplete failed
  recorder attempt and is not evidence. Fresh mode warms the first leaf,
  resolves loaded code afresh, then reaches the requested later leaf.

Reproduce a fresh capture after opening gcmulti in the original guest:

```sh
python3 scripts/capture_endgame_leaf.py --fresh-search --skip 402 --count 1 \
  --trace-bounds --output analysis/toolchain/endgame-leaf-403-bounds-live.json.gz
# Trigger normal Kibitz after the recorder reports it is waiting.
```

Historical capture console labels said402 after excluding the warmed leaf;
`requested_leaf` is403. Recorder logging now uses the actual one-based leaf
number. The underlying skip count and breakpoint behavior are unchanged.

## Regression and porting

```sh
python3 scripts/replay_endgame_leaf.py --capture analysis/toolchain/endgame-leaf-403-fresh-live.json.gz
python3 scripts/replay_endgame_search.py --capture analysis/toolchain/endgame-multiple-collection-search-live.json.gz
node scripts/replay_wasm_endgame.mjs endgame-multiple-collection-search-live
python3 scripts/replay_endgame_collection.py --capture analysis/toolchain/endgame-multiple-collection-search-live.json.gz
python3 scripts/verify_portable_replays.py --output analysis/toolchain/portable-verification-403-fix.json
```

The first four are now part of the expanded regression runner. All166
commands passed, including77 host tests and rebuilt wasm modules. The report
`portable-verification-403-fix.json` records each command and scope. Eighteen complete endgame fixtures are now
accepted; this does not establish complete branch or application coverage.
When porting or changing evaluation, preserve the distinction between the
full opposing rack and projected rack value. Both host and wasm compile the
same corrected C; no target-specific workaround is needed.

Disposable QEMU67277/session71379 and capture sessions85959/86042 exited.
Breakpoints were removed and verified by recorder cleanup before VM exit.
The previous seven-hour automation remains paused.
