# CODE 44 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 424 bytes |
| JT Offset | 2720 |
| JT Entries | 4 |
| Functions | 4 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0080, 0x00EA, 0x016A

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23056 | g_dawg_field | DAWG related field |

Also references 4 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 2130(A5) | unknown |
| 2202(A5) | data copy |
| 2394(A5) | setup function |
| 2410(A5) | setup_buffer |
| 2586(A5) | unknown |
| 3450(A5) | lookup |
| 3506(A5) | compare function |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 5 total

**Calls functions in**: CODE 29, 30, 32, 37, 52

**Assessment**: DAWG support
