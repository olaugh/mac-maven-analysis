# CODE 29 Detailed Analysis - Word Search Coordination

## Overview

| Property | Value |
|----------|-------|
| Size | 686 bytes |
| JT Offset | 2104 |
| JT Entries | 8 |
| Functions | 7 |
| Purpose | **Coordinate word search across board, manage search callbacks** |


## System Role

**Category**: Move Generation
**Function**: Search Coordination (Horizontal/Vertical)

## Architecture Role

CODE 29 coordinates the word search process:
1. Initialize search parameters
2. Set up callbacks for different search phases
3. Process search results
4. Manage hook-before and hook-after cross-check coordination

## Key Functions

### Function 0x0000 - Initialize and Search
```asm
0000: LINK       A6,#-34              ; frame=34
0004: MOVE.L     8(A6),-(A7)          ; Push context
0008: PEA        -34(A6)              ; Local buffer
000C: JSR        2290(A5)             ; JT[2290] - init
0010: MOVE.L     20(A6),(A7)          ; Push param4
0014: MOVE.L     16(A6),-(A7)         ; Push param3
0018: MOVE.L     12(A6),-(A7)         ; Push param2
001C: PEA        -34(A6)              ; Local buffer
0020: JSR        2610(A5)             ; JT[2610] - main search
0024: UNLK       A6
0026: RTS
```

**C equivalent**:
```c
void init_and_search(Context* ctx, void* p2, void* p3, void* p4) {
    char buffer[34];
    initialize(ctx, buffer);
    main_search(buffer, p2, p3, p4);
}
```

### Function 0x0028 - Setup Horizontal Search
```asm
0028: LINK       A6,#0
002C: MOVE.L     8(A6),-12504(A5)     ; Store callback1
0032: MOVE.L     12(A6),-12500(A5)    ; Store callback2
0038: MOVE.L     12(A6),-(A7)         ; Push rack
003C: JSR        2410(A5)             ; JT[2410] - setup
0040: JSR        2434(A5)             ; JT[2434] - more setup

; Set hook-after search callback
0044: PEA        2162(A5)             ; Horizontal callback
0048: JSR        2242(A5)             ; JT[2242] - set callback
004C: UNLK       A6
004E: RTS
```

### Function 0x0050 - Process Horizontal Move
```asm
0050: LINK       A6,#0
0054: MOVE.L     A4,-(A7)
0056: MOVEA.L    8(A6),A4             ; A4 = move candidate

; Check if already processed
005A: TST.B      28(A4)               ; Processed flag
005E: BNE.S      $00C8                ; Skip if set

0060: TST.W      4(A4)                ; Check flags
0064: BNE.S      $00C8                ; Skip if set

0066: TST.B      26(A4)               ; Valid flag
006A: BEQ.S      $00C8                ; Skip if not valid

; Initialize DAWG info for this move
006C: PEA        34                   ; Size
0070: PEA        -23090(A5)           ; g_dawg_info
0074: JSR        426(A5)              ; JT[426] - clear

; Store position info
0078: MOVEA.W    2(A4),A0             ; Get position
007C: MOVE.L     A0,-23040(A5)        ; Store for search
0080: MOVEA.W    (A4),A0
0082: MOVE.L     A0,-23006(A5)        ; Store anchor

; Store direction
0086: MOVE.B     25(A4),D0            ; Direction
008A: EXT.W      D0
008C: MOVE.W     D0,-2778(A5)         ; Store direction

; Call search with callbacks
0090: MOVE.L     -12500(A5),(A7)      ; callback2
0094: PEA        2170(A5)             ; Another callback
0098: MOVE.L     -12504(A5),-(A7)     ; callback1
009C: MOVE.L     A4,-(A7)             ; Push move
009E: JSR        -160(PC)             ; Internal search

; Store results back
00A2: MOVE.W     -23038(A5),2(A4)     ; Result position
00A8: MOVE.W     -23004(A5),(A4)      ; Result anchor

; Check for extension flag
00AC: TST.W      -23062(A5)
00B0: LEA        20(A7),A7
00B4: BEQ.S      $00BC

00B6: MOVE.B     #1,29(A4)            ; Set extension flag

; Check for cross-word flag
00BC: TST.L      -23066(A5)
00C0: BEQ.S      $00C8

00C2: MOVE.B     #1,24(A4)            ; Set cross-word flag

00C8: MOVEA.L    (A7)+,A4
00CA: UNLK       A6
00CC: RTS
```

