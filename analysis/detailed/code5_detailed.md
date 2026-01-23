# CODE 5 Detailed Analysis - Game State Setup

## Overview

| Property | Value |
|----------|-------|
| Size | 204 bytes |
| JT Offset | 160 |
| JT Entries | 1 |
| Functions | 1 |
| Purpose | **Game state initialization, board setup** |


## System Role

**Category**: Core System
**Function**: Init Helper

Initialization support routines
## Architecture Role

CODE 5 contains a single large function that:
1. Validates parameters
2. Initializes board buffers (g_field_14, g_field_22)
3. Sets up game mode
4. Configures which player goes first

## Key Function

### Function 0x0000 - Initialize Game State
```asm
; From disassembly:
0000: 4E56FB80      LINK       A6,#-1152            ; Large frame (1152 bytes)
0004: 2F2E000C      MOVE.L     12(A6),-(A7)         ; Push param2
0008: 2F2E0008      MOVE.L     8(A6),-(A7)          ; Push param1
000C: 4EAD054A      JSR        1354(A5)             ; JT[1354] - validate params
0010: 4A40          TST.W      D0
0012: 508F          ADDQ.L     #8,A7                ; Clean stack
0014: 670E          BEQ.S      $0024                ; If invalid, show error
0016: 3F3C03FF      MOVE.W     #$03FF,-(A7)         ; Push error code 1023 (0x3FF)
001A: 4EAD058A      JSR        1418(A5)             ; JT[1418] - show error dialog
001E: 4A40          TST.W      D0
0020: 548F          ADDQ.L     #2,A7                ; Clean stack
0022: 6606          BNE.S      $002A                ; If OK clicked, continue
0024: 7000          MOVEQ      #0,D0                ; Return 0 (failure)
0026: 600000A0      BRA.W      $00CA                ; Jump to return

; Initialization sequence
002A: 4EAD0292      JSR        658(A5)              ; JT[658] - init_subsystem
002E: 2F2E0008      MOVE.L     8(A6),-(A7)          ; Push param1
0032: 486DC366      PEA        -15514(A5)           ; Push &g_field_14
0036: 4EAD0DA2      JSR        3490(A5)             ; JT[3490] - copy_to_global
003A: 2EAE000C      MOVE.L     12(A6),(A7)          ; Replace with param2
003E: 486DC35E      PEA        -15522(A5)           ; Push &g_field_22
0042: 4EAD0DA2      JSR        3490(A5)             ; Copy to g_field_22

0046: 4EAD0552      JSR        1362(A5)             ; JT[1362] - state_update
004A: 2B6E0010C372  MOVE.L     16(A6),-15502(A5)   ; g_size2 = param3
0050: 2B6E0014C36E  MOVE.L     20(A6),-15506(A5)   ; g_size1 = param4

0056: 4EAD04EA      JSR        1258(A5)             ; JT[1258] - post_search_init
005A: 4EAD03FA      JSR        1018(A5)             ; JT[1018] - some init

; Copy 17x17 lookup table (289 bytes = 0x121)
005E: 48780121      PEA        $0121.W              ; Push 289 (17x17)
0062: 486DD76C      PEA        -10388(A5)           ; Push g_lookup_tbl (dest)
0066: 486DD88D      PEA        -10099(A5)           ; Push source
006A: 4EAD0D8A      JSR        3466(A5)             ; JT[3466] - memcpy

; Check who goes first (param at offset 24)
006E: 4A6E0018      TST.W      24(A6)               ; param5 (computer_first)
0072: 4FEF0018      LEA        24(A7),A7            ; Clean stack
0076: 6722          BEQ.S      $009A                ; If 0, human goes first

; Computer goes first path
0078: 41EDC366      LEA        -15514(A5),A0        ; A0 = &g_field_14
007C: 2B48C376      MOVE.L     A0,-15498(A5)        ; g_current_ptr = g_field_14
0080: 486DC366      PEA        -15514(A5)           ; Push g_field_14
0084: 4EAD0962      JSR        2402(A5)             ; JT[2402] - process buffer
0088: 486DC35E      PEA        -15522(A5)           ; Push g_field_22
008C: 4EAD0962      JSR        2402(A5)             ; Process other buffer
0090: 3B7C0003DE64  MOVE.W     #$0003,-8604(A5)     ; g_game_mode = 3 (computer's turn)
0096: 508F          ADDQ.L     #8,A7                ; Clean stack
0098: 6020          BRA.S      $00BA                ; Jump to final setup

; Human goes first path
009A: 41EDC35E      LEA        -15522(A5),A0        ; A0 = &g_field_22
009E: 2B48C376      MOVE.L     A0,-15498(A5)        ; g_current_ptr = g_field_22
00A2: 486DC35E      PEA        -15522(A5)           ; Push g_field_22
00A6: 4EAD0962      JSR        2402(A5)             ; Process buffer
00AA: 486DC366      PEA        -15514(A5)           ; Push g_field_14
00AE: 4EAD0962      JSR        2402(A5)             ; Process other buffer
00B2: 3B7C0002DE64  MOVE.W     #$0002,-8604(A5)     ; g_game_mode = 2 (human's turn)
00B8: 508F          ADDQ.L     #8,A7                ; Clean stack

; Final setup
00BA: 4EAD0552      JSR        1362(A5)             ; JT[1362] - state_update
00BE: 4EAD012A      JSR        298(A5)              ; JT[298] - final init
00C2: 426DD9AE      CLR.W      -9810(A5)            ; Clear g_some_flag
00C6: 7001          MOVEQ      #1,D0                ; Return 1 (success)
00C8: 4E5E          UNLK       A6
00CA: 4E75          RTS
```

