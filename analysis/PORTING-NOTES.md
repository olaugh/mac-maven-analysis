# Modification and porting notebook

BURR follow-up: the residual0.74-point difference was a reconstructed mask-table
aliasing bug. A corrected public AT->target sequence matches all original
ranking bytes in native/wasm. See [the causal evidence](toolchain/BURR-FIX.md);
this supersedes the older unresolved-BURR statements below.


## Current owned API acceptance

All five scoped behavioral steps are accepted. The final
[223-command verification report](toolchain/portable-verification-burr-fix.json)
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


Current overview: [DECOMPILATION-STATUS.md](DECOMPILATION-STATUS.md).
Next investigations: [NEXT-DECOMPILATION-STEPS.md](NEXT-DECOMPILATION-STEPS.md).
The chronological notes below retain superseded findings and explicit corrections.

## Endgame fallback correction after iteration403 disagreement

Keep the depth-zero and projected rack values distinct when changing the
endgame evaluator. CODE39+051a uses `other_a[127][0]` (all opposing rack points)
when no cached opponent reply is compatible with a candidate. The prepared
own-rack terms still use depth eight. Confusing the two changed pruning,
allocated two extra nodes, and took550 instead of549 iterations in gcmulti.
The same corrected C implementation now passes native and freestanding wasm.
The549-iteration capture and fresh leaf403 phase capture are permanent
regressions; see [the evidence](toolchain/ENDGAME-403-FIX.md). An intentionally
new evaluation policy should have separate tests and acceptance criteria.

## Connected simulation and selector boundary (20:19 UTC)

`simulation_search.[ch]` composes unseen-pool counting, exact opponent-rack
multiplicities, `rollout_search`, and sampled ranking. Five consecutive
original batches match native and wasm at450 boundaries, with150 reconstructed
refills. The private RNG is continuous; clock and Toolbox Random remain
explicit input streams. Replacing them with a modern seeded RNG is an
intentional behavior change and should be selectable separately from replay.

`search_dispatch.[ch]` gives the caller one selection entry point and preserves
CODE3's mixed signed/unsigned pool-size tests. Heuristic, late and endgame routing
are accepted in complete simulation batches. A further original trace computes
the random opponent draw before the batch, retaining the private RNG state.
All engines share application state and numeric tables. Endgame scaling uses
point units internally and restores point*100 externally. Its canonical masks,
leave words and tile points must be copied back into the common leave state.
The final selection is a full34-byte record, including preserved bytes after
the word terminator. Treat those bytes as original serialization behavior;
a modern semantic API may expose a clean string while retaining the original
record for exact comparisons.

The wasm simulation bridge exposes explicit staging arrays and zero imports.
It runs the same C algorithms and compares full event records. Original UI
publication and file logging still need adapters. Original Escape position
restoration and post-session leave-cache rebuilding have separate native
acceptance; full interrupted-session integration and random-loop termination
remain unfinished.
A responsive browser port should run search in a worker, expose deterministic
step/cancel boundaries, and restore the saved board/racks on interruption.
Do not interrupt between scaling into points and restoring application units
without a cleanup path. Allocation/hash initialization are caller-owned.

## Correction: late-search fallback is a speed gate (20:55 UTC)

Earlier notes called CODE36+1834..1896 a memory fallback. That was incorrect.
CODE9+ee runs CODE9+242 twice; each counts loop iterations until TickCount
changes, and only the second count is used. CODE36 selects one of six
nine-word workload rows at A5-89a using own/unseen blank counts and unseen
size8..16. It multiplies the signed word by8224, divides the bit pattern by
the calibration count as unsigned32, and uses heuristic search if the result
is greater than1700. Force1 bypasses this gate entirely.

`late_search_budget.[ch]` reconstructs the pure table/index/arithmetic policy;
its initial tests are static boundary checks, and it is not yet wired into
the shared selector. Runtime calibration is an explicit compatibility input:
a modern C or wasm loop has a different instruction cost, so blindly repeating
the timing loop would change search choice. Preserve a supplied reference
calibration for replay or document an intentional modern budget policy.
CORRECTION after original capture: multiplier0x2020 is8224, not the earlier8232.
Natural and explicitly controlled-calibration decisions now match native and
wasm. The shared selector accepts a workload table/calibration callback; NULL
table retains the prequalified replay path. Full session wiring remains open.

## Exit and memory-pressure boundaries (20:49 UTC)

`simulation_restore.[ch]` matches original ordinary Escape restoration in
native C and wasm. A second capture deliberately changes the disposable
session's limit from200000000 to1 after one completed batch. Original
CODE3+672 then takes its limit exit, unwinds and restores; the same buffer
checks pass. This proves the controlled branch, not natural completion of
200 million samples. A modern controller can return an explicit completion
reason and call the restoration helper while its snapshot remains alive.
The recovered core still needs that integrated controller and post-session
leave preparation; a host `setjmp` check is not a browser cancellation API.

Endgame pool reclamation is now accepted against original before/marked/after
snapshots. Keep the active frontier protected and sweep in original index
order for compatibility: the resulting free-list order affects subsequent
allocation and search. Root no-move returns a pass record before tree reset;
therefore a caller cannot assume every search clears all workspace. These
properties are covered using retained, nonzero state from earlier searches.

## Where to modify move choice

The entry points form a usable map for future changes:

