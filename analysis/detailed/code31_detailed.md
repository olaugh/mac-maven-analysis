# CODE 31 Detailed Analysis - Tile/Word Placement and Board Serialization

## Overview

| Property | Value |
|----------|-------|
| Size | 2510 bytes |
| JT Offset | 2264 |
| JT Entries | 15 |
| Functions | ~15 |
| Purpose | **Tile placement validation, board serialization, move application** |


## System Role

**Category**: Scoring
**Function**: Word Score

Word score calculation
## Architecture Role

CODE 31 manages:
1. Apply words/tiles to the board state
2. Validate and process move data
3. Serialize/deserialize board state
4. Track letter counts during placement

## Key Data Structures

Move structure referenced (at least 34 bytes):
```
+0:   next pointer
+16:  score (long)
+18:  bonus data
+20:  word start (string)
+32:  direction/flags
+33:  row position
```

## Key Functions

### Function 0x0000 - Count Empty Cells in Word Path
```asm
0000: LINK       A6,#0
0004: MOVEM.L    A2/A3/A4,-(SP)
0008: MOVEA.L    8(A6),A3              ; A3 = move data
000C: CLR.W      -20010(A5)            ; Clear counter
0010: MOVEA.L    A3,A4                 ; A4 = copy
0012: MOVE.B     33(A3),D0             ; D0 = row
0016: EXT.W      D0
0018: MOVE.B     32(A3),D1             ; D1 = direction
001C: EXT.W      D1
; ... calculate board position pointer ...
0030: TST.B      (A2)                  ; Check if cell occupied
0032: BNE.S      $0038                 ; Skip if occupied
0034: ADDQ.W     #1,-20010(A5)         ; Increment empty count
0038: ADDQ.L     #1,A4                 ; Next position
003A: ADDQ.L     #1,A2                 ; Next board cell
003C: TST.B      (A4)                  ; More letters?
003E: BNE.S      $0030                 ; Continue loop
0040: MOVEM.L    (SP)+,A2/A3/A4
0044: UNLK       A6
0046: RTS
```

**C equivalent**:
```c
void count_empty_cells(Move* move) {
    g_empty_count = 0;  // A5-20010
    char* word = &move->word[0];
    int row = move->row;           // offset 33
    int dir = move->direction;     // offset 32

    char* board_ptr = calculate_board_ptr(row, dir);

    while (*word) {
        if (*board_ptr == 0) {
            g_empty_count++;
        }
        word++;
        board_ptr++;
    }
}
```

### Function 0x0048 - Count Tiles in Row
```asm
0048: LINK       A6,#0
004C: MOVE.L     A4,-(A7)
004E: MOVEQ      #17,D0                ; Board width
0050: MULS.W     8(A6),D0              ; row * 17
0054: MOVEA.L    10(A6),A4
0056: LEA        -17155(A4),A4         ; Board base (off by 1?)
005A: ADDA.L     D0,A0                 ; Board[row]
0060: MOVEA.L    D0,A4
0062: BRA.S      $0066
0064: ; count non-empty loop
0068: BNE.S      $0064
006A: MOVE.L     A4,D0                 ; Return count
006C: ADDQ.L     #1,D0
006E: MOVEA.L    (A7)+,A4
0070: UNLK       A6
0072: RTS
```

### Function 0x0074 - Calculate Search Bounds
```asm
0074: LINK       A6,#-2
0078: CMPI.W     #16,8(A6)             ; Compare position
007E: BGE.S      $0096                 ; >= 16?
0080: MOVEQ      #15,D0                ; Max = 15
0086: MOVEA.L    12(A6),A0
008A: MOVE.W     D0,(A0)               ; Store max
008C: MOVEA.L    16(A6),A1
0090: MOVE.W     8(A6),(A1)            ; Store min = position
0094: BRA.S      $00AA
0096: MOVEA.L    12(A6),A0
009A: MOVE.W     10(A6),(A0)           ; Store position
009E: MOVEQ      #-15,D0               ; Offset
00A4: MOVEA.L    16(A6),A1
00A8: MOVE.W     D0,(A1)               ; Store result
00AA: UNLK       A6
00AC: RTS
```

