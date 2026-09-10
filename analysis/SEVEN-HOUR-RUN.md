# Seven-hour work window

Current overview: [DECOMPILATION-STATUS.md](DECOMPILATION-STATUS.md).
Next investigations: [NEXT-DECOMPILATION-STEPS.md](NEXT-DECOMPILATION-STEPS.md).
The chronological notes below retain superseded findings and explicit corrections.

User authorized continuing full decompilation and documenting future code
modifications and ports to modern OSes or WebAssembly.

Start: 2026-09-09 06:55:02 UTC (September 8, 11:55 p.m. Pacific).
Deadline: 2026-09-09 13:55:02 UTC (September 9, 6:55 a.m. Pacific).
Continuation automation: `mac-maven-seven-hour-decompilation`, every ten
minutes. On first wake at/after deadline, finish the handoff and pause it.
The larger goal remains active after this window; this is not a completion
deadline for a complete decompilation.

At each continuation verify current time, newer user instructions, worktree
state, and any actual owned process handles. Do not trust an old PID or a
socket's mere presence. Recheck exclusive emulator ownership before launch.
No newly launched processes in this run as of the initial ledger entry.

## Initial state and next work

* Compiler evidence points to THINK C 6-era startup runtime. Exact release
  and linker options remain unproven.
* CODE 34 rebuilds from 31 selected symbol intervals in recovered MacTraps.
  Five prefix-based labels were corrected using whole intervals; use the
  updated mactraps-symbols.json, never the former prefix map.
* 102 candidate A5 calls catalogued; selected callers statically decoded.
* Original runtime traces cover some dictionary, word enumeration, scanner,
  initializer, arithmetic, and file-check behavior, not the full application.
* New file_metadata.c reconstructs two CODE 47 helpers. Callback tests verify
  exact input bytes, synchronous calls, outputs on error, and physical-size
  addition wraparound. Natural parameter-block captures remain pending.
  See PORTING-NOTES.md.

## Initial batch results

`make check` passed all 32 tests; reconstruction inventory regenerated.
Owned build/test session 48538 exited 0. No emulator was launched in this
batch. The shared zeroing routine at CODE 11 [0xc5c,0xc7e) was disassembled:
it clears bytes up to the computed end, supporting the parameter-block
initialization in both new helpers. These are static/host checks, not a
natural runtime verification claim.

Next: use current source and natural UI paths to capture CODE 47 metadata
helpers or TextEdit's word-break callback. Avoid artificial input injection
being labeled as natural behavior. If no caller triggers these readily,
continue a coherent game/save or query caller chain with a documented trace.

Priority: follow real application behavior through owned disposable QEMU
sessions and reconstruct coherent caller chains. Verify loaded resource
identity and the debugger's known-answer ROM probe before capture. Preserve
original media, isolate guest writes, remove owned breakpoints, and stop or
explicitly account for every owned session before handing off.

## 07:05 UTC continuation

Revalidated time and worktree. Elevated pgrep found no qemu-system-m68k
process (exit 1); no VM started this batch. The initial sandboxed process
query could not access sysmond and was not treated as an absence result.

Decoded the volume lookup's comparison, CODE 23 [0x17a,0x1be). It skips the
last character and sign-extends the length, so equal lengths 128..255 compare
equal regardless of payload. Source now preserves this in pascal_string.c;
volume_lookup.c reconstructs CODE 47 [0xd0,0x12c), including persistent
parameter-block contents, 16-bit index wrap, and no output store on error.
Static bytes/instructions saved in volume-lookup-static.json. These are not
natural runtime observations. Porting notes explain the compatibility issue.

All 33 tests passed, including every Pascal length and each possible differing
character position, exact initial volume parameter-block bytes, first mismatch
then historical match, and error output preservation. Owned test session 92656
exited 0. Inventory regenerated and diff whitespace check passed.

Next runtime priority remains natural captures. No process ownership to inherit.

## 07:15 UTC continuation

Rechecked time and ledger. No owned emulator was inherited or launched.
Located CODE 47 exports/callers: metadata and volume helpers are not CODE 0
exports, while the whole-file loader at +0x25c is called from CODE 15+0x1a
and two other candidate sites. This is the stronger natural startup target.

Reconstructed whole_file.c with mutable read count, allocation-size check,
NUL termination, and original missing-close error paths. Tests assert complete
callback order for success and six failures, including successful short read.
All 34 tests passed; owned build session 69519 exited 0. Updated port notes
with concrete filesystem changes and compatibility limits.

Next: launch the disposable VM after checking ownership; use capture_startup
to stop before main, then catch A5+0xd3a (CODE 47+0x25c) through normal startup.
Resolve LoadSeg, verify all CODE 47 bytes, and record each Toolbox result and
returned file data. Do not call the helper artificially or inject arguments.

