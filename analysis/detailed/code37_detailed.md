# CODE 37 Detailed Analysis - DAWG Traversal and Word Validation

## Overview

| Property | Value |
|----------|-------|
| Size | 5344 bytes |
| JT Offset | 2560 |
| JT Entries | 4 |
| Functions | ~10 |
| Purpose | **DAWG traversal, word lookup, cross-check generation** |

## Architecture Role

CODE 37 handles DAWG (Directed Acyclic Word Graph) operations:
1. Initialize board position tracking
2. Traverse DAWG for word validation
3. Generate cross-check sets
4. Build letter constraint masks

## Key Data Structures

DAWG node (4 bytes):
```
Bits 0-7:   Letter code
Bit 8:      End-of-word flag
Bit 9:      Last-sibling flag
Bits 10-31: Child pointer (22 bits)
```

Position cross-check structure (68 bytes per row):
```
+0:   flags
+4:   cross-check mask for column 1
+8:   cross-check mask for column 2
...
+64:  cross-check mask for column 16
```

## Key Functions

### Function 0x0000 - Initialize Position Tracking
```asm
0000: LINK       A6,#-96               ; Local buffer for 31 words
0004: MOVEM.L    D7/A3/A4,-(SP)
0008: MOVE.W     #544,-(A7)            ; 544 = 17*32 bytes
000C: PEA        -17154(A5)            ; g_state1
0010: JSR        3450(A5)              ; JT[3450] - memcmp
0014: TST.W      D0
0016: BEQ.W      $00A8                 ; No changes

; Board changed - reinitialize
001C: PEA        -96(A6)               ; Local buffer
0020: MOVE.L     8(A6),-(A7)           ; Input
0024: JSR        172(PC)               ; Copy and validate

0028: MOVE.W     #7,-17156(A5)         ; Reset counter

; Clear position data
002E: MOVEQ      #34,D0                ; Size
0030: MOVE.L     D0,(A7)
0032: PEA        -10738(A5)            ; Position data 1
0036: JSR        426(A5)               ; JT[426] - memset

003A: MOVEQ      #34,D0
003C: MOVE.L     D0,(A7)
003E: PEA        -10704(A5)            ; Position data 2
0042: JSR        426(A5)               ; memset

; Setup move structure
0046: MOVEA.L    -10758(A5),A0         ; Move pointer
004A: MOVE.B     #8,32(A0)             ; Direction = 8 (horizontal)

0050: MOVEQ      #-1,D0
0052: ADD.L      -10758(A5),D0
0056: MOVE.L     D0,-10746(A5)         ; Store adjusted pointer

; Initialize board tracking
005A: LEA        -17018(A5),A0         ; Board offset
005E: MOVE.L     A0,-10754(A5)         ; Store pointer

0062: MOVE.W     #8,(A7)               ; Initial position
0066: JSR        2018(PC)              ; Setup position

; Setup letter data
006A: LEA        -27110(A5),A0         ; Letter data
006E: MOVE.L     A0,-10750(A5)

; Initialize traversal
0072: MOVEQ      #0,D7                 ; Index = 0
0074: LEA        -11960(A5),A4         ; DAWG base
0078: LEA        16(A7),A7

; Main initialization loop
007C: MOVE.L     (A4),-11968(A5)       ; Store DAWG root
0080: MOVE.W     D7,-10936(A5)         ; Store index
0084: MOVEA.L    A5,A0
0086: MOVE.L     D7,D0
0088: EXT.L      D0
008A: LSL.L      #3,D0                 ; *8 for table index
008E: MOVE.L     -11956(A0,D0.L),-11964(A5)
0094: BEQ.S      $00CA                 ; End of table

; Process DAWG node
0096: MOVE.L     -11964(A5),-(A7)
009A: JSR        430(PC)               ; Process node
009E: ADDQ.L     #4,A7
00A0: ADDQ.W     #1,D7                 ; Next index
00A2: ADDQ.L     #4,A4                 ; Next node
00A4: BRA.S      $007C

00A6: MOVEQ      #1,D7

; Initialize word array
00A8: LEA        -60(A6),A3            ; Local array
00AC: BRA.S      $00B6

00AE: MOVE.W     #-1,(A3)              ; Mark as invalid
00B2: ADDQ.W     #1,D7
00B4: ADDQ.L     #2,A3

00B6: CMPI.W     #31,D7                ; 31 entries
00BA: BLT.S      $00AE

; Continue initialization
00BC: MOVE.L     8(A6),-(A7)
00C0: PEA        -62(A6)
00C4: JSR        1772(PC)              ; Process words
00C8: ADDQ.L     #8,A7

00CA: MOVEM.L    (SP)+,D7/A3/A4
00CE: UNLK       A6
00D0: RTS
```

