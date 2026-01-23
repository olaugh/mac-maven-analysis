# CODE 49 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 546 bytes |
| JT Offset | 3312 |
| JT Entries | 2 |
| Functions | 3 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x00B8, 0x012E

Also references 3 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 74(A5) | get size/count |
| 90(A5) | calculation |
| 418(A5) | bounds_check / error |
| 1482(A5) | unknown |
| 2826(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 3 total

**Calls functions in**: CODE 2, 9, 11, 34

**Assessment**: Utility functions
