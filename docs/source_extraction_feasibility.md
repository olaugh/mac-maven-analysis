# Source Code Extraction Feasibility Assessment

## Executive Summary

Maven is a Classic Macintosh Scrabble AI application (type APPL/MAVN) consisting of
55 CODE resources totaling approximately 96 KB of Motorola 68000 machine code, plus
a 1,070,788-byte DAWG dictionary in the data fork and approximately 65 resource types
in the resource fork. This document assesses three approaches to extracting
recompilable source code from the existing binary, given the current state of reverse
engineering analysis.

**Bottom line**: Full recompilation targeting the original Classic Mac platform is
theoretically possible but practically infeasible as a one-person effort, requiring
an estimated 2,000+ hours of manual hex verification and C writing. A modern platform
port of the core AI engine is the most productive path, leveraging the existing C
decompilations as verified pseudocode. Binary patching remains viable for targeted
modifications to the original binary.

---

## 1. Current State of Reverse Engineering

### 1.1 CODE Resource Inventory

Maven contains 53 CODE resource files (IDs 0-54, with gaps at 26 and 33). CODE 0 is
the 3,564-byte jump table, not executable code. The remaining 52 segments contain
executable 68000 instructions.

| Metric | Value |
|--------|-------|
| Total CODE resource bytes | 96,054 |
| Total CODE segments (executable) | 52 |
| Total functions identified | ~500 |
| Segments with detailed analysis | ~12 |
| Segments with C decompilations | ~10 |
| Functions with verified hex-level C decompilation | ~80 |
| Functions with only automated disassembly | ~420 |

### 1.2 Segments with Deep Analysis

The following segments have detailed, hex-verified analyses with partial or complete
C decompilations:

| CODE | Size | Functions | Purpose | Decompilation Coverage |
|------|------|-----------|---------|----------------------|
| 3 | 4,390 | 16 | DAWG search coordinator, move generation pipeline | ~60% |
| 11 | 4,478 | 31 | Game controller, event dispatcher, lexicon manager | ~70% |
| 15 | 3,568 | 18 | DAWG traversal, pattern matching, MUL loading | ~50% |
| 30 | 3,492 | 22 | Alpha-beta search tree, coroutine state management | ~80% |
| 32 | 6,464 | ~20 | Leave evaluation, binomial MUL weighting, V/C balance | ~85% |
| 35 | 3,276 | 7 | Score calculation, SANE floating point integration | ~75% |
| 36 | 9,102 | 15 | Move evaluation coordinator, score caching pipeline | ~60% |
| 37 | 5,344 | 18 | Cross-check generation, Appel-Jacobson move gen | ~70% |
| 39 | 1,784 | 5 | Letter combination synergy scoring | ~65% |
| 46 | 2,904 | 25 | Custom WDEF window manager, QuickDraw rendering | ~50% |

These 10 segments account for approximately 44,800 bytes (47% of total code). The
remaining 42 segments have automated disassembly-level analysis only, which is
unreliable (see section 1.3).

### 1.3 Disassembler Reliability

The automated disassembler used for initial analysis produces systematically
incorrect output for 30+ instruction patterns. This is the single largest obstacle
to source extraction. The disassembler appears to be a general-purpose tool not
designed for 68000 Mac code, and it fails on instruction patterns that are extremely
common in Mac C compiler output.

**Affected instruction classes:**

| Correct Instruction | Disassembler Output | Frequency |
|---------------------|---------------------|-----------|
| `MULS.W #imm,Dn` | `ANDA.L #imm,An` | Very high (structure indexing) |
| `ADDA.W Dn,An` | `MOVE.B Dn,(An)+` | Very high (pointer arithmetic) |
| `ADDQ.L #n,A7` | `MOVE.B A7,(An)` | Very high (stack cleanup) |
| `ASL.L #n,Dn` / `LSL.L` | `ASL.B` or mangled | High (array indexing) |
| `ADDQ.W #1,d16(A5)` | `MOVEA.B ...,A1` | High (global increments) |
| `SUBQ.W #1,d16(A5)` | `MOVE.B ...,imm(A1)` | High (global decrements) |
| `MOVEM.L regs,(A0)` | `DC.W` or garbage | High (register save/restore) |
| `MOVEM.L (A0)+,regs` | `DC.W` | High (register restore) |
| `ADD.L An,Dn` | `MOVE.B An,(An)` | Medium |
| `CMP.L d16(A5),Dn` | `MOVE.W ...,(A0)` | Medium |
| `DIVS.W #imm,Dn` | `ORA.L #...` | Low-medium |
| `SUB.L An,Dn` | `MOVE.B An,(An)` | Low-medium |

