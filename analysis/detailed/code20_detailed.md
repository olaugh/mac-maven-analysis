# CODE 20 Detailed Analysis - Board State Management

## Overview

| Property | Value |
|----------|-------|
| Size | 3,398 bytes |
| JT Offset | 928 |
| JT Entries | 17 |
| Functions | 20+ |
| Purpose | **Board state arrays, tile placement, cross-check generation** |

## System Role

**Category**: Board State
**Function**: Position Management

Manages the core Scrabble board state including letter placement, score tracking, and cross-check information for move validation. Maintains multiple 17x17 arrays for different aspects of board state.

**Related CODE resources**:
- CODE 21 (main UI)
- CODE 12 (word validation)
- CODE 3 (search coordinator)

## Architecture Role

CODE 20 manages the Scrabble board state:
1. Initialize board state arrays (17x17 grids with 1-cell border)
2. Place and remove tiles with proper case handling
3. Generate and update cross-check information
4. Track letter scores for placed tiles
5. Provide iteration utilities for board traversal
6. Coordinate validation flag state

## Key Data Structures

### Board State Arrays

The board uses a 17x17 grid where cells 1-15 in each dimension are playable, with row/column 0 and 16 serving as borders.

| Array | Offset | Size | Element | Purpose |
|-------|--------|------|---------|---------|
| g_state1 | A5-17154 | 544 bytes | 2 bytes | Letter grid (17x17x2) |
| g_state2 | A5-16610 | 1088 bytes | 4 bytes | Score grid (17x17x4) |
| g_lookup_tbl | A5-10388 | 289 bytes | 1 byte | Cross-check lookups (17x17) |
| secondary_lookup | A5-10099 | 289 bytes | 1 byte | Secondary cross-check data |

### Array Calculations
```c
// Index calculation for 1-byte arrays (lookup tables)
index = row * 17 + column;  // Range: 0-288

// Index calculation for 2-byte arrays (g_state1)
index = row * 17 + column;  // Word access

// Index calculation for 4-byte arrays (g_state2)
index = row * 34 + column * 2;  // 34 = 17 * 2
```

## Key Functions

### Function 0x0000 - Initialize All Board Arrays
```asm
0000: JSR        1306(PC)             ; Internal init function
0004: PEA        $0220.W              ; Size = 544 bytes (0x220)
0008: PEA        -17154(A5)           ; g_state1 (letter grid)
000C: JSR        426(A5)              ; JT[426] - memset to zero

0010: PEA        $0121.W              ; Size = 289 bytes (0x121)
0014: PEA        -10388(A5)           ; g_lookup_tbl (cross-check)
0018: JSR        426(A5)              ; JT[426] - memset

001C: PEA        $0121.W              ; Size = 289 bytes
0020: PEA        -10099(A5)           ; Secondary lookup table
0024: JSR        426(A5)              ; JT[426] - memset

0028: PEA        $0440.W              ; Size = 1088 bytes (0x440)
002C: PEA        -16610(A5)           ; g_state2 (score grid)
0030: JSR        426(A5)              ; JT[426] - memset

0034: CLR.W      -9810(A5)            ; Clear validation flag
0038: JSR        658(A5)              ; JT[658] - additional setup
003C: JSR        1338(A5)             ; JT[1338] - post-init
0040: JSR        3252(PC)             ; Internal post-setup
0044: LEA        32(A7),A7            ; Clean stack (8 calls x 4 bytes)
0048: RTS
```

**C equivalent**:
```c
void init_board() {
    internal_init();

    memset(g_state1, 0, 544);       // 17x17 letter grid (2 bytes/cell)
    memset(g_lookup_tbl, 0, 289);   // Cross-check table (1 byte/cell)
    memset(secondary_lookup, 0, 289);
    memset(g_state2, 0, 1088);      // Score grid (4 bytes/cell)

    g_validation_flag = 0;
    setup_function_1();             // JT[658]
    setup_function_2();             // JT[1338]
    post_init();
}
```

### Function 0x004A - Reset Board State
```asm
004A: PEA        $0220.W              ; 544 bytes
004E: PEA        -17154(A5)           ; g_state1
0052: JSR        426(A5)              ; Clear letter grid

0056: PEA        $0440.W              ; 1088 bytes
005A: PEA        -16610(A5)           ; g_state2
005E: JSR        426(A5)              ; Clear score grid

0062: PEA        1090(A5)             ; Parameter
0066: JSR        942(PC)              ; Internal function
006A: JSR        1338(A5)             ; JT[1338] - reinitialize
006E: LEA        20(A7),A7
0072: RTS
```

