# Owned native and WebAssembly engine

The public interface is `reconstruction/portable_engine.h`. `make` builds
`.build/libmaven-reconstruction.a`; `sh scripts/build_wasm_portable.sh` builds
`.build/maven-portable.wasm`. The engine owns resource tables, dictionary,
mirrored board, racks, caches, heuristic/late/endgame workspaces, simulation
entries, game statistics and history. No emulator is required to execute it.
The original dictionary and extracted resource data are still required.

## Native operation

Create with `MavenTableResources`, the dictionary blob and `MavenAllocator`.
The constructor copies the inputs and frees partial allocations on failure.
Release their source buffers immediately if desired. Destroy the engine with
`maven_portable_destroy`. Allocators must provide ordinary C alignment.
An engine is synchronous and nonreentrant, including from callbacks. Distinct
engine instances have independent workspaces.

Set a `MavenPosition`, or load an original save with `maven_portable_load`.
Positions contain 225 lowercase board letters, 225 blank flags, two terminated
racks, two 32-bit score bit patterns in point-times-100 units, the pass/row-zero
counter and selected side.
Validation checks representation and tile inventory, not dictionary legality.
The setter accepts active positions; import/get also handle finished games.

Call `maven_portable_heuristic`, `maven_portable_late` or
`maven_portable_endgame`. Heuristic observation exposes every candidate before
ranking. Late search accepts an explicit compatibility calibration; force
bypasses the CPU gate. The gate can fall back to heuristic. Endgame requires
an empty bag and the supplied opposing rack to equal the unseen inventory.
Its elapsed-time and cooperative cancellation callbacks run between restored
iterations. This individual endgame entry point uses a fresh local hash from
its supplied private seed; it does not consume a game runtime's RNG stream.

`maven_portable_simulate` starts from the last successful search or last
published simulation ranking. Configure random sampling with a positive
sample limit, or exhaustive enumeration with 7..17 unseen tiles; lookahead
specifies pairs of replies. Late/endgame reply selectors are optional and
use the same recovered dispatch rules and shared state. Supply calibration
when late is enabled; elapsed seconds when endgame is enabled. The optional
`endgame_started` callback lets a host reset its per-search clock.

Publication timing matters. Each batch publishes before computing its new
samples. Exhaustive completion publishes once more. A random limit or
cancellation preserves the last displayed ranking without an extra final
publication. That displayed ranking becomes the next simulation/play input.
A cancelled simulation returns partial counters and advances the private seed
through work actually performed. Pre-start cancellation consumes no inputs.
The logical game position, statistics and history survive all simulations.

Commit one of these ranked moves with `maven_portable_play_ranked`. The engine
computes placement, scoring, feature collection, statistics, refill, player
transition, finishing rack adjustment and history. A successful play invalidates
the ranking. `get_position` retrieves the resulting position; side2 means
finished. `history_select` restores the position preceding an existing record,
including its recorded racks/orientation. Future records stay in history;
the next play/save appends a snapshot and marker to create a branch.

Save with `maven_portable_save`, using the returned required size for a retry
if capacity is insufficient. Load parses and replays the original big-endian
records, so refills still need runtime inputs. Statistics reset on import as
they were not serialized. Original Open resets the active player to the human
orientation; it does not preserve the post-turn selected side. The API retains
this behavior. History capacity is 512 records and 65,536 payload bytes;
record headers are additional wire bytes. Imported payloads are packed into
owned storage, and temporary import memory is released after each call.

## Runtime inputs and failure contracts

`MavenGameRuntime` owns the caller's nonzero 31-bit private seed and callbacks
for legacy ticks and Toolbox Random. Private random words are computed inside
the engine. Carry the returned seed into subsequent operations. The history
runtime optionally supplies the original per-refill stack-tick input; normal
hosts can instead initialize it deliberately. Each refill has a 4096-event
bound so an unchanging clock cannot leave the engine spinning forever.

Simulation lazily initializes its persistent endgame hash using the same
private RNG stream. Subsequent sessions reuse that hash. Individual fresh
endgame calls use an isolated hash so they cannot silently seed a later
simulation with unrelated random state. A failed simulation restores its
persistent hash along with preserving the caller's seed and output.