| Change | Source boundary | Compatibility detail |
| --- | --- | --- |
| Legal placement generation | `board_placements.c`, `opening_moves.c`, `cross_check_letters.c` | Preserve dictionary section filtering, blank identities and emission order. |
| Board scoring | `score_move.c`, `score_accumulate.c`, `move_finalize.c` | Values are normally points times100; endgame temporarily uses points. |
| Static move value | `move_evaluation.c`, `leave_table.c`, `heuristic_search.c` | Leave, premium exposure and row controls affect ranking beyond raw score. |
| Which search runs | `search_policy.c`, `search_dispatch.c` | Enabled endgame handles unseen total below8; enabled late search handles8..16; otherwise heuristic. The original tests narrow to a byte and mix signed/unsigned comparisons. |
| Simulation lookahead and samples | `rollout_search.c`, `simulation_search.c`, `random_opponent.c` | One opponent sample is shared by every candidate in a batch; preserve RNG state between refills and batches. |
| Endgame memory or time budget | `endgame_tree.c`, `endgame_search.c` | Pool size, pruning ties, transposition sharing, frontier history and clock rounding can change the chosen move. |
| Late-game approximation | `late_search.c`, `late_ranking.c`, `late_reply_value.c` | Pool identities, Q/blank branches and narrow integer arithmetic are part of observed behavior. |
| Reported candidate order | `candidate_ranking.c` | Preserve eligibility filters, tie order and original score/weight arithmetic before adding alternative ranking policies. |

For a modern application, expose a semantic move (word, coordinates, blank
assignments, score and evaluation) alongside the raw34-byte compatibility
record. Build public entry points around a validated position and owned search
workspace; the current wasm staging buffers are replay interfaces. Keep the
reference mode deterministic with supplied clock/random streams, then make
new search policies explicit options. A change should rerun the preserved
original comparisons and add a separate test for the intended new behavior.

## Complete late-search port boundary (17:21 UTC)

`late_search.[ch]` now composes the full normal CODE36 computational path for
8..16 unseen tiles: pool generation/selection, anchor merge, pattern caches,
constraints, leave preparation, exchanges, own placements and local replies.
Eight original fixtures match native and freestanding wasm, including Q and
blank cases. The wasm bridge uses explicit arrays and indices; serialized
68K pointers are evidence tokens only. No browser/desktop UI is required.
CPU-calibrated fallback, user cancellation and all extreme/tie states still
need original acceptance. Fixed buffer capacities remain trusted-research
contracts; public APIs need input validation and allocation error reporting.

Preserve original integer widths when modifying ranking: some large-Q paths
multiply and truncate as16-bit words while adjacent pass paths use32-bit
products. Another own-Q/blank branch computes a temporary result then restores
registers without adding it to the return value. Those behaviors were retained
and accepted in full original searches; strategic improvements should be
separate, explicitly selected policies with original mode still replayable.
Local reply cache initialization follows the first actual local pass, which
may occur after an earlier ranked pass is skipped. Pool-slot identities must
remain stable while column caches and constraint lists refer to them.

## Verified wasm milestone (08:25 UTC)

This supersedes earlier statements below that no wasm build exists: a first
freestanding wasm build now runs in Node and matches all 149 ordered words
from the four natural Word List captures. Build with
`sh scripts/build_wasm_query.sh`, then run
`node scripts/replay_wasm_query.mjs PATH/TO/maven2.1`.
Evidence is wasm-query-replay.json. LLVM 18's local clang/wasm-ld built it;
no downloaded toolchain or runtime dependency was needed.

Table installation moved into dictionary_tables.c with a header independent
of setjmp and filesystem APIs. Both native startup and the wasm bridge call
that same function. The bridge stages the fingerprinted original bytes in
linear memory, supplies four normalized query fields, and returns emitted
text. Only memset/strlen are supplied as small freestanding runtime functions.
There are no wasm imports. This is a bounded research interface, not a public
untrusted-input API: fixed capacities and the known file are assumed.

The wasm result does **not** include whole-file loading, longjmp/error transfer,
Mac Toolbox calls, browser permissions, UI, or gameplay. Node execution proves
wasm behavior for this core, not browser integration. Next browser work can
reuse the module with an explicit validated input boundary and a worker; the
remaining decompilation still requires original-runtime evidence.

This is an implementation notebook, not a claim that a full port exists.
Keep original behavior reconstructible before introducing intentional changes.
Attach each change to its original CODE range, observable effect, and a
replayable input/output trace. Separate intentional modernization from fixes
to a mistranslation.

## Existing seams that a port can use

The enumeration driver now traverses reconstructed whole-file loading,
dictionary setup, normalized query preparation, and enumeration. Hardcoded
root indices/table offsets were removed from that driver. The connected path
matches all 149 ordered emissions from four saved natural traces; see
loaded-query-replay.json. The native filesystem adapter is deliberately a
single-file research adapter, not a full Toolbox implementation. It maps a
configured host path to the guest logical open and uses a synthetic reference.
A desktop/wasm backend can replace this adapter while retaining the core and
the replay gate. UI event polling and final rendering are still external.

The host Makefile builds the reconstruction into a C library and a dictionary
enumeration executable. The enumeration/lookup code is the most developed
headless path: four natural queries produce 149 matching emissions, but that
does not establish gameplay, move evaluation, or full UI correctness.

Most reconstructed UI and Toolbox operations already use callback adapters.
Keep algorithm state and byte decoding independent of a desktop or browser UI.
Implement TextEdit-like selection, event routing, file access, and clipboard
operations at that boundary. Preserve callback order and state mutation where
the original reads values again after an external operation.

## Data representation

`dictionary_setup.c` is now the startup bridge from the whole-file loader to
the two dictionary tables. Its table offsets and roots match the natural
startup trace. Both tables point into the original allocation; keep that
allocation alive and do not copy or free it independently of the table state.
A wasm memory growth can invalidate JavaScript views even when numeric wasm
offsets remain usable, so a future bridge should recreate views at boundaries
instead of caching native-style pointers. This is a proposed bridge design,
not a verified browser implementation. Any new bounds validation belongs
before installation, with checks for arithmetic overflow and complete root
records; the original setup's two 'a' checks are insufficient validation.

