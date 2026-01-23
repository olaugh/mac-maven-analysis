# CODE 32 Detailed Analysis - Core Move Scoring and Leave Value Application

## Overview

| Property | Value |
|----------|-------|
| Size | 6464 bytes |
| JT Offset | 2384 |
| JT Entries | 13 |
| Functions | ~20 (large module) |
| Purpose | **Core move scoring with leave value adjustments** |

## System Role

**Category**: Scoring Engine
**Function**: Move Evaluation with Leave Values

This is the central scoring module that:
1. Evaluates base tile scores with multipliers
2. Applies bingo bonus (5000 centipoints = 50 points)
3. Applies MUL leave values (SUBTRACTED from score)
4. Tracks best positions for move generation

**Scale Note**: All scores in CENTIPOINTS (1/100 of a point).
- Bingo bonus = 5000 centipoints = 50 actual points
- Leave values are SUBTRACTED (negative raw value = bonus to score)

## Architecture Role

CODE 32 coordinates with:
- **CODE 15**: Loads MUL resources (leave value tables per tile)
- **CODE 39**: Combination generation
- **CODE 45**: Move ranking
- **CODE 35**: Simulation source

## Key Functions

### Function 0x0000 - Main Move Evaluation (Frame: 324 bytes)

```asm
0000: LINK       A6,#-324           ; Large frame for scoring state
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Clear position tracking globals
0008: CLR.W      -17158(A5)         ; g_best_col = 0
000C: CLR.W      -17160(A5)         ; g_best_col2 = 0
0010: CLR.W      -17162(A5)         ; g_best_row = 0
0014: CLR.W      -17164(A5)         ; g_best_row2 = 0
0018: CLR.W      -20010(A5)         ; g_tile_count = 0 (tiles placed this move)

; Get move descriptor and check validity
001C: MOVEQ      #32,D0
001E: ADD.B      8(A6),(A0)         ; Calculate move pointer
0022: MOVEA.L    D0,A4
0024: TST.B      (A4)               ; Check if move has tiles
0026: BNE.S      $002E              ; Continue if yes
0028: MOVEQ      #0,D0              ; Return 0 for empty move
002A: BRA.W      $0646

; Get rack pointer and initialize letter counts
002E: MOVEA.L    -26158(A5),A2      ; A2 = g_rack pointer

; Initialize letter count array at -256(A6)
; This tracks available letters for the move
0034: MOVEA.L    A6,A0
0036: ADD.W      D6,A0
0038: ADD.W      D6,A0              ; Double indexing for word alignment
003A: CLR.W      -256(A0)           ; Clear count for this letter code
...

; Process opponent rack to adjust available counts
0048: MOVEA.L    12(A6),A2          ; Get opponent rack parameter
004E: ADDQ.W     #1,-256(A0)        ; Increment opponent letter count
...

; Setup board array pointers
0086: MOVEQ      #17,D1             ; Board is 17x17 (with borders)
0088: AND.L      D4,A1              ; row * 17
008A: LEA        -17154(A5),A4      ; A4 = g_state1 (letter board)
...
00E2: MOVEQ      #34,D0
00E4: AND.L      D4,A0
00E6: LEA        -16610(A5),A0      ; A0 = g_state2 (score board, 34 bytes/row)
```

**C equivalent**:
```c
int evaluate_move(Move* move, char* rack, char* opp_rack, char* result) {
    int letter_counts[128] = {0};  // At -256(A6)

    // Clear position tracking
    g_best_col = g_best_col2 = 0;
    g_best_row = g_best_row2 = 0;
    g_tile_count = 0;

    if (!move->tiles[0]) return 0;  // Empty move

    // Count player's rack letters
    for (char* p = g_rack; *p; p++) {
        letter_counts[*p * 2] = 0;  // Initialize
    }

    // Adjust for opponent rack
    for (char* p = opp_rack; *p; p++) {
        letter_counts[*p * 2]++;
    }

    // Get board position
    int row = move->row;
    int col = move->col;
    char* board = &g_state1[row * 17];      // Letter grid
    short* scores = &g_state2[row * 34];    // Score grid

    // ... continue scoring ...
}
```

