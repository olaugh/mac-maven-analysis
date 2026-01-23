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

Largest CODE (13722 bytes), main event/game loop

**Related CODE resources**:
- CODE 11 (controller)
- CODE 6 (windows)
- CODE 8 (menus)
## Architecture Role

CODE 21 is the **largest CODE resource** and the main game interface:
1. Board display and tile placement
2. Rack management (7 tiles)
3. Turn processing
4. Move validation and scoring
5. Game flow coordination

## Key Data Structures

### Rack Structure (at A5-8664)
```c
struct RackEntry {
    short tile_value;    // Offset 0: Letter value (1-26, 0=blank)
    short played_flag;   // Offset 2: Non-zero if played this turn
};
// 7 entries × 4 bytes = 28 bytes at A5-8664 (g_flag1)
```

### Board Arrays
- **g_lookup_tbl** (A5-10388): 17×17 = 289 bytes - current board state
- **A5-10371**: 17×17 working array
- **A5-10082**: 17×17 working array
- **A5-27229**: Some mapping array

## Key Functions

### Function 0x0000 - Copy Rack to Buffer
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
0008: MOVE.L     8(A6),-(A7)          ; Push destination
000C: JSR        2410(A5)             ; JT[2410] - init buffer
0010: MOVEA.L    8(A6),A3             ; A3 = destination
0014: MOVEA.L    -8584(A5),A0         ; A0 = main handle
0018: MOVEA.L    (A0),A4              ; A4 = *handle
001A: LEA        786(A4),A4           ; A4 = rack data at offset 786
001E: LEA        12(A7),A7

0020: BRA.S      $003C                ; Jump into loop
0022: MOVEQ      #0,D6                ; D6 = 0
0024: LEA        -23218(A5),A2        ; A2 = letter mapping table
0028: ADD.W      D7,A2                ; Index into table
002A: BRA.S      $0032
002C: MOVE.B     D7,(A3)              ; Store character
002E: ADDQ.W     #1,D6                ; D6++
0030: ADDQ.L     #1,A3                ; A3++
0032: MOVE.B     (A2),D0              ; Get mapped value
0034: EXT.W      D0
0036: CMP.W      D6,D0                ; While D6 < mapped value
0038: BGT.S      $002C
003A: ADDQ.L     #1,A4                ; Next rack entry
003C: MOVE.B     (A4),D7              ; Get tile from rack
003E: EXT.W      D7
0040: TST.W      D7                   ; While not zero
0042: BNE.S      $0022
0044: CLR.B      (A3)                 ; Null terminate
004C: RTS
```

**Purpose**: Convert rack tiles to ASCII string for display.

### Function 0x004E - Initialize Board Display
```asm
004E: LINK       A6,#-4
0052: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
0056: PEA        -15514(A5)           ; Push g_field_14
005A: JSR        -92(PC)              ; Copy rack to buffer
005E: MOVEQ      #0,D6                ; D6 = 0 (index)
0060: LEA        -8664(A5),A4         ; A4 = g_flag1 (rack)
0064: LEA        12(A7),A7
0066: BRA.S      $0090

; Process each rack position
0068: PEA        -15514(A5)           ; Push g_field_14
006C: JSR        3522(A5)             ; JT[3522] - get length
0070: CMP.W      D6,D0                ; Compare with index
0076: BLS.S      $007C                ; If <= index
0078: CLR.W      (A4)                 ; Clear rack entry
007A: BRA.S      $0088
007C: MOVEA.L    A5,A0                ; Get character from g_field_14
007E: ADDA.W     D6,A0
0080: MOVE.B     -15514(A0),D0        ; D0 = g_field_14[D6]
0084: EXT.W      D0
0086: MOVE.W     D0,(A4)              ; Store in rack
0088: CLR.W      2(A4)                ; Clear played flag
008C: ADDQ.W     #1,D6                ; D6++
008E: ADDQ.L     #8,A4                ; Next rack entry
0090: CMPI.W     #7,D6                ; While D6 < 7
0094: BLT.S      $0068

