# CODE 6 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 1026 bytes |
| JT Offset | 168 |
| JT Entries | 7 |
| Functions | 9 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0062, 0x014A, 0x017E, 0x0244, 0x029C, 0x0358, 0x03AA, 0x03D0, 0x03F6

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-24026 | g_common | Common data area |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-8584 | g_handle | Handle to data structure |

Also references 13 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 122(A5) | unknown |
| 410(A5) | unknown |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 1266(A5) | unknown |
| 1362(A5) | state_update |
| 2074(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3498(A5) | unknown |
| 3554(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 2 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_SUPPORT

**Global Variable Profile**: 3 DAWG, 1 UI, 22 total

**Calls functions in**: CODE 3, 11, 21, 27, 52

**Assessment**: DAWG support