Classic THINK C's 16-bit int and 32-bit long/pointer assumptions must be
explicit. Use fixed-width integer types and explicit signed conversions.
Preserve machine wraparound with unsigned arithmetic when the original wraps;
do not rely on signed C overflow. Do not cast original file bytes to native
structs: Macintosh fields use big-endian order and two-byte alignment, unlike
many modern native layouts. Pointer fields in captured memory remain guest
addresses; resolve them through an adapter rather than casting them on a host.

`file_metadata.c` illustrates that boundary: it builds the original 122-byte
parameter block, writes a 32-bit name address at byte 18, and delegates the
PBHGetFInfo operation. A desktop/browser backend needs a name-address resolver
or a deliberate higher-level API. The two helpers preserve output assignment
even on error. Physical data/resource-fork size is not equivalent to a modern
single file's byte length. A port must document its replacement policy instead
of silently changing the meaning.

## Text and UI modifications

Original text mixes Pascal strings, C strings, and MacRoman bytes. ASCII
case conversion leaves high bytes unchanged; smart quote bytes are MacRoman,
not Unicode. Convert only at a documented UI boundary. A Unicode port needs
an explicit decision about byte-indexed selections and dictionary input.

CODE 17+0x97a installs CODE 9+0x742 through SetWordBreak. Thus the existing
word_boundary.c is a modification point for word selection/navigation, but
changing its rules can also alter TextEdit behavior. Its original end test
uses allocation size, not logical text length. The host decision function
avoids speculative guest reads; preserve that distinction in compatibility
tests. The original wrapper's callback ABI still needs live verification.

Word-list lengths use a saturating 16-bit decimal scanner and caller-specific
defaults. Raising limits requires checking buffers, lengths, output capacity,
and callers together. Increasing only a UI number is not a safe full change.

## Desktop and WebAssembly directions

Volume lookup uses an imperfect Pascal comparison at CODE 23+0x17a: it omits
the last byte and treats equal high-bit lengths as matching without checking
payload. This may cause the first similarly named volume to win. The current
reconstruction preserves this behavior. A modern volume picker should use
stable identities; retain a compatibility mode or explicit migration test
before correcting the comparison in a behavior-preserving port. Live examples
of the original lookup remain pending, so this is a static finding.

The C semantic core is a candidate for a WebAssembly build, but no wasm build
or browser execution has yet been verified. The first useful gate is the same
recorded dictionary-query replay in native and wasm builds, with byte-identical
ordered outputs. Add filesystem/UI bridges only after that gate succeeds.

Browser file selection and clipboard operations are asynchronous and permission
mediated, whereas many Toolbox calls are synchronous. Prefer explicit operation
states or a host adapter that stages input before core execution; do not assume
that a callback can block the browser UI. Preserve reentrancy and cancellation
semantics deliberately. This is a design direction, not a selected framework.

Classic resources and both file forks need a portable container representation.
Keep original bytes plus provenance hashes and stable type/id lookup. Extracted
resources can feed a host resource manager without emulating the Finder. Game
save code currently sets Finder type XGME; a modern extension/container can
carry that metadata, but save parsing and complete round-trip behavior must
first be reconstructed and verified. Never treat dictionary extraction alone
as recovery of the whole original file format.

## Remaining gates

The undo workspace is not a full game snapshot: it records a row, newly placed
columns, a marker, and the previous rack string. undo_move.c clears the recorded
board/value cells and restores the rack but leaves count tables and totals
alone. A modern command/undo abstraction must preserve the caller's surrounding
updates or explicitly capture more state. Testing only that board letters
disappear would miss these dependencies.

The placement loop now exposes typed state pointers rather than A5 globals.
It updates both board orientations and their parallel value words, consumes
counts only for newly occupied cells, and records undo columns. For a future
single-board representation, the adapter must keep the second orientation
consistent until every consumer is ported. Existing-tile handling and blank
consumption have host tests, but caller scoring and boundary cleanup remain
separate; using this loop alone as a complete move API would omit required
original state changes.

Rack reconstruction must retain alphabet order and byte-count semantics when
comparing original states. rack_counts.c only clears configured alphabet slots,
preserving all other entries; broad memset would change state. Its output
treats high-bit counts as negative and omits them. Normal seven-tile racks do
not reach this edge, but generalized rack sizes or Unicode character indices
need a separate port policy. The existing ASCII interface intentionally avoids
the original's negative indexing for high-bit input bytes.

The board stores both orientations. Changing to a single 15x15 grid requires
adapters for every original row/column access, the parallel word array, undo
workspace, and row-zero special records. board_state.c exposes the original
orientation transform and occupancy scan. The latter includes border slots;
do not replace it with a playable-cell count without checking border invariants.
The apparent end predicate uses exact counter values six and two, with an
occupancy threshold for two. Keep these legacy rules explicit until natural
game-ending traces establish their role and any intended modernization.

The tag-2 replay adapter now makes the history dependency explicit: restore
the previous index, update totals and rack strings, rebuild rack counts, apply
the move, then refresh. Do not parallelize these callbacks or precompute record
fields across restoration; the original reads state after the recursive call.
The refresh wrapper compares rack pointers, so replacing pointer identity with
copied equal strings can change which refresh work runs. A modern state model
should use an explicit player identity while testing that mapping against the
original two rack addresses. Full move application still needs reconstruction.

Tag-1 initial-history records hold two eight-byte rack strings at +6/+14 and
a rack selector word at +2. history_initial.c restores these using the original
copy semantics. Do not reinterpret the selector as a host Boolean serialized
with a native struct layout; any nonzero 16-bit value selects the first rack.
The word at +4 is returned by a backwards history scan, and is intentionally
zeroed in saves. Its exact name remains unresolved. A port should retain the
clear/restore behavior until its callers establish what saving is resetting.

