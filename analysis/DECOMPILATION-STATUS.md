# Mac Maven decompilation status

CORRECTION: POOFIER is resolved as a harness lifetime mismatch, not a scorer
defect. The omitted CODE29 shared-record clear is also fixed. Strict replay
of the continuous original sequence matches all 277 positions / 2,722 records.
See [POOFIER](toolchain/POOFIER-DISAGREEMENT.md),
[VID scratch](toolchain/VID-SCRATCH-FIX.md), and the new
[instruction-to-C audit](instruction-audit/README.md).

Magpie-driven games exposed an additional late-search discrepancy: the original
blank generator leaves its board cursor inside some words, and imported empty
squares have zero values. Both behaviors are now reconstructed. All 90 baseline
multiplicities and all 340 final ranking bytes match the EBON capture. See
[EBON-FIX.md](toolchain/EBON-FIX.md) and
[game comparison scope](toolchain/MAGPIE-GAME-COMPARISON.md).

BURR follow-up: the residual0.74-point difference was a reconstructed mask-table
aliasing bug. A corrected public AT->target sequence matches all original
ranking bytes in native/wasm. See [the causal evidence](toolchain/BURR-FIX.md);
this supersedes the older unresolved-BURR statements below.


## Current owned API acceptance

All five scoped behavioral steps are accepted. The final
[230-command verification report](toolchain/portable-verification-scratch-lifecycle.json)
includes79 host tests and records unchanged source fingerprints.


The owned native/wasm interface now includes heuristic, late and endgame search,
simulation, ranked play, scoring/refill/statistics, history selection and
original save/load. See [PORTABLE-API.md](PORTABLE-API.md) for the current
contract and [BEHAVIORAL-COMPLETION.md](BEHAVIORAL-COMPLETION.md) for acceptance
evidence. Native/wasm consecutive exhaustive and cancelled simulations match
154 refills,458 events and seven publications with continuous private RNG.
The wasm game cycle includes repeated load, history selection, search, BURIN
commit, preserved future history, save and reload. These statements supersede
older unfinished-interface/session/CPU-gate claims in the chronological notes.
The broader decompilation and a modern user interface remain separate work.


The iteration403 disagreement is fixed. CODE39's no-compatible-reply fallback
reads the opponent's full rack points at depth zero, not the depth-eight
projection. The preserved549-iteration search now matches native and wasm;
eighteen complete endgame fixtures are accepted. See
[the fix evidence](toolchain/ENDGAME-403-FIX.md).

The earlier seven-hour window ended at21:05:30UTC; its heartbeat stays paused.
The subsequent user-requested fix used disposable QEMU67277/session71379,
which has exited after capture. The full decompilation remains unfinished.

## Current generation and ranking progress

As of20:49UTC, readable nativeC and freestanding wasm match three complete
CODE28 heuristic searches:328,613,588 candidate callbacks, final ten records,
and application/leave/cache/scorer state. Opening generation7394 placements
and4381 scored records includes a blank; occupied-board generation377
placements/222 records matches full order and bytes.16 complete CODE35
collector calls,96 exchange records and full128-mask leave preparation match.

CODE3 now has a connected finite exhaustive simulation path: five original
opponent-rack batches,150 computed refills and450 state checkpoints match in
native C and freestanding wasm, including the final averaged ranking. Native
private RNG continues across all batches; original clock/Toolbox Random inputs
remain explicit. CODE38 enumeration matches all five racks and multiplicities
for the eight-unseen-tile fixture. A second full batch enables End Analyzer:
20 complete endgame searches,249 clock reads,30 refills and90 state boundaries
match native/wasm through the unified search selector. A late-enabled batch also matches19 late searches,30 refills and90 boundaries.
A further connected trace computes the original opponent draw before all19
late searches/30 batch refills, retaining private RNG state across the seam.
Ordinary Escape restoration and a deliberately lowered sample-limit exit
now have separate native/wasm buffer acceptance. Post-session leave rebuilding
has its own original trace; a complete portable session controller remains open.

