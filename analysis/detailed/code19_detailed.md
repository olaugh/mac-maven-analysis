# CODE 19 Detailed Analysis - Window Flag Toggles

## Overview

| Property | Value |
|----------|-------|
| Size | 382 bytes |
| JT Offset | 848 |
| JT Entries | 10 |
| Functions | 11 |
| Purpose | **Window display option toggles (show/hide features)** |

## Architecture Role

CODE 19 provides toggle functions for window display options:
1. Toggle boolean flags in window data structure
2. Each flag controls visibility of different UI elements
3. Uses SEQ/NEG.B pattern for boolean inversion
4. Triggers refresh after toggle

## Key Functions

### Function 0x0000 - Unknown Setter with Modal
```asm
0000: LINK       A6,#0
0004: MOVE.L     12(A6),-(A7)         ; Push parameter
0008: MOVE.W     18(A6),-(A7)         ; Push parameter
000C: MOVEA.L    -8584(A5),A0         ; A0 = window handle
0010: MOVEA.L    (A0),A0              ; Dereference
0012: MOVE.B     775(A0),-(A7)        ; Push byte at offset 775
0016: A945                            ; ModalDialog trap
001A: UNLK       A6
001C: RTS
```

### Function 0x001E - Toggle Flag at Offset 774
```asm
001E: LINK       A6,#0
0022: MOVEA.L    -8584(A5),A0         ; A0 = window handle
0026: MOVEA.L    (A0),A0              ; Dereference
0028: TST.W      774(A0)              ; Test current value
002C: SEQ        D0                   ; Set if equal (zero)
002E: NEG.B      D0                   ; Convert to 0/-1
0030: EXT.W      D0                   ; Extend to word
0032: MOVEA.L    -8584(A5),A0         ; Get handle again
0036: MOVEA.L    (A0),A0              ; Dereference
0038: MOVE.W     D0,774(A0)           ; Store toggled value
003C: JSR        970(A5)              ; JT[970] - refresh
0040: UNLK       A6
0042: RTS
```

**C equivalent**:
```c
void toggle_flag_774() {
    WindowData** wh = g_window_handle;  // A5-8584
    WindowData* w = *wh;

    // Toggle: if 0 -> -1 (true), if non-zero -> 0 (false)
    w->flag_774 = (w->flag_774 == 0) ? -1 : 0;

    refresh_window();  // JT[970]
}
```

### Function 0x0062 - Toggle Flag at Offset 776
```asm
0062: LINK       A6,#0
0066: MOVEA.L    -8584(A5),A0         ; Window handle
006A: MOVEA.L    (A0),A0              ; Dereference
006C: TST.W      776(A0)              ; Test flag
0070: SEQ        D0                   ; Set if zero
0072: NEG.B      D0                   ; Convert
0074: EXT.W      D0                   ; Extend
0076: MOVEA.L    -8584(A5),A0         ; Get handle
007A: MOVEA.L    (A0),A0              ; Dereference
007C: MOVE.W     D0,776(A0)           ; Store toggled
0080: JSR        970(A5)              ; JT[970] - refresh
0084: UNLK       A6
0086: RTS
```

### Function 0x00A6 - Toggle Flag at Offset 778
```asm
00A6: LINK       A6,#0
00AA: MOVEA.L    -8584(A5),A0
00AE: MOVEA.L    (A0),A0
00B0: TST.W      778(A0)              ; Test flag 778
00B4: SEQ        D0
00B6: NEG.B      D0
00B8: EXT.W      D0
00BA: MOVEA.L    -8584(A5),A0
00BE: MOVEA.L    (A0),A0
00C0: MOVE.W     D0,778(A0)           ; Store toggled
00C4: JSR        962(A5)              ; JT[962] - different refresh!
00C8: UNLK       A6
00CA: RTS
```

**Note**: This toggle calls JT[962] instead of JT[970], suggesting different refresh behavior.

### Function 0x00EA - Toggle Flag at Offset 782
```asm
00EA: LINK       A6,#0
00EE: MOVEA.L    -8584(A5),A0
00F2: MOVEA.L    (A0),A0
00F4: TST.W      782(A0)              ; Test flag 782
00F8: SEQ        D0
00FA: NEG.B      D0
00FC: EXT.W      D0
00FE: MOVEA.L    -8584(A5),A0
0102: MOVEA.L    (A0),A0
0104: MOVE.W     D0,782(A0)           ; Store toggled
0108: CLR.W      -(A7)                ; Push 0
010A: JSR        1274(A5)             ; JT[1274]
010E: UNLK       A6
0110: RTS
```

### Function 0x012E - Toggle Flag at Offset 784
```asm
012E: LINK       A6,#0
0132: MOVEA.L    -8584(A5),A0
0136: MOVEA.L    (A0),A0
0138: TST.W      784(A0)              ; Test flag 784
013C: SEQ        D0
013E: NEG.B      D0
0140: EXT.W      D0
0142: MOVEA.L    -8584(A5),A0
0146: MOVEA.L    (A0),A0
0148: MOVE.W     D0,784(A0)           ; Store toggled
014C: JSR        1154(A5)             ; JT[1154]
0150: UNLK       A6
0152: RTS
```

### Function 0x0172 - Simple Wrapper
```asm
0172: LINK       A6,#0
0176: JSR        202(A5)              ; JT[202]
017A: UNLK       A6
017C: RTS
```

## Toggle Pattern Analysis

All toggle functions use the same pattern:

```asm
TST.W      offset(A0)    ; Test current value
SEQ        D0            ; D0 = 0xFF if value was 0, else 0x00
NEG.B      D0            ; D0 = 0x01 if was 0xFF, else 0x00
                         ; Actually: 0 -> 0x01, non-zero -> 0x00
EXT.W      D0            ; Extend to word (0x0001 or 0x0000)
MOVE.W     D0,offset(A0) ; Store back
```

This converts:
- Zero to non-zero (specifically -1 or 0xFFFF when word extended)
- Non-zero to zero

## Window Data Structure Flags

| Offset | Size | Purpose | Refresh Call |
|--------|------|---------|--------------|
| 774 | 2 | Display option A | JT[970] |
| 775 | 1 | Modal dialog flag | - |
| 776 | 2 | Display option B | JT[970] |
| 777 | 1 | (byte at odd address) | - |
| 778 | 2 | Display option C | JT[962] |
| 779 | 1 | (byte getter at 0x0088) | - |
| 781 | 1 | (byte getter at 0x0154) | - |
| 782 | 2 | Display option D | JT[1274] |
| 783 | 1 | (byte getter at 0x00CC) | - |
| 784 | 2 | Display option E | JT[1154] |
| 785 | 1 | (byte getter at 0x0112) | - |

## Likely UI Options

Based on the structure and Scrabble game context:
- **Flag 774**: Show/hide tile values
- **Flag 776**: Show/hide best word
- **Flag 778**: Show/hide player scores
- **Flag 782**: Show/hide move history
- **Flag 784**: Show/hide rack tiles

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-8584 | Main window handle |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 202 | Unknown function |
| 962 | Refresh type A |
| 970 | Refresh type B |
| 1154 | Refresh type C |
| 1274 | Refresh type D |

## Confidence: HIGH

Clear toggle pattern with standard boolean inversion:
- SEQ/NEG.B is idiomatic 68K boolean toggle
- Different refresh calls suggest different UI regions affected
- Window data structure offsets are consistent
