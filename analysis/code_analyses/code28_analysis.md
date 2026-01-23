# CODE 28 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 664 bytes |
| JT Offset | 2080 |
| JT Entries | 3 |
| Functions | 3 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x00E6, 0x0116

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23056 | g_dawg_field | DAWG related field |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |

Also references 6 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 90(A5) | calculation |
| 426(A5) | memset/clear |
| 2354(A5) | unknown |
| 2362(A5) | unknown |
| 2394(A5) | setup function |
| 2410(A5) | setup_buffer |
| 2442(A5) | unknown |
| 2458(A5) | unknown |
| 2490(A5) | unknown |
| 2530(A5) | unknown |
| 2618(A5) | unknown |
| 2762(A5) | unknown |
| 3466(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 3 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_SUPPORT

**Global Variable Profile**: 3 DAWG, 0 UI, 9 total

**Calls functions in**: CODE 2, 11, 31, 32, 35, 36, 39, 45, 52

**Assessment**: DAWG support
