# CODE 21 Detailed Analysis - Main UI & Game Logic

## Overview

| Property | Value |
|----------|-------|
| Size | 13,718 bytes |
| JT Offset | 1064 |
| JT Entries | 39 |
| Functions | 50+ |
| Purpose | **Main game UI, tile placement, rack management, turn handling** |

## System Role

**Category**: Core System
**Function**: Main Game Loop

Largest CODE resource (13,722 bytes). Handles the main event/game loop, user interface, player input processing, and coordinates game flow between the human player and AI.

**Related CODE resources**:
- CODE 11 (controller)
- CODE 6 (windows)
- CODE 8 (menus)
- CODE 20 (board state)
- CODE 12 (word validation)

## Architecture Role

CODE 21 is the **largest CODE resource** and the main game interface:
1. Board display and tile placement with visual feedback
2. Rack management (7 tiles per player)
3. Turn processing and move validation
4. Score calculation and display integration
5. Game flow coordination between human and AI
6. Input handling (mouse clicks, keyboard)

## Key Data Structures

### Rack Structure (at A5-8664)
```c
struct RackEntry {
    short tile_value;    // Offset 0: Letter value (1-26, 0=blank)
    short played_flag;   // Offset 2: Non-zero if played this turn
    short reserved1;     // Offset 4: Reserved/padding
    short reserved2;     // Offset 6: Reserved/padding
};
// 7 entries x 8 bytes = 56 bytes at A5-8664 (g_flag1)
```

### Board Arrays
| Array | Offset | Size | Purpose |
|-------|--------|------|---------|
| g_lookup_tbl | A5-10388 | 289 bytes | Current board state (17x17) |
| working_array1 | A5-10082 | 289 bytes | Working copy for validation |
| working_array2 | A5-10371 | 289 bytes | Secondary working copy |
| mapping_array | A5-27229 | varies | Character mapping data |

### Game State
```c
short g_game_over;        // A5-9810: Non-zero when game has ended
short g_cursor_row;       // A5-8624: Current cursor row position
short g_cursor_col;       // A5-8622: Current cursor column position
short g_move_count;       // A5-8636: Tiles played in current turn
short g_input_flag;       // A5-8620: Input pending flag
```

## Key Functions

### Function 0x0000 - Copy Rack to Buffer
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
0008: MOVE.L     8(A6),-(A7)          ; Push destination buffer
000C: JSR        2410(A5)             ; JT[2410] - init_buffer
0010: MOVEA.L    8(A6),A3             ; A3 = destination
0014: MOVEA.L    -8584(A5),A0         ; A0 = main handle
0018: MOVEA.L    (A0),A4              ; A4 = *handle
001A: LEA        786(A4),A4           ; A4 = rack data at offset 786
001E: LEA        12(A7),A7

0020: BRA.S      $003C                ; Jump into loop
0022: MOVEQ      #0,D6                ; D6 = 0 (count for this letter)
0024: LEA        -23218(A5),A2        ; A2 = letter mapping table
0028: ADD.W      D7,A2                ; Index into table by letter value
002A: BRA.S      $0032

; Store multiple copies of same letter based on count
002C: MOVE.B     D7,(A3)              ; Store character
002E: ADDQ.W     #1,D6                ; D6++
0030: ADDQ.L     #1,A3                ; A3++ (next dest position)

0032: MOVE.B     (A2),D0              ; Get mapped count from table
0034: EXT.W      D0
0036: CMP.W      D6,D0                ; While D6 < count
0038: BGT.S      $002C                ; Continue storing

003A: ADDQ.L     #1,A4                ; Next rack entry
003C: MOVE.B     (A4),D7              ; Get tile from rack
003E: EXT.W      D7
0040: TST.W      D7                   ; While not zero
0042: BNE.S      $0022