## 07:25 UTC continuation

Fresh process check found only a transient broad-pattern match; a follow-up
exact-name query and PID inspection found no emulator. Launched owned VM
session 12982 and verified the ROM signature through the GDB connection.
Inspected screenshots, dismissed the boot notice, selected Maven in Finder,
and captured startup (session 88374 exited 0). Startup artifacts are under
.build/startup-whole-file.

New capture_whole_file.py observed the real startup call (session 98850
exited 0). All CODE 47 bytes matched. Six operation results, entire returned
data hash, and trailing NUL verified: 1,070,788 data bytes, allocation 1,070,789,
all error codes zero. Evidence saved as whole-file-live.json. No guest argument,
register, or data injection. The initial pre-GetEOF length was uninitialized
caller storage. It is not a valid file length.

Owned QEMU session 12982 shut down through QMP after capture. Next: replay
the exact captured success through C, then pursue the file's caller and the
dictionary initialization chain or a natural TextEdit callback capture.

## 07:35 UTC continuation

Rechecked time and saved capture; no owned process inherited. Added
whole_file_probe.c and replay_whole_file.py. The C reconstruction executes
against a native filesystem adapter, using recorded name/volume and initial
output storage. Replay verifies original resource/data hashes and matches
the operation order, file length, allocation size, full returned bytes, and
NUL. Evidence is whole-file-replay.json. Guest pointer identity and original
error paths are explicitly outside this replay's scope.

Reviewed CODE 15 [4,0xd2) and index_file.c again. This caller searches the
last records of the loaded data for an 'a' byte; its output is a record index.
Next useful work: expose its existing API in a header and integrate it with
whole_file.c, then capture caller arguments and final index naturally. The
current loader capture does not save its return PC, so do not claim that it
alone proves which of the three caller candidates invoked it.

## 07:45 UTC continuation

Rechecked time and source state; no owned emulator inherited or started.
Exposed index_file.h and connected index_file.c to whole_file.c via the native
probe. The complete original data file loads unchanged and yields record
index 267671 (low byte 'a'). Saved index-file-integration.json; this caller
result is host-checked, explicitly not live-verified. Added scan-boundary and
active-error-frame tests. Initial test compilation hit a macOS libc `index`
name collision; renamed the test variable to record_index and reran checks.

Port notes now describe the EOF-relative dictionary-index assumption and why
appending metadata or changing packaging needs explicit compatibility work.
Next capture should save the loader caller PC and, if it is CODE 15+0x1e,
continue through its original index-return path. Avoid inferring that caller
identity from the loaded filename alone.

Final validation: all 35 tests passed; owned session 23242 exited 0. Both
plain loader replay and integrated index replay passed after the probe change.
No owned processes remain.

## 07:55 UTC continuation

Verified no exact-name QEMU process, launched owned session 29947, performed
ROM handshake, and used screenshot-guided Finder launch. Startup capture
session 95560 exited 0. Extended capture_whole_file.py matches full candidate
caller resources and follows the identified caller to return. Capture session
20608 exited 0; evidence is whole-file-caller-live.json.

Actual startup caller is CODE 2+0x108, not CODE 15. Full loaded CODE 2 and CODE
47 matched. Captured roots 122166/145476 and table bases allocation+12/+488780,
with both root low bytes 'a'. Documented in DICTIONARY-SETUP.md. The CODE 15
index helper's natural caller remains unknown. QEMU session 29947 was quit
through QMP and exited 0. No owned processes remain.

Next: reconstruct coherent CODE 2 [0xf4,0x18a) dictionary setup and replay its
four globals against this live capture. Retain the distinct CODE 15 path and
avoid claiming the host-only index result was observed during startup.

## 08:05 UTC continuation

Rechecked time, source, and the latest capture. No VM inherited or launched.
Added dictionary_setup.c/.h covering CODE 2 [0xf4,0x18a), using the whole-file
loader, existing error context, persistent roots/table pointers, and diagnostic
callback. C table-installation replay matches the natural roots 122166/145476,
offsets 12/488780, and both root records. Evidence: dictionary-setup-replay.json.
The installation replay and previous loader replay are separate; do not call
this a full application or browser replay.

Build plus existing 35 tests passed (owned session 27746 exited 0). Added and
passed a separate diagnostic/load-error test afterward: it verifies the second
check re-reads globals modified by the diagnostic and load failure leaves old
table state intact while transferring through the error frame. Inventory and
porting notes updated. No owned processes remain.

Next useful integration: connect installed table state to the existing lookup/
enumeration interfaces, preserving original section ordering and root bases,
then replay recorded queries through that complete load-to-enumeration path.

## 08:15 UTC continuation

