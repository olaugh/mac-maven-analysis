# CODE 45 Detailed Analysis - Move Ranking and Best Move Selection

## Overview

| Property | Value |
|----------|-------|
| Size | 1122 bytes |
| JT Offset | 2752 |
| JT Entries | 4 |
| Functions | 5 |
| Purpose | **Move ranking system - maintains top 10 best moves** |

## System Role

**Category**: AI/Scoring
**Function**: Move Ranking

Ranks candidate moves by value, maintains top-10 best move lists for AI decision making.

**Related CODE resources**:
- CODE 32 (score calculation)
- CODE 43 (move generation)
- CODE 44 (move validation)

## Architecture Role

CODE 45 implements Maven's move ranking algorithm:
1. Evaluate candidate moves against score ranges
2. Maintain two parallel score tables (10 entries each)
3. Track best moves with multi-criteria ranking
4. Support tie-breaking between equivalent moves

## Critical Data Structures

### Score Tables (A5-1616 and A5-1576)
Each table holds 10 long values (40 bytes), initialized to -200,000,000 (0xF4143E00):
```c
// Score ranking tables
long g_score_table1[10];  // A5-1616 to A5-1576
long g_score_table2[10];  // A5-1576 to A5-1536
```

### Move Entry Structure (34 bytes)
```c
struct MoveEntry {
    char move_data[16];    // 0-15: Word placement data
    long main_score;       // 16-19: Primary score value
    long component_score;  // 20-23: Score component breakdown
    long bonus_score;      // 24-27: Bonus points (bingo, etc.)
    short flags;           // 28-29: Status flags (0x7F = special)
    short position;        // 30-31: Board position encoded
    char row;              // 32: Row index (0-14, 0=first move)
    char column;           // 33: Column index
};
```

## Key Functions

### Function 0x0000 - Primary Move Evaluator
**Purpose**: Evaluate a candidate move and submit for ranking

```asm
0000: LINK       A6,#-12              ; frame=12 bytes local
0004: MOVEM.L    D6/D7/A3/A4,-(SP)    ; save registers
0008: MOVEA.L    8(A6),A4             ; A4 = move candidate pointer

; Special case: Single tile on first move
000C: CMPI.W     #$0001,-20010(A5)    ; g_tile_count == 1?
0012: BNE.S      $002A                ; No - continue normal
0014: CMPI.B     #$0F,32(A4)          ; Row > 15 (invalid)?
001A: BLE.S      $002A                ; Valid row
001C: MOVE.L     A4,-(A7)
001E: JSR        2762(A5)             ; JT[2762] - validate_single_tile
0022: TST.W      D0
0026: BEQ.W      $01A6                ; Invalid - return early

; Check move flags for special handling
002A: TST.W      28(A4)               ; Move flags field
002E: BEQ.S      $0050                ; No flags - normal eval

; Flagged move - compare with current best
0030: MOVE.L     16(A4),D0            ; Get main score
0034: CMP.L      -23074(A5),D0        ; Compare with g_best_score
0038: BLE.W      $01A6                ; Not better - skip

; Update best move storage (34-byte copy)
003C: LEA        -23090(A5),A0        ; g_dawg_info destination
0040: LEA        (A4),A1              ; Source move
0042: MOVEQ      #7,D0                ; 8 longwords = 32 bytes
0044: MOVE.L     (A1)+,(A0)+          ; Copy loop
0046: DBF        D0,$0044
004A: MOVE.W     (A1)+,(A0)+          ; Plus 2 bytes = 34 total
004C: BRA.W      $01A6                ; Done

; Normal evaluation path
0050: MOVE.L     -1580(A5),-8(A6)     ; range1_low = g_score_range1
0056: MOVE.L     -1540(A5),-12(A6)    ; range2_low = g_score_range2

; Call evaluation function
005C: PEA        -4(A6)               ; &result1
0060: PEA        -2(A6)               ; &result2
0064: PEA        -12(A6)              ; &range2
0068: PEA        -8(A6)               ; &range1
006C: MOVE.L     A4,-(A7)             ; move candidate
006E: JSR        2090(A5)             ; JT[2090] - evaluate_ranges
0072: TST.W      D0
0078: BNE.W      $01A6                ; Failed evaluation

; Count entries in score table 1
007C: MOVEQ      #0,D7                ; count1 = 0
007E: LEA        -1616(A5),A3         ; A3 = g_score_table1
; ... count loop until count >= g_entry_count or score out of range

; Count entries in score table 2
0096: MOVEQ      #0,D6                ; count2 = 0
0098: LEA        -1576(A5),A3         ; A3 = g_score_table2
; ... similar count loop

; Update tables if not full (< 10 entries)
00B0: CMPI.W     #$000A,-12540(A5)    ; g_entry_count >= 10?
00BC: CMPI.W     #$000A,D7            ; count1 >= 10?
00C0: BCC.S      $00FA                ; Skip update
; ... update table 1 with new score
00EE: JSR        3466(A5)             ; JT[3466] - update_table

00FA: CMPI.W     #$000A,D6            ; count2 >= 10?
00FE: BCC.S      $0138                ; Skip update
; ... update table 2
012C: JSR        3466(A5)             ; JT[3466] - update_table

; Calculate final ranking scores
0138: TST.B      32(A4)               ; Row == 0 (first move)?
013C: BNE.S      $0172                ; No - use calculated scores
; First move uses comparison function
013E: MOVE.L     -12504(A5),-(A7)     ; g_compare1
0142: JSR        2122(A5)             ; JT[2122] - get_score
; ... calculate component scores

; Submit for ranking with negated scores (lower = better)
018E: MOVE.L     -8(A6),D0            ; range1
0192: NEG.L      D0                   ; Negate for ranking
0194: MOVE.L     D0,-(A7)
019A: NEG.L      D0                   ; range2 also negated
019C: MOVE.L     D0,-(A7)
019E: MOVE.L     A4,-(A7)             ; move
01A0: JSR        2210(A5)             ; JT[2210] - rank_move

01AA: UNLK       A6
01AC: RTS
```

