# CODE 37 Detailed Analysis - DAWG Traversal and Word Validation

## Overview

| Property | Value |
|----------|-------|
| Size | 5344 bytes |
| JT Offset | 2560 |
| JT Entries | 4 |
| Functions | ~10 |
| Purpose | **DAWG traversal, word lookup, cross-check generation** |


## System Role

**Category**: DAWG Engine
**Function**: Extended Word Checks

Additional word validation
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

---

## Speculative C Translation

### Header File (code37_dawg.h)

```c
/*
 * CODE 37 - DAWG Traversal and Word Validation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * This module implements DAWG (Directed Acyclic Word Graph) operations
 * for dictionary word validation and cross-check set generation.
 */

#ifndef CODE37_DAWG_H
#define CODE37_DAWG_H

#include <stdint.h>
#include <stdbool.h>

/*
 * DAWG Node Format (4 bytes):
 * Bits 0-7:   Letter code (a=1, b=2, ..., z=26, ?=63 for blank)
 * Bit 8:      End-of-word flag (EOW)
 * Bit 9:      Last-sibling flag
 * Bits 10-31: Child pointer (22 bits, scaled by 8)
 */
typedef uint32_t DAWGNode;

/* DAWG node field extraction macros */
#define DAWG_LETTER(node)       ((node) & 0xFF)
#define DAWG_IS_EOW(node)       (((node) >> 8) & 1)
#define DAWG_IS_LAST(node)      (((node) >> 9) & 1)
#define DAWG_CHILD_PTR(node)    ((node) >> 10)

/* Cross-check entry per position (4 bytes = 32-bit letter mask) */
typedef uint32_t CrossCheckMask;

/* Cross-check structure for one row (68 bytes) */
typedef struct CrossCheckRow {
    uint32_t flags;                 /* +0: Row flags */
    CrossCheckMask columns[16];     /* +4: Mask for each column (1-15) */
    uint32_t padding;               /* +64: Alignment padding */
} CrossCheckRow;

/*
 * Global variables (A5-relative)
 */
extern int8_t    g_char_class[256];     /* A5-1064: Character classification */
extern uint8_t   g_row_buffer[17];      /* A5-1714: Row validation buffer */
extern char      g_valid_letters[64];   /* A5-1778: Valid letter result buffer */
extern int8_t    g_position_counts[128];/* A5-10632: Position letter counts */
extern char*     g_rack_ptr_storage;    /* A5-10636: Rack pointer storage */
extern uint8_t   g_position_data1[34];  /* A5-10704: Position data area 1 */
extern uint8_t   g_position_data2[34];  /* A5-10738: Position data area 2 */
extern uint8_t*  g_traversal_ptr;       /* A5-10746: Traversal position pointer */
extern uint8_t*  g_letter_data_ptr;     /* A5-10750: Letter data pointer */
extern uint8_t*  g_board_ptr;           /* A5-10754: Board pointer storage */
extern uint8_t*  g_current_move_ptr;    /* A5-10758: Current move pointer */
extern uint16_t  g_letter_set_index;    /* A5-10936: Letter set index */
extern DAWGNode* g_dawg_table[8];       /* A5-11960: DAWG table array */
extern uint32_t  g_current_dawg_node;   /* A5-11964: Current DAWG node value */
extern DAWGNode* g_dawg_base_ptr;       /* A5-11968: DAWG base pointer */
extern uint8_t   g_board_offset[289];   /* A5-17018: Board offset base */
extern uint8_t   g_state1[544];         /* A5-17154: Board letter array (17*32) */
extern uint16_t  g_row_counter;         /* A5-17156: Row counter */
extern CrossCheckRow g_crosschecks[31]; /* A5-22118: Cross-check array */
extern int8_t    g_letter_counts[128];  /* A5-23218: Letter count array */
extern char*     g_rack;                /* A5-26158: Current rack pointer */
extern uint32_t  g_letter_masks[64];    /* A5-26542: Letter mask table */

/* Position constraints */
extern int8_t g_constraint1[32];        /* A5-27127 */
extern int8_t g_constraint2[32];        /* A5-26583 */
extern int8_t g_constraint3[32];        /* A5-27093 */
extern int8_t g_constraint4[32];        /* A5-26549 */

/* Letter data base */
extern uint8_t g_letter_data[256];      /* A5-27110 */

/* Function prototypes */
void init_position_tracking(void* input_data);
void setup_board_context(char* rack, uint8_t* move_struct);
void generate_crosscheck_sets(void);
uint32_t traverse_dawg_for_word(char* word);
char* find_valid_letters_for_position(char* prefix, char* expected_letters);

#endif /* CODE37_DAWG_H */
```

