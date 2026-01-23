# Maven CODE Resources Summary

## Overview

| Property | Value |
|----------|-------|
| Total CODE resources | 53 |
| Total code size | 119,012 bytes (~116 KB) |
| Missing IDs | 26, 33 |

## CODE Resources by Category

### DAWG/Dictionary Access (Core AI)
| ID | Size | Purpose |
|----|------|---------|
| 3 | 4,390 | **Main DAWG search/move generation** - large frame (6512 bytes), direct DAWG ptr access |
| 7 | 2,872 | **Board/rack state management** - uses g_size1, g_size2 |
| 11 | 4,478 | **Main event loop with DAWG** - complex with file I/O, UI, events |

### UI/Drawing
| ID | Size | Purpose |
|----|------|---------|
| 9 | 3,940 | UI Drawing |
| 14 | 2,766 | UI Drawing |
| 20 | 3,398 | UI Drawing |
| 21 | 13,718 | **Largest** - Main UI drawing routines |
| 46 | 2,904 | Main event loop/UI |

### Dialog Handling
| ID | Size | Purpose |
|----|------|---------|
| 2 | 750 | Alert/window management |
| 8 | 2,326 | Dialogs with g_lookup_table |
| 15 | 3,568 | Dialog handling |
| 16 | 1,894 | Dialog handling |
| 17 | 2,618 | Dialog handling |
| 18 | 4,460 | Dialog handling |
| 22 | 2,056 | Dialog handling |
| 41 | 660 | Dialog handling |
| 48 | 1,092 | Dialog handling |
| 49 | 546 | Dialog handling |

### File I/O
| ID | Size | Purpose |
|----|------|---------|
| 12 | 2,722 | File I/O |
| 34 | 1,388 | File I/O |

### Memory Management
| ID | Size | Purpose |
|----|------|---------|
| 1 | 574 | Memory - Handle ops |
| 6 | 1,026 | Memory - Complex algo |
| 47 | 908 | Memory management |
| 50 | 1,174 | Memory management |

### Special Purpose
| ID | Size | Purpose |
|----|------|---------|
| 0 | 3,564 | **Jump table** - Not actual code |
| 4 | 108 | Startup stub |

### Unknown/Unanalyzed
| ID | Size | Notes |
|----|------|-------|
| 5 | 204 | Complex algo indicator |
| 10 | 138 | Small utility |
| 13 | 512 | Unknown |
| 19 | 382 | Unknown |
| 23 | 608 | Unknown |
| 24 | 6,786 | Large - needs analysis |
| 25 | 200 | Unknown |
| 27-32 | varies | Need analysis |
| 35-45 | varies | Need analysis |
| 51-54 | varies | Small utilities |

## Key Global Variables

### DAWG Data (Most Important)
| Offset | Name | Purpose |
|--------|------|---------|
| A5-23074 | g_dawg_ptr | Main DAWG data pointer |
| A5-23070 | g_sect1_off | Section 1 offset |
| A5-23066 | g_sect2_off | Section 2 offset |
| A5-23090 | g_dawg_info | DAWG info structure (34 bytes) |
| A5-15506 | g_size1 | First section size (56630) |
| A5-15502 | g_size2 | Second section size (65536) |
| A5-11972 | g_dawg_ptr2 | Secondary DAWG pointer |

### Board/Game State
| Offset | Name | Purpose |
|--------|------|---------|
| A5-15514 | g_field_14 | Primary board buffer |
| A5-15522 | g_field_22 | Secondary board buffer |
| A5-15498 | g_current_ptr | Current active buffer |
| A5-17154 | g_state1 | State buffer 1 (272 bytes) |
| A5-16610 | g_state2 | State buffer 2 (1088 bytes) |
| A5-10464 | g_state3 | Game state (74 bytes) |

### UI/Window
| Offset | Name | Purpose |
|--------|------|---------|
| A5-8510 | g_window_ptr | Main window pointer |
| A5-8604 | g_game_mode | Game mode flag |
| A5-24026 | g_common | Common data area |
| A5-10388 | g_lookup_tbl | Lookup table |

