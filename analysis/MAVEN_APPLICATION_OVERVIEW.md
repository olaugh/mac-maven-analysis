# Maven Application Architecture Overview

## Executive Summary

Maven is a classic Macintosh Scrabble AI application from the late 1980s/early 1990s. The application consists of **53 CODE resources** totaling approximately **119 KB** of executable code. It uses a **DAWG (Directed Acyclic Word Graph)** data structure for efficient word lookup and move generation.

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
+------------------+     +------------------+     +------------------+
|   UI Layer       |     |   Game Logic     |     |   AI Engine      |
|   CODE 9,14,15   |<--->|   CODE 11,46     |<--->|   CODE 3,7,21    |
|   17,20,21,32    |     |                  |     |   22,30          |
+------------------+     +------------------+     +------------------+
        |                        |                        |
        v                        v                        v
+------------------+     +------------------+     +------------------+
|   Dialogs        |     |   File I/O       |     |   DAWG Data      |
|   CODE 8,15,16   |     |   CODE 12,13     |     |   Loaded from    |
|   17,18,22,41    |     |   24,34,35       |     |   'DAWG' rsrc    |
|   48,49          |     |                  |     |                  |
+------------------+     +------------------+     +------------------+
        |                        |                        |
        +------------------------+------------------------+
                                 |
                    +---------------------------+
                    |   Memory Management       |
                    |   CODE 1,6,47,50          |
                    +---------------------------+
                                 |
                    +---------------------------+
                    |   Mac Toolbox (A-traps)   |
                    +---------------------------+
