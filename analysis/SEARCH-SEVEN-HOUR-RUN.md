> Historical timed-run log. The old automation is paused. Current process
> ownership and behavioral acceptance are in [BEHAVIORAL-COMPLETION.md](BEHAVIORAL-COMPLETION.md).
> Do not act on a PID or deadline below without a fresh ownership check.

# Move generation, ranking, and search — seven-hour run

User-authorized window: 2026-09-09 14:05:30–21:05:30 UTC.
Goal: complete readable recovery of move generation/ranking/search, validated
against the original executable and full candidate/choice comparisons.

Previous source and evidence are preserved. Baseline:64 native tests, three
wasm modules,31 build/replay commands passed. None implies complete engine
recovery. The22-long vector is move statistics, not proven ranking.

At21:05:30UTC stop timed work, close only owned processes, write a handoff,
and pause automation `mac-maven-seven-hour-decompilation`. Do not mark the
larger goal achieved unless complete generation/ranking/search actually works.
No subagents are authorized. Original media stay preserved; use the disposable
VM and explicit code/ROM/register handshakes.

## 14:05 UTC start

Fresh clock, repository, goal and automation checks completed. New goal is
active. Existing paused heartbeat updated for the new deadline. No edits or
results from the previous run were discarded. First task: establish the
corrected-binary call paths for generation and candidate ranking, then complete
collector orchestration using already verified components.

## Runtime ownership

Owned disposable QEMU PID 36921, execution session51984. ROM handshake passed before boot. Cleanup: QMP quit through scripts/qmp_session.py; wait session51984. No other QEMU process existed before launch. Deadline unchanged21:05:30UTC.

## 14:17 UTC ranking recovery

Added `reconstruction/candidate_ranking.[ch]`: CODE3 sampled-result ranking
and strict incumbent selection; CODE28 top-ten insertion; CODE44 eligibility,
word-only duplicate rejection/replacement and removal. Corrected Capstone
assemblies for CODE3/17/18/19/27/28/29/30/35/36/37/44 are saved under toolchain.
These expose erroneous old DAWG-header claims: the34-byte records carry word,
three score terms and coordinates, not dictionary headers.

Original traces:64 top-ten calls match with recorded eligibility boundary;
128 subsequent calls match reconstructed eligibility and all list side effects
(31 insertions,37 cutoff skips,60 eligibility rejections). Eligibility modes2–6
and extra callback A5+0xad2 (CODE44+0x84 word deduplication). Full CODE28 identity
checked before traces; full CODE44 identity checked paused immediately after.
CODE3 sampled/incumbent functions currently independent-host-oracle only.
The signed32 overflow, signed division, zero-count fallback and stable ties
have300 randomized oracle cases. Original eligibility mode1 board branch is
not yet exercised. Further full move stream and search recovery remains.

VM36921/session51984 remains owned and paused. Recorder sessions91237,68922,
63134 all exited0 and cleared owned breakpoints. No other child process live.

## 14:23 UTC complete opening placement stream

`opening_placements.[ch]` recovers CODE37+24e recursion and opening iteration.
275 natural placements from rackeiimosx across both fingerprinted dictionary
sections match full order/word/row/column/opening adjustment/remaining counts;
final counts restored. This boundary is BEFORE CODE37+e46 exclusion/scoring.
`capture_opening_generator.py`, `replay_opening_generator.py` and
`opening-generator-live.json` preserve evidence. Synthetic ASan/UBSan test
covers blanks, lexical/column order and premium-adjacent vowel adjustments.

Correction: the first rejected opening capture found boardAEONIC, a speculative
position, NOT sentinels. No trace accepted from that run. CODE54+4 is indeed an
all-zero test; empty engineboard is allzero. Newgame confirmation plus Discard
of this agent-created game produced the verified empty-board stream. One60s
recorder UI-wait timed out; its cleanup hit a pending RSP stop reply, so no
success was claimed. A fresh connection rearmed the same sole breakpoint and
successful session51340 cleared it. Harden recorder cleanup next. Sessions65287
and81514 failed/closed;51340 completed0. VM36921 remains paused/owned.

## 14:32 UTC scoring integration and crossing helpers

Added opening_moves integration, occurrence-mask construction and
cross_check_letters. Cross helper synthetic suffix/prefix/duplicate-order tests
pass under ASan/UBSan. Opening full scorer integration awaits original stream
capture. Recorder73525 is active (owned), measuring an opening for hidden rack
`?aeopru`; QMP-only workload snapshot confirmed one blank. Capture collects
both E46 placements and1332 final candidate callbacks, so this larger search
requires longer. Do not attach another GDB client while it runs. New recorder
cleanup now closes the potentially stale RSP connection and uses a fresh
ROM-verified connection to remove its own points. Native source compiles.
CODE15+198 at E46 is earlier-section duplicate suppression, not a blacklist;
OPENING-GENERATOR.md records the correction and current boundaries.

## 15:04 UTC opening, collector and occupied-board work

