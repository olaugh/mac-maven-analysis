# CODE 48 Detailed Analysis - TextEdit Control Manager

## Overview

| Property | Value |
|----------|-------|
| Size | 1092 bytes |
| JT Offset | 3192 |
| JT Entries | 15 |
| Functions | 14 |
| Purpose | **TextEdit (TE) control management for dialogs** |

## System Role

**Category**: User Interface
**Function**: Text Input Handling

Manages TextEdit records within dialog controls for text input fields.

**Related CODE resources**:
- CODE 46 (Window management)
- CODE 49 (Clipboard for cut/copy/paste)

## Mac Toolbox TextEdit Traps

| Trap | Name | Purpose |
|------|------|---------|
| A873 | GlobalToLocal | Convert coordinates |
| A874 | GetPort | Get graphics port |
| A89B | ScrollRect | Scroll rectangle |
| A89C | TextSize | Set text size |
| A89E | PenSize | Set pen size |
| A8A3 | InsetRect | Inset rectangle |
| A8A8 | OffsetRect | Offset rectangle |
| A8A9 | InsetRect | Inset rectangle |
| A8B0 | EraseRect | Erase rectangle |
| A98D | GetDItem | Get dialog item |
| A9C8 | TEIdle | TextEdit idle (cursor blink) |
| A9D0 | TEActivate | Activate TE record |
| A9D1 | TEDeactivate | Deactivate TE record |
| A9D2 | TEKey | Handle key in TE |
| A9D3 | TECut | Cut to clipboard |
| A9D4 | TECopy | Copy to clipboard |
| A9D8 | TEPaste | Paste from clipboard |
| A9D9 | TEDelete | Delete selection |
| A9DA | TEDispose | Dispose TE record |

## Key Functions

### Function 0x0000 - TEIdle Loop
**Purpose**: Call TEIdle multiple times for cursor blinking

```asm
0000: LINK       A6,#0
0004: BRA.S      $000C                ; Enter loop

0006: MOVE.W     #$0001,-(A7)         ; flag = 1
000A: A9C8                            ; _TEIdle

000C: MOVE.W     8(A6),D0             ; count
; ... decrement
0016: BNE.S      $0006                ; Loop until 0

0018: UNLK       A6
001A: RTS
```

### Function 0x001C - Activate TextEdit Control
**Purpose**: Activate TE and set global flag

```asm
001C: LINK       A6,#0
0020: MOVE.L     8(A6),-(A7)          ; TE handle
0024: JSR        3010(A5)             ; internal_te_setup
0028: MOVE.W     #$0001,-3466(A5)     ; g_te_active = 1
002E: UNLK       A6
0030: RTS
```

### Function 0x0032 - Deactivate TextEdit Control
**Purpose**: Deactivate TE and set global flag

```asm
0032: LINK       A6,#0
0036: MOVE.L     8(A6),-(A7)
003A: JSR        3002(A5)             ; internal_te_cleanup
003E: MOVE.W     #$0001,-3466(A5)     ; g_te_active = 1
0044: UNLK       A6
0046: RTS
```

### Function 0x007C - TEDispose Wrapper
**Purpose**: Safely dispose TE record if valid

```asm
007C: LINK       A6,#0
0080: MOVEA.L    8(A6),A0             ; control handle
0084: CMPI.W     #$FFFF,164(A0)       ; contrlValue == -1?
008A: BEQ.S      $0096                ; Invalid - skip

008C: MOVEA.L    8(A6),A0
0090: MOVE.L     160(A0),-(A7)        ; contrlData = TE handle
0094: A9DA                            ; _TEDispose

0096: MOVEQ      #0,D0
009A: UNLK       A6
009C: RTS
```

### Function 0x00D8 - Draw TextEdit Frame
**Purpose**: Draw 3D inset frame around text field