**C equivalent**:
```c
void evaluate_and_rank_move(MoveEntry* move) {
    long range1_low, range2_low;
    short result1, result2;
    int count1, count2;

    // Single tile validation for opening move
    if (g_tile_count == 1 && move->row > 15) {
        if (!validate_single_tile(move)) {
            return;
        }
    }

    // Special flagged moves update best directly
    if (move->flags != 0) {
        if (move->main_score > g_best_score) {
            memcpy(&g_dawg_info, move, 34);
        }
        return;
    }

    // Normal evaluation
    range1_low = g_score_range1;
    range2_low = g_score_range2;

    if (evaluate_ranges(move, &range1_low, &range2_low,
                        &result1, &result2) != 0) {
        return;
    }

    // Count current entries in range
    count1 = count_in_range(g_score_table1, range1_low);
    count2 = count_in_range(g_score_table2, range2_low);

    // Update tables if not full
    if (g_entry_count < 10) {
        g_entry_count++;
    }
    if (count1 < 10) {
        update_score_table(g_score_table1, count1, range1_low);
    }
    if (count2 < 10) {
        update_score_table(g_score_table2, count2, range2_low);
    }

    // Calculate component scores
    if (move->row == 0) {
        // First move - use comparison scores
        int score1 = get_score(g_compare1);
        int score2 = get_score(g_compare2);
        move->component_score = score1;
        move->bonus_score = score2 - score1;
    } else {
        move->component_score = calculate_component(move->main_score);
        move->bonus_score = result2;
    }

    // Submit for ranking (negated for min-heap behavior)
    rank_move(move, -range1_low, -range2_low);
}
```

### Function 0x01AE - Simple Ranking Callback
**Purpose**: Rank a move with simplified scoring (used for quick evaluations)

```asm
01AE: LINK       A6,#0
01B2: MOVEM.L    D6/D7/A4,-(SP)
01B6: MOVEA.L    8(A6),A4             ; move
01BA: MOVE.L     12(A6),-(A7)         ; score_param
01BE: JSR        2122(A5)             ; get_score
01C6: MOVE.L     D0,D7                ; save score

; Set minimal scores
01C8: CLR.L      20(A4)               ; component = 0
01CC: MOVEQ      #1,D0
01CE: MOVE.L     D0,24(A4)            ; bonus = 1

; Rank with same score for both criteria
01D4: NEG.L      D6
01D8: MOVE.L     D6,-(A7)             ; -score twice
01DA: MOVE.L     A4,-(A7)
01DC: JSR        2210(A5)             ; rank_move

01E6: UNLK       A6
01E8: RTS
```

### Function 0x02B4 - Main Move Comparison/Ranking Entry
**Purpose**: Compare two moves and perform full ranking analysis

This is the main entry point, allocating 342 bytes for a buffer of 10 move entries:
```asm
02B4: LINK       A6,#-342             ; 10 * 34 = 340 + 2 padding
```

Key operations:
1. Quick compare two moves
2. If identical, check special conditions
3. If different, initialize score tables to -200,000,000
4. Process each differing move through primary evaluator
5. Copy best result to output

