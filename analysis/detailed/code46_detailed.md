# CODE 46 Detailed Analysis - Window and Graphics Manager

## Overview

| Property | Value |
|----------|-------|
| Size | 2904 bytes |
| JT Offset | 3032 |
| JT Entries | 12 |
| Functions | 20+ |
| Purpose | **Window management, QuickDraw graphics, hit testing** |

## Architecture Role

CODE 46 provides the user interface layer:
1. Window creation and management
2. Board and tile rendering
3. Mouse click hit testing
4. Window list management
5. Event dispatching

## QuickDraw Traps Used

This code makes extensive use of Mac Toolbox QuickDraw traps:

| Trap | Name | Purpose |
|------|------|---------|
| A870 | LineTo | Draw line to point |
| A871 | Line | Draw line relative |
| A873 | LocalToGlobal/GlobalToLocal | Coordinate conversion |
| A874 | GetPort | Get current port |
| A879 | PortSize | Get port size |
| A87A | MovePortTo | Move port origin |
| A884 | PaintRect | Fill rectangle |
| A887 | ForeColor | Set foreground color |
| A888 | BackColor | Set background color |
| A889 | ColorBit | Set color bit depth |
| A88A | SetCursor | Set cursor shape |
| A88C | GetFontInfo | Get font metrics |
| A891 | LineTo | Draw line |
| A892 | Line | Draw relative line |
| A893 | MoveTo | Move pen position |
| A894 | Move | Move pen relative |
| A89B | ScrollRect | Scroll rectangle |
| A89C | TextSize | Set text size |
| A89E | PenSize | Set pen size |
| A8A1 | FrameRect | Draw rectangle frame |
| A8A3 | InsetRect | Inset rectangle |
| A8A5 | FillPat | Fill with pattern |
| A8A8 | OffsetRect | Offset rectangle |
| A8A9 | InsetRect | Inset rectangle |
| A8AD | PtInRect | Point in rectangle test |
| A8D8 | NewRgn | Create new region |
| A8D9 | DisposeRgn | Dispose region |
| A8DC | CopyRgn | Copy region |
| A8DF | RectRgn | Set region to rect |
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

### Function 0x0000 - Main Event Dispatcher
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A4,-(SP)
0008: MOVEA.L    14(A6),A4            ; A4 = window
000C: MOVE.W     12(A6),D7            ; D7 = event type

; Dispatch based on event type
0010: TST.W      D7
0012: BNE.S      $0022                ; Not 0

; Event type 0: Draw content
0014: MOVE.L     8(A6),-(A7)          ; Push param
0018: MOVE.L     A4,-(A7)             ; Push window
001A: JSR        588(PC)              ; Draw content
001E: MOVE.B     A7,(A0)
0020: BRA.S      $0072                ; Return

; Event type 2: Update
0022: CMPI.W     #$0002,D7
0026: BNE.S      $0032
0028: MOVE.L     A4,-(A7)
002A: JSR        1106(PC)             ; Handle update
002E: MOVE.B     A7,(A4)
0030: BRA.S      $0072

; Event type 1: Mouse click
0032: CMPI.W     #$0001,D7
0036: BNE.S      $004C
0038: MOVE.L     8(A6),-(A7)          ; Param
003C: MOVE.W     18(A6),-(A7)         ; Modifier keys
0040: MOVE.L     A4,-(A7)             ; Window
0042: JSR        1224(PC)             ; Handle click
0046: MOVE.L     D0,20(A6)            ; Return result
004A: BRA.S      $0076

; Event type 6: Activate
004C: CMPI.W     #$0006,D7
0050: BNE.S      $0062
0052: TST.W      18(A6)               ; Activate/deactivate
0056: BNE.S      $0062
0058: MOVE.L     A4,-(A7)
005A: JSR        164(PC)              ; Handle activate
005E: MOVE.B     A7,(A4)
0060: BRA.S      $0072

; Event type 5: Idle
0062: CMPI.W     #$0005,D7
0066: BNE.S      $0072
0068: MOVE.L     8(A6),-(A7)
006C: JSR        24(PC)               ; Handle idle
0070: MOVE.B     A7,(A4)