### Function 0x0074 - Set Cell Value with Cross-Check Update
```asm
0074: LINK       A6,#0
0078: MOVEM.L    D6/D7/A3/A4,-(SP)
007C: MOVE.W     8(A6),D7             ; D7 = row
0080: MOVE.W     10(A6),D6            ; D6 = column

; Calculate index into g_lookup_tbl: row * 17 + column
0084: MOVEQ      #17,D0
0086: MULS.W     D7,D0                ; D0 = row * 17
0088: LEA        -10388(A5),A4        ; A4 = g_lookup_tbl base
008C: ADDA.L     D0,A4
008E: ADDA.W     D6,A4                ; A4 = &lookup[row][col]

; Same calculation for secondary table
0094: MOVEQ      #17,D0
0096: MULS.W     D7,D0
0098: LEA        -10099(A5),A3        ; A3 = secondary_lookup base
009C: ADDA.L     D0,A3
009E: ADDA.W     D6,A3                ; A3 = &secondary[row][col]

; Compare values - only update if different
00A4: MOVE.B     (A4),D0              ; Get primary lookup value
00A6: CMP.B      (A3),D0              ; Compare with secondary
00A8: BEQ.S      $00B6                ; If equal, skip update

; Values differ - copy and trigger cross-check update
00AA: MOVE.B     (A3),(A4)            ; Copy secondary to primary
00AC: MOVE.W     D6,-(A7)             ; Push column
00AE: MOVE.W     D7,-(A7)             ; Push row
00B0: JSR        1426(PC)             ; Update cross-check info
00B4: ADDQ.L     #4,A7

00B6: MOVEM.L    (SP)+,D6/D7/A3/A4
00BA: UNLK       A6
00BC: RTS
```

### Function 0x00BE - Validate Tile Placement
```asm
00BE: LINK       A6,#-8               ; 8 bytes local
00C2: MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)
00C6: MOVEQ      #0,D7                ; Clear counters
00C8: MOVEQ      #0,D6
00CA: CLR.L      -8(A6)
00CE: CLR.L      -4(A6)
00D0: MOVEQ      #0,D5
00D2: LEA        -8664(A5),A4         ; A4 = g_flag1 (rack)

; Loop through rack tiles
00D8: MOVE.W     (A4),D4              ; Get tile value
00DA: TST.W      D4                   ; End of rack?
00DC: BEQ.S      $0116                ; Yes, exit loop

00DE: MOVE.L     D4,D3
00E0: EXT.L      D3                   ; Extend to long
; ... validation logic for each tile ...

; Compare lengths
0116: PEA        -15514(A5)           ; g_field_14
011A: JSR        3522(A5)             ; JT[3522] - strlen
011E: CMP.L      D5,D0                ; Compare with expected
0122: BEQ.S      $0128                ; Match
0124: MOVEQ      #0,D0                ; Return false
0126: BRA.S      $0188

0128: ; ... more validation ...

; Final result
0186: MOVEQ      #1,D0                ; Return true
0188: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4
018C: UNLK       A6
018E: RTS
```