**C equivalent**:
```c
int setup_game_state(void* board1, void* board2,
                     long size2, long size1,
                     int computer_first) {
    // Validate parameters
    if (!validate_params(board1, board2)) {
        if (!show_error_dialog(0x3FF)) {
            return 0;  // User cancelled or error
        }
    }

    // Initialize subsystems
    init_subsystem();

    // Copy board data to global buffers
    copy_to_global(&g_field_14, board1);
    copy_to_global(&g_field_22, board2);

    state_update();

    // Store sizes
    g_size2 = size2;
    g_size1 = size1;

    post_search_init();
    some_init();

    // Copy 17x17 lookup table
    memcpy(&g_lookup_tbl, source, 289);

    // Set up turn order
    if (computer_first) {
        g_current_ptr = &g_field_14;
        process_buffer(&g_field_14);
        process_buffer(&g_field_22);
        g_game_mode = 3;  // Computer's turn
    } else {
        g_current_ptr = &g_field_22;
        process_buffer(&g_field_22);
        process_buffer(&g_field_14);
        g_game_mode = 2;  // Human's turn
    }

    state_update();
    final_init();
    g_some_flag = 0;  // A5-9810

    return 1;  // Success
}
```

## Global Variables Modified

| Offset | Name | Purpose |
|--------|------|---------|
| A5-15514 | g_field_14 | Hook-before board buffer |
| A5-15522 | g_field_22 | Hook-after board buffer |
| A5-15506 | g_size1 | Size of section 1 |
| A5-15502 | g_size2 | Size of section 2 |
| A5-15498 | g_current_ptr | Pointer to active buffer |
| A5-10388 | g_lookup_tbl | 17×17 lookup table |
| A5-8604 | g_game_mode | Current game state |
| A5-9810 | g_flag | Some game flag |

## Game Mode Values

| Value | Meaning |
|-------|---------|
| 0 | New game (idle) |
| 2 | Human's turn |
| 3 | Computer's turn |
| 8 | Loaded game |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 298 | Final initialization |
| 658 | init_subsystem |
| 1018 | Some initialization |
| 1258 | post_search_init |
| 1354 | Validate parameters |
| 1362 | state_update |
| 1418 | Error dialog |
| 2402 | Process board buffer |
| 3466 | memcpy |
| 3490 | copy_to_global |

