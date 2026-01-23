# CODE 38 Detailed Analysis - Rack Letter Filtering and Iteration

## Overview

| Property | Value |
|----------|-------|
| Size | 374 bytes |
| JT Offset | 2592 |
| JT Entries | 2 |
| Functions | 4 |
| Purpose | **Filter rack letters by validity mask, iterate with callbacks** |


## System Role

**Category**: Utility
**Function**: Small Helper

Minimal utility functions
## Architecture Role

CODE 38 provides rack letter processing:
1. Filter letters from rack based on validity masks
2. Iterate through filtered letters with callback functions
3. Support for score-based letter processing
4. Recursive combination generation

## Key Functions

### Function 0x0000 - Always Returns True
```asm
0000: LINK       A6,#0
0004: MOVEQ      #1,D0                ; Always return 1 (true)
0006: UNLK       A6
0008: RTS
```

**C equivalent**:
```c
int always_true(void) {
    return 1;
}
```

Simple constant function used as default callback or predicate.

### Function 0x000A - Iterate Rack with Callback
```asm
000A: LINK       A6,#-8               ; frame=8
000E: CLR.B      -8(A6)               ; Clear local buffer
0012: CLR.B      -15522(A5)           ; Clear global flag

; Main iteration loop
0016: PEA        -8(A6)               ; Push buffer
001A: JSR        2402(A5)             ; JT[2402] - get next letter
001E: PEA        -8(A6)
0022: JSR        -36(PC)              ; Call function 0x0000 (always_true)
0026: TST.W      D0
0028: MOVE.B     A7,(A0)              ; (spurious disasm)
002A: BEQ.S      $000E                ; Loop if returned 0

; Call user callback with found letter
002C: PEA        $0001.W              ; Push constant 1
0030: PEA        -8(A6)               ; Push letter buffer
0034: MOVEA.L    8(A6),A0             ; Get callback pointer
0038: JSR        (A0)                 ; Call user callback
003A: MOVE.B     A7,(A0)              ; (spurious)
003C: BRA.S      $000E                ; Continue loop
003E: UNLK       A6
0040: RTS
```

**C equivalent**:
```c
void iterate_rack_with_callback(void (*callback)(char*, int)) {
    char buffer[8];
    buffer[0] = 0;
    g_flag_15522 = 0;

    while (1) {
        get_next_letter(buffer);
        if (always_true(buffer)) {
            callback(buffer, 1);
        }
        // Continue until exhausted
    }
}
```

### Function 0x0042 - Filter Rack Letters
```asm
0042: LINK       A6,#-288             ; frame=288
0046: MOVEM.L    D7/A3/A4,-(SP)

; Validate callback parameter
004A: TST.L      8(A6)                ; Check callback
004E: BNE.S      $0054
0050: JSR        418(A5)              ; JT[418] - error if null

; Get validity mask for current position
0054: PEA        -128(A6)             ; Validity mask buffer (128 bytes)
0058: JSR        2394(A5)             ; JT[2394] - get validity mask
005C: MOVE.W     D0,D7                ; D7 = count

; Check count bounds
005E: CMPI.W     #$0012,D7            ; Max 18 letters?
0062: MOVE.B     A7,(A4)              ; (spurious)
0064: BLT.S      $006A
0066: JSR        418(A5)              ; JT[418] - bounds error

; Filter rack letters through validity mask
006A: LEA        -288(A6),A4          ; A4 = filtered output (160 bytes)
006E: MOVEA.L    -26158(A5),A3        ; A3 = g_rack pointer

; Loop through rack
0072: MOVE.B     (A3),D7              ; Get letter from rack
0074: TST.B      D7
0076: BEQ.S      $0088                ; End of rack

0078: MOVE.B     D7,D0
007A: EXT.W      D0
007C: TST.B      -128(A6,D0.W)        ; Check validity mask[letter]
0080: BEQ.S      $0084                ; Skip if not valid
0082: MOVE.B     (A3),(A4)+           ; Copy valid letter to output

0084: MOVE.B     A3,(A1)              ; (spurious - actually ADDQ #1,A3)
0086: BRA.S      $0072                ; Next letter

; Terminate filtered string
0088: CLR.B      (A4)                 ; Null terminate

; Call recursive processor
008A: MOVE.L     8(A6),-(A7)          ; Push callback
008E: CLR.W      -(A7)                ; Push depth=0
0090: PEA        -288(A6)             ; Push filtered rack
0094: PEA        -256(A6)             ; Push work buffer
0098: PEA        -128(A6)             ; Push validity mask
009C: JSR        12(PC)               ; Call function 0x00AA

00A0: MOVEM.L    -300(A6),D7/A3/A4
00A6: UNLK       A6
00A8: RTS
```