### Function 0x0272 - Place Tile on Board
```asm
0272: LINK       A6,#0
0276: MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)
027A: MOVE.W     8(A6),D6             ; D6 = row
027E: MOVE.W     10(A6),D5            ; D5 = column

; Get current cell value from primary lookup table
0282: MOVEQ      #17,D0
0284: MULS.W     D6,D0                ; row * 17
0286: LEA        -10388(A5),A0        ; g_lookup_tbl
028A: ADDA.L     D0,A0
028C: ADDA.W     D5,A0                ; A0 = &lookup[row][col]
028E: MOVE.B     (A0),D7              ; D7 = current value
0292: EXT.W      D7

; Get secondary lookup value
0294: MOVEQ      #17,D0
0296: MULS.W     D6,D0
0298: LEA        -10099(A5),A4
029C: ADDA.L     D0,A4
029E: ADDA.W     D5,A4                ; A4 = &secondary[row][col]

; Store in secondary if different
02A4: MOVE.B     (A4),D0
02A6: EXT.W      D0
02A8: CMP.W      D0,D7
02AA: BEQ.S      $02B8                ; Skip if same

02AC: MOVE.B     D7,(A4)              ; Store value
02AE: MOVE.W     D5,-(A7)             ; Push column
02B0: MOVE.W     D6,-(A7)             ; Push row
02B2: JSR        912(PC)              ; Update function
02B6: ADDQ.L     #4,A7

; Update g_state1 (letter grid) if value is non-zero
02B8: TST.W      D7
02BA: BEQ.S      $0330                ; Skip if empty

02BC: MOVEQ      #15,D4
02BE: ADD.W      D5,D4                ; D4 = col + 15 (for mirroring)
02C0: MOVE.W     D6,D3                ; D3 = row

; Calculate g_state1 index
02C2: MOVEQ      #17,D0
02C4: MULS.W     D6,D0                ; row * 17
02C6: LEA        -17154(A5),A4        ; g_state1
02CA: ADDA.L     D0,A4
02CC: ADDA.W     D5,A4                ; A4 = &state1[row][col]

; Convert to uppercase and store
02D2: MOVE.W     D7,-(A7)             ; Push letter
02D4: JSR        3554(A5)             ; JT[3554] - toupper
02D8: MOVE.B     D0,(A4)              ; Store uppercase letter

; Store in mirror position (for transposed access)
02DA: MOVEQ      #17,D1
02DC: MULS.W     D4,D1                ; (col+15) * 17
02DE: LEA        -17154(A5),A0        ; g_state1
02E2: ADDA.L     D1,A0
02E4: ADDA.W     D3,A0                ; A0 = &state1[col+15][row]
02E6: MOVE.B     D0,(A0)              ; Store mirrored

; Look up letter point value
02EA: MOVEQ      #0,D0
02EC: MOVE.B     D7,D0                ; Letter code
02EE: MOVEA.L    A5,A0
02F0: ADDA.L     D0,A0
02F4: TST.B      -1064(A0)            ; Check if valid letter
02F6: ADDQ.L     #2,A7
02F8: BPL.S      $02FE
02FA: MOVEQ      #0,D0                ; Invalid = 0 points
02FC: BRA.S      $030C

02FE: MOVE.B     (A4),D0              ; Get stored letter
0300: EXT.W      D0
0302: MOVEA.L    A5,A0
0304: ADDA.L     D0,A0
0306: ADDA.L     D0,A0
0308: MOVE.W     -27630(A0),D0        ; Get point value from table

; Store score in g_state2 (score grid)
030C: MOVEQ      #34,D1               ; 17 * 2 (word-aligned stride)
030E: MULS.W     D6,D1                ; row * 34
0310: LEA        -16610(A5),A0        ; g_state2
0314: ADDA.L     D1,A0
0316: ADDA.W     D5,A0
0318: ADDA.W     D5,A0                ; A0 = &state2[row][col]
031A: MOVE.W     D0,(A0)              ; Store score

; Store in transposed position
031E: MOVEQ      #34,D1
0320: MULS.W     D4,D1                ; (col+15) * 34
0322: LEA        -16610(A5),A0        ; g_state2
0326: ADDA.L     D1,A0
0328: ADDA.W     D3,A0
032A: ADDA.W     D3,A0                ; A0 = &state2[col+15][row]
032C: MOVE.W     D0,(A0)              ; Store mirrored score

0330: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4
0334: UNLK       A6
0336: RTS
```

**C equivalent**:
```c
void place_tile(short row, short col, short tile) {
    char* lookup = &g_lookup_tbl[row * 17 + col];
    char* secondary = &secondary_lookup[row * 17 + col];

    // Update lookup tables if different
    if (*lookup != *secondary) {
        *secondary = *lookup;
        update_crosscheck(row, col);
    }

    if (tile == 0) return;  // Empty tile

    // Store uppercase letter in g_state1
    char upper = toupper(tile);
    g_state1[row * 17 + col] = upper;
    g_state1[(col + 15) * 17 + row] = upper;  // Transposed

    // Look up point value
    short points = is_valid_letter(tile) ? letter_points[upper] : 0;

    // Store score in g_state2 (4-byte entries)
    g_state2[row * 17 + col] = points;
    g_state2[(col + 15) * 17 + row] = points;  // Transposed
}
```

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
0352: ADDA.W     D5,A0
0354: MOVE.B     (A0),D7              ; D7 = letter
0358: EXT.W      D7

; Get score from g_state2
035A: MOVEQ      #34,D0               ; 17 * 2
035C: MULS.W     D6,D0
035E: LEA        -16610(A5),A0        ; g_state2
0362: ADDA.L     D0,A0
0364: ADDA.W     D5,A0
0366: ADDA.W     D5,A0
0368: TST.W      (A0)                 ; Test score
036A: BEQ.S      $038A                ; If zero, skip

; Convert to lowercase for removal
036E: MOVE.W     D7,-(A7)
0370: JSR        3562(A5)             ; JT[3562] - tolower
0374: ADDQ.L     #2,A7

; Update lookup tables
0378: ; ... update cross-check info ...