Every function in every CODE resource must be manually verified against the raw hex
bytes using the Motorola 68000 Programmer's Reference Manual instruction encoding
tables. A single function of 50 instructions typically takes 30-60 minutes to fully
verify, identify all operands, determine data flow, and write equivalent C.

### 1.4 Data Structures Identified

The reverse engineering has identified the following key data structures, all defined
implicitly through A5-relative global offsets and stack frame layouts:

| Structure | Size | Location | Confidence |
|-----------|------|----------|------------|
| Move | 34 bytes | Stack / heap | HIGH |
| DAWGInfo | 34 bytes | A5 globals / stack | HIGH |
| SearchEntry | 46 bytes | Stack (CODE 3) | HIGH |
| SearchNode (alpha-beta) | 32 bytes | Heap pool (CODE 30) | HIGH |
| CacheEntry | 66 bytes | Heap (CODE 36) | HIGH |
| PositionRecord | 8 bytes | Heap table (CODE 35) | HIGH |
| ESTRRecord | 18 bytes | Resource data (CODE 39) | HIGH |
| WindowRecord (extended) | ~152 bytes | Mac Toolbox + custom fields | MEDIUM |
| SearchContext (coroutine) | 44 bytes | A5-24026 array (CODE 30) | HIGH |
| DAWGSection | 8 bytes | A5-11960 array (CODE 15) | HIGH |
| DispatchNode | variable | Linked list (CODE 11) | MEDIUM |

### 1.5 Global Variable Map

Maven uses A5-relative negative offsets for all global variables, which is the
standard convention for THINK C and MPW C on 68000 Macs. The analysis has identified
approximately 200 individual global variables across the analyzed segments, spanning
the range A5-27912 to A5-1318.

This implies the A5 global area is at least 27,912 bytes. The full layout has not
been mapped -- many segments have only automated analysis and their global references
are buried in incorrect disassembly output.

### 1.6 Jump Table

CODE 0 contains a 3,564-byte jump table with entries dispatching to functions across
all segments. The analysis has identified approximately 100 distinct jump table
offsets used across the analyzed segments. The total number of JT entries is
approximately 450 (3,564 / 8 bytes per entry). Each JT entry is an 8-byte record:
2-byte offset within segment, 4-byte `_LoadSeg` trap address, 2-byte segment ID.

### 1.7 Resource Dependencies

Maven's resource fork contains approximately 65 resource types. Key resources that
the code directly references:

| Resource Type | Count | Purpose | Code References |
|---------------|-------|---------|-----------------|
| MUL (a-z, ?) | 27 | Per-tile leave values (8 records x 28 bytes) | CODE 15, 32 |
| ESTR | ~6 | Letter combination scoring tables (128 x 18 bytes) | CODE 32, 39 |
| VCB (a-h) | 8 | Vowel/consonant balance data | Not used at runtime |
| PATB | 1+ | Board patterns | CODE 46 |
| EXPR | 1+ | Expression/format data | CODE 32, 36 |
| MENU | multiple | Menu bar definitions | CODE 11 |
| WDEF | 1 | Window definition (custom) | CODE 46 |
| FRST | 1 | Font/string resource | CODE 32 |
| ZERO | 1 | Zero-filled initialization data | CODE 2 |

---

## 2. Architecture Challenges for Recompilation

### 2.1 A5-Relative Global Variables

All global variables are accessed through negative offsets from register A5. This is
a fundamental architectural feature of 68000 Mac compilers (THINK C, MPW C,
CodeWarrior). The compiler allocates all globals in a contiguous block and accesses
them via `d16(A5)` addressing mode, which supports offsets from -32768 to +32767.

