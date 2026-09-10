# Five behavioral steps — accepted

User authorization: complete all five steps discussed after the iteration403
fix. No new seven-hour limit or recurring automation was requested. The prior
app goal remains unfinished and usage-limited; its objective cannot be
replaced through the goal tool. This document tracks the expanded scope.

## Acceptance checklist

1. Simulation lifecycle: integrate random/exhaustive batches, ranking
   publication, limits, cancellation, position restoration and leave rebuilding.
   Validate complete sessions against original captures, not only components.
2. CPU fallback: capture original force0 calibration/table/decision; integrate
   the decision with heuristic/late selection, including explicit bypass and
   defined calibration inputs for modern runtimes.
3. Coverage: add original differential cases for blanks/crossings, ties,
   interruption and reused state; preserve all existing166 regression commands.
   State actual covered cases rather than claiming universal equivalence.
4. Game lifecycle: load/play/score/history/refill/undo/continue with original
   state comparisons across multiple turns and save/reload boundaries.
5. Standalone interface: own/init tables and workspaces; validate positions;
   expose clock/RNG/cancel/allocation outcomes; run native and wasm comparisons
   from independent input initialization, without replay-only hidden setup.

Starting baseline: eighteen endgame and eight late-search fixtures, connected
simulation batches; no known gcmulti mismatch after CODE39 depth-zero fix.
All five scoped steps are now implemented and accepted on the documented
original and portable cases. The final report passed221 commands, including79
host tests, with source fingerprints verified unchanged. See the final
acceptance below; full-application and all-position equivalence are not claimed.

## Work order

Validate the CPU gate first while examining simulation cancellation boundaries.
Then integrate the session controller; use it for broader repeated-session
coverage. Build game/session APIs around recovered initialization and state
ownership, and exercise full turn histories and wasm integration.

## Process contract

Only owned disposable snapshot VMs; at most one emulator/recorder per socket.
Each VM session has a45-minute maximum lifetime, with task/ownership checks
between captures and progress review at least every minute. Terminate owned
processes before ending work; do not touch user-visible or unrelated VMs.
The prior timed automation stays paused.

## First checkpoint: CPU gate

Natural capture late-budget-live.json admits late search with estimate0.
Controlled input capture late-budget-controlled-live.json overrides D4 after
measuring calibration and takes the heuristic branch with estimate1488544.
No instruction bytes were modified. It exposed the wrong8232 multiplier;
CODE36+1874 is MULS #0x2020 =8224. Both replay in C and freestanding wasm.
search_dispatch accepts an explicit table and per-call calibration callback;
missing/zero calibration fails instead of dividing by zero. NULL table is
the documented prequalified computational replay path, not standalone setup.
Focused selector-routing tests and existing complete late rollout replay pass.
Session integration and broader calibration domains remain acceptance work.

Owned VM PID77294 / exec74185; original gate recorders77617/12698 and ordinary
Escape recorders75933/9721 completed and cleared breakpoints. ROM verified
at start. The VM remains owned for the next finite-session capture.

## Second checkpoint: finite session lifecycle

New session-exhaustive-live-01..05.json preserve five consecutive original
batches and natural session cleanup. Native and wasm match450 event records,
150 computed refills, and three cleanup boundaries including all leave words,
tile points, canonical/occurrence masks, generation stamps, board/value/racks,
counts and undo. simulation_session.[ch] owns snapshot/restore and final leave
rebuild; random-step plumbing exists but awaits full-session acceptance.
Cancellation remains between batches only; mid-search unwinding is still open.
This new run did not capture the final published ranking buffer; its final
accumulators match, and ranking is separately verified in older traces. Do
not describe this as a new direct final-publication comparison.

VM77294/session74185 and exhaustive recorder4002 exited successfully. No VM
remains. Regression now includes the finite session plus both gate captures.

## Regression checkpoint

portable-verification-session-gate.json: all171 commands pass, including78
host tests, seven wasm builds, the original166 cases, two native gate cases,
one wasm gate replay, and native/wasm complete finite-session cleanup.
No five-step completion claim: the controller still lacks mid-search cancel,
full game histories and standalone engine initialization/API validation.

