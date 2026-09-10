# Opening move generation

CODE37[0x24e,0x36c) performs depth-first DAWG traversal, consuming a real tile
of the required letter when available and a blank only otherwise. At terminal
nodes it emits every horizontal row8 placement covering the center, in ascending
column order. A placement's initial +24 adjustment subtracts one for each vowel
beside a letter/word premium on neighboring row7 or9. Its vowel character set
comes from CODE23+4, observed as `aeiou`. Counts are restored after recursion.

`opening_placements.[ch]` recovers that traversal and opening section iteration.
`opening-generator-live.json` captures275 placements for rack`eiimosx`. The
entire ordered stream matches portable C, including section, word, coordinates,
pre-evaluation adjustment and all128 remaining-count bytes. Both dictionary
sections and the full1,070,788-byte dictionary allocation were byte-verified
against the source file while paused at entry. Final counts also match.

The original's next boundary, CODE37+e46, calls CODE15+198 with current section
index as its count. **This suppresses words already in earlier sections.** It
is not evidence of a separate exclusion lexicon or blacklist. The original
pre-evaluation placements can therefore include words that never reach the
candidate callback. Older shorthand “exclusion” refers to this duplicate test.

`opening_moves.[ch]` is the next integration under runtime verification. It
combines the recovered traversal, existing CODE15 dictionary lookup, verified
CODE32 general scorer, CODE32 occurrence-mask construction and CODE37 move
metadata. It uses an original precomputed leave table as input. This is a
semantic integration, not a claim that CODE37's optimized scorer and all its
transient registers/globals have been literally decompiled. Full callback
stream/preliminary-ranking comparison must pass before calling it verified.
Final CODE35 collector reranking and multi-ply search remain separate work.

## Port and modification boundary

All code is standard C with explicit integer types and native context pointers.
Dictionary nodes stay in original big-endian serialized form. The placement
callback can collect a list, stream into ranking or yield to a modern UI.
Changing blank policy, traversal order, duplicate suppression or tie ordering
can change chosen moves even when the legal move set is unchanged. Preserve
original mode and ordered replay fixtures when experimenting.

The crossing-letter helpers in `cross_check_letters.[ch]` recover
CODE37[0x36c,0x4da). They expose prefix/suffix separately instead of using an
embedded zero board cell to separate them. Section-order duplicate letters are
retained. Native synthetic tests pass; original occupied-board traces remain
to be captured. This is not yet a complete nonempty-board generator.

## Scored blank-containing runtime acceptance (14:49UTC)

`opening-scored-generator-live.json`:7,394 pre-evaluation placements for rack
?aeopru,4,381 post-evaluation callbacks and all ten preliminary ranking slots
match C byte for byte. The complete placement order/count restoration also
matches. This covers the composed scorer and metadata with a blank. The
original leave table AND initial exchange candidate seed are supplied inputs;
exchange generation, leave-table construction and final CODE35 reranking are
not established by this particular replay. The original seed's word bytes
retain stale text after its NUL, so raw-record comparisons preserve that data.

The recorder completed and saved its trace before cleanup reported E22 for
already-absent breakpoints. A fresh ROM/register handshake and explicit
insert/remove confirmation cleared all three owned addresses. The cleanup
helper now handles both unsolicited stop packets and QEMU's disconnect-time
breakpoint removal. No trace data or arguments were patched.