**C equivalent**:
```c
void calc_search_bounds(int pos, int* max_out, int* min_out) {
    if (pos < 16) {
        *max_out = 15;
        *min_out = pos;
    } else {
        *max_out = pos;
        *min_out = -15;  // Search backwards
    }
}
```

### Function 0x00AE - Check Board State Validity
```asm
00AE: TST.B      -15522(A5)            ; g_field_22
00B2: BEQ.S      $00D6                 ; Not set, valid
00B4: TST.B      -15514(A5)            ; g_field_14
00B8: BEQ.S      $00D6                 ; Not set, valid
00BA: CMPI.W     #6,-19470(A5)         ; Check state
00C0: BEQ.S      $00D6                 ; Valid state
00C2: CMPI.W     #2,-19470(A5)         ; Check state 2
00C8: BNE.S      $00D2
00CA: JSR        56(PC)                ; Additional check
00CE: TST.W      D0
00D0: BEQ.S      $00D6                 ; Passed
00D2: MOVEQ      #0,D0                 ; Invalid
00D4: BRA.S      $00D8
00D6: MOVEQ      #1,D0                 ; Valid
00D8: RTS
```

### Function 0x00DA - Count Tiles on Board
```asm
00DA: LINK       A6,#-4
00DE: MOVEM.L    D7/A4,-(SP)
00E2: MOVEQ      #0,D7                 ; D7 = count
00E4: LEA        -17137(A5),A4         ; Board area (offset from g_state1)
00E8: BRA.S      $00F2
00EA: TST.B      (A4)                  ; Check cell
00EC: BEQ.S      $00F0                 ; Empty
00EE: ADDQ.W     #1,D7                 ; Count++
00F0: ADDQ.L     #1,A4                 ; Next cell
00F2: LEA        -16882(A5),A0         ; End of board area
00F6: CMPA.L     A4,A0                 ; Reached end?
00FA: BHI.S      $00EA                 ; Continue
00FC: MOVE.W     D7,D0                 ; Return count
00FE: MOVEM.L    (SP)+,D7/A4
0102: UNLK       A6
0104: RTS
```

**C equivalent**:
```c
int count_tiles_on_board() {
    int count = 0;
    char* ptr = g_board + 17;  // Skip border row
    char* end = g_board + 272; // 17*16 - 17

    while (ptr < end) {
        if (*ptr != 0) count++;
        ptr++;
    }
    return count;
}
```

### Function 0x0104 - Check High Tile Count
```asm
0104: JSR        -44(PC)               ; count_tiles_on_board
0108: CMPI.W     #79,D0                ; Compare with 79
010C: SLE        D0                    ; Set if <= 79
010E: NEG.B      D0                    ; Convert to boolean
0110: EXT.W      D0
0112: RTS
```

### Function 0x0114 - Check Low Tile Count
```asm
0114: JSR        -60(PC)               ; count_tiles_on_board
0118: CMPI.W     #86,D0                ; Compare with 86
011C: SGE        D0                    ; Set if >= 86
011E: NEG.B      D0                    ; Convert to boolean
0120: EXT.W      D0
0122: RTS
```

### Function 0x0124 - Get Letter Value with Cap
```asm
0124: LINK       A6,#0
0128: MOVE.L     D7,-(A7)
012A: MOVEA.L    A5,A0
012C: MOVE.W     8(A6),D0              ; Get letter
0130: ADDA.W     D0,A0
0132: ADDA.W     D0,A0
0134: MOVE.W     -27630(A0),D7         ; Get letter value
0138: CMPI.W     #100,D7               ; Cap at 100?
013C: BGE.S      $0142
013E: MOVE.W     D7,D0                 ; Return value
0140: BRA.S      $014A
0142: MOVE.L     D7,D0                 ; Value >= 100
0144: EXT.L      D0
0146: DIVU.W     #100,D0               ; Divide by 100
014A: UNLK       A6
014E: RTS
```

