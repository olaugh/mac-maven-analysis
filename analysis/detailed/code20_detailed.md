# CODE 20 Detailed Analysis - Board State Management

## Overview

| Property | Value |
|----------|-------|
| Size | 3,398 bytes |
| JT Offset | 928 |
| JT Entries | 17 |
| Functions | 20+ |
| Purpose | **Board state arrays, tile placement, cross-check generation** |

## Architecture Role

CODE 20 manages the Scrabble board state:
1. Initialize board state arrays (17x17 grids)
2. Place and remove tiles
3. Generate cross-check information
4. Track letter multipliers and scoring
5. Coordinate with move validation

## Key Data Structures

### Board State Arrays

| Array | Offset | Size | Purpose |
|-------|--------|------|---------|
| g_state1 | A5-17154 | 0x220 (544 bytes) | Tile letters (17×17×2) |
| g_state2 | A5-16610 | 0x440 (1088 bytes) | Tile scores/state (17×17×4) |
| g_lookup_tbl | A5-10388 | 0x121 (289 bytes) | Cross-check lookups (17×17) |
| (unnamed) | A5-10099 | 0x121 (289 bytes) | Additional cross-check data |

## Key Functions

### Function 0x0000 - Initialize All Board Arrays
```asm
0000: JSR        1306(PC)             ; Internal init
0004: PEA        $0220.W              ; Size = 544 bytes
0008: PEA        -17154(A5)           ; g_state1
000C: JSR        426(A5)              ; JT[426] - memset/clear

0010: PEA        $0121.W              ; Size = 289 bytes
0014: PEA        -10388(A5)           ; g_lookup_tbl
0018: JSR        426(A5)              ; JT[426] - memset

001C: PEA        $0121.W              ; Size = 289 bytes
0020: PEA        -10099(A5)           ; Additional lookup
0024: JSR        426(A5)              ; JT[426] - memset

0028: PEA        $0440.W              ; Size = 1088 bytes
002C: PEA        -16610(A5)           ; g_state2
0030: JSR        426(A5)              ; JT[426] - memset

0034: CLR.W      -9810(A5)            ; Clear validation flag
0038: JSR        658(A5)              ; JT[658]
003C: JSR        1338(A5)             ; JT[1338]
0040: JSR        3252(PC)             ; Internal setup
0044: LEA        32(A7),A7            ; Clean stack
0048: RTS
```

**C equivalent**:
```c
void init_board() {
    internal_init();

    memset(g_state1, 0, 544);     // 17x17 letter grid
    memset(g_lookup_tbl, 0, 289); // Cross-check table
    memset(g_extra_lookup, 0, 289);
    memset(g_state2, 0, 1088);    // Score/state grid

    g_validation_flag = 0;
    setup_function_1();
    setup_function_2();
    post_init();
}
```

### Function 0x004A - Reset Board State
```asm
004A: PEA        $0220.W              ; Size
004E: PEA        -17154(A5)           ; g_state1
0052: JSR        426(A5)              ; Clear state1

0056: PEA        $0440.W              ; Size
005A: PEA        -16610(A5)           ; g_state2
005E: JSR        426(A5)              ; Clear state2

0062: PEA        1090(A5)             ; Some parameter
0066: JSR        942(PC)              ; Internal function
006A: JSR        1338(A5)             ; JT[1338]
006E: LEA        20(A7),A7
0072: RTS
```

