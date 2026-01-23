# CODE 25 Detailed Analysis - Letter Product Calculation

## Overview

| Property | Value |
|----------|-------|
| Size | 200 bytes |
| JT Offset | 3536 |
| JT Entries | 1 |
| Functions | 1 |
| Purpose | **Calculate product of letter values for hashing/comparison** |


## System Role

**Category**: Utility
**Function**: Small Helper

Minimal utility functions
## Architecture Role

CODE 25 computes a product based on letter values, likely for:
1. Word hashing/identification
2. Anagram detection (same letters = same product)
3. Dictionary lookup optimization

## Main Function (0x0000)

```asm
0000: LINK       A6,#0
0004: MOVEM.L    D5/D6/D7/A3/A4,-(SP)  ; save
0008: MOVEA.L    12(A6),A4             ; A4 = count array (or NULL)
000C: MOVE.L     A4,D0
000E: BNE.S      $0014                 ; If provided, use it
0010: LEA        -23218(A5),A4         ; Else use global letter array

; Clear count array for each letter in string
0014: MOVEA.L    8(A6),A3              ; A3 = input string
0018: BRA.S      $0024                 ; Jump to loop test

; Clear array entries
001A: MOVE.B     (A3),D0               ; Get letter
001C: EXT.W      D0                    ; Extend to word
001E: CLR.B      0(A4,D0.W)            ; Clear count[letter]
0022: ADDQ.L     #1,A3                 ; Next char

0024: TST.B      (A3)                  ; End of string?
0026: BNE.S      $001A                 ; Continue if not

; Initialize product accumulators
0028: MOVEQ      #1,D6                 ; D6 = product1 = 1
002A: MOVE.L     D6,D7                 ; D7 = product2 = 1
002C: MOVEA.L    8(A6),A3              ; Reset string pointer
0030: MOVE.B     (A3),D5               ; D5 = current letter
0032: TST.B      D5
0034: BEQ.S      $00A4                 ; End of string

; Get letter value from table
0036: MOVE.B     D5,D0
0038: EXT.W      D0
003A: MOVE.B     0(A4,D0.W),D0         ; Get count[letter]
003E: EXT.W      D0
0040: MOVE.B     D5,D1                 ; Get letter
0042: EXT.W      D1
0044: MOVEA.L    A5,A0
0046: ADDA.W     D1,A0
0048: MOVE.B     -27374(A0),D1         ; Get prime value for letter
004C: EXT.W      D1

; Calculate: new_product = old_product * prime_value
0050: SUB.W      D0,A1                 ; Adjust for count
0052: MOVEA.W    D1,A0                 ; A0 = prime value
0054: MOVE.L     A0,-(A7)              ; Push prime
0056: MOVE.L     D7,-(A7)              ; Push product2
0058: JSR        66(A5)                ; JT[66] - multiply
005C: MOVE.L     D0,D7                 ; Update product2

; Check for overflow
005E: TST.L      D7
0060: BEQ.S      $00A4                 ; Overflow, return 0

; Increment count for this letter
0064: MOVE.B     (A3),D0
0068: ADDQ.B     #1,0(A4,D0.W)         ; count[letter]++
006C: MOVE.B     0(A4,D0.W),D0         ; Get new count
0070: EXT.W      D0

; Update product1
0074: MOVEA.W    D0,A0
0076: MOVE.L     A0,-(A7)              ; Push count
0078: MOVE.L     D6,-(A7)              ; Push product1
007A: JSR        66(A5)                ; JT[66] - multiply
007E: MOVE.L     D0,D6                 ; Update product1

; Calculate combined product
0082: MOVE.L     D6,-(A7)
0086: MOVE.L     D7,-(A7)
0088: JSR        1466(A5)              ; JT[1466] - gcd or lcm
008C: MOVE.L     D0,D5                 ; D5 = result
008E: MOVEQ      #1,D0
0090: CMP.L      D5,D0                 ; Compare with 1
0092: ADDQ.L     #8,A7
0094: BGE.S      $00A0                 ; If <= 1, continue

; Reduce products by common factor
0096: MOVE.L     D5,-(A7)
0098: MOVE.L     D7,-(A7)
009A: JSR        90(A5)                ; JT[90] - divide
009E: MOVE.L     D0,D7                 ; product2 /= factor

00A0: ADDQ.L     #1,A3                 ; Next character
00A2: BRA.S      $0030                 ; Continue loop

; Final calculation
00A4: MOVE.L     D6,-(A7)              ; Push product1
00A6: MOVE.L     D7,-(A7)              ; Push product2
00A8: JSR        98(A5)                ; JT[98] - modulo or combine
00AC: TST.L      D0
00AE: BEQ.S      $00B4                 ; If zero
00B0: JSR        418(A5)               ; JT[418] - bounds_error

00B4: MOVE.L     D6,-(A7)
00B6: MOVE.L     D7,-(A7)
00B8: JSR        90(A5)                ; JT[90] - divide
00BC: MOVE.L     D0,D7                 ; Final result

00BE: MOVE.L     D7,D0                 ; Return in D0
00C0: MOVEM.L    (SP)+,D5/D6/D7/A3/A4  ; restore
00C4: UNLK       A6
00C6: RTS
```

## Algorithm Analysis

This function computes a unique product for a word based on letter frequencies:

**Concept**: Assign each letter a unique prime number. The product of primes for all letters in a word uniquely identifies the set of letters (anagram signature).

```c
long letter_product(char* word, char* count_array) {
    if (count_array == NULL) {
        count_array = g_letter_array;  // A5-23218
    }

    // Clear counts for letters in word
    for (char* p = word; *p; p++) {
        count_array[(unsigned char)*p] = 0;
    }

    long product1 = 1;
    long product2 = 1;

    for (char* p = word; *p; p++) {
        int letter = *p;
        int count = count_array[letter];
        int prime = g_letter_primes[letter];  // A5-27374

        // Update products
        product2 = product2 * prime;
        if (product2 == 0) return 0;  // Overflow

        count_array[letter]++;
        product1 = product1 * (count + 1);

        // Reduce by GCD periodically to prevent overflow
        long factor = gcd(product1, product2);
        if (factor > 1) {
            product2 /= factor;
            product1 /= factor;
        }
    }

    return product2 / product1;
}
```

## Use Case: Anagram Detection

Two words are anagrams if and only if they produce the same letter product:
- "CAT" = prime(C) * prime(A) * prime(T)
- "ACT" = prime(A) * prime(C) * prime(T) = same product

This allows O(1) anagram comparison after computing the product.

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-23218 | Default letter count array |
| A5-27374 | Letter prime value table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | 32-bit multiply |
| 90 | 32-bit divide |
| 98 | Modulo or GCD |
| 418 | bounds_error |
| 1466 | GCD or LCM calculation |

## Confidence: MEDIUM-HIGH

The algorithm clearly computes a product-based hash:
- Uses prime values per letter
- Accounts for letter frequency
- Reduces to prevent overflow
- Commonly used for anagram detection