0072: CLR.L      20(A6)               ; Default return 0
0076: MOVEM.L    -8(A6),D7/A4
007C: UNLK       A6
007E: MOVEA.L    (A7)+,A0
0080: LEA        12(A7),A7            ; Pop parameters
0084: JMP        (A0)
```

**C equivalent**:
```c
long window_event_dispatcher(void* param, int event_type,
                             WindowPtr window, int modifiers) {
    switch (event_type) {
        case 0:  // Draw
            draw_content(window, param);
            return 0;

        case 1:  // Click
            return handle_click(window, modifiers, param);

        case 2:  // Update
            handle_update(window);
            return 0;

        case 5:  // Idle
            handle_idle(param);
            return 0;

        case 6:  // Activate
            if (modifiers == 0) {
                handle_activate(window);
            }
            return 0;
    }
    return 0;
}
```

### Function 0x0086 - Draw 3D Border
```asm
0086: LINK       A6,#-8               ; frame=8
008A: MOVE.L     A4,-(A7)
008C: MOVEA.L    8(A6),A4             ; A4 = rect

; Copy rect to local
0090: MOVE.L     (A4),-8(A6)          ; top-left
0094: MOVE.L     4(A4),-4(A6)         ; bottom-right

; Inset rect by -1 (expand)
009A: PEA        -8(A6)
009E: PEA        $FFFF.W              ; -1
...
; _InsetRect trap

; Frame the rect
...: A8A1                             ; _FrameRect

; Draw highlight (top-left lines)
00AA: MOVE.W     2(A4),-(A7)          ; Left edge
00AE: MOVE.W     (A4),-(A7)           ; Top
00B0: A893                            ; _MoveTo

; White color for highlight
00B2: MOVE.L     #$FFF30000,-(A7)     ; -13 = white
00B8: A892                            ; _Line relative

; Draw right edge highlight
00BA: MOVE.W     6(A4),D0             ; Right
00BE: MOVEA.B    2(A4),A0             ; Left
00C2: MOVE.W     D0,-(A7)
00C4: CLR.W      -(A7)
00C6: A892                            ; _Line

; Draw shadow (bottom-right)
00C8: MOVE.L     #$000D0000,-(A7)     ; 13 = dark
00CE: A892                            ; _Line

00D0: MOVE.L     #$0000FFF1,-(A7)     ; Offset
00D6: A894                            ; _Move relative

; Continue shadow lines
00D8: CLR.W      -(A7)
00DA: MOVE.W     4(A4),D0             ; Bottom
00DE: MOVEA.B    (A4),A0              ; Top
00E0: MOVE.W     D0,-(A7)
00E2: A892                            ; _Line

; More 3D effect lines
00E4: MOVE.L     #$FFF1000F,-(A7)
00EA: A894                            ; _Move

00EC: MOVE.W     2(A4),D0
00F0: MOVEA.B    6(A4),A0
00F4: MOVE.W     D0,-(A7)
00F6: CLR.W      -(A7)
00F8: A892                            ; _Line

00FA: MOVEA.L    (A7)+,A4
00FC: UNLK       A6
00FE: RTS
```

**C equivalent**:
```c
void draw_3d_border(Rect* rect) {
    Rect local = *rect;

    InsetRect(&local, -1, -1);
    FrameRect(&local);

    // Highlight (top-left)
    MoveTo(rect->left, rect->top);
    ForeColor(whiteColor);  // -13
    Line(0, rect->bottom - rect->top);

    MoveTo(rect->left, rect->top);
    Line(rect->right - rect->left, 0);

    // Shadow (bottom-right)
    ForeColor(blackColor);  // 13
    MoveTo(rect->right, rect->top);
    LineTo(rect->right, rect->bottom);
    LineTo(rect->left, rect->bottom);
}
```

### Function 0x0100 - Draw Tile at Position
```asm
0100: LINK       A6,#-20              ; frame=20
0104: PEA        -16(A6)              ; Local rect
0108: A874                            ; _GetPort
...
; Get tile content rect
0110: MOVEA.L    8(A6),A0             ; Tile data
0114: MOVE.L     16(A0),-8(A6)        ; Content rect
011A: MOVE.L     20(A0),-4(A6)

; Adjust for centering
0120: MOVEQ      #-14,D0
0122: MOVEA.B    -2(A6),A0            ; Bottom
0126: MOVE.W     D0,-6(A6)
012A: MOVEQ      #-14,D0
012C: MOVEA.B    -4(A6),A0            ; Right
0130: MOVE.W     D0,-8(A6)

; Inset and frame
0134: PEA        -8(A6)
0138: A8A3                            ; _InsetRect
013A: PEA        -8(A6)
013E: PEA        $FFFF.W
0142: A8A9                            ; _InsetRect
...
; _FrameRect