### Implementation File (code37_dawg.c)

```c
/*
 * CODE 37 - DAWG Traversal and Word Validation Implementation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * The DAWG is the core dictionary data structure enabling
 * efficient word lookup and move generation.
 */

#include "code37_dawg.h"
#include <string.h>

/* External Toolbox/JT functions */
extern void memset_jt(void* dest, int val, size_t size);  /* JT[426] */
extern int memcmp_jt(void* a, void* b, size_t size);      /* JT[3450] */
extern void memmove_jt(void* dest, void* src, size_t sz); /* JT[3466] */
extern int is_playable(int letter);                        /* JT[2002] */
extern void calc_position(int row, int col, int* out1, int* out2); /* JT[2338] */
extern void bounds_error(void);                            /* JT[418] */

/*
 * init_position_tracking - Function at 0x0000
 *
 * Initializes the board position tracking structures.
 * Called when the board state changes and cross-checks
 * need to be regenerated.
 *
 * Parameters:
 *   input_data - Data to copy/validate
 */
void init_position_tracking(void* input_data)
{
    uint16_t local_buffer[48];  /* 96 bytes / 2 = 48 words */
    int i;

    /* Check if board state has changed (544 bytes = 17*32) */
    if (memcmp_jt(g_state1, input_data, 544) == 0) {
        /* No changes - just initialize word array */
        goto init_word_array;
    }

    /* Board changed - reinitialize position tracking */
    /* Copy and validate input */
    /* uncertain - internal helper at PC+172 */

    g_row_counter = 7;  /* Reset counter */

    /* Clear position data areas */
    memset_jt(g_position_data2, 0, 34);
    memset_jt(g_position_data1, 0, 34);

    /* Setup move structure direction */
    g_current_move_ptr[32] = 8;  /* Direction = horizontal */

    /* Adjust traversal pointer */
    g_traversal_ptr = g_current_move_ptr - 1;

    /* Initialize board tracking */
    g_board_ptr = &g_board_offset[0];

    /* Setup initial position */
    /* Call internal setup at PC+2018 with position 8 */

    /* Initialize letter data pointer */
    g_letter_data_ptr = g_letter_data;

    /*
     * Main initialization loop - process DAWG table
     */
    int index = 0;
    DAWGNode** dawg_ptr = g_dawg_table;

    while (1) {
        g_dawg_base_ptr = (DAWGNode*)(*dawg_ptr);
        g_letter_set_index = index;

        /* Get child pointer from table */
        uint32_t child_ptr = (uint32_t)g_dawg_table[index];  /* uncertain */
        if (child_ptr == 0) {
            break;  /* End of table */
        }

        g_current_dawg_node = child_ptr;

        /* Process this DAWG node - call internal function at PC+430 */
        /* process_dawg_node(child_ptr); */

        index++;
        dawg_ptr++;
    }

init_word_array:
    /* Initialize local word array with -1 markers */
    for (i = 0; i < 31; i++) {
        local_buffer[i] = 0xFFFF;  /* Mark as invalid */
    }

    /* Process words - call internal function at PC+1772 */
    /* process_words(local_buffer, input_data); */
}

/*
 * setup_board_context - Function at 0x00D2
 *
 * Sets up the board context for move evaluation.
 * Copies letter counts and initializes position data.
 *
 * Parameters:
 *   rack - Pointer to player's rack letters
 *   move_struct - Pointer to move structure (34 bytes)
 */
void setup_board_context(char* rack, uint8_t* move_struct)
{
    /* Clear position data array (128 bytes) */
    memset_jt(g_position_counts, 0, 128);

    /* Store move pointer */
    g_current_move_ptr = move_struct;

    /* Clear move structure */
    memset_jt(move_struct, 0, 34);

    /* Copy letter counts to position counts */
    memmove_jt(g_position_counts, g_letter_counts, 128);

    /* Store rack pointer */
    g_rack_ptr_storage = rack;
}

/*
 * generate_crosscheck_sets - Function at 0x010E
 *
 * Generates cross-check sets for all board positions.
 * A cross-check set contains the valid letters that can
 * be played at a position based on perpendicular words.
 *
 * This is the Appel-Jacobson cross-check generation algorithm.
 */
void generate_crosscheck_sets(void)
{
    int row, col;
    uint32_t row_above_offset, row_below_offset;

    /* Validate that we have new row data */
    if (memcmp_jt(g_row_buffer, g_state1, 17) == 0) {
        bounds_error();  /* Should not be identical */
    }

    /*
     * Process each row (1-30, with 0 and 31 being borders)
     */
    CrossCheckRow* crosscheck_row = g_crosschecks;
    uint32_t board_row_ptr = (uint32_t)&g_state1[17];  /* Skip border */

    for (row = 1; row < 31; row++) {
        /*
         * Get pointers to row above and below for cross-check calculation
         */
        if (row == 1 || row == 16) {
            /* First/last playable row - use default buffer */
            row_above_offset = (uint32_t)g_row_buffer;
        } else {
            row_above_offset = (uint32_t)&g_state1[(row - 1) * 17];
        }

        g_board_ptr = (uint8_t*)board_row_ptr;

        if (row == 15 || row == 30) {
            row_below_offset = (uint32_t)g_row_buffer;
        } else {
            row_below_offset = (uint32_t)&g_state1[(row + 1) * 17];
        }

        /*
         * Process each column in this row
         */
        CrossCheckMask* crosscheck_ptr = &crosscheck_row->columns[0];

        for (col = 1; col < 16; col++) {
            uint8_t* board_cell = g_board_ptr + col;

            /* Check if cell is occupied */
            if (*board_cell != 0) {
                /* Cell has a letter - cross-check is that letter's mask */
                uint8_t letter = *board_cell;
                *crosscheck_ptr = g_letter_masks[letter * 2];  /* uncertain - *8 or *2 */
                goto next_column;
            }

            /* Check if adjacent cells (above/below) are empty */
            uint8_t* above = (uint8_t*)(row_above_offset + col);
            uint8_t* below = (uint8_t*)(row_below_offset + col);

            if (*above == 0 && *below == 0) {
                /* No adjacent letters - all letters valid */
                *crosscheck_ptr = 0xFFFFFFFF;  /* All bits set */
                goto next_column;
            }

            /*
             * Has adjacent letter - compute cross-check from DAWG
             */
            int16_t crossword_row, crossword_col;
            calc_position(row, col, &crossword_row, &crossword_col);

            /* Calculate cross-word starting position */
            uint32_t crossword_offset = crossword_row * 17 + crossword_col;
            uint8_t* crossword_ptr = &g_state1[crossword_offset] - 1;

            /* Find start of cross-word (scan backwards to empty) */
            while (*crossword_ptr != 0) {
                crossword_ptr--;
            }
            crossword_ptr++;  /* Step forward to first letter */

            /* Clear cross-check mask */
            *crosscheck_ptr = 0;

            /*
             * Query DAWG for valid letters
             * find_valid_letters_for_position returns letters that
             * form valid words when added at this position
             */
            char* valid = find_valid_letters_for_position(
                (char*)crossword_ptr,
                (char*)(g_rack + 1)
            );

            /* OR each valid letter's mask into cross-check */
            while (*valid != 0) {
                uint8_t letter = *valid++;
                *crosscheck_ptr |= g_letter_masks[letter * 2];  /* uncertain */
            }

        next_column:
            crosscheck_ptr++;
        }

        /* Advance to next row */
        crosscheck_row++;  /* +68 bytes */
        board_row_ptr += 17;
    }
}

/*
 * traverse_dawg_for_word - Function at 0x0368
 *
 * Traverses the DAWG to find a word, returning the node
 * at the end of the word (or -1 if not found).
 *
 * Parameters:
 *   word - Null-terminated string to look up
 *
 * Returns:
 *   DAWG node index at end of word, or -1 if not found
 */
uint32_t traverse_dawg_for_word(char* word)
{
    uint8_t current_letter = *word;

    if (current_letter == 0) {
        /* Empty word - return root node */
        return g_current_dawg_node;
    }

    uint32_t node_index = g_current_dawg_node;

    while (1) {
        /* Get DAWG node at current index */
        uint32_t node_offset = node_index * 8;  /* 8 bytes per entry in table */
        DAWGNode node = *(DAWGNode*)((uint8_t*)g_dawg_base_ptr + node_offset);

        uint8_t node_letter = DAWG_LETTER(node);

        /* Check for letter match */
        if (node_letter == current_letter) {
            /* Match found - get child pointer */
            node_index = DAWG_CHILD_PTR(node);

            /* Advance to next letter in word */
            word++;
            current_letter = *word;

            if (current_letter == 0) {
                /* End of word - return current node */
                return node_index;
            }

            if (node_index == 0) {
                /* No children but more letters - not found */
                return (uint32_t)-1;
            }

            continue;
        }

        /* Check if this is last sibling */
        if (DAWG_IS_LAST(node)) {
            return (uint32_t)-1;  /* Not found */
        }

        /* Check if we've passed the target letter */
        if (node_letter > current_letter) {
            return (uint32_t)-1;  /* Not found (list is sorted) */
        }

        /* Try next sibling */
        node_index++;
    }
}

/*
 * find_valid_letters_for_position - Function at 0x03CA
 *
 * Finds all letters that can be played at a position to form
 * valid cross-words. Used for cross-check generation.
 *
 * Parameters:
 *   prefix - Letters before the position (cross-word prefix)
 *   expected_letters - Letters to check (from rack)
 *
 * Returns:
 *   Pointer to buffer containing valid letters (null-terminated)
 */
char* find_valid_letters_for_position(char* prefix, char* expected_letters)
{
    char* result_buffer = g_valid_letters;
    char* result_ptr = result_buffer;
    char* saved_prefix = prefix;
    char* saved_expected = expected_letters;
    DAWGNode** dawg_table_ptr = g_dawg_table;
    int letter_set_index = 0;

    /*
     * Iterate through DAWG tables (multiple dictionaries possible)
     */
    while (1) {
        g_dawg_base_ptr = *dawg_table_ptr;
        g_letter_set_index = letter_set_index;

        /* Get root node for this letter set */
        uint32_t root_node = (uint32_t)g_dawg_table[letter_set_index];  /* uncertain */
        if (root_node == 0) {
            break;  /* No more letter sets */
        }

        g_current_dawg_node = root_node;

        /* Reset to original prefix */
        prefix = saved_prefix;
        expected_letters = saved_expected;

        /* Traverse for prefix */
        uint32_t node_index = traverse_dawg_for_word(prefix);

        if ((int32_t)node_index <= 0) {
            goto next_letter_set;  /* Prefix not found */
        }

        /* Skip to end of prefix */
        while (*prefix != 0) prefix++;

        /* Get node at end of prefix */
        uint32_t node_offset = node_index * 8;
        DAWGNode node = *(DAWGNode*)((uint8_t*)g_dawg_base_ptr + node_offset);

        /*
         * Check each expected letter to see if it forms a valid word
         */
        uint8_t expected = *expected_letters;

        while (expected != 0) {
            uint8_t node_letter = DAWG_LETTER(node);

            if (node_letter < expected) {
                expected_letters++;
                expected = *expected_letters;
                continue;
            }

            if (node_letter == expected) {
                /* Letter matches - check if forms valid word */
                if (*prefix == 0) {
                    /* No suffix - check end-of-word flag */
                    if (DAWG_IS_EOW(node)) {
                        *result_ptr++ = node_letter;
                    }
                } else {
                    /* Has suffix - need to check children */
                    uint32_t child_ptr = DAWG_CHILD_PTR(node);
                    if (child_ptr != 0) {
                        /* Check if suffix is valid from children */
                        /* uncertain - recursive check logic */
                        uint32_t suffix_offset = child_ptr * 8;
                        DAWGNode child = *(DAWGNode*)((uint8_t*)g_dawg_base_ptr + suffix_offset);

                        /* Match suffix letters */
                        char* suffix_ptr = prefix;
                        while (*suffix_ptr != 0) {
                            if (DAWG_LETTER(child) == *suffix_ptr) {
                                if (*(suffix_ptr + 1) == 0 && DAWG_IS_EOW(child)) {
                                    *result_ptr++ = node_letter;
                                }
                                break;
                            }

                            if (DAWG_IS_LAST(child)) {
                                break;
                            }
                            child_ptr++;
                            child = *(DAWGNode*)((uint8_t*)g_dawg_base_ptr + child_ptr * 8);
                        }
                    }
                }

                expected_letters++;
                expected = *expected_letters;
            }

            /* Check last sibling flag */
            if (DAWG_IS_LAST(node)) {
                break;
            }

            node_index++;
            node = *(DAWGNode*)((uint8_t*)g_dawg_base_ptr + node_index * 8);
        }

    next_letter_set:
        letter_set_index++;
        dawg_table_ptr++;
    }

    /* Null-terminate result */
    *result_ptr = 0;

    return result_buffer;
}

/*
 * process_dawg_node - Function at 0x024A (internal helper)
 *
 * Recursively processes a DAWG node during initialization,
 * checking for valid word placements on the board.
 *
 * This implements the core of the Appel-Jacobson move generation
 * algorithm for the initialization phase.
 */
static void process_dawg_node(uint32_t node_ptr)
{
    uint32_t node_offset;
    DAWGNode node;
    uint8_t letter;
    int8_t* letter_count_ptr;

    /* Increment traversal counter */
    g_traversal_ptr++;

    /* Get DAWG node */
    node_offset = node_ptr * 8;
    node = *(DAWGNode*)((uint8_t*)g_dawg_base_ptr + node_offset);
    letter = DAWG_LETTER(node);

    /* Store letter at traversal position */
    *g_traversal_ptr = letter;

    /* Validate letter is valid character */
    if (g_char_class[letter] >= 0) {
        bounds_error();  /* Invalid character */
    }

    /* Get letter availability */
    letter_count_ptr = &g_position_counts[letter];

    if (*letter_count_ptr == 0) {
        /* Letter not available in rack */
        goto check_sibling;
    }

    /* Decrement available count */
    (*letter_count_ptr)--;

    /* Check end-of-word flag */
    if (!DAWG_IS_EOW(node)) {
        goto try_children;
    }

    /*
     * Found valid word ending - try placements
     */
    uint32_t word_len = g_traversal_ptr - g_current_move_ptr;
    int16_t start_pos = 8 - word_len;  /* Starting position (row 8 = center) */

    while (start_pos <= 8) {
        g_current_move_ptr[33] = start_pos;  /* Set row */
        g_current_move_ptr[24] = 0;  /* Clear score */
        g_current_move_ptr[25] = 0;
        g_current_move_ptr[26] = 0;
        g_current_move_ptr[27] = 0;

        int16_t pos = start_pos;
        uint8_t* word_ptr = g_current_move_ptr;

        /* Check each letter position for constraints */
        while (*word_ptr != 0) {
            uint8_t current = *word_ptr;

            if (!is_playable(current)) {
                goto next_position;
            }

            /* Check position constraints */
            if (g_constraint1[pos] > 1) goto valid_position;
            if (g_constraint2[pos] > 1) goto valid_position;
            if (g_constraint3[pos] > 1) goto valid_position;
            if (g_constraint4[pos] <= 1) goto next_position;

        valid_position:
            /* Valid - increment match count */
            (*(uint32_t*)&g_current_move_ptr[24])++;

        next_position:
            pos++;
            word_ptr++;
        }

        /* Process this valid word placement */
        /* Internal handler at PC+2858 */

        /* Clear score for next iteration */
        g_current_move_ptr[24] = 0;

        start_pos++;
    }

try_children:
    /* Check for child nodes */
    {
        uint32_t child_ptr = DAWG_CHILD_PTR(node);
        if (child_ptr != 0) {
            /* Recurse into children */
            process_dawg_node(child_ptr);
        }
    }

    /* Restore letter count */
    (*letter_count_ptr)++;

check_sibling:
    /* Check last sibling flag */
    if (!DAWG_IS_LAST(node)) {
        /* Process next sibling */
        process_dawg_node(node_ptr + 1);
    }

    /* Backtrack */
    *g_traversal_ptr = 0;
    g_traversal_ptr--;
}
```

