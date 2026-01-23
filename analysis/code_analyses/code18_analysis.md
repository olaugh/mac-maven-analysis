# CODE 18 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 4460 bytes |
| JT Offset | 816 |
| JT Entries | 4 |
| Functions | 15 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0094, 0x05A2, 0x06B4, 0x0720, 0x08FA, 0x099E, 0x09B6, 0x0A92, 0x0BDC, 0x0C58, 0x0CBA, 0x0CCE, 0x0CDE, 0x0DDA

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15514 | g_field_14 | Board buffer 1 (vertical) |

Also references 77 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 74(A5) | get size/count |
| 82(A5) | unknown |
| 90(A5) | calculation |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 754(A5) | unknown |
| 1018(A5) | unknown |
| 1458(A5) | unknown |
| 1914(A5) | unknown |
| 1962(A5) | unknown |
| 1978(A5) | unknown |
| 2026(A5) | unknown |
| 2066(A5) | init/copy function |
| 2362(A5) | unknown |
| 2394(A5) | setup function |
| 2530(A5) | unknown |
| 2546(A5) | unknown |
| 2826(A5) | unknown |
| 3098(A5) | unknown |
| 3130(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3506(A5) | compare function |
| 3514(A5) | unknown |
| 3522(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- Uses the two-buffer system (horizontal/vertical word directions)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 78 total

**Calls functions in**: CODE 2, 9, 11, 15, 17, 20, 23, 24, 27, 31, 32, 34, 36, 41, 46, 52

**Assessment**: DAWG support
