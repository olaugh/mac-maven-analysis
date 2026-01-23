# CODE 17 Detailed Analysis - Text Editing & Windows

## Overview

| Property | Value |
|----------|-------|
| Size | 2,618 bytes |
| JT Offset | 1736 |
| JT Entries | 29 |
| Functions | 30+ |
| Purpose | **TextEdit management, scrollable windows, modal dialogs** |

## Architecture Role

CODE 17 provides text editing support:
1. Scrollable text windows
2. TextEdit record management
3. File loading into text fields
4. Window activation/deactivation

## Key Functions

### Function 0x0000 - Load Text from File
```asm
0000: LINK       A6,#-10034           ; Large local buffer
0004: MOVE.L     A4,-(A7)
0006: MOVEA.L    12(A6),A4            ; A4 = file info
000A: MOVE.L     #10000,-10022(A6)    ; Buffer size
0012: MOVE.L     #'TEXT',-16(A6)      ; File type

; Standard file dialog
001A: MOVE.W     #1,-(A7)             ; numTypes
001E: PEA        -16(A6)              ; typeList
0022: MOVE.L     A4,-(A7)             ; reply
0024: JSR        1554(A5)             ; JT[1554] - SFGetFile
0028: TST.W      D0
002A: LEA        10(A7),A7
002E: BEQ.W      $00B8                ; User cancelled

; Open file
0032: CLR.W      -(A7)                ; Permission
0034: PEA        10(A4)               ; Filename
0038: MOVE.W     6(A4),-(A7)          ; vRefNum
003C: PEA        -18(A6)              ; refNum result
0040: JSR        2842(A5)             ; JT[2842] - FSOpen
0044: TST.W      (A7)+
0046: BEQ.S      $004C
0048: JSR        418(A5)              ; Error

; Read file contents
004C: MOVEA.L    8(A6),A4             ; A4 = window
0050: LEA        160(A4),A4           ; TE handle offset
0054: CLR.W      -(A7)
0056: MOVE.W     -18(A6),-(A7)        ; refNum
005A: PEA        -10022(A6)           ; byte count
005E: PEA        -10018(A6)           ; buffer
0062: JSR        2858(A5)             ; JT[2858] - FSRead

; Set TextEdit text
0066: PEA        -10018(A6)           ; buffer
006A: MOVEA.W    -10020(A6),A0        ; bytes read
006E: MOVE.L     A0,-(A7)             ; length
0070: MOVE.L     (A4),-(A7)           ; TE handle
0072: A9DE                            ; TESetText trap

; Close file
0080: CLR.W      -(A7)
0082: MOVE.W     -18(A6),-(A7)        ; refNum
0086: JSR        2850(A5)             ; JT[2850] - FSClose
...
00BC: RTS
```

### Function 0x00BE - Handle Scroll Event
```asm
00BE: LINK       A6,#0
00C2: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
00C6: MOVE.L     10(A6),D7            ; D7 = window
00CA: TST.W      8(A6)                ; Check event type
00CE: BEQ.W      $016E                ; No scroll needed

; Get window data
00D2: MOVEA.L    D7,A0
00D4: MOVEA.L    (A0),A0
00D6: MOVEA.L    4(A0),A4             ; A4 = window data
00DA: CMP.W      156(A4),(A7)         ; Compare scroll pos
00DE: BEQ.S      $00E4
00E0: JSR        418(A5)              ; Error

; Handle scroll direction
00E4: MOVE.W     8(A6),D0
00E8: BMI.S      $0152                ; Negative = error

00EA: SUBI.W     #22,D0               ; Check type
00EE: BEQ.S      $011A                ; Page up/down
00F0: BPL.S      $00FA
00F2: ADDQ.W     #2,D0                ; Line up/down
00F4: BEQ.S      $0100                ; Line up
00F6: BPL.S      $010E                ; Line down
00F8: BRA.S      $0152

; Line up
0100: MOVEA.L    160(A4),A0           ; TE handle
0104: MOVEA.L    (A0),A0
0106: MOVE.W     24(A0),D6            ; Line height
010A: NEG.W      D6                   ; Negative for up
010C: BRA.S      $0156

; Line down
010E: MOVEA.L    160(A4),A0
0112: MOVEA.L    (A0),A0
0114: MOVE.W     24(A0),D6            ; Line height
0118: BRA.S      $0156

; Page up/down
011A: MOVEA.L    160(A4),A0
011E: MOVEQ      #8,D0                ; Page = 8 lines
0120: ADD.L      (A0),D0
0122: MOVEA.L    D0,A2
0124: MOVEA.L    160(A4),A0
0128: MOVEA.L    (A0),A3
012A: MOVE.W     24(A3),D6            ; Line height
012E: MULU.W     (A2),D6              ; * visible lines
0130: SUB.W      4(A2),D6
0134: BRA.S      $0156

; Apply scroll
0156: MOVE.L     D7,-(A7)             ; Window
0158: CLR.W      -(A7)
015A: MOVE.L     D7,-(A7)
015C: A960                            ; GetCtlValue trap
0160: MOVE.W     (A7)+,D0
0162: ADD.W      D6,D0                ; Add delta
0164: MOVE.W     D0,-(A7)
0166: A963                            ; SetCtlValue trap
0168: MOVE.L     A4,-(A7)
016C: JSR        16(PC)               ; Update display
...
0178: JMP        (A0)                 ; Return
```

