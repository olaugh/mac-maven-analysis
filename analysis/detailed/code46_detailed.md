# CODE 46 Detailed Analysis - Custom Window Manager & Graphics Layer

## Overview

| Property | Value |
|----------|-------|
| Size | 2,904 bytes (code) + 4 byte header = 2,908 total |
| JT Offset | 3032 |
| JT Entries | 12 |
| Functions | 23 (LINK A6) + 2 non-LINK leaf functions |
| Purpose | **Custom window management, QuickDraw rendering, hit testing, window ordering** |
| Confidence | **HIGH** |

## Module Purpose

CODE 46 is Maven's custom window management layer. It implements a complete WDEF-style windowing system on top of the Mac Toolbox, providing:

1. Window event dispatching (draw, click, update, idle, activate)
2. 3D border drawing in Mac OS 7+ raised/embossed style
3. Board square rendering with pattern fills and title drawing
4. Region-based hit testing (content, title bar, close box, grow box, pattern area)
5. Window creation wrapping NewCWindow with custom initialization
6. Window ordering, activation, and visibility management
7. A complete window tracking subsystem using four A5-relative globals

This module is the heart of Maven's custom UI framework. Unlike modules that use the Toolbox WDEF mechanism, CODE 46 manages its own window list traversal and event routing. It contains 120+ Toolbox trap calls -- by far the most QuickDraw-intensive module in Maven.

**Related CODE resources:**
- CODE 48 (TextEdit controls)
- CODE 49 (Clipboard/scrap)
- CODE 9, 11, 52 (called via JT)

## Function Map

| Offset | Frame | Size | Regs Saved | Purpose |
|--------|-------|------|------------|---------|
| 0x0000 | 0 | 134 | D7/A4 | Window event dispatcher |
| 0x0086 | -8 | 122 | A4 | Draw 3D border (inner) |
| 0x0100 | -20 | 186 | -- | Draw 3D border with activation check |
| 0x01BA | -8 | 82 | D6/D7/A4 | Fill pattern (checkerboard) |
| 0x020C | -4 | 40 | -- | Set content rect from region |
| 0x0234 | 0 | 52 | A4 | Adjust rect with inset offset |
| 0x0268 | -264 | 534 | D3-D7/A4 | Draw board square (main render) |
| 0x047E | -8 | 142 | A3/A4 | Compute clip region for window |
| 0x050C | -8 | 198 | A4 | Hit test point in window |
| 0x05CE | -- | 4 | -- | Double RTS (alignment padding) |
| 0x05D2 | 0 | 44 | -- | Check if window is in managed list |
| 0x05FE | 0 | 20 | -- | Get window flags (bit 7) |
| 0x0612 | 0 | 66 | A3/A4 | Invoke window procedure callback |
| 0x0654 | 0 | 106 | A4 | Show window and update system list |
| 0x06BE | 0 | 22 | -- | Set window order (DrawBehind) |
| 0x06D4 | -4 | 106 | A4 | Create color window (NewCWindow wrapper) |
| 0x073E | 0 | 50 | A4 | Activate/bring-to-front window |
| 0x0770 | -4 | 54 | -- | Check if window belongs to managed set |
| 0x07A6 | -- | 6 | -- | Get screen bit depth (leaf) |
| 0x07AC | -8 | 186 | D7/A3/A4 | Open window with region setup |
| 0x0866 | -6 | 126 | D7/A3/A4 | Reorder and activate window |
| 0x08E4 | -8 | 126 | A3/A4 | Hide and reorder window |
| 0x0962 | -16 | 148 | A4 | Select or show window (main dispatch) |
| 0x09F6 | -4 | 48 | -- | Set front window and select |
| 0x0A26 | (none) | 278 | D6/D7/A2/A3/A4 | Initialize window tracking (non-LINK) |
| 0x0B3C | 0 | 28 | -- | Configure window visibility flag |

## Global Variables

### A5-Relative Globals (4 unique offsets)

| Offset | Name | Type | Description |
|--------|------|------|-------------|
| A5-1318 | g_last_window | long | Last processed window in list (-1 = none) |
| A5-1322 | g_focus_window | WindowPtr | Window with keyboard focus |
| A5-1326 | g_front_window | WindowPtr | Frontmost active window |
| A5-1330 | g_active_window | WindowPtr | Currently managed active window |

### Low-Memory Globals

| Address | Name | Type | Description |
|---------|------|------|-------------|
| $09D6 | WindowList | WindowPtr | Head of system window list |
| $09DE | QDGlobals | Ptr | QuickDraw globals pointer |
| $09EE | ScreenRow | short | Screen row bytes |
| $0A64 | CurDeactive | WindowPtr | System front window / deactivation target |
| $0A68 | CurActivate | WindowPtr | Current activation target |
| $0BAA | ScrnBase | short | Screen bit depth |

## Jump Table Calls

| JT Offset | Count | Called From | Purpose |
|-----------|-------|-------------|---------|
| JT[514] | 1 | 0x0630 | Get procedure address (GetResource/ProcPtr) |
| JT[522] | 1 | 0x062A | Look up procedure by type/ID |
| JT[1562] | 1 | 0x08D6 | Window cleanup handler |
| JT[1610] | 5 | 0x05DA, 0x0778, 0x09D2, 0x0AE6 | Check window state (is-managed?) |
| JT[3434] | 2 | 0x05E8, 0x0607 | Get window flags/properties |

## QuickDraw and Toolbox Traps Summary

### Drawing Primitives
| Trap | Name | Count | Usage |
|------|------|-------|-------|
| A893 | _MoveTo | 8 | Position pen for drawing |
| A891 | _LineTo | 6 | Draw line to absolute point |
| A892 | _Line | 13 | Draw line relative |
| A894 | _Move | 3 | Move pen relative |
| A89E | _PenSize | 2 | Set pen width/height |
| A884 | _DrawString | 1 | Draw Pascal string |
| A8A1 | _FrameRect | 5 | Draw rectangle outline |
| A8A3 | _InsetRect | 5 | Shrink/expand rectangle |
| A8A9 | _InsetRect(2) | 5 | Alternate InsetRect encoding |
| A8A8 | _OffsetRect | 2 | Move rectangle |
| A8A5 | _FillRect | 1 | Fill with pattern |
| A89B | _ScrollRect | 1 | Scroll rectangle area |

### Color and Font
| Trap | Name | Count | Usage |
|------|------|-------|-------|
| A887 | _ForeColor | 2 | Set foreground color |
| A888 | _BackColor | 2 | Set background color |
| A889 | _ColorBit | 2 | Set color plane |
| A88A | _SetCursor | 2 | Set cursor shape |
| A88C | _GetFontInfo | 1 | Get font metrics |
| A89C | _TextSize | 2 | Set text size |

### Hit Testing
| Trap | Name | Count | Usage |
|------|------|-------|-------|
| A8AD | _PtInRect | 5 | Point-in-rectangle test |

