# CODE 22 Detailed Analysis - Debug Output & Board Dump

## Overview

| Property | Value |
|----------|-------|
| Size | 2,056 bytes |
| JT Offset | 1376 |
| JT Entries | 6 |
| Functions | 11 |
| Purpose | **Debug/diagnostic output, board state dumping, file export** |


## System Role

**Category**: Game Logic
**Function**: Player Management

Player state and turn management
## Architecture Role

CODE 22 provides debugging and diagnostic functions:
1. Board state text dump (for debugging)
2. File export functionality
3. Game state serialization
4. Word checking utilities

## Key Functions

### Function 0x0000 - Dump Board State to Text
```asm
0000: LINK       A6,#-152             ; 152 bytes local (enough for text buffer)
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVE.W     8(A6),D5             ; D5 = output handle/file
000C: MOVEQ      #1,D4                ; D4 = row counter
000E: LEA        -27229(A5),A4        ; A4 = some array
0012: LEA        -26685(A5),A0        ; Row data start
0016: MOVE.L     A0,D6
0018: LEA        -17137(A5),A3        ; Another array
001C: LEA        -16576(A5),A0        ; Another array
0020: MOVE.L     A0,D7

; Main loop - process 16 rows
0022: BRA.W      $0102
0026: LEA        -128(A6),A2          ; A2 = text buffer
002A: MOVEQ      #1,D3                ; D3 = column counter
002C: MOVE.L     D7,-136(A6)          ; Store pointers in frame
0030: MOVE.L     A3,-132(A6)
0034: MOVE.L     D6,-144(A6)
0038: MOVE.L     A4,-148(A6)

; Inner loop - process 16 columns
003C: MOVEA.W    D3,A0
003E: ADDA.L     A0,$2D48.W
...
; Check cell type and format output
004C: MOVEA.L    -136(A6),A0
0050: TST.B      0(A0,D3.W)           ; Check if empty
0052: BEQ.S      $005E                ; If empty, use different format
0054: MOVEA.L    -132(A6),A0
0058: MOVE.B     0(A0,D3.W),(A2)+     ; Copy character
005C: BRA.S      $00CA

; Empty cell - check for special markers
005E: MOVEA.W    D3,A0
0060: ADDA.L     A3,$2D48.W
0064: TST.B      ...
0074: JSR        3562(A5)             ; JT[3562] - tolower
0078: MOVE.B     D0,(A2)+             ; Store lowercase
...

; Check for double/triple letter markers
007E: MOVEA.L    -144(A6),A0
0082: CMPI.B     #2,0(A0,D3.W)        ; Double letter?
0088: BNE.S      $0090
008A: MOVE.B     #'$',(A2)+           ; '$' = double letter
008E: BRA.S      $00CA

0090: MOVEA.L    -144(A6),A0
0094: CMPI.B     #3,0(A0,D3.W)        ; Triple letter?
009A: BNE.S      $00A2
009C: MOVE.B     #'*',(A2)+           ; '*' = triple letter
00A0: BRA.S      $00CA

00A2: MOVEA.L    -148(A6),A0          ; Check word multiplier
00A6: CMPI.B     #2,0(A0,D3.W)        ; Double word?
00AC: BNE.S      $00B4
00AE: MOVE.B     #'+',(A2)+           ; '+' = double word
00B2: BRA.S      $00CA

00B4: MOVEA.L    -148(A6),A0
00B8: CMPI.B     #3,0(A0,D3.W)        ; Triple word?
00BE: BNE.S      $00C6
00C0: MOVE.B     #'#',(A2)+           ; '#' = triple word
00C4: BRA.S      $00CA

00C6: MOVE.B     #'-',(A2)+           ; '-' = empty square

; Add space between columns
00CA: MOVE.B     #' ',(A2)+
00CE: ADDQ.W     #1,D3                ; D3++ (column)
...
00D8: BCS.W      $004A                ; Loop columns

; Add newline and output row
00DC: MOVE.B     #$0D,(A2)+           ; CR
00E0: CLR.B      (A2)                 ; Null terminate
00E2: MOVE.W     D5,-(A7)             ; Push file handle
00E4: PEA        -128(A6)             ; Push string
00E8: JSR        3370(A5)             ; JT[3370] - write string
...
0100: CMPI.W     #16,D4               ; Loop 16 rows
0104: BCS.W      $0028

; Output field_14 and field_22 contents
0108: MOVE.W     D5,-(A7)
010A: PEA        -15514(A5)           ; g_field_14
010E: JSR        3370(A5)             ; Write

0114: PEA        -3768(A5)            ; Some other data
0118: JSR        3370(A5)

011E: PEA        -15522(A5)           ; g_field_22
0122: JSR        3370(A5)

; Output size values
0126: MOVEQ      #100,D0
012A: MOVE.L     -15506(A5),-(A7)     ; g_size1
012E: JSR        90(A5)               ; JT[90] - divide
...
; Format and output sizes
014A: JSR        2066(A5)             ; JT[2066] - sprintf
014E: MOVE.W     D5,(A7)
0150: PEA        -128(A6)
0154: JSR        3370(A5)             ; Write formatted string
...
0160: RTS
```

