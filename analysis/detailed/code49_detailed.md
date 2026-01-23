# CODE 49 Detailed Analysis - Clipboard/Scrap Manager

## Overview

| Property | Value |
|----------|-------|
| Size | 546 bytes |
| JT Offset | 3312 |
| JT Entries | 2 |
| Functions | 3 |
| Purpose | **Clipboard (scrap) management, copy/paste support** |

## Architecture Role

CODE 49 provides clipboard functionality:
1. Find scrap data by type
2. Get scrap content for specific types
3. Put data into scrap
4. Manage scrap resource handles

## Mac Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| A122 | NewHandle | Allocate memory handle |
| A9A0 | GetScrap | Get scrap data |
| A9A3 | ZeroScrap | Clear scrap |
| A994 | InfoScrap | Get scrap info |
| A999 | UnloadScrap | Unload scrap from memory |
| A9AA | PutScrap | Put data into scrap |
| A9AB | AddResource | Add to resource file |

## Key Functions

### Function 0x0000 - Find Scrap By Type
```asm
0000: LINK       A6,#-16              ; frame=16
0004: MOVEM.L    D7/A4,-(SP)

; Get window placement rect
0008: MOVE.L     -1450(A5),-16(A6)    ; g_window_rect top-left
000E: MOVE.L     -1446(A5),-12(A6)    ; g_window_rect bottom-right

; Search for scrap of type
0014: MOVEQ      #0,D7                ; Index = 0
0016: BRA.S      $0056                ; Start search

; Check current scrap entry
0018: MOVEA.L    (A4),A0              ; Dereference handle
001A: MOVE.L     (A0),-8(A6)          ; Get bounds
001E: MOVE.L     4(A0),-4(A6)

; Compare bounds with window
0024: MOVE.W     -8(A6),D0            ; top
0028: MOVEA.W    -16(A6),A0           ; Compare with window
002C: BNE.S      $0050                ; Not equal - next

002E: MOVE.W     -4(A6),D0            ; bottom
0032: MOVEA.W    -12(A6),A0
0036: BNE.S      $0050                ; Not equal - next

0038: MOVE.W     -6(A6),D0            ; left
003C: MOVEA.W    -14(A6),A0
0040: BNE.S      $0050                ; Not equal - next

0042: MOVE.W     -2(A6),D0            ; right
0046: MOVEA.W    -10(A6),A0
004A: BNE.S      $0050                ; Not equal - next

; Found matching scrap
004C: MOVE.L     A4,D0                ; Return handle
004E: BRA.S      $00B0

; Next entry
0050: MOVE.L     A4,-(A7)
0052: A9A3                            ; _ZeroScrap (release)
0054: MOVEA.B    D7,A1                ; Next index

; Get next scrap by type
0056: CLR.L      -(A7)                ; Offset = 0
0058: MOVE.L     #$77706C63,-(A7)     ; 'wplc' - window placement
005E: MOVE.W     D7,-(A7)             ; Index
0060: A9A0                            ; _GetScrap
0062: MOVEA.L    (A7)+,A4             ; A4 = handle
0064: MOVE.L     A4,D0
0066: BNE.S      $0018                ; Found - check it

; Not found - create new
0068: MOVEQ      #8,D0                ; Size = 8 bytes
006A: A122                            ; _NewHandle
006C: MOVEA.L    A0,A4                ; A4 = new handle
006E: MOVE.L     A4,D0
0070: BNE.S      $0076
0072: MOVEQ      #0,D0                ; Return NULL on error
0074: BRA.S      $00B0

; Lock and fill handle
0076: CLR.L      -(A7)                ; Offset
0078: MOVE.L     A4,-(A7)             ; Handle
007A: JSR        2826(A5)             ; JT[2826] - HLock
007E: MOVEQ      #8,D0
0080: MOVE.W     (A7)+,(A0)           ; Size check
0082: BEQ.S      $0088
0084: JSR        418(A5)              ; JT[418] - error

; Copy window rect to scrap
0088: MOVEA.L    (A4),A0
008A: MOVE.L     -16(A6),(A0)         ; top-left
008E: MOVE.L     -12(A6),4(A0)        ; bottom-right

; Add to scrap
0094: MOVE.L     A4,-(A7)             ; Handle
0096: MOVE.L     #$77706C63,-(A7)     ; 'wplc'
009C: MOVE.W     D7,-(A7)             ; Index
009E: MOVE.L     -3512(A5),-(A7)      ; Resource file ref
00A2: A9AB                            ; _AddResource

; Unlock handle
00A4: MOVE.L     A4,-(A7)
00A6: A9AA                            ; _PutScrap (register)
00A8: CLR.W      -(A7)
00AA: A994                            ; _InfoScrap
00AC: A999                            ; _UnloadScrap

00AE: MOVE.L     A4,D0                ; Return handle

00B0: MOVEM.L    (SP)+,D7/A4
00B4: UNLK       A6
00B6: RTS
```

