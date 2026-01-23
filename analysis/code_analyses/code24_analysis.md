# CODE 24 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 6786 bytes |
| JT Offset | 2024 |
| JT Entries | 3 |
| Functions | 25 |
| Categories | FILE_IO |
| Purpose | File I/O |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0AFC, 0x1404, 0x1438, 0x146E, 0x1492, 0x1540, 0x15EA, 0x161C, 0x163E, 0x1660, 0x1698, 0x16A2, 0x16BA, 0x16F6, 0x170E, 0x1732, 0x174A, 0x1764, 0x177E
... and 5 more

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A9EB | _SFGetFile |

Also references 13 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 74(A5) | get size/count |
| 82(A5) | unknown |
| 2026(A5) | unknown |
| 2450(A5) | unknown |
| 3458(A5) | unknown |
| 3474(A5) | unknown |
| 3482(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3522(A5) | unknown |

## Analysis Notes

- **Large code segment**: 6786 bytes suggests complex functionality

## Refined Analysis (Second Pass)

**Cluster**: File Io

**Category**: FILE_IO

**Global Variable Profile**: 0 DAWG, 0 UI, 13 total

**Calls functions in**: CODE 2, 32, 52

**Assessment**: File operations