```asm
00D8: LINK       A6,#-18
00DC: MOVE.L     A4,-(A7)
00DE: MOVEA.L    8(A6),A4             ; control

; Get item rectangle
00F0: MOVE.L     A4,-(A7)
00F2: MOVE.W     168(A4),-(A7)        ; contrlHilite = item number
00F6: PEA        -2(A6)               ; &itemType
00FA: PEA        -6(A6)               ; &itemHandle
00FE: PEA        -14(A6)              ; &itemRect
0102: A98D                            ; _GetDItem

; Check if editText type (4)
0106: CMPI.W     #$0004,-2(A6)
010A: BNE.S      $012E                ; Not text - skip

; Draw 3D inset effect
010C: MOVE.L     #$00030003,-(A7)     ; Inset(3,3)
0112: A89B                            ; _ScrollRect

0114: PEA        -14(A6)
0118: MOVE.L     #$FFFCFFFC,-(A7)     ; Inset(-4,-4) - expand
011E: A8A9                            ; _InsetRect

0122: PEA        -14(A6)
0126: MOVE.L     #$00100010,-(A7)     ; Offset(16,16)
012A: A8B0                            ; _EraseRect
012C: A89E                            ; _PenSize

012E: MOVEA.L    (A7)+,A4
0130: UNLK       A6
0132: RTS
```

### Function 0x0134 - Set TextEdit Text (Compare First)
**Purpose**: Set text only if different from current

```asm
0134: LINK       A6,#-256             ; 255-char buffer

; Get current text
0138: PEA        -256(A6)             ; buffer
013C: MOVE.W     12(A6),-(A7)         ; item ID
0140: MOVE.L     8(A6),-(A7)          ; dialog
0144: JSR        1602(A5)             ; GetDItemText

; Compare with new text
0148: MOVE.L     14(A6),(A7)          ; new text
014C: PEA        -256(A6)             ; current text
0150: PEA        -256(A6)
0154: JSR        1586(A5)             ; string_compare

0158: TST.W      D0
015E: BEQ.S      $017A                ; Same - don't update

; Different - update text
0160: MOVE.W     #$000F,-(A7)         ; max = 15
0164: A9C8                            ; _TEIdle
0166: PEA        -256(A6)
016E: MOVE.L     8(A6),-(A7)
0172: JSR        306(PC)              ; set_text
0176: LEA        10(A7),A7

017A: UNLK       A6
017C: RTS
```

### Function 0x01A2 - Initialize TextEdit Control
**Purpose**: Create new TE record for dialog item

```asm
01A2: LINK       A6,#-20
01A6: MOVE.L     A4,-(A7)
01A8: MOVEA.L    8(A6),A4             ; control

; Get dialog item info
01AC: MOVE.L     A4,-(A7)
01AE: MOVE.W     12(A6),-(A7)         ; item number
01B2: PEA        -2(A6)               ; &type
01B6: PEA        -6(A6)               ; &handle
01BA: PEA        -14(A6)              ; &rect
01BE: A98D                            ; _GetDItem

; Delete existing TE
01C2: MOVE.L     160(A4),-(A7)        ; old TE handle
01C6: A9D9                            ; _TEDelete

; Create new TE record
01D2: CLR.L      -(A7)                ; NULL
01D4: MOVE.L     -6(A6),-(A7)         ; destRect from handle
01D8: JSR        2826(A5)             ; JT - create TE

; Store in control
01E4: MOVE.W     D0,60(A0)            ; TE handle low word

; Set up rectangles
01EE: MOVEA.L    160(A4),A0
01F2: MOVEA.L    (A0),A0              ; dereference TE
01F4: MOVE.L     -14(A6),(A0)         ; destRect.topLeft
01F8: MOVE.L     -10(A6),4(A0)        ; destRect.botRight

; Copy to viewRect
01FE: MOVE.L     (A0),8(A1)           ; viewRect.topLeft
0202: MOVE.L     4(A0),12(A1)         ; viewRect.botRight

; Activate the TE
0208: MOVE.L     160(A4),-(A7)
020C: A9D0                            ; _TEActivate

; Additional setup
020E: MOVE.L     160(A4),-(A7)
0212: A9D8                            ; _TEPaste (initialize)

; Mark control as initialized
024E: MOVEQ      #-1,D0
0252: MOVE.W     D0,164(A4)           ; contrlValue = -1

0254: MOVEA.L    (A7)+,A4
0256: UNLK       A6
0258: RTS
```

### Function 0x0372 - Handle Key in TextEdit
**Purpose**: Process keyboard events for text controls