0044: CLR.B      (A3)                 ; Null terminate
004C: RTS
```

**C equivalent**:
```c
void copy_rack_to_buffer(char* dest) {
    init_buffer(dest);                      // JT[2410]

    Handle h = g_main_handle;               // A5-8584
    char* rack_ptr = (*h) + 786;            // Rack data at offset 786
    char* letter_map = &g_letter_map[-23218]; // Letter mapping table

    while (*rack_ptr != 0) {
        char tile = *rack_ptr++;
        int count = letter_map[tile];
        for (int i = 0; i < count; i++) {
            *dest++ = tile;
        }
    }
    *dest = '\0';
}
```

### Function 0x004E - Initialize Board Display
```asm
004E: LINK       A6,#-4
0052: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
0056: PEA        -15514(A5)           ; Push g_field_14 buffer
005A: JSR        -92(PC)              ; Copy rack to buffer
005E: MOVEQ      #0,D6                ; D6 = 0 (rack index)
0060: LEA        -8664(A5),A4         ; A4 = g_flag1 (rack structure)
0064: LEA        12(A7),A7

0066: BRA.S      $0090                ; Jump into loop

; Process each rack position (0-6)
0068: PEA        -15514(A5)           ; Push g_field_14
006C: JSR        3522(A5)             ; JT[3522] - strlen
0070: CMP.W      D6,D0                ; Compare length with index
0076: BLS.S      $007C                ; If length <= index

0078: CLR.W      (A4)                 ; Clear rack entry if too many
007A: BRA.S      $0088

; Get character at position D6 from g_field_14
007C: MOVEA.L    A5,A0
007E: ADDA.W     D6,A0
0080: MOVE.B     -15514(A0),D0        ; D0 = g_field_14[D6]
0084: EXT.W      D0
0086: MOVE.W     D0,(A4)              ; Store in rack entry.tile_value

0088: CLR.W      2(A4)                ; Clear rack entry.played_flag
008C: ADDQ.W     #1,D6                ; D6++
008E: ADDQ.L     #8,A4                ; A4 += 8 (next rack entry)

0090: CMPI.W     #7,D6                ; While D6 < 7
0094: BLT.S      $0068

0096: CLR.W      -8636(A5)            ; Clear move counter
009A: JSR        2890(PC)             ; Update display
...
00F6: RTS
```

**C equivalent**:
```c
void init_board_display() {
    copy_rack_to_buffer(g_field_14);

    RackEntry* rack = g_flag1;    // A5-8664
    int length = strlen(g_field_14);

    for (int i = 0; i < 7; i++) {
        if (i < length) {
            rack[i].tile_value = g_field_14[i];
        } else {
            rack[i].tile_value = 0;
        }
        rack[i].played_flag = 0;
    }

    g_move_count = 0;   // A5-8636
    update_display();
}
```

### Function 0x00F8 - Place Tile on Board
```asm
00F8: LINK       A6,#-22              ; 22 bytes local
00FC: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0100: MOVE.W     12(A6),D3            ; D3 = tile value
0104: TST.W      -9810(A5)            ; Check game state
0108: BNE.W      $0432                ; If game over, skip

; Calculate board position index: row * 17 + column
010C: MOVEQ      #17,D0
010E: MULU.W     8(A6),D0             ; D0 = row * 17
0112: ADD.W      A5,D0                ; Add base
0114: MOVEA.W    10(A6),A4            ; A4 = column
0118: LEA        -10099(A4),A4        ; A4 points to secondary board
011C: ADDA.W     D0,A4                ; A4 = board[row][col]

; Check if square is already occupied
0120: TST.B      (A4)                 ; Test current value
0122: BNE.S      $0146                ; If not empty, handle overlap

; Square empty - validate the new tile
0124: MOVE.B     (A4),D0              ; Get current tile (should be 0)
0126: EXT.W      D0
0128: MOVE.W     D0,-(A7)
012A: JSR        3554(A5)             ; JT[3554] - toupper
012E: MOVE.W     D0,-22(A6)           ; Store converted
0132: MOVE.W     D3,-(A7)             ; Push tile param
0134: JSR        3554(A5)             ; Convert param to uppercase
0138: CMP.W      -22(A6),D0           ; Compare
013E: BEQ.S      $0146                ; If same, OK to place
0140: MOVEQ      #0,D0                ; Return 0 (failure/conflict)
0142: BRA.W      $0452

; Place the tile on board
0146: MOVE.W     D3,-(A7)             ; Push tile
0148: JSR        3554(A5)             ; Convert to uppercase
...

; Update the g_field_14 buffer
0170: PEA        -15514(A5)           ; g_field_14
0174: JSR        2410(A5)             ; JT[2410] - init/clear

