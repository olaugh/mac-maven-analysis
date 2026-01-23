# CODE 46 Detailed Analysis - Window Manager and Graphics

## Overview

| Property | Value |
|----------|-------|
| Size | 2904 bytes |
| JT Offset | 3032 |
| JT Entries | 12 |
| Functions | 20+ |
| Purpose | **Window management, QuickDraw graphics, event handling** |

## System Role

**Category**: User Interface
**Function**: Window and Graphics Management

Provides the complete windowing layer for Maven's game interface.

**Related CODE resources**:
- CODE 48 (TextEdit controls)
- CODE 49 (Clipboard/scrap)

## QuickDraw Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| A870 | SetPortBits | Set port bitmap |
| A871 | LineTo | Draw line to point |
| A873 | GlobalToLocal | Convert global to local coords |
| A874 | GetPort | Get current graphics port |
| A879 | PortSize | Get port size |
| A87A | MovePortTo | Move port origin |
| A884 | DrawString | Draw text string |
| A887 | ForeColor | Set foreground color |
| A888 | BackColor | Set background color |
| A889 | ColorBit | Set color bit depth |
| A88A | SetCursor | Set cursor shape |
| A88C | GetFontInfo | Get font metrics |
| A891 | LineTo | Draw line to point |
| A892 | Line | Draw line relative |
| A893 | MoveTo | Move pen position |
| A894 | Move | Move pen relative |
| A89B | ScrollRect | Scroll rectangle area |
| A89C | TextSize | Set text size |
| A89E | PenSize | Set pen dimensions |
| A8A1 | FrameRect | Draw rectangle outline |
| A8A3 | InsetRect | Inset rectangle |
| A8A5 | FillPat | Fill with pattern |
| A8A8 | OffsetRect | Offset rectangle |
| A8A9 | InsetRect | Inset rectangle |
| A8AD | PtInRect | Point in rectangle test |
| A8B0 | EraseRect | Erase rectangle |
| A8D8 | NewRgn | Create new region |
| A8D9 | DisposeRgn | Dispose region |
| A8DC | CopyRgn | Copy region |
| A8DF | RectRgn | Set region to rectangle |
| A8E0 | OffsetRgn | Offset region |
| A8E5 | DiffRgn | Difference of regions |
| A8E6 | XorRgn | XOR of regions |
| A905 | NewWindow | Create window |
| A908 | ShowWindow | Show window |
| A90A | HideWindow | Hide window |
| A90B | GetWMgrPort | Get window manager port |
| A90C | SetPort | Set current port |
| A913 | NewCWindow | Create color window |
| A915 | BringToFront | Bring window to front |
| A919 | GetWTitle | Get window title |
| A91B | SetWTitle | Set window title |
| A91C | HiliteWindow | Highlight window |
| A91F | SelectWindow | Select window |
| A920 | FrontWindow | Get front window |
| A921 | SendBehind | Send window behind |

## Key Functions

### Function 0x0000 - Window Event Dispatcher
**Purpose**: Main event routing for window events

```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A4,-(SP)
0008: MOVEA.L    14(A6),A4            ; A4 = window pointer
000C: MOVE.W     12(A6),D7            ; D7 = event type

; Dispatch table
0010: TST.W      D7
0012: BNE.S      $0022                ; Not type 0
0014: ; Type 0: Draw content
0018: JSR        588(PC)
0020: BRA.S      $0072

0022: CMPI.W     #$0002,D7
0026: BNE.S      $0032
0028: ; Type 2: Update event
002A: JSR        1106(PC)
0030: BRA.S      $0072

0032: CMPI.W     #$0001,D7
0036: BNE.S      $004C
0038: ; Type 1: Mouse click
0042: JSR        1224(PC)
0046: MOVE.L     D0,20(A6)            ; Return hit result
004A: BRA.S      $0076

004C: CMPI.W     #$0006,D7
0050: BNE.S      $0062
0052: ; Type 6: Activate event
0056: TST.W      18(A6)               ; Check activate flag
005A: JSR        164(PC)
0060: BRA.S      $0072

0062: CMPI.W     #$0005,D7
0066: BNE.S      $0072
0068: ; Type 5: Idle
006C: JSR        24(PC)

0072: CLR.L      20(A6)               ; Default return 0
0076: MOVEM.L    -8(A6),D7/A4
007C: UNLK       A6
0080: LEA        12(A7),A7            ; Pop 12 bytes of params
0084: JMP        (A0)                 ; Tail return
```

**Event types**:
| Type | Event | Handler |
|------|-------|---------|
| 0 | Draw | draw_content() |
| 1 | Click | handle_click() - returns hit code |
| 2 | Update | handle_update() |
| 5 | Idle | handle_idle() |
| 6 | Activate | handle_activate() |

