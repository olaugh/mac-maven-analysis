# CODE 8 Detailed Analysis - Move Scoring & Cross-Check

## Overview

| Property | Value |
|----------|-------|
| Size | 2,326 bytes |
| JT Offset | 328 |
| JT Entries | 3 |
| Functions | 3 |
| Purpose | **Move scoring, cross-check validation, board state analysis** |


## System Role

**Category**: Game Logic
**Function**: Move Scoring and Validation

Core scoring engine for evaluating moves, validating placements, and applying moves to the board.

## Architecture Role

CODE 8 is responsible for:
1. Calculating scores for potential moves
2. Validating cross-words (perpendicular words)
3. Managing board state arrays for scoring

## Key Functions

### Function 0x0000 - Calculate Move Score
```asm
; From disassembly - main scoring function
0000: 4E56FFC0      LINK       A6,#-64              ; 64 bytes local vars
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; Save registers
0008: 266E0008      MOVEA.L    8(A6),A3             ; A3 = move info structure (MoveInfo*)
000C: 42AEFFDC      CLR.L      -36(A6)              ; total_score = 0
0010: 7E01          MOVEQ      #1,D7                ; D7 = word multiplier (starts at 1)
0012: 42AEFFCC      CLR.L      -52(A6)              ; cross_word_score = 0
0016: 41EB0010      LEA        16(A3),A0            ; A0 = &move->tiles
001A: 2D48FFE4      MOVE.L     A0,-28(A6)           ; Store tiles pointer
001E: 42AB0014      CLR.L      20(A3)               ; move->score = 0
0022: 7000          MOVEQ      #0,D0
0024: 3740001E      MOVE.W     D0,30(A3)            ; move->bingo_flag = 0
...

; Clear blank position tracking globals
003A: 3B40BCFA      MOVE.W     D0,-17158(A5)        ; blank2_col = 0
003E: 3B40BCF8      MOVE.W     D0,-17160(A5)        ; blank1_col = 0
0042: 3B40BCF6      MOVE.W     D0,-17162(A5)        ; blank2_row = 0
0046: 3B40BCF4      MOVE.W     D0,-17164(A5)        ; blank1_row = 0
004A: 3B40B1D6      MOVE.W     D0,-20010(A5)        ; g_tiles_used = 0

; Get move position from structure
004E: 162B0020      MOVE.B     32(A3),D3            ; D3 = move->row
0052: 4A03          TST.B      D3
0054: 67000312      BEQ.W      $036A                ; If no position, skip to end

; Check direction: row < 16 means horizontal, >= 16 means vertical
005C: 0C030010      CMPI.B     #16,D3
0060: 6C24          BGE.S      $0086                ; If row >= 16, vertical move

; Horizontal move setup
0062: 1C2B0021      MOVE.B     33(A3),D6            ; D6 = move->col
0066: 4886          EXT.W      D6
0068: 48C6          EXT.L      D6
; ... calculate horizontal offset
007E: 7201          MOVEQ      #1,D1
0080: 2D41FFD0      MOVE.L     D1,-48(A6)           ; step = 1 (horizontal)
0084: 602C          BRA.S      $00B2

; Vertical move setup
0086: 1C2B0021      MOVE.B     33(A3),D6            ; D6 = move->col
008E: 48780011      PEA        $0011.W              ; Push 17
0092: 2F06          MOVE.L     D6,-(A7)
0094: 4EAD0042      JSR        66(A5)               ; JT[66] - multiply (col * 17)
; ... adjust row and calculate offset
00AC: 7211          MOVEQ      #17,D1
00AE: 2D41FFD0      MOVE.L     D1,-48(A6)           ; step = 17 (vertical stride)

; Main scoring loop
00B2: MOVE.B     D3,D4                ; D4 = current position
00B8: MOVE.L     D6,D3
00BA: MOVE.L     A3,-32(A6)
...

; Process each tile in the move
0154: MOVEA.L    -12(A6),A0           ; A0 = board ptr
0158: TST.B      0(A0,D3.L)           ; Check if square empty
015C: BNE.W      $02CE                ; If occupied, process differently

; New tile placement
0160: ADDQ.W     #1,-20010(A5)        ; Increment tile count
0164: MOVEA.L    -20(A6),A0           ; Get letter data
0168: MOVE.B     0(A0,D3.L),D0
016E: MOVEA.W    D0,A1
0170: MOVE.L     A1,-(A7)
0172: MOVE.L     D7,-(A7)
0174: JSR        66(A5)               ; JT[66] - add to word score
...

; Check for blank tile ('?')
018C: TST.W      -17164(A5)
0190: BNE.S      $019E                ; If already have first blank
0192: MOVE.W     -54(A6),-17164(A5)   ; Store position
0198: MOVE.W     D3,-17160(A5)
019C: BRA.S      $01A8
019E: MOVE.W     -54(A6),-17162(A5)   ; Store second blank
01A4: MOVE.W     D3,-17158(A5)
01A8: MOVEQ      #63,D6               ; D6 = 63 (blank value)

; Get letter score
01AA: MOVEA.L    A5,A0
01AC: ADDA.L     D6,A0
01B0: MOVE.W     -37682(A0),-56(A6)   ; Get base score

; Get position multiplier
01B6: MOVEA.L    -16(A6),A0
01BA: MOVE.B     0(A0,D3.L),D0        ; Get square type
01BE: EXT.W      D0
01C0: MULU.W     -56(A6),D0           ; Multiply score
01C6: EXT.L      D0
01C6: ADD.L      D0,-36(A6)           ; Add to total

; Check for double/triple word
01CE: CMPI.W     #16,D4               ; Check position
01D0: BEQ.S      $01DA
01D2: MOVEA.L    -8(A6),A0            ; Check cross position
01D4: TST.B      0(A0,D3.L)
01D8: BNE.S      $01EE                ; Has cross letter

; Check for cross-words
01DA: MOVEQ      #15,D0
01DC: CMP.W      D4,D0
01DE: BEQ.W      $02EA
01E2: MOVEA.L    -4(A6),A0
01E6: TST.B      0(A0,D3.L)
01EA: BEQ.W      $02EA                ; No cross-word

; Calculate cross-word score
01EE: CLR.L      -60(A6)              ; cross_score = 0
01F2: MOVE.L     D4,D5
01F4: SUBQ.L     #1,D5
01F8: PEA        $0022.W              ; Push 34
01FE: MOVE.L     D5,-(A7)
0200: JSR        66(A5)               ; Calculate offset
0204: LEA        -16610(A5),A4        ; g_state2
020A: ADDA.W     D0,A4

; Scan backward to start of cross-word
020C: PEA        $0011.W
0210: MOVE.L     D5,-(A7)
0212: JSR        66(A5)
0216: LEA        -17154(A5),A0        ; g_state1
021A: ADDA.W     D0,A0
021C: MOVE.L     A0,-64(A6)
0220: BRA.S      $023A

; Backward scan loop
0222: MOVEA.L    A4,A0
0224: ADDA.L     A2,A0
0228: MOVE.B     (A0),D0
022A: EXT.L      D0
022A: ADD.L      D0,-60(A6)           ; Add letter score
0230: SUBQ.L     #1,D5
0234: LEA        -34(A4),A4           ; Move back one row
...

; Forward scan for rest of cross-word
024A: MOVE.L     D4,D5
024C: ADDQ.L     #1,D5
...

; Sum cross-word scores
02B0: MOVEA.L    -20(A6),A0
02A2: MOVE.B     0(A0,D3.L),D0
02A6: EXT.W      D0
02A8: MOVEA.W    D0,A1
02AA: MOVE.L     A1,-(A7)
...
02C0: JSR        66(A5)               ; Add to total
02C6: ADD.L      D0,-52(A6)           ; Add cross-word score
02CC: ...

; Check for BINGO (all 7 tiles used)
; From disassembly:
0336: 486DC366      PEA        -15514(A5)           ; Push g_field_14 (rack)
033A: 4EAD0DC2      JSR        3522(A5)             ; JT[3522] - strlen (get rack length)
033E: 306DB1D6      MOVEA.W    -20010(A5),A0        ; A0 = g_tiles_used
0344: B088          CMP.W      A0,D0                ; Compare tiles used with rack size
0346: 588F          ADDQ.L     #4,A7                ; Clean stack
0348: 6616          BNE.S      $0360                ; Not all tiles used

034A: 0C6D0007B1D6  CMPI.W     #7,-20010(A5)        ; tiles_used == 7?
0350: 6608          BNE.S      $035A                ; No, skip bonus
0352: 06AE00001388FFCC  ADDI.L #5000,-52(A6)       ; Add 50-point BINGO bonus (5000 = 50*100 internal scale)
035A: 377C0001001C  MOVE.W     #1,28(A3)            ; move->bingo_flag = 1

; Store final score in result structure
0360: 206EFFE4      MOVEA.L    -28(A6),A0           ; A0 = result pointer
0364: 20AEFFCC      MOVE.L     -52(A6),(A0)         ; *result = total_score
0368: 4CDF1CF8      MOVEM.L    (SP)+,D3-D7/A2-A4   ; Restore registers
036C: 4E5E          UNLK       A6
036E: 4E75          RTS
```