Rechecked time and driver source. Replaced its direct fread/hardcoded roots
and table offsets with maven_load_dictionary and a native single-file Toolbox
adapter (scripts/native_file_ops.h). Query preparation and enumeration now
receive installed state. Updated the temporary-build Python entry point and
Makefile dependencies. No VM was inherited or launched.

All 36 tests passed; owned session 17474 exited 0. New replay_loaded_queries.py
builds the driver then verifies all 149 ordered words across four captured
natural queries. Evidence: loaded-query-replay.json. Standalone Python driver
also produced the expected four CAT words. This joins previously separate
reconstructed components; it does not verify browser/UI/gameplay behavior.

Next: inspect feasible local wasm toolchain availability and make the same
replay portable if available, or continue original UI/game caller reconstruction.
Do not replace the full-decompilation objective with only this query pipeline.

## 08:25 UTC continuation

Rechecked time and installed tools. LLVM 18 has clang and wasm-ld; Node is
available. The default LLVM 22 installation lacks wasm-ld, so use the LLVM 18
path in build_wasm_query.sh. No tool installation was needed.

Separated pure dictionary table installation into dictionary_tables.c/.h;
native load still calls it. Added a freestanding wasm research bridge with
staged known data and normalized query fields, plus minimal memset/strlen.
Wasm built and ran in Node, matching all 149 ordered words from four natural
traces. Evidence: wasm-query-replay.json. This excludes filesystem loading,
error context, UI, and gameplay. Port notes explicitly supersede the old
statement that no wasm execution had been verified.

Native tests/replays are being rechecked after the source split. No VM was
started; no original media changes. Next: preserve this as a regression gate
and return to application decompilation rather than expand a substitute UI.

Validation completed: all 36 native tests, loaded-query replay, and dictionary
setup replay passed after the split; session 30159 exited 0. Inventory refreshed
and whitespace check passed. No owned processes remain.

## 08:35 UTC continuation

Rechecked time and CODE 47 [0x12c,0x1da). Reconstructed file_open.c/.h for
open/truncate and create/retry, used by CODE 22's game-writing routine.
Any initial error triggers Create; GetFInfo error is ignored; original scratch
creator bytes are explicit adapter input. Tests exercise error precedence,
truncate/no-truncate, retry, and failed metadata read. Documentation is
FILE-OPEN-CREATE.md, with corresponding modification notes in PORTING-NOTES.md.
No emulator was inherited or launched, and no file was written through the
new callbacks except temporary test binaries. Natural save verification pending.

All 37 tests passed; owned session 36523 exited 0. Inventory regenerated and
whitespace checks passed. Next: continue CODE 22 save serialization or capture
the actual save path using a uniquely named file in the disposable VM share.

## 08:45 UTC continuation

Rechecked time and disassembled CODE 22 save/read bodies. Reconstructed the
per-record write sequence as save_record.c: sign-extended tag, narrowed length,
signed payload count, ignored write errors, and tag-1 offset-4 clear/restore
with restore after unlock. Documented the surrounding six-byte handle-entry
loop and reader outline in SAVE-RECORDS.md. Payload field meaning remains
unknown. Tests cover exact bytes, ordering, negative narrowed length, and
error/count mutation without stopping later calls. No VM or save file created.

Next: capture a natural save to determine live record tags/sizes/content and
the actual meaning of tag 1. Prefer that evidence over inventing payload schemas.

All 38 tests passed; owned session 47621 exited 0. Inventory and whitespace
checks passed. No owned processes remain.

## 09:35 UTC continuation

Rechecked time and followed CODE31+0x184 with evaluation flag zero. Identified
the dual-orientation board transform, row-zero branch, paired letter/value
writes, and undo workspace outline. Reconstructed board_state.c covering
CODE31 [0x78,0x128): orientation mapping, occupied-byte count, thresholds,
and apparent end predicate. Full placement remains unfinished.

The count scans [17,272), including border slots. End conditions are empty
rack, counter==6, or counter==2 with count>79; no broad >=6 test. Row-zero
counter may include exchanges, so not named simply pass_count. Documented in
BOARD-APPLICATION.md and port notes. No emulator launched.

Build succeeded; 40 existing tests passed but the new test initially failed
compilation on a signed/unsigned assertion. Added the explicit int16_t cast;
the corrected new test passed separately. Session 52251 is terminal. Next:
capture restore of the saved game, recording board arrays and tag dispatch,
or continue the non-evaluation move application with explicit dependencies.

## 09:45 UTC continuation

Rechecked time and decoded rack count/materialization helpers. Added
rack_counts.c for CODE31 [0x992,0x9d2) and [0x71e,0x75c): alphabet-scoped
clearing, byte wrap, alphabet ordering, and signed-byte count emission.
Old RAM snapshot confirms alphabet ?abcdefghijklmnopqrstuvwxyz; provenance
is rack-alphabet-snapshot.json, explicitly not a new live call capture.

