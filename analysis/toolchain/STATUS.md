# Toolchain identification and executable decompilation

## Objective and evidence standard

Identify Maven's original compiler and linker if possible. Recover a usable
toolchain or reproduce its relevant behavior. Build readable, descriptive source
for the complete application, with claims supported by real debugger observations.
Exact original names and source formatting are not recoverable from code alone.
Matching semantics and matching emitted bytes are separate milestones.

Current status: recovered and ran THINK C 5.0.2 and 6.0.1 comparison builds.
The 6.0.1 build matches Maven's complete 566-byte executable startup body;
the full 578-byte resource differs only in its application-specific main-entry
field. The 5.0.2 build matches the shared 506-byte helper block. See
`THINK-C-EVIDENCE.md`, `think-c-6-probe.json`, and
`think-c-fingerprint.json`. The THINK runtime family is now strongly supported;
the original compiler/linker versions remain **unconfirmed**. The prior assertions
of THINK C 5.x / Symantec C++ 6.x are not a unique version identification.
Generic A5 globals, LINK/MOVEM prologues, and standard CODE jump tables are not
sufficient discriminators. Separate the compiler, linker, and linked runtime.

## Correction: seven extracted CODE resources were truncated

This supersedes the initial suspicion of different executable variants.
`extract_resources.py` used a brace-delimited regex before stripping DeRez ASCII
comments. A `}` in an ASCII preview prematurely ended a resource. For example,
CODE 8's `49ED D77D` was followed by the comment `I..}...`.

The corrected parser preserves quoted names and removes block comments first.
Every one of the 53 corrected CODE resources now matches the native resource fork
of `media/maven/share/maven2` byte for byte. See `extraction-corrections.json`.
There are 119,012 bytes including CODE 0. The dump does have preference/window
resource differences (`prfs` and `wplc`); code identity does not imply full-file identity.

The audit was expanded to all resources and corrected 16 more truncated extracts,
including DATA, EXPR, PATB, MULd and MULt. See the follow-up evidence document.

Affected CODE IDs: 8, 15, 20, 21, 32, 34, 41. All prior completeness claims,
function counts and end-of-segment conclusions for these need re-auditing.
In particular CODE 21 is 13,722 bytes, not 176. Native fork parsing is independent
of DeRez text parsing and is the cross-check, not a second run of the same regex.

## Startup/runtime fingerprint

CODE 1 is 578 bytes including the four-byte segment header. Existing analyses
often use offsets four bytes smaller without clearly saying they omit the header.
All offsets below INCLUDE that header.

- Entry code begins at 0x000c, after the header and two longword fields.
- 0x0048 fetches `ZERO` 0 and `DATA` 0 via A9A0 resource calls.
- 0x006e copies DATA words into the below-A5 area. A zero word consumes a
  ZERO word as a byte-run length; the DBRA loop writes that many further zeros.
- 0x0084 fetches `DREL` 0. The loop at 0x009c adds A5 to longwords addressed
  by signed word offsets from DREL.
- 0x00aa/0x00be/0x00d2 implement distinct switch-dispatch helpers.
- 0x00ee is low-32-bit multiplication; 0x0124 and 0x0144 call the unsigned
  division helper at 0x01d6. The signed wrappers at 0x0166 and 0x0186 call
  the sign-handling helper at 0x01a8. Some old notes reverse these assignments.

The DATA/ZERO encoding, DREL relocation sequence, arithmetic helper bytes and
startup callback arrangement are better fingerprints than generic prologues.
Compare these with authenticated runtime sources/libraries and small compiled
programs from candidate toolchains before assigning a family or version.

## Live experiment

QEMU 11.0.1, q800, 128 MiB, copied Mac OS 8 disk, disposable `-snapshot` writes,
and a separate shared-folder working copy. Maven 2.1 opened through Finder.
QMP physical-ROM reads and GDB virtual-ROM reads both returned
`f1acad130000002a067c4efa00804efa`, identical to the supplied Quadra ROM.
GDB register order was obtained from `m68k-core.xml`, not assumed from host ABI.

