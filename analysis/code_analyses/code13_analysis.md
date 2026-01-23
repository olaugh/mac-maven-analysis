# CODE 13 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 512 bytes |
| JT Offset | 592 |
| JT Entries | 4 |
| Functions | 5 |
| Categories | DAWG_ACCESS, MENUS, FILE_IO |
| Purpose | File I/O |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x007E, 0x00AE, 0x01D6, 0x01E6

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A945 | _MenuKey |
| $A9EB | _SFGetFile |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23056 | g_dawg_field | DAWG related field |
| A5-8584 | g_handle | Handle to data structure |

Also references 3 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 2114(A5) | unknown |
| 2130(A5) | unknown |
| 2754(A5) | allocation |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 1 UI, 5 total

**Calls functions in**: CODE 11, 29, 45

**Assessment**: DAWG support
