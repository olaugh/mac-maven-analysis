# CODE 0 Detailed Analysis - Jump Table

## Overview

| Property | Value |
|----------|-------|
| Size | 3,564 bytes |
| JT Offset | 0 |
| JT Entries | 3584 |
| Purpose | **Jump Table - NOT executable code** |


## System Role

**Category**: Core System
**Function**: Segment Loader

Initializes A5 global pointer, loads code segments on demand
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

The disassembler interprets the jump table data as instructions, which is why we see patterns like:
```asm
00AA: A9F0 00003F3C 0005  ; Actually: offset=0, push CODE 5, LoadSeg
00B2: A9F0 038A3F3C 0006  ; Actually: offset=$038A, push CODE 6, LoadSeg
```

## Jump Table Mapping (Partial)

Decoding the raw data, we can map JT offsets to CODE segments:

| JT Offset | CODE Segment | Function Offset |
|-----------|--------------|-----------------|
| 66 | CODE 1 | $00xx |
| 74 | CODE 1 | $00xx |
| 80-104 | CODE 2 | various |
| 112-152 | CODE 3 | various |
| 160 | CODE 5 | $0000 |
| 168-216 | CODE 6 | various |
| 224-320 | CODE 7 | various |
| 328-344 | CODE 8 | various |
| 352-368 | CODE 10 | various |
| 376-520 | CODE 11 | various |
| ... | ... | ... |

## How Calls Work

When code calls `JSR 418(A5)`:
1. A5 points to the jump table
2. Entry at offset 418 is read
3. If segment not loaded, A9F0 (_LoadSeg) loads it
4. Control transfers to the target function

## Key Entry Points

Based on frequency analysis:

| JT Offset | Segment | Purpose |
|-----------|---------|---------|
| 418 | CODE 11 | bounds_check/error |
| 426 | CODE 11 | memset |
| 362 | ? | DAWG traversal |
| 2066 | CODE 17 | data copy |
| 3490 | CODE 52 | global copy |

## Why 3584 Entries?

The header says 3584 JT entries × 8 bytes = 28,672 bytes, but CODE 0 is only 3,564 bytes. This suggests:
1. Not all entries are used
2. The header may include reserved space
3. Some entries may be dynamically allocated

## Classic Mac CODE Segment Model

```
┌─────────────────────────────────────┐
│           Application Heap          │
├─────────────────────────────────────┤
│  CODE 0: Jump Table (always loaded) │
├─────────────────────────────────────┤
│  CODE 1: Startup (loaded first)     │
├─────────────────────────────────────┤
│  CODE N: Loaded on demand           │
│          via _LoadSeg trap          │
├─────────────────────────────────────┤
│  A5 World: Globals + QuickDraw      │
└─────────────────────────────────────┘
```

## Confidence: HIGH

This is standard Classic Mac architecture. The pattern of A9F0 traps followed by segment numbers is unmistakable.