; Find and mark matching tile in rack as played
01E8: MOVE.B     (A2),D0              ; Get mapped letter
01EA: EXT.W      D0
01EC: MOVE.W     D0,-(A7)
01EE: JSR        3554(A5)             ; Convert to uppercase
01F2: MOVEA.L    A5,A0
...

; Handle blank tiles specially
020E: TST.B      -23155(A5)           ; Check blank flag
0212: BNE.S      $0226                ; If blank, special handling
0214: MOVE.B     -23155(A5),-(A1)     ; Update blank count
...

; Commit tile placement to board
036E: MOVE.B     D3,(A4)              ; Place tile on board array
0370: MOVEQ      #17,D0
0372: MULU.W     D6,D0                ; row * 17
0374: LEA        -10388(A5),A4        ; g_lookup_tbl (main board)
0378: ADDA.W     D0,A4
037A: ADDA.W     D7,A4                ; A4 = &lookup[row][col]
...

; Update display for the cell
0390: JSR        986(A5)              ; JT[986] - update_cell_display
...

; Return success
044E: MOVEQ      #1,D0                ; Return 1 (success)
0452: RTS
```

**C equivalent**:
```c
int place_tile(int row, int col, int tile) {
    if (g_game_over) return 0;  // A5-9810

    // Calculate board position
    char* board_pos = &g_secondary_board[row * 17 + col];

    // Check if square is already occupied
    if (*board_pos != 0) {
        // Verify placed tile matches existing (case-insensitive)
        if (toupper(*board_pos) != toupper(tile)) {
            return 0;  // Conflict - different letters
        }
    }

    // Place tile
    *board_pos = toupper(tile);

    // Update main lookup table
    g_lookup_tbl[row * 17 + col] = toupper(tile);

    // Mark rack tile as played
    for (int i = 0; i < 7; i++) {
        if (g_rack[i].value == tile && !g_rack[i].played) {
            g_rack[i].played = 1;
            break;
        }
    }

    update_cell_display(row, col);  // JT[986]
    return 1;
}
```

### Function 0x05FA - Validate and Score Move
```asm
05FA: LINK       A6,#0
05FE: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
0602: MOVEA.L    8(A6),A4             ; A4 = word string pointer
0606: MOVE.L     A4,-(A7)
0608: JSR        3522(A5)             ; JT[3522] - strlen
060C: TST.W      D0
0614: BLS.S      $0616                ; If length <= 7, continue
0612: MOVEQ      #0,D0                ; Return 0 (word too long)
0614: BRA.S      $0678

; Process each character in the word
0616: MOVEQ      #0,D7                ; D7 = character index
0618: LEA        -8664(A5),A3         ; A3 = g_flag1 (rack)
061C: MOVE.B     0(A4,D7.W),D6        ; Get character at index D7
0620: MOVEA.W    D7,A2
...

; Validate character is available in rack
0628: MOVEQ      #0,D0
062A: MOVE.B     D6,D0                ; Letter code
062C: MOVEA.L    A5,A0
062E: ADDA.L     D0,A0
0632: TST.B      -4056(A0)            ; Check tile availability table
0638: AND.B      #$C0,D0              ; Check validity flags
063E: BNE.S      $0644                ; If valid, continue
0640: JSR        418(A5)              ; JT[418] - error (invalid tile)

; Mark tile as used
0644: MOVE.B     (A2),D0
0646: EXT.W      D0
0648: MOVE.W     D0,-(A7)
064A: JSR        3554(A5)             ; JT[3554] - toupper
064E: MOVE.W     D0,(A3)              ; Store in rack entry
0652: ADDQ.W     #1,D7                ; D7++
0656: ADDQ.L     #8,A3                ; Next rack entry
065A: BRA.S      $061C                ; Loop

; Check word in dictionary
0658: MOVE.W     #$03FF,-(A7)         ; Push error code / search flags
065C: JSR        1418(A5)             ; JT[1418] - check_dictionary
0660: TST.W      D0
0666: BNE.S      $066A                ; Word found
0668: MOVEQ      #0,D0                ; Word not found
066A: BRA.S      $0678

066C: CLR.L      -(A7)                ; Push 0
066E: MOVE.L     A4,-(A7)             ; Push word string
0672: JSR        -170(PC)             ; Calculate score
0676: MOVE.L     D0,(A7)              ; Return score