### Function 0x00CE - Evaluate Position Score
```asm
00CE: LINK       A6,#-4               ; frame=4
00D2: MOVEM.L    D6/D7/A3/A4,-(SP)
00D6: MOVEA.L    8(A6),A3             ; A3 = position data

; Set found flag
00DA: MOVEQ      #1,D0
00DC: MOVE.L     D0,-23066(A5)        ; g_found_flag = 1

; Get cross-word pointer
00E0: LEA        28(A3),A4            ; A4 = cross-word area
00E4: TST.W      (A4)                 ; Has cross-word?
00E6: BEQ.S      $0100                ; No, calculate normally

; Get score from callback
00E8: MOVE.L     -12504(A5),-(A7)     ; Push callback
00EC: JSR        2122(A5)             ; JT[2122] - get score
00F0: ADD.W      D0,A0
00F2: EXT.L      D0
00F4: ADD.L      16(A3),D0            ; Add base score
00F8: MOVE.L     D0,D6                ; D6 = score1
00FA: MOVE.L     D0,D7                ; D7 = score2
00FC: ADDQ.L     #4,A7
00FE: BRA.S      $0136

; Calculate from position
0100: PEA        -4(A6)               ; Local var
0104: PEA        -2(A6)               ; Local var
0108: MOVE.W     30(A3),-(A7)         ; Player ID
010C: MOVE.W     -2778(A5),-(A7)      ; Direction
0110: JSR        2666(A5)             ; JT[2666] - calc position

0114: MOVEA.W    D0,A0
0116: MOVE.L     16(A3),D6            ; D6 = base score
011A: SUB.L      A0,D6                ; Adjust
011C: MOVE.L     D6,D7

011E: MOVEA.W    -4(A6),A0
0122: ADD.L      A0,D7                ; Add local adjustment
0124: MOVEA.W    -2(A6),A0
0128: SUB.L      A0,D6                ; Sub local adjustment

012A: CMP.L      D7,A6                ; Check bounds
012C: LEA        12(A7),A7
0130: BLE.S      $0136

0132: JSR        418(A5)              ; bounds_error

; Update best scores
0136: CMP.L      -23040(A5),D7
013A: BLE.S      $0144

013C: MOVE.W     (A4),-23062(A5)      ; Store flag
0140: MOVE.L     D7,-23040(A5)        ; Update best1

0144: CMP.L      -23006(A5),D6
0148: BLE.S      $0152

014A: MOVE.W     (A4),-23062(A5)      ; Store flag
014E: MOVE.L     D6,-23006(A5)        ; Update best2

0152: MOVEM.L    (SP)+,D6/D7/A3/A4
0156: UNLK       A6
0158: RTS
```

### Function 0x015A - Setup Vertical Search
```asm
015A: LINK       A6,#0
015E: MOVE.L     12(A6),-12504(A5)    ; Store callback1
0164: MOVE.L     8(A6),-12500(A5)     ; Store callback2 (note: swapped!)
016A: MOVE.L     8(A6),-(A7)          ; Push rack
016E: JSR        2410(A5)             ; JT[2410] - setup
0172: JSR        2434(A5)             ; JT[2434] - more setup

; Set hook-before search callback
0176: PEA        2186(A5)             ; Vertical callback
017A: JSR        2242(A5)             ; JT[2242] - set callback
017E: UNLK       A6
0180: RTS
```

