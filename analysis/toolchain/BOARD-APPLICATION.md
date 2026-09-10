# Move application and board representation

CODE 31+0x184 is called by tag-2 history restoration with evaluation flag zero.
That skips metric preparation [0x1a6,0x266) and the later evaluation branch
[0x534,0x63a), but retains actual board/rack modification.

The 544-byte board at A5-0x4302 is addressed as 32 rows of 17 bytes. The
coordinate helper [0x78,0xb2) maps (row,column) to (column+15,row) when signed
row<16; otherwise to (column,row-15). Thus ordinary cells at rows/columns
1..15 have a second orientation in rows 16..30. The helper is now board_state.c.
Signed 16-bit arithmetic is retained for out-of-normal-range arguments.

Normal placement [0x2aa,0x4f6) checks both orientations for conflicting letters,
consumes either the letter count or a blank, writes the letter to both board
locations, and writes a word from the character-value table at A5-0x6bee to
both corresponding auxiliary locations. This identifies the earlier 0x440-byte
auxiliary array as a parallel 32x17 array of 16-bit values, though all uses
and their score scaling remain to be reconstructed. The routine records newly
placed columns in a 33-byte undo workspace at A5-0xaca, terminating the list
with 0xff before copying rack text behind it. Undo at +0x642 uses that list.

Row-zero records take another branch: increment word A5-0x4c0e, subtract
letter counts for the payload string, and copy that string into board row zero.
Normal placements clear the counter. Do not yet equate every row-zero record
with a pass: a nonempty string may represent a tile exchange.

## Occupancy and terminal predicate

CODE 31 [0xde,0x108) counts nonzero bytes in board offsets [17,272), exactly
255 byte positions. This includes border columns; it is not a loop over only
225 playable cells. Wrappers at +0x108 and +0x118 test <=79 and >=86.

The apparent game-end predicate [0xb2,0xde) returns one if either rack is
empty, the row-zero counter equals six, or that counter equals two and the
count above exceeds 79. Otherwise it returns zero. Equality is exact (seven
does not satisfy the six test). The name describes inferred purpose; the
branch conditions are directly decoded. A natural game-end trace is pending.

Host tests cover all 255 occupancy counts, scan endpoints, both orientations,
word wrap, both empty-rack cases, and exact counter values. They do not prove
that complete move application, scoring, or the game's ending flow is correct.

## Rack counts and captured move

The saved 52-byte tag-2 payload contains the C string `aortae`, coordinate
bytes 8/7 at +0x20/+0x21, selector word zero at +0x22, racks `oriaate` and
`aceekoq` at +0x24/+0x2c, and the long 1400 at +0x10. These observed values
give a concrete replay input; they do not alone verify all payload fields.

Rack counts at A5-0x5ab2 are byte-sized, unlike Word List's separate 16-bit
counts. CODE31 [0x992,0x9d2) clears entries named in the alphabet at A5-0x662e
then increments each rack byte's count modulo 256. Other entries are untouched.
CODE31 [0x71e,0x75c) emits each alphabet character count times, treating the
count as signed; values 128..255 emit nothing. Both are now rack_counts.c.
The stored RAM snapshot's alphabet is `?abcdefghijklmnopqrstuvwxyz`, with
snapshot hash and pointer provenance in rack-alphabet-snapshot.json. This is
snapshot evidence, not a fresh live invocation of either helper.

## Reconstructed placement loop

place_letters.c now covers CODE31 [0x2f0,0x456). It computes the second
orientation, checks both cells, consumes a rack letter or blank only for
new cells, writes both copies and their value words, and appends new columns
to the undo workspace starting at byte one. If the premium code at a new
primary cell equals three, it returns the signed word at move+18 as a special
score value used by later evaluation code. Its exact evaluation role remains
outside this loop's reconstruction.