Original opening rack `?aeopru`: all7394 placements and4381 scored34-byte
records match in order; preliminary top-ten state matches byte-for-byte.
Prepared leave table and initial exchange seed are supplied boundaries.
Complete CODE35[36c,a48) collector recovered:16 natural calls match every
feature/weight, total, board/value/rack/undo/scorer and cache side effect.
Captures move-evaluation-live.json and numbered02..16 preserve this evidence.
Added static exchange_candidates and canonical mask arithmetic, with sanitized
host tests; original exchange stream still pending. Occupied-board traversal
passes16 exhaustive synthetic placement-set comparisons, including blanks.
board_moves composes that traversal with scoring/metadata; original acceptance
pending recorder21859/PID46300, currently active on OPAQUER board via CmdK.

Recorder73525 did save a complete valid opening trace but its naive cleanup
reported E22. A fresh ROM-verified connection explicitly inserted then removed
all three owned points to prove absence, recorded cleanup_recovery in JSON.
Shared maven_debug_cleanup now handles pending stop packets and confirms E22
absence by insert/remove. All16 collector recorders cleaned successfully.
Recorder71683 timed out waiting at idle board and cleaned successfully. No
other capture process remains besides21859. Owned VM36921/session51984.
Last full suite69passed; two later sanitized collector/exchange tests passed
separately. New board_moves integration still needs its runtime comparison.

## 15:12 UTC occupied board, leave table and exchanges accepted

377 original OPAQUER-board placements match full order/count state;222 scored
records match all34 bytes and preliminary ranking. Corrected word scratch
clearing: CODE37 clears16 bytes once per eligible anchor, preserving tail
bytes within that anchor across section traversal. No blanket NUL-tail masking.
CODE32+efa leave preparation matches128 words,96 canonical masks, occurrence
masks, all pattern/mask timestamps and balance cache state.96 natural exchanges
match every record and retained ranking. Capture/replay_leave_table.py and
replay_exchange_candidates.py preserve evidence. First recorder32180 rejected
full CODE32 identity, cleaned and exited; inspection proved exact previous
floating-trap-rewrites-live fingerprint across the entire resource. No bytes
ignored. Corrected recorder62423 exited0; exchange57717 exited0, both clean.

Added heuristic_search.[ch] connecting those components and CODE35 reranking;
whole-search comparison remains pending. Recorder97667 is currently active,
triggered by CmdK; VM36921/session51984 still owned. No other recorder alive.

## 15:16 UTC first complete heuristic search acceptance

heuristic-search-live.json and replay_heuristic_search.py match all328 natural
callbacks:96 exchanges,222 placements,10 full-collector reranked finalists.
Final ten records/count/cutoff, board/value/rack/count/undo/scorer state,
leave words, canonical masks, pattern/mask timestamps and balance cache match.
This uses original immutable dictionary/evaluation tables and prepared cache;
leave values and exchange seed are now COMPUTED by the recovered composition.
Recorder97667 completed0 with cleanup. VM36921 resumed for further game cases.
This is CODE28 heuristic selection, not yet CODE3 simulation or CODE30/36
multi-ply/endgame search. Additional boards/blank/late-game coverage remains.

## 15:23 UTC three complete native/wasm searches and endgame primitives

Whole searches328,613,588 callback records all match native and freestanding
wasm, including final lists and mutable state. No wasm imports. Second trace
was Maven's normal AI turn after QUOTA; third was human Kibitz after REGIE.
Recorders88881 and27551 completed0/clean. Failed13930 was an identity deferral:
CODE32 legitimately unloaded at actual outer entry; fixed recorder verifies
CODE28 there, then waits for natural CODE32 load before matching its exact
source/known FP rewrite bytes. No speculative loaded-address identity accepted.
VM36921/session51984 resumed; no capture currently active.
Expanded portable-verification.json:61 commands pass, including native suite
and all existing/new original replays. Added endgame_tree.[ch] node bounds,
pruning, GC, compact move codec, pass, transposition lookup/reuse and position
hash. Sanitized synthetic test passes; ORIGINAL endgame acceptance pending.
Disassembly generation is now reproducible with scripts/disassemble_code.py.

## 15:33 UTC rollout application and refill accepted

rollout_search.[ch] recovers CODE3[2c6,66a) computational batch. First original
capture rollout-batch-live.json matches90 checkpoints for10 candidates and2
reply plies, using recovered heuristic selectors and recorded refill outputs.
Second rollout-batch-refills-live.json matches all90 checkpoints with30 refills
COMPUTED from bag reconstruction and private RNG.356 ordered RNG/clock events
match; private seed is initialized once and continuous across all30 refills.
Toolbox random values and TickCount reads are explicit external inputs (debugger
pauses affect timing). Full candidate46-byte arrays, weighted score/win/count,
selected moves, board/value/racks/count/undo/scorer state all match. No array
masking or supplied selected moves. Recorder87498 and25138 exited0/clean.
Sampled ranking candidate-sampled-live.json also matches one natural call;
that replay still supplies the original eligibility callback result.

Added opponent_samples.[ch] static CODE38 enumeration with multiplicity weights
and exact skip-first traversal. Independent labelled-tile subset oracle tests
17 bags, duplicates/blanks, weight sums and callback stop. No ORIGINAL CODE38
enumeration trace yet. Random sampling is repeated CODE31 refill of temporary
rack after clearing hidden rack; CODE38+4 currently accepts every sample.

