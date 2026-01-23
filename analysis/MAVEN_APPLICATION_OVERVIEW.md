# Maven Application Architecture Overview

## Executive Summary

Maven is a classic Macintosh Scrabble AI application from the 1980s. The application consists of **53 CODE resources** totaling approximately **119 KB** of executable code. It uses a **DAWG (Directed Acyclic Word Graph)** data structure for efficient word lookup and move generation.

## Application Statistics

| Metric | Value |
|--------|-------|
| Total CODE resources | 53 |
| Total code size | 119,012 bytes (~116 KB) |
| Missing CODE IDs | 26, 33 |
| Largest segment | CODE 21 (13,718 bytes) |
| Smallest segment | CODE 54 (42 bytes) |
| DAWG-related segments | 23 |
| Estimated functions | ~600+ |

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         GAME CONTROLLER (CODE 11)                   │
│                    Dispatch, callbacks, state machine               │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        ▼                      ▼                      ▼
┌───────────────┐    ┌─────────────────┐    ┌────────────────────┐
│   UI LAYER    │    │   GAME STATE    │    │    AI ENGINE       │
│               │    │                 │    │                    │
│ CODE 14,17,21 │◄──►│ CODE 5,7,20,31  │◄──►│ CODE 3,30,32,36-45 │
│ 46,48,49      │    │ Board, Racks    │    │ Search, Score      │
└───────────────┘    └─────────────────┘    └─────────┬──────────┘
        │                                             │
        │            ┌────────────────────────────────┘
        │            ▼
        │    ┌─────────────────────────────────────────────────┐
        │    │              DAWG SUBSYSTEM                     │
        │    │                                                 │
        │    │  CODE 12,15: Word validation & pattern match    │
        │    │  CODE 37,43: Appel-Jacobson cross-checks        │
        │    │  CODE 52: Flag accessors (EOW, last-sibling)    │
        │    │  CODE 25: Prime product anagram hashing         │
        │    │                                                 │
        │    │  ┌─────────────────────────────────────────┐    │
        │    │  │  DAWG Data (loaded from resource fork)  │    │
        │    │  │  Section 1: Reversed words (56,630)     │    │
        │    │  │  Section 2: Forward words (65,536)      │    │
        │    │  │  Heavily overlapping (shared suffixes)  │    │
        │    │  └─────────────────────────────────────────┘    │
        │    └─────────────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────────────────────────────┐