```asm
0372: LINK       A6,#-18
0376: MOVEM.L    D6/D7/A4,-(SP)
037A: MOVEA.L    8(A6),A4             ; control

; Get key code from event
037E: MOVEA.L    12(A6),A0            ; EventRecord*
0382: MOVE.B     5(A0),D7             ; message low byte = key

; Check for Enter (0x03) or Return (0x0D)
0386: CMPI.B     #$0003,D7
038A: BEQ.S      $0392
038C: CMPI.B     #$000D,D7
0390: BNE.S      $03BE

; Enter/Return - flash default button if set
0392: TST.W      168(A4)              ; contrlHilite = default item
0396: BEQ.S      $03BE                ; No default

; Get default button and flash it
0398: MOVE.L     A4,-(A7)
039A: MOVE.W     168(A4),-(A7)        ; item number
039E: PEA        -2(A6)               ; &type
03A2: PEA        -6(A6)               ; &handle
03A6: PEA        -14(A6)              ; &rect
03AA: A98D                            ; _GetDItem

03AE: MOVE.W     #$000A,-(A7)         ; delay = 10 ticks
03B2: MOVE.L     -6(A6),-(A7)         ; button handle
03B6: JSR        466(A5)              ; flash_button
03BC: BRA.W      $043E                ; Done

; Check for Tab (0x09)
03CE: CMPI.B     #$0009,D7
03D2: BNE.S      $042A                ; Not Tab

; Tab key - switch fields
03D4: MOVEQ      #2,D7                ; direction = forward
03D6: ADD.W      D6,D7                ; next field
03D8: MOVEA.L    156(A4),A0           ; field list handle
03DC: MOVEA.L    (A0),A0
03DE: CMP.W      (A0),D7              ; compare with field count
03E0: BLE.S      $03E4
03E2: MOVEQ      #1,D7                ; wrap to field 1

; Loop to find next editable field
03E4: MOVE.W     #$FFFF,-2(A6)        ; type = -1
03EA: CLR.L      -6(A6)               ; handle = NULL

03EE: MOVE.L     A4,-(A7)
03F0: MOVE.W     D7,-(A7)             ; field number
03F2: PEA        -2(A6)
03F6: PEA        -6(A6)
03FA: PEA        -14(A6)
03FE: A98D                            ; _GetDItem

; Check if field exists
0402: TST.L      -6(A6)
0406: BNE.S      $040A
0408: JSR        418(A5)              ; error - no such item

; Check if editable (bit 4 of itemType)
040A: BTST       #4,-1(A6)
0410: BEQ.S      $0426                ; Not editable - try next

; Found editable field - switch to it
0412: MOVE.W     D7,-(A7)
0414: MOVE.L     A4,-(A7)
0416: JSR        -666(PC)             ; set_active_field
041A: MOVE.L     160(A4),(A7)
041E: JSR        1970(A5)             ; update_te
0424: BRA.S      $043C

; Try next field
0426: ADDQ.W     #1,D7
0428: BRA.S      $03D8

; Not Tab - pass key to TextEdit
042A: CLR.W      -(A7)                ; modifiers = 0
042C: MOVE.L     12(A6),-(A7)         ; event
0430: MOVE.L     160(A4),-(A7)        ; TE handle
0434: JSR        1530(A5)             ; TEKey wrapper

0438: LEA        10(A7),A7

043C: MOVEM.L    (SP)+,D6/D7/A4
0440: UNLK       A6
0442: RTS
```

**Key handling summary**:
| Key | Action |
|-----|--------|
| Enter (0x03) | Flash and activate default button |
| Return (0x0D) | Flash and activate default button |
| Tab (0x09) | Move to next editable field |
| Other | Pass to TEKey for normal editing |

## Control Structure Offsets

| Offset | Size | Field | Purpose |
|--------|------|-------|---------|
| 24 | 4 | contrlOwner | Owner window/dialog |
| 156 | 4 | field list | Handle to field array |
| 160 | 4 | contrlData | TE record handle |
| 164 | 2 | contrlValue | -1 when initialized |
| 168 | 2 | contrlHilite | Default button item # |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3466 | g_te_active - TextEdit active flag |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 466 | Flash button (for default button) |
| 1530 | TEKey wrapper |
| 1586 | String compare |
| 1602 | GetDItemText |
| 1970 | Update TE display |
| 2826 | Create TE record |
| 2986 | TE internal function 1 |
| 2994 | TE internal function 2 |
| 3002 | TE cleanup handler |
| 3010 | TE setup handler |

