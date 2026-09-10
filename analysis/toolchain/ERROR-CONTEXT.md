# Nonlocal errors and index-file loading

The previous goal turn established exact inline setjmp/longjmp matches with
the recovered THINK headers. The readable reconstruction now represents the
application's context stack in `reconstruction/error_context.h` and transfers
in `error_context.c`.

On the original non-68881 THINK ABI, the contiguous layout is:

| Global | Role | Size |
|---|---|---:|
| A5-24030 | Pending error payload | 4 |
| A5-24026 | Eight jump contexts | 8 × 44 |
| A5-23674 | Active context depth | 2 |

The payload's concrete type remains unknown. Host pointers/jmp_buf have different
sizes, so the host C structure must never be cast over guest memory. Calling
setjmp in a helper that returns would invalidate its saved frame; the save is
therefore a macro evaluated in the owning caller. As in the observed instructions,
the caller must check capacity before saving, and error transfer pops the context
before longjmp with value 1. No invented underflow recovery is added.

The nested-handler host test verifies that two transfers reach the correct
active frames, expose their error payloads, and leave depths one then zero.
That tests the readable C control flow, not original-runtime errors or ABI code
generation. Eight focused host tests currently pass.

## First CODE 15 function

Resource offsets 0x0004..0x00d2 load a file via A5+0x0d3a, mapped to CODE
47+0x025c. That callee opens a file, obtains its length, allocates length+1,
reads it, checks the allocated size, closes it, and appends a zero byte. Its
Toolbox calls still need a separate full API/cleanup audit.

CODE 15 divides byte count by four, initializes the caller's index to count-2,
and walks backward checking byte 3 of each record for ASCII 'a'. A failed load,
zero initial index, or failed bounded search stores A5-24792 into the pending
error field and pops/longjmps. `reconstruction/index_file.c` preserves the
unsigned comparisons and the order of the candidate check versus limit check.
For count >= 27, candidates are count-2 through count-27 inclusive.

The old claim that this routine searches a DAWG with a supplied pattern is
unsupported by these instructions. The output argument is written as a record
index. The exact meaning of the final records will be established from loaded
file bytes and their callers. No live-file success/error trace is claimed yet.

Malformed short lengths matter: TST.L/BHI tests nonzero, so count 0 or 1 wraps
the initial unsigned index instead of being rejected. The reconstruction does
not silently substitute a signed-positive or host-safety check. Use valid files
for execution until original behavior on malformed files is investigated in
the disposable guest.

## Reachability audit and actual startup file check

`index-loader-references.json` records a negative reference check against the
current CODE 15 hash: offset 0x0004 has no CODE 0 jump entry, and no even-aligned
16-bit displacement within CODE 15 points to it using the extension-word PC
base. Thus no direct call or PC-relative address-taking site has been found.
This does not prove the function unreachable: dynamic/indirect references or
other encodings are not ruled out. Retained unused code is a possibility, not
a confirmed linker option. Do not assume this function runs during startup.

The actually exported initialization entry is CODE 15+0x04d2, called through
A5+0x030a. At +0x0524 it calls +0x0d4c with CurApName (low-memory 0x0910,
confirmed by the recovered `LoMem.h`) and the volume reference at A5-3472.
This identifies the target as the application file itself.

The +0x0d4c routine opens that file, gets its EOF, requests a one-byte read,
accepts success or eofErr (-39), writes using the resulting actual byte count,
restores the saved EOF, and closes the file. Each failing step returns 1;
success returns 0. Intermediate failures do not visibly close the already-open
file. The caller transfers to its error context on nonzero result.

This appears to check write access. There is no seek between read and write,
so it is not generically content-preserving: for a nonempty file it writes at
the position after the read. Both preserved Maven data forks begin with two
zero bytes, consistent with leaving their first two bytes unchanged on this
path. This is a static inference, not a runtime hash comparison.

The next live trace should target this exported path and capture CurApName,
file-call arguments/results, original EOF, and the final return. Tracing the
unreferenced whole-file loader first could wait indefinitely without improving
the application decompilation.

## Original-runtime file check, now captured

The successful trace is `file-check-live.json`. It verified the complete loaded
CODE 15 resource, filename `maven2.1` at CurApName 0x0910, and volume reference
-3. FSOpen, GetEOF, FSRead, FSWrite, SetEOF and FSClose all returned zero.
The original length was 1,070,788 bytes; read and write each reported count 1
with byte 0x00. The function returned zero to its real caller, with SP advanced
four bytes (C return address only). The data fork's before/after SHA-256 was
`2619382321bca5b52967b3515d15b0592a8e1f641bce92f65edcf06ba10edb19`.
No arguments, registers, calls or memory were injected.

The reproducible sequence is `capture_startup.py` followed by
`capture_file_check.py --data-file PATH --output REPORT`. The latter catches
A5+0x030a, allows the original LoadSeg to resolve its stub, derives CODE 15's
base from the resulting JMP, and checks all bytes before capturing the file
routine. Beginning after the unload capture is too late: a first attempt
timed out because the check had already occurred. That observation corrects
the relative startup ordering; it was not counted as a successful trace.

`reconstruction/file_access_check.c` expresses the complete routine with typed
Toolbox adapters. The live success trace is replayed through compiled C in
`tests/test_file_access_check.py`, checking the operation sequence, filename,
volume/reference values, read/write counts and byte, saved length, and return.
All nine focused host tests pass. Early failures, eofErr handling, and their
file-descriptor effects still need original-runtime captures; the success test
does not validate those branches. The VM has been stopped after evidence saving.