03AE: MOVEM.L    (SP)+,D5/D6/D7/A3/A4
03B2: UNLK       A6
03B4: RTS
```

### Function 0x0416 - Iterate Over Board
```asm
0416: LINK       A6,#0
041A: MOVEM.L    D6/D7,-(SP)
041E: MOVEQ      #1,D7                ; D7 = row = 1 (skip border)

; Row loop
0420: BRA.S      $043C
0422: MOVEQ      #1,D6                ; D6 = column = 1

; Column loop
0424: BRA.S      $0434
0426: MOVE.W     D6,-(A7)             ; Push column
0428: MOVE.W     D7,-(A7)             ; Push row
042A: MOVEA.L    8(A6),A0             ; Get callback function
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
    // Iterate over playable cells (1-15, skipping border)
    for (int row = 1; row < 16; row++) {
        for (int col = 1; col < 16; col++) {
            callback(row, col);
        }
    }
}
```

## Board Layout

The 17x17 arrays include a 1-cell border around the 15x15 playable area:

```
     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 0 |##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##| Border
   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 1 |##|TW|  |  |DL|  |  |  |TW|  |  |  |DL|  |  |TW|##|
 2 |##|  |DW|  |  |  |TL|  |  |  |TL|  |  |  |DW|  |##|
 3 |##|  |  |DW|  |  |  |DL|  |DL|  |  |  |DW|  |  |##|
 4 |##|DL|  |  |DW|  |  |  |DL|  |  |  |DW|  |  |DL|##|
 5 |##|  |  |  |  |DW|  |  |  |  |  |DW|  |  |  |  |##|
 6 |##|  |TL|  |  |  |TL|  |  |  |TL|  |  |  |TL|  |##|
 7 |##|  |  |DL|  |  |  |DL|  |DL|  |  |  |DL|  |  |##|
 8 |##|TW|  |  |DL|  |  |  |*S|  |  |  |DL|  |  |TW|##| *S = Start
 9 |##|  |  |DL|  |  |  |DL|  |DL|  |  |  |DL|  |  |##|
10 |##|  |TL|  |  |  |TL|  |  |  |TL|  |  |  |TL|  |##|
11 |##|  |  |  |  |DW|  |  |  |  |  |DW|  |  |  |  |##|
12 |##|DL|  |  |DW|  |  |  |DL|  |  |  |DW|  |  |DL|##|
13 |##|  |  |DW|  |  |  |DL|  |DL|  |  |  |DW|  |  |##|
14 |##|  |DW|  |  |  |TL|  |  |  |TL|  |  |  |DW|  |##|
15 |##|TW|  |  |DL|  |  |  |TW|  |  |  |DL|  |  |TW|##|
   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
16 |##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##| Border
```

- Playable cells: rows 1-15, columns 1-15
- Border cells (row/col 0 and 16): Used for boundary detection
- TW = Triple Word, DW = Double Word, TL = Triple Letter, DL = Double Letter

## Cross-Check System

The lookup tables store information about valid letters for each position:
- Used during move generation to validate perpendicular words
- Updated when tiles are placed or removed
- Enables efficient anchor-based move generation

## Transposition

Both g_state1 and g_state2 store data in transposed positions (offset by 15 columns) to allow efficient access in both hook-after and hook-before directions without recalculating indices.

## Global Variables

| Offset | Type | Name | Purpose |
|--------|------|------|---------|
| A5-17154 | char[544] | g_state1 | Letter grid (17x17x2) |
| A5-16610 | short[289] | g_state2 | Score grid (17x17x4) |
| A5-10388 | char[289] | g_lookup_tbl | Primary cross-check table |
| A5-10099 | char[289] | secondary_lookup | Secondary cross-check table |
| A5-9810 | short | validation_flag | Validation mode flag |
| A5-8664 | struct[7] | g_flag1 | Rack tiles |
| A5-8576 | long | window_data | Window data pointer |
| A5-15514 | - | g_field_14 | General buffer |
| A5-27630 | short[27] | letter_points | Letter point values |
| A5-1064 | char[27] | letter_valid | Valid letter flags |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 426 | memset - Clear array |
| 658 | Setup function |
| 1338 | Post-init / reinitialize |
| 3522 | strlen - String length |
| 3554 | toupper - Convert to uppercase |
| 3562 | tolower - Convert to lowercase |

## Confidence: HIGH

Clear board management patterns:
- 17x17 arrays with border cells for boundary detection
- Tile placement with uppercase conversion
- Score lookup from letter point table
- Cross-check table updates on tile changes
- Board iteration callback pattern (rows 1-15, cols 1-15)
- Transposed storage for bidirectional access