VM36921/session51984 paused in active simulation after the second complete
batch. No recorder active. Resume and cancel normally before changing game.
Deadline unchanged21:05:30UTC. Full endgame/late-game search still pending.

## 15:38 UTC live late-game/endgame dispatch and reproducible fixture

The test game was advanced via normal original Kibitz choices and Play.
`media/maven/session/share/maven-search-late13` is a new original saved game
at13 unseen tiles, captured through Save UI. No guest memory writes. Repeated
Kibitz reused existing results; heuristic recorder26158 timed out cleanly and
paused the VM during save text entry. Resumed, inspected/reentered exact new
name, and saved successfully. That failed recorder produced no accepted trace.
After RUBRIC, original AI dispatch is CODE36+1810 with85 occupied cells.
After Maven EN, human Kibitz naturally enters CODE30+14e with empty bag.
Dispatch recorders22483/47525 exited0 and cleaned. Recorder83276 currently
captures completed CODE30 tree operations with every node/free-list link.
VM36921/session51984 owned. 66 portable verification commands now pass,
including74 native tests and both complete rollout replays.

## 15:52 UTC exact endgame component acceptance

128 original CODE30 operations match every one of8192 nodes:reset1/select1,
add-move51/expand75. Further64 match bounds2/select4/allocate29/prepend29.
Files endgame-tree-live.json.gz/endgame-tree-bounds-live.json.gz plus
replay_endgame_tree.py. The full solver's final choice is NOT yet reconstructed.
Recorders83276/42325 and native replay sessions39651/82397 all exited0.

CODE27 reply bounds plus CODE43 conflict tests:16+128+32 original calls match
all bounds, flags, cached conflict groups and linked-reply order. Third trace
computes54 nested CODE39 rack-bound calls from original prepared tables.
Separately32 natural paired-rack calls match. Added endgame_rack_bounds.[ch],
reply_bounds.[ch], endgame_move_cache.[ch] (cache module currently static with
sanitized host test). Original table construction:4 calls match all nine-word
rows; two further calls also COMPUTE CODE43 score preprocessing. Full sources
preserve signed word/long wrap, strict comparisons, stable order and the
24-point continuation penalty. New frontier selection/termination helpers have
host tests but no direct original checkpoint acceptance yet.

Recorders7675,74262,55252,70152 and two table recorders all exited0/clean.
Original solver returned naturally during final two-table capture; its UI
ranks NEAT C2 first. Saved separate new fixture maven-search-end6 through Save
As, preserving maven-search-late13. VM36921/session51984 now running/idle.
No recorder remains active. Main CODE30/36 and CODE45/29/43-map setup still need
integration/recovery; deadline unchanged21:05:30UTC.

## 16:06 UTC full two-rack endgame generation accepted

Original CODE40 generation emitted1941 raw candidates (1357 own/584 opponent).
Native ASan/UBSan reconstruction matches every raw34-byte record, both top-ten
lists, all six depth tables, canonical/occurrence/point masks,87 linked reply
summaries, conflict map rebuilt from their geometry, scorer/count/undo state.
Capture endgame-generation-live.json and replay_endgame_generation.py.
Recorder19154 and native68134 exited0. No full solver acceptance claimed.
VM36921/session51984 remains the sole owned VM. Recorder74380 now captures
CODE37 local reply generation, after the complete CODE40 return. Deadline
unchanged21:05:30UTC. Local reply/leaf tightening are the next integration gap.

## 16:17 UTC local replies and complete leaf expansion

CODE37 local-reply reconstruction now matches20 calls/416 candidates, all
raw records,31 anchor masks, board/value/count/undo/rack and scorer state.
Traces local-replies-03-live.json and -04. Older first trace used the wrong
leave-table address and is NOT an acceptance fixture; second lacked row
flags. Row control bytes atA5-6d2 can suppress main-word multipliers while
cross-word multipliers remain active. Local continuation can alias own/reply
rack pointers and retains full-rack occurrence masks after consuming tiles.
For captures03/04 aliasing follows the verified CODE29+272 callback contract;
new recorder versions store both pointers explicitly.

CODE39+4 correction recurrence matches16 natural calls. Full CODE45 leaf
reconstruction in endgame_leaf.[ch] matches two original expansions and all
ten phase checkpoints, comparing every8192-node pool entry, free links,
board/app state, mask tables, score caches and linked replies. CODE29's reuse
of ranking/best-move byte storage as scratch is outside the leaf API's outputs
and not claimed as fully modeled. Tests run native ASan/UBSan.

Important static correction: CODE31+4 only COUNTS newly placed tiles; it does
not rescore the move. CODE30 preflight tests existence of ANY generated move,
not a going-out win. Earlier informal descriptions were inaccurate. Original
A5-acc is a read-only reserve control in the observed code, not a proven
allocation counter; full search capture will record it and clock boundaries.

Recorders74380,89148,40533,36936,35293,99234 all finished and cleaned. Native
leaf94081/66274, local76155/17652 and correction replay all passed. VM36921
finished original search and ranks NEAT C2 first. Now reopening same fixture
for full CODE30 capture. Deadline21:05:30UTC unchanged.