**C equivalent**:
```c
void filter_rack_letters(void (*callback)(char*, int)) {
    char validity_mask[128];
    char filtered_rack[160];
    char work_buffer[32];

    if (callback == NULL) {
        error();
    }

    int count = get_validity_mask(validity_mask);
    if (count >= 18) {
        bounds_error();
    }

    // Filter rack through validity mask
    char *rack = g_rack;
    char *out = filtered_rack;

    while (*rack) {
        char letter = *rack;
        if (validity_mask[letter]) {
            *out++ = letter;
        }
        rack++;
    }
    *out = 0;

    // Process combinations recursively
    process_combinations(validity_mask, work_buffer, filtered_rack, 0, callback);
}
```

### Function 0x00AA - Recursive Combination Processor
```asm
00AA: LINK       A6,#0
00AE: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)

; Get parameters
00B2: MOVE.L     8(A6),D7             ; D7 = validity mask
00B6: MOVEA.L    12(A6),A4            ; A4 = work buffer
00BA: MOVEA.L    16(A6),A3            ; A3 = filtered rack
00BE: MOVE.W     20(A6),D6            ; D6 = depth

; Check depth limit (max 7 tiles)
00C2: CMPI.W     #$0007,D6
00C6: BLE.S      $00CE
00C8: MOVEQ      #0,D0                ; Return 0 if too deep
00CA: BRA.W      $016E

; At maximum depth - process combination
00CE: CMPI.W     #$0007,D6
00D2: BNE.S      $012A

; Depth == 7: full rack used
00D4: CLR.B      (A4)                 ; Null terminate
00D6: ...                             ; Setup for score lookup
00DA: MOVEA.L    A4,A3                ; A3 = work buffer
00DC: LEA        -1(A3),A2            ; A2 = previous position

; Loop through placed letters
00E0: MOVE.B     (A3),D5              ; Get letter
00E2: TST.B      D5
00E4: BEQ.S      $011E                ; End of word

00E6: MOVE.W     1(A3),D5             ; Get next letter index
00EA: BEQ.S      $011A                ; Skip if none

; Get letter value from score table
00EC: MOVE.B     D5,D0
00EE: EXT.W      D0
00F0: MOVEA.W    D0,A0
00F2: MOVE.B     0(A0,D7.L),D0        ; Look up in score table
00F6: EXT.W      D0
00F8: EXT.L      D0

; Add to running score
...
0100: LEA        -26024(A5),A0        ; A5-26024 = score lookup table
0104: ADD.B      A0,(A0)              ; (Add score value)
...

; Call JT[66] for score accumulation
0112: JSR        66(A5)               ; JT[66] - accumulate score
0116: MOVE.L     D0,D6
0118: MOVEA.L    A3,A2
011A: MOVE.B     A3,(A1)              ; (A3++)
011C: BRA.S      $00E0                ; Next letter

; Call callback with result
011E: MOVE.L     D6,-(A7)             ; Push score
0120: MOVE.L     A4,-(A7)             ; Push word buffer
0122: MOVEA.L    22(A6),A0            ; Get callback
0126: JSR        (A0)                 ; Call callback(word, score)
0128: BRA.S      $016C

; Not at max depth - try adding each letter
012A: TST.B      (A3)                 ; Any letters left?
012C: BNE.S      $0132
012E: MOVEQ      #0,D0                ; No letters - return 0
0130: BRA.S      $016C

; Recursive case - try each remaining letter
0132: MOVEQ      #0,D4                ; D4 = score accumulator
0134: MOVE.L     22(A6),-(A7)         ; Push callback
0138: MOVE.W     D6,-(A7)             ; Push depth
013A: PEA        1(A3)                ; Push remaining letters
013E: MOVE.L     A4,-(A7)             ; Push work buffer
0140: MOVE.L     D7,-(A7)             ; Push validity mask
0142: JSR        -154(PC)             ; Recursive call

0146: TST.W      D0                   ; Check return
0148: LEA        18(A7),A7
014C: BEQ.S      $0152
014E: MOVEQ      #1,D0                ; Found valid - return 1
0150: BRA.S      $016C

; Try next letter in rack
0152: MOVE.B     (A3),(A4)+           ; Add letter to work buffer
0154: MOVE.B     D6,A1                ; (depth++)
...

; Look up letter score
015A: MOVE.B     (A3),D1
015C: EXT.W      D1
015E: MOVEA.W    D1,A0
0160: MOVE.B     0(A0,D7.L),D1        ; Score for this letter
0164: EXT.W      D1
0166: ...
0168: BGT.S      $0134                ; Continue with next letter

016A: MOVEQ      #0,D0                ; Return 0
016C: MOVEM.L    -28(A6),D4/D5/D6/D7/A2/A3/A4
0172: UNLK       A6
0174: RTS
```