### Function 0x00D2 - Setup Board Context
```asm
00D2: LINK       A6,#0

; Clear position data
00D6: PEA        128                   ; 128 bytes
00DA: PEA        -12668(A5)            ; Position array
00DE: JSR        426(A5)               ; memset

; Store move pointer
00E2: MOVE.L     12(A6),-10758(A5)

; Clear move structure
00E8: MOVEQ      #34,D0
00EA: MOVE.L     D0,(A7)
00EC: MOVE.L     12(A6),-(A7)
00F0: JSR        426(A5)               ; memset

; Copy letter counts
00F4: PEA        128
00F8: PEA        -23218(A5)            ; Source: letter counts
00FC: PEA        -10632(A5)            ; Dest: position counts
0100: JSR        3466(A5)              ; memmove

; Store rack pointer
0104: MOVE.L     8(A6),-10636(A5)

010A: UNLK       A6
010C: RTS
```

### Function 0x010E - Generate Cross-Check Sets
```asm
010E: LINK       A6,#-4
0112: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Validate row data
0116: MOVE.W     #17,-(A7)             ; Row size
011A: PEA        -1714(A5)             ; Row buffer
011E: JSR        3450(A5)              ; memcmp
0122: TST.W      D0
0124: BNE.S      $012C
0126: JSR        418(A5)               ; Error if same

; Initialize loop
012C: MOVEQ      #1,D4                 ; Row counter
012E: LEA        -22118(A5),A4         ; Cross-check base
0132: LEA        -17137(A5),A0         ; Board + 17 (skip border)
0136: MOVE.L     A0,D5
0138: BRA.W      $023C

; Process each row
013C: CMPI.W     #1,D4                 ; First row?
0140: BEQ.S      $0148
0142: CMPI.W     #16,D4                ; Last row?
0146: BNE.S      $0150

; First/last row - use all letters
0148: LEA        -1714(A5),A0
014C: MOVE.L     A0,D0
014E: BRA.S      $015E

; Calculate row offset for lookups
0150: MOVEQ      #-1,D0
0152: ADD.W      D4,D0
0154: MULU.W     #17,D0
0158: LEA        -17154(A5),A0
015C: ADDA.L     D0,A0

015E: MOVE.L     D0,D6                 ; D6 = row above offset
0160: MOVE.L     D5,-10754(A5)         ; Store board pointer

; Similar for row below
0164: CMPI.W     #15,D4
0168: BEQ.S      $0170
016A: CMPI.W     #30,D4
016E: BNE.S      $0178

0170: LEA        -1714(A5),A0
0174: MOVE.L     A0,D0
0176: BRA.S      $0186

0178: MOVEQ      #1,D0
017A: ADD.W      D4,D0
017C: MULU.W     #17,D0
0180: LEA        -17154(A5),A0
0184: ADDA.L     D0,A0

0186: MOVE.L     D0,D7                 ; D7 = row below offset

; Process each column
0188: LEA        4(A4),A3              ; A3 = cross-check array
018C: MOVEQ      #1,D3                 ; Column counter
018E: BRA.W      $022A

; Check if cell occupied
0192: MOVEA.L    -10754(A5),A2
0196: ADDA.W     D3,A2
0198: TST.B      (A2)                  ; Cell has letter?
019A: BEQ.S      $01AE                 ; No, calculate cross-check

; Cell occupied - get existing letter mask
019C: MOVE.B     (A2),D0
019E: EXT.W      D0
01A0: MOVEA.L    A5,A0
01A2: EXT.L      D0
01A4: LSL.L      #3,D0
01A8: MOVE.L     -26542(A0,D0.L),(A3)  ; Get letter mask
01AC: BRA.S      $0224

; Check adjacent cells
01AE: MOVEA.W    D3,A0
01B0: TST.B      0(A0,D6.L)            ; Cell above empty?
01B4: BNE.S      $01C4
01B6: MOVEA.W    D3,A0
01B8: TST.B      0(A0,D7.L)            ; Cell below empty?
01BC: BNE.S      $01C4

; Both adjacent empty - all letters valid
01BE: MOVEQ      #-1,D0
01C0: MOVE.L     D0,(A3)               ; All bits set
01C2: BRA.S      $0224

; Has adjacent letter - compute cross-check
01C4: PEA        -4(A6)                ; Output buffer
01C8: PEA        -2(A6)                ; Output buffer
01CC: MOVE.W     D3,-(A7)              ; Column
01CE: MOVE.W     D4,-(A7)              ; Row
01D0: JSR        2338(A5)              ; JT[2338] - calc_position

; Calculate cross-word position
01D4: MOVEQ      #17,D0
01D6: MULU.W     -2(A6),D0
01DA: MOVEA.W    -4(A6),A2
01DE: LEA        -17155(A2),A2         ; Board - 1
01E4: ADDA.L     D0,A2
01E6: MOVEA.L    D0,A2
01E8: LEA        12(A7),A7

; Find start of cross-word
01EC: BRA.S      $01F0
01EE: SUBQ.L     #1,A2                 ; Move backwards
01F0: TST.B      (A2)
01F2: BNE.S      $01EE                 ; Continue while has letter

01F4: ADDQ.L     #1,A2                 ; Step forward
01F6: CLR.L      (A3)                  ; Clear cross-check

; Get valid letters from DAWG
01F8: MOVEA.L    -26158(A5),A0         ; g_rack
01FC: PEA        1(A0)                 ; Rack + 1
0200: MOVE.L     A2,-(A7)              ; Cross-word position
0202: JSR        454(PC)               ; Get valid letters
0206: MOVEA.L    D0,A2
0208: ADDQ.L     #8,A7
020A: BRA.S      $0220

; OR in each valid letter's bit
020C: MOVE.B     (A2),D0
020E: EXT.W      D0
0210: MOVEA.L    A5,A0
0212: EXT.L      D0
0214: LSL.L      #3,D0
0218: MOVE.L     -26542(A0,D0.L),D0    ; Get letter mask
021C: OR.L       D0,(A3)               ; OR into cross-check
021E: ADDQ.L     #1,A2

0220: TST.B      (A2)
0222: BNE.S      $020C                 ; Continue for all letters

0224: ADDQ.W     #1,D3                 ; Next column
0226: ADDQ.L     #4,A3                 ; Next cross-check entry

022A: CMPI.W     #16,D3
022C: BLT.W      $0194

; Next row
0230: ADDQ.W     #1,D4
0232: LEA        68(A4),A4             ; Next row's cross-checks
0236: MOVEQ      #17,D0
0238: ADD.L      D0,D5                 ; Next board row

023C: CMPI.W     #31,D4                ; 31 rows (with borders)
023E: BLT.W      $013E

0242: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
0246: UNLK       A6
0248: RTS
```

