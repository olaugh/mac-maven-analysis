# CODE 50 Detailed Analysis - Move History and Notation

## Overview

| Property | Value |
|----------|-------|
| Size | 1174 bytes |
| JT Offset | 3544 |
| JT Entries | 1 |
| Functions | 1 (large) |
| Purpose | **Format move notation for history display** |


## System Role

**Category**: Game State
**Function**: History Formatting

Formats game moves for history display using standard Scrabble notation.

**Related CODE resources**:
- CODE 35 (FP statistics)
- CODE 15 (MUL resources)

## Architecture Role

CODE 50 formats game moves for display:
1. Generate standard move notation
2. Format scores and timing
3. Create history list entries
4. Handle special move indicators (bingo, exchange, pass)

## Mac Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| A9EB | Pack7/SANE | Floating-point operations |
| A9A0 | GetScrap | Get scrap data (clipboard) |
| A9AB | AddResource | Add resource to file |
| A9AA | WriteResource | Write resource data |
| A9AF | ReleaseResource | Release resource |
| A999 | ChangedResource | Mark resource as changed |
| A994 | GetResInfo | Get resource info |
| A122 | NewHandle | Allocate new handle |

## Key Function

### Function 0x0000 - Format Move History Entry
```asm
; Entry - frame=66 bytes of local storage
0000: LINK       A6,#-66
0004: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVE.L     8(A6),D6             ; D6 = move index
000C: MOVE.L     12(A6),D5            ; D5 = player (0 or 1)

; Get game state handle
0010: MOVE.L     -8584(A5),-(A7)      ; g_game_state
0014: JSR        1514(A5)             ; JT[1514] - HLock
0018: MOVEA.L    D0,A4                ; A4 = locked state ptr

; Get field from state at offset 770
001A: MOVEA.L    -8584(A5),A0
001E: MOVEA.L    (A0),A0
0020: MOVE.W     770(A0),D0           ; Get move count or index

; Format player scores
002A: ... (format score to g_score_buffer1)
0030: JSR        842(A5)              ; JT[842] - format score
0034: MOVEA.L    -8584(A5),A0
...
004A: JSR        842(A5)              ; JT[842] - format score 2

; Find or create HIST resource
0062: MOVE.L     #$48495354,-(A7)     ; 'HIST' type
0068: CLR.W      -(A7)                ; ID 0
006A: A9A0                            ; _GetScrap
...
0074: BNE.S      $0090                ; Found existing

; Create new history handle
0076: MOVEQ      #0,D0
0078: A122                            ; _NewHandle (size 0)
007A: MOVEA.L    A0,A3
...

; Add to resource file
0080: MOVE.L     A3,-(A7)             ; Handle
0082: MOVE.L     #$48495354,-(A7)     ; 'HIST'
0088: CLR.W      -(A7)                ; ID 0
008A: MOVE.L     -3512(A5),-(A7)      ; g_res_file refnum
008E: A9AB                            ; _AddResource

; Lock handle for writing
009C: CLR.L      -(A7)
009E: MOVE.L     A3,-(A7)
00A0: JSR        2826(A5)             ; JT[2826] - HLock

; Resize for 8 more bytes
00A8: PEA        $0008.W              ; 8 bytes per entry
00AC: MOVE.L     A3,-(A7)
00AE: JSR        1482(A5)             ; JT[1482] - SetHandleSize

; Format move number
00D4: PEA        $0064.W              ; max 100
00D8: MOVE.L     D6,-(A7)             ; move index
00DA: JSR        90(A5)               ; JT[90] - NumToString

; Format player number
00E4: PEA        $0064.W
00E8: MOVE.L     D5,-(A7)             ; player
00EA: JSR        90(A5)               ; JT[90]

; Get move data from state at offset 770
00F4: MOVEA.L    -8584(A5),A0
00F8: MOVEA.L    (A0),A0
00FA: MOVE.W     770(A0),D0

; Copy 10-byte move entry (4+4+2 bytes)
0144: LEA        0(A4,D0.L),A1        ; Source
0146: MOVE.L     (A1)+,(A0)+          ; 4 bytes
0148: MOVE.L     (A1)+,(A0)+          ; 4 bytes
014A: MOVE.W     (A1)+,(A0)+          ; 2 bytes

; Multiple SANE (A9EB) calls for formatting
0162: PEA        -24180(A0)           ; Source buffer
0166: PEA        -36(A6)              ; Dest buffer
016A: MOVE.W     #$200E,-(A7)         ; SANE operation
016E: A9EB                            ; _Pack7 (SANE)
...

; Check for game over
02FE: TST.W      768(A4)              ; g_game_over flag
0302: BEQ.S      $0338                ; Not over

; Compare final scores
0304: MOVEA.L    -8584(A5),A0
...
032E: MOVE.W     D1,-(A7)
0330: CLR.L      -(A7)
0332: JSR        634(A5)              ; JT[634] - format result

; Final cleanup
046E: JSR        810(A5)              ; JT[810] - HUnlock
0472: MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4
0476: UNLK       A6
0478: RTS
```

