# CODE 35 Detailed Analysis - SANE Floating-Point Score Calculation

## Overview

| Property | Value |
|----------|-------|
| Size | 3276 bytes |
| JT Offset | 2488 |
| JT Entries | 4 |
| Functions | ~8 |
| Purpose | **Extended precision arithmetic for score evaluation using SANE** |


## System Role

**Category**: Simulation
**Function**: SANE FP Statistics

Heavy FP (22 calls) for simulation statistics - computes averages

**Related CODE resources**:
- CODE 50 (stores results)
- CODE 32 (runtime consumer)
- CODE 24 (analysis)

**Scale Note**: Computes FP averages from simulation, results stored as centipoints in MUL resources.
## Architecture Role

CODE 35 performs precise score calculations using Apple's SANE (Standard Apple Numerics Environment):
1. Extended precision (80-bit) floating-point arithmetic
2. Move evaluation with precise scoring
3. Board position scoring
4. Letter value accumulation with multipliers

## SANE Overview

SANE uses the A9EB trap with operation codes:
- 0x0000-0x000F: Basic arithmetic
- 0x0016: Convert to extended
- 0x2008: Compare
- 0x280E: Move extended
- 0x2810: Convert extended to integer
- 0x300E: Multiply
- 0x3010: Divide

Extended format (10 bytes):
```
+0: Sign/Exponent (2 bytes)
+2: Mantissa (8 bytes)
```

## Key Functions

### Function 0x0000 - Check Position in Bounds (Lower)
```asm
0000: LINK       A6,#-2
0004: TST.W      8(A6)                 ; Check position
0008: BLE.S      $0026                 ; <= 0, invalid
000A: MOVE.W     8(A6),D0
000E: CMP.W      -10914(A5),D0         ; Compare with board size
0012: BGE.S      $0026                 ; >= size, invalid
0014: MOVE.W     8(A6),D0
0018: EXT.L      D0
001A: LSL.L      #3,D0                 ; Multiply by 8
001E: MOVEA.L    -10904(A5),A0         ; Get table pointer
0022: TST.B      6(A0,D0.L)            ; Check table entry
0026: MOVEQ      #0,D0                 ; Return 0 (invalid)
0028: BRA.S      $002C
002A: MOVEQ      #1,D0                 ; Return 1 (valid)
002C: UNLK       A6
002E: RTS
```

**C equivalent**:
```c
int check_lower_bound(int pos) {
    if (pos <= 0 || pos >= g_board_size) {
        return 0;
    }
    long* table = g_position_table;
    return table[pos].flags != 0;
}
```

### Function 0x0030 - Check Position in Bounds (Upper)
```asm
0030: LINK       A6,#-2
0034: TST.W      8(A6)
0038: BLT.S      $005A                 ; < 0, invalid
003A: MOVE.W     8(A6),D0
003E: CMP.W      -10914(A5),D0         ; Compare with board size
0042: BGE.S      $0056                 ; >= size, valid (at boundary)
0044: MOVE.W     8(A6),D0
0048: EXT.L      D0
004A: LSL.L      #3,D0
004E: MOVEA.L    -10904(A5),A0
0052: TST.B      7(A0,D0.L)            ; Check different flag
0056: MOVEQ      #0,D0
0058: BRA.S      $005C
005A: MOVEQ      #1,D0
005C: UNLK       A6
005E: RTS
```

### Function 0x0060 - Calculate Extended Product
```asm
0060: LINK       A6,#-38               ; 38-byte frame for extended values
0064: MOVEM.L    D5/D6/D7,-(SP)
0068: MOVEQ      #0,D7                 ; D7 = accumulator

; Copy input to local extended
006A: LEA        -28(A6),A0            ; Local extended 1
006E: LEA        12(A6),A1             ; Input parameter
0072: MOVE.L     (A1)+,(A0)+           ; Copy 10 bytes
0074: MOVE.L     (A1)+,(A0)+
0076: MOVE.W     (A1)+,(A0)+

; Convert to extended format
0078: PEA        -10(A0)               ; Result ptr
007C: MOVE.W     #$0016,-(A7)          ; SANE op: to extended
0080: _FP68K                           ; A9EB trap

; Convert second operand
0088: PEA        -18(A6)               ; Second extended
008C: LEA        12(A6),A1
0090: MOVE.W     #$3010,-(A7)          ; SANE op
0092: _FP68K

; Multiply loop setup
009C: BRA.S      $00A6
0098: LSR.L      #1,D6                 ; Shift multiplier
009A: ADDQ.L     #1,D7
009C: TST.L      D6
009E: BNE.S      $0098                 ; Continue while non-zero

00A0: MOVE.L     D7,D0
00A2: EXT.L      D0
00A4: DIVU.W     #2,D0                 ; Divide by 2

; Check for overflow
00AA: TST.L      D5
00AC: BEQ.S      $00C6                 ; No overflow

; Handle overflow - set to max
00AE: MOVE.L     D5,-14(A6)
00B2: CLR.L      -18(A6)
00B6: PEA        -18(A6)
00BA: PEA        -28(A6)
00BE: MOVE.W     #$300E,-(A7)          ; SANE multiply
00C2: _FP68K

; Check result overflow
00C6: CLR.L      -22(A6)
00CA: MOVE.L     #$80000000,-26(A6)    ; Large value
00D2: MOVE.W     #$3FFF,-28(A6)        ; Max exponent

; Copy result back
00D8: LEA        -10(A6),A0
00DC: LEA        -28(A6),A1
00E0: MOVE.L     (A1)+,(A0)+
00E2: MOVE.L     (A1)+,(A0)+
00E4: MOVE.W     (A1)+,(A0)+

; Compare with limit
00E6: PEA        126(PC)               ; Limit value
00EA: PEA        12(A6)
00EE: MOVE.W     #$2008,-(A7)          ; SANE compare
00F2: _FP68K
00F4: BGE.S      $00FA                 ; >= limit?
00F6: JSR        418(A5)               ; bounds_error

; Iteration loop
00FA: MOVEQ      #0,D7
00FC: BRA.S      $0134

; Main calculation loop
00FE: LEA        -38(A6),A0            ; Work buffer
0102: LEA        12(A6),A1             ; Input
0106: MOVE.L     (A1)+,(A0)+
0108: MOVE.L     (A1)+,(A0)+
010A: MOVE.W     (A1)+,(A0)+

; Divide
010C: PEA        -10(A6)
0110: PEA        -10(A0)
0114: MOVE.W     #$0006,-(A7)          ; SANE divide
0118: _FP68K

; Multiply accumulator
011C: PEA        -10(A6)
0120: PEA        -10(A6)
0124: CLR.W      -(A7)
0126: _FP68K

; Compare and conditionally add
012A: PEA        60(PC)                ; Constant
012E: PEA        -10(A6)
0132: MOVE.W     #$2006,-(A7)          ; SANE compare/add
0136: _FP68K

; Check if done
0140: MOVE.W     #$2008,-(A7)
0144: _FP68K
0146: BLE.S      $014C
0148: ADDQ.W     #1,D7                 ; Increment count
014A: CMPI.W     #5,D7
014E: BLT.S      $00FE                 ; Continue loop

; Copy result to output
014C: MOVEA.L    8(A6),A0              ; Output ptr
0150: LEA        -10(A6),A1            ; Result
0154: MOVE.L     (A1)+,(A0)+
0156: MOVE.L     (A1)+,(A0)+
0158: MOVE.W     (A1)+,(A0)+
015A: MOVEM.L    (SP)+,D5/D6/D7
015E: UNLK       A6
0160: RTS
```

