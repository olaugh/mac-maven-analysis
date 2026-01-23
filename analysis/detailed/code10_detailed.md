# CODE 10 Detailed Analysis - Cursor & Dialog Support

## Overview

| Property | Value |
|----------|-------|
| Size | 138 bytes |
| JT Offset | 352 |
| JT Entries | 3 |
| Functions | 4 |
| Purpose | **Cursor management, dialog/alert support** |


## System Role

**Category**: User Interface
**Function**: Dialog Utilities

Dialog box support functions
## Architecture Role

CODE 10 provides UI support utilities:
1. Cursor display management
2. Dialog/alert callbacks
3. Event processing hooks

## Key Functions

### Function 0x0000 - Show Dialog/Alert
```asm
; From disassembly:
0000: 4E56FF00      LINK       A6,#-256             ; 256 bytes local (Str255 buffer)
0004: 42A7          CLR.L      -(A7)                ; Push NULL (filterProc)
0006: 3F3C0080      MOVE.W     #128,-(A7)           ; Push resource ID 128
000A: A949          GetIndString                     ; _GetIndString trap
...
0012: 486EFF00      PEA        -256(A6)             ; Push string buffer
0014: A946          ParamText                        ; _ParamText trap
...
001C: A9B6          Alert                            ; _Alert trap
001E: 4E5E          UNLK       A6
0020: 4E75          RTS
```

**C equivalent**:
```c
void show_alert(short stringID) {
    Str255 str;
    GetIndString(str, 128, stringID);
    ParamText(str, NULL, NULL, NULL);
    Alert(stringID, NULL);
}
```

### Function 0x0022 - Set Cursor from State
```asm
; From disassembly:
0022: 4E560000      LINK       A6,#0
0026: 7000          MOVEQ      #0,D0                ; Clear D0
0028: 102DD720      MOVE.B     -10464(A5),D0        ; D0 = g_cursor_state (A5-10464)
002C: 3F00          MOVE.W     D0,-(A7)             ; Push cursor ID
002E: 4EAD0112      JSR        274(A5)              ; JT[274] - SetCursor
0032: 4E5E          UNLK       A6
0034: 4E75          RTS
```

**C equivalent**:
```c
void set_cursor_from_state(void) {
    short cursor_id = g_cursor_state;  // A5-10464
    set_cursor(cursor_id);
}
```

### Function 0x0036 - Clear Cursor (Reset to Arrow)
```asm
; From disassembly:
0036: 4E560000      LINK       A6,#0
003A: 4267          CLR.W      -(A7)                ; Push 0 (arrow cursor ID)
003C: 4EAD0112      JSR        274(A5)              ; JT[274] - SetCursor
0040: 4E5E          UNLK       A6
0042: 4E75          RTS
```

**C equivalent**:
```c
void clear_cursor(void) {
    set_cursor(0);  // Arrow cursor
}
```

### Function 0x0044 - Process Event with Callback
```asm
; From disassembly:
0044: 4E560000      LINK       A6,#0
0048: 48E70018      MOVEM.L    A3/A4,-(SP)          ; Save registers
004C: 286E0008      MOVEA.L    8(A6),A4             ; A4 = object pointer (param)
0050: 2F0C          MOVE.L     A4,-(A7)             ; Push object
0052: 4EAD064A      JSR        1610(A5)             ; JT[1610] - check_event
0056: 4A40          TST.W      D0                   ; Test result
0058: 588F          ADDQ.L     #4,A7                ; Clean stack
005A: 670E          BEQ.S      $006A                ; If 0, try callback

; Event found - process it
005C: 2F0C          MOVE.L     A4,-(A7)             ; Push object
005E: 4EAD064A      JSR        1610(A5)             ; JT[1610] - process_event
0062: 3E80          MOVE.W     D0,(A7)              ; Store result
0064: A9B7          SystemTask                       ; _SystemTask trap (yield time)
...

; Look up and call callback function
006A: 48780007      PEA        $0007.W              ; Push callback type 7
006E: 2F0C          MOVE.L     A4,-(A7)             ; Push object
0070: 4EAD01FA      JSR        506(A5)              ; JT[506] - lookup_callback
0074: 2640          MOVEA.L    D0,A3                ; A3 = callback function
0076: 200B          MOVE.L     A3,D0                ; Test if NULL
0078: 508F          ADDQ.L     #8,A7                ; Clean stack
007A: 6706          BEQ.S      $0082                ; If NULL, skip

; Call the callback
007C: 2F0C          MOVE.L     A4,-(A7)             ; Push object
007E: 4E93          JSR        (A3)                 ; Call callback(object)
0080: 588F          ADDQ.L     #4,A7                ; Clean stack

0082: 4CDF1800      MOVEM.L    (SP)+,A3/A4          ; Restore registers
0086: 4E5E          UNLK       A6
0088: 4E75          RTS
```

**C equivalent**:
```c
void process_event(void* object) {
    if (check_something(object)) {
        int result = process_something(object);
        system_task(result);  // A9B7 trap
    }

    // Look up callback for type 7
    void (*callback)(void*) = lookup_callback(object, 7);
    if (callback != NULL) {
        callback(object);
    }
}
```

## Global Variables

| Offset | Name | Purpose |
|--------|------|---------|
| A5-10464 | g_cursor_state | Current cursor ID |

## Toolbox Traps Used

| Trap | Purpose |
|------|---------|
| A946 | ParamText |
| A949 | GetIndString |
| A9B6 | Alert |
| A9B7 | SystemTask/callback |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 274 | SetCursor |
| 506 | Lookup callback |
| 1610 | Check/process event |

## Cursor IDs

| ID | Cursor |
|----|--------|
| 0 | Arrow (default) |
| 1+ | Custom cursors |

## Confidence: HIGH

Standard Mac UI patterns:
- Alert/dialog display
- Cursor management
- Callback-based event processing
