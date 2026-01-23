# CODE 24 Detailed Analysis - Printf/Sprintf Implementation

## Overview

| Property | Value |
|----------|-------|
| Size | 6,786 bytes |
| JT Offset | 2024 |
| JT Entries | 3 |
| Functions | 10+ |
| Purpose | **Full printf/sprintf implementation with format parsing** |


## System Role

**Category**: C Runtime Library
**Function**: Formatted Output

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

---

## Speculative C Translation

### Format State Structure

```c
/* Format flags bitmask (at stack offset -538) */
#define FMT_LEFT_JUSTIFY  0x80  /* Bit 7: '-' flag */
#define FMT_SHOW_SIGN     0x40  /* Bit 6: '+' flag */
#define FMT_ALTERNATE     0x20  /* Bit 5: '#' flag */
#define FMT_ZERO_PAD      0x10  /* Bit 4: '0' flag */
#define FMT_PRECISION     0x08  /* Bit 3: precision specified */
#define FMT_UNSIGNED      0x04  /* Bit 2: unsigned conversion */
#define FMT_LONG          0x02  /* Bit 1: 'l' modifier */
#define FMT_SHORT         0x01  /* Bit 0: 'h' modifier */

typedef struct {
    short flags;           /* -538: Format flags */
    char sign_char;        /* -536: Sign character ('-', '+', ' ', or 0) */
    char exp_sign;         /* -535: Exponent sign for floats */
    short width;           /* -534: Field width */
    short precision;       /* -532: Precision value */
    short decimal_pos;     /* -530: Decimal point position */
    short output_len;      /* -528: Current output length */
    char* hex_digits;      /* -526: Pointer to hex digit table */
    char work_buffer[500]; /* -522: Working buffer for conversion */
} FormatState;

/* Global hex digit tables */
char g_hex_upper[] = "0123456789ABCDEF";  /* A5-2944 */
char g_hex_lower[] = "0123456789abcdef";  /* A5-2962 */
```

### Main sprintf Function (0x0000)

```c
/*
 * maven_sprintf - Formatted string output
 *
 * @param output: Destination buffer
 * @param format: Format string with % specifiers
 * @param ...: Variable arguments
 * Returns: Number of characters written
 *
 * This is a full printf implementation supporting:
 *   %d, %i, %u, %o, %x, %X, %s, %S, %c, %e, %E, %f, %g, %G, %%, %W, %R
 */
int maven_sprintf(char* output, char* format, ...) {
    FormatState state;           /* Local format state (-574 to -36 on stack) */
    char* fmt_ptr = format;      /* A4: Current format position */
    int output_count = 0;        /* D4: Characters output */
    int current_char;            /* D7: Current format character */
    va_list args;                /* Points to 16(A6) */

    va_start(args, format);

    /* Main parsing loop */
    while ((current_char = *fmt_ptr++) != '\0') {

        /* Check for format specifier */
        if (current_char != '%') {
            /* Regular character - output directly */
            *output++ = current_char;
            output_count++;
            continue;
        }

        /* Initialize format state with defaults */
        state.flags = 0;
        state.sign_char = 0;
        state.width = 0;
        state.precision = -1;  /* -1 = not specified */

        /* Parse flags */
        while (1) {
            current_char = *fmt_ptr++;

            switch (current_char) {
                case '-':
                    state.flags |= FMT_LEFT_JUSTIFY;
                    continue;
                case '+':
                    state.flags |= FMT_SHOW_SIGN;
                    continue;
                case ' ':
                    state.sign_char = ' ';
                    continue;
                case '#':
                    state.flags |= FMT_ALTERNATE;
                    continue;
                case '0':
                    state.flags |= FMT_ZERO_PAD;
                    continue;
                default:
                    break;
            }
            break;
        }

        /* Parse width */
        if (current_char == '*') {
            /* Dynamic width from argument */
            state.width = va_arg(args, int);
            if (state.width < 0) {
                state.flags |= FMT_LEFT_JUSTIFY;
                state.width = -state.width;
            }
            current_char = *fmt_ptr++;
        } else {
            /* Parse numeric width */
            while (current_char >= '0' && current_char <= '9') {
                state.width = state.width * 10 + (current_char - '0');
                current_char = *fmt_ptr++;
            }
        }

        /* Parse precision */
        if (current_char == '.') {
            state.flags |= FMT_PRECISION;
            current_char = *fmt_ptr++;

            if (current_char == '*') {
                /* Dynamic precision from argument */
                state.precision = va_arg(args, int);
                current_char = *fmt_ptr++;
            } else {
                state.precision = 0;
                while (current_char >= '0' && current_char <= '9') {
                    state.precision = state.precision * 10 + (current_char - '0');
                    current_char = *fmt_ptr++;
                }
            }
        }

        /* Parse length modifier */
        if (current_char == 'l') {
            state.flags |= FMT_LONG;
            current_char = *fmt_ptr++;
        } else if (current_char == 'h') {
            state.flags |= FMT_SHORT;
            current_char = *fmt_ptr++;
        }

        /* Dispatch on format specifier */
        switch (current_char) {
            case 'd':
            case 'i':
                output_count += format_signed_int(&state, output, args);
                break;

            case 'u':
                state.flags |= FMT_UNSIGNED;
                output_count += format_unsigned_int(&state, output, args);
                break;

            case 'o':
                output_count += format_octal(&state, output, args);
                break;

            case 'x':
                state.hex_digits = g_hex_lower;
                output_count += format_hex(&state, output, args);
                break;

            case 'X':
                state.hex_digits = g_hex_upper;
                output_count += format_hex(&state, output, args);
                break;

            case 's':
                output_count += format_string(&state, output, args);
                break;

            case 'S':
                output_count += format_pascal_string(&state, output, args);
                break;

            case 'c':
                output_count += format_char(&state, output, args);
                break;

            case 'e':
            case 'E':
                output_count += format_scientific(&state, output, args, current_char);
                break;

            case 'f':
                output_count += format_fixed(&state, output, args);
                break;

            case 'g':
            case 'G':
                output_count += format_general(&state, output, args, current_char);
                break;

            case '%':
                *output++ = '%';
                output_count++;
                break;

            case 'W':
                /* uncertain: Wide string format */
                output_count += format_wide_string(&state, output, args);
                break;

            case 'R':
                /* uncertain: Resource string format */
                output_count += format_resource_string(&state, output, args);
                break;

            default:
                /* Invalid specifier - output as-is */
                *output++ = current_char;
                output_count++;
                break;
        }

        output = output + state.output_len;  /* uncertain: exact advancement */
    }

    *output = '\0';
    va_end(args);
    return output_count;
}
```