### Function 0x024A - Process DAWG Node
```asm
024A: LINK       A6,#0
024E: MOVEM.L    D4/D5/D6/D7/A3/A4,-(SP)

; Increment traversal counter
0252: ADDQ.L     #1,-10746(A5)

; Get node pointer
0256: MOVE.L     8(A6),D0
025A: ADDQ.L     #1,8(A6)              ; Advance input
025E: LSL.L      #3,D0                 ; *8
0262: ADD.L      -11968(A5),D0         ; Add DAWG base
0266: MOVEA.L    D0,A0
0268: MOVE.L     (A0),D7               ; D7 = DAWG node
026C: MOVEA.L    -10746(A5),A0
0270: MOVE.B     D7,(A0)               ; Store letter

; Validate letter
0274: MOVEQ      #0,D0
0276: MOVE.B     (A0),D0
0278: MOVEA.L    A5,A1
027A: TST.B      -1064(A1,D0.L)        ; Check character class
0280: BMI.S      $0286
0282: JSR        418(A5)               ; Invalid character

; Get letter value
0286: MOVE.B     D6,D0
0288: EXT.W      D0
028A: LEA        -10632(A5),A4         ; Position counts
028E: ADDA.W     D0,A4
0290: TST.B      (A4)                  ; Has this letter?
0292: BEQ.W      $0346                 ; No, skip

; Decrement available count
0296: SUBQ.B     #1,(A4)

; Check end-of-word flag
0298: BTST       #8,D7                 ; End of word?
029C: BEQ.W      $032C                 ; No, continue traversal

; Found valid word ending
02A0: MOVE.L     -10746(A5),D0
02A4: SUB.L      -10758(A5),D0         ; Calculate word length
02A8: MOVEQ      #8,D5                 ; Starting position
02AA: SUB.W      D0,D5
02AC: BRA.S      $0324

; Try each starting position
02AE: MOVEA.L    -10758(A5),A0
02B2: MOVE.B     D5,33(A0)             ; Store row
02B6: MOVEA.L    -10758(A5),A0
02BA: CLR.L      24(A0)                ; Clear score

02BE: MOVE.W     D5,D4                 ; D4 = position
02C0: MOVEA.L    -10758(A5),A3
02C4: BRA.S      $0312

; Check each letter position
02C6: MOVE.B     (A3),D0
02C8: EXT.W      D0
02CA: MOVE.W     D0,-(A7)
02CC: JSR        2002(A5)              ; JT[2002] - is_playable
02D0: TST.W      D0
02D2: BEQ.S      $030E                 ; Not playable

; Check position constraints
02D6: MOVEA.L    A5,A0
02D8: ADDA.W     D4,A0
02DA: CMPI.B     #1,-27127(A0)         ; Check constraint
02E0: BGT.S      $0306
02E2: MOVEA.L    A5,A0
02E4: ADDA.W     D4,A0
02E6: CMPI.B     #1,-26583(A0)
02EC: BGT.S      $0306
02EE: MOVEA.L    A5,A0
02F0: ADDA.W     D4,A0
02F2: CMPI.B     #1,-27093(A0)
02F8: BGT.S      $0306
02FA: MOVEA.L    A5,A0
02FC: ADDA.W     D4,A0
02FE: CMPI.B     #1,-26549(A0)
0304: BLE.S      $030E

; Valid position - increment score
0306: MOVEA.L    -10758(A5),A0
030A: ADDQ.L     #1,24(A0)             ; Increment match count

030E: ADDQ.W     #1,D4
0310: ADDQ.L     #1,A3

0312: TST.B      (A3)
0314: BNE.S      $02C6                 ; Continue for word

; Process found word
0316: JSR        2858(PC)              ; Handle valid word

031A: MOVEA.L    -10758(A5),A0
031E: CLR.L      24(A0)

0322: ADDQ.W     #1,D5                 ; Next position
0324: CMPI.W     #8,D5
0328: BLE.S      $02AE

; Check for child nodes
032A: MOVE.L     D7,D0
032C: MOVEQ      #10,D1
032E: LSR.L      D1,D0                 ; Get child pointer
0330: BEQ.S      $033E                 ; No children

; Traverse children
0332: MOVE.L     D7,D0
0334: MOVEQ      #10,D1
0336: LSR.L      D1,D0
0338: MOVE.L     D0,-(A7)
033A: JSR        -242(PC)              ; Recursive call
033E: ADDQ.L     #4,A7

; Restore letter count
0340: ADDQ.B     #1,(A4)

; Check last-sibling flag
0344: BRA.S      $034E
0346: LEA        -10569(A5),A4
0348: TST.B      (A4)
034A: BNE.W      $0298

034E: BTST       #9,D7                 ; Last sibling?
0352: BEQ.W      $0258                 ; No, continue

; Done with this subtree
0356: MOVEA.L    -10746(A5),A0
035A: SUBQ.L     #1,-10746(A5)
035E: CLR.B      (A0)

0360: MOVEM.L    (SP)+,D4/D5/D6/D7/A3/A4
0364: UNLK       A6
0366: RTS
```

