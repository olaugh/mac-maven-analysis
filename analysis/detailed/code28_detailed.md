# CODE 28 Detailed Analysis - Move Array Management

## Overview

| Property | Value |
|----------|-------|
| Size | 664 bytes |
| JT Offset | 2080 |
| JT Entries | 3 |
| Functions | 3 |
| Purpose | **Move array insertion, score calculation, word string handling** |


## System Role

**Category**: Move Data Structures
**Function**: Sorted Move Array Management

## Architecture Role

CODE 28 manages arrays of move candidates:
1. Insert moves into sorted array
2. Calculate word scores
3. Handle move scoring during search

## Key Data Structures

Move array entry (34 bytes each):
```
+0:   next pointer (for linked list mode)
+4:   score data
+8:   flags
+16:  base score (long)
+20:  bonus score (long)
+24:  extra score (long)
+34:  next entry
```

## Key Functions

### Function 0x0000 - Insert Move into Sorted Array
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A2/A3/A4,-(SP)    ; save
0008: MOVEA.L    8(A6),A4             ; A4 = move to insert

; Calculate total score
000C: MOVE.L     20(A4),D7            ; D7 = base score
0010: ADD.L      16(A4),D7            ; + bonus
0014: ADD.L      24(A4),D7            ; + extra

; Check array limit
0018: CMPI.W     #10,-12540(A5)       ; Max 10 entries?
001E: BNE.S      $0028

; Compare with worst score in array
0020: CMP.L      -2782(A5),D7         ; Compare with min score
0024: BLE.W      $00DE                ; If worse, don't insert

; Validate move
0028: MOVE.L     A4,-(A7)
002A: JSR        2762(A5)             ; JT[2762] - validate move
002E: TST.W      D0
0030: ADDQ.L     #4,A7
0032: BEQ.W      $00DE                ; Invalid, skip

; Find insertion point (array already has entries)
0036: CMPI.W     #10,-12540(A5)
003C: BNE.S      $005A                ; Not full, different path

; Find position in sorted array
003E: LEA        -23056(A5),A3        ; A3 = array base
0042: BRA.S      $0048

0044: LEA        34(A3),A3            ; A3 += 34 (next entry)

; Compare scores
0048: MOVE.L     16(A3),D0            ; Entry base score
004C: ADD.L      20(A3),D0            ; + bonus
0050: ADD.L      24(A3),D0            ; + extra
0054: CMP.L      D7,D0                ; Compare with new score
0056: BGE.S      $0044                ; Continue if entry >= new
0058: BRA.S      $008A                ; Found position

; Not at limit - find position differently
005A: LEA        -23056(A5),A3        ; A3 = array base
005E: MOVEQ      #34,D0               ; Entry size
0060: MULS.W     -12540(A5),D0        ; * count
0064: LEA        -23056(A5),A2
0068: ADDA.L     D0,A2                ; A2 = end of used entries
006A: BRA.S      $0072

006E: LEA        34(A3),A3            ; Next entry

; Compare and find position
0072: CMP.L      A3,A2                ; Reached end?
0076: MOVE.L     16(A3),D0
007A: ADD.L      20(A3),D0
007E: ADD.L      24(A3),D0
0082: CMP.L      D7,D0
0084: BGE.S      $006E
0086: ADDQ.W     #1,-12540(A5)        ; Increment count

; Shift entries to make room
008A: PEA        34                   ; Entry size
008E: PEA        34
0092: LEA        -23056(A5),A0
0096: MOVE.L     A3,D0
0098: SUB.L      A0,D0                ; Offset of insertion point
009A: MOVE.L     D0,-(A7)
009C: JSR        90(A5)               ; JT[90] - divide

; Calculate entries to shift
00A0: MOVEA.W    -12540(A5),A0        ; Current count
00A4: SUBQ.W     #1,A0
00A6: SUB.L      D0,A0
00A8: MOVE.L     A0,-(A7)
00AA: JSR        66(A5)               ; JT[66] - multiply
00AE: MOVE.L     D0,-(A7)
00B0: MOVE.L     A3,-(A7)
00B2: PEA        34(A3)               ; Destination
00B6: JSR        3466(A5)             ; JT[3466] - memmove