Eighteen complete CODE30 search fixtures match native and wasm, spanning
zero-iteration no-move return through549 iterations. Native compares all8192
nodes and workspaces per iteration; wasm compares final nodes/ranking/state.
The120-iteration GC fixture separately matches pruning+marking and
sweep+unmarking across all8192 nodes, reclaiming7057 and retaining1135.
A blank-rack endgame matches, as does the no-move early return with one pass
record and retained old tree state. The original targets pass nodes for leaf expansion at four checkpoints in
deep7 and20 in gc7; deep7 also preserves shared child lists from iteration147. The larger repeated-collection fixture now matches all549 native iteration
checkpoints and the wasm final state/ranking. Its three captured GC operations
also match in isolation. The former iteration403 failure and its resolution
remain recorded in `toolchain/known-replay-failures.json`.
The A5-5a32 scratch alias retains bytes after NUL from the last leaf record.

Complete CODE36 orchestration matches eight original searches in native C
and freestanding wasm: 13 unseen tiles, unseen Q with13/16 tiles, own Q with
and without U, own blank, and unseen blank; the eighth repeats the16-tile Q
case with branch coverage. Exchange-eligible positions are included. Native
compares30 selected stage checkpoints and all final ten move records; wasm
compares final state/ranking/pools, not each checkpoint. Both90-record pools
exclude serialized pointer bytes; constraint contents and list effects are
compared separately. Constructed saves are searched through normal Open/Kibitz.
Force0 simulation integration now matches the connected traces above.
CPU-calibrated fallback and cancellation remain open.

Expanded regression166 passed after the iteration403 fix, including77 host
tests, rebuilt wasm modules, all18 accepted endgames, leaf403 phases and
the three gcmulti collections. See `toolchain/portable-verification-403-fix.json`.
The CPU workload gate has static boundary tests and awaits its original
decision capture and shared-selector integration.
No complete playable application or comprehensive coverage is claimed.

## Compiler and linker evidence

Recovered THINK C5.0.2 and 6.0.1 both compile, link, and run a comparison probe
in the disposable classic Mac VM. THINK6's entire566-byte startup body
matches Maven CODE1; the whole578-byte resource differs only in the
application-specific A5 entry field. THINK5 matches the shared506-byte helper
body but lacks the additional startup thunk. This strongly identifies the
THINK runtime family, but does not uniquely prove the exact original compiler
release, linker release, optimizer options, or provenance of every object.

All1,392 bytes and 31 jump-table entry offsets of Maven CODE34 can be rebuilt
from the recovered MacTraps library's symbol metadata and a selected name
list. That reproduces one library segment's selection/order/header behavior;
it is not a complete linker or whole-program reconstruction. See
`toolchain/THINK-C-EVIDENCE.md` and `toolchain/MACTRAPS-PROJECT-SYMBOLS.md`.

## Recovered behavior with original-runtime evidence

- Dictionary startup/file reading, root tables, lookup, and four Word List
  enumerations totaling149 ordered results.
- Move scoring and integrated non-evaluation application: ordinary opening
  move plus three documented blank fixtures; original scores, blank
  coordinates, board/value/undo/count state all match native C and wasm.
- Original undo and rack refill, including observed random/time inputs.
- Saved-game record writing and portions of history restoration.
-22-field per-player move statistics inputs and accumulation. These were
  initially mislabeled ranking features; the downstream consumer establishes
  statistics use. This does not identify the complete AI ranking formula.
- Rack-composition recurrence: terminal and full seven-level baseline calls.
- SANE-based letter expectation:24 natural calls match an exact-integer port
  in native C and wasm; numerical bounds and excluded environments documented.
- Adjacent-premium penalties: two original calls, including a nonzero penalty.
- Pattern-cache construction:2,263 records become125 identical entries;
  64 lookups match scores and returned accumulator-entry identities.
- Rack/board pattern matcher: observed rack-record paths and restored count
  state match C; broader board/blank/Q branches have focused host tests.

The source-associated range inventory in `toolchain/reconstruction-inventory.json`
records each range and its evidence limitations. It is not a completeness
percentage. CODE resources also contain data and metadata.

## Portable builds already running

`make check` builds the native reconstruction library and runs the host
suite. Current broad verification passed76 host tests and142 build/replay commands;
see `toolchain/portable-verification.json`. Replay scripts separately compare captured original runtime calls.

`sh scripts/build_wasm_query.sh` builds a freestanding dictionary/query module.
`node scripts/replay_wasm_query.mjs PATH/TO/maven2.1` replays149 ordered words.
The original dictionary file is fingerprinted; arbitrary files are not a
supported input contract.

