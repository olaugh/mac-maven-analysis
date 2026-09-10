# Magpie-driven original Maven game comparisons

The intended comparison is **Mac Maven versus the reconstruction**. Magpie only
selects the human side's moves. Magpie's evaluations are not an oracle for Maven.

## Corrected result (2026-09-10 UTC)

The original v7/v8 reports preserve their historical failures. Replaying both
sequences with **one continuous C engine**, after fixing the omitted CODE29
scratch clear, matches **all 277 positions / 2,722 ranked records byte-for-byte**.
POOFIER's apparent scoring error came from restarting only the native engine;
[the corrected diagnosis](POOFIER-DISAGREEMENT.md) explains the original's retained
query/control buffer. [VID-SCRATCH-FIX.md](VID-SCRATCH-FIX.md) explains the separate
unused-byte fix and the ALOIN → VID stale-byte path.

The live harness now checks original query/control initialization before a new
native sequence. A new guarded fresh-session game completed all 22 positions
with exact agreement (`original-magpie-fresh-guard.json`). The old 20-game target
was not completed; the reports cover 11 complete games plus partial games, and
this additional complete game. Neither historical failures nor duplicate
positions are relabeled as new independent games.

The authoritative continuous replay is:

```sh
python3 scripts/replay_original_magpie_matches.py --build \
  analysis/toolchain/poofier-continuous-diagnostic.positions.jsonl.gz
```

The file name is historical; this uses the normal strict comparator.

## Vehicle

`play_original_magpie_matches.py` maintains a deterministic shuffled bag and two
racks. Starting seats alternate between games. It writes each position as a new
original-format snapshot, opens it through Maven's normal file dialog, and invokes
Kibitz. There are no guest memory/register writes or code patches. Debugger
breakpoints capture the selected search entry and its return; the current CODE
resource body is verified against the recovered resource. The loaded dictionary
is verified on the first position of the batch.

The reconstruction receives only public board/blank/rack data, the observed
consecutive-row-zero counter, and the search mode/inputs. No original caches,
leave tables, occurrence masks, or crossing workspace are injected. Both original
Maven and the reconstruction remain alive across the sequence. The log includes
the original crossing workspace for diagnosis, not initialization.

At every position compare all 340 bytes in the ten-slot ranking, the active count,
and (for ordinary heuristic search) the cutoff. This checks move spelling,
coordinates, order, score and valuation terms, plus metadata/unused slots. Late
search uses the corresponding native late API. Endgame records every original
elapsed-clock return and derives the initial private RNG seed from the verified
original hash sequence, then replays those inputs through the native endgame API.

Magpie supplies one static-equity best move on its turns. On computer turns,
**original Maven's** top ranked move is used, after the ranking has matched. The
reconstructed move applier supplies that move's precise blank assignment. Its
refill is discarded; the match host draws from the seeded bag. No outcome is
counted as evidence of identical game-history/refill behavior.

## Dictionary and selection policy

`prepare_magpie_maven_lexicon.py` extracts the word list through the reconstructed
word enumerator. Its test-only output callback resets the original Word List UI's
1000-result counter so extraction can continue. It does not change reconstructed
source. 246,691 unique ASCII words of length 2–15 are accepted. Three padded
records are rejected rather than silently changed into playable words.

Magpie uses this KWG/wordmap and CSW21 leave values solely to choose moves. The
lexicon preparation report records hashes and rejected records. Lexicon files
remain local derivative data, not source-code deliverables.

## Evidence and replay

- `magpie-original-pilot.json`: original full candidate trace (396 callbacks).
  The existing `replay_portable_engine.py` matched every callback, all valuation
  bytes, and the final ranking on three repeated searches.
- `original-magpie-games.json`: initial recorder-development run; 18 matching
  positions, then a timeout because the recorder did not follow the late-game
  entry. **Not a Maven discrepancy or a completed game batch.**
- `original-magpie-games-v2.json` and `.positions.jsonl.gz`: stopped on the EBON/OBE discrepancy, now fixed (see `EBON-FIX.md`).
- `original-magpie-games-v7.json` and `original-magpie-games-v8.json`: latest strict runs.
  Consult `complete`, `completed_games`, `positions`, and `failure` before making
  any completeness claim. A disagreement stops the batch and saves its position.