### Function 0x0168 - Score Calculation Main
```asm
0168: LINK       A6,#-70               ; Large frame
016C: MOVEM.L    A2/A4,-(SP)
0170: MOVEA.L    8(A6),A4              ; A4 = move data
0174: MOVE.L     A4,D0
0176: BEQ.W      $030A                 ; Null check

; Check move score threshold
017A: MOVEQ      #20,D0
017C: CMP.L      20(A4),D0             ; Compare score
0180: BGT.W      $02D2                 ; Score too low

; Convert score to extended
0184: PEA        20(A4)                ; Score address
0188: PEA        -30(A6)               ; Extended buffer
018C: MOVE.W     #$280E,-(A7)          ; SANE move
0190: _FP68K

; Setup calculation buffers
0198: LEA        -40(A6),A0
019C: LEA        10(A4),A1             ; Second score component
01A0: MOVE.L     (A1)+,(A0)+
01A2: MOVE.L     (A1)+,(A0)+
01A4: MOVE.W     (A1)+,(A0)+

; Divide operation
01A0: PEA        -30(A6)
01A4: PEA        -10(A0)
01A8: MOVE.W     #$0006,-(A7)          ; SANE divide
01AC: _FP68K

; Multiple calculation stages...
01BC: LEA        -40(A6),A0
01C0: LEA        -10(A6),A1
01C4: MOVE.L     (A1)+,(A0)+
01C6: MOVE.L     (A1)+,(A0)+
01C8: MOVE.W     (A1)+,(A0)+

; Multiply stages
01CA: PEA        -10(A6)
01CE: PEA        -10(A0)
01D2: MOVE.W     #$0004,-(A7)          ; SANE multiply
01D6: _FP68K

; Subtract operation
01E4: PEA        -30(A6)
01E8: PEA        -10(A1)
01EC: MOVE.W     #$0006,-(A7)          ; SANE subtract
01F0: _FP68K

; Add components
0200: PEA        -10(A0)
0204: PEA        -10(A2)
0208: MOVE.W     #$0002,-(A7)          ; SANE add
020C: _FP68K

; ... more SANE operations ...

; Call helper function
0242: PEA        -40(A6)
0246: JSR        -488(PC)              ; calc_extended_product

; Copy to work buffer
024A: LEA        -20(A6),A0
024E: LEA        -40(A6),A1
0252: MOVE.L     (A1)+,(A0)+
0254: MOVE.L     (A1)+,(A0)+
0256: MOVE.W     (A1)+,(A0)+

; Compare with threshold
0258: PEA        182(PC)               ; Threshold constant
025C: PEA        -20(A6)
0260: MOVE.W     #$2008,-(A7)          ; SANE compare
0264: _FP68K
026C: BLE.S      $0288                 ; Below threshold

; Add to accumulator
026C: PEA        -20(A6)
0270: PEA        -10(A6)
0274: MOVE.W     #$0008,-(A7)          ; SANE add
0278: _FP68K
027A: BLE.S      $0288                 ; Check result

; Multiply result
0280: PEA        -10(A6)
0284: PEA        -10(A6)
0288: MOVE.W     #$0002,-(A7)          ; SANE multiply
028C: _FP68K

; Prepare final result
0290: LEA        -40(A6),A0
0294: LEA        -20(A6),A1
0298: MOVE.L     (A1)+,(A0)+
029A: MOVE.L     (A1)+,(A0)+
029C: MOVE.W     (A1)+,(A0)+

; Round to integer
029A: PEA        -10(A0)
029E: MOVE.W     #$000D,-(A7)          ; SANE round
02A2: _FP68K

; ... more operations ...

; Convert back to integer
02BE: CLR.W      -(A7)
02C0: _FP68K

; Clear result on error
02C6: CLR.L      -4(A6)
02CA: CLR.L      -8(A6)
02CE: CLR.W      -10(A6)
02D0: BRA.S      $02DC

; Alternative path - clear
02D0: CLR.L      -4(A6)
02D4: CLR.L      -8(A6)
02D8: CLR.W      -10(A6)

; Prepare output
02DC: LEA        -44(A6),A0
02E0: LEA        -10(A6),A1
02E4: MOVE.L     (A1)+,(A0)+
02E6: MOVE.L     (A1)+,(A0)+
02E8: MOVE.W     (A1)+,(A0)+

; Convert to integer result
02EA: PEA        -10(A0)
02EE: MOVE.W     #$0016,-(A7)          ; To integer
02F2: _FP68K

; Store final result
0300: MOVE.L     -30(A6),24(A4)        ; Store in move structure

030A: MOVEM.L    (SP)+,A2/A4
030C: UNLK       A6
030E: RTS
```