### Function 0x0086 - Draw 3D Border
**Purpose**: Draw 3D-effect border around rectangle (Mac OS 7 style)

```asm
0086: LINK       A6,#-8
008A: MOVE.L     A4,-(A7)
008C: MOVEA.L    8(A6),A4             ; rect parameter

; Copy rect to local
0090: MOVE.L     (A4),-8(A6)
0094: MOVE.L     4(A4),-4(A6)

; Expand rect by 1 pixel
009A: PEA        -8(A6)
009E: PEA        $FFFF.W              ; -1
; ... InsetRect(-1, -1)
; ... FrameRect

; Draw highlight (top-left edges in white)
00AA: MOVE.W     2(A4),-(A7)          ; left
00AE: MOVE.W     (A4),-(A7)           ; top
00B0: A893                            ; _MoveTo
00B2: MOVE.L     #$FFF30000,-(A7)     ; white color offset
00B8: A892                            ; _Line

; Draw shadow (bottom-right edges in dark)
00C8: MOVE.L     #$000D0000,-(A7)     ; dark color
00CE: A892                            ; _Line
; ... continue shadow edges

00FA: MOVEA.L    (A7)+,A4
00FC: UNLK       A6
00FE: RTS
```

### Function 0x0268 - Draw Board Square
**Purpose**: Draw a single board square with optional highlighting

```asm
0268: LINK       A6,#-264             ; Large frame for title buffer
026C: MOVEM.L    D3-D7/A4,-(SP)
0270: MOVEA.L    8(A6),A4             ; board data

; Check visibility
0274: TST.B      110(A4)              ; visible flag
0278: BEQ.W      $0478                ; Not visible - return

; Check for highlight mode
027C: TST.L      12(A6)               ; param != NULL?
0280: BEQ.W      $0336                ; Full redraw

; Partial redraw with selection highlight
; ... draw X marks in square corners

; Full redraw path
0336: PEA        -8(A6)
033A: JSR        -304(PC)             ; get_full_rect
033E: A89E                            ; _PenSize(1,1)
0340: PEA        -8(A6)
0344: A8A1                            ; _FrameRect

; Draw patterns if enabled
0358: TST.B      111(A4)              ; pattern1 flag
035E: BEQ.S      $0394
0360: JSR        -428(PC)             ; draw_pattern1
0368: TST.B      112(A4)              ; pattern2 flag
036E: BEQ.S      $0394
0376: JSR        -324(PC)             ; draw_pattern2

; Save and set colors
0394: MOVEA.L    $09DE.W,A0           ; QuickDraw globals
0398: MOVE.W     68(A0),D6            ; fore color
039C: MOVE.W     72(A0),D7            ; back color
03B6: MOVE.W     #$0004,-(A7)
03BA: A887                            ; _ForeColor(4)
03BC: MOVE.W     #$0001,-(A7)
03C0: A888                            ; _BackColor(1)

; Get and draw title
03E4: PEA        -264(A6)             ; title buffer
03E8: A919                            ; _GetWTitle
; ... draw title string
0410: PEA        -264(A6)
0414: A884                            ; _DrawString

; Frame content area
0426: MOVEA.L    114(A4),A0           ; content handle
042A: MOVEA.L    (A0),A0
042C: MOVE.L     2(A0),-8(A6)         ; bounds
0442: PEA        -8(A6)
0446: A8A1                            ; _FrameRect

0476: MOVEM.L    (SP)+,D3-D7/A4
047A: UNLK       A6
047C: RTS
```

### Function 0x050C - Hit Test Point
**Purpose**: Determine which part of window was clicked