**C equivalent**:
```c
int process_combinations(char* validity_mask, char* work_buf,
                         char* rack, int depth,
                         void (*callback)(char*, int)) {
    if (depth > 7) {
        return 0;  // Exceeded max rack size
    }

    if (depth == 7) {
        // Full rack used - calculate score and call callback
        *work_buf = 0;
        int score = 0;

        // Sum up letter scores
        for (char* p = work_buf - depth; *p; p++) {
            char letter = *p;
            score += g_score_table[letter];
        }

        callback(work_buf - depth, score);
        return 1;
    }

    if (*rack == 0) {
        return 0;  // No letters left
    }

    // Try recursive call with remaining letters
    if (process_combinations(validity_mask, work_buf, rack + 1,
                            depth, callback)) {
        return 1;
    }

    // Try adding current letter
    *work_buf++ = *rack;
    int letter_score = g_score_table[*rack];

    // Continue trying combinations
    // ... recursive enumeration

    return 0;
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-15522 | Iteration flag |
| A5-26024 | Letter score lookup table |
| A5-26158 | g_rack - current player's rack |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | Score accumulator function |
| 418 | Error handler |
| 2394 | Get validity mask for position |
| 2402 | Get next letter from iteration |

## Algorithm

The rack filtering process:
1. Get validity mask for current board position (which letters can be played)
2. Filter rack to only include playable letters
3. Recursively enumerate all combinations up to 7 letters
4. Calculate scores for complete combinations
5. Call user callback with each valid combination

## Data Structures

**Validity Mask** (128 bytes):
- One byte per letter (ASCII-indexed)
- Non-zero means letter is valid at current position
- Generated from cross-check sets

**Score Table** at A5-26024:
- Letter point values indexed by letter
- Standard Scrabble scoring (A=1, B=3, C=3, etc.)

## Confidence: HIGH

Clear rack processing patterns:
- Filters rack through validity masks
- Recursive combination enumeration
- Score table lookup for letter values
- Callback-based result processing

---

## Speculative C Translation

### Header File (code38_rack.h)

```c
/*
 * CODE 38 - Rack Letter Filtering and Iteration
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * This small module (374 bytes) provides utilities for filtering
 * rack letters based on validity masks and generating combinations.
 */

