# CODE 9 Detailed Analysis - Runtime Support Library

## Overview

| Property | Value |
|----------|-------|
| Size | 3,940 bytes |
| JT Offset | 1440 |
| JT Entries | 37 |
| Functions | 48 |
| Purpose | **Runtime support / standard library functions** |


## System Role

**Category**: User Interface
**Function**: Event Handling

Mac event loop processing
## Key Insight

CODE 9 is the **runtime support library**. It contains 37 exported functions (via jump table) that provide common services used throughout the application. This is a classic C runtime pattern - small utility functions that don't warrant their own segment.

## Function Analysis

### Function 0x0000 - Wrapper for JT[2866]
```asm
0000: LINK       A6,#0
0004: CLR.W      -(A7)           ; push 0 (flag)
0006: MOVE.W     8(A6),-(A7)     ; push param1
000A: PEA        10(A6)          ; push &param2
000E: MOVE.L     14(A6),-(A7)    ; push param3
0012: JSR        2866(A5)        ; call JT[2866]
0016: UNLK       A6
0018: RTS
```
**Purpose**: Simple wrapper that reformats parameters and calls JT[2866].

### Function 0x001A - Get Low-Memory Global
```asm
001A: LINK       A6,#-4
001E: LEA        -4(A6),A1       ; local var
0022: MOVEA.L    8(A6),A0        ; param = address
0026: MOVE.L     -128(PC,D2),D0  ; read PC-relative data
002A: UNLK       A6
002C: RTS
```
**Purpose**: Read a low-memory global value. Classic Mac pattern.

### Function 0x002E - Call JT[482] with constant 0x140
```asm
002E: MOVE.W     #$0140,-(A7)    ; push 320
0032: JSR        482(A5)         ; call JT[482]
0036: ADDQ.L     #4,A7           ; clean stack (2 bytes shown wrong)
0038: RTS
```
**Purpose**: Returns screen width (320 pixels for classic Mac).

### Function 0x003A - Swap Global Pointer
```asm
003A: LINK       A6,#0
003E: MOVEA.L    8(A6),A0         ; A0 = destination ptr
0042: MOVE.L     -23670(A5),(A0)  ; *dest = g_ptr (save old)
0046: MOVE.L     12(A6),-23670(A5); g_ptr = new value
004C: UNLK       A6
004E: RTS
```
**Purpose**: Swap a global pointer, returning the old value. Used for save/restore patterns.

**C equivalent**:
```c
void* swap_global_ptr(void** old_storage, void* new_value) {
    *old_storage = g_some_ptr;  // save old
    g_some_ptr = new_value;     // set new
}
```

### Function 0x0050 - Set Global Pointer
```asm
0050: LINK       A6,#0
0054: MOVE.L     8(A6),-23670(A5) ; g_ptr = param
005A: UNLK       A6
005C: RTS
```
**Purpose**: Simple setter for the global at A5-23670.

### Function 0x005E - Set Cursor
```asm
005E: PEA        -3396(A5)       ; push cursor data address
0062: _SetCursor                 ; A851 trap
0064: RTS
```
**Purpose**: Set cursor to a predefined cursor stored at A5-3396.

### Function 0x0066 - Init Cursor
```asm
0066: _InitCursor               ; A850 trap
0068: RTS
```
**Purpose**: Reset to arrow cursor.

### Function 0x006A - Open Port
```asm
006A: CLR.W      -(A7)           ; push 0
006C: _OpenPort                  ; A861 trap
006E: MOVE.W     (A7)+,D0        ; get result
0070: RTS
```
**Purpose**: Open a graphics port, return result.

### Function 0x0072 - Get Ticks
```asm
0072: LINK       A6,#0
0076: MOVEA.L    8(A6),A0        ; destination ptr
007A: MOVE.L     $016A.W,(A0)    ; read TickCount low-mem
007E: UNLK       A6
0080: RTS
```
**Purpose**: Read system tick count from low-memory ($016A = Ticks).

### Function 0x0082 - Time-Based Calculation
```asm
0082: LINK       A6,#0
0086: PEA        $003C.W         ; push 60 (ticks per second)
008A: MOVE.L     $016A.W,D0      ; D0 = current ticks
008E: SUB.L      8(A6),D0        ; D0 -= start_time (param)
0092: MOVEA.L    D0,A0
0094: PEA        30(A0)          ; push D0 + 30 (for rounding)
0098: JSR        90(A5)          ; call division function
009C: UNLK       A6
009E: RTS
```
**Purpose**: Calculate elapsed time in half-seconds: `(ticks - start + 30) / 60`

### Function 0x00A0 - New Handle
```asm
00A0: LINK       A6,#0
00A4: MOVE.L     8(A6),D0        ; D0 = size
00A8: _NewHandle                 ; A11E (or A122)
00AA: MOVE.L     A0,D0           ; return handle in D0
00AC: UNLK       A6
00AE: RTS
```
**Purpose**: Allocate a new handle of given size.

### Function 0x00B0 - Dispose Pointer
```asm
00B0: LINK       A6,#0
00B4: MOVEA.L    8(A6),A0        ; A0 = pointer
00B8: _DisposePtr                ; A01F
00BA: UNLK       A6
00BC: RTS
```
**Purpose**: Dispose of a pointer.

## Pattern Recognition

CODE 9 contains standard runtime functions:
1. **Memory**: NewHandle, DisposePtr, BlockMove wrappers
2. **Time**: TickCount access, elapsed time calculation
3. **Cursor**: SetCursor, InitCursor
4. **Ports**: OpenPort wrapper
5. **Global accessors**: Get/set functions for A5-relative globals

## Global Variables Referenced

| Offset | Purpose |
|--------|---------|
| A5-23670 | Temporary/swap pointer |
| A5-3396 | Cursor data |
| $016A | Ticks (low memory) |

## Called Jump Table Functions

| JT Offset | Purpose |
|-----------|---------|
| 90(A5) | Division/calculation |
| 418(A5) | Assertion/bounds check |
| 482(A5) | Get screen dimension |
| 2866(A5) | Unknown |

## Confidence: HIGH

This is clearly a runtime support library. The patterns are consistent with THINK C's generated code for standard library wrappers.