Next owned VM: PID82631/session78298, fresh ROM signature verified. Random
opponent recorder75867 completed to CODE38+3c; output session-random-draw-live.json
contains14 external RNG/tick events and sample eqekeoe. Recorder79227 is now
following the first batch with --controlled-session-limit, writing
session-random-limit-live.json and its cleanup tail. Account for this recorder
before touching the VM. Session TTL45 minutes from launch, then stop/reassess.

## Third checkpoint: random session limit

Original first opponent draw + first batch + controlled limit exit now match
native/wasm through the session controller, including the three final cleanup
boundaries. session-random-draw-live.json and session-random-limit-live.json
preserve34 external RNG/tick events,31 draws/refills including the opponent
sample, and90 move-state records. Only the configured sample limit changed
after batch completion; no board/counter/result/code mutation. Private RNG
state is continuous. This accepts one complete limited random session, not
natural exhaustion of200 million samples or arbitrary mid-search cancellation.
Recorder79227 completed. VM82631/session78298 remains owned and paused at the
session return. No recorder is active. Recheck ownership before resuming.

Next cancellation investigation: CODE30+058e handles cancel separately. It
calls unscale(+06d0), then copies the saved (already point-scaled) board/value
buffers and normalized racks, and rethrows to CODE3. CODE3 subsequently
restores its own point*100 snapshot and rebuilds leaves. Do not assume an
endgame-local cancellation returns through the normal result/row-zero cleanup.
Capture at CODE30+0848 (poll before hash reuse) with End Analyzer enabled,
then observe +058e/+05a4 and CODE3+d86/dd6/de2/return before implementing.
The C engines currently have no structured mid-search cancellation path.

## Fourth checkpoint: reply-boundary cancellation

Original session-reply-cancel-live.json plus session-cancel-draw-live-02.json
now match native and wasm through the checked rollout/session controller.
Eight move-state events, three actual rollout refills plus opponent draw,
16 external inputs, partial candidate counters and all three cleanup boundaries
match. Escape was accepted after reply two, before candidate spread/win commit.
The sample count remains advanced, while the interrupted batch is not counted
as complete. maven_run_rollout_batch_checked returns interruption explicitly;
random and exhaustive controllers restore/rebuild and stop enumeration.

CORRECTION to the prior timing explanation: in this simulation, the inner
CODE37 poll callback A5-5c76 is NULL. CODE3+0500 explicitly calls CODE9+0376
(GetOSEvent / Escape check) after each reply. The controlled-deadline experiment
session-endgame-cancel-controlled-poll.json changed only the deadline but had
callback0, so it cannot accept inner endgame cancellation. Two ordinary traces
session-after-endgame-cancel-live*.json also reached only the outer handler.
Inner cancellation remains a separate standalone-search investigation.

Recorder51942 failed after Escape sent while paused was not accepted; no
successful interrupted-batch output was retained from that attempt. Recorder
98502 sends input after resume and completed all eight events and cleanup.
VM82631/session78298 exited successfully after13m31s. All recorders completed;
no VM remains. Full175-command regression is running in exec98056; focused
native and wasm cancellation replays pass. Do not claim overall five-step
completion: broader cancellation/error cases, full histories and independent
standalone engine initialization remain.

Full regression portable-verification-session-cancel.json passed175 commands.
This ran before adding the new, still-investigative history_snapshot component.
Next VM PID88590/session65825: fresh ROM verified,45-minute TTL. Opened enum8
normally, now preparing capture_history_snapshot.py. No recorder currently
active. Snapshot replay against later simulation entry fails four mirrored
value words; board and rack data match. Do not change+16 to+15 without the
new immediate-return capture. The difference may be repaired after loading.

## Fifth checkpoint: saved snapshot and display rebuild

history-snapshot-live.json and history-snapshot-rebuild-live.json confirm
CODE7 tag0's column+16 blank-value clearing survives through normal Open.
CODE20+004e rebuilds from display cells before search and uses column+15,
explaining the later corrected values. Both transitions now match native and
freestanding wasm; four new portable components/bridges provide bounded record
framing, tag0 restore and display rebuild. Malformed-file/capacity/snapshot
bounds have sanitizer tests. This is NOT full history replay or game lifecycle.

VM88590/session65825 exited successfully after6m43s. Recorders55746 and98311
completed. Recorder1778 (PID90065) waited for CODE28 heuristic dispatch, while
Kibitz selected CODE36 via CODE44 for this eight-unseen position; interrupted
it deliberately, and its finally handler cleared breakpoints. No accepted
heuristic-after-snapshot capture exists. All owned VMs are closed.

