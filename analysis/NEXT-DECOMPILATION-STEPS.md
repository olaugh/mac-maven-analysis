## Current priority — instruction-to-C effect audit

POOFIER and VID are resolved; see [the current audit](instruction-audit/README.md).
The latest frozen-source suite passes 230 commands. Continue systematic original
instruction/register/memory-write mapping from the existing C functions, with
shared storage and partial writes first. Older proposals and counts below are
historical.

## Five behavioral steps accepted — further investigations

The authoritative checklist and process ledger are now
[BEHAVIORAL-COMPLETION.md](BEHAVIORAL-COMPLETION.md). The five scoped features
are implemented and accepted; the final frozen-source suite passed221 commands. The current owned
native/wasm contract is [PORTABLE-API.md](PORTABLE-API.md). Do not restart
snapshot loading, CPU-gate recovery, session publication, history ownership
or standalone initialization from the older instructions below: those paths
now have concrete original and portable acceptance.

Further work beyond that scoped acceptance can target:

1. BURR is now explained and fixed: see [BURR-FIX.md](toolchain/BURR-FIX.md).
   A clean original AT whole-generator/repeated-position capture would broaden
   evidence for the separate original crossing-buffer alias, but is no longer
   needed to explain the74-unit discrepancy.
2. Build a modern UI or worker host around the owned API, adding live clock,
   cancellation and RNG callbacks. The shipped wasm adapter is a deterministic
   bounded input-stream bridge, not an interactive browser application.
3. Add intentional modern policies as separate configurations: budgets,
   evaluator changes, resource/dictionary variants and a save format that
   preserves active side/statistics. Keep compatibility fixtures unchanged.
4. Expand original fixtures where they answer a specific remaining coverage
   question. Cooperative cancellation is implemented; classic nonlocal UI
   exceptions inside a selector are not claimed equivalent.
5. Continue compiler/linker fingerprinting or full classic UI decompilation
   if requested. Behavioral acceptance does not identify exact original
   project options or establish byte-exact recompilation.

No emulator or recorder remains owned. The old seven-hour automation is
paused. The final foreground regression has completed; no new background run or
user-visible machine action is implied by this document.

Older notes below are historical leads and may describe completed work.

# Next decompilation session

Current tested status is in `DECOMPILATION-STATUS.md`; this file identifies
concrete next investigations rather than promising a complete playable port.
All addresses below are resource-relative, including the 4-byte CODE header.
Resolve live addresses again after loading or UI transitions.

## Active run priority (16:06UTC update)

1. Complete CODE37 local-reply region generation and apply/enumerate/undo;
   capture/replay_local_replies.py. Read the process ledger before attaching.
2. Validate CODE39+4 local score corrections, then connect CODE29 tightening
   and CODE45 leaf expansion to the accepted CODE40 pipeline and tree.
3. Complete CODE30 main solver and original final-choice comparisons; recover
   CODE36 late-game search, proven to run at CODE36+1810.
4. Preserve saved fixtures maven-search-late13 and maven-search-end6 on the
   disposable session share. Do not modify the original user disk images.
5. Broaden blank/terminal/pass/GC runtime coverage; integrate new accepted
   modules into native/wasm regression. CODE38 exact enumeration still needs
   original acceptance. Avoid repeating already accepted heuristic work.

Use SEARCH-SEVEN-HOUR-RUN.md for deadline and current process ownership.
The older numbered investigations below are historical leads; completed
collector work is now documented in DECOMPILATION-STATUS.md and its captures.

## 1. Verify and finish the CODE35 collector

The main collector spans[0x36c,0xa48). Its dependencies now include recovered
rack counting/unseen counts, move application/undo, adjacent-premium penalty,
rack composition, binomial letter expectation, and pattern matching.

- Opening term[0x39c,0x3d8) uses move length (or0 for row-zero moves),
  the table at A5-0x2a98 with 28-byte records/+24 longs, and emitted ID-32.
- Adjacent-premium term[0x3d8,0x6a6) is now `premium_exposure.c`; nonzero
  penalties emit ID20000.
- [0x6a6,0x7ea) applies the move temporarily, classifies the unseen pool and
  residual rack, clamps draws, emits balance ID-1, and conditionally emits
  ID-33 from the short table at A5-0x6122 (relative to entry8).
