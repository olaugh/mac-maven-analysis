# CODE 23 Detailed Analysis - String Utilities

## Overview

| Property | Value |
|----------|-------|
| Size | 608 bytes |
| JT Offset | 1968 |
| JT Entries | 7 |
| Functions | 12 |
| Purpose | **String manipulation, character filtering, case conversion** |


## System Role

**Category**: Utility Functions
**Function**: String processing and character classification

## Architecture Role

CODE 23 provides string utility functions:
1. Character search in strings (strchr-like)
2. Character filtering/validation
3. Case conversion wrappers
4. Pascal string formatting
5. String copying with filtering

## Key Functions

### Function 0x0000 - Check Character in Set
```asm
0000: LINK       A6,#0
0004: MOVE.W     8(A6),-(A7)          ; Push character
0008: PEA        -3018(A5)            ; Push charset at A5-3018
000C: JSR        3514(A5)             ; JT[3514] - strchr
0010: TST.L      D0                   ; Test result
0012: SNE        D0                   ; Set if not equal (found)
0014: NEG.B      D0                   ; Convert to boolean
0016: EXT.W      D0                   ; Extend to word
0018: UNLK       A6
001A: RTS
```

**C equivalent**:
```c
int char_in_set(char c) {
    char* charset = g_charset;  // A5-3018
    return strchr(charset, c) != NULL;
}
```

### Function 0x001C - Find First Matching Character
```asm
001C: LINK       A6,#0
0020: MOVE.L     A4,-(A7)
0022: MOVEA.L    12(A6),A4            ; A4 = string to search
0026: BRA.S      $0044                ; Jump to loop test

; Loop body
0028: MOVE.B     (A4),D0              ; Get current char
002A: EXT.W      D0                   ; Extend to word
002C: MOVE.W     D0,-(A7)             ; Push char
002E: MOVE.L     8(A6),-(A7)          ; Push charset
0032: JSR        3514(A5)             ; JT[3514] - strchr
0036: TST.L      D0                   ; Found?
0038: ADDQ.L     #6,A7                ; Clean stack
003A: BEQ.S      $0042                ; Not found, continue
003C: MOVE.B     (A4),D0              ; Get matching char
003E: EXT.W      D0
0040: BRA.S      $004A                ; Return char

0042: ADDQ.L     #1,A4                ; Next char

; Loop test
0044: TST.B      (A4)                 ; End of string?
0046: BNE.S      $0028                ; Continue if not
0048: MOVEQ      #0,D0                ; Return 0 (not found)

004A: MOVEA.L    (A7)+,A4
004C: UNLK       A6
004E: RTS
```

**C equivalent**:
```c
int find_first_in_set(char* charset, char* str) {
    while (*str) {
        if (strchr(charset, *str)) {
            return *str;  // Return the matching character
        }
        str++;
    }
    return 0;  // Not found
}
```

### Function 0x0050 - Filter String by Charset
```asm
0050: LINK       A6,#-4               ; frame=4
0054: BRA.S      $0072                ; Jump to loop test

; Loop body
0056: MOVEA.L    8(A6),A0             ; A0 = dest
005A: MOVE.B     (A0),D0              ; Get dest char
005C: EXT.W      D0
005E: MOVE.W     D0,-(A7)             ; Push char
0060: MOVE.L     16(A6),-(A7)         ; Push charset
0064: JSR        3514(A5)             ; JT[3514] - strchr
0068: TST.L      D0                   ; In charset?
006A: ADDQ.L     #6,A7                ; Clean stack
006C: BEQ.S      $0072                ; Skip if not in charset
006E: ADDQ.L     #1,8(A6)             ; Advance dest ptr

; Loop: copy from source to dest
0072: MOVEA.L    12(A6),A0            ; A0 = source
0076: ADDQ.L     #1,12(A6)            ; Advance source
007A: MOVEA.L    8(A6),A1             ; A1 = dest
007E: MOVE.B     (A0),(A1)            ; Copy char
0080: BNE.S      $0056                ; Continue if not null
0082: UNLK       A6
0084: RTS
```

**Purpose**: Copies source string to dest, keeping only characters that are in the charset.

