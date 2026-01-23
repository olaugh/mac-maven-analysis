# CODE 22 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 2056 bytes |
| JT Offset | 1376 |
| JT Entries | 6 |
| Functions | 10 |
| Categories | DAWG_ACCESS |
| Purpose | Core DAWG/AI |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x0162, 0x02C8, 0x0486, 0x04A4, 0x058C, 0x0674, 0x06F6, 0x0730, 0x07B0

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-24026 | g_common | Common data area |
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 12 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 74(A5) | get size/count |
| 90(A5) | calculation |
| 354(A5) | unknown |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 658(A5) | init_subsystem |
| 794(A5) | unknown |
| 1066(A5) | unknown |
| 1242(A5) | unknown |
| 1362(A5) | state_update |
| 1514(A5) | unknown |
| 2026(A5) | unknown |
| 2034(A5) | unknown |
| 2066(A5) | init/copy function |
| 2402(A5) | buffer function |
| 2826(A5) | unknown |
| 2842(A5) | unknown |
| 2850(A5) | unknown |
| 2858(A5) | unknown |
| 2866(A5) | unknown |
| 2874(A5) | unknown |
| 2890(A5) | unknown |
| 2906(A5) | unknown |
| 2922(A5) | unknown |
| 3170(A5) | unknown |
| 3178(A5) | unknown |
| 3370(A5) | unknown |
| 3378(A5) | unknown |
| 3466(A5) | unknown |
| 3506(A5) | compare function |
| 3554(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 5 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Core

**Category**: CORE_AI

**Global Variable Profile**: 5 DAWG, 1 UI, 20 total

**Calls functions in**: CODE 2, 9, 10, 11, 14, 16, 21, 24, 27, 32, 34, 41, 51, 52

**Assessment**: Core AI - high priority
