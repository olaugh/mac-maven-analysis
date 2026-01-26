# CODE 10 Analysis - UI Utilities

## Overview

| Property | Value |
|----------|-------|
| Size | 142 bytes (138 code + 4 header) |
| JT Offset | 352 (0x0160) |
| JT Entries | 3 |
| Functions | 4 |
| Category | UI_SUPPORT |
| Purpose | Alert dialogs, cursor management, event callbacks |
| Confidence | **HIGH** |

## CODE Resource Header

```
Offset 0x0000: 0160  - JT Offset (352)
Offset 0x0002: 0003  - JT Entries (3)
```

---

## Complete Disassembly

### Function 0x0004: Show Alert Dialog (JT[352])
**Stack Frame**: -256 bytes (local string buffer)

```asm
; void show_alert_dialog(short string_index)
; Displays alert using string from STR# resource 128

0004: 4E56 FF00    LINK       A6,#-256        ; Create 256-byte stack frame
0008: 42A7         CLR.L      -(A7)           ; Push NULL (filterProc)
000A: 3F3C 0080    MOVE.W     #128,-(A7)      ; Push STR# resource ID 128
000E: A949         _GetIndString              ; GetIndString(str, 128, index)
0010: 3F2E 000C    MOVE.W     12(A6),-(A7)    ; Push string index parameter
0014: 486E FF00    PEA        -256(A6)        ; Push local string buffer
0018: A946         _ParamText                 ; ParamText(str, NULL, NULL, NULL)
001A: 4267         CLR.W      -(A7)           ; Push item hit result space
001C: 486E FF00    PEA        -256(A6)        ; Push dialog template
0020: A9B6         _Alert                     ; Display alert
0022: 4E5E         UNLK       A6              ; Restore frame
0024: 4E75         RTS                        ; Return
```

**C Translation** (Confidence: HIGH):
```c
void show_alert_dialog(short string_index) {
    Str255 alert_text;                              /* -256(A6) */

    GetIndString(alert_text, 128, string_index);    /* A949 trap */
    ParamText(alert_text, NULL, NULL, NULL);        /* A946 trap */
    Alert(string_index, NULL);                      /* A9B6 trap */
}
```

---

### Function 0x0026: Set Cursor from State (JT[360])
**Stack Frame**: 0 bytes

```asm
; void set_cursor_from_state(void)
; Sets cursor based on g_cursor_state global

0026: 4E56 0000    LINK       A6,#0           ; No local variables
002A: 7000         MOVEQ      #0,D0           ; Clear D0
002C: 102D D720    MOVE.B     -10464(A5),D0   ; D0 = g_cursor_state
0030: 3F00         MOVE.W     D0,-(A7)        ; Push cursor ID
0032: 4EAD 0112    JSR        274(A5)         ; JT[274] - set_cursor(id)
0036: 4E5E         UNLK       A6              ; Restore frame
0038: 4E75         RTS                        ; Return
```

**C Translation** (Confidence: HIGH):
```c
void set_cursor_from_state(void) {
    short cursor_id = (short)g_cursor_state;        /* A5-10464 */
    set_cursor(cursor_id);                          /* JT[274] */
}
```

---

### Function 0x003A: Clear Cursor (Arrow) (JT[368])
**Stack Frame**: 0 bytes

```asm
; void clear_cursor(void)
; Resets cursor to arrow (cursor ID 0)

003A: 4E56 0000    LINK       A6,#0           ; No local variables
003E: 4267         CLR.W      -(A7)           ; Push 0 (arrow cursor)
0040: 4EAD 0112    JSR        274(A5)         ; JT[274] - set_cursor(0)
0044: 4E5E         UNLK       A6              ; Restore frame
0046: 4E75         RTS                        ; Return
```

**C Translation** (Confidence: HIGH):
```c
void clear_cursor(void) {
    set_cursor(0);                                  /* Arrow cursor */
}
```

---

### Function 0x0048: Process Event with Callback (JT[376])
**Stack Frame**: 0 bytes
**Saved Registers**: A3, A4

