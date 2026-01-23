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

---

## Speculative C Translation

### Data Structures and Globals

```c
/*
 * Random hash table for string hashing
 *
 * 16-entry table initialized lazily on first use.
 * Located at A5-1128 (64 bytes total).
 */
long g_random_hash_table[16];  /* A5-1128 through A5-1068 */
```

### Function 0x0000 - Hash Generator with Lazy Initialization

```c
/*
 * compute_string_hash - Generate hash value for input string
 *
 * Uses a table-based mixing algorithm with lazy table initialization.
 * The algorithm provides consistent hashing once the random table
 * is initialized.
 *
 * Algorithm:
 *   hash = (hash >> 1) + random_table[hash & 0xF] + char
 *
 * Used for:
 * - Tile bag randomization (shuffling for tile draws)
 * - Transposition table keys (AI search memoization)
 * - Game seed generation (reproducible random games)
 * - Move ordering tie-breaking
 *
 * @param input_string: Pointer to start of input data
 * @param input_length: Number of bytes to hash
 * @return: 32-bit hash value
 */
long compute_string_hash(const char *input_string, long input_length) {
    const char *current_ptr;
    const char *end_ptr;
    long hash_accumulator;
    short table_index;
    long mixed_value;
    char current_char;
    short init_counter;
    long *table_ptr;

    /* Set up pointers */
    current_ptr = input_string;
    end_ptr = input_string + input_length;

    /* Initialize hash accumulator to zero */
    hash_accumulator = 0;

    /*------------------------------------------------------------------
     * Lazy initialization of random hash table
     *------------------------------------------------------------------*/
    if (g_random_hash_table[0] == 0) {
        /* Table not yet initialized - fill with random values */
        init_counter = 0;
        table_ptr = g_random_hash_table;

        while (init_counter < 16) {
            /* Call Mac Toolbox Random() via jump table */
            /* JT[1458] = Random - returns 0 to 65535 */
            *table_ptr = mac_random();

            init_counter++;
            table_ptr++;
        }

        /* Verify initialization succeeded */
        /* Random() returning 0 for first entry would cause infinite init */
        if (g_random_hash_table[0] == 0) {
            error_handler();  /* JT[418] - fatal error */
            /* uncertain: may continue anyway */
        }
    }

    /*------------------------------------------------------------------
     * Hash computation loop
     *------------------------------------------------------------------*/
    while (current_ptr < end_ptr) {
        /* Read next character from input */
        current_char = *current_ptr;

        /* Mixing step 1: Shift accumulator right by 1 bit */
        /* This spreads high bits toward low bits over multiple iterations */
        mixed_value = hash_accumulator >> 1;

        /* Mixing step 2: Use low 4 bits as table index */
        /* Provides non-linear mixing through table lookup */
        table_index = (short)(hash_accumulator & 0x0F);

        /* Mixing step 3: Add random table entry */
        mixed_value += g_random_hash_table[table_index];

        /* Mixing step 4: Add character value */
        /* Sign-extended to preserve negative char values */
        mixed_value += (signed char)current_char;

        /* Store result for next iteration */
        hash_accumulator = mixed_value;

        /* Advance to next character */
        current_ptr++;
    }

    /* Return final hash value */
    return hash_accumulator;
}
```

### Optimized Implementation (Equivalent)

```c
/*
 * compute_string_hash_optimized - Cleaner equivalent implementation
 *
 * Same algorithm, more readable structure.
 */
long compute_string_hash_optimized(const char *input, long length) {
    /* Lazy initialization */
    static Boolean initialized = false;

    if (!initialized || g_random_hash_table[0] == 0) {
        for (int i = 0; i < 16; i++) {
            g_random_hash_table[i] = mac_random();
        }

        if (g_random_hash_table[0] == 0) {
            /* Extremely unlikely but handle it */
            error_handler();
        }

        initialized = true;
    }

    /* Compute hash */
    long hash = 0;
    const char *end = input + length;

    while (input < end) {
        signed char c = *input++;

        /* Core mixing function:
         * - Shift spreads influence of old hash
         * - Table lookup adds non-linearity
         * - Character adds input dependence
         */
        hash = (hash >> 1) + g_random_hash_table[hash & 0x0F] + c;
    }

    return hash;
}
```

