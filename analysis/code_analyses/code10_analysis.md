# CODE 10 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 138 bytes |
| JT Offset | 352 |
| JT Entries | 3 |
| Functions | 4 |
| Categories | UNKNOWN |
| Purpose | Small utility |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0022, 0x0036, 0x0044

Also references 1 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 274(A5) | unknown |
| 506(A5) | unknown |
| 1610(A5) | check_something |

## Analysis Notes

- **Small utility**: Likely a simple helper function
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: TINY_UTIL

**Global Variable Profile**: 0 DAWG, 0 UI, 1 total

**Calls functions in**: CODE 7, 9, 11

**Assessment**: Utility functions