**C equivalent**:
```c
Handle find_scrap_by_type(void) {
    Rect windowRect = g_window_rect;
    int index = 0;
    Handle scrapH;

    // Search existing scraps
    while ((scrapH = GetScrap(NULL, 'wplc', index)) != NULL) {
        Rect* scrapRect = *(Rect**)scrapH;

        // Check if matches window rect
        if (EqualRect(scrapRect, &windowRect)) {
            return scrapH;  // Found
        }

        ZeroScrap();  // Release and try next
        index++;
    }

    // Create new scrap
    scrapH = NewHandle(8);
    if (!scrapH) return NULL;

    HLock(scrapH);

    // Copy window rect
    *(Rect*)*scrapH = windowRect;

    // Add to resource file
    AddResource(scrapH, 'wplc', index, g_res_file);
    PutScrap(sizeof(Rect), 'wplc', *scrapH);
    InfoScrap();
    UnloadScrap();

    return scrapH;
}
```

### Function 0x00B8 - Get Scrap Data
```asm
00B8: LINK       A6,#-4               ; frame=4
00BC: MOVEM.L    D6/D7/A2/A3/A4,-(SP)

; Find scrap first
00C0: JSR        -194(PC)             ; Find scrap
00C4: MOVEA.L    D0,A4                ; A4 = handle
00C6: MOVE.L     A4,D0
00C8: BEQ.S      $0126                ; Not found

; Lock handle
00CA: CLR.L      -(A7)
00CC: MOVE.L     A4,-(A7)
00CE: JSR        2826(A5)             ; JT[2826] - HLock

00D2: MOVE.L     (A7)+,-4(A6)         ; Store pointer

; Get data size
00D6: PEA        $000E.W              ; 14 bytes
00DA: MOVEA.L    -4(A6),A0
00DE: PEA        -22(A0)              ; Data offset
00E2: JSR        90(A5)               ; JT[90] - get size

; Store size
00E6: MOVE.L     D0,D7
00E8: MOVEQ      #0,D6                ; Index = 0
00EA: ...
00EC: BRA.S      $0118

; Search for matching data
00EE: LEA        8(A3),A2             ; Data offset
00F2: ...
...

; Compare values
00FC: MOVE.W     12(A6),D0            ; Compare value
0100: MOVEA.W    4(A2),A0
0104: BNE.S      $0118                ; Not equal

; Found - copy to output
0106: MOVE.L     (A4),D0
0108: MOVEA.L    14(A6),A0            ; Output buffer
010C: MOVE.L     14(A3,D0.L),(A0)     ; Copy data
0110: MOVE.L     18(A3,D0.L),4(A0)
0116: BRA.S      $0122

; Next entry
0118: MOVEA.B    D6,A1                ; index++
011A: LEA        14(A3),A3            ; Next entry
011E: MOVE.W     D6,(A7)
0120: BGE.S      $00EE                ; Continue loop

; Release scrap
0122: MOVE.L     A4,-(A7)
0124: A9A3                            ; _ZeroScrap (release)

0126: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
012A: UNLK       A6
012C: RTS
```

**C equivalent**:
```c
void get_scrap_data(int type, Rect* output) {
    Handle scrapH = find_scrap_by_type();
    if (!scrapH) return;

    HLock(scrapH);

    char* data = *scrapH;
    int count = GetPtrSize(data - 22);

    // Search entries
    for (int i = 0; i < count; i += 14) {
        ScrapEntry* entry = (ScrapEntry*)(data + 8 + i);

        if (entry->type == type) {
            // Copy rect to output
            output->top = entry->bounds.top;
            output->left = entry->bounds.left;
            output->bottom = entry->bounds.bottom;
            output->right = entry->bounds.right;
            break;
        }
    }

    ZeroScrap();  // Release
}
```

