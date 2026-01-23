# CODE 43 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 1486 bytes |
| JT Offset | 2688 |
| JT Entries | 4 |
| Functions | 5 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x00B6, 0x01D8, 0x0310, 0x04D4

Also references 10 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 2450(A5) | unknown |
| 2474(A5) | unknown |
| 3514(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Unknown

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 10 total

**Calls functions in**: CODE 11, 32, 52

**Assessment**: Standard
