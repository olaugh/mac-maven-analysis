# Recovered THINK C runtime and comparison build

## Observed result

Update: **THINK C 6.0.1 has now been installed and used to compile, link and run
the same probe. Its emitted CODE 1 startup body is identical to Maven's entire
566-byte body**, not just the shared 506-byte helper block. See the 6.0.1
comparison section below. This explains the extra callback thunk absent from
the 5.0.2 default build. Exact original release attribution is still unproven.

The preserved distribution identifies itself as **THINK C 5.0.2** in its `vers`
resource and bundled READ ME. It has been recovered, its libraries extracted by
their original self-extractor under Mac OS 8, and its compiler and linker used
successfully to build `reconstruction/toolchain_probe.c`.

Maven CODE 1 bytes [0x0048,0x0242) match a continuous **506-byte** block at
[0x0034,0x022e) in both the THINK C application and the newly compiled probe's
CODE 1. This covers global initialization and the switch/integer helpers.
The fingerprint is reproduced by `scripts/fingerprint_think_runtime.py` and
recorded with input hashes in `think-c-fingerprint.json`.

This is strong evidence for the THINK runtime/toolchain family. **The original
compiler version and linker version are not uniquely identified.** Shared runtime
code can survive multiple releases or be linked into independently compiled code.
We still need comparison builds for earlier/later releases and source-level
code-generation fingerprints to distinguish those possibilities.

Maven's startup has an additional longword, a call, and a small callback thunk;
its 578-byte CODE 1 is 20 bytes larger than the probe's 558-byte CODE 1. We have
now reproduced that layout with a default THINK C 6.0.1 project. See below.

## Acquisition and provenance