### Function 0x017A - Update TextEdit Display
```asm
017A: LINK       A6,#0
017E: MOVEM.L    D5/D6/D7/A3/A4,-(SP)
0182: MOVEA.L    8(A6),A3             ; A3 = window
0186: LEA        160(A3),A4           ; A4 = TE handle ptr
018A: MOVE.L     (A4),-(A7)           ; Push TE handle
018C: JSR        72(PC)               ; Get scroll info
0190: MOVE.W     D0,D7                ; D7 = current pos

0192: CLR.W      -(A7)
0194: MOVE.L     156(A3),-(A7)        ; Scroll bar
0198: A960                            ; GetCtlValue trap
019C: MOVE.W     (A7)+,D6             ; D6 = scroll value

; Get TE metrics
01A0: MOVEA.L    160(A3),A0
01A4: MOVEA.L    (A0),A0
01A6: MOVE.W     24(A0),D5            ; D5 = line height
01A8: LEA        10(A7),A7

; Scroll TE if needed
01AA: BRA.S      $01AC
01AC: SUBQ.W     #1,D6
01AE: MOVE.W     D6,D0
01B0: SUB.W      D7,D0                ; delta
01B2: EXT.L      D0
01B4: MULS.W     D5,D0                ; * line height
01B8: TST.L      D0
01BA: BEQ.S      $01AA                ; No scroll needed

; Update scroll bar
01BA: MOVE.L     156(A3),-(A7)        ; Scroll bar
01BE: MOVE.W     D6,-(A7)             ; New value
01C0: A963                            ; SetCtlValue trap

; Scroll TextEdit
01C4: CLR.W      -(A7)
01C6: MOVE.W     D0,D0
01C8: MOVE.W     D0,-(A7)             ; Delta pixels
01CA: MOVE.L     (A4),-(A7)           ; TE handle
01CC: A812                            ; TEScroll trap
01CE: MOVEM.L    (SP)+,...
01D4: RTS
```

### Function 0x01D6 - Get Text Length
```asm
01D6: LINK       A6,#0
01DA: MOVE.L     A4,-(A7)
01DC: MOVEA.L    8(A6),A0             ; TE handle
01E0: MOVEA.L    (A0),A4              ; Dereference
01E2: MOVE.W     8(A4),D0             ; teLength
01E6: SUB.W      (A4),D0              ; - selStart?
01EA: UNLK       A6
01EC: RTS
```

