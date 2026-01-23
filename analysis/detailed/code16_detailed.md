# CODE 16 Detailed Analysis - Statistics & Game History

## Overview

| Property | Value |
|----------|-------|
| Size | 1,894 bytes |
| JT Offset | 776 |
| JT Entries | 5 |
| Functions | 12 |
| Purpose | **Game statistics, history tracking, score formatting** |


## System Role

**Category**: Simulation
**Function**: Simulation Support

Supports Monte Carlo simulation (6 FP calls)
## Architecture Role

CODE 16 handles game statistics and history:
1. Track game history (moves, scores)
2. Format statistics for display
3. Scale scores for presentation
4. Generate statistical reports

## Key Functions

### Function 0x0000 - Copy Statistics Block
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A3/A4,-(SP)
0008: MOVEA.L    8(A6),A4             ; A4 = dest
000C: MOVEA.L    12(A6),A3            ; A3 = source
0010: MOVEQ      #0,D7                ; D7 = counter
0012: BRA.S      $001A

; Copy loop - 22 longs (88 bytes)
0014: MOVE.L     (A4)+,D0
0016: ADD.L      (A3)+,D0             ; Accumulate
0018: ADDQ.W     #1,D7

001A: CMPI.W     #22,D7
001E: BCS.S      $0014                ; Loop 22 times
0020: MOVEM.L    (SP)+,D7/A3/A4
0024: UNLK       A6
0026: RTS
```

**C equivalent**:
```c
void copy_stats_block(long* dest, long* source) {
    for (int i = 0; i < 22; i++) {
        dest[i] += source[i];
    }
}
```

### Function 0x0028 - Scale Statistics
```asm
0028: LINK       A6,#0
002C: MOVEM.L    D6/D7/A4,-(SP)
0030: MOVEA.L    8(A6),A4             ; A4 = stats block
0034: MOVE.L     16(A6),D7            ; D7 = scale factor

; Scale by 100, then by 2
0038: PEA        100                  ; divisor
003C: MOVE.L     D7,-(A7)             ; dividend
003E: JSR        66(A5)               ; JT[66] - divide
0042: MOVE.L     D0,D7                ; D7 = D7/100
0044: PEA        2
0048: MOVE.L     D7,-(A7)
004A: JSR        90(A5)               ; JT[90] - divide
004E: MOVE.L     D0,D6                ; D6 = D7/2

; Copy source to dest
0050: MOVEA.L    12(A6),A0            ; Source
0054: LEA        (A4),A1              ; Dest
0056: MOVEQ      #21,D0               ; 22 longs
0058: MOVE.L     (A0)+,(A1)+
005A: DBF        D0,$0058

; Scale fields at various offsets
; offset 4
0090: JSR        90(A5)               ; Divide by D7
0094: ADD.L      56(A4),D0
0098: LEA        4(A4),A0
009C: MOVE.L     D7,-(A7)
009E: MOVE.L     (A0),-(A7)
00A0: JSR        90(A5)
00A4: MOVE.L     D0,(A0)

; offset 8
00A6: LEA        8(A4),A1
00AA: MOVE.L     D7,-(A7)
00AC: MOVE.L     (A1),-(A7)
00AE: JSR        90(A5)
00B2: MOVE.L     D0,(A1)

; offset 12
00B4: LEA        12(A4),A0
...
; Continue for offsets 16, 20, 28, 32, 36, 40, 44, 48, 56
```

**Purpose**: Scales a 88-byte statistics block by a percentage factor.

### Function 0x0148 - Format Statistics Report
```asm
0148: LINK       A6,#-236             ; Large local frame
014C: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0150: MOVEA.L    8(A6),A4             ; A4 = output buffer

; Get current player
0154: MOVEA.L    -8584(A5),A0         ; Window handle
0158: MOVEA.L    (A0),A0              ; Dereference
015A: MOVE.W     770(A0),D0           ; Current player
015E: MOVEA.L    A5,A0
0160: EXT.L      D0
0162: LSL.L      #3,D0                ; * 8
0166: MOVE.L     -6956(A0,D0.L),-(A7) ; Player data offset
016A: PEA        -6940(A5)            ; Format string
016E: MOVE.L     A4,-(A7)             ; Output buffer
0170: JSR        2066(A5)             ; JT[2066] - sprintf

; Get history handle
017A: JSR        974(PC)              ; Get history
017E: MOVEA.L    D0,A3                ; A3 = history ptr
0180: MOVE.L     A3,D0
0186: BEQ.W      $04E6                ; No history

; Clear counters
018A: CLR.L      -222(A6)             ; wins
018E: CLR.L      -208(A6)             ; losses
0192: CLR.L      -216(A6)             ; ties
0196: CLR.L      -212(A6)             ; games
019A: MOVEQ      #0,D6
019C: MOVE.L     D6,D5
019E: MOVEQ      #0,D4

; Get entry count
01A0: MOVE.L     (A3),D7              ; D7 = count
01A2: MOVEA.L    -8584(A5),A0
01A6: MOVEA.L    (A0),A0
01A8: MOVE.W     770(A0),-218(A6)     ; Store player