#ifndef CODE38_RACK_H
#define CODE38_RACK_H

#include <stdint.h>
#include <stdbool.h>

/* Callback function type for combination processing */
typedef void (*RackCallback)(char* letters, int score);

/*
 * Global variables (A5-relative)
 */
extern uint8_t  g_iteration_flag;       /* A5-15522: Iteration state flag */
extern int16_t  g_score_table[128];     /* A5-26024: Letter score lookup */
extern char*    g_rack;                 /* A5-26158: Current player's rack */

/* Function prototypes */
int always_true(void);
void iterate_rack_with_callback(RackCallback callback);
void filter_rack_letters(RackCallback callback);
int process_combinations(char* validity_mask, char* work_buf,
                        char* rack, int depth, RackCallback callback);

#endif /* CODE38_RACK_H */
```

### Implementation File (code38_rack.c)

```c
/*
 * CODE 38 - Rack Letter Filtering and Iteration Implementation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * Small utility module for rack letter processing with:
 * - Validity mask filtering
 * - Recursive combination enumeration (up to 7 letters)
 * - Score accumulation for combinations
 */

#include "code38_rack.h"

/* External JT functions */
extern int get_validity_mask(char* mask_buffer);           /* JT[2394] */
extern char get_next_letter(char* buffer);                 /* JT[2402] */
extern void bounds_error(void);                            /* JT[418] */
extern int32_t score_accumulate(int32_t val);              /* JT[66] */

/*
 * always_true - Function at 0x0000
 *
 * Trivial function that always returns 1.
 * Used as a default callback or predicate.
 *
 * Returns:
 *   Always 1 (true)
 */
int always_true(void)
{
    return 1;
}

/*
 * iterate_rack_with_callback - Function at 0x000A
 *
 * Iterates through rack letters, calling the provided callback
 * for each valid letter found.
 *
 * Parameters:
 *   callback - Function to call for each letter
 */
void iterate_rack_with_callback(RackCallback callback)
{
    char buffer[8];

    buffer[0] = 0;
    g_iteration_flag = 0;

    while (1) {
        /* Get next letter from rack iteration */
        get_next_letter(buffer);

        /* Check validity (always returns true in default case) */
        if (always_true()) {
            /* Call user callback with letter and constant 1 */
            callback(buffer, 1);
        }

        /* Continue until exhausted (break condition in get_next_letter) */
    }
}

/*
 * filter_rack_letters - Function at 0x0042
 *
 * Filters rack letters through a validity mask, then recursively
 * processes all valid combinations up to 7 letters deep.
 *
 * Parameters:
 *   callback - Function to call with valid combinations
 */
void filter_rack_letters(RackCallback callback)
{
    char validity_mask[128];
    char filtered_rack[160];
    char work_buffer[32];
    char* rack_ptr;
    char* output_ptr;
    int validity_count;

    /* Validate callback is provided */
    if (callback == NULL) {
        bounds_error();
    }

    /* Get validity mask for current board position */
    validity_count = get_validity_mask(validity_mask);

    /* Bounds check: maximum 18 letters processable */
    if (validity_count >= 18) {
        bounds_error();
    }

    /*
     * Filter rack letters through validity mask
     * Only letters that can form valid plays pass through
     */
    output_ptr = filtered_rack;
    rack_ptr = g_rack;

    while (*rack_ptr != 0) {
        char letter = *rack_ptr;

        /* Check if letter is valid at current position */
        if (validity_mask[(unsigned char)letter] != 0) {
            *output_ptr++ = letter;
        }

        rack_ptr++;
    }

    /* Null-terminate filtered result */
    *output_ptr = 0;

    /*
     * Process combinations recursively
     * depth=0, max_depth=7 (full rack)
     */
    process_combinations(
        validity_mask,
        work_buffer,
        filtered_rack,
        0,
        callback
    );
}

