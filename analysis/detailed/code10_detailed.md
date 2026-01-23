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

---

## Speculative C Translation

```c
/* CODE 10 - Speculative C Translation */
/* Cursor & Dialog Support */

/*============================================================
 * Global Variables
 *============================================================*/
extern char g_cursor_state;          /* A5-10464: current cursor ID */

/* Cursor ID constants (speculative) */
#define CURSOR_ARROW    0            /* Standard arrow cursor */
#define CURSOR_IBEAM    1            /* Text insertion cursor */
#define CURSOR_WATCH    2            /* Wait/busy cursor */
#define CURSOR_CROSS    3            /* Crosshair cursor */
#define CURSOR_CUSTOM   128          /* Application-defined cursor */

/*============================================================
 * Function 0x0000 - Show Alert Dialog
 * JT offset: 352(A5)
 * Frame size: 256 bytes (Str255 buffer)
 *
 * Displays a standard Mac alert with text from string resource.
 *============================================================*/
void show_alert_dialog(short string_id /* uncertain param */) {
    Str255 alert_text;               /* -256(A6), Pascal string buffer */

    /* Get alert text from string resource */
    /* Resource ID 128 is the STR# resource containing alert strings */
    GetIndString(alert_text,         /* A949 trap at 0x000A */
                 128,                 /* STR# resource ID */
                 string_id);          /* String index */

    /* Set up ParamText for the alert */
    /* ParamText substitutes ^0, ^1, ^2, ^3 placeholders */
    ParamText(alert_text,            /* A946 trap at 0x0014 */
              NULL,                   /* ^1 substitution (unused) */
              NULL,                   /* ^2 substitution (unused) */
              NULL);                  /* ^3 substitution (unused) */

    /* Display the alert dialog */
    /* The alert resource (ALRT) defines the dialog appearance */
    Alert(string_id,                 /* A9B6 trap at 0x001C */
          NULL);                      /* filterProc = NULL (no custom filter) */
}

/*============================================================
 * Function 0x0022 - Set Cursor from Global State
 * JT offset: 360(A5)
 *
 * Sets the cursor based on the current g_cursor_state global.
 * Used to restore cursor after operations that change it.
 *============================================================*/
void set_cursor_from_state(void) {
    short cursor_id;

    /* Read cursor state from global */
    cursor_id = (short)g_cursor_state;  /* MOVE.B -10464(A5),D0 */

    /* Set the cursor via jump table function */
    set_cursor(cursor_id);           /* JT[274] at 0x002E */
}

/*============================================================
 * Function 0x0036 - Clear Cursor (Reset to Arrow)
 * JT offset: 368(A5)
 *
 * Resets cursor to the standard arrow cursor.
 * Called when leaving a region that had a custom cursor.
 *============================================================*/
void clear_cursor(void) {
    set_cursor(CURSOR_ARROW);        /* JT[274] with 0 */
}

/*============================================================
 * Function 0x0044 - Process Event with Callback
 * JT offset: 376(A5)
 *
 * Main event processing function that:
 * 1. Checks for pending events
 * 2. Processes events if found
 * 3. Yields time to system (cooperative multitasking)
 * 4. Looks up and calls registered callback
 *
 * This is the core of Maven's event loop for UI objects.
 *============================================================*/
void process_event_with_callback(void *object /* 8(A6), stored in A4 */) {
    typedef void (*CallbackFunc)(void*);
    CallbackFunc callback;           /* A3 */
    short event_result;

    /* Check if there's a pending event for this object */
    event_result = check_event(object);  /* JT[1610] at 0x0052 */

    if (event_result != 0) {         /* TST.W D0; BEQ.S at 0x005A */
        /* Event pending - process it */
        event_result = process_event(object);  /* JT[1610] again at 0x005E */

        /* Yield time to other processes */
        /* SystemTask allows other apps to run (cooperative multitasking) */
        /* uncertain: exact trap usage */
        SystemTask();                /* A9B7 trap at 0x0064 */
    }

    /*
     * Look up registered callback for this object
     * Callback type 7 is used (purpose uncertain - possibly "idle" callback)
     */
    callback = (CallbackFunc)lookup_callback(
        object,                      /* Object to look up */
        7                            /* Callback type */
    );                               /* JT[506] at 0x0070 */

    /* Call the callback if one is registered */
    if (callback != NULL) {          /* TST/BEQ at 0x0076-0x007A */
        callback(object);            /* JSR (A3) at 0x007E */
    }
}

/*============================================================
 * Callback System (speculative)
 *
 * Maven appears to use a callback registration system where:
 * - Objects can register callbacks for various event types
 * - JT[506] (lookup_callback) retrieves the callback function
 * - Callback types include:
 *   - Type 7: Idle/background processing
 *   - Other types: Unknown
 *
 * This pattern is common in Mac event-driven applications,
 * allowing modular handling of different event types.
 *============================================================*/

/*============================================================
 * Cursor Management Summary
 *
 * Cursor changes throughout the application:
 *
 * 1. Arrow (0): Default, most UI areas
 * 2. Watch/Wait: During AI thinking
 * 3. I-Beam: Over text fields
 * 4. Custom: Over game board squares
 *
 * The g_cursor_state global tracks the "intended" cursor,
 * which can differ from the actual cursor during temporary
 * changes (like showing watch during processing).
 *
 * set_cursor_from_state() restores the intended cursor
 * after a temporary change.
 *============================================================*/

/*============================================================
 * Alert Dialog Flow
 *
 * 1. Get localized string from STR# 128 resource
 * 2. Set up ParamText for substitution
 * 3. Display alert using ALRT resource
 * 4. Wait for user dismissal
 *
 * Common alert strings (speculative):
 * - "Cannot find dictionary"
 * - "Invalid move"
 * - "Memory allocation failed"
 * - "Are you sure you want to resign?"
 *============================================================*/

/*============================================================
 * Event Loop Integration
 *
 * process_event_with_callback() is called repeatedly in
 * Maven's main event loop:
 *
 * while (game_running) {
 *     WaitNextEvent(everyEvent, &event, sleep, NULL);
 *
 *     switch (event.what) {
 *         case mouseDown:
 *             // Handle click
 *             break;
 *         case keyDown:
 *             // Handle key
 *             break;
 *         // ...
 *     }
 *
 *     // Process callbacks for active UI elements
 *     for each (object in active_objects) {
 *         process_event_with_callback(object);
 *     }
 * }
 *============================================================*/
```