; Check if should draw letter
014A: JSR        2266(PC)             ; Get tile state
014E: MOVE.W     8(A6),(A0)
0152: BNE.S      $01B0                ; Not visible - done

; Draw letter content
0154: MOVE.L     -4(A6),-12(A6)
015A: MOVEQ      #-13,D0
015C: MOVEA.B    -10(A6),A0
0160: MOVE.W     D0,-(A7)
0162: MOVEQ      #-13,D0
0164: MOVEA.B    -12(A6),A0
0168: MOVE.W     D0,-(A7)
016A: A893                            ; _MoveTo

; Draw cross pattern (for blank tile?)
016C: PEA        $0006.W
0170: A892                            ; _Line (6,0)
0172: MOVE.L     #$00060000,-(A7)
0178: A892                            ; _Line (0,6)
017A: MOVE.L     #$0000FFFA,-(A7)     ; (0,-6)
0180: A892                            ; _Line
0182: MOVE.L     #$FFFA0000,-(A7)     ; (-6,0)
0188: A892                            ; _Line
018A: MOVE.L     #$00020006,-(A7)     ; (2,6)
0190: A894                            ; _Move

; Inner cross
0192: PEA        $0004.W
0196: A892                            ; _Line (4,0)
0198: MOVE.L     #$00080000,-(A7)
019E: A892                            ; _Line (0,8)
01A0: MOVE.L     #$0000FFF8,-(A7)     ; (0,-8)
01A6: A892                            ; _Line
01A8: MOVE.L     #$FFFC0000,-(A7)     ; (-4,0)
01AE: A892                            ; _Line

01B0: MOVE.L     -16(A6),-(A7)
01B4: A873                            ; _GlobalToLocal
01B6: ...
01B8: RTS
```

**C equivalent**:
```c
void draw_tile(TileData* tile) {
    GrafPtr port;
    Rect content, frame;

    GetPort(&port);

    // Get content rectangle
    content.top = tile->contentRect.top;
    content.left = tile->contentRect.left;
    content.bottom = tile->contentRect.bottom - 14;
    content.right = tile->contentRect.right - 14;

    InsetRect(&content, -1, -1);
    FrameRect(&content);

    // Check if should draw
    if (get_tile_state(tile) != 0) return;

    // Draw letter or blank pattern
    MoveTo(content.left - 13, content.top - 13);

    // Draw cross pattern for blank
    Line(6, 0);
    Line(0, 6);
    Line(0, -6);
    Line(-6, 0);

    Move(2, 6);
    Line(4, 0);
    Line(0, 8);
    Line(0, -8);
    Line(-4, 0);
}
```

### Function 0x01BA - Set Tile Pattern
```asm
01BA: LINK       A6,#-8               ; frame=8
01BE: MOVEM.L    D6/D7/A4,-(SP)
01C2: MOVEA.L    8(A6),A4             ; A4 = tile

; Set up checkerboard patterns
01C6: MOVE.L     #$00AA00AA,D7        ; Pattern 1: 10101010
01CC: MOVE.L     #$00550055,D6        ; Pattern 2: 01010101

; Check orientation bit
01D2: BTST       #0,3(A4)             ; Bit 0 of byte 3
01D8: BEQ.S      $01DE
01DA: MOVE.L     D6,D0                ; Use pattern 2
01DC: BRA.S      $01E0
01DE: MOVE.L     D7,D0                ; Use pattern 1

; Store pattern
01E0: MOVE.L     D0,-8(A6)

; Check another bit
01E4: BTST       #0,1(A4)             ; Bit 0 of byte 1
01EA: BEQ.S      $01F6
01EC: MOVE.L     -8(A6),D0
01F0: ...                             ; Shift pattern
01F4: ...
01F6: ...

; Fill with pattern
01FC: MOVE.L     A4,-(A7)
01FE: PEA        -8(A6)               ; Pattern
0202: A8A5                            ; _FillPat

