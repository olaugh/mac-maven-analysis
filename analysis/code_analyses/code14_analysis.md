# CODE 14 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2766 bytes |
| JT Offset | 624 |
| JT Entries | 14 |
| Functions | 20 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x002E, 0x0118, 0x0182, 0x02DA, 0x0302, 0x032E, 0x0368, 0x03A0, 0x03AC, 0x03D2, 0x0410, 0x0428, 0x0446, 0x0500, 0x056E, 0x073A, 0x0778, 0x0930, 0x0A18

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |
| A5-23056 | g_dawg_field | DAWG related field |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15498 | g_current_ptr | Current active buffer pointer |

Also references 28 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 74(A5) | get size/count |
| 338(A5) | unknown |
| 418(A5) | bounds_check / error |
| 434(A5) | unknown |
| 1018(A5) | unknown |
| 1082(A5) | unknown |
| 1282(A5) | check function |
| 1370(A5) | unknown |
| 1378(A5) | unknown |
| 1482(A5) | unknown |
| 1514(A5) | unknown |
| 1642(A5) | unknown |
| 1706(A5) | unknown |
| 1714(A5) | unknown |
| 1722(A5) | unknown |
| 1730(A5) | unknown |
| 1738(A5) | unknown |
| 2066(A5) | init/copy function |
| 2386(A5) | unknown |
| 2410(A5) | setup_buffer |
| 2442(A5) | unknown |
| 2466(A5) | unknown |
| 2754(A5) | allocation |
| 2826(A5) | unknown |
| 3074(A5) | unknown |
| 3098(A5) | unknown |
| 3130(A5) | unknown |
| 3426(A5) | unknown |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3506(A5) | compare function |
| 3522(A5) | unknown |
| 3538(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 2 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_SUPPORT

**Global Variable Profile**: 3 DAWG, 0 UI, 33 total

**Calls functions in**: CODE 8, 9, 11, 17, 20, 21, 22, 25, 27, 32, 34, 41, 45, 46, 52

**Assessment**: DAWG support