- `replay_original_magpie_matches.py`: independent no-VM replay of saved searches,
  preserving their order and checking every ranked record again.

Example, from the analysis repository (with the isolated Mac running Maven):

```sh
python3 scripts/prepare_magpie_maven_lexicon.py
python3 scripts/play_original_magpie_matches.py --build --games 20 \
  --max-seconds 3600 --output analysis/toolchain/original-magpie-games-v7.json
python3 scripts/replay_original_magpie_matches.py \
  analysis/toolchain/original-magpie-games-v7.positions.jsonl.gz
```

## Limits

This is a sequence of normal original search calls on imported game positions,
not a proof of the original UI move-entry, simulation, refill, history, final-score
adjustment, or cancellation lifecycle. It covers ordinary heuristic, late, and
endgame search as selected by Kibitz. Bulk comparison is of ranked lists; only the
pilot traces every generated candidate.

Snapshot import does not retain the host's previous exchanges/passes as history.
The two compared engines use the actual original-imported row-zero counter, and
the host uses its own consecutive-pass/exchange counter for game termination.
Scores in the game report precede final rack adjustments; they are not tournament
results or an engine-strength estimate.

`play_magpie_matches.py` and `magpie-pilot.json` are the earlier, superseded
Magpie-versus-reconstruction pilot. They do **not** establish original equivalence.

## Runtime and debugger overhead (2026-09-10 UTC)

The new seed-9102050 batch uses QEMU 11.0.1's q800 TCG machine with no
instruction pacing, clock alignment, or CPU throttle. The existing driver is
QEMU-specific; Basilisk II was not found in PATH or the searched application and
source directories. See `more-games-runtime.json` for launch identification.

Each position goes through normal Open/Kibitz and search-entry/return
breakpoints. Original code runs freely between stops, except for lazy resource
loading, breakpoint cleanup, and endgame clock observations. This bulk run does
not breakpoint every generated candidate.

The driver deliberately sleeps 1.2 seconds around Open, 0.56 seconds for the
seven-character filename, and 0.16 seconds for Open/Return keys: at least 1.92
seconds per position, plus 0.08 seconds when it sends Kibitz. These are source
accounting figures, not separately profiled wall-clock measurements. Remaining
time includes key delivery, QMP/GDB round trips, resource verification, both
engines' searches, and host match work. Initial observations were roughly
2.1–2.4 seconds per position.

Future throughput work should first time those stages individually, then
replace conservative fixed Open waits with verified UI/search readiness and
reduce connection/round-trip overhead. Preserve normal import side effects,
resource identity checks, and both engines' continuous lifetimes: bypassing
those can reintroduce the POOFIER comparison error. No pacing changes were made
to the running batch.

## Completed new batch and faster UI trial

Seed 9102050 completed **20 games, 455 positions, 4,508 ranked records** in
1092.70 seconds. All comparisons and the independent offline replay passed:
354 heuristic, 51 late, and 50 endgame positions.

The first five seeds were repeated with `--ui-delay-scale .25`: Open waits of
0.05/0.25 seconds and 0.04 seconds between keys. All **110 positions / 1,097
ranked records** passed in 127.72 seconds (baseline first five: about 245.2
seconds). Every imported CGP and final ranking also matched the baseline run.
This repeat is a speed check, not five additional independent games. No Maven
binary patch was used. One Mac OS session was retained; Maven was relaunched
once between batches to pair fresh original/native engine lifetimes.

Excluding the first dictionary-verification position, measured mean fast-driver
stages were: attach/arm 0.0008 s, Open UI 0.7123 s, entry/input capture 0.2788 s,
and original search with debugger 0.1121 s. Search-kind mix affects these
averages; they are not pure CPU timings. See `more-games-summary.json`.

The default direct-driver delays remain unchanged. The standalone overnight
supervisor explicitly selects `.25`, records source hashes, checks them every
60 seconds, and pauses on exit. See the Fable handoff for monitoring commands.