Save records serialize raw handle bytes behind a 16-bit tag/length header.
Their contents cannot safely be replaced by a native struct dump on a modern
host: endianness, pointer fields, and layout need per-record decoding. Tag 1
temporarily clears a word at payload+4, whose meaning is still unknown. Sizes
are narrowed to 16 bits then sign-extended for the write, so large records need
an explicitly versioned format change. The original write loop ignores errors;
stronger reporting or atomic replacement should be added as a documented
modernization after natural round-trip evidence establishes the baseline.

The save/open wrapper at CODE 47+0x16c tries Create after any open/truncate
error and ignores failure reading the application creator metadata. The new
file_open.c exposes the stale Finder-info scratch bytes as explicit input.
A port should distinguish missing files from access/truncation errors and
define metadata behavior intentionally; silently choosing a creator would
obscure an original error path. A safe modern save design also needs an
explicit atomic-replacement policy, but that would be a deliberate behavior
change, not a claim about how the original writes. First capture the original
successful save and parse the complete file format before making that change.

The index-loading caller (CODE 15 [4,0xd2)) is now connected to the reconstructed
whole-file loader in the native probe. On the original file it returns record
267,671, whose low byte is `'a'`. It starts two records before EOF and scans
backward; the last file record is excluded. Changing dictionary packaging or
appending metadata at EOF can therefore break this assumption. A port should
either preserve that layout or introduce a versioned explicit index pointer,
with original-file compatibility tests. The caller still lacks a natural
return-value capture. Malformed short files can underflow indices in the
original; the C reconstruction currently has a valid-file contract, not a
secure untrusted-file parser.

The whole-file loader at CODE 47 [0x25c,0x2ee) is a concrete filesystem
modification point. It opens the file, gets EOF, requests a cleared allocation
of EOF+1, reads with a mutable count, checks allocation size equals final count+1,
closes, then adds NUL. A successful short read therefore fails the allocation
size check. Its early GetEOF/allocation failures return without closing;
read/size failures dispose memory without closing; a close failure disposes
memory. `whole_file.c` deliberately retains this order. A modern adapter should
first expose these events in tests, then separately implement any approved
cleanup policy. Do not hide short reads by returning a fabricated requested
count. A browser bridge can stage selected file bytes before this synchronous
core runs. The host pointer API cannot reproduce guest faults from pathological
32-bit allocation-size wrap; record that limitation rather than claim exact
behavior for every address-space input.

Full game state, legal move generation, evaluation, simulation, persistence,
and UI integration remain incomplete. A port should replay original games,
compare choices and scores under controlled randomness, round-trip saves, and
exercise resource/error paths. Existing narrow tests are useful evidence for
their modules only. Maintain a trace-to-source map as coverage expands.

### Restore sequence and portable board validation

Natural reopening of the 86-byte saved game now validates the placement
reconstruction's entire board/value arrays and undo prefix (see
`toolchain/game-placement-replay.json`). Letter values are stored in
hundredths of a point: the six one-point AORTAE tiles each hold 100 and the
observed move total is 1400. Preserve integer units at the engine boundary;
formatting for UI is a separate decision. Broader score semantics are pending.

Do not expose history replay as a pure board mutation prematurely. At the
reader's return Maven has refilled the mover's rack and refreshed a count
table for the other rack. A native/wasm port needs explicit sequencing for
placement, undo storage, refill/RNG, player selection and count-cache refresh.
The current placement-only replay intentionally checks no full-restore rack
or RNG equivalence. Its captured table is evidence for this version, not a
hard-coded universal tile-value rule for future lexicons or variants.

### Undo storage, blanks, and random refill

Move finalization is now explicit portable C: boundary-value invalidation,
undo marker plus original rack, and rack reconstruction are separate from
refill. Complete undo workspace matches one natural restore capture. Keep
classic returning diagnostics distinct from host input validation; the
original size diagnostic continues execution and is not a safe parser API.

The reconstructed remaining-bag builder treats an occupied board cell with
zero value as a blank, except row-zero exchange data, which counts literal
letters. Preserve that distinction when changing board storage. A board of
letters alone cannot reproduce tile accounting correctly.

Refill appears to mix time and random helpers, including a possible
uninitialized time local on the small-bag branch. Exact emulation needs a
natural trace before choosing semantics. A modern/wasm implementation can
later offer deterministic seeded RNG as an explicit behavior change; do not
label that an exact reproduction of the original refill sequence.

### Verified refill interface

Natural refill now replays exactly from captured clock and Toolbox-random
values, with the private generator implemented in portable C. Bag construction,
86 bag bytes, 16 input events, complete workspace/board and resulting rack
all match (`toolchain/rack-refill-replay.json`). Reopening the same save in
two runs produced different refilled racks. For a faithful port retain the
external input boundary; for deterministic testing or multiplayer, record
those inputs or introduce an explicitly versioned RNG policy. Capturing only
the private seed is insufficient because the original also uses clock and
Toolbox random values. Debugger-induced timing is part of this trace's limits.

### Scoring precision and corrected coordinate semantics

First-phase scoring is now readable C with explicit word truncation and
32-bit wrap. Preserve the low-16-bit signed product before accumulation;
replacing everything with floating point or unbounded integers changes
out-of-normal-range behavior. Score accumulation precedes a separate blank
optimization phase, so its intermediate result is not a complete score API.

CORRECTION to earlier “boundary-value invalidation” wording: scoring records
existing zero-value tile coordinates in those globals, and later blank
optimization also uses them. The renamed maven_clear_recorded_move_values
preserves behavior while removing that unsupported semantic label. A future
board model should carry explicit blank/value metadata; infer no word-boundary
cache from these fields.

### Complete scoring interface and blank assignments

