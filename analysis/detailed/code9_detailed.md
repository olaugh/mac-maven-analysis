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

**Category**: Runtime Support
**Function**: Standard Library / System Wrappers

Provides wrapper functions for Mac Toolbox calls and common utilities.

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

---

## Speculative C Translation

```c
/* CODE 9 - Speculative C Translation */
/* Runtime Support Library */

/*============================================================
 * Global Variables
 *============================================================*/
extern void *g_temp_ptr;             /* A5-23670: temporary pointer storage */
extern Cursor g_custom_cursor;       /* A5-3396: custom cursor data */

/* Low-memory globals (Mac OS) */
#define TICKS  (*(long*)0x016A)      /* System tick count */

/*============================================================
 * Function 0x0000 - Wrapper for JT[2866]
 * JT offset: 1440(A5)
 *
 * Reformats parameters and calls another function.
 *============================================================*/
void wrapper_2866(
    short param1,                    /* 8(A6) */
    void *param2_ptr,                /* 10(A6) - passed by reference */
    long param3                      /* 14(A6) */
) {
    /* Reformat parameters and call */
    some_function_2866(
        param3,                      /* Reordered: param3 first */
        param2_ptr,                  /* param2 by reference */
        param1,                      /* param1 */
        0                            /* Added: 0 flag */
    );                               /* JT[2866] at 0x0012 */
}

/*============================================================
 * Function 0x001A - Read Low-Memory Global
 * JT offset: 1448(A5)
 *
 * Reads a value from low memory or PC-relative data.
 *============================================================*/
long read_low_memory(void *address /* 8(A6) */) {
    long result;                     /* -4(A6) */

    /* Read from specified low-memory address */
    /* uncertain: exact mechanism (PC-relative or absolute) */
    result = *(long*)address;

    return result;
}

/*============================================================
 * Function 0x002E - Get Screen Width
 * JT offset: 1456(A5)
 *
 * Returns screen width constant (320 for original Mac).
 *============================================================*/
short get_screen_width(void) {
    return get_dimension(320);       /* JT[482] with 0x140 */
}

/*============================================================
 * Function 0x003A - Swap Global Pointer
 * JT offset: 1464(A5)
 *
 * Atomically swaps a global pointer, saving old value.
 * Useful for save/restore context patterns.
 *============================================================*/
void swap_global_ptr(
    void **save_location,            /* 8(A6) - where to save old value */
    void *new_value                  /* 12(A6) - new value to set */
) {
    /* Save current value */
    *save_location = g_temp_ptr;     /* MOVE.L -23670(A5),(A0) */

    /* Set new value */
    g_temp_ptr = new_value;          /* MOVE.L 12(A6),-23670(A5) */
}

/*============================================================
 * Function 0x0050 - Set Global Pointer
 * JT offset: 1472(A5)
 *============================================================*/
void set_global_ptr(void *value /* 8(A6) */) {
    g_temp_ptr = value;              /* Direct store to A5-23670 */
}

/*============================================================
 * Function 0x005E - Set Custom Cursor
 * JT offset: 1480(A5)
 *
 * Sets cursor to a predefined custom cursor.
 *============================================================*/
void set_custom_cursor(void) {
    SetCursor(&g_custom_cursor);     /* A851 trap at 0x0062 */
}

/*============================================================
 * Function 0x0066 - Initialize Cursor (Reset to Arrow)
 * JT offset: 1488(A5)
 *============================================================*/
void init_cursor(void) {
    InitCursor();                    /* A850 trap */
}

/*============================================================
 * Function 0x006A - Open Graphics Port
 * JT offset: 1496(A5)
 *============================================================*/
short open_port(void) {
    return OpenPort(0);              /* A861 trap, return result */
}

/*============================================================
 * Function 0x0072 - Get Current Tick Count
 * JT offset: 1504(A5)
 *
 * Reads the system tick count (1/60th second intervals).
 *============================================================*/
void get_ticks(long *dest /* 8(A6) */) {
    *dest = TICKS;                   /* Read from low-memory $016A */
}

/*============================================================
 * Function 0x0082 - Calculate Elapsed Time
 * JT offset: 1512(A5)
 *
 * Calculates elapsed time since a start point, rounded to
 * half-second intervals. Used for timing game moves.
 *
 * Returns: (current_ticks - start_ticks + 30) / 60
 *============================================================*/
long get_elapsed_time(long start_ticks /* 8(A6) */) {
    long current = TICKS;            /* MOVE.L $016A,D0 at 0x008A */
    long elapsed = current - start_ticks;  /* SUB.L at 0x008E */

    /*
     * Add 30 for rounding (half of 60), then divide by 60.
     * This gives elapsed time in approximately 1-second units.
     */
    return (elapsed + 30) / 60;      /* JT[90] division at 0x0098 */
}

/*============================================================
 * Function 0x00A0 - Allocate New Handle
 * JT offset: 1520(A5)
 *
 * Wrapper for Memory Manager NewHandle trap.
 *============================================================*/
Handle new_handle_wrapper(long size /* 8(A6) */) {
    Handle h;

    /* Call NewHandle trap */
    h = NewHandle(size);             /* A11E or A122 trap at 0x00A8 */

    return h;                        /* Return in D0 */
}

/*============================================================
 * Function 0x00B0 - Dispose Pointer
 * JT offset: 1528(A5)
 *
 * Wrapper for Memory Manager DisposePtr trap.
 *============================================================*/
void dispose_ptr_wrapper(Ptr p /* 8(A6) */) {
    DisposePtr(p);                   /* A01F trap at 0x00B8 */
}

/*============================================================
 * Runtime Library Summary
 *
 * CODE 9 provides these common services:
 *
 * Memory Management:
 * - new_handle_wrapper()    - Allocate relocatable block
 * - dispose_ptr_wrapper()   - Free non-relocatable block
 * - (others)                - BlockMove, etc.
 *
 * Timing:
 * - get_ticks()             - Read system tick count
 * - get_elapsed_time()      - Calculate elapsed seconds
 *
 * Cursor Management:
 * - set_custom_cursor()     - Display custom cursor
 * - init_cursor()           - Reset to arrow cursor
 *
 * Global State:
 * - swap_global_ptr()       - Save/restore pattern
 * - set_global_ptr()        - Direct setter
 *
 * Screen Info:
 * - get_screen_width()      - Returns 320 for classic Mac
 *
 * These functions are called throughout Maven via the
 * jump table, providing a consistent API for common
 * operations.
 *============================================================*/

/*============================================================
 * Mac Low Memory Addresses Reference
 *
 * $016A - Ticks:      System tick count (1/60 sec)
 * $0102 - ScrVRes:    Screen vertical resolution
 * $0104 - ScrHRes:    Screen horizontal resolution
 * $0106 - ScreenRow:  Bytes per screen row
 * $0824 - ExpandMem:  Expanded memory pointer
 *
 * Classic Mac used low memory for system globals because
 * there was no MMU for memory protection.
 *============================================================*/
```