make check is running in exec44669 after the new history modules. Focused
native/wasm history replays pass; latest full regression remains175 commands
before history additions. verify_portable_replays now has178 commands; run
when further integration merits the next complete checkpoint.

## Next integration: recursive history playback

make check after snapshot/display/parser additions passed79 tests. New
history_playback.[ch] now connects supported tags0..4, actual apply/scoring,
totals and refill callback, iterating from the closest snapshot/initial record
instead of recursive stack frames. This new orchestration is compile-checked
only so far. capture_history_playback.py and replay_history_playback.py are
prepared for original multi-record/multi-refill acceptance; do not claim it
verified yet. They require a real tag2-containing history, e.g. end6/late13.

New owned VM PID90995/session6226: fresh ROM signature verified,45-minute TTL.
Dismissed dirty-shutdown notice, waiting for Finder; no recorder active.
Open enum8 normally first to load CODE22/7/31, then arm history recorder before
normal Open of end6. Recorders compare wire payloads with original loaded
handles before accepting any history states. Full178-command regression has
not been rerun; latest175 pass plus focused history native/wasm and79 tests.

## Sixth checkpoint: complete saved-history restore

history-playback-end6-live.json matches native and wasm:18 record returns
from the latest snapshot through16 subsequent played turns,16 computed
refills and196 random/tick events. Board, values, racks, player totals,
counts, undo, selector and scorer fields match at every record return.
The file framing and every loaded original payload are verified against the
saved file. This accepts a complete existing history restoration, not new
turn commit/save/undo branching yet. Research bridge now supports history
playback; the previous snapshot/rebuild wasm replay still passes.

VM90995/session6226 remains owned. Capture87538 completed. New navigation
capture34326 is active after double-clicking the visible rubric history row;
mac_ui's final mouse release hit a paused breakpoint and reported VM not
running. Account for the active recorder and release the mouse after its
completion before further UI input. This is a known input timing issue, not
an engine failure. Goal still requires full game lifecycle and standalone init.

## Seventh checkpoint: consecutive restore and regression

CORRECTION/supersedes prior active-process note: navigation capture34326
completed and the mouse was released. Original Open followed by navigation
(index21) now matches C and wasm continuously:34 record checkpoints,
30 actual refills,380 external events, continuous private RNG/state. This
caught and fixed missing final rack recount/sort in playback. Display order
comes from prfs+0x312 (`abcdefghijklmnopqrstuvwxyz?`, blank LAST), separately
verified in history-display-order-live.json. Final state/counts are checked.

Full180-command regression PASSED in portable-verification-history.json.
The first attempt stopped because build_wasm_history output was parsed as
JSON; runner now marks it a plain-text build, and the entire rerun passed.
No engine disagreement caused that runner error.

Next integration adds evaluated_application.[ch] and exposes the scorer's
remaining rack/special score through MavenAppliedMove. New code compiles,
but it is NOT accepted as runtime-matching yet. Existing flag-zero API is
preserved. Row-zero original uninitialized remaining scratch is an explicit
caller workspace, not silently treated as a recovered deterministic value.

Process ledger: VM90995/session6226 remains owned,45-minute TTL. Full
regression39474 complete. Failed turn recorders38231/37308 have completed;
no accepted BURIN turn capture was produced. The first recorder hit an
unexpected preliminary flag-zero apply; resumed recorder then waited for
human stats after the game had advanced to opponent play. New recorder
checks caller identity and persists partial capture checkpoints. Goal still
requires new turn/save/branch lifecycle and standalone initialization.

## Eighth checkpoint: evaluated turns and saved continuation

VM90995/session6226 terminated successfully at35m56s, within45-minute TTL.
No VM/recorder remains. Save30518, reload58299, final-score capture completed;
failed intermediate recorders are also terminated. Owned file
media/maven/session/share/maven-port-turns-0909 was created via normal Save As.
It does not overwrite the source end6 fixture.

