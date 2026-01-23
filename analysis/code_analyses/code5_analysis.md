# CODE 5 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 204 bytes |
| JT Offset | 160 |
| JT Entries | 1 |
| Functions | 1 |
| Categories | DAWG_ACCESS |
| Purpose | Unknown |
| Confidence | HIGH |

## Functions

Entry points at: 0x0000

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8604 | g_game_mode | Game mode/state flag |

Also references 2 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 298(A5) | unknown |
| 658(A5) | init_subsystem |
| 1018(A5) | unknown |
| 1258(A5) | post-search init |
| 1354(A5) | unknown |
| 1362(A5) | state_update |
| 1418(A5) | unknown |
| 2402(A5) | buffer function |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |

## Analysis Notes

- **DAWG-related**: Uses 4 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: CORE_AI

**Global Variable Profile**: 5 DAWG, 1 UI, 9 total

**Calls functions in**: CODE 7, 14, 20, 21, 22, 32, 52

**Assessment**: DAWG support
