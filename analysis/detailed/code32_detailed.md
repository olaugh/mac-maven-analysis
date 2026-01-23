# CODE 32 Detailed Analysis - Move Scoring and Position Tracking

## Overview

| Property | Value |
|----------|-------|
| Size | 6464 bytes |
| JT Offset | 2384 |
| JT Entries | 13 |
| Functions | Multiple (large module) |
| Purpose | **Score move candidates, track best positions, validate moves** |

## Architecture Role

CODE 32 is a core scoring module that:
1. Evaluates potential moves on the board
2. Tracks best positions for horizontal/vertical plays
3. Calculates scores with multipliers and bonuses
4. Maintains position state for move generation

## Key Functions

### Function 0x0000 - Main Move Evaluation
```asm
0000: LINK       A6,#-324             ; frame=324 (large!)
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Clear position tracking globals
0008: CLR.W      -17158(A5)           ; g_best_col
000C: CLR.W      -17160(A5)           ; g_best_col2
0010: CLR.W      -17162(A5)           ; g_best_row
0014: CLR.W      -17164(A5)           ; g_best_row2
0018: CLR.W      -20010(A5)           ; g_tile_count

; Setup from parameter
001C: MOVEQ      #32,D0
001E: ADD.B      8(A6),(A0)           ; Get move descriptor
0022: MOVEA.L    D0,A4

; Check for valid move
0024: TST.B      (A4)
0026: BNE.S      $002E
0028: MOVEQ      #0,D0                ; No move - return 0
002A: BRA.W      $0646

; Get rack pointer
002E: MOVEA.L    -26158(A5),A2        ; A2 = g_rack

; Initialize letter count array (256 bytes at -256(A6))
0032: BRA.S      $0040
0034: MOVEA.L    A6,A0
0036: ADD.W      D6,A0
0038: ADD.W      D6,A0
003A: CLR.W      -256(A0)             ; Clear count for this letter
003E: ADDQ       #1,A2                ; Next rack letter
0040: MOVE.B     (A2),D6
0042: EXT.W      D6
0044: TST.W      D6
0046: BNE.S      $0034                ; Loop through rack

; Process opponent rack similarly
0048: MOVEA.L    12(A6),A2            ; Get opponent rack
004C: BRA.S      $005A
004E: MOVEA.L    A6,A0
0050: ADD.W      D6,A0
0052: ADD.W      D6,A0
0054: ADDQ.W     #1,-256(A0)          ; Increment opponent count
0058: ADDQ       #1,A2
005A: MOVE.B     (A2),D6
005C: EXT.W      D6
005E: TST.W      D6
0060: BNE.S      $004E

; Store initial score state
0062: MOVEA.W    -130(A6),A0          ; Initial score
0066: MOVE.L     A0,-286(A6)
006A: CLR.L      -306(A6)             ; Clear best score

; Initialize iteration
006E: MOVEQ      #0,D5                ; D5 = current index
0070: MOVEQ      #1,D0
0072: MOVE.L     D0,-324(A6)          ; Score multiplier

; Get move position
0076: MOVE.B     (A4),D4              ; D4 = row
0078: EXT.W      D4
007A: MOVEA.L    8(A6),A1
007E: MOVE.B     33(A1),D3            ; D3 = column
0082: EXT.W      D3
0084: MOVEA.L    A1,A2                ; A2 = move struct

; Calculate board array indices
0086: MOVEQ      #17,D1
0088: AND.L      D4,A1                ; Index = row * 17
008A: LEA        -17154(A5),A4        ; A4 = g_state1 (letter board)
008E: ADD.B      A4,(A1)
0090: MOVEA.L    D1,A4

0092: MOVEQ      #17,D1
0094: AND.L      D4,A1
0096: LEA        -26702(A5),A0        ; Letter values table
009A: ADD.B      A0,(A1)
009C: MOVE.L     D1,-302(A6)

00A0: MOVEQ      #17,D2
00A2: AND.L      D4,A2
00A4: LEA        -27246(A5),A0        ; Letter score table
00A8: ADD.B      A0,(A2)
00AA: MOVE.L     D2,-298(A6)

; Set direction markers (-1/+1 for row/col movement)
00AE: MOVEQ      #-1,D0
00B0: ADD.B      D4,A0
00B2: MOVE.W     D0,-310(A6)          ; Row direction = -1

00B6: MOVEQ      #-1,D0
00B8: ADD.B      D4,A0
00BA: ...                             ; (Complex index calculation)
00C4: MOVE.L     D0,-270(A6)

00C8: MOVEQ      #1,D0
00CA: ADD.B      D4,A0
00CC: MOVE.W     D0,-314(A6)          ; Row direction = +1
...

; Get g_state2 (score board) pointer
00E2: MOVEQ      #34,D0
00E4: AND.L      D4,A0
00E6: LEA        -16610(A5),A0        ; A0 = g_state2
00EA: ADD.B      A0,(A0)
00EC: MOVE.L     D0,-262(A6)

; Setup column iteration
00F0: MOVEA.W    D3,A0
00F2: ADD.B      A0,$2D48.W
00F6: ...

; Validate board position is empty
00FE: MOVE.B     D6,D0
0100: MOVEA.L    A5,A0
0102: ADD.B      D0,$4A28.W
0106: ...
0108: BMI.S      $010E                ; Valid - continue
010A: JSR        418(A5)              ; JT[418] - error

; Check if position is occupied
010E: TST.B      0(A4,D3.W)           ; Check g_state1[row][col]
0112: BNE.W      $02B8                ; Occupied - skip to next
```

