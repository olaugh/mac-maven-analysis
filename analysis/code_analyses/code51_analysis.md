# CODE 51 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 236 bytes |
| JT Offset | 3360 |
| JT Entries | 6 |
| Functions | 6 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0026, 0x0044, 0x0070, 0x00CC, 0x00DC

Also references 1 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 506(A5) | unknown |
| 3066(A5) | unknown |
| 3074(A5) | unknown |
| 3114(A5) | unknown |
| 3122(A5) | unknown |
| 3130(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 1 total

**Calls functions in**: CODE 11, 41, 46

**Assessment**: Utility functions