### Integer Formatting Helpers

```c
/*
 * format_signed_int - Format a signed decimal integer
 */
static int format_signed_int(FormatState* state, char* output, va_list args) {
    long value;
    int digit_count = 0;
    char digit_buffer[32];
    char* digit_ptr = digit_buffer + sizeof(digit_buffer) - 1;

    /* Get value based on size modifier */
    if (state->flags & FMT_LONG) {
        value = va_arg(args, long);
    } else {
        value = (short)va_arg(args, int);
    }

    /* Handle negative numbers */
    if (value < 0) {
        value = -value;
        state->sign_char = '-';
    } else if (state->flags & FMT_SHOW_SIGN) {
        state->sign_char = '+';
    }

    /* Convert to digits (reverse order) */
    do {
        int digit = modulo_long(value, 10);  /* JT[82] */
        *digit_ptr-- = '0' + digit;
        value = divide_long(value, 10);      /* JT[74] */
        digit_count++;
    } while (value != 0);

    /* Output sign if needed */
    /* ... padding and output logic ... */

    return digit_count + (state->sign_char ? 1 : 0);
}

/*
 * format_octal - Format as octal number
 */
static int format_octal(FormatState* state, char* output, va_list args) {
    unsigned long value;
    int digit_count = 0;
    char digit_buffer[32];
    char* digit_ptr = digit_buffer + sizeof(digit_buffer) - 1;

    if (state->flags & FMT_LONG) {
        value = va_arg(args, unsigned long);
    } else {
        value = (unsigned short)va_arg(args, unsigned int);
    }

    /* Convert to octal digits */
    do {
        *digit_ptr-- = '0' + (value & 7);  /* value & 0x7 */
        value >>= 3;                        /* LSR.L #3 */
        digit_count++;
    } while (value != 0);

    /* Add '0' prefix if alternate form */
    if ((state->flags & FMT_ALTERNATE) && digit_buffer[digit_count-1] != '0') {
        *digit_ptr-- = '0';
        digit_count++;
    }

    /* ... output logic ... */
    return digit_count;
}

/*
 * format_hex - Format as hexadecimal number
 */
static int format_hex(FormatState* state, char* output, va_list args) {
    unsigned long value;
    int digit_count = 0;
    char digit_buffer[32];
    char* digit_ptr = digit_buffer + sizeof(digit_buffer) - 1;
    char* hex_table = state->hex_digits;

    /* For pointer formatting, force 8 digits */
    if (state->flags & FMT_LONG) {
        state->precision = 8;  /* 8 hex digits for 32-bit */
    }

    if (state->flags & FMT_LONG) {
        value = va_arg(args, unsigned long);
    } else {
        value = (unsigned short)va_arg(args, unsigned int);
    }

    /* Convert to hex digits using lookup table */
    do {
        int nibble = value & 0xF;          /* AND.L #15 */
        *digit_ptr-- = hex_table[nibble];  /* Lookup in table */
        value >>= 4;                        /* LSR.L #4 */
        digit_count++;
    } while (value != 0);

    /* Add '0x' or '0X' prefix if alternate form */
    if (state->flags & FMT_ALTERNATE) {
        /* uncertain: exact prefix handling */
    }

    /* ... padding and output logic ... */
    return digit_count;
}
```