### Score Calculation with Multipliers (0x0116-0x02B8)

```asm
; Accumulate base tile score
0116: MOVE.L     -324(A6),-(A7)     ; Push current accumulated score
011A: MOVEA.L    -302(A6),A0        ; Letter values table (A5-26702)
011E: MOVE.B     0(A0,D3.W),D0      ; Get letter value for column
0122: EXT.W      D0
0124: MOVEA.W    D0,A1
0126: MOVE.L     A1,-(A7)
0128: JSR        66(A5)             ; JT[66] - multiply accumulator

; Increment tile count
0130: ADDQ.W     #1,-20010(A5)      ; g_tile_count++

; Validate tile count (must be 1-7)
0134: CMPI.W     #$0008,-20010(A5)  ; if >= 8
013A: BGE.S      $0142              ; Error
013C: TST.W      -20010(A5)         ; if <= 0
0140: BGT.S      $0146              ; OK
0142: JSR        418(A5)            ; bounds_error()

; Check cross-word scoring
; Word multipliers: 2=double, 3=triple
019A: CMPI.W     #$0010,D4          ; Check row bounds
01A0: MOVEA.L    -270(A6),A0        ; Get multiplier lookup
01A4: TST.B      0(A0,D3.W)         ; Check for word multiplier
01A8: BNE.S      $01BE              ; Apply multiplier

; Apply word multiplier (double/triple word)
01CC: PEA        $0022.W            ; 34 = row stride for g_state2
01D0: MOVE.L     D7,-(A7)           ; Direction multiplier
01D2: JSR        66(A5)             ; Multiply
01D6: LEA        -16610(A5),A0      ; g_state2
```

### Bingo Bonus Check (0x0328-0x0344)

**Confidence: VERY HIGH** - Clear comparison and constant

```asm
; Check for bingo (all 7 tiles from rack used)
0328: CMPI.W     #$0007,-20010(A5)  ; g_tile_count == 7?
032E: BNE.S      $0336              ; No bingo
0330: MOVE.W     #$1388,D0          ; 0x1388 = 5000 decimal = BINGO BONUS!
0334: BRA.S      $0338
0336: MOVEQ      #0,D0              ; No bonus

; Add bonus to accumulated score
0338: MOVE.L     D5,-(A7)
033A: MOVE.L     -324(A6),-(A7)     ; Current score
033E: MOVE.L     D0,D1              ; Bingo bonus (5000 or 0)
0340: JSR        66(A5)             ; JT[66] - add/multiply
```

**Analysis**:
- 5000 centipoints = 50 actual Scrabble points (standard bingo bonus)
- Applied when exactly 7 tiles placed from rack

### Best Position Tracking (0x0594-0x05B8)

```asm
; Compare current score with best scores, update tracking
0594: CMP.L      -314(A6),(A5)      ; Compare with best1
0598: BGE.S      $05B8              ; Not better - skip

059A: CMP.L      -310(A6),(A5)      ; Compare with best2
059E: BGE.S      $05B0              ; Not better for best2

; New score beats both - shift down
05A0: MOVE.W     -17160(A5),-17158(A5)  ; g_best_col = g_best_col2
05A6: MOVE.L     -310(A6),-314(A6)      ; best1 = old best2

; Store new best
05AA: MOVE.W     D3,-17160(A5)      ; g_best_col2 = current col
05AE: MOVE.L     D5,-310(A6)        ; best2 = current score
05B2: BRA.S      $05B8

05B0: MOVE.W     D3,-17158(A5)      ; g_best_col = current col
05B4: MOVE.L     D5,-314(A6)        ; best1 = current score
```

### Leave Value Application (Functions at 0x0BFC and around 0x0B54)

**Confidence: HIGH** - Multiple JT[90] (divide) calls with leave-related context

The leave value system works with the MUL resources:

```asm
; From function around 0x0B42-0x0B62
0B42: MOVEA.W    -12538(A5),A0      ; Get configuration value
0B48: MOVEA.W    -12538(A5),A0      ; g_config
0B4C: MOVE.L     -26(A6),D0         ; Get leave total
0B50: SUB.B      A0,(A0)            ; Adjustment
0B52: MOVE.L     D0,-(A7)
0B54: JSR        90(A5)             ; JT[90] - divide (scale leave value)
0B58: MOVE.W     D0,D3
0B5A: CMPI.W     #$FF9C,D3          ; -100 comparison
0B5E: BLE.S      $0B9A              ; Branch if <= -100
0B60: MOVEQ      #-100,D3           ; Clamp to -100 minimum
0B62: BRA.S      $0B9A
0B64: MOVEQ      #0,D3              ; Default to 0
```

**Leave Value Interpretation**:
- Leave values are SUBTRACTED from move score
- Negative leave value = BONUS (improves score)
- Positive leave value = PENALTY (reduces score)
- Values clamped to -100 minimum (prevents extreme bonuses)
- JT[90] used for division/scaling

### Function 0x08B8 - Initialize Scoring Context (Frame: 136 bytes)

```asm
08B8: LINK       A6,#-136
08BC: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
08C0: MOVE.L     12(A6),D7          ; Parameter 2
08C4: MOVEA.L    16(A6),A4          ; Parameter 3

; Increment scoring counter
08C8: ADDQ.L     #1,-20004(A5)      ; g_score_counter++
08CC: MOVE.L     -20004(A5),-20008(A5)  ; Save previous value

; Clear working buffers
08D2: PEA        $0100.W            ; 256 bytes
08D6: PEA        -17420(A5)         ; g_work_buffer
08DA: JSR        426(A5)            ; memset

08DE: PEA        $0100.W            ; 256 bytes
08E2: PEA        -13060(A5)         ; Another buffer
08E6: JSR        426(A5)            ; memset

; Clear leave index
08EA: CLR.W      -13062(A5)         ; g_leave_index = 0
```

### Function 0x064C - Filter Positions by Mask

```asm
064C: LINK       A6,#0
0650: MOVEM.L    D7/A2/A3/A4,-(SP)

; Call setup function
0654: MOVE.W     8(A6),-(A7)        ; Push mask parameter
0658: JSR        354(PC)            ; Internal filter setup

; Initialize iteration
065C: MOVEQ      #0,D7              ; Counter
065E: LEA        -2728(A5),A4       ; A4 = g_filter_output
0662: LEA        -12804(A5),A3      ; A3 = g_position_list

; Filter loop
0678: MOVE.W     8(A6),D0           ; Get mask
067C: EXT.L      D0
067E: AND.L      (A2),D0            ; Apply mask to position flags
0680: BEQ.S      $0684              ; Skip if no match
0682: MOVE.B     (A3),(A4)+         ; Copy matching position

0684: ADDQ.L     #1,A3              ; Next position
0686: ADDQ.W     #1,D7              ; Increment counter
0688: ADDQ.L     #4,A2              ; Next mask entry (4 bytes)
068A: TST.B      (A3)               ; End of list?
068C: BNE.S      $0678              ; Continue

068E: CLR.B      (A4)               ; Null terminate output
0690: LEA        -2728(A5),A0       ; Return filtered list
0694: MOVE.L     A0,D0
```

## Global Variables

