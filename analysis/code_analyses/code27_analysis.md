# CODE 27 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 662 bytes |
| JT Offset | 2048 |
| JT Entries | 4 |
| Functions | 5 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0022, 0x0148, 0x018E, 0x01D0

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23056 | g_dawg_field | DAWG related field |

Also references 3 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 2658(A5) | unknown |
| 2666(A5) | unknown |
| 2722(A5) | unknown |
| 2738(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 4 total

**Calls functions in**: CODE 11, 40, 44, 52

**Assessment**: DAWG support