0096: CLR.W      -8636(A5)            ; Clear counter
009A: JSR        2890(PC)             ; Update display
...
00F6: RTS
```

### Function 0x00F8 - Place Tile on Board
```asm
00F8: LINK       A6,#-22              ; 22 bytes local
00FC: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0100: MOVE.W     12(A6),D3            ; D3 = tile value
0104: TST.W      -9810(A5)            ; Check game state
0108: BNE.W      $0432                ; If game over, skip

; Calculate board position
010C: MOVEQ      #17,D0
010E: MULU.W     8(A6),D0             ; D0 = row * 17
0112: ADD.W      A5,D0
0114: MOVEA.W    10(A6),A4            ; A4 = column
0118: LEA        -10099(A4),A4        ; A4 points to board position
011C: ADDA.W     D0,A4

; Check if square occupied
0120: TST.B      (A4)                 ; Test current value
0122: BNE.S      $0146                ; If not empty, handle overlap

; Tile placement validation
0124: MOVE.B     (A4),D0              ; Get current tile
0126: EXT.W      D0
0128: MOVE.W     D0,-(A7)
012A: JSR        3554(A5)             ; JT[3554] - convert to uppercase
012E: MOVE.W     D0,-22(A6)           ; Store converted
0132: MOVE.W     D3,-(A7)
0134: JSR        3554(A5)             ; Convert param tile
0138: CMP.W      -22(A6),D0           ; Compare
013E: BEQ.S      $0146                ; If same, OK
0140: MOVEQ      #0,D0                ; Return 0 (failure)
0142: BRA.W      $0452

; Place the tile
0146: MOVE.W     D3,-(A7)
0148: JSR        3554(A5)             ; Convert
...
0170: PEA        -15514(A5)           ; g_field_14
0174: JSR        2410(A5)             ; JT[2410]

; Update rack - find matching tile
01E8: MOVE.B     (A2),D0              ; Get mapped letter
01EA: EXT.W      D0
01EC: MOVE.W     D0,-(A7)
01EE: JSR        3554(A5)             ; Convert
01F2: MOVEA.L    A5,A0
...
020E: TST.B      -23155(A5)           ; Check blank flag
0212: BNE.S      $0226
0214: MOVE.B     -23155(A5),-(A1)     ; Update blank count
...

; Update scoring arrays
036E: MOVE.B     D3,(A4)              ; Place tile on board
0370: MOVEQ      #17,D0
0372: MULU.W     D6,D0                ; row * 17
0374: LEA        -10388(A5),A4        ; g_lookup_tbl
0378: ADDA.W     D0,A4
037A: MOVEA.W    D7,A4
...
0390: JSR        986(A5)              ; JT[986] - update display
...
044E: MOVEQ      #1,D0                ; Return 1 (success)
0452: RTS
```

**C equivalent**:
```c
int place_tile(int row, int col, int tile) {
    if (g_game_over) return 0;

    char* board_pos = &g_board[row * 17 + col];

    // Check if square is already occupied
    if (*board_pos != 0) {
        // Verify placed tile matches
        if (toupper(*board_pos) != toupper(tile)) {
            return 0;  // Conflict
        }
    }

    // Place tile
    *board_pos = tile;

    // Update lookup table
    g_lookup_tbl[row * 17 + col] = tile;

    // Mark rack tile as played
    for (int i = 0; i < 7; i++) {
        if (g_rack[i].value == tile && !g_rack[i].played) {
            g_rack[i].played = 1;
            break;
        }
    }

    update_display(row, col);
    return 1;
}
```

### Function 0x05FA - Validate and Score Move
```asm
05FA: LINK       A6,#0
05FE: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
0602: MOVEA.L    8(A6),A4             ; A4 = word string
0606: MOVE.L     A4,-(A7)
0608: JSR        3522(A5)             ; Get string length
060C: TST.W      D0
0614: BLS.S      $0616                ; If length <= 7
0612: MOVEQ      #0,D0                ; Return 0
0614: BRA.S      $0678

; Process each character
0616: MOVEQ      #0,D7
0618: LEA        -8664(A5),A3         ; g_flag1 (rack)
061C: MOVE.B     0(A4,D7.W),D6        ; Get character
0620: MOVEA.W    D7,A2
...
; Validate character is in rack
0628: MOVEQ      #0,D0
062A: MOVE.B     D6,D0
062C: MOVEA.L    A5,A0
062E: ADDA.L     D0,A0
0632: TST.B      -4056(A0)            ; Check tile table
0638: AND.B      #$C0,D0              ; Check if valid
063E: BNE.S      $0644
0640: JSR        418(A5)              ; Error - invalid tile

