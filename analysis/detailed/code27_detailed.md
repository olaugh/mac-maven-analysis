# CODE 27 Detailed Analysis - Move Candidate List Management

## Overview

| Property | Value |
|----------|-------|
| Size | 662 bytes |
| JT Offset | 2048 |
| JT Entries | 4 |
| Functions | 4 |
| Purpose | **Manage linked list of move candidates, filtering and sorting** |


## System Role

**Category**: Move Data Structures
**Function**: Move Candidate List Management

## Architecture Role

CODE 27 manages move candidate data structures:
1. Iterate over candidate list with callback
2. Evaluate and filter candidates
3. Compare candidate positions
4. Copy candidate data between structures

## Key Data Structure

Move candidate structure (at least 34 bytes):
```
+0:  next pointer (linked list)
+4:  score data
+8:  flags
+9:  row
+10: column
+11: direction
+12: word length
+13: candidate ID
+16: base score
+20: bonus score
+24: extra score
+28: flags2
+29: special flag
+30: player ID
+31: additional flags
+32: word data
```

## Key Functions

### Function 0x0000 - Iterate Candidates with Callback
```asm
0000: LINK       A6,#0
0004: MOVE.L     A4,-(A7)
0006: MOVEA.L    -2786(A5),A4         ; A4 = candidate list head
000A: BRA.S      $0018                ; Jump to test

; Loop body
000C: MOVE.L     A4,-(A7)             ; Push candidate
000E: MOVEA.L    8(A6),A0             ; Get callback
0012: JSR        (A0)                 ; Call callback(candidate)
0014: ADDQ.L     #4,A7                ; Clean stack
0016: MOVEA.L    (A4),A4              ; A4 = A4->next

; Loop test
0018: MOVE.L     A4,D0                ; Test pointer
001A: BNE.S      $000C                ; Continue if not null
001C: MOVEA.L    (A7)+,A4
001E: UNLK       A6
0020: RTS
```

**C equivalent**:
```c
void iterate_candidates(void (*callback)(Candidate* c)) {
    Candidate* c = g_candidate_head;  // A5-2786
    while (c != NULL) {
        callback(c);
        c = c->next;
    }
}
```

### Function 0x0022 - Evaluate Candidate Scores
```asm
0022: LINK       A6,#-4               ; frame=4
0026: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
002A: MOVEA.L    8(A6),A2             ; A2 = input candidate
002E: MOVEA.L    20(A6),A0
0032: CLR.W      (A0)                 ; Clear result flag
0034: MOVEQ      #0,D7                ; D7 = count

0036: JSR        2738(A5)             ; JT[2738] - setup

; Initialize best scores to large value
003A: MOVE.L     #$0BEBC200,D5        ; D5 = 200000000 (big number)
0040: MOVE.L     D5,D6                ; D6 = same
0042: LEA        -2786(A5),A4         ; A4 = &list head

; Loop through candidates
0046: BRA.W      $00EA                ; Jump to test
004A: MOVE.L     A2,-(A7)             ; Push input
004C: MOVE.L     A3,-(A7)             ; Push candidate
004E: JSR        2722(A5)             ; JT[2722] - compare
0052: TST.L      D0
0054: ADDQ.L     #8,A7
0056: BNE.W      $00E8                ; Different, skip

; Check if candidate is better
005A: TST.B      8(A3)                ; Check flag
005E: BEQ.S      $0086                ; If zero, do normal calc

; Special handling for flagged candidates
0060: MOVEA.L    A5,A0
0062: MOVE.W     30(A2),D0            ; Get player ID
0066: ADDA.W     D0,A0
0068: ADDA.W     D0,A0
006A: MOVEA.W    -13318(A0),A0        ; Get player data
006E: ADDA.L     A0,A0
0072: MOVE.L     16(A2),D0            ; Get score
0076: SUB.L      4(A3),D0             ; Subtract candidate score
007A: ADD.L      D0,D4                ; Accumulate
007C: MOVEA.L    20(A6),A0
0080: MOVE.W     #1,(A0)              ; Set found flag
0084: BRA.S      $00BC

; Normal score calculation
0086: PEA        -4(A6)               ; Local var
008A: PEA        -2(A6)               ; Local var
008E: MOVE.B     9(A3),D0             ; Get row
0092: EXT.W      D0
0094: MOVE.W     D0,-(A7)
0096: MOVE.W     30(A2),-(A7)         ; Player ID
009A: JSR        2666(A5)             ; JT[2666] - calc position
009E: MOVE.L     16(A2),D3            ; D3 = input score
00A2: SUB.L      4(A3),D3             ; Subtract
00A6: ADD.W      D0,A0
00A8: ADD.L      D3,D4                ; Accumulate
00AA: MOVEA.W    -2(A6),A0
00AE: ADD.L      A0,A4
00B2: MOVEA.W    -4(A6),A0
00B6: SUB.L      A0,A3
00B8: LEA        12(A7),A7

; Track best scores
00BC: CMP.L      D4,A6
00BE: BLE.S      $00C2
00C0: MOVE.L     D4,D6                ; Update best

00C2: CMP.L      D3,A5
00C4: BLE.S      $00C8
00C6: MOVE.L     D3,D5                ; Update best

; Check thresholds
00C8: MOVEA.L    12(A6),A0            ; Get threshold1
00CC: CMP.L      (A0),A6
00CE: BGE.S      $00E6                ; If below threshold
00D0: MOVEA.L    16(A6),A0            ; Get threshold2
00D4: CMP.L      (A0),A5
00D6: BGE.S      $00E6                ; If below threshold

; Add to result list
00D8: MOVE.L     (A3),(A4)            ; candidate->next = list->next
00DA: MOVE.L     -2786(A5),(A3)       ; candidate->next = head
00DE: MOVE.L     A3,-2786(A5)         ; head = candidate
00E2: MOVEQ      #1,D7                ; Found one
00E4: BRA.S      $00F0                ; Continue

00E6: MOVEA.L    A3,A4                ; Update prev pointer
00E8: MOVEA.L    (A4),A3              ; A3 = next candidate

; Loop test
00EA: MOVE.L     A3,D0
00EC: BNE.W      $004C                ; Continue if not null

; ... more processing ...
0140: MOVEM.L    (SP)+,...
0144: UNLK       A6
0146: RTS
```