; Copy new entry into position
00BA: LEA        (A3),A0              ; Dest
00BC: LEA        (A4),A1              ; Source
00BE: MOVEQ      #7,D0                ; 8 longs = 32 bytes
00C0: MOVE.L     (A1)+,(A0)+          ; Copy loop
00C2: DBF        D0,$00C0
00C6: MOVE.W     (A1)+,(A0)+          ; Plus 2 more bytes

; Update minimum score tracker
00C8: LEA        -22750(A5),A3        ; Last entry in array
00CC: MOVE.L     16(A3),D0
00D0: ADD.L      20(A3),D0
00D4: ADD.L      24(A3),D0
00D8: MOVE.L     D0,-2782(A5)         ; Store as min score

00DC: MOVEM.L    (SP)+,...
00E2: UNLK       A6
00E4: RTS
```

**C equivalent**:
```c
void insert_move(Move* new_move) {
    long score = new_move->base + new_move->bonus + new_move->extra;

    // Check if array is full and score is too low
    if (g_move_count >= 10 && score <= g_min_score) {
        return;
    }

    // Validate move
    if (!validate_move(new_move)) {
        return;
    }

    // Find insertion point (sorted descending by score)
    Move* pos = g_move_array;
    while (pos->score >= score && pos < end_of_array) {
        pos++;
    }

    // Shift entries down
    memmove(pos + 1, pos, remaining_entries * 34);

    // Copy new entry
    memcpy(pos, new_move, 34);

    // Update minimum score
    g_min_score = g_move_array[g_move_count - 1].score;
}
```

### Function 0x00E6 - Calculate Word Score
```asm
00E6: LINK       A6,#0
00EA: MOVEM.L    D6/D7,-(SP)
00EE: MOVEQ      #0,D7                ; D7 = total score
00F0: BRA.S      $0100

; Sum letter values
00F2: MOVE.B     D6,D0                ; Get letter
00F4: EXT.W      D0
00F6: MOVEA.L    A5,A0
00F8: ADDA.W     D0,A0
00FA: ADDA.W     D0,A0
00FC: ADD.W      -27630(A0),D7        ; Add letter value

; Get next letter
0100: MOVEA.L    8(A6),A0             ; String pointer
0104: ADDQ.L     #1,8(A6)             ; Advance
0108: MOVE.B     (A0),D6              ; Get char
010A: BNE.S      $00F2                ; Continue if not null

010C: MOVE.W     D7,D0                ; Return total
010E: MOVEM.L    (SP)+,D6/D7
0112: UNLK       A6
0114: RTS
```

**C equivalent**:
```c
int calculate_word_score(char* word) {
    int total = 0;
    while (*word) {
        total += g_letter_values[(unsigned char)*word * 2];
        word++;
    }
    return total;
}
```

### Function 0x0116 - Process Move Search
```asm
0116: LINK       A6,#-528             ; Large stack frame
011A: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
011E: MOVEA.L    8(A6),A4             ; A4 = search context
0122: MOVEA.L    12(A6),A3            ; A3 = callback

; Initialize
0126: MOVE.L     A4,-(A7)
0128: JSR        2410(A5)             ; JT[2410] - setup

012C: PEA        -132(A6)
0130: JSR        2394(A5)             ; JT[2394]
0134: MOVE.B     D0,D4                ; D4 = some count

0136: JSR        2458(A5)             ; JT[2458]

; Clear move array
013A: PEA        340                  ; 10 * 34 bytes
013E: PEA        -23056(A5)           ; g_dawg_?
0142: JSR        426(A5)              ; JT[426] - memset

; Clear local buffer
0146: MOVEQ      #34,D0
0148: MOVE.L     D0,(A7)
014A: PEA        -182(A6)
014E: JSR        426(A5)              ; memset

; Initialize counters
0152: CLR.W      -12540(A5)           ; Move count = 0
0156: CLR.W      -20010(A5)           ; Another counter

; Set sentinel value
015A: MOVE.L     #$F4143E00,-23040(A5)  ; Marker value

; Run search
0162: JSR        2354(A5)             ; JT[2354] - start search
0166: TST.W      D0
0168: LEA        20(A7),A7
016C: BEQ.S      $0178                ; If search found nothing

; Process result
016E: MOVE.L     A3,-(A7)             ; Push callback
0170: JSR        2490(A5)             ; JT[2490]
0174: ADDQ.L     #4,A7
0176: BRA.S      $01BE

; Alternative search
0178: JSR        2362(A5)             ; JT[2362]
017C: TST.W      D0
017E: BEQ.S      $01BE                ; Nothing found

