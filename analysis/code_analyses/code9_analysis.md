# CODE 9 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 3940 bytes |
| JT Offset | 1440 |
| JT Entries | 37 |
| Functions | 48 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x001A, 0x003A, 0x0050, 0x0072, 0x0082, 0x00A0, 0x00B0, 0x00BE, 0x00D4, 0x00F4, 0x011E, 0x0138, 0x0154, 0x0170, 0x018E, 0x01A6, 0x01E6, 0x020E, 0x022A
... and 28 more

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A873 | _EqualPt |
| $A95B | _SetCRefCon |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |

Also references 9 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 90(A5) | calculation |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 482(A5) | unknown |
| 2010(A5) | unknown |
| 2018(A5) | unknown |
| 2818(A5) | unknown |
| 2826(A5) | unknown |
| 2866(A5) | unknown |
| 2882(A5) | unknown |
| 2930(A5) | unknown |
| 2938(A5) | unknown |
| 2978(A5) | unknown |
| 3018(A5) | unknown |
| 3026(A5) | unknown |
| 3050(A5) | unknown |
| 3058(A5) | unknown |
| 3090(A5) | unknown |
| 3098(A5) | unknown |
| 3386(A5) | unknown |
| 3434(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3522(A5) | unknown |

## Analysis Notes


## Refined Analysis (Second Pass)

**Cluster**: Unknown

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 12 total

**Calls functions in**: CODE 2, 11, 23, 34, 46, 51, 52

**Assessment**: Standard
