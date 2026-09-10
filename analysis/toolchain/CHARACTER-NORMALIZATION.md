# Character normalization and THINK library fingerprint

The Word List readers call A5+0x7f2, mapped by CODE 0 to CODE 23+0x01be.
This copies a NUL-terminated byte string, sign-extending each byte to a
16-bit argument for A5+0x0de2. It returns the initial destination pointer.
The callee resolves to CODE 52+0x015e..0x0186: index the 256-byte table at
A5-0x0428 using the argument's low byte, test bit 6, and XOR the full word
with 0x20 if set. The unchanged full word is returned otherwise.

`character-table-fingerprint.json` records the saved RAM snapshot hash,
CurrentA5, complete loaded CODE 23/52 identities, and the entire table.
Only bytes 65..90 carry bit 6. Thus this captured configuration lowercases
ASCII A–Z and leaves high-bit MacRoman bytes unchanged. It is not a general
MacRoman case converter. The table remains an explicit reconstruction
argument, preserving behavior if another application state changes it.

The recovered THINK C 5.0.2 and 6.0.1 `ctype.c` files both define exactly
this table and the same conversion expression. All 256 table bytes match,
including the implicitly zero-initialized upper half. The library header
defines the uppercase flag as 64 and explicitly indexes using an unsigned
character cast. This supports the THINK runtime attribution, but does not
distinguish those releases or establish a unique compiler/linker version.

`scripts/fingerprint_character_table.py` reproduces the comparison from the
saved snapshot and recovered distributions. `character_normalization.c`
reconstructs the 16-bit conversion and copying wrapper. The host test checks
all 65,536 argument words and an in-place string containing every nonzero
byte, against the behavior derived from the instructions and captured table.
No natural conversion-call trace has yet been collected; these tests are
not a substitute for that trace. Query preparation still accepts already
normalized ASCII, and does not claim to reproduce UI validation of other bytes.

Additional resolved setup calls: CODE 12+0x0668 calls A5+0x06aa, mapping to
CODE 9+0x0062, which supplies A5-0x0d44 to trap A851 (`SetCursor`). The
length reader CODE 12+0x082e initializes minimum to 0 and maximum to 15,
parses both fields through A5+0x081a, then resets maximum to 15 if it is
less than minimum. The saved format global points to `%d`. The caller is now
reconstructed in `word_length_controls.c` with explicit field-reader and
16-bit decimal-scanner adapters. It ignores the scanner's return value,
preserves defaults on an unassigned conversion, and does not clamp negative
values or recheck an inverted interval after resetting maximum. Evidence is
in `word-length-controls.json`; CODE 12 is not resident in that saved snapshot,
so this is a static caller reconstruction with a separately observed format
pointer, not a new original-runtime caller trace.

Recovered THINK `scanf.c` is a candidate for the parser at CODE 24+0x16fa,
whose wrapper calls +0x1712 and then the scanner at +0x0b00. Its integer
overflow handling differs from simply narrowing a host `sscanf` result.
Full parser equivalence and natural length-control calls remain to be checked.