## Dialog Item Types

| Value | Type | Editable |
|-------|------|----------|
| 4 | editText | Yes |
| 5 | statText | No |
| 6 | iconItem | No |
| 7 | picItem | No |

Bit 4 (0x10) in itemType indicates the field is editable.

## Confidence: HIGH

Standard Mac Toolbox TextEdit/Dialog patterns:
- GetDItem for dialog item access
- TEKey for text input
- Tab field navigation
- Enter/Return for default button
- Proper TE record lifecycle management

---

## Speculative C Translation

### Data Structures

```c
/* Extended control structure for TextEdit management */
typedef struct TEControlData {
    ControlRecord base;        /* 0-155: Standard ControlRecord */
    Handle field_list_handle;  /* 156: Handle to array of field items */
    TEHandle te_handle;        /* 160: TextEdit record handle (contrlData) */
    short control_value;       /* 164: -1 when properly initialized */
    short default_button_item; /* 168: Item number for default button */
} TEControlData;

/* Global state */
short g_te_active;             /* A5-3466: TextEdit activity flag */
```

### Function 0x0000 - TEIdle Loop

```c
/*
 * te_idle_loop - Call TEIdle multiple times for cursor blinking
 *
 * Used to ensure cursor blinks during idle processing.
 * Multiple calls may be needed if system was busy.
 *
 * @param iteration_count: Number of times to call TEIdle
 */
void te_idle_loop(short iteration_count) {
    while (iteration_count > 0) {
        TEIdle(/* te_handle from current context */);
        iteration_count--;
    }
}
```

### Function 0x001C - Activate TextEdit Control

```c
/*
 * te_control_activate - Activate a TextEdit control for input
 *
 * Sets up the TE record for receiving keyboard input.
 *
 * @param te_handle: Handle to TextEdit record
 */
void te_control_activate(TEHandle te_handle) {
    /* Internal setup via jump table */
    internal_te_setup(te_handle);

    /* Set global active flag */
    g_te_active = 1;
}
```

### Function 0x0032 - Deactivate TextEdit Control

```c
/*
 * te_control_deactivate - Deactivate a TextEdit control
 *
 * Removes focus from the TE record.
 *
 * @param te_handle: Handle to TextEdit record
 */
void te_control_deactivate(TEHandle te_handle) {
    /* Internal cleanup via jump table */
    internal_te_cleanup(te_handle);

    /* Set global flag (note: still sets to 1, not 0) */
    /* uncertain: seems like this should clear the flag */
    g_te_active = 1;
}
```

### Function 0x007C - Safe TEDispose

```c
/*
 * te_safe_dispose - Dispose TE record if valid
 *
 * Checks the control value before disposing to avoid disposing
 * an already-disposed or uninitialized record.
 *
 * @param control_ptr: Pointer to control with embedded TE
 */
void te_safe_dispose(TEControlData *control_ptr) {
    /* Check if control was properly initialized (-1 means valid) */
    if (control_ptr->control_value != -1) {
        return;  /* Already disposed or never initialized */
    }

    /* Dispose the TextEdit record */
    TEDispose(control_ptr->te_handle);
}
```

### Function 0x00D8 - Draw TextEdit Frame

```c
/*
 * te_draw_frame - Draw 3D inset frame around text field
 *
 * Creates the standard Mac OS appearance for edit fields.
 *
 * @param control_ptr: Control containing the text field
 */
void te_draw_frame(TEControlData *control_ptr) {
    short item_type;
    Handle item_handle;
    Rect item_rect;
    Rect draw_rect;

    /* Get the dialog item information */
    GetDItem(control_ptr->base.contrlOwner,
             control_ptr->default_button_item,  /* uncertain: item source */
             &item_type, &item_handle, &item_rect);

    /* Only draw frame for editText items (type 4) */
    if (item_type != 4) {
        return;
    }

    /* Create 3D inset effect */
    draw_rect = item_rect;

    /* Inset for shadow border */
    InsetRect(&draw_rect, 3, 3);

    /* Expand back out for full frame */
    InsetRect(&draw_rect, -4, -4);

    /* Erase and redraw */
    /* uncertain: exact QuickDraw sequence */
    EraseRect(&draw_rect);
    PenSize(1, 1);
    FrameRect(&draw_rect);
}
```

