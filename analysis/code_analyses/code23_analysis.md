# CODE 23 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 608 bytes |
| JT Offset | 1968 |
| JT Entries | 7 |
| Functions | 12 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x001C, 0x0050, 0x0086, 0x00B8, 0x00DC, 0x0124, 0x0146, 0x0176, 0x01BA, 0x01FA, 0x023A

Also references 2 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 2066(A5) | init/copy function |
| 3514(A5) | unknown |
| 3522(A5) | unknown |
| 3530(A5) | unknown |
| 3554(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 2 total

**Calls functions in**: CODE 27, 52

**Assessment**: Utility functions