Parsed captured tag2 fields: aortae, row8/column7, selector0, racks oriaate/
aceekoq, score bits1400. Tests cover alphabet scope/order and count edges
0..256. No VM launched. Next: reconstruct placement on both orientations
using this exact recorded move, then compare original post-restore board/rack
state via a natural reopen trace.

All 42 tests passed; owned session 48357 exited 0. Inventory/whitespace checks
passed. No owned processes remain.

## 08:55 UTC continuation

No exact-name QEMU process existed. Launched owned VM session 31132 and
passed ROM handshake. Added capture_save_records.py with register-layout
check, full CODE 22 identity check, and write input/result breakpoints.
Initial capture 62224 timed out waiting for dialog input, cleaned up, and
exited 1; no VM restart. Retry 69231 used the same VM and exited 0 after
normal Save to unique filename maven-re-0855. Escape initially cancelled
the dialog; reopened it and entered the filename normally.

The initial empty position has zero save records: no FSWrite calls, close
success, return one. Host file is zero bytes with Finder metadata inspected
in save-empty-file.json. Evidence is save-empty-live.json. This is empty-save
verification only; payload writer still needs a nonempty history capture.
Owned VM was quit through QMP; session 31132 exited 0. No owned processes.

Next: start a game or create history through normal UI before recording
another Save, using a new unique filename. Do not inject record bytes or
invent tag meanings. The empty save is a useful baseline, not a completed
save-format reconstruction.

## 09:05 UTC continuation

Verified no emulator, launched owned session 91157, and passed ROM handshake.
Used current Finder screenshot (icon positions changed after previous save)
to launch Maven, then normal Command-N and Command-S. Captured save to unique
maven-re-0905 with session 3035 (exited 0). Full CODE 22 identity verified.

Three records: tag1/22 bytes, tag4/0, tag2/52. All nine writes and close returned
zero. The 86-byte saved file exactly matches concatenated captured writes.
Tag1 word+4 was 0001 before and after, 0000 on disk. C replay matches all writes
and restoration; evidence in save-new-game-live.json, save-new-game-file.json,
and save-record-replay.json. QEMU session 91157 quit via QMP and exited 0.
No owned processes remain. Updated inventory to natural evidence for this
success case; original error paths remain unverified.

Next: inspect history-record producers and reader to identify payload fields,
then capture a controlled subsequent move/save for differential evidence.

## 09:15 UTC continuation

Rechecked time and traced history consumers in CODE 7, rather than guessing
from payload bytes. Tag1 branch [0x70,0xca) clears board-related buffers,
copies racks at +6/+14, selects via word+2, and resets two running totals.
Reconstructed history_initial.c and host-tested the captured rack strings and
selector variants. Original restoration globals are not yet live-captured.
CODE 7+0x590 is the lock/dispatch/unlock history-entry wrapper.

Word+4 is read by a backwards history scan at [0x5ea,0x656), returning it for
tag1 or zero for tag0. Exact semantic name unresolved. Tag2 consumer reads
selector+0x22, adds long+0x10 to one total, and copies rack strings at +0x24/
+0x2c. Documented these offsets in SAVE-RECORDS.md. No VM launched.

All 39 tests passed; owned session 42641 exited 0. Inventory regenerated.
Next: follow tag2's remaining helper calls to reconstruct move application,
or capture reopening the saved game to verify history restoration naturally.

## 09:25 UTC continuation

Rechecked time and resolved tag2's helper slots: A5+0x96a → CODE31+0x992 rack
count; A5+0x942 → CODE31+0x184 move application; A5+0x582 → CODE22+0x48a rack
refresh wrapper. Reconstructed CODE7 [0x278,0x2e6) in history_move.c, retaining
previous-history recursion, subsequent payload reads, wrapped score/index
arithmetic, rack copies, and callback order. Full move application stays
external, not falsely counted as implemented. No VM started.

Port notes flag pointer-identity refresh behavior and ordering requirements.
Next: follow CODE31+0x184's non-evaluation path (the actual zero flag used by
history restore), then compare a reopened saved game's state in the debugger.

All 40 tests passed; owned session 71039 exited 0. Inventory and whitespace
checks passed. No owned processes remain.

## 09:55 UTC continuation

Rechecked time and board-application notes. Added place_letters.c for CODE31
[0x2f0,0x456), explicitly the inner placement loop, not complete application.
Captured aortae input host replay places six letters in both orientations and
leaves i; synthetic value/premium tables prevent claiming real score-table
verification. Tests include existing-tile reuse and blank consumption.
Surrounding scoring, cleanup, undo suffix and rack rebuild remain separate.
No VM started. Inventory and port notes updated. Next: capture natural reopen
state and integrate the remaining non-evaluation operations against it.