### Function 0x0426 - Search Area Initialization
**Purpose**: Initialize ranking system for new search

```asm
0426: LINK       A6,#0
042A: MOVE.L     8(A6),-(A7)
042E: JSR        2410(A5)             ; setup_search

0432: CLR.W      -12540(A5)           ; g_entry_count = 0
0436: JSR        2434(A5)             ; additional_init

; Clear buffers
043A: PEA        $0154.W              ; 340 bytes (10 moves)
043E: PEA        -23056(A5)           ; g_dawg_search_area
0442: JSR        426(A5)              ; memset

0446: PEA        $0200.W              ; 512 bytes
044A: PEA        -22698(A5)           ; results buffer
044E: JSR        426(A5)

0452: PEA        $0200.W              ; 512 bytes
0456: PEA        -12496(A5)           ; cache buffer
045A: JSR        426(A5)

045E: UNLK       A6
0460: RTS
```

## Global Variables

| Offset | Size | Purpose |
|--------|------|---------|
| A5-1540 | 4 | g_score_range2_low - Range 2 threshold |
| A5-1576 | 40 | g_score_table2 - Second score table (10 longs) |
| A5-1580 | 4 | g_score_range1_low - Range 1 threshold |
| A5-1616 | 40 | g_score_table1 - First score table (10 longs) |
| A5-12496 | 512 | Move cache buffer |
| A5-12500 | 4 | g_compare2 - Second comparison move pointer |
| A5-12504 | 4 | g_compare1 - First comparison move pointer |
| A5-12540 | 2 | g_entry_count - Current entries in tables |
| A5-19486 | 4 | g_callback_ptr - Validation callback pointer |
| A5-20010 | 2 | g_tile_count - Tiles in current move |
| A5-22698 | 512 | Results buffer |
| A5-23056 | 340 | g_dawg_search_area - Move storage (10 entries) |
| A5-23062 | 2 | g_dawg_info.flags - Best move flags |
| A5-23074 | 4 | g_best_score - Current best score |
| A5-23090 | 34 | g_dawg_info - Best move entry |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 426 | memset - clear memory |
| 2090 | Evaluate move against score ranges |
| 2122 | Get score value from context |
| 2154 | Finalize comparison |
| 2178 | Commit ranking result |
| 2210 | Rank move in priority queue |
| 2218 | Alternative handler |
| 2226 | Check evaluation condition |
| 2234 | Special case handler |
| 2242 | Completion callback |
| 2274 | Quick move comparison |
| 2322 | Process move entry |
| 2410 | Setup search context |
| 2434 | Additional initialization |
| 2698 | Detailed move comparison |
| 2762 | Validate single tile move |
| 3466 | Update score table entry |

## Algorithm Notes

### Score Table Initialization
The magic value 0xF4143E00 = -200,000,000 in decimal ensures any valid Scrabble score will be greater, making the tables effectively empty initially.

### Negated Scores for Ranking
Scores are negated before ranking because the ranking system likely uses a min-heap or sorted list where smaller values have higher priority. Negating means the highest positive score becomes the most negative, thus highest priority.

### Two-Table Design
Using two parallel score tables allows:
- Primary scoring by raw points
- Secondary scoring by strategic value (word length, position, etc.)
- Tie-breaking between moves with equal raw scores

## Confidence: HIGH

The move ranking patterns are clear:
- Well-defined 34-byte move structure
- Consistent table management with 10 entries
- Score comparison and update logic
- Standard priority-based ranking approach

---

## Speculative C Translation

### Data Structures

```c
/* Move entry structure - 34 bytes */
typedef struct MoveEntry {
    char word_tiles[16];       /* 0-15: Tiles placed on board */
    long main_score;           /* 16-19: Primary move score */
    long positional_value;     /* 20-23: Strategic/positional component */
    long bonus_points;         /* 24-27: Bingo bonus, etc. */
    short move_flags;          /* 28-29: Status flags (0x7F = special) */
    short board_position;      /* 30-31: Encoded board position */
    char row_index;            /* 32: Row (0-14, 0=center for first move) */
    char col_index;            /* 33: Column index */
} MoveEntry;

/* Global variables */
long g_score_table1[10];       /* A5-1616: Primary score ranking table */
long g_score_table2[10];       /* A5-1576: Secondary score ranking table */
long g_score_range1_low;       /* A5-1580: Range 1 threshold */
long g_score_range2_low;       /* A5-1540: Range 2 threshold */
short g_entry_count;           /* A5-12540: Current entries in tables */
long g_best_score;             /* A5-23074: Current best score found */
MoveEntry g_best_move;         /* A5-23090: Best move entry (34 bytes) */
MoveEntry g_move_buffer[10];   /* A5-23056: Move storage buffer */
char g_results_buffer[512];    /* A5-22698: Results working buffer */
char g_cache_buffer[512];      /* A5-12496: Move cache buffer */
long g_compare_move1;          /* A5-12504: First comparison pointer */
long g_compare_move2;          /* A5-12500: Second comparison pointer */
short g_tile_count;            /* A5-20010: Tiles in current move */
```

