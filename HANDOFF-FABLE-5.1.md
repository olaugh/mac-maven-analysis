# Fable 5.1 morning handoff: original Mac Maven comparison

User objective: leave a token-free script comparing many games overnight, then
start debugging as soon as a disagreement appears. Original Mac Maven is the
behavioral oracle. Magpie only picks the human side's moves. Compare original
Maven's ranking with our C reconstruction, including unused bytes.

Repository: `/Users/john/sources/jan14-aviary/research/mac-maven-analysis`.
The working tree contains extensive uncommitted/untracked project work. Do not
reset, clean, bulk-revert, or assume untracked code is disposable.

## First action in the morning

```sh
cd /Users/john/sources/jan14-aviary/research/mac-maven-analysis
python3 scripts/monitor_maven.py analysis/toolchain/overnight-20260909 --once
```

Live terminal monitoring (no tokens, no model calls):

```sh
python3 scripts/monitor_maven.py analysis/toolchain/overnight-20260909 --notify
```

The monitor exits 2 for failures/disagreements and 3 for a stale heartbeat.
`RUNNING` means the supervisor is alive, not that the requested run is finished.
`COMPLETE` means the requested game count was reached. `STOPPED` with
`time_limit` is the normal 12-hour boundary, possibly partway through a game.
Only `completed_games` counts completed games.

To stop early, before debugging or editing any engine/driver source:

```sh
python3 scripts/monitor_maven.py analysis/toolchain/overnight-20260909 --stop
```

Wait for terminal status and `vm_paused: true`. If heartbeat is stale, inspect
PIDs and logs first; do not launch another driver on the same debugger sockets.

## What is running

`scripts/overnight_maven.py` supervises one continuous process of
`scripts/play_original_magpie_matches.py`, with 50,000 games as an upper bound,
12 hours of runtime, seed 9102071, and `--ui-delay-scale .25`. It makes no OpenAI
or other model calls. It does not need an AI task/automation to stay awake.
The supervisor is detached, uses `caffeinate -i` for its own lifetime, and
records PIDs in `status.json`. It checks progress every 5 seconds and hashes
sources/resources/binaries every 60 seconds. A 120-second progress stall,
source/VM identity change, or low disk space stops the run as an infrastructure
issue. It never restarts the game engines automatically.

Mac emulator: QEMU 11.0.1 q800 / 128 MB, unthrottled TCG, no `-icount` pacing.
It is not Basilisk II. The VM uses disposable `-snapshot` disks. QMP socket:
`/tmp/maven-re-qmp.sock`; GDB socket: `/tmp/maven-re-gdb.sock`.
The current owned VM PID was 90578 at setup; reverify it against manifest and
`ps` before taking any action. Do not touch unrelated user VMs.

There is one Mac OS boot and one Maven application instance per batch, not per
game. Each position is imported through normal Open/Kibitz. The original and
native engine both retain their state across every game in a batch. Relaunching
only one side can manufacture disagreements.

At normal or abnormal termination the supervisor pauses the existing VM and
leaves it available for debugging. This deliberately retained paused VM is
accounted for in the manifest/status; it is not an unowned background process.
If you are finished with it, verify PID/command/socket identity, then use
`python3 scripts/qmp_session.py quit`. Do not quit it before capturing a failure.

## Evidence directory

`analysis/toolchain/overnight-20260909/` contains:

- `status.json`: atomic heartbeat, terminal state, PIDs, counts, failure.
- `manifest.json`: source/resource/binary hashes and original VM identity.
- `games.json`: full batch report and first discrepancy, if any.
- `games.positions.jsonl.gz`: ordered captures for every compared position.
- `games.log`: position progress and traceback.
- `supervisor.log`: detached supervisor output.
- `STOP`: user-created graceful stop request.
- `DONE`: terminal state. Existing run directories cannot restart.
- `ALERT`: created for disagreement or infrastructure failure.
- On failure: `failure.png`, `failure.ppm`, `failure.ram` (128 MB physical RAM),
  `failure-registers.json` (raw 18-register GDB register packet and RAM layout).

q800 does not support QMP `dump-guest-memory`. The tested alternative is HMP
`pmemsave` plus GDB registers. The RAM dump was checked against live Mac
low-memory bytes. Dump failures are explicit status fields; never assume a file
was successfully captured without inspecting them. The VM remains paused.

## If there is a disagreement

1. Read `status.json`, `games.json`, and the tail of `games.log`. Distinguish
   `DISAGREEMENT` (byte/count/cutoff mismatch) from `ERROR`/`STALLED`/source change.
   The supervisor stops at the first failure. Do not overwrite this directory.
2. Preserve the complete ordered log, not just the failing CGP. Original query
   scratch state has observable effects across searches and games.
3. Verify the files against `manifest.json` and inspect the owned live VM before
   changing any source. Follow `.agents/skills/emulator-ipc-driving/SKILL.md`
   from the outer workspace: require ROM probe
   `m40800000,10 == f1acad130000002a067c4efa00804efa` before trusting reads.