The valid-input scoring routine now returns score, remaining rack, new-tile
count and recorded zero-value coordinates. It reads the board; placement then
writes tiles and uses the recorded coordinates to mark blanks. Keep those
two operations separate in a port. Repeated letters can be assigned to blanks
at different squares; Maven chooses the least costly placement with strict,
left-to-right tie behavior. A generic “first missing character is blank”
implementation changes scoring. Row-zero scoring leaves the output rack
untouched, which callers must account for explicitly.

### Natural scoring milestone

Complete scorer replay now agrees with a natural AORTAE invocation using
actual premium tables: internal1400, six new tiles, remaining rack i, and
recorded coordinates. This closes the earlier synthetic1200-versus-live1400
fixture gap. Only that exercised path is runtime-verified; blank assignment,
cross scoring and bingo still have host fixtures. Output comparisons stop
at the C-string terminator so uninitialized caller stack bytes never become
an accidental portable API requirement.

### Integrated move application boundary

maven_apply_move_without_evaluation now offers an explicit state-based move
operation suitable for reuse in a modern engine. Scoring, cell placement,
blank marking, undo storage and rack rebuilding are connected; refill and
history stay separate. Combined AORTAE state matches the available natural
captures. Do not equate this with the AI evaluation path or full game loop.
The score callback receives a private copy with score bytes updated; changing
that copy does not alter the original move subsequently placed. Preserve
that distinction when replacing callbacks with UI events or wasm messages.

### Verified engine undo ownership

Natural engine undo now matches the C reconstruction for full board/value,
rack, workspace and counter state. It leaves tile counts unchanged. Keep
count-cache refresh as a caller responsibility instead of embedding it in
undo, or candidate-search sequences may observe a different state. This
trace occurred while Maven searched a new game; user-facing history undo is
a separate orchestration layer still to reconstruct and verify.

### Evaluation vector and modification points

The 22-long evaluation feature vector now has a stable enumerated layout in
evaluation_features.h. This is a useful future tuning boundary: keep feature
extraction stable while experimenting with separately versioned weights, once
the consuming evaluator is reconstructed. Current labels follow observable
assignments; this is not yet a complete model of Maven's move ranking.

Preserve distinct before/after inputs: game-stage thresholds use occupancy
before placement, repetition/vowel features use the original rack counts,
and rare-tile use is inferred from count changes. Moving feature extraction
entirely after placement would change these values. An evaluated row-zero
move also exposes apparently uninitialized scorer output; natural verification
is required before choosing a compatibility or corrected-port behavior.

### Feature validation and runtime code rewriting

All22 features now match one natural evaluated candidate, with the original
collector's seven ID/weight pairs supplied to replay. Before extraction the
collector rebuilds counts from the selected rack; capturing only function
entry state would miss that dependency. The collector remains unreconstructed.

Live resources can differ from disk bytes: observed floating-trap call sites
became direct calls outside the checked collector/scorer bodies. These changes
are consistent with runtime floating-point dispatch optimization, but their
writer and full semantics have not been traced. Preserve separate original
and live hashes; verify exact relevant ranges and retain differences. Do not
normalize arbitrary mismatches or treat patched code as compiler output.

### Correction: statistics are not proven ranking weights

The22-field vector is consumed by per-player accumulation and selected-field
normalization in CODE16. Earlier suggestions to treat this vector as the
move-ranking tuning boundary were premature. Its extraction remains verified,
but final ranking/weight consumers must be traced independently. A port can
reuse the reconstructed statistics accumulator now without presenting it as
an AI evaluator. Normalization preserves asymmetric signed rounding and leaves
many fields unscaled; a generic average across all22 fields is incorrect.

### WebAssembly board/scorer milestone

The same reconstructed C now compiles into an import-free wasm module and
passes natural-capture replays for scoring, combined placement and undo under
Node26. See toolchain/WASM-BOARD.md for build commands, buffer sizes and limits.
The explicit endianness conversion is essential: original value arrays are
big-endian words, wasm memory uses little-endian words. Byte-for-byte struct
overlays would silently corrupt scores.

The bridge resets all storage, loads tables explicitly, and keeps count
preparation separate from application. Its diagnostics trap for testing;
production compatibility may require a returning callback instead. There is
still no browser UI, complete history/refill flow, legal move generator or AI
ranking in this module. The earlier dictionary/query wasm replay also still
passes all149 ordered results after the shared string-header update.

### Rack-balance compatibility details

rack_balance.c preserves the original cache and blank-allocation policies.
One blank averages two composition adjustments; two blanks choose the maximum
of three. A replacement that always maximizes would change Maven's behavior.
Cache keys include pool counts and held composition, but omit draws; zero
results are recomputed. Before modernizing this cache, establish the natural
caller invariant and whether the underlying computation is side-effect free.
Its implementation is still an explicit dependency, not a completed AI model.

### Composition recurrence portability

The underlying rack-composition recurrence is now C over an8x8 grid, with
terminal values supplied independently from the original table pointer layout.
It weights vowel/consonant successors using remaining pool counts, clamps
negative availability, and uses equal weights if both are exhausted. Every
weighted sum wraps32 bits and every level truncates signed division. A single
floating-point expectation followed by rounding can differ from this repeated
integer calculation. Keep terminal-table provenance separate from algorithm
recovery; the saved snapshot's zero smaller-total tables are not universal
constants established for all versions or configurations.

### Composition table evidence

The live cache's19 populated entries match reconstructed total7 composition
adjustments with its observed pool key and terminal table. This supports the
recurrence but does not establish every call's omitted draw/total input.
Keep that limitation attached to the evidence when replacing the old global
cache with explicit state. Direct-call validation is still pending.

### Pattern-cache and mask state