## Jump Table Mapping (A5-relative calls)

The most frequently called functions:
| Offset | Called From | Likely Purpose |
|--------|-------------|----------------|
| 66(A5) | 15 CODEs | Common utility |
| 74(A5) | 10 CODEs | Get size/count |
| 90(A5) | 13 CODEs | Common calculation |
| 418(A5) | many | Error check/bounds |
| 426(A5) | many | memset/clear |
| 1362(A5) | many | State update |
| 2066(A5) | several | Data copy |
| 3490(A5) | 16+ calls | Copy to/from global |

## Analysis Priority

For understanding DAWG access, analyze in this order:
1. **CODE 3** - Main DAWG search ✓ (see code3_c_translation.md)
2. **CODE 7** - Board/rack state ✓ (see code7_analysis.md)
3. **CODE 11** - Game controller ✓ (see code11_analysis.md)
4. **CODE 21** - Main UI (13KB) - minor DAWG refs for display only
5. **CODE 36** - Unknown (9KB) - uses A5-23056 extensively
6. **CODE 24** - Unknown (6KB) - no direct DAWG refs

## DAWG Reference Counts by CODE

| CODE | Direct DAWG Refs | Primary Purpose |
|------|-----------------|-----------------|
| 3 | 31 | **Main DAWG search** |
| 11 | 24 | **Game controller** |
| 7 | 35 | **Board state** |
| 21 | 9 | UI (display only) |
| 36 | 6 | Unknown (A5-23056) |
| 24 | 0 | UI (no DAWG) |
| 32 | 0 | UI (no DAWG) |

## Structure Sizes

From disassembly analysis:
- **DAWG Entry**: 4 bytes (ptr:2, flags:1, letter:1)
- **Search State**: 34 bytes (used in loops)
- **Board Cell**: 1 byte × 17 × 17 = 289
- **Extended Board**: 34 bytes × 32 = 1088
- **Game State**: 74 bytes (XGME format)

## Detailed Analysis Files

- `code3_c_translation.md` - DAWG search with C translation
- `code3_annotated.md` - CODE 3 annotated disassembly
- `code7_analysis.md` - Board/rack state management
- `code11_analysis.md` - Game controller / main event loop
- `disasm/code*_disasm.asm` - Raw disassemblies for all 53 CODE resources

## Key Insights

### DAWG Access Pattern
The code uses two **heavily overlapping** DAWG sections for cross-check computation:
- **Shared suffix pool (0-999)**: 986 of 1000 entries referenced by both sections
- **Section 1 (0-56,629)**: Reversed words for hook-BEFORE checking
- **Section 2 (56,630-122,165)**: Forward words for hook-AFTER checking

Section 2 is not self-contained - 57% of its children point to the shared pool, 43% point into Section 1, and 0% point within Section 2 itself. It acts as an "alternate entry layer" that reuses Section 1's suffix structure.

Section 2 = exactly 65,536 (2^16) entries, maxing out a 16-bit index.

**Speculation:** Both DAWGs may be used for main word generation (left/right extension from anchors) as well as cross-set computation - not yet confirmed in disassembly.

Offset calculations frequently seen:
- `g_dawg_ptr + g_size1` - Start of section 2
- `g_dawg_ptr + g_size2` - Another offset

### Two-Buffer System
Both CODE 7 and CODE 11 use alternating buffers:
- `g_field_14` (A5-15514): Paired with reversed DAWG (hook-before)
- `g_field_22` (A5-15522): Paired with forward DAWG (hook-after)
- `g_current_ptr` (A5-15498): Points to active buffer

This enables efficient cross-check computation without brute-force A-Z testing.

### State Machine
`g_game_mode` (A5-8604) controls game states:
- 0: Idle/Processing
- 2-3: Player turns
- 4: AI thinking
- 5: End game
- 8: Loaded game
