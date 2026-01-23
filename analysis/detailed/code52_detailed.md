# CODE 52 Detailed Analysis - DAWG Entry Flag Accessors

## Overview

| Property | Value |
|----------|-------|
| Size | 938 bytes |
| JT Offset | 3424 |
| JT Entries | 14 |
| Functions | 14 |
| Purpose | **DAWG entry flag/field extraction** |

## Critical Discovery

CODE 52 is a set of **DAWG entry accessor functions**! All functions follow the exact same pattern but extract different bit fields from a DAWG entry byte. This is the low-level interface to DAWG data.

## Common Pattern

Every function in CODE 52 follows this pattern:
```asm
LINK       A6,#0
MOVEQ      #0,D0
MOVE.B     9(A6),D0         ; Get byte param (entry index or offset)
MOVEA.L    A5,A0
ADD.L      D0,A0            ; A0 = A5 + offset (points into DAWG data)
MOVE.B     (A0),D0          ; Read the flags byte
EXT.W      D0               ; Sign extend to word
ANDI.W     #mask,D0         ; Mask specific bits
UNLK       A6
RTS
```

## Function Mapping - Bit Field Extraction

| Offset | JT Offset | Mask | Bits | Likely Purpose |
|--------|-----------|------|------|----------------|
| 0x0000 | 3424 | 0x00D0 | 4,6,7 | Combined flags |
| 0x001C | 3432 | 0x00C0 | 6,7 | High flags |
| 0x0038 | 3440 | 0x0003 | 0,1 | **Last sibling / terminal** |
| 0x0054 | 3448 | 0x0010 | 4 | Some flag |
| 0x0070 | 3456 | 0x00D8 | 3,4,6,7 | Combined flags |
| 0x008C | 3464 | 0x0080 | 7 | **End-of-word flag** |
| 0x00A8 | 3472 | 0x00DC | 2,3,4,6,7 | Combined flags |
| 0x00C4 | 3480 | 0x0008 | 3 | Some flag |
| 0x00E0 | 3488 | 0x0006 | 1,2 | Some flags |
| 0x00FC | 3496 | 0x0040 | 6 | Some flag |
| 0x0118 | 3504 | 0x0030 | 4,5 | Some flags |

## Mapping to DAWG Entry Structure

Based on earlier analysis, DAWG entries are 4 bytes:
```
Byte 0-1: Child pointer (16 bits)
Byte 2:   Flags
Byte 3:   Letter (ASCII)
```

The flags byte (byte 2) appears to have this structure:
```
Bit 7 (0x80): End-of-word - this path forms a complete word
Bit 6 (0x40): Unknown flag
Bit 5 (0x20): Unknown flag
Bit 4 (0x10): Unknown flag
Bit 3 (0x08): Unknown flag
Bit 2 (0x04): Unknown flag
Bit 1 (0x02): Unknown flag
Bit 0 (0x01): Last sibling - no more siblings at this level
```

## C Equivalent

```c
// CODE 52 provides these DAWG flag accessors:

// Get bits 4,6,7 (combined flags)
int get_flags_D0(DawgEntry* entry) {
    return entry->flags & 0xD0;
}

// Get bits 6,7 (high flags)
int get_high_flags(DawgEntry* entry) {
    return entry->flags & 0xC0;
}

// Get bits 0,1 (terminal/last sibling)
int get_terminal_flags(DawgEntry* entry) {
    return entry->flags & 0x03;
}

// Get bit 7 (end-of-word)
int is_end_of_word(DawgEntry* entry) {
    return entry->flags & 0x80;
}

// etc.
```

## Why 23 CODE Segments Call This

CODE 52 is called by nearly half of all CODE segments because:
1. It's the **only way to access DAWG entry flags**
2. Every DAWG traversal needs to check end-of-word and sibling flags
3. The consistent interface allows the compiler to inline these efficiently

## Call Pattern Analysis

From the call graph, CODE 52 is called by:
- All DAWG core codes (3, 7, 11, 21, 22, 30)
- All DAWG support codes (5, 6, 8, 14, 15, etc.)
- Even FILE_IO and utility codes that need to parse DAWG data

## Key Insight

**JT[3466] and JT[3490]** (which appear in many call lists) are likely:
- **3466(A5)** → CODE 52's `get_end_of_word()` (mask 0x80 at offset 0x008C)
- **3490(A5)** → CODE 52's `get_terminal()` (mask 0x03 at offset 0x0038)

This explains why these are the most frequently called JT functions - every DAWG node traversal needs to check these flags!

## Confidence: VERY HIGH

The repetitive pattern with different bit masks is unmistakable. This is definitely a set of bit-field accessors for a data structure, and given the calling pattern and A5-relative addressing, it's accessing DAWG entry flags.