0678: RTS
```

**C equivalent**:
```c
int validate_and_score(char* word) {
    int length = strlen(word);
    if (length > 7) return 0;  // Too long for one turn

    RackEntry* rack = g_flag1;

    // Validate each letter is available
    for (int i = 0; i < length; i++) {
        char c = word[i];
        if (!is_tile_available(c)) {
            error_invalid_tile();
            return 0;
        }
        rack[i].tile_value = toupper(c);
    }

    // Check word in dictionary
    if (!check_dictionary(word, 0x03FF)) {
        return 0;  // Not a valid word
    }

    // Calculate and return score
    return calculate_score(word, NULL);
}
```

### Function 0x07EC - Start AI Turn
```asm
07EC: CLR.W      -9810(A5)            ; Clear game-over flag
07F0: JSR        4362(PC)             ; Get AI move
07F4: MOVE.L     D0,-(A7)             ; Push move data
07F6: JSR        4364(PC)             ; Process/execute move
07FA: JSR        4346(PC)             ; Calculate final score
07FE: MOVE.L     D0,-8614(A5)         ; Store score at A5-8614
0802: JSR        4204(PC)             ; Update display with AI move
0808: RTS
```

**C equivalent**:
```c
void start_ai_turn() {
    g_game_over = 0;           // A5-9810

    Move* move = get_ai_move();
    execute_move(move);
    int score = calculate_final_score();
    g_ai_score = score;        // A5-8614
    update_display();
}
```

### Function 0x080A - Process Player Input
```asm
080A: MOVEM.L    D6/D7/A4,-(SP)
080E: JSR        10382(PC)            ; Check for valid input
0812: TST.W      D0
0814: BNE.S      $0824                ; If not valid
0816: MOVE.W     #$0001,-(A7)         ; Push error code
081A: JSR        262(PC)              ; Show error message
0820: BRA.W      $08F6                ; Exit

0824: TST.W      -9810(A5)            ; Check game state
0828: BEQ.W      $08D4                ; If game not over

; AI mode processing
082C: JSR        8682(PC)             ; Get AI recommendation
0830: TST.W      D0
0832: BEQ.W      $08F6                ; If no move available

0836: TST.B      -15514(A5)           ; Check g_field_14 has data
083A: BNE.S      $0864                ; If has data, use it

; Need to search for moves
083C: CLR.W      -(A7)                ; Push 0
083E: JSR        378(A5)              ; JT[378] - init_search
0842: TST.W      D0
0848: BEQ.S      $0864                ; If found moves

; Found moves - show best one
084E: PEA        -23090(A5)           ; g_dawg_info
0852: MOVE.W     #$7FFF,-(A7)         ; Max score threshold
0856: JSR        8616(PC)             ; Get best move
085A: JSR        2736(PC)             ; Display move suggestion
...
```

## Input Processing Flow

```
User Click/Key
      |
      v
Process Player Input (0x080A)
      |
      +---> Validate Input
      |           |
      |           v
      +---> Game Over Check
      |           |
      |           v
      +---> AI Recommendation (if in hint mode)
      |           |
      |           v
      +---> Execute Move
      |           |
      |           v
      +---> Update Display
```

## Key Global Variables

| Offset | Type | Name | Purpose |
|--------|------|------|---------|
| A5-4056 | char[128] | tile_valid_table | Tile validity flags |
| A5-8584 | Handle | g_main_handle | Main window/game data handle |
| A5-8614 | long | g_ai_score | Last AI move score |
| A5-8620 | short | g_input_flag | Input pending flag |
| A5-8622 | short | g_cursor_col | Current cursor column |
| A5-8624 | short | g_cursor_row | Current cursor row |
| A5-8636 | short | g_move_count | Tiles played in current turn |
| A5-8664 | RackEntry[7] | g_flag1 | Rack entries (7 tiles x 8 bytes) |
| A5-9810 | short | g_game_over | Game over flag |
| A5-10082 | char[289] | working_array1 | 17x17 working board |
| A5-10099 | char[289] | secondary_board | Secondary board state |
| A5-10371 | char[289] | working_array2 | 17x17 working board |
| A5-10388 | char[289] | g_lookup_tbl | Main 17x17 board state |
| A5-15514 | char[64] | g_field_14 | General string buffer |
| A5-23090 | - | g_dawg_info | DAWG search state |
| A5-23155 | short | g_blank_count | Blank tiles remaining |
| A5-23218 | char[27] | letter_map | Letter mapping table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 378 | init_search - Start move search |
| 418 | bounds_check - Error handler |
| 426 | memset - Clear memory |
| 986 | update_cell_display - Redraw single cell |
| 1418 | check_dictionary - Validate word |
| 2402 | process_buffer |
| 2410 | init_buffer - Initialize string buffer |
| 3522 | strlen - String length |
| 3554 | toupper - Convert to uppercase |
| 3562 | tolower - Convert to lowercase |

## Game Flow Coordination

```
                  ┌─────────────────┐
                  │    CODE 21      │
                  │   (Main UI)     │
                  └────────┬────────┘
                           │
       ┌───────────────────┼───────────────────┐
       │                   │                   │
       v                   v                   v
 ┌──────────┐       ┌──────────┐       ┌──────────┐
 │ CODE 12  │       │ CODE 20  │       │ CODE 14  │
 │ (Valid.) │       │ (Board)  │       │ (Select) │
 └──────────┘       └──────────┘       └──────────┘
