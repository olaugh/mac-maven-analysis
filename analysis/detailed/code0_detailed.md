# CODE 0 Detailed Analysis - Jump Table

## Overview

| Property | Value |
|----------|-------|
| Size | 3,564 bytes |
| JT Offset | 0 |
| JT Entries | 3584 (header claim) |
| Purpose | **Jump Table - NOT executable code** |

## Critical Understanding

CODE 0 is **not executable code** - it's the application's **jump table**. This is a standard Classic Mac OS convention where CODE 0 contains a table that maps function offsets to their actual locations across all CODE segments.

## Structure

The jump table consists of 8-byte entries:
```
struct JumpTableEntry {
    uint16_t offset;      // Offset within the CODE segment
    uint16_t push_instr;  // MOVE.W #seg,-(SP) instruction (3F3C)
    uint16_t segment;     // CODE segment number
    uint16_t trap;        // LoadSeg trap (A9F0)
};
```

## Disassembly Pattern Analysis

The disassembler interprets the jump table data as instructions, which produces misleading output. The actual format is:

```
Raw bytes: A9F0 OOOO 3F3C SSSS
Where:
  - A9F0 = _LoadSeg trap (or patched JSR)
  - OOOO = Offset within segment
  - 3F3C = MOVE.W #imm,-(SP) opcode
  - SSSS = Segment number
```

After a segment is loaded, the trap is patched to a direct JSR.

## Jump Table Mapping (Decoded from Disassembly)

Based on the raw hex patterns visible in the disassembly:

| JT Offset | CODE Segment | Function Offset | Notes |
|-----------|--------------|-----------------|-------|
| 0x0008 | CODE 1 | 0x0000 | Entry point |
| 0x005A | CODE 2 | 0x027E | Resource/data loading |
| 0x0062 | CODE 2 | 0x0250 | Data copy |
| 0x006A | CODE 2 | 0x0000 | Init resources |
| 0x0072 | CODE 2 | 0x002C | Event handler |
| 0x007A | CODE 3 | various | DAWG search |
| 0x009A | CODE 3 | 0x0000 | Main search entry |
| 0x00AA | CODE 5 | 0x0000 | UI code |
| 0x00B2 | CODE 6 | 0x038A | Game logic |
| 0x00EA | CODE 7 | 0x0A70 | Board state |
| 0x014A | CODE 7 | 0x0000 | Init board |
| 0x0152 | CODE 8 | 0x0714 | Apply move |
| 0x015A | CODE 8 | 0x0000 | Calculate score |
| 0x0162 | CODE 8 | 0x0370 | Validate move |
| 0x016A | CODE 10 | 0x0000 | Cursor/dialog |
| 0x01AA | CODE 11 | 0x037E | memset |
| 0x05AA | CODE 9 | 0x018E | Runtime support |

## How Calls Work

When code calls `JSR xxx(A5)`:
1. A5 points to the application globals area
2. Positive offsets into A5 area reach the jump table
3. Entry at that offset is read
4. If segment not loaded, A9F0 (_LoadSeg) loads it
5. Control transfers to the target function

## Segment Distribution

Analyzing the jump table entries:

| Segment | Entry Count | Primary Purpose |
|---------|-------------|-----------------|
| CODE 1 | ~10 | Runtime initialization, math |
| CODE 2 | 4 | Resource loading |
| CODE 3 | 6 | DAWG search coordination |
| CODE 4 | 2 | Unknown |
| CODE 5 | 1 | UI code |
| CODE 6 | 7 | Game logic |
| CODE 7 | 13 | Board state management |
| CODE 8 | 3 | Move scoring |
| CODE 9 | 37 | Runtime support library |
| CODE 10 | 3 | Cursor/dialog |
| CODE 11 | 18 | Utility functions |

## Key Jump Table Offsets

Based on frequency analysis across all CODE resources:

| JT Offset | Purpose | Confidence |
|-----------|---------|------------|
| 66(A5) | Multiply (for index calc) | HIGH |
| 90(A5) | Division | HIGH |
| 274(A5) | SetCursor | HIGH |
| 362(A5) | DAWG traversal | MEDIUM |
| 418(A5) | bounds_check/assert | HIGH |
| 426(A5) | memset | HIGH |
| 506(A5) | Callback lookup | MEDIUM |
| 658(A5) | Init subsystem | MEDIUM |
| 962(A5) | Redraw board | HIGH |
| 986(A5) | Update cell | HIGH |
| 1666(A5) | NewPtr wrapper | HIGH |
| 1682(A5) | FreeMem wrapper | HIGH |
| 2066(A5) | sprintf-like format | HIGH |
| 2370(A5) | Setup params | MEDIUM |
| 2410(A5) | Init/setup buffer | HIGH |
| 3466(A5) | memcpy | HIGH |
| 3490(A5) | Copy to global | HIGH |
| 3522(A5) | strlen | HIGH |

## Classic Mac CODE Segment Model

```
+-------------------------------------+
|           Application Heap          |
+-------------------------------------+
|  CODE 0: Jump Table (always loaded) |
+-------------------------------------+
|  CODE 1: Startup (loaded first)     |
+-------------------------------------+
|  CODE N: Loaded on demand           |
|          via _LoadSeg trap          |
+-------------------------------------+
|  A5 World: Globals + QuickDraw      |
+-------------------------------------+
```

## Size Discrepancy

The header claims 3584 JT entries (28,672 bytes), but CODE 0 is only 3,564 bytes. This indicates:
1. The header value may be a version number or other data
2. Actual entries = 3564 / 8 = ~445 entries
3. Some entries may be dynamically allocated

## Confidence: HIGH

This is standard Classic Mac architecture. The pattern of A9F0 traps followed by segment numbers is unmistakable. The disassembler's attempt to interpret this as code produces the garbled output seen in the disassembly.
