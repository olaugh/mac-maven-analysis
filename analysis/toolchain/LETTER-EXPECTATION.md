# Exact-integer port of the SANE letter expectation

`letter_expectation.c` reconstructs the successful numerical behavior of
CODE32[0x140a,0x164c). The original lazily allocates8,080 bytes for a101x8
Pascal triangle of10-byte extended values. It initializes C(n,0)=1 and
C(0,k>0)=0, then fills C(n,k)=C(n-1,k)+C(n-1,k-1). The selected letter's
coefficient table is indexed0 for`?`,1..26 for`a`..`z`.

For total N>=7, letter count K, and D=min(N-7,6), it computes:

```
w[i] = choose(K,i) * choose(N-K,D-i)
delta[i] = signed32(score[i+1] - score[0])
result = truncate_toward_zero(sum(w[i]*delta[i]) / sum(w[i]))
```

The loop uses0<=i<=min(K,D). For N<7 it returns0 before table use. Scores
are BE32 bits at+24 in28-byte records. Subtraction wraps at32 bits before
conversion to extended precision.

Recovered THINK6 `SANE.h` identifies operation0x0000 as FADDX,0x0004 as
FMULX,0x2804 as FMULL,0x0006 as FDIVX, and0x0016 as FTINTX. The last one
is truncation; FRINTX is0x0014 and is not used here. Conversion0x2810
then stores the integral extended result as a long. This resolves the
rounding direction from recovered primary headers, rather than inferring it
from an average or a few observed values.

## Numerical domain and portability

The integer port requires7<=N<=100 and0<=K<=N. D<=6, so the sum of weights
is C(N,D)<=C(100,6)=1,192,052,400. Every wrapped signed32 delta has magnitude
at most2^31. Thus the sum of absolute weighted terms is less than2^62,
within signed64 arithmetic and the64-bit significand of original extended
precision. Integer Pascal-triangle construction and multiplication/addition
are exact in that precision. A nonintegral quotient is at least1/C(N,D)
from an integer, greater than extended-precision rounding error at this
result magnitude, so final truncation agrees with exact rational division.

This is a mathematical portability replacement, not an emulation of SANE
allocation, exception flags, or every precision mode. Reduced SANE precision,
invalid counts, corrupted tables, allocation failure, and NaN behavior are
outside the contract.300 deterministic randomized host cases compare against
Python's independent math.comb calculation, including signed score wrap and
negative truncation; the C test runs with undefined-behavior sanitizer.

## Original runtime comparison

24 natural calls, including actual-pool and96-tile baseline inputs, match
the integer C outputs. They also match the same C compiled into freestanding
wasm. The executed range matched the exact earlier captured floating-trap
rewrite fingerprint (and ROM/register identity), not arbitrary ignored byte
differences. That identity limitation is preserved in the capture. The
runtime dispatcher rewriting itself remains separate reverse-engineering work.

`letter-expectation-live.json`, `letter-expectation-replay.json`, and
`wasm-rack-math-replay.json` preserve the inputs/results/hashes.
Build `sh scripts/build_wasm_rack_math.sh`; run
`node scripts/replay_wasm_rack_math.mjs`. The wasm module has no imports and
also matches the two original integer rack-composition captures. Its eight
score slots are caller-supplied decoded integers, not native or guest pointers.
