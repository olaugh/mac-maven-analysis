# CODE 51 Detailed Analysis - Procedure Loader and Caller

## Overview

| Property | Value |
|----------|-------|
| Size | 236 bytes |
| JT Offset | 3360 |
| JT Entries | 6 |
| Functions | 6 |
| Purpose | **Dynamic procedure loading and invocation** |


## System Role

**Category**: Utility
**Function**: Small Helper

Minimal utility functions
## Architecture Role

CODE 51 provides dynamic code loading:
1. Get procedure addresses from CODE resources
2. Check if procedures are loaded
3. Call loaded procedures
4. Handle Apple Events or callbacks

## Key Functions

### Function 0x0000 - Get Procedure Entry Point
```asm
0000: LINK       A6,#0
0004: MOVE.L     D7,-(A7)

; Get entry point from jump table
0006: PEA        $0018.W              ; Entry offset 24
000A: MOVE.L     8(A6),-(A7)          ; CODE resource
000E: JSR        506(A5)              ; JT[506] - get entry

0012: MOVE.L     D0,D7                ; D7 = entry point
0014: TST.L      D7
0016: ...
0018: BNE.S      $001E                ; Valid
001A: JSR        418(A5)              ; JT[418] - error

001E: MOVE.L     D7,D0                ; Return entry point
0020: MOVE.L     (A7)+,D7
0022: UNLK       A6
0024: RTS
```

**C equivalent**:
```c
ProcPtr get_proc_entry(Handle code_res) {
    ProcPtr entry = GetCodeEntry(code_res, 24);

    if (!entry) {
        error_handler();
    }

    return entry;
}
```

### Function 0x0026 - Check Procedure Loaded
```asm
0026: LINK       A6,#0

; Get entry at offset 7
002A: PEA        $0007.W              ; Offset 7
002E: MOVE.L     8(A6),-(A7)          ; CODE resource
0032: JSR        506(A5)              ; JT[506] - get entry

; Return boolean (entry != 0)
0036: TST.L      D0
0038: SNE        D0                   ; Set if non-zero
003A: NEG.B      D0                   ; Convert to -1/0
003C: EXT.W      D0                   ; Extend to word
003E: EXT.L      D0                   ; Extend to long

0040: UNLK       A6
0042: RTS
```

**C equivalent**:
```c
Boolean is_proc_loaded(Handle code_res) {
    ProcPtr entry = GetCodeEntry(code_res, 7);
    return (entry != NULL);
}
```

### Function 0x0044 - Call Procedure
```asm
0044: LINK       A6,#0
0048: MOVE.L     A4,-(A7)

; Get procedure address
004A: PEA        $0007.W              ; Offset 7
004E: MOVE.L     8(A6),-(A7)          ; CODE resource
0052: JSR        506(A5)              ; JT[506]

0056: MOVEA.L    D0,A4                ; A4 = proc address
0058: MOVE.L     A4,D0
005A: ...
005C: BNE.S      $0062                ; Valid
005E: JSR        418(A5)              ; JT[418] - error

; Call the procedure
0062: MOVE.L     8(A6),-(A7)          ; Pass CODE handle
0066: JSR        (A4)                 ; Call procedure

0068: MOVEA.L    -4(A6),A4
006C: UNLK       A6
006E: RTS
```

**C equivalent**:
```c
void call_procedure(Handle code_res) {
    ProcPtr proc = GetCodeEntry(code_res, 7);

    if (!proc) {
        error_handler();
    }

    // Call procedure with CODE handle as parameter
    proc(code_res);
}
```

### Function 0x0070 - Handle Event With Procedure
```asm
0070: LINK       A6,#0
0074: MOVE.L     A4,-(A7)
0076: MOVEA.L    8(A6),A4             ; A4 = param 1

; Check event flags
007A: MOVEA.L    12(A6),A0            ; Event record
007E: BTST       #0,14(A0)            ; Test bit 0
0084: BNE.S      $00B2                ; Set - skip

; Check if loaded
0086: MOVE.L     A4,-(A7)
0088: JSR        -138(PC)             ; is_proc_loaded
008C: ANDI.W     #$0080,D0            ; Mask bit
0090: ...
0092: BEQ.S      $009E                ; Not loaded

; Call procedure via JT[3066]
0094: MOVE.L     A4,-(A7)
0096: JSR        3066(A5)             ; JT[3066]
009A: ...
009C: BRA.S      $00B2                ; Done

; Try alternate handler
009E: MOVE.L     A4,-(A7)
00A0: JSR        3114(A5)             ; JT[3114]
00A4: TST.W      D0
00A6: ...
00A8: BNE.S      $00B2                ; Handled

; Fall back to default
00AA: MOVE.L     A4,-(A7)
00AC: JSR        3130(A5)             ; JT[3130]
00B0: ...

; Store window rect
00B2: PEA        -1450(A5)            ; g_window_rect
00B6: MOVEA.L    12(A6),A0
00BA: MOVE.L     10(A0),-(A7)         ; Event where
00BE: MOVE.L     A4,-(A7)
00C0: JSR        3122(A5)             ; JT[3122]

00C4: MOVEA.L    -4(A6),A4
00C8: UNLK       A6
00CA: RTS
```

**C equivalent**:
```c
void handle_event_with_proc(Handle code_res, EventRecord* event) {
    // Check if event already handled
    if (event->modifiers & 0x01) {
        goto store_rect;
    }

    // Check if procedure is loaded
    if (is_proc_loaded(code_res) & 0x80) {
        handler_3066(code_res);
    } else {
        // Try alternate handler
        if (!handler_3114(code_res)) {
            // Use default
            handler_3130(code_res);
        }
    }

store_rect:
    // Store window position from event
    store_window_rect(code_res, event->where, &g_window_rect);
}
```

### Function 0x00CC - Simple Procedure Call
```asm
00CC: LINK       A6,#0
00D0: MOVE.L     8(A6),-(A7)          ; CODE resource
00D4: JSR        3130(A5)             ; JT[3130] - call
00D8: UNLK       A6
00DA: RTS
```

**C equivalent**:
```c
void simple_proc_call(Handle code_res) {
    handler_3130(code_res);
}
```

### Function 0x00DC - Another Procedure Call
```asm
00DC: LINK       A6,#0
00E0: MOVE.L     8(A6),-(A7)          ; CODE resource
00E4: JSR        3074(A5)             ; JT[3074] - call
00E8: UNLK       A6
00EA: RTS
```

**C equivalent**:
```c
void another_proc_call(Handle code_res) {
    handler_3074(code_res);
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1450 | g_window_rect - Window position rect |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 506 | Get CODE entry point |
| 3066 | Procedure handler 1 |
| 3074 | Procedure handler 2 |
| 3114 | Alternate handler |
| 3122 | Store window rect |
| 3130 | Default handler |

## CODE Resource Entry Points

| Offset | Purpose |
|--------|---------|
| 7 | Main procedure entry |
| 24 | Secondary entry point |

## Confidence: HIGH

Standard Mac CODE resource patterns:
- Dynamic procedure loading
- Jump table entry resolution
- Event-based dispatch
- Error checking on load