### Function 0x0182 - Process Vertical Move
```asm
0182: LINK       A6,#-10              ; frame=10
0186: MOVEM.L    D6/D7/A4,-(SP)
018A: MOVEA.L    8(A6),A4             ; A4 = move candidate

; Skip if already processed
018E: TST.B      28(A4)               ; Processed flag
0192: BNE.W      $021E

0196: TST.B      29(A4)               ; Extension flag
019A: BNE.W      $021E

019E: TST.W      4(A4)                ; Other flag
01A2: BNE.S      $021C

01A4: TST.B      26(A4)               ; Valid flag
01A8: BEQ.S      $021C                ; Skip if not valid

; Clear results array
01AA: PEA        512                  ; Size
01AE: PEA        -22698(A5)           ; Results array
01B2: JSR        426(A5)              ; JT[426] - clear

; Call search
01B6: MOVE.L     -12500(A5),(A7)      ; Push callback
01BA: PEA        2194(A5)             ; Another callback
01BE: MOVE.L     -12500(A5),-(A7)     ; Push callback again
01C2: MOVE.L     A4,-(A7)             ; Push move
01C4: JSR        -454(PC)             ; Internal search

; Determine search range based on flags
01C8: MOVE.B     24(A4),D7            ; Get flag
01CC: TST.B      D7
01CE: LEA        20(A7),A7
01D2: BEQ.S      $01D8

01D4: MOVEQ      #1,D0                ; If flag set, range = 1
01D6: BRA.S      $01DA

01D8: MOVEQ      #8,D0                ; Else range = 8

01DA: MOVE.W     D0,D6                ; D6 = min range

; Similar for max range
01DC: TST.B      D7
01DE: BEQ.S      $01E4
01E0: MOVEQ      #2,D0
01E2: BRA.S      $01E6
01E4: MOVEQ      #8,D0
01E6: MOVE.W     D0,D7                ; D7 = max range

; Extended search with range
01E8: PEA        -2776(A5)            ; Result ptr
01EC: PEA        -2774(A5)            ; Result ptr
01F0: PEA        -10(A6)              ; Local buffer
01F4: MOVE.W     D7,-(A7)             ; Max range
01F6: MOVE.W     D6,-(A7)             ; Min range
01F8: MOVE.L     -12500(A5),-(A7)     ; Callback
01FC: MOVE.L     A4,-(A7)             ; Move
01FE: JSR        2642(A5)             ; JT[2642] - extended search

; Check results
0202: MOVE.W     -8(A6),D0
0206: SUB.W      (A4),D0              ; Compare with move
020A: TST.L      -2774(A5)            ; Check result
020E: LEA        24(A7),A7
0212: BEQ.S      $021C

; Found improvement
0216: PEA        2138(A5)             ; Update callback
021A: JSR        2242(A5)             ; JT[2242]

021C: MOVEM.L    (SP)+,D6/D7/A4
0220: UNLK       A6
0222: RTS
```

### Function 0x0224 - Check Position Validity
```asm
0224: LINK       A6,#0
0228: MOVEM.L    A3/A4,-(SP)
022C: MOVEA.L    8(A6),A3             ; A3 = position
0230: LEA        8(A3),A4             ; A4 = cross-word area

; Check if within bounds
0234: MOVEA.W    (A4),A0
0236: CMP.L      -2774(A5),A0         ; Compare with limit
023C: TST.B      28(A3)               ; Check flag
0240: BNE.S      $0266

0242: TST.B      29(A3)               ; Check flag2
0246: BNE.S      $0266

0248: TST.W      4(A3)                ; Check flag3
024C: BNE.S      $0266

024E: MOVE.B     25(A3),D0            ; Get direction
0252: EXT.W      D0
0254: OR.W       -2776(A5),D0         ; OR with search dir
0258: MOVE.B     25(A3),D1
025C: EXT.W      D1
025E: CMP.W      D0,A1                ; Compare
0260: BNE.S      $0266

; Position is valid - update result
0262: MOVE.W     -2772(A5),(A4)       ; Store result

0266: MOVEM.L    (SP)+,A3/A4
026A: UNLK       A6
026C: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2772 | Search result value |
| A5-2774 | Search result ptr 1 |
| A5-2776 | Search direction |
| A5-2778 | Current direction |
| A5-12500 | Callback pointer 2 |
| A5-12504 | Callback pointer 1 |
| A5-22698 | Vertical results array |
| A5-23004 | Best score 2 |
| A5-23006 | Anchor position |
| A5-23038 | Result position |
| A5-23040 | Best score 1 |
| A5-23062 | Extension flag |
| A5-23066 | Cross-word found flag |
| A5-23090 | g_dawg_info |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | bounds_error |
| 426 | memset |
| 2122 | Get score from callback |
| 2242 | Set search callback |
| 2290 | Initialize context |
| 2410 | Setup search |
| 2434 | Additional setup |
| 2610 | Main search function |
| 2642 | Extended search |
| 2666 | Calculate position |

## Search Coordination

The module coordinates hook-before and hook-after cross-checks:
1. **Horizontal (0x0028/0x0050)**: Primary word placement
2. **Vertical (0x015A/0x0182)**: Cross-word checking
3. Both use callback system for extensibility
4. Results stored in global variables

## Confidence: HIGH

Clear search coordination patterns:
- Horizontal/vertical search setup
- Callback registration for different phases
- Score tracking with best-score updates
- Position validity checking

---

## Speculative C Translation

### Data Structures

```c
/*
 * Search context - 34 bytes
 */