### Function 0x0310 - Sum Word Values
```asm
0310: LINK       A6,#0
0314: MOVEM.L    D5/D6/D7,-(SP)

; Validate inputs
031A: TST.L      12(A6)                ; Check ptr1
031E: BNE.S      $0324
0320: JSR        418(A5)               ; bounds_error

0324: TST.L      8(A6)                 ; Check ptr2
0328: BNE.S      $032E
032A: JSR        418(A5)               ; bounds_error

; Initialize sum
032E: MOVEQ      #0,D7                 ; D7 = sum
0330: BRA.S      $0352

; Sum loop
0332: MOVEA.L    12(A6),A0
0336: ADDQ.L     #2,12(A6)             ; Advance ptr
033A: MOVE.W     (A0),D5               ; Get value

; Check if filtering
033C: TST.W      16(A6)
0340: BEQ.S      $034E                 ; No filter
0342: MOVE.W     D6,-(A7)
0344: JSR        -790(PC)              ; Filter check
0348: TST.W      D0
034A: BEQ.S      $0352                 ; Skip if filtered

034E: MOVEA.W    D5,A0
0350: ADD.W      A0,D7                 ; Add to sum

0352: MOVEA.L    8(A6),A0
0356: ADDQ.L     #2,8(A6)              ; Advance ptr
035A: MOVE.W     (A0),D6               ; Get next value
035C: BNE.S      $0332                 ; Continue if not zero

035E: MOVE.L     D7,D0                 ; Return sum
0360: MOVEM.L    (SP)+,D5/D6/D7
0364: UNLK       A6
0366: RTS
```

