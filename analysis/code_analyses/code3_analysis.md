# CODE 3 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 4390 bytes |
| JT Offset | 112 |
| JT Entries | 6 |
| Functions | 16 |
| Categories | DAWG_ACCESS |
| Purpose | Core DAWG/AI |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000, 0x019E, 0x01DA, 0x0264, 0x02C2, 0x069E, 0x0C54, 0x0E12, 0x0E1E, 0x0EBE, 0x0EE2, 0x0EFC, 0x0F68, 0x109C, 0x10F0, 0x1114

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-28628 | g_buffer2 | Buffer area 2 |
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-23074 | g_dawg_ptr | Main DAWG data pointer |
| A5-23070 | g_sect1_off | Section 1 offset |
| A5-23066 | g_sect2_off | Section 2 offset |
| A5-23056 | g_dawg_field | DAWG related field |
| A5-15522 | g_field_22 | Board buffer 2 (horizontal) |
| A5-15514 | g_field_14 | Board buffer 1 (vertical) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-11972 | g_dawg_ptr2 | Secondary DAWG pointer |
| A5-10388 | g_lookup_tbl | Lookup table |

Also references 22 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 74(A5) | get size/count |
| 90(A5) | calculation |
| 362(A5) | process_dawg - DAWG traversal |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 490(A5) | unknown |
| 666(A5) | copy_buffer |
| 674(A5) | init function |
| 682(A5) | check function |
| 962(A5) | unknown |
| 1034(A5) | unknown |
| 1066(A5) | unknown |
| 1234(A5) | unknown |
| 1250(A5) | unknown |
| 1258(A5) | post-search init |
| 1282(A5) | check function |
| 1306(A5) | unknown |
| 1346(A5) | data function |
| 1362(A5) | state_update |
| 1434(A5) | unknown |
| 1490(A5) | unknown |
| 1506(A5) | unknown |
| 1522(A5) | unknown |
| 1602(A5) | unknown |
| 1650(A5) | finalize |
| 1706(A5) | unknown |
| 1714(A5) | unknown |
| 1738(A5) | unknown |
| 1746(A5) | unknown |
| 1754(A5) | setup function |
| 2066(A5) | init/copy function |
| 2074(A5) | unknown |
| 2122(A5) | buffer comparison/scoring |
| 2130(A5) | unknown |
| 2202(A5) | data copy |
| 2346(A5) | check_result |
| 2362(A5) | unknown |
| 2370(A5) | setup_params |
| 2394(A5) | setup function |
| 2402(A5) | buffer function |
| 2410(A5) | setup_buffer |
| 2458(A5) | unknown |
| 2530(A5) | unknown |
| 2586(A5) | unknown |
| 2626(A5) | unknown |
| 2634(A5) | unknown |
| 2826(A5) | unknown |
| 2850(A5) | unknown |
| 2866(A5) | unknown |
| 3218(A5) | unknown |
| 3282(A5) | unknown |
| 3338(A5) | unknown |
| 3378(A5) | unknown |
| 3450(A5) | lookup |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3506(A5) | compare function |
| 3522(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 8 DAWG-related globals
- Uses the two-buffer system (horizontal/vertical word directions)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Core

**Category**: CORE_AI

**Global Variable Profile**: 11 DAWG, 0 UI, 37 total

**Calls functions in**: CODE 2, 4, 9, 10, 11, 14, 17, 20, 21, 27, 29, 30, 31, 32, 34, 36, 37, 39, 47, 48, 51, 52

**Assessment**: Core AI - high priority
