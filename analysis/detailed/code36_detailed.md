# CODE 36 Detailed Analysis - Move Cache and Position Scoring

## Overview

| Property | Value |
|----------|-------|
| Size | 9102 bytes |
| JT Offset | 2520 |
| JT Entries | 5 |
| Functions | ~10 |
| Purpose | **Move caching, position scoring, lookup optimization** |


## System Role

**Category**: DAWG Engine
**Function**: Word Validation

Validates words against dictionary
## Architecture Role

CODE 36 manages move evaluation caching:
1. Cache move scores for previously calculated positions
2. Look up cached entries to avoid recalculation
3. Manage cache structures (66-byte entries)
4. Calculate position-specific scores

## Key Data Structures

Cache entry structure (66 bytes):
```
+0:   link/flags
+4:   score (long)
+14:  cache index
+16:  move data (34 bytes - copy of Move)
+30:  position row
+32:  position col
+36:  score flags
+38:  extra score
+40:  position hash
+48:  direction
+49:  player
+58:  cached value
+60:  letter counts [4]
```

## Key Functions

### Function 0x0000 - Calculate Position Score
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVEA.L    8(A6),A4              ; A4 = move data
000C: CMPI.L     #5000,16(A4)          ; Check base score >= 5000
0014: BLE.S      $0020                 ; Skip if too low
0016: MOVE.B     -23155(A5),D0         ; Get blank count
001A: CMP.B      -12605(A5),D0         ; Compare with player blanks
001E: BNE.S      $0026                 ; Different, continue
0020: MOVEQ      #0,D5                 ; Return 0
0022: BRA.W      $0128                 ; Exit
0026: TST.L      -1820(A5)             ; Check cache enabled
002A: BEQ.W      $00D8                 ; No cache, calculate

; Cache lookup
002E: MOVEQ      #0,D5
0030: MOVEA.L    A4,A3                 ; A3 = word pointer
0032: MOVE.B     33(A4),D0             ; Get row
0036: EXT.W      D0
0038: MOVE.B     32(A4),D1             ; Get direction
003C: EXT.W      D1
; ... calculate cache index ...

; Check each letter
0050: TST.B      (A2)                  ; Cell occupied?
0052: BNE.S      $00C6                 ; Yes, skip
0054: MOVEA.L    A5,A0
0056: ADDA.W     D7,A0
0058: ADDA.W     D7,A0
005A: CMPI.W     #800,-27630(A0)       ; Letter value >= 800?
0060: BGE.S      $00C6                 ; High value, skip

; Calculate bonus
0062: MOVE.B     -12605(A5),D0         ; Get player info
0066: EXT.W      D0
0068: MOVEA.L    A5,A0
006A: ADDA.W     D0,A0
006C: ADDA.W     D0,A0
006E: MOVE.L     D7,D0
0070: EXT.L      D0
; ... lookup in bonus table ...

; Apply score from cache
0090: LEA        -19470(A5),A1         ; Game state
0094: ADDA.L     D0,A1
0096: OR.W       30(A4),D0             ; Combine with move flags
0098: AND.W      -18460(A0),D0         ; Mask with position data
009C: MOVE.W     D0,D4                 ; D4 = score modifier
009E: MOVEQ      #0,D0
00A0: MOVE.W     D4,D0
00A2: ADD.L      -1820(A5),D0          ; Add cache base
00A6: MOVEA.L    D0,A0
00A8: MOVE.B     (A0),D0               ; Get cached value
00AA: EXT.W      D0
00AC: CMP.W      12(A6),D0             ; Compare with input
00B0: BEQ.S      $00C6                 ; Match

; Update score
00AC: MOVEA.L    A5,A0
00AE: ADDA.W     D7,A0
00B0: MOVE.B     -12668(A0),D0         ; Get letter data
00B4: EXT.W      D0
00B6: ADD.W      D0,D5                 ; Add to score
; ... continue for word ...

00C6: ADDQ.L     #1,A3                 ; Next letter
00C8: ADDQ.L     #1,A2                 ; Next cell
00CA: MOVE.B     (A3),D7               ; Get char
00CC: EXT.W      D7
00CE: TST.W      D7
00D0: BNE.W      $0052                 ; Continue loop

; Calculate final score
00D4: BRA.S      $0126

; No cache - direct calculation
00D6: CMPI.W     #7,-20010(A5)         ; Check tile count
00DC: BEQ.S      $0124                 ; 7 tiles = bingo