### Function 0x0134 - Set Text if Different

```c
/*
 * te_set_text_if_changed - Update text field only if content differs
 *
 * Avoids unnecessary redraw by comparing first.
 *
 * @param dialog_ptr: Dialog containing the text field
 * @param item_number: Dialog item number
 * @param new_text: New text to set (Pascal string)
 */
void te_set_text_if_changed(DialogPtr dialog_ptr, short item_number,
                            StringPtr new_text) {
    Str255 current_text;

    /* Get current text from dialog item */
    GetDItemText(dialog_ptr, item_number, current_text);

    /* Compare with new text */
    if (string_compare(current_text, new_text) == 0) {
        return;  /* Same content - no update needed */
    }

    /* Different content - update with cursor blink */
    TEIdle(/* current TE */);  /* Ensure cursor state is clean */

    /* Set the new text */
    te_set_item_text(dialog_ptr, item_number, new_text);
}
```

### Function 0x01A2 - Initialize TextEdit Control

```c
/*
 * te_init_control - Create and initialize a TextEdit control
 *
 * Creates a new TE record for a dialog edit item, setting up
 * the destination and view rectangles.
 *
 * @param control_ptr: Control to initialize
 * @param item_number: Dialog item number for bounds
 */
void te_init_control(TEControlData *control_ptr, short item_number) {
    short item_type;
    Handle item_handle;
    Rect item_rect;
    TEHandle old_te;
    TEHandle new_te;
    TEPtr te_ptr;

    /* Get dialog item bounds */
    GetDItem(control_ptr->base.contrlOwner, item_number,
             &item_type, &item_handle, &item_rect);

    /* Clean up any existing TE record */
    old_te = control_ptr->te_handle;
    if (old_te != NULL) {
        TEDelete(old_te);  /* uncertain: might be TEDispose */
    }

    /* Create new TextEdit record */
    /* uncertain: exact parameters for TE creation */
    new_te = create_te_record(NULL, item_handle);

    /* Store handle in control */
    control_ptr->te_handle = new_te;

    /* Set up destination rectangle */
    te_ptr = *new_te;
    te_ptr->destRect = item_rect;

    /* View rectangle matches destination */
    te_ptr->viewRect = te_ptr->destRect;

    /* Activate for immediate use */
    TEActivate(new_te);

    /* Initialize with any clipboard content */
    /* uncertain: TEPaste here seems odd - may be initialization */
    TEPaste(new_te);

    /* Mark as properly initialized */
    control_ptr->control_value = -1;
}
```

### Function 0x0372 - Handle Keyboard Events

```c
/*
 * te_handle_key - Process keyboard events for TextEdit control
 *
 * Handles special keys (Tab, Enter, Return) and passes others to TE.
 *
 * @param control_ptr: Control receiving keyboard input
 * @param event_ptr: EventRecord with key information
 */
void te_handle_key(TEControlData *control_ptr, EventRecord *event_ptr) {
    char key_char;
    short item_type;
    Handle item_handle;
    Rect item_rect;
    short current_field;
    short next_field;
    short field_count;
    Handle field_list;

    /* Extract key character from event message */
    key_char = (char)(event_ptr->message & charCodeMask);

    /* Check for Enter (0x03) or Return (0x0D) - activate default button */
    if (key_char == 0x03 || key_char == 0x0D) {
        /* Only if default button is set */
        if (control_ptr->default_button_item != 0) {
            /* Get the default button */
            GetDItem(control_ptr->base.contrlOwner,
                     control_ptr->default_button_item,
                     &item_type, &item_handle, &item_rect);

            /* Flash the button (10 tick delay) */
            flash_button(item_handle, 10);
            return;
        }
        /* No default button - fall through to normal handling */
    }

    /* Check for Tab (0x09) - field navigation */
    if (key_char == 0x09) {
        /* Get field list to determine navigation */
        field_list = control_ptr->field_list_handle;
        field_count = **(short**)field_list;

        /* Calculate next field (uncertain: current_field source) */
        next_field = current_field + 2;  /* Move forward */

        /* Wrap around if past end */
        if (next_field > field_count) {
            next_field = 1;
        }

        /* Find next editable field */
        while (1) {
            /* Get item info for candidate field */
            GetDItem(control_ptr->base.contrlOwner, next_field,
                     &item_type, &item_handle, &item_rect);

            /* Check if item exists */
            if (item_handle == NULL) {
                error_handler();  /* JT[418] */
                return;
            }

            /* Check if editable (bit 4 = 0x10 set) */
            if (item_type & 0x10) {
                /* Found editable field - switch to it */
                set_active_field(control_ptr, next_field);
                update_te_display(control_ptr->te_handle);
                return;
            }

            /* Try next field */
            next_field++;
        }
    }

    /* Regular key - pass to TextEdit */
    te_key_wrapper(control_ptr->te_handle, event_ptr, 0);
}
```

