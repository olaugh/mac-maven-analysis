# CODE 6 Detailed Analysis - Window & Display Management

## Overview

| Property | Value |
|----------|-------|
| Size | 1026 bytes |
| JT Offset | 168 |
| JT Entries | 7 |
| Functions | 10 |
| Purpose | **Window management, display updates, player switching** |

## Architecture Role

CODE 6 handles window/display operations:
1. Buffer pointer management for h/v directions
2. Window initialization and drawing
3. Player turn switching
4. Display refresh

## Key Functions

### Function 0x0000 - Update Display Pointers
```asm
0000: MOVEA.L    -8584(A5),A0         ; A0 = handle
0004: MOVEA.L    (A0),A0              ; A0 = *handle
0006: MOVE.W     770(A0),D0           ; D0 = direction flag (field 770)
000A: BEQ.S      $001A                ; If 0, use horizontal
000C: BMI.S      $0060                ; If negative, error
000E: CMPI.W     #1,D0                ; Compare with 1
0010: BEQ.S      $003E                ; If 1, use vertical variant
0012: CMPI.W     #2,D0                ; Compare with 2
0016: BEQ.S      $002C                ; If 2, use horizontal variant
0018: BRA.S      $002C

; Direction 0: Horizontal
001A: MOVE.L     -8596(A5),-11960(A5) ; Copy ptr1
0020: MOVE.L     -8588(A5),-11956(A5) ; Copy ptr2
0026: CLR.L      -11948(A5)           ; Clear extra ptr
002A: BRA.S      $0060

; Direction 2: Horizontal with second buffer
002C: MOVE.L     -8600(A5),-11960(A5)
0032: MOVE.L     -8592(A5),-11956(A5)
0038: CLR.L      -11948(A5)
003C: BRA.S      $0060

; Direction 1: Vertical (both buffers)
003E: MOVE.L     -8596(A5),-11960(A5)
0044: MOVE.L     -8588(A5),-11956(A5)
004A: MOVE.L     -8600(A5),-11952(A5)
0050: MOVE.L     -8592(A5),-11948(A5)
0056: CLR.L      -11940(A5)
005C: JSR        418(A5)              ; bounds_check
0060: RTS
```

**C equivalent**:
```c
void update_display_pointers(void) {
    Handle h = g_main_handle;
    int direction = (*h)->direction;  // offset 770

    switch (direction) {
    case 0:  // Horizontal only
        g_display_ptr1 = g_ptr1;      // A5-11960 = A5-8596
        g_display_ptr2 = g_ptr2;      // A5-11956 = A5-8588
        g_display_ptr3 = NULL;
        break;
    case 2:  // Horizontal alternate
        g_display_ptr1 = g_ptr3;      // A5-8600
        g_display_ptr2 = g_ptr4;      // A5-8592
        g_display_ptr3 = NULL;
        break;
    case 1:  // Both directions
        g_display_ptr1 = g_ptr1;
        g_display_ptr2 = g_ptr2;
        g_display_ptr3 = g_ptr3;
        g_display_ptr4 = g_ptr4;
        g_display_ptr5 = NULL;
        break;
    default:
        error();
    }
}
```

### Function 0x0062 - Initialize Game Window
```asm
0062: LINK       A6,#-258             ; 258 bytes local
0066: MOVEM.L    D6/D7/A4,-(SP)
006A: JSR        722(PC)              ; Check something
006E: TST.W      D0
0070: BNE.W      $0128                ; If true, skip init

0074: JSR        578(PC)              ; Setup call
0078: CLR.B      -256(A6)             ; Clear string buffer

; Get string from resource
007C: MOVE.L     #$00020000,-(A7)     ; Resource type/ID
0082: MOVE.W     #$03FA,-(A7)         ; String ID 1018
0086: PEA        -256(A6)             ; Destination
008A: JSR        122(A5)              ; JT[122] - GetIndString

; Get another string
0096: MOVE.L     #$00020001,-(A7)     ; Resource type/ID
00A0: MOVE.W     #$03F9,-(A7)         ; String ID 1017
00A4: PEA        -256(A6)
00A8: JSR        122(A5)

; Parse numeric value from string
00AC: PEA        -258(A6)             ; Result
00B0: PEA        -28510(A5)           ; Format string
00B4: PEA        -256(A6)             ; Input
00B8: JSR        2074(A5)             ; JT[2074] - sscanf

; Check time limit range
00BE: MOVEQ      #1,D7                ; Default = 1
00C0: CMPI.W     #700,-258(A6)        ; If value < 700 (0x2BC)
00C8: BGE.S      $00D4
00CA: MOVE.W     #700,-258(A6)        ; Clamp to 700
00D0: MOVEQ      #18,D7               ; Flag = 18
00D2: BRA.S      $00E2
00D4: CMPI.W     #2100,-258(A6)       ; If value > 2100 (0x834)
00DC: BLE.S      $00E2
00DC: MOVE.W     #2100,-258(A6)       ; Clamp to 2100

; Set up window controls
00E2: MOVEQ      #4,D6                ; Start at control 4
00E4: BRA.S      $010C
00E6: MOVE.W     #192,D0              ; 0xC0
00EA: MULS.W     D6,D0                ; Offset = 192 * index
00EC: MOVEA.L    D0,A4
00EE: MOVEA.L    -8584(A5),A0
00F2: MOVE.L     (A0),D0
00F4: MOVE.W     D7,10(A4,D0.L)       ; Set control value
00F8: ... (more setup) ...
010A: DBF        D6,$00E6             ; Loop for all controls

; Display window
0116: PEA        -28506(A5)           ; Rect?
011A: JSR        696(PC)              ; Draw something
011E: MOVE.L     -8584(A5),(A7)
0122: A9AA                            ; HUnlock
0124: CLR.W      -(A7)
0126: A994                            ; ShowWindow
0128: ... check and show if needed ...
0142: MOVEM.L    (SP)+,...
0146: UNLK       A6
0148: RTS
```