; Loop through entries
01B0: MOVE.L     D4,D0
01B2: EXT.L      D0
01B4: LSL.L      #3,D0                ; * 8
01B8: MOVEA.L    A2,A0
01B6: BRA.S      $021A

; Check entry for current player
01B8: MOVE.W     6(A2,D7.L),D0        ; Entry player
01BC: CMP.W      -218(A6),D0          ; Match current?
01C0: BNE.S      $0216                ; Skip if not

; Accumulate statistics
01C4: MOVEA.L    A2,A0
01C8: ADD.L      (A3),$3610.W         ; Add to total
01CC: MOVEA.L    A2,A0
01CE: ADD.L      (A3),$2D48.W
01D2: MOVE.W     4(A4),D0
01D4: EXT.L      D0
01D8: ADD.L      -216(A6),D0          ; Add to ties
...
; Continue accumulating
0216: ADDQ.W     #1,D4
0218: ADDQ.L     #8,A2                ; Next entry
021A: MOVEA.W    D4,A0
021C: CMP.L      -4(A6),A0            ; Check count
0220: BLT.S      $01B8                ; Loop

; Calculate percentages
0230: PEA        2                    ; Divide by 2
0234: MOVE.L     D3,-(A7)
0236: JSR        90(A5)
023A: MOVE.L     D0,D4
...
; Format output strings
02B0: PEA        -15514(A5)           ; g_field_14
02B4: MOVE.L     A4,-(A7)
02B6: JSR        2066(A5)             ; sprintf

; Format various statistics
032E: PEA        -6826(A5)            ; Format string
0330: MOVE.L     A4,-(A7)
0334: JSR        2066(A5)             ; sprintf
...
; Multiple sprintf calls for different stats
```

### Function 0x054A - Get History Resource
```asm
054A: LINK       A6,#0
054E: MOVE.L     A4,-(A7)
0550: CLR.L      -(A7)                ; NULL
0552: MOVE.L     #'HIST',-(A7)        ; Resource type 'HIST'
0558: CLR.W      -(A7)                ; ID 0
055A: A9A0                            ; GetResource trap
055E: MOVEA.L    (A7)+,A4             ; A4 = handle
0560: MOVE.L     A4,D0
0562: BEQ.S      $0574                ; Not found

0562: CLR.L      -(A7)
0564: MOVE.L     A4,-(A7)
0566: JSR        2826(A5)             ; GetHandleSize
056A: MOVE.L     (A7)+,D0
056C: LSR.L      #3,D0                ; / 8
056E: MOVEA.L    8(A6),A0
0572: MOVE.L     D0,(A0)              ; Store count

0574: MOVE.L     A4,D0                ; Return handle
0578: UNLK       A6
057A: RTS
```

**C equivalent**:
```c
Handle get_history(long* count_out) {
    Handle h = GetResource('HIST', 0);
    if (h != NULL) {
        long size = GetHandleSize(h);
        *count_out = size / 8;  // 8 bytes per entry
    }
    return h;
}
```

### Function 0x06F0 - Generate Full Report
```asm
06F0: LINK       A6,#-16384           ; 16KB local buffer!
06F4: MOVE.L     D7,-(A7)
06F6: PEA        -16384(A6)           ; Buffer
06FA: JSR        -1460(PC)            ; Format stats
06FE: MOVE.L     D0,D7                ; D7 = length

0700: PEA        -16384(A6)           ; Buffer
0704: MOVE.L     D7,-(A7)             ; Length
0706: MOVEA.L    -8580(A5),A0         ; Window
070A: MOVE.L     160(A0),-(A7)        ; Get TE handle
070E: A9CF                            ; TESetText trap
0710: MOVE.L     -8580(A5),(A7)
0714: JSR        1890(A5)             ; JT[1890] - update
0718: MOVE.L     -8580(A5),(A7)
071C: JSR        1874(A5)             ; JT[1874] - redraw
0720: CLR.W      (A7)                 ; Push 0
0722: JSR        -424(PC)             ; Another function
072C: RTS
```

**Purpose**: Generates a full statistics report and displays in a TextEdit field.

## Statistics Block Structure (88 bytes)

| Offset | Size | Purpose |
|--------|------|---------|
| 0 | 4 | Total games |
| 4 | 4 | Wins |
| 8 | 4 | Losses |
| 12 | 4 | Ties |
| 16 | 4 | Total points scored |
| 20 | 4 | Total points against |
| 24-84 | - | Various accumulated stats |

## History Entry Structure (8 bytes)

| Offset | Size | Purpose |
|--------|------|---------|
| 0 | 4 | Score/data |
| 4 | 2 | Flags |
| 6 | 2 | Player ID |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-6826 | Format string |
| A5-6940 | Player format string |
| A5-8580 | Statistics window |
| A5-8584 | Main window handle |
| A5-15514 | g_field_14 |

## Toolbox Traps

| Trap | Purpose |
|------|---------|
| A9A0 | GetResource |
| A9CF | TESetText |

## Confidence: HIGH

Clear statistics tracking:
- History resource loading ('HIST')
- Accumulation of wins/losses/ties
- Percentage calculations
- Text formatting for display