### Function 0x0148 - Compare Two Positions
```asm
0148: LINK       A6,#0
014C: MOVEM.L    A3/A4,-(SP)
0150: MOVEA.L    8(A6),A4             ; A4 = pos1
0154: MOVEA.L    12(A6),A3            ; A3 = pos2

; Compare row
0158: MOVE.B     9(A4),D0             ; pos1.row
015C: CMP.B      9(A3),D0             ; pos2.row
0160: BNE.S      $0180                ; Different

; Compare column
0162: MOVE.B     10(A4),D0            ; pos1.col
0166: CMP.B      10(A3),D0            ; pos2.col
016A: BNE.S      $0180                ; Different

; Compare direction
016C: MOVE.B     11(A4),D0            ; pos1.dir
0170: CMP.B      11(A3),D0            ; pos2.dir
0174: BNE.S      $0180                ; Different

; Compare word length
0176: MOVE.B     12(A4),D0            ; pos1.len
017A: CMP.B      12(A3),D0            ; pos2.len
017E: BEQ.S      $0184                ; Same

0180: MOVEQ      #0,D0                ; Return false
0182: BRA.S      $0186

0184: MOVEQ      #1,D0                ; Return true

0186: MOVEM.L    (SP)+,A3/A4
018A: UNLK       A6
018C: RTS
```

**C equivalent**:
```c
int positions_equal(Candidate* c1, Candidate* c2) {
    return (c1->row == c2->row) &&
           (c1->col == c2->col) &&
           (c1->dir == c2->dir) &&
           (c1->len == c2->len);
}
```

### Function 0x018E - Copy Candidate Data
```asm
018E: LINK       A6,#0
0192: MOVEM.L    A3/A4,-(SP)
0196: MOVEA.L    8(A6),A4             ; A4 = dest
019A: MOVEA.L    12(A6),A3            ; A3 = source

; Copy selected fields
019E: MOVE.B     29(A3),8(A4)         ; flags
01A4: MOVE.L     16(A3),4(A4)         ; score
01AA: MOVE.B     32(A3),10(A4)        ; col
01B0: MOVE.B     33(A3),11(A4)        ; dir

; Get word length
01B6: MOVE.L     A3,-(A7)
01B8: JSR        3522(A5)             ; JT[3522] - strlen
01BC: MOVE.B     D0,12(A4)            ; Store length

; Copy more fields
01C0: MOVE.B     31(A3),9(A4)         ; row
01C6: MOVEM.L    (SP)+,A3/A4
01CC: UNLK       A6
01CE: RTS
```

