# CODE 49 Detailed Analysis - Scrap Manager (Window Placement)

## Overview

| Property | Value |
|----------|-------|
| Size | 546 bytes |
| JT Offset | 3312 |
| JT Entries | 2 |
| Functions | 3 |
| Purpose | **Manage window placement persistence via scrap/resources** |

## System Role

**Category**: System Services
**Function**: Window State Persistence

Saves and restores window positions using custom scrap type.

**Related CODE resources**:
- CODE 46 (Window management)
- CODE 50 (HIST resource - similar pattern)

## Mac Toolbox Scrap Traps

| Trap | Name | Purpose |
|------|------|---------|
| A122 | NewHandle | Allocate memory |
| A9A0 | GetScrap | Get scrap data by type |
| A9A3 | ZeroScrap | Clear scrap |
| A994 | InfoScrap | Get scrap info |
| A999 | UnloadScrap | Unload from memory |
| A9AA | PutScrap | Put data in scrap |
| A9AB | AddResource | Add to resource file |

## Custom Scrap Type

| Type | Value | Description |
|------|-------|-------------|
| wplc | 0x77706C63 | Window PLaCement data |

## Scrap Entry Structure (14 bytes)

```c
struct WindowPlacement {
    long   id;      // 0-3: Window identifier
    short  type;    // 4-5: Window type code
    Rect   bounds;  // 6-13: Window bounds rectangle
};
```

## Key Functions

### Function 0x0000 - Find or Create Window Placement
**Purpose**: Find existing placement scrap or create new one

```asm
0000: LINK       A6,#-16              ; Local: 2 Rects (16 bytes)
0004: MOVEM.L    D7/A4,-(SP)

; Get current window rect from globals
0008: MOVE.L     -1450(A5),-16(A6)    ; g_window_rect.topLeft
000E: MOVE.L     -1446(A5),-12(A6)    ; g_window_rect.botRight

; Search for existing 'wplc' scrap
0014: MOVEQ      #0,D7                ; index = 0
0016: BRA.S      $0056                ; Start search

; Check if current entry matches window rect
0018: MOVEA.L    (A4),A0              ; Dereference handle
001A: MOVE.L     (A0),-8(A6)          ; Get scrap bounds
001E: MOVE.L     4(A0),-4(A6)

; Compare bounds
0024: MOVE.W     -8(A6),D0            ; top
0028: CMP.W      -16(A6),D0           ; == window.top?
002C: BNE.S      $0050                ; No match
002E: MOVE.W     -4(A6),D0            ; bottom
0032: CMP.W      -12(A6),D0           ; == window.bottom?
0036: BNE.S      $0050
0038: MOVE.W     -6(A6),D0            ; left
003C: CMP.W      -14(A6),D0           ; == window.left?
0040: BNE.S      $0050
0042: MOVE.W     -2(A6),D0            ; right
0046: CMP.W      -10(A6),D0           ; == window.right?
004A: BNE.S      $0050

; Found matching placement
004C: MOVE.L     A4,D0                ; Return handle
004E: BRA.S      $00B0

; Try next scrap
0050: MOVE.L     A4,-(A7)
0052: A9A3                            ; _ZeroScrap (release)
0054: ADDQ.W     #1,D7                ; index++

; GetScrap for 'wplc' type
0056: CLR.L      -(A7)                ; offset = 0
0058: MOVE.L     #$77706C63,-(A7)     ; 'wplc'
005E: MOVE.W     D7,-(A7)             ; index
0060: A9A0                            ; _GetScrap
0062: MOVEA.L    (A7)+,A4             ; A4 = handle
0064: MOVE.L     A4,D0
0066: BNE.S      $0018                ; Found - check it

; Not found - create new scrap
0068: MOVEQ      #8,D0                ; Size = 8 bytes (Rect)
006A: A122                            ; _NewHandle
006C: MOVEA.L    A0,A4
006E: MOVE.L     A4,D0
0070: BNE.S      $0076
0072: MOVEQ      #0,D0                ; Failed - return NULL
0074: BRA.S      $00B0

; Initialize and add to resource file
0076: CLR.L      -(A7)
0078: MOVE.L     A4,-(A7)
007A: JSR        2826(A5)             ; HLock
007E: MOVEQ      #8,D0
0082: BEQ.S      $0088
0084: JSR        418(A5)              ; Error handler

; Store window rect in new scrap
0088: MOVEA.L    (A4),A0
008A: MOVE.L     -16(A6),(A0)         ; topLeft
008E: MOVE.L     -12(A6),4(A0)        ; botRight

; Add to resource file as 'wplc'
0094: MOVE.L     A4,-(A7)
0096: MOVE.L     #$77706C63,-(A7)     ; 'wplc'
009C: MOVE.W     D7,-(A7)             ; resource ID = index
009E: MOVE.L     -3512(A5),-(A7)      ; g_res_file
00A2: A9AB                            ; _AddResource

; Register in scrap
00A4: MOVE.L     A4,-(A7)
00A6: A9AA                            ; _PutScrap
00A8: CLR.W      -(A7)
00AA: A994                            ; _InfoScrap
00AC: A999                            ; _UnloadScrap

00AE: MOVE.L     A4,D0                ; Return handle

00B0: MOVEM.L    (SP)+,D7/A4
00B4: UNLK       A6
00B6: RTS
```

### Function 0x00B8 - Get Window Placement Data
**Purpose**: Retrieve stored window bounds by type

