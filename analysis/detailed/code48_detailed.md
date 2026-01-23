# CODE 48 Detailed Analysis - TextEdit Control Manager

## Overview

| Property | Value |
|----------|-------|
| Size | 1092 bytes |
| JT Offset | 3192 |
| JT Entries | 15 |
| Functions | 14 |
| Purpose | **TextEdit (TE) control management, text input handling** |

## Architecture Role

CODE 48 provides TextEdit functionality:
1. Create and manage text edit controls
2. Handle text input and editing
3. Process key events in text fields
4. Manage selection and cursor

## Mac Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| A873 | GlobalToLocal | Convert coordinates |
| A874 | GetPort | Get current graphics port |
| A870 | SetPortBits | Set port bits |
| A89B | ScrollRect | Scroll rectangle area |
| A89E | PenSize | Set pen size |
| A8A3 | InsetRect | Inset rectangle |
| A8A8 | OffsetRect | Offset rectangle |
| A8A9 | InsetRect | Inset rectangle |
| A8B0 | EraseRect | Erase rectangle |
| A98D | GetDItem | Get dialog item |
| A9C8 | TEIdle | TextEdit idle |
| A9D0 | TEActivate | Activate TE |
| A9D1 | TEDeactivate | Deactivate TE |
| A9D2 | TEKey | Handle key in TE |
| A9D3 | TECut | Cut selection |
| A9D4 | TECopy | Copy selection |
| A9D8 | TEPaste | Paste |
| A9D9 | TEDelete | Delete selection |
| A9DA | TEDispose | Dispose TE record |

## Key Functions

### Function 0x0000 - TextEdit Idle
```asm
0000: LINK       A6,#0
0004: BRA.S      $000C                ; Jump to loop

; Call TEIdle for blinking cursor
0006: MOVE.W     #$0001,-(A7)         ; flag
000A: A9C8                            ; _TEIdle trap

; Decrement counter
000C: MOVE.W     8(A6),D0             ; Get count
0010: MOVE.B     8(A6),...            ; Decrement
0014: ...
0016: BNE.S      $0006                ; Loop until zero

0018: UNLK       A6
001A: RTS
```

**C equivalent**:
```c
void textedit_idle(int count) {
    while (count > 0) {
        TEIdle();
        count--;
    }
}
```

### Function 0x001C - Activate TextEdit
```asm
001C: LINK       A6,#0
0020: MOVE.L     8(A6),-(A7)          ; TE handle
0024: JSR        3010(A5)             ; JT[3010] - internal setup
0028: MOVE.W     #$0001,-3466(A5)     ; Set active flag
002E: UNLK       A6
0030: RTS
```

**C equivalent**:
```c
void activate_textedit(TEHandle te) {
    internal_setup(te);
    g_te_active = 1;  // A5-3466
}
```

### Function 0x0032 - Deactivate TextEdit
```asm
0032: LINK       A6,#0
0036: MOVE.L     8(A6),-(A7)          ; TE handle
003A: JSR        3002(A5)             ; JT[3002] - internal cleanup
003E: MOVE.W     #$0001,-3466(A5)     ; Set flag
0044: UNLK       A6
0046: RTS
```

### Function 0x007C - TEDispose Wrapper
```asm
007C: LINK       A6,#0
0080: MOVEA.L    8(A6),A0             ; Get control
0084: CMPI.W     #$FFFF,164(A0)       ; Check if valid
008A: BEQ.S      $0096                ; Invalid - skip

008C: MOVEA.L    8(A6),A0
0090: MOVE.L     160(A0),-(A7)        ; TE handle
0094: A9DA                            ; _TEDispose
...
0098: MOVEQ      #0,D0
009A: UNLK       A6
009C: RTS
```

**C equivalent**:
```c
void dispose_textedit(ControlHandle ctrl) {
    if ((**ctrl).contrlValue != -1) {
        TEDispose((TEHandle)(**ctrl).contrlData);
    }
}
```