```

## CODE Resource Categories

### Core DAWG/AI Engine (5 segments, ~28 KB)

These are the heart of the AI - they access DAWG data structures and generate moves.

| CODE | Size | Functions | Purpose |
|------|------|-----------|---------|
| **3** | 4,390 | 16 | Main DAWG search coordinator |
| **7** | 2,872 | 21 | Board/rack state management |
| **11** | 4,478 | 29 | Game controller / main loop |
| **21** | 13,718 | 53 | Main UI + DAWG display (largest) |
| **22** | 2,056 | 10 | DAWG-related processing |
| **30** | 3,492 | 15 | DAWG traversal support |

### DAWG Support (17 segments, ~23 KB)

These segments reference DAWG globals but serve auxiliary functions.

| CODE | Size | Purpose |
|------|------|---------|
| 5 | 204 | Small DAWG utility |
| 6 | 1,026 | Memory + DAWG |
| 8 | 2,326 | Dialogs + DAWG lookup |
| 14 | 2,766 | UI + DAWG display |
| 15 | 3,568 | Dialogs + DAWG |
| 18 | 4,460 | DAWG-related |
| 20 | 3,398 | DAWG-related |
| 27-29 | ~2,000 | Various DAWG support |
| 31 | 2,510 | DAWG support |
| 36 | 9,102 | Large DAWG segment |
| 38,40,44,45 | ~2,500 | Small DAWG utilities |

### UI/Drawing (3 segments, ~10 KB)

| CODE | Size | Functions | Purpose |
|------|------|-----------|---------|
| 11 | 4,478 | 29 | Mixed: Game control + UI |
| 15 | 3,568 | 20 | UI Drawing + dialogs |
| 17 | 2,618 | 34 | Pure UI drawing |

### File I/O (3 segments, ~11 KB)

| CODE | Size | Purpose |
|------|------|---------|
| 13 | 512 | File operations + menus |
| 24 | 6,786 | Main file I/O (save/load games) |
| 35 | 3,276 | Additional file operations |

### System/Infrastructure (25 segments, ~32 KB)

| CODE | Size | Purpose |
|------|------|---------|
| 0 | 3,564 | **Jump table** (not executable code) |
| 1 | 574 | Startup initialization |
| 2 | 750 | Alert/window management |
| 4 | 108 | Startup stub |
| 9 | 3,940 | 48 functions - likely utilities |
| 10,53,54 | ~300 | Small utilities |
| 12 | 2,722 | Unknown (no traps/DAWG) |
| 16,19,23,25 | ~3,000 | Various utilities |
| 32 | 6,464 | Large unknown segment |
| 34,37,39 | ~8,500 | Various utilities |
| 41-43 | ~2,900 | Dialog-related |
| 46-52 | ~8,500 | Various utilities |

## Key Data Structures

### DAWG (Directed Acyclic Word Graph)

The DAWG is split into **two sections**:

| Section | Size | Purpose |
|---------|------|---------|
| Section 1 | 56,630 entries | **Reversed words** (suffix matching for vertical) |
| Section 2 | 65,536 entries | **Forward words** (prefix matching for horizontal) |

**DAWG Entry Format (4 bytes)**:
```c
typedef struct {
    uint16_t child_ptr;    // Index to child node
    uint8_t  flags;        // Bit 7: end-of-word, Bit 0: last sibling
    char     letter;       // ASCII letter (a-z)
} DawgEntry;
```

### Board Buffer System

Maven uses a **two-buffer system** for searching in different directions:

| Buffer | Global | Paired With | Direction |
|--------|--------|-------------|-----------|
| g_field_14 | A5-15514 | g_size1 (56630) | Vertical words |
| g_field_22 | A5-15522 | g_size2 (65536) | Horizontal words |
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

## Appendix: CODE Resource Index

```
ID    Size    Category        Purpose
--    ----    --------        -------
0     3564    SYSTEM          Jump table
1      574    SYSTEM          Startup init
2      750    SYSTEM          Window management
3     4390    CORE_AI         DAWG search coordinator
4      108    SYSTEM          Startup stub
5      204    DAWG            DAWG utility
6     1026    MEMORY          Memory management
7     2872    CORE_AI         Board/rack state
8     2326    DIALOG+DAWG     Dialogs with lookup
9     3940    UTILITY         48 utility functions
10     138    UTILITY         Small utility
11    4478    CORE_AI+UI      Game controller
12    2722    UNKNOWN         No traps/DAWG refs
13     512    FILE_IO         File + menus
14    2766    UI+DAWG         UI drawing
15    3568    UI+DIALOG       Dialog handling
16    1894    DIALOG          Dialog handling
17    2618    UI              Pure UI drawing
18    4460    DAWG            DAWG-related
19     382    UTILITY         Small utility
20    3398    UI+DAWG         UI drawing
21   13718    CORE_AI         Largest - main UI/DAWG
22    2056    CORE_AI         DAWG processing
23     608    UTILITY         Unknown
24    6786    FILE_IO         Save/load games
25     200    UTILITY         Small utility
27     662    DAWG            DAWG support
28     664    DAWG            DAWG support
29     686    DAWG            DAWG support
30    3492    CORE_AI         DAWG traversal
31    2510    DAWG            DAWG support
32    6464    UTILITY         Unknown (large)
34    1388    UTILITY         Unknown
35    3276    FILE_IO         File operations
36    9102    DAWG            DAWG-related (large)
37    5344    UTILITY         Unknown
38     374    DAWG            Small DAWG utility
39    1784    UTILITY         Unknown
40     624    DAWG            Small DAWG utility
41     660    DIALOG          Dialog handling
42     734    UTILITY         Unknown
43    1486    UTILITY         Unknown
44     424    DAWG            Small DAWG utility
45    1122    DAWG            DAWG support
46    2904    UI              Event handling
47     908    MEMORY          Memory management
48    1092    DIALOG          Dialog handling
49     546    DIALOG          Dialog handling
50    1174    MEMORY          Memory management
51     236    UTILITY         Small utility
52     938    UTILITY         Unknown
53     106    UTILITY         Small utility
54      42    UTILITY         Smallest - stub

Missing: CODE 26, CODE 33
```