**The problem**: If source code is recompiled, the compiler assigns A5 offsets to
globals in the order it encounters them. Unless the declaration order and compilation
unit order are reproduced exactly, the A5 layout will differ. This matters because:

- All CODE segments share the same A5 base. A global at A5-11960 in CODE 37 is the
  same physical memory as A5-11960 in CODE 15. If recompilation assigns different
  offsets, cross-segment global references will break silently.
- The jump table entries encode segment IDs but not A5 offsets. Inter-segment calls
  work correctly regardless of A5 layout, but shared globals do not.

**Mitigation**: Define all globals in a single header file as a large struct,
ensuring deterministic layout. Alternatively, abstract all global access through
accessor functions.

### 2.2 SANE Floating Point

Maven uses Apple's SANE (Standard Apple Numeric Environment) library for 80-bit
extended precision floating point arithmetic. This is accessed via the A9EB trap
(`_FP68K`), which pops an opcode word and operand pointers from the stack.

CODE 32 and CODE 35 contain heavy SANE usage (22 A9EB traps in CODE 35 alone).
The operations include:

- Extended precision add, subtract, multiply, divide
- Int16/Int32/Comp to extended conversion and back
- Truncation to integer (FTINT), rounding (FRINT)
- Negation (FNEG), absolute value (FABS)
- Comparison (FCMP) setting condition codes

**The problem**: No modern C compiler produces SANE code. IEEE 754 64-bit double
is the universal standard. The 80-bit extended format has different precision,
range, and rounding behavior. Maven's leave evaluation computes binomial-weighted
averages in extended precision, and differences in rounding could produce different
AI behavior.

**Mitigation**: For a Classic Mac recompilation, SANE is available through the
Toolbox. For a modern port, replace SANE with `long double` (which is 80-bit on
x86) or accept minor floating-point differences. The leave evaluation algorithm
is well-understood and could be reimplemented in IEEE 754 with negligible gameplay
impact.

### 2.3 Mac Toolbox Traps

Maven uses 100+ different A-line traps across its codebase. CODE 46 alone contains
120+ QuickDraw and Window Manager trap calls. These fall into several categories:

**Memory Management**: `_NewPtr`, `_DisposPtr`, `_NewHandle`, `_DisposHandle`,
`_GetHandleSize`, `_HLock`, `_HUnlock`, `_BlockMove`

**Window Manager**: `_NewWindow`, `_NewCWindow`, `_ShowWindow`, `_HideWindow`,
`_SelectWindow`, `_FrontWindow`, `_BringToFront`, `_SendBehind`, `_DrawBehind`,
`_HiliteWindow`, `_GetWMgrPort`

**QuickDraw**: `_MoveTo`, `_LineTo`, `_Line`, `_Move`, `_PenSize`, `_DrawString`,
`_FrameRect`, `_InsetRect`, `_FillRect`, `_ScrollRect`, `_SetPort`, `_GetPort`,
`_ForeColor`, `_BackColor`, `_NewRgn`, `_DisposeRgn`, `_CopyRgn`, `_RectRgn`,
`_DiffRgn`, `_PtInRect`, `_GlobalToLocal`, `_LocalToGlobal`

**Event Handling**: `_GetNextEvent`, `_WaitNextEvent`, `_SystemClick`

**Resource Manager**: `_GetResource`, `_GetIndResource`, `_CountResources`,
`_ReleaseResource`, `_HomeResFile`

**Menu Manager**: `_GetMenuHandle`, `_InsertMenu`, `_DeleteMenu`, `_DrawMenuBar`,
`_HiliteMenu`, `_MenuSelect`

**Dialog Manager**: `_GetDialogItem`, `_SetDialogItem`, `_Alert`

**SANE**: `_FP68K` (A9EB)

**The problem**: For Classic Mac recompilation, these are all available. For a modern
port, every trap call must be replaced with equivalent modern API calls or
eliminated entirely.

### 2.4 Segment Loading

The Mac Segment Loader automatically loads CODE resources into memory on demand
via the jump table. When a cross-segment call is made through the JT, the Segment
Loader checks whether the target CODE resource is loaded, loads it if not, patches
the JT entry to point directly to the loaded code, and transfers control.

