# CODE 28 Detailed Analysis - Move Array Management

## Overview

| Property | Value |
|----------|-------|
| Size | 664 bytes |
| JT Offset | 2080 |
| JT Entries | 3 |
| Functions | 3 |
| Purpose | **Move array insertion, score calculation, word string handling** |


## System Role

**Category**: Move Data Structures
**Function**: Sorted Move Array Management

## Architecture Role

CODE 28 manages arrays of move candidates:
1. Insert moves into sorted array
2. Calculate word scores
3. Handle move scoring during search

## Key Data Structures

Move array entry (34 bytes each):
```
+0:   next pointer (for linked list mode)
+4:   score data
+8:   flags
+16:  base score (long)
+20:  bonus score (long)
+24:  extra score (long)
+34:  next entry
```

## Key Functions

### Function 0x0000 - Insert Move into Sorted Array
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A2/A3/A4,-(SP)    ; save
0008: MOVEA.L    8(A6),A4             ; A4 = move to insert

; Calculate total score
000C: MOVE.L     20(A4),D7            ; D7 = base score
0010: ADD.L      16(A4),D7            ; + bonus
0014: ADD.L      24(A4),D7            ; + extra

; Check array limit
0018: CMPI.W     #10,-12540(A5)       ; Max 10 entries?
001E: BNE.S      $0028

; Compare with worst score in array
0020: CMP.L      -2782(A5),D7         ; Compare with min score
0024: BLE.W      $00DE                ; If worse, don't insert

; Validate move
0028: MOVE.L     A4,-(A7)
002A: JSR        2762(A5)             ; JT[2762] - validate move
002E: TST.W      D0
0030: ADDQ.L     #4,A7
0032: BEQ.W      $00DE                ; Invalid, skip

; Find insertion point (array already has entries)
0036: CMPI.W     #10,-12540(A5)
003C: BNE.S      $005A                ; Not full, different path

; Find position in sorted array
003E: LEA        -23056(A5),A3        ; A3 = array base
0042: BRA.S      $0048

0044: LEA        34(A3),A3            ; A3 += 34 (next entry)

; Compare scores
0048: MOVE.L     16(A3),D0            ; Entry base score
004C: ADD.L      20(A3),D0            ; + bonus
0050: ADD.L      24(A3),D0            ; + extra
0054: CMP.L      D7,D0                ; Compare with new score
0056: BGE.S      $0044                ; Continue if entry >= new
0058: BRA.S      $008A                ; Found position

; Not at limit - find position differently
005A: LEA        -23056(A5),A3        ; A3 = array base
005E: MOVEQ      #34,D0               ; Entry size
0060: MULS.W     -12540(A5),D0        ; * count
0064: LEA        -23056(A5),A2
0068: ADDA.L     D0,A2                ; A2 = end of used entries
006A: BRA.S      $0072

006E: LEA        34(A3),A3            ; Next entry

; Compare and find position
0072: CMP.L      A3,A2                ; Reached end?
0076: MOVE.L     16(A3),D0
007A: ADD.L      20(A3),D0
007E: ADD.L      24(A3),D0
0082: CMP.L      D7,D0
0084: BGE.S      $006E
0086: ADDQ.W     #1,-12540(A5)        ; Increment count

; Shift entries to make room
008A: PEA        34                   ; Entry size
008E: PEA        34
0092: LEA        -23056(A5),A0
0096: MOVE.L     A3,D0
0098: SUB.L      A0,D0                ; Offset of insertion point
009A: MOVE.L     D0,-(A7)
009C: JSR        90(A5)               ; JT[90] - divide

; Calculate entries to shift
00A0: MOVEA.W    -12540(A5),A0        ; Current count
00A4: SUBQ.W     #1,A0
00A6: SUB.L      D0,A0
00A8: MOVE.L     A0,-(A7)
00AA: JSR        66(A5)               ; JT[66] - multiply
00AE: MOVE.L     D0,-(A7)
00B0: MOVE.L     A3,-(A7)
00B2: PEA        34(A3)               ; Destination
00B6: JSR        3466(A5)             ; JT[3466] - memmove

; Copy new entry into position
00BA: LEA        (A3),A0              ; Dest
00BC: LEA        (A4),A1              ; Source
00BE: MOVEQ      #7,D0                ; 8 longs = 32 bytes
00C0: MOVE.L     (A1)+,(A0)+          ; Copy loop
00C2: DBF        D0,$00C0
00C6: MOVE.W     (A1)+,(A0)+          ; Plus 2 more bytes

; Update minimum score tracker
00C8: LEA        -22750(A5),A3        ; Last entry in array
00CC: MOVE.L     16(A3),D0
00D0: ADD.L      20(A3),D0
00D4: ADD.L      24(A3),D0
00D8: MOVE.L     D0,-2782(A5)         ; Store as min score

00DC: MOVEM.L    (SP)+,...
00E2: UNLK       A6
00E4: RTS
```

**C equivalent**:
```c
void insert_move(Move* new_move) {
    long score = new_move->base + new_move->bonus + new_move->extra;

    // Check if array is full and score is too low
    if (g_move_count >= 10 && score <= g_min_score) {
        return;
    }

    // Validate move
    if (!validate_move(new_move)) {
        return;
    }

    // Find insertion point (sorted descending by score)
    Move* pos = g_move_array;
    while (pos->score >= score && pos < end_of_array) {
        pos++;
    }

    // Shift entries down
    memmove(pos + 1, pos, remaining_entries * 34);

    // Copy new entry
    memcpy(pos, new_move, 34);

    // Update minimum score
    g_min_score = g_move_array[g_move_count - 1].score;
}
```

### Function 0x00E6 - Calculate Word Score
```asm
00E6: LINK       A6,#0
00EA: MOVEM.L    D6/D7,-(SP)
00EE: MOVEQ      #0,D7                ; D7 = total score
00F0: BRA.S      $0100

