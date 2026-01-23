# CODE 4 Detailed Analysis - Random Number Generator

## Overview

| Property | Value |
|----------|-------|
| Size | 108 bytes |
| JT Offset | 1424 |
| JT Entries | 2 |
| Functions | 3 |
| Purpose | **Random number generation, GCD calculation** |


## System Role

**Category**: Utility
**Function**: Small Helper

Minimal utility functions for random numbers and mathematical operations.

## Architecture Role

CODE 4 provides random number services:
1. Linear feedback shift register (LFSR) random number generator
2. GCD (Greatest Common Divisor) calculation using Euclidean algorithm
3. Seed management for reproducible random sequences

## Key Functions

### Function 0x0000 - Get Random Number
```asm
; From disassembly:
0000: 2F07          MOVE.L     D7,-(A7)             ; Save D7
0002: 2E2DF23C      MOVE.L     -3524(A5),D7         ; D7 = seed (g_random_seed)
0006: 2007          MOVE.L     D7,D0                ; D0 = seed
0008: E888          LSR.L      #4,D0                ; D0 = seed >> 4 (shift right)
000A: BF80          ...                             ; Masked comparison
...
0014: 203C40000000  MOVE.L     #$40000000,D0        ; Feedback constant
0018: 6002          BRA.S      $001C
001A: 7000          MOVEQ      #0,D0                ; Zero adjustment
001C: 2207          MOVE.L     D7,D1                ; D1 = seed
001E: E289          LSR.L      #1,D1                ; D1 = seed >> 1
0020: D280          ADD.L      D0,D1                ; D1 = (seed >> 1) + feedback
0022: 2B41F23C      MOVE.L     D1,-3524(A5)         ; Store new seed
0026: 2001          MOVE.L     D1,D0                ; Return new value
0028: 2E1F          MOVE.L     (A7)+,D7             ; Restore D7
002A: 4E75          RTS
```

**C equivalent**:
```c
long g_random_seed;  // at A5-3524

long get_random(void) {
    long seed = g_random_seed;
    long feedback;

    // Linear feedback shift register (LFSR)
    // Check specific bit pattern for feedback tap
    if (check_feedback_bits(seed)) {
        feedback = 0;
    } else {
        feedback = 0x40000000;  // High bit feedback
    }

    long new_seed = (seed >> 1) + feedback;
    g_random_seed = new_seed;
    return new_seed;
}
```

### Function 0x002C - Set Random Seed
```asm
; From disassembly:
002C: 4E560000      LINK       A6,#0
0030: 2B6E0008F23C  MOVE.L     8(A6),-3524(A5)      ; g_random_seed = param
0036: 4E5E          UNLK       A6
0038: 4E75          RTS
```

**C equivalent**:
```c
void set_random_seed(long seed) {
    g_random_seed = seed;  // A5-3524
}
```

### Function 0x003A - Greatest Common Divisor (GCD)
```asm
; From disassembly:
003A: 4E560000      LINK       A6,#0
003E: 48E70700      MOVEM.L    D5/D6/D7,-(SP)       ; Save registers
0042: 2E2E0008      MOVE.L     8(A6),D7             ; D7 = param1
0046: 2C2E000C      MOVE.L     12(A6),D6            ; D6 = param2
004A: BC87          CMP.L      D7,D6                ; Compare D6 with D7
004C: 6F06          BLE.S      $0054                ; If D6 <= D7, skip swap
004E: 2A07          MOVE.L     D7,D5                ; D5 = temp = D7
0050: 2E06          MOVE.L     D6,D7                ; D7 = D6 (larger)
0052: 2C05          MOVE.L     D5,D6                ; D6 = temp (smaller)
0054: 2F06          MOVE.L     D6,-(A7)             ; Push divisor
0056: 2F07          MOVE.L     D7,-(A7)             ; Push dividend
0058: 4EAD0062      JSR        98(A5)               ; JT[98] - modulo operation
005C: 2E00          MOVE.L     D0,D7                ; D7 = remainder
005E: 4A87          TST.L      D7                   ; Test remainder
0060: 66E8          BNE.S      $004A                ; Loop while remainder != 0
0062: 2006          MOVE.L     D6,D0                ; Return GCD in D0
0064: 4CDF00E0      MOVEM.L    (SP)+,D5/D6/D7       ; Restore registers
0068: 4E5E          UNLK       A6
006A: 4E75          RTS
```

**C equivalent**:
```c
long gcd(long a, long b) {
    // Ensure a >= b (swap if needed)
    if (b > a) {
        long temp = a;
        a = b;
        b = temp;
    }

    // Euclidean algorithm
    while (a != 0) {
        long remainder = b % a;  // via JT[98]
        b = a;
        a = remainder;
    }
    return b;
}
```

## Global Variables

| Offset | Name | Size | Purpose |
|--------|------|------|---------|
| A5-3524 | g_random_seed | 4 | Current random seed |

## Algorithm Analysis

### Random Number Generator

The RNG appears to be a **Linear Feedback Shift Register (LFSR)** style generator:
1. Takes the current seed
2. Shifts right by 8 bits
3. Applies a mask (0x02400001)
4. Shifts right by 1
5. Adds adjustment based on feedback

This is a common technique for fast pseudo-random generation on older CPUs without hardware multiply.

### GCD Algorithm

The GCD function uses the **Euclidean algorithm**:
1. Ensure larger number is in D7
2. Compute remainder (D7 mod D6)
3. Replace (D7, D6) with (D6, remainder)
4. Repeat until remainder is 0
5. Return the last non-zero value

**Why is GCD in a Scrabble game?**
- Possibly for scoring calculations
- Reducing fractions in evaluation functions
- Normalizing heuristic values

## Jump Table Mapping

| JT Offset | Function | Purpose |
|-----------|----------|---------|
| 1424(A5) | 0x0000 | get_random |
| 1432(A5) | 0x002C | set_random_seed |

## Called Jump Table Functions

| JT Offset | Purpose |
|-----------|---------|
| 98(A5) | Modulo operation (used by GCD) |

## Usage Context

The GCD function may be used for:
- Reducing fractions in scoring heuristics
- Normalizing evaluation values
- Statistical calculations in AI opponent

The random number generator is likely used for:
- AI move randomization (among equally good moves)
- Tile bag shuffling
- Adding variety to computer play

## Confidence: HIGH

The patterns are unmistakable:
- LFSR random generator with 0x40000000 feedback tap
- Euclidean GCD algorithm calling JT[98] for modulo
- Simple seed management at A5-3524