0204: MOVEM.L    (SP)+,D6/D7/A4
0208: UNLK       A6
020A: RTS
```

**C equivalent**:
```c
void set_tile_pattern(TileData* tile) {
    Pattern pattern;

    // Checkerboard patterns
    long pat1 = 0x00AA00AA;  // Alternating rows
    long pat2 = 0x00550055;  // Offset alternating

    // Select pattern based on position
    if (tile->flags & 0x01) {
        pattern = pat2;
    } else {
        pattern = pat1;
    }

    // Shift if needed
    if (tile->flags2 & 0x01) {
        pattern = shift_pattern(pattern);
    }

    FillPat(tile, &pattern);
}
```

### Function 0x0268 - Draw Board Square
```asm
0268: LINK       A6,#-264             ; frame=264 (large buffer)
026C: MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)
0270: MOVEA.L    8(A6),A4             ; A4 = board data

; Check if board is visible
0274: TST.B      110(A4)              ; Visible flag
0278: BEQ.W      $0478                ; Not visible - return

; Check if parameter provided
027C: TST.L      12(A6)
0280: BEQ.W      $0336                ; No param - full redraw

; Partial redraw with highlight
0284: PEA        -8(A6)               ; Local rect
0288: MOVE.L     A4,-(A7)
028A: JSR        -88(PC)              ; Get content rect

; Get current pen size
028E: MOVEA.L    $09DE.W,A0           ; QuickDraw globals
0292: MOVE.W     56(A0),D7            ; Pen size

; Set new pen size
0296: MOVE.W     #$000A,(A7)          ; Size = 10
029A: A89C                            ; _TextSize

; Draw highlight box
029C: MOVEQ      #2,D0
029E: MOVEA.B    -6(A6),A0
02A2: MOVE.W     D0,(A7)
02A4: MOVEQ      #2,D0
02A6: MOVEA.B    -8(A6),A0
02AA: MOVE.W     D0,-(A7)
02AC: A893                            ; _MoveTo

; Draw box lines
02AE: MOVEQ      #-3,D0
02B0: MOVEA.B    -2(A6),A0
02B4: MOVE.W     D0,(A7)
02B6: MOVEQ      #-3,D0
02B8: MOVEA.B    -4(A6),A0
02BC: MOVE.W     D0,-(A7)
02BE: A891                            ; _LineTo

; More highlight lines
02C0: MOVEQ      #-3,D0
02C2: MOVEA.B    -2(A6),A0
02C6: MOVE.W     D0,(A7)
02C8: MOVEQ      #2,D0
02CA: MOVEA.B    -8(A6),A0
02CE: MOVE.W     D0,-(A7)
02D0: A893                            ; _MoveTo

; Continue drawing highlight
...

; Draw decorative elements
02E4: MOVEQ      #4,D0
02E6: MOVEA.B    -6(A6),A0
02EA: MOVE.W     D0,-(A7)
02EC: MOVEQ      #1,D0
02EE: MOVEA.B    -8(A6),A0
02F2: MOVE.W     D0,-(A7)
02F4: A893                            ; _MoveTo

; Draw cross marks
02F6: MOVEQ      #4,D0
02F8: MOVEA.B    -6(A6),A0
02FC: MOVE.W     D0,-(A7)
02FE: MOVEQ      #-2,D0
0300: MOVEA.B    -4(A6),A0
0304: MOVE.W     D0,-(A7)
0306: A891                            ; _LineTo

...

; Restore pen size
032C: MOVE.W     D7,-(A7)
032E: A89C                            ; _TextSize
0330: BRA.W      $0478                ; Done

; Full redraw path
0336: PEA        -8(A6)
0338: MOVE.L     A4,-(A7)
033A: JSR        -304(PC)             ; Get full rect
033E: A89E                            ; _PenSize

; Erase background
0340: PEA        -8(A6)
0344: A8A1                            ; _FrameRect

; Inset for content
0346: PEA        -8(A6)
034A: MOVE.L     #$00010001,-(A7)     ; Inset (1,1)
0350: A8A9                            ; _InsetRect
...

; Check for special patterns
0358: TST.B      111(A4)              ; Pattern flag 1
035C: ...
035E: BEQ.S      $0394

; Draw pattern
0360: PEA        -8(A6)
0364: JSR        -428(PC)             ; Draw pattern 1

; Check for second pattern
0368: TST.B      112(A4)              ; Pattern flag 2
036C: ...
036E: BEQ.S      $0394

; Draw second pattern
0370: PEA        -8(A6)
0374: MOVE.L     A4,-(A7)
0376: JSR        -324(PC)             ; Draw pattern 2
...