### String Formatting

```c
/*
 * format_string - Format a C string (%s)
 */
static int format_string(FormatState* state, char* output, va_list args) {
    char* str = va_arg(args, char*);
    int len;

    if (str == NULL) {
        str = "(null)";  /* uncertain: actual null handling */
    }

    len = strlen(str);  /* JT[3522] */

    /* Apply precision limit */
    if ((state->flags & FMT_PRECISION) && state->precision < len) {
        len = state->precision;
    }

    /* Handle width and justification */
    int padding = state->width - len;

    if (!(state->flags & FMT_LEFT_JUSTIFY)) {
        /* Right justify - add leading spaces */
        while (padding > 0) {
            *output++ = ' ';
            padding--;
        }
    }

    /* Copy string */
    memcpy(output, str, len);  /* uncertain: exact copy method */
    output += len;

    if (state->flags & FMT_LEFT_JUSTIFY) {
        /* Left justify - add trailing spaces */
        while (padding > 0) {
            *output++ = ' ';
            padding--;
        }
    }

    state->output_len = len + (state->width > len ? state->width - len : 0);
    return state->output_len;
}

/*
 * format_pascal_string - Format a Pascal string (%S)
 *
 * Pascal strings have a length byte prefix.
 */
static int format_pascal_string(FormatState* state, char* output, va_list args) {
    unsigned char* pstr = va_arg(args, unsigned char*);
    int len = pstr[0];  /* First byte is length */
    char* str = (char*)(pstr + 1);  /* String data follows */

    /* Handle alternate form - might do something special */
    if (state->flags & FMT_ALTERNATE) {
        /* uncertain: special pascal string handling */
    }

    /* Use C string length if no pascal length */
    if (len == 0) {
        len = strlen(str);  /* JT[3522] */
    }

    /* uncertain: may need conversion to C string first */
    /* Copy without length byte */
    strncpy(output, str, len);  /* JT[3490] */

    state->output_len = len;
    return len;
}
```

### Floating Point Formatting

```c
/*
 * format_scientific - Format in scientific notation (%e, %E)
 */
static int format_scientific(FormatState* state, char* output, va_list args, char specifier) {
    /* Default precision is 6 */
    if (!(state->flags & FMT_PRECISION)) {
        state->precision = 6;
    }

    /* Call internal float formatter */
    /* uncertain: exact float handling */
    int format_type = (specifier == 'E') ? 1 : 0;

    /* Push arguments for internal call at PC+1188 */
    return internal_format_float(
        format_type,
        state->precision,
        state->work_buffer,
        args
    );
}

/*
 * format_fixed - Format as fixed-point decimal (%f)
 */
static int format_fixed(FormatState* state, char* output, va_list args) {
    if (!(state->flags & FMT_PRECISION)) {
        state->precision = 6;
    }

    /* uncertain: exact implementation */
    return internal_format_float(2, state->precision, state->work_buffer, args);
}

/*
 * format_general - Smart format selection (%g, %G)
 *
 * Uses %e or %f depending on exponent value.
 */
static int format_general(FormatState* state, char* output, va_list args, char specifier) {
    if (!(state->flags & FMT_PRECISION)) {
        state->precision = 6;
    }

    /* uncertain: selection logic between %e and %f */
    return internal_format_float(3, state->precision, state->work_buffer, args);
}
```

### Usage Example

```c
/*
 * Example usage in Maven code:
 *
 * Display move information:
 *   sprintf(buffer, "Move: %s at %d,%d scores %ld", word, row, col, score);
 *
 * Debug board state:
 *   sprintf(buffer, "g_size1: %ld  g_size2: %ld", g_size1/100, g_size2/100);
 *
 * Format Pascal string for TextEdit:
 *   sprintf(output+1, "%s", word);
 *   output[0] = strlen(output+1);  // Set Pascal length byte
 */
```
