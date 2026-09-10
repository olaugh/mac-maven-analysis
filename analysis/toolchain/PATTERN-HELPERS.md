# Pattern cache and mask updates

pattern_lookup.c reconstructs CODE32[0x1872,0x18e4), after the cache has been
built and sorted. Original entries are10 bytes: pointer to sorted-letter C
string, mutable long accumulator, and signed word table index. The portable
struct represents those fields natively and is not a guest-memory overlay.
Binary search clears the output accumulator pointer first. A match returns
the signed BE word at score_table+28*index+26 and a pointer to that entry's
accumulator. A zero score can be a match; callers must inspect the pointer
if that distinction matters. Cache construction remains unreconstructed.
Current contract requires unique sorted ASCII strings, count<=16384 and valid
nonnegative table indices, avoiding original word-index overflow conditions.

mask_supersets.c reconstructs CODE32[0x18e4,0x1944). Stamp array at A5-0x4e20
contains128 longs; word values begin A5-0x440c. If stamp[mask] differs from
generation A5-0x4e24, store the generation, add the signed delta modulo16 bits,
and recursively visit mask OR each of seven word masks from A5-0x662a+4*i+2.
Equal stamps suppress the entire visit, even the initial one. Duplicate or
zero masks terminate because stamping precedes recursion. Tests compare all
128 superset memberships and verify generation reuse, wrap and duplicates.
The caller's semantic meaning of masks/accumulators still needs tracing.

These helper tests are host-only. Neither helper is claimed naturally traced
in this batch. Their original pointer, flag and table contracts are retained
separately from any future safe external-input interface.

## Cache construction recovered at 13:02 UTC

`pattern_cache.c` reconstructs CODE32[0x16c0,0x1872). The lazy constructor
ignores record0, selects records whose signed word+4 is nonzero and byte+6
is zero, and borrows strings using signed word+2 offsets from the string
base. It diagnoses descending adjacent letters, zeros each accumulator,
and retains word+4 as the score-table index. Shell-sort gaps are generated
by3*h+1, then divided by3 each pass. A final strict-order check diagnoses
duplicates as well as disorder. Existing non-NULL cache storage suppresses
reconstruction and preserves mutable accumulators.

The native adapter allocates native structs rather than10-byte Mac pointer
records. Valid input requires nonempty ASCII strings, valid borrowed storage,
successful allocation, initial count0, and at most9841 selected records for
the documented gap-arithmetic domain. This is not a general untrusted parser.
Host tests cover filtering, index/string association, ordering, diagnostics,
zeroing, lazy reuse, duplicate strings, and the zero-entry case. Runtime
construction has not yet been captured; binary lookup remains separately
reconstructed. The original routine falls through into lookup at0x1872.

## Runtime construction and lookup validation, 13:13–13:15 UTC

This supersedes the earlier host-only status for construction and lookup.
In a fresh session, original construction selected125 entries from2263
records. Native C matches every borrowed string offset, accumulator, and
score-table index. A subsequent64 natural lookups match every signed score
and returned mutable-entry identity:28 hits,36 misses. No zero-score hit was
observed in this trace; that distinction remains covered by host tests.
Exact CODE32[0x16c0,0x18e4) and ROM/register identity were checked. Neither
capture writes arguments or game memory. Mask recursion remains host-only.
