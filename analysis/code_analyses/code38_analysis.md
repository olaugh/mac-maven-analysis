# CODE 38 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 374 bytes |
| JT Offset | 2592 |
| JT Entries | 2 |
| Functions | 4 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x000A, 0x0042, 0x00AA

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |

Also references 2 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 418(A5) | bounds_check / error |
| 2394(A5) | setup function |
| 2402(A5) | buffer function |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 3 total

**Calls functions in**: CODE 11, 32

**Assessment**: DAWG support