### Function 0x0086 - Filter with Mask
```asm
0086: LINK       A6,#0
008A: MOVE.L     A4,-(A7)
008C: MOVEA.L    8(A6),A4             ; A4 = string
0090: BRA.S      $00A4                ; Jump to copy loop

; Character check
0092: MOVEQ      #0,D0
0094: MOVE.B     (A4),D0              ; Get char
0096: MOVEA.L    A5,A0                ; Get base
0098: ADDA.L     D0,A0                ; Index into table
009C: AND.B      -1064(A0),D0         ; AND with mask table
00A0: BNE.S      $00A4                ; If non-zero, keep
00A2: ADDQ.L     #1,A4                ; Else skip this char

; Copy loop
00A4: MOVEA.L    12(A6),A0            ; A0 = source
00A8: ADDQ.L     #1,12(A6)            ; Advance source
00AC: MOVE.B     (A0),(A4)            ; Copy to filtered dest
00AE: BNE.S      $0092                ; Continue if not null
00B0: CLR.B      (A4)                 ; Null terminate
00B2: MOVEA.L    (A7)+,A4
00B4: UNLK       A6
00B6: RTS
```

**Purpose**: Filters string using a mask lookup table at A5-1064.

### Function 0x00B8 - Format Pascal String
```asm
00B8: LINK       A6,#-4               ; frame=4
00BC: MOVE.L     12(A6),-(A7)         ; Push format arg
00C0: PEA        -3012(A5)            ; Push format string at A5-3012
00C4: MOVEA.L    8(A6),A0             ; A0 = output buffer
00C8: PEA        1(A0)                ; Push output+1 (skip length byte)
00CC: JSR        2066(A5)             ; JT[2066] - sprintf
00D0: MOVEA.L    8(A6),A0             ; Get output ptr
00D4: MOVE.B     D0,(A0)              ; Store length in first byte
00D6: MOVE.L     A0,D0                ; Return buffer
00D8: UNLK       A6
00DA: RTS
```

**C equivalent**:
```c
char* format_pascal_string(char* output, long arg) {
    char* format = g_format_string;  // A5-3012
    int len = sprintf(output + 1, format, arg);
    output[0] = len;  // Pascal string length byte
    return output;
}
```

### Function 0x00DC - Copy with Length Limit
```asm
00DC: LINK       A6,#0
00E0: MOVEM.L    D6/D7,-(SP)          ; save
00E4: MOVE.W     16(A6),D7            ; D7 = max length
00E8: SUBQ.W     #1,D7                ; D7 = max - 1
00EC: MOVE.L     A0,-(A7)
00EE: MOVE.L     12(A6),-(A7)         ; Push source
00F2: MOVEA.L    8(A6),A0             ; A0 = dest
00F6: PEA        1(A0)                ; Push dest+1
00FA: JSR        3530(A5)             ; JT[3530] - strncpy
00FE: MOVE.L     12(A6),(A7)          ; Push source again
0102: JSR        3522(A5)             ; JT[3522] - strlen
0106: MOVE.W     D0,D6                ; D6 = strlen
0108: CMP.W      D6,A7                ; Compare with D7
010A: LEA        12(A7),A7
010E: BGE.S      $0114                ; If D6 >= D7
0110: MOVE.W     D7,D0                ; Use max length
0112: BRA.S      $0116
0114: MOVE.W     D6,D0                ; Use strlen
0116: MOVEA.L    8(A6),A0
011A: MOVE.B     D0,(A0)              ; Store length
011C: MOVEM.L    (SP)+,D6/D7          ; restore
0120: UNLK       A6
0122: RTS
```

**C equivalent**:
```c
void copy_pascal_string(char* dest, char* src, int max_len) {
    strncpy(dest + 1, src, max_len - 1);
    int len = strlen(src);
    dest[0] = (len < max_len) ? len : max_len - 1;
}
```

