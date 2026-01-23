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

**Category**: Runtime
**Function**: Dynamic Code Loading

Provides dynamic procedure loading and calling through CODE resource entry points.

## Architecture Role

CODE 51 provides dynamic code loading:
1. Get procedure addresses from CODE resources
2. Check if procedures are loaded
3. Call loaded procedures
4. Handle events with procedure dispatch

## Key Functions

### Function 0x0000 - Get Procedure Entry Point (offset 24)
```asm
; JT offset: 3360
0000: LINK       A6,#0
0004: MOVE.L     D7,-(A7)             ; Save D7

; Get entry point at offset 24 (0x18) in CODE
0006: PEA        $0018.W              ; Entry offset 24
000A: MOVE.L     8(A6),-(A7)          ; CODE resource handle
000E: JSR        506(A5)              ; JT[506] - GetCodeEntry

; Check if valid
0012: MOVE.L     D0,D7                ; D7 = entry point
0014: TST.L      D7
0016: ...
0018: BNE.S      $001E                ; Valid - continue
001A: JSR        418(A5)              ; JT[418] - error handler

; Return entry point
001E: MOVE.L     D7,D0
0020: MOVE.L     (A7)+,D7             ; Restore D7
0022: UNLK       A6
0024: RTS
```

**C equivalent**:
```c
ProcPtr get_proc_entry_24(Handle codeRes) {
    ProcPtr entry = GetCodeEntry(codeRes, 24);

    if (!entry) {
        error_handler();
    }

    return entry;
}
```

### Function 0x0026 - Check Procedure Loaded (offset 7)
```asm
; JT offset: 3368
0026: LINK       A6,#0

; Get entry at offset 7
002A: PEA        $0007.W              ; Entry offset 7
002E: MOVE.L     8(A6),-(A7)          ; CODE resource handle
0032: JSR        506(A5)              ; JT[506] - GetCodeEntry

; Convert to boolean
0036: TST.L      D0                   ; Test if non-zero
0038: SNE        D0                   ; Set if non-zero (0xFF)
003A: NEG.B      D0                   ; Convert to -1 (TRUE) or 0 (FALSE)
003C: EXT.W      D0                   ; Extend to word
003E: EXT.L      D0                   ; Extend to long

0040: UNLK       A6
0042: RTS
```

**C equivalent**:
```c
Boolean is_proc_loaded(Handle codeRes) {
    ProcPtr entry = GetCodeEntry(codeRes, 7);
    return (entry != NULL) ? -1 : 0;  // Mac Boolean: -1=TRUE, 0=FALSE
}
```

### Function 0x0044 - Call Procedure (offset 7)
```asm
; JT offset: 3376
0044: LINK       A6,#0
0048: MOVE.L     A4,-(A7)             ; Save A4

; Get procedure address at offset 7
004A: PEA        $0007.W
004E: MOVE.L     8(A6),-(A7)          ; CODE handle
0052: JSR        506(A5)              ; JT[506] - GetCodeEntry

; Validate
0056: MOVEA.L    D0,A4                ; A4 = proc address
0058: MOVE.L     A4,D0
005A: ...
005C: BNE.S      $0062                ; Valid
005E: JSR        418(A5)              ; JT[418] - error

; Call procedure with CODE handle as parameter
0062: MOVE.L     8(A6),-(A7)          ; Push CODE handle
0066: JSR        (A4)                 ; Call procedure!

; Cleanup
0068: MOVEA.L    -4(A6),A4            ; Restore A4
006C: UNLK       A6
006E: RTS
```

**C equivalent**:
```c
void call_procedure(Handle codeRes) {
    typedef void (*ProcType)(Handle);

    ProcType proc = (ProcType)GetCodeEntry(codeRes, 7);

    if (!proc) {
        error_handler();
    }

    // Call procedure, passing the CODE handle
    proc(codeRes);
}
```