### Function 0x00D8 - Draw TextEdit Frame
```asm
00D8: LINK       A6,#-18              ; frame=18
00DC: MOVE.L     A4,-(A7)
00DE: MOVEA.L    8(A6),A4             ; A4 = control

; Get port and push for later
00E2: MOVE.L     A4,-(A7)
00E4: MOVE.L     24(A4),-(A7)         ; Window ptr
00E8: A978                            ; _GetPort
...

; Check if should draw
00EE: TST.W      168(A4)              ; Visible?
...
; Get TE rect
00F0: MOVE.L     A4,-(A7)
00F2: MOVE.W     168(A4),-(A7)        ; Item number
00F6: PEA        -2(A6)               ; Item type
00FA: PEA        -6(A6)               ; Item handle
00FE: PEA        -14(A6)              ; Item rect
0102: A98D                            ; _GetDItem

; Check item type
0106: CMPI.W     #$0004,-2(A6)        ; editText?
010A: BNE.S      $012E                ; No - skip

; Draw 3D inset frame
010C: MOVE.L     #$00030003,-(A7)     ; Inset (3,3)
0112: A89B                            ; _ScrollRect

0114: PEA        -14(A6)              ; Rect
0118: MOVE.L     #$FFFCFFFC,-(A7)     ; Inset (-4,-4)
011E: A8A9                            ; _InsetRect

0122: PEA        -14(A6)              ; Rect
0126: MOVE.L     #$00100010,-(A7)     ; Offset (16,16)
012A: A8B0                            ; _EraseRect
012C: A89E                            ; _PenSize

012E: MOVEA.L    (A7)+,A4
0130: UNLK       A6
0132: RTS
```

**C equivalent**:
```c
void draw_textedit_frame(ControlHandle ctrl) {
    Rect itemRect;
    Handle itemHandle;
    short itemType;
    GrafPtr port;

    GetPort(&port);

    if ((**ctrl).contrlHilite == 0) return;

    GetDItem((**ctrl).contrlOwner, (**ctrl).contrlHilite,
             &itemType, &itemHandle, &itemRect);

    if (itemType == editText) {
        // Draw 3D inset frame
        InsetRect(&itemRect, 3, 3);
        ScrollRect(&itemRect, 3, 3, NULL);
        InsetRect(&itemRect, -4, -4);
        OffsetRect(&itemRect, 16, 16);
        EraseRect(&itemRect);
        PenSize(1, 1);
    }
}
```

### Function 0x0134 - Set TextEdit Text
```asm
0134: LINK       A6,#-256             ; frame=256

; Get text from control
0138: PEA        -256(A6)             ; Buffer
013C: MOVE.W     12(A6),-(A7)         ; Item ID
0140: MOVE.L     8(A6),-(A7)          ; Dialog
0144: JSR        1602(A5)             ; JT[1602] - GetDItemText

; Compare with new text
0148: MOVE.L     14(A6),(A7)          ; New text
014C: PEA        -256(A6)             ; Current text
0150: PEA        -256(A6)             ; Buffer
0154: JSR        1586(A5)             ; JT[1586] - compare

0158: TST.W      D0
015A: LEA        18(A7),A7
015E: BEQ.S      $017A                ; Same - skip

; Set new text
0160: MOVE.W     #$000F,-(A7)         ; Max length
0164: A9C8                            ; _TEIdle
0166: PEA        -256(A6)             ; New text
016A: MOVE.W     12(A6),-(A7)         ; Item ID
016E: MOVE.L     8(A6),-(A7)          ; Dialog
0172: JSR        306(PC)              ; Set text

0176: LEA        10(A7),A7

017A: UNLK       A6
017C: RTS
```

**C equivalent**:
```c
void set_textedit_text(DialogPtr dialog, int item_id, StringPtr text) {
    Str255 current_text;

    GetDItemText(dialog, item_id, current_text);

    if (!EqualString(current_text, text)) {
        TEIdle();
        SetDItemText(dialog, item_id, text);
    }
}
```

