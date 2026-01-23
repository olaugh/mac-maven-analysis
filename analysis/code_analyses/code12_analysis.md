# CODE 12 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2722 bytes |
| JT Offset | 528 |
| JT Entries | 8 |
| Functions | 22 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0078, 0x0142, 0x018C, 0x038A, 0x03AA, 0x049E, 0x066A, 0x0676, 0x0682, 0x06F2, 0x06FC, 0x0714, 0x072C, 0x07B2, 0x082A, 0x0890, 0x08F0, 0x0948, 0x09D6, 0x09F0
... and 2 more

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |

Also references 42 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 802(A5) | unknown |
| 1522(A5) | unknown |
| 1602(A5) | unknown |
| 1706(A5) | unknown |
| 1714(A5) | unknown |
| 1738(A5) | unknown |
| 1770(A5) | unknown |
| 1882(A5) | unknown |
| 2034(A5) | unknown |
| 2066(A5) | init/copy function |
| 2074(A5) | unknown |
| 3098(A5) | unknown |
| 3130(A5) | unknown |
| 3282(A5) | unknown |
| 3290(A5) | unknown |
| 3338(A5) | unknown |
| 3506(A5) | compare function |
| 3522(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Unknown

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 44 total

**Calls functions in**: CODE 9, 11, 16, 17, 24, 27, 41, 46, 47, 48, 52

**Assessment**: Standard
