# EBON / OBE late-search discrepancy

The Magpie-driven original/reconstruction comparison found a reproducible
three-unit (0.03-point) valuation discrepancy at game 2, turn 17 of seed 9102026.
Raw move scores and ranking order agreed. EBON was -2.38 in the original versus
-2.41 in the reconstruction; OBE was -8.97 versus -9.00.

The position and all preceding searches are in
`original-magpie-games-v2.positions.jsonl.gz`. The final record preserves the
failure rather than silently replacing it with a corrected result. A second
normal original Kibitz invocation produced the identical ranking. Its detailed
stage trace is `magpie-ebon-late-live.json.gz`.

## Cause 1: inherited scorer cursor

CODE36+059c reads four bytes through A2 before assigning its own cached reply
pointer to A2. CODE37's scorer supplies the inherited register value. Ordinary
scoring leaves A2 just beyond the word, but blank arbitration has several paths
that stop earlier. The reconstruction had modeled only the ordinary path.

`magpie-ebon-fastpath-live.json` is a direct debugger witness for RETREAD:

- Expected-by-old-port board-relative cursor: 220.
- Actual original A2 cursor: 218, after the last newly placed E.
- Four inherited bytes: original `00000000`, old prediction `00006570`.
- Original execution reached CODE36+061a, confirming the duplicate skip.

The original multiplicity trace contains 2,180 baseline calls; the old native
sequence contains 2,191. Aligned calls agree on their multiplicity results. The
extra native calls arise from missed duplicate skips, not a different binomial
formula or leave valuation. RETREAD is the first extra call.

`late_search.c` now reconstructs the scorer's cursor for each blank path:
CODE37+10ce, +1198 and +12f6 stop after the last relevant new tile; +126a stops on
the first relevant new tile for two identical blanks with no matching real tile.
The other paths retain the end-of-word cursor. This is an integer offset into the
emulated original board/value layout, not an unsafe host pointer read.

## Cause 2: empty-square initialization

The owned portable initializer assigned `letter_values[0]` to empty squares.
That recovered lookup entry is -10000 (bits 55536), whereas original CODE20+004e
clears the value buffer and leaves unoccupied squares zero. Ordinary scoring
ignores these cells, but the inherited pointer read can reach them when the
candidate is near the end of the mirrored board.

`portable_engine.c` now assigns zero to empty squares explicitly. Substituting
original value-buffer bytes alone did not fix EBON; the cursor correction alone
fixed its final ranking but left four other baseline multiplicities different.
Both corrections are needed to reproduce the full baseline pool:

| Reply slot | Old weight | Corrected / original |
|---|---:|---:|
| 1 | 1823 | 1805 |
| 6 | 85 | 81 |
| 13 | 103 | 101 |
| 22 | 3184 | 3152 |
| 26 | 80 | 64 |

The final controlled replay uses the public initializer and position only, with
no captured table, scratch, flag, or value-buffer injection. All 90 baseline
multiplicities and all 340 final ranking bytes match. See
`ebon-fix-analysis.json`, `ebon-controlled-before.jsonl.gz`, and
`ebon-controlled-after.jsonl.gz`.

## Regression and continuation

The existing native portable-late replay passes the new capture for three
repeated searches. The wasm portable replay accepts `--late` for this capture,
and both tests are included in the broad verification script. Consult
`portable-verification-ebon-fix.json` for the completed verification result;
an interrupted earlier run is not a pass.

The offline game-sequence replay matches all 42 records in v2 and all 45 records
captured in v3 after both fixes. v3 stopped on a QMP handshake race, not a ranking
disagreement. QMP now skips asynchronous events before requiring the actual
connection greeting, and GDB reads drain unsolicited stop notifications before
accepting the requested memory/register response. A real ROM read was rechecked
after that helper change.

`original-magpie-games-v7.json` and `original-magpie-games-v8.json` are continuation batches; read their completion
fields before claiming all games passed. See `MAGPIE-GAME-COMPARISON.md` for
vehicle limits and replay commands.

## Implications for future modifications and ports

Preserve this implicit register dependency explicitly if original behavior is
the goal. Recompiling a superficially similar C pointer expression with a modern
compiler will not reproduce it reliably. The observed instructions are consistent
with an uninitialized local pointer, but that source-level interpretation remains
an inference; the original A2 reads and branches are directly verified.

A modernized engine could remove this accidental duplicate-filter dependency,
but that would be a deliberate behavior change, not a more faithful decompilation.
Keep the exact compatibility behavior and any corrected policy distinct.

## Separate fixture limitation

An experiment appending synthetic zero-tile history records to a starting
snapshot caused original Maven error 12 on two attempts. Those records were not
validated as authentic original pass records; this is not evidence that ordinary
passes crash Maven. The batch does not use them. The raw experimental file is
retained locally as `analysis/toolchain/unverified-pass-history.bin`. Both compared searches
use the counter observed after ordinary snapshot import, while the match host
tracks its own termination counter. Native lifecycle equivalence is not claimed
by this batch.