typedef struct SearchContext {
    char data[34];  /* Matches g_dawg_info size */
} SearchContext;

/*
 * Move candidate structure - shared with CODE 27/28
 */
typedef struct MoveCandidate {
    struct MoveCandidate* next;  /* +0 */
    short position_data1;        /* +0 alternate interpretation */
    short position_data2;        /* +2 */
    short flags;                 /* +4 */
    char reserved[18];           /* +6 to +23 */
    char cross_word_flag;        /* +24 */
    char direction;              /* +25 */
    char valid_flag;             /* +26 */
    char reserved2;              /* +27 */
    char processed_flag;         /* +28 */
    char extension_flag;         /* +29 */
    short player_id;             /* +30 */
    short position_data3;        /* +32 or word area */
} MoveCandidate;

/* Global variables */
void (*g_callback_1)(void*);     /* A5-12504: Primary callback */
void (*g_callback_2)(void*);     /* A5-12500: Secondary callback */
short g_search_direction;        /* A5-2778: Current search direction */
short g_search_result_dir;       /* A5-2776: Result direction */
short g_search_result_val;       /* A5-2772: Result value */
long* g_result_ptr_1;            /* A5-2774: Result pointer 1 */
long g_best_score_1;             /* A5-23040: Best score tracking 1 */
long g_best_score_2;             /* A5-23006: Best score tracking 2 / anchor */
short g_extension_flag;          /* A5-23062: Extension found flag */
long g_cross_word_found;         /* A5-23066: Cross-word found flag */
char g_dawg_info[34];            /* A5-23090: DAWG search info */
char g_vertical_results[512];    /* A5-22698: Vertical search results */
```

### Function 0x0000 - Initialize and Search

```c
/*
 * init_and_search - Entry point for search initialization
 *
 * @param context: Search context pointer
 * @param param2: Secondary parameter
 * @param param3: Tertiary parameter
 * @param param4: Quaternary parameter
 */
void init_and_search(void* context, void* param2, void* param3, void* param4) {
    SearchContext local_buffer;  /* -34(A6) */

    /* Initialize the context */
    initialize_context(context, &local_buffer);  /* JT[2290] */

    /* Run main search with all parameters */
    main_search(&local_buffer, param2, param3, param4);  /* JT[2610] */
}
```

### Function 0x0028 - Setup Horizontal Search

```c
/*
 * setup_horizontal_search - Configure for horizontal word search
 *
 * @param callback1: First callback function
 * @param callback2: Second callback function
 *
 * This sets up the search to find words placed horizontally
 * (left to right). Uses "hook after" strategy.
 */
void setup_horizontal_search(void (*callback1)(void*),
                             void (*callback2)(void*)) {
    /* Store callbacks in globals */
    g_callback_1 = callback1;  /* A5-12504 */
    g_callback_2 = callback2;  /* A5-12500 */

    /* Setup search with rack */
    setup_search(callback2);  /* JT[2410] - push rack */
    additional_setup();        /* JT[2434] */

    /* Register horizontal callback (hook-after position) */
    /* 2162(A5) is the horizontal search handler address */
    set_search_callback(HORIZONTAL_CALLBACK);  /* JT[2242] */
}
```

### Function 0x0050 - Process Horizontal Move

```c
/*
 * process_horizontal_move - Score a horizontal word placement
 *
 * @param candidate: Move candidate to process
 *
 * This function:
 * 1. Validates the candidate hasn't been processed
 * 2. Initializes DAWG info for the position
 * 3. Runs the search with callbacks
 * 4. Updates candidate with results
 */