### Function 0x020E - Toggle Active Buffer
```asm
020E: MOVEA.L    -8584(A5),A0         ; Get handle
0212: MOVEA.L    (A0),A0              ; Dereference
0214: TST.W      772(A0)              ; Check flag at offset 772
0218: BNE.S      $022E                ; If set, use field_14

; Currently using field_14, switch to field_22
021A: LEA        -15522(A5),A0        ; A0 = &g_field_22
021E: MOVE.L     A0,-15498(A5)        ; g_current_ptr = g_field_22
0222: MOVEA.L    -8584(A5),A1
0226: MOVEA.L    (A1),A1
0228: CLR.W      772(A1)              ; Clear flag
022C: BRA.S      $0242

; Currently using field_22, switch to field_14
022E: LEA        -15514(A5),A0        ; A0 = &g_field_14
0232: MOVE.L     A0,-15498(A5)        ; g_current_ptr = g_field_14
0236: MOVEA.L    -8584(A5),A1
023A: MOVEA.L    (A1),A1
023C: MOVE.W     #$0001,772(A1)       ; Set flag
0242: RTS
```

**C equivalent**:
```c
void toggle_active_buffer(void) {
    Handle h = g_main_handle;

    if ((*h)->direction_flag) {
        // Switch to field_22
        g_current_ptr = &g_field_22;
        (*h)->direction_flag = 0;
    } else {
        // Switch to field_14
        g_current_ptr = &g_field_14;
        (*h)->direction_flag = 1;
    }
}
```

### Function 0x02B8 - Create Main Window
```asm
02B8: MOVE.L     #$0000042E,D0        ; Size = 1070 bytes
02BE: A322                            ; NewHandle
02C0: MOVE.L     A0,-8584(A5)         ; Store handle
02C4: MOVE.L     A0,D0
02C6: BNE.S      $02EE                ; If allocated, continue

; Allocation failed
02C8: MOVE.L     -27736(A5),-24030(A5)
... error handling ...

; Setup handle fields
02EE: MOVEA.L    -8584(A5),A0
02F2: MOVEA.L    (A0),A0
02F4: MOVE.W     #$0001,780(A0)       ; Set flag at offset 780
...
030C: MOVE.W     #$0001,778(A0)
...
0318: MOVE.W     #$0001,784(A0)

; Create window
031E: MOVE.L     -8584(A5),-(A7)      ; Push handle
0322: MOVE.L     #'prfs',-(A7)        ; 'prfs' resource type
0328: CLR.W      -(A7)
032A: MOVE.L     -3512(A5),-(A7)      ; Resource reference
032E: A9AB                            ; GetNewWindow
...
033A: A999                            ; SelectWindow
033E: RTS
```

### Function 0x038A - Toggle Window Visibility
```asm
038A: MOVEA.L    -8584(A5),A0
038E: MOVEA.L    (A0),A0
0390: TST.W      780(A0)              ; Check visibility flag
0394: SEQ        D0                   ; D0 = (flag == 0) ? 0xFF : 0
0396: NEG.B      D0                   ; D0 = (flag == 0) ? 1 : 0
0398: EXT.W      D0
039A: MOVEA.L    -8584(A5),A0
039E: MOVEA.L    (A0),A0
03A0: MOVE.W     D0,780(A0)           ; Toggle flag
03A4: JSR        1266(A5)             ; JT[1266] - redraw?
03A8: RTS
```

## Window Data Structure (at handle offset)

| Offset | Size | Purpose |
|--------|------|---------|
| 770 | 2 | Direction flag (0/1/2) |
| 772 | 2 | Buffer selection flag |
| 778 | 2 | UI flag 1 |
| 780 | 2 | Visibility flag |
| 782 | 2 | UI flag 2 |
| 784 | 2 | UI flag 3 |
| 786 | var | Rack data (17 bytes) |
| 814 | var | More data |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-8584 | Main window handle |
| A5-8588 | Pointer 1 |
| A5-8592 | Pointer 2 |
| A5-8596 | Pointer 3 |
| A5-8600 | Pointer 4 |
| A5-11940 | Display pointer 5 |
| A5-11948 | Display pointer 4 |
| A5-11952 | Display pointer 3 |
| A5-11956 | Display pointer 2 |
| A5-11960 | Display pointer 1 |
| A5-15498 | g_current_ptr |
| A5-15514 | g_field_14 |
| A5-15522 | g_field_22 |

## Toolbox Traps Used

| Trap | Purpose |
|------|---------|
| A322 | NewHandle |
| A873 | GetPort |
| A922 | SetPort |
| A9AA | HUnlock |
| A9AB | GetNewWindow |
| A994 | ShowWindow |
| A999 | SelectWindow |

## Confidence: HIGH

Clear window management patterns:
- Handle allocation and management
- Buffer pointer switching
- Window creation and display
- Standard Mac Toolbox calls
