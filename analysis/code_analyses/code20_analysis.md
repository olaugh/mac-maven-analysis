# CODE 20 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 3398 bytes |
| JT Offset | 928 |
| JT Entries | 17 |
| Functions | 21 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0074, 0x00BE, 0x0232, 0x0272, 0x0338, 0x03DC, 0x0416, 0x044A, 0x051C, 0x0538, 0x0582, 0x05F0, 0x0644, 0x065E, 0x0710, 0x084C, 0x0926, 0x09CC, 0x0B9A, 0x0C3E
... and 1 more

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 28 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 658(A5) | init_subsystem |
| 1338(A5) | unknown |
| 1378(A5) | unknown |
| 3506(A5) | compare function |
| 3522(A5) | unknown |
| 3554(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 2 UI, 32 total

**Calls functions in**: CODE 11, 14, 21, 22, 52

**Assessment**: DAWG support