```

## Speculative C Translation

### Header Definitions
```c
/* CODE 21 - Main UI & Game Logic
 * Main game interface: board display, tile placement, turn handling.
 * LARGEST CODE resource (13,718 bytes).
 */

#include <MacTypes.h>

/*========== Constants ==========*/
#define BOARD_SIZE              17      /* 15 playable + 2 border */
#define RACK_SIZE               7       /* Tiles in player's rack */
#define RACK_ENTRY_SIZE         8       /* Bytes per rack entry */
#define MAX_WORD_LENGTH         7       /* Max tiles per turn */

/*========== Data Structures ==========*/

/* Rack entry structure (8 bytes each) */
typedef struct RackEntry {
    short tile_value;           /* Offset 0: Letter value (1-26, 0=blank) */
    short played_flag;          /* Offset 2: Non-zero if played this turn */
    short reserved1;            /* Offset 4: Reserved/padding */
    short reserved2;            /* Offset 6: Reserved/padding */
} RackEntry;

/* Letter mapping table entry */
typedef struct LetterMapEntry {
    char count;                 /* Number of this letter available */
} LetterMapEntry;

/*========== Global Variables (A5-relative) ==========*/
/* Board Arrays */
extern char   g_lookup_tbl[289];            /* A5-10388: Main board (17x17) */
extern char   g_working_array1[289];        /* A5-10082: Working copy */
extern char   g_secondary_board[289];       /* A5-10099: Secondary state */
extern char   g_working_array2[289];        /* A5-10371: Working copy 2 */

/* Game State */
extern short  g_game_over;                  /* A5-9810: Game over flag */
extern short  g_cursor_row;                 /* A5-8624: Cursor row position */
extern short  g_cursor_col;                 /* A5-8622: Cursor column position */
extern short  g_move_count;                 /* A5-8636: Tiles played this turn */
extern short  g_input_flag;                 /* A5-8620: Input pending flag */
extern short  g_blank_count;                /* A5-23155: Blanks available */

/* Rack */
extern RackEntry g_rack[RACK_SIZE];         /* A5-8664: Player's rack (g_flag1) */
extern char   g_letter_map[128];            /* A5-23218: Letter mapping table */
extern char   g_field_14[64];               /* A5-15514: General string buffer */
extern char   g_tile_valid[128];            /* A5-4056: Tile validity table */

/* Handles */
extern Handle g_main_handle;                /* A5-8584: Main window/game handle */
extern long   g_ai_score;                   /* A5-8614: Last AI move score */
extern void*  g_dawg_info;                  /* A5-23090: DAWG search state */
```

### Rack Management
```c
/*
 * copy_rack_to_buffer - Extract rack letters to string buffer
 *
 * Iterates through rack structure at offset 786 in main handle,
 * building a string of available letters with counts from map.
 *
 * @param dest: Destination buffer for rack string
 */