### Function 0x0074 - Set Cell Value with Cross-Check
```asm
0074: LINK       A6,#0
0078: MOVEM.L    D6/D7/A3/A4,-(SP)    ; save
007C: MOVE.W     8(A6),D7             ; D7 = row
0080: MOVE.W     10(A6),D6            ; D6 = column

; Calculate index: row * 17 + column
0084: MOVEQ      #17,D0
0086: MULS.W     D7,D0                ; row * 17
0088: LEA        -10388(A5),A4        ; g_lookup_tbl
008C: ADDA.L     D0,A4
008E: MOVEA.W    D6,A4                ; + column
0090: ADDA.L     D0,A4                ; A4 = &lookup[row][col]

; Same for secondary table
0094: MOVEQ      #17,D0
0096: MULS.W     D7,D0
0098: LEA        -10099(A5),A3        ; Secondary lookup
009C: ADDA.L     D0,A3
009E: MOVEA.W    D6,A3
00A0: ADDA.L     D0,A3                ; A3 = &lookup2[row][col]

; Compare values
00A4: MOVE.B     (A4),D0              ; Get lookup value
00A6: CMP.B      (A3),D0              ; Compare with lookup2
00A8: BEQ.S      $00B6                ; If equal, skip update

; Update cross-check
00AA: MOVE.B     (A3),(A4)            ; Copy value
00AC: MOVE.W     D6,-(A7)             ; Push column
00AE: MOVE.W     D7,-(A7)             ; Push row
00B0: JSR        1426(PC)             ; Update cross-check
00B4: ADDQ.L     #4,A7

00B6: MOVEM.L    (SP)+,D6/D7/A3/A4    ; restore
00BA: UNLK       A6
00BC: RTS
```

### Function 0x00BE - Validate Tile Placement
```asm
00BE: LINK       A6,#-8               ; frame=8
00C2: MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)
00C6: MOVEQ      #0,D7                ; Clear counters
00C8: MOVEQ      #0,D6
00CA: CLR.L      -8(A6)
00CE: CLR.L      -4(A6)
00D0: MOVEQ      #0,D5
00D2: LEA        -8664(A5),A4         ; g_flag1 (rack)

; Loop through rack tiles
00D8: MOVE.W     (A4),D4              ; Get tile
00DA: TST.W      D4                   ; End of rack?
00DC: BEQ.S      $0116                ; Yes, exit loop

00DE: MOVE.L     D4,D3
00E0: EXT.L      D3                   ; Extend to long
; ... validation logic ...

0116: PEA        -15514(A5)           ; g_field_14
011A: JSR        3522(A5)             ; JT[3522] - strlen
011E: CMP.L      D5,D0                ; Compare lengths
0122: BEQ.S      $0128                ; Match
0124: MOVEQ      #0,D0                ; Return false
0126: BRA.S      $0188

; More validation
0128: MOVEQ      #0,D5
012A: MOVEA.L    A5,A0
012C: ADDA.L     D5,A0
; ... more checks ...

; Final result
0186: MOVEQ      #1,D0                ; Return true
0188: MOVEM.L    (SP)+,...
018C: UNLK       A6
018E: RTS
```

**Purpose**: Validates that a tile placement uses valid rack letters.

### Function 0x0232 - Check Cell and Update
```asm
0232: LINK       A6,#-4               ; frame=4
0236: TST.W      -9810(A5)            ; Check validation flag
023A: BNE.S      $0262                ; Skip if set

; Calculate cell indices
023C: MOVEQ      #17,D0
023E: MULS.W     8(A6),D0             ; row * 17
0242: ADDA.L     A5,D0
0244: MOVEA.W    10(A6),A0            ; + column
0248: ADDA.L     D0,A0

; Compare lookup tables
024C: MOVEQ      #17,D0
0250: MULS.W     8(A6),D0
0254: ADDA.L     A5,D0
0256: MOVEA.W    10(A6),A1
025A: ADDA.L     D0,A1
025C: MOVE.B     -10099(A1),D0        ; Get lookup2 value
0260: CMP.B      -10388(A0),D0        ; Compare with lookup
0262: BNE.S      $026E                ; If different

; Call update function
0262: MOVE.W     10(A6),-(A7)         ; Push column
0266: MOVE.W     8(A6),-(A7)          ; Push row
026A: JSR        6(PC)                ; Update cell
026E: UNLK       A6
0270: RTS
```