**Output format**:
```
A B C - - + D E F ...
G H - $ * # - I J ...
...
g_field_14: [data]
g_field_22: [data]
g_size1: 56630  g_size2: 65536
```

### Function 0x0162 - Save Game to File
```asm
0162: LINK       A6,#-30
0166: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)
016A: MOVE.W     8(A6),D6             ; D6 = vRefNum
016E: MOVE.L     10(A6),D7            ; D7 = filename ptr

; Create file with type 'TEXT'
0172: MOVE.L     #'TEXT',-(A7)        ; File type
0178: MOVE.W     #$0001,-(A7)         ; Flags
017C: PEA        -2(A6)               ; Ref num result
0180: MOVE.W     D6,-(A7)             ; vRefNum
0182: MOVE.L     D7,-(A7)             ; Filename
0184: JSR        3378(A5)             ; JT[3378] - FSCreate
0188: TST.W      D0
018E: BEQ.S      $0194
0190: JSR        418(A5)              ; Error if failed

; Open file
0194: CLR.W      -(A7)                ; Permission
0196: MOVE.L     D7,-(A7)             ; Filename
0198: MOVE.W     D6,-(A7)             ; vRefNum
019A: PEA        -26(A6)              ; IOParamBlock
019E: JSR        2874(A5)             ; JT[2874] - FSOpen

; Set file info
01A2: MOVE.L     #'XGME',-26(A6)      ; Creator 'XGME' (Maven?)
...

; Write window data
01C6: CLR.W      -(A7)
01CC: MOVEA.L    -8510(A5),A0         ; Window ptr
01D0: MOVE.L     202(A0),-(A7)        ; Get data handle
01D4: JSR        2826(A5)             ; JT[2826] - GetHandleSize
01D8: MOVE.L     (A7)+,-30(A6)        ; Store size

01DC: PEA        $0006.W              ; Push 6
01E0: MOVE.L     -30(A6),-(A7)        ; Push size
01E4: JSR        74(A5)               ; JT[74] - divide for record count
...

; Write records in loop
01F0: MOVEA.L    -8510(A5),A0
01F4: MOVEA.L    202(A0),A0           ; Get data
01F8: MOVEA.L    A4,A2
01FA: ADDA.L     (A0),A2              ; Offset
...
0218: MOVEM.L    (SP)+,...
021A: JSR        2866(A5)             ; Write record
...
0274: JSR        2866(A5)             ; Write more
028A: ADDQ.W     #1,D5                ; Increment record counter
028C: BRA.W      $01CC                ; Loop

; Close file
0292: CLR.W      -(A7)
0294: MOVE.W     -2(A6),-(A7)         ; File ref
0298: JSR        2850(A5)             ; JT[2850] - FSClose
...
02B4: JSR        1242(A5)             ; JT[1242] - FlushVol
02BC: MOVEQ      #1,D0                ; Return success
02C6: RTS
```