void copy_rack_to_buffer(char* dest) {
    char* dest_ptr = dest;
    char** handle_ptr;
    char* rack_ptr;
    char tile;
    char* map_ptr;
    int count;

    /* Initialize buffer */
    init_buffer(dest);                      /* JT[2410] */

    /* Get rack from main handle at offset 786 */
    handle_ptr = (char**)g_main_handle;     /* A5-8584 */
    rack_ptr = *handle_ptr + 786;

    /* Process each rack tile */
    while ((tile = *rack_ptr) != 0) {
        /* Get count from letter mapping table */
        map_ptr = &g_letter_map[(int)tile]; /* A5-23218 */
        count = *map_ptr;

        /* Store multiple copies based on count */
        for (int i = 0; i < count; i++) {
            *dest_ptr++ = tile;
        }

        rack_ptr++;     /* Each entry is at +1 byte offset */
    }

    *dest_ptr = '\0';   /* Null terminate */
}

/*
 * init_board_display - Initialize board and rack display
 *
 * Copies rack to buffer, populates rack structure,
 * clears played flags, and updates display.
 */
void init_board_display(void) {
    int i;
    int rack_len;

    /* Copy current rack to g_field_14 buffer */
    copy_rack_to_buffer(g_field_14);

    rack_len = strlen(g_field_14);          /* JT[3522] */

    /* Populate rack entries (7 tiles max) */
    for (i = 0; i < RACK_SIZE; i++) {
        if (i < rack_len) {
            g_rack[i].tile_value = g_field_14[i];
        } else {
            g_rack[i].tile_value = 0;       /* Empty slot */
        }
        g_rack[i].played_flag = 0;          /* Clear played flag */
    }

    /* Reset move counter */
    g_move_count = 0;                       /* A5-8636 */

    /* Update display */
    update_board_display();                 /* PC-relative at 0x0B4A */

    /* Sync working arrays with lookup table */
    for (int row = 1; row < 16; row++) {
        for (int col = 1; col < 16; col++) {
            int idx = row * BOARD_SIZE + col;

            /* Compare working arrays */
            if (g_working_array1[idx] != g_working_array2[idx]) {
                /* Sync and update display */
                g_working_array2[idx] = g_working_array1[idx];
                update_cell_display(row, col);  /* JT[986] */
            }
        }
    }

    /* Final refresh calls */
    refresh_board();                        /* JT[962] */
    additional_display_update();            /* PC-relative at 0x08FC */
}
```

### Tile Placement
```c
/*
 * place_tile_on_board - Place tile at board position
 *
 * Handles tile placement including conflict detection,
 * uppercase conversion, rack tracking, and display updates.
 *
 * @param row: Board row (1-15)
 * @param col: Board column (1-15)
 * @param tile: Tile character to place
 * @return: 1 if successful, 0 if failed (conflict)
 */
int place_tile_on_board(short row, short col, short tile) {
    int board_idx;
    char* board_pos;
    char existing_tile;
    char upper_existing;
    char upper_tile;
    int i;

    /* Check if game is over */
    if (g_game_over != 0) {                 /* A5-9810 */
        return 0;   /* Can't place during game over */
    }

    /* Calculate board position */
    board_idx = row * BOARD_SIZE + col;
    board_pos = &g_secondary_board[board_idx];  /* A5-10099 */

    /* Check if square is occupied */
    existing_tile = *board_pos;
    if (existing_tile != 0) {
        /* Square occupied - check for conflict */
        upper_existing = toupper(existing_tile);    /* JT[3554] */
        upper_tile = toupper(tile);

        if (upper_existing != upper_tile) {
            return 0;   /* Conflict - different letters */
        }
        /* Same letter - allow (re-placing existing tile) */
    }

    /* Convert tile to uppercase for board */
    upper_tile = toupper(tile);             /* JT[3554] */

    /* Initialize buffer for tracking */
    init_buffer(g_field_14);                /* JT[2410] */

    /* Clear local tracking vars */
    short local_flags = 0;                  /* -14(A6) */
    short local_idx = 0;                    /* -12(A6) */

    /* Find matching tile in rack and mark as played */
    for (i = 0; i < RACK_SIZE; i++) {
        if (g_rack[i].tile_value == 0) {
            break;  /* End of rack */
        }

        char rack_letter = toupper(g_rack[i].tile_value);  /* JT[3554] */

        /* Check letter map for availability */
        if (g_letter_map[(int)rack_letter] > 0) {
            g_letter_map[(int)rack_letter]--;

            /* Mark this rack entry as played */
            /* uncertain: exact tracking mechanism */
        }
    }

    /* Handle blank tiles specially */
    if (g_blank_count > 0 && is_blank_tile(tile)) {  /* A5-23155 */
        g_blank_count--;
        /* uncertain: blank designation logic */
    }

    /* Place tile on board */
    *board_pos = tile;

    /* Update main lookup table */
    board_pos = &g_lookup_tbl[row * BOARD_SIZE + col];  /* A5-10388 */
    *board_pos = toupper(*board_pos);       /* JT[3554] */

    /* Update cell display */
    update_cell_display(row, col);          /* JT[986] */

    /* Handle secondary updates for across/down play */
    /* uncertain: mirror position logic */

    /* Trigger search if enabled */
    if (/* search enabled flag at 16(A6) */) {
        init_search(0);                     /* JT[378] */
        if (/* search successful */) {
            validate_with_dawg(g_dawg_info);    /* JT[762] */
        }
        memset(g_dawg_info, 0, 34);         /* JT[426] - clear 34 bytes */
    }

    return 1;   /* Success */
}
```

### Cursor Management
```c
/*
 * update_cursor_position - Move cursor and update display
 *
 * Updates cursor position globals, redraws old and new positions.
 *
 * @param new_row: New cursor row
 * @param new_col: New cursor column
 */