**C equivalent (partial)**:
```c
int evaluate_move(MoveStruct* move, char* rack, char* opp_rack, char* result) {
    int letter_counts[256] = {0};

    // Clear best position tracking
    g_best_col = 0;
    g_best_col2 = 0;
    g_best_row = 0;
    g_best_row2 = 0;
    g_tile_count = 0;

    if (!move->word[0]) {
        return 0;  // Empty move
    }

    // Count letters in player's rack
    for (char* p = g_rack; *p; p++) {
        letter_counts[*p]++;
    }

    // Count opponent's rack
    for (char* p = opp_rack; *p; p++) {
        letter_counts[*p]--;
    }

    int row = move->row;
    int col = move->col;
    int score_mult = 1;

    // Get pointers to board arrays
    char* board = &g_state1[row * 17];
    char* scores = &g_state2[row * 34];

    // Validate position
    if (board[col] != 0) {
        // Position occupied - skip
        goto next_position;
    }

    // ... continue scoring calculation
}
```

### Score Calculation Logic (0x0116-0x02B8)
```asm
; Accumulate score for valid position
0116: MOVE.L     -324(A6),-(A7)       ; Push current score
011A: MOVEA.L    -302(A6),A0          ; Letter values table
011E: MOVE.B     0(A0,D3.W),D0        ; Get letter value
0122: EXT.W      D0
0124: MOVEA.W    D0,A1
0126: MOVE.L     A1,-(A7)             ; Push letter value
0128: JSR        66(A5)               ; JT[66] - multiply
012C: MOVE.L     D0,-324(A6)          ; Store new score

; Increment tile count
0130: ADDQ.W     #1,-20010(A5)        ; g_tile_count++

; Validate tile count (1-7)
0134: CMPI.W     #$0008,-20010(A5)
013A: BGE.S      $0142                ; Error if >= 8
013C: TST.W      -20010(A5)
0140: BGT.S      $0146                ; OK if > 0
0142: JSR        418(A5)              ; JT[418] - bounds error

; Check for cross words
0146: LEA        -256(A6),A3          ; Letter count array
014A: ADD.W      D6,A3
014C: ADD.W      D6,A3
014E: TST.W      (A3)                 ; Check if letter available
0150: BNE.S      $017A                ; Yes - continue

; No letter available - check position limits
0152: MOVE.W     -130(A6),D0          ; Current position
0156: SUBQ.W     #1,-130(A6)          ; Decrement
...

; Calculate cross-word score
017A: SUBQ.W     #1,(A3)              ; Use one letter
...

; Process adjacent squares
0188: MOVEA.L    -298(A6),A0          ; Score lookup table
018C: MOVE.B     0(A0,D3.W),D0        ; Get position score
0190: EXT.W      D0
0192: AND.L      -316(A6),A0          ; Apply multiplier
...

; Check for word multipliers (double/triple word)
019A: CMPI.W     #$0010,D4            ; Check row 16
019E: BEQ.S      $01AA
01A0: MOVEA.L    -270(A6),A0
01A4: TST.B      0(A0,D3.W)           ; Check multiplier square
01A8: BNE.S      $01BE

01AA: CMPI.W     #$000F,D4            ; Check row 15
01AE: BEQ.W      $02E6
01B2: MOVEA.L    -266(A6),A0
01B6: TST.B      0(A0,D3.W)
01BA: BEQ.W      $02E6

; Apply word multiplier
01BE: CLR.L      -320(A6)             ; Clear temp
01C2: MOVE.W     -310(A6),D7          ; Get direction
01C6: EXT.L      D7
01C8: MOVEA.L    -274(A6),A3          ; Score pointer

; Calculate multiplied score
01CC: PEA        $0022.W              ; Push 34 (word mult)
01D0: MOVE.L     D7,-(A7)             ; Push direction
01D2: JSR        66(A5)               ; JT[66] - multiply
01D6: LEA        -16610(A5),A0        ; g_state2
01DA: ADD.B      A0,(A0)
01DC: MOVE.L     D0,-290(A6)

01E0: PEA        $0011.W              ; Push 17
01E4: MOVE.L     D7,-(A7)
01E6: JSR        66(A5)               ; JT[66]
01EA: LEA        -17154(A5),A0        ; g_state1
01EE: ADD.B      A0,(A0)
01F0: MOVE.L     D0,-294(A6)
```