### Region Operations
| Trap | Name | Count | Usage |
|------|------|-------|-------|
| A8D8 | _NewRgn | 4 | Create region |
| A8D9 | _DisposeRgn | 4 | Dispose region |
| A8DC | _CopyRgn | 2 | Copy region |
| A8DF | _RectRgn | 3 | Set region to rectangle |
| A8E0 | _OffsetRgn | 1 | Offset region |
| A8E5 | _DiffRgn | 1 | Region difference |
| A8E6 | _XorRgn | 1 | Region XOR |
| A870 | _SetPortBits | 2 | Set port bitmap |

### Window Manager
| Trap | Name | Count | Usage |
|------|------|-------|-------|
| A905 | _NewWindow | 1 | Create standard window |
| A913 | _NewCWindow | 1 | Create color window |
| A908 | _ShowWindow | 2 | Show window |
| A90A | _HideWindow | 1 | Hide window |
| A90B | _GetWMgrPort | 1 | Get window manager port |
| A90C | _SetPort | 1 | Set current port |
| A915 | _BringToFront | 1 | Bring window to front |
| A919 | _GetWTitle | 1 | Get window title |
| A91B | _SetWTitle | 1 | Set window title |
| A91C | _HiliteWindow | 5 | Highlight/unhighlight window |
| A91F | _SelectWindow | 5 | Select window |
| A920 | _FrontWindow | 1 | Get front window |
| A921 | _SendBehind | 3 | Send window behind another |
| A92D | _DrawBehind | 1 | Draw windows behind |
| A873 | _GlobalToLocal | 8 | Convert coordinates |
| A874 | _GetPort | 3 | Get current port |
| A879 | _PortSize | 2 | Port size |
| A87A | _MovePortTo | 1 | Move port origin |
| A871 | _SetPortBits | 1 | Set port bitmap |
| A973 | _GetNextEvent | 1 | Peek at event queue |
| A86A | _OpenPort | 1 | Open graphics port |

## Window Data Structure

Maven extends the standard Mac WindowRecord with custom fields at specific offsets:

