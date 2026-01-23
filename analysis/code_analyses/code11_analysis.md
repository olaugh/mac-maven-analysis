# CODE 11 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 4478 bytes |
| JT Offset | 376 |
| JT Entries | 19 |
| Functions | 29 |
| Categories | DAWG_ACCESS, UI_DRAWING |
| Purpose | Core DAWG/AI |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x0058, 0x0086, 0x00A0, 0x00E6, 0x0106, 0x014C, 0x017C, 0x01A6, 0x020E, 0x027E, 0x02D2, 0x0342, 0x037E, 0x039E, 0x03B4, 0x0468, 0x04C8, 0x0550, 0x05BA
... and 9 more

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A8E6 | _DrawPicture |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-23074 | g_dawg_ptr | Main DAWG data pointer |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-8604 | g_game_mode | Game mode/state flag |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 29 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 234(A5) | unknown |
| 282(A5) | unknown |
| 290(A5) | unknown |
| 314(A5) | unknown |
| 346(A5) | unknown |
| 362(A5) | process_dawg - DAWG traversal |
| 650(A5) | get_data from buffer |
| 658(A5) | init_subsystem |
| 778(A5) | unknown |
| 842(A5) | copy_buffers |
| 1042(A5) | unknown |
| 1218(A5) | clear_window |
| 1258(A5) | post-search init |
| 1362(A5) | state_update |
| 1410(A5) | finalize_buffer |
| 1450(A5) | unknown |
| 1570(A5) | unknown |
| 1578(A5) | unknown |
| 1610(A5) | check_something |
| 1618(A5) | unknown |
| 1626(A5) | unknown |
| 1634(A5) | unknown |
| 2346(A5) | check_result |
| 2370(A5) | setup_params |
| 2410(A5) | setup_buffer |
| 2434(A5) | setup_more |
| 2954(A5) | unknown |
| 2962(A5) | unknown |
| 2970(A5) | unknown |
| 3082(A5) | unknown |
| 3114(A5) | unknown |
| 3138(A5) | unknown |
| 3194(A5) | unknown |
| 3506(A5) | compare function |
| 3578(A5) | final_call with sizes |

## Analysis Notes

- **DAWG-related**: Uses 6 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)

## Refined Analysis (Second Pass)

**Cluster**: Dawg Core

**Category**: CORE_AI

**Global Variable Profile**: 7 DAWG, 3 UI, 41 total

**Calls functions in**: CODE 7, 8, 9, 10, 14, 16, 18, 20, 21, 22, 31, 32, 34, 41, 46, 48, 52

**Assessment**: Core AI - high priority
