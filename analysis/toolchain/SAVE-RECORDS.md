# CODE 22 record serialization

The save routine [0x166,0x2cc) iterates a handle at current-window+0xca.
Each in-memory entry occupies six bytes: a tag byte at +0 and a handle at +2.
The loop re-reads the list handle size and divides by six before each entry.
It uses a signed-extended 16-bit counter compared unsigned against that
32-bit quotient. This is not yet a reconstructed whole save orchestration.

The per-record sequence [0x200,0x28e), now save_record.c, writes:

1. Two-byte big-endian sign extension of the entry's tag byte.
2. Two-byte big-endian low word of GetHandleSize(payload_handle).
3. Payload bytes, with the low-word size sign-extended back to 32 bits for
   FSWrite's mutable byte count.

Each write's result is ignored, and the count is reset before the next write.
After locking the payload through A5+0x5ea, tag 1 causes the word at +4 to be
saved and cleared. The payload write sees that cleared word. HUnlock occurs
before the original word is restored through the saved pointer. The meaning
of that field is not yet established; do not call it a score, flag, or pointer
without evidence from its producers/consumers.

The corresponding read routine [0x2cc,0x48a) reads a two-byte tag and exits
on -39 (EOF) from that read. It then reads a two-byte length, allocates or
resizes a payload handle, stores the tag's low byte in the six-byte entry,
and reads the payload using signed length. Other read-error handling is weak
in the decoded sequence. The complete reader still needs reconstruction and
natural round-trip captures.

After the save loop, FSClose failure invokes a diagnostic. FlushVol's result
is ignored, current-window+0xd2 is cleared, a filename-related helper is called,
and D0 is set to one. This means a success return is not proof that every
payload write succeeded. A modern save adapter must preserve this distinction
in compatibility tests before intentionally improving error reporting.

Host tests verify wire bytes, sign extension, length truncation, ignored error
results, and the fact that the word remains zero until after unlock. No
original save file or natural save execution was captured in this batch.

## Natural empty-position save

The subsequent capture save-empty-live.json verifies loaded CODE 22 and a
normal Save action from the initial empty position. It makes zero FSWrite
calls, closes successfully, and returns one. The file maven-re-0855 in the
disposable session share has a zero-byte data fork; save-empty-file.json
records its hash and Finder metadata. This verifies the empty loop case,
not per-record serialization. A game with history is needed for payloads.

## Natural new-game save

After normal Command-N, Maven dealt tiles and produced history. The subsequent
Save to maven-re-0905 is captured in save-new-game-live.json, with full loaded
CODE 22 identity. Nine FSWrite calls and FSClose all returned zero; the routine
returned one. All 86 saved file bytes equal the concatenated captured writes.

| File offset | Tag | Payload bytes |
| --- | --- | --- |
| 0 | 1 | 22 |
| 26 | 4 | 0 |
| 30 | 2 | 52 |

The tag-1 word at payload+4 was 0001 before serialization, zero in the captured
write/file, and 0001 again after restoration. The C writer reproduces every
captured write and the restoration through replay_save_records.py; evidence
is save-record-replay.json. The file hash and record hashes are recorded in
save-new-game-file.json. Payload prefixes contain rack-like letters, but exact
field meanings remain unassigned pending producer/consumer analysis.

## History consumers in CODE 7

CODE 7+0x590 obtains the six-byte entry's handle, locks it, sign-extends its
tag, and calls the dispatcher at +0x3c with payload, tag, and history index.
It unlocks afterward. The tag-1 branch is [0x70,0xca), now history_initial.c:

| Tag-1 payload field | Consumer meaning |
| --- | --- |
| +0 word | Not read by this branch; meaning unresolved |
| +2 word | Nonzero selects first restored rack; zero selects second |
| +4 word | Not read by this branch; separate backwards scan below |
| +6 C string | First rack (captured `aceekoq`) |
| +14 C string | Second rack (captured `oriaate`) |

Before restoring racks it clears 0x220 bytes at A5-0x4302 and 0x440 bytes at
A5-0x40e2. It clears long totals at A5-0x3c8e/-0x3c92 and writes the selected
rack pointer to A5-0x3c8a. String copying is A5+0xda2, verified as the ordinary
byte-copy-until-NUL routine at CODE 52+0x21c. This is a static consumer mapping
tested with the captured payload, not a natural restore-state capture.

CODE 7 [0x5ea,0x656) scans history backward: tag 0 returns zero, tag 1 returns
the payload word at +4, and other tags continue scanning. This gives that
word a history-state role, but does not yet establish a descriptive semantic
name. The save writer's intentional clearing therefore affects a later
history query; do not simply remove it as redundant serialization cleanup.

Tag 2's branch [0x278,0x2e6) recursively restores the previous record, reads
a selector word at +0x22, adds the long at +0x10 to one running total, and
copies rack strings from +0x24/+0x2c before further helpers. This supports
score/rack interpretation but full move application is still unreconstructed.

The tag-2 branch is now history_move.c. Its external calls are identified:
count_rack is CODE 31 [0x992,0x9d2) at A5+0x96a; it clears counts only for
characters in a global alphabet string, then increments byte counts for the
supplied rack. apply_move is the much larger CODE 31+0x184 at A5+0x942,
called here with its third argument zero. refresh_rack is CODE 22+0x48a at
A5+0x582, which has a pointer-identity special case for the first rack before
calling A5+0x962. Those helpers remain explicit dependencies of the branch.

The branch re-reads the record selector after restoring previous history.
The score addition is ADD.L, retaining 32-bit wrapping behavior. The previous
index is a 16-bit subtraction, also wrapping. Tests assert these edges and
the restore → rack count → apply → refresh ordering for both players. They
do not prove that the complete game state is restored correctly.