All 43 tests passed; owned session 6145 exited 0. No owned processes remain.

## 10:05 UTC continuation

Rechecked time and CODE31 undo instructions. Reconstructed undo_move.c for
[0x642,0x71e): paired cell/value clearing from positive column list, saved
rack restore, and row-zero counter/row clearing with returning diagnostics.
Count tables and totals are not part of this helper. Host tests cover exact
changed/preserved locations and counter wrap. No VM launched.
Next priority remains natural restore/undo capture, then integration of the
placement surrounding operations. No whole-game equivalence claim.

All 44 tests passed; session 55443 exited 0. No owned processes remain.

## 10:15–10:25 UTC continuation

Captured natural Open of `maven-re-0905` with full loaded CODE22/7/31 identity
checks and ROM/register handshake. Reader returned 1; saved evidence in
`game-restore-live.json`. Portable placement replay matches all 544 board
bytes, 544 value words and seven undo-prefix bytes using the actual live
letter-value table. Special score/premium behavior remains unvalidated.
Final racks reveal refill after placement: residual i becomes ilibdps;
reader-return counts belong to the other rack. Documented integration/port
implications without claiming full restore equivalence.

Owned capture session 83919 and QEMU session 63435 both exited 0. Next:
reconstruct CODE31 placement finalization and follow the restore reader's
refill/count-refresh calls, then validate a second natural move/undo case.

All 44 tests passed; check session 62641 exited 0. Inventory now links the
placement interval to this natural restore evidence. Whitespace check passed.
Seven-hour heartbeat remains active; deadline remains 13:55 UTC.

## 10:26 UTC continuation

Fresh time/repo/process check: no QEMU process running. Reconstructed CODE31
boundary cleanup and undo/rack finalization in move_finalize.c. Host sentinel
checks cover both orientations; placement replay now matches all 33 bytes
of the captured natural undo workspace. First check passed all45 tests.

Followed refill to CODE31+0x7e0 and reconstructed its remaining-bag builder
[0x8be,0x992) as remaining_tiles.c. Tests distinguish blank value-zero cells,
row-zero literal letters, scan edges and byte-count wrap. Documented apparent
uninitialized time local on the small-bag refill branch; requires natural
trace, not a guessed seed. No VM launched. Next: map refill time/random
helpers and capture entry/exit bag/rack state, including a small-bag case.

Final check: all46 tests passed, session48764 exited0; inventory and
whitespace checks passed. No owned process remains. Refill helper mappings
and exact CODE4 PRNG recurrence are recorded in BOARD-APPLICATION.md for the
next batch; no new runtime claims made for these static findings.

## 10:36–10:42 UTC continuation

Fresh time/repo/process checks: no QEMU before launch. Added rack_refill.c
for private generator and post-bag refill; explicit initial_stack_ticks models
the small-bag uninitialized local. All47 host tests passed, session65230 exit0.

Launched owned QEMU57300 and captured natural Open's first refill with
capture_rack_refill.py (recorder91278 exit0). Full loaded CODE31/4/9/1 match,
ROM/register handshake passed. C replay matches all86 bag bytes, all16 input
events, full bag workspace/board, rack idigngx, every private-random result
and final seed. Reopening same save previously produced ilibdps, so retained
clock/Toolbox inputs are essential. Pauses affect timing; small-bag branch
remains unverified. QMPquit terminated owned QEMU57300 cleanly exit0.

Updated port notes and inventory with this evidence. Next: integrate initial
history, placement/finalization/refill into a staged saved-move replay while
keeping scoring-prelude and boundary inputs explicit; capture normal undo or
another move to broaden runtime evidence. Full app remains incomplete.

## 10:46 UTC continuation

Fresh time/repo/process checks; no QEMU running or launched. Followed
A5+0x98a to CODE32+4. Added score_accumulate.c for first scoring phase
[0x32,0x352), with exact word-truncated products, main/cross scores, bingo,
and preliminary missing-letter bookkeeping. Later blank optimization and
final CODE32 return remain excluded. Host fixtures are synthetic, not a
natural score validation.

Corrected earlier boundary terminology: recorded coordinates are assigned
for existing zero-value tiles during scoring. Renamed clear helper to
maven_clear_recorded_move_values and recorded explicit superseding notes.
Next: decode CODE32 blank optimization after +0x352, then naturally capture
premiums and intermediate/final scores for a complete scoring replay.

All48 tests passed, session29763 exited0. Inventory and whitespace checks
passed. No owned processes remain. Tail CODE32[0x60e,0x648) emits remaining
positive signed-word rack counts in alphabet order and returns accumulated
score; row-zero early return bypasses that tail. This can support a no-new-
blank scoring path before the missing-blank optimization is completed.

