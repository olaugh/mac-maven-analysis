# CODE 18 Detailed Analysis - Move Description Formatting

## Overview

| Property | Value |
|----------|-------|
| Size | 4,460 bytes |
| JT Offset | 816 |
| JT Entries | 4 |
| Functions | 6+ |
| Purpose | **Format move descriptions for display, handle special moves** |

## Architecture Role

CODE 18 creates human-readable move descriptions:
1. Format word placements with coordinates
2. Handle special moves (pass, exchange, etc.)
3. Score notation with bonuses
4. Direction indicators

## Key Functions

### Function 0x0000 - Format Move to String
```asm
0000: LINK       A6,#-24
0004: MOVEM.L    A3/A4,-(SP)
0008: MOVEA.L    8(A6),A3             ; A3 = output buffer
000C: MOVEA.L    12(A6),A4            ; A4 = move data

; Check if blank played
0010: TST.B      32(A4)               ; Blank flag?
0014: BEQ.S      $0046                ; No blank

; Format blank notation
0016: MOVE.L     A4,-(A7)             ; Move data
0018: MOVE.L     A4,-(A7)
001A: MOVE.L     16(A6),-(A7)         ; Context
001E: MOVE.L     A4,-(A7)
0020: JSR        3506(A5)             ; JT[3506] - compare
0024: TST.W      D0
0026: BEQ.S      $0032                ; Different format

; Same-tile format
002A: LEA        -5678(A5),A0         ; Format string 1
002E: MOVE.L     A0,D0
0030: BRA.S      $0038

; Different-tile format
0032: LEA        -5674(A5),A0         ; Format string 2
0036: MOVE.L     A0,D0
0038: MOVE.L     D0,-(A7)             ; Push format
003A: MOVE.L     A3,-(A7)             ; Push buffer
003C: JSR        2066(A5)             ; sprintf
0040: LEA        16(A7),A7
0044: BRA.S      $008A                ; Done

; No blank - check if word played
0046: TST.B      (A4)                 ; Word present?
0048: BNE.S      $0058                ; Yes

; No word - "no play"
004A: PEA        -5668(A5)            ; "no play" string
004E: MOVE.L     A3,-(A7)
0050: JSR        3490(A5)             ; strcpy
0054: BEQ.S      $0056
0056: BRA.S      $008A

; Word played - check if across
0058: MOVEA.L    16(A6),A0            ; Get direction
005C: TST.B      32(A0)               ; Horizontal?
0060: BNE.S      $007E                ; Yes

; Vertical play - format with row number
0062: MOVE.L     A4,-(A7)             ; Move data
0064: PEA        -24(A6)              ; Local buffer
0068: JSR        2026(A5)             ; Get coords
006C: MOVE.L     D0,(A7)              ; Push coord
006E: PEA        -5660(A5)            ; Format string
0072: MOVE.L     A3,-(A7)             ; Output
0074: JSR        2066(A5)             ; sprintf
0078: LEA        16(A7),A7
007C: BRA.S      $008A

; Horizontal play
007E: PEA        -5648(A5)            ; Horizontal format
0082: MOVE.L     A3,-(A7)
0084: JSR        3490(A5)             ; strcpy
0088: BEQ.S      $008A

008A: MOVE.L     A3,D0                ; Return buffer
008C: MOVEM.L    (SP)+,A3/A4
0090: UNLK       A6
0092: RTS
```

