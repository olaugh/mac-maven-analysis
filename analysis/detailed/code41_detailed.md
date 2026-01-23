# CODE 41 Detailed Analysis - Dialog Manager Interface

## Overview

| Property | Value |
|----------|-------|
| Size | 660 bytes |
| JT Offset | 3128 |
| JT Entries | 8 |
| Functions | 8 |
| Purpose | **Dialog box management, user interaction handling** |


## System Role

**Category**: Utility
**Function**: Helper Functions

General helper functions
## Architecture Role

CODE 41 provides dialog interface functionality:
1. Create and display modal dialogs
2. Handle user input events in dialogs
3. Process dialog item clicks
4. Manage dialog resources (DITL)

## Key Functions

### Function 0x0000 - Simple Modal Dialog
```asm
0000: LINK       A6,#-256             ; frame=256
0004: MOVE.L     8(A6),-(A7)          ; Push parameter
0008: PEA        -256(A6)             ; Local buffer
000C: JSR        2010(A5)             ; JT[2010] - setup
0010: MOVE.L     D0,(A7)              ; Store result
0012: CLR.L      -(A7)                ; Push 0
0014: CLR.L      -(A7)                ; Push 0
0016: CLR.L      -(A7)                ; Push 0
0018: DC.W       $A98B                ; _ModalDialog trap
001A: UNLK       A6
001C: RTS
```

**C equivalent**:
```c
void simple_modal_dialog(void* param) {
    char buffer[256];
    setup_dialog(param, buffer);
    ModalDialog(NULL, NULL, NULL);  // Mac Toolbox call
}
```

Uses Mac Toolbox `_ModalDialog` trap (A98B) for standard modal dialog handling.

### Function 0x001E - Create Dialog with Callback
```asm
001E: LINK       A6,#-8               ; frame=8
0022: MOVEM.L    D6/D7/A3/A4,-(SP)

; Get dialog ID parameter
0026: MOVE.W     8(A6),D7             ; D7 = dialog ID

; Initialize cursor
002A: DC.W       $A850                ; _InitCursor trap

; Get DITL resource
002C: PEA        -8(A6)               ; Handle storage
0030: MOVE.W     D7,-(A7)             ; Resource ID
0032: MOVE.L     #'DITL',-(A7)        ; Resource type 'DITL'
0038: JSR        1546(A5)             ; JT[1546] - GetResource
003C: MOVEA.L    D0,A4                ; A4 = DITL handle
003E: MOVE.L     A4,D0
0040: LEA        10(A7),A7
0044: BNE.S      $004A                ; Got resource
0046: JSR        418(A5)              ; JT[418] - error

; Detach resource for modification
004A: PEA        -8(A6)
004E: MOVE.W     D7,-(A7)             ; ID
0050: MOVE.L     #'DITL',-(A7)        ; Type
0056: JSR        3346(A5)             ; JT[3346] - DetachResource

; Create dialog window
005A: CLR.L      (A7)                 ; wStorage = NULL
005C: CLR.L      -(A7)                ; behind = NULL
005E: PEA        -8(A6)               ; bounds
0062: MOVE.L     10(A6),-(A7)         ; title
0066: MOVE.L     #$08050100,-(A7)     ; procID (movable modal)
006C: PEA        $FFFF.W              ; visible = true
0070: CLR.B      -(A7)                ; goAwayFlag = false
0072: PEA        -1242(A5)            ; refCon
0076: MOVE.L     A4,-(A7)             ; items list
0078: DC.W       $A97D                ; _NewDialog trap
007A: MOVEA.L    (A7)+,A3             ; A3 = dialog pointer
...

; Set up dialog
0086: MOVE.L     A3,-(A7)
0088: JSR        530(A5)              ; JT[530] - setup dialog

; Show and draw dialog
008C: CLR.W      (A7)                 ; itemHit = 0
008E: JSR        474(A5)              ; JT[474] - SetPort
0092: JSR        3138(A5)             ; JT[3138] - DrawDialog

; Call user callback
0096: MOVE.L     18(A6),(A7)          ; Push user data
009A: MOVE.L     A3,-(A7)             ; Push dialog
009C: MOVEA.L    14(A6),A0            ; Get callback
00A0: JSR        (A0)                 ; Call callback(dialog, userdata)
00A2: MOVE.W     D0,D6                ; Save return value

; Clean up
00A4: MOVE.W     #$0001,(A7)          ; itemHit = 1
00A8: JSR        474(A5)              ; JT[474] - reset
00AC: MOVE.L     A3,(A7)
00AE: MOVE.W     D7,-(A7)
00B0: MOVE.L     #'DITL',-(A7)
00B6: JSR        3354(A5)             ; JT[3354] - release DITL

; Dispose dialog
00BA: MOVE.L     A3,(A7)
00BC: JSR        538(A5)              ; JT[538] - pre-dispose
00C0: MOVE.L     A3,(A7)
00C2: DC.W       $A983                ; _CloseDialog trap
00C4: ...

00CA: MOVEM.L    -24(A6),D6/D7/A3/A4
00D0: UNLK       A6
00D2: RTS
```

