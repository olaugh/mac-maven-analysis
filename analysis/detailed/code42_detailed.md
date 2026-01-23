# CODE 42 Detailed Analysis - Rack Analysis and Letter Scoring

## Overview

| Property | Value |
|----------|-------|
| Size | 734 bytes |
| JT Offset | 2672 |
| JT Entries | 2 |
| Functions | 3 |
| Purpose | **Analyze rack letters, calculate letter scores, recursive evaluation** |


## System Role

**Category**: Scoring
**Function**: Rack Analysis

Analyzes rack for scoring potential
## Architecture Role

CODE 42 provides rack analysis functionality:
1. Count available letters in rack
2. Calculate letter scores for positions
3. Recursive letter combination evaluation
4. Support move scoring calculations

## Key Functions

### Function 0x0000 - Initialize Rack Analysis
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D6/D7/A3/A4,-(SP)

; Clear analysis counters
0008: CLR.W      -1668(A5)            ; g_blank_count
000C: CLR.W      -1666(A5)            ; g_letter_count

; Setup rack iteration
0010: LEA        -1696(A5),A4         ; A4 = letter buffer
0014: MOVEA.L    -26158(A5),A3        ; A3 = g_rack

; Loop through rack
0018: BRA.S      $005E

; Process each letter
001A: MOVEA.L    8(A6),A0             ; Get filter array
001E: TST.B      0(A0,D7.W)           ; Check if letter valid
0022: BEQ.S      $005C                ; Skip if not valid

; Valid letter - update output
0024: MOVEA.L    12(A6),A0            ; Output pointer
0028: ADDQ.L     #1,12(A6)            ; Increment output ptr
002C: MOVE.B     D7,(A0)              ; Store letter

; Check if blank (value 0)
002E: MOVEA.L    8(A6),A0
0032: MOVE.B     0(A0,D7.W),D6        ; Get letter value
0036: MOVE.B     D6,D0
0038: EXT.W      D0
003A: ADD.W      D0,-1666(A5)         ; Add to letter count

; Check for special handling
003C: CMPI.W     #1,D0
0040: BNE.S      $0058                ; Not value 1

; Track position in letter buffer
0044: MOVE.L     D7,D0
0046: EXT.L      D0
...
0050: ADD.W      1,-1668(A5)          ; Increment blank count
...

; Check if letter should be stored
0056: BRA.S      $005C
0058: MOVE.B     D7,(A4)+             ; Store in letter buffer
005C: ADDQ       #1,A3                ; Next rack letter

; Get next letter from rack
005E: MOVE.B     (A3),D7
0060: EXT.W      D7
0062: TST.W      D7
0064: BNE.S      $001A                ; Continue if not null

; Terminate output
0066: MOVEA.L    12(A6),A0
006A: CLR.B      (A0)                 ; Null terminate output
006C: CLR.B      (A4)                 ; Null terminate buffer

; Initialize cross-check arrays
006E: MOVE.W     -1666(A5),D0         ; Get letter count
0072: LEA        -17404(A5),A1        ; A1 = cross-check array 1
0076: LEA        -17500(A5),A0        ; A0 = cross-check array 2

; Index into arrays
007A: ADD.W      D0,A0
007C: ADD.W      D0,A0
...

; Validate and initialize
0080: CMP.L      A0,A1
0082: BHI.S      $0086
0084: JSR        418(A5)              ; JT[418] - bounds error

; Clear cross-check entries
0086: MOVEQ      #0,D7
0088: LEA        -17500(A5),A4
008C: BRA.S      $0096

008E: MOVE.W     #$FFFF,(A4)          ; Mark as unprocessed
0092: ADDQ       #1,D7
0094: ADDQ       #2,A4
0096: CMP.W      -1666(A5),D7
009A: BLT.S      $008E                ; Continue init loop

