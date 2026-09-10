# CODE 20 text-size switch

The function at +0x07ee loads a pointer from A5-0x2180 and reads its word
at offset 10. After subtracting 12, an unsigned check against 16 selects
the 17-entry inline table at +0x082e. Its destinations choose these sizes:

| Input word | TextSize argument |
|---|---:|
| 12 | 10 |
| 14 | 12 |
| 15 | 13 |
| 18, 20 | 14 |
| 26, 28 | 24 |

All other values branch to the Debugger wrapper A5+0x01a2. If that returns
normally preserving D7, the routine uses the incoming D7 low word rather
than a defined constant. The routine saves/restores the caller's full D7 and
calls TextSize (A88A). The readable reconstruction makes the fallback word
explicit; no default font size is invented.

`drawing_text_size.c` reconstructs this control flow. Its host test checks
all signed-word inputs and debugger-before-TextSize ordering. The input
structure's identity, normal caller values, original register fallback and
Toolbox behavior have not been captured live. This source association covers
+0x07ee..0x082e; the adjacent jump-table bytes are data, not source instructions.

## Startup layout selection

The pointer is assigned by CODE 15+0x04f4..0x0518. Signed word comparisons
against 640 at A5-0x05a4 and 480 at A5-0x05a6 choose A5-0x1c68 when both
thresholds are met, otherwise A5-0x1bfe. These adjacent records are 106 bytes
apart. The saved snapshot selects the first record, whose word at offset 10
is 26; the second record contains 18. Their raw bytes and snapshot identity
are preserved in `drawing-layout-records.json`. Identifying the dimension
globals' writer remains necessary before treating them as proven screen size.

CODE 20+0x0a2c multiplies the same offset-10 word by a board coordinate,
and +0x0a40 multiplies it by 15 for a line extent. Thus cell spacing is a
better interpretation than font size for this input. The text-size switch
maps the captured large/small spacing values to 24/14. This is a static
data-flow interpretation supported by saved values, not a newly captured
natural TextSize call. Other record fields remain unnamed pending audit.

## QuickDraw ownership of the dimensions

The recovered QuickDraw.h declaration places screenBits 122 bytes before
qd.thePort (14-byte BitMap, 68-byte Cursor, five 8-byte Patterns). CODE 15
at +0x0cd0 pushes A5-0x0536 and calls InitGraf at +0x0cd4. Subtracting 122
locates screenBits at A5-0x05b0 and its bounds at A5-0x05aa. Thus A5-0x05a6
and A5-0x05a4 are bounds.bottom and bounds.right respectively.

The saved bitmap contains baseAddr F9001000, rowBytes 128, and bounds
top=0, left=0, bottom=480, right=640. `quickdraw-screen-bounds.json` records
header/snapshot hashes, the exact bitmap bytes and the InitGraf instruction
check. This establishes the structure and initialization API behind the
selection. Strictly, Maven compares right and bottom coordinates, without
subtracting left and top; describing it as width/height assumes the observed
zero origin. No new live InitGraf or TextSize call trace was collected.