void process_horizontal_move(MoveCandidate* candidate) {
    /* Skip if already processed */
    if (candidate->processed_flag != 0) {
        return;
    }

    /* Skip if flags indicate already handled */
    if (candidate->flags != 0) {
        return;
    }

    /* Must be marked valid */
    if (candidate->valid_flag == 0) {
        return;
    }

    /* Clear DAWG info (34 bytes) */
    memset(g_dawg_info, 0, 34);  /* JT[426] */

    /* Store position info for search */
    g_best_score_1 = (long)candidate->position_data2;
    g_best_score_2 = (long)candidate->position_data1;

    /* Store direction */
    g_search_direction = (short)candidate->direction;

    /* Run internal search with both callbacks */
    internal_search(
        candidate,
        g_callback_1,
        CROSS_CHECK_CALLBACK,  /* 2170(A5) */
        g_callback_2
    );

    /* Store results back to candidate */
    candidate->position_data2 = (short)g_best_score_1;  /* A5-23038 value */
    candidate->position_data1 = (short)g_best_score_2;  /* A5-23004 value */

    /* Check if extension was found */
    if (g_extension_flag != 0) {
        candidate->extension_flag = 1;
    }

    /* Check if cross-word was found */
    if (g_cross_word_found != 0) {
        candidate->cross_word_flag = 1;
    }
}
```

### Function 0x00CE - Evaluate Position Score

```c
/*
 * evaluate_position_score - Calculate score for a word position
 *
 * @param position_data: Position information structure
 *
 * This is called during search to evaluate how good a position is.
 * Updates global best-score trackers.
 */
void evaluate_position_score(void* position_data) {
    char* pos = (char*)position_data;
    short* cross_word_ptr;       /* A4: Cross-word area pointer */
    long score_1, score_2;       /* D6, D7: Score calculations */

    /* Set found flag */
    g_cross_word_found = 1;

    /* Get cross-word area (offset 28 in structure) */
    cross_word_ptr = (short*)(pos + 28);

    /* Check if there's a cross-word to score */
    if (*cross_word_ptr != 0) {
        /* Get score from callback */
        int callback_score = get_score_from_callback(g_callback_1);  /* JT[2122] */

        /* Add to base score */
        long base_score = *(long*)(pos + 16);
        score_1 = base_score + callback_score;
        score_2 = score_1;
    } else {
        /* No cross-word - calculate from position */
        short local_adj_1, local_adj_2;
        short player_id = *(short*)(pos + 30);

        calculate_position_adjustment(
            player_id,
            g_search_direction,
            &local_adj_1,
            &local_adj_2
        );  /* JT[2666] */

        long base_score = *(long*)(pos + 16);
        score_1 = base_score - local_adj_1;
        score_2 = score_1;

        score_2 += local_adj_1;
        score_1 -= local_adj_2;

        /* Bounds check */
        if (score_2 > score_1) {
            bounds_error();  /* JT[418] */
        }
    }

    /* Update best scores if this is better */
    if (score_2 > g_best_score_1) {
        g_extension_flag = *cross_word_ptr;
        g_best_score_1 = score_2;
    }

    if (score_1 > g_best_score_2) {
        g_extension_flag = *cross_word_ptr;
        g_best_score_2 = score_1;
    }
}
```

### Function 0x015A - Setup Vertical Search

```c
/*
 * setup_vertical_search - Configure for vertical word search
 *
 * @param callback1: First callback (note: swapped from horizontal)
 * @param callback2: Second callback
 *
 * This sets up the search to find words placed vertically
 * (top to bottom). Uses "hook before" strategy.
 *
 * Note: Callback order is SWAPPED compared to horizontal search!
 */
void setup_vertical_search(void (*callback1)(void*),
                           void (*callback2)(void*)) {
    /* Store callbacks - NOTE: order is swapped! */
    g_callback_1 = callback2;  /* A5-12504 = param2 */
    g_callback_2 = callback1;  /* A5-12500 = param1 */

    /* Setup search with rack */
    setup_search(callback1);  /* JT[2410] - use first param */
    additional_setup();        /* JT[2434] */

    /* Register vertical callback (hook-before position) */
    /* 2186(A5) is the vertical search handler address */
    set_search_callback(VERTICAL_CALLBACK);  /* JT[2242] */
}
```

### Function 0x0182 - Process Vertical Move

```c
/*
 * process_vertical_move - Score a vertical word placement
 *
 * @param candidate: Move candidate to process
 *
 * This has additional complexity compared to horizontal:
 * - Clears a 512-byte results array
 * - Uses different search ranges based on flags
 * - May update the search callback if improvement found
 */