009C: MOVEM.L    (SP)+,D6/D7/A3/A4
00A0: UNLK       A6
00A2: RTS
```

**C equivalent**:
```c
void init_rack_analysis(char* filter, char* output) {
    g_blank_count = 0;
    g_letter_count = 0;

    char* letter_buf = g_letter_buffer;
    char* rack = g_rack;

    while (*rack) {
        char letter = *rack++;

        if (filter[letter]) {
            *output++ = letter;

            int value = filter[letter];
            g_letter_count += value;

            if (value == 1) {
                // Track position for blank handling
                g_blank_count++;
            } else {
                *letter_buf++ = letter;
            }
        }
    }

    *output = 0;
    *letter_buf = 0;

    // Initialize cross-check arrays
    int count = g_letter_count;
    if (count > MAX_ENTRIES) error();

    for (int i = 0; i < count; i++) {
        g_crosscheck_array[i] = 0xFFFF;  // Unprocessed marker
    }
}
```

### Function 0x00A4 - Filtered Letter Score
```asm
00A4: LINK       A6,#-160             ; frame=160
00A8: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)

; Get parameters
00AC: MOVE.L     8(A6),D7             ; D7 = score table
00B0: MOVE.W     12(A6),D4            ; D4 = filter mask
00B4: MOVEQ      #7,D6                ; D6 = max iterations

; Apply filter to blank count
00B6: MOVE.W     -1668(A5),D5         ; D5 = g_blank_count
00BA: AND.W      D4,D5                ; Apply filter

; Count bits set
00BC: BRA.S      $00C8
00BE: SUBQ       #1,D6                ; Decrement
00C0: MOVEQ      #-1,D0
00C2: ADD.B      D5,A0                ; (Bit counting)
00C4: AND.W      D5,D0
00C6: MOVE.W     D0,D5
00C8: TST.W      D5
00CA: BNE.S      $00BE                ; Continue counting

; Validate iteration count
00CC: TST.W      D6
00CE: BGE.S      $00D4
00D0: JSR        418(A5)              ; JT[418] - error

; Invert filter for letter selection
00D4: MOVE.W     -1668(A5),D0
00D8: NOT.W      D0
00DA: AND.W      D0,D4                ; D4 = inverted filter

; Get letter count for iteration
00DC: MOVE.W     -1666(A5),D5         ; g_letter_count
00E0: ADD.W      D6,A5                ; Adjust for blanks

; Check for empty result
00E2: SUBQ       #1,D4
00E4: TST.W      D4
00E6: BNE.S      $00FE                ; Has letters

; Empty - use default
00E8: MOVE.L     D5,D0
00EA: EXT.L      D0
00EC: ...
00F2: ADD.B      A0,(A0)
00F4: MOVEA.W    D6,A0
00F6: ADD.B      A0,$3030.W
00FA: BTST       #24666,D0
00FE: MOVEQ      #123,D0              ; Default value
0100: ADD.B      D7,(A0)
0102: MOVEA.L    D0,A4

; Store result
0104: MOVE.B     D5,(A4)

; Setup iteration buffers
0106: LEA        -160(A6),A2          ; Local buffer
010A: LEA        -1696(A5),A3         ; g_letter_buffer

; Filter letters into local buffer
010E: BRA.S      $0130

; Process each letter
0110: MOVE.L     D5,D0
0112: EXT.L      D0
...
0118: ADD.B      D0,$3028.W
...
0124: MOVE.B     D5,(A2)+             ; Copy to local

; Look up score
0126: MOVEA.W    D5,A0
0128: MOVE.B     0(A0,D7.L),D0        ; Get letter score
012C: SUB.B      D0,(A4)              ; Subtract from total
012E: ADDQ       #1,A3                ; Next letter

0130: MOVE.B     (A3),D5
0132: EXT.W      D5
0134: TST.W      D5
0136: BNE.S      $0110                ; Continue

; Add terminator
0138: MOVE.B     #$7B,(A2)+           ; '{' terminator
013C: CLR.B      (A2)                 ; Null terminate