### Function 0x012E - Put Scrap Data
```asm
012E: LINK       A6,#-12              ; frame=12
0132: MOVEM.L    D6/D7/A2/A3/A4,-(SP)

; Find scrap first
0136: JSR        -312(PC)             ; Find scrap
013A: MOVEA.L    D0,A4                ; A4 = handle
013C: MOVE.L     A4,D0
013E: BEQ.W      $021C                ; Not found

; Get source rect from input
0142: MOVEA.L    14(A6),A0            ; Source data
0146: MOVE.L     16(A0),-8(A6)        ; contentRect
014C: MOVE.L     20(A0),-4(A6)

; Convert to global coordinates
0152: MOVE.L     A0,-(A7)
0154: A873                            ; _GlobalToLocal
0158: ...
015C: PEA        -4(A6)
0160: A870                            ; _SetPortBits

; Add entry to scrap
0164: PEA        $000E.W              ; 14 bytes per entry
0168: MOVE.L     A4,-(A7)
016C: JSR        1482(A5)             ; JT[1482] - resize handle

; Check if successful
0170: TST.W      $0220.W              ; MemErr
...
0172: BNE.W      $0218                ; Error

; Lock and get pointer
0176: CLR.L      -(A7)
0178: MOVE.L     A4,-(A7)
017A: JSR        2826(A5)             ; JT[2826] - HLock

017E: MOVE.L     (A7)+,-12(A6)        ; Store pointer

; Get current size
0182: PEA        $000E.W
0186: MOVEA.L    -12(A6),A0
018A: PEA        -22(A0)
018E: JSR        74(A5)               ; JT[74] - GetPtrSize

; Calculate entry offset
0192: MOVE.L     D0,D7
0194: PEA        $000E.W
0198: MOVE.L     D7,-(A7)
019A: JSR        66(A5)               ; JT[66] - multiply

; Store type ID
019E: MOVEA.L    D0,A3
01A0: MOVE.L     (A4),D0
01A2: MOVE.L     8(A6),8(A3,D0.L)     ; Store ID

01A8: MOVE.L     (A4),D0
01AA: MOVE.W     12(A6),12(A3,D0.L)   ; Store type

; Search for existing entry of same type
01B0: MOVEQ      #0,D6
01B2: MOVEQ      #8,D0
01B4: MOVEA.B    (A4),(A0)
01B6: MOVEA.L    D0,A2
01B8: ...

; Loop through entries
01C4: ...
01CC: MOVEA.L    A2,A0
01CE: ...
01D2: ...
01D6: BNE.S      $01C6                ; Not found - continue

; Found - check type
01D8: MOVE.L     (A4),D0
01DA: MOVE.W     12(A3,D0.L),D0
01DE: MOVEA.W    12(A6),A0
01E2: BNE.S      $01C6                ; Different type

; Update existing entry
01E4: PEA        $000E.W
01E8: MOVE.L     D6,-(A7)
01EA: JSR        66(A5)               ; JT[66]
01EE: MOVEA.L    (A4),A0
01F0: LEA        14(A0,D0.L),A0       ; Entry offset
01F4: MOVE.L     -8(A6),(A0)+         ; Store rect
01F8: MOVE.L     -4(A6),(A0)+

; Check if need to shrink
01FC: MOVE.W     D6,(A7)
01FE: BLE.S      $020C                ; Already at start

; Shrink handle
0200: PEA        $FFF2.W              ; -14 bytes
0204: MOVE.L     A4,-(A7)
0206: JSR        1482(A5)             ; JT[1482] - resize
020A: ...

; Mark scrap changed
020C: MOVE.L     A4,-(A7)
020E: A9AA                            ; _PutScrap
0212: CLR.W      -(A7)
0214: A994                            ; _InfoScrap
0216: A999                            ; _UnloadScrap
0218: MOVE.L     A4,-(A7)
021A: A9A3                            ; _ZeroScrap

021C: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
0220: UNLK       A6
0222: RTS
```

**C equivalent**:
```c
void put_scrap_data(long id, int type, WindowPtr window) {
    Handle scrapH = find_scrap_by_type();
    if (!scrapH) return;

    // Get window content rect
    Rect contentRect = window->contentRect;
    GlobalToLocal(&contentRect);

    // Resize handle to add entry
    SetHandleSize(scrapH, GetHandleSize(scrapH) + 14);
    if (MemError()) return;

    HLock(scrapH);

    // Get current entry count
    int size = GetPtrSize(*scrapH - 22);

    // Calculate offset for new entry
    ScrapEntry* newEntry = (ScrapEntry*)(*scrapH + 8 + size);
    newEntry->id = id;
    newEntry->type = type;

    // Search for existing entry of same type
    int found = -1;
    for (int i = 0; i < size / 14; i++) {
        ScrapEntry* entry = (ScrapEntry*)(*scrapH + 8 + i * 14);
        if (entry->type == type) {
            // Update existing
            entry->bounds = contentRect;
            found = i;
            break;
        }
    }

    if (found < 0) {
        // Add new entry
        newEntry->bounds = contentRect;
    } else if (found > 0) {
        // Shrink handle if replaced non-first
        SetHandleSize(scrapH, GetHandleSize(scrapH) - 14);
    }

    PutScrap(GetHandleSize(scrapH), 'wplc', *scrapH);
    InfoScrap();
    UnloadScrap();
    ZeroScrap();
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1446 | g_window_rect + 4 (bottom-right) |
| A5-1450 | g_window_rect (top-left) |
| A5-3512 | g_res_file - Resource file ref |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | Multiply |
| 74 | GetPtrSize |
| 90 | Get data size |
| 418 | Error handler |
| 1482 | Resize handle |
| 2826 | HLock |

## Scrap Type

| Code | Type |
|------|------|
| wplc | 0x77706C63 - Window placement |

## Scrap Entry Structure (14 bytes)

| Offset | Size | Field |
|--------|------|-------|
| 0 | 4 | ID |
| 4 | 2 | Type |
| 6 | 8 | Bounds rect |

## Confidence: HIGH

Standard Mac Scrap Manager patterns:
- GetScrap/PutScrap for clipboard access
- Handle-based memory management
- Type-based scrap searching
- Window placement storage
