# CODE 10 Detailed Analysis - Cursor & Dialog Support

## Overview

| Property | Value |
|----------|-------|
| Size | 138 bytes |
| JT Offset | 352 |
| JT Entries | 3 |
| Functions | 4 |
| Purpose | **Cursor management, dialog/alert support** |

## Architecture Role

CODE 10 provides UI support utilities:
1. Cursor display management
2. Dialog/alert callbacks
3. Event processing hooks

## Key Functions

### Function 0x0000 - Show Dialog/Alert
```asm
0000: LINK       A6,#-256             ; 256 bytes local (Pascal string buffer)
0004: CLR.L      -(A7)                ; Push NULL
0006: MOVE.W     #128,-(A7)           ; Push resource ID
000A: A949                            ; GetIndString trap
000E: MOVE.W     12(A6),-(A7)         ; Push param
0012: PEA        -256(A6)             ; Push string buffer
0016: A946                            ; ParamText trap
001A: CLR.W      -(A7)                ; Push 0
001C: PEA        -256(A6)             ; Push string
0020: A9B6                            ; Alert trap
0024: UNLK       A6
0026: RTS
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
0022: LINK       A6,#0
0026: MOVEQ      #0,D0
0028: MOVE.B     -10464(A5),D0        ; Get cursor state (g_state3)
002C: MOVE.W     D0,-(A7)             ; Push as parameter
002E: JSR        274(A5)              ; JT[274] - SetCursor
0032: UNLK       A6
0034: RTS
```

**C equivalent**:
```c
void set_cursor_from_state(void) {
    short cursor_id = g_cursor_state;  // A5-10464
    set_cursor(cursor_id);
}
```

### Function 0x0036 - Clear Cursor
```asm
0036: LINK       A6,#0
003A: CLR.W      -(A7)                ; Push 0 (arrow cursor)
003C: JSR        274(A5)              ; JT[274] - SetCursor
0040: UNLK       A6
0042: RTS
```

**C equivalent**:
```c
void clear_cursor(void) {
    set_cursor(0);  // Arrow cursor
}
```

### Function 0x0044 - Process Event with Callback
```asm
0044: LINK       A6,#0
0048: MOVEM.L    A3/A4,-(SP)          ; Save registers
004C: MOVEA.L    8(A6),A4             ; A4 = event/object pointer
0050: MOVE.L     A4,-(A7)             ; Push pointer
0052: JSR        1610(A5)             ; JT[1610] - check_something
0056: TST.W      D0
0058: LEA        12(A7),A7
005A: BEQ.S      $006A                ; If 0, skip

; Has valid event - process again
005C: MOVE.L     A4,-(A7)
005E: JSR        1610(A5)             ; JT[1610] - process again
0062: MOVE.W     D0,(A7)
0064: A9B7                            ; SystemTask/callback trap
0068: BRA.S      $0082                ; Skip to callback lookup

; Look up callback function
006A: PEA        $0007.W              ; Push callback ID 7
006E: MOVE.L     A4,-(A7)             ; Push object
0070: JSR        506(A5)              ; JT[506] - lookup_callback
0074: MOVEA.L    D0,A3                ; A3 = callback function
0076: MOVE.L     A3,D0
0078: LEA        16(A7),A7
007A: BEQ.S      $0082                ; If no callback, skip

; Call the callback
007C: MOVE.L     A4,-(A7)             ; Push object
007E: JSR        (A3)                 ; Call callback
0080: LEA        4(A7),A7

0082: MOVEM.L    (SP)+,A3/A4
0086: UNLK       A6
0088: RTS
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
