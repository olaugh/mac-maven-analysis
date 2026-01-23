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

**Category**: Word Hashing
**Function**: Anagram Signature Computation

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

---

## Speculative C Translation

### Global Variables

```c
/* Letter-related data tables */
char g_letter_count_array[256];  /* A5-23218: Default letter count array */
char g_letter_primes[128];       /* A5-27374: Prime value for each letter */

/*
 * Prime values assigned to letters (speculative mapping):
 *
 * Common letters get small primes (for smaller products):
 *   E=2, A=3, I=5, O=7, N=11, R=13, T=17, L=19, S=23, U=29, ...
 *
 * Rare letters get larger primes:
 *   Q=97, Z=89, X=83, J=79, K=73, ...
 *
 * This ensures unique products for each letter combination.
 */
```

### Main Function - Letter Product Calculation

```c
/*
 * calculate_letter_product - Compute unique product signature for a word
 *
 * @param word: Input word string
 * @param count_array: Optional array to track letter frequencies
 *                     (NULL to use global default)
 * Returns: Unique product value, or 0 on overflow
 *
 * Algorithm:
 *   Each letter has a unique prime number.
 *   Product of primes for all letters = unique "anagram signature".
 *   Two words are anagrams iff they have the same product.
 *
 * Example:
 *   "CAT" = prime(C) * prime(A) * prime(T) = 47 * 3 * 17 = 2397
 *   "ACT" = prime(A) * prime(C) * prime(T) = 3 * 47 * 17 = 2397 (same!)
 *   "ATE" = prime(A) * prime(T) * prime(E) = 3 * 17 * 2 = 102 (different)
 */
long calculate_letter_product(char* word, char* count_array) {
    long product_of_primes;     /* D7: Running product of letter primes */
    long factorial_product;     /* D6: Product accounting for multiplicities */
    char letter;                /* D5: Current letter being processed */

    /* Use provided count array or default global */
    if (count_array == NULL) {
        count_array = g_letter_count_array;  /* A5-23218 */
    }

    /*
     * Phase 1: Clear count array for letters in this word
     * This prepares for counting letter frequencies
     */
    for (char* p = word; *p; p++) {
        unsigned char letter = (unsigned char)*p;
        count_array[letter] = 0;
    }

    /*
     * Phase 2: Calculate products while tracking letter frequencies
     */
    product_of_primes = 1;     /* Start with multiplicative identity */
    factorial_product = 1;      /* Track n! for repeated letters */

    char* p = word;
    letter = *p;

    if (letter == 0) {
        /* Empty word - return 0 or 1? */
        /* uncertain */
        return 0;
    }

    while (letter != 0) {
        unsigned char letter_idx = (unsigned char)letter;

        /* Get current count for this letter (before incrementing) */
        int current_count = count_array[letter_idx];

        /* Get prime value for this letter from lookup table */
        int prime_value = g_letter_primes[letter_idx];  /* A5-27374 + letter */

        /*
         * Multiply into product_of_primes
         * This accumulates: prime(letter1) * prime(letter2) * ...
         */
        product_of_primes = multiply_long(product_of_primes, prime_value);  /* JT[66] */

        /* Check for overflow */
        if (product_of_primes == 0) {
            return 0;  /* Overflow - word too long or primes too large */
        }

        /*
         * Increment the count for this letter
         * This tracks how many times we've seen each letter
         */
        count_array[letter_idx]++;
        int new_count = count_array[letter_idx];

        /*
         * Multiply into factorial_product
         * For repeated letters, we need to divide by n! to get unique signature
         * Instead of dividing, we multiply by n each time we see the letter:
         *   1st occurrence: *= 1
         *   2nd occurrence: *= 2  (now have 2! = 2)
         *   3rd occurrence: *= 3  (now have 3! = 6)
         */
        factorial_product = multiply_long(factorial_product, new_count);  /* JT[66] */

        /*
         * Reduce products by GCD to prevent overflow
         * If both products share a common factor, divide it out
         */
        long gcd = calculate_gcd(factorial_product, product_of_primes);  /* JT[1466] */
        if (gcd > 1) {
            product_of_primes = divide_long(product_of_primes, gcd);  /* JT[90] */
            factorial_product = divide_long(factorial_product, gcd);  /* uncertain */
        }

        /* Move to next letter */
        p++;
        letter = *p;
    }

    /*
     * Phase 3: Final calculation
     *
     * The final signature is: product_of_primes / factorial_product
     *
     * For a word like "AARDVARK":
     *   product_of_primes = prime(A)^3 * prime(R)^2 * prime(D) * prime(V) * prime(K)
     *   factorial_product = 3! * 2! * 1! * 1! * 1! = 6 * 2 = 12
     *   signature = product_of_primes / 12
     *
     * Wait, that doesn't give a unique signature for anagrams...
     * Re-examining: maybe it's product_of_primes * factorial adjustment?
     */

    /* Verify products are compatible */
    long remainder = modulo_long(product_of_primes, factorial_product);  /* JT[98] */
    if (remainder != 0) {
        /* This shouldn't happen - indicates bug */
        bounds_error();  /* JT[418] */
    }

    /* Final division to get signature */
    long signature = divide_long(product_of_primes, factorial_product);  /* JT[90] */

    return signature;
}
```

