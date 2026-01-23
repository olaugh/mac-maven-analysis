# CODE 37 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 5344 bytes |
| JT Offset | 2560 |
| JT Entries | 4 |
| Functions | 18 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x00D2, 0x010E, 0x024A, 0x0368, 0x03CA, 0x04D6, 0x0506, 0x0544, 0x07B2, 0x0808, 0x084A, 0x091C, 0x0988, 0x0D82, 0x0E42, 0x1352, 0x13E4

Also references 46 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 802(A5) | unknown |
| 2002(A5) | unknown |
| 2330(A5) | unknown |
| 2338(A5) | unknown |
| 2370(A5) | setup_params |
| 2378(A5) | unknown |
| 2410(A5) | setup_buffer |
| 3450(A5) | lookup |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3522(A5) | unknown |

## Analysis Notes

- **Large code segment**: 5344 bytes suggests complex functionality
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Unknown

**Category**: UNKNOWN

**Global Variable Profile**: 0 DAWG, 0 UI, 46 total

**Calls functions in**: CODE 11, 16, 23, 31, 32, 52

**Assessment**: Large - needs analysis