; Check which field to use
0180: LEA        -15514(A5),A0        ; g_field_14
0184: CMP.L      A4,A0
0188: LEA        -15522(A5),A0        ; g_field_22
018C: MOVE.L     A0,D0
018E: BRA.S      $0196

0190: LEA        -15514(A5),A0        ; g_field_14
0194: MOVE.L     A0,D0

; Calculate word score
0196: MOVE.L     D0,-(A7)
0198: JSR        -180(PC)             ; calculate_word_score
019C: NEG.W      D0                   ; Negate
019E: MOVE.W     D0,-528(A6)

01A2: MOVE.L     A4,(A7)
01A4: JSR        -192(PC)             ; calculate_word_score
01A8: ADD.W      D0,A0
01AA: MOVE.W     -528(A6),D1
01AE: SUB.W      D0,A1
01B0: MOVEA.W    D1,A0
01B2: MOVE.L     A0,-162(A6)          ; Store difference

01B6: PEA        -182(A6)             ; Local buffer
01BA: JSR        (A3)                 ; Call callback
01BC: ADDQ.L     #4,A7

; Cleanup
01BE: MOVE.L     A3,-(A7)
01C0: JSR        2618(A5)             ; JT[2618] - cleanup

; Check sentinel
01C4: CMPI.L     #$F4143E00,-23040(A5)
01CC: ADDQ.L     #4,A7
01CE: BNE.S      $01D8

01D0: CLR.L      -23040(A5)           ; Clear sentinel
01D4: BRA.W      $0292                ; Exit

; Continue processing if more to do...
01D8: CMPI.B     #17,D4
01DC: BCS.W      $0292                ; If < 17, exit

; ... additional processing for each position ...
028A: BGT.W      $0208
0290: MOVEM.L    (SP)+,...
0294: UNLK       A6
0296: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2782 | Minimum score in array |
| A5-12540 | Move count |
| A5-15514 | g_field_14 (word field) |
| A5-15522 | g_field_22 (another field) |
| A5-20010 | Secondary counter |
| A5-22750 | Last entry in array |
| A5-23040 | Sentinel/marker value |
| A5-23056 | Move array base |
| A5-27630 | Letter value table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | multiply |
| 90 | divide |
| 426 | memset |
| 2354 | Start search |
| 2362 | Alternative search |
| 2394 | Get count |
| 2410 | Setup |
| 2458 | Another setup |
| 2490 | Process result |
| 2618 | Cleanup |
| 2762 | Validate move |
| 3466 | memmove |

## Move Array Layout

The array at A5-23056 holds up to 10 moves (340 bytes total):
- Sorted by score (highest first)
- Insertion maintains sort order
- Worst move tracked at A5-2782 for fast rejection

## Confidence: HIGH

Clear array management patterns:
- Sorted insertion with shift
- Score calculation from letter values
- Sentinel value for search state
- Standard search/callback pattern

---

## Speculative C Translation

### Data Structures

```c
/*
 * Move structure - stored in sorted array
 * Size: 34 bytes per entry
 */
typedef struct Move {
    struct Move* next;      /* +0: Linked list pointer (unused in array mode) */
    long score_data;        /* +4: Combined score info */
    char flags;             /* +8: Move flags */
    char row;               /* +9: Starting row */
    char col;               /* +10: Starting column */
    char direction;         /* +11: 0=horizontal, 1=vertical */
    char length;            /* +12: Word length */
    char id;                /* +13: Move ID */
    short reserved;         /* +14: Padding */
    long base_score;        /* +16: Base tile score */
    long bonus_score;       /* +20: Bonus points (bingo, etc.) */
    long extra_score;       /* +24: Cross-word score */
    char flags2;            /* +28: Secondary flags */
    char special;           /* +29: Special placement flag */
    short player_id;        /* +30: Player index */
    char word[2];           /* +32: Word data (variable length) */
} Move;

#define MOVE_SIZE       34
#define MAX_MOVES       10
#define ARRAY_SIZE      (MAX_MOVES * MOVE_SIZE)  /* 340 bytes */

/* Global variables */
Move g_move_array[MAX_MOVES];   /* A5-23056: Sorted move array */
long g_min_score;               /* A5-2782: Minimum score in array */
short g_move_count;             /* A5-12540: Current number of moves */
char g_current_word[32];        /* A5-15514: g_field_14 */
char g_cross_word[32];          /* A5-15522: g_field_22 */
long g_sentinel_marker;         /* A5-23040: Search state sentinel */
short g_secondary_counter;      /* A5-20010: Secondary counter */
short g_letter_values[128];     /* A5-27630: Letter point values */
```

