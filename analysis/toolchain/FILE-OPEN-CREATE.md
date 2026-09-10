# File opening and create fallback

CODE 47 [0x12c,0x16c) calls FSOpen, returns its error if nonzero, then
conditionally calls SetEOF(ref,0) when its 16-bit truncate argument is nonzero.
It returns that result and does not close on truncation failure.

CODE 47 [0x16c,0x1da), exported at A5+0xd32, calls this helper. Any error
triggers GetFInfo on the application name at low memory 0x910, volume zero.
It ignores GetFInfo's status and reads the creator from the local FInfo+4.
Create receives the requested filename/volume, that creator, and the type
argument at A6+0x14. If Create succeeds, the original open/truncate helper
is called once more. The Create or second-open error replaces the first error.

Known aligned callers are CODE 3+0x110c and CODE 22+0x188; CODE 22 passes
type TEXT and truncate=true. Its later FInfo update changes type to XGME.
These call chains have static instruction evidence, not a new natural save
capture. No host or guest files were opened for writing in this analysis.

`file_open.c` retains call order and error precedence. Its scratch_info argument
represents the original uninitialized local buffer if GetFInfo fails without
filling it. This is explicit input to the host API, avoiding undefined host C
reads without inventing a creator value. A debugger capture can supply the
actual original stack bytes. A modern port should make a deliberate choice
to reject this failure or provide a known creator, documented as a change.

Tests cover successful open/truncate, file-not-found/create/retry, initial
truncation failure followed by Create failure, no-truncate success, and a
second open failure. The GetFInfo callback deliberately fails without writing
the scratch bytes, verifying the original ignored-status behavior.
