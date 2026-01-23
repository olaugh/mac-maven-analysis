# CODE 16 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 1894 bytes |
| JT Offset | 776 |
| JT Entries | 5 |
| Functions | 9 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0028, 0x0148, 0x054A, 0x057C, 0x05A2, 0x05D0, 0x06F0, 0x072E

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-8584 | g_handle | Handle to data structure |

Also references 15 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 90(A5) | calculation |
| 1642(A5) | unknown |
| 1874(A5) | unknown |
| 1890(A5) | unknown |
| 2066(A5) | init/copy function |
| 2826(A5) | unknown |
| 3074(A5) | unknown |
| 3098(A5) | unknown |
| 3130(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: File Io

**Category**: UI_SUPPORT

**Global Variable Profile**: 0 DAWG, 1 UI, 16 total

**Calls functions in**: CODE 2, 9, 17, 27, 34, 41, 46

**Assessment**: File operations