4. Replay the complete sequence offline, using its recorded binary first:

   ```sh
   python3 scripts/replay_original_magpie_matches.py \
     analysis/toolchain/overnight-20260909/games.positions.jsonl.gz
   ```

   This raises on the first disagreement. Do not use `--build` until preserving
   the recorded binary and establishing the baseline. The sequence uses one C
   engine and replays computer-side move application to retain scratch effects.
5. For byte differences, decode each 34-byte record and distinguish score,
   valuation, coordinates/order/count from unused tails. Both matter, but a
   tail difference is not evidence of a scoring bug. Prioritize scoring first.
6. Use original entry/return breakpoints and focused traces to find the first
   divergent operation. No broad source rewrites or full instruction translation
   are required before isolating an observed failure. Do not patch the original
   oracle while gathering the baseline. The user authorizes temporary patches
   for driver/speed experiments, but those need separate explicit attribution.

## Established results and traps

- New independent seed-9102050 batch: 20 games, 455 positions, 4,508 ranked moves,
  all 340 ranking bytes/counts matching live and offline; 354 heuristic, 51 late,
  50 endgame positions. `original-magpie-more-games.json` and matching log.
- Same first five seeds repeated with shorter sleeps: 110 positions / 1,097
  ranked records, live/offline exact; all CGPs and rankings match baseline.
  127.72 s versus ~245.2 s. `original-magpie-fast-ui.json` / `more-games-summary.json`.
  This repeat is not five additional independent games.
- The earlier 230-command regression suite passed after the CODE29 fix. Only
  Python driver/supervisor/monitor changes followed; reconstruction C is unchanged.
- POOFIER was a harness lifetime mismatch, not a scoring bug: warm original
  A5-6f2 crossing query buffer aliases row flags at A5-6d2. Retained byte 34
  suppresses a main-word multiplier. Warm original 14 vs fresh native 28 was
  invalid comparison. Continuous v7/v8 replay matches all 277 positions / 2,722
  ranked records. See `analysis/toolchain/POOFIER-DISAGREEMENT.md`.
- VID unused-byte mismatch was real: omitted CODE29 scratch clear in C
  `endgame_leaf.c:tighten_replies`. An earlier ALOIN record left stale `n` at
  byte 4 after VID\0. Original clears all 34 bytes. Fixed and traced directly.
  This was stale initialized data, not uninitialized memory.
  See `analysis/toolchain/VID-SCRATCH-FIX.md`.
- Prior EBON/OBE 0.03 valuation fix involved original blank-arbitration A2 cursor
  semantics and zero-valued empty board cells. BURR mask-table alias fixed earlier.
- Instruction/source audit: `analysis/instruction-audit/README.md`,
  `source-map.json`, `CODE29-REPLY-TIGHTENING.md`. 33,336 verified disassembly
  records are not a claim of 33,336 fully ported instructions.

## Scope and speed

Bulk comparison covers the original ten-slot ranking, active count and heuristic
cutoff, not every generated candidate. Endgame clock/RNG inputs are recorded and
replayed. Full move candidate traces exist for selected fixtures only.

This is imported-position search equivalence, not proof of the complete original
UI play/refill/history/simulation lifecycle. Host owns the bag and scores. Magpie
is not a valuation oracle. Read `analysis/toolchain/MAGPIE-GAME-COMPARISON.md`.

The driver now supports temporary reduced sleeps. Defaults remain unchanged;
overnight explicitly selects `.25`: Open waits .05/.25 s and key delay .04 s
(QEMU holds keys for .03 s). No original Maven binary patch was needed. Measured
fast-stage means excluding the initial dictionary check: Open UI .7123 s,
entry/input capture .2788 s, original search with debugger .1121 s. Most delay
comes from the driver. Further speed experiments must verify the actual imported
board/racks and preserve both engines' state and code identity checks.

A separate detached `monitor_maven.py --notify` process watches the live run.
Its PID is in `monitor.pid`, output is in `monitor.log`; it exits at completion
or failure and attempts a local macOS notification on failure or stale heartbeat.
Notification visibility depends on macOS notification settings; the terminal
monitor and persisted ALERT/status files are the authoritative indicators.

## Launch accounting

The actual overnight supervisor PID is 96655, batch PID 96661,
monitor PID 96684, and owned QEMU PID 90578. Verify these against live
process commands before acting; PIDs can be reused. Planned time limit: 2026-09-10 07:23:20 PDT.

`Watch Maven.command` at the repository root opens the read-only terminal monitor.
Validation completed before launch: full supervisor game (22 positions / 220
records), deliberate warm-state failure with verified RAM preservation, and
detached graceful stop after one position. Both successful logs replayed exactly.
The warm-state failure-check directories are intentional harness tests, not Maven
scoring disagreements.
