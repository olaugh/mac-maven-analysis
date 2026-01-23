# CODE 50 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 1174 bytes |
| JT Offset | 3544 |
| JT Entries | 1 |
| Functions | 1 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-8584 | g_handle | Handle to data structure |

Also references 1 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 90(A5) | calculation |
| 418(A5) | bounds_check / error |
| 634(A5) | unknown |
| 810(A5) | unknown |
| 842(A5) | copy_buffers |
| 1482(A5) | unknown |
| 1514(A5) | unknown |
| 2826(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: File Io

**Category**: UI_SUPPORT

**Global Variable Profile**: 0 DAWG, 1 UI, 2 total

**Calls functions in**: CODE 2, 9, 11, 14, 16, 18, 34

**Assessment**: File operations