; Mark tile as used
0644: MOVE.B     (A2),D0
0646: EXT.W      D0
0648: MOVE.W     D0,-(A7)
064A: JSR        3554(A5)             ; Convert
064E: MOVE.W     D0,(A3)              ; Store in rack entry
0652: ADDQ.W     #1,D7
0656: ADDQ.L     #8,A3
065A: BRA.S      $061C                ; Loop

; Check word in dictionary
0658: MOVE.W     #$03FF,-(A7)         ; Push error code
065C: JSR        1418(A5)             ; JT[1418] - check word
0660: TST.W      D0
0666: BNE.S      $066A
0668: MOVEQ      #0,D0                ; Word not found
066A: BRA.S      $0678

066C: CLR.L      -(A7)
066E: MOVE.L     A4,-(A7)
0672: JSR        -170(PC)             ; Calculate score
0676: MOVE.L     D0,(A7)
0678: RTS
```

### Function 0x07EC - Start AI Turn
```asm
07EC: CLR.W      -9810(A5)            ; Clear game-over flag
07F0: JSR        4362(PC)             ; Get AI move
07F4: MOVE.L     D0,-(A7)             ; Push move
07F6: JSR        4364(PC)             ; Process move
07FA: JSR        4346(PC)             ; Calculate score
07FE: MOVE.L     D0,-8614(A5)         ; Store score
0802: JSR        4204(PC)             ; Update display
0808: RTS
```

### Function 0x080A - Process Player Input
```asm
080A: MOVEM.L    D6/D7/A4,-(SP)
080E: JSR        10382(PC)            ; Check for valid input
0812: TST.W      D0
0814: BNE.S      $0824                ; If not valid
0816: MOVE.W     #$0001,-(A7)         ; Push error code
081A: JSR        262(PC)              ; Show error
0820: BRA.W      $08F6

0824: TST.W      -9810(A5)            ; Check game state
0828: BEQ.W      $08D4                ; If game not over

; Game is in AI mode
082C: JSR        8682(PC)             ; Get AI recommendation
0830: TST.W      D0
0832: BEQ.W      $08F6                ; If no move

0836: TST.B      -15514(A5)           ; Check g_field_14
083A: BNE.S      $0864                ; If has data

; Need to search for moves
083C: CLR.W      -(A7)
083E: JSR        378(A5)              ; JT[378] - init search
0842: TST.W      D0
0848: BEQ.S      $0864

; Found moves - show best
084E: PEA        -23090(A5)           ; g_dawg_info
0852: MOVE.W     #$7FFF,-(A7)         ; Max score
0856: JSR        8616(PC)             ; Get best move
085A: JSR        2736(PC)             ; Display move
...
```

## Key Global Variables

| Offset | Name | Purpose |
|--------|------|---------|
| A5-8620 | g_input_flag | Input pending flag |
| A5-8624 | g_cursor_row | Current cursor row |
| A5-8622 | g_cursor_col | Current cursor column |
| A5-8636 | g_move_count | Moves in current turn |
| A5-8664 | g_flag1 | Rack entries (7 × 4 bytes) |
| A5-9810 | g_game_over | Game over flag |
| A5-10082 | working_array1 | 17×17 working board |
| A5-10371 | working_array2 | 17×17 working board |
| A5-10388 | g_lookup_tbl | 17×17 board state |
| A5-23090 | g_dawg_info | DAWG search info |
| A5-23155 | g_blank_count | Blanks remaining |
| A5-23218 | letter_map | Letter mapping table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 378 | init_search |
| 418 | bounds_check |
| 426 | memset |
| 986 | update_cell_display |
| 1418 | check_word / error_dialog |
| 2402 | process_buffer |
| 2410 | init_buffer |
| 3522 | strlen |
| 3554 | toupper |
| 3562 | tolower |

## Confidence: HIGH

CODE 21 is clearly the main game UI:
- Extensive rack management
- Board placement logic
- Input validation
- Score calculation integration
- AI move display