###16:25UTC — complete endgame acceptance and late-game transition

The complete normal CODE30 search now matches the original six-iteration
`endgame-search-live.json.gz` trace, including all8192 final node slots,
frontier choices and all340 final ranking bytes. Native replay and the new
freestanding wasm endgame module both pass. The expanded portable verifier
passes82 commands. This does not yet cover original collection/cancellation,
blank endgames or no-move termination.

Only QEMU PID36921/session51984 remains active. Recorder sessions and verifier
session65374 have exited successfully. VM is paused at verified CODE36+1810
in `late-search-dispatch-02-live.json`, naturally entered by Kibitz on the
saved late13 game. No debugger client is attached. Next: recover larger pool
occurrence masks, CODE42 multiset weights, and CODE36 reply summaries/search.

###16:34UTC — late-pool collector accepted

The native CODE36+6de collector reproduces all2815 natural initial pool
callbacks and all defined fields of its90 retained replies, plus physical-slot
column-cache behavior and cutoff. Original uninitialized record padding is
not treated as output. The pool is aadeeeeiknort (13 tiles); this fixture has
no candidates using more than7 tiles. The first CODE37 stream is also being
replayed through the expanded pool generator. CODE42 source and an independent
physical-tile draw oracle are implemented; live weight recording is pending.

Important memory alias: CODE42's scratch cache at A5-445c starts at occurrence
row123 ('{') of the A5-4c0c table. Its ffff initialization supplies the recursive
aggregate-bucket sentinel; explicit portable arrays mirror this overlap.

Recorder PID/session18441 owns the only GDB connection and is collecting pool
merge and weight phases. QEMU remains PID36921/session51984. Native regression
makecheck passed76 tests; the complete endgame replay still passes after the
larger-pool scoring changes.

###16:40UTC — pool weights and initial late rankings accepted

`late-pool-live.json.gz` is complete:2815 initial selection callbacks,2292
second-pass merge callbacks, and61 natural CODE42 weight calls. Native pool
traversal matches all2815 full candidate records/scores/used counts; native
collector matches all defined first-pass fields and every66-byte second-pass
record. Scratch occurrence row123 is verified ffff in the original.

`late-ranking-live.json.gz` contains16 complete original CODE36+113a calls and
127 CODE36+91e valuations. The no-unseen-Q valuation and weighted ranking ports
match every call, including candidate records, retained rankings, constraint
allocation effects, fallback cache and CODE43 conflict groups. Unseen-Q
valuation remains explicitly unsupported rather than approximated.

The first pool stream reuses invariant premium/class/dictionary tables from
an earlier original capture; a fresh executable/dictionary identity check is
being taken by the local-refinement recorder. No mask below128 occurs in that
stream, so its seven-tile leave table is provably never accessed.

Recorders18441 and53504 completed/cleaned. Recorder23319 now owns GDB and is
capturing two natural CODE37 local-pool refinement calls and CODE36+18c inputs.
Only QEMU36921/session51984 and this recorder remain active. Deadline remains
21:05:30UTC. Full CODE36 search and unseen-Q cases are still incomplete.

### 16:56 UTC — local reply preparation and search leaves accepted

Completed both local CODE37 pool calls (606 candidates) and CODE36+18c
refinement, preserving every 66-byte reply record. CODE36+14d0 preparation
matches all 90 original pattern calls, intermediate applied boards/counts,
undo/scorer state, and sorted final records. Original search returned ten
moves; complete CODE36 orchestration still needs integration.

New CODE32+9dc late leave replay matches all 128 words, tile points,
canonical/occurrence masks, timestamps, and balance cache. Correct mapping:
CODE32+16c0 is raw lookup; +164c adds single-letter expectation. The special
constant at A5-97c is '?' (blank), not 'u'. This corrects the working static
interpretation; no Q/blank path has yet received full search acceptance.

The full regression completed 87 commands before the latest local/preparation
components; their dedicated sanitizer replays passed afterward. All recorders
are closed. Only owned QEMU36921/session51984 remains; paused naturally at
CODE36+1f0c after a second Kibitz leave-table capture. Deadline21:05:30UTC.

### 16:58 UTC — complete no-unseen-Q late search accepted

`late-search-live.json.gz` records a complete naturally requested CODE36
search from entry through return: ten local passes and ten final moves.
`late_search.c` computes the entire path: 13-tile pool traversal, selection,
restricted merge, pattern preparation, 61 constraints, late leaves, own move
ranking, and all local reply refinements. Native sanitizer replay matches
30 checkpoints and every final 34-byte move. First choice RUBRIC, followed
by BURIN, COURB, SCRUB. Both 90-record pools and constraints match.

The same recovered source compiles to freestanding wasm with zero imports;
its replay matches final move records, both pools, conflict map, constraints,
leave values, canonical masks and generation counters. Native pointers are
reconstructed from explicit arrays; guest serialization tokens are never
dereferenced. Raw reply pointer fields are excluded from byte comparisons,
with actual list/constraint behavior compared separately. This is one full
late-game acceptance position, not coverage of unseen Q, exchanges, memory
fallback or all tie/blank states.