; Sum letter values
00F2: MOVE.B     D6,D0                ; Get letter
00F4: EXT.W      D0
00F6: MOVEA.L    A5,A0
00F8: ADDA.W     D0,A0
00FA: ADDA.W     D0,A0
00FC: ADD.W      -27630(A0),D7        ; Add letter value

; Get next letter
0100: MOVEA.L    8(A6),A0             ; String pointer
0104: ADDQ.L     #1,8(A6)             ; Advance
0108: MOVE.B     (A0),D6              ; Get char
010A: BNE.S      $00F2                ; Continue if not null

010C: MOVE.W     D7,D0                ; Return total
010E: MOVEM.L    (SP)+,D6/D7
0112: UNLK       A6
0114: RTS
```

**C equivalent**:
```c
int calculate_word_score(char* word) {
    int total = 0;
    while (*word) {
        total += g_letter_values[(unsigned char)*word * 2];
        word++;
    }
    return total;
}
```

### Function 0x0116 - Process Move Search
```asm
0116: LINK       A6,#-528             ; Large stack frame
011A: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
011E: MOVEA.L    8(A6),A4             ; A4 = search context
0122: MOVEA.L    12(A6),A3            ; A3 = callback

; Initialize
0126: MOVE.L     A4,-(A7)
0128: JSR        2410(A5)             ; JT[2410] - setup

012C: PEA        -132(A6)
0130: JSR        2394(A5)             ; JT[2394]
0134: MOVE.B     D0,D4                ; D4 = some count

0136: JSR        2458(A5)             ; JT[2458]

; Clear move array
013A: PEA        340                  ; 10 * 34 bytes
013E: PEA        -23056(A5)           ; g_dawg_?
0142: JSR        426(A5)              ; JT[426] - memset

; Clear local buffer
0146: MOVEQ      #34,D0
0148: MOVE.L     D0,(A7)
014A: PEA        -182(A6)
014E: JSR        426(A5)              ; memset

; Initialize counters
0152: CLR.W      -12540(A5)           ; Move count = 0
0156: CLR.W      -20010(A5)           ; Another counter

; Set sentinel value
015A: MOVE.L     #$F4143E00,-23040(A5)  ; Marker value

; Run search
0162: JSR        2354(A5)             ; JT[2354] - start search
0166: TST.W      D0
0168: LEA        20(A7),A7
016C: BEQ.S      $0178                ; If search found nothing

; Process result
016E: MOVE.L     A3,-(A7)             ; Push callback
0170: JSR        2490(A5)             ; JT[2490]
0174: ADDQ.L     #4,A7
0176: BRA.S      $01BE

; Alternative search
0178: JSR        2362(A5)             ; JT[2362]
017C: TST.W      D0
017E: BEQ.S      $01BE                ; Nothing found

; Check which field to use
0180: LEA        -15514(A5),A0        ; g_field_14
0184: CMP.L      A4,A0
0188: LEA        -15522(A5),A0        ; g_field_22
018C: MOVE.L     A0,D0
018E: BRA.S      $0196

0190: LEA        -15514(A5),A0        ; g_field_14
0194: MOVE.L     A0,D0

; Calculate word score
0196: MOVE.L     D0,-(A7)
0198: JSR        -180(PC)             ; calculate_word_score
019C: NEG.W      D0                   ; Negate
019E: MOVE.W     D0,-528(A6)

01A2: MOVE.L     A4,(A7)
01A4: JSR        -192(PC)             ; calculate_word_score
01A8: ADD.W      D0,A0
01AA: MOVE.W     -528(A6),D1
01AE: SUB.W      D0,A1
01B0: MOVEA.W    D1,A0
01B2: MOVE.L     A0,-162(A6)          ; Store difference

01B6: PEA        -182(A6)             ; Local buffer
01BA: JSR        (A3)                 ; Call callback
01BC: ADDQ.L     #4,A7

; Cleanup
01BE: MOVE.L     A3,-(A7)
01C0: JSR        2618(A5)             ; JT[2618] - cleanup

; Check sentinel
01C4: CMPI.L     #$F4143E00,-23040(A5)
01CC: ADDQ.L     #4,A7
01CE: BNE.S      $01D8

01D0: CLR.L      -23040(A5)           ; Clear sentinel
01D4: BRA.W      $0292                ; Exit

; Continue processing if more to do...
01D8: CMPI.B     #17,D4
01DC: BCS.W      $0292                ; If < 17, exit

; ... additional processing for each position ...
028A: BGT.W      $0208
0290: MOVEM.L    (SP)+,...
0294: UNLK       A6
0296: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2782 | Minimum score in array |
| A5-12540 | Move count |
| A5-15514 | g_field_14 (word field) |
| A5-15522 | g_field_22 (another field) |
| A5-20010 | Secondary counter |
| A5-22750 | Last entry in array |
| A5-23040 | Sentinel/marker value |
| A5-23056 | Move array base |
| A5-27630 | Letter value table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | multiply |
| 90 | divide |
| 426 | memset |
| 2354 | Start search |
| 2362 | Alternative search |
| 2394 | Get count |
| 2410 | Setup |
| 2458 | Another setup |
| 2490 | Process result |
| 2618 | Cleanup |
| 2762 | Validate move |
| 3466 | memmove |

## Move Array Layout

The array at A5-23056 holds up to 10 moves (340 bytes total):
- Sorted by score (highest first)
- Insertion maintains sort order
- Worst move tracked at A5-2782 for fast rejection

## Confidence: HIGH

Clear array management patterns:
- Sorted insertion with shift
- Score calculation from letter values
- Sentinel value for search state
- Standard search/callback pattern