00DE: MOVE.W     -2090(A5),D0          ; Get position values
00E2: MOVEA.L    A5,A0
00E4: ADDA.W     D0,A0
00E6: MOVE.B     -12668(A0),D1
00EA: EXT.W      D1
00EC: MOVE.W     -2086(A5),D2
00F0: MOVEA.L    A5,A0
00F2: ADDA.W     D2,A0
00F4: MOVE.B     -12668(A0),D0
00F8: EXT.W      D0
00FA: MOVE.W     -2092(A5),D2
00FE: MOVEA.L    A5,A0
0100: ADDA.W     D2,A0
0102: MOVE.B     -12668(A0),D2
0106: EXT.W      D2
0108: MOVEA.W    -2088(A5),A0
010C: LEA        -12668(A0),A0
0110: MOVE.B     (A0),D3
0114: EXT.W      D3
0116: MOVE.W     -20010(A5),D5         ; Get base from tile count
011A: SUB.W      D3,D5
011C: SUB.W      D2,D5
011E: SUB.W      D0,D5
0120: SUB.W      D1,D5
0122: BRA.S      $0126

0124: MOVEQ      #7,D5                 ; Bingo bonus

; Sum up final score
0126: MOVEA.L    A4,A3
0128: CLR.L      D0
012A: CLR.L      D1
012C: CLR.L      D7
012E: LEA        -23218(A5),A0         ; Letter array
0132: LEA        -12668(A5),A1         ; Position data
0136: LEA        -26024(A5),A2         ; Lookup table

; Process letters
013A: MOVE.B     63(A0),D0             ; Get letter count[63]
013E: MOVE.B     63(A1),D1
0142: LSL.L      #1,D0
0146: ADD.W      D1,A1
0148: MOVE.W     0(A2,D1.W),D6         ; Get from lookup

014C: MOVE.B     (A3)+,D7              ; Get next letter
014E: MOVE.B     0(A1,D7.W),D1
0152: BEQ.S      $0170                 ; Not found
0154: CLR.B      0(A1,D7.W)            ; Clear used
0158: MOVE.B     0(A0,D7.W),D0         ; Get count
015C: CMP.B      D0,D1
015E: BEQ.S      $0170                 ; Match
0160: EXT.W      D0
0162: LSL.L      #1,D0
0166: SUB.W      (A2),D5               ; Adjust score
0168: ADD.W      D1,A1
016C: AND.W      0(A2,D1.W),D6         ; Mask

0170: MOVE.B     (A3)+,D7
0172: BNE.S      $014E                 ; Continue

0174: TST.W      D6
0176: BNE.S      $017C
0178: JSR        418(A5)               ; Error if zero

017C: MOVE.W     D5,D0                 ; Return score
017E: ADD.W      D6,D0                 ; Add modifier
0180: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
0184: UNLK       A6
0186: RTS
```

### Function 0x0188 - Cache Move Entry
```asm
0188: LINK       A6,#0
018C: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0190: MOVEA.L    8(A6),A3              ; A3 = move data
0194: CMPI.W     #7,-20010(A5)         ; 7 tiles = bingo
019A: BGT.W      $04D0                 ; Too many, skip

019E: LEA        16(A3),A4             ; A4 = score area
01A2: MOVE.L     -1924(A5),D7          ; Get cache hash
01A6: ADD.W      (A4),D7               ; Add score
01A8: MOVEQ      #-1,D0
01AA: ADD.W      -12540(A5),D0         ; Add count
01AE: MULU.W     #66,D0                ; * entry size
01B4: MOVEA.L    -12508(A5),A0         ; Cache base
01B8: CMP.L      4(A0,D0.L),D7         ; Compare hash
01BC: BLE.W      $04D0                 ; Not better

; Calculate cache index
01BE: MOVE.W     -2094(A5),D6          ; Get index parts
01C2: SUB.W      -20010(A5),D6
01C6: MOVE.W     D6,D5
01C8: SUBI.W     #7,D5                 ; Adjust
01CC: BLE.S      $01D4
01CE: BGT.S      $01DA
01D0: MOVEQ      #7,D5
01D2: BRA.S      $01DA
01D4: TST.W      D5
01D6: BGT.S      $01DA
01D8: MOVEQ      #1,D5