void process_vertical_move(MoveCandidate* candidate) {
    short min_range, max_range;  /* D6, D7: Search range limits */
    char local_buffer[10];       /* -10(A6): Local work buffer */

    /* Skip if processed or has extension */
    if (candidate->processed_flag != 0) {
        return;
    }
    if (candidate->extension_flag != 0) {
        return;
    }

    /* Skip if flags set or not valid */
    if (candidate->flags != 0) {
        return;
    }
    if (candidate->valid_flag == 0) {
        return;
    }

    /* Clear vertical results buffer (512 bytes) */
    memset(g_vertical_results, 0, 512);  /* JT[426] */

    /* Run internal search */
    internal_search(
        candidate,
        g_callback_2,
        VERTICAL_CHECK_CALLBACK,  /* 2194(A5) */
        g_callback_2
    );

    /* Determine search range based on cross-word flag */
    if (candidate->cross_word_flag != 0) {
        min_range = 1;
        max_range = 2;
    } else {
        min_range = 8;
        max_range = 8;
    }

    /* Extended search with range */
    extended_search(
        candidate,
        g_callback_2,
        min_range,
        max_range,
        local_buffer,
        &g_result_ptr_1,
        &g_search_result_dir
    );  /* JT[2642] */

    /* Check if improvement found */
    short result_diff = local_buffer[8] - candidate->position_data1;

    if (g_result_ptr_1 != NULL) {
        /* Found improvement - register update callback */
        set_search_callback(UPDATE_CALLBACK);  /* JT[2242], 2138(A5) */
    }
}
```

### Function 0x0224 - Check Position Validity

```c
/*
 * check_position_validity - Verify a position is valid for placement
 *
 * @param position: Position data structure
 *
 * Checks various flags and bounds to ensure the position
 * is suitable for word placement.
 */
void check_position_validity(void* position) {
    char* pos = (char*)position;
    short* result_ptr;           /* A4: Result area pointer */

    /* Get result area (offset 8) */
    result_ptr = (short*)(pos + 8);

    /* Compare with global limit */
    if (*result_ptr > g_result_ptr_1) {
        /* Exceeds limit - skip */
    }

    /* Check processed flag */
    if (pos[28] != 0) {
        return;  /* Already processed */
    }

    /* Check extension flag */
    if (pos[29] != 0) {
        return;  /* Has extension */
    }

    /* Check main flags */
    if (*(short*)(pos + 4) != 0) {
        return;  /* Flags set */
    }

    /* Check direction compatibility */
    short direction = (short)pos[25];
    short combined = direction | g_search_result_dir;

    if (combined != direction) {
        return;  /* Direction mismatch */
    }

    /* Position is valid - update result */
    *result_ptr = g_search_result_val;
}
```

### Search Callback Addresses

```c
/*
 * Callback addresses (offsets from A5)
 *
 * These are function pointers stored at fixed offsets:
 */
#define HORIZONTAL_CALLBACK    2162  /* Horizontal word handler */
#define CROSS_CHECK_CALLBACK   2170  /* Cross-word checking */
#define VERTICAL_CALLBACK      2186  /* Vertical word handler */
#define VERTICAL_CHECK_CALLBACK 2194 /* Vertical cross-check */
#define UPDATE_CALLBACK        2138  /* Update best position */
```

### Search Coordination Flow

```c
/*
 * Complete search flow for move generation:
 *
 * 1. Setup Phase:
 *    - Call setup_horizontal_search() or setup_vertical_search()
 *    - Registers appropriate callbacks
 *
 * 2. Candidate Processing:
 *    - For each anchor position on the board:
 *      a. Create MoveCandidate
 *      b. Call process_horizontal_move() or process_vertical_move()
 *      c. Callback evaluates position scores
 *
 * 3. Score Evaluation:
 *    - evaluate_position_score() is called for each valid word
 *    - Updates g_best_score_1 and g_best_score_2
 *    - Sets extension and cross-word flags
 *
 * 4. Result Collection:
 *    - Best positions tracked in global variables
 *    - Results fed to CODE 28's sorted move array
 *
 * Note: Horizontal and vertical searches are independent.
 * The board transpose (CODE 22) allows reusing horizontal
 * logic for vertical searches.
 */
void run_complete_search(char* rack, MoveCandidate* candidates, int count) {
    /* Run horizontal search */
    setup_horizontal_search(score_callback, filter_callback);
    for (int i = 0; i < count; i++) {
        process_horizontal_move(&candidates[i]);
    }

    /* Transpose board for vertical search */
    transpose_board();

    /* Run vertical search */
    setup_vertical_search(score_callback, filter_callback);
    for (int i = 0; i < count; i++) {
        process_vertical_move(&candidates[i]);
    }

    /* Transpose back */
    transpose_board();
}
```