### Function 0x02C8 - Load Game from File
```asm
02C8: LINK       A6,#-30
02CC: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
02D0: MOVE.L     10(A6),D7            ; D7 = filename ptr

; Null-terminate filename
02D4: MOVEA.L    D7,A0
02D6: MOVE.B     (A0),D0              ; Get length byte
02D8: EXT.W      D0
02DA: MOVE.L     D7,D1
02DC: ADDQ.L     #1,D1                ; Skip length byte
02DE: MOVEA.W    D0,A0
02E0: CLR.B      0(A0,D1.L)           ; Null terminate

; Open file for reading
02E4: CLR.W      -(A7)                ; Read permission
02E6: MOVE.L     D7,-(A7)             ; Filename
02E8: MOVE.W     8(A6),-(A7)          ; vRefNum
02EC: PEA        -2(A6)               ; IOParamBlock
02F0: JSR        2842(A5)             ; JT[2842] - FSOpen
02F4: TST.W      (A7)+
02F6: BEQ.S      $02FC
02F8: JSR        418(A5)              ; Error

; Get file size
02FC: CLR.L      -(A7)
02FE: MOVEA.L    -8510(A5),A0
0302: MOVE.L     202(A0),-(A7)
0306: JSR        2826(A5)             ; GetHandleSize
...

; Read records
0322: MOVEQ      #2,D0
0326: MOVE.L     D0,-10(A6)           ; Bytes to read
032A: CLR.W      -(A7)
032C: MOVE.W     -2(A6),-(A7)         ; File ref
0330: PEA        -10(A6)              ; Byte count
0334: PEA        -4(A6)               ; Buffer
0338: JSR        2858(A5)             ; JT[2858] - FSRead
...

; Process records
0362: MOVEA.L    -8510(A5),A0
0366: MOVEQ      #1,D0
0368: ADD.W      D5,D0                ; Record number
036C: MULU.W     #6,D0                ; * 6 bytes per record
...

; Restore game state
042C: MOVE.W     #-1,D0
042E: ADD.W      D5,D0
0430: MOVE.W     D0,-(A7)
0432: JSR        354(A5)              ; JT[354] - set_random_seed
...

; Update lookup table
046A: PEA        $0121.W              ; 289 bytes
046E: PEA        -10388(A5)           ; g_lookup_tbl
0472: PEA        -10099(A5)           ; Source
0476: JSR        3466(A5)             ; JT[3466] - memcpy
047A: MOVEQ      #1,D0                ; Return success
0484: RTS
```

### Function 0x0486 - Quick Board Check
```asm
0486: LINK       A6,#0
048A: LEA        -15514(A5),A0        ; g_field_14
048E: CMP.L      8(A6),A0             ; Compare with param
0494: BNE.S      $04A2
0494: JSR        658(A5)              ; JT[658] - init_subsystem
0498: MOVE.L     8(A6),-(A7)
049C: JSR        2402(A5)             ; JT[2402] - process_buffer
04A2: RTS
```

### Function 0x058C - Check Word Against Board
```asm
058C: LINK       A6,#-288             ; Large frame
0590: MOVEM.L    D7/A3/A4,-(SP)
0594: MOVEA.L    8(A6),A4             ; A4 = board position
0598: BRA.W      $065E

; Process each position
059C: MOVE.B     (A4),D7              ; Get current tile
059E: TST.B      D7
05A0: BEQ.S      $060E                ; If empty, skip

05A2: TST.B      1(A4)                ; Check next position
05A6: BEQ.S      $060E

05A8: TST.B      -1(A4)               ; Check previous
05AC: BNE.S      $060E                ; If not start of word

; Found start of horizontal word
05AE: LEA        -32(A6),A3           ; Buffer for word
05B2: BRA.S      $05C4

; Copy word characters
05B4: MOVE.B     (A4),D0
05B6: EXT.W      D0
05B8: MOVE.W     D0,-(A7)
05BA: JSR        3554(A5)             ; toupper
05BE: MOVE.B     D0,(A3)+             ; Store
05C0: LEA        12(A7),A7
05C2: ADDQ.L     #1,A4                ; Next position
05C4: TST.B      (A4)
05C6: BNE.S      $05B4                ; While not empty

05C8: CLR.B      (A3)                 ; Null terminate
05CA: PEA        -32(A6)              ; Push word
05CE: JSR        794(A5)              ; JT[794] - check_in_dictionary
05D2: TST.L      D0
05D6: BNE.W      $065C                ; If found, continue

; Word not in dictionary
05DA: PEA        -32(A6)
05DE: JSR        278(PC)              ; Display error
...
```

## Board Symbol Legend

From the dump function, the board uses these symbols:
- Uppercase letter: Placed tile
- Lowercase letter: Tentative tile
- `-`: Empty square
- `$`: Double letter score
- `*`: Triple letter score
- `+`: Double word score
- `#`: Triple word score

## File Format

The save file uses creator 'XGME' and type 'TEXT':
- 6-byte records for each game element
- Includes window state, board data, rack

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3768 | Additional data buffer |
| A5-8510 | Window pointer |
| A5-10099 | Source board array |
| A5-10388 | g_lookup_tbl |
| A5-15502 | g_size2 |
| A5-15506 | g_size1 |
| A5-15514 | g_field_14 |
| A5-15522 | g_field_22 |
| A5-16576 | Board array 3 |
| A5-17137 | Board array 2 |
| A5-26685 | Board array 1 |
| A5-27229 | Multiplier array |

## Confidence: HIGH

The patterns are clear:
- Text formatting for board display
- File I/O with FSOpen/FSClose
- Record-based save format
- Board symbol encoding
