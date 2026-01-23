# CODE 41 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 660 bytes |
| JT Offset | 3128 |
| JT Entries | 8 |
| Functions | 8 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x001E, 0x00D4, 0x00F0, 0x0106, 0x011C, 0x0234, 0x024C

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |

Also references 3 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 474(A5) | unknown |
| 530(A5) | unknown |
| 538(A5) | unknown |
| 546(A5) | unknown |
| 554(A5) | unknown |
| 1546(A5) | unknown |
| 2010(A5) | unknown |
| 3138(A5) | unknown |
| 3226(A5) | unknown |
| 3346(A5) | unknown |
| 3354(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Unknown

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 6 total

**Calls functions in**: CODE 9, 11, 12, 23, 47, 48

**Assessment**: Standard
