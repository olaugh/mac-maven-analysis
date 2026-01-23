# CODE 7 Detailed Analysis - Board State Management

## Overview

| Property | Value |
|----------|-------|
| Size | 2,872 bytes |
| JT Offset | 224 |
| JT Entries | 13 |
| Functions | 21 |
| Purpose | **Board state, rack management, game state transitions** |


## System Role

**Category**: Board State
**Function**: Board Management

Manages g_state1 (letters) and g_state2 (scores) arrays

**Related CODE resources**:
- CODE 32 (uses board state)
- CODE 52 (flags)
## Architecture Role

CODE 7 manages the core game state including:
1. The two board buffers (g_field_14, g_field_22)
2. Game state structures (g_state1, g_state2)
3. State transitions (new game, load game)
4. Current buffer selection (g_current_ptr)

## Key Functions

### Function 0x0000 - Initialize/Switch to Field_14
```asm
0000: LINK       A6,#0
0004: MOVE.W     8(A6),-(A7)      ; push param
0008: JSR        1410(PC)         ; call local setup
000C: LEA        -15514(A5),A0    ; A0 = &g_field_14
0010: MOVE.L     A0,-15498(A5)    ; g_current_ptr = g_field_14
0014: TST.B      (A0)             ; test first byte
0018: BEQ.S      $001E            ; if zero...
001A: MOVEQ      #8,D0            ; D0 = 8 (loaded game mode)
001C: BRA.S      $0020
001E: MOVEQ      #0,D0            ; D0 = 0 (new game mode)
0020: MOVE.W     D0,-8604(A5)     ; g_game_mode = D0
0024: JSR        1034(A5)         ; JT[1034]
0028: JSR        1258(A5)         ; JT[1258] - post-search init
002C: JSR        1362(A5)         ; JT[1362] - state update
0030: JSR        658(A5)          ; JT[658] - init subsystem
0034: UNLK       A6
0036: RTS
```

**C equivalent**:
```c
void init_board_state(int param) {
    local_setup(param);
    g_current_ptr = &g_field_14;

    if (g_field_14[0] != 0) {
        g_game_mode = 8;  // Loaded game
    } else {
        g_game_mode = 0;  // New game
    }

    call_1034();
    post_search_init();
    state_update();
    init_subsystem();
}
```

### Function 0x0038 - Complex Game State Handler
```asm
0038: LINK       A6,#-2           ; small frame
003C: MOVEM.L    D3-D7/A2-A4,-(SP)
0040: MOVEA.L    8(A6),A3         ; A3 = param (game data ptr)
0044: MOVE.W     14(A6),D3        ; D3 = param3
0048: MOVE.W     12(A6),D0        ; D0 = param2 (action code)
004C: BEQ.S      $00C6            ; if 0, goto load
004E: BMI.W      $02E4            ; if negative, goto cleanup

; Action code > 0: Handle various states
006C: MOVEA.L    A3,A4            ; A4 = game data
006E: PEA        $0220.W          ; push 544
0072: PEA        -17154(A5)       ; push g_state1
0076: JSR        426(A5)          ; memset(g_state1, 0, 544)
007A: PEA        $0440.W          ; push 1088
007E: PEA        -16610(A5)       ; push g_state2
0082: JSR        426(A5)          ; memset(g_state2, 0, 1088)
0086: PEA        6(A4)            ; push &data->field_6
008A: PEA        -15514(A5)       ; push g_field_14
008E: JSR        3490(A5)         ; copy to g_field_14
0092: PEA        14(A4)           ; push &data->field_14
0096: PEA        -15522(A5)       ; push g_field_22
009A: JSR        3490(A5)         ; copy to g_field_22
009E: TST.W      2(A4)            ; check data->field_2
00A6: BEQ.S      $00B0
00A8: LEA        -15514(A5),A0    ; use g_field_14
00AC: MOVE.L     A0,D0
00AE: BRA.S      $00B6
00B0: LEA        -15522(A5),A0    ; use g_field_22
00B4: MOVE.L     A0,D0
00B6: MOVE.L     D0,-15498(A5)    ; g_current_ptr = selected
00BA: CLR.L      -15502(A5)       ; g_size2 = 0
00BE: CLR.L      -15506(A5)       ; g_size1 = 0
```

**Purpose**: This is the main game state transition handler:
- Action 0: Load saved game
- Action > 0: Various game actions
- Action < 0: Cleanup

### Function 0x00C6 - Load Game State
```asm
00C6: MOVEA.L    A3,A4
00C8: PEA        $0110.W          ; push 272
00CC: PEA        -17154(A5)       ; push g_state1
00D0: MOVE.L     A4,-(A7)         ; push source
00D2: JSR        1658(A5)         ; copy function
; Then set up 17x17 board grid
00D6: MOVEQ      #17,D0
00D8: MOVE.L     D0,(A7)
00DA: PEA        -17154(A5)
00DE: JSR        426(A5)          ; clear first 17 bytes
00E2: MOVEQ      #16,D4           ; outer loop: 16 rows
00E4: LEA        -16882(A5),A3    ; A3 = board data
; Nested loop copies 17x17 grid
```