/*
 * process_combinations - Function at 0x00AA
 *
 * Recursively enumerates all letter combinations from the filtered rack,
 * calculating scores for complete combinations and calling the callback.
 *
 * Parameters:
 *   validity_mask - 128-byte validity mask for letters
 *   work_buf - Work buffer for building current combination
 *   rack - Remaining letters to process
 *   depth - Current recursion depth (0-7)
 *   callback - Function to call with valid combinations
 *
 * Returns:
 *   1 if a valid combination was found, 0 otherwise
 */
int process_combinations(char* validity_mask, char* work_buf,
                        char* rack, int depth, RackCallback callback)
{
    int score;
    char* word_ptr;
    char* prev_ptr;

    /* Check depth limit (max 7 tiles in Scrabble rack) */
    if (depth > 7) {
        return 0;
    }

    /*
     * Base case: depth == 7 (full rack used)
     * Calculate final score and call callback
     */
    if (depth == 7) {
        /* Null-terminate work buffer */
        *work_buf = 0;

        /* Initialize score calculation */
        score = 0;

        /* Point to start of word (work_buf - depth) */
        word_ptr = work_buf - depth;
        prev_ptr = word_ptr - 1;

        /* Sum up letter scores */
        while (*word_ptr != 0) {
            char current = *word_ptr;
            char next = *(word_ptr + 1);

            /* Skip if same as next (avoid double counting) */
            if (next != 0) {
                /* Get letter value from score table */
                int letter_score = g_score_table[(unsigned char)current];

                /* Accumulate score - uses JT[66] */
                score = score_accumulate(score + letter_score);
            }

            prev_ptr = word_ptr;
            word_ptr++;
        }

        /* Call user callback with word and score */
        callback(work_buf - depth, score);
        return 1;
    }

    /* Check if any letters remain */
    if (*rack == 0) {
        return 0;
    }

    /*
     * Recursive case: try skipping current letter
     */
    if (process_combinations(validity_mask, work_buf, rack + 1,
                            depth, callback)) {
        return 1;  /* Found valid combination */
    }

    /*
     * Try adding current letter to combination
     */
    *work_buf = *rack;

    /* Get score for this letter */
    int letter_score = g_score_table[(unsigned char)*rack];

    /* Continue with deeper recursion */
    if (process_combinations(validity_mask, work_buf + 1, rack + 1,
                            depth + 1, callback)) {
        return 1;
    }

    /* Continue trying other combinations */
    if (letter_score > 0) {
        /* High-value letter - try more combinations */
        /* uncertain - exact continuation logic */
    }

    return 0;
}
```

### Key Algorithmic Notes

```
VALIDITY MASK:
==============
128-byte array indexed by ASCII character code.
Non-zero entry means letter is valid at current position.
Generated by CODE 43's cross-check computation.

RECURSIVE ENUMERATION:
======================
Generates all subsets of rack letters up to 7 deep:
- Skip current letter (recurse with same depth)
- Use current letter (recurse with depth+1)
- Base case at depth 7: calculate score, call callback

SCORE CALCULATION:
==================
At depth 7:
1. Walk through accumulated word
2. Look up each letter in g_score_table (A5-26024)
3. Skip duplicate adjacent letters (uncertain why)
4. Call JT[66] for score accumulation (possibly weighted)

CALLBACK SYSTEM:
================
RackCallback(char* letters, int score):
- letters: Null-terminated string of chosen letters
- score: Accumulated point value

Used by move generator to evaluate rack subsets.

MEMORY LAYOUT:
==============
- validity_mask: 128 bytes (frame -128)
- filtered_rack: 160 bytes (frame -288)
- work_buffer: 32 bytes (frame -256)
Total stack frame: 288 bytes

SIZE NOTE:
==========
At only 374 bytes, this is the smallest CODE resource
in Maven's Scrabble engine. It provides focused utility
functions for rack processing.
```