; Get color info from QuickDraw globals
0394: MOVEA.L    $09DE.W,A0
0398: MOVE.W     68(A0),D6            ; Fore color
039C: MOVEA.L    $09DE.W,A0
03A0: MOVEQ      #0,D5
03A2: MOVE.B     70(A0),D5            ; Color mode
03A6: MOVEA.L    $09DE.W,A0
03AA: MOVE.W     72(A0),D7            ; Back color
03AE: MOVEA.L    $09DE.W,A0
03B2: MOVE.W     74(A0),D4            ; Additional color

; Set colors
03B6: MOVE.W     #$0004,-(A7)
03BA: A887                            ; _ForeColor
03BC: MOVE.W     #$0001,-(A7)
03C0: A888                            ; _BackColor
03C2: CLR.W      -(A7)
03C4: A889                            ; _ColorBit
03C6: MOVE.W     #$0009,-(A7)
03CA: A88A                            ; _SetCursor

; Get text metrics
03CC: PEA        -8(A6)
03D0: MOVE.L     A4,-(A7)
03D2: JSR        -456(PC)             ; Get metrics
03D6: MOVE.W     -2(A6),D3            ; Height
03DA: MOVEA.B    -6(A6),A3            ; Ascent
03DE: ADDI.W     #$FFD8,D3            ; Adjust by -40

; Get window title
03E2: MOVE.L     A4,(A7)
03E4: PEA        -264(A6)             ; Buffer
03E8: A919                            ; _GetWTitle
03EA: CLR.W      (A7)
03EC: PEA        -264(A6)
03F0: A88C                            ; _GetFontInfo
...

; Draw title string
03FE: ...
0400: ...
0404: MOVE.W     D0,(A7)
0406: MOVEQ      #-3,D0
0408: MOVEA.B    -4(A6),A0
040C: MOVE.W     D0,-(A7)
040E: A893                            ; _MoveTo

; Draw text
0410: PEA        -264(A6)             ; String
0414: A884                            ; _DrawString
...

; Frame content area
0426: MOVEA.L    114(A4),A0           ; Content handle
042A: MOVEA.L    (A0),A0
042C: MOVE.L     2(A0),-8(A6)         ; Content rect
0432: MOVE.L     6(A0),-4(A6)
...

; Frame the content
0442: PEA        -8(A6)
0446: A8A1                            ; _FrameRect

; Draw border lines
044C: MOVE.L     #$00010001,-(A7)
0452: A89B                            ; _ScrollRect
...

; Restore colors
0474: A89E                            ; _PenSize
0476: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4
047A: UNLK       A6
047C: RTS
```

**C equivalent**:
```c
void draw_board_square(BoardData* board, void* param) {
    Rect localRect;
    Str255 title;
    GrafPtr port;
    int penSize, foreColor, backColor;

    if (!board->visible) return;

    if (param != NULL) {
        // Partial redraw with highlight
        get_content_rect(board, &localRect);

        penSize = GetPenSize();
        TextSize(10);

        // Draw highlight box
        MoveTo(localRect.left + 2, localRect.top + 2);
        LineTo(localRect.right - 3, localRect.bottom - 3);

        MoveTo(localRect.right - 3, localRect.top + 2);
        LineTo(localRect.left + 2, localRect.bottom - 3);

        // Draw cross marks
        MoveTo(localRect.left + 4, localRect.top + 1);
        LineTo(localRect.left + 4, localRect.bottom - 2);

        TextSize(penSize);
        return;
    }

    // Full redraw
    get_full_rect(board, &localRect);
    PenSize(1, 1);
    FrameRect(&localRect);
    InsetRect(&localRect, 1, 1);

    // Draw patterns if needed
    if (board->pattern1) {
        draw_pattern1(&localRect);
    }
    if (board->pattern2) {
        draw_pattern2(board, &localRect);
    }

    // Set colors
    ForeColor(4);
    BackColor(1);
    ColorBit(0);
    SetCursor(9);

    // Get and draw title
    GetWTitle(board, title);
    GetFontInfo(&fontInfo);

    MoveTo(localRect.left + adjust, localRect.top - 3);
    DrawString(title);

    // Frame content
    Handle content = board->contentHandle;
    localRect = (**content).bounds;
    FrameRect(&localRect);

    // Clean up
    PenSize(1, 1);
}
```

### Function 0x050C - Hit Test Point
```asm
050C: LINK       A6,#-8               ; frame=8
0510: MOVE.L     A4,-(A7)
0512: MOVEA.L    8(A6),A4             ; A4 = window