**Purpose**: Load game from saved state, reconstructing the 17×17 board.

## State Structures

### g_state1 (A5-17154)
- Size: 544 bytes (0x220)
- Contains: Primary board state
- Layout: 17 × 32 = 544 (17 rows × 32 bytes each)

### g_state2 (A5-16610)
- Size: 1088 bytes (0x440)
- Contains: Extended board state
- Layout: 32 × 34 = 1088 (34-byte entries × 32)

### Board Grid
- Location: A5-16882
- Size: 17 × 17 = 289 bytes
- Contains: Tile placement data

## Buffer Selection Logic

```c
void select_buffer(GameData* data) {
    if (data->field_2 != 0) {
        g_current_ptr = &g_field_14;  // Vertical
    } else {
        g_current_ptr = &g_field_22;  // Horizontal
    }
    g_size1 = 0;  // Clear sizes initially
    g_size2 = 0;
}
```

## Game Data Structure (Offset from A4)

| Offset | Size | Purpose |
|--------|------|---------|
| 0 | 2 | Unknown |
| 2 | 2 | Direction flag (0=horiz, else=vert) |
| 6 | 8 | Field_14 data |
| 14 | 8 | Field_22 data |
| 280 | 8 | More field_14 data |
| 288 | 4 | Size 2 value |
| 292 | 4 | Size 1 value |
| 298 | 1 | Some byte |

## Global Variables

| Offset | Name | Size | Purpose |
|--------|------|------|---------|
| A5-17154 | g_state1 | 544 | Primary state buffer |
| A5-16882 | board_grid | 289 | 17×17 board |
| A5-16610 | g_state2 | 1088 | Extended state |
| A5-15522 | g_field_22 | ? | Hook-after buffer |
| A5-15514 | g_field_14 | ? | Hook-before buffer |
| A5-15506 | g_size1 | 4 | Section 1 size |
| A5-15502 | g_size2 | 4 | Section 2 size |
| A5-15498 | g_current_ptr | 4 | Active buffer |
| A5-8604 | g_game_mode | 2 | Game state |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 426(A5) | memset |
| 658(A5) | init_subsystem |
| 1034(A5) | Unknown |
| 1258(A5) | post_search_init |
| 1362(A5) | state_update |
| 1658(A5) | copy function |
| 3490(A5) | copy to global |

## Confidence: HIGH

The board management patterns are clear:
- 17×17 grid (standard Scrabble plus borders)
- Two buffer system for h/v directions
- State machine with clear transitions
- Size clearing on new game

---

## Speculative C Translation

