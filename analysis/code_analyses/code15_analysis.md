# CODE 15 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 3568 bytes |
| JT Offset | 736 |
| JT Entries | 5 |
| Functions | 20 |
| Categories | DAWG_ACCESS, UI_DRAWING |
| Purpose | UI Drawing |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x00CE, 0x0124, 0x0194, 0x01C4, 0x023A, 0x0272, 0x0356, 0x03D6, 0x0404, 0x0458, 0x04CE, 0x05A6, 0x0670, 0x0936, 0x09D6, 0x0AA4, 0x0B6A, 0x0CA4, 0x0D48

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A887 | _MoveTo |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-24026 | g_common | Common data area |
| A5-15522 | g_field_22 | Board buffer 2 (horizontal) |
| A5-15514 | g_field_14 | Board buffer 1 (vertical) |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 61 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 74(A5) | get size/count |
| 130(A5) | unknown |
| 242(A5) | unknown |
| 250(A5) | unknown |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 530(A5) | unknown |
| 626(A5) | unknown |
| 1290(A5) | unknown |
| 1298(A5) | unknown |
| 1362(A5) | state_update |
| 1386(A5) | unknown |
| 1394(A5) | unknown |
| 1498(A5) | unknown |
| 1546(A5) | unknown |
| 1570(A5) | unknown |
| 1850(A5) | unknown |
| 2066(A5) | init/copy function |
| 2538(A5) | unknown |
| 2826(A5) | unknown |
| 2842(A5) | unknown |
| 2850(A5) | unknown |
| 2858(A5) | unknown |
| 2866(A5) | unknown |
| 2882(A5) | unknown |
| 2914(A5) | unknown |
| 2922(A5) | unknown |
| 3042(A5) | unknown |
| 3130(A5) | unknown |
| 3346(A5) | unknown |
| 3386(A5) | unknown |
| 3466(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 2 DAWG-related globals
- Uses the two-buffer system (horizontal/vertical word directions)

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: DAWG_MINOR

**Global Variable Profile**: 2 DAWG, 2 UI, 67 total

**Calls functions in**: CODE 3, 7, 9, 11, 12, 14, 17, 21, 22, 27, 34, 36, 41, 46, 47, 51, 52

**Assessment**: DAWG support
