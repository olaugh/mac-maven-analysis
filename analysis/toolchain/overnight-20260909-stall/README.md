# Overnight 2026-09-09 stall at game 302 (303rd game), turn 21

**Verdict: repeatable harness limitation, not a VM fault and not a scoring disagreement.**

## What happened

- `overnight-20260909` stopped as `STALLED` (`signal_15`) after 302 completed games,
  6,869 positions, 67,942 ranked records, all matched. Last logged line was game 302
  turn 21 (1-based), i.e. position `game=302, turn=21` (0-based) never completed.
- Position: after Magpie played DESTRIER (A5 down, 60), original Maven to move with
  DEEINUY vs HZ, 356/415, bag empty. CODE30 endgame search, budget 120 ticks.
- The paused VM (QEMU PID 90578) had PC = CODE30 base + 0x476, immediately after the
  clock call at base + 0x472, frame return address 0x07b3c5c6 (Kibitz caller),
  12(a6) = 0x78 budget, d0 = 38 ticks elapsed. The search was progressing normally.

## Why it exceeded the 120 s watchdog

The driver breakpoints every clock read (`c`, `g`, remove, `s`, re-add, `c`), which
costs ~0.11 s wall per read (measured: 0.069 s continue-wait + 0.042 s bookkeeping).
The supervisor stall limit counts seconds since the last *completed* position.

| endgame | clock reads | wall seconds under driver |
|---|---|---|
| previous slowest (game 149 turn 19) | 693 | 68.6 |
| game 302 turn 21 (this one) | 1,388 | ~150 (est.); 1,129 reads before the kill, 259 after |

No endgame in the run ever reached its 120-tick deadline (max 47 ticks here), so
the guest clock is not the limiter; the per-read debugger round trip is.

## Verification done after the stop

1. Offline replay of all 6,869 recorded positions with the recorded dylib: all matched
   (`replay.log`, 41 s).
2. Resumed the paused search under the same breakpoint loop (`stall-continuation.json`):
   259 more reads, 28.8 s, finished naturally at 47 ticks, count 2.
3. Post-search board/racks read from the VM (`stall-post-search-state.json`) equal the
   host position (DESTRIER present, racks deeinuy / hz).
4. Fresh C engine replayed the full sequence, then ran this position with the
   post-search seed 389304680 and a counting clock callback: 1,388 reads, rc 0,
   identical 2 records (DO 3.00 / OD 6.00), zero byte differences
   (`stall-c-comparison.json`).

Caveat: the pre-kill clock prefix values were lost with the batch process; only their
count matters (elapsed is compared only against the budget) and it was reconstructed
from the C engine's read count.

## VM state

QEMU 90578 remains paused after the continuation; original Maven has completed this
Kibitz search and is stopped at the caller return address. The original directory was
not modified.

## Recommendation

Make the watchdog progress-aware (driver heartbeat per clock read, or per GDB stop)
or raise `--stall-seconds` to ~900 for endgame-heavy runs. Alternatively cut per-read
cost (avoid the remove/step/re-add cycle) — 1,388 reads at 0.11 s is 2.5 minutes.

## Follow-up (2026-09-09 22:29 PDT)

- Driver now reports a heartbeat at every debugger stop (`--heartbeat-file`,
  events entry/search/clock/return); the supervisor resets its stall timer on
  any heartbeat change and records `last_heartbeat` in `status.json`. The endgame
  clock loop keeps the caller breakpoint armed and only steps over the clock one.
- Validated with a fresh Maven instance: `validate-heartbeat-20260909`, 1 game,
  20 positions, all matched live and offline.
- Maven relaunched fresh again (guard matched the resource initializer), then
  `thousand-20260909` launched: seed 9102072, 1000 games, 14 h limit, QEMU 90578,
  supervisor 26818, batch 26823, monitor 26819. `Watch Maven.command` points at it.