## Local Variables (Stack Frame)

| Offset | Size | Purpose |
|--------|------|---------|
| -2(A6) | 2 | Temp word |
| -8(A6) | 4 | Temp long |
| -10(A6) | 10 | Extended precision buffer |
| -36(A6) | 10 | Extended precision buffer 2 |
| -46(A6) | 10 | Extended precision buffer 3 |
| -48(A6) | 2 | Score differential |
| -56(A6) | 10 | Extended precision buffer 4 |
| -66(A6) | 10 | Extended precision buffer 5 |

## SANE Operations Used

| Code | Operation |
|------|-----------|
| 0x0002 | FX2I - Extended to Integer |
| 0x0006 | FI2X - Integer to Extended |
| 0x0008 | FL2X - Long to Extended |
| 0x000D | FX2S - Extended to String |
| 0x0016 | FSUBX - Subtract Extended |
| 0x1004 | FCPXX - Compare Extended |
| 0x100E | FSUB with mode |
| 0x200E | FADD with mode |
| 0x2002 | FX2I variant |
| 0x2004 | FI2X variant |
| 0x2008 | FL2X variant |
| 0x2010 | FADDX variant |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3512 | g_res_file - Resource file reference |
| A5-8504 | g_score_buffer1 - Score format buffer |
| A5-8584 | g_game_state - Game state handle |
| A5-23312 | g_score_buffer2 - Second score buffer |

## Game State Structure (partial)

| Offset | Type | Purpose |
|--------|------|---------|
| 768 | Word | Game over flag |
| 770 | Word | Move count or current index |
| 770+N*10 | 10 bytes | Move entry N |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 90 | NumToString wrapper |
| 418 | Error handler |
| 634 | Format result string |
| 810 | HUnlock |
| 842 | Format score |
| 1482 | SetHandleSize |
| 1514 | HLock |
| 2826 | HLock (alternate entry) |

## Resource Types

| Code | ASCII | Purpose |
|------|-------|---------|
| 0x48495354 | 'HIST' | History entries |

## Move Notation Format

Standard Scrabble notation:
- Move number: "1. "
- Word played: "QUARTZ"
- Position: "H8" (horizontal) or "8H" (vertical)
- Score: "+92"
- Bingo indicator: "*" for 7-tile bonus
- Exchange: "(exchange)"
- Pass: "(pass)"
- Game end: "WIN" or "LOSS by N"

## History Entry Structure

Each entry is 8 bytes stored in 'HIST' resource:
```c
struct HistoryEntry {
    int16_t move_number;
    int16_t player;
    int16_t score;
    int16_t flags;  // bingo, exchange, pass indicators
};
```

## C Equivalent

```c
void format_move_history(int move_index, int player) {
    char buffer[66];

    GameState** stateH = g_game_state;
    HLock((Handle)stateH);
    GameState* state = *stateH;

    // Get current scores
    format_score(state->player1Score, g_score_buffer1);
    format_score(state->player2Score, g_score_buffer2);

    // Find or create history resource
    Handle histH = GetResource('HIST', 0);
    if (!histH) {
        histH = NewHandle(0);
        AddResource(histH, 'HIST', 0, NULL);
    }

    HLock(histH);

    // Resize for new entry (8 bytes per entry)
    SetHandleSize(histH, GetHandleSize(histH) + 8);

    // Get move data
    MoveData* move = &state->moves[move_index];

    // Format move notation with SANE extended precision
    // for accurate score calculations
    Extended scoreExt;
    FI2X(move->score, &scoreExt);
    // ... formatting operations ...

    // Check for game over
    if (state->gameOver) {
        // Compare final scores and format result
        if (state->player1Score > state->player2Score) {
            format_result(player == 0 ? "WIN" : "LOSS", diff);
        } else {
            format_result(player == 1 ? "WIN" : "LOSS", diff);
        }
    }

    HUnlock(histH);
    HUnlock((Handle)stateH);
}
```

