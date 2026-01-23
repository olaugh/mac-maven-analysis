# CODE 54 Detailed Analysis - String Comparison Utility

## Overview

| Property | Value |
|----------|-------|
| Size | 42 bytes |
| JT Offset | 3416 |
| JT Entries | 1 |
| Functions | 1 |
| Purpose | **Compare two null-terminated strings for equality** |


## System Role

**Category**: Utility
**Function**: String Compare

String equality comparison (smallest CODE at 46 bytes)
## Architecture Role

CODE 54 is the smallest CODE resource, providing a simple utility:
1. Compare two C-style strings
2. Return equality result
3. Used throughout the application for string matching

## Key Functions

### Function 0x0000 - String Compare
```asm
0000: LINK       A6,#0
0004: MOVEM.L    A3/A4,-(SP)          ; Save registers
0008: MOVEA.L    8(A6),A4             ; A4 = string1
000C: MOVEA.W    12(A6),A3            ; A3 = string2 (word offset)

; Main comparison loop
0010: MOVE.B     A4,8(PC,D6.W)        ; Complex addressing
0014: TST.B      (A4)+                ; Get char from string1, advance
0016: BEQ.S      $001C                ; Null terminator - end

; Check if chars match
0018: MOVEQ      #0,D0                ; Assume not equal
001A: BRA.S      $0022                ; Return 0

; Check if both strings ended
001C: MOVE.W     A4,-12(PC,D6.W)      ; Check string2
0020: MOVEQ      #1,D0                ; Strings equal - return 1

0022: MOVEM.L    (SP)+,A3/A4          ; Restore registers
0026: UNLK       A6
0028: RTS
```

**Simplified C equivalent**:
```c
int string_equal(char* str1, char* str2) {
    while (*str1) {
        if (*str1 != *str2) {
            return 0;  // Not equal
        }
        str1++;
        str2++;
    }

    // Check if str2 also ended
    if (*str2 == '\0') {
        return 1;  // Equal
    }

    return 0;  // str2 is longer
}
```

## Detailed Assembly Analysis

The code is compact but slightly unusual in its addressing:

```asm
; Entry
0000: LINK       A6,#0                ; Standard frame setup
0004: MOVEM.L    A3/A4,-(SP)          ; Save A3, A4

; Get parameters
0008: MOVEA.L    8(A6),A4             ; First string pointer
000C: MOVEA.W    12(A6),A3            ; Second string (word value)

; Comparison loop
0010: D7CC                            ; Add A4 to D7 (complex)
0012: 6008                            ; BRA.S +8 to check

; Test current character
0014: TST.B      (A4)+                ; Test and increment
0016: BEQ.S      $001C                ; Branch if zero (end)

; Not equal case
0018: MOVEQ      #0,D0                ; Return 0
001A: BRA.S      $0022                ; Exit

; End of string1 - check string2
001C: B7CC                            ; Compare A4 with something
001E: 62F4                            ; BNE back to loop

; Strings are equal
0020: MOVEQ      #1,D0                ; Return 1

; Cleanup and return
0022: MOVEM.L    (SP)+,A3/A4          ; Restore registers
0026: UNLK       A6
0028: RTS
```

## Usage Pattern

This function is likely used for:
1. **Word Dictionary Lookup**: Check if a word exists
2. **Command Parsing**: Match user input commands
3. **Resource Name Matching**: Find resources by name
4. **Configuration Comparison**: Check settings

## Return Values

| Value | Meaning |
|-------|---------|
| 0 | Strings are different |
| 1 | Strings are equal |

## Parameters

| Offset | Type | Description |
|--------|------|-------------|
| 8(A6) | char* | First string (null-terminated) |
| 12(A6) | char* | Second string (null-terminated) |

## Performance Characteristics

- **Fast**: Single-pass comparison
- **Early Exit**: Returns immediately on mismatch
- **No Length Check**: Relies on null terminators

## Confidence: MEDIUM

The disassembly shows some unusual addressing modes that may be partially incorrect due to instruction boundary issues. However, the overall function purpose (string comparison) is clear from:
- Two pointer parameters
- Loop with character testing
- Binary return value

## Note

The 42-byte size makes this one of the smallest CODE resources, containing just this single utility function. The compact size suggests it may be called frequently and was optimized for minimal code segment loading overhead.