│                    SUPPORT LAYER                                  │
│                                                                   │
│  CODE 1,9: Runtime (32-bit math, timing, cursors)                │
│  CODE 4: Random (LFSR), GCD                                       │
│  CODE 23,52-54: String utilities, C library                       │
│  CODE 2,22,24,47: File I/O, printf                                │
│  CODE 39: Synergy scoring (ESTR patterns)                         │
└───────────────────────────────────────────────────────────────────┘
```

## Functional Subsystems

### 🎯 AI & Move Generation
The core algorithms for finding and scoring moves.

| CODE | Key Functions |
|------|---------------|
| **3** | DAWG search coordinator - manages 65-state search stack |
| **12** | Recursive DAWG word validation (max 1000 results) |
| **30** | DAWG traversal engine (1766-byte stack frame) |
| **32** | **Core scoring** - bingo bonus, leave value calculation |
| **36** | Move cache with hash-based lookup |
| **37, 43** | **Appel-Jacobson** cross-check generation |
| **39** | **Synergy scoring** (9632-byte frame, 6 tables) |
| **45** | Move ranking with dual-table system |

### 🎮 Game State & Board
Managing the board, racks, and game flow.

| CODE | Key Functions |
|------|---------------|
| **5** | Game setup, turn order |
| **7** | Board state (17×17 arrays with borders) |
| **8** | Move scoring with letter/word multipliers |
| **11** | Game controller, dispatch system |
| **20** | Board management, transposed arrays for efficiency |
| **21** | Main UI, rack management, AI/player turns |
| **31** | Tile placement, Fisher-Yates shuffle |

### 📝 Dictionary & DAWG
Accessing and traversing the word graph.

| CODE | Key Functions |
|------|---------------|
| **15** | DAWG pattern matching with callbacks |
| **25** | **Prime product hash** for anagram detection |
| **52** | DAWG flag accessors (EOW, last-sibling, etc.) |

### 🖥️ User Interface
Windows, dialogs, and display.

| CODE | Key Functions |
|------|---------------|
| **6** | Window/display management |
| **14** | Move selection UI, candidate display |
| **16** | Statistics display, report generation |
| **17** | TextEdit windows, scroll handling |
| **18** | Move description formatting |
| **46** | Window management, 3D borders |
| **48** | TextEdit controls |
| **49** | Window placement persistence |

### 💾 File I/O & Persistence
Saving and loading games.

| CODE | Key Functions |
|------|---------------|
| **2** | Resource loading, SFGetFile |
| **22** | Debug board dump, game save/load |
| **24** | printf/sprintf implementation |
| **47** | File I/O primitives |

### ⚙️ Runtime & Utilities
Low-level support functions.

| CODE | Key Functions |
|------|---------------|
| **0** | Jump table (not executable) |
| **1** | Runtime init, 32-bit math (68000 workarounds) |
| **4** | LFSR random, GCD algorithm |
| **9** | Runtime library (timing, cursors, memory) |
| **23** | String utilities, case conversion |
| **51** | Procedure loader |
| **52** | C string library (memcpy, strcmp, etc.) |
| **53, 54** | Hash and string compare utilities |

## Key Data Structures

### DAWG (Directed Acyclic Word Graph)

The DAWG uses **two heavily overlapping sections** for efficient cross-check computation:

| Region | Entries | Purpose |
|--------|---------|---------|
| Shared suffix pool | 0-999 | Common endings referenced by both sections (986 of 1000 shared) |
| Section 1 | 0-56,629 | **Reversed words** - for hook-BEFORE checks (what letters can precede) |
| Section 2 | 56,630-122,165 | **Forward words** - for hook-AFTER checks (what letters can follow) |

**Key insight: Sections overlap heavily.**
- Section 2 is NOT self-contained: 57% of its children → shared pool, 43% → Section 1
- 0% of Section 2 children point within Section 2 itself
- Section 2 acts as an "alternate entry layer" that reuses Section 1's suffix structure

**Why two entry points?** Without a reversed DAWG, computing cross-checks would require brute-force testing all 26 letters A-Z. The two DAWGs may also be used for main word generation (extending left/right from anchors), not just cross-sets - this hasn't been confirmed in the disassembly yet.

**Size note**: Section 2 = exactly 65,536 (2^16) entries, maxing out a 16-bit index. It only stores unique forward-word prefixes since all suffixes are shared.

**DAWG Entry Format (4 bytes)**:
```c
typedef struct {
    uint16_t child_ptr;    // Index to child node
    uint8_t  flags;        // Bit 7: end-of-word, Bit 0: last sibling
    char     letter;       // ASCII letter (a-z)
} DawgEntry;
```

### Board Buffer System

Maven uses a **two-buffer system** for searching:

| Buffer | Global | Paired With | Purpose |
|--------|--------|-------------|---------|
| g_field_14 | A5-15514 | g_size1 (56630) | Reversed DAWG (hook-before checks) |
| g_field_22 | A5-15522 | g_size2 (65536) | Forward DAWG (hook-after checks) |
| g_current_ptr | A5-15498 | - | Active buffer pointer |

### DAWG Info Structure (34 bytes)

A configuration structure at `A5-23090` that stores:
- Section offsets and sizes
- Search parameters
- Copied between functions as 8 longs + 1 word

### Game State

| Global | Offset | Purpose |
|--------|--------|---------|
| g_game_mode | A5-8604 | Current game state (0-8) |
| g_window_ptr | A5-8510 | Main window handle |
| g_handle | A5-8584 | Primary data handle |

**Game Mode Values**:
- 0: Idle/Processing
- 2: Player turn (horizontal)
- 3: Player turn (vertical)
- 4: AI thinking
- 5: End game
- 8: Loaded game

## Jump Table Architecture

CODE 0 is not executable - it's a **jump table** that maps offsets to functions across all CODE segments. This enables:
- Inter-segment function calls via `JSR d(A5)`
- Late binding of code segments
- Efficient memory management (segments can be loaded/purged)

**Frequently Called Jump Table Offsets**:

| Offset | Calls From | Purpose |
|--------|------------|---------|
| 66(A5) | 15 CODEs | Common utility |
| 74(A5) | 10 CODEs | Get size/count |
| 90(A5) | 13 CODEs | Calculation |
| 362(A5) | Core AI | **DAWG traversal** |
| 418(A5) | Many | Bounds check/error |
| 426(A5) | Many | memset/clear |
| 1362(A5) | Many | State update |
| 2066(A5) | Many | Data copy |
| 3490(A5) | 16+ calls | Copy to/from global |

## Memory Layout

Maven uses classic Mac memory conventions:
- **A5**: Global data pointer (QuickDraw globals)
- **A6**: Stack frame pointer
- **A7**: Stack pointer

Global variable space spans approximately **A5-28628** to **A5-8500** (~20 KB of globals).

## Toolbox Usage

The application makes relatively few direct Toolbox calls - most are routed through the jump table for modularity. Direct traps appear mainly in:

- **UI segments**: QuickDraw calls (_MoveTo, _DrawString, _FrameRect)
- **File segments**: File Manager calls (_Open, _Close, _Read, _Write)
- **Dialog segments**: Dialog Manager calls (_Alert, _ModalDialog)

## Compiler Identification

**Likely Compiler**: THINK C 5.x or Symantec C++ 6.x

**Evidence**:
- LINK A6,#-n / UNLK A6 prologue/epilogue
- MOVEM.L saves D3-D7/A2-A4 (THINK C register convention)
- A5-relative global addressing
- Jump table structure matches THINK C output

## Analysis Confidence Levels

| Aspect | Confidence | Notes |
|--------|------------|-------|
| CODE resource boundaries | HIGH | Clear from resource fork |
| Function boundaries | HIGH | LINK/UNLK patterns |
| DAWG structure | HIGH | Confirmed by multiple CODEs |
| Two-buffer system | HIGH | Clear pattern across CODEs |
| Jump table purposes | MEDIUM | Inferred from usage |
| Individual function purposes | LOW | Requires deeper analysis |
| Game state machine | MEDIUM | Partially confirmed |

## Files Generated

### Per-CODE Analysis
- `code_analyses/code{N}_analysis.md` - Individual analysis for each CODE

### Summary Documents
- `code_analyses/00_master_summary.md` - Tabular summary
- `code_summary.md` - Categorical summary with globals
- `MAVEN_APPLICATION_OVERVIEW.md` - This document

### Detailed Analysis
- `code3_c_translation.md` - C translation attempt for CODE 3
- `code3_revised_analysis.md` - Updated CODE 3 analysis
- `code7_analysis.md` - Board/rack state analysis
- `code11_analysis.md` - Game controller analysis

### Raw Disassembly
- `disasm/code{N}_disasm.asm` - Annotated disassembly for each CODE

## Next Steps for Further Analysis

1. **Map Jump Table Completely**: Determine which CODE implements each JT offset
2. **Trace DAWG Traversal**: Find the actual 4-byte entry access in JT[362]
3. **Document Game Flow**: Map the complete state machine
4. **Analyze Score Calculation**: Find how moves are scored
5. **Understand Move Generation**: Document the AI algorithm
6. **Extract Dictionary**: Parse the DAWG data into a word list

## CODE Resource Quick Reference

Based on speculative C decompilation, here's what each CODE resource actually does:

### Runtime & System (CODE 0-4)

| CODE | Size | What It Does |
|------|------|--------------|
| **0** | 3,564 | **Jump Table** - not code, maps JT offsets → segment entry points |
| **1** | 574 | **Runtime init** - `_start()`, Toolbox init, 32-bit multiply/divide (68000 workarounds) |
| **2** | 750 | **Resource loading** - `init_game_resources()`, SFGetFile dialogs, DAWG loader |
| **3** | 4,390 | **DAWG search coordinator** - 2282-byte frame, 65 search states, type classification |
| **4** | 108 | **Random & GCD** - LFSR random (0x40000000 tap), Euclidean GCD algorithm |

### Game State & Board (CODE 5-10)

| CODE | Size | What It Does |
|------|------|--------------|
| **5** | 204 | **Game setup** - buffer init, turn order, game mode assignment |
| **6** | 1,026 | **Window/display** - direction pointers, buffer toggling, 1070-byte window handle |
| **7** | 2,872 | **Board state** - 544/1088-byte structures, 17×17 grid with borders |
| **8** | 2,326 | **Move scoring** - letter multipliers, cross-words, **BINGO bonus (50 pts)** |
| **9** | 3,940 | **Runtime library** - timing, cursors, memory wrappers, low-memory access |
| **10** | 138 | **Cursor/dialogs** - alert display, cursor state management |

### Core Game Logic (CODE 11-21)

| CODE | Size | What It Does |
|------|------|--------------|
| **11** | 4,478 | **Game controller** - dispatch system, callback management, menu iteration |
| **12** | 2,722 | **Word validation** - recursive DAWG search, depth-first traversal, max 1000 words |
| **13** | 512 | **Direction toggle** - horizontal↔vertical, sound playback via Sound Manager |
| **14** | 2,766 | **Move selection** - 34-byte Move structure, score thresholds, candidate evaluation |
| **15** | 3,568 | **DAWG pattern search** - pattern matching, sibling/child navigation, modeless windows |
| **16** | 1,894 | **Statistics** - 88-byte stats block, 'HIST' resource, report generation |
| **17** | 2,618 | **Text editing** - Standard File dialogs, scroll bars, TextEdit windows |
| **18** | 4,460 | **Move formatting** - special codes (PASS/EXCHANGE/CHALLENGE), string tables |
| **19** | 382 | **Flag toggles** - boolean toggles using 68K SEQ/NEG.B idiom |
| **20** | 3,398 | **Board management** - transposed arrays, cross-check sync, tile place/remove |
| **21** | 13,718 | **Main UI** - 8-byte rack entries, cursor management, AI turn, player input |

### Debug & Utilities (CODE 22-25)

| CODE | Size | What It Does |
|------|------|--------------|
| **22** | 2,056 | **Debug/board dump** - ASCII visualization ($*+# multipliers), game save/load |
| **23** | 608 | **String utilities** - charset filtering, Pascal strings, case conversion |
| **24** | 6,786 | **printf/sprintf** - full format parser, flags, integer/string/float formatting |
| **25** | 200 | **🔑 Prime product hash** - unique anagram signatures via prime multiplication |

### Move Search (CODE 27-32)

| CODE | Size | What It Does |
|------|------|--------------|
| **27** | 662 | **Candidate list** - 34-byte linked list entries, callback traversal |
| **28** | 664 | **Move array** - sorted insertion, maintains top 10 moves |
| **29** | 686 | **Search coordination** - horizontal/vertical setup, callback addresses |
| **30** | 3,492 | **DAWG traversal engine** - 1766-byte frame, core tree walking |
| **31** | 2,510 | **Tile placement** - move apply/undo, **Fisher-Yates shuffle**, serialization |
| **32** | 6,464 | **🔑 Core scoring** - 324-byte frame, **bingo=5000 centipoints**, leave SUBTRACTED |

### Endgame & Advanced (CODE 34-44)

| CODE | Size | What It Does |
|------|------|--------------|
| **34** | 1,388 | *(analysis pending deeper review)* |
| **35** | 3,276 | **File operations** - additional I/O support |
| **36** | 9,102 | **Move cache** - 66-byte entries, hash lookup, score-based replacement |
| **37** | 5,344 | **DAWG traversal** - Appel-Jacobson cross-check generation |
| **38** | 374 | **Rack filtering** - recursive combination enumeration (depth 0-7) |
| **39** | 1,784 | **🔑 Synergy scoring** - **9632-byte frame!**, 6 tables, ESTR patterns |
| **40** | 624 | **Move cache L2** - two-level cache hierarchy, callback system |
| **41** | 660 | **Dialog Manager** - modal dialogs, DITL resources |
| **42** | 734 | **Rack analysis** - depth-first enumeration, blank tile handling |
| **43** | 1,486 | **🔑 Cross-check generation** - Appel-Jacobson algorithm, 17408-byte table |
| **44** | 424 | **Search dispatcher** - rack-size thresholds (8, 17), 34-byte entries |

### UI & System (CODE 45-54)

| CODE | Size | What It Does |
|------|------|--------------|
| **45** | 1,122 | **Move ranking** - dual-table system, negated-score mechanism |
| **46** | 2,904 | **Window management** - event routing, 3D borders, board square drawing |
| **47** | 908 | **File I/O primitives** - read/write byte, HParamBlockRec, line reading |
| **48** | 1,092 | **TextEdit controls** - cursor blink, activation, Tab/Enter handling |
| **49** | 546 | **Window placement** - 14-byte entries, position persistence |
| **50** | 1,174 | **Move history** - SANE floating-point, notation formatting |
| **51** | 236 | **Procedure loader** - GetCodeEntry, self-referential handles |
| **52** | 938 | **🔑 DAWG accessors + C library** - all flag extractors, memcpy/strcmp/etc |
| **53** | 106 | **Hash function** - string hashing with lazy table init |
| **54** | 42 | **String compare** - equality check utility |

**Missing**: CODE 26, CODE 33

---

## Key Algorithms Identified

| Algorithm | CODE | Description |
|-----------|------|-------------|
| **Appel-Jacobson** | 37, 43 | Cross-check set generation for move validation |
| **Prime Product Hash** | 25 | Unique anagram signatures - multiply letter primes |
| **Fisher-Yates Shuffle** | 31 | Tile bag randomization |
| **LFSR Random** | 4 | Linear feedback shift register with 0x40000000 tap |
| **GCD Reduction** | 4, 25 | Euclidean algorithm to prevent overflow |

## Key Constants

| Value | Meaning | Found In |
|-------|---------|----------|
| 5000 | Bingo bonus in centipoints (= 50 actual points) | CODE 32 |
| 34 | Move/candidate structure size (bytes) | CODE 14, 27, 44 |
| 17×17 | Board array dimensions (15×15 + borders) | CODE 7, 20 |
| 65 | Max search depth (states in search stack) | CODE 3 |
| 9632 | Synergy calculation stack frame size | CODE 39 |
