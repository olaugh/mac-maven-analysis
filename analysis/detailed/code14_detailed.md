# CODE 14 Detailed Analysis - Move Selection & Comparison

## Overview

| Property | Value |
|----------|-------|
| Size | 2,766 bytes |
| JT Offset | 624 |
| JT Entries | 14 |
| Functions | 20+ |
| Purpose | **Move selection, score comparison, AI decision making** |

## Architecture Role

CODE 14 handles AI move selection:
1. Copy rack letters to buffer for move generation
2. Compare moves by score for best-move selection
3. Coordinate search across directions
4. Manage player-specific data structures

## Key Functions

### Function 0x0000 - Copy Rack to Buffer
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A3/A4,-(SP)
0008: MOVEA.L    8(A6),A4             ; A4 = destination buffer
000C: MOVEQ      #0,D7                ; D7 = index
000E: LEA        -8664(A5),A3         ; A3 = g_flag1 (rack)
0012: BRA.S      $001C

; Copy each rack tile
0014: MOVE.B     1(A3),(A4)+          ; Copy letter byte
0018: ADDQ.W     #1,D7
001A: ADDQ.L     #8,A3                ; Next rack entry (8 bytes each)

001C: TST.W      (A3)                 ; Check if tile present
001E: BNE.S      $0014                ; Loop while tiles exist
0020: CLR.B      (A4)                 ; Null terminate
0022: MOVE.L     8(A6),D0             ; Return buffer ptr
002A: UNLK       A6
002C: RTS
```

**C equivalent**:
```c
char* copy_rack_to_buffer(char* dest) {
    RackEntry* rack = g_flag1;  // A5-8664
    int i = 0;

    while (rack->tile != 0) {
        dest[i++] = rack->letter;
        rack++;  // Each entry is 8 bytes
    }
    dest[i] = '\0';
    return dest;
}
```

### Function 0x002E - Main Search Coordinator
```asm
002E: LINK       A6,#-4
0032: JSR        2624(PC)             ; Initialize
0036: JSR        1082(A5)             ; JT[1082] - setup
003A: JSR        1018(A5)             ; JT[1018] - more setup
003E: PEA        -15514(A5)           ; g_field_14
0042: JSR        -68(PC)              ; Copy rack
0046: JSR        1706(A5)             ; JT[1706] - start search
004A: PEA        690(A5)              ; Push constant
004E: PEA        -4(A6)               ; Push local
0052: JSR        1722(A5)             ; JT[1722] - coordinate

; Bounds check
0056: CMPI.W     #8,-23674(A5)        ; Check counter
005C: BCC.S      $0068
0062: TST.W      -23674(A5)
0066: BGE.S      $006C
0068: JSR        418(A5)              ; bounds_error

; DAWG compare
00BC: MOVE.L     -24030(A5),-(A7)     ; Push compare ptr
00C0: MOVE.L     -27732(A5),-(A7)     ; Push DAWG ptr
00C4: JSR        3506(A5)             ; JT[3506] - compare
00C8: TST.W      D0
00CA: BEQ.S      $00D4
00CE: JSR        580(PC)              ; Not found handler
...
0104: CLR.L      -19486(A5)           ; Clear result
0108: JSR        1714(A5)             ; JT[1714] - cleanup
0114: RTS
```

### Function 0x0118 - Compare Two Moves
```asm
0118: LINK       A6,#0
011C: MOVEM.L    D5/D6/D7/A3/A4,-(SP)
0120: MOVEA.L    8(A6),A4             ; A4 = move1
0124: MOVEA.L    12(A6),A3            ; A3 = move2
0128: MOVE.L     20(A4),D7            ; D7 = move1.score
012C: ADD.L      16(A4),D7            ; Add bonus
0130: ADD.L      24(A4),D7            ; Add more
0134: MOVE.L     20(A3),D6            ; D6 = move2.score
0138: ADD.L      16(A3),D6
013C: ADD.L      24(A3),D6

; Compare scores
0140: CMP.W      D6,(A7)
0142: BGT.S      $0174                ; move2 wins

; If equal, check other criteria
0144: CMP.W      D7,(A6)
0146: BNE.S      $0150
0148: LEA        -7426(A5),A0         ; Return "equal" string
014C: MOVE.L     A0,D0
014E: BRA.S      $017A