Host tests run the captured `aortae` record through the loop using synthetic
letter-value/premium tables: six new letters occupy row8/columns7..12 and
the corresponding second-orientation cells; the residual rack is `i`. The
tests also verify an existing letter consumes nothing and a missing new
letter consumes a blank. These tests do not establish original post-move
value-table contents or complete scoring. Natural restore-state comparison
is still needed.

The function explicitly excludes scoring/helper calls before the loop,
row-zero handling, boundary-value cleanup after it, undo termination/rack
suffix, rack rebuilding, and evaluation metrics. Those dependencies must be
connected before calling this a complete move application.

## Undo workspace consumer

undo_move.c reconstructs CODE31 [0x642,0x71e). For nonzero workspace row it
walks positive signed-byte columns until a nonpositive marker, clearing each
letter and word value in both orientations. It restores the rack string
following that marker. It does not rebuild the byte-count table, scores, or
history globals; callers own those steps.

For row zero it expects marker 0xff, checks that a nonempty board row-zero
string is accompanied by a seven-character saved rack, decrements the row-zero
counter with 16-bit wrap, clears the first 17 board bytes, and copies the saved
rack. Failed checks call diagnostics and may continue. Tests assert exact
cleared cells, preservation of all other cells/values, rack restore, counter
wrap, and returning diagnostics. Natural undo execution remains pending.

## Natural saved-game restore, 2026-09-09 10:22 UTC

`capture_game_restore.py` observed normal Open of `maven-re-0905`, returning
1 from CODE22+0x2cc. The recorder verifies complete loaded CODE22, CODE7,
and CODE31 against extracted resources and performs the ROM/register handshake.
No game memory or arguments were injected. `game-restore-live.json` retains
post-reader-return state; the owned disposable QEMU session exited cleanly.

`replay_game_placement.py` uses the saved tag-2 payload and captured live
letter-value table, beginning with the zero board prescribed by tag 1.
The placement C matches all 544 board bytes, all 544 host value words and
seven undo-prefix bytes. AORTAE occupies primary cells 143..148 and paired
cells 382,399,416,433,450,467; each has value 100. Synthetic premium codes
mean the special-score result is deliberately not compared. This establishes
one natural placement case, not whole-function or whole-game equivalence.

Post-reader state is rack0 `aceekoq`, rack1 `ilibdps`, totals 0/1400,
selected-rack offset -0x3c9a, and row-zero counter 0. Placement alone leaves
`i`. Counts at reader return describe rack0, not that placement residual.
The reader/history sequence includes further rack refill/count refresh;
those operations remain to be reconstructed. Undo begins
`08 07 08 09 0a 0b 0c ff 6f 72 69 61 61 74 65 00`, preserving pre-move
`oriaate` after the marker. The evidence therefore constrains subsequent
integration without silently treating post-reader racks as placement output.

## Finalization and bag reconstruction, 10:26–10:34 UTC

move_finalize.c reconstructs CODE31 [0x456,0x4f6) boundary-value clearing and
[0x4f6,0x52a) undo/rack finalization. The former clears the two coordinates
at A5-0x430a/-0x4306 and A5-0x430c/-0x4308, then their paired coordinates
in reverse order. Sentinel tests cover both orientations; actual boundary
arguments still need a natural trace. The latter writes 0xff at undo_end,
diagnoses unsigned strlen(rack)+signed undo_end >=31, copies the original
rack behind that marker, then rebuilds rack from counts. The placement replay
now matches the ENTIRE 33-byte natural undo workspace, superseding the earlier
prefix-only comparison. It still does not reproduce complete restoration.

Following the tag-2 refresh wrapper identifies CODE31+0x7e0 as rack refill.
Its bag builder [0x8be,0x992) is now remaining_tiles.c. It copies 128 byte
counts from A5-0x6aee, subtracts the 16x16 primary region (rows0..15,
columns0..15), subtracts rack1 then rack0, and emits positive signed counts
in alphabet order. An occupied cell with value zero subtracts '?' except
in row zero, which always subtracts the literal character. This resolves
one important consumer of the board value array's blank distinction.
No natural bag-builder invocation is claimed yet.