**C equivalent**:
```c
typedef struct {
    // ... other fields
    char tiles[17];      // Offset 16
    long score;          // Offset 20
    short flags;         // Offset 28
    short bingo;         // Offset 30
    char row;            // Offset 32
    char col;            // Offset 33
} MoveInfo;

void calculate_score(MoveInfo* move) {
    long total_score = 0;
    long cross_scores = 0;
    int tiles_used = 0;
    int direction = (move->row < 16) ? 1 : 17;  // h or v

    for (int i = 0; i < strlen(move->tiles); i++) {
        int pos = get_position(move->row, move->col, i, direction);

        if (board_empty(pos)) {
            tiles_used++;
            int letter_score = get_letter_value(move->tiles[i]);
            int multiplier = get_square_multiplier(pos);
            total_score += letter_score * multiplier;

            // Check cross-words
            long cross = calculate_cross_word(pos, direction);
            cross_scores += cross;
        }
    }

    // BINGO bonus
    if (tiles_used == 7) {
        total_score += 5000;  // 50 points * 100
        move->bingo = 1;
    }

    move->score = total_score + cross_scores;
}
```

### Function 0x0370 - Validate Move Placement
```asm
0370: LINK       A6,#-152             ; 152 bytes local
0374: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0378: MOVEQ      #1,D7                ; D7 = valid flag
037A: CLR.W      -140(A6)             ; Clear various flags
...
0392: PEA        -15514(A5)           ; g_field_14
0396: JSR        2410(A5)             ; JT[2410] - init

; Check each position
03AA: MOVEQ      #1,D3                ; D3 = column
03AC: MOVE.L     A3,-134(A6)
...

; Validate letter against rack
03C2: TST.B      (A4)                 ; Empty square?
03C0: BEQ.S      $0420                ; Skip

; Check if letter is available
03E6: MOVEQ      #0,D7                ; Assume invalid
03E8: MOVEA.L    A4,A2
03EA: MOVE.B     0(A2,D3.W),D0
03EE: EXT.W      D0
03F0: MOVE.W     D0,-(A7)
03F2: JSR        3554(A5)             ; toupper
03F6: MOVE.W     D0,D5
03F8: LEA        -23218(A5),A0        ; Letter table
03FC: ADDA.W     D5,A0
03FE: MOVE.L     A0,-138(A6)
0402: TST.B      (A0)                 ; Letter available?
0408: BNE.S      $041A                ; Yes
040A: TST.B      -23155(A5)           ; Blank available?
040E: BNE.S      $0414
0410: MOVEQ      #0,D0                ; Invalid move
0414: SUBQ.B     #1,-23155(A5)        ; Use blank
0418: BRA.S      $0420
041A: MOVEA.L    -138(A6),A0
041E: SUBQ.B     #1,(A0)              ; Use letter
...

; Check word validity in dictionary
0476: PEA        $0022.W              ; Push 34
047A: PEA        -23090(A5)           ; g_dawg_info
047E: JSR        426(A5)              ; memset
0486: PEA        -22706(A5)           ; Another buffer
048A: PEA        -23090(A5)           ; g_dawg_info
048E: JSR        2034(A5)             ; JT[2034] - copy
0492: MOVEQ      #1,D0                ; Return valid
...
```

