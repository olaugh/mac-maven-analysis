# CODE 7 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2872 bytes |
| JT Offset | 224 |
| JT Entries | 13 |
| Functions | 21 |
| Categories | DAWG_ACCESS, BOARD_STATE, LEXICON_CONTROL |
| Purpose | **Board State Management / Lexicon Mode Switching** |
| Confidence | HIGH |

## Menu Context

This code handles board state operations and lexicon mode switching:
- Called when user selects items from the **Lexicon menu** (Menu ID 131)
- Handles "North American" (Item 1), "United Kingdom" (Item 2), "Both" (Item 3)
- Also involved in board setup from dialogs

## Functions

Entry points at: 0x0000, 0x0038, 0x02EA, 0x03A0, 0x046C, 0x048E, 0x050A, 0x0564, 0x058C, 0x05E6, 0x0652, 0x0796, 0x07BC, 0x0808, 0x08B8, 0x092C, 0x095A, 0x09B2, 0x0A16, 0x0A70
... and 1 more

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-8604 | g_lexicon_mode | **Lexicon mode: 1=NA, 2=UK, 3=Both, 6=?, 8=?** |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 14 unknown A5-relative globals.

## Lexicon Mode Settings (from disassembly)

```
0x0A0C: MOVE.W   #$0008,-8604(A5)  ; Set mode = 8
0x0A66: MOVE.W   #$0006,-8604(A5)  ; Set mode = 6
0x0AC0: MOVE.W   #$0001,-8604(A5)  ; Set mode = 1 (North American/TWL)
```

This code sets lexicon mode to 1 (North American) at 0x0AC0, suggesting it handles the "North American" menu item selection from the Lexicon menu.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 74(A5) | get size/count |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 482(A5) | unknown |
| 658(A5) | init_subsystem |
| 1034(A5) | unknown |
| 1242(A5) | unknown |
| 1258(A5) | post-search init |
| 1362(A5) | state_update |
| 1402(A5) | unknown |
| 1410(A5) | finalize_buffer |
| 1442(A5) | unknown |
| 1450(A5) | unknown |
| 1482(A5) | unknown |
| 1514(A5) | unknown |
| 1554(A5) | unknown |
| 1658(A5) | unknown |
| 2066(A5) | init/copy function |
| 2122(A5) | buffer comparison/scoring |
| 2370(A5) | setup_params |
| 2410(A5) | setup_buffer |
| 2826(A5) | unknown |
| 3178(A5) | unknown |
| 3186(A5) | unknown |
| 3490(A5) | copy to/from global |

## Analysis Notes

- **DAWG-related**: Uses 4 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support, Board State

**Category**: CORE_AI, UI_HANDLER

**Global Variable Profile**: 5 DAWG, 3 UI, 22 total

**Calls functions in**: CODE 9, 11, 14, 20, 21, 22, 27, 29, 31, 32, 34, 41, 52

**Assessment**: Board state management and lexicon mode switching - handles Lexicon menu

## Key Functions

| Offset | Purpose |
|--------|---------|
| 0x0A00-0x0AC0 | Lexicon mode switching (modes 1, 6, 8) |
| 0x0000-0x0038 | Board state initialization |
| 0x02EA+ | Board buffer operations |

## Menu Handler Identification

This code appears to be the **Lexicon menu handler**:
- Sets mode=1 for "North American" (TWL dictionary)
- Modes 6 and 8 may be transitional states during dictionary loading
- Works with the two-buffer system (g_field_14/g_field_22) for dictionary switching