### Function 0x0150 - Copy Word to Global Buffer
```asm
0150: LINK       A6,#0
0154: PEA        33                    ; Size (33 bytes)
0158: PEA        -2762(A5)             ; g_word_buffer
015C: MOVE.L     8(A6),-(A7)           ; Source string
0160: JSR        3466(A5)              ; JT[3466] - memmove
0164: UNLK       A6
0166: RTS
```

### Function 0x0168 - Copy from Global Buffer
```asm
0168: LINK       A6,#0
016C: PEA        33                    ; Size
0170: MOVE.L     8(A6),-(A7)           ; Dest
0174: PEA        -2762(A5)             ; g_word_buffer
0178: JSR        3466(A5)              ; JT[3466] - memmove
017C: UNLK       A6
017E: RTS
```

### Function 0x0180 - Apply Move to Board (Main)
```asm
0180: LINK       A6,#-2150             ; Large frame
0184: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0188: MOVEA.L    8(A6),A3              ; A3 = move data
018C: MOVEA.L    12(A6),A2             ; A2 = rack
0190: LEA        32(A3),A4             ; A4 = word in move
0194: MOVE.B     (A4),-2762(A5)        ; Copy first char
0198: MOVEQ      #1,D7                 ; D7 = index

019A: TST.W      16(A6)                ; Check flag
019E: BEQ.W      $0264                 ; Skip validation

; Validation and setup
01A2: PEA        -2106(A6)             ; Local buffer 1
01A6: PEA        -1082(A6)             ; Local buffer 2
01AA: MOVE.L     A3,-(A7)              ; Push move
01AC: JSR        2530(A5)              ; JT[2530] - validate

; Clear DAWG info
01B0: MOVEQ      #88,D0                ; Size
01B2: MOVE.L     D0,(A7)
01B4: PEA        -23488(A5)            ; g_dawg_info
01B8: JSR        426(A5)               ; JT[426] - memset

; Store original positions
01BC: MOVE.B     -23112(A5),D0         ; Various game state
01C0: EXT.W      D0
01C2: MOVE.W     D0,-2122(A6)          ; Store locally
; ... more state saving ...

; Get rack string length
01EE: MOVE.L     A2,(A7)               ; Push rack
01F0: JSR        3522(A5)              ; JT[3522] - strlen
01F4: MOVE.W     D0,-2136(A6)          ; Store length

; Loop through letters a-z checking rack
01FC: MOVEQ      #97,D3                ; 'a'
0202: BRA.S      $0242
0204: MOVEA.L    A5,A0
0206: ADDA.W     D3,A0
0208: MOVE.B     -23218(A0),D5         ; Get letter count
020C: EXT.W      D5
020E: TST.W      D5
0210: BEQ.S      $0240                 ; Skip if zero

0212: MOVE.W     D3,-(A7)              ; Push letter
0214: JSR        2002(A5)              ; JT[2002] - check if playable
0218: TST.W      D0
021A: ...                              ; Process result

0240: ADDQ.W     #1,D3                 ; Next letter
0242: CMPI.W     #122,D3               ; 'z'
0246: BLE.S      $0204                 ; Continue loop

; Check for special conditions
0248: CMPI.W     #6,D6
024C: BLT.S      $0256
024E: MOVEQ      #1,D0
0250: MOVE.L     D0,-23416(A5)         ; Set flag
0254: BRA.S      $0262
0256: CMPI.W     #6,D4
025A: BLT.S      $0262
025C: MOVEQ      #1,D0
025E: MOVE.L     D0,-23420(A5)         ; Set other flag

; Apply tiles to board
02A6: CLR.W      -19470(A5)            ; Clear state
02AA: LEA        -34(A6),A0            ; Local copy of move
02AE: LEA        (A3),A1               ; Source
02B0: MOVEQ      #7,D0                 ; Copy 8 longs
02B2: MOVE.L     (A1)+,(A0)+
02B4: DBF        D0,$02B2
02B8: MOVE.W     (A1)+,(A0)+           ; Plus 2 bytes

; Call validation
02BA: PEA        -50(A6)
02BE: MOVE.L     A2,-(A7)              ; Rack
02C0: PEA        -34(A6)               ; Move copy
02C4: JSR        2442(A5)              ; JT[2442] - validate_move
02C8: MOVE.L     D0,-18(A6)            ; Store result

; Callback if registered
02DA: TST.L      -19474(A5)            ; Check callback
02DE: BEQ.S      $02EC
02E0: PEA        -34(A6)
02E4: MOVEA.L    -19474(A5),A0         ; Get callback
02E8: JSR        (A0)                  ; Call it

; Place tiles on board
02EC: MOVE.B     (A4),D4               ; Current letter
02EE: EXT.W      D4
02F0: MOVE.B     33(A3),D3             ; Row position
02F4: EXT.W      D3

; Calculate board addresses
02F6: PEA        -2110(A6)             ; Output 1
02FA: PEA        -2108(A6)             ; Output 2
02FE: MOVE.W     D3,-(A7)              ; Row
0300: MOVE.W     D4,-(A7)              ; Column
0302: JSR        -656(PC)              ; calc_search_bounds

; Setup board pointers
0308: MOVEA.L    A3,A4
030A: MOVEQ      #17,D0
030C: MULS.W     D4,D0
030E: LEA        -17154(A5),A0         ; g_state1
0312: ADDA.L     D0,A0
0314: MOVE.L     D0,-2134(A6)

0316: MOVEQ      #34,D1
0318: MULS.W     D4,D1
031A: LEA        -16610(A5),A0         ; g_state2
031E: ADDA.L     D1,A0
0320: MOVE.L     D1,-2126(A6)

; Place each letter
03AA: MOVEA.L    -2144(A6),A0
03AC: TST.B      (A0)                  ; Cell empty?
03AE: BNE.W      $0442                 ; Skip if occupied

; Handle blank tile
03B2: MOVE.B     (A4),D0               ; Get letter
03B4: EXT.W      D0
03B6: MOVEA.L    A5,A0
03B8: ADDA.W     D0,A0
03BA: TST.B      -23218(A0)            ; Check if in rack
03BE: BNE.S      $03D0                 ; Has letter
03C0: TST.B      -23155(A5)            ; Check blank count
03C4: BGT.S      $03CA
03C6: JSR        418(A5)               ; bounds_error
03CA: SUBQ.B     #1,-23155(A5)         ; Use blank
03CE: BRA.S      $03DC

; Use normal tile
03D0: MOVE.B     (A4),D0
03D2: EXT.W      D0
03D4: MOVEA.L    A5,A0
03D6: ADDA.W     D0,A0
03D8: SUBQ.B     #1,-23218(A0)         ; Decrement count

; Store tile on board
03DC: MOVE.W     D7,D0
03DE: ADDQ.W     #1,D7
03E0: MOVEA.L    A5,A0
03E2: ADDA.W     D0,A0
03E4: MOVE.B     D3,-2762(A0)          ; Store in word buffer

; Place on g_state1
03E8: MOVEQ      #17,D0
03EA: MULS.W     -2108(A6),D0
03EE: ADDA.L     A5,A0
03F0: MOVEA.W    -2110(A6),A0
03F4: ; ... place letter ...
03F8: MOVE.B     D0,-17154(A0)         ; Store in g_state1

; Store score in g_state2
040A: MOVEA.L    A5,A1
0410: MOVE.W     -27630(A1),D1         ; Get letter value
0422: MOVE.W     D1,-16610(A0)         ; Store in g_state2

; ... continue for all letters ...

063A: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
063C: UNLK       A6
063E: RTS
```

