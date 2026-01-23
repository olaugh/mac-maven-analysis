# CODE 34 Detailed Analysis - String and System Utilities

## Overview

| Property | Value |
|----------|-------|
| Size | 1,388 bytes |
| JT Offset | 2784 |
| JT Entries | 31 |
| Functions | ~10 |
| Purpose | **String manipulation and system utilities** |

## Key Insight

CODE 34 contains low-level string manipulation functions (Pascal-style strings) and system environment detection. These are called by many other CODE segments.

## Function Analysis

### Function 0x0000 - Reverse String In-Place
```asm
0000: MOVEA.L    4(A7),A0        ; A0 = string ptr (Pascal string)
0004: LEA        1(A0),A1        ; A1 = &string[1] (skip length byte)
0008: MOVEQ      #0,D0           ; D0 = 0
000A: MOVE.B     (A0),D1         ; D1 = length byte
000C: MOVE.B     D0,(A0)+        ; clear current byte, advance
000E: MOVE.B     D1,D0           ; D0 = previous char
0010: BNE.S      $000A           ; loop until null
0012: SUB.L      A1,A0           ; A0 = end - start = length
0016: MOVE.B     D0,-(A1)        ; store null at end
0018: MOVE.L     A1,D0           ; return pointer
001A: RTS
```

**C equivalent**:
```c
// Converts Pascal string to C string in-place, returns end pointer
char* pascal_to_c_string(unsigned char* str) {
    char* p = str;
    char* start = str + 1;
    char prev = 0, curr;
    do {
        curr = *p;
        *p++ = prev;
        prev = curr;
    } while (curr);
    return p;  // points past end
}
```

### Function 0x001C - C String to Pascal String
```asm
001C: MOVEA.L    4(A7),A0        ; A0 = string ptr
0020: MOVEQ      #0,D0           ; D0 = 0
0022: MOVE.B     (A0),D0         ; D0 = first char (will be length)
0024: BRA.S      $002A
0026: MOVE.B     1(A0),(A0)+     ; shift chars left
002A: DBF        D0,$0026        ; loop D0 times
002E: CLR.B      (A0)            ; null terminate
0030: MOVE.L     4(A7),D0        ; return original ptr
0034: RTS
```

**C equivalent**:
```c
// Shift Pascal string content left by 1, placing length at end
char* shift_string_left(char* str) {
    int len = (unsigned char)str[0];
    for (int i = 0; i < len; i++) {
        str[i] = str[i+1];
    }
    str[len] = 0;
    return str;
}
```

### Function 0x0036 - Check System Environment
```asm
0036: TST.W      $028E.W         ; Test ROM version (low mem global)
003A: BMI.S      $005E           ; If negative (128K ROM), skip
003C: MOVE.W     #$0090,D0       ; Selector for Gestalt
0040: _Gestalt                   ; A346 - get system info
0044: MOVE.W     #$009F,D0       ; Another selector
0048: _Gestalt
004C: BEQ.S      $005E           ; if zero, skip
...
```

**Purpose**: Detect system capabilities using Gestalt. Tests for:
- ROM version ($028E)
- Various system features via Gestalt selectors

### Function 0x005E - Initialize Environment Block
```asm
005E: MOVEA.L    4(A7),A0        ; A0 = buffer
0062: MOVE.W     #$0001,D0       ; start with 1
0066: MOVEA.L    A0,A1           ; A1 = buffer copy
0068: BRA.S      $0070
...
0070: MOVE.W     #$0010,D0       ; 16 iterations
0074: MOVEA.L    D0,A1
0076: ...
007A: DBF        D0,$0078        ; loop 16 times
007E: MOVE.W     #$0002,(A1)     ; set field to 2
0082: MOVEA.L    $02AE.W,A0      ; Get UnitTable (low mem)
0086: MOVE.W     #$FFFE,2(A1)    ; set field to -2
008C: CMPI.B     #$FF,9(A0)      ; check unit table entry
...
```

**Purpose**: Initialize an environment/configuration block based on system state. Checks various low-memory globals:
- $028E - ROM version
- $02AE - UnitTable
- $0B22 - Some system flag
- $012F - Some configuration byte

### Environment Detection Logic (0x0092-0x00D6)
```asm
0094: TST.B      8(A0)           ; check byte 8
0098: BGT.S      $00BA           ; if > 0, go to $00BA
009A: MOVE.W     #$FFFF,2(A1)    ; set to -1
00A0: TST.W      $028E.W         ; check ROM version
00A4: BMI.S      $00D6           ; if 128K ROM, done
00A6: MOVE.W     #$0001,2(A1)    ; set to 1
00AC: TST.W      $0B22.W         ; check another flag
00B0: BPL.S      $00D6           ; if positive, done
00B2: MOVE.W     #$0002,2(A1)    ; set to 2
```

**C equivalent**:
```c
typedef struct {
    short field_0;
    short field_2;
    short field_4;
    // ... more fields
} EnvBlock;

void init_environment(EnvBlock* env) {
    short* unitTable = *(short**)0x02AE;

    env->field_0 = 2;
    env->field_2 = -2;

    if (unitTable[4] == 0xFF) return;  // byte 9

    if (unitTable[4] > 0) {
        env->field_2 = 0;
        // More checks...
    } else {
        env->field_2 = -1;
        if (*(short*)0x028E >= 0) {  // Not 128K ROM
            env->field_2 = 1;
            if (*(short*)0x0B22 < 0) {
                env->field_2 = 2;
            }
        }
    }
}
```

## Low-Memory Globals Referenced

| Address | Name | Purpose |
|---------|------|---------|
| $028E | ROMBase | ROM version indicator |
| $02AE | UnitTable | Device unit table |
| $0B22 | Unknown | System flag |
| $012F | Unknown | Configuration byte |
| $021E | Unknown | System variable |
| $0291 | Unknown | System flag |

## Purpose Summary

CODE 34 provides:
1. **String conversion**: Pascal ↔ C string conversion
2. **System detection**: ROM version, capabilities via Gestalt
3. **Environment setup**: Initialize configuration blocks based on system

This is why it's called by 12 different CODE segments - it provides essential system utilities.

## Confidence: HIGH

The string manipulation patterns are clear and match known Classic Mac conventions. The system detection code follows standard Gestalt patterns.