### Function 0x01BA - Convert String to Uppercase
```asm
01BA: LINK       A6,#-8               ; frame=8
01BE: MOVE.L     A4,-(A7)
01C0: MOVEA.L    8(A6),A4             ; A4 = output
01C4: BRA.S      $01E4                ; Jump to loop test

; Loop body
01C6: MOVEA.L    12(A6),A0            ; A0 = source
01CA: MOVE.B     (A0),D0              ; Get char
01CC: EXT.W      D0
01CE: MOVE.W     D0,-(A7)             ; Push char
01D0: JSR        3554(A5)             ; JT[3554] - toupper
01D4: MOVEA.L    8(A6),A0             ; A0 = output
01D8: ADDQ.L     #1,8(A6)             ; Advance output
01DC: MOVE.B     D0,(A0)              ; Store uppercase char
01DE: ADDQ.L     #1,12(A6)            ; Advance source
01E2: ADDQ.L     #2,A7                ; Clean stack

; Loop test
01E4: MOVEA.L    12(A6),A0            ; A0 = source
01E8: TST.B      (A0)                 ; End of string?
01EA: BNE.S      $01C6                ; Continue if not
01EC: MOVEA.L    8(A6),A0
01F0: CLR.B      (A0)                 ; Null terminate
01F2: MOVE.L     A4,D0                ; Return output
01F4: MOVEA.L    (A7)+,A4
01F6: UNLK       A6
01F8: RTS
```

**C equivalent**:
```c
char* string_to_upper(char* dest, char* src) {
    char* result = dest;
    while (*src) {
        *dest++ = toupper(*src++);
    }
    *dest = '\0';
    return result;
}
```

### Function 0x01FA - Convert String to Lowercase
```asm
01FA: LINK       A6,#-8               ; frame=8
01FE: MOVE.L     A4,-(A7)
0200: MOVEA.L    8(A6),A4             ; A4 = output
0204: BRA.S      $0224                ; Jump to loop test

; Loop body (same structure as toupper)
0206: MOVEA.L    12(A6),A0
020A: MOVE.B     (A0),D0
020C: EXT.W      D0
020E: MOVE.W     D0,-(A7)
0210: JSR        3562(A5)             ; JT[3562] - tolower
0214: MOVEA.L    8(A6),A0
0218: ADDQ.L     #1,8(A6)
021C: MOVE.B     D0,(A0)
021E: ADDQ.L     #1,12(A6)
0222: ADDQ.L     #2,A7

; Loop test
0224: MOVEA.L    12(A6),A0
0228: TST.B      (A0)
022A: BNE.S      $0206
022C: MOVEA.L    8(A6),A0
0230: CLR.B      (A0)                 ; Null terminate
0232: MOVE.L     A4,D0                ; Return output
0234: MOVEA.L    (A7)+,A4
0236: UNLK       A6
0238: RTS
```

### Function 0x023A - Skip Non-Alpha Characters
```asm
023A: LINK       A6,#-4               ; frame=4
023E: BRA.S      $0244                ; Jump to loop test

; Loop body
0240: ADDQ.L     #1,8(A6)             ; Advance pointer

; Loop test
0244: MOVEA.L    8(A6),A0             ; Get current ptr
0248: MOVEQ      #0,D0
024A: MOVE.B     (A0),D0              ; Get char
024C: MOVEA.L    A5,A1
024E: ADDA.L     D0,A1                ; Index into table
0252: AND.B      -1064(A1),D0         ; Check mask
0254: ???                              ; (disassembly incomplete)
0256: BNE.S      $0240                ; Continue if not alpha
0258: MOVE.L     8(A6),D0             ; Return pointer
025C: UNLK       A6
025E: RTS
```

## String Data Structures

### Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1064 | Character classification mask table |
| A5-3012 | Format string for Pascal string |
| A5-3018 | Character set for validation |

### Jump Table Functions

| JT Offset | Purpose |
|-----------|---------|
| 2066 | sprintf |
| 3514 | strchr (find char in string) |
| 3522 | strlen |
| 3530 | strncpy |
| 3554 | toupper |
| 3562 | tolower |

## Pascal String Format

Classic Mac uses Pascal strings (length-prefixed):
```
+0: length byte (0-255)
+1: characters (no null terminator needed)
```

Functions in this segment handle conversion between C strings (null-terminated) and Pascal strings.

## Character Classification Table

The table at A5-1064 appears to be a character classification bitmap:
- Each byte index corresponds to ASCII value
- Bits indicate character properties (alpha, digit, etc.)
- AND with mask tests character class

## Usage Context

These string utilities support:
- Rack string manipulation (filtering valid letters)
- User input processing (case normalization)
- Display formatting (Pascal strings for Mac TextEdit)
- Word validation preprocessing

## Confidence: HIGH

Standard string utility patterns clearly identified:
- strchr/strlen/strncpy library wrappers
- toupper/tolower character conversion loops
- Pascal string formatting for Mac Toolbox
- Character set filtering with two methods (strchr and mask table)
- All functions follow standard 68000 calling conventions