## Parameter Layout

```c
int setup_game_state(
    void* board1,        // 8(A6)  - First board data
    void* board2,        // 12(A6) - Second board data
    long  size2,         // 16(A6) - Size for section 2
    long  size1,         // 20(A6) - Size for section 1
    int   computer_first // 24(A6) - Non-zero = computer first
);
```

## Confidence: HIGH

The function flow is clear:
- Parameter validation
- Board buffer initialization
- Turn order setup based on parameter
- Game mode assignment
- Standard return pattern

---

## Speculative C Translation

```c
/* CODE 5 - Speculative C Translation */
/* Game State Setup */

/*============================================================
 * Global Variables
 *============================================================*/

/* Board direction buffers - used for cross-check searches */
extern void* g_field_14;             /* A5-15514: "hook-before" buffer */
extern void* g_field_22;             /* A5-15522: "hook-after" buffer */

/* Active search direction pointer */
extern void* g_current_ptr;          /* A5-15498: points to active buffer */

/* Section sizes for DAWG navigation */
extern long g_size1;                 /* A5-15506 */
extern long g_size2;                 /* A5-15502 */

/* 17x17 position lookup table (likely bonus squares or anchors) */
extern char g_lookup_tbl[289];       /* A5-10388: 17*17 = 289 bytes */
extern char g_lookup_source[289];    /* A5-10099: source data */

/* Game state */
extern short g_game_mode;            /* A5-8604: current turn/state */
extern short g_some_flag;            /* A5-9810: game flag */

/* Game mode constants */
#define GAME_MODE_IDLE        0      /* New/no game */
#define GAME_MODE_HUMAN_TURN  2      /* Human player's turn */
#define GAME_MODE_CPU_TURN    3      /* Computer's turn */
#define GAME_MODE_LOADED      8      /* Loaded saved game */

/*============================================================
 * Function 0x0000 - Setup Game State
 * JT offset: 160(A5)
 * Frame size: 1152 bytes (used for temporary board state?)
 *============================================================*/
int setup_game_state(
    void* player1_board,             /* 8(A6)  - First player's board data */
    void* player2_board,             /* 12(A6) - Second player's board data */
    long section2_size,              /* 16(A6) - DAWG section 2 size */
    long section1_size,              /* 20(A6) - DAWG section 1 size */
    short computer_goes_first        /* 24(A6) - Non-zero if computer first */
) {
    /* Large local frame - 1152 bytes, possibly for board copy */
    char local_board_state[1152];    /* -1152(A6), 0xFB80 */

    /*
     * PHASE 1: Parameter Validation
     */

    /* Validate board pointers */
    short valid = validate_params(player1_board, player2_board);  /* JT[1354] */

    if (valid != 0) {                /* TST.W D0; BEQ.S at 0x0014 */
        /*
         * Validation failed - show error dialog with code 0x3FF (1023)
         * This could be:
         * - "Invalid board data"
         * - "Dictionary not loaded"
         * - "Memory allocation failed"
         */
        short user_choice = show_error_dialog(0x03FF);  /* JT[1418] at 0x001A */

        if (user_choice == 0) {      /* TST.W D0; BNE.S at 0x0022 */
            return 0;                 /* User cancelled - return failure */
        }
        /* User clicked OK/Continue - proceed anyway */
    }

    /*
     * PHASE 2: Subsystem Initialization
     */

    /* Initialize display, memory, and other subsystems */
    init_subsystem();                /* JT[658] at 0x002A */

    /*
     * PHASE 3: Board Buffer Setup
     *
     * Copy player board data to the two global buffers:
     * - g_field_14: Used for "hook-before" searches (left/top anchors)
     * - g_field_22: Used for "hook-after" searches (right/bottom anchors)
     */

    copy_to_global(&g_field_14, player1_board);  /* JT[3490] at 0x0036 */
    copy_to_global(&g_field_22, player2_board);  /* JT[3490] at 0x0042 */

    /* Synchronize game state after buffer setup */
    state_update();                  /* JT[1362] at 0x0046 */

    /*
     * PHASE 4: Store DAWG Section Sizes
     *
     * These sizes control DAWG navigation boundaries
     */
    g_size2 = section2_size;         /* MOVE.L 16(A6),-15502(A5) at 0x004A */
    g_size1 = section1_size;         /* MOVE.L 20(A6),-15506(A5) at 0x0050 */

    /*
     * PHASE 5: Post-Search Initialization
     */
    post_search_init();              /* JT[1258] at 0x0056 */
    some_init();                     /* JT[1018] at 0x005A */

    /*
     * PHASE 6: Copy Position Lookup Table
     *
     * 17x17 = 289 bytes, likely contains:
     * - Bonus square information (DL, TL, DW, TW)
     * - Anchor positions for word placement
     * - Valid starting positions
     */
    memcpy(g_lookup_tbl,             /* JT[3466] at 0x006A */
           g_lookup_source,           /* A5-10099 */
           289);                      /* 0x121 = 17*17 */

    /*
     * PHASE 7: Set Turn Order
     *
     * The active player's buffer is stored in g_current_ptr.
     * Process both buffers, but set state based on who goes first.
     */

    if (computer_goes_first != 0) {  /* TST.W 24(A6); BEQ.S at 0x0076 */
        /*
         * Computer goes first:
         * - g_current_ptr points to g_field_14 (computer's perspective)
         * - Process computer's buffer first
         * - Set game mode to CPU_TURN (3)
         */
        g_current_ptr = &g_field_14;     /* LEA/MOVE.L at 0x0078-0x007C */

        process_buffer(&g_field_14);      /* JT[2402] at 0x0084 */
        process_buffer(&g_field_22);      /* JT[2402] at 0x008C */

        g_game_mode = GAME_MODE_CPU_TURN; /* MOVE.W #3 at 0x0090 */
    } else {
        /*
         * Human goes first:
         * - g_current_ptr points to g_field_22 (human's perspective)
         * - Process human's buffer first
         * - Set game mode to HUMAN_TURN (2)
         */
        g_current_ptr = &g_field_22;     /* LEA/MOVE.L at 0x009A-0x009E */

        process_buffer(&g_field_22);      /* JT[2402] at 0x00A6 */
        process_buffer(&g_field_14);      /* JT[2402] at 0x00AE */

        g_game_mode = GAME_MODE_HUMAN_TURN; /* MOVE.W #2 at 0x00B2 */
    }

    /*
     * PHASE 8: Final Setup
     */

    /* Final state synchronization */
    state_update();                  /* JT[1362] at 0x00BA */

    /* Complete initialization */
    final_init();                    /* JT[298] at 0x00BE */

    /* Clear game flag (purpose uncertain - maybe "game in progress"?) */
    g_some_flag = 0;                 /* CLR.W -9810(A5) at 0x00C2 */

    return 1;                        /* Success */
}

/*============================================================
 * Analysis Notes
 *
 * Turn Order Logic:
 * The function sets up two board perspectives:
 * 1. g_field_14 - Computer/AI perspective
 * 2. g_field_22 - Human player perspective
 *
 * The g_current_ptr indicates whose turn it is.
 * Both buffers are processed regardless, but the order
 * and active pointer determine initial game state.
 *
 * 17x17 Lookup Table:
 * Standard Scrabble board is 15x15, but adding a 1-cell
 * border on each side gives 17x17, which simplifies
 * boundary checking during word validation.
 *
 * The table likely encodes:
 * - 0: Empty/normal square
 * - 1: Double Letter Score
 * - 2: Triple Letter Score
 * - 3: Double Word Score
 * - 4: Triple Word Score
 * - 5: Center star
 * - 255 or -1: Board edge (out of bounds)
 *============================================================*/
```