Source: [Internet Archive item think_c_5](https://archive.org/details/think_c_5).
All four image SHA-1 hashes match the item's metadata, preserved locally as
`media/maven/toolchains/think-c-5/archive-metadata.json` (relative to Aviary root).
SHA-256 hashes are additionally recorded in `think-c-fingerprint.json`.

The original product's `vers` bytes decode to version 5.0.2. Its READ ME is dated
January 10, 1992 and identifies the package as 5.0.2. This is evidence from the
distribution itself, rather than relying on the download item's short title.

The `.img` files are read-only source artifacts in `media/maven/toolchains/think-c-5`.
`files/` holds disk contents with native Mac forks and Finder metadata. `installed/`
contains the libraries/headers extracted in the emulator. The active test copies
and generated project/application are in `media/maven/session/share/THINK C 5`.
The 9P driver uses `.idump` and `.rdump` sidecars, so these are retained too.
machfs 1.3 and macresources 1.2 were installed only into `/tmp/maven-tools-venv`
for disk reading and sidecar generation; Maven analysis scripts use the standard
library unless otherwise documented.

## Actual compile/link/run experiment

1. Launch the recovered THINK C executable through Finder.
2. New project `Toolchain Probe`; Source → Add `probe.c`.
3. Project → Build Application; confirm Bring Up To Date; save `Probe App`
   with Smart Link enabled. No external library was added.
4. Quit the compiler and launch `Probe App` from Finder.
5. Pause via QMP; attach GDB; read the target's registers and globals. Verify
   the entire loaded CODE 2 against the generated application's resource.

The probe uses volatile inputs, preventing constant folding. It loops after
finishing so its results can be inspected without adding an output library.
The input globals are 0x12345678 and 0x00010003. Observed results are:

| Operation | Observed value |
|---|---:|
| Low 32-bit product | 0x8d150368 |
| Unsigned quotient | 0x00001234 |
| Unsigned remainder | 0x00001fdc |
| Completion flag | 1 |

All agree with the known source. The main function is 58 bytes plus the 4-byte
CODE 2 header. It calls the runtime through A5-relative jump-table slots. Its
initialized globals are eight DATA bytes followed by fourteen zero bytes;
the encoded DATA resource contains a trailing zero word and ZERO supplies
the remaining twelve-byte run. The compiled application has a zero-length DREL.
See `think-c-probe-live.json` for the actual session addresses and full data read.

This proves a functioning comparison compiler/linker and successful generated
code execution. It does not yet prove byte-identical rebuilding of Maven or
its original optimizer settings.

## Resource audit expansion

The same DeRez-comment bug also truncated **16 non-CODE resources**. These are
now regenerated from the corrected parser, with changes recorded in
`additional-extraction-corrections.json`. Particularly consequential corrections:

- DATA: 4,608 → 9,472 bytes.
- EXPR: 96 → 8,960 bytes.
- PATB: 688 → 18,104 bytes.
- MULd and MULt: now the complete 224 bytes each.

Any analysis relying on the previously incomplete evaluation tables needs
revalidation. Regeneration does not retroactively validate those conclusions.

## Global initializer reconstruction

`reconstruction/global_initializer.c` reproduces word copying, ZERO byte runs,
and signed DREL offsets in a big-endian guest byte buffer. It processes Maven's
complete 28,654-byte below-A5 area and 189 relocation entries at a nonzero
synthetic A5 address, and reproduces the probe's 22-byte initial global layout.

Two original-runtime captures now support this reconstruction. The debugger
identified startup through the current GetResource trap handler, then verified
all 578 bytes of loaded CODE 1 before stopping at the writer's return instruction
(resource offset 0x00a8). A5 and the low-memory below-A5 pointer were read from
the running guest. No calls, input values, registers or memory were injected.

The compiled C reconstruction matched all **28,654 bytes**, including all
**189 relocations**, on both launches. The initial regions differed (189 and
246 distinct byte values; 10,315 and 8,691 bytes changed respectively), while
both final regions had SHA-256
`850b830d650480735e25f83d219f9c5f9297b1d433f46ce6b69344cd8598f675`.
These were two launches in one disposable boot, not different OS configurations.
See `startup-live.json` and `startup-repeat-live.json`.

Reproduce with `scripts/capture_startup.py --output-dir CAPTURE --launch-selected`
after visibly selecting Maven in Finder, then run
`scripts/verify_startup.py CAPTURE`. The latter compiles the C implementation
and compares against the saved before/after snapshots. Capturing unrelated
Finder resource calls is not evidence that Maven launched. The capture has a
wall-clock deadline in addition to a resource-call limit.

The original performs unchecked memory operations; the host reconstruction adds
error checks and currently accepts relocations into the below-A5 buffer only.
That covers all Maven DREL offsets, ranging from -28,632 through -1,140.

## Inline header fingerprints

The recovered `C Libraries/headers/setjmp.h` supplies explicit instruction arrays
for setjmp and longjmp, selected by the `mc68881` and `int_4` compiler options.
`scripts/fingerprint_inline_runtime.py` extracts those arrays from the header
itself and scans even resource offsets in all corrected CODE resources. The
header and matching CODE hashes are in `inline-runtime-fingerprint.json`.

Results: nine exact non-mc68881 setjmp sequences and 21 exact non-int_4 longjmp
sequences; no matches for either alternative. The main entry's context save at
CODE 11+0x0ca8 is one of these matches. This independently corroborates the
THINK header/runtime family and the 44-byte saved context, using original
header definitions rather than inferred register-save conventions.

At these sites, setjmp saves no FP registers and longjmp tests its return value
as a 16-bit word. This does not prove that all compilation units use the same
options, rule out other floating-point code elsewhere, or uniquely identify
the compiler release: these header sequences can be shared between releases.

A restore path is visible at CODE 15+0x0028: it assigns the error value from
A5-24792 to A5-24030, decrements the context count at A5-23674, selects the
44-byte context at A5-24026 + count*44, sets D0=1, and executes the exact
16-bit longjmp sequence at offset 0x0042. This explains why main's nonlocal
error branch does not itself decrement the count. Its actual error trigger and
runtime execution still need tracing; this is a static identification.

The additional startup callback thunk in Maven was not found verbatim in the
recovered THINK C 5 files or decoded sidecar resources. This negative byte
search does not exclude an equivalent implementation or configurable template.

## THINK C 6 comparison distribution

The four THINK C 6.0.1 installer disks were recovered from
[WinWorld](https://winworldpc.com/product/think-c/6x). The disk's own READ ME
identifies THINK C 6.0.1 and is dated October 14, 1993. Archive and image hashes
are recorded in `think-c-6-acquisition.json`; these are locally computed hashes,
not independently authenticated publisher checksums. The distribution uses
Apple Installer plus VISE compression. Installation, compilation, linking and
probe execution have now succeeded in the disposable Mac OS 8/QEMU session.

The installer requires the original `disk 1` through `disk 4` volume names.
A combined shared folder was insufficient; multiple extra 9P shares failed
during boot, and raw HFS CD images were not recognized. The working method was
to repack the original files behind the known-working disk's partition map and
SCSI drivers. `scripts/prepare_think6_media.py` verifies every original file's
data/resource forks, type and creator after repacking. Run with the isolated
machfs Python environment and `--driver-template media/maven/hds/macos8.img`
(adjust relative paths to the current directory). Then launch with
`MAVEN_THINK6_INSTALLER=1 bash scripts/launch_debug_session.sh`.

The generated media are under `media/maven/toolchains/think-c-6/hfs-media`;
hashes are in `think-c-6-mounted-media.json`. All guest disk writes used snapshot
mode. Easy Install to the temporary `untitled` disk completed successfully.
Finder copied Development to the shared disk; its preserved copy is under
`toolchains/think-c-6/installed`. The project manager and THINK C translator both
carry original `vers` resources identifying 6.0.1.

### Startup and emitted-code comparison

The recovered project manager's CODE 1 is 578 bytes, exactly Maven's length.
Only byte 7 differs: it belongs to the program-specific main-entry A5 offset
(0x0142 for the manager versus 0x01ba for Maven). All bytes from offset 12 onward
are identical, including the formerly unexplained callback thunk. Record:
`think-c-6-startup-fingerprint.json`.

A new `Toolchain Probe 6` project added `probe.c`, used Build Application with
Smart Link enabled, and included no external library. Its 578-byte CODE 1 also
matches Maven except the main-entry field (probe 0x0072 versus Maven 0x01ba).
Its 62-byte CODE 2, including the header and 58-byte main function, is identical
to the earlier THINK C 5.0.2 probe's CODE 2. Record: `think-c-6-probe.json`.

The generated `Probe App 6` was launched from Finder. GDB verified all loaded
CODE 2 bytes, then read globals at the real A5. Results were product 0x8d150368,
quotient 0x00001234, remainder 0x00001fdc, completion flag 1, for inputs
0x12345678 and 0x00010003. No register or memory values were injected. Project,
source and output sidecars are preserved under `toolchains/think-c-6/comparison-build`.
The disposable emulator was then terminated.

This establishes a working compiler/linker that reproduces Maven's startup
template exactly, with the expected application-specific pointer difference.
It does not uniquely distinguish 6.0.1 from releases sharing the same template,
identify every original project option, or prove identical application code
generation beyond the probe. The probe's identical 5.0.2/6.0.1 main code is
evidence that a small arithmetic example alone cannot distinguish those compilers.

### Application call-site survey

`scripts/map_runtime_calls.py` scans corrected CODE resources for aligned
JSR/JMP instructions using the known A5 startup-helper slots. The resulting
`runtime-call-candidates.json` retains per-resource hashes and surrounding
bytes for manual control-flow auditing. It finds 91 multiplication candidates,
26 unsigned quotient candidates, 8 unsigned remainder candidates, 85 signed
quotient candidates and 4 signed remainder candidates: 214 in total.

No direct A5-relative JSR/JMP candidate targets the three switch helpers.
That does not prove the helpers are unused: other call forms, local runtime
copies and computed control flow are outside the scan. Conversely, aligned
opcode matches can occur in inline data; these counts are not validated
function calls or a coverage metric. Startup-template inclusion alone cannot
establish the compiler's switch-lowering choices. This inventory supplies
specific application sites for broader recovered-compiler comparison beyond
the already verified small arithmetic probe.

### Audited inline switch dispatch

The format switch in CODE 24 at +0x0b9c uses inline dispatch rather than
calling the startup switch helpers. It subtracts 0x003f from the 16-bit
selector, performs an unsigned comparison against 0x0039, loads table
+0x1394 PC-relatively, doubles the index, adds a signed word from the table
to its base, and jumps through that address register. The table contains
58 entries for character values 63 through 120 and ends at +0x1408.

`scripts/map_scanner_switch.py` checks the exact dispatch bytes and decodes
all entries into `scanner-switch-table.json`. The 20 nondefault character
entries agree with recovered `scanf.c`: modifiers `?`, `h`, `l`, `L`, numeric
and string conversions, and shared floating/hex branches. Other entries and
out-of-range values go to +0x0dfc. This is an audited application code-generation
example, not merely a linked startup template. Reproducing this lowering
with candidate compiler settings remains to be done; its presence alone
does not uniquely distinguish THINK releases.

`scripts/map_inline_switches.py` finds eight instances of that exact A1/D0
encoding across CODE 3, 11, 20, 21 and 24. The tables contain 12, 9, 16, 6,
17, 30, 52 and 58 entries (200 total). All table bounds, signed displacement
targets and default targets are inside their original resources, and all
entry targets are word-aligned. `inline-switch-candidates.json` records each
table, comparison, default branch, context and resource hash.

This broader survey strengthens the usefulness of the pattern for comparison
builds and identifies inline-data ranges for disassembly. It still recognizes
only one lowering variant; incoming control flow and selector normalization
have not been audited at every site. Apart from the separately audited scanner
format switch, these remain static switch candidates rather than live-verified
dispatches or a complete inventory of application switches.

### Exact SysEnvirons library match

Maven CODE 34+0x003a..0x01a4 (362 bytes) exactly matches recovered THINK C
6.0.1 `Mac Libraries/MacTraps` CODE 2 at offset 116. The same complete block
occurs in the bundled SourceServer CODE 1 at offset 27430. Evidence and
resource hashes are in `sysenvirons-library-fingerprint.json`.

The block includes trap-availability detection, native SysEnvirons dispatch,
the old-machine fallback, keyboard mapping bytes 03 13 0B 02 01, and the
fallback volume probe containing ERIK. This is a full byte match, not a
heuristic match on the embedded constant. A search of 775 preserved data
forks found no match; parsing 3,699 resources from installed rdump sidecars
found the two matches above. A lack of additional matches in the preserved
files is not proof that other THINK releases lacked this glue.

This identifies a concrete supplied library implementation in Maven and
supports the existing THINK runtime attribution. It does not establish that
the entire application was compiled with precisely 6.0.1: compatibility glue
can persist across releases and be linked into differently compiled code.

### CODE 34 correspondence to MacTraps

`scripts/compare_mactraps.py` compares Maven CODE 34 against recovered
MacTraps CODE 2. Fifteen ordered exact blocks of at least 16 bytes account
for 1,353 of the 1,388 bytes after Maven's segment header. The three gaps
are only 12, 14 and 9 bytes; each also has an exact occurrence in MacTraps
(offsets 1224, 2350 and 4325). Thus every post-header byte is accounted for
by exact matching blocks, without needing to explain a changed byte as a
relocation. The separate blocks reflect omitted material between them in
the larger library, not a contiguous full-segment match.

`mactraps-code34-comparison.json` retains the maps and both resource hashes.
This strongly identifies CODE 34 as selected MacTraps library content,
including the Pascal-string and scrap-transfer wrappers already reconstructed.
It does not prove function boundaries from short matches, identify all linker
selection rules, or establish a unique compiler release. Library symbol and
relocation metadata remain to be decoded before claiming a reproduced link.

The ranges have now been checked for complete, ordered, nonoverlapping
coverage and recorded in `code34-library-recipe.json`. Running
`scripts/assemble_library_segment.py` with that recipe and the recovered
MacTraps rdump reconstructs all 1,392 bytes of CODE 34, including the supplied
four-byte header 0AE0001F. The resulting SHA-256 is
`891d3d98ce59b26f24c5d7396e7703896ff332d203a0a7ac7d58a33ba58ae01a`,
and a direct comparison with the original resource passes. The assembler
does not read Maven's CODE resource when constructing its output.

This establishes an exact segment assembly from 18 selected library ranges.
The selection recipe and header were derived from the existing application;
they are not a recovered project or independently inferred linker algorithm.
Symbol-driven selection, segment-header generation and relocation handling
remain open requirements for reproducing the original link process.

### Segment-header rule verified across all segments

The four-byte nonzero-CODE header is two big-endian words: first jump-table
entry index multiplied by eight, followed by the number of entries belonging
to the segment. All 52 nonzero CODE resources satisfy this rule, with each
segment's entries contiguous in CODE 0. Results are recorded in
`segment-header-derivation.json`. The first word excludes CODE 0's configured
32-byte A5 jump-table offset; CODE 34 is index 348 * 8 = 2784, count 31.

The library assembler now requires `--jump-table` and derives this header
from entry grouping instead of accepting literal header bytes. Reassembling
CODE 34 still matches all 1,392 original bytes. The previously stated open
header-generation requirement is therefore resolved for the observed segment
format. Generating the jump table itself from recovered symbols, and selecting
library code without the post-hoc range recipe, remain unfinished.

### Library project records are not a linked application table

An attempt to apply Maven's linked CODE 0 interpretation directly to MacTraps
failed its instruction checks. The library header describes 288 eight-byte
records: ten are normal 3F3C/A9F0 stubs, 277 have only their first offset word
populated, and the final record has another form. These unresolved records
must not be treated as direct CODE 2 addresses. The library additionally
contains ZONE, INDX, KIND, SYMS and CREL metadata needed to resolve them.

`mactraps-project-structure.json` preserves the raw record classification and
resource hashes/sizes. This supersedes the assumption that library entry
selection can be obtained by parsing its CODE 0 exactly like Maven's linked
application. The exact CODE 34 byte reconstruction remains valid; converting
it to symbol-driven linking requires decoding the project metadata first.
