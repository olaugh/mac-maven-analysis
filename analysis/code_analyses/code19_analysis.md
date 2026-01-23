# CODE 19 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 382 bytes |
| JT Offset | 848 |
| JT Entries | 10 |
| Functions | 12 |
| Categories | UNKNOWN |
| Purpose | Unknown |
| Confidence | LOW |

## Functions

Entry points at: 0x0000, 0x001E, 0x0044, 0x0062, 0x0088, 0x00A6, 0x00CC, 0x00EA, 0x0112, 0x012E, 0x0154, 0x0172

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-8584 | g_handle | Handle to data structure |

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 202(A5) | unknown |
| 962(A5) | unknown |
| 970(A5) | unknown |
| 1154(A5) | unknown |
| 1274(A5) | unknown |

## Analysis Notes

- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: UI_SUPPORT

**Global Variable Profile**: 0 DAWG, 1 UI, 1 total

**Calls functions in**: CODE 6, 20, 21

**Assessment**: Utility functions