### Function 0x0000 - Insert Move into Sorted Array

```c
/*
 * insert_move_sorted - Insert a move into the sorted best-moves array
 *
 * @param new_move: Move to insert
 *
 * The array is sorted by total score (descending).
 * If array is full (10 moves), worst move is discarded.
 * Only valid moves that beat the minimum score are kept.
 */
void insert_move_sorted(Move* new_move) {
    /* Calculate total score for the new move */
    long new_score = new_move->base_score +
                     new_move->bonus_score +
                     new_move->extra_score;

    /* Quick rejection: array full and new score isn't better than worst */
    if (g_move_count >= MAX_MOVES) {
        if (new_score <= g_min_score) {
            return;  /* Don't bother - won't make the cut */
        }
    }

    /* Validate the move (check if legal placement) */
    if (!validate_move(new_move)) {  /* JT[2762] */
        return;  /* Invalid move */
    }

    /* Find insertion position in sorted array */
    Move* insert_pos;

    if (g_move_count >= MAX_MOVES) {
        /* Array full - find where new move fits by score */
        insert_pos = g_move_array;

        while (insert_pos < &g_move_array[MAX_MOVES]) {
            long entry_score = insert_pos->base_score +
                               insert_pos->bonus_score +
                               insert_pos->extra_score;

            if (entry_score < new_score) {
                break;  /* Found insertion point */
            }
            insert_pos++;
        }
    } else {
        /* Array not full - find position and increment count */
        insert_pos = g_move_array;
        Move* end_of_used = &g_move_array[g_move_count];

        while (insert_pos < end_of_used) {
            long entry_score = insert_pos->base_score +
                               insert_pos->bonus_score +
                               insert_pos->extra_score;

            if (entry_score < new_score) {
                break;  /* Found insertion point */
            }
            insert_pos++;
        }

        g_move_count++;  /* Increment move count */
    }

    /* Calculate how many entries need to shift */
    int entries_to_shift = (&g_move_array[g_move_count - 1]) - insert_pos;

    /* Shift entries down to make room */
    if (entries_to_shift > 0) {
        memmove(insert_pos + 1, insert_pos,
                entries_to_shift * MOVE_SIZE);  /* JT[3466] */
    }

    /* Copy new move into position */
    memcpy(insert_pos, new_move, MOVE_SIZE);

    /* Update minimum score tracker (last entry in array) */
    Move* last_entry = &g_move_array[g_move_count - 1];
    g_min_score = last_entry->base_score +
                  last_entry->bonus_score +
                  last_entry->extra_score;
}
```

### Function 0x00E6 - Calculate Word Score

```c
/*
 * calculate_word_score - Sum letter values for a word string
 *
 * @param word: Null-terminated word string
 * Returns: Total point value of all letters
 *
 * This calculates the raw letter score without multipliers.
 * Used for comparing moves and validating scores.
 */
int calculate_word_score(char* word) {
    int total_score = 0;    /* D7: Accumulated score */
    char letter;            /* D6: Current letter */

    while ((letter = *word++) != '\0') {
        /* Look up letter value in table */
        /* Table is at A5-27630, indexed by letter * 2 (word-sized entries) */
        unsigned char letter_idx = (unsigned char)letter;
        int letter_value = g_letter_values[letter_idx];

        total_score += letter_value;
    }

    return total_score;
}
```

### Function 0x0116 - Process Move Search

