# CODE 24 Detailed Analysis - Printf/Sprintf Implementation

## Overview

| Property | Value |
|----------|-------|
| Size | 6,786 bytes |
| JT Offset | 2024 |
| JT Entries | 3 |
| Functions | 10+ |
| Purpose | **Full printf/sprintf implementation with format parsing** |

## Architecture Role

CODE 24 provides C-style formatted output:
1. Parse format strings with % specifiers
2. Handle integer, string, float formatting
3. Support width, precision, and flags
4. Output to buffer (sprintf) or stream

## Main sprintf Function (0x0000)

### Function Prologue
```asm
0000: LINK       A6,#-574             ; Large stack frame (574 bytes)
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVEA.L    12(A6),A4            ; A4 = format string
000C: MOVEQ      #0,D4                ; D4 = output count
000E: MOVE.B     (A4),D7              ; D7 = current char
0010: EXT.W      D7
0012: BRA.W      $09C8                ; Jump to main loop
```

### Format Flag Parsing
```asm
; Check for '%' character
0016: CMPI.W     #$0025,D7            ; '%' = 0x25
001A: BNE.W      $08BE                ; Not a format spec

; Initialize format state
001E: MOVE.L     -3006(A5),-538(A6)   ; Copy default flags
0024: MOVE.L     -3002(A5),-534(A6)   ; Copy default state
002A: ADDQ.L     #1,A4                ; Skip '%'
002C: MOVE.B     (A4),D7              ; Get next char
002E: EXT.W      D7

; Parse '-' flag (left justify)
0030: CMPI.W     #$002D,D7            ; '-'
0034: BNE.S      $003E
0036: BSET       #7,-538(A6)          ; Set left-justify flag
003C: BRA.S      $002A                ; Get next char

; Parse '+' flag (always show sign)
003E: CMPI.W     #$002B,D7            ; '+'
0042: BNE.S      $004C
0044: BSET       #6,-538(A6)          ; Set show-sign flag
004A: BRA.S      $002A

; Parse ' ' flag (space before positive)
004C: CMPI.W     #$0020,D7            ; ' '
0050: BNE.S      $005A
0052: MOVE.B     #$20,-536(A6)        ; Set space prefix
0058: BRA.S      $002A

; Parse '#' flag (alternate form)
005A: CMPI.W     #$0023,D7            ; '#'
005E: BNE.S      $0068
0060: BSET       #5,-538(A6)          ; Set alternate flag
0066: BRA.S      $002A

; Parse '0' flag (zero padding)
0068: CMPI.W     #$0030,D7            ; '0'
006C: BNE.S      $0076
006E: BSET       #4,-538(A6)          ; Set zero-pad flag
0074: BRA.S      $002A
```

### Width and Precision Parsing
```asm
; Parse '*' for dynamic width
0076: CMPI.W     #$002A,D7            ; '*'
007A: BNE.S      $00BC
007C: MOVEA.L    16(A6),A0            ; Get varargs pointer
0080: ADDQ.L     #4,16(A6)            ; Advance varargs
0084: MOVE.W     (A0),D0              ; Get width value
0086: MOVE.W     D0,-534(A6)          ; Store width
008A: TST.W      D0
008C: BGE.S      $009E                ; If positive
008E: BSET       #7,-538(A6)          ; Negative = left-justify
0094: MOVE.W     -534(A6),D0
0098: NEG.W      D0                   ; Make positive
009A: MOVE.W     D0,-534(A6)
009E: ADDQ.L     #1,A4                ; Next char
00A0: MOVE.B     (A4),D7
00A2: EXT.W      D7
00A4: BRA.S      $00C8

; Parse numeric width
00A6: MOVEQ      #10,D0
00A8: MULS.W     -534(A6),D0          ; width * 10
00AC: ADDI.W     #-48,D0              ; + (char - '0')
00B0: ADD.W      D7,D0
00B2: MOVE.W     D0,-534(A6)          ; Store new width
00B6: ADDQ.L     #1,A4
00B8: MOVE.B     (A4),D7
00BA: EXT.W      D7

; Check for more digits
00BC: CMPI.W     #$0030,D7            ; '0'
00C0: BLT.S      $00C8
00C2: CMPI.W     #$0039,D7            ; '9'
00C6: BLE.S      $00A6                ; Loop for digits

; Parse '.' precision
00C8: CMPI.W     #$002E,D7            ; '.'
00CC: BNE.S      $011C
00CE: ADDQ.L     #1,A4
00D0: MOVE.B     (A4),D7
00D2: EXT.W      D7

; Parse '*' for dynamic precision
00D4: CMPI.W     #$002A,D7            ; '*'
00D8: BNE.S      $0104
00DA: MOVEA.L    16(A6),A0
00DE: ADDQ.L     #4,16(A6)
00E2: MOVE.W     (A0),-532(A6)        ; Store precision
; ... continue parsing ...
```

