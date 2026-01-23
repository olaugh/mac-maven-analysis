# CODE 31 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2510 bytes |
| JT Offset | 2264 |
| JT Entries | 15 |
| Functions | 14 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0048, 0x0074, 0x00DA, 0x0124, 0x0150, 0x0168, 0x0180, 0x063E, 0x071A, 0x0758, 0x07DC, 0x08BA, 0x098E

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15522 | g_field_22 | Board buffer 2 (horizontal) |
| A5-15514 | g_field_14 | Board buffer 1 (vertical) |

Also references 44 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 82(A5) | unknown |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 1458(A5) | unknown |
| 1690(A5) | unknown |
| 1762(A5) | unknown |
| 2002(A5) | unknown |
| 2442(A5) | unknown |
| 2530(A5) | unknown |
| 2546(A5) | unknown |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3522(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 2 DAWG-related globals
- Uses the two-buffer system (horizontal/vertical word directions)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 2 DAWG, 0 UI, 46 total

**Calls functions in**: CODE 2, 9, 11, 17, 23, 32, 36, 52

**Assessment**: DAWG support