; Call recursive evaluator
013E: MOVE.W     D6,-(A7)             ; Push iteration count
0140: CLR.W      -(A7)                ; Push 0
0142: PEA        -160(A6)             ; Push filtered buffer
0146: PEA        -128(A6)             ; Push work buffer
014A: MOVE.W     D4,-(A7)             ; Push filter
014C: MOVE.L     D7,-(A7)             ; Push score table
014E: JSR        18(PC)               ; Call recursive function

0152: MOVE.W     D0,D5                ; Save result
0154: CLR.B      (A4)                 ; Clear temp
0156: MOVE.W     D5,D0                ; Return result

0158: MOVEM.L    -188(A6),D4/D5/D6/D7/A2/A3/A4
015E: UNLK       A6
0160: RTS
```

**C equivalent**:
```c
int filtered_letter_score(int* score_table, uint16_t filter) {
    char local_buffer[160];
    char work_buffer[32];

    int iterations = 7;
    uint16_t blank_mask = g_blank_count & filter;

    // Count bits in blank mask
    while (blank_mask) {
        iterations--;
        blank_mask &= (blank_mask - 1);
    }

    if (iterations < 0) error();

    // Invert filter for letter selection
    uint16_t letter_filter = filter & ~g_blank_count;

    int letter_count = g_letter_count + iterations;

    if (letter_filter == 0) {
        // No letters - use default
        return calculate_default(iterations);
    }

    int total = 123;  // Base value

    // Filter letters and calculate scores
    char* out = local_buffer;
    for (char* p = g_letter_buffer; *p; p++) {
        char letter = *p;
        // ... filtering logic
        *out++ = letter;
        total -= score_table[letter];
    }

    *out++ = '{';  // Terminator
    *out = 0;

    return recursive_evaluate(score_table, letter_filter,
                             work_buffer, local_buffer, 0, iterations);
}
```

### Function 0x0162 - Recursive Letter Evaluation
```asm
0162: LINK       A6,#-2               ; frame=2
0166: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Get parameters
016A: MOVEA.L    8(A6),A2             ; A2 = score table
016E: MOVE.W     12(A6),D6            ; D6 = filter
0172: MOVEA.L    14(A6),A4            ; A4 = work buffer
0176: MOVEA.L    18(A6),A3            ; A3 = letter buffer
017A: MOVE.W     22(A6),D7            ; D7 = depth
017E: CMP.W      24(A6),D7            ; Compare with max
0182: BLE.S      $018A
0184: MOVEQ      #0,D0                ; Exceeded max - return 0
0186: BRA.W      $02D8

; Check if at max depth
018A: CMP.W      24(A6),D7
018E: BNE.S      $01E0                ; Not at max

; At max depth - calculate final score
0190: TST.W      D6                   ; Any filter remaining?
0192: BEQ.S      $019A
0194: MOVEQ      #0,D0                ; Filter remains - invalid
0196: BRA.W      $02D8

; Terminate buffer and calculate
019A: CLR.B      (A4)                 ; Null terminate
019C: MOVEA.W    D7,A0
019E: ADD.B      A0,#$01              ; (Score init)
01A2: MOVEA.L    A4,A3
01A4: LEA        -1(A3),A4            ; Backup one

; Sum up scores for placed letters
01A8: MOVE.B     (A3),D3              ; Get letter
01AA: TST.B      D3
01AC: BEQ.S      $01DA                ; End of word

01AE: CMP.W      1(A3),D3             ; Check next
01B2: BEQ.S      $01D6                ; Same letter - skip

; Look up letter score
01B4: MOVE.B     D3,D0
01B6: EXT.W      D0
01B8: MOVE.B     0(A2,D0.W),D0        ; Get from score table
01BC: EXT.W      D0
01BE: EXT.L      D0

; Accumulate score
01C0: ...
01C6: LEA        -26024(A5),A0        ; g_letter_scores
01CA: ADD.B      A0,(A0)
...
01D2: AND.L      (A0),A4              ; (Combine scores)
01D4: MOVEA.L    A3,A4
01D6: ADDQ       #1,A3                ; Next letter
01D8: BRA.S      $01A8                ; Continue

01DA: MOVE.W     D4,D0                ; Return accumulated score
01DC: BRA.W      $02D8