## Confidence: HIGH

Clear move history formatting patterns:
- Standard Scrabble notation
- SANE floating-point for accurate score calculations
- Score tracking for both players
- Win/loss determination
- Resource-based storage with 'HIST' type

---

## Speculative C Translation

### Data Structures

```c
/* SANE 80-bit extended precision type */
typedef struct {
    unsigned char bytes[10];
} Extended80;

/* Move entry in game state - 10 bytes */
typedef struct MoveEntry {
    long word_data;            /* 0-3: Word/tile information */
    long score_data;           /* 4-7: Score information */
    short flags;               /* 8-9: Move flags (bingo, exchange, pass) */
} MoveEntry;

/* History entry stored in HIST resource - 8 bytes */
typedef struct HistoryEntry {
    short move_number;         /* 0-1: Sequential move number */
    short player;              /* 2-3: Player 0 or 1 */
    short score;               /* 4-5: Points scored */
    short flags;               /* 6-7: Special indicators */
} HistoryEntry;

/* Game state structure (partial) */
typedef struct GameState {
    char reserved[768];        /* 0-767: Other game data */
    short game_over_flag;      /* 768: Non-zero if game ended */
    short current_move_index;  /* 770: Current position in move list */
    MoveEntry moves[];         /* 772+: Variable-length move array */
} GameState;

/* Global variables */
Handle g_game_state_handle;    /* A5-8584: Handle to GameState */
short g_resource_file_ref;     /* A5-3512: Application resource file ref */
char g_score_buffer1[32];      /* A5-8504: First score format buffer */
char g_score_buffer2[32];      /* A5-23312: Second score format buffer */
```

### Function 0x0000 - Format Move History Entry