### Function 0x01D0 - Build Candidate List
```asm
01D0: LINK       A6,#0
01D4: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
01D8: MOVE.L     8(A6),D7             ; D7 = input pointer
01DC: MOVEA.L    D7,A4
01DE: MOVEQ      #0,D6                ; D6 = count
01E0: MOVEA.L    D7,A2
01E2: LEA        3584(A2),A2          ; Skip to data area

; Clear list head
01E6: CLR.L      -2786(A5)

; Loop through entries
01EA: BRA.S      $020C

01EC: TST.B      10(A2)               ; Check if valid
01F0: BEQ.S      $020C                ; Skip if not

01F2: CMPI.W     #256,D6              ; Max 256 entries
01F6: BLT.S      $01FC
01F8: JSR        418(A5)              ; bounds_error

; Link into list
01FC: MOVE.W     D6,D0
01FE: ADDQ.W     #1,D6                ; count++
0200: MOVE.B     D0,13(A2)            ; Store ID
0204: MOVE.L     -2786(A5),(A2)       ; entry->next = head
0208: MOVE.L     A2,-2786(A5)         ; head = entry

020C: LEA        -14(A2),A2           ; Previous entry (going backwards?)
0210: CMP.L      A2,A4                ; Reached start?
0214: BCS.S      $01EC                ; Continue

; ... additional processing ...
028A: MOVE.L     -2786(A5),D0         ; Return list head
028E: MOVEM.L    (SP)+,...
0292: UNLK       A6
0294: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2786 | Candidate linked list head |
| A5-2926 | Secondary candidate array |
| A5-12540 | Counter variable |
| A5-23056 | DAWG/move data array |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | bounds_error |
| 2666 | Calculate position score |
| 2722 | Compare candidates |
| 2738 | Setup function |
| 3522 | strlen |

## Candidate Comparison

Two candidates match if they have the same:
- Row (offset 9)
- Column (offset 10)
- Direction (offset 11)
- Word length (offset 12)

## Confidence: HIGH

Clear linked list management:
- Standard linked list iteration with callback
- Position comparison for matching
- Data copying between structures
- List building with bounds checking

---

## Speculative C Translation

### Data Structures

```c
/*
 * Candidate structure - represents a potential move
 * Size: 34 bytes
 */
typedef struct Candidate {
    struct Candidate* next;  /* +0: Linked list pointer */
    long score_data;         /* +4: Primary score information */
    char flags;              /* +8: Status flags */
    char row;                /* +9: Board row (1-15) */
    char col;                /* +10: Board column (1-15) */
    char direction;          /* +11: 0=horizontal, 1=vertical */
    char word_length;        /* +12: Length of word */
    char candidate_id;       /* +13: Unique ID for this candidate */
    short reserved;          /* +14: Padding */
    long base_score;         /* +16: Score before adjustments */
    long bonus_score;        /* +20: Bonus points */
    long extra_score;        /* +24: Additional scoring info */
    char flags2;             /* +28: Secondary flags */
    char special_flag;       /* +29: Special placement indicator */
    short player_id;         /* +30: Which player (0 or 1) */
    char word_data[2];       /* +32: Start of word string (variable length) */
} Candidate;

/* Global variables */
Candidate* g_candidate_head;  /* A5-2786: Head of candidate linked list */
char* g_secondary_array;      /* A5-2926: Secondary candidate storage */
short g_candidate_counter;    /* A5-12540: Current candidate count */
```

### Function 0x0000 - Iterate Candidates with Callback

```c
/*
 * iterate_candidates - Apply callback function to each candidate
 *
 * @param callback: Function to call for each candidate
 *
 * This is a simple linked list traversal with function callback.
 * Used for operations like scoring all candidates, filtering, etc.
 */
typedef void (*CandidateCallback)(Candidate* candidate);