; Not at max depth - check for more letters
01E0: TST.B      (A3)
01E2: BNE.S      $01EA
01E4: MOVEQ      #0,D0                ; No more letters
01E6: BRA.W      $02D8

; Has more letters
01EA: TST.W      D6                   ; Check filter
01EC: BNE.W      $0270                ; Filter active - use it

; No filter - sum all remaining
01F0: MOVEQ      #0,D5                ; Running total
01F2: MOVE.B     (A3),D3              ; Get letter
01F4: TST.B      D3
01F6: BEQ.S      $0208                ; End of buffer

; Add letter score
01F8: MOVE.B     D3,D0
01FA: EXT.W      D0
01FC: MOVE.B     0(A2,D0.W),D0        ; Look up score
0200: EXT.W      D0
0202: ADD.W      D0,A5                ; Add to total
0204: ADDQ       #1,A3
0206: BRA.S      $01F2                ; Continue

; Check if total exceeds target
0208: MOVE.W     24(A6),D6            ; Get target
020C: SUB.W      D7,A6                ; Adjust
020E: CMP.W      D5,A6
0210: BLE.S      $0218
0212: MOVEQ      #0,D0                ; Not enough - return 0
0214: BRA.W      $02D8

; Calculate with remaining letters
0218: CLR.B      (A4)                 ; Null terminate
021A: MOVEA.W    D7,A0
...
022A: MOVEA.W    D6,A0
022C: ADD.B      A0,$3830.W
0230: BTST       #9804,D0
0234: LEA        -1(A3),A4            ; Backup

; Score remaining
0238: MOVE.B     (A3),D3
023A: TST.B      D3
023C: BEQ.S      $026A                ; Done

023E: CMP.W      1(A3),D3
0242: BEQ.S      $0266                ; Skip duplicates

; Add score
0244: MOVE.B     D3,D0
0246: EXT.W      D0
0248: MOVE.B     0(A2,D0.W),D0
024C: EXT.W      D0
024E: EXT.L      D0
...
0256: LEA        -26024(A5),A0
025A: ADD.B      A0,(A0)
...
0264: MOVEA.L    A3,A4
0266: ADDQ       #1,A3
0268: BRA.S      $0238

026A: MOVE.W     D4,D0                ; Return score
026C: BRA.S      $02D6

; Filter active - check current letter
026E: MOVE.B     (A3),D0
0270: EXT.W      D0
0272: EXT.L      D0
...
027C: AND.W      64(A4,D4.W*8),D0     ; Check against filter
...
0284: BEQ.S      $028A
0286: MOVEQ      #0,D0                ; Filtered out
0288: BRA.S      $02D6

; Letter passes filter - recurse
028A: MOVEQ      #0,D5                ; Reset accum
028C: MOVEQ      #0,D4                ; Reset count

; Recursive call
028E: MOVE.W     24(A6),-(A7)         ; Max depth
0292: MOVE.W     D7,-(A7)             ; Current depth
0294: PEA        1(A3)                ; Remaining letters
0298: MOVE.L     A4,-(A7)             ; Work buffer
029A: MOVE.W     D6,-(A7)             ; Filter
029C: MOVE.L     A2,-(A7)             ; Score table
029E: JSR        -318(PC)             ; Recursive call

02A2: ADD.B      D0,A4                ; Accumulate

; Look up current letter score
02A4: MOVE.B     (A3),D0
02A6: EXT.W      D0
02A8: EXT.L      D0
...
02B4: ADD.B      -120(A4,A5.W),D0
02B6: AND.W      0(A0,D0.L),D6        ; Update filter

; Store letter in work buffer
02BA: MOVE.B     (A3),(A4)+           ; Copy letter
02BC: ADDQ       #1,D7                ; Increment depth
02BE: LEA        18(A7),A7            ; Clean stack