Return codes are OK0, invalid1, allocation2, no-position3, diagnostic4,
unsupported5, cancelled6, external-input failure7 and capacity8. A failing
play/load preserves logical game/history/statistics, result and seed. External
callbacks already consumed cannot be undone. A cancelled individual endgame
preserves output; a cancelled simulation deliberately returns a partial result.
Callbacks may already have observed provisional publications before an error.
Do not confuse a callback notification with a successful final return.
The optional simulation `runtime_failed` callback reports failures from host
clocks/publication adapters separately from requested cancellation; the wasm
bridge uses it for exhausted clocks and publication capacity. These errors
also roll back persistent hash initialization so retry consumes the same RNG
prefix as a clean engine.

## WebAssembly wire adapter

The freestanding wasm bridge uses the same owned engine and zero imports.
`maven_port_buffer(id)` and `maven_port_capacity(id)` expose bounded staging
buffers. Write only within capacity. Integers in serialized buffers are big
endian; callers do not depend on C structure packing or wasm endianness.

| Buffer | Contents |
| --- | --- |
| 0 | Resource package: 43 offset/length BE32 pairs followed by resource bytes |
| 1 | Dictionary bytes |
| 2 | Position: letters225, flags225, racks16, scores8, counter2, side1 |
| 3 | Ten 34-byte ranked move records |
| 4 | Candidate observation records: phase, mode, move34 |
| 5 | Elapsed-second BE32 input stream, up to4096 events |
| 6 | Up to4096 tick/Toolbox inputs: BE32 kind0/1 and value |
| 7 | Up to512 per-refill initial stack-tick BE32 inputs |
| 8 | Original history wire, up to67,584 bytes |
| 9 | Play result: move34, features88, statistics176, evaluation4, side4, phase4, history-count4 |
| 10 | Simulation configuration: ten BE32 words, described below |
| 11 | Simulation result: entries460, published moves340, five BE32 counters |
| 12 | Up to256 publication records: count4, event-index4, moves340 |

Buffer10 words are seed, lookahead, flags (bit0 exhaustive, bit1 late, bit2
endgame), sample limit, endgame budget seconds, late calibration, external
input count, refill-start count, elapsed count, and cancellation poll number
(zero means no requested cancellation). Buffer11 counters are completed
batches, total weight, publication count, candidate count and session status.

Exports cover create, position/get-position, search/late/endgame, simulate,
play, load, history-select, save and count. See the signature declarations in
`scripts/wasm_portable.c`; `scripts/replay_wasm_game.mjs` is a complete resource
packing/load/search/play/save/reload example, and
`scripts/replay_wasm_portable_simulation.mjs` runs two consecutive sessions.
`maven_port_count` exposes ranking count0, candidate count1, cutoff2,
used-late3, gate estimate4, endgame iterations5, elapsed cursor6, seed7,
external cursor8, refill cursor9, saved byte count10, history count11,
heap bytes12, publication count13 and simulation event count14.

This adapter accepts explicit streams for reproducible execution. It is not
a browser UI or a live browser-clock bridge. A responsive application should
run the engine in a worker and add host callbacks/cooperative scheduling.
A synchronous worker cannot receive ordinary message events mid-call; use
shared cancellation state or a resumable API if interactive cancellation is
required. Native callback hooks already identify the required boundaries.

## Compatibility and modification boundaries

The engine keeps 34-byte original records, including trailing word bytes,
wrapped arithmetic, stable tie order, pool limits and original resource scores.
The original occurrence masks are one shared table. The reconstructed late
search and leave-table views must stay synchronized, including synthetic
population masks outside the rack's letters. Losing those masks changed rack
combination weights and caused the now-resolved0.74-point BURR discrepancy;
see [the regression and data flow](toolchain/BURR-FIX.md).

Crossing queries retain a 64-byte workspace whose upper half aliases row
scoring flags. Clearing it between rows or replacing it with isolated buffers
changes original behavior. Preserve this in compatibility mode; a cleaner
modern policy should be an explicit alternative with its own tests.

For a modern engine, separate configuration for dictionary/scoring resources,
search budgets, evaluation policy, randomness and cancellation is preferable
to changing the reference implementation silently. This constructor currently
validates the recovered resource format, not arbitrary Scrabble variants.
The compatibility CPU loop count is not wall-clock seconds and should not be
replaced by timing a differently compiled modern loop without defining the
resulting search-policy change.

Original record serialization and a modern semantic move interface can coexist.
A modern save format could preserve active side and statistics explicitly;
the original format cannot. Browser rendering, networking, tournament rules,
arbitrary move entry and full classic UI reconstruction remain application work.
No byte-exact recompilation or equivalence on every possible position is claimed.

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