### Function 0x0714 - Apply Move to Board
```asm
0714: LINK       A6,#-140
0718: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
071C: MOVEA.L    8(A6),A4             ; A4 = move info
0720: TST.B      32(A4)               ; Check if move exists
0724: BNE.S      $0766                ; Has move

; No move - copy to result
0726: TST.W      14(A6)               ; Debug mode?
072A: BEQ.S      $0756
072C: PEA        -23090(A5)           ; g_dawg_info
0730: JSR        3522(A5)             ; strlen
0736: PEA        -28302(A5)           ; Format string
073A: PEA        -132(A6)             ; Output buffer
073E: JSR        2066(A5)             ; sprintf
...

; Has move - apply to board
0766: CMPI.B     #16,32(A4)           ; Check direction
076C: BGE.S      $0782                ; Vertical
076E: MOVE.B     32(A4),D7            ; Horizontal: D7 = row
0774: MOVE.B     33(A4),D6            ; D6 = column
077C: MOVEQ      #0,D5                ; step = 0 (horizontal)
0780: BRA.S      $0798
0782: MOVE.B     33(A4),D7            ; Vertical: D7 = column
0788: MOVE.B     32(A4),D6            ; D6 = row - 16
078E: ADDI.W     #-15,D6              ; Adjust
0792: MOVEQ      #1,D5                ; step = 1 (vertical)

; Update board position
07C8: MOVEQ      #17,D0
07CA: MULU.W     D7,D0
07CC: LEA        -10388(A5),A0        ; g_lookup_tbl
07D0: ADDA.W     D0,A0
07D2: MOVEA.W    D6,A0
07D4: TST.B      0(A0,D0.L)           ; Already has tile?
07D8: BNE.S      $07FC                ; Skip

; Place new tile
07DA: MOVEQ      #17,D0
07DC: MULU.W     D7,D0
07DE: LEA        -10388(A5),A0
07E2: ADDA.W     D0,A0
07E4: MOVEA.W    D6,A0
07E6: MOVEQ      #17,D1
07E8: MULU.W     D7,D1
07EA: LEA        -10099(A5),A1        ; Source board
...
0844: MOVE.B     D0,0(A0,D1.L)        ; Write to board

; Update display
0870: MOVE.W     D6,-(A7)             ; Push col
086E: MOVE.W     D7,-(A7)             ; Push row
0870: JSR        986(A5)              ; JT[986] - update_cell
...

; Copy lookup table for next iteration
08F4: PEA        $0121.W              ; 289 bytes
08F8: PEA        -10388(A5)           ; g_lookup_tbl
08FC: PEA        -10099(A5)           ; Source
0900: JSR        3466(A5)             ; memcpy
0904: JSR        1338(A5)             ; JT[1338]
0908: JSR        962(A5)              ; JT[962] - redraw
...
```