### Function 0x063E - Undo Move from Board
```asm
063E: LINK       A6,#-4
0642: MOVEM.L    D5/D6/D7/A3/A4,-(SP)
0646: MOVEQ      #1,D7
0648: MOVE.B     -2762(A5),D6          ; Get first char from buffer
064C: EXT.W      D6
064E: TST.W      D6
0650: BNE.S      $068E                 ; Has content

; Empty word - just clear
0652: CMPI.B     #$FF,-2761(A5)        ; Check marker
0658: BEQ.S      $065E
065A: JSR        418(A5)               ; Error

; Verify board is clear at position
065E: TST.B      -17154(A5)            ; Check g_state1
0662: BEQ.S      $067A                 ; Good

; Verify word buffer is clear
0664: MOVEA.L    A5,A0
0666: ADDA.W     D7,A0
0668: PEA        -2761(A0)             ; Word buffer+1
066C: JSR        3522(A5)              ; strlen
0670: ADDQ.L     #4,D0
0674: BEQ.S      $067A
0676: JSR        418(A5)               ; Error

; Clear board state
067A: SUBQ.W     #1,-19470(A5)         ; Decrement state
067E: PEA        17                    ; Row size
0684: PEA        -17154(A5)            ; g_state1
0688: JSR        426(A5)               ; memset
068C: BRA.S      $0700

; Undo each placed tile
068E: MOVEQ      #17,D0
0690: MULS.W     D6,D0
0692: LEA        -17154(A5),A4         ; g_state1 base
0696: ADDA.L     D0,A4

069A: MOVEQ      #34,D0
069C: MULS.W     D6,D0
069E: LEA        -16610(A5),A3         ; g_state2 base
06A2: ADDA.L     D0,A3

06A6: BRA.S      $06F2

; Loop - remove each tile
06A8: PEA        -4(A6)                ; Output buffer
06AC: PEA        -2(A6)                ; Output buffer
06B0: MOVE.W     D5,-(A7)              ; Position
06B2: MOVE.W     D6,-(A7)              ; Row
06B4: JSR        -1602(PC)             ; calc_search_bounds

; Clear cell
06C4: CLR.B      0(A4,D5.W)            ; Clear g_state1[pos]

; Clear score
06CE: MOVEQ      #34,D0
06D0: ; ... calculate offset ...
06E0: CLR.W      -16610(A0)            ; Clear g_state2[pos]

; Clear scores array entry
06E4: MOVEA.L    A3,A0
06E8: CLR.W      0(A0,D5.W)

06F0: ADDQ.W     #1,D7                 ; Next position
06F2: MOVEA.L    A5,A0
06F4: ADDA.W     D7,A0
06F6: MOVE.B     -2762(A0),D5          ; Get next char from buffer
06FA: EXT.W      D5
06FC: TST.W      D5
06FE: BGT.S      $06A8                 ; Continue if more

; Restore original content
0700: MOVEA.L    A5,A0
0702: ADDA.W     D7,A0
0704: PEA        -2761(A0)             ; Dest: word buffer
0708: MOVE.L     8(A6),-(A7)           ; Source
070C: JSR        3490(A5)              ; JT[3490] - strcpy
0710: MOVEM.L    -24(A6),D5/D6/D7/A3/A4
0716: UNLK       A6
0718: RTS
```

