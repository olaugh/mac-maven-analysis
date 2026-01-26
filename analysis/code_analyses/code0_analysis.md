# CODE 0 Analysis - Jump Table

## Overview

| Property | Value |
|----------|-------|
| Size | 3564 bytes |
| Type | **Jump Table (NOT Executable Code)** |
| Categories | SYSTEM |
| Purpose | Segment Loader Jump Table |
| Confidence | **HIGH** |

## Structure

CODE 0 contains the application's jump table, used by the Segment Loader to dispatch function calls to the appropriate CODE segments.

### Header (16 bytes)

```
Offset 0x00: 0000 0E00 = Above A5 size: 3584 bytes
Offset 0x04: 0000 6FEE = Below A5 size: 28654 bytes
Offset 0x08: 0000 0DE0 = Jump table size: 3552 bytes (444 entries × 8 bytes)
Offset 0x0C: 0000 0020 = Jump table offset from A5: 32 bytes
```

### Jump Table Entry Format

Each entry is 8 bytes:
```
Bytes 0-1: Offset within target CODE segment
Bytes 2-3: 3F3C (MOVE.W #imm,-(SP) opcode)
Bytes 4-5: CODE segment number
Bytes 6-7: A9F0 (_LoadSeg trap)
```

When called, if the segment isn't loaded:
1. Push segment number onto stack
2. Call _LoadSeg trap ($A9F0)
3. Segment loader loads CODE resource
4. Patches entry to direct jump

## Complete Jump Table Dump

### CODE 1 Entries (Runtime Library)

| JT Offset | Target | Function |
|-----------|--------|----------|
| 66 | 0x00A6 | switch_dispatch_linear |
| 74 | 0x00BA | switch_dispatch_variant |
| 82 | 0x00CE | switch_dispatch_range |
| 90 | 0x00EA | multiply_32bit |
| 98 | 0x0120 | divide_signed_quotient |
| 106 | 0x0140 | divide_signed_remainder |
| 114 | 0x0162 | divmod |
| 122 | 0x0182 | modulo |
| 130 | 0x023C | unsigned_divide_core |

### CODE 2 Entries (Resource Loading)

| JT Offset | Target | Function |
|-----------|--------|----------|
| 80 | 0x027E | port_function |
| 88 | 0x0250 | update_function |
| 96 | 0x0000 | main_resource_init |
| 104 | 0x002C | resource_helper |

### CODE 3 Entries (DAWG Core)

| JT Offset | Target | Function |
|-----------|--------|----------|
| 112 | 0x0000 | dawg_main_search |
| 120 | 0x02C2 | dawg_bounds_check |
| 128 | 0x0E12 | dawg_query |
| 136 | 0x0EBE | dawg_validate |
| 144 | 0x0EE2 | dawg_traverse |
| 152 | 0x0EFC | dawg_finalize |

### Sample Hex Dump with Annotations

```asm
; Header
0000: 0000 0E00     ; Above A5 = 3584 bytes
0004: 0000 6FEE     ; Below A5 = 28654 bytes
0008: 0000 0DE0     ; JT size = 3552 bytes
000C: 0000 0020     ; JT offset = 32

; First entry (offset 0x10 = 16)
0010: 0008          ; Target offset in segment
0012: 3F3C          ; MOVE.W #imm,-(SP)
0014: 0001          ; CODE 1
0016: A9F0          ; _LoadSeg

; Entry for CODE 1 function (JT[66])
0042: 00A6          ; Offset 0x00A6 in CODE 1
0044: 3F3C          ; MOVE.W #imm,-(SP)
0046: 0001          ; CODE 1
0048: A9F0          ; _LoadSeg

; Entry for CODE 3 main search (JT[112])
0070: 0000          ; Offset 0x0000 in CODE 3
0072: 3F3C          ; MOVE.W #imm,-(SP)
0074: 0003          ; CODE 3
0076: A9F0          ; _LoadSeg
```

## Segment Statistics