New accepted results:
- turn-commit-tiores-live.json is actually TIROS (name was a visual misread).
  Native replay_turn_commit and wasm replay_wasm_turn match complete evaluated
  application, computed collector, CODE8 display scorer callback,22 features,
  and22 accumulated statistic fields. Display input for this first trace was
  read immediately after the turn, before any opponent continuation; this
  limitation is explicit. New entry-time capture mode has been added.
- game_turn.[ch] integrates history payload semantic fields, totals, canonical
  rack preparation, evaluated application, statistics, actual refill and next
  side/end decision. replay_game_turn passes the TIROS capture. Its bag is
  empty, so nonempty new-turn refill acceptance remains to add (history and
  simulations separately exercise many nonempty refills).
- game-finish-tiros-live.json + replay_game_finish prove doubled leftover
  rack credit,44 accumulated statistics, two final-record semantic fields,
  rack/count/selector/phase cleanup. Totals42800/31400. Output padding is
  deliberately zeroed; original stack garbage after NUL is not reproduced.
- save-continued-end6-live.json records33 save records /2038 bytes; all writes
  succeeded. Disk file equals captured bytes, SHA256
  4cd19e359fd8b943479ba46a1edd555f0d86ed6b3179b67202d265705f164d13.
  Original record writer and new bounded whole-file serializer both match.
- history-continued-end6-live.json reloads9 records after the last snapshot,
 5 actual refills,16 external events; native/wasm pass, including final totals.
- history_store computes a new snapshot+tag4 while retaining all24 original
  records, then copies the observed continued moves/final records. Its output
  equals the entire original2038-byte save. Capacity failure is atomic.

CORRECTION to any assumption that editing history truncates future turns:
Maven retained the original24 records, appended snapshot24 +marker25, then
BURIN/EANED/YACK/JEE/TIROS and two final score records. Also CODE7+492 resets
racks from the selected record after recursive playback; random-refill racks
are only intermediate. maven_prepare_history_selection now models this step.
Its original record22 opponent rack differs from the post-recursion refill,
which exposed the missing distinction during computed-snapshot comparison.

CORRECTION to earlier turn trace diagnosis: CODE31 can relocate during
preparation. Resolve its A5 stub at CODE11+fa0, not before preparation.
CODE8 and CODE7 can also be lazily unloaded; verify CODE8 after its callback,
and resolve CODE7 through its loader stub before tracing the final adjustment.
These were recorder boundaries, not engine disagreements. Capture scripts
save partial checkpoints and label incomplete traces. turn-finish-tiros-live
is partial (complete:false) after lazy CODE7 load; its following dispatch is
captured completely in game-finish-tiros-live. Do not call the partial trace a
standalone completed turn capture.

## Resource initialization work in progress

Engine fixed arrays from DATA/ZERO/DREL match live tables directly. PATB and
ESTR are also resources, but old ESTR captures include56 bytes beyond their
allocation and FRST captures include8 out-of-allocation longs. Only the actual
resources are used for new initialization; valid opening moves use slots0..7.

CODE15+aa8 loops CODE35+16c across score records. Recovered formula uses the
sample count, first/second accumulated moments, five Newton iterations for
standard error,80-point threshold and truncation to integer. Python probe
matches every EXPR/MUL/VCB observed live score, including four EXPR cached
on-disk values changed by startup. New score_statistics.[ch] uses IEEE double
intermediates; its claim is fixed-resource output equivalence, not arbitrary
SANE80-bit equivalence. engine_tables.[ch] loads and validates owned arrays
from resource blobs, with no captured memory input. Native verification passed
(2263 pattern records,320 score records and all fixed arrays). Complete public engine ownership/position validation,
wasm resource initialization, clock/RNG/cancel/allocation API and integrated
whole-engine search remain required. Latest full regression is180; new
focused tests pass but must be added to the next full checkpoint.

## Ninth checkpoint: owned resource-initialized engine

197 commands passed in portable-verification-owned-engine.json (includes the
previous180 plus new resource/turn/save/history/owned-engine cases). The run
built portable_engine before the experimental late API and latest row-flag
connection; those later edits need a fresh focused/full checkpoint.

