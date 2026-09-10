# Whole-file loader

CODE 47 [0x25c,0x2ee), callable at A5+0xd3a, is reconstructed in whole_file.c.
Aligned callers occur in CODE 2+0x104, CODE 15+0x1a, and CODE 9+0xe6.
The CODE 15 caller is the dictionary/index loading path and is a useful next
natural startup capture target. These caller matches are static evidence.

Operation offsets: FSOpen at 0x276; GetEOF at 0x28a; NewPtrClear trap at
0x29a; FSRead at 0x2b0; GetPtrSize at 0x2bc; FSClose at 0x2ce; NUL store
at 0x2da; DisposePtr at 0x2e2. Error results are tested immediately after
each returning Toolbox wrapper. GetPtrSize returns a long on the Pascal stack.

The caller supplies a mutable 32-bit length pointer. GetEOF initializes it;
FSRead may change it. The code compares the allocation size with the updated
length plus one, then writes the trailing zero at that updated index. The
addition is original 32-bit ADD.L, including wraparound.

The file is only closed after a successful read and allocation-size check.
GetEOF or allocation failure returns NULL without a close. Read or size-check
failure disposes the buffer without a close. Close failure also disposes the
buffer. These historical error paths are preserved, not recommended behavior
for a new filesystem implementation.

Host tests exercise success, open/GetEOF/allocation/read/close failure, and a
successful short read. They assert full callback order and disposal/close
effects. They do not execute original guest instructions. A natural startup
trace must still verify loaded CODE 47 bytes, arguments, all operation results,
final buffer bytes/hash, and the caller-visible length and return pointer.

## Natural startup capture

`whole-file-live.json` now records the natural call following a fresh startup.
Complete loaded CODE 47 matched the extracted resource. Maven opened
`maven2.1` on volume reference zero; GetEOF and FSRead reported 1,070,788 bytes;
GetPtrSize reported 1,070,789; FSOpen/GetEOF/FSRead/FSClose each returned zero.
The returned buffer's first 1,070,788 bytes matched the original data fork's
SHA-256 `2619382321bca5b52967b3515d15b0592a8e1f641bce92f65edcf06ba10edb19`,
and the next byte was zero. No function calls, arguments, registers, or data
were injected. The initial length before GetEOF was uninitialized caller
storage and must not be interpreted as a valid requested length.

The recorder is capture_whole_file.py, run after capture_startup.py. This
verifies the original success-path behavior. Original error paths remain
separate work.

`replay_whole_file.py` now executes whole_file.c against a native filesystem
adapter using the recorded name, volume, and initial output storage. It checks
the captured resource/data hashes before replay and compares the six-operation
order, output length, allocation size, all returned bytes, and final NUL.
The result in whole-file-replay.json matches. The host adapter uses a synthetic
file reference and native allocation; guest addresses and Toolbox internals
are outside this equivalence claim.