### Function 0x0272 - Place Tile on Board
```asm
0272: LINK       A6,#0
0276: MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)
027A: MOVE.W     8(A6),D6             ; D6 = row
027E: MOVE.W     10(A6),D5            ; D5 = column

; Get current cell value from lookup table
0282: MOVEQ      #17,D0
0284: MULS.W     D6,D0                ; row * 17
0286: LEA        -10388(A5),A0        ; g_lookup_tbl
028A: ADDA.L     D0,A0
028C: MOVEA.W    D5,A0                ; + column
028E: MOVE.B     0(A0,D0.L),D7        ; D7 = current value
0292: EXT.W      D7

; Get secondary lookup value
0294: MOVEQ      #17,D0
0296: MULS.W     D6,D0
0298: LEA        -10099(A5),A4
029C: ADDA.L     D0,A4
029E: MOVEA.W    D5,A4
02A0: ADDA.L     D0,A4

; Store in secondary if different
02A4: MOVE.B     (A4),D0
02A6: EXT.W      D0
02A8: CMP.W      D0,A7
02AA: BEQ.S      $02B8                ; Skip if same

02AC: MOVE.B     D7,(A4)              ; Store value
02AE: MOVE.W     D5,-(A7)             ; Push column
02B0: MOVE.W     D6,-(A7)             ; Push row
02B2: JSR        912(PC)              ; Update function
02B6: ADDQ.L     #4,A7

; Update g_state1 (letter grid)
02B8: TST.W      D7                   ; If value is non-zero
02BA: BEQ.S      $0330                ; Skip if empty

02BC: MOVEQ      #15,D4
02BE: ADD.W      D5,D4                ; D4 = col + 15
02C0: MOVE.W     D6,D3                ; D3 = row

; Calculate g_state1 index
02C2: MOVEQ      #17,D0
02C4: MULS.W     D6,D0                ; row * 17
02C6: LEA        -17154(A5),A4        ; g_state1
02CA: ADDA.L     D0,A4
02CC: MOVEA.W    D5,A4                ; + column
02CE: ADDA.L     D0,A4                ; A4 = &state1[row][col]

; Convert to uppercase and store
02D2: MOVE.W     D7,-(A7)             ; Push letter
02D4: JSR        3554(A5)             ; JT[3554] - toupper
02D8: MOVE.B     D0,(A4)              ; Store uppercase

; Look up letter value
02DA: MOVEQ      #17,D1
02DC: MULS.W     D4,D1
02DE: LEA        -17154(A5),A0        ; g_state1
02E2: ADDA.L     D1,A0
02E4: MOVEA.W    D3,A0
02E6: MOVE.B     D0,0(A0,D1.L)        ; Store in mirror position

; Get letter point value from lookup
02EA: MOVEQ      #0,D0
02EC: MOVE.B     D7,D0                ; Letter code
02EE: MOVEA.L    A5,A0
02F0: ADDA.L     D0,A0
02F4: TST.B      -1064(A0)            ; Check if valid
02F6: ADDQ.L     #2,A7
02F8: BPL.S      $02FE
02FA: MOVEQ      #0,D0                ; Invalid = 0 points
02FC: BRA.S      $030C

02FE: MOVE.B     (A4),D0              ; Get letter
0300: EXT.W      D0
0302: MOVEA.L    A5,A0
0304: ADDA.L     D0,A0
0306: ADDA.L     D0,A0
0308: MOVE.W     -27630(A0),D0        ; Get point value

; Store in g_state2 (score grid)
030C: MOVEQ      #34,D1               ; 17 * 2 for word size
030E: MULS.W     D6,D1                ; row * 34
0310: LEA        -16610(A5),A0        ; g_state2
0314: ADDA.L     D1,A0
0316: MOVEA.W    D5,A0                ; + column * 2
0318: ADDA.L     A0,A0
031A: MOVE.W     D0,0(A0,D4.L)        ; Store score

; Mirror to transposed position
031E: MOVEQ      #34,D1
0320: MULS.W     D4,D1                ; (col+15) * 34
0322: LEA        -16610(A5),A0
0326: ADDA.L     D1,A0
0328: MOVEA.W    D3,A0                ; + row * 2
032A: ADDA.L     A0,A0
032C: MOVE.W     D0,0(A0,D4.L)        ; Store mirrored

0330: MOVEM.L    (SP)+,...            ; restore
0334: UNLK       A6
0336: RTS
```

**Purpose**: Places a tile on the board, updating both the letter grid and score grid.