```asm
050C: LINK       A6,#-8
0512: MOVEA.L    8(A6),A4             ; window

; Get content region bounds
0516: MOVEA.L    114(A4),A0           ; content handle
051A: MOVEA.L    (A0),A0
051C: MOVE.L     2(A0),-8(A6)         ; bounds rect

; Test main content
0528: CLR.B      -(A7)                ; result
052A: MOVE.L     14(A6),-(A7)         ; point
052E: PEA        -8(A6)               ; rect
0532: A8AD                            ; _PtInRect
0536: BEQ.W      $05C8                ; Not in content

; Test title bar
053A: MOVEA.L    118(A4),A0           ; title handle
0544: PEA        2(A0)                ; title rect
054A: A8AD                            ; _PtInRect
054E: BEQ.S      $0582                ; Not in title

; Check for close box (top-left 16x16)
0556: MOVEQ      #-16,D0
055C: MOVE.W     D0,-6(A6)            ; shrink rect
056A: PEA        -8(A6)
0574: A8AD                            ; _PtInRect
0578: BEQ.S      $057E
057A: MOVEQ      #3,D0                ; Return 3 = close box
057C: BRA.S      $05C8

057E: MOVEQ      #1,D0                ; Return 1 = title bar
0580: BRA.S      $05C8

; Test grow box area (bottom-right)
0582: MOVEQ      #13,D0
0588: MOVE.W     D0,-4(A6)            ; adjust bottom
058C: PEA        -8(A6)
0596: A8AD                            ; _PtInRect
059A: BEQ.S      $05C6                ; Not in grow

; Check for pattern area
059C: TST.B      111(A4)              ; pattern flag
05A0: BEQ.S      $05C2
05A8: JSR        -886(PC)             ; get_pattern_rect
05B6: A8AD                            ; _PtInRect
05BC: BEQ.S      $05C2
05BE: MOVEQ      #4,D0                ; Return 4 = pattern
05C0: BRA.S      $05C8

05C2: MOVEQ      #2,D0                ; Return 2 = grow box
05C4: BRA.S      $05C8

05C6: MOVEQ      #0,D0                ; Return 0 = content

05C8: MOVEA.L    (A7)+,A4
05CA: UNLK       A6
05CC: RTS
```

**Return codes**:
| Code | Area |
|------|------|
| 0 | Content area |
| 1 | Title bar |
| 2 | Grow box |
| 3 | Close box |
| 4 | Pattern/special area |

### Function 0x0A26 - Initialize Window List
**Purpose**: Walk window list and set up tracking pointers

```asm
0A26: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
0A2A: MOVEQ      #1,D7                ; flag1
0A2C: MOVEQ      #0,D6                ; flag2

; Clear global pointers
0A2E: CLR.L      -1326(A5)            ; g_front_window
0A32: CLR.L      -1330(A5)            ; g_active_window
0A36: CLR.L      -1322(A5)            ; g_focus_window
0A3A: MOVEQ      #-1,D0
0A3C: MOVE.L     D0,-1318(A5)         ; g_last_window = -1

; Get system window list
0A40: MOVEA.L    $09D6.W,A4           ; WindowList low-mem
0A44: BRA.S      $0AC2                ; Start loop

; Process each window
0A46: TST.B      110(A4)              ; Check visible
0A4A: BEQ.S      $0ABE                ; Skip hidden

; Track first visible as focus
0A4C: TST.L      -1322(A5)
0A50: BNE.S      $0A56
0A52: MOVE.L     A4,-1322(A5)         ; g_focus_window = this

; Check if active window
0A56: MOVE.L     A4,-(A7)
0A58: JSR        -1160(PC)            ; is_active?
0A5C: TST.W      D0
0A60: BEQ.S      $0A74                ; Not active
0A62: TST.L      -1326(A5)
0A66: BNE.S      $0ABE
0A68: MOVE.L     A4,-1326(A5)         ; g_front_window = this

; ... more window list processing

; Next window
0ABE: MOVEA.L    144(A4),A4           ; window->nextWindow
0AC2: MOVE.L     A4,D0
0AC4: BNE.S      $0A46                ; Continue loop

; Return appropriate window
0B22: MOVE.L     -1330(A5),D0
0B2A: BNE.S      $0B32
0B2C: MOVE.L     -1326(A5),D0
0B30: BRA.S      $0B36
0B32: MOVE.L     -1322(A5),D0

0B36: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
0B3A: RTS
```

## Window Structure Offsets

| Offset | Size | Field |
|--------|------|-------|
| 24 | 4 | Owner/parent window |
| 110 | 1 | Visible flag |
| 111 | 1 | Pattern flag 1 |
| 112 | 1 | Pattern flag 2 |
| 114 | 4 | Content region handle |
| 118 | 4 | Title region handle |
| 144 | 4 | Next window pointer |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1318 | g_last_window - Last processed window |
| A5-1322 | g_focus_window - Current focus window |
| A5-1326 | g_front_window - Front window pointer |
| A5-1330 | g_active_window - Active window pointer |
| $09D6 | Low-mem: WindowList head |
| $09DE | Low-mem: QuickDraw globals |
| $0A64 | Low-mem: System front window |
| $0BAA | Low-mem: Screen depth |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 514 | Get procedure address |
| 522 | Look up procedure |
| 1562 | Window cleanup handler |
| 1610 | Check window state |
| 3434 | Get window flags |

## Confidence: HIGH

Standard Mac Toolbox window management patterns:
- QuickDraw trap sequences match documented usage
- Window list traversal using standard nextWindow chain
- Region-based hit testing
- 3D border drawing for Mac OS 7+ appearance