```c
/*
 * format_move_history_entry - Format a move for history display
 *
 * Creates a formatted string representation of a game move using
 * standard Scrabble notation. Also maintains the HIST resource
 * for game history persistence.
 *
 * @param move_index: Index of the move to format
 * @param player: Player number (0 or 1)
 */
void format_move_history_entry(long move_index, long player) {
    /* Local buffers for floating-point operations */
    Extended80 ext_buffer1;      /* -10(A6) */
    Extended80 ext_buffer2;      /* -36(A6) */
    Extended80 ext_buffer3;      /* -46(A6) */
    Extended80 ext_buffer4;      /* -56(A6) */
    Extended80 ext_buffer5;      /* -66(A6) */
    short score_diff;            /* -48(A6) */
    long temp_long;              /* -8(A6) */
    short temp_word;             /* -2(A6) */

    GameState *game_state;
    Handle hist_handle;
    HistoryEntry *hist_entry;
    MoveEntry *move_ptr;
    char move_notation[64];

    /* Lock game state for access */
    HLock(g_game_state_handle);
    game_state = *(GameState**)g_game_state_handle;

    /* Get move count/index from state */
    short state_move_index = game_state->current_move_index;

    /*--------------------------------------------------
     * Format player scores using field at offset 770+
     *--------------------------------------------------*/

    /* uncertain: exact score extraction */
    format_score_value(game_state, g_score_buffer1, 0);  /* Player 1 */
    format_score_value(game_state, g_score_buffer2, 1);  /* Player 2 */

    /*--------------------------------------------------
     * Find or create HIST resource
     *--------------------------------------------------*/

    hist_handle = GetResource('HIST', 0);

    if (hist_handle == NULL) {
        /* Create new history resource */
        hist_handle = NewHandle(0);

        if (hist_handle == NULL) {
            HUnlock(g_game_state_handle);
            return;  /* Memory allocation failed */
        }

        /* Add to resource file for persistence */
        AddResource(hist_handle, 'HIST', 0, "\p");
    }

    /* Lock history handle */
    HLock(hist_handle);

    /* Resize to add new 8-byte entry */
    SetHandleSize(hist_handle, GetHandleSize(hist_handle) + 8);

    /* Check for memory error */
    if (MemError() != noErr) {
        error_handler();  /* JT[418] */
    }

    /*--------------------------------------------------
     * Format move number and player
     *--------------------------------------------------*/

    /* Convert move index to string (max 100) */
    /* JT[90] = NumToString wrapper */
    num_to_string(move_index, 100, move_notation);

    /* Add player indicator */
    num_to_string(player, 100, move_notation + strlen(move_notation));

    /*--------------------------------------------------
     * Get and format move data
     *--------------------------------------------------*/

    /* Calculate offset to move entry */
    /* uncertain: exact offset calculation */
    long move_offset = state_move_index * sizeof(MoveEntry);
    move_ptr = (MoveEntry*)((char*)&game_state->moves + move_offset);

    /* Copy 10-byte move entry to local storage */
    MoveEntry local_move = *move_ptr;

    /*--------------------------------------------------
     * SANE floating-point score calculations
     *--------------------------------------------------*/

    /* Convert score to extended precision for accurate formatting */
    /* SANE operation $200E = FADD extended */
    long_to_extended(local_move.score_data, &ext_buffer1);

    /* Copy for manipulation */
    copy_extended(&ext_buffer1, &ext_buffer2);

    /* Perform formatting operations */
    /* SANE $0002 = FX2I (extended to integer) */
    extended_to_int(&ext_buffer2, &temp_word);

    /* uncertain: exact sequence of SANE operations */
    /* Multiple conversions between extended and string formats */
    extended_add(&ext_buffer1, &ext_buffer3, &ext_buffer4);
    extended_subtract(&ext_buffer4, &ext_buffer5, &ext_buffer1);

    /* Format score with proper rounding */
    /* SANE $000D = FX2S (extended to string) */
    extended_to_string(&ext_buffer1, g_score_buffer1);

    /*--------------------------------------------------
     * Check for game over
     *--------------------------------------------------*/

    if (game_state->game_over_flag != 0) {
        /* Game has ended - determine winner */

        /* Get final scores */
        long player1_score = get_player_score(game_state, 0);
        long player2_score = get_player_score(game_state, 1);

        /* Compare scores */
        /* SANE $1004 = FCPXX (compare extended) */
        if (player1_score > player2_score) {
            score_diff = (short)(player1_score - player2_score);

            if (player == 0) {
                format_win_result(score_diff);
            } else {
                format_loss_result(score_diff);
            }
        } else if (player2_score > player1_score) {
            score_diff = (short)(player2_score - player1_score);

            if (player == 1) {
                format_win_result(score_diff);
            } else {
                format_loss_result(score_diff);
            }
        } else {
            /* Tie game */
            format_tie_result();
        }
    }

    /*--------------------------------------------------
     * Store history entry
     *--------------------------------------------------*/

    /* Get pointer to new entry at end of handle */
    long hist_size = GetHandleSize(hist_handle);
    hist_entry = (HistoryEntry*)(*hist_handle + hist_size - 8);

    hist_entry->move_number = (short)move_index;
    hist_entry->player = (short)player;
    hist_entry->score = temp_word;  /* Formatted score */
    hist_entry->flags = local_move.flags;

    /* Mark resource as changed for saving */
    ChangedResource(hist_handle);
    WriteResource(hist_handle);

    /*--------------------------------------------------
     * Cleanup
     *--------------------------------------------------*/

    HUnlock(hist_handle);
    ReleaseResource(hist_handle);
    HUnlock(g_game_state_handle);
}
```

### SANE Helper Functions (Speculative)

```c
/*
 * SANE (Standard Apple Numerics Environment) wrapper functions
 *
 * These call through the A9EB trap (Pack7) with operation codes.
 */

/* Convert long integer to 80-bit extended */
void long_to_extended(long value, Extended80 *result) {
    /* SANE operation $0008 or $2008 = FL2X */
    SANE_Pack7(0x2008, &value, result);
}

/* Convert integer to 80-bit extended */
void int_to_extended(short value, Extended80 *result) {
    /* SANE operation $0006 or $2004 = FI2X */
    SANE_Pack7(0x2004, &value, result);
}

/* Convert 80-bit extended to integer */
void extended_to_int(Extended80 *source, short *result) {
    /* SANE operation $0002 or $2002 = FX2I */
    SANE_Pack7(0x2002, source, result);
}

/* Add two extended values */
void extended_add(Extended80 *a, Extended80 *b, Extended80 *result) {
    /* SANE operation $200E or $2010 = FADDX */
    SANE_Pack7(0x200E, a, b, result);
}

/* Subtract extended values */
void extended_subtract(Extended80 *a, Extended80 *b, Extended80 *result) {
    /* SANE operation $0016 or $100E = FSUBX */
    SANE_Pack7(0x100E, a, b, result);
}

/* Compare extended values */
short extended_compare(Extended80 *a, Extended80 *b) {
    /* SANE operation $1004 = FCPXX */
    short result;
    SANE_Pack7(0x1004, a, b, &result);
    return result;
}

/* Convert extended to decimal string */
void extended_to_string(Extended80 *source, char *result) {
    /* SANE operation $000D = FX2S */
    DecForm format = { FIXEDDECIMAL, 0, 2 };  /* uncertain: format params */
    SANE_Pack7(0x000D, source, &format, result);
}

/* Copy extended value */
void copy_extended(Extended80 *source, Extended80 *dest) {
    BlockMove(source, dest, 10);
}
```