Captures45211 and23971 and all native/wasm build sessions completed. Only
QEMU36921/session51984 remains, paused at the full original search return.
Expanded regression is starting. Next recover unseen-Q valuation and extend
late search to exchange-eligible pools, plus broader endgame cases.

### 17:11 UTC — Q and exchange paths accepted in complete searches

Three additional original complete searches match native/wasm: a13-tile pool
with unseen Q (BORIC first), a16-tile unseen-Q pool with exchanges (NIBS first),
and held-Q plus U (QUIM first). Held-Q without U also matches native, with QIS
first; wasm replay is pending for this latest fixture. The Q positions are
separate constructed tag0 test saves, not naturally played histories. Each
loads through normal Open and searches through normal Kibitz; no guest memory
or code patch. Tile conservation and all resulting words were checked.

The16-tile fixture trims THEY->THE, GUV->GU and VOX->OX, ALAND->LAND.
The earlier unseen-Q fixture changes ALANG->ALAND, uses the released real G
for the existing blank G, and moves that blank to Q in QUOTA. Both board
orientations and blank values are symmetric after original Open. Original
saves remain unchanged; fixture hashes/provenance are recorded separately.

Recovered full CODE36+91e now includes large-pool Q expectation branches,
word-vs-long product truncation differences, exchanges and held-Q/blank cases.
Complete native/wasm q16 replay matches all30 checkpoints, both90-record pools,
constraints and final records. New captures verify full loaded CODE31/32/35/
36/37/42/43 bodies, allowing only exact previously measured SANE rewrites.

Expanded regression completed95 commands before the latest Q extensions.
Inventory now associates all recovered search stages with explicit source
ranges/evidence; byte association remains distinct from completion coverage.
Only QEMU36921/session51984 and recorder59436 are currently active; recorder
59436 owns GDB for the own-blank search. Previous recorders8020/13648/96438
completed and removed breakpoints. Deadline remains21:05:30UTC.

### 17:18 UTC — seven complete late-search fixtures accepted

Native and freestanding wasm now accept seven full original searches: base13,
unseenQ13, unseenQ16 with exchanges, ownQ with/without U, own blank, and
unseen blank. The latter six use constructed saves loaded through original
Open/Kibitz. Native compares 30 selected stage checkpoints, all ten final move
records, both 90-record reply pools (excluding serialized pointer fields),
constraints and leaves. Wasm compares final state/pools/ranking; its checkpoint
count does not mean per-stage byte comparison. Transient scratch globals are
not comprehensively compared. Latest source resets the local column cache on
the first actual local pass even if an earlier ranked pass was skipped.

All recorders closed; only owned QEMU36921/session51984 remains, paused at
the poolblank search return. Expanded regression now includes all seven
fixtures. Next targets are original opponent enumeration/simulation scheduling
and wider endgame behavior. Deadline unchanged21:05:30UTC.

### 17:22 UTC — exhaustive opponent enumeration accepted

A separate enum8 save adds ANTIAR with five real tiles, generated using the
original dictionary on the unseen-Q13 board. Remaining pool eeeekoqt yields
five original CODE38 callbacks in exact order: eeekoqt(weight4), eeeeoqt(1),
eeeekqt(1), eeeekot(1), eeeekoq(1). The native reconstruction reproduces all
racks/weights/return behavior and preserves counts. All original callbacks
completed full two-reply simulations through normal UI; no memory injection.
Board/value arrays and both rack strings restore after enumeration. This
accepts CODE38 enumeration for one full fixture; full continuous simulation
composition and cancellation still need work. Expanded regression107 passed.
Recorder95113 closed and removed its breakpoints. Final sampled-ranking
capture is now starting; only owned QEMU36921/session51984 is persistent.

### 17:28 UTC — complete finite exhaustive simulation accepted

Five consecutive original CODE3 batches now replay as one uninterrupted
native computation from the first input state, with no resets between batches.
The new simulation_search wrapper derives unseen counts, enumerates every
opponent rack, executes the recovered heuristic replies/refills, and computes
the sampled ranking. All450 original state boundaries match, including150
refills, weighted accumulated scores/wins, and every final ranked record.
Private RNG continues across batches;100 original clock/Toolbox/private-check
events are staged, rather than substituting refill outcomes. A freestanding
wasm build reproduces the same450 boundaries and final ranking with zero
imports. This accepts finite exhaustive simulation with heuristic selectors;
random infinite sampling, cancellation and CODE3 post-session cache rebuild
remain separate, and endgame/late-enabled simulation needs integration.

The test caught a missing A5-4e2a tile-count state write when small-pool
heuristic search skips the final evaluation pass. CODE37+ea4/eb2 establishes
the correct update, now mirrored in heuristic_search.c. Prior heuristic
fixtures will be rechecked with the expanded suite. All captures/replayers
closed; only QEMU36921/session51984 persists, paused at sampled display+132.

17:29 UTC recorder6136 timed out waiting for the endgame entry; it cleaned
its breakpoint and paused the VM. No endgame capture was produced and no
result was inferred. The original dialog still showed Use End Analyzer and
Enumerate All Racks selected. Recorder39389 rearms with a180-second socket
timeout, followed by normal Return activation of the visible default button.