The refill caller [0x7e0,0x8be) has additional time/random dependencies:
A5+0x69a writes a time word/long; A5+0x5b2 and +0x6e2 feed arithmetic through
+0x52. It shuffles while time is unchanged, then draws by swapping selected
bag entries with the shrinking last entry, adds 211 to a local each draw,
and clears board row zero afterward. Exact helpers and arithmetic require
mapping. The local at frame-0x84 is initialized only on the branch where
bag size is greater than 8-rack_length, but is read in the draw loop even
when that branch is skipped. Do not silently supply zero or a modern seed:
confirm this apparent uninitialized-local behavior in a small-bag trace.

Jump-table follow-up: +0x69a → CODE9+0x76, +0x5b2 → CODE4+4,
+0x6e2 → CODE9+0x6e, +0x52 → CODE1+0x144. CODE4+4 updates
A5-0xdc4 by `(old >> 1) + ((((old >> 4) ^ old) & 1) ? 0x40000000 : 0)`
with unsigned 32-bit arithmetic; +0x30 assigns the seed. CODE9+0x6e wraps
trap 0xa861 and returns its word; the caller sign-extends it. CODE1+0x144
returns the remainder from unsigned division helper +0x1d6. These are static
findings to use for the next refill reconstruction, not natural RNG traces.

## Refill reconstruction

rack_refill.c reconstructs CODE4 [4,0x30) private generator and CODE31
[0x7f4,0x8b4) refill after bag creation. Clock wrapper CODE9+0x76 reads the
32-bit low-memory value at 0x16a. The code preserves private-random then
signed Toolbox-random call order, unsigned 32-bit sums/remainders, one or
more swaps until the clock changes, draw-time +211, and row-zero clearing.
The small-bag path accepts an explicit initial_stack_ticks value to model
the uninitialized frame bytes without invoking C undefined behavior.
Callbacks make clock/Toolbox effects observable and replaceable for ports.
Host tests cover the exact threshold, negative random words, swap order,
row clearing, no random calls for empty bags, and generator boundary seeds.
Natural trace recorder capture_rack_refill.py is prepared; any timing trace
must acknowledge that breakpoint pauses influence the shuffle iteration count.

## Natural refill validation, 10:41 UTC

`rack-refill-live.json` captures the first refill during normal Open of
`maven-re-0905`. Full loaded CODE31/4/9/1 resources matched original bytes.
The recorder performs ROM/register checks and never changes game arguments,
state, or random/clock returns; breakpoints necessarily alter elapsed timing.

`replay_rack_refill.py` reconstructs the initial bag from actual distribution,
board, values, both racks and alphabet: all 86 bytes match. It then consumes
all 16 clock/private-random/Toolbox-random events in their original order.
The C private generator matches every captured private return and final seed.
Refill matches the full bag workspace, full 544-byte board and final rack
`idigngx`. This differs from the earlier restore's `ilibdps`, demonstrating
that save reopening does not preserve a single next-rack outcome under these
runs. The external time/random inputs are retained so this trace replays
exactly without claiming that uninstrumented timing would match.

Only the normal clock-initializing branch was observed. Small-bag stack
contents, blank placements, and all remaining application behavior still
require dedicated natural traces. QEMU session57300 and recorder91278 exited0.

## First scoring phase and coordinate correction, 10:46 UTC

A5+0x98a maps to CODE32+4. score_accumulate.c reconstructs [0x32,0x352):
rack counts, new-tile count, multiplied main-word score, cross-word sums,
existing value contributions, seven-tile bonus 5000, and initial missing
letter/blank bookkeeping. It explicitly stops BEFORE the later blank-value
optimization; its returned score_bits is not the final CODE32 return value.
Word multiplier products are checked against {1,2,3,4,9,27}. New letter
value times letter multiplier is sign-extended from its LOW WORD, including
in cross scoring; 32-bit sums/products wrap. Host tests cover this detail,
main/cross scores, bingo, missing letters, and existing zero-value cells.
Input contract requires valid ASCII alphabet/rack membership and <=2 missing
letters; the original only clears alphabet slots in its stack count array.
No natural invocation of this phase has been captured yet.