CODE segments can also be unloaded to free memory (`_UnloadSeg`). Maven's 52
executable segments would have been loaded and unloaded dynamically on the 1-4 MB
Macs of the era.

**The problem**: A recompiled version must either maintain the same segment
structure (requiring the same compiler and linker configuration) or merge all
segments into a single code block (eliminating the need for segment loading but
changing the memory model).

### 2.5 Coroutine/setjmp Pattern

CODE 3 and CODE 30 implement a setjmp/longjmp-like coroutine mechanism using
MOVEM.L to save and restore 11 registers (D3-D7, A1-A4, A6, A7) into 44-byte
stack entries at A5-24026. This enables the alpha-beta search to suspend and
resume at arbitrary points.

Register mask DEF8 saves D3, D4, D5, D6, D7, A1, A2, A3, A4, A6, A7. Register
D0 carries the first-call/restored discriminator (0 for initial call, 1 for
restore). Register A0 is the entry pointer. A5 is the global base, never saved.

**The problem**: This pattern relies on intimate knowledge of the register
allocation convention. A C compiler's setjmp/longjmp will save a different register
set. Rewriting this requires understanding every function that participates in the
coroutine protocol.

**Mitigation**: The coroutine pattern is well-documented in the CODE 3 and CODE 30
analyses. It can be reimplemented using standard C setjmp/longjmp, C++ coroutines,
or explicit state machines.

---

## 3. Feasibility of Three Approaches

### 3.1 Approach A: Full Recompilation to Classic Mac

**Goal**: Produce C source code that compiles under THINK C, MPW C, or CodeWarrior
to produce a functionally equivalent Classic Mac application.

**Requirements**:
1. Complete C decompilation of all 52 CODE segments (~500 functions)
2. Complete global variable map with correct A5 offsets (or struct abstraction)
3. Complete jump table mapping (all ~450 entries resolved to functions)
4. Working Classic Mac C compiler environment (in emulator)
5. Correct resource fork preserved alongside compiled code
6. SANE floating point compatibility (native on Classic Mac)
7. Correct segment structure in linker output

**Work completed**: Approximately 80 functions across 10 segments have verified C
decompilations. These cover the core AI engine (DAWG traversal, move generation,
scoring, leave evaluation, alpha-beta search) and the main event loop.

**Work remaining**:
- ~420 functions need hex verification and C decompilation
- ~200+ global variables remain unmapped across unanalyzed segments
- ~350 jump table entries remain unresolved
- Segment structure and linker configuration untested
- Integration testing in emulator

**Estimated effort**: At an average of 45 minutes per function for hex verification,
operand identification, data flow analysis, and C writing, the remaining 420
functions represent approximately 315 hours of skilled work. Adding global mapping,
JT resolution, integration, and debugging doubles this to approximately 600-800
hours.

**Difficulty**: VERY HARD.

**Confidence of success**: 40%. Even with perfect decompilation, matching the
compiler's A5 layout, register allocation, and code generation patterns is
extremely difficult without knowing which compiler and version was originally used.
The resulting binary would be functionally equivalent but not byte-identical.

**Risk factors**:
- Unknown original compiler (THINK C vs MPW C vs CodeWarrior) affects calling
  conventions and A5 layout
- Some functions may rely on specific compiler codegen patterns (e.g., the coroutine
  register mask DEF8 implies a specific set of callee-saved registers)
- The disassembler errors mean every function is a potential source of subtle bugs
- Testing requires a working Classic Mac environment with sufficient game state
  coverage

### 3.2 Approach B: Port to Modern Platform

**Goal**: Rewrite the core AI algorithms in modern C or C++, replacing the Mac
Toolbox UI with a modern framework, producing a functional Scrabble AI that
implements Maven's algorithms.

**Requirements**:
1. Reimplement the DAWG dictionary engine (traversal, cross-check generation,
   multi-section support)
2. Reimplement the Appel-Jacobson move generator
3. Reimplement the scoring engine (tile values, multipliers, bingo bonus,
   cross-word scoring)
4. Reimplement the leave evaluation system (binomial-weighted MUL values,
   vowel/consonant balance)