### Format Specifier Jump Table
```asm
; Specifier dispatch
012C: MOVE.W     D7,D0
012E: SUBI.W     #$0045,D0            ; Subtract 'E'
0132: CMPI.W     #$0033,D0            ; Range check
0136: BHI.W      $08B6                ; Invalid specifier
013A: LEA        2204(PC),A1          ; Jump table
013E: ADDA.W     D0,A0
0140: ADDA.W     0(A1,D0.W),A1        ; Get offset
0144: JMP        (A1)                 ; Dispatch
```

### String Specifier (%s, %S)
```asm
0146: MOVEA.L    16(A6),A0            ; Get varargs
014A: ADDQ.L     #8,16(A6)            ; Advance (long ptr)
014E: MOVEA.L    (A0),A3              ; A3 = string pointer

0150: TST.B      32(A3)               ; Check string type
0154: BEQ.S      $016C                ; Normal C string

; Pascal string handling
0156: MOVE.L     A3,-(A7)
0158: JSR        3522(A5)             ; strlen
015C: SUBQ.L     #1,A2
0160: MOVE.L     A3,(A7)
0162: MOVE.L     A2,-(A7)
0164: JSR        3490(A5)             ; strcpy
0168: ADDQ.L     #8,A7
016A: BRA.S      $01B2

; Handle alternate form (#)
016C: BTST       #5,-538(A6)          ; Alternate flag?
0172: BEQ.S      $018E
; ... alternate string handling ...
```

### Integer Specifier (%d, %i, %u)
```asm
032A: BTST       #1,-538(A6)          ; Check 'l' modifier
0330: BEQ.S      $033E
0332: MOVEA.L    16(A6),A0            ; Get long value
0336: ADDQ.L     #8,16(A6)
033A: MOVE.L     (A0),D3              ; D3 = value
033C: BRA.S      $034A

033E: MOVEA.L    16(A6),A0            ; Get int value
0342: ADDQ.L     #4,16(A6)
0346: MOVE.W     (A0),D3              ; D3 = value
0348: EXT.L      D3                   ; Sign extend

; Check for signed conversion
034A: BTST       #2,-538(A6)          ; Unsigned?
0350: BNE.S      $0354
0352: EXT.L      D3                   ; Keep unsigned

; Handle negative numbers
0354: TST.L      D3
0356: BGE.S      $0362
0358: NEG.L      D3                   ; Make positive
035A: MOVE.B     #$2D,-536(A6)        ; Store '-'
0360: BRA.S      $03A4

; Handle '+' flag for positive
0362: BTST       #6,-538(A6)
0368: BEQ.S      $03A4
036A: MOVE.B     #$2B,-536(A6)        ; Store '+'
0370: BRA.S      $03A4
```

### Integer to String Conversion
```asm
; Convert to decimal digits
03D4: MOVEQ      #0,D6                ; Digit count
03D6: BRA.S      $03F6

; Division loop
03D6: PEA        10                   ; Divide by 10
03DA: MOVE.L     D3,-(A7)
03DC: JSR        82(A5)               ; JT[82] - modulo
03E0: ADDI.B     #$30,D0              ; Add '0'
03E4: ; Store digit...
03E8: PEA        10
03EC: MOVE.L     D3,-(A7)
03EE: JSR        74(A5)               ; JT[74] - divide
03F2: MOVE.L     D0,D3                ; Update value
03F4: ADDQ.W     #1,D6                ; Increment count

03F6: TST.L      D3                   ; More digits?
03F8: BNE.S      $03D6                ; Continue loop
```