### Bingo Bonus Check (0x0328-0x0338)
```asm
; Check for bingo (all 7 tiles used)
0328: CMPI.W     #$0007,-20010(A5)    ; g_tile_count == 7?
032E: BNE.S      $0336
0330: MOVE.W     #$1388,D0            ; 5000 point bingo bonus!
0334: BRA.S      $0338
0336: MOVEQ      #0,D0                ; No bonus

; Add bonus to score
0338: MOVE.L     D5,-(A7)
033A: MOVE.L     -324(A6),-(A7)       ; Current score
033E: MOVE.L     D0,D1                ; Bonus
0340: JSR        66(A5)               ; JT[66] - add
```

### Best Position Tracking (0x0594-0x05B8)
```asm
; Compare with current best scores and update
0594: CMP.L      -314(A6),(A5)        ; Compare with best1
0598: BGE.S      $05B8                ; Not better - skip

059A: CMP.L      -310(A6),(A5)        ; Compare with best2
059E: BGE.S      $05B0                ; Not better for best2

; Shift best scores down
05A0: MOVE.W     -17160(A5),-17158(A5) ; best_col = best_col2
05A6: MOVE.L     -310(A6),-314(A6)    ; best1 = best2

; Store new best
05AA: MOVE.W     D3,-17160(A5)        ; g_best_col2 = col
05AE: MOVE.L     D5,-310(A6)          ; best2 = score
05B2: BRA.S      $05B8

05B4: MOVE.W     D3,-17158(A5)        ; g_best_col = col
05B8: MOVE.L     D5,-314(A6)          ; best1 = score
```

### Function 0x064C - Filter Positions by Mask
```asm
064C: LINK       A6,#0
0650: MOVEM.L    D7/A2/A3/A4,-(SP)

0654: MOVE.W     8(A6),-(A7)          ; Push filter mask
0658: JSR        354(PC)              ; Internal filter setup

065C: MOVEQ      #0,D7                ; Counter
065E: LEA        -2728(A5),A4         ; A4 = output buffer
0662: LEA        -12804(A5),A3        ; A3 = position list

; Filter loop
0666: MOVE.L     D7,D0
0668: EXT.L      D0
...
0676: BRA.S      $068A

; Check if position matches filter
0678: MOVE.W     8(A6),D0
067C: EXT.L      D0
067E: AND.L      (A2),D0              ; Apply mask
0680: BEQ.S      $0684                ; No match - skip
0682: MOVE.B     (A3),(A4)+           ; Copy to output

0684: ADDQ       #1,A3                ; Next position
0686: ADDQ       #1,D7                ; Increment counter
0688: ADDQ       #4,A2                ; Next mask entry
068A: TST.B      (A3)                 ; End of list?
068C: BNE.S      $0678                ; Continue

068E: CLR.B      (A4)                 ; Null terminate
0690: LEA        -2728(A5),A0         ; Return output buffer
0694: MOVE.L     A0,D0
0696: MOVEM.L    (SP)+,D7/A2/A3/A4
069A: UNLK       A6
069C: RTS
```

