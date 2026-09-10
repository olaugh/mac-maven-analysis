# Original blank scoring and application, 2026-09-09

Three constructed saves derive from the naturally captured86-byte
`maven-re-0905` save. Each changes the initial/selected rack and stored move
score, retaining AORTAE at row8,column7. Exact changed offsets and hashes are
in the fixture JSON files. The original save remains unmodified. The copied
`.idump` metadata (`XGMEMAVN`, kHasBeenInited) makes each fixture visible in
Maven's ordinary Open dialog. These are valid-format experimental fixtures,
not claims that the games were naturally played.

| Rack | Original score | Recorded blank coordinates |
|---|---:|---|
| ori?ate |1200|(8,7)|
| ori??te |1000|(8,11),(8,7)|
| o?i?ate |1000|(8,7),(8,9)|

Scores above are raw internal integers. The captured letter-value table uses
100 for one-point letters; keep that scaling separate from displayed points.
The22-field statistics vector also contains unscaled counts, so it must not
be uniformly divided by100.

`capture_move_score.py --application-state` checks the ROM signature,
register layout, full loaded CODE32 and CODE31 resources, then observes the
score return and CODE31 application epilogue. No debugger memory writes or
argument substitution are used. These exercise one missing letter, two of
the same missing letter, and two different missing letters. Blank-square
selection order is retained rather than sorting the returned coordinates.

Native C and freestanding wasm both match scores, remaining rack, six new
tiles, recorded coordinates, all544 board bytes,544 value words,33 undo
bytes,128 rack-count bytes, and zero row-zero counter. The residual rack is
`i`. C-string output checks stop at NUL rather than comparing unrelated
original stack bytes afterward. Refill/history/player totals are outside
this captured application boundary.

Scripts and reports: `blank-move-score-live.json`,
`two-blank-same-live.json`, `two-blank-different-live.json`, their fixture and
replay JSONs, `replay_move_score.py`, `replay_apply_move.py --capture`, and
`replay_wasm_board.mjs <capture-name-without-json>`.

These traces do not establish cross-word blank scoring, existing blanks,
bingo scoring, malformed inputs, every premium configuration, or every tie.