Pattern lookup now uses an explicit native entry struct instead of overlaying
the original10-byte pointer/long/word record. A zero returned score is not
necessarily a miss: a match also supplies a mutable accumulator pointer.
A wasm bridge should expose a stable entry index or handle for that mutation.
The recursive mask helper uses generation stamps to update each reachable
mask once; reuse of a generation intentionally suppresses later updates.
Replacing it with a set traversal must preserve that cross-call state.

### Direct composition validation

The composition C now matches two direct natural calls, including a full
seven-level empty-rack baseline (-49) and a terminal case (-713), both using
Maven's captured table. This strengthens the earlier indirect cache check.
The original table-loading/initialization path and rare arithmetic edge cases
are still separate work; retain captured numerical tables as version-specific
data rather than inferring they apply universally.

### Pattern cache ownership and initialization

Cache construction is now readable C with an allocator callback. The native
entries borrow the source strings and keep mutable accumulators, so a port
must keep string storage alive and avoid silently rebuilding the cache
between lookups. Original records use signed16-bit string offsets; decode
those before converting to native pointers. Do not serialize native structs
as original10-byte records. The original constructor diagnoses malformed
letter order and duplicate patterns rather than normalizing or deduplicating
silently; any user-facing repair policy belongs outside compatibility code.

### Blank compatibility now exercised in wasm

Normal Open of three constructed saves exercises one blank, two blanks for
the same letter, and two blanks for different letters. C and wasm both match
the original score, coordinate ordering, full board/value/undo/count state,
and residual rack at the application boundary. Keep blank identity as tile
value0 even though the board stores its represented letter. A visual editor
that changes only the letter grid loses this information. Save fixtures and
exact provenance are documented in `toolchain/BLANK-SCORING.md`; other blank
contexts remain separate validation work.

### SANE-free letter expectation

The binomial letter expectation now has an exact-integer C implementation
that matches24 natural original calls in both native and wasm builds. The
valid7..100 total-tile domain permits bounded64-bit arithmetic, and the
original final SANE operation truncates toward0. Preserve wrapped32-bit score
differences before weighting. This removes an extended-floating-point and
allocation dependency for this numerical result, but does not reproduce
SANE environment/exception side effects. See `toolchain/LETTER-EXPECTATION.md`
for the bound/proof and excluded precision modes. A new wasm rack-math module
also includes the already verified integer composition recurrence.

### Adjacent premium tuning

`premium_exposure.c` computes the original pre-placement adjacency penalty
using a20-record table (letter,direction,premium product,penalty). Two natural
IOTA candidates produce0 and-20, both matching C. A future tuning UI can edit
this data independently of board application. Preserve directional tests and
neighbor emptiness rules; merely penalizing every nearby premium square would
change Maven's behavior. Only the captured cases are runtime-verified so far.

### Transient cross-word queries and rack masks

The crossing-word helper intentionally writes only one orientation of the
paired board while calling the dictionary, then clears that cell on both
outcomes. A native or wasm dictionary callback must consume this transient
string synchronously; it must not retain a pointer or hand it to asynchronous
UI code. A replacement can construct a separate word buffer after establishing
that callers do not depend on observing the temporary board mutation. Current
host tests preserve the original mutation and query order.

Rack mask validation searches a descending signed16-bit list. The string
builder sign-extends the mask before intersecting32-bit per-position masks;
it does not select by letter identity, so duplicate rack letters retain their
position distinctions. Invalid-list diagnostics may return and the original
still emits the selected string. Keep public input validation outside this
compatibility helper rather than relying on the diagnostic as an exception.

### Single-letter pattern baseline wrapper

`adjusted_pattern_lookup.c` adds the current-pool letter expectation to a
base pattern score and subtracts an expectation using total96 and the original
distribution count minus1. It truncates the combined result at16 bits. This
fixed96 baseline deserves investigation before changing bag distributions;
do not silently replace it with the current bag size. Multi-letter patterns
bypass this adjustment. The accumulator pointer still comes from the base
lookup, even if the adjustment makes a missing single-letter result nonzero.
Underlying lookup and expectation have original traces; this composite wrapper
currently has host tests only and requires a prepared cache.

### Score units at the UI boundary

Captured move scores and letter values use internal integer units (100 for
one-point letters). Keep those raw values in compatibility calculations and
apply presentation scaling at the UI boundary. Statistics vectors mix score
fields and ordinary counts; a blanket scaling pass changes their meaning.

## 2026-09-09 move selector and WebAssembly boundary

`heuristic_search.[ch]` now composes leave-table preparation, exchange/pass
records, both orientation move generation, scoring, top-ten insertion, and
CODE35 finalist evaluation. `scripts/wasm_engine.c` builds this same C into a
freestanding module with no imports. Three complete original searches match
native and wasm candidate streams (328,613,588 callbacks) and final state.
`build_wasm_engine.sh` and `replay_wasm_engine.mjs` reproduce the wasm check.
This is CODE28's heuristic selection, not the CODE3 rollout simulator or
CODE30/CODE36 endgame/preendgame engines. Those are separate remaining work.

For future modifications, change one boundary at a time: dictionary sections,
scoring/premium tables, leave/pattern tables, candidate eligibility, or finalist
collector. Word-only deduplication affects the available finalist set and tie
order; it is a configurable original callback, not interchangeable with
coordinate-based deduplication. Blank assignment belongs to scoring, while
DAWG traversal consumes real tiles before blanks. Full move records retain
some unused word-tail bytes within an anchor; replay compares them exactly.

The wasm bridge accepts trusted, already-decoded original tables. Native words
are little-endian in wasm memory; raw DAWG and move records stay big-endian.
Its buffers have fixed capacities and are not a safe arbitrary-file importer.
A modern public app should validate file/table sizes and dictionary indices,
load licensed/user-provided data, and wrap this engine behind a small typed
request/response API. UI, clocks, files, and random draws should stay outside
the deterministic move-selection core. Cancellation requires explicit polling
through long traversal/search loops; no browser event loop is yet integrated.