### Function 0x0094 - Format Score Description
```asm
0094: LINK       A6,#-164             ; Large local frame
0098: MOVEM.L    D3/D4/D5/D6/D7,-(SP)
009C: MOVE.W     8(A6),D7             ; D7 = score/type

; Validate
00A0: TST.W      D7
00A2: BNE.S      $00A8
00A4: JSR        418(A5)              ; Error if zero

; Setup rect
00A8: PEA        -144(A6)
00AC: JSR        2394(A5)             ; SetRect

; Check for special values
00B0: CMPI.W     #$4E20,D7            ; 20000 = special
00B4: BEQ.S      $00E2                ; Handle special

; Check for pass (0x8001)
00B8: TST.W      12(A6)               ; Check flag
00BC: BEQ.S      $00C8
00BE: LEA        -5636(A5),A0         ; "won" string
00C2: MOVE.L     A0,D0
00C4: BRA.W      $059C

00C8: TST.W      10(A6)               ; Check score sign
00CC: BLE.S      $00D8
00CE: LEA        -5592(A5),A0         ; "ahead" string
00D2: MOVE.L     A0,D0
00D4: BRA.W      $059C

00D8: LEA        -5554(A5),A0         ; "behind" string
00DC: MOVE.L     A0,D0
00DE: BRA.W      $059C

; Handle pass (0x8001)
00E2: CMPI.W     #$8001,D7
00E6: BNE.S      $00F2
00E8: LEA        -5516(A5),A0         ; "pass" string
00EC: MOVE.L     A0,D0
00EE: BRA.W      $059C

; Handle forfeit (0xFFFF)
00F2: CMPI.W     #$FFFF,D7
00F6: BNE.S      $0102
00F8: LEA        -5510(A5),A0         ; "forfeit" string
00FC: MOVE.L     A0,D0
00FE: BRA.W      $059C

; Handle exchange (0xFFFE)
0102: CMPI.W     #$FFFE,D7
0106: BNE.S      $0112
0108: LEA        -5486(A5),A0         ; "exchange" string
010C: MOVE.L     A0,D0
010E: BRA.W      $059C

; Handle timeout (0xFFE0)
0112: CMPI.W     #$FFE0,D7
0116: BNE.S      $0122
0118: LEA        -5462(A5),A0         ; "time" string
011C: MOVE.L     A0,D0
011E: BRA.W      $059C

; Handle overtime (0xFFDF)
0122: CMPI.W     #$FFDF,D7
0126: BNE.S      $0132
0128: LEA        -5446(A5),A0         ; "overtime" string
012C: MOVE.L     A0,D0
012E: BRA.W      $059C

; Handle challenge (0xFFFD)
0132: CMPI.W     #$FFFD,D7
0136: BNE.S      $0152
0138: TST.W      12(A6)               ; Check outcome
013C: BEQ.S      $0148
013E: LEA        -5430(A5),A0         ; "challenge won"
0142: MOVE.L     A0,D0
0144: BRA.W      $059C

0148: LEA        -5366(A5),A0         ; "challenge lost"
014C: MOVE.L     A0,D0
014E: BRA.W      $059C

; Handle resign (0x07DA = 2010)
0152: CMPI.W     #$07DA,D7
0156: BNE.S      $0162
0158: LEA        -5338(A5),A0         ; "resign" string
015C: MOVE.L     A0,D0
015E: BRA.W      $059C

; Handle end game (0xFFFC)
0162: CMPI.W     #$FFFC,D7
0166: BNE.S      $0172
0168: LEA        -5316(A5),A0         ; "end" string
016C: MOVE.L     A0,D0
016E: BRA.W      $059C

; Check for letter exchange range (0xFFE1-0xFFFB)
0172: CMPI.W     #$FFFB,D7            ; <= -5
0176: BGT.W      $0206
017A: CMPI.W     #$FFE1,D7            ; >= -31
017E: BLT.W      $0206

; Format letter exchange
0182: MOVEQ      #-5,D0
0184: SUB.W      D7,D0                ; Count = -5 - value
0186: MOVEA.L    -26158(A5),A0        ; Tile table
018A: MOVE.B     0(A0,D0.W),D0        ; Get letter
018E: EXT.W      D0
0190: MOVEA.L    A6,A1
0192: ADD.W      D0,A1
0194: TST.B      -144(A1)             ; Check validity
0198: BNE.S      $01C4                ; Valid

; Format exchange count
019A: MOVEQ      #-5,D0
019C: SUB.W      D7,D0
019E: MOVEA.L    -26158(A5),A0
01A2: MOVE.B     0(A0,D0.W),D0
01A6: EXT.W      D0
01A8: MOVE.W     D0,-(A7)
01AA: JSR        3562(A5)             ; tolower
01AE: MOVE.W     D0,(A7)
01B0: PEA        -5280(A5)            ; Format string
01B4: PEA        -5774(A5)            ; Output buffer
01B8: JSR        2066(A5)             ; sprintf
01BC: LEA        10(A7),A7
01C0: BRA.W      $0596

; Format with direction indicator
01C4: MOVEQ      #-5,D0
01C6: SUB.W      D7,D0
01C8: MOVEA.L    -26158(A5),A0
01CC: MOVE.B     0(A0,D0.W),D0
01D0: EXT.W      D0
01D2: MOVE.W     D0,-(A7)
01D4: JSR        3562(A5)             ; tolower
01D8: MOVE.W     D0,(A7)

; Choose across/down string
01DA: TST.W      10(A6)
01DE: BLE.S      $01E8
01E0: LEA        -5260(A5),A0         ; " across"
01E4: MOVE.L     A0,D0
01E6: BRA.S      $01EE

01E8: LEA        -5256(A5),A0         ; " down"
01EC: MOVE.L     A0,D0
01EE: MOVE.L     D0,-(A7)
01F0: PEA        -5250(A5)            ; Format string
01F4: PEA        -5774(A5)            ; Output buffer
01F8: JSR        2066(A5)             ; sprintf
01FC: LEA        14(A7),A7
0200: BRA.W      $0596

; Regular score - format placement
0206: EXT.L      D0
0208: LSL.L      #2,D0                ; * 4
020C: MOVEA.L    -11960(A5),A0        ; DAWG base
0210: TST.B      (A0,D0.L)            ; Get letter
0214: BNE.S      $0246                ; Has letter

; No letter - just format score
0216: EXT.L      D0
0218: LSL.L      #2,D0
021C: MOVEA.L    -11960(A5),A0
0220: MOVE.W     (A0,D0.L),D0         ; Get word data
0224: MOVE.L     A0,-(A7)
0228: PEA        -16(A6)              ; Coords
022C: JSR        2026(A5)             ; Get position
0230: MOVE.L     D0,(A7)
0232: PEA        -5228(A5)            ; Format string
0236: PEA        -5774(A5)            ; Output buffer
023A: JSR        2066(A5)             ; sprintf
023E: LEA        16(A7),A7
0242: BRA.W      $0596

; Extract coordinates and format
0246: MOVEQ      #0,D6
0248: MOVE.W     D6,D3
024A: MOVE.W     D6,D5
024C: MOVE.W     D6,D4
024E: MOVE.W     D7,-160(A6)          ; Store score

; Parse word and calculate bounds
0252: BRA.S      $02A2                ; Start loop
0254: MOVE.W     -160(A6),D0
0258: EXT.L      D0
025A: LSL.L      #2,D0
025E: MOVEA.L    -11960(A5),A0
0262: MOVE.B     (A0,D0.L),D0         ; Get letter
0266: EXT.W      D0
026A: MOVE.W     D0,-154(A6)          ; Store letter

; Get row/column
026E: MOVE.W     -160(A6),D1
0272: EXT.L      D1
0274: LSL.L      #2,D1
0278: MOVE.B     7(A1,D1.L),D4        ; Column
027A: EXT.W      D1
027C: MOVE.W     D1,-152(A6)          ; Row

; Track min/max
027E: CMP.W      D0,D5                ; Min column
0280: BGE.S      $0284
0282: MOVE.W     -154(A6),D5

0284: CMP.W      -154(A6),D4
0288: BLE.S      $028E
028A: MOVE.W     -154(A6),D4          ; Max column

028E: CMP.W      -152(A6),D6
0292: BGE.S      $0298
0294: MOVE.W     -152(A6),D6          ; Min row

0298: CMP.W      -152(A6),D3
029C: BLE.S      $02A2
029E: MOVE.W     -152(A6),D3          ; Max row

; Next character
02A2: MOVE.W     -160(A6),D0
02A6: EXT.L      D0
02A8: LSL.L      #2,D0
02AC: MOVEA.L    -11960(A5),A0
02B0: MOVE.W     (A0,D0.L),-160(A6)   ; Get next
02B4: BNE.S      $0254                ; Loop if more

; Calculate word length
02B6: MOVE.L     D7,D0
02B8: EXT.L      D0
02BA: LSL.L      #2,D0
02BE: MOVEA.L    -11960(A5),A0
02C2: MOVE.B     (A0,D0.L),D0
02C6: EXT.W      D0
02C8: ADD.W      D6,D0                ; Min row
02CC: CMPI.W     #15,D0               ; Board edge?
02D0: BNE.S      $02D4
02D2: ADDQ.W     #1,D6                ; Adjust

; Check column
02D0: MOVE.L     D7,D0
02D2: EXT.L      D0
02D4: LSL.L      #2,D0
02D8: MOVEA.L    -11960(A5),A0
02DC: MOVE.B     (A0,D0.L),D0
02E0: EXT.W      D0
02E2: ADD.W      D3,D0                ; Max row
02E6: SUBQ.W     #1,D0
02EA: BNE.S      $02F0
02EC: SUBQ.W     #1,D3                ; Adjust

; Format coordinates and word
...

; Return formatted string
0594: LEA        -5774(A5),A0         ; Output buffer
0598: MOVE.L     A0,D0
059A: MOVEM.L    (SP)+,D3/D4/D5/D6/D7
059E: UNLK       A6
05A0: RTS
```