### Function 0x0368 - Full Score Calculation
```asm
0368: LINK       A6,#-330              ; Large frame
036C: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0370: MOVEA.L    12(A6),A4             ; A4 = output scores
0374: MOVEA.L    16(A6),A3             ; A3 = output values
0378: CLR.L      -316(A6)              ; Clear accumulator

; Setup search
037C: MOVE.L     -15498(A5),-(A7)      ; g_current_rack
0380: JSR        2410(A5)              ; JT[2410] - setup

; Get letter info
0384: PEA        -140(A6)              ; Local buffer
0388: JSR        2394(A5)              ; JT[2394] - get_letter_info
038C: MOVE.B     D0,-317(A6)           ; Store letter count

; Check game state flag
0390: TST.B      -17010(A5)            ; g_game_flag
0394: ADDQ.L     #4,A7
0396: BNE.S      $03D4                 ; Active game

; No active game - calculate from move
0398: MOVEA.L    8(A6),A0              ; Move ptr
039C: TST.B      32(A0)                ; Check word present
03A0: BEQ.S      $03AE
03A2: MOVE.L     8(A6),-(A7)
03A6: JSR        3522(A5)              ; strlen
03AA: ADDQ.L     #4,A7
03AC: BRA.S      $03B0
03AE: MOVEQ      #0,D0

; Calculate score multiplier
03B0: PEA        28                    ; Multiplier
03B4: MOVE.L     D0,-(A7)              ; Word length
03B6: JSR        66(A5)                ; JT[66] - multiply

; Lookup base score
03BA: MOVEA.L    -10904(A5),A0         ; Score table
03BE: MOVE.L     24(A0,D0.L),D3        ; Get base score

; Add to accumulator
03C2: ADD.L      D3,-316(A6)

; Handle output pointers
03CC: MOVE.L     A4,D0
03CE: BEQ.S      $03D4
03D0: MOVE.W     #-32,(A4)+            ; Store marker

; Get word info
03D4: MOVEA.L    8(A6),A0
03D8: MOVE.B     32(A0),D5             ; Word present?
03DC: TST.B      D5
03DE: BEQ.W      $06A4                 ; No word, skip

; Setup board positions
03E2: MOVEQ      #0,D3                 ; Clear accumulator
03E4: MOVE.B     D5,D4
03E6: EXT.W      D4                    ; D4 = direction

03E8: MOVEA.L    8(A6),A0
03EC: MOVE.B     33(A0),D5             ; D5 = position
03F0: EXT.W      D5

; Calculate board pointers
03F2: MOVEA.L    A0,A2                 ; A2 = move
03F4: MOVEQ      #17,D0
03F6: MULS.W     D4,D0
03F8: LEA        -17154(A5),A1         ; g_state1
03FC: ADDA.L     D0,A1
03FE: MOVE.L     D0,-308(A6)           ; Store offset

; Setup multiple board views
0402: MOVEQ      #-1,D1
0404: ADDA.W     D4,A1
0406: ; ... more offset calculations for adjacent rows ...

; Main scoring loop
0492: MOVE.B     (A2),D7               ; Get letter
0494: TST.B      D7
0496: BEQ.W      $068E                 ; End of word

; Validate letter
049A: MOVEQ      #0,D0
049C: MOVE.B     D7,D0
049E: MOVEA.L    A5,A0
04A0: TST.B      -1064(A0,D0.L)        ; Character class check
04A4: BMI.S      $04AC
04A6: JSR        418(A5)               ; bounds_error

; Bounds check position
04AC: CMPI.W     #1,D4
04B0: BLT.S      $04C4
04B2: CMPI.W     #30,D4                ; 30 = max position
04B6: BGT.S      $04C4
04B8: CMPI.W     #1,D5
04BC: BLT.S      $04C4
04BE: CMPI.W     #15,D5
04C2: BLE.S      $04C8
04C4: JSR        418(A5)               ; bounds_error

; Check if cell occupied
04C8: MOVEA.L    -308(A6),A0           ; Board pointer
04CC: TST.B      0(A0,D5.W)            ; Cell at position
04D0: BEQ.S      $04E8                 ; Empty - place tile

; Cell occupied - verify match
04D2: MOVEA.L    -308(A6),A0
04D6: MOVE.B     (A2),D0               ; Expected letter
04D8: CMP.B      0(A0,D5.W),D0         ; Match?
04DC: BEQ.W      $0686                 ; Good
04E0: JSR        418(A5)               ; Mismatch error
04E4: BRA.W      $0686

; Calculate cross-word score
04E8: CMPI.W     #1,D4
04EC: BEQ.W      $05B2                 ; First row, no cross
04F0: CMPI.W     #16,D4
04F4: BEQ.W      $05B2                 ; Last row, no cross

; Check adjacent cells for cross-words
04F8: MOVEA.L    -304(A6),A0           ; Row above
04FC: TST.B      0(A0,D5.W)
0500: BNE.W      $05B2                 ; Has letter, forms cross

0504: MOVEA.L    -300(A6),A0           ; Two above
0508: MOVE.B     0(A0,D5.W),D0
050C: EXT.W      D0
050E: MOVEA.L    -296(A6),A1           ; Row below
0512: MOVE.B     0(A1,D5.W),D1
0516: EXT.W      D1
0518: MULS.W     D1,D0                 ; Product = 0 if either empty
051A: MOVE.W     D0,-320(A6)

; Check left/right for horizontal
0528: CMPI.W     #2,D4
052A: BEQ.S      $053A
052C: CMPI.W     #17,D4
0530: BEQ.S      $053A
0532: MOVEA.L    -276(A6),A0           ; Left adjacent
0536: TST.B      0(A0,D5.W)
0538: BNE.S      $05B0

053A: CMPI.W     #15,D4
053E: BEQ.S      $0550
0540: CMPI.W     #30,D4
0544: BEQ.S      $0550
0546: MOVEA.L    -280(A6),A0           ; Right adjacent
054A: TST.B      0(A0,D5.W)
054E: BNE.S      $05B0

; Check bonus squares
0550: CLR.W      -322(A6)
0554: MOVE.B     (A2),D7               ; Get letter
0556: MOVE.B     (A2),D6
0558: EXT.W      D6
055A: LEA        -2422(A5),A0          ; Bonus table
055E: MOVE.W     -322(A6),D0
0562: EXT.L      D0
0564: LSL.L      #2,D0                 ; *4 for table index
0568: ADDA.L     D0,A0
056A: MOVE.L     A0,-326(A6)
056C: BRA.S      $05A8

; Scan bonus table
056E: MOVEA.L    -326(A6),A0
0572: TST.B      1(A0)                 ; Check bonus type
0576: BNE.S      $05A0

0578: MOVEA.L    -326(A6),A0
057C: MOVEQ      #0,D0
057E: MOVE.B     2(A0),D0              ; Get row
0582: CMP.W      -320(A6),D0           ; Match position?
0586: BNE.S      $05A0

0588: MOVEA.L    -326(A6),A0
058C: MOVEQ      #0,D0
058E: MOVE.B     (A0),D0               ; Get letter
0590: CMP.W      D6,D0
0592: BNE.S      $05A0                 ; Letter mismatch

; Apply bonus
0594: MOVEA.L    -326(A6),A0
0598: MOVEQ      #0,D0
059A: MOVE.B     3(A0),D0              ; Get bonus value
059E: SUB.W      D0,D3                 ; Subtract from score

05A0: ADDQ.W     #1,-322(A6)           ; Next bonus entry
05A4: ADDQ.L     #4,-326(A6)
05A8: CMPI.W     #20,-322(A6)          ; Max 20 bonuses
05AE: BCS.S      $056E

; Check horizontal cross-word
05B0: CMPI.W     #15,D4
05B4: BEQ.W      $0686
05B8: CMPI.W     #30,D4
05BC: BEQ.W      $0686

; Calculate letter value
05C0: MOVEQ      #1,D0
05C2: ADDA.W     D4,A0
05C4: LEA        -17154(A5),A0
05CA: ADDA.L     D0,A0
05CC: MOVEA.W    D5,A0
05D0: TST.B      0(A0,D0.L)            ; Check adjacent
05D4: BNE.W      $0686                 ; Has neighbor

; Get letter values
05D8: MOVEA.L    -284(A6),A0
05DC: MOVE.B     0(A0,D5.W),D0
05E0: EXT.W      D0
05E2: MOVEA.L    -288(A6),A1
05E6: MOVE.B     0(A1,D5.W),D1
05EA: EXT.W      D1
05EC: MULS.W     D1,D0
05EE: MOVE.W     D0,-320(A6)

; ... more cross-word checks ...

; Add letter value to score
0672: ADDQ.B     #1,-322(A6)
0674: ADDQ.L     #4,-326(A6)
067C: CMPI.W     #20,-322(A6)
0682: BCS.S      $063E

0684: ADDQ.L     #1,A2                 ; Next letter
0686: ADDQ.W     #1,D5                 ; Next position
0688: BRA.W      $0494                 ; Continue loop

; End of word
068C: TST.L      D3
068E: BEQ.S      $06A2

; Store score
0690: ADD.L      D3,-316(A6)
0696: MOVE.L     A4,D0
069C: BEQ.S      $06A2
069E: MOVE.W     #20000,(A4)+          ; Store marker

; Continue with rack
06A2: CLR.W      -(A7)
06A4: MOVE.L     -15498(A5),-(A7)      ; g_current_rack
06A8: MOVE.L     8(A6),-(A7)           ; Move
06AC: JSR        2370(A5)              ; JT[2370] - process_rack

; Sum up letter values
06B0: MOVE.B     -23(A6),D0
06B4: EXT.W      D0
06B6: MOVE.B     -29(A6),D1
06BA: EXT.W      D1
06BC: MOVE.B     -35(A6),D2
06C0: EXT.W      D2
06C2: MOVE.W     D0,-330(A6)

; Calculate totals
06D2: ADD.W      D0,D5
06D4: ADD.W      D2,D5
06D6: ADD.W      D1,D5
06D8: ADD.W      -330(A6),D5

; Get letter count
06DC: MOVE.B     -317(A6),D4
06E0: EXT.W      D4
06E2: MOVE.W     D4,D7
06E4: SUB.W      D5,D7

; Calculate bonus
06E6: MOVEQ      #10,D0
06E8: MULS.W     D5,D0
06EA: MOVE.W     D4,D1
06EC: LSL.W      #1,D1                 ; *2
06F0: CMP.W      D0,D1
06F4: BLE.S      $0700

; Apply letter bonus
06F6: MOVE.B     -77(A6),D3
06FA: EXT.W      D3
06FC: ADD.W      D3,D5
06FE: SUB.W      D3,D7

; Process blank tiles
0700: CLR.W      -322(A6)              ; Counter
0704: CLR.W      -320(A6)              ; Blank count
0708: MOVEQ      #0,D4
070A: MOVEA.L    -15498(A5),A2         ; Rack
070E: BRA.S      $0730

; Count rack letters
0710: MOVE.W     D6,-(A7)
0712: JSR        2002(A5)              ; JT[2002] - is_playable
0716: TST.W      D0
0718: BEQ.S      $0722
071A: ADDQ.W     #1,-320(A6)           ; Playable count
0720: BRA.S      $0730

0722: CMPI.W     #63,D6                ; '?' blank
0726: BEQ.S      $072C
0728: ADDQ.W     #1,D4                 ; Regular letter
072A: BRA.S      $0730
072C: ADDQ.W     #1,-322(A6)           ; Blank count

0730: MOVE.B     (A2)+,D6
0732: EXT.W      D6
0734: TST.W      D6
0736: BNE.S      $0710                 ; Continue

; Calculate final rack adjustment
0738: MOVEQ      #7,D6
073A: SUB.W      -320(A6),D6
073E: SUB.W      D4,D6
0740: SUB.W      -322(A6),D6

0744: MOVE.B     -317(A6),D0
0748: EXT.W      D0
074A: SUBQ.W     #1,D0
074C: MOVE.W     D0,-328(A6)
0750: CMP.W      D0,D6
0752: BLE.S      $0766

; Apply adjustment
0754: CMPI.B     #7,-317(A6)
075A: BGT.S      $0760
075C: MOVEQ      #0,D0
075E: BRA.S      $0764
0760: MOVE.W     -328(A6),D0
0764: MOVE.W     D0,D6

; Store results
0766: MOVE.W     D6,-(A7)
0768: MOVE.W     D7,-(A7)
076A: MOVE.W     D5,-(A7)
076C: MOVE.W     -322(A6),-(A7)
0770: MOVE.W     D4,-(A7)
0772: MOVE.W     -320(A6),-(A7)
0776: JSR        2506(A5)              ; JT[2506] - final_calc
077A: MOVE.L     D0,D3                 ; D3 = result

; Add to total
077C: ADD.L      D3,-316(A6)
0782: ADDQ.L     #12,A7

; Store in output
0786: MOVE.L     A4,D0
078C: BEQ.S      $0792
078E: MOVE.W     #-1,(A4)+             ; Terminator

; Check word length bonus
0792: MOVEA.L    8(A6),A0
0796: TST.B      32(A0)                ; Has word?
079A: BEQ.S      $07A0
079C: SUBQ.B     #1,-317(A6)           ; Adjust count

07A0: CMPI.B     #7,-317(A6)           ; 7+ letters?
07A6: BLE.S      $07D8
07A8: CMPI.B     #17,-317(A6)          ; Max 17?
07AE: BGE.S      $07D8

; Apply bingo bonus
07B0: MOVE.B     -317(A6),D0
07B4: EXT.W      D0
07B6: MOVEA.L    A5,A0
07B8: ADDA.W     D0,A0
07BA: ADDA.W     D0,A0
07BC: MOVE.W     -24866(A0),D3         ; Bingo bonus table
07C0: SUB.W      -24850(A5),D3         ; Adjust
07C4: EXT.L      D3
07C6: ADD.L      D3,-316(A6)

; Store bonus marker
07CC: MOVE.L     A4,D0
07D2: BEQ.S      $07D8
07D4: MOVE.W     #-33,(A4)+            ; Bingo marker

; Process individual letters
07D8: MOVEA.L    8(A6),A0
07DC: TST.B      32(A0)
07E0: BEQ.S      $07E6
07E2: ADDQ.B     #1,-317(A6)           ; Restore count

07E6: MOVEQ      #0,D3
07E8: CLR.B      -271(A6)
07EC: MOVEA.L    -26158(A5),A2         ; g_rack

; Letter loop
07F0: BRA.S      $083E
07F2: MOVE.B     D6,-272(A6)
07F6: TST.W      D6
07F8: BLT.S      $080A                 ; Invalid
07FA: CMPI.W     #128,D6               ; Max letter
07FE: BCC.S      $080A                 ; Invalid
0800: MOVEA.L    A6,A0
0802: ADDA.W     D6,A0
0804: TST.B      -140(A0)              ; Check buffer
0808: BGE.S      $080E
080A: JSR        418(A5)               ; bounds_error

; Get letter value
080E: LEA        -140(A6),A0
0812: ADDA.W     D6,A0
0814: MOVE.L     A0,-312(A6)
0818: TST.B      (A0)
081A: BEQ.S      $083E                 ; Zero value

; Skip 'q' special handling
081C: CMPI.W     #113,D6               ; 'q'
0820: BEQ.S      $083E

; Calculate and add score
0822: PEA        -144(A6)
0826: PEA        -272(A6)
082A: JSR        2498(A5)              ; JT[2498] - letter_score
082E: MOVEA.L    -312(A6),A0
0832: MOVE.B     (A0),D1
0834: EXT.W      D1
0836: MULS.W     D0,D1
0838: MOVEA.W    D1,A1
083A: ADD.L      A1,D3
083C: ADDQ.L     #8,A7

083E: MOVE.B     (A2)+,D6
0840: EXT.W      D6
0842: TST.W      D6
0844: BNE.S      $07F2                 ; Continue

; Check for special letter patterns
0846: TST.B      -27(A6)
084A: BEQ.S      $086E

084C: PEA        -144(A6)
0850: PEA        -2272(A5)             ; Pattern string
0854: JSR        2498(A5)              ; JT[2498]
0858: MOVE.B     -23(A6),D1
085C: EXT.W      D1
085E: MOVEA.L    A5,A0
0860: ADDA.W     D1,A0
0862: ADDA.W     D1,A0
0864: MOVEA.W    -2302(A0),A0
0868: ADDA.W     D0,A0
086A: ADD.L      A0,D3
086C: ADDQ.L     #8,A7

; Calculate per-letter average
086E: MOVE.L     -15498(A5),-(A7)
0872: JSR        3522(A5)              ; strlen(rack)
0876: MOVEQ      #7,D6
0878: SUB.W      D0,D6                 ; Tiles needed
087A: MOVEA.W    D6,A0
087C: MOVE.L     A0,(A7)
087E: MOVE.L     D3,-(A7)
0880: JSR        66(A5)                ; JT[66] - multiply
0884: MOVE.L     D0,D3

; Get letter count
0886: MOVE.B     -317(A6),D5
088A: EXT.W      D5
088C: EXT.L      D5
088E: MOVE.L     D5,D4
0894: EXT.W      D4

; Divide by count
089A: MOVEA.W    D5,A0
089C: ADD.L      A0,D3
08A0: MOVE.B     -317(A6),D7
08A4: EXT.W      D7
08A6: EXT.L      D7
08A8: MOVE.L     D7,-(A7)
08AA: MOVE.L     D3,-(A7)
08AC: JSR        90(A5)                ; JT[90] - divide
08B0: MOVE.L     D0,D3

; Store result
08AE: ADD.L      D3,-316(A6)
08B4: MOVE.L     A4,D0
08BA: BEQ.S      $08C0
08BC: MOVE.W     #-2,(A4)+             ; Marker

; Check for 'u' after 'q'
08C0: MOVE.W     #117,-(A7)            ; 'u'
08C4: MOVE.L     -15498(A5),-(A7)
08C8: JSR        3514(A5)              ; JT[3514] - strchr
08CC: TST.L      D0
08CE: ADDQ.L     #6,A7
08D0: BEQ.S      $0924                 ; No 'u'

; Has 'u' - check for 'q'
08D2: TST.B      -27(A6)
08D6: BEQ.S      $0924

; Calculate qu bonus
08D8: PEA        -144(A6)
08DC: PEA        -2270(A5)             ; "qu" string
08E0: JSR        2498(A5)
08E4: MOVE.B     -23(A6),D1
08E8: EXT.W      D1
08EA: MOVEA.L    A5,A0
08EC: ADDA.W     D1,A0
08EE: ADDA.W     D1,A0
08F0: SUB.W      -2302(A0),D0
08F4: EXT.L      D0
08F6: MOVE.L     D0,D3

; Multiply and divide
08F8: MOVEA.W    D6,A0
08FA: MOVE.L     A0,(A7)
08FC: MOVE.L     D3,-(A7)
08FE: JSR        66(A5)                ; multiply
0902: MOVE.L     D0,D3
0904: MOVEA.W    D5,A0
0906: ADD.L      A0,D3
0908: MOVE.L     D7,(A7)
090A: MOVE.L     D3,-(A7)
090C: JSR        90(A5)                ; divide
0910: MOVE.L     D0,D3
0912: ADD.L      D3,-316(A6)

; Store marker
0918: MOVE.L     A4,D0
091E: BEQ.S      $0924
0920: MOVE.W     #-3,(A4)+             ; qu marker

; Check for 'q' alone
0924: MOVE.W     #113,-(A7)            ; 'q'
0928: MOVE.L     -15498(A5),-(A7)
092C: JSR        3514(A5)              ; strchr
0930: TST.L      D0
0932: ADDQ.L     #6,A7
0934: BEQ.S      $0974                 ; No 'q'

; Check if 'u' also present
0936: MOVE.W     #117,-(A7)            ; 'u'
093A: MOVE.L     -15498(A5),-(A7)
093E: JSR        3514(A5)
0942: TST.L      D0
0944: ADDQ.L     #6,A7
0946: BNE.S      $0974                 ; Has 'u', ok

; Q without U - penalty
0948: MOVEQ      #10,D0
094A: MULS.W     D6,D0
094C: MOVE.B     -23(A6),D1
0950: EXT.W      D1
0952: LEA        -2342(A5),A0          ; Q penalty table
0956: ADDA.L     D0,A0
0958: MOVEA.W    D1,A0
095A: MOVE.W     0(A0,D0.L),D3
095E: EXT.L      D3

; Store result
0962: ADD.L      D3,-316(A6)
0968: MOVE.L     A4,D0
096E: BEQ.S      $0974
0970: MOVE.W     #-4,(A4)+             ; Q penalty marker

; Process remaining rack letters
0974: MOVEA.L    -15498(A5),A2
0978: MOVE.B     (A2),D7
097A: TST.B      D7
097C: BEQ.S      $09F4                 ; Empty

; Check each letter
097E: CMP.B      1(A2),D7              ; Duplicate?
0982: BEQ.S      $09F0                 ; Skip duplicates

; Calculate individual letter score
0984: MOVE.B     (A2),D0
0986: EXT.W      D0
0988: MOVEA.L    A6,A0
098A: ADDA.W     D0,A0
098C: MOVE.B     -140(A0),D0           ; Get count
0990: EXT.W      D0
0992: MOVE.W     D0,-(A7)
0994: MOVE.W     D4,-(A7)

0996: MOVE.B     (A2),D0
0998: EXT.W      D0
099A: MOVE.W     D0,-(A7)
099C: JSR        2514(A5)              ; JT[2514] - calc_letter_value
09A0: MOVE.L     D0,D3

; Get letter base value
09A2: MOVE.B     (A2),D0
09A4: EXT.W      D0
09A6: MOVEA.L    A5,A0
09A8: ADDA.W     D0,A0
09AA: MOVE.B     -27374(A0),D0         ; Prime value
09AE: EXT.W      D0
09B0: SUBQ.W     #1,D0
09B2: MOVE.L     D0,D7

; Calculate with letter frequency
09B4: MOVE.W     #96,-(A7)             ; 'a'-1
09B8: MOVE.B     (A2),D0
09BA: EXT.W      D0
09BC: MOVE.W     D0,-(A7)
09BE: JSR        2514(A5)              ; calc_letter_value
09C2: SUB.W      D0,D3

; Store result
09C4: ADD.L      D3,-316(A6)
09CA: ADDQ.L     #10,A7

; Store marker
09CE: MOVE.L     A4,D0
09D4: BEQ.S      $09F0

; Calculate index for letter
09D6: MOVE.B     (A2),D0
09D8: EXT.W      D0
09DA: MOVE.W     D0,-(A7)
09DC: MOVE.L     -26158(A5),-(A7)      ; g_rack
09E0: JSR        3514(A5)              ; strchr
09E4: SUB.L      -26158(A5),D0         ; Offset
09E8: MOVEQ      #-5,D1
09EA: SUB.W      D0,D1                 ; Marker value
09EC: MOVE.W     D1,(A4)+
09EE: ADDQ.L     #6,A7

09F0: ADDQ.L     #1,A2                 ; Next letter
09F2: BRA.S      $0978

; Finalize
09F4: CLR.W      -(A7)
09F6: MOVE.L     A3,-(A7)              ; Output values
09F8: MOVE.L     A4,-(A7)              ; Output scores
09FA: JSR        72(PC)                ; Helper function

; Accumulate final total
09FE: ADD.L      D0,-316(A6)
0A04: MOVEA.L    -15498(A5),A2
0A08: ADDQ.L     #10,A7

; Validate remaining letters
0A0C: MOVE.B     (A2),D7
0A0E: TST.B      D7
0A10: BEQ.S      $0A26                 ; Done

0A12: MOVE.B     D7,D0
0A14: EXT.W      D0
0A16: MOVEA.L    A5,A0
0A18: TST.B      -23218(A0,D0.L)       ; Check count
0A1C: BGT.S      $0A22
0A1E: JSR        418(A5)               ; bounds_error

0A22: ADDQ.L     #1,A2
0A24: BRA.S      $0A0C

; Cleanup
0A26: MOVE.L     -15498(A5),-(A7)
0A2A: JSR        2378(A5)              ; JT[2378] - cleanup
0A2E: MOVE.L     -15498(A5),(A7)
0A32: JSR        2410(A5)              ; JT[2410] - reset

; Return total
0A36: MOVE.L     -316(A6),D0
0A3A: MOVEM.L    -362(A6),D3/D4/D5/D6/D7/A2/A3/A4
0A40: UNLK       A6
0A42: RTS
```