### Usage Examples

```c
/*
 * Example: Hash a word for transposition table lookup
 */
long get_word_hash(const char *word) {
    return compute_string_hash(word, strlen(word));
}

/*
 * Example: Hash board position for AI memoization
 *
 * Board state represented as 225 bytes (15x15 squares)
 */
long get_board_position_hash(const char *board_state) {
    return compute_string_hash(board_state, 225);
}

/*
 * Example: Generate tile draw sequence
 *
 * Hash the current game state to get a seed for tile shuffling
 */
void shuffle_tile_bag(char *tile_bag, int tile_count, long game_seed) {
    /* Use hash of game seed as shuffle source */
    char seed_bytes[4];
    *(long*)seed_bytes = game_seed;

    long shuffle_hash = compute_string_hash(seed_bytes, 4);

    /* Fisher-Yates shuffle using hash values */
    for (int i = tile_count - 1; i > 0; i--) {
        /* Generate index using hash */
        int j = (int)(shuffle_hash % (i + 1));

        /* Swap */
        char temp = tile_bag[i];
        tile_bag[i] = tile_bag[j];
        tile_bag[j] = temp;

        /* Update hash for next iteration */
        shuffle_hash = (shuffle_hash >> 1) +
                       g_random_hash_table[shuffle_hash & 0x0F] +
                       tile_bag[i];
    }
}
```

### Hash Quality Analysis

```c
/*
 * Hash Function Properties:
 *
 * STRENGTHS:
 * - Deterministic: Same input always produces same output (after init)
 * - Fast: Simple shift/add/lookup operations
 * - Reasonable distribution: Table mixing spreads values
 * - Non-linear: Table lookup prevents trivial collisions
 *
 * WEAKNESSES:
 * - Only 16 table entries (4-bit index) - limited mixing depth
 * - No avalanche guarantee - similar inputs may produce similar hashes
 * - Linear character addition - predictable contribution
 *
 * For Maven's use cases (game hashing, seeding), this is adequate.
 * For cryptographic purposes, this would be insufficient.
 *
 * MIXING VISUALIZATION:
 *
 * Input char: 'A' (0x41)
 * Current hash: 0x12345678
 *
 * Step 1: shifted = 0x12345678 >> 1 = 0x091A2B3C
 * Step 2: index = 0x12345678 & 0xF = 8
 * Step 3: table_add = shifted + random_table[8]
 *                   = 0x091A2B3C + 0xDEADBEEF (example)
 *                   = 0xE7C7EA2B
 * Step 4: final = 0xE7C7EA2B + 0x41 = 0xE7C7EA6C
 *
 * Next iteration uses 0xE7C7EA6C as starting hash.
 */
```

### Memory Layout

```
Address         Content
-------         -------
A5-1128         random_table[0]   (4 bytes) - First entry checked for init
A5-1124         random_table[1]   (4 bytes)
A5-1120         random_table[2]   (4 bytes)
A5-1116         random_table[3]   (4 bytes)
A5-1112         random_table[4]   (4 bytes)
A5-1108         random_table[5]   (4 bytes)
A5-1104         random_table[6]   (4 bytes)
A5-1100         random_table[7]   (4 bytes)
A5-1096         random_table[8]   (4 bytes)
A5-1092         random_table[9]   (4 bytes)
A5-1088         random_table[10]  (4 bytes)
A5-1084         random_table[11]  (4 bytes)
A5-1080         random_table[12]  (4 bytes)
A5-1076         random_table[13]  (4 bytes)
A5-1072         random_table[14]  (4 bytes)
A5-1068         random_table[15]  (4 bytes)
                                  --------
                Total:            64 bytes
```
