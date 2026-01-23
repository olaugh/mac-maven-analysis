# CODE 45 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 1122 bytes |
| JT Offset | 2752 |
| JT Entries | 4 |
| Functions | 5 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x01AE, 0x01EA, 0x02B4, 0x0426

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-23074 | g_dawg_ptr | Main DAWG data pointer |
| A5-23056 | g_dawg_field | DAWG related field |

Also references 12 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 2090(A5) | unknown |
| 2122(A5) | buffer comparison/scoring |
| 2154(A5) | unknown |
| 2178(A5) | unknown |
| 2210(A5) | unknown |
| 2218(A5) | unknown |
| 2226(A5) | unknown |
| 2234(A5) | unknown |
| 2242(A5) | unknown |
| 2250(A5) | unknown |
| 2274(A5) | unknown |
| 2282(A5) | unknown |
| 2322(A5) | unknown |
| 2410(A5) | setup_buffer |
| 2434(A5) | setup_more |
| 2594(A5) | unknown |
| 2618(A5) | unknown |
| 2698(A5) | unknown |
| 2762(A5) | unknown |
| 3466(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 3 DAWG-related globals
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_SUPPORT

**Global Variable Profile**: 3 DAWG, 0 UI, 15 total

**Calls functions in**: CODE 11, 28, 29, 30, 31, 32, 38, 39, 43, 52

**Assessment**: DAWG support