void update_cursor_position(short new_row, short new_col) {
    short old_row, old_col;

    /* Check if cursor already exists */
    if (g_cursor_row != 0 || g_cursor_col != 0) {
        /* Save old position */
        old_row = g_cursor_row;             /* A5-8624 */
        old_col = g_cursor_col;             /* A5-8622 */

        /* Update to new position */
        g_cursor_row = new_row;
        g_cursor_col = new_col;

        /* Redraw old position (remove cursor) */
        update_cell_display(old_row, old_col);  /* JT[986] */

        /* Redraw new position (show cursor) */
        update_cell_display(g_cursor_row, g_cursor_col);    /* JT[986] */
    }
}
```

### Word Validation
```c
/*
 * validate_and_score_word - Validate word and calculate score
 *
 * Checks that word uses available tiles, validates against
 * dictionary, and calculates score.
 *
 * @param word: Null-terminated word string
 * @return: Score if valid, 0 if invalid
 */
int validate_and_score_word(char* word) {
    int length;
    int i;
    char letter;

    /* Get word length */
    length = strlen(word);                  /* JT[3522] */

    /* Check maximum length (can't play more than 7 tiles) */
    if (length > MAX_WORD_LENGTH) {
        return 0;   /* Too long */
    }

    /* Validate each letter is available */
    for (i = 0; i < length; i++) {
        letter = word[i];

        /* Check tile validity table */
        if (!g_tile_valid[(int)letter]) {   /* A5-4056 */
            bounds_check_error();           /* JT[418] */
            return 0;
        }

        /* Store uppercase in rack tracking */
        g_rack[i].tile_value = toupper(letter);     /* JT[3554] */
    }

    /* Check word in dictionary */
    if (!check_dictionary(word, 0x03FF)) {  /* JT[1418] */
        return 0;   /* Not a valid word */
    }

    /* Calculate and return score */
    return calculate_word_score(word, NULL);
}
```

### AI Turn Processing
```c
/*
 * start_ai_turn - Initiate AI move computation
 *
 * Clears game-over state, computes AI move, executes it,
 * calculates score, and updates display.
 */
void start_ai_turn(void) {
    Move* ai_move;
    long score;

    /* Clear game-over flag */
    g_game_over = 0;                        /* A5-9810 */

    /* Compute AI's best move */
    ai_move = compute_ai_move();            /* PC-relative at 0x1108 */

    /* Execute the move */
    execute_move(ai_move);                  /* PC-relative at 0x110A */

    /* Calculate final score */
    score = calculate_final_score();        /* PC-relative at 0x10F8 */

    /* Store AI score */
    g_ai_score = score;                     /* A5-8614 */

    /* Update display with AI move */
    display_ai_move();                      /* PC-relative at 0x1068 */
}
```

### Player Input Processing
```c
/*
 * process_player_input - Handle player input event
 *
 * Validates input, checks game state, optionally shows
 * AI recommendations.
 */