; move1-move2 comparison
0150: MOVE.L     D6,D5
0152: SUB.L      D7,D5
0154: CMPI.L     #200,D5              ; < 200 points diff?
015A: BGT.S      $0164
015C: LEA        -7420(A5),A0         ; "close"
0160: MOVE.L     A0,D0
0162: BRA.S      $017A

0164: CMPI.L     #500,D5              ; < 500 points diff?
016A: BGT.S      $0174
016C: LEA        -7414(A5),A0         ; "moderate"
0170: MOVE.L     A0,D0
0172: BRA.S      $017A

0174: LEA        -7410(A5),A0         ; "significant"
0178: MOVE.L     A0,D0
017A: MOVEM.L    (SP)+,...
017E: UNLK       A6
0180: RTS
```

**C equivalent**:
```c
char* compare_moves(Move* move1, Move* move2) {
    long score1 = move1->base_score + move1->bonus + move1->extra;
    long score2 = move2->base_score + move2->bonus + move2->extra;

    if (score2 > score1) {
        // move2 better
    }

    if (score1 == score2) {
        return g_equal_string;  // A5-7426
    }

    long diff = score2 - score1;
    if (diff <= 200) return g_close_string;      // A5-7420
    if (diff <= 500) return g_moderate_string;   // A5-7414
    return g_significant_string;                  // A5-7410
}
```

### Function 0x0182 - Process Move Candidate
```asm
0182: LINK       A6,#-16
0186: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
018A: MOVEA.L    8(A6),A2             ; A2 = candidate
018E: JSR        2326(PC)             ; Validate
0192: TST.W      D0
0194: BEQ.W      $02D2                ; Invalid, skip

0198: PEA        -15514(A5)           ; g_field_14
019C: JSR        2410(A5)             ; JT[2410] - setup
01A0: PEA        -15514(A5)
01A4: JSR        2386(A5)             ; JT[2386] - more setup

; Check each rack tile
01A8: MOVEQ      #0,D7                ; D7 = count
01AA: LEA        -8664(A5),A4         ; A4 = rack
01B0: BRA.S      $01CC

01B2: TST.W      2(A4)                ; Tile present?
01B6: BEQ.S      $01C8                ; Skip if empty
01B8: LEA        -23218(A5),A3        ; Get letter array
01BC: ADD.B      D6,(A3)+             ; Index by letter
01BE: TST.B      (A3)
01C0: BGE.S      $01C6
01C2: JSR        418(A5)              ; bounds_error
01C6: SUBQ.B     #1,(A3)              ; Decrement count

01C8: ADDQ.W     #1,D7
01CA: ADDQ.L     #8,A4                ; Next tile
01CC: MOVE.W     (A4),D6
01CE: BNE.S      $01B2

; Process placement
01D0: PEA        -16(A6)              ; Local buffer
01D4: JSR        2386(A5)             ; Setup
01D8: LEA        30(A2),A4            ; A4 = candidate.placement
...
; Compare with existing best
022C: MOVE.L     A4,-(A7)
022E: MOVE.L     A2,-(A7)
0230: JSR        3506(A5)             ; JT[3506] - compare
0234: TST.W      D0
0236: BEQ.S      $023A
0238: MOVEQ      #0,D5                ; Not better
023A: BRA.S      $023C
023C: MOVEQ      #1,D5                ; Better

; Update best if needed
02C0: MOVE.L     A2,-(A7)
02C2: MOVEQ      #-1,D0
02C4: ADD.B      D6,D0
02C6: MOVE.W     D0,-(A7)
02C8: JSR        326(PC)              ; Store new best
...
02D8: RTS
```

### Function 0x0368 - Check if Valid Position
```asm
0368: LINK       A6,#0
036C: LEA        -15514(A5),A0        ; g_field_14
0370: CMP.L      -15498(A5),(A0)      ; Compare with limit
0376: TST.B      -15514(A5)           ; Check flag
037A: BEQ.S      $038A                ; If zero, skip

037C: JSR        1282(A5)             ; JT[1282] - validate
0380: TST.W      D0
0382: BNE.S      $038A                ; Valid
0384: TST.W      -9810(A5)            ; Check another flag
0388: BEQ.S      $038E                ; Invalid