- [0x7ea,0x978) contains expected draw values and Q/U adjustments. Decode
  the strings at A5-0x8e0/-0x8de and tables at A5-0x8fe/-0x926 with actual
  runtime inputs before assigning final strategic names.
- [0x978,0x9f8) adds per-distinct-residual-letter expectation differences,
  including the fixed96 baseline. `letter_expectation.c` supplies the
  numerical operation; the orchestration now exists in `move_evaluation.c` and needs original traces.
- [0x9f8,0xa48) invokes recovered `pattern_match.c`, checks residual counts,
  undoes the temporary move, rebuilds counts, and returns accumulated value.

Capture a whole original collector call, including all table inputs and
observable state before/after. Match individual emitted IDs/weights as well
as the total; equal totals can hide compensating mistakes. Preserve optional
NULL output pointers instead of injecting replacements. Emission-site
breakpoints in `capture_pattern_match.py --trace-matches` show that technique.

## 2. Follow actual search and ranking consumers

The22-long vector recovered earlier is consumed as per-player move statistics,
not established as the ranking function. Trace the collector's return value
and candidate comparison sites separately. CODE32[0x9dc,0xc00) and
[0xefa,0x115c) contain related rack-mask calculations using the recovered
composition, pattern lookup, expectation and generation-stamped mask helpers.
Their precise role and complete control flow remain work.

`cross_word_possible.c` reconstructs[0x6a2,0x7c0), but its attempted normal
trace did not hit. Audit callers and code-pointer references before trying
repeated UI actions. A timeout is not evidence that the helper is broken or
that it runs on every ordinary candidate. The final linear CODE32 scan and
CODE0 audit found no direct target reference or exported entry for0x6a2;
see `toolchain/cross-word-reference-audit.json`. Computed pointers and global
reachability remain unaudited. Retained unreferenced code may help investigate
linker selection granularity, but this is not yet proof of dead code.

## 3. Expand original-runtime cases deliberately

- Anchored board patterns, including blank values and Q with multiple allowed
  letters. Current accepted matcher traces exercise rack records only.
- Cross-word scoring, existing blanks, bingo scoring, and diverse premiums.
  Three controlled blank saves already cover one blank/two same/two different
  missing letters for AORTAE at an opening position.
- Endgame and small-bag refill. Retain the observed-stack-ticks dependency in
  the small-bag path until a natural trace settles initialization behavior.
- Full saved-game restore/play/undo orchestration. The current component
  replays exclude portions of history, player totals, refill and UI state.

Use existing fixture manifests and normal Open, not silent board stamping.
The historical dictionary/table version belongs in every measurement.

## 4. Narrow compiler/linker settings

The recovered THINK6 startup and CODE34 library selection are exact matches,
but the small main probe compiles identically in THINK5 and 6. Use additional
small controlled source probes that resemble recovered Maven functions:
structure/aggregate arguments, signed/unsigned promotions, bit operations,
loops and switch lowering, and calls across segments. Compare emitted bodies,
relocations, headers and entry offsets. Keep library-family evidence separate
from compiler-release evidence. Original project options and full linking
behavior remain unknown.

## 5. Port incrementally through tested interfaces

The three wasm modules already execute dictionary queries, board/scoring/undo,
and rack mathematics. A worker can expose these components through validated
buffer offsets, explicit state and cancellation. A complete game/AI interface
must wait for, or explicitly replace, the remaining orchestration/search.

The native library is standard C, while some replay harnesses use macOS
`-dynamiclib` and `.dylib`. Adapt those build flags for Linux/Windows and run
the same captured-input comparisons there. Do not count cross-compilation
alone as runtime verification. Keep versioned original tables separate from
user-modifiable tuning data, and retain a compatibility mode.

## Reproduce the completed checks

From the repository root:

```sh
python3 scripts/verify_portable_replays.py
python3 scripts/verify_toolchain_artifacts.py
python3 scripts/reconstruction_inventory.py
```

The first command launches no VM and writes a scoped verification report.
The second rechecks preserved compiler artifacts; it does not perform a fresh
classic compile. For CODE34, use the documented symbol-link command in
`toolchain/MACTRAPS-PROJECT-SYMBOLS.md`. Original media/toolchains remain under
the parent repository's ignored `media/maven` directory.
