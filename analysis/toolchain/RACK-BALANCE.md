# Rack composition adjustment

CODE35 collector call A5+0x9ca maps to CODE32+0xcc4, reconstructed in
rack_balance.c together with the base wrapper CODE32+0xc00. Parameters are
held vowels, consonants, blanks, unseen-pool vowels/consonants and draws,
according to the collector's preceding membership/count calculations.
Underlying CODE32+0xdb0 remains an explicit computation callback.

## Base cache [0xc00,0xcc4)

Negative draws call the returning diagnostic. The signed-word sum of held
counts plus draws is clamped to seven by adjusting draws. No held letters
returns zero immediately, BEFORE cache-key invalidation. Otherwise changes
to either signed pool count clear256 bytes, an8x8 array of long results.
Index is consonants*8+vowels. A zero cell triggers two computations with the
same total tile count: held composition and empty composition; their wrapped
32-bit difference is stored. A zero result is recomputed on the next call.

The cache key omits draws/total tile count. The reconstruction preserves this
rather than introducing a more complete key. Whether all natural callers
maintain an invariant that makes the omission safe remains to be established.
The current API requires valid0..7 indices, including assignments made by
the blank wrapper; it does not emulate out-of-allocation stack/global access.

## Blank policy [0xcc4,0xdb0)

Two blanks evaluate (v,c+2), (v+1,c+1), (v+2,c) in that order and return the
signed maximum, keeping the earlier result on ties. One blank evaluates
(v,c+1), (v+1,c), adds with32-bit wrap and signed-divides by two. Any other
blank count, including negative or greater than two, takes the unchanged
(v,c) path. This is directly decoded behavior, not a generic Scrabble rule.

Host tests verify callback order/count, clamping, zero-result recomputation,
empty-rack early exit, key changes, omitted draws, and the differing blank
policies. No natural invocation of these wrappers has been captured yet.
The names describe inferred role from the collector; full ranking semantics
still require following the underlying computation and consumers.

## Underlying composition calculation [0xdb0,0xefa)

rack_composition.c now reconstructs the underlying8x8 recurrence. For total
N, terminal cell[c][N-c] comes from the BE32 value at table_by_total[N]+24+28*c.
Then levels descend from N-1 to held_vowels+held_consonants. For each reachable
consonant count c, available consonants are max(pool_c-c+held_c,0), available
vowels max(c+pool_v-level+held_v,0). If both are zero, each becomes one.
The next consonant/vowel cells are weighted by these counts; products and
sum wrap32 bits, then signed division truncates toward zero. The result is
cell[held_c][held_v]. Valid0<=held sum<=N<=7 is explicit; invalid original
indices can touch uninitialized/out-of-buffer stack storage.

Terminal values are caller-supplied decoded words in the portable interface;
original table acquisition/initialization remains separate. Host tests cover
known weighted expectations, equal-weight exhaustion fallback, negative
pool clamping, negative rounding, product overflow and integration with the
baseline-difference cache. A natural capture is being prepared separately.

## Live cache consistency, 12:38 UTC

Two direct-call capture attempts timed out without producing an accepted
composition invocation. They armed the wrapper/computation too late to catch
a cache miss during these paths. This timing explanation is plausible, not a
verified statement about every missed call. Recorder now resolves CODE32 at
its earlier scorer entry for a future fresh-session attempt.

A read-only live snapshot after search contains19 nonzero cache entries with
pool key(36,52), plus the actual seven-tile terminal table. All19 agree with
reconstructed total7 recurrence minus its empty-composition baseline, including
negative values. Evidence: composition-cache-live.json and
composition-cache-consistency.json, produced by check_composition_cache.py.
This is a consistency check with assumed total7: draws/total are absent from
the cache key and were not captured at each call. It is not equivalent to19
observed function entry/return traces. The algorithm remains host-tested with
indirect runtime support; direct natural invocation validation is outstanding.

## Direct natural validation, 12:47 UTC

Earlier-entry capture now succeeds. It arms every CODE32 jump-table entry,
resolves the first natural resource load/call, then breaks on +0xdb0 before
cache reuse. ROM/register handshake and exact[0xdb0,0xefa) bytes are verified;
no arguments, returns or game state are injected.

First call: held vowels5, consonants2, pool39/54, total7 returns -713. That
is the terminal-table case. The next direct call is held0/0 with the same
pool and total7, returning -49; this exercises all seven recurrence levels.
Both returns match reconstructed C using captured table values. Evidence:
rack-composition-live.json / rack-composition-replay.json and
rack-composition-baseline-live.json / rack-composition-baseline-replay.json.

This supersedes the earlier statement that direct invocation validation was
still pending, for these two paths only. Exhausted-pool/overflow branches
remain host-only; table initialization and blank-wrapper runtime behavior
remain separate. Owned captures29304/75688 and VM85124 exited0.