## 10:56–11:03 UTC continuation

Fresh time/repo/process checks; no VM initially. Completed valid-input
CODE32 scoring via score_move.c: one/two blank cost minimization, strict tie
ordering, score deductions and remaining-rack output. Extended accumulator
with retained counts/multiplier. All49 tests passed, session61020 exit0.

Owned VM8707 started; first attach preceded socket creation and failed, then
retry passed ROM handshake. capture_move_score.py observed normal Open's
scoring call, full loaded CODE32 identity checked. Complete C scorer replay
matches natural score1400, new_tiles6, remaining rack i and all recorded
coordinate words. Blank/cross/bingo branches remain host-only. Capture65676
and VM8707 exited0. No owned process remains. Inventory/notes updated.
Next: integrate non-evaluation placement around this scorer and the existing
finalizer, then validate combined move state; seek natural blank/undo cases.

## 11:06 UTC continuation

Fresh time/repo/process check; no VM running or launched. Added apply_move.c
for evaluation-flag-zero orchestration. Connected score, private scored-copy
callback, normal placement, recorded-value clearing and undo/rack finalizer;
row-zero branch preserves scorer globals and wraps its counter. Host test
covers blank cells, callback copy isolation and row-zero behavior.

Integrated replay using natural score inputs and separate natural restored
state matches all544 board bytes, all544 value words, all33 undo bytes,
residual i, six new tiles and zero counter. Evidence explicitly identifies
split capture boundaries; excludes refill, history, totals and evaluation.
Next: natural blank scoring/placement or undo trace, then integrate history
and refill; AI evaluation branch remains a major gap.

All50 tests passed; session2482 exited0. Inventory and whitespace checks
passed. No owned processes remain.

## 11:16–11:21 UTC continuation

Fresh time/repo/process check; no VM initially. Added two CODE31 board
helpers (new-tile count and preceding word-start scan) with host tests.
All51 tests passed; check36859 exited0.

Owned VM56444 booted after ROM handshake. capture_move_undo.py observed a
natural CODE31+0x642 invocation during New Game/search; full loaded CODE31
identity verified. Undo row8/cols3..8 restores nitedaa. C replay matches full
board/value/rack/workspace/counter and confirms original counts unchanged.
This is engine undo, not UI Undo/history validation. Recorder54512 exited0;
QMPquit ended owned VM56444 exit0. Inventory and port notes updated.
Next: natural blank scoring capture, evaluation-path reconstruction, and
history/refill integration remain useful; no full-app completion claim.

## 11:26 UTC continuation

Fresh time/repo/process check; no VM running or launched. Reconstructed
CODE31 evaluation feature preparation/completion in evaluation_features.c,
preserving the22-long layout, before/after inputs, thresholds and signed
arithmetic. CODE35 record-flag predicate also reconstructed. Collector
CODE35+0x36c and final weighted evaluation remain external/unresolved.
Snapshot at A5-0xbca establishes aeiou membership for classification; not a
fresh runtime call. Host tests cover stages, repetitions, count signs and
record flags. Documented row-zero evaluator's uninitialized remainder-buffer
dependency rather than silently defaulting it.
Next: capture natural evaluated move entry/exit and feature vector, then
replay with actual record IDs/weights/predicate flags; investigate collector.

All52 tests passed; session61574 exited0. Inventory and whitespace checks
passed. No owned processes remain.

## 11:36 UTC continuation (in progress)

Fresh time/repo/process check; no VM initially. Evaluation capture reached
its target in owned VM25578 but rejected full CODE35/32 identity: live Mac OS
rewrote floating-point trap call sites outside the collector/scorer ranges.
Exact differences retained in floating-trap-rewrites-live.json. Relevant
CODE35 collector[0x36c,end), predicate[0x34,0x64), and CODE32 scorer[4,0x650)
match; recorder now verifies these exact ranges and records whole-resource
mismatch rather than waiving it. CODE31/23 remain full-resource checks.

Later capture attempts45913(assertion),58398,5816,75149,1854,94374(timeouts)
all exited1 and cleaned breakpoints; none produced accepted feature evidence.
Timeouts included new-game dialogs, a human-first game, and later candidate
paths. VM25578 exited0 via QMPquit. Clean owned VM24533 is now booted for a
fresh first-game retry; no other VM remains. Added unseen-tile count helper
CODE31[0x75c,0x7e0), host-tested. Check15041 passed all52 tests and exited0.

## 11:55 UTC completion of evaluation batch