5. Reimplement the letter synergy scoring (ESTR tables, pair/combination analysis)
6. Reimplement the alpha-beta search (node pool, negamax, pruning, coroutine state)
7. Create a new UI (could be terminal, web, or native GUI)
8. Parse or convert the DAWG data file and MUL/ESTR resource data

**Work completed**: The core AI algorithms are well-understood:
- **DAWG structure**: Fully documented. 32-bit BE entries, letter/eow/last/child
  bit fields, dual-section layout, letter index, traversal algorithm. Python
  validation scripts exist and achieve 99.4% accuracy against reference word lists.
- **Move generation**: The Appel-Jacobson algorithm in CODE 37 is ~70% decompiled.
  Cross-check set generation, leftward prefix extension, rightward suffix extension
  are all documented.
- **Scoring**: CODE 32 and CODE 35 scoring functions are ~80% decompiled. Tile
  values, letter/word multipliers, bingo bonus (5000 centipoints for 7 tiles),
  cross-word scoring all understood.
- **Leave evaluation**: CODE 32's binomial-weighted MUL system is fully understood.
  The formula, MUL record format (8 records x 28 bytes, offset 24 = centipoints),
  binomial coefficient table (101 x 8 x 10-byte SANE), and V/C balance cache
  (256 bytes at A5-2712) are all documented. A Python reimplementation exists.
- **Alpha-beta search**: CODE 30's node pool (32-byte nodes, free list, negamax
  window inversion with -200M sentinel) is ~80% decompiled.

**Work remaining**:
- Translate the verified C decompilations into clean, modern C/C++
- Extract and parse MUL resource data (27 resources, format known)
- Extract and parse ESTR resource data (6 tables, format known)
- Parse the DAWG data file (format fully known, Python parser exists)
- Implement the board representation (17x17 grid with multiplier overlay)
- Implement rack management and tile bag
- Implement the letter synergy scoring (CODE 39, partially decompiled)
- Build a new UI
- Test against known game positions and reference word lists

**Estimated effort**: The core AI engine (DAWG + move gen + scoring + leave eval +
alpha-beta) could be reimplemented in approximately 200-300 hours, leveraging the
existing decompilations as verified pseudocode. A basic terminal UI would add 40-60
hours. A graphical UI would add 100-200 hours depending on the framework.

**Difficulty**: MODERATE for the game engine. The algorithms are published (the
Appel-Jacobson move generation algorithm is well-known in the literature), and the
Maven-specific innovations (leave evaluation, letter synergy, V/C balance) are
documented in detail. The DAWG data format is fully understood and Python parsers
exist.

**Confidence of success**: 85%. The core algorithms are well-understood, and a
functional reimplementation is straightforward. The primary risk is subtle
algorithmic differences in the leave evaluation or letter synergy scoring that
affect AI playing strength. These would require extensive testing against reference
game logs.

**Key advantages**:
- No dependency on Classic Mac environment
- Can use modern tooling (debuggers, profilers, unit tests)
- Can target any platform (Linux, macOS, Windows, web)
- SANE floating point replaced by IEEE 754 with negligible impact
- No A5 layout constraints
- No segment loading complexity

### 3.3 Approach C: Hybrid Binary Patching

**Goal**: Keep the original Maven binary intact, making targeted modifications by
replacing specific CODE resources or data fork contents with hand-assembled 68000
code or modified data.

**Requirements**:
1. Understand the specific CODE segment(s) to be modified
2. Write replacement 68000 assembly that maintains the same calling conventions,
   A5 global offsets, and JT entry points
3. Assemble to raw binary and replace the CODE resource
4. Test in emulator

**Work completed**: The dictionary update approach (replacing the DAWG data fork)
has already been demonstrated. The DAWG format is fully understood, and Python
scripts can generate valid DAWG data. Replacing the data fork with an updated
dictionary is straightforward.

**Suitable modifications**:
- Dictionary updates (replace data fork) -- EASY, already demonstrated
- Tile value adjustments (modify MUL resources) -- EASY, format known
- Score table changes (modify ESTR resources) -- EASY, format known
- Simple logic changes within a single function (e.g., changing the bingo bonus
  from 50 to 35 points: change `MOVE.W #$1388` to `MOVE.W #$0DAC` at CODE 32
  offset 0x0330) -- MODERATE
