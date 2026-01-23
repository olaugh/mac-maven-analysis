# CODE 4 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 108 bytes |
| JT Offset | 1424 |
| JT Entries | 2 |
| Functions | 2 |
| Categories | UNKNOWN |
| Purpose | Small utility |
| Confidence | LOW |

## Functions

Entry points at: 0x002C, 0x003A

Also references 1 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 98(A5) | unknown |

## Analysis Notes

- **Small utility**: Likely a simple helper function
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: TINY_UTIL

**Global Variable Profile**: 0 DAWG, 0 UI, 1 total

**Calls functions in**: CODE 2

**Assessment**: Utility functions
