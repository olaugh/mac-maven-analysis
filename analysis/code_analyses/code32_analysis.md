# CODE 32 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 6464 bytes |
| JT Offset | 2384 |
| JT Entries | 13 |
| Functions | 19 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x064C, 0x069E, 0x07BC, 0x07D6, 0x08B8, 0x09D8, 0x0BFC, 0x0CC0, 0x0DAC, 0x0EF6, 0x11E2, 0x123E, 0x12CA, 0x1300, 0x1406, 0x1648, 0x16BC, 0x18E0

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15498 | g_current_ptr | Current active buffer pointer |

Also references 49 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 90(A5) | calculation |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 794(A5) | unknown |
| 1666(A5) | unknown |
| 2002(A5) | unknown |
| 2338(A5) | unknown |
| 2386(A5) | unknown |
| 2394(A5) | setup function |
| 3490(A5) | copy to/from global |
| 3506(A5) | compare function |
| 3514(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes

- **Large code segment**: 6464 bytes suggests complex functionality
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 50 total

**Calls functions in**: CODE 2, 9, 11, 16, 23, 31, 52

**Assessment**: DAWG support