- Adding new functionality to an existing segment -- HARD (must maintain JT
  entry points, A5 offsets, and stack frame conventions)
- Modifying cross-segment interactions -- VERY HARD

**Estimated effort**: Dictionary-only changes take hours. Single-instruction patches
take minutes once the target is identified. New functionality requires the same
per-function effort as Approach A but limited to the specific segment.

**Difficulty**: EASY for data/resource changes, MODERATE for single-function patches,
HARD for anything requiring new code.

**Confidence of success**: 95% for data modifications, 70% for instruction-level
patches, 30% for new functionality.

---

## 4. Completion Assessment by Subsystem

### 4.1 Game Engine (AI Core)

| Component | Understanding | Decompilation | Rewrite Ready |
|-----------|--------------|---------------|---------------|
| DAWG data format | 100% | N/A (data) | Yes |
| DAWG traversal (CODE 15) | 80% | 50% | Mostly |
| Move generation (CODE 3, 37) | 75% | 65% | Mostly |
| Cross-check generation (CODE 37) | 80% | 70% | Yes |
| Tile scoring (CODE 32, 35) | 85% | 80% | Yes |
| Leave evaluation (CODE 32) | 95% | 85% | Yes |
| V/C balance (CODE 32) | 90% | 80% | Yes |
| Letter synergy (CODE 39) | 65% | 60% | Partially |
| Alpha-beta search (CODE 30) | 80% | 75% | Mostly |
| Move eval pipeline (CODE 36) | 60% | 55% | Partially |
| Score caching (CODE 36) | 50% | 40% | Partially |
| **Overall Game Engine** | **~75%** | **~65%** | **Mostly** |

### 4.2 UI and Application Framework

| Component | Understanding | Decompilation | Rewrite Ready |
|-----------|--------------|---------------|---------------|
| Event dispatcher (CODE 11) | 70% | 65% | N/A for port |
| Window manager (CODE 46) | 50% | 45% | N/A for port |
| Menu system (CODE 11) | 60% | 55% | N/A for port |
| Lexicon controller (CODE 11) | 70% | 65% | Useful |
| Board display (CODE 21) | 30% | 20% | N/A for port |
| Dialog handling (CODE 11, 46) | 40% | 30% | N/A for port |
| File I/O (CODE 13, 24, 50) | 30% | 15% | N/A for port |
| TextEdit controls (CODE 48) | 25% | 15% | N/A for port |
| **Overall UI** | **~40%** | **~35%** | **N/A** |

### 4.3 Infrastructure and Utilities

| Component | Understanding | Decompilation | Rewrite Ready |
|-----------|--------------|---------------|---------------|
| Jump table (CODE 0) | 80% | N/A | N/A |
| Initialization (CODE 1, 2) | 40% | 25% | Partially |
| Memory management | 30% | 15% | Partially |
| String/formatting utilities | 35% | 20% | Trivial |
| Resource loading | 50% | 30% | Partially |
| Game state save/load (CODE 24) | 25% | 10% | Partially |
| **Overall Infrastructure** | **~40%** | **~20%** | **Partially** |

---

## 5. Critical Unknowns

### 5.1 TWL-Only Word Validation

The mechanism by which Maven validates TWL-only words (words in the Tournament Word
List but not in OSW, such as "aah", "ag", "hm") is not yet understood. Section 2 of
the DAWG is confirmed to be the OSW dictionary (99.4% match). TWL-only words do not
appear in either DAWG section using known traversal algorithms. This validation
mechanism lives somewhere in the unanalyzed portions of the codebase, likely
involving a flag or separate data structure not yet identified.

### 5.2 Unanalyzed Segments

The 42 segments without detailed analysis include potentially important modules:

- **CODE 21** (13,718 bytes, largest segment): Contains 53 functions and significant
  DAWG references. Likely the main board display and game interaction module.
- **CODE 9** (3,940 bytes, 48 functions): High function count, unknown purpose.
- **CODE 18** (4,460 bytes): DAWG reference, likely game state management.
- **CODE 20** (3,398 bytes): DAWG reference, unknown.
- **CODE 14** (2,766 bytes): Multiple DAWG references, unknown.
- **CODE 24** (6,786 bytes): File save/load, critical for game state persistence.