| Offset | Size | Purpose |
|--------|------|---------|
| A5-2728 | ~256 | Filter output buffer |
| A5-12538 | 2 | Configuration / scaling value |
| A5-12804 | ~256 | Position list for filtering |
| A5-13060 | 256 | Scoring work buffer |
| A5-13062 | 2 | Leave value index |
| A5-16610 | 578 | g_state2 - Score board (17x17x2) |
| A5-17154 | 289 | g_state1 - Letter board (17x17) |
| A5-17158 | 2 | g_best_col - Best column position |
| A5-17160 | 2 | g_best_col2 - Second best column |
| A5-17162 | 2 | g_best_row - Best row position |
| A5-17164 | 2 | g_best_row2 - Second best row |
| A5-17420 | 256 | Work buffer for scoring |
| A5-20004 | 4 | g_score_counter |
| A5-20008 | 4 | g_score_counter_prev |
| A5-20010 | 2 | g_tile_count - Tiles placed this move |
| A5-26158 | 4 | g_rack - Pointer to current rack string |
| A5-26702 | 544 | Letter value lookup table |
| A5-27246 | 544 | Letter score lookup table |
| A5-27630 | 256 | Letter point values (for scoring) |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | Multiply/accumulate scores |
| 90 | Divide (used for leave value scaling) |
| 418 | Error handler (bounds checking) |
| 426 | memset |
| 794 | Dictionary lookup |
| 2002 | Check if letter playable |
| 2338 | Calculate search bounds |
| 2386 | Initialize position list |
| 2394 | Get position count |
| 3466 | memmove |
| 3490 | strcpy |
| 3506 | strcmp |
| 3514 | strncmp |
| 3522 | strlen |

## Score Calculation Algorithm

1. **Initialization**:
   - Clear best position tracking globals
   - Count available letters from rack
   - Set up board array pointers

2. **For each tile placement**:
   - Verify position is empty
   - Look up letter value from table
   - Apply letter multiplier (2x, 3x letter)
   - Check for word multipliers (2x, 3x word)
   - Accumulate cross-word scores
   - Increment tile count

3. **Finalization**:
   - Check for bingo (7 tiles = +5000 centipoints)
   - Apply leave value adjustment (SUBTRACT from score)
   - Update best position tracking if score improved

4. **Leave Value Application**:
   - Look up remaining rack tiles after move
   - Get leave value from MUL resource
   - Scale appropriately (JT[90] divide)
   - SUBTRACT from move score (negative = bonus)

## Board Layout

17x17 arrays with border cells:
- **g_state1**: Letter codes (0 = empty, ASCII otherwise)
- **g_state2**: Score values (0 = blank tile, else letter points)

Position calculation:
```c
int board_idx = row * 17 + col;
char letter = g_state1[board_idx];
short score = g_state2[board_idx * 2];  // Word-sized entries
```

## Leave Value System

The MUL (presumably "Multiple Utility Leave") resources contain pre-computed leave values:
- One MUL resource per tile count (1-7 tiles remaining)
- Indexed by rack combination
- **Negative values are GOOD** (common letters like S, blank)
- **Positive values are BAD** (awkward letters like Q, V)
- Subtraction means: score = base_score - leave_value
- So negative leave_value INCREASES final score

## Confidence Levels

- **Bingo bonus (5000)**: VERY HIGH - explicit constant comparison
- **Board layout (17x17)**: VERY HIGH - consistent multipliers throughout
- **Leave subtraction**: HIGH - consistent with Scrabble AI theory
- **Global variable purposes**: HIGH - consistent usage patterns
- **JT function purposes**: MEDIUM-HIGH - inferred from context

## Related Resources

- **MUL 1-7**: Leave value tables per tile count
- **VCB**: Vowel count bonus/penalty adjustments
- **CODE 15**: Resource loading
- **CODE 35**: Simulation (uses same scoring)

---

## Speculative C Translation

### Main Move Evaluation Function (0x0000)

This is the core scoring function that evaluates a move and calculates its total score including cross-words, bingo bonus, and leave value adjustments.