portable_engine.[ch] owns copied resources/dictionary, decoded tables, caches,
board/racks and search workspaces. dictionary_validate.[ch] checks both DAG
sections, size/root bounds, ordering and backward links. Child links can point
to a suffix of an earlier sibling group. The shipped dictionary has three
space-suffixed entries: antichoicers, antipruritics, nonintoxicants. Board
letter-bit construction now handles nonletters without an undefined shift.
The public position uses225 letters+225 blank flags, two racks, side/scores.
It validates structure/inventory; it does not validate Scrabble word legality.
Both allocation failure points release owned storage; failed position updates
preserve the previous position. Finished/empty-rack positions currently reject.

Native replay_portable_engine and wasm replay_wasm_portable match all328,
613 and588 original heuristic candidate events and complete final ranking,
three repeats per fixture. Inputs are resources, dictionary and public position,
not captured tables, roots, caches, mirrored board or counts. Input resource
buffers are freed/overwritten before search. Wasm package has43 bounded resource
blob descriptors, a477-byte serialized position and explicit result statuses.
Wasm hash after experimental late addition and row controls:
b0654640f362f9fb3caf4579ec255921790febc611af9e4f10a53bb155b0185b.

EXPERIMENTAL late API is connected but does NOT yet pass independent original
ranking. maven_portable_late and wasm maven_port_late must not be called verified.
All actual scoring/choose/bitmask resource tables match original; differing
bytes in captured table block are relocated pointers and unrelated scratch.
Fresh-cache leave scores/tile points match; pool preparation semantic fields
and initial own ranking match. First local refinement differs.

Important discovered hidden state: A5-6d2 row-scoring flags overlap the upper
half of CODE37+3ce's crossing-query output at A5-6f2. The original helper
concatenates results from both dictionary sections, so >31 output bytes spill
into flags. DATA starts flags with00000000..., while late-search-live starts
74767700... ("tvw"). A controlled local probe copying JUST these original
three bytes makes all first9 local refinements/rankings match. Last BURR
adjustment remains74 lower (one output byte); cause still open, possibly other
retained workspace state. This is controlled diagnosis, NOT independent input
initialization. Do not insert those bytes as hardcoded engine initialization.
Temporary probes .build/debug_owned_late.py and .build/debug-owned-late.jsonl;
the script currently injects the3 bytes only in its temporary C copy.
The reconstructed generator currently computes per-section cross masks without
modeling the overlapping shared scratch output. Need either recover the full
stateful sequence or establish fresh original runtime boundary validation;
old captured hidden state cannot be assumed derivable from a board alone.

Owned fresh VM PID8963 / exec8448, launched after orphan sweep;45-minute TTL.
ROM and GDB XML handshake passed. Boot warning dismissed by normal click.
No recorder yet. Current purpose: capture original fresh startup/late path and
query-overlap effects. Must terminate this VM before TTL and before stopping.

## Tenth checkpoint: fresh owned late/endgame and natural shared-buffer proof

Supersedes the ninth checkpoint's experimental-late status: the owned native
and wasm late API now matches all10 original rankings from
late-search-fresh-start-live.json.gz, three repeated calls. Resource tables,
dictionary and public position initialize it; no captured scratch is injected.
Calibration0 rejects atomically,1 falls back to computed heuristic,4923651
admits late. The hidden opponent placeholder is one feasible tile because late
search uses unseen inventory rather than the actual hidden rack.

The owned endgame API matches all10 rankings and12 iterations from
endgame-search-owned-fresh-live.json.gz, native/wasm, three repeats. This capture
is the continuation after BURIN/EANED, NOT the original end6 board. Inputs
include the observed CODE4 private RNG seed515346463 and12 clock events.
CODE53 hash initialization uses that private RNG, not Toolbox Random; this
supersedes older speculative CODE53 notes. Cooperative cancellation before
search and after a restored iteration leaves caller output/position unchanged.
Wasm clock exhaustion also fails without publication. This does not establish
original nonlocal UI interruption inside a selector, nor persistent game RNG.

turn-commit-burin-fresh-live.json is a complete newly played turn with a real
six-tile bag,12 refill events,12 collector contributions and result693. Native
whole-commit replay passes; native/wasm evaluated application and statistics
pass. Wasm whole-turn refill and the owned game/history API remain separate work.