Clean first-game recorder81707 succeeded after43 flag-zero applications and
one flag-one candidate. Exact relevant ranges plus full CODE31/23 verified;
C replay matches all22 feature longs using seven original collected records.
Vector includes early score2400, one pair and matched-weight sum -185.
Capture and VM24533 exited0; no owned processes remain. Latest check15041
passed all52 tests. Inventory and whitespace checks passed.

Next: reconstruct collector CODE35+0x36c or its subhelpers, and locate the
feature-vector weighting consumer. Natural blank scoring remains valuable.
No full-app or all-feature equivalence claim; larger goal remains active.

## 11:57 UTC continuation

Fresh time/repo/process check; no VM running or launched. Traced vector
consumer CODE11→CODE16: per-player statistics accumulation, not demonstrated
weighted move ranking. Explicitly corrected earlier evaluation/ranking
interpretation in board and port notes; natural feature equivalence remains
valid. Added move_statistics.c for22-long addition and selective signed
normalization. Added CODE35 flag-set predicate with its distinct ID0 rule.
Host tests cover rounding, preserved fields, wrap, aliasing and predicate
asymmetry. Next useful step: expose verified scorer/application in wasm and
continue collector/ranking reconstruction with corrected semantic labels.

All53 tests passed; session43716 exited0. Inventory and whitespace checks
passed. No owned processes remain.

## 12:07 UTC continuation

Fresh time/repo/process check; no VM running or launched. Added freestanding
wasm_board.c bridge, build_wasm_board.sh and replay_wasm_board.mjs, linking
the same scorer/application/undo C. Initial build rejected an empty-loop
warning; corrected it and rebuilt successfully. Import-free wasm matches
natural score outputs, combined full board/value/undo and separate natural
undo state. Explicit BE-capture→LE-wasm word conversion; buffer contracts and
scope documented in WASM-BOARD.md. No browser/full-game claim.

Rebuilt query wasm after shared string-header declarations changed; all149
ordered query results still match. Whitespace check passed. No owned process
remains. Native53-test suite unchanged in this batch. Next: continue CODE35
collector/rating decomposition and pursue natural blank scoring as time allows.

## 12:17 UTC continuation

Fresh time/repo/process check; no VM running or launched. Followed collector
rack-composition call to CODE32+0xcc4. Reconstructed [0xc00,0xdb0) in
rack_balance.c: clamped draw count,8x8 baseline-difference cache, zero sentinel,
key omission of draws, one-blank average and two-blank signed max. Underlying
CODE32+0xdb0 remains external. Host tests cover cache and policy distinctions;
no new natural runtime claim. RACK-BALANCE.md and port notes added.
Next: decode the underlying composition calculation or naturally capture
these inputs/outputs; continue toward collector/ranking understanding.

All54 tests passed; check56265 exited0. Inventory and whitespace checks
passed. No owned processes remain. Exact next helper disassembly retained
in rack-composition-disassembly.txt, CODE32[0xdb0,0xefa).

## 12:27 UTC continuation (in progress)

Fresh time/repo/process check; no VM initially. Added rack_composition.c for
CODE32[0xdb0,0xefa), integer recurrence and explicit terminal table input.
All55 tests passed in check45721; an additional cache-integration case passed
its focused test afterward. Saved snapshot terminal tables with provenance.
Owned VM24595 launched, ROM handshake passed. Capture46539 reached wrapper
but timed out waiting for underlying calculation; exited1 with cleanup.
Retry44684 is armed directly on the loaded calculation during normal Kibitz.
No accepted natural composition result yet; do not infer it from host tests.

## 12:39 UTC completion of composition batch

Retry44684 also timed out and cleaned up; no direct invocation accepted.
Read-only live cache snapshot has19 nonzero entries and pool key(36,52).
All19 match total7 reconstructed recurrence minus baseline using the actual
live terminal table. This is explicitly indirect consistency evidence, not
19 call traces, since draws/total were not observed. Evidence and limitations
saved. VM24595 exited0 via QMPquit; no owned processes remain.

Recorder updated to resolve CODE32 from the earlier scorer slot for future
fresh-session capture before the cache warms. Last full55 tests passed; cache
integration focused test also passed. Inventory and whitespace checks passed.
Next: direct early composition capture, or continue collector decomposition.

## 12:39–12:48 UTC continuation

Fresh time/repo/process check; no VM initially. Added pattern_lookup.c
(CODE32[0x1872,0x18e4)) and mask_supersets.c([0x18e4,0x1944)), preserving
accumulator-pointer semantics and generation-stamped recursive mask updates.
All57 tests passed; check50692 exited0.

Owned VM85124 booted after ROM handshake. Broadened early capture to first
CODE32 jump-table entry so composition misses are caught before warm cache.
Capture29304 returns -713 for(5,2,39,54,7); direct next call75688 returns -49
for(0,0,39,54,7). Both match C with original terminal tables; the second
exercises all7 recurrence levels. Exact executed range verified. Captures
and VM85124 exited0. No owned processes remain. Inventory/notes updated.
Next: natural blank scorer via normal rack editing/Kibitz, cache construction,
or further collector decomposition; full app and ranking remain incomplete.

