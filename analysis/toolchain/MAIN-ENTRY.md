# Application entry-point audit

Static evidence: corrected CODE resources and recovered THINK C 5.0.2 Macintosh
headers. The unload routine now has a differential argument trace; the other
application paths below remain supported by static evidence only.
Offsets include the four-byte segment header. See `main-entry-disassembly.txt`
for instructions and the CODE 11 hash.

CODE 1 calls A5+0x01ba, which CODE 0 maps to CODE 11+0x0c7e. This establishes
the entry point independently of inherited function-name guesses.

## Entry sequence, CODE 11 [0x0c7e,0x0d4c)

1. Allocate a 282-byte frame. Validate the word at A5-23674 as an index in
   0..7, calling A9FF (debugger trap) on failure. The trap can return; treating
   this instruction as an unconditional process abort would change semantics.
2. Increment the index. At A5-24026 + old_index*44, save D3-D7, A1-A4, A6
   and SP. A1 holds the resume address 0x0cb2 and D0 is zero. This is an inline
   nonlocal-return context save. Nonzero D0 at the resume address branches to
   0x0d3a. It exactly matches the recovered THINK `setjmp.h` non-68881 inline
   sequence. CODE 15+0x0028 is one identified restore path: it decrements the
   count before selecting the 44-byte record and executing the header's
   16-bit longjmp sequence at +0x0042. Runtime error-path tracing is pending.
3. Call A5+0x030a (CODE 15+1234); its full initialization behavior is pending.
4. Call A5+0x0b8a (CODE 34+996) with two local word addresses. Its argument
   order and instructions match `CountAppFiles(message, count)` in `SegLoad.h`.
5. For each one-based launch-file index, call A5+0x0b92 (CODE 34+1032,
   `GetAppFiles`) to populate a local AppFile. For type `XGME`, pass the Pascal
   filename and volume reference to A5+0x05aa (CODE 22+716). The callee's full
   behavior remains unverified. Always call A5+0x0b9a (CODE 34+1102,
   `ClrAppFiles`) for that index.
6. If the launch message is not 1, call CODE 11+0x10ee. On return, call
   ChangedResource on the handle at A5-8584, check ResError, invoke the debugger
   trap on error, then call UpdateResFile(CurResFile()).
7. Normal completion decrements the context index. The nonlocal error branch
   instead passes the long at A5-24030 to A5+0x0c7a (CODE 41+568). Both branches
   call A5+0x0662 (CODE 9+3752) and return. Do not assume host setjmp/longjmp
   equivalence until the original restore path has been traced.

The launch-message comparison at 0x0cf2 has no conditional branch consuming
its flags before later instructions overwrite them. It must not be translated
into invented behavior; it may be residual compiler output.

## Corrected unload block

CODE 11 [0x0d4c,0x0da8) has fifteen PEA/A9F1 pairs followed by RTS.
The recovered `SegLoad.h` declares `UnloadSeg(void *routineAddr) = 0xA9F1`.
This unloads segments; it does not “register 15 handlers” as inherited notes say.
`reconstruction/segment_management.c` preserves argument values and call order,
with an explicit Toolbox adapter boundary.

The jump slots resolve to CODE resources 44, 42, 43, 27, 29, 30, 45, 40, 36,
53, 37, 39, 31, 28, 32. All point to resource offset 4 except CODE 36, offset
6160. UnloadSeg accepts a routine address within the segment.

## Live unload validation

`scripts/capture_segment_unloads.py` locates UnloadSeg through the guest's
Toolbox table at 0x15c4, verifies the debugger register layout and ROM identity,
and accepts the first caller only after the entire loaded CODE 11 matches the
corrected resource. This launch used CODE 11 base 0x07b307a0 and A5 0x07cf5500;
these are observed addresses, not constants for future capture.

All fifteen natural trap entries had the expected return PCs and A5-relative
arguments. Compiling `segment_management.c` and collecting its adapter calls
produced exactly the same sequence. No register, memory or call injection was
used. See `segment-unloads-live.json` for all actual arguments and the code hash.
The last capture stops at the fifteenth trap entry, so this proves call issuance
and argument order, not the OS's eventual memory-release behavior.

Next: observe main entry, launch-file values, and the
nonlocal restore path under the debugger. Audit the called initialization,
state-loop and termination routines. Inherited HIGH confidence labels do not
substitute for that evidence.
