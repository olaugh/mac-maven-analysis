# CODE 46 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2904 bytes |
| JT Offset | 3032 |
| JT Entries | 12 |
| Functions | 23 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0086, 0x0100, 0x01BA, 0x020C, 0x0234, 0x0268, 0x047E, 0x050C, 0x05D2, 0x05FE, 0x0612, 0x0654, 0x06BE, 0x06D4, 0x073E, 0x0770, 0x07AC, 0x0866, 0x08E4
... and 3 more

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A873 | _EqualPt |

Also references 4 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 514(A5) | unknown |
| 522(A5) | unknown |
| 1562(A5) | unknown |
| 1610(A5) | check_something |
| 3434(A5) | unknown |

## Analysis Notes


## Refined Analysis (Second Pass)

**Cluster**: Ui Main

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 4 total

**Calls functions in**: CODE 9, 11, 52

**Assessment**: UI drawing