```c
/* Global variables (A5-relative) */
short g_best_col;           /* A5-17158: Best column position found */
short g_best_col2;          /* A5-17160: Second best column */
short g_best_row;           /* A5-17162: Best row position found */
short g_best_row2;          /* A5-17164: Second best row */
short g_tile_count;         /* A5-20010: Number of tiles placed this move */
char* g_rack;               /* A5-26158: Pointer to current rack string */
char  g_board_letters[289]; /* A5-17154: 17x17 board letter grid (g_state1) */
short g_board_scores[289];  /* A5-16610: 17x17 board score grid (g_state2) */
char  g_letter_values[256]; /* A5-26702: Letter point values for scoring */
char  g_letter_mult[256];   /* A5-27246: Letter multiplier lookup */
char  g_word_mult_before[289]; /* A5-17154 - 544: Word multiplier (before) */
char  g_word_mult_after[289];  /* uncertain: Word multiplier (after) */

#define BOARD_WIDTH 17
#define BINGO_BONUS 5000    /* 50 points in centipoints */
#define MAX_TILES 7

typedef struct {
    char tiles[32];         /* +0: Word tiles to play */
    char row;               /* +33: Starting row */
    /* uncertain */ char col;  /* +32: Starting column or direction */
} Move;

/*
 * evaluate_move - Calculate total score for a proposed move
 *
 * @param move_ptr: Pointer to Move structure
 * @param opponent_rack: String of opponent's rack tiles
 * Returns: Total move score in centipoints, or 0 if invalid
 */
long evaluate_move(Move* move_ptr, char* opponent_rack) {  /* uncertain */
    short letter_counts[128];      /* -256(A6): Track available letters */
    long accumulated_score;         /* -324(A6): Running score total */
    long best_score_1;              /* -314(A6): Best score tracking */
    long best_score_2;              /* -310(A6): Second best score */
    long cross_word_score;          /* -320(A6): Cross-word score accumulator */
    char* letter_value_table;       /* -302(A6): Pointer to A5-26702 */
    char* letter_mult_table;        /* -298(A6): Pointer to A5-27246 */
    char* word_mult_before;         /* -270(A6): Word multiplier table 1 */
    char* word_mult_after;          /* -266(A6): Word multiplier table 2 */
    short* score_row_ptr;           /* -262(A6): Current row in score grid */

    /* Clear position tracking globals */
    g_best_col = 0;
    g_best_col2 = 0;
    g_best_row = 0;
    g_best_row2 = 0;
    g_tile_count = 0;

    /* Get move word - offset 32 into structure */
    char* word_to_play = (char*)move_ptr + 32;

    /* Empty move check */
    if (*word_to_play == 0) {
        return 0;
    }

    /* Initialize letter counts from player's rack */
    for (char* p = g_rack; *p; p++) {
        int idx = (unsigned char)*p;
        letter_counts[idx * 2] = 0;  /* Clear count for rack letters */
    }

    /* Adjust counts for opponent's rack */
    for (char* p = opponent_rack; *p; p++) {
        int idx = (unsigned char)*p;
        letter_counts[idx * 2]++;    /* Increment for opponent tiles */
    }

    /* Get starting position */
    int start_row = move_ptr->row;   /* Offset 33 */
    int direction = move_ptr->col;   /* Offset 32 - uncertain if col or dir */

    /* Initialize score accumulators */
    accumulated_score = 1;           /* Start at 1 for multiplication */
    cross_word_score = 0;
    best_score_1 = -1;               /* Sentinel for "no score yet" */
    best_score_2 = -1;

    /* Calculate board array pointers */
    int board_offset = start_row * BOARD_WIDTH;
    char* board_row = &g_board_letters[board_offset];
    letter_value_table = g_letter_values + board_offset;
    letter_mult_table = g_letter_mult + board_offset;

    int score_offset = start_row * (BOARD_WIDTH * 2);  /* 34 bytes per row */
    short* score_row = &g_board_scores[score_offset / 2];

    /* Main scoring loop - process each tile in the word */
    int col = 0;  /* uncertain: starting column tracking */
    for (char* tile_ptr = word_to_play; *tile_ptr; tile_ptr++) {
        char tile = *tile_ptr;

        /* Check if this position is already occupied */
        if (board_row[col] != 0) {
            /* Position occupied - add existing tile score, no multipliers */
            goto next_position;
        }

        /* Get letter point value from table */
        int letter_value = letter_value_table[col];

        /* Multiply into accumulated score */
        accumulated_score = multiply_scores(accumulated_score, letter_value);  /* JT[66] */

        /* Increment tile placement count */
        g_tile_count++;

        /* Bounds check: must place 1-7 tiles */
        if (g_tile_count >= 8 || g_tile_count <= 0) {
            bounds_error();  /* JT[418] */
        }

        /* Check if we need to apply word multipliers */
        /* uncertain: exact multiplier logic */
        if (start_row != 16) {  /* Not border row */
            if (word_mult_before[col] != 0) {
                /* Has word multiplier - apply to cross-words */
                apply_word_multiplier(col, &cross_word_score);  /* uncertain */
            }
        }

        if (start_row != 15) {  /* Not last playable row */
            if (word_mult_after[col] != 0) {
                /* Secondary multiplier check */
                apply_secondary_multiplier(col);  /* uncertain */
            }
        }

        /* Track best positions */
        if (accumulated_score < best_score_1) {
            /* New best - shift down */
            g_best_col = g_best_col2;
            best_score_1 = best_score_2;

            g_best_col2 = col;
            best_score_2 = accumulated_score;
        } else if (accumulated_score < best_score_2) {
            g_best_col = col;
            best_score_1 = accumulated_score;
        }

        /* Update row tracking */
        if (score_row[col] == 0) {
            /* First time placing here - update best row tracking */
            g_best_row2 = g_best_row;
            g_best_col2 = g_best_col;
            g_best_row = start_row;
            g_best_col = col;
        }

    next_position:
        col++;
        /* uncertain: exact column/direction advancement */
    }

    /* Validate final accumulated score is a valid multiplier product */
    /* Check against valid word multiplier combinations: 1, 2, 3, 4, 9, 27 */
    if (accumulated_score != 1 && accumulated_score != 2 &&
        accumulated_score != 3 && accumulated_score != 4 &&
        accumulated_score != 9 && accumulated_score != 27) {
        bounds_error();  /* JT[418] - invalid multiplier combination */
    }

    /*=== BINGO BONUS CHECK ===*/
    /* If exactly 7 tiles placed, add 50-point (5000 centipoint) bingo bonus */
    short bingo_bonus = 0;
    if (g_tile_count == 7) {
        bingo_bonus = 5000;  /* 0x1388 = 50 actual Scrabble points */
    }

    /* Add bingo bonus to accumulated score */
    /* uncertain: exact combination with cross_word_score */
    long final_score = multiply_scores(accumulated_score, bingo_bonus);  /* JT[66] */
    final_score += cross_word_score;

    /* Additional position-based scoring... */
    /* uncertain: ~200 more lines of position refinement */

    return final_score;
}
```