; Get content region
0516: MOVEA.L    114(A4),A0           ; Content handle
051A: MOVEA.L    (A0),A0
051C: MOVE.L     2(A0),-8(A6)         ; Content rect
0522: MOVE.L     6(A0),-4(A6)

; Test if point in main content
0528: CLR.B      -(A7)                ; Result
052A: MOVE.L     14(A6),-(A7)         ; Point to test
052E: PEA        -8(A6)               ; Content rect
0532: A8AD                            ; _PtInRect
...
0536: BEQ.W      $05C8                ; Not in rect

; Test if in title bar
053A: CLR.B      -(A7)
053C: MOVE.L     14(A6),-(A7)
0540: MOVEA.L    118(A4),A0           ; Title region
0544: MOVEA.L    (A0),A0
0546: PEA        2(A0)
054A: A8AD                            ; _PtInRect
054E: BEQ.S      $0582                ; Not in title

; Test modifiers
0550: TST.W      12(A6)
0554: BNE.S      $057E                ; Has modifiers

; Check for close box area
0556: MOVEQ      #-16,D0
0558: MOVEA.B    -2(A6),A0
055C: MOVE.W     D0,-6(A6)            ; Adjust rect
0560: MOVEQ      #-16,D0
0562: MOVEA.B    -4(A6),A0
0566: MOVE.W     D0,-8(A6)

; Test close box
056A: CLR.B      -(A7)
056C: MOVE.L     14(A6),-(A7)
0570: PEA        -8(A6)
0574: A8AD                            ; _PtInRect
0578: BEQ.S      $057E
057A: MOVEQ      #3,D0                ; Return 3 = close box
057C: BRA.S      $05C8

057E: MOVEQ      #1,D0                ; Return 1 = title bar
0580: BRA.S      $05C8

; Test grow box area
0582: MOVEQ      #13,D0
0584: MOVEA.B    -8(A6),A0
0588: MOVE.W     D0,-4(A6)

058C: CLR.B      -(A7)
058E: MOVE.L     14(A6),-(A7)
0592: PEA        -8(A6)
0596: A8AD                            ; _PtInRect
...
059A: BEQ.S      $05C6

; Check for pattern region
059C: TST.B      111(A4)              ; Pattern flag
05A0: BEQ.S      $05C2

05A2: PEA        -8(A6)
05A6: MOVE.L     A4,-(A7)
05A8: JSR        -886(PC)             ; Get pattern rect
05AC: CLR.B      -(A7)
05AE: MOVE.L     14(A6),-(A7)
05B2: PEA        -8(A6)
05B6: A8AD                            ; _PtInRect
...
05BA: ...
05BC: BEQ.S      $05C2
05BE: MOVEQ      #4,D0                ; Return 4 = pattern area
05C0: BRA.S      $05C8

05C2: MOVEQ      #2,D0                ; Return 2 = grow box
05C4: BRA.S      $05C8

05C6: MOVEQ      #0,D0                ; Return 0 = content

05C8: MOVEA.L    (A7)+,A4
05CA: UNLK       A6
05CC: RTS
```

**C equivalent**:
```c
int hit_test_point(WindowPtr window, Point pt, int modifiers) {
    Rect contentRect, titleRect, closeRect;
    Handle content = window->contentHandle;

    contentRect = (**content).bounds;

    // Test main content
    if (!PtInRect(pt, &contentRect)) {
        return 0;  // In content area
    }

    // Test title bar
    Handle title = window->titleHandle;
    titleRect = (**title).bounds;

    if (PtInRect(pt, &titleRect)) {
        if (modifiers == 0) {
            // Check close box
            closeRect = contentRect;
            closeRect.bottom -= 16;
            closeRect.right -= 16;

            if (PtInRect(pt, &closeRect)) {
                return 3;  // Close box
            }
        }
        return 1;  // Title bar
    }

    // Test grow box area
    Rect growRect = contentRect;
    growRect.top = contentRect.bottom + 13;

    if (PtInRect(pt, &growRect)) {
        // Check pattern region
        if (window->pattern1) {
            Rect patternRect;
            get_pattern_rect(window, &patternRect);
            if (PtInRect(pt, &patternRect)) {
                return 4;  // Pattern area
            }
        }
        return 2;  // Grow box
    }

    return 0;  // Content
}
```

### Function 0x0654 - Activate Window
```asm
0654: LINK       A6,#0
0658: MOVE.L     A4,-(A7)
065A: MOVEA.L    8(A6),A4             ; A4 = window