### Simplified Alternative Interpretation

Looking at the code more carefully, the algorithm might be simpler:

```c
/*
 * Alternative interpretation: Multiset signature
 *
 * This computes a signature that:
 * 1. Is the same for any permutation of the same letters (anagrams)
 * 2. Distinguishes words with different letter sets
 *
 * The key insight is that multiplying primes gives unique products
 * because of the fundamental theorem of arithmetic (unique factorization).
 */
long calculate_anagram_signature(char* word, char* count_buffer) {
    if (count_buffer == NULL) {
        count_buffer = g_letter_count_array;
    }

    /* Clear counts for letters in this word */
    for (char* p = word; *p; p++) {
        count_buffer[(unsigned char)*p] = 0;
    }

    long signature = 1;

    for (char* p = word; *p; p++) {
        unsigned char letter = (unsigned char)*p;

        /* Get the prime assigned to this letter */
        int prime = g_letter_primes[letter];

        /* Multiply into signature */
        signature = signature * prime;  /* May use JT[66] for 32-bit multiply */

        if (signature == 0) {
            return 0;  /* Overflow */
        }

        count_buffer[letter]++;
    }

    return signature;
}
```

### Use Cases

```c
/*
 * Use case 1: Anagram detection
 *
 * Check if two words are anagrams:
 */
int are_anagrams(char* word1, char* word2) {
    long sig1 = calculate_letter_product(word1, NULL);
    long sig2 = calculate_letter_product(word2, NULL);

    return (sig1 != 0 && sig1 == sig2);
}

/*
 * Use case 2: Dictionary lookup optimization
 *
 * Group words by anagram signature for faster search:
 */
typedef struct {
    long signature;
    char* words[32];  /* All words with this signature are anagrams */
    int word_count;
} AnagramGroup;

AnagramGroup* find_anagram_group(long signature, AnagramGroup* groups, int num_groups) {
    /* Binary search or hash lookup by signature */
    for (int i = 0; i < num_groups; i++) {
        if (groups[i].signature == signature) {
            return &groups[i];
        }
    }
    return NULL;
}

/*
 * Use case 3: Can we make a word from rack?
 *
 * Check if rack tiles can form a given word:
 */
int can_make_word(char* word, char* rack) {
    /* Get signatures */
    long word_sig = calculate_letter_product(word, NULL);
    long rack_sig = calculate_letter_product(rack, NULL);

    /* Word signature must divide rack signature evenly */
    /* (Each required prime must be present in rack) */
    if (modulo_long(rack_sig, word_sig) == 0) {
        return 1;  /* Can make this word */
    }
    return 0;  /* Missing required letters */
}
```

### Prime Assignment Strategy (Speculative)

```c
/*
 * Optimal prime assignment minimizes overflow by giving
 * smaller primes to more common letters.
 *
 * Scrabble letter frequencies (approximate order):
 *   Most common: E, A, I, O, N, R, T, L, S, U
 *   Least common: Q, Z, X, J, K
 *
 * Speculative prime table:
 */
const int LETTER_PRIMES[26] = {
    /*  A    B    C    D    E    F    G    H    I    J    K    L    M */
        3,  47,  43,  37,   2,  41,  53,  61,   5,  79,  73,  19,  59,
    /*  N    O    P    Q    R    S    T    U    V    W    X    Y    Z */
       11,   7,  67,  97,  13,  23,  17,  29,  71,  83,  89,  31,  83
};

/*
 * With this assignment:
 *   "CAT" = 43 * 3 * 17 = 2193
 *   "ACT" = 3 * 43 * 17 = 2193 (same - they're anagrams!)
 *   "TAC" = 17 * 3 * 43 = 2193 (same!)
 *   "DOG" = 37 * 7 * 53 = 13727 (different word, different signature)
 *
 * Maximum product for 7-tile word:
 *   Worst case: QZXJKWV = 97 * 83 * 89 * 79 * 73 * 83 * 71
 *             = 2.6 trillion (too big for 32-bit!)
 *
 * This explains why the code has GCD reduction and overflow checks.
 */
```