**C equivalent**:
```c
char* filter_positions(uint32_t mask) {
    setup_filter(mask);

    char* output = g_filter_buffer;  // A5-2728
    char* positions = g_position_list; // A5-12804
    uint32_t* masks = g_mask_array;

    int i = 0;
    while (*positions) {
        if (masks[i] & mask) {
            *output++ = *positions;
        }
        positions++;
        i++;
    }
    *output = 0;

    return g_filter_buffer;
}
```

### Function 0x069E - Validate Position
```asm
069E: LINK       A6,#-4               ; frame=4
06A2: MOVEM.L    D6/D7/A3/A4,-(SP)

06A6: MOVE.W     16(A6),D7            ; Row
06AA: MOVE.W     18(A6),D6            ; Column

; Check board state
06AE: MOVEQ      #17,D0
06B0: AND.L      D7,A0                ; Index
06B2: LEA        -17154(A5),A0        ; g_state1
06B6: ADD.B      A0,(A0)
06B8: MOVEA.W    D6,A0
06BA: TST.B      0(A0,D0.L)           ; Check if occupied
06BE: BEQ.S      $06C4                ; Empty - OK
06C0: JSR        418(A5)              ; JT[418] - error

; Check boundaries
06C4: CMPI.W     #$0010,D7            ; Row < 16?
06C8: BEQ.S      $06E0
06CA: MOVEQ      #-1,D0
06CC: ADD.B      D7,A0
06CE: ...                             ; Calculate adjacent index
06D6: ADD.B      A0,(A0)
06D8: MOVEA.W    D6,A0
06DA: TST.B      0(A0,D0.L)           ; Check adjacent
06DE: BNE.S      $0700                ; Has adjacent - valid

06E0: CMPI.W     #$000F,D7            ; Row < 15?
06E4: BEQ.S      $06FC
...
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2728 | Filter output buffer |
| A5-12804 | Position list for filtering |
| A5-16610 | g_state2 - Score/multiplier board (17×17×2) |
| A5-17154 | g_state1 - Letter board (17×17) |
| A5-17158 | g_best_col - Best column position |
| A5-17160 | g_best_col2 - Second best column |
| A5-17162 | g_best_row - Best row position |
| A5-17164 | g_best_row2 - Second best row |
| A5-20010 | g_tile_count - Tiles placed in current move |
| A5-26158 | g_rack - Current player's rack |
| A5-26702 | Letter value lookup table |
| A5-27246 | Letter score lookup table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | Multiply/add scores |
| 418 | Error handler |

## Score Calculation Algorithm

1. **Initialize**: Clear position tracking, count rack letters
2. **For each position**:
   - Check if square is empty
   - Look up letter value and position multiplier
   - Calculate base score
   - Check for cross-words (perpendicular words)
   - Apply word multipliers (double/triple word)
3. **Bingo check**: If 7 tiles used, add 5000 point bonus
4. **Track best**: Maintain top 2 positions for each direction
5. **Return**: Best overall score

## Board Layout

The board arrays use 17×17 layout (including boundaries):
- g_state1: Letter at each position (0 = empty)
- g_state2: Score multiplier info (34 bytes per row for word scores)

## Confidence: HIGH

Clear scoring logic with:
- Standard Scrabble scoring structure
- Bingo bonus (5000 points for using all 7 tiles)
- Position tracking for move ordering
- Cross-word score calculation