cross-query-at-overlap-live.json now PROVES natural shared-buffer overlap.
A controlled legal AT board with rack ?abcdef was loaded via Open, then Kibitz.
CODE37+3ce returned35 letters for ?AT across both dictionary sections. Bytes32..35
became74767700 (tvw\0), precisely the older late trace's initial row flags.
Three subsequent shorter queries retained those bytes. The native crossing
helper, using one retained64-byte output buffer, matches all64 bytes before/
after each of13 queries. The first overlap is query9. This establishes the
mechanism, not yet full repeated-search integration: board enumeration still
uses separate per-section local buffers and must be connected to owned shared
scratch with original row-preparation timing. The residual old BURR discrepancy
also remains to be rechecked after that integration.

Recorder correction: waiting for CODE37+4 before arming3ce misses early row
preparation. When CODE37 is already loaded, resolve its verified stub while
idle and arm3ce directly. The earlier HE/blank-board captures remain explicitly
incomplete; the AT capture is complete. No guest memory mutation was used.

The expanded regression run exposed replay_history_store reading a mutable
shared game file. Normal later play changed its record count. The test now
uses the first24 preserved records in the original Save trace; computed
snapshot+continuation again matches all2038 bytes. A fresh full regression is
running; do not treat the prior197 report as covering these latest changes.

## Eleventh checkpoint: simulation publication and shared workspace integration

205 commands passed in portable-verification-owned-search.json before the
shared-workspace/publication observer changes below. This supersedes197 as the
latest completed broad run, but a new broad run is needed for these edits.

Original session-publication-full-limit-live plus its separate captured draw
now replay in native and wasm:90 events,30 turn refills plus the opponent draw,
one publication before the batch, and all three restoration phases. The
controlled sample-limit exit does NOT republish the accumulated result.
The five session-publication-exhaustive-live captures also pass native/wasm:
450 events,150 refills,six publications (one before each batch,one after all),
then restoration. Original timing/Toolbox inputs stay explicit. A new ordinary
Escape publication trace is in progress.

New shared-workspace entry points preserve the old C struct ABIs. Crossing
queries concatenate both lexicon sections into64 retained bytes; bytes32..63
alias row flags. Board scoring freezes its main control after the row's cross
checks, before candidate callbacks. Owned heuristic/late/endgame paths and
their local continuations now use the same retained workspace. Existing APIs
without the explicit workspace retain isolated captured-control behavior.
The controlled AT board produces original final32 flag bytes on two native
enumerations. The three owned heuristic traces pass separately; fresh late
and endgame also pass with the workspace connected. Native/wasm late/endgame
rankings pass; current portable wasm SHA
ae63c9608f6d50f078572897be923fa85b2fb09e460f6a834983ef93d1b058ab.
This does not yet prove an original multi-position sequence with workspace
overlap; do not claim the residual older BURR discrepancy fixed.

Fixture/error accounting: the new publication snapshot failed to load in the
original (Type12 initially,Type1 on a later attempt). Its single-record bytes
differ from the working enum8 fixture only in totals and reversed blank-coordinate
order. Cause is NOT established; use established enum8 for accepted captures.
The initial constructed HE/AT/publication files also appended an incorrectly
encoded marker04000000 (tag1024/low-byte0, not tag4). Their first snapshot was
loaded and the AT helper trace is verified, but the trailing record is invalid.
Do not present these files as validated saves; preserve them as failed-fixture
evidence. The shared-board replay reads only the first valid snapshot. A clean
AT recapture from a single-record or correctly serialized fixture is desirable.

## Twelfth checkpoint: owned game/history and consecutive simulations

Supersedes the unfinished game/history/publication statements above. The owned
`portable_engine` now loads original saves, selects history, searches, plays a
ranked move, computes original scoring/statistics/refill, saves and reloads.
`replay_portable_game.py` matches the fresh BURIN turn, all22 features,
statistics, evaluation693 and seven non-private external inputs. Native history
load matches33 original records and the2038-byte save, including five computed
refills and continuous private RNG. Selecting record26 retains future history;
a later save appends snapshot+marker instead of truncating it.

The wasm game replay loads the original game20 times without increasing heap
use, selects the pre-BURIN position, runs late search, commits/refills BURIN,
preserves all33 future records, saves36 records and reloads the new branch.
It compares original board/blanks/racks/totals and the complete saved bytes.
Original Open restores human orientation even when a prior turn selected the
computer. Temporary imports are freed. Packed history storage excludes wire
headers; boundary probes cover full payload capacity and in-place compaction.
Allocation, malformed-input and callback failures preserve logical state.

