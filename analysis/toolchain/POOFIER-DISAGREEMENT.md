# POOFIER — corrected diagnosis: comparison lifecycle mismatch

**CORRECTION (2026-09-10): the earlier claim of a reconstructed scoring bug was
wrong.** Both implementations give 28 on a fresh application state and 14 after
the same preceding search sequence. The v8 match batch created a fresh C engine
while continuing the original Mac process from v7. Opening a snapshot preserves
original query/control storage, so the two search lifetimes were different.

The original shared crossing-query buffer begins at A5-6f2; its upper half
aliases row controls at A5-6d2. At the warm POOFIER entry, buffer byte 34 (row 2)
is 0x77, `w`. CODE37+086c tests that byte and selects a main-word multiplier
table filled with ones. In the fresh original process it is zero; the POOFIER
scorer reads multiplier 2. This is retained initialized query output affecting
scoring, not an uninitialized heap/stack read. Its compatibility behavior was
already modeled in the reconstruction.

## Distinguishing evidence

- `poofier-search-live.json`: original warm search, 690 callbacks, POOFIER score
  14. The v8 and repeat captures have exactly the same ranking.
- `poofier-multiplier-live.json`: fresh original CODE37 row/scorer witness,
  verified resource bytes, row control zero and D5 multiplier 2 at +0f6c.
- `poofier-cold-search-live.json`: original fresh-session search, POOFIER score
  28. Native and wasm portable replay match every callback and final ranking.
- `poofier-continuous-diagnostic.positions.jsonl.gz`: concatenates the original
  v7 and v8 captured search sequence. The normal strict replay retains one C
  engine for the whole sequence. After the separate VID scratch clear fix,
  **all 277 positions / 2,722 ranked records match byte-for-byte**, including
  the warm 14-point POOFIER. No captured query buffer or other hidden state is
  injected. The file's historical “diagnostic” name does not imply relaxed tests.
- `original-magpie-fresh-guard.json`: new fresh-process game with the corrected
  lifecycle guard; all 22 positions match.

## Harness fix

The match adapter derives the initial query/control buffer from the recovered
resource initializer. Before creating a new search sequence, the live harness
requires original Maven's buffer to match that baseline. It rejects a warm
process with an explicit restart/continuation explanation. It does not copy the
original buffer into the reconstruction or reset it silently. A normal original
application restart passed the guard; the preceding warm process was rejected.
The check catches the demonstrated mismatch; it is not a universal attestation
that all possible hidden globals match.

```sh
python3 scripts/replay_portable_engine.py --capture analysis/toolchain/poofier-cold-search-live.json
python3 scripts/replay_original_magpie_matches.py --build analysis/toolchain/poofier-continuous-diagnostic.positions.jsonl.gz
```

The old warm single-position replay is expected to differ when initialized cold.
It is a negative control for the lifetime mismatch, not a remaining scoring bug.
The original failing reports are retained, without changing expected rankings.