void iterate_candidates(CandidateCallback callback) {
    Candidate* current = g_candidate_head;  /* A5-2786 */

    while (current != NULL) {
        /* Call the callback with this candidate */
        callback(current);

        /* Move to next candidate */
        current = current->next;
    }
}
```

### Function 0x0022 - Evaluate Candidate Scores

```c
/*
 * evaluate_candidates - Score and filter candidates against input
 *
 * @param input_candidate: Reference candidate to compare against
 * @param threshold1: Score threshold for filtering (pointer)
 * @param threshold2: Secondary score threshold (pointer)
 * @param found_flag: Output flag indicating match found (pointer)
 *
 * This function:
 * 1. Iterates through all candidates
 * 2. Compares each to the input candidate
 * 3. Calculates score differentials
 * 4. Filters out candidates below thresholds
 * 5. Reorders list based on scores
 */
void evaluate_candidates(Candidate* input_candidate,
                         long* threshold1,
                         long* threshold2,
                         short* found_flag) {
    long best_score_1 = 200000000L;  /* D5: 0x0BEBC200 - large initial value */
    long best_score_2 = 200000000L;  /* D6: same */
    long accumulated_diff;           /* D4: Accumulated score difference */
    short match_count = 0;           /* D7: Number of matches found */

    *found_flag = 0;  /* Clear output flag */

    setup_evaluation();  /* JT[2738] */

    Candidate** prev_ptr = &g_candidate_head;  /* A4: Previous node's next ptr */
    Candidate* current = g_candidate_head;     /* A3: Current candidate */

    while (current != NULL) {
        /* Compare positions - are they the same move location? */
        int same_position = compare_candidates(current, input_candidate);  /* JT[2722] */

        if (!same_position) {
            /* Different position - skip to next */
            prev_ptr = &current->next;
            current = current->next;
            continue;
        }

        /* Same position - calculate score differential */
        long score_diff;

        if (current->flags != 0) {
            /* Flagged candidate - special scoring */
            /* uncertain: exact player data lookup */
            short player = input_candidate->player_id;
            void* player_data = get_player_data(player);  /* A5-13318 offset */

            score_diff = input_candidate->base_score - current->score_data;
            accumulated_diff += score_diff;
            *found_flag = 1;
        } else {
            /* Normal candidate scoring */
            short local_adj_1, local_adj_2;
            calculate_position_adjustment(
                input_candidate->player_id,
                current->row,
                &local_adj_1,
                &local_adj_2
            );  /* JT[2666] */

            score_diff = input_candidate->base_score - current->score_data;
            accumulated_diff += score_diff;
            accumulated_diff += local_adj_1;
            accumulated_diff -= local_adj_2;
        }

        /* Track best scores */
        if (accumulated_diff < best_score_2) {
            best_score_2 = accumulated_diff;
        }
        if (score_diff < best_score_1) {
            best_score_1 = score_diff;
        }

        /* Check if candidate passes thresholds */
        if (accumulated_diff >= *threshold1 || score_diff >= *threshold2) {
            /* Below threshold - remove from list */
            prev_ptr = &current->next;
            current = current->next;
            continue;
        }

        /* Passes thresholds - relink into list */
        /* uncertain: exact relinking logic */
        *prev_ptr = current->next;
        current->next = g_candidate_head;
        g_candidate_head = current;
        match_count = 1;

        current = *prev_ptr;
    }

    /* Update output thresholds with best found */
    *threshold1 = best_score_1;
    *threshold2 = best_score_2;
}
```

### Function 0x0148 - Compare Two Positions

```c
/*
 * positions_equal - Check if two candidates are at the same board position
 *
 * @param cand1: First candidate
 * @param cand2: Second candidate
 * Returns: 1 if same position, 0 if different
 *
 * Two candidates are at the "same position" if they have matching:
 *   - Row (where word starts)
 *   - Column (where word starts)
 *   - Direction (horizontal vs vertical)
 *   - Word length
 */
int positions_equal(Candidate* cand1, Candidate* cand2) {
    /* Compare row */
    if (cand1->row != cand2->row) {
        return 0;
    }

    /* Compare column */
    if (cand1->col != cand2->col) {
        return 0;
    }

    /* Compare direction */
    if (cand1->direction != cand2->direction) {
        return 0;
    }

    /* Compare word length */
    if (cand1->word_length != cand2->word_length) {
        return 0;
    }

    /* All match - same position */
    return 1;
}
```

### Function 0x018E - Copy Candidate Data

```c
/*
 * copy_candidate_data - Copy selected fields from source to destination
 *
 * @param dest: Destination candidate structure
 * @param source: Source candidate to copy from
 *
 * Note: This doesn't copy all fields - just the essential ones
 * for creating a summary or reference copy.
 */