### Function 0x01A2 - Initialize TextEdit Control
```asm
01A2: LINK       A6,#-20              ; frame=20
01A6: MOVE.L     A4,-(A7)
01A8: MOVEA.L    8(A6),A4             ; A4 = control

; Get item rect
01AC: MOVE.L     A4,-(A7)
01AE: MOVE.W     12(A6),-(A7)         ; Item number
01B2: PEA        -2(A6)               ; Type
01B6: PEA        -6(A6)               ; Handle
01BA: PEA        -14(A6)              ; Rect
01BE: A98D                            ; _GetDItem

; Delete existing TE
01C2: MOVE.L     160(A4),-(A7)        ; TE handle
01C6: A9D9                            ; _TEDelete

; Create new view rect
01C8: MOVEA.L    160(A4),A0
01CC: MOVEA.L    (A0),A0
01CE: MOVE.L     -6(A6),62(A0)        ; Store rect

; Set up TE handle
01D2: CLR.L      -(A7)
01D4: MOVE.L     -6(A6),-(A7)         ; Rect
01D8: JSR        2826(A5)             ; JT[2826] - create TE

01DC: MOVE.L     (A7)+,D0
01DE: MOVEA.L    160(A4),A0
01E2: MOVEA.L    (A0),A0
01E4: MOVE.W     D0,60(A0)            ; Store TE handle

; Store dest rect
01E8: MOVEA.L    160(A4),A0
01EC: MOVEA.L    (A0),A0
01EE: MOVE.L     -14(A6),(A0)         ; Top-left
01F2: MOVE.L     -10(A6),4(A0)        ; Bottom-right

; Store view rect
01F8: MOVEA.L    160(A4),A1
01FC: MOVEA.L    (A1),A1
01FE: MOVE.L     (A0),8(A1)
0202: MOVE.L     4(A0),12(A1)

; Activate TE
0208: MOVE.L     160(A4),-(A7)
020C: A9D0                            ; _TEActivate

; Copy port settings
020E: MOVE.L     160(A4),-(A7)
0212: A9D8                            ; _TEPaste (copy state)

; Get item again
0216: MOVE.L     A4,-(A7)
0218: MOVE.W     12(A6),-(A7)
021C: PEA        -2(A6)
0220: PEA        -6(A6)
0224: PEA        -14(A6)
0228: A98D                            ; _GetDItem

; Convert coordinates
022A: PEA        -18(A6)
022E: A874                            ; _GetPort

0230: MOVE.L     A4,-(A7)
0234: PEA        -14(A6)
0238: A8A3                            ; _InsetRect

; Set up dest rect
023C: PEA        -14(A6)
0240: MOVE.L     160(A4),-(A7)
0244: A9D3                            ; _TECut (setup)

; Get port
0246: MOVE.L     -18(A6),-(A7)
024A: A873                            ; _GlobalToLocal

; Store control value
024C: MOVEQ      #-1,D0
024E: MOVEA.B    12(A6),A0
0252: MOVE.W     D0,164(A4)           ; Set value to -1

0254: MOVEA.L    (A7)+,A4
0256: UNLK       A6
0258: RTS
```

**C equivalent**:
```c
void init_textedit_control(ControlHandle ctrl, int itemNum) {
    Rect itemRect;
    Handle itemHandle;
    short itemType;
    TEHandle te;

    GetDItem((**ctrl).contrlOwner, itemNum,
             &itemType, &itemHandle, &itemRect);

    // Delete existing TE record
    TEDelete((TEHandle)(**ctrl).contrlData);

    // Create new TE with rect
    te = TENew(&itemRect, &itemRect);
    (**ctrl).contrlData = (Handle)te;

    // Set up view and dest rects
    (**te).destRect = itemRect;
    (**te).viewRect = itemRect;

    TEActivate(te);

    // Convert to local coordinates
    GlobalToLocal(&itemRect.topLeft);

    (**ctrl).contrlValue = -1;
}
```

