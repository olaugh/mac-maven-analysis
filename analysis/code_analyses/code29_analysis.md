# CODE 29 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 686 bytes |
| JT Offset | 2104 |
| JT Entries | 8 |
| Functions | 8 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x0028, 0x0050, 0x00CE, 0x015A, 0x0182, 0x0224, 0x026E

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-23066 | g_sect2_off | Section 2 offset |

Also references 12 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 2122(A5) | buffer comparison/scoring |
| 2242(A5) | unknown |
| 2290(A5) | unknown |
| 2410(A5) | setup_buffer |
| 2434(A5) | setup_more |
| 2610(A5) | unknown |
| 2642(A5) | unknown |
| 2666(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 1 DAWG-related globals
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 2 DAWG, 0 UI, 14 total

**Calls functions in**: CODE 11, 30, 31, 32, 39, 40

**Assessment**: DAWG support