### 5.3 Original Compiler

The original compiler is unknown. Evidence points toward THINK C or MPW C based on:
- A5-relative globals with negative offsets (standard for both)
- LINK/UNLK stack frames (standard for both)
- Callee-saved registers D3-D7/A2-A4 (standard for both)
- Jump table format (8-byte entries with _LoadSeg trap)
- Segment loading via CODE resources (standard for both)

Knowing the original compiler would significantly help Approach A, as each compiler
has slightly different conventions for struct padding, register usage in leaf
functions, and optimization patterns.

### 5.4 Exact Global Layout

The full A5 global area layout is unknown. The analyzed segments reference globals
from A5-27912 to A5-1318, but the actual start and end of the global area, the
total number of globals, and the mapping between A5 offsets and semantic variable
names are only partially known. A complete global map would require analyzing all
52 segments.

---

## 6. Recommended Path Forward

### 6.1 For AI Algorithm Preservation (Recommended)

**Approach B (Modern Port)** is the most productive path. The core AI algorithms
are sufficiently understood to reimplement in modern C/C++:

1. **Phase 1 -- DAWG engine** (40 hours): Port the DAWG data parser and traversal
   engine. Python prototypes already exist. Convert to C with the same bit-field
   extraction patterns documented in CODE 15 and CODE 37.

2. **Phase 2 -- Move generator** (60 hours): Implement the Appel-Jacobson algorithm
   using the CODE 37 decompilation as reference. The cross-check generation,
   anchor square identification, prefix extension, and suffix extension are all
   documented.

3. **Phase 3 -- Scoring engine** (40 hours): Implement tile scoring, cross-word
   scoring, and bingo bonus using the CODE 32/35 decompilations. Replace SANE
   with IEEE 754 double precision.

4. **Phase 4 -- Leave evaluation** (40 hours): Implement the binomial-weighted MUL
   system, V/C balance calculation, and letter synergy scoring. Parse MUL and ESTR
   resources.

5. **Phase 5 -- Alpha-beta search** (60 hours): Implement the search tree manager
   using CODE 30 decompilation. Replace the coroutine mechanism with standard
   C setjmp/longjmp or an explicit state machine.

6. **Phase 6 -- Integration and UI** (60 hours): Wire the components together,
   build a minimal interface, test against reference word lists and known game
   positions.

**Total estimated effort**: 300 hours for a functional AI engine without GUI.

### 6.2 For Original Binary Modification

**Approach C (Binary Patching)** for targeted changes:

- Dictionary updates: Use existing Python scripts to generate replacement DAWG data
- Parameter tuning: Modify MUL/ESTR resources directly
- Simple code patches: Change constants or branch targets in specific CODE resources

### 6.3 For Complete Source Recovery

**Approach A (Full Recompilation)** only if all 52 segments must be recovered:

- Continue hex-verified analysis of remaining segments, prioritizing CODE 21, 9,
  18, 20, 14, and 24
- Build a complete A5 global map by cross-referencing all segments
- Resolve all jump table entries
- Identify the original compiler through code generation pattern analysis
- Set up a Classic Mac C compiler environment in an emulator
- Compile, link, and test incrementally

This approach requires 600-800 hours and carries significant risk of failure.

---

## 7. Conclusion

Maven's source code cannot be directly extracted from the binary -- it must be
reconstructed through manual reverse engineering. The current analysis has achieved
deep understanding of the core AI engine (~75% understanding, ~65% decompilation)
and moderate understanding of the UI layer (~40%). The disassembler's systematic
errors mean that every function requires manual hex verification, making the process
labor-intensive but methodical.

The most feasible and productive path is a modern platform port (Approach B),
leveraging the existing C decompilations as verified pseudocode for the AI
algorithms. This avoids the intractable problems of A5 layout matching, SANE
floating point, segment loading, and Mac Toolbox dependency, while preserving the
intellectual substance of Maven's AI: the DAWG dictionary, Appel-Jacobson move
generation, binomial leave evaluation, and alpha-beta search.