038A: MOVEQ      #0,D0                ; Return false
038C: BRA.S      $0390
038E: MOVEQ      #1,D0                ; Return true
0390: UNLK       A6
0392: RTS
```

### Function 0x03AC - Get Handle Size and Count
```asm
03AC: LINK       A6,#-4
03B0: CLR.L      -(A7)
03B2: MOVEA.L    -8520(A5),A0         ; Window ptr
03B6: MOVE.L     202(A0),-(A7)        ; Get handle
03BA: JSR        2826(A5)             ; JT[2826] - GetHandleSize
03BE: MOVE.L     (A7)+,-4(A6)         ; Store size
03C2: PEA        6                    ; Divide by 6
03C6: MOVE.L     -4(A6),-(A7)
03CA: JSR        74(A5)               ; JT[74] - divide
03CE: UNLK       A6
03D0: RTS
```

**Purpose**: Returns number of 6-byte records in window data.

### Function 0x056E - Process Move List Entry
```asm
056E: LINK       A6,#-168             ; Large local frame
0572: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0576: MOVEA.L    8(A6),A4             ; A4 = entry
057A: CLR.W      -160(A6)             ; Clear flags
057E: CLR.W      -158(A6)
0582: MOVE.L     24(A4),-(A7)         ; Push score
0586: A8D4                            ; InvalRect trap
0588: LEA        -34(A6),A3           ; Local buffer

; Copy move data
058C: MOVEA.L    202(A4),A0           ; Get handle
0590: MOVEA.L    (A0),A0              ; Dereference
0592: MOVEA.L    2(A0),A0             ; Get data ptr
0596: MOVEA.L    (A0),A0              ; Dereference again
0598: LEA        -68(A6),A1           ; Dest buffer
059C: MOVEQ      #7,D0                ; Copy 32 bytes (8 longs)
059E: MOVE.L     (A0)+,(A1)+
05A0: DBF        D0,$059E
05A4: MOVE.W     (A0)+,(A1)+          ; Plus 2 more bytes

; Get current scores
05B8: MOVE.L     20(A3),D4            ; D4 = base score
05BC: ADD.L      16(A3),D4            ; Add bonus
05C0: ADD.L      24(A3),D4
05C4: MOVE.L     D4,D5                ; D5 = total

; Get handle size / 6 for count
05C6: CLR.L      -(A7)
05C8: MOVE.L     202(A4),-(A7)
05CC: JSR        2826(A5)             ; GetHandleSize
05D0: MOVE.L     (A7)+,-168(A6)
05D4: PEA        6
05D8: MOVE.L     -168(A6),-(A7)
05DC: JSR        74(A5)               ; divide
05E0: MOVE.L     D0,-152(A6)          ; Store count
...
```

## Move Structure (34 bytes)

| Offset | Size | Purpose |
|--------|------|---------|
| 0 | 2 | Flags |
| 2 | 2 | Row |
| 4 | 2 | Column |
| 6 | 2 | Direction |
| 8 | 8 | Word (null-terminated) |
| 16 | 4 | Bonus score |
| 20 | 4 | Base score |
| 24 | 4 | Extra score |
| 28 | 2 | Tile count |
| 30 | 4 | Placement data |

## Comparison Thresholds

| Difference | Category |
|------------|----------|
| 0 | Equal |
| 1-200 | Close |
| 201-500 | Moderate |
| 501+ | Significant |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-7410 | "significant" string |
| A5-7414 | "moderate" string |
| A5-7420 | "close" string |
| A5-7426 | "equal" string |
| A5-8520 | Window pointer |
| A5-8664 | g_flag1 (rack) |
| A5-9810 | Validation flag |
| A5-15498 | Field limit |
| A5-15514 | g_field_14 |
| A5-19486 | Result storage |
| A5-23218 | Letter count array |
| A5-23674 | Counter |
| A5-24030 | Compare pointer |
| A5-27732 | DAWG pointer |

## Confidence: HIGH

Clear move comparison and selection patterns:
- Score calculation from multiple components
- Comparison with threshold-based categorization
- Rack tile tracking
- Best-move selection
