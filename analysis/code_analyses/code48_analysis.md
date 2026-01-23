# CODE 48 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 1092 bytes |
| JT Offset | 3192 |
| JT Entries | 15 |
| Functions | 18 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x001C, 0x0032, 0x0048, 0x0058, 0x0068, 0x007C, 0x009C, 0x00BA, 0x00D8, 0x0134, 0x017E, 0x01A2, 0x0258, 0x02A6, 0x02CA, 0x02F0, 0x0372

Also references 1 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 1530(A5) | unknown |
| 1586(A5) | unknown |
| 1594(A5) | unknown |
| 1602(A5) | unknown |
| 1970(A5) | unknown |
| 2826(A5) | unknown |
| 2986(A5) | unknown |
| 2994(A5) | unknown |
| 3002(A5) | unknown |
| 3010(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 1 total

**Calls functions in**: CODE 9, 11, 23, 34

**Assessment**: Utility functions
