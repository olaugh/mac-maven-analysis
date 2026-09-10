# Toolbox initialization ownership

CODE 15+0x0cc0..0x0d4c is called at +0x04d6 before selecting the drawing
layout. It preserves D7 and performs these operations in order:

1. MoreMasters (A036), four times.
2. InitGraf (A86E), with A5-0x0536, followed by InitFonts (A8FE),
   InitWindows (A912), InitMenus (A930), TEInit (A9CC), and InitDialogs
   (A97B) with a null resume procedure.
3. A5+0x0be2 with version 1 and output A5-0x0da0; the version-dependent
   wrapper itself still needs a complete audit.
4. InitCursor (A850), then A5+0x0622. The latter resolves to CODE 9+0x0c5e
   and inspects the structure returned by A9F9, comparing its word at +8
   with A5-0x0d8c and conditionally calling A5+0x0bca. Its side effects are
   outside this initialization audit.
5. GetCursor (A9B9) for resource 1, copying 17 longwords to A5-0x0d88;
   then GetCursor for resource 4, copying 17 longwords to A5-0x0d44.
   Both handles are dereferenced without a null check. The copies are 68
   bytes each, matching the recovered QuickDraw Cursor structure.
6. FlushEvents (A032) with D0=0000FFFF, then write FFFF to low memory 0144.
   Raw register/memory operands are retained here pending their full API audit.
7. A5+0x0b42 with a null pointer and output A5-0x0d90, then SetResPurge
   (A993) with true, and restore D7.

Trap names above were checked against the recovered THINK C 6 Apple headers.
`toolbox-initialization.json` records CODE/snapshot hashes and both saved
cursor destinations. The second cursor is later supplied to SetCursor by
CODE 9+0x0062, reached from Word List setup CODE 12+0x0668. This establishes
its initialization path without assuming the investigation harness created it.
The original cursor resources need a direct comparison, and natural calls
through this full initialization sequence have not yet been captured.

## Clipboard synchronization helper

The recovered Scrap.h identifies A9F9 as InfoScrap and its structure's +8
word as scrapCount. CODE 9+0x0c5e compares that count with A5-0x0d8c,
calls A5+0x0bca on a mismatch, then calls InfoScrap again and caches the
new count. The import wrapper maps to CODE 34+0x04ce and requests TEXT
through GetScrap. Its full transfer implementation remains external.

CODE 9+0x0c84 exports only when A5-0x0d8a is nonzero. It calls ZeroScrap,
stores the low word of that return value in the cached-count global, calls
A5+0x0bd2 (CODE 34+0x0524, PutScrap TEXT), and clears the dirty word.
It does not test either result or replace the cached word with an InfoScrap
query. `clipboard_sync.c` preserves this order, including failed-adapter
behavior. Host tests cover the post-import count refresh and ignored export
failures; no live clipboard transfer or user clipboard operation was performed.

`scrap_transfer.c` now reconstructs the underlying CODE 34 wrappers.
Import queries GetScrap(TEXT) with null destination, rejects nonnegative sizes
>=32001 with -501, then reads into the TextEdit scrap handle at low memory
0xab4. Failure clears its length word at 0xab0. Success stores the low length
word and returns zero. The second read is not checked against the first size
or the 32000 limit. Export locks the handle, zero-extends its length word for
PutScrap(TEXT), returns the low result word and unlocks even after failure.
Host tests include the size boundary, both failure paths, changed second-read
size and unconditional unlock. Scrap/Memory Manager calls remain adapters;
no original-runtime transfer comparison is claimed.

## Environment and cursor provenance follow-up

A5+0x0be2 maps to CODE 34+0x003a, the SysEnvirons compatibility wrapper.
Recovered OSUtils.h identifies A090 and its version/output arguments.
The wrapper checks the low-memory word at 028E and compares trap addresses
before entering the native trap at +0x005a; otherwise it constructs a fallback
record. The fallback is not yet fully reconstructed. Startup requests version
1 and writes the 16-byte SysEnvRec at A5-0x0da0. The saved structure is decoded
in `system-environment.json` using the recovered header's field layout.

Direct comparison found neither requested CURS ID 1 nor ID 4 in Maven's
extracted application fork, and neither saved 68-byte cursor equals any of
its seven CURS resources. The comparison is recorded in
`toolbox-initialization.json`. GetCursor can search the resource chain; the
supplying system resource file still needs identification. Do not attribute
these bytes to Maven's own fork or treat absence there as a failed load.