`sh scripts/build_wasm_board.sh` builds the same C scorer, application, and
undo routines for wasm. `node scripts/replay_wasm_board.mjs` runs the base
capture; append `blank-move-score-live`, `two-blank-same-live`, or
`two-blank-different-live` for direct blank/application comparisons. These
modules have no imports and run in Node. Browser UI, a complete playable
game, and the full AI are not implemented.

`sh scripts/build_wasm_rack_math.sh` builds the exact-integer expectation
and composition routines; `node scripts/replay_wasm_rack_math.mjs` compares
24 expectation and 2 composition calls. This third module also has no imports.

Run `python3 scripts/verify_portable_replays.py` for the native suite, all
three wasm builds, and the selected original-runtime replays in one command.
Its report preserves each component’s scope; it launches no emulator.

## Modification and porting entry points

| Intended change | Recovered boundary | Preserve before changing policy |
|---|---|---|
| Dictionary queries | dictionary_tables/query_prepare/word_enumerator | Data format, original ordering, counted/terminated lookup distinctions |
| Scores or premiums | score_move/score_accumulate, explicit letter and premium tables | Fixed-width wrap/truncation, blank value separate from represented letter |
| Board editor or new UI | apply_move/place_letters/move_finalize/undo_move | Paired board representation, undo record, counts and value grid kept consistent |
| Randomness or deterministic replay | rack_refill callbacks and private generator | Recorded clock/random sequence; original timing affects shuffle behavior |
| Rack-balance tuning | rack_balance/rack_composition and terminal tables | Repeated integer division, one-blank averaging versus two-blank maximum |
| Pattern weights | pattern_cache/pattern_lookup/pattern_match/adjusted_pattern_lookup | Borrowed-string lifetime, full32-bit total versus low16-bit emitted weight |
| Numerical expectation | letter_expectation and coefficient tables | Signed32 differences, exact64 arithmetic bounds, truncation, fixed96-tile baseline |
| Adjacent premium penalty | premium_exposure and 20-record table | Direction and neighbor-emptiness rules |
| Text/dialog replacement | reconstructed text/navigation dispatch with callbacks | Separate compatibility behavior from native/browser event handling |
| File/save adapters | whole_file/save_record/history components | Original BE formats and optional/unknown tags; restoration still partial |

For a modern OS build, keep recovered engine state explicit and place file,
UI, allocator, clock, and random adapters outside the compatibility routines.
For wasm, use validated buffer offsets/handles rather than guest or native
pointers, decode BE fields explicitly, and run long engine work in a worker.
Current wasm bridges are trusted research interfaces with fixed capacities;
a public interface needs validation, cancellation, and defined error results.
Preserve a compatibility mode and its runtime fixtures before tuning behavior.

## Remaining work

Original validation of the assembled collector, completion of move generation/ranking/search, other floating-point
table initialization, full history/game orchestration, and large portions of
Mac UI/Toolbox integration remain unreconstructed. Error and rare-input paths
are not all traced. Original floating-trap call sites are rewritten at runtime;
verify exact executed ranges rather than masking arbitrary mismatches.

Next useful experiments: complete CODE35 collector terms around the recovered
pattern matcher, follow actual ranking consumers, capture board-pattern and
cross-word blank cases, connect remaining game orchestration, and add a modern
front end only over verified engine boundaries. Continue code-generation
comparison probes to narrow toolchain settings. Do not infer exact compiler
version merely from the matching runtime library.

The crossing-word availability helper, rack-mask helpers, and adjusted
pattern wrapper are reconstructed with host tests; direct original call
verification remains pending for those composite helpers. Some replay tools
currently build macOS `.dylib` files with `-dynamiclib`; adapt that harness
flag/output suffix when testing on Linux or Windows. Native Linux/Windows
and browser integration have not been run here.

The final preserved compiler artifact audit is
`toolchain/toolchain-final-verification.json`; the final exact CODE34 link
report is `toolchain/code34-final-link-verification.json`. Source and notes
remain uncommitted.

Detailed chronological evidence and process accounting: `SEVEN-HOUR-RUN.md`.
Modification notes and corrections: `PORTING-NOTES.md`. Preserved original
media and comparison toolchains live under the parent repository's ignored
`media/maven` directory; source/notes and replay tools are in this repository.