; Check if already front
065E: MOVE.W     -1326(A5),#$6714     ; g_front_window
0664: MOVE.W     -1330(A5),#$6630     ; g_active_window
066A: MOVE.L     144(A4),-(A7)        ; Next window
066E: JSR        -114(PC)             ; Check if visible
0672: TST.W      D0
0674: ...
0676: BEQ.S      $069A

; Set as front window
0678: MOVE.L     144(A4),$0A64.W      ; Set front ptr
067E: BRA.S      $068A

; Walk window list
0680: MOVEA.L    $0A64.W,A0
0684: MOVE.L     144(A0),$0A64.W
068A: TST.L      $0A64.W              ; Check ptr
068E: BEQ.S      $069A                ; End of list
0690: MOVEA.L    $0A64.W,A0
0694: TST.B      110(A0)              ; Check visible
0698: BEQ.S      $0680                ; Skip hidden

; Show and hilite window
069A: MOVE.L     A4,-(A7)
069C: CLR.B      -(A7)                ; hiliteState = false
069E: A908                            ; _ShowWindow

; Call custom handler
06A0: JSR        900(PC)              ; Custom activate

; Check for secondary window
06A4: TST.L      -1326(A5)            ; g_front_window
06A8: BEQ.S      $06B8
06AA: MOVE.B     #$01,-(A7)           ; hiliteState = true
06AE: MOVE.L     -1326(A5),-(A7)
06B2: JSR        434(PC)              ; Hilite front
06B6: ...

06B8: MOVEA.L    (A7)+,A4
06BA: UNLK       A6
06BC: RTS
```

**C equivalent**:
```c
void activate_window(WindowPtr window) {
    // Check if visible and update front window chain
    if (check_visible(window->nextWindow)) {
        // Walk window list to find position
        WindowPtr front = (WindowPtr)0x0A64;  // System front
        while (front) {
            if (front->visible) break;
            front = front->nextWindow;
        }
        *(WindowPtr*)0x0A64 = window->nextWindow;
    }

    // Show window without hilite
    ShowWindow(window);
    HiliteWindow(window, false);

    // Custom activation
    custom_activate(window);

    // Hilite previous front window
    if (g_front_window) {
        hilite_window(g_front_window, true);
    }
}
```

### Function 0x0A26 - Initialize Window List
```asm
0A26: MOVEM.L    D6/D7/A2/A3/A4,-(SP)

; Initialize flags
0A2A: MOVEQ      #1,D7                ; Flag 1
0A2C: MOVEQ      #0,D6                ; Flag 2

; Clear window pointers
0A2E: CLR.L      -1326(A5)            ; g_front_window
0A32: CLR.L      -1330(A5)            ; g_active_window
0A36: CLR.L      -1322(A5)            ; g_focus_window
0A3A: MOVEQ      #-1,D0
0A3C: MOVE.L     D0,-1318(A5)         ; g_last_window = -1

; Get first window
0A40: MOVEA.L    $09D6.W,A4           ; Window list head
0A44: BRA.S      $0AC2

; Process each window
0A46: TST.B      110(A4)              ; Check visible
0A4A: BEQ.S      $0ABE                ; Skip hidden

; Track first visible
0A4C: TST.L      -1322(A5)            ; g_focus_window set?
0A50: BNE.S      $0A56
0A52: MOVE.L     A4,-1322(A5)         ; Set focus

; Check if active
0A56: MOVE.L     A4,-(A7)
0A58: JSR        -1160(PC)            ; Is active?
0A5C: TST.W      D0
0A5E: ...
0A60: BEQ.S      $0A74

; Set as front if first active
0A62: TST.L      -1326(A5)
0A66: BNE.S      $0ABE
0A68: MOVE.L     A4,-1326(A5)         ; g_front_window
0A6C: TST.B      D6
0A6E: BEQ.S      $0ABE
0A70: MOVEQ      #0,D7                ; Clear flag
0A72: BRA.S      $0ABE

; Check if should be front
0A74: MOVE.L     A4,-(A7)
0A76: JSR        -1146(PC)            ; Should be front?
0A7A: TST.W      D0
0A7C: ...
0A7E: BEQ.S      $0AB6

