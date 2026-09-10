# Application callers of recovered MacTraps symbols

`scripts/map_mactraps_calls.py` records 102 aligned JSR/JMP candidates to
the 31 recovered CODE 34 entries. The scan alone does not prove instruction
boundaries or reachability. The following sequences were separately decoded
as instructions; none is a new live execution capture.

## Word-break callback installation

CODE 17 at 0x972 pushes the address of A5+0x602, then at 0x976 pushes the
TextEdit handle stored at A4+0xa0. The JSR at 0x97a calls A5+0xbda,
now identified by full interval matching as `SetWordBreak`, CODE 34+0x54a.
A5+0x602 resolves through CODE 0 to CODE 9+0x742, the decision routine
represented by `reconstruction/word_boundary.c`.

This connects the reconstructed separator logic to TextEdit's callback
installation. It does not prove that TextEdit has invoked it in our captured
runs. The wrapper includes an internal callback trampoline; the replacement
C decision function alone does not reconstruct that calling convention.

## Finder type in the game-writing routine

Within CODE 22's routine beginning at 0x166, the sequence at 0x198 prepares
a Pascal `GetFInfo` call with the filename in D7, volume reference in D6,
and a local FInfo at A6-0x1a. JSR 0x1a2 targets A5+0xb3a. The next instruction,
at 0x1a6, writes `0x58474d45` (`XGME`) to the first longword of FInfo. The
matching `SetFInfo` call is at 0x1b8, through A5+0xb5a.

The recovered Apple Files.h declares FInfo's first field as `fdType`; its
second is `fdCreator`. Thus this sequence changes the **type**, not the
creator. Both Toolbox error results are ignored here. Afterward a SetEOF
call at 0x1c4 truncates the open file to zero. Full save-path behavior still
needs reconstruction and live observation.

## File information helpers in CODE 47

Both routines below zero a 122-byte local parameter block through CODE
11+0xc5c (A5+0x1aa), set its name pointer at byte 18, call `PBHGetFInfo`
synchronously via A5+0xb82, and return its signed 16-bit error code. They
write the output value regardless of that error code.

| Resource interval | Output expression | Meaning from HFileParam |
| --- | --- | --- |
| CODE 47 [0x5a,0x92) | longword at parameter block +76 | ioFlMdDat, modification timestamp |
| CODE 47 [0x92,0xd0) | longword +68 plus longword +58 | resource-fork physical length plus data-fork physical length |

The second is physical allocation, not the sum of logical EOF lengths.
Its ADD.L uses 32-bit wrapping arithmetic. These offsets follow the recovered
Files.h layout with two-byte alignment: FInfo at 32, ioDirID at 48,
ioFlStBlk at 52, ioFlLgLen at 54, ioFlPyLen at 58, ioFlRStBlk at 62,
ioFlRLgLen at 64, ioFlRPyLen at 68, ioFlCrDat at 72, ioFlMdDat at 76.
The two helpers' output loads are at 0x84 and 0xb8/0xbc respectively.

CODE 47 [0xd0,0x12c) enumerates volume indices starting at one using
`PBGetVInfo` (call at 0xfa), a local Pascal name buffer, and a string comparison
via A5+0x7fa. On a matching comparison it stores the returned volume reference;
on an error it returns the error without storing an output. The comparison's
semantics were subsequently decoded at CODE 23 [0x17a,0x1be): compare length
bytes first, sign-extend the length, then compare byte indices starting at one
while index is strictly less than that signed length. This omits the final
character, and skips payload comparison entirely for lengths 128..255.
There is no case folding. `pascal_string.c` and `volume_lookup.c` preserve
these quirks; their occurrence in natural runtime inputs remains unverified.

The decisive sequence is CODE 23+0x196 MOVE.B length to D6, +0x198 EXT.W D6,
+0x194 MOVEQ 1 to D7, and +0x1b0 CMP.W D7,D6 followed by +0x1b2 BGT to the
comparison. Thus names of length three with the same first two bytes compare
equal even when the third byte differs. No lexical ordering result is returned:
the function returns only zero (match under these rules) or one (mismatch).

## Limits

The corrected library names strengthen static interpretation but do not
replace runtime evidence. In particular, no filesystem metadata was changed
to perform this analysis, and no current guest parameter blocks were observed.
The next useful runtime captures are the TextEdit callback trampoline and
the complete parameter blocks before/after these file-information calls.