### Move Notation Formatting

```c
/*
 * Build standard Scrabble move notation string
 *
 * Format examples:
 *   "1. QUARTZ H8 +92"        - Normal word play
 *   "2. BINGOES* 15A +83"     - Bingo (7 tiles, 50 pt bonus)
 *   "3. (exchange 4)"         - Tile exchange
 *   "4. (pass)"               - Pass turn
 *   "Game: WIN by 45"         - Final result
 */

#define MOVE_FLAG_BINGO     0x0001
#define MOVE_FLAG_EXCHANGE  0x0002
#define MOVE_FLAG_PASS      0x0004

void format_move_notation(MoveEntry *move, short move_num, char *output) {
    char *ptr = output;

    /* Move number */
    ptr += sprintf(ptr, "%d. ", move_num);

    if (move->flags & MOVE_FLAG_PASS) {
        strcpy(ptr, "(pass)");
        return;
    }

    if (move->flags & MOVE_FLAG_EXCHANGE) {
        short tiles_exchanged = (move->flags >> 8) & 0x0F;
        sprintf(ptr, "(exchange %d)", tiles_exchanged);
        return;
    }

    /* Normal word play */
    /* uncertain: exact word/position extraction */
    extract_word_from_move(move, ptr);
    ptr += strlen(ptr);

    /* Position (e.g., "H8" or "8H") */
    *ptr++ = ' ';
    format_board_position(move, ptr);
    ptr += strlen(ptr);

    /* Score */
    short score = (short)(move->score_data & 0xFFFF);
    sprintf(ptr, " +%d", score);

    /* Bingo indicator */
    if (move->flags & MOVE_FLAG_BINGO) {
        strcat(output, "*");
    }
}

void format_win_result(short point_diff) {
    /* uncertain: exact output location */
    sprintf(g_result_buffer, "WIN by %d", point_diff);
}

void format_loss_result(short point_diff) {
    sprintf(g_result_buffer, "LOSS by %d", point_diff);
}

void format_tie_result(void) {
    strcpy(g_result_buffer, "TIE");
}
```

### Resource Management

```c
/* HIST resource structure in file */
/*
 * The HIST resource stores the complete game history:
 *
 * Offset 0: HistoryEntry[0] - First move
 * Offset 8: HistoryEntry[1] - Second move
 * ...
 * Offset 8*n: HistoryEntry[n] - nth move
 *
 * Each entry is 8 bytes containing:
 * - Move number (2 bytes)
 * - Player (2 bytes)
 * - Score (2 bytes)
 * - Flags (2 bytes)
 */

void save_game_history(void) {
    Handle hist_handle = GetResource('HIST', 0);

    if (hist_handle != NULL) {
        ChangedResource(hist_handle);
        WriteResource(hist_handle);
        UpdateResFile(g_resource_file_ref);
    }
}

void clear_game_history(void) {
    Handle hist_handle = GetResource('HIST', 0);

    if (hist_handle != NULL) {
        SetHandleSize(hist_handle, 0);
        ChangedResource(hist_handle);
    }
}
```

### Why SANE Floating-Point?

The code uses 80-bit extended precision for several reasons:

1. **Score Accuracy**: Prevents rounding errors when accumulating scores across many moves
2. **Statistics**: Enables precise calculation of averages and differentials
3. **Comparison**: Reliable score comparisons for win/loss determination
4. **Formatting**: Proper decimal formatting with controlled precision

This is typical for Macintosh applications of this era that needed reliable numeric processing.