### Function 0x0070 - Handle Event With Procedure Dispatch
```asm
; JT offset: 3384
0070: LINK       A6,#0
0074: MOVE.L     A4,-(A7)             ; Save A4
0076: MOVEA.L    8(A6),A4             ; A4 = first param (CODE handle)
007A: MOVEA.L    12(A6),A0            ; A0 = event record

; Check event modifier bit 0
007E: BTST       #0,14(A0)            ; Test bit 0 of modifiers (offset 14)
0084: BNE.S      $00B2                ; Set - skip to store rect

; Check if procedure is loaded
0086: MOVE.L     A4,-(A7)
0088: JSR        -138(PC)             ; Call is_proc_loaded (function at 0x0026)
008C: ANDI.W     #$0080,D0            ; Mask bit 7
0090: ...
0092: BEQ.S      $009E                ; Not loaded (bit 7 clear)

; Call handler via JT[3066]
0094: MOVE.L     A4,-(A7)
0096: JSR        3066(A5)             ; JT[3066] - primary handler
009A: ...
009C: BRA.S      $00B2                ; Done

; Try alternate handler
009E: MOVE.L     A4,-(A7)
00A0: JSR        3114(A5)             ; JT[3114] - alternate handler
00A4: TST.W      D0                   ; Check result
00A6: ...
00A8: BNE.S      $00B2                ; Handled - done

; Fall back to default handler
00AA: MOVE.L     A4,-(A7)
00AC: JSR        3130(A5)             ; JT[3130] - default handler
00B0: ...

; Store window position
00B2: PEA        -1450(A5)            ; g_window_rect
00B6: MOVEA.L    12(A6),A0            ; Event record
00BA: MOVE.L     10(A0),-(A7)         ; event->where (Point at offset 10)
00BE: MOVE.L     A4,-(A7)             ; CODE handle
00C0: JSR        3122(A5)             ; JT[3122] - store_window_rect

00C4: MOVEA.L    -4(A6),A4
00C8: UNLK       A6
00CA: RTS
```

**C equivalent**:
```c
void handle_event_with_proc(Handle codeRes, EventRecord* event) {
    // Check if event already handled (modifier bit 0)
    if (event->modifiers & 0x01) {
        goto store_rect;
    }

    // Check if procedure is loaded with specific flag
    if (is_proc_loaded(codeRes) & 0x80) {
        // Call primary handler
        handler_3066(codeRes);
    } else {
        // Try alternate handler
        if (!handler_3114(codeRes)) {
            // Use default handler
            handler_3130(codeRes);
        }
    }

store_rect:
    // Store window position from event
    store_window_rect(codeRes, event->where, &g_window_rect);
}
```

### Function 0x00CC - Simple Default Handler Call
```asm
; JT offset: 3392
00CC: LINK       A6,#0
00D0: MOVE.L     8(A6),-(A7)          ; CODE handle
00D4: JSR        3130(A5)             ; JT[3130] - default handler
00D8: UNLK       A6
00DA: RTS
```

**C equivalent**:
```c
void simple_default_call(Handle codeRes) {
    handler_3130(codeRes);
}
```

### Function 0x00DC - Alternate Handler Call
```asm
; JT offset: 3400
00DC: LINK       A6,#0
00E0: MOVE.L     8(A6),-(A7)          ; CODE handle
00E4: JSR        3074(A5)             ; JT[3074] - alternate handler
00E8: UNLK       A6
00EA: RTS
```

**C equivalent**:
```c
void alternate_handler_call(Handle codeRes) {
    handler_3074(codeRes);
}
```

## EventRecord Structure (Mac OS)

| Offset | Type | Field |
|--------|------|-------|
| 0 | Word | what (event type) |
| 2 | Long | message |
| 6 | Long | when (tick count) |
| 10 | Point | where (mouse location) |
| 14 | Word | modifiers |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1450 | g_window_rect - Window position rect |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 506 | GetCodeEntry - Get CODE entry point |
| 3066 | Primary procedure handler |
| 3074 | Alternate handler 2 |
| 3114 | Alternate handler 1 |
| 3122 | Store window rect |
| 3130 | Default handler |

## CODE Resource Entry Points

| Offset | Purpose |
|--------|---------|
| 7 | Main procedure entry |
| 24 (0x18) | Secondary entry point |

These offsets are standard for Mac CODE resources:
- Offset 7 is the standard entry point for the first function
- Offset 24 (0x18) is likely a secondary export

## Architecture Pattern

This module implements a dynamic dispatch system:
1. CODE resources can export multiple procedures at fixed offsets
2. Callers use this module to safely invoke procedures
3. Event handling uses a fallback chain: primary -> alternate -> default

## Boolean Conversion Pattern

The SNE/NEG.B/EXT.W/EXT.L sequence at 0x0038-003E is the standard 68K pattern for converting a test result to a Mac Boolean:
- SNE sets D0.B to 0xFF if non-zero, 0x00 if zero
- NEG.B converts 0xFF to 0x01 (but actually -1 after extension)
- EXT.W/EXT.L sign-extend to full long
- Result: -1 (0xFFFFFFFF) for TRUE, 0 for FALSE

## Confidence: HIGH

Standard Mac CODE resource patterns:
- Dynamic procedure loading via fixed offsets
- Jump table entry resolution
- Event-based dispatch with fallback chain
- Error checking on load failures
- Boolean conversion using standard 68K idiom