```asm
00B8: LINK       A6,#-4
00BC: MOVEM.L    D6/D7/A2/A3/A4,-(SP)

; Find scrap first
00C0: JSR        -194(PC)             ; find_or_create_scrap
00C4: MOVEA.L    D0,A4
00C6: MOVE.L     A4,D0
00C8: BEQ.S      $0126                ; Not found

; Lock handle
00CA: CLR.L      -(A7)
00CC: MOVE.L     A4,-(A7)
00CE: JSR        2826(A5)             ; HLock
00D2: MOVE.L     (A7)+,-4(A6)         ; pointer

; Get entry count
00D6: PEA        $000E.W              ; Entry size = 14
00DA: MOVEA.L    -4(A6),A0
00DE: PEA        -22(A0)              ; Data offset
00E2: JSR        90(A5)               ; Get count
00E6: MOVE.L     D0,D7                ; D7 = count

; Search for matching type
00E8: MOVEQ      #0,D6                ; index = 0
00EC: BRA.S      $0118                ; Start loop

; Check entry
00EE: LEA        8(A3),A2             ; Entry data start
; ... compare entry->type with param
00FC: MOVE.W     12(A6),D0            ; type param
0100: CMP.W      4(A2),D0             ; entry->type
0104: BNE.S      $0118                ; No match

; Found - copy bounds to output
0106: MOVE.L     (A4),D0              ; Dereference
0108: MOVEA.L    14(A6),A0            ; Output buffer
010C: MOVE.L     14(A3,D0.L),(A0)     ; Copy bounds
0110: MOVE.L     18(A3,D0.L),4(A0)
0116: BRA.S      $0122                ; Done

; Next entry
0118: ADDQ.W     #1,D6                ; index++
011A: LEA        14(A3),A3            ; Next entry
011E: CMP.W      D6,D7                ; index < count?
0120: BGE.S      $00EE                ; Continue

; Release scrap
0122: MOVE.L     A4,-(A7)
0124: A9A3                            ; _ZeroScrap

0126: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
012A: UNLK       A6
012C: RTS
```

### Function 0x012E - Store Window Placement
**Purpose**: Save window bounds for later restoration

```asm
012E: LINK       A6,#-12
0132: MOVEM.L    D6/D7/A2/A3/A4,-(SP)

; Find scrap
0136: JSR        -312(PC)
013A: MOVEA.L    D0,A4
013C: MOVE.L     A4,D0
013E: BEQ.W      $021C                ; Failed

; Get window content rect
0142: MOVEA.L    14(A6),A0            ; Window pointer
0146: MOVE.L     16(A0),-8(A6)        ; contentRect.topLeft
014C: MOVE.L     20(A0),-4(A6)        ; contentRect.botRight

; Convert to global coordinates
0152: MOVE.L     A0,-(A7)
0154: A873                            ; _GlobalToLocal
; ... coordinate conversion

; Resize handle to add entry
0164: PEA        $000E.W              ; Add 14 bytes
0168: MOVE.L     A4,-(A7)
016C: JSR        1482(A5)             ; SetHandleSize

; Check memory error
0170: TST.W      $0220.W              ; MemErr
0172: BNE.W      $0218                ; Error

; Lock and get pointer
0176: CLR.L      -(A7)
0178: MOVE.L     A4,-(A7)
017A: JSR        2826(A5)             ; HLock
017E: MOVE.L     (A7)+,-12(A6)        ; Save pointer

; Store entry data
01A0: MOVE.L     (A4),D0              ; Dereference
01A2: MOVE.L     8(A6),8(A3,D0.L)     ; Store ID
01AA: MOVE.W     12(A6),12(A3,D0.L)   ; Store type

; Search for existing entry to update
01B0: MOVEQ      #0,D6                ; index = 0
; ... loop through entries

; If found same type, update bounds
01E4: PEA        $000E.W              ; entry size
01E8: MOVE.L     D6,-(A7)             ; index
01EA: JSR        66(A5)               ; Calculate offset
01EE: MOVEA.L    (A4),A0
01F4: MOVE.L     -8(A6),(A0)+         ; Store bounds
01F8: MOVE.L     -4(A6),(A0)+

; If replaced existing, shrink handle
0200: PEA        $FFF2.W              ; -14 bytes
0204: MOVE.L     A4,-(A7)
0206: JSR        1482(A5)             ; SetHandleSize

; Mark changed
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

## Global Variables

| Offset | Size | Purpose |
|--------|------|---------|
| A5-1446 | 4 | g_window_rect + 4 (bottom-right) |
| A5-1450 | 4 | g_window_rect (top-left) |
| A5-3512 | 4 | g_res_file - Resource file ref |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | Multiply (for offset calculation) |
| 74 | GetPtrSize |
| 90 | Get data size |
| 418 | Error handler |
| 1482 | SetHandleSize |
| 2826 | HLock |

## Usage Pattern

1. **On Window Open**: Call get_placement() to restore saved position
2. **On Window Close/Move**: Call store_placement() to save current position
3. **Data persists** in resource file between launches

## Algorithm Notes

### Search Strategy
The code maintains a list of window placements indexed by window type. When looking up:
1. Find or create the 'wplc' scrap container
2. Linear search through entries for matching type
3. Return bounds if found

### Memory Management
- Uses both scrap (clipboard) and resource mechanisms
- Scrap provides runtime storage
- Resources provide file persistence
- Handle resizing for dynamic entry list

## Confidence: HIGH

Standard Mac Scrap/Resource Manager patterns:
- GetScrap/PutScrap for clipboard-like access
- AddResource for file persistence
- Handle-based memory with proper locking
- Linear search through typed entries