### 17:35 UTC — endgame simulation corpus and scratch-record correction

Eleven original endgame calls are captured during one ordinary End Analyzer
simulation, with2..32 iterations and complete node/engine snapshots. Initial
calls matched native/wasm; the third exposed shared A5-5a32 scratch ownership:
final node expansion preserves bytes after the word terminator, seeded from
the last leaf best-empty record, not the saved caller selection. The port now
mirrors that alias before final ranking and still restores caller selection.
The previously failing complete third trace passes. The corpus is being
replayed after the correction; no bytes were masked out.

Recorder60433 finished all ten additional calls and cleaned breakpoints.
Recorder96255 now captures a full original batch with endgame call clock
streams. QEMU36921/session51984 remains owned. Regression112 passed before
the latest endgame/scratch integration; new corpus regression is underway.

17:40 UTC all12 complete endgame fixtures passed native/wasm after the scratch
alias fix. rollout-endgame-live adds20 endgame calls/249 clock reads inside
one full90-checkpoint batch, also accepted native/wasm and averaged ranking.
The unified search_dispatch now handles heuristic and endgame composition.
Q16 coverage repeat accepted native/wasm and hit original large-Q branches
36:aae/ab8/c0c/f2a/f50/f88 plus93a/c84/d88/ee8/e98. Recorder77735 closed.
Recorder49152 now waits for a Late Analyzer simulation. Only this recorder
and owned QEMU36921/session51984 are active. Deadline21:05:30UTC unchanged.

17:42 UTC recorder49152 timed out waiting for a simulation batch because
the menu selection had not opened the dialog. It cleaned its breakpoint and
paused the VM. No late-simulation result was produced. A concurrent UI pointer
move received VM-not-running during cleanup, without a mouse press. Recorder
closed; resumed the VM and reopened the freshly inspected Stuff menu. Future
rollout waits use180 seconds and settings are opened before the recorder.

17:46 UTC UI gate probe78101 confirmed original CODE3+154 returns1. Its
20-event cap interrupted a held menu drag47393; cleanup initially collided
with the drag's QMP connection (connection refused/time out). QEMU stayed
alive. Fresh ROM handshake and insert/remove checks confirmed all9 owned
breakpoints absent, then resumed and explicitly released the mouse. Both
probe/drag processes are closed. A700ms held click at180,58 successfully
opened Simulate. Short70ms menu clicks can silently dismiss without dispatch.
No guest memory patched. Recorder99199 now owns GDB for Late Analyzer batch,
started by normal Return. The16-tile UI disables exhaustive enumeration, so
this case uses original random opponent sampling (recorded at batch entry).

17:47 UTC recorder99199 reached original batch entry but its identity check
found CODE36 unloaded after opening Simulate. It stopped before advancing
the batch and cleaned all breakpoints. Recorder28655 resumes that exact
entry with --at-entry; the recorder now resolves the original LoadSeg stub
on each late call, verifies full bodies after return, and removes old code
addresses before another load. This is loader observation, not injected calls.

### 19:47 UTC — late simulation composed and accepted

There was an app/sampling inactivity gap after the17:49 work; no continuous
work is claimed for that interval. Late batch recorder28655 completed and
closed. The native comparison then exposed only shared new_tiles mismatches.
CODE36+1642 explicitly clears/increments A5-4e2a, including at2346 before
final candidate reranking. Mirroring that write for pass/local ranking and
refinement resolves every mismatch without masking. Native and zero-import
wasm now match19 late calls,30 refills,90 boundaries and final sampled ranking
in rollout-late-live. Native uses ASan/UBSan. Originalforce0 is preserved.

New simulation candidate seeding matches all ten46-byte records in each of
two original first-batch configs. Eight signed-word lookahead boundary checks
are static semantics, not new guest evidence. First setup build accidentally
included the historical THINK compiler probe; excluding that separate-ABI
file resolved the build and the actual setup comparison passed.

Expanded regression30930 is running. Recorder40371 owns GDB while observing
the next original random opponent sample. Only disposable QEMU36921/session
51984 remains as a persistent owned VM; fresh process args and QMPdebug state
were verified before the recorder. Deadline21:05:30UTC unchanged.

### 19:54 UTC — computed random draw flows into full simulation

Recorder40371 captured original CODE38 sampling (oyeraqt), then62749 captured
another draw (onyiaev) including the state before sample/opponent clears.
Both closed and native refill comparisons passed. New random_opponent.[ch]
recovers CODE38+12..22 using computed remaining bag and existing refill.
Recorder77173 captured the immediately following batch; sampled-ranking
recorder completed afterward. All GDB clients are closed; QEMU36921 is paused
at CODE3+132 with no owned breakpoints remaining.

The connected native/wasm comparison initially chose TRANQS instead of QATS
at event59, despite matching all preceding states and computed random stream.
Original CODE37+868..892 tests A5-6d2[row] and forces main-word multipliers to1
when nonzero. Heuristic search had dropped this control, while late/endgame
already preserved it. Added optional row_flags to heuristic search and wired
the shared original bytes through both simulation adapters. This restores
all90 boundaries and final accumulated/averaged records: computed opponent
draw,19 late calls,30 batch refills, continuous private RNG. No byte masking.
Original control bytes here include nonzero row1/2; interpreting their wider
storage ownership still needs investigation.