CORRECTION: earlier “boundary-value” interpretation is superseded. CODE32
[0x2d4,0x2e8) stores the most recent two EXISTING ZERO-VALUE tile coordinates
in A5-0x430a/-0x4306 and -0x430c/-0x4308. Later blank optimization can also
write these fields and remains undecoded. The clear helper is now named
maven_clear_recorded_move_values; its exact clearing behavior is unchanged.
Do not describe these coordinates as word boundaries or generic cache
invalidation. Their role is tied to blank/zero-value scoring state.

The synthetic AORTAE test uses only a double-word square and yields 1200;
this is intentionally not the captured original 1400 score. Real premium
arrays and the remaining scoring phases must be captured/reconstructed before
asserting complete natural scoring equivalence.

The tail CODE32 [0x60e,0x648) emits the remaining positive signed-word rack
counts in alphabet order to the third pointer argument, terminates it with
NUL, and returns accumulated score. If no blank was consumed, +0x352 branches
directly there. Row-zero early return bypasses the tail. This gives a bounded
route to a complete no-new-blank scoring path once counts are retained by
the scan API; do not yet claim that path is integrated.

## Complete valid-input scorer reconstruction

score_move.c now combines CODE32 [4,0x32) early handling, the shared score
accumulator, and [0x352,0x650) blank assignment/rack output. This covers the
routine's valid-input logic but is not a claim that every branch is runtime
verified. At most two missing letters and valid ASCII rack/alphabet membership
are explicit contracts; the original uses uninitialized stack slots outside
its alphabet and a two-byte missing-letter area.