void process_player_input(void) {
    int valid_input;

    /* Check for valid input */
    valid_input = check_input_valid();      /* PC-relative at 0x288E */

    if (!valid_input) {
        /* Show error message */
        show_error_message(1);              /* PC-relative at 0x0106 */
        return;
    }

    /* Check game state */
    if (g_game_over != 0) {                 /* A5-9810 */
        /* Game over - check AI recommendation mode */
        if (!get_ai_recommendation()) {     /* PC-relative at 0x21EA */
            return;
        }

        /* Check if field_14 has data */
        if (g_field_14[0] != 0) {
            /* Has data - use it */
            /* uncertain: data usage */
        }
        else {
            /* Need to search for moves */
            init_search(0);                 /* JT[378] */

            if (/* search found moves */) {
                /* Get best move */
                get_best_move(g_dawg_info, 0x7FFF);     /* PC-relative */
                display_move_suggestion();              /* PC-relative */
            }
        }
    }
}

/*
 * show_error_message - Display error to user
 *
 * @param error_code: Error code to display
 */
static void show_error_message(short error_code) {
    /* uncertain: exact error display mechanism */
    /* Likely uses Alert or similar Mac dialog */
}
```

### Board State Synchronization
```c
/*
 * sync_board_arrays - Synchronize board state arrays
 *
 * Compares working arrays and updates display for changed cells.
 */
void sync_board_arrays(void) {
    char* array1 = g_working_array1;        /* A5-10082 */
    char* array2 = g_working_array2;        /* A5-10371 */

    for (int row = 1; row <= 15; row++) {
        for (int col = 1; col <= 15; col++) {
            int idx = row * BOARD_SIZE + col;

            if (array1[idx] != array2[idx]) {
                /* Cell changed - sync and update */
                array2[idx] = array1[idx];
                update_cell_display(row, col);  /* JT[986] */
            }
        }
    }
}

/*
 * validate_board_state - Check board state consistency
 *
 * Verifies letter counts and board state match expected values.
 *
 * @return: 1 if consistent, 0 if mismatch
 */
int validate_board_state(void) {
    int blank_count = 0;
    char local_buffer[128];
    int i;

    /* Clear and fill local buffer */
    memset(local_buffer, 0, 128);

    /* Process working arrays */
    for (int row = 1; row <= 15; row++) {
        for (int col = 1; col <= 15; col++) {
            char cell = g_working_array2[row * BOARD_SIZE + col];

            if (cell != 0) {
                /* Check if valid letter */
                if (!is_valid_letter(cell)) {   /* Check A5-4056 */
                    /* Blank tile */
                    local_buffer[0x3F]++;   /* '?' position */
                }
                else {
                    /* Regular letter */
                    char upper = toupper(cell);     /* JT[3554] */
                    local_buffer[(int)upper]++;
                }
            }
        }
    }

    /* Count rack tiles */
    for (i = 0; i < RACK_SIZE && g_rack[i].tile_value != 0; i++) {
        short tile = g_rack[i].tile_value;
        local_buffer[(int)tile]--;
    }

    /* uncertain: final validation checks */
    return 1;
}
```

### Letter Availability
```c
/*
 * check_letter_available - Check if letter can be played
 *
 * Verifies letter is in rack and hasn't been played.
 *
 * @param letter: Letter to check
 * @return: 1 if available, 0 if not
 */
int check_letter_available(char letter) {
    char upper = toupper(letter);           /* JT[3554] */

    /* Check letter map count */
    if (g_letter_map[(int)upper] <= 0) {
        return 0;   /* No copies available */
    }

    return 1;
}

/*
 * use_letter_from_rack - Mark letter as used
 *
 * Decrements letter count and marks rack entry.
 *
 * @param letter: Letter being used
 */
void use_letter_from_rack(char letter) {
    char upper = toupper(letter);

    /* Decrement count in letter map */
    g_letter_map[(int)upper]--;

    /* Find and mark corresponding rack entry */
    for (int i = 0; i < RACK_SIZE; i++) {
        if (g_rack[i].tile_value == letter && g_rack[i].played_flag == 0) {
            g_rack[i].played_flag = 1;
            break;
        }
    }
}
```

## Confidence: HIGH

CODE 21 is clearly the main game UI with:
- Extensive rack management (7 tiles, 8 bytes each)
- Board placement logic with conflict detection
- Input validation through dictionary lookup
- Score calculation integration
- AI move display and recommendations
- Turn processing coordination

The 17x17 board arrays with offset calculations and the rack structure at fixed A5 offsets are well-documented patterns throughout the code.
