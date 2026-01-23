# CODE 27 Detailed Analysis - Move Candidate List Management

## Overview

| Property | Value |
|----------|-------|
| Size | 662 bytes |
| JT Offset | 2048 |
| JT Entries | 4 |
| Functions | 4 |
| Purpose | **Manage linked list of move candidates, filtering and sorting** |


## System Role

**Category**: Move Logic
**Function**: Move Generation

Move generation helper
## Architecture Role

CODE 27 manages move candidate data structures:
1. Iterate over candidate list with callback
2. Evaluate and filter candidates
3. Compare candidate positions
4. Copy candidate data between structures

## Key Data Structure

Move candidate structure (at least 34 bytes):
```
+0:  next pointer (linked list)
+4:  score data
+8:  flags
+9:  row
+10: column
+11: direction
+12: word length
+13: candidate ID
+16: base score
+20: bonus score
+24: extra score
+28: flags2
+29: special flag
+30: player ID
+31: additional flags
+32: word data
```

## Key Functions

### Function 0x0000 - Iterate Candidates with Callback
```asm
0000: LINK       A6,#0
0004: MOVE.L     A4,-(A7)
0006: MOVEA.L    -2786(A5),A4         ; A4 = candidate list head
000A: BRA.S      $0018                ; Jump to test

; Loop body
000C: MOVE.L     A4,-(A7)             ; Push candidate
000E: MOVEA.L    8(A6),A0             ; Get callback
0012: JSR        (A0)                 ; Call callback(candidate)
0014: ADDQ.L     #4,A7                ; Clean stack
0016: MOVEA.L    (A4),A4              ; A4 = A4->next

; Loop test
0018: MOVE.L     A4,D0                ; Test pointer
001A: BNE.S      $000C                ; Continue if not null
001C: MOVEA.L    (A7)+,A4
001E: UNLK       A6
0020: RTS
```

**C equivalent**:
```c
void iterate_candidates(void (*callback)(Candidate* c)) {
    Candidate* c = g_candidate_head;  // A5-2786
    while (c != NULL) {
        callback(c);
        c = c->next;
    }
}
```

### Function 0x0022 - Evaluate Candidate Scores
```asm
0022: LINK       A6,#-4               ; frame=4
0026: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
002A: MOVEA.L    8(A6),A2             ; A2 = input candidate
002E: MOVEA.L    20(A6),A0
0032: CLR.W      (A0)                 ; Clear result flag
0034: MOVEQ      #0,D7                ; D7 = count

0036: JSR        2738(A5)             ; JT[2738] - setup

; Initialize best scores to large value
003A: MOVE.L     #$0BEBC200,D5        ; D5 = 200000000 (big number)
0040: MOVE.L     D5,D6                ; D6 = same
0042: LEA        -2786(A5),A4         ; A4 = &list head

; Loop through candidates
0046: BRA.W      $00EA                ; Jump to test
004A: MOVE.L     A2,-(A7)             ; Push input
004C: MOVE.L     A3,-(A7)             ; Push candidate
004E: JSR        2722(A5)             ; JT[2722] - compare
0052: TST.L      D0
0054: ADDQ.L     #8,A7
0056: BNE.W      $00E8                ; Different, skip

; Check if candidate is better
005A: TST.B      8(A3)                ; Check flag
005E: BEQ.S      $0086                ; If zero, do normal calc

; Special handling for flagged candidates
0060: MOVEA.L    A5,A0
0062: MOVE.W     30(A2),D0            ; Get player ID
0066: ADDA.W     D0,A0
0068: ADDA.W     D0,A0
006A: MOVEA.W    -13318(A0),A0        ; Get player data
006E: ADDA.L     A0,A0
0072: MOVE.L     16(A2),D0            ; Get score
0076: SUB.L      4(A3),D0             ; Subtract candidate score
007A: ADD.L      D0,D4                ; Accumulate
007C: MOVEA.L    20(A6),A0
0080: MOVE.W     #1,(A0)              ; Set found flag
0084: BRA.S      $00BC

; Normal score calculation
0086: PEA        -4(A6)               ; Local var
008A: PEA        -2(A6)               ; Local var
008E: MOVE.B     9(A3),D0             ; Get row
0092: EXT.W      D0
0094: MOVE.W     D0,-(A7)
0096: MOVE.W     30(A2),-(A7)         ; Player ID
009A: JSR        2666(A5)             ; JT[2666] - calc position
009E: MOVE.L     16(A2),D3            ; D3 = input score
00A2: SUB.L      4(A3),D3             ; Subtract
00A6: ADD.W      D0,A0
00A8: ADD.L      D3,D4                ; Accumulate
00AA: MOVEA.W    -2(A6),A0
00AE: ADD.L      A0,A4
00B2: MOVEA.W    -4(A6),A0
00B6: SUB.L      A0,A3
00B8: LEA        12(A7),A7

; Track best scores
00BC: CMP.L      D4,A6
00BE: BLE.S      $00C2
00C0: MOVE.L     D4,D6                ; Update best

00C2: CMP.L      D3,A5
00C4: BLE.S      $00C8
00C6: MOVE.L     D3,D5                ; Update best

; Check thresholds
00C8: MOVEA.L    12(A6),A0            ; Get threshold1
00CC: CMP.L      (A0),A6
00CE: BGE.S      $00E6                ; If below threshold
00D0: MOVEA.L    16(A6),A0            ; Get threshold2
00D4: CMP.L      (A0),A5
00D6: BGE.S      $00E6                ; If below threshold

; Add to result list
00D8: MOVE.L     (A3),(A4)            ; candidate->next = list->next
00DA: MOVE.L     -2786(A5),(A3)       ; candidate->next = head
00DE: MOVE.L     A3,-2786(A5)         ; head = candidate
00E2: MOVEQ      #1,D7                ; Found one
00E4: BRA.S      $00F0                ; Continue

00E6: MOVEA.L    A3,A4                ; Update prev pointer
00E8: MOVEA.L    (A4),A3              ; A3 = next candidate

; Loop test
00EA: MOVE.L     A3,D0
00EC: BNE.W      $004C                ; Continue if not null

; ... more processing ...
0140: MOVEM.L    (SP)+,...
0144: UNLK       A6
0146: RTS
```