Cache timestamps, signed16/32 wrapping, stable tie order, and the original
rack-balance cache key are deliberately preserved. Improving any of them may
change ranking and should be a named compatibility mode with recorded game
regressions, not an undocumented cleanup.

### Simulation batch and opponent-rack sampling

`rollout_search` now composes the original candidate/reply/apply/restore loop
with pluggable selection and refill. Two natural10-candidate batches matched
all90 state boundaries. The stronger refill trace computes30 bags/refills,
keeps one continuous private RNG seed, and consumes356 observed inputs/events.
Clock ticks and Toolbox Random remain host dependencies; deterministic ports
should inject those streams or explicitly introduce a new RNG policy. Such a
policy may improve reproducibility but changes historical game behavior.

`opponent_samples` statically recovers exact seven-tile enumeration with
hypergeometric multiplicity weights and skip-first alphabet traversal. It has
an independent combinatorial oracle, not yet original runtime acceptance.
The random sampler invokes the existing refill on an empty temporary rack,
with the hidden rack string cleared. It accepts all generated racks in this
binary. A future opponent model belongs at CODE38+4's always-true predicate.

Cancellation currently crosses a deliberate boundary: original CODE3 uses
setjmp/longjmp plus its restoration stack. Portable batch code models completed
batches only. A browser worker needs cooperative cancellation at stable batch
boundaries or an explicit unwind that restores board/rack/scaler state; merely
returning from the middle of a reply is insufficient. UI logging and progress
callbacks do not belong in the move generator. Weighted accumulators wrap32
bits, and win counts use two units for a win and one for a draw.

### Exact endgame score units and table cache

The endgame temporarily divides every board/letter value and bingo bonus by100.
The scorer now has explicit bonus-aware entry points, preserving the existing
normal-score APIs. Endgame uses50; regular play uses5000. Do not infer the
bonus from the rack or rescale only final scores: intermediate word arithmetic,
blank optimization and compact-node scores depend on these units.

`endgame_rack_bounds` computes the nine-word rows used by the original bound
recurrences. The fixed24 continuation penalty, wrapping word/long operations,
strict improvements and stabilization stopping rule are historical behavior.
The first6 original table preparations match; two include score reindexing
and runner-up margin conversion. Blank substitution is implemented from the
binary but lacks original-branch acceptance so far. Replacing this machinery
with modern evaluation heuristics is a deliberate search-policy change.

`reply_bounds` now rebuilds each8-group conflict bitmap from reply summaries,
including cross-word extensions and paired-board symmetry. Those reconstructed
maps match the recorded originals, closing that supplied-data boundary. The
same module matches176 original bound traversals, with54 computed nested rack
calculations in the strongest trace. This still does not prove whole CODE30
search ordering or all late-game CODE36 behavior.

CODE37 local reply generation constructs31 anchor masks BEFORE applying the
move, then applies it, enumerates with the second rack, and undoes it. CODE29
also passes the SAME rack pointer twice to explore continuations. In that
case enumeration uses the shortened rack but retains full-rack bit positions.
Copying those two input strings into separate storage changes behavior. The
portable local_replies API preserves pointer aliasing and those masks.

The generator's row flags can suppress main-word multipliers independently
of cross-word multipliers. Ordinary score_move retains ordinary board rules;
board_moves_prepared exposes these historical search controls explicitly.
Twenty local traces match416 raw records. Complete CODE45 leaf expansion now
passes two original traces/all8192 node entries at ten checkpoints, including
CODE29 reply/continuation tightening. Main CODE30 and late-game CODE36 remain
separate acceptance work; this is not yet a full engine completion claim.

## Complete endgame boundary (2026-09-09 16:25UTC)

`endgame_search.[ch]` now composes the recovered generation, reply bounds,
local continuation tightening and tree selection into the normal CODE30
search. Native and freestanding wasm replay the same original six-iteration
fixture exactly, including final move ordering. The caller supplies the
original position/hash table and elapsed ticks. Platform UI cancellation and
its nonlocal exception unwinding are not implemented by this API. One
accepted position establishes integration, not full behavioral coverage.

The next late-game path uses pools larger than a seven-tile rack. Keep
physical pool masks (up to16 positions) distinct from the maximum7 tiles
placed in one move; existing128-entry leave tables cannot be indexed by
arbitrary pool masks. Recover the original CODE37 alternate callback mode
before widening that boundary.

## Late-search integration (2026-09-09 16:58 UTC)

`late_search.[ch]` composes the recovered generator/ranker over caller-owned
memory. The first complete acceptance domain is unseen8..13 and no unseen Q;
only the captured13-tile position has full original comparison. The reusable
wasm bridge exposes numeric arrays in little endian and retains raw dictionary,
pattern and move bytes in big endian. No Toolbox, emulator, libc or browser
imports are required by the wasm module. Host UI, worker scheduling and
cancellation can be layered around this computational interface later.

Preserve original 16/32-bit wrapping and signed comparisons during changes.
The pool's66-byte records intentionally overlap embedded move metadata. Host
pointers must stay separate from their serialized guest tokens. CODE42 scratch
storage aliases occurrence row123; the port mirrors that alias explicitly.
CODE36+4da also reads priority bytes through inherited A2, which normally
points after the generated word's board span; the current port models those
bytes explicitly rather than assuming an ordinary cached-record pointer.

The alternate leave preparation CODE32+9dc uses adjusted single-letter lookup
(+164c) for residual racks, raw lookup (+16c0) for pool averages and Q overrides,
and tests '?' in the special blank override. That override stamps the lookup
entry selected by the replacement `qu` query. These details were checked
against natural execution and matter when changing evaluator tables.