; Handle front window logic
0A80: TST.L      -1326(A5)
0A84: BEQ.S      $0AA6
0A86: MOVE.L     -1326(A5),D0
0A8A: MOVE.W     -1322(A5),(A0)
0A8E: BNE.S      $0A9A
0A90: MOVE.L     A4,-(A7)
0A92: A91F                            ; _SelectWindow
0A94: MOVE.L     A4,-1322(A5)
0A98: BRA.S      $0AA2

; Send behind current front
0A9A: MOVE.L     -1326(A5),-(A7)
0A9E: MOVE.L     A4,-(A7)
0AA0: A921                            ; _SendBehind
0AA2: MOVEA.L    -1326(A5),A4

; Update active window
0AA6: TST.L      -1330(A5)
0AAA: BNE.S      $0AB0
0AAC: MOVE.L     A4,-1330(A5)         ; g_active_window
0AB0: MOVE.L     A4,-1318(A5)         ; g_last_window
0AB4: BRA.S      $0ABE

; Set secondary flag
0AB6: TST.L      -1330(A5)
0ABA: BEQ.S      $0ABE
0ABC: MOVEQ      #1,D6                ; Flag = 1

; Next window
0ABE: MOVEA.L    144(A4),A4           ; window->nextWindow
0AC2: MOVE.L     A4,D0
0AC4: BNE.S      $0A46                ; Continue loop

; Post-process
0AC6: TST.B      D7
0AC8: BNE.S      $0B22                ; Done

; Reorder windows if needed
...

; Return appropriate window
0B22: MOVE.L     -1330(A5),D0         ; g_active_window
0B26: MOVE.W     -1322(A5),(A0)
0B2A: BNE.S      $0B32
0B2C: MOVE.L     -1326(A5),D0         ; g_front_window
0B30: BRA.S      $0B36
0B32: MOVE.L     -1322(A5),D0         ; g_focus_window

0B36: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
0B3A: RTS
```

**C equivalent**:
```c
WindowPtr init_window_list(void) {
    int flag1 = 1, flag2 = 0;

    // Clear global pointers
    g_front_window = NULL;
    g_active_window = NULL;
    g_focus_window = NULL;
    g_last_window = (WindowPtr)-1;

    // Walk all windows
    WindowPtr window = (WindowPtr)0x09D6;  // System window list

    while (window) {
        if (window->visible) {
            // Track first visible
            if (!g_focus_window) {
                g_focus_window = window;
            }

            // Check if active
            if (is_active_window(window)) {
                if (!g_front_window) {
                    g_front_window = window;
                    if (flag2) flag1 = 0;
                }
            } else if (should_be_front(window)) {
                // Handle window ordering
                if (g_front_window) {
                    if (g_front_window != g_focus_window) {
                        SelectWindow(window);
                        g_focus_window = window;
                    } else {
                        SendBehind(window, g_front_window);
                    }
                    window = g_front_window;
                }

                if (!g_active_window) {
                    g_active_window = window;
                }
                g_last_window = window;
            } else {
                if (g_active_window) {
                    flag2 = 1;
                }
            }
        }

        window = window->nextWindow;
    }

    // Return appropriate window
    if (g_active_window != g_focus_window) {
        return g_front_window;
    }
    return g_focus_window;
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1318 | g_last_window - Last processed window |
| A5-1322 | g_focus_window - Current focus window |
| A5-1326 | g_front_window - Front window pointer |
| A5-1330 | g_active_window - Active window pointer |
| $09D6 | System window list head |
| $09DE | QuickDraw globals pointer |
| $0A64 | System front window pointer |
| $0A68 | Secondary window pointer |
| $0BAA | Screen depth/mode |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 514 | Get procedure address |
| 522 | Look up procedure |
| 1562 | Window cleanup |
| 1610 | Check window state |
| 3434 | Get window flags |

## Hit Test Return Codes

| Code | Meaning |
|------|---------|
| 0 | Content area |
| 1 | Title bar |
| 2 | Grow box |
| 3 | Close box |
| 4 | Pattern/special area |

## Window Structure Offsets

| Offset | Size | Field |
|--------|------|-------|
| 110 | 1 | Visible flag |
| 111 | 1 | Pattern flag 1 |
| 112 | 1 | Pattern flag 2 |
| 114 | 4 | Content region handle |
| 118 | 4 | Title region handle |
| 144 | 4 | Next window pointer |

## Confidence: HIGH

Clear Mac Toolbox window management patterns:
- Standard QuickDraw trap sequences
- Window list traversal
- Hit testing with multiple regions
- 3D border drawing for visual depth
