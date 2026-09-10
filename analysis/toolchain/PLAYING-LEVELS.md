# Playing levels (the "nerf" mechanism)

Maven's Level menu (MENU resource 5) offers 18 strengths, from 2100 down to
1420 in steps of 40, plus a disabled "Vary Level By Result". This reconstructs
how a chosen level weakens the computer's play, from CODE13, the live A5 tables
in the 128 MB RAM dump, and the profile records in `prfs`.

## Where the level lives

The selected level is a 1-based word stored in the active player profile at
`profile+0xa` (profiles are 0xC0-byte records; the active index is `prefs+0x302`,
the profile base is `prefs+0x300` region reached through the preferences handle
at A5-0x2188). Level word 1 = menu item "2100", 2 = "2060", ... 18 = "1420".

Two parallel tables, both read from the running app (CurrentA5 0x07cf5500):

| Level word | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Rating T (A5-0x5e74) | 2100 | 2060 | 2020 | 1980 | 1940 | 1900 | 1860 | 1820 | 1780 | 1740 | 1700 | 1660 | 1620 | 1580 | 1540 | 1500 | 1460 | 1420 |
| Accept N (A5-0x1d44) | 256 | 256 | 216 | 182 | 153 | 128 | 108 | 90 | 76 | 64 | 54 | 45 | 38 | 32 | 27 | 23 | 19 | 16 |

## The computer move: CODE13+0x00b2

`CODE13+0x00b2` is the single computer-move entry (called from the CODE11 game
commit at CODE11+0x1024). Given the profile's level word `d7`:

1. It sets the per-search leave bias A5-0x5ab4 to `round(T[level] - player_rating)`
   via SANE (FP68K): load T[level] as an integer, subtract the profile's stored
   extended rating, round to integer. This bias is added to every leave value in
   CODE32+0x1378 and in the exchange generator, and is cleared after the search.
   It is 0 exactly when the level's cap equals the player's rating.
2. If `d7 == 1` (2100): call the full CODE44 dispatcher (CODE44+0x0004), which
   chooses heuristic / pre-endgame / endgame by unseen count. Full strength.
3. Otherwise (2060 and weaker): build a 256-slot acceptance mask, then run ONLY
   the CODE28 heuristic (CODE28+0x011a) with a per-candidate filter as its
   callback. No pre-endgame or endgame search ever runs at a reduced level.

## The candidate-drop filter: CODE13+0x0082

The acceptance mask is 256 bytes. It is filled by setting slot `(17*k) mod 256`
for `k = 0 .. N[level]-1` (stride 17; gcd(17,256)=1, so the slots are distinct).
A persistent global counter (A5-0x1d1e), advanced once per generated candidate
and wrapped mod 256, indexes the mask. The filter (CODE13+0x0082) is CODE28's
per-candidate callback: it admits candidate `p` iff mask slot `p mod 256` is
set, i.e. iff `(241*p mod 256) < N[level]` where 241 = 17^-1 mod 256. Admitted
candidates go to the normal top-ten insert (CODE28+0x0004); rejected ones are
discarded before ranking. The counter persists across moves, so the drops are a
deterministic pseudo-random thinning of the candidate stream.

Every exchange/pass candidate and every placement candidate passes through the
filter. The CODE28 phase-2 collector rescore of the survivors re-inserts
directly (CODE28+0x0004, a `jsr $4(pc)` at CODE28+0x25a), bypassing the filter.

So a reduced level sees only ~N/256 of its candidates and never runs the deep
searches, and plays the best of what survived. At the weakest level (1420) it
keeps 16 of 256 candidates; passing or exchanging on a full rack becomes common
because the filter can leave no accepted play in a given move.

## Reconstruction (native C and wasm share one implementation)

Implemented in the reconstruction proper:
- `reconstruction/playing_level.{c,h}`: the rating and accept tables, the
  `MavenLevelFilter` (stride-17 mask + persistent mod-256 counter), the admit
  predicate and the `round(cap - rating)` leave bias. Pure C99 integers, so it
  builds for the host, wasm and a 68k target.
- `reconstruction/heuristic_search.c`: `MavenHeuristicSearch` gained an optional
  `MavenLevelFilter *level`. When NULL (full strength / 2100) nothing changes;
  when set, the pre-insertion point in `accept()` gates phase-0/1 candidates
  through the filter and never gates the phase-2 rescore.
- `reconstruction/portable_engine.c`: `maven_portable_heuristic_leveled(engine,
  level_index, player_rating, ...)` runs the heuristic only with the filter and
  the leave bias, advancing a persistent per-engine counter;
  `maven_portable_level_reset` clears it at a new game.

The wasm app (`web/engine/maven_app.c` `app_move`) calls
`maven_portable_heuristic_leveled` directly for sub-2100 levels and the full
dispatch for 2100. The web Level menu drives it; a reduced level opens the
original "Your Rating" dialog (DITL 1017) once.

Regression: after adding the level hook, the rebuilt match library replays all
6,869 recorded 2100 positions / 67,942 ranked records with `all_matched: true`,
so 2100 behavior is unchanged.

## Verified vs. not

- Verified: the tables (from live RAM), the stride-17 / mod-256 / persistent
  counter filter structure (from CODE13), the reduced-levels-are-heuristic-only
  dispatch (from CODE13's `d7==1` branch to CODE44 vs. direct CODE28), and that
  level 0 (2100) with a 2100 rating reproduces the recorded overnight rankings
  byte-for-byte across 200 heuristic positions (`web/tests/levels.test.mjs`).
- Verified against the original at every reduced level. For each of the 17
  reduced levels (2060 down to 1420) a computer move was captured from the
  original Mac Maven in the QEMU VM at that level: the profile rating, the
  persistent CODE13 acceptance counter before and after, the board, both racks,
  and the original's full 340-byte / 10-slot ranking. Seeded with the same
  counter and position, `maven_portable_heuristic_leveled` reproduces the entire
  ranking and the counter advance byte-for-byte for all 17. The captures cover
  openings and mid-game positions and include a placement, a bingo (1900,
  "railhead"), an exchange (1820), and short defensive plays, so the phase-0
  exchange filter, the phase-1 board generator and the phase-2 rescore are all
  exercised. The captures live in `web/tests/fixtures/level-captures/` and the
  replay is the `every reduced level reproduces an original VM capture`
  regression test in `web/tests/levels.test.mjs`.
- Note on the leave bias: the profile rating in the captured VM was 2000, which
  is above every reduced level's cap, so `round(cap - rating)` clamps to 0 in
  all 17 captures (the original's A5-0x5ab4 read back 0 each time, matching the
  reconstruction). A non-zero leave bias — a player rated below the chosen
  level's cap — is therefore consistent with these captures but not yet
  independently exercised against the original.