## Scoring System

### Letter Values (from code analysis)
The scores appear to be stored at A5-37682 (letter_scores table).

### Square Multipliers
| Type | Value |
|------|-------|
| Normal | 1 |
| Double Letter | 2 |
| Triple Letter | 3 |
| Double Word | 2× total |
| Triple Word | 3× total |

### BINGO Bonus
When all 7 tiles are used, a bonus of 5000 points (50 × 100 internal scaling) is added.

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-10099 | Source board array |
| A5-10388 | g_lookup_tbl (17×17 board) |
| A5-15514 | g_field_14 |
| A5-16610 | g_state2 (scoring data) |
| A5-17154 | g_state1 (scoring data) |
| A5-17158 | Blank position 2 column |
| A5-17160 | Blank position 1 column |
| A5-17162 | Blank position 2 row |
| A5-17164 | Blank position 1 row |
| A5-20010 | Tiles used counter |
| A5-22706 | Working buffer |
| A5-23090 | g_dawg_info |
| A5-23155 | Blank tiles remaining |
| A5-23218 | Letter availability table |
| A5-37682 | Letter score table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | Multiply/offset calculation |
| 418 | bounds_check |
| 426 | memset |
| 962 | Redraw board |
| 986 | Update cell display |
| 1338 | Board update |
| 2034 | Copy structure |
| 2410 | Init board |
| 3466 | memcpy |
| 3522 | strlen |
| 3554 | toupper |