Regression30930 completed142 commands successfully before random integration.
69434 now runs expanded comparisons after the shared-control correction.
Only QEMU36921/session51984 persists; deadline21:05:30UTC unchanged.

### 20:04 UTC — cancellation restoration and larger endgame fixture

Original Escape cancellation capture completed through exception_caught,
before_restore,board_racks_restored,leave_rebuilt,returned. The interrupted
board differs from the saved board; restoration matches saved board/values,
both full rack buffers in this trace, and selected pointer. Error depth drops
3→2 and pending payload equals the original cancellation token. New
simulation_restore.[ch] preserves string-copy tail semantics and matches this
trace with native ASan/UBSan; native exception-context routing and14 signed
sample-limit boundary cases are explicitly host checks, not guest coverage
of the limit branch. Recorder11250 separately captured the post-cancel
CODE32 leave rebuild; all128 entries/masks/cache stamps/balance state match.

Regression69434 completed146 commands. It predates the restore module but
includes computed random draw→batch→ranking and the shared row-control fix.
A constructed end7 save consumes one E through legal generated AE at3,5,
leaving both racks seven tiles and no bag. Normal Open/Kibitz capture16066
completed one iteration with exact root119 bounds; native and wasm match.
This fixture does not exercise GC. Exploration77739 now uses the portable
engine to choose harder rack partitions for subsequent original captures;
those exploratory outcomes are not original-runtime correctness evidence.
QEMU36921/session51984 remains paused after the end7 search; no GDB client.

### 20:10 UTC — larger-tree capture remains active

Deep7 recorder82182 owns GDB and has passed70 iterations; it records all8192
nodes and restored workspaces each iteration. The original tick clock advances
only a few seconds across debugger pauses, so the120-second guest budget is
not wall-clock elapsed time. Native/wasm bridges now accept4096 clock samples
and iterations for broader fixtures; prior bound was256. Host76 tests pass.

CORRECTION: the first exploratory wasm counter was named collections but was
wired to the general tree poll callback, so those counts were NOT GC counts.
It was renamed poll_calls; a separate empty_pool_polls records observed zero
free-list head at polling points. Recomputed exploration supersedes the first
report. No user-facing original-GC claim was made. Five selected partitions
reach empty pools in this host vehicle; gc7 (beekoqs/ceinrtu) takes120 host
iterations and is saved for original capture after82182 closes. The updated
recorder has explicit before/marked/after collection sites and optional
--save-every10, retaining all checkpoints while reducing repeated compression.
QEMU36921/session51984 remains the only persistent owned VM. Deadline unchanged.

### 20:18 UTC — prefixes and prepared boundary fixtures

A native ASan/UBSan replay matches the first102 complete original deep7
iterations and all8192 nodes/workspaces at each checkpoint. This is explicitly
a prefix, not a whole-search result. Recorder82182 continues beyond156.
A gc7 fixture and a blank7 fixture are ready; the latter swaps the real rack Q
with the blank representing Q on the board, conserving physical tiles.
No-move fixture construction searched1081 legal six-tile placements, finding
BEDECKS with six additions at column10. It leaves own Q/other EINORTU/no bag,
and the recovered generator finds no Q placement. This remains an exploratory
fixture until the original application searches it. No existing save overwritten.

The no-move replay path now supports an absent search clock/ranking phase and
retained node/conflict state; it is not yet original-accepted. Complete end7
replay is being rechecked after these harness changes. No GDB clients other
than82182, and no background exploration remains. QEMU36921/session51984 owned.

### 20:37 UTC — complete251-iteration acceptance

Deep7 recorder82182 completed251 iterations and exited cleanly. Native
ASan/UBSan replay61416 matches all8192 nodes and workspaces each iteration,
all251 clock reads and the final three ranked moves. Freestanding wasm also
matches final nodes/ranking/state; its recorded research runtime was241ms,
not a controlled performance benchmark. This supersedes prefix-only status.

GC recorder87348 now owns GDB, armed after the original window title and
racks verified maven-search-gc7 (BEEKOQS/CEINRTU). One intermediate file-dialog
selection loaded enum8; the title caught it before capture and it was corrected.
Normal Kibitz starts the search; no search arguments were injected. Updated
recorder saves every10 iterations, retains all in memory and uses atomic gzip
replacement. QEMU36921/session51984 remains owned; deadline21:05:30UTC.

The coverage summarizer observes reachable pass nodes in end7 and simulation09;
that is node-construction evidence, not root-no-move or expanded-pass coverage.
Porting notes now map generation/scoring/ranking/search policy to source files.

### 20:42 UTC — direct GC and blank acceptance

GC recorder87348 completed120 iterations and captured all three collection
sites. Native replay7169 and wasm both match the complete search. Dedicated
replay_endgame_collection.py matches all8192 nodes after pruning+marking and
after sweep+unmarking:1135 reachable nodes,7057 reclaimed,free_head8150,
current7983. Thus collection is now direct original-runtime evidence, beyond
host polling counters. Blank7 recorder35371 completed one iteration; native
94736 and wasm match all recorded state and ten final rankings.

