# CODE 8 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2326 bytes |
| JT Offset | 328 |
| JT Entries | 3 |
| Functions | 3 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x0370, 0x0714

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-23074 | g_dawg_ptr | Main DAWG data pointer |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 23 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 962(A5) | unknown |
| 986(A5) | unknown |
| 1002(A5) | unknown |
| 1338(A5) | unknown |
| 1418(A5) | unknown |
| 1426(A5) | unknown |
| 2034(A5) | unknown |
| 2066(A5) | init/copy function |
| 2266(A5) | unknown |
| 2410(A5) | setup_buffer |
| 2442(A5) | unknown |
| 3170(A5) | unknown |
| 3178(A5) | unknown |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3522(A5) | unknown |
| 3554(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 3 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_SUPPORT

**Global Variable Profile**: 3 DAWG, 1 UI, 28 total

**Calls functions in**: CODE 4, 11, 20, 21, 22, 24, 27, 31, 32, 41, 52

**Assessment**: DAWG support