### Function 0x0000 - Primary Move Evaluator

```c
/*
 * evaluate_and_rank_move - Evaluate a candidate move and submit for ranking
 *
 * This function checks if a move should be added to the top-10 best moves list.
 * It handles special cases like first-move validation and flagged moves.
 *
 * @param candidate_move: Pointer to move entry being evaluated
 */
void evaluate_and_rank_move(MoveEntry *candidate_move) {
    long range1_threshold, range2_threshold;
    short eval_result1, eval_result2;
    int count_in_range1, count_in_range2;

    /* Special case: Single tile on opening move needs center validation */
    if (g_tile_count == 1 && candidate_move->row_index > 15) {
        /* uncertain: row > 15 might indicate off-center placement */
        if (!validate_single_tile_placement(candidate_move)) {
            return;  /* Invalid opening move */
        }
    }

    /* Handle flagged moves (pre-evaluated or special) */
    if (candidate_move->move_flags != 0) {
        /* Flagged moves bypass normal evaluation - direct comparison */
        if (candidate_move->main_score > g_best_score) {
            /* Copy 34 bytes to best move storage */
            memcpy(&g_best_move, candidate_move, 34);
        }
        return;
    }

    /* Normal evaluation path */
    range1_threshold = g_score_range1_low;
    range2_threshold = g_score_range2_low;

    /* Call range evaluation - returns 0 on success */
    if (evaluate_score_ranges(candidate_move,
                              &range1_threshold, &range2_threshold,
                              &eval_result1, &eval_result2) != 0) {
        return;  /* Move failed evaluation criteria */
    }

    /* Count how many entries already beat this score in table 1 */
    count_in_range1 = 0;
    for (int i = 0; i < g_entry_count && i < 10; i++) {
        if (range1_threshold <= g_score_table1[i]) {
            break;
        }
        count_in_range1++;
    }

    /* Count entries in table 2 */
    count_in_range2 = 0;
    for (int i = 0; i < g_entry_count && i < 10; i++) {
        if (range2_threshold <= g_score_table2[i]) {
            break;
        }
        count_in_range2++;
    }

    /* Update entry count if not full */
    if (g_entry_count < 10) {
        g_entry_count++;
    }

    /* Insert into table 1 if there's room */
    if (count_in_range1 < 10) {
        /* uncertain: exact insertion logic */
        update_score_table(g_score_table1, count_in_range1, range1_threshold);
    }

    /* Insert into table 2 if there's room */
    if (count_in_range2 < 10) {
        update_score_table(g_score_table2, count_in_range2, range2_threshold);
    }

    /* Calculate component scores based on move type */
    if (candidate_move->row_index == 0) {
        /* First move (center square) - use comparison function */
        short score1 = get_comparison_score(g_compare_move1);
        short score2 = get_comparison_score(g_compare_move2);
        candidate_move->positional_value = score1;
        candidate_move->bonus_points = score2 - score1;
    } else {
        /* Normal move - scores already calculated */
        /* uncertain: exact component calculation */
        candidate_move->positional_value = candidate_move->main_score;
        candidate_move->bonus_points = eval_result2;
    }

    /* Submit for ranking - scores negated for min-heap behavior */
    /* Lower (more negative) = better ranking priority */
    rank_move_in_list(candidate_move, -range1_threshold, -range2_threshold);
}
```

### Function 0x01AE - Simple Ranking Callback

```c
/*
 * simple_rank_move - Quick evaluation for simpler move ranking
 *
 * Used when full evaluation isn't needed - just scores and ranks.
 *
 * @param move_entry: Move to evaluate
 * @param score_context: Context for score calculation
 */
void simple_rank_move(MoveEntry *move_entry, long score_context) {
    /* Get score from context */
    short calculated_score = get_comparison_score(score_context);

    /* Set minimal component values */
    move_entry->positional_value = 0;
    move_entry->bonus_points = 1;  /* Minimal bonus to differentiate ties */

    /* Rank with same score for both criteria (no secondary sort) */
    long negated_score = -calculated_score;
    rank_move_in_list(move_entry, negated_score, negated_score);
}
```