; Check for more combinations
02C2: MOVE.W     D5,D0
02C4: ADDQ       #1,D5
02C6: MOVE.B     (A3),D1
02C8: EXT.W      D1
02CA: MOVE.B     0(A2,D1.W),D1        ; Get score
02CE: EXT.W      D1
02D0: CMP.W      D0,A1
02D2: BGT.S      $028E                ; More to try

02D4: MOVE.W     D4,D0                ; Return best
02D6: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
02DA: UNLK       A6
02DC: RTS
```

**C equivalent**:
```c
int recursive_evaluate(int* scores, uint16_t filter,
                       char* work_buf, char* letters,
                       int depth, int max_depth) {
    if (depth > max_depth) {
        return 0;
    }

    if (depth == max_depth) {
        if (filter != 0) return 0;  // Invalid combination

        // Calculate final score
        *work_buf = 0;
        int total = calculate_base(depth);

        for (char* p = work_buf - depth; *p; p++) {
            if (*p != *(p+1)) {  // Skip duplicates
                total += g_letter_scores[scores[*p]];
            }
        }
        return total;
    }

    if (*letters == 0) {
        return 0;  // No more letters
    }

    if (filter == 0) {
        // No filter - sum all remaining
        int sum = 0;
        for (char* p = letters; *p; p++) {
            sum += scores[*p];
        }

        if (sum < (max_depth - depth)) {
            return 0;  // Not enough points
        }

        // Calculate remaining
        return calculate_remaining(scores, work_buf, letters, depth);
    }

    // Filter active - try each letter
    if (!(filter & get_letter_mask(*letters))) {
        return 0;  // Filtered out
    }

    int best = 0;
    for (int i = 0; i < scores[*letters]; i++) {
        int result = recursive_evaluate(scores, filter & ~get_bit(i),
                                        work_buf + 1, letters + 1,
                                        depth + 1, max_depth);
        *work_buf = *letters;
        if (result > best) best = result;
    }

    return best;
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1666 | g_letter_count - Total letter values |
| A5-1668 | g_blank_count - Blank tile tracking |
| A5-1696 | g_letter_buffer - Filtered letters |
| A5-17404 | Cross-check array 1 |
| A5-17500 | Cross-check array 2 |
| A5-26024 | g_letter_scores - Point values |
| A5-26158 | g_rack - Current player's rack |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error/bounds handler |

## Algorithm

Recursive letter evaluation:
1. **Initialize**: Count letters, set up cross-check arrays
2. **Filter**: Apply mask to select subset of letters
3. **Recurse**: Try each valid letter placement
4. **Score**: Sum letter values for valid combinations
5. **Backtrack**: Try alternative letter placements
6. **Return**: Best score found

## Score Calculation

- Base value = 123 (adjusted for letter values)
- Each letter subtracts its score from base
- Cross-check validation against filter masks
- Duplicate letters handled (skip consecutive same)

## Integration with CODE 39

CODE 42's rack analysis feeds directly into CODE 39's letter combination scoring:

1. **CODE 42 → CODE 39 Data Flow**:
   - CODE 42 produces filtered letter lists and counts
   - CODE 39 uses these to generate letter pair combinations
   - Score tables at A5-12512 to A5-12532 are shared

2. **Recursive Evaluation Depth**:
   - Maximum depth = 7 (one full rack)
   - Each depth level represents one letter placement
   - Filter mask tracks which positions have been filled

3. **Cross-Check Integration**:
   - Cross-check arrays at A5-17404 and A5-17500 initialized to 0xFFFF
   - Values updated as letters are validated against board constraints
   - Shared with CODE 43's cross-check generation

## Global Variable Cross-References

| Offset | Used By | Purpose |
|--------|---------|---------|
| A5-1666 | CODE 42, 39 | Letter count accumulator |
| A5-1668 | CODE 42, 39 | Blank tile tracking |
| A5-26024 | CODE 42, 39, 35 | Letter score lookup table |
| A5-26158 | CODE 42, 38, 35 | g_rack pointer |

## Confidence: MEDIUM-HIGH

Recursive scoring pattern with:
- Clear base case (max depth reached)
- Filter-based pruning (0x7F mask)
- Score accumulation via g_letter_scores (A5-26024)
- Backtracking support with filter restoration

Some disassembly artifacts (garbled complex addressing modes) but algorithm structure is clearly a depth-first enumeration with pruning.

---

## Speculative C Translation

### Header File (code42_rack_analysis.h)

```c
/*
 * CODE 42 - Rack Analysis and Letter Scoring
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * Analyzes rack letters for scoring potential using
 * recursive depth-first enumeration with pruning.
 */

#ifndef CODE42_RACK_ANALYSIS_H
#define CODE42_RACK_ANALYSIS_H

#include <stdint.h>
#include <stdbool.h>

/*
 * Global variables (A5-relative)
 */
extern uint16_t  g_blank_tracking;       /* A5-1668: Blank tile tracking */
extern uint16_t  g_letter_value_sum;     /* A5-1666: Total letter values */
extern char      g_letter_buffer[128];   /* A5-1696: Filtered letter buffer */
extern int16_t   g_crosscheck1[48];      /* A5-17404: Cross-check array 1 */
extern int16_t   g_crosscheck2[48];      /* A5-17500: Cross-check array 2 */
extern int16_t   g_letter_scores[128];   /* A5-26024: Letter point values */
extern char*     g_rack;                 /* A5-26158: Current rack pointer */

/* Unprocessed marker for cross-check arrays */
#define CROSSCHECK_UNPROCESSED  0xFFFF

/* Function prototypes */
void init_rack_analysis(char* filter, char* output);
int16_t filtered_letter_score(int32_t* score_table, uint16_t filter);
int16_t recursive_evaluate(int32_t* score_table, uint16_t filter,
                          char* work_buf, char* letters,
                          int depth, int max_depth);

#endif /* CODE42_RACK_ANALYSIS_H */
```

### Implementation File (code42_rack_analysis.c)

```c
/*
 * CODE 42 - Rack Analysis and Letter Scoring Implementation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * Recursive letter evaluation for move scoring:
 * 1. Filter rack letters by validity
 * 2. Enumerate subsets recursively (depth 0-7)
 * 3. Calculate scores for valid combinations
 * 4. Support backtracking for optimal search
 */

#include "code42_rack_analysis.h"

/* External JT functions */
extern void bounds_error(void);  /* JT[418] */

/*
 * init_rack_analysis - Function at 0x0000
 *
 * Initializes rack analysis by filtering valid letters
 * and setting up cross-check arrays.
 *
 * Parameters:
 *   filter - 128-byte validity filter (non-zero = valid)
 *   output - Output buffer for filtered letters
 */
void init_rack_analysis(char* filter, char* output)
{
    char* letter_buf = g_letter_buffer;
    char* rack = g_rack;
    int letter_value;
    int i;

    /* Clear counters */
    g_blank_tracking = 0;
    g_letter_value_sum = 0;

    /*
     * Iterate through rack, filtering by validity
     */
    while (*rack != 0) {
        char letter = *rack;

        /* Check if letter passes filter */
        if (filter[(unsigned char)letter] != 0) {
            /* Valid - add to output */
            *output++ = letter;

            /* Get letter value from filter */
            letter_value = filter[(unsigned char)letter];
            g_letter_value_sum += letter_value;

            /* Check for special handling (value == 1) */
            if (letter_value == 1) {
                /* Track blank tiles */
                g_blank_tracking++;
            } else {
                /* Store in letter buffer */
                *letter_buf++ = letter;
            }
        }

        rack++;
    }

    /* Null terminate both buffers */
    *output = 0;
    *letter_buf = 0;

    /*
     * Initialize cross-check arrays
     * Mark all entries as unprocessed (0xFFFF)
     */
    int count = g_letter_value_sum;

    /* Bounds check */
    if (count > 48) {  /* Max array size */
        bounds_error();
    }

    for (i = 0; i < count; i++) {
        g_crosscheck2[i] = CROSSCHECK_UNPROCESSED;
    }
}

/*
 * filtered_letter_score - Function at 0x00A4
 *
 * Calculates score for letters after applying filter mask.
 * Uses recursive evaluation for combination enumeration.
 *
 * Parameters:
 *   score_table - Pointer to letter score lookup table
 *   filter - 16-bit filter mask for letter selection
 *
 * Returns:
 *   Best score found for filtered combination
 */
int16_t filtered_letter_score(int32_t* score_table, uint16_t filter)
{
    char local_buffer[160];
    char work_buffer[32];
    char* out;
    char* src;
    int iterations;
    uint16_t blank_mask;
    uint16_t letter_filter;
    int16_t base_total;

    /*
     * Count bits in blank mask (intersection with filter)
     */
    iterations = 7;  /* Start at max rack size */
    blank_mask = g_blank_tracking & filter;

    while (blank_mask != 0) {
        iterations--;
        blank_mask &= (blank_mask - 1);  /* Clear lowest bit */
    }

    if (iterations < 0) {
        bounds_error();
    }

    /*
     * Invert filter for letter selection
     * Letters NOT marked as blanks
     */
    letter_filter = filter & ~g_blank_tracking;

    /*
     * Check for empty result
     */
    if (letter_filter == 0) {
        /* No letters - calculate default based on iterations */
        /* uncertain - exact default calculation */
        return iterations * 10;  /* Placeholder */
    }

    /*
     * Initialize base total
     * 123 appears to be a magic base value
     */
    base_total = 123;

    /*
     * Filter letters into local buffer, subtracting scores
     */
    out = local_buffer;
    src = g_letter_buffer;

    while (*src != 0) {
        char letter = *src;

        /* Copy to local buffer */
        *out++ = letter;

        /* Look up and subtract score */
        int16_t letter_score = ((int8_t*)score_table)[(unsigned char)letter];
        base_total -= letter_score;

        src++;
    }

    /* Add terminator marker ('{' = 0x7B) */
    *out++ = '{';
    *out = 0;

    /*
     * Call recursive evaluator
     */
    return recursive_evaluate(
        score_table,
        letter_filter,
        work_buffer,
        local_buffer,
        0,              /* Starting depth */
        iterations      /* Max depth */
    );
}

/*
 * recursive_evaluate - Function at 0x0162
 *
 * Recursively evaluates letter combinations using depth-first
 * search with filter-based pruning.
 *
 * Parameters:
 *   score_table - Letter score lookup table
 *   filter - Current filter mask (bits cleared as letters used)
 *   work_buf - Work buffer for current combination
 *   letters - Remaining letters to process
 *   depth - Current recursion depth
 *   max_depth - Maximum depth (letters to place)
 *
 * Returns:
 *   Best score found, or 0 if invalid
 */
int16_t recursive_evaluate(int32_t* score_table, uint16_t filter,
                          char* work_buf, char* letters,
                          int depth, int max_depth)
{
    int16_t accumulated_score;
    char* word_ptr;
    char* prev_ptr;
    char current_letter;
    int16_t letter_score;
    int16_t best_score;
    int count;

    /*
     * Check depth limit
     */
    if (depth > max_depth) {
        return 0;  /* Exceeded - invalid */
    }

    /*
     * BASE CASE: At max depth
     * Calculate final score for this combination
     */
    if (depth == max_depth) {
        /* Filter must be empty at max depth */
        if (filter != 0) {
            return 0;  /* Still have filter bits - invalid */
        }

        /* Null terminate work buffer */
        *work_buf = 0;

        /* Initialize score calculation */
        accumulated_score = depth + 1;  /* Base value */

        /* Walk through accumulated word */
        word_ptr = work_buf - depth;  /* Point to start */
        prev_ptr = word_ptr - 1;

        while (*word_ptr != 0) {
            current_letter = *word_ptr;

            /* Skip if same as next letter (avoid double counting) */
            if (*(word_ptr + 1) != current_letter) {
                /* Look up letter score */
                letter_score = ((int8_t*)score_table)[(unsigned char)current_letter];

                /* Add to accumulated score via lookup */
                accumulated_score += g_letter_scores[letter_score];
            }

            prev_ptr = word_ptr;
            word_ptr++;
        }

        return accumulated_score;
    }

    /*
     * Check if any letters remain
     */
    if (*letters == 0) {
        return 0;  /* No more letters */
    }

    /*
     * CASE: No filter remaining
     * Sum all remaining letters
     */
    if (filter == 0) {
        int16_t remaining_sum = 0;
        char* p = letters;

        /* Sum remaining letter scores */
        while (*p != 0) {
            letter_score = ((int8_t*)score_table)[(unsigned char)*p];
            remaining_sum += letter_score;
            p++;
        }

        /* Check if enough potential to reach target */
        int remaining_depth = max_depth - depth;
        if (remaining_sum < remaining_depth) {
            return 0;  /* Not enough points */
        }

        /* Calculate score for remaining */
        *work_buf = 0;
        accumulated_score = depth + remaining_depth;

        /* Similar scoring loop for remaining letters */
        word_ptr = letters;
        while (*word_ptr != 0) {
            current_letter = *word_ptr;

            if (*(word_ptr + 1) != current_letter) {
                letter_score = ((int8_t*)score_table)[(unsigned char)current_letter];
                accumulated_score += g_letter_scores[letter_score];
            }

            word_ptr++;
        }

        return accumulated_score;
    }

    /*
     * RECURSIVE CASE: Filter active
     * Check if current letter passes filter
     */
    current_letter = *letters;

    /* uncertain - exact filter check mechanism */
    /* Check letter against filter mask */
    uint32_t letter_mask = 1 << (current_letter & 0x1F);  /* uncertain */

    if ((filter & letter_mask) == 0) {
        return 0;  /* Filtered out */
    }

    /*
     * Try combinations with this letter
     */
    best_score = 0;
    count = 0;
    letter_score = ((int8_t*)score_table)[(unsigned char)current_letter];

    while (count < letter_score) {
        /* Recursive call with updated filter */
        uint16_t new_filter = filter & ~(1 << count);  /* Clear bit */

        int16_t result = recursive_evaluate(
            score_table,
            new_filter,
            work_buf + 1,
            letters + 1,
            depth + 1,
            max_depth
        );

        /* Store letter in work buffer */
        *work_buf = current_letter;

        /* Track best score */
        if (result > best_score) {
            best_score = result;
        }

        count++;
    }

    return best_score;
}
```

### Key Algorithmic Notes

```
RECURSIVE ENUMERATION:
======================
Depth-first search through letter combinations:
- depth 0: Initial call, 0 letters placed
- depth 1-6: Intermediate states
- depth 7: Base case, full rack evaluated

FILTER-BASED PRUNING:
=====================
16-bit filter mask tracks which positions are filled:
- Bit set = position available
- Bit clear = position filled
- Filter must be 0 at max depth for valid combination

SCORE CALCULATION:
==================
Base value + sum of letter scores:
- Base value = depth + 1 (or 123 in some paths)
- Each unique letter adds g_letter_scores[letter_value]
- Skip duplicate adjacent letters

BLANK HANDLING:
===============
Blank tiles tracked separately in g_blank_tracking.
Filter is masked with ~g_blank_tracking to exclude blanks
from normal letter processing.

CROSS-CHECK ARRAYS:
===================
Two 48-entry arrays (96 bytes total) at A5-17404/17500.
Initialized to 0xFFFF (unprocessed).
Updated during evaluation to cache results.

INTEGRATION WITH CODE 39:
=========================
CODE 42 provides:
- Filtered letter lists
- Letter counts (g_letter_value_sum)
- Blank tracking (g_blank_tracking)

CODE 39 uses these for letter pair generation
and synergy scoring.

BACKTRACKING:
=============
Work buffer accumulates current combination.
On return from recursion, previous state is preserved
in work_buf allowing exploration of alternatives.

TERMINATOR CHARACTER:
=====================
'{' (0x7B) used as special terminator in local_buffer.
Distinguishes end of letters from null terminator.
```
