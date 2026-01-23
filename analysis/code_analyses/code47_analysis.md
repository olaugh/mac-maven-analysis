# CODE 47 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 908 bytes |
| JT Offset | 3328 |
| JT Entries | 4 |
| Functions | 11 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0034, 0x0056, 0x008E, 0x00CC, 0x0128, 0x0168, 0x01D6, 0x0258, 0x02EA, 0x0354

Also references 1 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 426(A5) | memset/clear |
| 2042(A5) | unknown |
| 2818(A5) | unknown |
| 2834(A5) | unknown |
| 2842(A5) | unknown |
| 2850(A5) | unknown |
| 2858(A5) | unknown |
| 2866(A5) | unknown |
| 2874(A5) | unknown |
| 2890(A5) | unknown |
| 2898(A5) | unknown |
| 2914(A5) | unknown |
| 2922(A5) | unknown |
| 2946(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 1 total

**Calls functions in**: CODE 11, 24, 34, 52

**Assessment**: Utility functions