### Function 0x02B4 - Main Move Comparison Entry Point

```c
/*
 * compare_and_rank_moves - Compare two moves and perform full ranking
 *
 * Main entry point for move comparison. Allocates buffer for 10 moves.
 *
 * @param move1: First move to compare
 * @param move2: Second move to compare
 */
void compare_and_rank_moves(MoveEntry *move1, MoveEntry *move2) {
    MoveEntry local_buffer[10];  /* 340 bytes on stack */
    short comparison_result;

    /* Quick comparison first */
    if (quick_move_compare(move1, move2, NULL) == 0) {
        /* Moves appear identical - detailed compare needed */
        comparison_result = detailed_move_compare(move1, move2, local_buffer);

        if (comparison_result == 0) {
            /* Still identical - check special conditions */
            if (check_evaluation_condition()) {
                /* Special case: identical moves, use comparison scores */
                memset(local_buffer, 0, 34);
                local_buffer[0].move_flags = 0x7F;  /* Special flag */

                short score1 = get_comparison_score(g_compare_move1);
                short score2 = get_comparison_score(g_compare_move2);
                short diff = score2 - score1;

                /* uncertain: exact score assignment */
                rank_move_in_list(&local_buffer[0], score1, score1);
            } else {
                /* Use alternate handler */
                alternate_move_handler(move1, move2);
            }
            return;
        }
    }

    /* Moves are different - full ranking analysis */
    g_compare_move1 = (long)move1;
    g_compare_move2 = (long)move2;

    /* Initialize score tables to "empty" value */
    /* 0xF4143E00 = -200,000,000 - any valid score will be greater */
    for (int i = 0; i < 10; i++) {
        g_score_table1[i] = -200000000L;
        g_score_table2[i] = -200000000L;
    }

    /* Clear best move storage */
    memset(&g_best_move, 0, 34);
    g_callback_ptr = NULL;  /* uncertain: callback purpose */

    /* Process each move in detailed comparison result */
    for (int i = 0; i < comparison_result; i++) {
        process_move_entry(&local_buffer[i]);
        evaluate_and_rank_move(&local_buffer[i]);
    }

    /* Handle special case of exactly 10 different moves */
    if (comparison_result == 10) {
        special_case_handler();
        finalize_search(2794);  /* uncertain: magic number */
    }

    /* Prepare output buffer */
    memset(local_buffer, 0, 34);
    local_buffer[0].move_flags = 0x7F;
    evaluate_and_rank_move(&local_buffer[0]);

    /* If best move was found, copy to output */
    if (g_best_move.move_flags != 0) {
        /* uncertain: which output location */
        copy_move_result(&g_best_move, move2);
    }

    /* Finalize comparison */
    finalize_comparison(move1, move2);
    commit_ranking_result(move1, move2);

    /* Verify results match inputs */
    if (g_compare_move1 != (long)move1 || g_compare_move2 != (long)move2) {
        error_handler();
    }

    completion_callback(2786);  /* uncertain: callback ID */
}
```

### Function 0x0426 - Search Area Initialization

```c
/*
 * initialize_ranking_system - Set up ranking system for new search
 *
 * Clears all buffers and counters before starting a new move search.
 *
 * @param search_context: Context/parameters for the search
 */
void initialize_ranking_system(long search_context) {
    /* Set up search context */
    setup_search_context(search_context);

    /* Reset entry counter */
    g_entry_count = 0;

    /* Additional initialization */
    additional_search_init();

    /* Clear move storage buffer - 340 bytes (10 * 34) */
    memset(g_move_buffer, 0, 340);

    /* Clear results buffer - 512 bytes */
    memset(g_results_buffer, 0, 512);

    /* Clear cache buffer - 512 bytes */
    memset(g_cache_buffer, 0, 512);
}
```

### Algorithm Notes

The move ranking system uses a dual-table approach:

1. **Score Table 1**: Primary ranking by raw point value
2. **Score Table 2**: Secondary ranking by strategic value (position, leave quality, etc.)

The magic value `-200,000,000` (0xF4143E00) initializes empty table slots. Any valid Scrabble score (typically 0-1700+) will be greater than this sentinel value.

Scores are **negated** before ranking because the system uses a priority structure where smaller values have higher priority. Negating converts "highest score = best" into "most negative = highest priority".

The `0x7F` flag in `move_flags` appears to indicate a "special" or "synthetic" move entry used for tie-breaking or placeholder purposes.
