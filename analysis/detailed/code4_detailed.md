# CODE 4 Detailed Analysis - Random Number Generator

## Overview

| Property | Value |
|----------|-------|
| Size | 108 bytes |
| JT Offset | 1424 |
| JT Entries | 2 |
| Functions | 3 |
| Purpose | **Random number generation, GCD calculation** |

## Architecture Role

CODE 4 provides random number services:
1. Linear congruential random number generator
2. GCD (Greatest Common Divisor) calculation
3. Seed management

## Key Functions

### Function 0x0000 - Get Random Number
```asm
0000: MOVE.L     D7,-(A7)             ; Save D7
0002: MOVE.L     -3524(A5),D7         ; D7 = seed (A5-3524)
0006: MOVE.L     D7,D0                ; D0 = seed
0008: LSR.L      #8,D0                ; D0 = seed >> 8
000A: AND.L      #$02400001,D0        ; Mask bits
000E: CMPI.L     #$01,D1              ; (some check)
0012: BEQ.S      $001A                ; If equal, return small
0014: MOVE.L     #$40000000,D0        ; Return large constant
0018: BRA.S      $001C
001A: MOVEQ      #0,D0                ; Return 0
001C: MOVE.L     D7,D1                ; D1 = seed
001E: LSR.L      #1,D1                ; D1 = seed >> 1
0020: ADD.L      D0,D1                ; D1 = (seed >> 1) + adjustment
0022: MOVE.L     D1,-3524(A5)         ; Store new seed
0026: MOVE.L     D1,D0                ; Return new value
0028: MOVE.L     (A7)+,D7             ; Restore D7
002A: RTS
```

**C equivalent**:
```c
long g_random_seed;  // at A5-3524

long get_random(void) {
    long seed = g_random_seed;
    long adjust;

    // Linear feedback shift register style
    if ((seed >> 8) & 0x02400001) == 1) {
        adjust = 0;
    } else {
        adjust = 0x40000000;
    }

    long new_seed = (seed >> 1) + adjust;
    g_random_seed = new_seed;
    return new_seed;
}
```

### Function 0x002C - Set Random Seed
```asm
002C: LINK       A6,#0
0030: MOVE.L     8(A6),-3524(A5)      ; seed = param
0036: UNLK       A6
0038: RTS
```

**C equivalent**:
```c
void set_random_seed(long seed) {
    g_random_seed = seed;
}
```

### Function 0x003A - Greatest Common Divisor (GCD)
```asm
003A: LINK       A6,#0
003E: MOVEM.L    D5/D6/D7,-(SP)       ; Save registers
0042: MOVE.L     8(A6),D7             ; D7 = param1
0046: MOVE.L     12(A6),D6            ; D6 = param2
004A: CMP.L      D7,D6                ; Compare
004C: BLE.S      $0054                ; If D6 <= D7, skip swap
004E: MOVE.L     D7,D5                ; Swap values
0050: MOVE.L     D6,D7                ; D7 = max
0052: MOVE.L     D5,D6                ; D6 = min
0054: MOVE.L     D6,-(A7)             ; Push divisor
0056: MOVE.L     D7,-(A7)             ; Push dividend
0058: JSR        98(A5)               ; JT[98] - modulo
005C: MOVE.L     D0,D7                ; D7 = remainder
005E: TST.L      D7
0060: BNE.S      $004A                ; Loop while remainder != 0
0062: MOVE.L     D6,D0                ; Return GCD
0064: MOVEM.L    (SP)+,D5/D6/D7
0068: UNLK       A6
006A: RTS
```

**C equivalent**:
```c
long gcd(long a, long b) {
    // Ensure a >= b
    if (b > a) {
        long temp = a;
        a = b;
        b = temp;
    }

    // Euclidean algorithm
    while (a != 0) {
        long temp = a;
        a = b % a;
        b = temp;
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
| 1424 | 0x0000 | get_random |
| 1432 | 0x002C | set_random_seed |

## Confidence: HIGH

The patterns are unmistakable:
- LFSR random generator
- Euclidean GCD algorithm
- Simple seed management