The owned simulation API runs from resources, dictionary and a public position.
The original exhaustive run matches150 refills,450 events,six publications,
final460 candidate bytes and final ranking. The limited random session matches
31 draws/refills,90 events,one publication and final candidate statistics.
Private RNG words are computed, not supplied as recorded outcomes.

A consecutive exhaustive->random-cancel replay exposed a real integration bug:
the API retained the pre-simulation ranking, but the original next simulation
uses the last displayed sampled ranking. Corrected the engine and wasm adapter.
The previous exhaustive final ranking is byte-identical to the cancellation
trace's initial ten moves, and the private seed continues without adjustment.
Native/wasm now match both sessions:154 refills,458 events,seven publications,
including the partial cancellation counters and no extra final publication.
Pre-start cancellation consumes no inputs. Native callback-failure/retry tests
also preserve logical position, seed and result. Successful/cancelled simulation
updates the ranking used by the next simulation or play.

The persistent simulation hash uses that runtime's private RNG. Individual
fresh endgame calls use a separate local hash and cannot silently initialize a
subsequent simulation with an unrelated seed. Simulation errors roll back its
hash so a failed call does not consume an unreported private RNG prefix.

Original Escape publication capture completed before VM shutdown; its component
native/wasm replays compare eight events,one publication and all three restore
phases. Owned QEMU8963/exec8448 exited normally after34m09s; all recorders exited.
No VM or recorder was launched for the new standalone acceptance probes.
The prior seven-hour automation remains paused.

The new API/wasm wire contract and modification boundaries are documented in
[PORTABLE-API.md](PORTABLE-API.md). A fresh broad regression is running; the
initial attempt found an outdated isolated selector stub after shared-workspace
routing changed. The stub now uses the new symbols and verifies workspace
forwarding. The full suite must complete before recording a new accepted count.

## Thirteenth checkpoint: acceptance audit and host-error retry

The owned-lifecycle regression passed220 commands, including79 host tests and
all earlier original comparisons. Report:
`toolchain/portable-verification-owned-lifecycle.json`. This precedes the final
host-error distinction described next; it is preserved as an honest checkpoint.

Eight further owned native/wasm sessions exercise heuristic CPU fallback,
admitted late search, endgame, and both selectors enabled, with two sessions
per engine. They match complete results, all consumed runtime streams and
restored logical positions:79 late-gate calls and55 endgame calls. Inputs here
are deterministic host callbacks, not original debugger traces; these tests
establish portable integration and complement the original selector captures.

The wasm adapter previously treated exhausted clock input as ordinary cancel
inside the native engine, then returned an error without publishing the advanced
seed. That could leave persistent simulation hash initialization inconsistent
on retry. Added the optional `runtime_failed` signal to distinguish host failure
from intentional cancellation, including a publication-buffer capacity failure.
The engine now restores its prior hash on these errors. A wasm failed-clock
attempt followed by retry exactly matches the clean native engine's complete
result and private seed. This is a tested failure path, not just a documented
precondition. A final221-command suite is running with source-file SHA256 maps
and an unchanged-source assertion before its report may be published.

Acceptance map for the five requested steps (final suite pending):

1. **Simulation lifecycle implemented.** Complete original random-limit,
   exhaustive and ordinary Escape sessions compare publication timing, partial
   counters, board/rack restoration and rebuilt leave state. Owned native/wasm
   consecutive sessions additionally prove ranking reuse and private RNG
   continuity. Inner search cancellation is an explicit cooperative API.
2. **CPU fallback implemented.** Natural and controlled original decisions
   prove multiplier8224, workload indexing, unsigned divide and1700 threshold.
   Owned late and simulation dispatch use explicit calibration and force bypass;
   zero calibration rejects, low calibration falls back, high admits late.
3. **Differential coverage expanded.** Original blank scoring, crossing-buffer
   aliasing, stable ties, no-move returns, garbage collection, interruption,
   continued histories and repeated sessions are in the suite. Native sanitizer
   probes and wasm error/retry checks cover public API boundaries. This is
   acceptance on concrete cases, not universal behavioral equivalence.
4. **Game lifecycle implemented.** Original multi-turn continuation and final
   adjustment replay, computed BURIN commit/refill/statistics, original history
   selection, preserved future branches and exact save/reload are accepted.
   Native/wasm public entry points no longer need preloaded emulator workspaces.