### Function 0x0372 - Handle Key in TextEdit
```asm
0372: LINK       A6,#-18              ; frame=18
0376: MOVEM.L    D6/D7/A4,-(SP)
037A: MOVEA.L    8(A6),A4             ; A4 = control

; Get key from event
037E: MOVEA.L    12(A6),A0            ; Event record
0382: MOVE.B     5(A0),D7             ; Key code

; Check for Enter or Return
0386: CMPI.B     #$0003,D7            ; Enter?
038A: BEQ.S      $0392
038C: CMPI.B     #$000D,D7            ; Return?
0390: BNE.S      $03BE

; Enter/Return pressed - check for default
0392: TST.W      168(A4)              ; Has default?
0396: BEQ.S      $03BE                ; No

; Get item and click default button
0398: MOVE.L     A4,-(A7)
039A: MOVE.W     168(A4),-(A7)        ; Item number
039E: PEA        -2(A6)               ; Type
03A2: PEA        -6(A6)               ; Handle
03A6: PEA        -14(A6)              ; Rect
03AA: A98D                            ; _GetDItem

; Simulate button click
03AE: MOVE.W     #$000A,-(A7)         ; 10 ticks
03B2: MOVE.L     -6(A6),-(A7)         ; Button handle
03B6: JSR        466(A5)              ; JT[466] - flash button
...
03BC: BRA.W      $043E                ; Done

; Check if Tab key
03BE: CMPI.B     #$0003,D7            ; Tab?
03C2: BEQ.S      $043C                ; Ignore tabs

; Check control value
03C4: MOVE.W     164(A4),D6           ; Get value
03C8: CMPI.W     #$FFFF,D6            ; Valid?
03CC: BEQ.S      $043C                ; No - skip

; Check for Tab (0x09)
03CE: CMPI.B     #$0009,D7            ; Tab?
03D2: BNE.S      $042A                ; No

; Handle Tab for field switching
03D4: MOVEQ      #2,D7
03D6: MOVEA.B    D6,A7
03D8: MOVEA.L    156(A4),A0           ; Get field list
03DC: MOVEA.L    (A0),A0
03DE: MOVEA.W    (A0),A7              ; Get field count
03E0: BLE.S      $03E4                ; <= 0
03E2: MOVEQ      #1,D7                ; Direction = 1

; Set up for new field
03E4: MOVE.W     #$FFFF,-2(A6)        ; Set -1
03EA: CLR.L      -6(A6)               ; Clear handle

; Get item info
03EE: MOVE.L     A4,-(A7)
03F0: MOVE.W     D7,-(A7)             ; Field number
03F2: PEA        -2(A6)
03F6: PEA        -6(A6)
03FA: PEA        -14(A6)
03FE: A98D                            ; _GetDItem

; Check if valid field
0402: TST.L      -6(A6)
0406: BNE.S      $040A                ; Valid
0408: JSR        418(A5)              ; JT[418] - error

; Check bit 4 of type
040A: BTST       #4,-1(A6)            ; editable?
0410: BEQ.S      $0426                ; No

; Switch to new field
0412: MOVE.W     D7,-(A7)
0414: MOVE.L     A4,-(A7)
0416: JSR        -666(PC)             ; Set active field
041A: MOVE.L     160(A4),(A7)         ; TE handle
041E: JSR        1970(A5)             ; JT[1970] - update
0422: ...
0424: BRA.S      $043C

; Try next field
0426: MOVEA.B    D7,A1
0428: BRA.S      $03D8                ; Loop

; Pass key to TE
042A: CLR.W      -(A7)
042C: MOVE.L     12(A6),-(A7)         ; Event
0430: MOVE.L     160(A4),-(A7)        ; TE handle
0434: JSR        1530(A5)             ; JT[1530] - TEKey

0438: LEA        10(A7),A7

043C: MOVEM.L    (SP)+,D6/D7/A4
0440: UNLK       A6
0442: RTS
```

**C equivalent**:
```c
void handle_textedit_key(ControlHandle ctrl, EventRecord* event) {
    char key = event->message & 0xFF;
    TEHandle te = (TEHandle)(**ctrl).contrlData;

    // Enter/Return - activate default button
    if (key == 0x03 || key == 0x0D) {
        if ((**ctrl).contrlHilite != 0) {
            // Flash default button
            Handle button;
            Rect rect;
            short itemType;

            GetDItem((**ctrl).contrlOwner, (**ctrl).contrlHilite,
                     &itemType, &button, &rect);

            flash_button(button, 10);
            return;
        }
    }

    if ((**ctrl).contrlValue == -1) return;

    // Tab - switch fields
    if (key == 0x09) {
        int direction = (GetFieldCount(ctrl) > 0) ? 1 : 2;
        int nextField = (**ctrl).contrlValue + direction;

        // Find next editable field
        while (1) {
            short itemType;
            Handle handle;
            Rect rect;

            GetDItem((**ctrl).contrlOwner, nextField,
                     &itemType, &handle, &rect);

            if (itemType & 0x10) {  // Editable
                set_active_field(ctrl, nextField);
                update_te(te);
                return;
            }
            nextField++;
        }
    }

    // Pass other keys to TextEdit
    TEKey(key, te);
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3466 | g_te_active - TextEdit active flag |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 466 | Flash button |
| 1530 | TEKey wrapper |
| 1586 | String compare |
| 1602 | GetDItemText |
| 1970 | Update TE |
| 2826 | Create TE |
| 2986 | TE internal 1 |
| 2994 | TE internal 2 |
| 3002 | TE cleanup |
| 3010 | TE setup |

## Control Structure Offsets

| Offset | Size | Field |
|--------|------|-------|
| 24 | 4 | contrlOwner (window) |
| 156 | 4 | Field list handle |
| 160 | 4 | contrlData (TE handle) |
| 164 | 2 | contrlValue |
| 168 | 2 | contrlHilite |

## Confidence: HIGH

Standard Mac Toolbox TextEdit patterns:
- GetDItem for dialog item access
- TEKey for text input
- Tab key field switching
- Enter/Return for default button
