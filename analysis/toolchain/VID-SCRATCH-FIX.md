# VID unused-byte fix

The four differing bytes were initialized leftovers, not uninitialized memory.
The native diagnostic observes the scratch record containing **ALOIN** before
reply tightening. Expanding `VID\0` later replaces bytes 0–3 and leaves ALOIN's
`n` at byte 4. ADD, GAD and DAD inherit the same byte; a subsequent longer DOVER
record overwrites it. The original clears the shared record first.

CODE29+0070/+0074 passes length 34 and A5-5a32 to the clear routine at +0078.
That location is also the leaf best-empty-move record and the final move-expansion
scratch. The readable `tighten_replies` had modeled the numeric bound computation
but omitted this aliased write. It now clears the record and mirrors the original
“any reply” long and emptied-rack word at offsets 24 and 28. All final 340 bytes
match; meaningful move scores, valuations and order are unchanged.

Evidence:

- `vid-tail-search-live.json.gz`: complete original two-iteration search and
  scratch snapshots. The final original first four names have byte 4 zero.
- `vid-tail-clear-two-leaves-live.json`: original CODE29 before/after breakpoints
  over both leaf calls, including ALOIN immediately before the clear and 34
  zero bytes immediately afterward.
- `vid-tail-clear-live.json`: original CODE29 before/after clear breakpoints,
  with exact resource and ROM identity. No guest memory/register writes.
- `vid-native-clear-diagnostic.log`: isolated native probe observes ALOIN before
  the new clear, then verifies the entire original final ranking.
- Native and wasm portable endgame replays pass the new capture. Native replay
  exercises three consecutive searches and two cancellation cases.
- Strict public-input replay of the combined v7/v8 sequence passes all 277
  positions / 2,722 ranked records, including the former raw-byte failure.

This resolves this particular stale-storage difference. It does not establish
that no other original or reconstructed code ever reads uninitialized storage.
The instruction audit records every decoded instruction in the affected
CODE29 routine: [mapping](../instruction-audit/CODE29-REPLY-TIGHTENING.md).