### Function 0x0368 - Traverse DAWG for Word
```asm
0368: LINK       A6,#0
036C: MOVEM.L    D5/D6/D7,-(SP)
0370: MOVEA.L    8(A6),A0              ; Input word
0374: MOVE.B     (A0),D7               ; First letter
0376: BNE.S      $037E
0378: MOVE.L     -11964(A5),D0         ; Empty = return root
037C: BRA.S      $03C2

; Get initial node
037E: MOVE.L     -11964(A5),D6         ; D6 = current node
0382: MOVE.L     D6,D0
0384: LSL.L      #3,D0                 ; *8
0388: ADD.L      -11968(A5),D0         ; Add base
038C: MOVEA.L    D0,A0
038E: MOVE.L     (A0),D5               ; D5 = DAWG entry

; Check for letter match
0390: CMP.B      D5,D7
0392: BNE.S      $03B0                 ; No match

; Letter matches
0394: MOVE.L     D5,D6                 ; Update current
0396: MOVEQ      #10,D0
0398: LSR.L      D0,D6                 ; Get child pointer

039C: ADDQ.L     #1,8(A6)              ; Advance input
03A0: MOVEA.L    8(A6),A0
03A2: MOVE.B     (A0),D7               ; Next letter
03A4: BNE.S      $03A8
03A6: MOVE.L     D6,D0                 ; End of word - return node
03A8: BRA.S      $03C2

03AA: TST.L      D6
03AC: BNE.S      $0382                 ; Continue search
03AE: MOVEQ      #-1,D0                ; Not found
03B0: BRA.S      $03C2

; Check sibling
03B2: BTST       #9,D5                 ; Last sibling?
03B4: BNE.S      $03BA
03B6: CMP.B      D5,D7
03B8: BGE.S      $03BE
03BA: MOVEQ      #-1,D0                ; Not found
03BC: BRA.S      $03C2

03BE: ADDQ.L     #1,D6                 ; Try next sibling
03C0: BRA.S      $0382

03C2: MOVEM.L    (SP)+,D5/D6/D7
03C6: UNLK       A6
03C8: RTS
```