### Function 0x071A - Expand Rack to Letters
```asm
071A: LINK       A6,#0
071E: MOVEM.L    D5/D6/D7/A3/A4,-(SP)
0722: MOVEA.L    8(A6),A3              ; A3 = output buffer
0726: MOVEA.L    -26158(A5),A4         ; A4 = rack string (g_rack)
072A: BRA.S      $0746

; Loop for each letter in rack
072C: MOVEA.L    A5,A0
072E: ADDA.W     D7,A0
0730: MOVE.B     -23218(A0),D6         ; Get count for this letter
0734: EXT.W      D6
0736: MOVEQ      #0,D5                 ; Counter
0738: BRA.S      $0740

; Output letter D6 times
073A: MOVE.B     D7,(A3)               ; Store letter
073C: ADDQ.L     #1,D5
073E: ADDQ.L     #1,A3
0740: CMP.W      D5,D6                 ; More copies?
0742: BGT.S      $073A                 ; Continue
0744: ADDQ.L     #1,A4                 ; Next rack letter

0746: MOVE.B     (A4),D7               ; Get rack char
0748: EXT.W      D7
074A: TST.W      D7
074C: BNE.S      $072C                 ; Continue if not null

074E: CLR.B      (A3)                  ; Null terminate
0750: MOVEM.L    (SP)+,D5/D6/D7/A3/A4
0754: UNLK       A6
0756: RTS
```

