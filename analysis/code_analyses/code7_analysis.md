# CODE 7 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2872 bytes |
| JT Offset | 224 |
| JT Entries | 13 |
| Functions | 21 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x0038, 0x02EA, 0x03A0, 0x046C, 0x048E, 0x050A, 0x0564, 0x058C, 0x05E6, 0x0652, 0x0796, 0x07BC, 0x0808, 0x08B8, 0x092C, 0x095A, 0x09B2, 0x0A16, 0x0A70
... and 1 more

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15522 | g_field_22 | Board buffer 2 (horizontal) |
| A5-15514 | g_field_14 | Board buffer 1 (vertical) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-8604 | g_game_mode | Game mode/state flag |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 14 unknown A5-relative globals.

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
- Uses the two-buffer system (horizontal/vertical word directions)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: CORE_AI

**Global Variable Profile**: 5 DAWG, 3 UI, 22 total

**Calls functions in**: CODE 9, 11, 14, 20, 21, 22, 27, 29, 31, 32, 34, 41, 52

**Assessment**: DAWG support
