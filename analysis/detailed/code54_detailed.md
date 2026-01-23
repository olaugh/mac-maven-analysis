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

String equality comparison - the smallest CODE resource at 42 bytes.

## Architecture Role

CODE 54 provides a simple utility:
1. Compare two C-style null-terminated strings
2. Return boolean equality result
3. Used throughout the application for string matching

## Key Function

### Function 0x0000 - String Equality Compare
```asm
; Entry
0000: LINK       A6,#0
0004: MOVEM.L    A3/A4,-(SP)          ; Save A3, A4

; Get parameters from stack
0008: MOVEA.L    8(A6),A4             ; A4 = string1 pointer
000C: MOVEA.W    12(A6),A3            ; A3 = string2 pointer (word value - unusual)

; Main comparison loop
0010: ...                             ; (disassembly shows complex addressing)

; Test current character
0014: TST.B      (A4)+                ; Test char at A4, then increment
0016: BEQ.S      $001C                ; If null terminator, go check str2

; Characters didn't match (or still comparing)
0018: MOVEQ      #0,D0                ; Return 0 (not equal)
001A: BRA.S      $0022                ; Exit

; End of string1 reached - check if string2 also ended
001C: ...                             ; Complex check of string2
0020: MOVEQ      #1,D0                ; Return 1 (strings equal)

; Cleanup and return
0022: MOVEM.L    (SP)+,A3/A4          ; Restore registers
0026: UNLK       A6
0028: RTS
```

## Detailed Analysis

The actual comparison logic (reconstructed from disassembly patterns):

```asm
; Loop start - compare characters
loop:
    MOVE.B     (A4)+,D0         ; Get char from string1, advance
    MOVE.B     (A3)+,D1         ; Get char from string2, advance

    CMP.B      D1,D0            ; Compare characters
    BNE.S      not_equal        ; Different - fail

    TST.B      D0               ; Check if null terminator
    BNE.S      loop             ; Not null - continue loop

    ; Both strings ended at same point
    MOVEQ      #1,D0            ; Return TRUE (equal)
    BRA.S      exit

not_equal:
    MOVEQ      #0,D0            ; Return FALSE (not equal)

exit:
    MOVEM.L    (SP)+,A3/A4
    UNLK       A6
    RTS
```

## Parameters

| Offset | Type | Description |
|--------|------|-------------|
| 8(A6) | char* | First string pointer (null-terminated) |
| 12(A6) | char* | Second string pointer (null-terminated) |

Note: The disassembly shows `MOVEA.W 12(A6),A3` which loads a word, not a long. This is unusual for a pointer and may indicate:
- A near pointer in the first 64KB
- Disassembly artifact
- Actually a length or offset parameter

## Return Values

| Value | Meaning |
|-------|---------|
| 0 | Strings are different |
| 1 | Strings are equal |

## C Equivalent

```c
int string_equal(const char* str1, const char* str2) {
    // Compare character by character
    while (*str1) {
        if (*str1 != *str2) {
            return 0;  // Not equal - mismatch found
        }
        str1++;
        str2++;
    }

    // str1 ended - check if str2 also ended
    if (*str2 == '\0') {
        return 1;  // Equal - both ended at same point
    }

    return 0;  // Not equal - str2 is longer
}
```

## Usage Pattern

This function is likely used for:
1. **Word Dictionary Lookup**: Check if a word exists in word list
2. **Command Parsing**: Match user input commands
3. **Resource Name Matching**: Find resources by name
4. **Configuration Comparison**: Check settings strings

## Why a Separate CODE Segment?

At only 42 bytes, this is the smallest CODE segment in Maven. Possible reasons:
1. **Frequent calls**: Loaded once, used many times
2. **Segment optimization**: Keep frequently-used utilities in small segments for fast loading
3. **Compiler artifact**: May have been compiled separately

## Performance Characteristics

- **Fast**: Single-pass comparison, O(n) where n = string length
- **Early Exit**: Returns immediately on first mismatch
- **No Length Check**: Relies entirely on null terminators
- **Minimal Register Use**: Only A3, A4 saved/restored

## Comparison with CODE 52 strcmp

CODE 52 contains a full `strcmp` implementation that returns -1/0/+1 for ordering.
This function (CODE 54) only returns 0/1 for equality, which is simpler and slightly faster.

| Feature | CODE 54 | CODE 52 strcmp |
|---------|---------|----------------|
| Return | 0 or 1 | -1, 0, or +1 |
| Purpose | Equality only | Ordering |
| Size | 42 bytes | ~40 bytes |
| Speed | Slightly faster | Standard |

## Register Usage

| Register | Purpose |
|----------|---------|
| A3 | String 2 pointer |
| A4 | String 1 pointer |
| D0 | Current char / return value |

## Confidence: MEDIUM

The disassembly shows some unusual addressing modes that may be partially incorrect due to instruction boundary issues. However, the overall function purpose (string comparison returning boolean) is clear from:
- Two pointer parameters
- Loop with character testing
- Binary return value (0 or 1)
- Small size suggests simple equality check

## Note

The 42-byte size makes this one of the smallest CODE resources, containing just this single utility function. The compact size suggests it was designed for:
1. Minimal code segment loading overhead
2. Frequent invocation from multiple callers
3. Fast memory footprint when loaded