```c
#define SENTINEL_VALUE  0xF4143E00L  /* -200000000 decimal */

/*
 * process_move_search - Coordinate move generation search
 *
 * @param search_context: Context for the search
 * @param result_callback: Function to call with results
 *
 * This is the main entry point for finding valid moves.
 * It:
 * 1. Initializes search state
 * 2. Clears the move array
 * 3. Runs primary search
 * 4. Falls back to alternate search if needed
 * 5. Calculates score differentials
 */
void process_move_search(void* search_context,
                         void (*result_callback)(Move*)) {
    char local_buffer[132];     /* -132(A6): Local work buffer */
    Move local_move;            /* -182(A6): Local move structure */
    short search_count;         /* D4: Number of positions searched */
    short score_diff;           /* -528(A6): Score differential */

    /* Initialize search */
    setup_search(search_context);  /* JT[2410] */

    search_count = get_search_count(&local_buffer);  /* JT[2394] */

    additional_setup();  /* JT[2458] */

    /* Clear the move array (10 entries * 34 bytes = 340 bytes) */
    memset(g_move_array, 0, ARRAY_SIZE);  /* JT[426] */

    /* Clear local move buffer */
    memset(&local_move, 0, MOVE_SIZE);  /* JT[426] */

    /* Reset counters */
    g_move_count = 0;
    g_secondary_counter = 0;

    /* Set sentinel marker for search state */
    g_sentinel_marker = SENTINEL_VALUE;

    /* Run primary search */
    int found = run_primary_search();  /* JT[2354] */

    if (found) {
        /* Primary search found results - process them */
        process_search_results(result_callback);  /* JT[2490] */
    } else {
        /* Try alternate search method */
        found = run_alternate_search();  /* JT[2362] */

        if (found) {
            /* Calculate score differential between fields */
            char* field_to_use;

            if (search_context == g_current_word) {
                field_to_use = g_cross_word;  /* A5-15522 */
            } else {
                field_to_use = g_current_word;  /* A5-15514 */
            }

            /* Calculate word scores */
            int field_score = calculate_word_score(field_to_use);
            score_diff = -field_score;  /* Negate */

            int context_score = calculate_word_score(search_context);
            score_diff += context_score;

            /* Store differential in local move */
            local_move.base_score = score_diff;

            /* Call callback with result */
            result_callback(&local_move);
        }
    }

    /* Cleanup */
    cleanup_search(result_callback);  /* JT[2618] */

    /* Verify sentinel (detect memory corruption) */
    if (g_sentinel_marker != SENTINEL_VALUE) {
        /* Sentinel corrupted - clear and return */
        g_sentinel_marker = 0;
        return;
    }

    g_sentinel_marker = 0;

    /* Extended search for positions >= 17 */
    if (search_count >= 17) {
        /* Continue with extended position search... */
        /* uncertain: additional 150 lines of processing */
    }
}
```

### Helper Functions

```c
/*
 * get_move_at_rank - Get the Nth best move from array
 *
 * @param rank: 0 = best, 1 = second best, etc.
 * Returns: Pointer to move, or NULL if rank > count
 */
Move* get_move_at_rank(int rank) {
    if (rank < 0 || rank >= g_move_count) {
        return NULL;
    }
    return &g_move_array[rank];
}

/*
 * clear_move_array - Reset the move array to empty
 */
void clear_move_array(void) {
    memset(g_move_array, 0, ARRAY_SIZE);
    g_move_count = 0;
    g_min_score = 0x7FFFFFFF;  /* Max positive value */
}

/*
 * dump_top_moves - Debug output of best moves
 */
void dump_top_moves(short file_handle) {
    char buffer[80];

    for (int i = 0; i < g_move_count; i++) {
        Move* m = &g_move_array[i];
        long total = m->base_score + m->bonus_score + m->extra_score;

        sprintf(buffer, "%d. Score: %ld  Pos: (%d,%d) Dir: %s\r",
                i + 1,
                total / 100,  /* Convert centipoints to points */
                m->row, m->col,
                m->direction ? "V" : "H");

        write_string_to_file(file_handle, buffer);
    }
}
```

### Usage Flow

```c
/*
 * Typical move generation flow:
 *
 * 1. User plays tiles / AI thinking
 * 2. process_move_search() is called
 * 3. For each valid word found:
 *    a. Create Move structure with position and word
 *    b. Call CODE 32 to calculate full score with leave values
 *    c. Call insert_move_sorted() to add to best list
 * 4. After search completes:
 *    a. g_move_array contains top 10 moves, sorted
 *    b. g_move_array[0] is the best move
 *    c. AI plays best move or shows user the options
 */
void generate_and_rank_moves(char* rack) {
    /* Clear previous results */
    clear_move_array();

    /* Run move generation */
    process_move_search(g_current_word, score_and_insert_callback);

    /* Best move is now at g_move_array[0] */
    if (g_move_count > 0) {
        Move* best = &g_move_array[0];
        printf("Best move: %s at (%d,%d) for %ld points\n",
               best->word,
               best->row, best->col,
               (best->base_score + best->bonus_score + best->extra_score) / 100);
    } else {
        printf("No valid moves found\n");
    }
}
```
