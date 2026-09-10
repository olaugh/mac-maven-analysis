# Recovered MacTraps project symbols

The installed THINK C 6.0.1 MacTraps library retains enough project metadata
to recover 288 named symbols: 278 code symbols (including aliases) and ten
QuickDraw data symbols. All 31 Maven CODE 34 jump-table entries map to code
symbols in this library by comparing every byte between successive Maven
entries. Each matched interval also ends at the next distinct library symbol
or the compilation unit's end.

Run `scripts/map_mactraps_symbols.py --library PATH/TO/MacTraps.rdump` to
reproduce `mactraps-symbols.json`. The script checks every symbol against its
compilation unit and redundant metadata fields, then checks every Maven
CODE 34 entry. It does not identify a unique original compiler release.

## Observed fields

Integers below are big-endian. These field interpretations apply to this
recovered file; unknown fields remain uninterpreted.

* ZONE begins with a saved pointer table. Subtract its first 32-bit value
  from each referenced pointer to obtain an offset in the resource. These
  are serialized addresses, not addresses in the running Maven process.
* INDX has ten 64-byte compilation-unit records. Offset 0 is the ZONE
  handle index; that object's Pascal filename begins at offset 47.
  Record offsets 4, 20, and 24 hold the CODE 0 jump-record byte offset,
  SYMS byte offset, and CODE 2 code byte offset. Offsets 48 and 50 hold
  16-bit symbol-data and code lengths.
* SYMS has 14-byte records. Offset 0 references the symbol's ZONE object.
  Offset 10 distinguishes observed data (0) and code (1) symbols; offset
  12 holds the unit-relative data offset or callable jump offset.
  The middle bytes contain apparent stale storage and are not decoded.
* A symbol ZONE object's offsets 4 and 6 hold its 16-bit unit index and
  32-bit unit-relative SYMS offset. Offsets 10 and 14 duplicate the symbol
  kind and offset. The Pascal symbol name begins at offset 26.
* For code, subtract two from the callable jump offset and add the unit's
  CODE 0 byte offset. The 16-bit value there, added to the unit's CODE 2
  base, gives the symbol's code address. This correctly handles CPstr.Lib's
  jump records at the end of CODE 0, despite its code being first in CODE 2.

The unit code ranges cover CODE 2 after its four-byte header. QDGlobals
has zero code bytes and ten data symbols. Symbol ranges cover all SYMS.
Do not interpret this library project's CODE 0 as a finished application's
uniform array of segment-loader stubs.

## Selected Maven labels

| Maven CODE 34 offset | Original library name(s) |
| --- | --- |
| 0x0004 | CtoPstr |
| 0x0020 | PtoCstr |
| 0x003a | SysEnvirons |
| 0x01a4 | GetPtrSize |
| 0x01d2 | FSOpen / OpenDF |
| 0x02aa | GetVol |
| 0x0486 | HandToHand |
| 0x04ce | TEFromScrap |
| 0x0524 | TEToScrap |
| 0x054a | SetWordBreak |

The JSON contains all 31 entries, their A5 callable offsets, and all library
symbols. Multiple names at one address are retained as aliases.

## Correction to the initial prefix-based map

The initial map followed arbitrary exact-byte recipe ranges and verified just
two instruction bytes at each entry. This was insufficient: different wrappers
share prefixes. Full interval comparison corrects five names:

| Maven offset | Incorrect initial label | Full-interval match |
| --- | --- | --- |
| 0x01c0 | SetHandleSize | PBGetVInfo |
| 0x0274 | Control | GetFInfo |
| 0x032a | FSDelete | SetFInfo |
| 0x03d2 | PBSetCatInfo | PBHGetFInfo |
| 0x054a | SetClikLoop | SetWordBreak |

The generated JSON and decoder now require the stronger comparison. The old
byte-range recipe remains a valid byte reconstruction, but its arbitrary
matching boundaries must not be used for naming or function boundaries.

## Symbol-driven reconstruction

`scripts/link_mactraps_symbols.py` takes the recovered library, the names in
`code34-symbol-selection.json`, and the Maven jump-table manifest. It decodes
library symbol addresses, sorts the selected intervals in library address
order, copies each through the next distinct symbol (or unit end), and derives
the segment header from the jump-table grouping. It reads neither Maven CODE
34 nor the byte-range recipe. All 1,392 output bytes match original CODE 34;
all 31 output entry offsets also match the original jump table.

The report is `code34-symbol-link.json`. Reproduce it with:

```sh
python3 scripts/link_mactraps_symbols.py \
  --library PATH/TO/MacTraps.rdump \
  --selection analysis/toolchain/code34-symbol-selection.json \
  --jump-table analysis/toolchain/jump-table.json \
  --output .build/CODE34-from-symbols.bin
cmp .build/CODE34-from-symbols.bin resources/CODE/34_34.bin
```

This reproduces observed symbol-interval selection and order for one library
segment. The names are recovered inputs, not independently resolved application
references. It does not yet reproduce dependency discovery, relocation,
dead-code elimination generally, or the choice of source alias. Entry intervals
can contain internal entry points and shared control flow; they are not a claim
that each interval is a self-contained C function.