void copy_candidate_data(Candidate* dest, Candidate* source) {
    /* Copy flags from offset 29 to offset 8 */
    dest->flags = source->special_flag;  /* +29 -> +8 */

    /* Copy base score */
    dest->score_data = source->base_score;  /* +16 -> +4 */

    /* Copy column (from word data area) */
    dest->col = source->word_data[0];  /* +32 -> +10 */

    /* Copy direction */
    dest->direction = source->word_data[1];  /* +33 -> +11 */

    /* Calculate and copy word length */
    int length = strlen((char*)source);  /* JT[3522] - uncertain: what gets strlen'd */
    dest->word_length = (char)length;

    /* Copy row (from offset 31 to 9) */
    dest->row = source->word_data[-1];  /* +31 -> +9 - uncertain indexing */
}
```

### Function 0x01D0 - Build Candidate List

```c
#define MAX_CANDIDATES 256

/*
 * build_candidate_list - Construct linked list from data array
 *
 * @param data_base: Base pointer to candidate data area
 * Returns: Pointer to head of linked list
 *
 * This function:
 * 1. Clears the global candidate list
 * 2. Iterates through a data array (going backwards)
 * 3. Links valid entries into the candidate list
 * 4. Assigns unique IDs to each candidate
 */
Candidate* build_candidate_list(void* data_base) {
    short count = 0;        /* D6: Number of candidates added */
    char* current;          /* A2: Current entry pointer */

    /* Calculate start of data area (offset 3584 from base) */
    current = (char*)data_base + 3584;

    /* Clear the list head */
    g_candidate_head = NULL;

    /* Iterate backwards through entries */
    /* uncertain: why backwards iteration? possibly for ordering */
    while (current > (char*)data_base) {
        /* Check if this entry is valid */
        if (((Candidate*)current)->col != 0) {  /* Offset 10 */
            /* Valid entry - check bounds */
            if (count >= MAX_CANDIDATES) {
                bounds_error();  /* JT[418] */
            }

            /* Assign unique ID */
            ((Candidate*)current)->candidate_id = (char)count;
            count++;

            /* Link into list (prepend) */
            ((Candidate*)current)->next = g_candidate_head;
            g_candidate_head = (Candidate*)current;
        }

        /* Move to previous entry (14 bytes back) */
        current -= 14;  /* uncertain: entry size */
    }

    /* Additional processing... */
    /* uncertain: lines 0x028A onward */

    return g_candidate_head;
}
```

### Helper Functions

```c
/*
 * calculate_total_score - Sum all score components
 */
static inline long calculate_total_score(Candidate* cand) {
    return cand->base_score + cand->bonus_score + cand->extra_score;
}

/*
 * is_candidate_better - Compare two candidates by score
 */
static inline int is_candidate_better(Candidate* new_cand, Candidate* old_cand) {
    return calculate_total_score(new_cand) > calculate_total_score(old_cand);
}

/*
 * remove_candidate - Unlink a candidate from the list
 */
void remove_candidate(Candidate* target) {
    if (g_candidate_head == target) {
        g_candidate_head = target->next;
        return;
    }

    Candidate* prev = g_candidate_head;
    while (prev != NULL && prev->next != target) {
        prev = prev->next;
    }

    if (prev != NULL) {
        prev->next = target->next;
    }
}
```

### Usage Example

```c
/*
 * Example: Find best move at each position
 *
 * During move generation, Maven:
 * 1. Builds candidate list from all valid placements
 * 2. Scores each candidate
 * 3. Filters to best candidates per position
 * 4. Returns top N moves for user/AI
 */
void find_best_moves(void) {
    /* Build initial candidate list */
    build_candidate_list(g_move_data_buffer);

    /* Score all candidates */
    iterate_candidates(score_candidate);

    /* Evaluate and filter */
    long threshold1 = MAX_SCORE;
    long threshold2 = MAX_SCORE;
    short found;

    Candidate* best = g_candidate_head;
    evaluate_candidates(best, &threshold1, &threshold2, &found);

    /* Top candidates now at front of list */
    display_top_moves(g_candidate_head, 10);
}
```