### Octal Specifier (%o)
```asm
0470: MOVEQ      #0,D6                ; Digit count
0472: BRA.S      $0484

; Octal conversion loop
0474: MOVEQ      #7,D0
0476: AND.L      D3,D0                ; D0 = D3 & 7
0478: ADDI.B     #$30,D0              ; Add '0'
047C: ; Store digit...
0480: LSR.L      #3,D3                ; D3 >>= 3
0482: ADDQ.W     #1,D6

0484: TST.L      D3
0486: BNE.S      $0474
```

### Hexadecimal Specifier (%x, %X)
```asm
04B6: BSET       #1,-538(A6)          ; Set long flag
04BC: BSET       #3,-538(A6)          ; Set precision flag
04C2: MOVE.W     #8,-532(A6)          ; Precision = 8
04C8: LEA        -2962(A5),A0         ; Lowercase hex digits
04CC: MOVE.L     A0,-526(A6)
04D0: BRA.S      $04DA

04D2: LEA        -2944(A5),A0         ; Uppercase hex digits
04D6: MOVE.L     A0,-526(A6)

; Hex conversion
04DA: ; ... get value ...
053C: MOVEQ      #15,D0
053E: AND.L      D3,D0                ; D0 = D3 & 15
0540: ADDA.L     -526(A6),D0          ; Index into hex table
0544: MOVEA.L    D0,A0
0546: ; Store hex digit from table
054A: LSR.L      #4,D3                ; D3 >>= 4
054C: ADDQ.W     #1,D6
```

### Floating Point Specifiers (%e, %E, %f, %g, %G)
```asm
057C: BTST       #3,-538(A6)          ; Check precision flag
0582: BNE.S      $058A
0584: MOVE.W     #6,-532(A6)          ; Default precision = 6

058A: MOVE.L     16(A6),-(A7)         ; Push varargs
058E: PEA        -570(A6)             ; Push output buffer
0592: MOVE.W     -532(A6),-(A7)       ; Push precision
0596: MOVE.W     #1,-(A7)             ; Push format type
059A: JSR        1188(PC)             ; Call float formatter
```

### Character Specifier (%c)
```asm
08BE: ; Handle literal character
08C0: ; ... output single character ...
```

## Stack Frame Layout

| Offset | Size | Purpose |
|--------|------|---------|
| -538 | 2 | Format flags |
| -536 | 1 | Sign character |
| -535 | 1 | Exponent sign |
| -534 | 2 | Width |
| -532 | 2 | Precision |
| -530 | 2 | Decimal position |
| -528 | 2 | Output length |
| -526 | 4 | Hex digit table pointer |
| -522 | ~500 | Work buffer |

## Format Flags (at -538)

| Bit | Meaning |
|-----|---------|
| 7 | Left justify (-) |
| 6 | Always show sign (+) |
| 5 | Alternate form (#) |
| 4 | Zero padding (0) |
| 3 | Precision specified |
| 2 | Unsigned conversion |
| 1 | Long modifier (l) |
| 0 | Short modifier (h) |

## Supported Format Specifiers

| Specifier | Purpose |
|-----------|---------|
| %d, %i | Signed decimal |
| %u | Unsigned decimal |
| %o | Octal |
| %x | Lowercase hex |
| %X | Uppercase hex |
| %s | C string |
| %S | Pascal string |
| %c | Character |
| %e, %E | Scientific notation |
| %f | Fixed-point float |
| %g, %G | General float |
| %W | Wide string |
| %R | Resource string |
| %% | Literal '%' |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2944 | Uppercase hex digits "0123456789ABCDEF" |
| A5-2962 | Lowercase hex digits "0123456789abcdef" |
| A5-3002 | Default format state |
| A5-3006 | Default format flags |
| A5-24090 | Format string for special case |
| A5-24094 | Another format string |
| A5-24122 | Board position format |
| A5-24126 | Another position format |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 74 | Integer division |
| 82 | Integer modulo |
| 2026 | Wide string conversion |
| 2450 | Resource string lookup |
| 3490 | strcpy |
| 3522 | strlen |

## Confidence: HIGH

Standard printf implementation patterns:
- Format specifier parsing with flags
- Width and precision handling
- Integer to string conversion loops
- Hex digit lookup tables
- Floating point formatting helpers