### Function 0x0A44 - Calculate Per-Tile Scores
```asm
0A44: LINK       A6,#-12
0A48: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0A4C: MOVEA.L    8(A6),A4              ; Output scores
0A50: MOVEA.L    12(A6),A3             ; Output values
0A54: CLR.L      -10(A6)               ; Clear accumulator
0A58: MOVEQ      #1,D7                 ; Start index
0A5A: BRA.W      $0CAE

; Position loop
0A5E: MOVE.L     D7,D0
0A60: EXT.L      D0
0A62: LSL.L      #3,D0                 ; *8
0A66: MOVEA.L    -10904(A5),A0         ; Position table
0A6A: TST.B      4(A0,D0.L)            ; Check valid
0A6E: BEQ.W      $0CAC                 ; Invalid, skip

; Get position data
0A72: MOVE.L     D7,D0
0A74: EXT.L      D0
0A76: LSL.L      #3,D0
0A7A: MOVEA.L    -10904(A5),A0
0A7E: MOVE.B     6(A0,D0.L),D4         ; Row
0A82: EXT.W      D4

; ... extensive position-based calculations ...

; Check board position
0B44: MOVEQ      #17,D0
0B46: MULS.W     D4,D0
0B48: LEA        -17154(A5),A0         ; g_state1
0B4C: ADDA.L     D0,A0
0B4E: MOVEA.W    D5,A0
0B50: MOVE.B     0(A0,D0.L),D0         ; Get letter
0B54: EXT.W      D0
0B56: MOVE.W     D0,-12(A6)
0B5A: TST.W      D0
0B5C: BEQ.W      $0CAC                 ; Empty cell

; Calculate value
0B60: MOVE.W     -12(A6),-(A7)
0B64: MOVE.L     D7,D0
0B66: EXT.L      D0
0B68: LSL.L      #3,D0
0B6C: MOVEA.L    -10908(A5),A0
0B70: MOVE.L     8(A0,D0.L),-(A7)
0B74: JSR        3514(A5)              ; strchr

; Continue calculations...

; Get score from g_state2
0BF0: MOVEQ      #34,D0
0BF2: MULS.W     D4,D0
0BF4: LEA        -16610(A5),A0         ; g_state2
0BF8: ADDA.L     D0,A0
0BFA: MOVEA.W    D5,A0
0BFC: TST.W      0(A0,D0.L)            ; Check score
0C00: BNE.S      $0C34                 ; Has score

; Calculate from letter value
0C08: MOVEQ      #17,D0
0C0A: MULS.W     D4,D0
0C0C: LEA        -17154(A5),A0
0C10: ADDA.L     D0,A0
0C12: MOVEA.W    D5,A0
0C14: MOVE.B     0(A0,D0.L),D0         ; Get letter
0C18: EXT.W      D0
0C1A: MOVEA.L    A5,A0
0C1C: ADDA.W     D0,A0
0C1E: ADDA.W     D0,A0
0C20: MOVEA.L    D3,A1
0C22: MOVE.W     -27630(A0),D3         ; Letter value
0C26: ADD.W      A1,D3                 ; Accumulate
0C28: ADD.W      D3,A1
0C2A: MOVE.L     A1,D3

; Check for special case (Q)
0C5C: MOVEQ      #17,D0
0C5E: MULS.W     D4,D0
0C60: LEA        -17154(A5),A0
0C64: ADDA.L     D0,A0
0C66: MOVEA.W    D5,A0
0C68: CMPI.B     #113,0(A0,D0.L)       ; 'q'?
0C6E: BNE.S      $0C9A

; Q handling - check word length
0C70: MOVE.L     D7,D0
0C72: EXT.L      D0
0C74: LSL.L      #3,D0
0C78: MOVEA.L    -10908(A5),A0
0C7C: MOVE.L     8(A0,D0.L),-(A7)
0C80: JSR        3522(A5)              ; strlen
0C84: SUBQ.L     #1,D0
0C88: BLS.S      $0C9A                 ; Single letter

; Divide by 2 for Q value
0C8E: PEA        2
0C92: MOVE.L     D3,-(A7)
0C94: JSR        90(A5)                ; divide
0C98: MOVE.L     D0,D3

; Store results
0C9A: MOVE.L     A4,D0
0C9C: BEQ.S      $0CA0
0C9E: MOVE.W     D7,(A4)+              ; Store index
0CA0: MOVE.L     A3,D0
0CA2: BEQ.S      $0CA6
0CA4: MOVE.W     D3,(A3)+              ; Store value
0CA6: ADD.L      D3,-10(A6)            ; Accumulate

0CAC: ADDQ.W     #1,D7                 ; Next position
0CAE: CMP.W      -10914(A5),D7         ; Check bounds
0CB0: BLT.W      $0A5E

; Terminate outputs
0CB4: MOVE.L     A4,D0
0CB6: BEQ.S      $0CBA
0CB8: CLR.W      (A4)                  ; Null terminate
0CBA: MOVE.L     A3,D0
0CBC: BEQ.S      $0CC0
0CBE: CLR.W      (A3)                  ; Null terminate

; Return total
0CC0: MOVE.L     -10(A6),D0
0CC4: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
0CC8: UNLK       A6
0CCA: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1064 | Character classification table |
| A5-2270 | "qu" string |
| A5-2272 | Pattern string |
| A5-2302 | Bonus lookup table |
| A5-2342 | Q penalty table |
| A5-2422 | Bonus square table |
| A5-10904 | Position info table (ptr) |
| A5-10908 | Position strings table (ptr) |
| A5-10914 | Board size |
| A5-15498 | g_current_rack |
| A5-16610 | g_state2 (score grid) |
| A5-17010 | g_game_flag |
| A5-17154 | g_state1 (letter grid) |
| A5-23218 | Letter count array |
| A5-24850 | Bingo adjustment value |
| A5-24866 | Bingo bonus table |
| A5-26158 | g_rack |
| A5-27374 | Letter prime values |
| A5-27630 | Letter point values |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | 32-bit multiply |
| 90 | 32-bit divide |
| 418 | bounds_error |
| 2002 | Check if letter playable |
| 2370 | Process rack |
| 2378 | Cleanup |
| 2394 | Get letter info |
| 2410 | Setup |
| 2498 | Calculate letter score |
| 2506 | Final score calculation |
| 2514 | Calculate letter value |
| 3514 | strchr |
| 3522 | strlen |

## SANE Operations Used

| Code | Operation |
|------|-----------|
| 0x0002 | Add |
| 0x0004 | Multiply |
| 0x0006 | Divide |
| 0x0008 | Compare add |
| 0x000D | Round |
| 0x0016 | Convert to extended |
| 0x2006 | Compare/add |
| 0x2008 | Compare |
| 0x280E | Move extended |
| 0x2810 | Extended to integer |
| 0x300E | Multiply extended |
| 0x3010 | Divide extended |

## Score Calculation Flow

1. **Initialize**: Setup rack and letter counts
2. **Word Score**: Calculate base word value
3. **Cross-words**: Add perpendicular word values
4. **Bonus Squares**: Apply letter/word multipliers
5. **Bingo Bonus**: Add 50 points for 7-letter word
6. **Q Handling**: Special scoring for Q/QU combinations
7. **Rack Leave**: Evaluate remaining tiles

## Confidence: HIGH

Clear SANE floating-point patterns:
- Extended precision arithmetic
- Multiple accumulation passes
- Position-based lookups
- Letter value tables
- Standard Scrabble scoring rules
