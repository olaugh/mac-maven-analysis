# CODE 21 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 13718 bytes |
| JT Offset | 1064 |
| JT Entries | 39 |
| Functions | 53 |
| Categories | DAWG_ACCESS |
| Purpose | Core DAWG/AI |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x004E, 0x00F8, 0x045A, 0x04A8, 0x0594, 0x05C6, 0x05FA, 0x0682, 0x0922, 0x0B24, 0x0BE6, 0x0C16, 0x0D20, 0x130C, 0x133A, 0x13F8, 0x142A, 0x147C, 0x1496
... and 33 more

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A873 | _EqualPt |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8604 | g_game_mode | Game mode/state flag |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 90 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 74(A5) | get size/count |
| 90(A5) | calculation |
| 98(A5) | unknown |
| 298(A5) | unknown |
| 306(A5) | unknown |
| 322(A5) | unknown |
| 338(A5) | unknown |
| 354(A5) | unknown |
| 378(A5) | unknown |
| 410(A5) | unknown |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 466(A5) | unknown |
| 658(A5) | init_subsystem |
| 754(A5) | unknown |
| 762(A5) | unknown |
| 962(A5) | unknown |
| 978(A5) | unknown |
| 986(A5) | unknown |
| 994(A5) | unknown |
| 1002(A5) | unknown |
| 1010(A5) | unknown |
| 1018(A5) | unknown |
| 1058(A5) | unknown |
| 1082(A5) | unknown |
| 1410(A5) | finalize_buffer |
| 1418(A5) | unknown |
| 1474(A5) | unknown |
| 1482(A5) | unknown |
| 1514(A5) | unknown |
| 1594(A5) | unknown |
| 1602(A5) | unknown |
| 1666(A5) | unknown |
| 1674(A5) | unknown |
| 2026(A5) | unknown |
| 2066(A5) | init/copy function |
| 2314(A5) | unknown |
| 2354(A5) | unknown |
| 2410(A5) | setup_buffer |
| 2826(A5) | unknown |
| 3146(A5) | unknown |
| 3170(A5) | unknown |
| 3178(A5) | unknown |
| 3202(A5) | unknown |
| 3210(A5) | unknown |
| 3314(A5) | unknown |
| 3322(A5) | unknown |
| 3458(A5) | unknown |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3514(A5) | unknown |
| 3522(A5) | unknown |
| 3554(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 5 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- **Large code segment**: 13718 bytes suggests complex functionality

## Refined Analysis (Second Pass)

**Cluster**: Dawg Core

**Category**: CORE_AI

**Global Variable Profile**: 6 DAWG, 3 UI, 103 total

**Calls functions in**: CODE 2, 7, 8, 9, 10, 11, 14, 15, 20, 22, 24, 27, 31, 32, 34, 41, 48, 49, 52

**Assessment**: Core AI - high priority
