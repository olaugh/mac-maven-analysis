# CODE 4 Analysis - Random Number Generator & GCD

## Overview

| Property | Value |
|----------|-------|
| Size | 108 bytes |
| JT Offset | 1424 (0x0590) |
| JT Entries | 2 |
| Functions | 3 |
| Categories | MATH_UTILITY |
| Purpose | LFSR Random Number Generator and GCD |
| Confidence | **HIGH** |

## Header

```
Offset 0x00: 0590 = 1424 (JT offset)
Offset 0x02: 0002 = 2 (JT entries)
Code starts at offset 0x04
```

## Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-3524 | g_random_seed | 32-bit LFSR state |

## Complete Disassembly

### Function 1: random() at 0x0004

Linear Feedback Shift Register (LFSR) random number generator.

```asm
0004: 2F07          MOVE.L   D7,-(A7)        ; Save D7
0006: 2E2D F23C     MOVE.L   -3524(A5),D7    ; D7 = g_random_seed
000A: 2007          MOVE.L   D7,D0           ; D0 = seed
000C: E888          LSR.L    #4,D0           ; D0 = seed >> 4
000E: BF80          EOR.L    D7,D0           ; D0 = seed ^ (seed >> 4)
0010: 0240 0001     ANDI.W   #1,D0           ; D0 = low bit only
0014: 6708          BEQ.S    $001E           ; if bit is 0, skip feedback
0016: 203C 40000000 MOVE.L   #$40000000,D0   ; D0 = feedback tap (bit 30)
001C: 6002          BRA.S    $0020
001E: 7000          MOVEQ    #0,D0           ; D0 = 0 (no feedback)
0020: 2207          MOVE.L   D7,D1           ; D1 = seed
0022: E289          LSR.L    #1,D1           ; D1 = seed >> 1
0024: D280          ADD.L    D0,D1           ; D1 = (seed >> 1) + feedback
0026: 2B41 F23C     MOVE.L   D1,-3524(A5)    ; g_random_seed = D1
002A: 2001          MOVE.L   D1,D0           ; return value = new seed
002C: 2E1F          MOVE.L   (A7)+,D7        ; Restore D7
002E: 4E75          RTS
```

#### C Translation

```c
/*
 * LFSR-based random number generator
 * Uses taps at bits 0 and 4 for feedback into bit 30
 * Returns: new 32-bit pseudo-random value
 * Confidence: HIGH
 */
long random(void) {
    long seed = g_random_seed;  /* A5-3524 */

    /* Calculate feedback bit from XOR of bits 0 and 4 */
    long feedback_bit = (seed ^ (seed >> 4)) & 1;

    /* Shift right and inject feedback into bit 30 */
    long new_seed;
    if (feedback_bit) {
        new_seed = (seed >> 1) + 0x40000000;
    } else {
        new_seed = (seed >> 1);
    }

    g_random_seed = new_seed;
    return new_seed;
}
```

### Function 2: set_random_seed() at 0x0030 (JT Entry 1)

```asm
0030: 4E56 0000     LINK     A6,#0           ; No local variables
0034: 2B6E 0008 F23C MOVE.L  8(A6),-3524(A5) ; g_random_seed = param
003A: 4E5E          UNLK     A6
003C: 4E75          RTS
```

#### C Translation

```c
/*
 * Set the random seed for the LFSR generator
 * Param: seed - new 32-bit seed value
 * Confidence: HIGH
 */
void set_random_seed(long seed) {
    g_random_seed = seed;  /* A5-3524 */
}
```

### Function 3: gcd() at 0x003E (JT Entry 2)

Euclidean algorithm for Greatest Common Divisor.

```asm
003E: 4E56 0000     LINK     A6,#0           ; No local variables
0042: 48E7 0700     MOVEM.L  D5/D6/D7,-(SP)  ; Save D5-D7
0046: 2E2E 0008     MOVE.L   8(A6),D7        ; D7 = a (first param)
004A: 2C2E 000C     MOVE.L   12(A6),D6       ; D6 = b (second param)
004E: BC87          CMP.L    D7,D6           ; Compare b to a
0050: 6F06          BLE.S    $0058           ; if b <= a, skip swap
0052: 2A07          MOVE.L   D7,D5           ; temp = a
0054: 2E06          MOVE.L   D6,D7           ; a = b
0056: 2C05          MOVE.L   D5,D6           ; b = temp
0058: 2F06          MOVE.L   D6,-(A7)        ; Push divisor (b)
005A: 2F07          MOVE.L   D7,-(A7)        ; Push dividend (a)
005C: 4EAD 0062     JSR      98(A5)          ; Call modulo via JT[98]
0060: 508F          ADDQ.L   #8,A7           ; Clean stack (2 longs)
0062: 2E00          MOVE.L   D0,D7           ; a = a % b
0064: 4A87          TST.L    D7              ; Test if remainder is 0
0066: 66E6          BNE.S    $004E           ; if not 0, continue loop
0068: 2006          MOVE.L   D6,D0           ; Return b (the GCD)
006A: 4CDF 00E0     MOVEM.L  (SP)+,D5/D6/D7  ; Restore D5-D7
006E: 4E5E          UNLK     A6
0070: 4E75          RTS
```

#### C Translation

```c
/*
 * Euclidean algorithm for Greatest Common Divisor
 * Params: a, b - two positive integers
 * Returns: GCD of a and b
 * Confidence: HIGH
 */
long gcd(long a, long b) {
    /* Ensure a >= b */
    if (b > a) {
        long temp = a;
        a = b;
        b = temp;
    }

    /* Euclidean algorithm */
    while (a != 0) {
        long remainder = a % b;  /* via JT[98] */
        a = remainder;
        if (a != 0) {
            /* Swap for next iteration */
            if (b > a) {
                long temp = a;
                a = b;
                b = temp;
            }
        }
    }

    return b;  /* GCD */
}
```

## Jump Table Calls

| Offset | Purpose | Implementing CODE |
|--------|---------|-------------------|
| 98(A5) | modulo operation | CODE 1 |

## Analysis Notes

- **LFSR Algorithm**: The random() function implements a 32-bit Linear Feedback Shift Register
  - Feedback taps at bits 0 and 4 (XORed together)
  - Feedback injected at bit 30
  - This is a Galois LFSR configuration

- **GCD Algorithm**: Standard Euclidean algorithm
  - Uses JT[98] for modulo operation (implemented in CODE 1)
  - Swaps operands to ensure larger value is the dividend

- **Usage in Maven**: The GCD function is likely used for:
  - Tile distribution calculations
  - Probability/scoring normalization
  - The random() function drives AI move selection randomization

## Confidence Levels

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Function boundaries | HIGH | LINK/UNLK/RTS patterns clear |
| Disassembly | HIGH | Complete, all bytes accounted for |
| Algorithm identification | HIGH | LFSR and Euclidean GCD well-known |
| Variable purposes | HIGH | Single global clearly a seed |
| Function names | MEDIUM | Inferred from behavior |

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: MATH_UTILITY

**Global Variable Profile**: 0 DAWG, 0 UI, 1 total

**Calls functions in**: CODE 1 (for modulo)

**Assessment**: Core math utilities - random number generation and GCD calculation
