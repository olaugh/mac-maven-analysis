# CODE 40 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 624 bytes |
| JT Offset | 2640 |
| JT Entries | 4 |
| Functions | 4 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0098, 0x0110, 0x01FE

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23056 | g_dawg_field | DAWG related field |

Also references 5 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 2098(A5) | unknown |
| 2106(A5) | unknown |
| 2114(A5) | unknown |
| 2618(A5) | unknown |
| 2650(A5) | unknown |
| 2746(A5) | unknown |
| 2762(A5) | unknown |
| 2778(A5) | unknown |
| 2810(A5) | unknown |
| 3466(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 6 total

**Calls functions in**: CODE 11, 28, 29, 34, 39, 44, 45, 52

**Assessment**: DAWG support