### Key Algorithmic Notes

```
DAWG NODE FORMAT:
=================
4 bytes packed as follows:
- Bits 0-7:   Letter code (1-26 for a-z, 63 for blank)
- Bit 8:      End-of-word (EOW) flag
- Bit 9:      Last-sibling flag
- Bits 10-31: Child pointer index (22 bits)

Nodes are stored in 8-byte table entries (for alignment).

CROSS-CHECK GENERATION:
=======================
For each empty board position:
1. Check if adjacent cells (above/below for horizontal moves) are empty
2. If empty: all 26 letters are valid (mask = 0xFFFFFFFF)
3. If occupied: traverse DAWG to find letters forming valid cross-words

Cross-check masks are 32 bits:
- Bit N set = letter N is valid at this position
- Used to quickly filter rack letters during move generation

APPEL-JACOBSON ALGORITHM:
=========================
The DAWG traversal implements Appel-Jacobson move generation:
1. Anchor squares: positions adjacent to existing tiles
2. For each anchor: try placing letters from rack
3. Extend left (prefix) and right (suffix) from anchor
4. Validate cross-words using cross-check masks
5. Validate main word in DAWG

BOARD COORDINATE SYSTEM:
========================
- Board is 17x32 bytes (includes borders)
- Row 0 and 16 are borders
- Columns 1-15 are playable
- Cross-checks stored per row (68 bytes each)

MULTIPLE LETTER SETS:
=====================
g_dawg_table can contain multiple DAWG roots for:
- Different dictionaries (TWL vs SOWPODS)
- Challenge word verification
- Pattern matching modes
```