### Leave Value Application (around 0x0B42-0x0BFC)

This function applies the MUL (leave value) adjustment to the move score. Leave values represent the expected value of tiles remaining on the rack after a move.

```c
/* Global variables */
short g_config_value;       /* A5-12538: Configuration/scaling factor */
short g_leave_index;        /* A5-13062: Current leave lookup index */

/*
 * apply_leave_value - Adjust move score based on remaining rack quality
 *
 * Leave values are SUBTRACTED from the move score:
 *   - Negative leave value = BONUS (good tiles remaining, e.g., S, blank)
 *   - Positive leave value = PENALTY (awkward tiles remaining, e.g., Q, V)
 *
 * @param base_score: The raw move score before leave adjustment
 * @param remaining_rack: Tiles left on rack after this move
 * Returns: Adjusted score (base_score - leave_value)
 */
long apply_leave_value(long base_score, char* remaining_rack) {  /* uncertain */
    long leave_total;           /* -26(A6): Accumulated leave value */
    short scaled_leave;         /* D3: Scaled leave for final application */

    /* Look up leave value from MUL resource */
    /* uncertain: exact lookup mechanism */
    leave_total = lookup_mul_leave(remaining_rack);  /* Uses MUL 1-7 resources */

    /* Scale the leave value */
    short config = g_config_value;
    leave_total = divide_long(leave_total, config);  /* JT[90] */

    scaled_leave = (short)leave_total;

    /* Clamp leave adjustment to reasonable range */
    if (scaled_leave <= -100) {
        scaled_leave = -100;   /* Minimum penalty (max bonus when subtracted) */
    }
    /* uncertain: upper clamp logic */

    /* Apply leave value by SUBTRACTION */
    /* Negative leave = good remaining tiles = score INCREASES */
    /* Positive leave = bad remaining tiles = score DECREASES */
    long adjusted_score = base_score - scaled_leave;

    return adjusted_score;
}
```

