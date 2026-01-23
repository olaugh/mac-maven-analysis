# CODE 30 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 3492 bytes |
| JT Offset | 2168 |
| JT Entries | 12 |
| Functions | 15 |
| Categories | DAWG_ACCESS |
| Purpose | Core DAWG/AI |
| Confidence | HIGH |

## Functions

Entry points at: 0x001C, 0x004A, 0x014A, 0x072A, 0x07A0, 0x07F8, 0x08BA, 0x0920, 0x09C2, 0x0A98, 0x0AF4, 0x0BB8, 0x0C1E, 0x0CCE, 0x0D62

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-23074 | g_dawg_ptr | Main DAWG data pointer |
| A5-23070 | g_sect1_off | Section 1 offset |
| A5-23066 | g_sect2_off | Section 2 offset |
| A5-23056 | g_dawg_field | DAWG related field |
| A5-15522 | g_field_22 | Board buffer 2 (horizontal) |
| A5-15514 | g_field_14 | Board buffer 1 (vertical) |

Also references 19 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | common utility |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 1690(A5) | unknown |
| 1698(A5) | unknown |
| 2114(A5) | unknown |
| 2122(A5) | buffer comparison/scoring |
| 2322(A5) | unknown |
| 2370(A5) | setup_params |
| 2386(A5) | unknown |
| 2410(A5) | setup_buffer |
| 2434(A5) | setup_more |
| 2450(A5) | unknown |
| 2594(A5) | unknown |
| 2618(A5) | unknown |
| 2802(A5) | unknown |
| 2810(A5) | unknown |
| 3442(A5) | unknown |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3506(A5) | compare function |
| 3522(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 5 DAWG-related globals
- Uses the two-buffer system (horizontal/vertical word directions)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: CORE_AI

**Global Variable Profile**: 7 DAWG, 0 UI, 28 total

**Calls functions in**: CODE 9, 11, 29, 31, 32, 34, 38, 39, 52

**Assessment**: DAWG support