| Offset | Size | Type | Field Name | Description |
|--------|------|------|------------|-------------|
| 0 | 1 | byte | -- | (standard WindowRecord) |
| 1 | 1 | byte | pattern_sel_1 | Pattern selector bit 0 (BTST #0) |
| 3 | 1 | byte | pattern_sel_2 | Pattern selector bit 0 (BTST #0) |
| 24 | 4 | long | refCon_or_behind | Window behind/reference field |
| 110 | 1 | Boolean | visible | Window visible flag |
| 111 | 1 | Boolean | pattern_flag1 | Has pattern fill 1 |
| 112 | 1 | Boolean | pattern_flag2 | Has pattern fill 2 |
| 114 | 4 | Handle | contentRgn | Content region handle |
| 118 | 4 | Handle | titleRgn | Title bar region handle |
| 144 | 4 | WindowPtr | nextWindow | Next window in chain |

## Function-by-Function Analysis

### Function 0x0000 - Window Event Dispatcher
**Hex verification:** `4E56 0000 48E7 0108` = LINK A6,#0; MOVEM.L D7/A4,-(SP)

```
Parameters: 8(A6)=event_data, 12(A6)=event_type(W), 14(A6)=window_ptr
Returns: 20(A6)=result (for click events)
```

Main routing function. Loads A4 = window pointer from 14(A6), D7 = event type from 12(A6). Dispatches via if-else chain (not a jump table):

| Type | Branch Target | Handler | PC-relative Target |
|------|---------------|---------|-------------------|
| 0 | 0x0014 | draw_content | JSR +588 -> 0x0268 |
| 1 | 0x0038 | handle_click | JSR +1224 -> 0x050C |
| 2 | 0x0028 | handle_update | JSR +1106 -> 0x047E |
| 5 | 0x0068 | handle_idle | JSR +24 -> 0x0086 |
| 6 | 0x0052 | handle_activate | JSR +164 -> 0x0100 |

For event type 1 (click), the return value from hit_test (D0) is stored at 20(A6). All other event types store 0 at 20(A6). The function uses a custom calling convention: UNLK A6, pop 12 bytes of parameters, JMP (A0) for tail return.

**Note**: Event type 5 (idle) dispatches to `draw_3d_border` at 0x0086 -- this handles cursor blink / visual refresh during idle.

```c
long window_event_dispatcher(long event_data, short event_type, WindowPtr window) {
    long result = 0;
    switch (event_type) {
        case 0:  /* Draw */
            draw_board_square(window, event_data);
            break;
        case 1:  /* Click */
            result = hit_test_point(window, event_data, /*modifiers*/);
            return result;
        case 2:  /* Update */
            compute_clip_region(window);
            break;
        case 5:  /* Idle */
            draw_3d_border(window, event_data);
            break;
        case 6:  /* Activate */
            draw_3d_border_extended(window);
            break;
    }
    return 0;
}
```

### Function 0x0086 - Draw 3D Border (Inner)
**Hex verification:** `4E56 FFF8 2F0C` = LINK A6,#-8; MOVE.L A4,-(SP)

```
Parameters: 8(A6)=rect_ptr
Local: -8(A6)=local_rect(8 bytes)
```

Copies the bounds rect from the parameter to local storage, expands by InsetRect(-1,-1), frames with FrameRect, then draws 3D highlight/shadow lines.

The 3D effect uses Line() calls with signed delta pairs to draw:
- Top-left highlight: MoveTo(rect.left, rect.top), Line(-13, 0) -- white/light
- Bottom-right shadow: Line(13, 0), Line(0, -15) -- dark
- Additional offset lines using Move(relative) + Line(relative) for the beveled corners

The complete sequence uses 6 Line() calls and 2 Move() calls to create a raised border appearance consistent with Mac OS 7 "platinum" look.

```c
void draw_3d_border(Rect *bounds) {
    Rect r;
    r = *bounds;

    /* Expand and frame outer edge */
    InsetRect(&r, -1, -1);
    FrameRect(&r);

    /* Highlight (top-left edges) */
    MoveTo(bounds->left, bounds->top);
    Line(-13, 0);

    /* Shadow (bottom-right edges) */
    h_delta = bounds->bottom - bounds->left;
    Line(h_delta, 0);   /* Bottom edge */
    Line(13, 0);
    Line(0, -15);        /* Right edge */

    /* Corner adjustments */
    Move(0, bounds->top - bounds->bottom);
    Line(-15, 0);

    Move(-15, 15);
    h_delta = bounds->left - bounds->bottom;
    Line(h_delta, 0);
}
```

### Function 0x0100 - Draw 3D Border with Activation Check
**Hex verification:** `4E56 FFEC 486E FFF0` = LINK A6,#-20; PEA -16(A6)

```
Parameters: 8(A6)=window_ptr
Local: -20(A6)=saved_port(4), -16(A6)=local_point(4), -8(A6)=local_rect(8)
```

This is the activate/deactivate event handler. It:
1. Saves current port via GetPort
2. Converts event point via GlobalToLocal
3. Copies window bounds at offsets 16-20 to local rect
4. Computes an inset rect: adds -14 to both right and bottom coordinates (0x70F2 = MOVEQ #-14 -> offset by -14 pixels)
5. Calls InsetRect to shrink, then InsetRect(-1,-1) to expand, then FrameRect
6. Calls initialize_window_tracking (0x0A26) to rebuild window list
7. Compares result with the original window parameter
8. If window is ACTIVE (matches): draws highlight lines with MoveTo + Line sequence (6+6+6+(-6)+(-6)+(-4)+(+2)+(+6)+(+8)+(0)+(-8)+(-4)+0) creating a detailed 3D inset frame
9. If window is NOT active: draws a different set of lines for the inactive border appearance

The two line sets differ to give visual feedback about focus state. Active windows get pronounced shadow/highlight, inactive windows get flat framing.

Finally restores the original coordinate system with GlobalToLocal.

```c
void draw_3d_border_extended(WindowPtr window) {
    GrafPtr saved_port;
    Point local_pt;
    Rect r;

    GetPort(&saved_port);
    GlobalToLocal(&local_pt);

    /* Get window bounds into local rect, inset by 14 pixels */
    r.top = window->portRect.top;
    r.left = window->portRect.left;
    r.bottom = window->portRect.bottom;
    r.right = window->portRect.right;
    r.right += -14;  /* Shrink right edge */
    r.bottom += -14; /* Shrink bottom edge */

    InsetRect(&r, /* ... */);
    InsetRect(&r, -1, -1);
    FrameRect(&r);

    initialize_window_tracking();

    if (result == (long)window) {
        /* Active window: draw highlight border */
        MoveTo(r.right - 13, r.bottom - 13);
        Line(0, 6);
        Line(6, 0);
        Line(0, -6);
        Line(-6, 0);
        Move(2, 6);
        Line(0, 4);
        Line(8, 0);
        Line(0, -8);
        Line(-4, 0);
    } else {
        /* Inactive window: draw flat border */
        MoveTo(r.right - 12, r.bottom - 12);
        Line(0, 4);
        Line(8, 0);
        Line(0, -8);
        Line(-4, 0);
    }

    GlobalToLocal(&local_pt);  /* Restore */
}
```

### Function 0x01BA - Fill Pattern (Checkerboard)
**Hex verification:** `4E56 FFF8 48E7 0308` = LINK A6,#-8; MOVEM.L D6/D7/A4,-(SP)

```
Parameters: 8(A6)=window_ptr
Local: -8(A6)=pattern_data(8 bytes)
```

Selects and draws a checkerboard pattern based on window data bits. Uses BTST #0 on offsets 3 and 1 of the window data to select between two pattern constants:

- If bit 0 at offset 3 is set: use D6 = `$00AA00AA` (dark checkerboard)
- Otherwise: use D7 = `$00550055` (light checkerboard)
- If bit 0 at offset 1 is set: rotate pattern left by 1 bit (LSL.L #1 + carry)

Stores the 8-byte QuickDraw pattern at -8(A6) and calls FillRect.

```c
void fill_pattern(MavenWindow *window) {
    Pattern pat;
    long pattern_val;

    if (window->pattern_sel_2 & 0x01)
        pattern_val = 0x00AA00AA;  /* Dark pattern */
    else
        pattern_val = 0x00550055;  /* Light pattern */

    if (window->pattern_sel_1 & 0x01)
        pattern_val = (pattern_val << 1) | (pattern_val >> 31);  /* Rotate */

    *(long*)&pat[0] = pattern_val;
    *(long*)&pat[4] = pattern_val;

    FillRect(&window->bounds, &pat);
}
```

### Function 0x020C - Set Content Rect from Region
**Hex verification:** `4E56 FFFC 206E 0008` = LINK A6,#-4; MOVEA.L 8(A6),A0

```
Parameters: 8(A6)=window_ptr, 12(A6)=dest_rect_ptr
```

Dereferences the content region handle at offset 114 of the window, copies the region bounding box (at offset 2 within the region data) to the destination rect, then adjusts the bottom by adding 13 pixels.

```c
void set_content_rect(MavenWindow *window, Rect *dest) {
    Handle rgn_h = window->contentRgn;
    RgnPtr rgn = *rgn_h;

    dest->top = rgn->rgnBBox.top;
    dest->left = rgn->rgnBBox.left;
    dest->bottom = rgn->rgnBBox.bottom;
    dest->right = rgn->rgnBBox.right;

    dest->bottom = dest->top + 13;  /* Fixed 13-pixel title bar height */
}
```

### Function 0x0234 - Adjust Rect with Inset Offset
**Hex verification:** `4E56 0000 2F0C 286E 000C` = LINK A6,#0; MOVE.L A4,-(SP); MOVEA.L 12(A6),A4

```
Parameters: 8(A6)=flag/mode, 12(A6)=window_ptr
```

Calls set_content_rect (0x020C) internally, then modifies the rect by adding 9 to the top and 9 to the left coordinates. This effectively computes a smaller rect inset from the title bar -- likely the close box or icon area.

```c
void adjust_rect_with_offset(short mode, MavenWindow *window) {
    Rect r;
    set_content_rect(window, &r);
    r.bottom = r.top + 9;
    r.right = r.left + 9;
}
```

### Function 0x0268 - Draw Board Square (Main Render)
**Hex verification:** `4E56 FEF8 48E7 1F08` = LINK A6,#-264; MOVEM.L D3-D7/A4,-(SP)

```
Parameters: 8(A6)=window_ptr, 12(A6)=highlight_param
Local: -264(A6)=title_buffer(256), -8(A6)=work_rect(8)
```

This is the largest function in CODE 46 (534 bytes) and the main window rendering routine. It handles both full redraws and partial highlight updates.

**Flow:**

1. **Visibility check**: TST.B 110(A4) -- if not visible, return immediately
2. **Highlight-only path** (12(A6) != NULL):
   - Calls adjust_rect (0x0234) to get the work rect
   - Reads QuickDraw globals at $09DE to save text size (offset 0x38)
   - Sets TextSize(10)
   - Draws selection markers: 4 pairs of MoveTo/LineTo calls drawing X marks at rect corners
   - Each mark is offset by +2/-3 from corner, creating small cross-hatch selection indicators
   - Restores original text size
3. **Full redraw path** (12(A6) == NULL):
   - Calls set_content_rect (0x020C) to get the full rect
   - PenSize(1,1), FrameRect (outer frame)
   - InsetRect(1,1) then InsetRect to create inner border
   - **Pattern check**: TST.B 111(A4) -- if pattern_flag1 set:
     - Calls fill_pattern (0x01BA)
     - TST.B 112(A4) -- if pattern_flag2 also set:
       - Calls adjust_rect (0x0234) for secondary pattern
     - Re-frames after pattern fill
   - **Color setup**: Reads QDGlobals to save current fore/back colors
     - ForeColor(4) = red, BackColor(1) = white
     - ColorBit(0), SetCursor(9)
   - **Title drawing**:
     - Calls set_content_rect again to get title rect area
     - Computes text baseline: D3 = rect.bottom - rect.top + gets title width
     - Stores window in PEA, calls GetWTitle to get the title Pascal string
     - CLR.W pushes 0, calls GetFontInfo for metrics
     - Computes centering: (MULS #2 on font descent + 20 offset)
     - Adds font height + 20 to position
     - MoveTo(computed_x, rect.bottom - 3), DrawString(title)
   - **Restore colors**: ForeColor(saved), BackColor(saved), ColorBit, SetCursor
   - **Content frame**: Dereferences contentRgn handle at offset 114, gets bounds, adjusts by -1/-1 (Sn = subtract 1), FrameRect
   - **Scroll line and borders**: Additional LineTo/MoveTo pairs draw a horizontal separator and vertical borders within the content area
   - PenSize reset at end

```c
void draw_board_square(MavenWindow *window, void *highlight_param) {
    Rect r;
    Str255 title_buf;
    short saved_fg, saved_bg, saved_cb, saved_cursor;
    FontInfo finfo;

    if (!window->visible) return;

    if (highlight_param != NULL) {
        /* Highlight-only path: draw selection marks */
        adjust_rect_with_offset(highlight_param, window);
        short old_size = QDGlobals->txSize;
        TextSize(10);

        /* Draw 4 corner marks */
        MoveTo(r.right + 2, r.top + 2);
        LineTo(r.bottom - 3, r.right - 3);
        MoveTo(r.bottom - 3, r.top + 2);
        LineTo(r.right + 2, r.right - 3);
        /* ... 4 more mark lines ... */

        TextSize(old_size);
        return;
    }

    /* Full redraw */
    set_content_rect(window, &r);
    PenSize(1, 1);
    FrameRect(&r);
    InsetRect(&r, 1, 1);
    InsetRect(&r, /*...*/);

    if (window->pattern_flag1) {
        fill_pattern(window);
        if (window->pattern_flag2) {
            adjust_rect_with_offset(window, &r);
        }
        FrameRect(&r);
        InsetRect(&r, 1, 1);
        InsetRect(&r, /*...*/);
    }

    /* Save and set colors */
    saved_fg = *(short*)((char*)QDGlobals + 0x44);
    saved_bg = *(char*)((char*)QDGlobals + 0x46);
    saved_cb = *(short*)((char*)QDGlobals + 0x48);
    saved_cursor = *(short*)((char*)QDGlobals + 0x4A);

    ForeColor(4);     /* Red */
    BackColor(1);     /* White */
    ColorBit(0);
    SetCursor(9);

    /* Title */
    set_content_rect(window, &r);
    short title_height = r.bottom - r.top;
    title_height += -40;
    /* ... */
    GetWTitle(window, title_buf);
    GetFontInfo(&finfo);
    short text_x = (title_height * 2) / 2 + 20;
    MoveTo(r.top + text_x, r.bottom - 3);
    DrawString(title_buf);

    /* Restore */
    ForeColor(saved_fg);
    BackColor(saved_bg);
    ColorBit(saved_cb);
    SetCursor(saved_cursor);

    /* Frame content area */
    Rect *bounds = &(*(window->contentRgn))->rgnBBox;
    r = *bounds;
    r.bottom--;
    r.right--;
    FrameRect(&r);

    /* Scroll separator and additional borders */
    ScrollRect(&r, 1, 1, /*...*/);
    MoveTo(r.bottom, r.top + 2);
    LineTo(r.bottom, r.right);
    MoveTo(r.top + 2, r.right);
    LineTo(/*...*/);
    PenSize(/*reset*/);
}
```

### Function 0x047E - Compute Clip Region for Window
**Hex verification:** `4E56 FFF8 48E7 0018` = LINK A6,#-8; MOVEM.L A3/A4,-(SP)

```
Parameters: 8(A6)=window_ptr
Local: -8(A6)=work_rect(8)
```

Complex region manipulation for clipping. Creates temporary regions, computes the visible clip by subtracting the title bar and content regions:

1. Copies window bounds to local rect
2. Negates the rect coordinates (NEG.W via D@ trick)
3. Calls OffsetRect to shift origin
4. Dereferences titleRgn handle, calls RectRgn to set region
5. InsetRect(-1,-1) on the work rect
6. Adjusts bottom by +12 for title bar height
7. Dereferences contentRgn, calls RectRgn again
8. Calls OffsetRect(2,2) to inset content slightly
9. Adjusts bottom-1, right-1
10. Creates NewRgn for scratch, calls RectRgn
11. Computes DiffRgn(content, scratch) -- clips out the inner content
12. DisposeRgn scratch

This ensures that when drawing, only the frame/border area is updated, not the inner content (which has its own drawing routines).

```c
void compute_clip_region(MavenWindow *window) {
    Rect r;
    RgnHandle scratch_rgn;

    r = window->portRect;

    /* Negate and offset to local coordinates */
    r.left = -r.left;
    r.top = -r.top;
    OffsetRect(&r, r.left, r.top);

    /* Set title region */
    RectRgn(window->titleRgn, &r);

    /* Expand and adjust for frame */
    InsetRect(&r, -1, -1);
    r.bottom += 12;

    /* Set content region */
    RectRgn(window->contentRgn, &r);
    OffsetRect(&r, 2, 2);
    r.bottom--;
    r.right--;

    /* Create scratch region for inner area */
    scratch_rgn = NewRgn();
    RectRgn(scratch_rgn, &r);

    /* Clip: content minus inner = frame only */
    DiffRgn(window->contentRgn, scratch_rgn, window->contentRgn);

    DisposeRgn(scratch_rgn);
}
```

### Function 0x050C - Hit Test Point in Window
**Hex verification:** `4E56 FFF8 2F0C 286E 0008` = LINK A6,#-8; MOVE.L A4,-(SP); MOVEA.L 8(A6),A4

```
Parameters: 8(A6)=window_ptr, 12(A6)=modifiers(W), 14(A6)=test_point(L)
Returns: D0 = hit code (0-4)
```

Multi-stage hit testing using PtInRect against different window regions:

1. **Content region test**: Dereferences contentRgn (offset 114), gets bounds, PtInRect. If outside content, return 0.
2. **Title bar test**: Dereferences titleRgn (offset 118), gets bounds at offset+2, PtInRect.
   - If in title: checks modifiers at 12(A6). If non-zero (shift/option held):
     - Computes close box rect: insets by -16 on both right and bottom (MOVEQ #-16 = 0xF0 = -16)
     - PtInRect against close box area
     - If in close box: return **3**
   - If not in close box: return **1** (title bar / drag region)
3. **Grow box test**: Adjusts rect.bottom by +13 (13-pixel grow box area), PtInRect.
   - If in grow area: checks pattern_flag1 at offset 111
     - If pattern flag set: calls adjust_rect (0x0234) to get pattern sub-rect, PtInRect
       - If in pattern area: return **4**
     - Return **2** (grow box)
4. **Default**: return **0** (general content)

```c
short hit_test_point(MavenWindow *window, short modifiers, Point test_pt) {
    Rect r;

    /* Get content region bounds */
    RgnPtr content = *(window->contentRgn);
    r = content->rgnBBox;

    if (!PtInRect(test_pt, &r))
        return 0;  /* Outside content */

    /* Test title bar */
    RgnPtr title = *(window->titleRgn);
    if (PtInRect(test_pt, &title->rgnBBox)) {
        if (modifiers != 0) {
            /* Check close box (16x16 area) */
            r.right = r.top - 16;
            r.bottom = r.left - 16;
            if (PtInRect(test_pt, &r))
                return 3;  /* Close box */
        }
        return 1;  /* Title bar */
    }

    /* Test grow box */
    r.bottom = r.top + 13;
    if (PtInRect(test_pt, &r)) {
        if (window->pattern_flag1) {
            Rect pat_r;
            adjust_rect_with_offset(window, &pat_r);
            if (PtInRect(test_pt, &pat_r))
                return 4;  /* Pattern area */
        }
        return 2;  /* Grow box */
    }

    return 0;  /* Content */
}
```

**Hit codes:**
| Code | Region | Description |
|------|--------|-------------|
| 0 | Content | Main content area or outside |
| 1 | Title | Title bar (draggable) |
| 2 | Grow | Grow/resize box |
| 3 | Close | Close box (top-left) |
| 4 | Pattern | Pattern/special area |

### Function 0x05D2 - Check If Window Is in Managed List
**Hex verification:** `4E56 0000 2F2E 0008` = LINK A6,#0; MOVE.L 8(A6),-(SP)

```
Parameters: 8(A6)=window_ptr
Returns: D0 = 1 if managed, 0 if not
```

Two-step check:
1. Calls JT[1610] (check_window_state) with the window. If result is non-zero (TST.W D0, BNE), proceed to step 2.
2. Calls JT[3434] (get_window_flags) with the window. Tests result AND #$0080 (bit 7). If bit 7 is SET, returns 0 (NOT managed). If clear, returns 1 (IS managed).

The logic is: a window is "managed" if it passes the state check AND does NOT have bit 7 set in its flags.

```c
short is_window_in_managed_list(WindowPtr window) {
    if (check_window_state(window) == 0)  /* JT[1610] */
        return 0;

    short flags = get_window_flags(window);  /* JT[3434] */
    if (flags & 0x0080)
        return 0;  /* Has "unmanaged" flag */

    return 1;
}
```

### Function 0x05FE - Get Window Flags (Bit 7)
**Hex verification:** `4E56 0000 2F2E 0008` = LINK A6,#0; MOVE.L 8(A6),-(SP)

```
Parameters: 8(A6)=window_ptr
Returns: D0 = flags AND $0080
```

Simple wrapper that calls JT[3434] and masks the result to isolate bit 7. Returns the masked value (0 or $0080).

```c
short get_window_flags(WindowPtr window) {
    return get_window_properties(window) & 0x0080;  /* JT[3434] */
}
```

### Function 0x0612 - Invoke Window Procedure Callback
**Hex verification:** `4E56 0000 48E7 0018 99CC` = LINK A6,#0; MOVEM.L A3/A4,-(SP); SUBA.L A4,A4

```
Parameters: 8(A6)=param
Returns: D0 = A4 (callback result)
```

Indirect procedure call mechanism. Checks g_active_window (A5-1330). If non-NULL:
1. Pushes $0011 (17) and g_active_window to stack
2. Calls JT[522] (look up procedure) -- this resolves a procedure ID to a code address
3. Stores result in D7 via MOVE.L D0,D7
4. Calls JT[514] (get procedure address) -- loads the actual function pointer
5. Stores result in A3
6. If A3 is non-NULL: calls the procedure via JSR (A3) with param and g_active_window as arguments
7. Stores result (from A0 -> A4)
8. Returns A4

This is the "call window procedure" pattern: look up a procedure table entry for the active window, resolve it, and invoke it.

```c
WindowPtr invoke_window_proc(long param) {
    WindowPtr result = NULL;

    if (g_active_window != NULL) {
        /* Look up procedure #17 for the active window */
        ProcPtr proc;
        push_args(0x0011, g_active_window);
        lookup_proc();        /* JT[522] */
        long type = D7;
        get_proc_address();   /* JT[514] */
        proc = (ProcPtr)A3;

        if (proc != NULL) {
            result = (*proc)(param, g_active_window);
        }
    }
    return result;
}
```

### Function 0x0654 - Show Window and Update System List
**Hex verification:** `4E56 0000 2F0C 286E 0008` = LINK A6,#0; MOVE.L A4,-(SP); MOVEA.L 8(A6),A4

```
Parameters: 8(A6)=window_ptr
```

Manages window visibility with system front window ($0A64) tracking. The logic:

1. Compare A4 with g_front_window (A5-1326). If equal, skip to show.
2. Compare A4 with g_active_window (A5-1330). If not equal, proceed with front window update.
3. Load nextWindow (offset 144) of the current window. Call get_window_flags (0x05FE) to check if the next window is managed.
4. If managed: update $0A64 (system CurDeactive) to point to A4's nextWindow (offset 144).
5. If NOT managed: walk the $0A64 chain checking offset 110 (visible) on each entry, updating $0A64.
6. Call ShowWindow(A4, FALSE) via _ShowWindow trap.
7. Call initialize_window_tracking (0x0A26) to rebuild the window list.
8. If g_front_window is non-NULL, call reorder_activate_window (0x0866) with g_front_window and flag=1.

```c
void show_window_in_list(MavenWindow *window) {
    if (window == g_front_window || window == g_active_window)
        goto do_show;

    short flags = get_window_flags(window->nextWindow);
    if (flags) {
        CurDeactive = window->nextWindow;
    } else {
        WindowPtr w = CurDeactive;
        while (w) {
            CurDeactive = w->nextWindow;
            if (CurDeactive == NULL) break;
            w = CurDeactive;
            if (!w->visible) break;
        }
    }

do_show:
    ShowWindow(window, false);
    initialize_window_tracking();

    if (g_front_window != NULL) {
        reorder_activate_window(g_front_window, true);
    }
}
```

### Function 0x06BE - Set Window Order (DrawBehind)
**Hex verification:** `4E56 0000 2F2E 0008` = LINK A6,#0; MOVE.L 8(A6),-(SP)

```
Parameters: 8(A6)=window_ptr
```

Simple wrapper: calls invoke_window_proc (0x0654) with the parameter, stores the parameter at (A6+8) for later use, then calls _DrawBehind (A92D). This causes the window manager to redraw the desktop behind the specified window.

```c
void set_window_order(WindowPtr window) {
    invoke_window_proc(window);
    DrawBehind(window);
}
```

### Function 0x06D4 - Create Color Window (NewCWindow Wrapper)
**Hex verification:** `4E56 FFFC 2F0C` = LINK A6,#-4; MOVE.L A4,-(SP)

```
Parameters: 8(A6)=boundsRect, 12(A6)=title, 16(A6)=visible/style,
            18(A6)=behind, 20(A6)=refCon, 24(A6)=goAway(B),
            28(A6)=behind_window, 30(A6)=storage
Returns: D0 = A4 = new window pointer
```

Creates a new color window via _NewCWindow (A913), then performs post-creation setup:

1. Pushes all parameters in correct order for NewCWindow (result space, storage, bounds, title, visible=FALSE, procID, behind, goAway flag, refCon).
2. Calls _NewCWindow (A913).
3. Pops result into A4.
4. Checks if 24(A6) == -1 ($FFFF). If so:
   - Calls _HiliteWindow(A4, true) to highlight
   - Calls select_or_show_window (0x0962) to make it front
5. Else if 24(A6) != 0:
   - Calls hide_and_reorder_window (0x08E4) with the behind parameter
6. Checks 20(A6) (goAway flag). If set, calls activate_window (0x073E).
7. Returns window pointer.

```c
WindowPtr create_color_window(Ptr storage, Rect *bounds, StringPtr title,
                               short procID, Boolean visible, WindowPtr behind,
                               Boolean goAway, long refCon) {
    WindowPtr window;

    window = NewCWindow(storage, bounds, title, false, procID,
                         behind, goAway, refCon);

    if (behind == (WindowPtr)-1) {
        HiliteWindow(window, true);
        select_or_show_window(window);
    } else if (behind != NULL) {
        hide_and_reorder_window(behind, window);
    }

    if (visible) {
        activate_window(window);
    }

    return window;
}
```

### Function 0x073E - Activate/Bring-to-Front Window
**Hex verification:** `4E56 0000 2F0C 286E 0008` = LINK A6,#0; MOVE.L A4,-(SP); MOVEA.L 8(A6),A4

```
Parameters: 8(A6)=window_ptr
```

Calls get_window_flags (0x05FE). If the window has the managed flag:
- HiliteWindow(window, true)
- ShowWindow(window, true)

Otherwise:
- BringToFront(window) via A915 trap

```c
void activate_window(MavenWindow *window) {
    if (get_window_flags(window)) {
        HiliteWindow(window, true);
        ShowWindow(window, true);
    } else {
        BringToFront(window);
    }
}
```

### Function 0x0770 - Check If Window Belongs to Managed Set
**Hex verification:** `4E56 FFFC 2F2D FAD6` = LINK A6,#-4; MOVE.L -1322(A5),-(SP)

```
Parameters: 8(A6)=window_ptr (or 0)
Returns: D0 = 0 or 1
```

Calls JT[1610] with g_focus_window. If that returns zero (unmanaged focus):
- If 8(A6) is NULL: return 0
- Compare 8(A6) with g_front_window (A5-1326): if equal, return 1
- Compare 8(A6) with g_active_window (A5-1330): if equal, return 1
- Otherwise return 0

This checks if a given window is part of the managed window set by comparing against the known tracked windows.

### Non-LINK Leaf Function 0x07A6 - Get Screen Bit Depth
**Hex verification:** `3038 0BAA 4E75` = MOVE.W $0BAA.W,D0; RTS

```
Parameters: none
Returns: D0 = screen bit depth
```

Two-instruction leaf function. Reads the screen bit depth from low-memory global $0BAA and returns it. Used by the window creation code to determine if color window features should be enabled.

```c
short get_screen_depth(void) {
    return *(short*)0x0BAA;
}
```

### Function 0x07AC - Open Window with Region Setup
**Hex verification:** `4E56 FFF8 48E7 0138` = LINK A6,#-8; MOVEM.L D7/A3/A4,-(SP)

```
Parameters: 8(A6)=window_ptr, 12(A6)=bounds_left(W), 16(A6)=bounds_top(W)
Local: -8(A6)=work_rect(8), -4(A6)=saved_port(4)
```

Full window initialization with region setup and port configuration:

1. Checks GetNextEvent (A973) -- peeks at event queue (result in Boolean return)
2. Saves current port, calls GetPort/GlobalToLocal
3. Gets QuickDraw globals, calls GlobalToLocal
4. Creates two NewRgn for content and title regions
5. Calls MovePortTo to set port origin
6. Calls PortSize with $09EE (screen row bytes)
7. Calls GetWMgrPort to get window manager port
8. Pushes bounds parameters and various flags
9. Calls NewWindow (A905) -- creates a standard window
10. Gets the result (window) into D7
11. Pushes 0 (false) and D7, calls OpenPort (A86A)
12. Stores result in -4(A6)
13. Compares created window bounds against screen depth check
14. If bounds are valid (not $8000xxxx which indicates error):
    - Gets window title region offsets at +16/+18
    - Adds region offset to local rect
    - Calls GlobalToLocal to convert
    - Calls SetPortBits
    - Calls SetWTitle with computed position
15. Restores port via GlobalToLocal

This is the heavy-lifting window opener that sets up all the internal regions, port mapping, and coordinate transforms needed for a fully functional custom window.

```c
WindowPtr open_window_with_regions(MavenWindow *window, short bounds_left, short bounds_top) {
    GrafPtr saved_port;
    Rect r;
    RgnHandle content_rgn, title_rgn;

    if (!GetNextEvent(0, NULL)) return NULL;

    GetPort(&saved_port);
    GlobalToLocal(&local_pt);

    /* Set up port */
    MovePortTo(/*...*/);
    PortSize(*(long*)0x09EE);
    GetWMgrPort(&wm_port);

    /* Create regions */
    content_rgn = NewRgn();
    CopyRgn(content_rgn, /*...*/);
    title_rgn = NewRgn();
    CopyRgn(title_rgn, /*...*/);

    /* Create the window */
    WindowPtr new_win = NewWindow(NULL, &r, /*title*/, false, 0, NULL, /*...*/);

    /* Set up port bitmap */
    OpenPort(new_win, false);

    /* Adjust regions for screen position */
    if (r.top != (short)0x8000) {
        short dx = window->portRect.left + r.left;
        short dy = window->portRect.top + r.top;
        GlobalToLocal(&pt);
        SetPortBits(/*...*/);
        SetWTitle(new_win, /*computed title*/);
    }

    GlobalToLocal(&saved_port);
    return new_win;
}
```

### Function 0x0866 - Reorder and Activate Window
**Hex verification:** `4E56 FFFA 48E7 0118` = LINK A6,#-6; MOVEM.L D7/A3/A4,-(SP)

```
Parameters: 8(A6)=window_ptr, 12(A6)=activate_flag(B)
```

Activates a window and reorders the window list:

1. Calls _HiliteWindow(window, activate_flag) to set visual highlight state
2. Calls _GlobalToLocal on the window port
3. Checks g_active_window. If non-NULL:
   - Compares g_focus_window with g_active_window
   - Sets D7 = (focus != active) ? 1 : 0 via SEQ/NEG.B
   - Walks from g_active_window through nextWindow chain (offset 144):
     - For each window in chain: HiliteWindow(window, D7)
     - Stops when reaching g_last_window (A5-1318)
4. If g_front_window is non-NULL:
   - Walks from g_front_window->nextWindow:
     - For each: calls is_window_in_managed_list (0x05D2)
     - If managed: HiliteWindow(window, false)
   - Continues until end of chain
5. Calls JT[1562] (window cleanup handler) with the original window

```c
void reorder_activate_window(MavenWindow *window, Boolean activate) {
    HiliteWindow(window, activate);
    GlobalToLocal(&window->portRect);

    if (g_active_window != NULL) {
        Boolean hilite = (g_focus_window != g_active_window);
        WindowPtr w = g_active_window;
        while (w != NULL) {
            HiliteWindow(w, hilite);
            if (w == g_last_window) break;
            w = w->nextWindow;
        }
    }

    if (g_front_window != NULL) {
        WindowPtr w = g_front_window->nextWindow;
        while (w != NULL) {
            if (is_window_in_managed_list(w)) {
                HiliteWindow(w, false);
            }
            w = w->nextWindow;
        }
    }

    window_cleanup(window);  /* JT[1562] */
}
```

### Function 0x08E4 - Hide and Reorder Window
**Hex verification:** `4E56 FFF8 48E7 0018` = LINK A6,#-8; MOVEM.L A3/A4,-(SP)

```
Parameters: 8(A6)=window_ptr, 12(A6)=behind_param
```

Handles window hiding with proper reordering:

1. Saves port, calls GetPort/GlobalToLocal
2. Creates two NewRgn for scratch computation
3. Dereferences window->refCon (offset 24), copies title region
4. Calls SendBehind(window, behind_param) via A921
5. Gets window content region bounds, calls SetPortBits
6. Computes OffsetRgn to adjust title position
7. Performs XorRgn of old and new title positions
8. Calls SetPort to window manager port
9. Calls HideWindow (A90A)
10. Restores saved port, disposes scratch regions

```c
void hide_and_reorder_window(MavenWindow *window, WindowPtr behind) {
    GrafPtr saved_port;
    RgnHandle scratch1, scratch2;

    GetPort(&saved_port);
    GlobalToLocal(/*...*/);

    scratch1 = NewRgn();
    CopyRgn(window->contentRgn, scratch1);

    scratch2 = NewRgn();
    CopyRgn(scratch2, /*...*/);

    /* Reorder */
    SendBehind(window, behind);

    /* Compute dirty region */
    Rect *bounds = &(*(window->contentRgn))->rgnBBox;
    SetPortBits(/*...*/);

    short dy = bounds->bottom - (*scratch1)->rgnBBox.bottom;
    OffsetRgn(scratch1, 0, dy);

    /* XOR old/new to find changed area */
    XorRgn(window->contentRgn, scratch1, scratch1);

    /* Update */
    SetPort(window);
    HideWindow(window);

    GlobalToLocal(/*...*/);
    DisposeRgn(scratch2);
}
```

### Function 0x0962 - Select or Show Window (Main Dispatch)
**Hex verification:** `4E56 FFF0 2F0C 286E 0008` = LINK A6,#-16; MOVE.L A4,-(SP); MOVEA.L 8(A6),A4

```
Parameters: 8(A6)=window_ptr
```

The main window selection/visibility dispatcher. Contains two major branches based on whether the window is currently in the managed list:

**Branch 1: Window IS managed** (is_window_in_managed_list returns true):
1. If g_active_window is non-NULL:
   - Calls hide_and_reorder_window(window, g_last_window) to move to correct Z-order
   - Compares g_active_window with g_focus_window
   - If equal: calls SelectWindow(g_active_window)
   - If not equal: calls reorder_activate_window(window, 1) to activate
2. Calls reorder_activate_window(g_front_window, 0) to deactivate the old front

**Branch 2: Window is NOT managed**:
- Calls SelectWindow(window) directly

**Branch 3: Window passes get_window_flags but not is_managed**:
1. If g_focus_window is non-NULL:
   - Calls JT[1610] to check g_focus_window state
   - If valid: calls set_front_and_select (0x09F6)
2. Otherwise: calls SelectWindow(window)

```c
void select_or_show_window(MavenWindow *window) {
    if (is_window_in_managed_list(window)) {
        if (g_active_window != NULL) {
            hide_and_reorder_window(window, g_last_window);

            if (g_active_window == g_focus_window)
                SelectWindow(g_active_window);
            else
                reorder_activate_window(window, true);

            reorder_activate_window(g_front_window, false);
        }
    } else if (get_window_flags(window)) {
        if (g_focus_window != NULL) {
            if (check_window_state(g_focus_window))  /* JT[1610] */
                set_front_and_select(window);
            else
                SelectWindow(window);
        } else {
            SelectWindow(window);
        }
    } else {
        SelectWindow(window);
    }
}
```

### Function 0x09F6 - Set Front Window and Select
**Hex verification:** `4E56 FFFC 2F2E 0008` = LINK A6,#-4; MOVE.L 8(A6),-(SP)

```
Parameters: 8(A6)=window_ptr
Returns: none
```

Sets the system front window globals and calls FrontWindow:

1. Calls get_window_flags (0x05FE) on the parameter
2. If flagged: sets $0A68 (CurActivate) = g_active_window
3. If not flagged: sets $0A68 = g_front_window
4. Calls _FrontWindow (A920) trap
5. Stores parameter at $0A64 (CurDeactive/system front)

```c
void set_front_and_select(WindowPtr window) {
    if (get_window_flags(window))
        *(WindowPtr*)0x0A68 = g_active_window;
    else
        *(WindowPtr*)0x0A68 = g_front_window;

    FrontWindow();
    *(WindowPtr*)0x0A64 = window;
}
```

### Function 0x0A26 - Initialize Window Tracking (Non-LINK)
**Hex verification:** `48E7 0338` = MOVEM.L D6/D7/A2/A3/A4,-(SP) (no LINK frame)

```
Parameters: none
Returns: D0 = appropriate window pointer
```

The master window list rebuild function. This is the only non-LINK framed function in CODE 46 (it uses register save/restore via MOVEM.L without a frame pointer). Walks the entire system window list and updates all four A5-relative window tracking globals.

**Algorithm:**

1. Initialize: D7=1 (flag1), D6=0 (flag2)
2. Clear all globals: g_front_window=NULL, g_active_window=NULL, g_focus_window=NULL, g_last_window=-1
3. Get WindowList head from $09D6
4. For each window in the list (linked via offset 144):
   a. Skip if not visible (TST.B offset 110)
   b. If g_focus_window is NULL: set it to this window
   c. Call is_window_in_managed_list (0x05D2):
      - If managed AND g_front_window is NULL: set g_front_window, clear D7
      - If managed AND g_front_window already set: do nothing for front
   d. Call get_window_flags (0x05FE):
      - If flagged AND g_front_window is NULL: compare with g_focus_window
        - If different: SelectWindow, update g_focus_window
        - Else: SendBehind to reorder, update pointers
      - Update g_active_window if NULL
      - Update g_last_window
5. Post-loop reordering:
   - If D7 is still 0 (found a managed front window):
     - Walk from g_front_window (or g_last_window) through chain
     - For each flagged window: swap title region values via offset+4, SendBehind, restore
   - This ensures proper visual layering
6. Return: if g_active_window != g_focus_window, return g_front_window; else return g_focus_window

```c
WindowPtr initialize_window_tracking(void) {
    Boolean found_managed = true;  /* D7 = 1 */
    Boolean flag2 = false;          /* D6 = 0 */

    g_front_window = NULL;
    g_active_window = NULL;
    g_focus_window = NULL;
    g_last_window = -1;

    MavenWindow *current = (MavenWindow*)WindowList;

    while (current != NULL) {
        if (!current->visible) {
            current = current->nextWindow;
            continue;
        }

        if (g_focus_window == NULL)
            g_focus_window = (WindowPtr)current;

        if (is_window_in_managed_list(current)) {
            if (g_front_window == NULL) {
                g_front_window = (WindowPtr)current;
                if (!flag2) found_managed = false;
            }
        } else if (get_window_flags(current)) {
            if (g_front_window == NULL) {
                if (current != g_focus_window) {
                    SelectWindow(current);
                    g_focus_window = (WindowPtr)current;
                } else {
                    SendBehind(current, g_front_window);
                    current = g_front_window;
                }
            }
            if (g_active_window == NULL)
                g_active_window = (WindowPtr)current;
            g_last_window = (long)current;
        } else {
            flag2 = true;
        }

        current = current->nextWindow;
    }

    /* Post-loop: reorder flagged windows behind managed ones */
    if (!found_managed && g_front_window != NULL) {
        WindowPtr base = g_front_window ? g_front_window : g_last_window;
        MavenWindow *w = g_active_window->nextWindow;

        while (w != NULL && w != base) {
            if (check_window_state(w)) {  /* JT[1610] */
                RgnPtr title = *(w->titleRgn);
                short saved = title->rgnBBox.bottom;
                title->rgnBBox.bottom = title->rgnBBox.top;

                SendBehind(w, base);

                title->rgnBBox.right = saved;
                w = g_active_window;
            }
            w = w->nextWindow;
        }
    }

    if (g_active_window != g_focus_window)
        return g_front_window;
    return g_focus_window;
}
```

### Function 0x0B3C - Configure Window Visibility Flag
**Hex verification:** `4E56 0000 206E 000C` = LINK A6,#0; MOVEA.L 12(A6),A0

```
Parameters: 8(A6)=window_ptr, 12(A6)=flags_ptr
```

Extracts bit 0 from byte at offset 15 of the flags parameter (AND.B #1, 15(A0)), pushes it as a Boolean, then calls reorder_activate_window (0x0866) with the window and the extracted flag.

```c
void configure_window_visible(WindowPtr window, void *flags) {
    Boolean activate = ((char*)flags)[15] & 0x01;
    reorder_activate_window(window, activate);
}
```

## Internal Call Graph

```
window_event_dispatcher (0x0000)
  |-> draw_board_square (0x0268)
  |     |-> adjust_rect_with_offset (0x0234)
  |     |     |-> set_content_rect (0x020C)
  |     |-> set_content_rect (0x020C)
  |     |-> fill_pattern (0x01BA)
  |-> compute_clip_region (0x047E)
  |-> hit_test_point (0x050C)
  |     |-> adjust_rect_with_offset (0x0234)
  |-> draw_3d_border (0x0086)
  |-> draw_3d_border_extended (0x0100)
        |-> initialize_window_tracking (0x0A26)
              |-> is_window_in_managed_list (0x05D2)
              |     |-> JT[1610] check_window_state
              |     |-> JT[3434] get_window_flags
              |-> get_window_flags (0x05FE)
              |     |-> JT[3434]

show_window_in_list (0x0654)
  |-> get_window_flags (0x05FE)
  |-> initialize_window_tracking (0x0A26)
  |-> reorder_activate_window (0x0866)
        |-> is_window_in_managed_list (0x05D2)
        |-> JT[1562] window_cleanup

set_window_order (0x06BE)
  |-> invoke_window_proc (0x0612)
  |     |-> JT[522] look_up_procedure
  |     |-> JT[514] get_procedure_address

create_color_window (0x06D4)
  |-> select_or_show_window (0x0962)
  |     |-> is_window_in_managed_list (0x05D2)
  |     |-> hide_and_reorder_window (0x08E4)
  |     |-> reorder_activate_window (0x0866)
  |     |-> set_front_and_select (0x09F6)
  |           |-> get_window_flags (0x05FE)
  |-> hide_and_reorder_window (0x08E4)
  |-> activate_window (0x073E)
        |-> get_window_flags (0x05FE)

configure_window_visible (0x0B3C)
  |-> reorder_activate_window (0x0866)
```

## Architecture Notes

1. **Custom WDEF pattern**: CODE 46 implements a complete custom window definition function (WDEF). The event dispatcher at 0x0000 follows the standard WDEF calling convention with event type codes matching Apple's WDEF specification (draw=0, hit=1, calcRgns=2, new=3(?), dispose=4(?), grow=5, idle=6(?)).

2. **Window list management**: Rather than relying solely on the Window Manager's built-in ordering, Maven maintains its own parallel tracking via four A5-relative globals. This allows it to implement custom Z-ordering policies (e.g., keeping certain windows always-on-top or grouping related windows).

3. **Region-based clipping**: The compute_clip_region function (0x047E) uses the full region arithmetic suite (NewRgn/RectRgn/DiffRgn/DisposeRgn) to compute precise clip regions that exclude the inner content area from frame drawing.

4. **3D appearance**: The 3D border drawing (0x0086, 0x0100) implements Mac OS 7+ "platinum" appearance with distinct highlight/shadow edges, giving windows a raised/embossed look before Apple provided this in the Appearance Manager.

5. **Pattern fills**: The checkerboard pattern system (0x01BA) uses bit-selected patterns ($00AA00AA / $00550055) with optional rotation, likely for board square differentiation (premium squares, etc.).

6. **Low-memory manipulation**: Direct writes to $0A64 (CurDeactive) and $0A68 (CurActivate) indicate this code manipulates the Window Manager's internal activation tracking, which was a common (if fragile) technique in Classic Mac programming.

## Confidence: HIGH

All QuickDraw trap sequences match documented Apple usage. The window list traversal pattern (offset 144 = nextWindow) is standard WindowRecord layout. Region manipulation sequences are canonical. The WDEF event dispatch codes align with Inside Macintosh documentation. The only uncertain areas are some of the more complex reordering logic in initialize_window_tracking, where multiple flag combinations create nuanced behavior paths.