## Confidence: HIGH

The scoring logic is clear:
- Letter × position multiplier
- Cross-word calculation
- 7-tile BINGO bonus
- Board update sequence

---

## Speculative C Translation

```c
/* CODE 8 - Speculative C Translation */
/* Move Scoring & Cross-Check Validation */

/*============================================================
 * Data Structures
 *============================================================*/

/* Move information structure */
typedef struct MoveInfo {
    char unknown[16];                /* Offset 0-15: unknown fields */
    char tiles[17];                  /* Offset 16: tiles to play */
    long score;                      /* Offset 20: calculated score */
    short reserved;                  /* Offset 24 */
    short reserved2;                 /* Offset 26 */
    short flags;                     /* Offset 28: move flags */
    short bingo_flag;                /* Offset 30: 1 if used all 7 tiles */
    char row;                        /* Offset 32: row (or row+16 for vertical) */
    char col;                        /* Offset 33: column */
} MoveInfo;

/*============================================================
 * Global Variables
 *============================================================*/
extern char g_board[17][17];         /* A5-10388: 17x17 board grid */
extern char g_board_source[17][17];  /* A5-10099: source/backup board */
extern char g_state1[544];           /* A5-17154: scoring state 1 */
extern char g_state2[1088];          /* A5-16610: scoring state 2 */
extern char g_rack[];                /* A5-15514: current rack */
extern short g_letter_scores[64];    /* A5-37682: point values per letter */
extern char g_letter_avail[64];      /* A5-23218: tiles remaining per letter */
extern char g_blank_count;           /* A5-23155: blanks remaining */
extern short g_tiles_used;           /* A5-20010: tiles placed this move */
extern short g_blank1_row;           /* A5-17164: first blank position */
extern short g_blank1_col;           /* A5-17160 */
extern short g_blank2_row;           /* A5-17162: second blank position */
extern short g_blank2_col;           /* A5-17158 */

/* Internal score scaling: scores are *100 internally */
#define BINGO_BONUS 5000             /* 50 points * 100 */

/*============================================================
 * Function 0x0000 - Calculate Move Score
 * JT offset: 328(A5)
 * Frame size: 64 bytes
 *============================================================*/
void calculate_move_score(MoveInfo *move /* 8(A6), stored in A3 */) {
    /* Local variables */
    long main_word_score = 0;        /* -36(A6) */
    long cross_word_total = 0;       /* -52(A6) */
    int word_multiplier = 1;         /* D7 */
    char *tiles_ptr = move->tiles;   /* -28(A6) */
    int step;                        /* -48(A6): 1 for horiz, 17 for vert */
    int current_pos;                 /* D3 */
    int row_or_col;                  /* D4 */

    /* Initialize move result fields */
    move->score = 0;                 /* CLR.L 20(A3) at 0x001E */
    move->bingo_flag = 0;            /* MOVE.W #0,30(A3) at 0x0024 */

    /* Clear blank position tracking */
    g_blank1_row = 0;                /* A5-17164 */
    g_blank1_col = 0;                /* A5-17160 */
    g_blank2_row = 0;                /* A5-17162 */
    g_blank2_col = 0;                /* A5-17158 */
    g_tiles_used = 0;                /* A5-20010 */

    /* Get starting position */
    char start_row = move->row;      /* offset 32 */
    if (start_row == 0) {            /* TST.B D3; BEQ at 0x0054 */
        return;  /* No move to score */
    }

    /*
     * Direction encoding:
     * - row < 16: Horizontal move (step = 1)
     * - row >= 16: Vertical move (step = 17, actual row = row - 16)
     */
    if (start_row < 16) {            /* CMPI.B #16,D3 at 0x005C */
        /* Horizontal move */
        current_pos = start_row * 17 + move->col;
        step = 1;                    /* MOVEQ #1,D1 at 0x007E */
        row_or_col = start_row;
    } else {
        /* Vertical move */
        int actual_row = start_row - 16;
        current_pos = move->col * 17 + actual_row;
        step = 17;                   /* MOVEQ #17,D1 at 0x00AC */
        row_or_col = move->col;
    }

    /* Process each tile in the move */
    int tile_index = 0;
    while (tiles_ptr[tile_index] != '\0') {
        char tile = tiles_ptr[tile_index];

        /* Check if this square is empty (new tile placement) */
        if (g_board[current_pos / 17][current_pos % 17] == 0) {
            /* New tile - count it */
            g_tiles_used++;          /* ADDQ.W #1 at 0x0160 */

            /* Get letter value */
            int letter_index = tile;
            if (tile == '?') {       /* Blank tile */
                /* Track blank positions */
                if (g_blank1_row == 0) {
                    g_blank1_row = current_pos / 17;
                    g_blank1_col = current_pos % 17;
                } else {
                    g_blank2_row = current_pos / 17;
                    g_blank2_col = current_pos % 17;
                }
                letter_index = 63;   /* Blank has index 63 */
            }

            /* Get base letter score */
            short letter_score = g_letter_scores[letter_index];

            /* Get square multiplier (DL=2, TL=3, etc) */
            /* uncertain: exact lookup method */
            int square_mult = get_square_letter_multiplier(current_pos);
            main_word_score += letter_score * square_mult;

            /* Check for word multiplier squares (DW, TW) */
            int word_mult = get_square_word_multiplier(current_pos);
            word_multiplier *= word_mult;

            /* Calculate cross-word score if applicable */
            long cross_score = calculate_cross_word_score(
                current_pos,
                step == 1 ? 17 : 1,  /* perpendicular direction */
                letter_score
            );
            cross_word_total += cross_score;
        }

        /* Move to next position */
        current_pos += step;
        tile_index++;
    }

    /* Apply word multiplier to main word */
    main_word_score *= word_multiplier;

    /* Check for BINGO (all 7 tiles used) */
    short rack_length = strlen(g_rack);  /* JT[3522] at 0x033A */

    if (g_tiles_used == rack_length) {   /* All rack tiles used */
        if (g_tiles_used == 7) {         /* CMPI.W #7 at 0x034A */
            cross_word_total += BINGO_BONUS;  /* Add 50-point bonus */
        }
        move->bingo_flag = 1;            /* Mark as bingo */
    }

    /* Store final score */
    move->score = main_word_score + cross_word_total;
}

/*============================================================
 * Cross-Word Score Calculation Helper
 *============================================================*/
static long calculate_cross_word_score(
    int main_pos,                    /* Position of new tile */
    int cross_step,                  /* Step in perpendicular direction */
    short new_tile_score             /* Score of the new tile */
) {
    long cross_score = 0;
    int pos;

    /* Scan backward to find start of cross-word */
    pos = main_pos - cross_step;
    while (pos >= 0 && g_board[pos / 17][pos % 17] != 0) {
        /* Add existing tile's score */
        /* uncertain: exact score lookup */
        cross_score += g_state2[(pos - 1) * 34];  /* approximate */
        pos -= cross_step;
    }

    /* Scan forward to find end of cross-word */
    pos = main_pos + cross_step;
    while (pos < 289 && g_board[pos / 17][pos % 17] != 0) {
        /* Add existing tile's score */
        cross_score += g_state2[(pos - 1) * 34];
        pos += cross_step;
    }

    /* If there were adjacent tiles, this forms a cross-word */
    if (cross_score > 0) {
        /* Add the new tile's contribution */
        /* Note: letter multipliers apply, but word multipliers don't
           affect existing tiles in cross-words */
        cross_score += new_tile_score;
    }

    return cross_score;
}

/*============================================================
 * Function 0x0370 - Validate Move Placement
 * JT offset: 336(A5)
 * Frame size: 152 bytes
 *============================================================*/
short validate_move_placement(MoveInfo *move /* 8(A6) */) {
    short valid = 1;                 /* D7 = 1 initially */
    char local_avail[64];            /* Local copy of letter availability */

    /* Initialize validation state */
    setup_validation(&g_rack);       /* JT[2410] at 0x0396 */

    /* Copy letter availability for tracking */
    memcpy(local_avail, g_letter_avail, 64);

    /* Check each tile in the move */
    for (int i = 0; move->tiles[i] != '\0'; i++) {
        char tile = move->tiles[i];
        char upper_tile = toupper(tile);  /* JT[3554] at 0x03F2 */

        /* Check if this letter is available in rack */
        if (local_avail[upper_tile] > 0) {
            /* Use a regular tile */
            local_avail[upper_tile]--;    /* SUBQ.B #1 at 0x041E */
        }
        else if (g_blank_count > 0) {
            /* Use a blank tile */
            g_blank_count--;              /* SUBQ.B #1 at 0x0414 */
        }
        else {
            /* No tile available - invalid move */
            valid = 0;                    /* MOVEQ #0,D7 at 0x03E6 */
            break;
        }
    }

    /* If tiles are valid, check word in dictionary */
    if (valid) {
        /* Clear DAWG info structure */
        memset(&g_dawg_info, 0, 34);     /* JT[426] at 0x047E */

        /* Perform dictionary lookup */
        valid = check_word_in_dawg(move->tiles);  /* uncertain */
    }

    return valid;
}

/*============================================================
 * Function 0x0714 - Apply Move to Board
 * JT offset: 344(A5)
 * Frame size: 140 bytes
 *============================================================*/
void apply_move_to_board(
    MoveInfo *move,                  /* 8(A6), stored in A4 */
    short update_display,            /* 12(A6) */
    short debug_mode                 /* 14(A6) */
) {
    char output_buffer[132];         /* -132(A6) */
    int row, col, step;

    /* Check if move exists */
    if (move->row == 0) {            /* TST.B 32(A4) at 0x0720 */
        /* No move - possibly output debug info */
        if (debug_mode) {            /* TST.W 14(A6) at 0x0726 */
            short len = strlen(g_dawg_info);  /* JT[3522] */
            sprintf(output_buffer, g_format_str, /* ... */);  /* JT[2066] */
        }
        return;
    }

    /* Decode position and direction */
    if (move->row < 16) {            /* CMPI.B #16 at 0x0766 */
        /* Horizontal move */
        row = move->row;             /* D7 = row */
        col = move->col;             /* D6 = col */
        step = 0;                    /* D5 = 0 (horizontal step indicator) */
    } else {
        /* Vertical move */
        col = move->col;             /* D7 = col (used as row for calc) */
        row = move->row - 16 + 1;    /* D6 = actual row (adjusted) */
        step = 1;                    /* D5 = 1 (vertical step indicator) */
    }

    /* Place each tile on the board */
    int tile_idx = 0;
    while (move->tiles[tile_idx] != '\0') {
        /* Calculate board position: row * 17 + col */
        int board_offset = row * 17 + col;

        /* Check if square is empty */
        if (g_board[row][col] == 0) {   /* TST.B at 0x07D4 */
            /* Place new tile */
            g_board[row][col] = move->tiles[tile_idx];  /* MOVE.B at 0x0844 */

            /* Update display for this cell */
            update_cell_display(row, col);   /* JT[986] at 0x0870 */
        }

        /* Advance to next position */
        if (step == 0) {
            col++;  /* Horizontal: move right */
        } else {
            row++;  /* Vertical: move down */
        }
        tile_idx++;
    }

    /* Copy board state for next iteration */
    memcpy(g_board, g_board_source, 289);  /* JT[3466] at 0x0900 */

    /* Update game state */
    update_board_state();            /* JT[1338] at 0x0904 */

    /* Redraw entire board */
    redraw_board();                  /* JT[962] at 0x0908 */
}

/*============================================================
 * Scrabble Scoring Summary
 *
 * Letter scores (standard US Scrabble):
 *   1 point:  A, E, I, O, U, L, N, S, T, R
 *   2 points: D, G
 *   3 points: B, C, M, P
 *   4 points: F, H, V, W, Y
 *   5 points: K
 *   8 points: J, X
 *   10 points: Q, Z
 *   0 points: Blank (?)
 *
 * Board multipliers:
 *   DL (Double Letter): 2x letter score
 *   TL (Triple Letter): 3x letter score
 *   DW (Double Word):   2x word score
 *   TW (Triple Word):   3x word score
 *
 * Bingo bonus: 50 points for using all 7 tiles
 *============================================================*/
```