| Segment | JT Entries | Size (bytes) | Primary Function |
|---------|------------|--------------|------------------|
| CODE 1 | 10 | 574 | Runtime library, math |
| CODE 2 | 4 | 750 | Resource loading |
| CODE 3 | 6 | 4390 | DAWG search core |
| CODE 5 | 1 | 204 | DAWG support |
| CODE 6 | 7 | 1026 | DAWG support |
| CODE 7 | 13 | 2872 | Board state mgmt |
| CODE 8 | 3 | 2326 | DAWG processing |
| CODE 10 | 3 | 138 | Small utility |
| CODE 11 | 19 | 4478 | Game controller |
| CODE 12 | 8 | 2722 | UI support |
| CODE 13 | 4 | 512 | File I/O, menus |
| CODE 14 | 14 | 2766 | DAWG support |
| CODE 15 | 5 | 3568 | Word Lister |
| CODE 16 | 5 | 1894 | File operations |
| CODE 17 | 29 | 2618 | UI drawing |
| CODE 18 | 4 | 4460 | General |
| CODE 19 | 10 | 382 | UI support |
| CODE 20 | 17 | 3398 | DAWG minor |
| CODE 21 | 39 | 13718 | Main UI (largest) |
| CODE 22 | 6 | 2056 | DAWG core |
| CODE 23 | 7 | 608 | Utilities |
| CODE 24 | 3 | 6786 | File save/load |
| CODE 25 | 1 | 200 | Utility |
| CODE 27 | 4 | 662 | DAWG minor |
| CODE 28 | 3 | 664 | DAWG support |
| CODE 29 | 8 | 686 | DAWG minor |
| CODE 30 | 12 | 3492 | DAWG core |
| CODE 31 | 15 | 2510 | DAWG support |
| CODE 32 | 13 | 6464 | Leave calculation |
| CODE 34 | 31 | 1388 | General |
| CODE 35 | 4 | 3276 | File I/O |
| CODE 36 | 5 | 9102 | Move scoring |
| CODE 37 | 4 | 5344 | Large segment |
| CODE 38 | 2 | 374 | DAWG minor |
| CODE 39 | 4 | 1784 | General |
| CODE 40 | 4 | 624 | DAWG minor |
| CODE 41 | 8 | 660 | UI support |
| CODE 42 | 2 | 734 | General |
| CODE 43 | 4 | 1486 | General |
| CODE 44 | 4 | 424 | DAWG minor |
| CODE 45 | 4 | 1122 | DAWG support |
| CODE 46 | 12 | 2904 | UI drawing |
| CODE 47 | 4 | 908 | Utilities |
| CODE 48 | 15 | 1092 | Utilities |
| CODE 49 | 2 | 546 | Utilities |
| CODE 50 | 1 | 1174 | File UI |
| CODE 51 | 6 | 236 | Utilities |
| CODE 52 | 14 | 938 | Common utilities |
| CODE 53 | 1 | 106 | Small utility |
| CODE 54 | 1 | 42 | Small utility |

**Total**: ~444 jump table entries across 52 CODE segments

## Memory Layout

```
         +------------------------+
A5+3584  | Top of JT area         |
         +------------------------+
A5+32    | Jump table (3552 bytes)|
         | 444 entries × 8 bytes  |
         +------------------------+
A5       | Global data base       |
         +------------------------+
         | Application globals    |
         | (28654 bytes)          |
         +------------------------+
A5-28654 | Bottom of globals      |
         +------------------------+
```

## Analysis Notes

- **Not executable**: CODE 0 is a data structure, not code
- **Segment Manager**: Mac OS uses this for demand-loading CODE resources
- **Patching**: After loading, entries become direct JMP instructions
- **A5 register**: Central to Mac application memory model
- **Trap $A9F0**: _LoadSeg - segment loader trap

## Confidence Levels

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Structure format | HIGH | Standard Mac jump table |
| Entry decoding | HIGH | Well-documented format |
| Segment mapping | HIGH | Numbers directly in data |
| Function purposes | LOW-MEDIUM | Inferred from analysis |
