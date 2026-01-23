# CODE 35 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 3276 bytes |
| JT Offset | 2488 |
| JT Entries | 4 |
| Functions | 5 |
| Categories | FILE_IO |
| Purpose | File I/O |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0030, 0x0060, 0x0368, 0x0A44

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A9EB | _SFGetFile |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15498 | g_current_ptr | Current active buffer pointer |

Also references 12 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 90(A5) | calculation |
| 418(A5) | bounds_check / error |
| 2002(A5) | unknown |
| 2370(A5) | setup_params |
| 2378(A5) | unknown |
| 2394(A5) | setup function |
| 2410(A5) | setup_buffer |
| 2498(A5) | unknown |
| 2506(A5) | unknown |
| 2514(A5) | unknown |
| 3514(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes


## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 1 DAWG, 0 UI, 13 total

**Calls functions in**: CODE 2, 11, 23, 31, 32, 52

**Assessment**: DAWG support