No-move recorder55728 is active after title/racks verified maven-search-nomove
(Q/EINORTU). Original Kibitz invoked through ordinary keyboard input. QEMU
36921/session51984 remains owned. A controlled sample-limit recorder is prepared
but not yet run; it explicitly labels its single configuration-field mutation
and must never be described as an unmodified UI limit termination.

### 20:49 UTC — no-move and controlled-limit acceptance

No-move recorder55728 completed with zero iterations/clock reads and one pass
record. Native23369 and wasm match, including retained old node/conflict
state; this early return does not initialize the tree. All17 completed search
fixtures currently pass focused native/wasm comparisons.

Controlled recorder74198 waited for a natural completed simulation batch,
then changed only config+0 from200000000 to1, equal to the original computed
first candidate weight. Readback proves all other config bytes unchanged.
The original executes CODE3+672, exception_caught, restore, leave rebuild and
return. Native and wasm restored-buffer comparisons pass. This is a deliberate
configuration perturbation; it does not establish an unmodified UI run reaching
200 million samples. The limit field belongs to the disposable call's config.

CORRECTION: review found the native random composition checked computed sample
bytes but still passed the identical captured sample into the batch. It now
passes drawn_sample directly; focused ASan/UBSan87387 still matches19 late
calls,30 refills,90 checkpoints and final ranking. Wasm already consumed its
computed sample. Earlier claims of native buffer linkage were overstated;
individual draw equality and resulting batch outcomes were valid.

A tile-conserving new gcmulti save uses BCEEEKQ/INORSTU. Title/racks verified,
recorder8393 now owns GDB and records every iteration, saving every25. It is
expected to exercise repeated collections based on host exploration only.
Expanded portable regression has started independently. QEMU36921/session51984
remains owned; deadline21:05:30UTC. No other active emulator/recorder owned.

### 20:55 UTC — regression162 and fallback correction

Regression61804 completed162 commands with all passes. It includes17 full
endgame searches, direct GC, blank/no-move, ordinary cancellation and controlled
limit restoration. Its computed-draw native path consumes the computed buffer.
The repeated-collection original capture8393 continues beyond300 iterations.

CORRECTION: CODE36+1834..1896 was described as a memory fallback; inspecting
CODE9+ee/+242 proves a TickCount-bounded CPU calibration. The gate uses a
six-by-nine table, signed16 product by8232 followed by unsigned32 division,
and an unsigned1700 threshold. New late_search_budget.[ch] expresses the
static policy and passes its boundary tests; it is not integrated into the
selector or original-accepted yet. A natural force0 recorder is prepared.
No additional GDB client while8393 owns the socket. QEMU36921/session51984 owned.

### 21:02 UTC — larger search exposes a preserved failure

Recorder8393 completed549 original iterations and three collections. All three
collections match dedicated replay (retained868/667/2; reclaimed7324/7525/8190).
Whole native replay FAILS at iteration403,current231, actual free189 vs191,
with two extra nodes and changed bounds; wasm runs550 iterations. First402
native checkpoints matched. This is not an accepted eighteenth search.
known-replay-failures.json records exact reproduction and evidence scope.

Targeted recorder76825 now owns GDB, skipping402 natural leaf calls without
changing their execution, then capturing leaf403 phases. A second ordinary
Kibitz invocation was needed after the app returned to its event loop. The
CPU gate capture is postponed; its helper remains static-only and unintegrated.
Host77 tests pass; regression162 completed before this new static module.
Deadline21:05:30UTC; QEMU36921/session51984 remains owned.

### 21:04 UTC — handoff of the unresolved leaf

Targeted76825 timed out before receiving any leaf and exited through cleanup;
its output is incomplete and cannot establish phase behavior. No GDB recorder
remains active. The long trace's first difference is NOS versus CQ at current
node231. Next work should reload the save freshly before targeted tracing,
or construct a smaller legal save from that captured board and rack state.
CPU-gate capture was postponed to prioritize this actual mismatch. No speculative
engine fix was applied; all accepted algorithms remain unchanged this late pass.
The optional MAVEN_DUMP_ITERATION native diagnostic now names failing iterations.

### Window closure —21:05:30UTC

Automation mac-maven-seven-hour-decompilation was updated to PAUSED while
preserving its prompt, schedule and target. QMP quit closed owned QEMU36921;
exec session51984 returned exit0. All owned recorders/verifiers have exited.
No user VM or original source disk was stopped, reverted or modified in cleanup.
The seven-hour authorized window is closed; this is not a claim of uninterrupted
sampling throughout the earlier inactivity gap or of full goal completion.

Accepted checkpoint:17 complete original endgame replays;162-command broad
regression passed, followed by77 host tests after the new static workload gate.
Known failure:549-iteration gcmulti, first mismatch403; three GC operations
match independently. The targeted follow-up leaf capture timed out and remains
incomplete. No speculative engine patch was made to hide the difference.
Modification/porting map, corrected speed-gate interpretation, reproduction
commands and next steps are preserved. No commit or remote publication made.