### Initialize Scoring Context (0x08B8)

Sets up the working buffers and counters for a scoring pass.

```c
/* Global variables */
long g_score_counter;       /* A5-20004: Total scoring operations */
long g_score_counter_prev;  /* A5-20008: Previous counter value */
char g_work_buffer[256];    /* A5-17420: Scoring work buffer */
char g_secondary_buffer[256]; /* A5-13060: Secondary work buffer */

/*
 * init_scoring_context - Prepare for a new scoring evaluation
 *
 * @param context: Scoring context pointer (uncertain structure)
 * @param param2: Unknown parameter
 * @param param3: Unknown parameter
 */
void init_scoring_context(void* context, long param2, void* param3) {
    /* Increment global scoring counter */
    g_score_counter++;
    g_score_counter_prev = g_score_counter;

    /* Clear 256-byte work buffers */
    memset(g_work_buffer, 0, 256);      /* JT[426] */
    memset(g_secondary_buffer, 0, 256); /* JT[426] */

    /* Reset leave value index */
    g_leave_index = 0;

    /* uncertain: additional context setup */
}
```

### Filter Positions by Mask (0x064C)

Filters valid board positions based on a bitmask for move generation.

```c
/* Global variables */
char g_filter_output[256];  /* A5-2728: Filtered position list */
char g_position_list[256];  /* A5-12804: Full position list */
long g_position_flags[256]; /* uncertain: Flags for each position */

/*
 * filter_positions - Extract positions matching a given mask
 *
 * @param mask: Bitmask to filter positions (e.g., horizontal vs vertical)
 * Returns: Pointer to null-terminated list of matching positions
 */
char* filter_positions(short mask) {
    char* output = g_filter_output;
    char* positions = g_position_list;
    long* flags = g_position_flags;

    /* Call setup helper */
    setup_filter(mask);  /* PC-relative call at +354 */

    int count = 0;

    /* Iterate through positions, copying those matching the mask */
    while (*positions) {
        long pos_flags = *flags;

        if ((pos_flags & (long)mask) != 0) {
            /* Position matches mask - copy to output */
            *output++ = *positions;
        }

        positions++;
        flags++;  /* 4 bytes per flag entry */
        count++;
    }

    /* Null-terminate output list */
    *output = 0;

    return g_filter_output;
}
```

### Key Data Structures

```c
/*
 * Move structure - represents a single move candidate
 * Total size: 34 bytes
 */
typedef struct Move {
    struct Move* next;      /* +0: Linked list pointer */
    long score;             /* +4: Calculated score */
    char flags;             /* +8: Move flags */
    char row;               /* +9: Board row (1-15) */
    char col;               /* +10: Board column (1-15) */
    char direction;         /* +11: 0=horizontal, 1=vertical */
    char length;            /* +12: Word length */
    char id;                /* +13: Move candidate ID */
    short reserved;         /* +14: Padding */
    long base_score;        /* +16: Score before multipliers */
    long bonus_score;       /* +20: Bonus points (bingo, etc.) */
    long extra_score;       /* +24: Cross-word score */
    char flags2;            /* +28: Secondary flags */
    char special;           /* +29: Special placement flag */
    char player_id;         /* +30: Player index */
    char extra_flags;       /* +31: Additional flags */
    char word[2];           /* +32: Start of word (variable length) */
} Move;

/*
 * Scoring state - local variables during evaluation
 * Stack frame: 324 bytes
 */
typedef struct ScoringState {
    long accumulated_score;     /* -324: Running score product */
    long cross_word_total;      /* -320: Cross-word score sum */
    short word_mult_product;    /* -316: Word multiplier product */
    long best_score_1;          /* -314: Best position score */
    long best_score_2;          /* -310: Second best score */
    long cross_word_score;      /* -306: Single cross-word score */
    char* letter_values;        /* -302: Letter value table ptr */
    char* letter_mults;         /* -298: Letter mult table ptr */
    char* board_row_ptr;        /* -294: Current board row */
    char* score_row_ptr;        /* -290: Current score row */
    short start_offset;         /* -286: Starting board offset */
    char* word_mult_before;     /* -270: Before word mult table */
    char* word_mult_after;      /* -266: After word mult table */
    short* score_grid_ptr;      /* -262: Score grid pointer */
    short letter_counts[128];   /* -256: Available letter tracking */
    short start_position;       /* -130: Move start position */
} ScoringState;
```