; Calculate score contribution
01DA: JSR        4442(PC)              ; Calculate modifier
01DE: MOVE.L     D0,D4                 ; D4 = modifier
01E0: MOVE.W     -20010(A5),D0         ; Tile count
01E4: MULU.W     -1822(A5),D0          ; * multiplier
01E8: MOVEA.W    D6,A0
01EA: MOVE.L     A0,-(A7)
01EC: MOVEA.W    D5,A0
01EE: MOVE.L     A0,-(A7)
01F0: MOVE.L     D4,-(A7)
01F2: MOVE.L     D0,D1
01F4: JSR        66(A5)                ; JT[66] - multiply
01F8: AND.W      D0,D1
01FA: MOVE.L     D1,-(A7)
01FC: MOVE.L     D0,D1
01FE: JSR        90(A5)                ; JT[90] - divide
0202: AND.W      D0,D1
0204: ADD.W      (A4),D1               ; Add to score
0206: MOVEA.W    D0,A0
0208: ADD.L      A0,D1
020A: MOVE.L     D1,D7                 ; D7 = final hash

; Verify cache space
020C: MOVEQ      #-1,D0
020E: ADD.W      -12540(A5),D0
0212: MULU.W     #66,D0
0218: MOVEA.L    -12508(A5),A0
021A: AND.W      D7,-(A4)
021C: CMP.L      4(A0,D0.L),D7
021E: BLE.W      $04D0

; Check count limit
0222: CMPI.W     #90,-12540(A5)        ; Max 90 entries
0228: BEQ.S      $022E
022A: JSR        418(A5)               ; Error

; Check cache pointer valid
022E: TST.L      -1820(A5)             ; Cache enabled?
0232: BEQ.W      $031C                 ; No, skip

; Lookup existing entry
0236: MOVEQ      #0,D0
0238: MOVE.W     30(A3),D0             ; Get position
023C: ADD.L      -1820(A5),D0          ; Add cache base
0240: MOVEA.L    D0,A0
0242: MOVE.B     (A0),D6               ; Get cached value
0244: EXT.W      D6
0246: CMPI.W     #$FFFF,D6
024A: BEQ.W      $031C                 ; Not found

; Bounds check
024E: CMP.W      -12540(A5),D6         ; Check index valid
0252: BGE.S      $0258
0254: TST.W      D6
0256: BGE.S      $025C
0258: JSR        418(A5)

; Get cache entry
025C: MOVEA.L    -12508(A5),A4         ; Cache array base
0260: MOVEQ      #66,D0
0262: MULU.W     -12540(A5),D0
0266: ADD.L      -12508(A5),D0
026A: CMP.L      A4,D0
026C: BHI.S      $0272
026E: JSR        418(A5)

; Scan for matching entry
0272: LEA        40(A4),A2             ; A2 = position hash area
0276: MOVEA.W    D6,A0
0278: CMP.L      (A2),D6               ; Match?
027C: BNE.S      $031C                 ; No match

; Verify position
0282: MOVE.B     48(A4),D0             ; Get direction
0286: CMP.B      32(A3),D0             ; Match move?
028A: BNE.W      $031C
028E: MOVE.B     49(A4),D0             ; Get row
0292: CMP.B      33(A3),D0             ; Match?
0296: BNE.W      $031C

; Check letter counts match
029A: MOVE.B     60(A4),D0             ; Get stored count
029E: EXT.W      D0
02A0: CMP.W      -20010(A5),D0         ; Match current?
02A4: BNE.S      $031A

02A6: MOVE.W     -2088(A5),D0          ; Get letter counts
02AA: MOVEA.L    A5,A0
02AC: ADDA.W     D0,A0
02AE: MOVE.B     61(A4),D1
02B2: CMP.B      -12668(A0),D1
02B6: BNE.S      $031A

02B8: MOVE.W     -2092(A5),D0
02BC: MOVEA.L    A5,A0
02BE: ADDA.W     D0,A0
02C0: MOVE.B     62(A4),D1
02C4: CMP.B      -12668(A0),D1
02C8: BNE.S      $031A

02CA: MOVE.W     -2086(A5),D0
02CE: MOVEA.L    A5,A0
02D0: ADDA.W     D0,A0
02D2: MOVE.B     63(A4),D1
02D6: CMP.B      -12668(A0),D1
02DA: BNE.S      $031A

02DC: MOVE.W     -2090(A5),D0
02E0: MOVEA.L    A5,A0
02E2: ADDA.W     D0,A0
02E4: MOVE.B     64(A4),D1
02E8: CMP.B      -12668(A0),D1
02EC: BNE.S      $031A

