# BURR discrepancy: mask-table alias lost by the reconstruction

## Finding

The residual74-unit (0.74-point) difference was a reconstruction bug, not an
unidentified quirk in Mac Maven. The reconstructed late search had two C copies
of a mask array that is one global table in the original. It initialized a
special mask in one copy and then overwrote it with an older value from the
other. Certain opponent-rack combination counts became wrong. The final BURR
adjustment became1678 instead of the original1752; the actual move score1200
was unaffected.

This is separate from the genuine original crossing-buffer/row-flag overlap.
That earlier issue explains why a fresh search of the target board differs
from a search after some previous positions. Both state effects were needed
to understand the older trace; only the crossing-buffer dependency belongs
to the original executable.

## Original evidence and exact data flow

The original occurrence-mask table is at A5-0x4c0c. CODE42+0x8c points A4 at
A5-0x445c, which is occurrence_masks[123][0]. CODE42+0x92 writes0xffff and
continues across the special scratch cells. These are masks for the synthetic
'{' population used while counting seven-tile racks from the unseen pool.
They must not behave like real physical tile occurrences.

`late-search-live.json.gz` contains0xffff in these cells at entry and through
all relevant phases. More decisively, `late-search-fresh-start-live.json.gz`
starts with zeros, shows0xffff at pool_ready, and retains it through
leaves_ready and own_ranked. Initialization happens in the current search;
it does not require unknown previous operations.

The C data flow before the correction was:

1. `maven_prepare_pool_weights` initializes `search.occurrence_masks`, including
   the synthetic-population sentinels.
2. `maven_prepare_search_leave_table` updates a distinct
   `leaves.occurrence_masks` array for letters in the player's rack. Unused
   cells in this copy still contain their earlier values, often zero.
3. A full copy from the leave array into the search array overwrites the newly
   initialized sentinels.
4. Later local constraints call `maven_count_pool_racks` with the bad masks.

The fix copies the current search masks into the leave-array view immediately
before leave preparation. That preparation changes only relevant rack cells;
copying its result back now preserves the original shared-table behavior.
No hardcoded historical mask value or captured workspace is used by the fix.

## How the discrepancy was isolated

`diagnose_burr_state.py` generates separate instrumented C probes. Explicit
state-injection options are controlled diagnostics, not standalone acceptance.
The results distinguished several tempting explanations:

- Restoring captured empty-square values did not remove the74-unit difference.
- The baseline pool's unused byte65 differs but is not responsible.
- The fallback evaluation cache matches the captured-state component replay.
- Local reply records match. The first significant difference is in the
  counts/weights assigned to their rack constraints, beginning at the first
  local refinement.
- Restoring only `leaves.occurrence_masks[123][0]=0xffff` eliminates the final
  difference in the diagnostic. Synchronizing the actual arrays eliminates
  it without injecting that constant.

The corrected active constraint weights match the actual original capture at
all24 relevant checkpoints, including65 active weights at the last refinement.

Examples from the first local refinement: incorrect924 becomes714,462 becomes
336,7 becomes2, and210 becomes140. Earlier nine refined rankings remain the
same despite these weight differences; the final BURR ranking exposes them.

## Reproduction without captured-memory initialization

Use the original resources and dictionary, create an owned engine, then:

1. Set an AT board: row8, columns8 and9; rack `?abcdef`, opponent `ghijklm`.
2. Run the public heuristic search. Ordinary crossing queries recreate the
   retained `tvw` bytes in the upper half of the shared crossing buffer.
3. Set the board/rack from `late-search-live` and run forced late search.

The corrected owned engine matches all340 original ranking bytes, including
BURR1752. Both native and wasm pass three repeated late searches after this
predecessor. Resources and dictionary inputs are overwritten/freed before
search, and no original caches/tables/scratch buffers are injected.

AT is a sufficient constructed predecessor, not proof that this was the exact
historical sequence before the old capture. Existing original AT query captures
prove the crossing-buffer mechanism; no new original VM session was needed
for this diagnosis.

A counterfactual build removes only the new transfer and executes the same
public AT->target sequence. It produces the original unresolved failure again:
ranking byte333 is0x8e rather than0xd8, BURR1678 rather than1752. This guards
against attributing success to an unrelated earlier change.

## Evidence and commands

- `burr-state-analysis.json`: compact structured findings and original-capture hash.
- `burr-controlled-before.jsonl.gz`: instrumented counterfactual C trace.
- `burr-controlled-after.jsonl.gz`: instrumented corrected C trace.
- `code42-corrected.asm`: original sentinel initialization.
- `portable-verification-burr-fix.json`: **223-command passing regression report**, including79 host tests and the two new owned AT->target cases.

```sh
python3 scripts/replay_portable_late.py --capture analysis/toolchain/late-search-live.json.gz --prime-at
sh scripts/build_wasm_portable.sh
node scripts/replay_wasm_portable.mjs late-search-live --prime-at
python3 scripts/diagnose_burr_state.py --prime-at
python3 scripts/diagnose_burr_state.py --prime-at --omit-mask-transfer
```

The last command is expected to display the74-unit mismatch. It compiles a
separate temporary control and does not modify the production source or any
original executable.

Final verification completed 2026-09-10T00:39:53.443476+00:00. All source fingerprints
remained unchanged during the run. All local probe/regression processes exited.