5. **Standalone interface implemented.** Resources/dictionary/tables and all
   engine workspaces/history are owned; inputs are validated; runtime callbacks,
   allocation/capacity/errors and cancellation are explicit. Native and wasm
   initialize independently and run game/search/simulation acceptance. The API
   and modern-port modification points are in `PORTABLE-API.md`.

Remaining boundaries beyond this acceptance: full classic UI/event-loop recovery,
a browser UI/live host-import bridge, arbitrary user-entered move validation,
all-position equivalence, arbitrary resource variants/SANE80 arithmetic and
byte-exact recompilation. The older late-search capture still cannot be
reconstructed solely from its public position: its prior shared-query/cache
history is absent. The old one-byte BURR comparison remains an unresolved
fresh-state comparison, while the original-state component replay and fresh
owned late capture pass. Do not describe that historical comparison as fixed.
A clean original AT fixture capture would also improve the helper evidence,
because the existing file had a valid first snapshot and malformed trailing
marker. These limitations are retained rather than erased by passing tests.


## Final acceptance: five steps complete

`toolchain/portable-verification-five-steps.json` passed **221 commands**,
including **79 host tests**, all preserved original comparisons and the new
owned lifecycle/mode/error-retry probes. Started 2026-09-10T00:19:56.569975+00:00; completed
2026-09-10T00:25:20.630790+00:00. The report records SHA256 for all 505
source/build/test files and asserts they did not change during verification.
The final portable wasm SHA256 is `1978e4495ccfaa94cc876726705f4074b796c5e34794e878f3f4af84cd9ad4ee`.

The five acceptance-map items above are complete. This replaces their pending
status and the older open-step statements; chronological investigations remain
as evidence. The remaining boundaries in the preceding paragraph are explicit
limits of this acceptance, not silently claimed solved. Current usage and
modification guidance: [PORTABLE-API.md](PORTABLE-API.md).

All foreground verification and owned capture/VM processes have completed.
No additional timed run, automation, commit or push was started.


## BURR follow-up: root cause identified and corrected

CORRECTION: the older BURR74-unit difference is no longer an unexplained
prior-state discrepancy. The C reconstruction split the original A5-4c0c
occurrence-mask table into search and leave views, then overwrote current
synthetic-population sentinels with the stale leave view. The correction
synchronizes these views before leave preparation. Original fresh-start
captures prove these sentinels are initialized within the current search.

A normal public AT search followed by the target position now reproduces all
340 original ranking bytes in native and wasm, three repeated searches each.
Removing only the correction restores the exact74-unit difference. The real
original crossing-buffer/row-flag overlap remains a separate behavior that
must be preserved for compatibility. No new VM session was launched.
See [BURR-FIX.md](toolchain/BURR-FIX.md) for addresses, causal controls and
reproduction. The expanded223-command regression passed, including79 host tests, with
unchanged source fingerprints: `toolchain/portable-verification-burr-fix.json`.
The corrected active rack-constraint weights also match24 original capture
checkpoints. This correction is accepted; the BURR discrepancy is resolved.

## Query/scratch follow-up — 2026-09-10

The apparent POOFIER scorer discrepancy was a harness lifecycle mismatch: a
fresh C engine was compared with a warm original process. Continuous replay
matches both cold (28) and warm (14) outcomes. The live match runner now rejects
that mismatch using an original-resource initialization check. CODE29's shared
record clear was missing from the C reply-tightening routine and is now explicit;
it removes ALOIN's stale n after VID's terminator. Original before/after debugger
reads prove the clear, and public native/wasm replays match all bytes.

All 230 regression commands pass with unchanged source fingerprints in
`toolchain/portable-verification-scratch-lifecycle.json`. Strict continuous replay
passes 277 positions / 2,722 ranked records; a fresh guarded live game and its
offline replay pass another 22 positions / 220 records. These are imported-position
search comparisons, not full UI gameplay. The owned disposable QEMU81598
(session38162), both live traces, live game and regression processes are terminal.

User steering now prioritizes instruction-to-C mapping/auditing as a preventive
measure. `instruction-audit/README.md` tracks the initial global association index
and the first fully effect-mapped 36-instruction routine, without claiming a
complete instruction-level port.