**C equivalent**:
```c
int create_dialog_with_callback(int dialog_id, StringPtr title,
                                DialogCallback callback, void* userdata) {
    Handle ditl_handle;
    Rect bounds;

    InitCursor();

    // Get DITL resource
    ditl_handle = GetResource('DITL', dialog_id);
    if (!ditl_handle) error();

    DetachResource('DITL', dialog_id);

    // Create dialog
    DialogPtr dialog = NewDialog(
        NULL,           // storage
        &bounds,        // bounds
        title,          // title
        true,           // visible
        movableDBoxProc,// procID
        (WindowPtr)-1,  // behind
        false,          // goAway
        g_refcon,       // refCon
        ditl_handle     // items
    );

    setup_dialog(dialog);
    SetPort(dialog);
    DrawDialog(dialog);

    // Call user callback
    int result = callback(dialog, userdata);

    // Cleanup
    CloseDialog(dialog);

    return result;
}
```

### Function 0x00D4 - Standard Dialog Wrapper
```asm
00D4: LINK       A6,#0
00D8: MOVE.L     10(A6),-(A7)         ; Push userdata
00DC: PEA        3162(A5)             ; Push callback address
00E0: MOVE.L     -3512(A5),-(A7)      ; Push stored data
00E4: MOVE.W     8(A6),-(A7)          ; Push dialog ID
00E8: JSR        -204(PC)             ; Call function 0x001E
00EC: UNLK       A6
00EE: RTS
```

**C equivalent**:
```c
void standard_dialog(int dialog_id, void* userdata) {
    create_dialog_with_callback(
        dialog_id,
        g_stored_data,        // A5-3512
        standard_callback,    // A5+3162
        userdata
    );
}
```

### Function 0x00F0 - Read Dialog Value
```asm
00F0: LINK       A6,#-2               ; frame=2
00F4: MOVE.L     12(A6),-(A7)         ; Push item handle
00F8: PEA        -2(A6)               ; Push result storage
00FC: DC.W       $A991                ; _GetDialogItem trap
0100: MOVE.W     -2(A6),D0            ; Return value
0102: UNLK       A6
0104: RTS
```

### Function 0x011C - Dialog Event Handler
```asm
011C: LINK       A6,#-12              ; frame=12
0120: MOVEM.L    D7/A3/A4,-(SP)

; Get parameters
0124: MOVEA.L    12(A6),A3            ; A3 = event record
0128: MOVEA.L    16(A6),A4            ; A4 = dialog data

; Get event type
012C: MOVE.W     (A3),D7              ; D7 = what field

; Check for keyDown or autoKey
012E: CMPI.W     #3,D7                ; keyDown?
0132: BEQ.S      $013A
0134: CMPI.W     #5,D7                ; autoKey?
0138: BNE.S      $0172                ; No - check other events

; Key event handling
013A: MOVE.W     4(A3),D7             ; Get key code
013E: ANDI.W     #$00FF,D7            ; Mask to character
0142: CMPI.W     #3,D7                ; Enter key?
0146: BEQ.S      $014E
0148: CMPI.W     #13,D7               ; Return key?
014C: BNE.S      $0166

; Enter/Return pressed - check if button exists
014E: TST.W      168(A4)              ; Check for default button
0152: BEQ.S      $0166                ; No default button

; Simulate button click
0154: MOVEA.L    8(A6),A0             ; Get item ptr
0158: MOVE.W     168(A4),(A0)         ; Set item to default button
015C: MOVE.B     #1,20(A6)            ; Set handled flag
0162: BRA.W      $0228                ; Return handled

0166: MOVE.L     A3,-(A7)
0168: JSR        546(A5)              ; JT[546] - handle key
016C: ADDQ       #4,A7
016E: BRA.W      $0222

; Check for update event
0172: CMPI.W     #6,D7                ; updateEvt?
0176: BEQ.S      $017E
0178: CMPI.W     #8,D7                ; activateEvt?
017C: BNE.S      $018A

; Update/activate - redraw
017E: MOVE.L     A3,-(A7)
0180: JSR        546(A5)              ; JT[546] - redraw
0184: ADDQ       #4,A7
0186: BRA.W      $0222

; Check for mouseDown
018A: CMPI.W     #1,D7                ; mouseDown?
018E: BNE.W      $0214

; Mouse down - track click
0192: CLR.W      -(A7)                ; part code
0194: MOVE.L     10(A3),-(A7)         ; where
0198: PEA        -4(A6)               ; window ptr storage
019C: DC.W       $A92C                ; _FindWindow trap
01A0: MOVE.W     (A7)+,D7             ; Get part code

; Check part code
01A2: CMP.W      -4(A6),D7
01A6: BEQ.S      $01D6                ; In dialog - handle
...

; Handle dialog item click
01D6: CMPI.W     #3,D7                ; inDrag?
01DA: BNE.S      $0208

; Track text edit or click
01DC: MOVE.L     10(A3),-8(A6)        ; Store click point
01E2: MOVE.L     -4(A6),-(A7)         ; Window
01E6: PEA        -8(A6)               ; Click point
01EA: DC.W       $A873                ; _GlobalToLocal trap
01EE: CLR.W      -(A7)                ; extend = false
01F0: MOVE.L     -8(A6),-(A7)         ; Local point
01F4: MOVE.L     -4(A6),-(A7)         ; Window
01F8: PEA        -12(A6)              ; Item result
01FC: DC.W       $A96C                ; _DialogSelect trap
0200: MOVE.W     (A7)+,D7
0202: BEQ.S      $0206
0204: CLR.B      20(A6)               ; Clear handled
0206: BRA.S      $0226

0208: MOVE.L     A3,-(A7)
020A: JSR        546(A5)              ; JT[546]
020E: ADDQ       #4,A7
0210: BRA.S      $0220

; Null event
0212: TST.W      D7
0214: BNE.S      $0220
0216: MOVE.L     A3,-(A7)
0218: MOVE.L     A4,-(A7)
021A: JSR        554(A5)              ; JT[554] - idle
021E: ADDQ       #8,A7

0220: CLR.W      (A3)                 ; Clear event
0222: CLR.B      20(A6)               ; Clear handled flag

0226: MOVEM.L    (SP)+,D7/A3/A4
022A: UNLK       A6
022C: MOVEA.L    (A7)+,A0
022E: LEA        12(A7),A7
0232: JMP        (A0)                 ; Return
```