```asm
; void process_event_callback(void* object)
; Processes events and invokes registered callback

0048: 4E56 0000    LINK       A6,#0           ; No local variables
004C: 48E7 0018    MOVEM.L    A3/A4,-(SP)     ; Save A3, A4
0050: 286E 0008    MOVEA.L    8(A6),A4        ; A4 = object parameter
0054: 2F0C         MOVE.L     A4,-(A7)        ; Push object
0056: 4EAD 064A    JSR        1610(A5)        ; JT[1610] - check_event
005A: 4A40         TST.W      D0              ; Test result
005C: 588F         ADDQ.L     #4,A7           ; Clean stack
005E: 670E         BEQ.S      $006E           ; If 0, skip to callback

; Event found - process it
0060: 2F0C         MOVE.L     A4,-(A7)        ; Push object
0062: 4EAD 064A    JSR        1610(A5)        ; JT[1610] - process_event
0066: 3E80         MOVE.W     D0,(A7)         ; Store result
0068: A9B7         _SystemTask                ; Yield time
006A: 548F         ADDQ.L     #2,A7           ; Clean stack
006C: 6018         BRA.S      $0086           ; Exit

; Look up callback
006E: 4878 0007    PEA        $0007.W         ; Push callback type 7
0072: 2F0C         MOVE.L     A4,-(A7)        ; Push object
0074: 4EAD 01FA    JSR        506(A5)         ; JT[506] - lookup_callback
0078: 2640         MOVEA.L    D0,A3           ; A3 = callback ptr
007A: 200B         MOVE.L     A3,D0           ; Test NULL
007C: 508F         ADDQ.L     #8,A7           ; Clean stack
007E: 6706         BEQ.S      $0086           ; If NULL, skip

; Invoke callback
0080: 2F0C         MOVE.L     A4,-(A7)        ; Push object
0082: 4E93         JSR        (A3)            ; Call callback(object)
0084: 588F         ADDQ.L     #4,A7           ; Clean stack

0086: 4CDF 1800    MOVEM.L    (SP)+,A3/A4     ; Restore registers
008A: 4E5E         UNLK       A6
008C: 4E75         RTS
```

**C Translation** (Confidence: HIGH):
```c
void process_event_callback(void* object) {
    typedef void (*CallbackFunc)(void*);
    CallbackFunc callback;
    short event_result;

    event_result = check_event(object);             /* JT[1610] */

    if (event_result != 0) {
        event_result = process_event(object);       /* JT[1610] */
        SystemTask();                               /* A9B7 - yield */
        return;
    }

    /* Look up callback for type 7 (idle/background) */
    callback = (CallbackFunc)lookup_callback(object, 7);  /* JT[506] */

    if (callback != NULL) {
        callback(object);                           /* Indirect call */
    }
}
```

---

## Global Variables

| Offset | Type | Name | Description |
|--------|------|------|-------------|
| A5-10464 | char | g_cursor_state | Current cursor ID |

## Jump Table Calls

| JT Offset | Function | Purpose |
|-----------|----------|---------|
| 274(A5) | set_cursor | Set cursor by ID |
| 506(A5) | lookup_callback | Find callback for object/type |
| 1610(A5) | check_event | Check/process pending events |

## Toolbox Traps

| Trap | Name | Purpose |
|------|------|---------|
| A946 | _ParamText | Set dialog text substitution |
| A949 | _GetIndString | Get string from STR# resource |
| A9B6 | _Alert | Display alert dialog |
| A9B7 | _SystemTask | Yield CPU time |

## Refined Analysis (Second Pass)

**Cluster**: Utilities

**Category**: UI_SUPPORT

**Global Variable Profile**: 0 DAWG, 1 UI, 1 total

**Calls functions in**: CODE 7, 9, 11

**Assessment**: Standard Mac UI utilities with callback dispatch

## Confidence: HIGH

Standard Mac UI patterns with clear trap usage and callback dispatch.
