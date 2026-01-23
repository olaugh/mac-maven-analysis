# CODE 39 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 1784 bytes |
| JT Offset | 2608 |
| JT Entries | 4 |
| Functions | 5 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x018C, 0x0516, 0x0572, 0x0688

Also references 8 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 2474(A5) | unknown |
| 2482(A5) | unknown |
| 2730(A5) | unknown |
| 3522(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Unknown

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 8 total

**Calls functions in**: CODE 11, 32, 44, 52

**Assessment**: Standard