### Function 0x05A2 - Format Score with Percentage
```asm
05A2: LINK       A6,#0
05A6: MOVEM.L    D6/D7/A4,-(SP)
05AA: MOVE.W     8(A6),D6             ; D6 = score
05AE: MOVE.L     D6,D0
05B0: EXT.L      D0

; Calculate percentage
05B2: DIVS.W     #100,D0
05B8: MULS.W     #100,D0
05BC: MOVE.W     D0,D7
05BE: SUB.W      D0,D7                ; D7 = remainder

; Validate range
05C0: TST.W      D7
05C2: BLT.S      $05C8
05C4: CMPI.W     #100,D7
05C8: BLT.S      $05CC
05CA: JSR        418(A5)              ; Error

; Check thresholds
05CC: CMPI.W     #2,D7
05D0: BGE.S      $05E0
05D2: CMPI.W     #1,D6
05D6: BLE.S      $05E0

; Low percentage
05D8: LEA        -5160(A5),A4         ; "low" string
05DC: BRA.W      $067C

; Check if zero or negative
05E0: TST.W      D6
05E2: BGE.S      $05EA
...
```

## Special Move Types

| Code | Meaning |
|------|---------|
| 0x4E20 (20000) | Game end special |
| 0x8001 | Pass |
| 0xFFFF | Forfeit |
| 0xFFFE | Exchange tiles |
| 0xFFFD | Challenge |
| 0xFFFC | End game |
| 0xFFE0 | Timeout |
| 0xFFDF | Overtime |
| 0x07DA (2010) | Resign |
| 0xFFE1-0xFFFB | Exchange specific letters |

## String Table Offsets

| Offset | String |
|--------|--------|
| A5-5160 | Percentage indicator |
| A5-5192 | Horizontal format |
| A5-5214 | Coordinate format |
| A5-5228 | Position format |
| A5-5250 | Direction format |
| A5-5256 | "down" |
| A5-5260 | "across" |
| A5-5280 | Exchange format |
| A5-5316 | "end" |
| A5-5338 | "resign" |
| A5-5366 | "challenge lost" |
| A5-5430 | "challenge won" |
| A5-5446 | "overtime" |
| A5-5462 | "time" |
| A5-5486 | "exchange" |
| A5-5510 | "forfeit" |
| A5-5516 | "pass" |
| A5-5554 | "behind" |
| A5-5592 | "ahead" |
| A5-5636 | "won" |
| A5-5648 | Horizontal string |
| A5-5660 | Vertical format |
| A5-5668 | "no play" |
| A5-5674 | Format string 2 |
| A5-5678 | Format string 1 |
| A5-5774 | Output buffer |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-11960 | DAWG base pointer |
| A5-26158 | Tile table |

## Confidence: HIGH

Clear move formatting patterns:
- Special move code handling
- Coordinate formatting
- Direction indicators
- Score notation