**C equivalent**:
```c
Boolean dialog_event_handler(EventRecord* event, DialogData* data) {
    int what = event->what;

    switch (what) {
        case keyDown:
        case autoKey: {
            char key = event->message & 0xFF;
            if ((key == 3 || key == 13) && data->defaultButton) {
                // Enter/Return - click default button
                *itemHit = data->defaultButton;
                return true;
            }
            handle_key(event);
            break;
        }

        case updateEvt:
        case activateEvt:
            redraw(event);
            break;

        case mouseDown: {
            WindowPtr win;
            int part = FindWindow(event->where, &win);

            if (part == inDrag) {
                Point local = event->where;
                GlobalToLocal(&local);
                DialogSelect(win, local, false, &itemHit);
            } else {
                handle_click(event);
            }
            break;
        }

        case nullEvent:
            idle(event, data);
            break;
    }

    event->what = 0;  // Mark handled
    return false;
}
```

### Function 0x024C - Alert Dialog
```asm
024C: LINK       A6,#0
0250: MOVE.L     8(A6),-(A7)          ; Push param
0254: CLR.L      -(A7)                ; filterProc = NULL
0256: CLR.L      -(A7)                ; 0
0258: CLR.L      -(A7)                ; 0
025A: DC.W       $A98B                ; _ModalDialog trap
025E: ...
0262: JSR        -348(PC)             ; Internal helper
...
026A: MOVE.L     -27732(A5),-24030(A5) ; Copy global
0270: SUBQ.W     #1,-23674(A5)        ; Decrement counter
0276: AND.L      -23674(A5),A0
027A: LEA        -24026(A5),A0        ; g_common
...
0290: UNLK       A6
0292: RTS
```

## Mac Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| A850 | InitCursor | Reset cursor to arrow |
| A873 | GlobalToLocal | Convert coordinates |
| A92C | FindWindow | Determine click location |
| A96C | DialogSelect | Handle dialog click |
| A97D | NewDialog | Create dialog window |
| A983 | CloseDialog | Dispose dialog |
| A98B | ModalDialog | Run modal dialog |
| A991 | GetDialogItem | Get item info |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1242 | Dialog refCon storage |
| A5-3512 | Stored dialog data |
| A5+3162 | Standard callback address |
| A5+3210 | Secondary callback |
| A5-23674 | Dialog counter |
| A5-24026 | g_common dialog data |
| A5-24030 | Dialog copy buffer |
| A5-27732 | Dialog state |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 474 | SetPort wrapper |
| 530 | Setup dialog |
| 538 | Pre-dispose cleanup |
| 546 | Handle dialog event |
| 554 | Idle processing |
| 1546 | GetResource wrapper |
| 2010 | Dialog setup |
| 3138 | DrawDialog wrapper |
| 3226 | Alert helper |
| 3346 | DetachResource |
| 3354 | Release DITL |

## Event Types Handled

| Code | Event Type |
|------|------------|
| 0 | nullEvent |
| 1 | mouseDown |
| 3 | keyDown |
| 5 | autoKey |
| 6 | updateEvt |
| 8 | activateEvt |

## Confidence: HIGH

Clear Mac Toolbox Dialog Manager patterns:
- Standard dialog creation/disposal sequence
- Event filtering with ModalDialog
- DITL resource management
- Proper coordinate conversion for clicks