### Score Calculation Algorithm (Pseudocode)

```c
/*
 * Complete scoring algorithm combining all components
 */
long calculate_complete_move_score(Move* move, char* rack, char* opp_rack) {
    /*
     * PHASE 1: Base tile scoring
     *   - Sum letter values for placed tiles
     *   - Apply letter multipliers (DL=2x, TL=3x)
     */
    long tile_score = 0;
    int word_multiplier = 1;
    int tiles_placed = 0;

    for (each tile in move->word) {
        if (board_position_empty(tile.position)) {
            /* Placing new tile */
            int letter_val = g_letter_values[tile.letter];
            int letter_mult = get_letter_multiplier(tile.position);

            tile_score += letter_val * letter_mult;
            word_multiplier *= get_word_multiplier(tile.position);
            tiles_placed++;
        } else {
            /* Using existing tile on board */
            tile_score += get_existing_tile_score(tile.position);
        }
    }

    /*
     * PHASE 2: Apply word multipliers
     *   - DW = 2x, TW = 3x
     *   - Multiple word multipliers stack multiplicatively
     */
    long word_score = tile_score * word_multiplier;

    /*
     * PHASE 3: Cross-word scoring
     *   - For each new tile placed, check perpendicular words
     *   - Each cross-word scored separately with its multipliers
     */
    long cross_word_total = 0;
    for (each new tile placed) {
        if (forms_cross_word(tile.position)) {
            cross_word_total += score_cross_word(tile.position);
        }
    }

    /*
     * PHASE 4: Bingo bonus
     *   - Using all 7 tiles from rack = +50 points (5000 centipoints)
     */
    long bingo_bonus = 0;
    if (tiles_placed == 7) {
        bingo_bonus = 5000;  /* CONFIRMED: 0x1388 in code */
    }

    /*
     * PHASE 5: Calculate raw score
     */
    long raw_score = (word_score + cross_word_total + bingo_bonus) * 100;
    /* Note: scores in centipoints for precision */

    /*
     * PHASE 6: Leave value adjustment
     *   - Look up quality of remaining rack tiles
     *   - SUBTRACT leave value (negative leave = bonus)
     */
    char remaining_rack[8];
    calculate_remaining_rack(rack, move->word, remaining_rack);

    long leave_value = lookup_leave_value(remaining_rack);  /* From MUL resource */
    long leave_adjustment = scale_leave(leave_value);

    /* Final score = raw_score - leave_adjustment */
    /* If leave is negative (good tiles like S, blank), score INCREASES */
    long final_score = raw_score - leave_adjustment;

    return final_score;
}
```

### Notes on Confidence Levels

| Component | Confidence | Notes |
|-----------|------------|-------|
| Bingo bonus (5000) | **VERY HIGH** | Explicit constant 0x1388 at offset 0x0330 |
| Tile count check (==7) | **VERY HIGH** | CMPI.W #$0007 at offset 0x0328 |
| Leave subtraction | **HIGH** | Consistent with Scrabble AI theory, JSR 90 patterns |
| Position tracking | **HIGH** | Clear global variable updates |
| Multiplier tables | **MEDIUM-HIGH** | LEA instructions with consistent offsets |
| Cross-word scoring | **MEDIUM** | Complex nested loops, some uncertainty |
| Move structure layout | **MEDIUM** | Inferred from offset usage patterns |