```c
/* CODE 7 - Speculative C Translation */
/* Board State Management */

/*============================================================
 * Data Structures
 *============================================================*/

/* Primary board state - 544 bytes (17 rows * 32 bytes) */
typedef struct BoardState1 {
    char rows[17][32];               /* Letter data per row */
} BoardState1;

/* Extended board state - 1088 bytes (32 entries * 34 bytes) */
typedef struct BoardState2 {
    struct {
        char data[34];               /* 34-byte state entry */
    } entries[32];
} BoardState2;

/* Game data passed to state handler */
typedef struct GameData {
    short unknown_0;                 /* Offset 0 */
    short direction_flag;            /* Offset 2: 0=horizontal, else=vertical */
    short reserved;                  /* Offset 4 */
    long field_14_data;              /* Offset 6: data for g_field_14 */
    long field_22_data;              /* Offset 14: data for g_field_22 */
    /* ... more fields ... */
    long more_field_14[2];           /* Offset 280 */
    long size2_value;                /* Offset 288 */
    long size1_value;                /* Offset 292 */
    char some_byte;                  /* Offset 298 */
} GameData;

/*============================================================
 * Global Variables
 *============================================================*/
extern BoardState1 g_state1;         /* A5-17154: 544 bytes */
extern BoardState2 g_state2;         /* A5-16610: 1088 bytes */
extern char g_board_grid[17][17];    /* A5-16882: 289 bytes */
extern void* g_field_14;             /* A5-15514: hook-before buffer */
extern void* g_field_22;             /* A5-15522: hook-after buffer */
extern void* g_current_ptr;          /* A5-15498: active buffer pointer */
extern long g_size1;                 /* A5-15506 */
extern long g_size2;                 /* A5-15502 */
extern short g_game_mode;            /* A5-8604: current game state */

/* Game mode constants */
#define MODE_NEW_GAME     0
#define MODE_HUMAN_TURN   2
#define MODE_CPU_TURN     3
#define MODE_LOADED_GAME  8

/*============================================================
 * Function 0x0000 - Initialize Board State
 * JT offset: 224(A5)
 *============================================================*/
void init_board_state(short param /* 8(A6) */) {
    /* Call local setup routine */
    local_setup(param);              /* JSR 1410(PC) at 0x0008 */

    /* Set current buffer to field_14 (vertical direction) */
    g_current_ptr = &g_field_14;     /* LEA/MOVE.L at 0x000C-0x0010 */

    /* Determine game mode based on buffer contents */
    if (*(char*)g_current_ptr != '\0') {  /* TST.B (A0) at 0x0014 */
        /* Buffer has data - this is a loaded game */
        g_game_mode = MODE_LOADED_GAME;   /* MOVEQ #8,D0 at 0x001A */
    } else {
        /* Buffer empty - new game */
        g_game_mode = MODE_NEW_GAME;      /* MOVEQ #0,D0 at 0x001E */
    }

    /* Call initialization chain */
    call_1034();                     /* JT[1034] at 0x0024 */
    post_search_init();              /* JT[1258] at 0x0028 */
    state_update();                  /* JT[1362] at 0x002C */
    init_subsystem();                /* JT[658] at 0x0030 */
}

/*============================================================
 * Function 0x0038 - Game State Handler
 * Frame size: 2 bytes
 * Handles new game, load game, and cleanup actions
 *============================================================*/
void handle_game_state(
    GameData* data,                  /* 8(A6) -> A3 */
    short action_code,               /* 12(A6) -> D0 */
    short extra_param                /* 14(A6) -> D3 */
) {
    short local_var;                 /* -2(A6) */

    /* Dispatch based on action code */
    if (action_code == 0) {          /* BEQ.S $00C6 at 0x004C */
        /* Action 0: Load saved game */
        goto load_game;
    }
    else if (action_code < 0) {      /* BMI.W $02E4 at 0x004E */
        /* Negative action: Cleanup */
        goto cleanup;
    }

    /* Action > 0: Initialize new game state */

    /* Clear primary state buffer - 544 bytes */
    memset(&g_state1, 0, 0x0220);    /* JT[426] at 0x0076 */

    /* Clear extended state buffer - 1088 bytes */
    memset(&g_state2, 0, 0x0440);    /* JT[426] at 0x0082 */

    /* Copy board data to direction buffers */
    copy_to_global(&g_field_14, &data->field_14_data);  /* JT[3490] at 0x008E */
    copy_to_global(&g_field_22, &data->field_22_data);  /* JT[3490] at 0x009A */

    /* Select active buffer based on direction flag */
    if (data->direction_flag != 0) { /* TST.W 2(A4) at 0x009E */
        g_current_ptr = &g_field_14;  /* Vertical direction */
    } else {
        g_current_ptr = &g_field_22;  /* Horizontal direction */
    }

    /* Clear section sizes for new game */
    g_size2 = 0;                     /* CLR.L -15502(A5) at 0x00BA */
    g_size1 = 0;                     /* CLR.L -15506(A5) at 0x00BE */

    /* Continue with initialization... */
    return;

load_game:
    /* Load 272 bytes to state1 */
    copy_function(&g_state1, data, 0x0110);  /* JT[1658] at 0x00D2 */

    /* Clear first 17 bytes of state1 (border row?) */
    memset(&g_state1, 0, 17);        /* JT[426] at 0x00DE */

    /* Reconstruct 17x17 board grid */
    char *board_ptr = g_board_grid;  /* LEA -16882(A5) at 0x00E4 */

    for (int row = 0; row < 16; row++) {  /* D4 = 16 at 0x00E2 */
        for (int col = 0; col < 17; col++) {
            /* Copy tile data to board grid */
            /* ... nested loop copies board ... */
        }
    }
    return;

cleanup:
    /* Handle cleanup action */
    /* ... cleanup code at 0x02E4 ... */
    return;
}

/*============================================================
 * Board Grid Layout
 *
 * The 17x17 grid adds a 1-cell border around the 15x15 Scrabble board:
 *
 *   0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
 * 0 [border row - all empty]
 * 1 . . . . . . . . . . .  .  .  .  .  . .
 * 2 . [actual 15x15 board cells]        . .
 * ...
 * 15. . . . . . . . . . .  .  .  .  .  . .
 * 16[border row - all empty]
 *
 * This simplifies boundary checking during word validation.
 *============================================================*/

/*============================================================
 * Buffer Selection Helper
 *============================================================*/
static void select_direction_buffer(GameData* data) {
    /*
     * The direction_flag determines which buffer is active:
     * - 0: Horizontal (g_field_22) - words read left-to-right
     * - Non-zero: Vertical (g_field_14) - words read top-to-bottom
     *
     * g_current_ptr is set to point at the active buffer.
     * This affects:
     * - Move generation (which direction to search)
     * - Cross-check validation (perpendicular direction)
     * - Display rendering (highlight direction)
     */
    if (data->direction_flag != 0) {
        g_current_ptr = &g_field_14;
    } else {
        g_current_ptr = &g_field_22;
    }
}

/*============================================================
 * State Structure Details
 *
 * g_state1 (544 bytes = 17 * 32):
 * - Each row uses 32 bytes (only 17 are board squares)
 * - Extra bytes likely store cross-check or scoring data
 * - Row 0 and row 16 are border rows (unused for tiles)
 *
 * g_state2 (1088 bytes = 32 * 34):
 * - 32 entries of 34 bytes each
 * - May store move candidates or search state
 * - 34-byte size matches DAWGInfo structure
 *============================================================*/
```