### Function 0x03CA - Find Valid Letters for Position
```asm
03CA: LINK       A6,#-14
03CE: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
03D2: MOVEA.L    8(A6),A3              ; Word prefix
03D6: MOVEA.L    12(A6),A2             ; Output buffer
03DA: MOVE.L     A3,-4(A6)
03DE: MOVE.L     A2,-8(A6)
03E2: LEA        -1778(A5),A4          ; Result buffer

03E6: CLR.W      -10(A6)               ; Counter
03EA: LEA        -11960(A5),A0         ; DAWG table
03EE: MOVE.L     A0,-14(A6)

; Traverse for each letter set
03F2: MOVEA.L    -14(A6),A0
03F6: MOVE.L     (A0),-11968(A5)
03FA: MOVE.W     -10(A6),D0
03FE: MOVE.W     D0,-10936(A5)
0402: MOVEA.L    A5,A1
0404: EXT.L      D0
0406: LSL.L      #3,D0
040A: MOVE.L     -11956(A1,D0.L),-11964(A5)
0410: BEQ.W      $04C8                 ; No more

; Process with word prefix
0414: MOVEA.L    -4(A6),A3
0418: MOVEA.L    -8(A6),A2
041C: MOVE.L     A3,-(A7)
041E: JSR        -184(PC)              ; Traverse for word
0422: MOVE.L     D0,D6                 ; D6 = node
0424: TST.L      D6
0426: BLE.W      $04BC                 ; Not found

; Skip to end of prefix
042C: TST.B      (A3)+
042E: BNE.S      $042C

; Get node entry
0430: MOVE.L     D6,D0
0432: LSL.L      #3,D0
0436: ADD.L      -11968(A5),D0
043A: MOVEA.L    D0,A0
043C: MOVE.L     (A0),D3               ; D3 = node

; Get letter
043E: MOVE.B     (A2),D4               ; Expected letter
0440: CMP.B      D3,D4
0442: BGE.S      $0446
0444: ADDQ.L     #1,A2                 ; Next letter
0446: BRA.S      $04B6

; Check letter match
0448: CMP.B      D3,D4
044A: BNE.S      $04A2                 ; No match

; Letter found - check if valid word
044C: TST.B      (A3)
044E: BNE.S      $0458
0450: BTST       #8,D3                 ; End of word?
0454: BEQ.S      $04A0
0456: MOVE.B     D3,(A4)+              ; Store valid letter
0458: BRA.S      $04A0

; Continue with children
045A: MOVE.L     D3,D4
045C: MOVEQ      #10,D0
045E: LSR.L      D0,D4                 ; Child pointer
0460: BEQ.S      $04A0

; Recursive check
0462: MOVE.L     D7,D0
0464: MOVE.L     D4,D0
0468: LSL.L      #3,D0
046C: ADD.L      -11968(A5),D0
0470: MOVEA.L    D0,A0
0472: MOVE.L     (A0),D5               ; Child node

; Match child letter
0474: MOVEA.L    D7,A0
0476: CMP.B      (A0),D5
0478: BNE.S      $0490                 ; No match

; Found child match
047C: TST.B      (A0)
047E: BNE.S      $0486
0480: BTST       #8,D5                 ; End of word?
0484: BEQ.S      $04A0
0486: MOVE.B     D3,(A4)+              ; Store letter
0488: BRA.S      $04A0

; Check child siblings
0490: BTST       #9,D5                 ; Last sibling?
0494: BNE.S      $04A0
0496: MOVEA.L    D7,A0
0498: CMP.B      (A0),D5
049A: BGT.S      $04A0
049C: ADDQ.L     #1,D4                 ; Next sibling
049E: BRA.S      $0462

04A0: ADDQ.L     #1,A2                 ; Next expected

; Check sibling
04A2: BTST       #9,D3                 ; Last sibling?
04A6: BNE.S      $04BA
04A8: ADDQ.L     #1,D6
04AA: MOVE.L     D6,D0
04AC: LSL.L      #3,D0
04B0: ADD.L      -11968(A5),D0
04B4: MOVEA.L    D0,A0
04B6: MOVE.L     (A0),D3
04B8: BRA.S      $043C

04BA: ADDQ.W     #1,-10(A6)            ; Next letter set
04BE: ADDQ.L     #4,-14(A6)
04C2: BRA.W      $03F4

04C6: CLR.B      (A4)                  ; Null terminate

04C8: LEA        -1778(A5),A0          ; Return result buffer
04CC: MOVE.L     A0,D0

04CE: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
04D2: UNLK       A6
04D4: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1064 | Character class table |
| A5-1714 | Row validation buffer |
| A5-1778 | Valid letter result buffer |
| A5-10632 | Position letter counts |
| A5-10636 | Rack pointer storage |
| A5-10704 | Position data 2 |
| A5-10738 | Position data 1 |
| A5-10746 | Traversal position pointer |
| A5-10750 | Letter data pointer |
| A5-10754 | Board pointer storage |
| A5-10758 | Current move pointer |
| A5-10936 | Letter set index |
| A5-11960 | DAWG table array |
| A5-11964 | Current DAWG node |
| A5-11968 | DAWG base pointer |
| A5-17018 | Board offset base |
| A5-17137 | g_state1 + 17 (skip border) |
| A5-17154 | g_state1 |
| A5-17156 | Row counter |
| A5-22118 | Cross-check array base |
| A5-23218 | Letter count array |
| A5-26158 | g_rack pointer |
| A5-26542 | Letter mask table |
| A5-27093 | Position constraint 1 |
| A5-27110 | Letter data base |
| A5-27127 | Position constraint 2 |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | bounds_error |
| 426 | memset |
| 2002 | Check if letter playable |
| 2338 | Calculate board position |
| 3450 | memcmp |
| 3466 | memmove |
| 3522 | strlen |

## DAWG Node Format

Each DAWG node is 4 bytes:
```
Byte 0:    Letter code (a=1, b=2, ...)
Byte 1:    Flags
           Bit 0: End of word
           Bit 1: Last sibling
Bytes 2-3: Child pointer (scaled by 8)
```

Traversal uses 8-byte entries in the node table, with the actual DAWG node in the first 4 bytes.

## Cross-Check Generation

Cross-check sets determine which letters can be played at each position based on perpendicular words:
1. For each empty cell, check if adjacent cells have letters
2. If no adjacent letters, all letters are valid (all bits set)
3. If adjacent letters exist, traverse DAWG to find valid extensions
4. Result stored as 32-bit mask (one bit per letter)

## Confidence: HIGH

Clear DAWG traversal patterns:
- Node format with letter, flags, child pointer
- Recursive traversal for word validation
- Cross-check set generation for move generation
- Position constraint checking