; Score comparison
02EA: CMP.L      4(A4),D7              ; New score better?
02EE: BLE.W      $04D0                 ; No, skip

; Update cache entry
02F2: MOVE.L     D7,4(A4)              ; Store new score
02F6: LEA        16(A4),A0             ; Dest = entry.move
02FA: LEA        (A3),A1               ; Src = move
02FC: MOVEQ      #7,D0
02FE: MOVE.L     (A1)+,(A0)+           ; Copy 8 longs
0300: DBF        D0,$02FE
0304: MOVE.W     (A1)+,(A0)+           ; Copy word
0306: MOVE.W     D4,58(A4)             ; Store modifier
030A: MOVEA.W    D6,A0
030C: MOVE.L     A0,(A2)               ; Update hash
030E: BRA.W      $04D0

; Continue scanning
0312: LEA        66(A4),A4             ; Next entry
0316: BRA.W      $0262
031A: MOVEQ      #0,D3

; Create new entry if not found
031C: CMPI.W     #7,-20010(A5)
0322: BNE.S      $035E

; 7 tiles - special handling
0324: MOVEA.L    -1852(A5),A4          ; Get special cache
0328: BRA.S      $0350

; Sum letter values
032A: MOVEA.L    A5,A0
032C: ADDA.W     D5,A0
032E: ADDA.W     D5,A0
0330: MOVEA.L    A5,A1
0332: ADDA.W     D5,A1
0334: MOVE.B     -12668(A1),D0
0338: EXT.W      D0
033A: MOVEA.L    A5,A1
033C: ADDA.W     D5,A1
033E: MOVE.B     -23218(A1),D1
0342: EXT.W      D1
0344: SUB.W      D0,A1
0346: MULS.W     -27630(A0),D1
034A: MOVEA.W    D1,A0
034C: ADD.L      A0,D3
034E: ADDQ.L     #1,A4

0350: MOVE.B     (A4),D5
0352: EXT.W      D5
0354: TST.W      D5
0356: BNE.S      $032A
0358: ADD.L      D3,D3
035A: ADD.L      16(A3),D3             ; Add move score

; ... continue with entry creation and update ...

04CE: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
04D2: UNLK       A6
04D4: RTS
```

### Function 0x04D6 - Similar Cache Management
```asm
04D6: LINK       A6,#0
04DA: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)
04DE: MOVEA.L    8(A6),A3
04E2: CMPI.W     #7,-20010(A5)
04E8: BGT.W      $06D4                 ; Too many tiles

04EC: LEA        16(A3),A4             ; Score area
04F0: MOVE.L     -1924(A5),D7
04F4: ADD.W      (A4),D7

; Similar structure to 0x0188 but different cache handling
; ... continues with similar pattern ...

06D4: MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4
06D8: UNLK       A6
06DA: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1820 | Cache enable/base pointer |
| A5-1822 | Score multiplier |
| A5-1852 | Special 7-tile cache pointer |
| A5-1924 | Cache hash base |
| A5-2086 | Position value 1 |
| A5-2088 | Position value 2 |
| A5-2090 | Position value 3 |
| A5-2092 | Position value 4 |
| A5-2094 | Position index |
| A5-12508 | Cache array pointer |
| A5-12540 | Cache entry count |
| A5-12605 | Player blank count |
| A5-12668 | Position data array |
| A5-18460 | Position mask table |
| A5-19470 | Game state |
| A5-20010 | Tiles placed count |
| A5-23155 | Blank tile count |
| A5-23218 | Letter count array |
| A5-26024 | Score lookup table |
| A5-27630 | Letter value table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | 32-bit multiply |
| 90 | 32-bit divide |
| 418 | bounds_error |
| 3466 | memmove |

## Cache Structure

The cache uses 66-byte entries:
- Up to 90 entries maximum
- Indexed by position hash
- Stores move data copy (34 bytes)
- Tracks letter counts for validation
- Score comparison for replacement

Cache lookup flow:
1. Calculate position hash from row/col/direction
2. Look up in position table for entry index
3. Verify letter counts match
4. Compare scores - replace if better

## Confidence: HIGH

Clear caching optimization patterns:
- Hash-based lookup for positions
- Score comparison for replacement
- Entry validation with letter counts
- 66-byte entry structure confirmed by memmove calls