### Function 0x0338 - Remove Tile from Board
```asm
0338: LINK       A6,#0
033C: MOVEM.L    D5/D6/D7/A3/A4,-(SP)
0340: MOVE.W     8(A6),D6             ; D6 = row
0344: MOVE.W     10(A6),D5            ; D5 = column

; Get current letter from g_state1
0348: MOVEQ      #17,D0
034A: MULS.W     D6,D0
034C: LEA        -17154(A5),A0        ; g_state1
0350: ADDA.L     D0,A0
0352: MOVEA.W    D5,A0
0354: MOVE.B     0(A0,D0.L),D7        ; D7 = letter
0358: EXT.W      D7

; Get score from g_state2
035A: MOVEQ      #34,D0               ; 17 * 2
035C: MULS.W     D6,D0
035E: LEA        -16610(A5),A0        ; g_state2
0362: ADDA.L     D0,A0
0364: MOVEA.W    D5,A0
0366: ADDA.L     A0,A0
0368: TST.W      0(A0,D0.L)           ; Test score
036A: BEQ.S      $038A                ; If zero, skip

; Convert to lowercase
036E: MOVE.W     D7,-(A7)
0370: JSR        3562(A5)             ; JT[3562] - tolower
0374: ADDQ.L     #2,A7

; Update lookup tables
0378: ; ... update cross-check info ...

03AE: MOVEM.L    (SP)+,...
03B2: UNLK       A6
03B4: RTS
```

### Function 0x0416 - Iterate Over Board
```asm
0416: LINK       A6,#0
041A: MOVEM.L    D6/D7,-(SP)
041E: MOVEQ      #1,D7                ; D7 = row = 1

; Row loop
0420: BRA.S      $043C
0422: MOVEQ      #1,D6                ; D6 = column = 1

; Column loop
0424: BRA.S      $0434
0426: MOVE.W     D6,-(A7)             ; Push column
0428: MOVE.W     D7,-(A7)             ; Push row
042A: MOVEA.L    8(A6),A0             ; Get callback
042E: JSR        (A0)                 ; Call callback(row, col)
0430: ADDQ.L     #4,A7
0432: ADDQ.W     #1,D6                ; column++

0434: CMPI.W     #16,D6               ; column < 16?
0438: BLT.S      $0426                ; Continue column loop
043A: ADDQ.W     #1,D7                ; row++

043C: CMPI.W     #16,D7               ; row < 16?
0440: BLT.S      $0422                ; Continue row loop

0442: MOVEM.L    (SP)+,D6/D7
0446: UNLK       A6
0448: RTS
```

**C equivalent**:
```c
void iterate_board(void (*callback)(int row, int col)) {
    for (int row = 1; row < 16; row++) {
        for (int col = 1; col < 16; col++) {
            callback(row, col);
        }
    }
}
```

## Board Layout

The 17×17 arrays include a 1-cell border around the 15×15 playable area:

```
  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
0|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  <- Border
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
1|  |TW|  |  |DL|  |  |  |TW|  |  |  |DL|  |  |TW|  |
 ...
15|  |TW|  |  |DL|  |  |  |TW|  |  |  |DL|  |  |TW|  |
 +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
16|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  <- Border
```

Cells 1-15 in each dimension are playable (rows 1-15, columns 1-15).

## Cross-Check System

The lookup tables store information about valid letters for each position:
- Used during move generation
- Ensures words formed in perpendicular direction are valid
- Updated when tiles are placed or removed

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-17154 | g_state1 - Letter grid (17×17×2) |
| A5-16610 | g_state2 - Score grid (17×17×4) |
| A5-10388 | g_lookup_tbl - Cross-check table |
| A5-10099 | Secondary cross-check table |
| A5-9810 | Validation flag |
| A5-8664 | g_flag1 (rack tiles) |
| A5-8576 | Window data |
| A5-15514 | g_field_14 |
| A5-27630 | Letter point values |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 426 | memset/clear array |
| 658 | Setup function |
| 1338 | Post-init function |
| 3522 | strlen |
| 3554 | toupper |
| 3562 | tolower |

## Confidence: HIGH

Clear board management patterns:
- 17×17 arrays with border cells
- Tile placement with uppercase conversion
- Score lookup and storage
- Cross-check table updates
- Board iteration callback pattern