### Function 0x0758 - Calculate Rack Value
```asm
0758: LINK       A6,#0
075C: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
0760: MOVE.L     8(A6),D7              ; D7 = output array
0764: MOVEQ      #0,D6                 ; D6 = total value

; Copy letter values to output
0766: PEA        128                   ; Size
076A: PEA        -27374(A5)            ; Letter prime table
076E: MOVE.L     D7,-(A7)              ; Output
0770: JSR        3466(A5)              ; memmove

; Process board tiles
0774: LEA        -17137(A5),A3         ; Board area
0778: LEA        -16576(A5),A4         ; Scores area
077C: LEA        12(A7),A7
0780: BRA.S      $07A0

; Loop through board
0782: MOVE.B     (A3),D5               ; Get letter
0784: EXT.W      D5
0786: TST.W      D5
0788: BEQ.S      $079C                 ; Empty cell

078A: TST.W      (A4)                  ; Check score
078C: BEQ.S      $0796
078E: MOVEA.W    D5,A0
0790: SUBQ.B     #1,0(A0,D7.L)         ; Decrement available
0794: BRA.S      $079C

0796: MOVEA.L    D7,A0
0798: SUBQ.B     #1,63(A0)             ; Decrement blank count

079C: ADDQ.L     #1,A3                 ; Next board cell
079E: ADDQ.L     #2,A4                 ; Next score entry

07A0: LEA        -16882(A5),A0         ; End marker
07A4: CMPA.L     A3,A0
07A8: BHI.S      $0782                 ; Continue

; Process rack
07A8: MOVEA.L    -26158(A5),A3         ; g_rack
07AC: BRA.S      $07CA

07AE: MOVEA.W    D5,A2
07B0: ADDA.L     D7,A2
07B2: MOVEA.L    A5,A0
07B4: ADDA.W     D5,A0
07B6: MOVE.B     -23218(A0),D0         ; Letter count
07BA: SUB.B      (A2),D0               ; Subtract
07BC: TST.B      (A2)
07BE: BGE.S      $07C2
07C0: CLR.B      (A2)                  ; Clamp to 0

07C2: MOVE.B     (A2),D0
07C4: EXT.W      D0
07C6: ADD.W      D0,D6                 ; Add to total
07C8: ADDQ.L     #1,A3

07CA: MOVE.B     (A3),D5
07CC: EXT.W      D5
07CE: TST.W      D5
07D0: BNE.S      $07AE                 ; Continue

07D2: MOVE.W     D6,D0                 ; Return total
07D4: MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4
07D8: UNLK       A6
07DA: RTS
```