For one missing letter, scan every matching NEW cell and choose the first
strict minimum of letter-multiplier times (main-word multiplier plus this
cell's word multiplier if a cross word exists). Store its coordinate in the
second slot. For two different letters, minimize independently; for two equal
letters, preserve the first two minima in order. Subtract each chosen cost
times that letter's signed word value from the score. A negative result calls
the returning diagnostic. Existing blank coordinates survive unless replaced
by these new assignments. These coordinates are later zeroed by placement
finalization, explaining the earlier clear helper without a cache hypothesis.

The tail emits remaining positive signed counts in alphabet order. The
row-zero shortcut returns zero and resets score globals without writing the
remaining-rack output. Tests cover that preserved output, repeated-letter
minimum choice/ties, cross-word cost, distinct two blanks, and rack leftovers.

## Natural score validation, 11:02 UTC

capture_move_score.py observed CODE32+4 called during ordinary Open of
maven-re-0905. Full loaded CODE32 bytes match; ROM/register handshake passed.
The capture includes the 34-byte move, rack, entire board/value arrays,
actual letter values/classification, alphabet and both premium arrays.
replay_move_score.py compiles the full scorer C and matches score1400,
new_tiles6, remaining rack `i`, and all four recorded coordinate words (zero).
It compares rack text through the NUL only; the other captured output-buffer
bytes are preexisting stack contents, not output semantics.

This confirms the full no-new-blank path for AORTAE. Blank choice, bingo,
crossword and row-zero branches retain host-only verification. Capture does
not establish full-application equivalence. Owned VM8707 and capture65676
exited0; an initial attach attempted before the socket existed, then the
same owned VM completed the handshake on retry. No orphan VM was launched.

## Integrated non-evaluation application, 11:06 UTC

apply_move.c now composes CODE31's evaluation-flag-zero path from the scorer,
placement, recorded-value clear, and rack finalizer. It initializes undo row,
counts occupancy, handles row-zero decrementing tile counts/copying exchange
text/incrementing the word counter, or clears that counter for a normal move.
The normal prelude copies 34 move bytes, computes score, writes BE32 score at
copy+16 and passes that copy to the optional A5-0x4c12 callback. Placement
still uses the original move. Scorer coordinates/new-tile count are retained
in explicit state; the callback can access that state through its user object.
The original caller assumes valid coordinates, rack/counts and buffer sizes.

replay_apply_move.py now checks the COMBINED C path against natural score
inputs and a separate restored-state capture for the same AORTAE move.
All544 board bytes, all544 value words, all33 undo bytes, residual rack i,
six new tiles and zero row counter agree. This is stronger integration
coverage than replaying components separately, but is not a single direct
entry/exit trace of CODE31+0x184. Refill, history and player totals are excluded.
Host tests additionally cover blank placement in both orientations, callback
copy isolation, and row-zero counter wrap. Natural blank/undo cases remain
valuable next validation targets; evaluation-flag-one branches are unimplemented.

## Natural undo validation, 11:20 UTC

capture_move_undo.py armed A5+0x94a → CODE31+0x642, verified the entire loaded
CODE31 resource plus ROM/register handshake, and observed the first invocation
after normal New Game. No input/state injection occurred. It captured both
sides of the actual helper call. This is engine move-search undo, not a claim
about the user-facing Undo/history sequence.

Undo row8/columns3..8 restored rack `nitedaa` from residual `a`. Portable C
matches every board byte, value word, rack byte (including preserved trailing
storage), undo byte and row counter. The original count table is unchanged,
confirming that callers must handle it separately. Evidence:
move-undo-live.json and move-undo-replay.json. Row-zero undo remains host-only.
Owned recorder54512 and VM56444 exited0; no owned emulator remains.

Board helpers [4,0x4c) and [0x4c,0x78) are additionally reconstructed in
board_state.c. The first counts empty primary cells beneath the move word
without checking matching letters. The second begins one cell left of its
supplied coordinate, scans backward over nonzero bytes, then returns the cell
after the zero sentinel. It does not first inspect the supplied cell. Host
tests cover these contracts; natural helper traces remain pending.

## Evaluation features, 11:26 UTC

The evaluation-flag-one path clears 88 bytes at A5-0x5bc0, a vector of22
longs. evaluation_features.c reconstructs preparation [0x1b4,0x266) and
completion [0x534,0x63a), with explicit external record collection and predicate.
These are raw feature assignments, not the final weighted evaluation.
Order (indices0..21): constant, early/middle/late/end score, bingo score/flag,
blank/Q/X/J/Z score, special score/flag, matched-record weight sum, pairs
except S, triples, many consonants/vowels, prior Q, prior blank, row-zero flag.
Stage thresholds use BEFORE-placement occupied count: <30,30..76,77..85,>=86.
Bingo requires empty scorer remainder, original rack length7 and signed score
>=5000. Rare-letter score slots change when that count differs after placement.

Preparation counts signed-byte letters a..z; >=3 occurrences count one triple
feature, exactly2 count a pair except s. Classification at A5+0x7d2 is
CODE23+4 membership in the C string at A5-0xbca; saved RAM contains `aeiou`
(vowel-alphabet-snapshot.json). This is snapshot evidence, not a natural call.
Six or more vowels set one flag; only otherwise are six or more consonants
checked. Signed counts can reduce totals; word arithmetic is retained.

A5+0x9e2 maps to CODE35+0x36c and produces parallel word ID/weight lists before
feature preparation; that collector remains external. A5+0x9f2 maps to
CODE35[0x34,0x64), now maven_evaluation_record_flag_clear: negative IDs match,
IDs >=signed record count do not, in-range IDs match iff byte6 of their
8-byte record is zero. Matching signed word weights accumulate modulo2^32.
Semantic record purpose remains unresolved.

IMPORTANT unresolved row-zero dependency: the evaluated row-zero branch
skips scoring but later calls strlen on the local scoring-output buffer at
frame-0x32. The reconstruction requires an explicit observed value for that
input; it does not invent an empty string. This path and all feature-vector
assignments still need natural evaluation traces before integration. Host
tests cover feature slots, thresholds, count signs, negative/out-of-range
record IDs and flag bytes. No VM was launched in this batch.

Collector follow-up: CODE35+0x36c first rebuilds the byte-count table from
the globally selected rack (A5-0x3c8a), then calls CODE31+0x75c. Therefore
evaluation feature preparation must use counts AFTER collection, which need
not be the counts present at CODE31 entry. The natural recorder now preserves
both snapshots and supplies the post-collector one to replay. Predicate
records are captured again after placement for the same reason: external
stages must not be assumed side-effect free. Collector's opening-board branch
can emit ID -32 and a weight from a 28-byte table indexed by word length;
its remaining scanning logic is still unreconstructed.

CODE31+0x75c is another distribution helper: copy128 distribution bytes,
subtract occupied board cells in linear offsets[17,272), using '?' for
zero-valued tiles; subtract the selected rack's count table alphabet entries;
clamp resulting negative signed bytes to zero; return their signed-word sum.
This differs from +0x8be, which accounts for both racks and emits a bag string.
The collector uses the former, not the reconstructed full-bag builder.

## Natural evaluation-vector validation, 11:55 UTC

Clean VM capture evaluation-features-live.json observes one evaluated
candidate after43 non-evaluated applications during the first New Game.
Full CODE31/23 resources, CODE35 collector[0x36c,end) and predicate[0x34,0x64),
and CODE32 scorer[4,0x650) match original bytes. Other CODE35/32 regions differ
at floating-trap call sites, recorded separately and not waived as matching.

C replay matches all22 feature longs, including early score2400, one pair,
and signed matched-weight sum -185 from seven collected records. Original
collector outputs and post-collector/post-placement states are explicit inputs.
This validates feature extraction for one real candidate, not collection,
weight fitting, full ranking, or every feature branch. Decoder predicates
and the original membership alphabet are used in replay. Owned capture81707
and clean VM24533 both exited0. No emulator remains.

Earlier attempts with later games/Kibitz produced only timeouts or rejected
identity checks, not accepted evaluation evidence. The successful trace
shows many flag-zero applications preceding a flag-one application; do not
infer that every candidate application requests feature extraction.

remaining_tiles.c also now implements +0x75c unseen counts. Host tests cover
primary scan boundaries, blank values, one-rack subtraction, negative-byte
clamp and untouched nonalphabet counts. It is not yet naturally replayed.

## Statistics consumer: correction to ranking hypothesis, 11:57 UTC

CORRECTION: the first verified consumer of the22-long vector is per-player
STATISTICS accumulation, not a weighted candidate-ranking calculation.
CODE11+0xf94 passes flag1 to CODE31+0x184 for the selected move; +0xfa4..0xfb0
adds the vector into A5-0x5b68 through A5+0x34a → CODE16+4. A parallel path
at +0x1068 uses A5-0x5b10. The earlier43 flag-zero calls followed by flag1
are consistent with search followed by committed-move statistics. The natural
capture still verifies the feature values; calling it a ranking/evaluation
vector was an unsupported semantic inference. Existing evaluation_features
API names are historical and should be read as feature/statistic extraction.

move_statistics.c reconstructs CODE16[4,0x2c) addition of22 longs and
[0x2c,0x14c) selective normalization. It copies the vector; adds half of
scale_count*100 to fields1..5 and7..12, then signed-divides those fields by
scale_count*100. Field14 instead adds half of field0 then divides by field0.
Other fields retain their copied values. Addition/multiplication wrap32 bits;
division truncates toward zero, so negative rounding is not symmetric.
Both divisors must be nonzero in the current valid-input contract. Exact
caller meaning of scale_count remains to be traced. Host tests cover field
selection, signed rounding, accumulation wrap and identical-source aliasing.

CODE35[4,0x34) record flag-set predicate is also reconstructed. It rejects
IDs<=0; flag-clear at +0x34 accepts negative IDs and can inspect ID0. These
functions are not logical complements. Tests retain the ID0 distinction.