At the recorded boot, A5 was 0x07cf5500 and CODE 1 base was 0x07b30450.
These are session-specific addresses, not constants for future launches.
The complete 578-byte live CODE 1 matched the extracted resource before capture.

Starting a new game naturally called CODE 1+0x00ee. An initial call had arguments
1 and 15 and returned 15. A further 32 calls (31 distinct input pairs) were
captured at entry and at their actual caller return PCs. All results match the
compiled `reconstruction/runtime_arithmetic.c`; D1 and D2-D5 were preserved and
SP advanced by 12 bytes (return address plus eight argument bytes).
See `multiply-live-calls.json` and `scripts/capture_multiply.py`.

This is **not** full-domain arithmetic verification, an emulator replacement,
or an ABI-compatible compiled drop-in. Overflow and sign-bit cases follow from
instruction analysis but were not exercised by these natural initialization calls.
No inputs, registers, or calls were injected; only debugger breakpoints and the
new-game UI action were used. Breakpoints were removed and the guest left paused.

After saving the evidence, the disposable session was terminated via QMP `quit`.
No remote emulator was launched or changed. Relaunch with
`bash scripts/launch_debug_session.sh` from this repository, then connect and
handshake before issuing QMP `cont`. The disk image remains the copied baseline;
the separate shared-folder working copy retains any application preference writes.

QEMU's GDB stub stops on attach. Query `?` when already stopped; sending an
interrupt then does not produce a second stop reply. Explicitly remove an entry
breakpoint before continuing past it; this small client does not implement GDB's
automatic step-over logic. These protocol behaviors were observed directly.

## Next milestones

Completed since the initial list: the full resource audit, two live startup
captures with exact reconstructed-global comparisons, and a static CODE 0 map.
`jump-table.json` records 444 valid intersegment entries and their resource-relative
targets. This is an entry-point map, not a count of all application functions.
The startup main slot at A5+0x01ba resolves to CODE 11 resource offset 3198.
`scripts/map_jump_table.py` checks entry structure and target bounds; it does not
prove instruction boundaries or function semantics. All offsets include the
four-byte CODE segment header. See `THINK-C-EVIDENCE.md` for current startup proof.
The latest disposable QEMU session has been terminated after saving its captures.

1. Audit all resource extracts, address conventions and inherited disassembly
   against the corrected native-fork inventory. Mark conjecture versus verified facts.
2. Recover candidate THINK/Lightspeed C, MPW C and Symantec runtime distributions.
   A bounded filename search of T7 found no compiler distribution yet.
3. Compare startup, integer helpers, switch lowering, SANE calling convention,
   DATA/ZERO compression, DREL and CODE 0 layout. Keep versioned hashes and
   distinguish library revisions from compiler revisions.
4. Trace the real startup writer and replay its decompression/relocations in
   readable source, comparing against memory immediately before application init.
5. Build a function/global/type map with resource-relative addresses and a live
   resolver. Reconstruct modules progressively, with original-runtime differential
   traces for normal play, search, endgames, file I/O, UI and exceptional paths.
6. Rebuild an application. Verify cold starts and full games before calling the
   decompilation complete. Retain SANE precision and actual integer/ABI behavior.

## Historical sources consulted

These are contemporary first-hand discussions, not proof of Maven's toolchain:

- [THINK C 5.0 review](https://preserve.mactech.com/articles/mactech/Vol.07/07.09/ThinkC5.0/index.html): compiler options and floating-point/runtime choices.
- [Symantec THINK 6 discussion](https://preserve.mactech.com/articles/mactech/Vol.09/09.08/Aug93Think10/index.html): differing default integer and floating-point options between THINK C and Symantec C++.
- [Apple developer article on standalone globals](https://preserve.mactech.com/articles/develop/issue_12/Rollin_final.html): globals and startup conventions depend on toolchain and output kind.