### Function 0x0148 - Compare Two Positions
```asm
0148: LINK       A6,#0
014C: MOVEM.L    A3/A4,-(SP)
0150: MOVEA.L    8(A6),A4             ; A4 = pos1
0154: MOVEA.L    12(A6),A3            ; A3 = pos2

; Compare row
0158: MOVE.B     9(A4),D0             ; pos1.row
015C: CMP.B      9(A3),D0             ; pos2.row
0160: BNE.S      $0180                ; Different

; Compare column
0162: MOVE.B     10(A4),D0            ; pos1.col
0166: CMP.B      10(A3),D0            ; pos2.col
016A: BNE.S      $0180                ; Different

; Compare direction
016C: MOVE.B     11(A4),D0            ; pos1.dir
0170: CMP.B      11(A3),D0            ; pos2.dir
0174: BNE.S      $0180                ; Different

; Compare word length
0176: MOVE.B     12(A4),D0            ; pos1.len
017A: CMP.B      12(A3),D0            ; pos2.len
017E: BEQ.S      $0184                ; Same

0180: MOVEQ      #0,D0                ; Return false
0182: BRA.S      $0186

0184: MOVEQ      #1,D0                ; Return true

0186: MOVEM.L    (SP)+,A3/A4
018A: UNLK       A6
018C: RTS
```

**C equivalent**:
```c
int positions_equal(Candidate* c1, Candidate* c2) {
    return (c1->row == c2->row) &&
           (c1->col == c2->col) &&
           (c1->dir == c2->dir) &&
           (c1->len == c2->len);
}
```

### Function 0x018E - Copy Candidate Data
```asm
018E: LINK       A6,#0
0192: MOVEM.L    A3/A4,-(SP)
0196: MOVEA.L    8(A6),A4             ; A4 = dest
019A: MOVEA.L    12(A6),A3            ; A3 = source

; Copy selected fields
019E: MOVE.B     29(A3),8(A4)         ; flags
01A4: MOVE.L     16(A3),4(A4)         ; score
01AA: MOVE.B     32(A3),10(A4)        ; col
01B0: MOVE.B     33(A3),11(A4)        ; dir

; Get word length
01B6: MOVE.L     A3,-(A7)
01B8: JSR        3522(A5)             ; JT[3522] - strlen
01BC: MOVE.B     D0,12(A4)            ; Store length

; Copy more fields
01C0: MOVE.B     31(A3),9(A4)         ; row
01C6: MOVEM.L    (SP)+,A3/A4
01CC: UNLK       A6
01CE: RTS
```

### Function 0x01D0 - Build Candidate List
```asm
01D0: LINK       A6,#0
01D4: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
01D8: MOVE.L     8(A6),D7             ; D7 = input pointer
01DC: MOVEA.L    D7,A4
01DE: MOVEQ      #0,D6                ; D6 = count
01E0: MOVEA.L    D7,A2
01E2: LEA        3584(A2),A2          ; Skip to data area

; Clear list head
01E6: CLR.L      -2786(A5)

; Loop through entries
01EA: BRA.S      $020C

01EC: TST.B      10(A2)               ; Check if valid
01F0: BEQ.S      $020C                ; Skip if not

01F2: CMPI.W     #256,D6              ; Max 256 entries
01F6: BLT.S      $01FC
01F8: JSR        418(A5)              ; bounds_error

; Link into list
01FC: MOVE.W     D6,D0
01FE: ADDQ.W     #1,D6                ; count++
0200: MOVE.B     D0,13(A2)            ; Store ID
0204: MOVE.L     -2786(A5),(A2)       ; entry->next = head
0208: MOVE.L     A2,-2786(A5)         ; head = entry

020C: LEA        -14(A2),A2           ; Previous entry (going backwards?)
0210: CMP.L      A2,A4                ; Reached start?
0214: BCS.S      $01EC                ; Continue

; ... additional processing ...
028A: MOVE.L     -2786(A5),D0         ; Return list head
028E: MOVEM.L    (SP)+,...
0292: UNLK       A6
0294: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2786 | Candidate linked list head |
| A5-2926 | Secondary candidate array |
| A5-12540 | Counter variable |
| A5-23056 | DAWG/move data array |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | bounds_error |
| 2666 | Calculate position score |
| 2722 | Compare candidates |
| 2738 | Setup function |
| 3522 | strlen |

## Candidate Comparison

Two candidates match if they have the same:
- Row (offset 9)
- Column (offset 10)
- Direction (offset 11)
- Word length (offset 12)

## Confidence: HIGH

Clear linked list management:
- Standard linked list iteration with callback
- Position comparison for matching
- Data copying between structures
- List building with bounds checking
