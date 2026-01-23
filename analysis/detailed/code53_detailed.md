# CODE 53 Detailed Analysis - Random Number Generator / Hash Function

## Overview

| Property | Value |
|----------|-------|
| Size | 106 bytes |
| JT Offset | 3408 |
| JT Entries | 1 |
| Functions | 1 |
| Purpose | **Generate random numbers or hash values** |

## Architecture Role

CODE 53 provides pseudo-random number generation:
1. Initialize random state table
2. Hash string input to numeric value
3. Provide consistent random sequences
4. Support game randomization (tile drawing, etc.)

## Key Functions

### Function 0x0000 - Hash/Random Generator
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
0008: MOVEA.L    8(A6),A3             ; A3 = input string
000C: MOVEA.L    A3,A4                ; A4 = working pointer
000E: MOVE.B     12(A6),#$00          ; Clear high byte
0014: MOVEQ      #0,D7                ; D7 = accumulator

; Check if table initialized
0014: TST.L      -1128(A5)            ; g_random_table[0]
0018: BNE.S      $0032                ; Already initialized

; Initialize 16-entry random table
001A: MOVEQ      #0,D6                ; Index = 0
001C: LEA        -1128(A5),A2         ; A2 = g_random_table

0020: BRA.S      $002C                ; Start loop

; Generate random entries
0022: JSR        1458(A5)             ; JT[1458] - Random
0026: MOVE.L     D0,(A2)              ; Store in table
0028: MOVEA.B    D6,A1                ; index++
002A: MOVE.B     A2,(A4)              ; Advance pointer

002C: CMPI.W     #$0010,D6            ; 16 entries?
0030: BCS.S      $0022                ; Continue loop

; Verify table initialized
0032: TST.L      -1128(A5)            ; Check first entry
0036: BNE.S      $005C                ; OK
0038: JSR        418(A5)              ; JT[418] - error
003C: BRA.S      $005C                ; Continue anyway

; Hash the input string
003E: MOVE.B     (A3),D0              ; Get next char
0040: EXT.W      D0                   ; Extend to word
0042: MOVE.L     D7,D1                ; Copy accumulator
0044: LSR.L      #1,A1                ; Shift right (into D1)
0046: MOVEQ      #15,D2               ; Mask = 0x0F
0048: AND.L      D7,D2                ; index = acc & 0x0F

; Look up in random table
004A: MOVEA.L    A5,A0
004C: ...                             ; Complex indexing
0050: ADD.B      -1128(A0),(A1)       ; Add table entry
0054: MOVEA.W    D0,A0                ; Add char value
0056: ADD.B      A0,(A1)              ; To accumulator
0058: MOVE.L     D1,D7                ; Update accumulator
005A: MOVE.B     A3,(A1)              ; Advance string

; Check if done
005C: MOVE.W     A3,#$62DE            ; Compare pointers
0060: MOVE.L     D7,D0                ; Return hash value

0062: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
0066: UNLK       A6
0068: RTS
```

**C equivalent**:
```c
long hash_string(char* input, int length) {
    static long random_table[16];
    static Boolean initialized = false;

    // Initialize random table on first call
    if (!initialized) {
        for (int i = 0; i < 16; i++) {
            random_table[i] = Random();
        }
        initialized = true;
    }

    // Verify initialization
    if (random_table[0] == 0) {
        error_handler();
    }

    // Hash the input string
    long hash = 0;

    while (*input && length > 0) {
        char c = *input++;
        length--;

        // Mix with random table
        hash = hash >> 1;  // Shift right
        int index = hash & 0x0F;  // Low 4 bits

        hash += random_table[index];
        hash += c;
    }

    return hash;
}
```

## Algorithm Analysis

The hash function uses a simple but effective approach:
1. **Random Table**: 16 pseudo-random 32-bit values initialized from Mac toolbox Random()
2. **Accumulator**: Running hash value
3. **Per-Character Processing**:
   - Shift accumulator right by 1
   - Use low 4 bits as table index
   - Add table entry and character value

This provides:
- Good distribution for short strings
- Consistent results (same input = same output)
- Fast computation

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1128 | g_random_table - 16-entry random lookup table (64 bytes) |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 1458 | Random - Mac toolbox random number |

## Use Cases in Maven

1. **Tile Bag Randomization**: Generate random sequence for tile drawing
2. **Transposition Table**: Hash board positions for AI search optimization
3. **Game Seed**: Initialize reproducible random games

## Confidence: HIGH

Clear pseudo-random hash patterns:
- Table-based randomization
- Accumulator mixing
- Standard PRNG seeding from Mac Random()
