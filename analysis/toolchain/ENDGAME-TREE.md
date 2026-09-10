# Endgame tree recovery checkpoint

Current evidence update (20:49UTC): seventeen complete original searches match
native and wasm, spanning0..251 iterations. GC now has direct three-stage
capture acceptance: all8192 nodes match after pruning/marking and sweeping/
unmarking, with7057 reclaimed and1135 reachable. Blank-rack and root-no-move
fixtures also match. The549-iteration repeated-collection search FAILS complete replay beginning
at iteration403; its three individual GC operations match. It remains a known
failure and is not included among the17 accepted whole searches.
Original leaf entries target pass nodes four times in deep7 and20 in gc7.
Deep7 contains shared child lists from iteration147; all those states are in
the accepted complete replays. Historical notes retain their original scope.
Sources:
`endgame_tree.[ch]`, corrected CODE30 and CODE53 disassembly. The original
solver uses32-byte nodes linked by signed16 indices in a bounded pool, root0,
and child/sibling index0 as null. Native fields preserve the layout concept
without interpreting host-endian structs as raw guest memory.

Node lower/upper are bounds for the opponent continuation after this move.
Its parent's lower bound is max(move_score-child.upper), upper is
max(move_score-child.lower). Child selection maximizes the latter possibility,
retaining the first linked child on ties. A pass node excludes another pass
from selected continuation. New children prepend to the linked list.

Pool exhaustion invokes bound-based pruning, marks reachable nodes, sweeps
unreachable nodes into the free list, then clears marks. Shared child lists
implement transpositions; recursion marks prevent repeated bounds traversal.
The active frontier is protected during pruning. Exact solved child nodes
can discard their own descendants. These details affect search ordering and
resource-limit behavior, so replacing them with generic alpha-beta would be
a behavioral port, not an exact reconstruction.

Compact nodes store only newly placed letters, a kept-rack mask, coordinates,
score, emptied-rack flag and two low-byte evaluation tags. Expanding a node
merges letters through occupied board cells and restores score scale*100.
CODE30+666/+6d0 temporarily divide/multiply board/letter/bingo values by100;
full endgame integration must account for that different score unit.

Position hashes use a lazily seeded16-word table and, for each signed byte,
`h=(h>>4)+table[h&15]+byte` modulo2^32. Search combines the first272 board
bytes with rack hashes, weighting the second rack by2; zero becomes1. Hash
matches reuse child lists/bounds subject to solved/expanded-node checks and
a two-consecutive-pass lookup limit. No collision-proof board comparison
has been observed in this routine; do not invent one for compatibility mode.

Host sanitizer tests cover negamax bounds, pruning ties, allocation exhaustion,
pass construction, compact/full record conversion, transposition result
conditions and signed-byte hashing. Runtime checks of these exact routines
and complete CODE30/45/27/29/40 orchestration remain outstanding.

## Original runtime acceptance at15:52UTC

The original empty-bag fixture now exists as `maven-search-end6` in the session
share, reached by playing original suggestions from OPAQUER through RUBRIC,
with Maven replying EN. Its original Kibitz search ranks NEAT C2 first.
Two CODE30 traces validate192 completed tree operations against all8192 nodes
and free-list links. They include insertion/expansion, recursive bounds,
branch selection, allocation and prepending. GC/pruning runtime coverage is
still absent. Frontier switching and stopping rules are now readable helpers
but only host tested. Full solver orchestration remains incomplete.

CODE27 reply-bound traversal and CODE43 conflict queries match176 calls;
32 of those include54 reconstructed CODE39 mask calculations. Prepared matrix
inputs and nine-word tables are explicit boundaries in these comparisons.
CODE39 own/paired arithmetic is recovered;32 standalone paired calls match.
Depth-table preparation matches4 natural calls from adjusted score inputs,
and2 further calls include CODE43 score preprocessing. Six calls converge in
four to six depths. Original blank score-preprocessing branch not yet covered.

## Connected search acceptance (2026-09-09)

CODE30/45/29/40/37/43 orchestration now runs as readable C and freestanding
wasm. Twelve earlier complete captures cover2..32 iterations; endgame-seven
adds an exact one-iteration solution with both racks initially seven tiles.
Native compares all8192 nodes and workspaces at every recorded iteration;
wasm compares full final nodes/state/ranking with the observed clock stream.
The endgame-enabled rollout verifies20 solver calls,249 clocks and90 board/
rack/scorer boundaries in one batch. A shared selected-record alias retains
bytes after NUL from the last leaf best-empty record before final ranking.

Current search coverage still excludes a directly accepted pool collection,
root no-move return and endgame-specific blank paths. Native host tests of
those branches must not be described as original runtime acceptance.