### Function 0x07DC - Shuffle Board Letters
```asm
07DC: LINK       A6,#-140              ; Local buffer for letters
07E0: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)
07E4: MOVEA.L    8(A6),A4              ; Output buffer

; Calculate rack value
07E8: PEA        -128(A6)              ; Local buffer
07EC: JSR        204(PC)               ; calc_rack_value
07F0: MOVE.L     D0,D7                 ; D7 = value

07F2: MOVE.L     A4,(A7)
07F4: JSR        3522(A5)              ; strlen(output)
07F8: MOVE.L     D0,D6                 ; D6 = length

; Check if shuffle needed
07FA: MOVEQ      #8,D0
07FC: SUB.L      D6,D0
07FE: CMP.L      D7,D0
0800: BCC.S      $085A                 ; No shuffle needed

; Initialize random
0804: PEA        -132(A6)
0808: JSR        1690(A5)              ; JT[1690] - init_random

; Shuffle loop
0850: MOVE.L     -136(A6),D0
0854: CMP.L      -132(A6),D0
0858: BEQ.S      $081C                 ; Continue shuffling

; Fisher-Yates shuffle step
081C: JSR        1458(A5)              ; JT[1458] - random
0820: MOVE.L     D0,-140(A6)
0824: JSR        1762(A5)              ; JT[1762] - more random
0828: MOVE.L     D7,-(A7)
082A: EXT.L      D0
082C: ADD.L      -140(A6),D0
0830: MOVE.L     D0,-(A7)
0832: JSR        82(A5)                ; JT[82] - modulo
0836: MOVE.L     D0,D5                 ; D5 = random index

; Swap elements
0838: LEA        -128(A6,D5.L),A2      ; src
083C: MOVE.B     (A2),D4               ; Save
0842: MOVE.B     (A3),(A2)             ; Swap
0844: MOVE.B     D4,(A3)               ; Complete swap

; ... continue shuffle ...

; Clear g_state1 row
08A4: PEA        17
08A8: PEA        -17154(A5)
08AC: JSR        426(A5)               ; memset
08B0: MOVEM.L    -168(A6),D4/D5/D6/D7/A2/A3/A4
08B6: UNLK       A6
08B8: RTS
```

### Function 0x08BA - Serialize Board State
```asm
08BA: LINK       A6,#-136
08BE: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
08C2: MOVE.L     8(A6),D7              ; D7 = output buffer
08C6: MOVE.L     D7,D6                 ; D6 = copy

; Copy prime table
08C8: PEA        128
08CC: PEA        -27374(A5)            ; Letter primes
08D0: PEA        -128(A6)              ; Local buffer
08D4: JSR        3466(A5)              ; memmove

; Process board
08D8: MOVEQ      #0,D4                 ; Row counter
08DA: LEA        -16610(A5),A2         ; g_state2
08DE: LEA        -17154(A5),A3         ; g_state1
08E2: LEA        12(A7),A7
08E6: BRA.S      $0932

; Process each row
08E8: MOVEQ      #0,D5                 ; Column counter
08EA: MOVE.L     A3,-136(A6)           ; Save row start
08EE: MOVE.L     A2,-132(A6)           ; Save score row
08F2: MOVEA.W    D5,A4
08F4: BRA.S      $0920

; Process cell
08F8: MOVEA.L    -136(A6),A0           ; Board row
08FC: MOVE.B     0(A0,D5.W),D3         ; Get letter
0900: EXT.W      D3
0902: TST.W      D3
0904: BEQ.S      $091E                 ; Empty cell

; Check if blank
0906: MOVEA.L    A4,A0
0908: TST.W      0(A0)                 ; Score zero = blank
090E: BNE.S      $0914
0910: TST.W      D4                    ; First row?
0912: BNE.S      $091A

; Output letter
0914: SUBQ.B     #1,-128(A6,D3.W)      ; Decrement count
0918: BRA.S      $091E
091A: SUBQ.B     #1,-65(A6)            ; Decrement blank

091E: ADDQ.W     #1,D5                 ; Next column
0920: ADDQ.L     #2,A4                 ; Next score
0922: CMPI.W     #16,D5
0926: BLT.S      $08F8                 ; Continue row

0928: ADDQ.W     #1,D4                 ; Next row
092A: LEA        34(A2),A2             ; Next score row
092E: LEA        17(A3),A3             ; Next board row

0932: CMPI.W     #16,D4
0936: BLT.S      $08E8                 ; Continue

; Process g_field_22 and g_field_14
0938: LEA        -15522(A5),A2         ; g_field_22
093C: BRA.S      $0942
093E: SUBQ.B     #1,-128(A6,D3.W)      ; Decrement
0942: MOVE.B     (A2)+,D3
0944: EXT.W      D3
0946: TST.W      D3
0948: BNE.S      $093E

094A: LEA        -15514(A5),A2         ; g_field_14
094E: BRA.S      $0954
0950: SUBQ.B     #1,-128(A6,D3.W)      ; Decrement
0954: MOVE.B     (A2)+,D3
0956: EXT.W      D3
0958: TST.W      D3
095A: BNE.S      $0950

; Process rack
095C: MOVEA.L    -26158(A5),A2         ; g_rack
0960: BRA.S      $0976
0962: MOVE.B     -128(A6,D3.W),D4
0966: EXT.W      D4
0968: BRA.S      $0972

; Output rack letters
096A: MOVEA.L    D7,A0
096C: ADDQ.L     #1,D7
096E: MOVE.B     D3,(A0)               ; Store letter
0970: SUBQ.W     #1,D4
0972: TST.W      D4
0974: BGT.S      $096A

0976: MOVE.B     (A2)+,D3
0978: EXT.W      D3
097A: TST.W      D3
097C: BNE.S      $0962

; Null terminate
097E: MOVEA.L    D7,A0
0980: CLR.B      (A0)

0982: MOVE.L     D7,D0
0984: SUB.L      D6,D0                 ; Return length
0986: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
098A: UNLK       A6
098C: RTS
```