## 12:55–13:10 UTC continuation

Constructed three documented save fixtures from original86-byte game;
original source unchanged. Added XGMEMAVN idump metadata for ordinary Open.
OwnedVM42298, capture11753(oneblank),42109(two same),65317(two different)
all exited0; direct scorer/application capture and C/wasm replays match.
Scores1200/1000/1000; all board, values, undo, counts match. See
BLANK-SCORING.md for scope/provenance. VM42298 quit0.

Added pattern_cache.c construction and host tests; all58 tests passed,
check15864 exit0. Initial cache recorder rejected an unloaded slot and then
rejected a previously built cache (71919exit1); neither is accepted evidence.
Fresh ownedVM79327 now booting for first-use capture; ROM handshake passed.

## 13:10–13:37 UTC continuation

FreshVM79327 produced pattern-cache capture10923:2263 source records,
125 cache entries; all native fields match. Capture85401:64 original
lookups,28hits/36misses, scores and accumulator identities match C.
Pattern matcher capture53243 gives -861 and unchanged128counts; traced
repeat captures record64 contributing -861. Other accepted captures include
multiple rack records in subsequent played positions, all replayed in C.
Bounded sampler14543 observed9 additional rack-only calls then timed out
waiting for another call; recorder cleaned up, controller exited1. No board
match is claimed. Last accepted temporary capture preserved and replayed.

Premium exposure C and tests added. Recorder41939 timed out across a UI
segment unload; updated recorder resolves the next actual CODE35 jump-table
entry. Capture90866 succeeds with IOTA penalties0 and-20, both match C.
The selected legal Kibitz move was played normally; Maven replied QUAG.

SANE letter expectation recovered as a binomial weighted average with final
FTINTX truncation. Exact bounded64-bit integer replacement matches24 natural
calls (capture22746) and300 randomized independent-combinatorics host cases
with UBSan. New freestanding rack-math wasm matches those24 plus2 earlier
composition calls, no imports. Executed range matched the exact recorded FP
rewrite fingerprint; limitation documented. Check89402:61 tests passed.

Cross-word availability and descending rack-mask helpers added with host
tests. Cross-word recorder82084 is waiting for an original call; do not treat
it as runtime-verified without a completed capture. VM79327 remains owned.

## 13:37–13:50 UTC final verification and handoff preparation

Cross-word recorder82084 timed out and cleaned up; no accepted natural
cross-word call. VM79327 quit0. Exact process sweep found no QEMU instance.
Host checks71600 passed63 tests. Added adjusted_pattern_lookup.c with
composite host tests (underlying lookup/expectation have separate traces).
Formatted107 then2 new source/header files for readability; historical
compiler probe intentionally preserved. Final native suite passes64 tests.

`verify_portable_replays.py` completed31 build/test/replay commands, preserving
scope in portable-verification.json (completed13:46:33UTC). Sessions46313 and
18795 exited0. Three wasm modules have passing original-capture replays.
CODE34 was reconstructed again from library symbol metadata and compared
byte-for-byte:1392 bytes/31 entries match. Preserved THINK5/6 probe artifacts
reverified. Guest source usesCR, canonical host source usesLF; exact content
matches after that documented line-ending conversion. No fresh compiler run
is claimed for this final artifact audit.

Fresh goal-tool read reports app-controlled status `usageLimited`, not active;
no attempt was made to change that status or redeem a credit. The larger
objective remains incomplete. Timed automation is still active until the
13:55:02UTC deadline, when it must be paused. All owned processes are closed.
Source and notes remain uncommitted in the nested repository. No full app
rebuild or complete AI decompilation is claimed.

## 13:55 UTC — timed window complete

The requested06:55:02–13:55:02UTC seven-hour window has ended. Automation
`mac-maven-seven-hour-decompilation` was updated toPAUSED, confirmed by the
app. All owned sessions were accounted for and closed; the final process
sweep found no QEMU, and both debugger sockets were absent. No further timed
decompilation work is scheduled by this automation.

Handoff: DECOMPILATION-STATUS.md, NEXT-DECOMPILATION-STEPS.md, PORTING-NOTES.md.
Final evidence:64 native tests;31 portable build/test/replay commands;3 wasm
modules; exact1392-byte/31-entry CODE34 reconstruction; preserved THINK5/6
comparison artifacts reverified. Source/notes remain uncommitted. Full app,
complete collector/search/ranking, and broad error/runtime validation remain
unfinished; the larger app-controlled goal status was not changed.