### Function 0x01EE - Scroll and Update
```asm
01EE: LINK       A6,#0
01F2: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)
01F6: MOVEA.L    8(A6),A4             ; A4 = TE handle
01FA: MOVEA.L    12(A6),A3            ; A3 = window

; Clear selection
01FE: CLR.W      -(A7)                ; selStart
0200: MOVE.L     A4,-(A7)             ; TE handle
0202: A960                            ; SetCtlValue for scroll

0206: CLR.W      -(A7)                ; selEnd
0208: MOVE.L     A4,-(A7)
020A: A962                            ; TESetSelect trap

; Get scroll position
020E: MOVE.L     A3,-(A7)
0210: JSR        -60(PC)              ; Get scroll info
0214: MOVE.W     D0,D5

0216: MOVE.L     A3,(A7)
0218: JSR        1912(PC)             ; More scroll handling
021C: MOVEA.L    (A3),A2
021E: MOVE.W     94(A2),D4            ; Max scroll
0222: SUB.W      D0,D4
0224: MULS.W     24(A2),D4            ; * line height

; Clamp values
022A: TST.W      D5
022C: BGE.S      $0230
022E: MOVEQ      #0,D5                ; Min = 0
0230: TST.W      D4
0232: BGE.S      $0236
0234: MOVEQ      #0,D4                ; Min = 0

; Update scroll bar if changed
0236: CMP.W      D6,D4
0238: BEQ.S      $0240
023A: MOVE.L     A4,-(A7)
023C: MOVE.W     D4,-(A7)
023E: A965                            ; SetCtlMax trap

0240: CMP.W      D7,A5
0242: BEQ.S      $024A
0244: MOVE.L     A4,-(A7)
0246: MOVE.W     D5,-(A7)
0248: A963                            ; SetCtlValue trap
024C: MOVEM.L    (SP)+,...
0250: RTS
```

### Function 0x0332 - Create Text Window
```asm
0332: LINK       A6,#-26
0336: MOVE.L     A4,-(A7)
0338: MOVEA.L    8(A6),A4             ; A4 = window
033C: MOVE.L     A4,-(A7)
033E: A873                            ; GetPort trap

; Store window rect
0342: MOVE.L     16(A4),-20(A6)
0346: MOVE.L     20(A4),-24(A6)

; Get port rect
034C: PEA        -24(A6)
0350: A8A3                            ; GetWMgrPort trap
0352: PEA        -24(A6)
0356: A928                            ; InsetRect trap

; Create TextEdit record
035A: MOVE.L     -16(A6),-(A7)        ; dest rect
035E: MOVE.L     #$00040000,-(A7)     ; flags
0362: MOVEQ      #-15,D0
0364: ADD.W      -18(A6),D0
0368: MOVE.W     D0,-(A7)
036A: MOVE.W     -20(A6),-(A7)
036E: A8A7                            ; TENew trap

; Setup text
0376: MOVE.L     -8(A6),-8(A6)
037C: MOVE.W     #4,-6(A6)            ; Font size
0382: PEA        -8(A6)
0386: CLR.W      -(A7)
0388: MOVEA.L    160(A4),A0           ; TE handle
038C: MOVEA.L    (A0),A0
038E: MOVEA.L    160(A4),A1
0392: MOVEA.L    (A1),A1
0394: MOVE.W     (A1),D0
0396: SUB.W      8(A0),D0
039A: MOVE.W     D0,-(A7)
039C: A8A8                            ; TESetText trap
...
; Create scroll bar
0406: CLR.L      -(A7)
0408: MOVE.L     A4,-(A7)             ; Window
040A: PEA        -24(A6)              ; Rect
040E: MOVE.L     -3512(A5),-(A7)      ; Scroll proc
0412: PEA        $0100.W              ; Flags
0416: CLR.L      -(A7)
0418: MOVE.W     #16,-(A7)            ; Width
041C: PEA        -3268(A5)            ; Title
0420: A954                            ; NewControl trap
0424: MOVE.L     (A7)+,156(A4)        ; Store control
...
0432: RTS
```

## TextEdit Offsets

| Offset | Purpose |
|--------|---------|
| 0 | selStart |
| 2 | selEnd |
| 4 | teLength? |
| 8 | teLength |
| 24 | lineHeight |

## Window Data Structure

| Offset | Size | Purpose |
|--------|------|---------|
| 156 | 4 | Scroll bar control |
| 160 | 4 | TextEdit handle |
| 164 | 2 | Flags |
| 166 | 2 | Mode |

## Toolbox Traps

| Trap | Purpose |
|------|---------|
| A812 | TEScroll |
| A8A3 | GetWMgrPort |
| A8A7 | TENew |
| A8A8 | TESetText |
| A928 | InsetRect |
| A954 | NewControl |
| A960 | GetCtlValue |
| A962 | TESetSelect |
| A963 | SetCtlValue |
| A965 | SetCtlMax |
| A9DE | TESetText |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3268 | Scroll bar title |
| A5-3512 | Scroll proc pointer |

## Confidence: HIGH

Standard Mac TextEdit patterns:
- TENew/TESetText for text fields
- Scroll bar management
- File loading with SFGetFile