Useful edit boundaries: change dictionary sections for lexicon variants;
change score/pattern tables for evaluation experiments; change candidate
limits and local-cutoff policy only alongside new original/oracle fixtures.
The existing30-checkpoint late replay catches changes to intermediate pools,
constraints and final ranking rather than relying only on the best move.

## Connected random-draw integration (2026-09-09 19:54 UTC)

`random_opponent.[ch]` computes one original CODE38 draw. It clears the first
byte of the opponent rack and scratch sample, preserves their trailing bytes,
constructs the bag, and invokes recovered refill. The simulator consumes that
computed rack with weight1. One native/wasm trace verifies this through90 batch
boundaries and final rankings without reseeding private RNG. Clock/Toolbox
inputs remain explicit; small-bag uninitialized stack ticks need a declared
modern policy if exact historical behavior is not required.

The heuristic generator also needs the shared32-byte row scoring controls,
just like late/endgame generation. CODE37+868..892 suppresses main-word
multipliers when the corresponding byte is nonzero. Dropping the control can
change the selected move after a late→heuristic transition. The new optional
`MavenHeuristicSearch.row_flags` pointer exposes this dependency; NULL models
all-zero controls, not an assertion that original globals were zero. Captured
control bytes are supplied by simulation adapters. Future session APIs should
own the shared storage once and bind every search engine to it.

## Cancellation and partial simulation results

`simulation_restore.[ch]` recovers the session-level position snapshot and
restoration. It restores board/values, both rack strings and selected side;
it does not reset partially accumulated candidate totals, undo/scorer scratch
or pattern caches. The original Escape trace interrupts an altered board and
restores the saved position exactly. Native and freestanding wasm both match
the restoration buffers and selected side; the wasm check covers the pure
cleanup operation, not browser event delivery or complete session unwinding. CODE3 then recounts the selected rack and
rebuilds the heuristic leave table; the separate captured rebuild matches all
128 leave entries, canonical/occurrence masks, stamps and balance state.

A native compatibility session can use the recovered error context around a
live snapshot. A wasm/browser interface should propagate cancellation to one
restoration boundary with an explicit result, since native/68k jmp_buf layouts
are not portable and browser work should be interruptible. Preserve the
original partial-sample accounting separately if reproducing cancelled rankings;
normalizing or discarding incomplete samples is a new policy, not yet accepted
against the executable. The signed32 first-candidate sample limit is recovered,
but its natural limit-triggered exit still lacks a direct capture.

The endgame bridge exposes caller-owned original node/scratch state for the
root no-move path, which can return before tree reset and score scaling. Do
not assume that every invocation initializes the entire workspace. Larger
research traces allow4096 iterations/clock observations; this bridge limit is
not an algorithmic search limit. Production APIs should provide an explicit
clock/cancellation callback and storage policy rather than replay arrays.

## Saved snapshots and the pre-search display rebuild

Fresh original traces history-snapshot-live.json and
history-snapshot-rebuild-live.json establish a compatibility trap. CODE7 tag0
clears mirrored blank values using column+16, despite board transpose using
column+15. Four words in enum8 differ after Open:365/381 remain1000 rather than0,
while382/398 become0 rather than100. CODE20+004e clears and rebuilds engine
board/values from the display grid before Kibitz; its +0276 cell writer uses
column+15 and the character class high bit for blanks. Native and wasm match
both transitions. Keep history_snapshot and display_board as separate steps;
normalizing on initial load is a deliberate modern-port behavior change, not
an exact reproduction of the original loader return. UI redraw callbacks are
outside the portable computational rebuild. Pending display edits are excluded
with force0, accepted/synchronized with force nonzero.

history_records provides bounded zero-copy parsing of original BE16 tag/length
framing. The historical reader retains the tag's low byte. The modern parser
rejects truncation, negative lengths, empty histories and excess records before
writing descriptors. Descriptor payloads borrow the input storage, which must
remain alive. The research wasm bridge has explicit1MiB/1024-record limits;
it is not a full standalone game API. Full history traversal, multi-turn refill,
save/reload and undo/continue remain acceptance work.

### History playback refresh and consecutive calls

The complete history traversal leaves its last record's rack counts in
place until CODE7+4 performs CODE21+52/+4. The portable history playback
now performs this final recount/sort. Omitting it passed isolated fixtures
but failed a consecutive restore using the previous final state. Both C and
wasm now pass34 original record states and30 refills over two consecutive
restores with continuous RNG. The rack display order is prfs+0x312 with
blank last, unlike the internal blank-first alphabet. Keep that distinction
when implementing a modern UI. See history-display-order-live.json and
portable-verification-history.json (180 accepted regression commands).

## Late-search compatibility discovered through games

The EBON/OBE game fixture exposed two hidden dependencies: blank arbitration
can leave the original scorer cursor inside the word, and empty board values
are zero rather than the resource table's sentinel for character zero. The
portable engine models the inherited read with bounded integer offsets. Preserve
these details for exact compatibility; removing the accidental pointer dependency
is a separately testable change in evaluation policy. See
[EBON-FIX.md](toolchain/EBON-FIX.md) for original debugger evidence and native/wasm
regressions, and [game comparisons](toolchain/MAGPIE-GAME-COMPARISON.md) for scope.

## Query lifetime and scratch alias follow-up

A snapshot sets a position, not a fresh process. POOFIER is 28 in both fresh
engines and 14 in both after the recorded prior search sequence; the row flag
is retained output from the shared crossing-query buffer. A host must preserve
both engines' lifetimes during differential tests. CODE29 also clears the
shared best-empty/final-expansion record while tightening replies; omitting
that clear retained ALOIN's final n after VID's string terminator. The clear is
now explicit. See [POOFIER](toolchain/POOFIER-DISAGREEMENT.md) and
[VID](toolchain/VID-SCRATCH-FIX.md). These cases motivate the
[instruction-effect audit](instruction-audit/README.md).
