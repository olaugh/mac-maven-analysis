# CODE 36 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 9102 bytes |
| JT Offset | 2520 |
| JT Entries | 5 |
| Functions | 14 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0188, 0x04D6, 0x06DA, 0x091A, 0x1136, 0x1372, 0x14CC, 0x163E, 0x16CE, 0x1710, 0x178C, 0x17C2, 0x180C

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23056 | g_dawg_field | DAWG related field |

Also references 63 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 74(A5) | get size/count |
| 90(A5) | calculation |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 1658(A5) | unknown |
| 1666(A5) | unknown |
| 1674(A5) | unknown |
| 1682(A5) | unknown |
| 2114(A5) | unknown |
| 2130(A5) | unknown |
| 2298(A5) | unknown |
| 2306(A5) | unknown |
| 2354(A5) | unknown |
| 2370(A5) | setup_params |
| 2378(A5) | unknown |
| 2386(A5) | unknown |
| 2394(A5) | setup function |
| 2410(A5) | setup_buffer |
| 2418(A5) | unknown |
| 2426(A5) | unknown |
| 2466(A5) | unknown |
| 2490(A5) | unknown |
| 2498(A5) | unknown |
| 2522(A5) | unknown |
| 2602(A5) | unknown |
| 2610(A5) | unknown |
| 2618(A5) | unknown |
| 2706(A5) | unknown |
| 2714(A5) | unknown |
| 2722(A5) | unknown |
| 2738(A5) | unknown |
| 2746(A5) | unknown |
| 3466(A5) | unknown |
| 3482(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3498(A5) | unknown |
| 3514(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- **Large code segment**: 9102 bytes suggests complex functionality
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 64 total

**Calls functions in**: CODE 2, 9, 11, 29, 31, 32, 35, 38, 39, 43, 44, 52

**Assessment**: DAWG support
