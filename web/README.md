# Maven in the browser

A WebAssembly build of the reconstructed Maven engine behind a pixel-faithful
reproduction of the 1995 Macintosh interface (640x480, Charcoal/Monaco/Geneva
bitmap fonts, original menus and dialogs).

## Run

```sh
sh web/engine/build.sh        # builds web/build/maven-app.wasm (needs llvm@18 clang)
python3 web/serve.py 8765     # serves web/ with cross-origin isolation headers
```

Open http://localhost:8765/ (localhost or HTTPS enables `SharedArrayBuffer`,
which the app uses to stop simulations and endgame searches with Escape; on a
plain HTTP LAN address simulations run to a fixed sample limit instead).
Any static host works; only the cancellation feature needs the two headers
`Cross-Origin-Opener-Policy: same-origin` and
`Cross-Origin-Embedder-Policy: require-corp`.

Tests: `node --test 'web/tests/*.test.mjs'` (engine bridge against the recorded
original rankings and the BURIN human-commit capture; GCG importer).

## What plays exactly like Maven

The engine is the unmodified `reconstruction/` C compiled to wasm, plus
`web/engine/portable_engine_app.c` which adds human move entry, exchanges,
dealing, lexicon selection, word checks and the Word List on top of the
private engine structure. The bridge (`web/engine/maven_app.c`) supplies a live
tick clock, a per-search elapsed-seconds clock, a cancellation flag and the
classic Toolbox `Random()`.

Verified in `web/tests/engine.test.mjs`:

- Kibitz dispatch (heuristic / late / endgame by unseen count, opening word
  deduplication) reproduces the original's 34-byte ranking records byte for
  byte on the recorded overnight positions, retaining warm search state across
  a continuous sequence.
- A human move commits through the original CODE11 turn commit with the CODE8
  staged-display scorer; the BURIN capture matches record, features, board and
  totals.

Not exact, by nature or by omission:

- Level menu: all 18 levels play. 2100 is the full engine; 2060 and below run
  the heuristic only (no pre-endgame or endgame) and drop candidates through
  the recovered CODE13 filter, so they play weaker. See
  `analysis/toolchain/PLAYING-LEVELS.md`. Reduced-level equivalence to the
  original is reconstructed from the code and live tables, not yet byte-verified
  against fresh original captures (that needs the VM, which is busy).
- Endgame budgets are real seconds, so a slow machine can cut a search where a
  fast one would not, exactly as two different Macs would.
- New Game dealing and refills are random; the mixing routine is the original
  but the seeds are the host's.
- Tile placement UI, Kibitzer labels (BEST/GOOD/ALSO threshold) and dialogs are
  reproductions from the resources, not reconstructed UI code.

## Dictionaries

`web/dictionaries/` holds Maven-format data forks compiled by
`web/tools/build_dawg.py`, which rebuilds the shipped 1995 file byte for byte
from its own word lists: MAVEN-1995 (TWL98 / OSW), NWL23-CSW24, NWL20-CSW21,
TWL06-CSW24. The Lexicon menu picks North American (section 1), United
Kingdom (section 2) or both, and lists the dictionary files. "Compile Word
Lists..." builds a dictionary in the browser from text files
(`web/dawg_compiler.js`). Changing dictionaries restarts the engine, as
relaunching Maven with a different data fork would.

## Games and positions

- File > Open: original Maven save files, GCG games (from cross-tables,
  Woogles or Quackle) or a CGP position line, chosen by content. Edit > Paste
  Position also accepts a CGP position or pasted GCG text.
- Imported games open in review: click a turn to see the position before it,
  then Kibitz or Simulate. Unknown opponent racks are drawn from the unseen
  tiles. Alter Rack & Position edits racks, scores and side to move.
- File > Save writes the original history format; Export GCG writes GCG.
- Closing the window or the tab: File > Close and Quit offer to save first,
  like the original. The game is also autosaved to browser storage and offered
  for resumption on the next visit (a resumed game runs on a fresh engine
  instance, like relaunching Maven and opening the saved file).

## Controls

Click a square to place the arrow (click again to turn it) and type letters,
or drag tiles from the rack. Tap-to-place for touch screens: tap a rack tile
then a square; tap the same tile twice to mark it for exchange. Type `?` or
place the blank to choose its letter (an on-screen A-Z picker appears). Play
or Return commits; Reset or Escape takes tiles back; Command-K kibitzes.
The screen scales to the window, including phone widths.
