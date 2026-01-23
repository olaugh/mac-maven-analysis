# CODE 2 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 750 bytes |
| JT Offset | 80 |
| JT Entries | 4 |
| Functions | 5 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x002C, 0x00F0, 0x0250, 0x027E

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-24026 | g_common | Common data area |
| A5-8584 | g_handle | Handle to data structure |

Also references 19 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 770(A5) | unknown |
| 1602(A5) | unknown |
| 1666(A5) | unknown |
| 1682(A5) | unknown |
| 2050(A5) | unknown |
| 3170(A5) | unknown |
| 3202(A5) | unknown |
| 3218(A5) | unknown |
| 3234(A5) | unknown |
| 3290(A5) | unknown |
| 3386(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3522(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Unknown

**Category**: UI_SUPPORT

**Global Variable Profile**: 0 DAWG, 1 UI, 22 total

**Calls functions in**: CODE 9, 11, 15, 27, 41, 48, 51, 52

**Assessment**: Standard
