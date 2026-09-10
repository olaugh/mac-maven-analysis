# Freestanding board/scoring WebAssembly milestone

Build from repository root:

```sh
sh scripts/build_wasm_board.sh
node scripts/replay_wasm_board.mjs
```

LLVM18 produces `.build/maven-board.wasm` with no imports and exported linear
memory. The bridge links the same reconstructed C used by native tests:
scorer, non-evaluation application, placement/finalization, rack counting,
board helpers and undo. Evidence is in `wasm-board-replay.json`.

Natural scoring inputs reproduce score1400, remaining rack i, six new tiles
and recorded coordinates. Combined application reproduces all board/value/
undo bytes from the separate restore capture. An independent natural undo
capture reproduces complete board/value/rack/workspace/counter and unchanged
counts. These are the same scoped comparisons as native replay, not a new
claim of full-game equivalence. The runner uses Node26; no browser UI tested.

## Research bridge layout

`maven_board_reset()` zeroes all bridge storage and installs internal pointers.
`maven_board_buffer(id)` returns addresses for these fixed-capacity arrays:

| ID | Buffer | Size in bytes |
|---:|---|---:|
| 0 | board | 544 |
| 1 | value words | 1088 |
| 2 | letter-value words | 256 |
| 3 | word multipliers | 544 |
| 4 | letter multipliers | 544 |
| 5 | letter classification | 128 |
| 6 | alphabet | 28 |
| 7 | move | 34 |
| 8 | rack | 8 |
| 9 | undo | 33 |
| 10 | rack counts | 128 |
| 11 | scorer remaining rack | 16 |

Word arrays are wasm little-endian. The JavaScript replay explicitly decodes
big-endian original captures and writes little-endian words; it never overlays
classic Mac structs. Byte arrays retain original byte representations.

`maven_board_score()` returns score bits, with other scorer outputs available
through buffer11 and result getters. `maven_board_prepare_counts()` explicitly
prepares the rack-count prerequisite, then `maven_board_apply()` applies the
move. `maven_board_set_counter()` and `maven_board_undo()` support undo replay.
Result getter IDs0..4 expose scorer new-tile count/rows/columns;5..6 expose
application new-tile count and row-zero counter. Unsupported IDs and returning
diagnostics trap in this research bridge. This is a fail-fast adapter choice,
not a claim that original diagnostics always abort.

Inputs must satisfy the reconstruction's valid ASCII/game-state contracts.
This raw-memory bridge is not an untrusted file parser or general product API.
A future browser integration needs validated input, lifecycle and table loading,
UI, refill/randomness and history. Scoring/application alone do not supply
legal move generation, AI ranking or a complete playable game.
