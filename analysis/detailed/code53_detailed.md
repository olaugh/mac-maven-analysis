# CODE 53 Detailed Analysis - Random Number Generator / Hash Function

## Overview

| Property | Value |
|----------|-------|
| Size | 106 bytes |
| JT Offset | 3408 |
| JT Entries | 1 |
| Functions | 1 |
| Purpose | **Generate hash values using random table** |


## System Role

**Category**: Utility
**Function**: Hash/Random Generator

Provides table-based hash computation for strings, with lazy table initialization.

## Architecture Role

CODE 53 provides pseudo-random hash generation:
1. Lazily initialize 16-entry random table on first call
2. Hash input using table-based mixing
3. Provide consistent hash sequences for same input
4. Support game randomization (tile drawing, position hashing)

## Key Function

### Function 0x0000 - Hash/Random Generator
```asm
; Entry
0000: LINK       A6,#0
0004: MOVEM.L    D6/D7/A2/A3/A4,-(SP)  ; Save registers
0008: MOVEA.L    8(A6),A3              ; A3 = input string pointer
000C: MOVEA.L    A3,A4                 ; A4 = working pointer
000E: MOVE.B     12(A6),D0             ; Get length parameter
...
0014: MOVEQ      #0,D7                 ; D7 = hash accumulator (0)

; Check if random table is initialized
0014: TST.L      -1128(A5)             ; g_random_table[0]
0018: BNE.S      $0032                 ; Already initialized - skip

; Initialize 16-entry random table
001A: MOVEQ      #0,D6                 ; D6 = index counter (0)
001C: LEA        -1128(A5),A2          ; A2 = g_random_table base

; Loop: fill table with 16 random values
0020: BRA.S      $002C                 ; Jump to loop test
0022: JSR        1458(A5)              ; JT[1458] - Random (Mac Toolbox)
0026: MOVE.L     D0,(A2)               ; Store random value in table
0028: ADDQ.W     #1,D6                 ; index++
002A: ADDQ.L     #4,A2                 ; Advance to next table entry
002C: CMPI.W     #$0010,D6             ; Compare index to 16
0030: BCS.S      $0022                 ; If < 16, continue loop

; Verify initialization succeeded
0032: TST.L      -1128(A5)             ; Check first entry
0036: BNE.S      $005C                 ; Non-zero = OK
0038: JSR        418(A5)               ; JT[418] - error handler
003C: BRA.S      $005C                 ; Continue anyway

; Hash computation loop
003E: MOVE.B     (A3),D0               ; Get next char from input
0040: EXT.W      D0                    ; Sign extend to word

; Mix hash accumulator
0042: MOVE.L     D7,D1                 ; Copy accumulator
0044: LSR.L      #1,D1                 ; Shift right by 1 (divide by 2)
0046: MOVEQ      #15,D2                ; D2 = 0x0F (mask)
0048: AND.L      D7,D2                 ; index = hash & 0x0F (low 4 bits)

; Add table entry
004A: MOVEA.L    A5,A0
004C: LSL.L      #2,D2                 ; index * 4 (long size)
...
0050: ADD.L      -1128(A0,D2.L),D1     ; D1 += random_table[index]

; Add character value
0054: MOVEA.W    D0,A0                 ; char value in A0
0056: ADD.L      A0,D1                 ; D1 += char

; Store and advance
0058: MOVE.L     D1,D7                 ; Update accumulator
005A: ADDQ.L     #1,A3                 ; Advance string pointer

; Check if at end of input
005C: CMP.L      A4,A3                 ; Compare current to end
005E: BCS.S      $003E                 ; Continue if not done

; Return hash value
0060: MOVE.L     D7,D0                 ; Return accumulator as hash

; Cleanup
0062: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
0066: UNLK       A6
0068: RTS
```

## Algorithm Analysis

### Initialization Phase
```c
// First-call initialization
if (g_random_table[0] == 0) {
    for (int i = 0; i < 16; i++) {
        g_random_table[i] = Random();  // Mac Toolbox Random()
    }

    // Verify (Random() returning 0 would be bad)
    if (g_random_table[0] == 0) {
        error_handler();
    }
}
```

### Hash Computation Phase
```c
// Process each character
long hash = 0;
while (ptr < end) {
    char c = *ptr++;

    // Mix operations:
    // 1. Shift accumulator right (spread bits)
    // 2. Use low 4 bits as table index
    // 3. Add random table entry
    // 4. Add character value

    hash = (hash >> 1) + g_random_table[hash & 0x0F] + c;
}
```

## Data Structures

### Random Table
```c
// Located at A5-1128, 64 bytes (16 longs)
long g_random_table[16];  // At A5-1128
```

## Global Variables

| Offset | Type | Purpose |
|--------|------|---------|
| A5-1128 | long[16] | g_random_table - 16-entry random lookup table (64 bytes) |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 1458 | Random - Mac toolbox random number (0-65535) |

## Hash Properties

The algorithm provides:
- **Deterministic**: Same input always produces same hash (after table init)
- **Good distribution**: Table mixing spreads values
- **Fast**: Simple shift/add/lookup operations
- **16-bit sensitivity**: All input bits affect output via table indexing

## Use Cases in Maven

1. **Tile Bag Randomization**: Generate shuffled tile sequence
2. **Transposition Table**: Hash board positions for AI search memoization
3. **Game Seed**: Initialize reproducible random games
4. **Move Ordering**: Hash-based tie-breaking for move evaluation

## C Equivalent

```c
long hash_string(char* input, int length) {
    static long random_table[16];
    static Boolean initialized = false;

    // Lazy initialization of random table
    if (!initialized || random_table[0] == 0) {
        for (int i = 0; i < 16; i++) {
            random_table[i] = Random();  // Mac Toolbox
        }
        initialized = true;

        // Sanity check
        if (random_table[0] == 0) {
            error_handler();
        }
    }

    // Compute hash
    long hash = 0;
    char* end = input + length;

    while (input < end) {
        char c = *input++;

        // Mix: shift, lookup, add
        int index = hash & 0x0F;  // Low 4 bits
        hash = (hash >> 1) + random_table[index] + c;
    }

    return hash;
}
```

## Table Memory Layout

```
A5-1128: random_table[0]   (4 bytes)
A5-1124: random_table[1]   (4 bytes)
A5-1120: random_table[2]   (4 bytes)
...
A5-1068: random_table[15]  (4 bytes)
```

Total: 64 bytes (16 * 4)

## Hash Quality Analysis

The hash function is simple but effective:
- Right shift spreads high bits into low bits
- Table lookup provides non-linearity
- Character addition incorporates input

Weaknesses:
- Only 16 table entries (4-bit index)
- Simple mixing may have collision patterns
- No avalanche guarantee (small input changes may not flip all output bits)

For Maven's purposes (move hashing, game seeding), this is sufficient.

## Confidence: HIGH

Clear pseudo-random hash patterns:
- Table-based randomization with lazy init
- Accumulator mixing algorithm
- Standard PRNG seeding from Mac Random()
- Loop structure matches typical hash computation