### Function 0x098E - Clear Letter Counts
```asm
098E: LINK       A6,#0
0992: MOVEM.L    D7/A4,-(SP)
0996: MOVEA.L    -26158(A5),A4         ; g_rack

; Clear rack letters
099A: BRA.S      $09A6
099C: MOVEA.L    A5,A0
099E: ADDA.W     D7,A0
09A0: CLR.B      -23218(A0)            ; Clear count
09A4: ADDQ.L     #1,A4
09A6: MOVE.B     (A4),D7
09A8: EXT.W      D7
09AA: TST.W      D7
09AC: BNE.S      $099C

; Restore from input
09AE: MOVEA.L    8(A6),A4              ; Input string
09B2: BRA.S      $09BE
09B4: MOVEA.L    A5,A0
09B6: ADDA.W     D7,A0
09B8: ADDQ.B     #1,-23218(A0)         ; Increment count
09BC: ADDQ.L     #1,A4
09BE: MOVE.B     (A4),D7
09C0: EXT.W      D7
09C2: TST.W      D7
09C4: BNE.S      $09B4

09C6: MOVEM.L    (SP)+,D7/A4
09CA: UNLK       A6
09CC: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2762 | g_word_buffer (33 bytes) |
| A5-15514 | g_field_14 (current word field) |
| A5-15522 | g_field_22 (opponent field) |
| A5-16610 | g_state2 (17x17 score grid) |
| A5-16882 | End of g_state2 |
| A5-17137 | g_state1 + 17 (skip border) |
| A5-17154 | g_state1 (17x17 letter grid) |
| A5-19470 | Game state counter |
| A5-19474 | Move callback pointer |
| A5-20010 | Empty cell counter |
| A5-23155 | Blank tile count |
| A5-23218 | Letter count array |
| A5-23416 | Special condition flag 1 |
| A5-23420 | Special condition flag 2 |
| A5-23488 | g_dawg_info (88 bytes) |
| A5-26158 | g_rack pointer |
| A5-27374 | Letter prime values |
| A5-27630 | Letter point values |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 82 | Integer modulo |
| 418 | bounds_error |
| 426 | memset |
| 1458 | Random number |
| 1690 | Initialize random |
| 1762 | Random helper |
| 2002 | Check if letter playable |
| 2442 | Validate move |
| 2530 | Validate full move |
| 3466 | memmove |
| 3490 | strcpy |
| 3522 | strlen |

## Board Layout

The board uses 17x17 arrays (with border cells):
- g_state1: Stores letter codes (0 = empty)
- g_state2: Stores letter values (0 = blank tile placed)

Position calculations:
```c
board_offset = row * 17 + col;
g_state1[board_offset]  // Letter
g_state2[board_offset * 2]  // Score (word)
```

## Confidence: HIGH

Clear board management patterns:
- Apply/undo move operations
- Board serialization
- Tile counting and validation
- Shuffle algorithm for randomization