### Function 0x0258 - Set Text from Handle

```c
/*
 * te_set_text_from_handle - Set control text from a text handle
 *
 * Copies text from a handle into the dialog item's TextEdit record.
 *
 * @param dialog_ptr: Dialog containing the item
 * @param item_number: Item to update
 * @param text_handle: Handle containing the text
 */
void te_set_text_from_handle(DialogPtr dialog_ptr, short item_number,
                             Handle text_handle) {
    char text_buffer[32000];  /* Large stack buffer */
    long text_size;

    /* Handle NULL gracefully */
    if (text_handle == NULL) {
        text_buffer[0] = '\0';
    } else {
        /* Lock handle and copy text */
        HLock(text_handle);
        text_size = GetHandleSize(text_handle);

        /* Copy to local buffer */
        BlockMove(*text_handle, text_buffer, text_size);
        text_buffer[text_size] = '\0';  /* Null terminate */

        HUnlock(text_handle);
    }

    /* Set the text in the control */
    te_set_text_internal(dialog_ptr, item_number, text_buffer);
}
```

### Function 0x02F0 - Handle Click in TextEdit

```c
/*
 * te_handle_click - Process mouse clicks in TextEdit area
 *
 * Handles selection, cursor positioning, and double-click word selection.
 *
 * @param control_ptr: Control that was clicked
 * @param event_ptr: EventRecord with click location and modifiers
 */
void te_handle_click(TEControlData *control_ptr, EventRecord *event_ptr) {
    Rect port_rect;
    Point click_point;
    short item_number;
    short item_type;
    Handle item_handle;
    Rect item_rect;

    /* Get current port bounds */
    GetPort(&port_rect);

    /* Convert click to local coordinates */
    click_point = event_ptr->where;
    GlobalToLocal(&click_point);

    /* Get item at click location */
    item_number = FindDItem(control_ptr->base.contrlOwner, click_point);

    if (item_number == -1) {
        return;  /* Click outside all items */
    }

    item_number++;  /* FindDItem returns 0-based */

    /* Get item info */
    GetDItem(control_ptr->base.contrlOwner, item_number,
             &item_type, &item_handle, &item_rect);

    /* Check for shift-click (extend selection) */
    Boolean extend_selection = (event_ptr->modifiers & shiftKey) != 0;

    /* Pass click to TextEdit */
    TEClick(click_point, extend_selection, control_ptr->te_handle);
}
```

### Key Character Constants

```c
/* Special key codes handled by te_handle_key */
#define KEY_ENTER   0x03    /* Enter key (numpad) */
#define KEY_TAB     0x09    /* Tab key (field navigation) */
#define KEY_RETURN  0x0D    /* Return key (default button) */

/* Dialog item types */
#define kEditTextItem  4    /* Editable text field */
#define kStatTextItem  5    /* Static text (non-editable) */
#define kIconItem      6    /* Icon item */
#define kPictItem      7    /* Picture item */

/* Item type flags */
#define kItemDisabledFlag  0x80  /* Item is disabled */
#define kEditableFlag      0x10  /* Item accepts keyboard input */
```

### TextEdit Control Lifecycle

```
1. Dialog Creation
   |
   v
2. te_init_control() - Create TE record
   |
   v
3. te_control_activate() - Make TE active
   |
   +---> te_handle_key() - Process keyboard
   |     te_handle_click() - Process mouse
   |     te_idle_loop() - Cursor blink
   |
   v
4. te_control_deactivate() - Remove focus
   |
   v
5. te_safe_dispose() - Clean up TE record
```
