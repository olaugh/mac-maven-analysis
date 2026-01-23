# CODE 13 Detailed Analysis - Player/Direction Management

## Overview

| Property | Value |
|----------|-------|
| Size | 512 bytes |
| JT Offset | 592 |
| JT Entries | 4 |
| Functions | 5 |
| Purpose | **Player direction switching, move direction display, sound playback** |

## System Role

**Category**: UI Support
**Function**: Direction Management

Handles player move direction toggling (hook-after/hook-before) and manages direction indicators on the board display. Also provides sound playback support.

**Related CODE resources**:
- CODE 21 (main UI)
- CODE 20 (board state)
- CODE 6 (window management)

## Architecture Role

CODE 13 handles player direction management:
1. Toggle between hook-after and hook-before move directions
2. Update direction indicators on the game board
3. Manage player-specific direction settings
4. Coordinate UI updates when direction changes
5. Play sound effects

## Key Data Structures

### Window Data Structure (partial)
```c
struct WindowData {
    // ... earlier fields ...
    short toggle_state;       // Offset 768: Direction toggle state
    short current_player;     // Offset 770: Current player (0 or 1)
    // Player data starts at offset 10, size 192 bytes per player
    struct PlayerData {
        // ...
        short direction;      // Offset 10 within player data
        // ...
    } players[2];
};
// Each player has 192 bytes of data
// player[n].direction = window_base + 10 + (n * 192)
```

## Key Functions

### Function 0x0000 - Handle Direction Toggle
```asm
0000: LINK       A6,#0
0004: MOVE.L     D7,-(A7)             ; Save D7
0006: MOVE.W     8(A6),D7             ; D7 = new direction
000A: CMPI.W     #$0013,D7            ; Compare with 19
000E: BLS.S      $003E                ; If <= 19, normal update

; Toggle mode (direction > 19)
0010: MOVEA.L    -8584(A5),A0         ; Get window handle
0014: MOVEA.L    (A0),A0              ; Dereference
0016: TST.W      768(A0)              ; Check current toggle state
001A: SEQ        D0                   ; D0 = (state == 0) ? 0xFF : 0
001C: NEG.B      D0                   ; D0 = (state == 0) ? 1 : 0
001E: EXT.W      D0
0020: MOVEA.L    -8584(A5),A0
0024: MOVEA.L    (A0),A0
0026: MOVE.W     D0,768(A0)           ; Toggle the state

; Update display
002A: MOVEA.L    -8584(A5),A0
002E: MOVEA.L    (A0),A0
0030: MOVE.W     768(A0),-(A7)        ; Push new state
0034: MOVE.W     D7,-(A7)             ; Push direction
0036: JSR        430(PC)              ; Update display
003A: LEA        12(A7),A7
003C: BRA.S      $0078

; Normal direction update (direction <= 19)
003E: CLR.W      -(A7)                ; Push 0 (clear indicator)
0040: MOVEA.L    -8584(A5),A0
0044: MOVEA.L    (A0),A1
0046: MOVE.W     770(A1),D0           ; Get current player
004A: MULU.W     #192,D0              ; * 192 (player data size)
0050: MOVEA.L    (A0),A0
0054: MOVE.W     10(A0,D0.L),-(A7)    ; Get old direction
0058: JSR        400(PC)              ; Clear old indicator

; Set new direction
005C: MOVEA.L    -8584(A5),A0
0060: MOVEA.L    (A0),A1
0062: MOVE.W     770(A1),D0           ; Get player
0066: MULU.W     #192,D0
006C: MOVEA.L    (A0),A0
0068: MOVE.W     D7,10(A0,D0.L)       ; Set new direction

; Show new indicator
006C: MOVE.W     #$0001,(A7)          ; Push 1 (show)
0070: MOVE.W     D7,-(A7)             ; Push new direction
0072: JSR        370(PC)              ; Show new indicator
0076: LEA        12(A7),A7

0078: MOVE.L     (A7)+,D7
007A: UNLK       A6
007C: RTS
```

**C equivalent**:
```c
void handle_direction(short new_dir) {
    WindowData** wh = g_window_handle;  // A5-8584
    WindowData* w = *wh;

    if (new_dir > 19) {
        // Toggle mode - flip direction state
        w->toggle_state = (w->toggle_state == 0) ? 1 : 0;
        update_display(new_dir, w->toggle_state);
    } else {
        // Normal direction change
        short player = w->current_player;
        short old_dir = w->players[player].direction;

        clear_indicator(old_dir, 0);              // Hide old
        w->players[player].direction = new_dir;
        show_indicator(new_dir, 1);               // Show new
    }
}
```

### Function 0x007E - Check and Update Counter
```asm
007E: LINK       A6,#0
0082: CMPI.W     #256,-7454(A5)       ; If counter >= 256
0088: BLT.S      $008E
008A: CLR.W      -7454(A5)            ; Reset counter to 0
008E: MOVE.W     -7454(A5),D0         ; Get counter
0092: ADDQ.W     #1,-7454(A5)         ; Increment counter
0096: MOVEA.L    -7452(A5),A0         ; Get data pointer
009A: TST.B      0(A0,D0.W)           ; Check flag at counter index
009E: BEQ.S      $00AA                ; If zero, skip
00A0: MOVE.L     8(A6),-(A7)          ; Push param
00A4: JSR        2114(A5)             ; JT[2114] - update function
00A8: LEA        4(A7),A7
00AA: UNLK       A6
00AC: RTS
```

**C equivalent**:
```c
void check_and_update(void* param) {
    // Cycle through 256-entry array checking flags
    if (g_counter >= 256)
        g_counter = 0;

    short idx = g_counter++;
    if (g_flag_array[idx] != 0) {
        update_function(param);  // JT[2114]
    }
}
```

### Function 0x00AE - Get Direction-Based Search Area
```asm
00AE: LINK       A6,#-268             ; 268 bytes local
00B2: MOVEM.L    D5/D6/D7/A4,-(SP)

; Get current player's direction
00B6: MOVEA.L    -8584(A5),A0
00BA: MOVEA.L    (A0),A1
00BC: MOVE.W     770(A1),D0           ; Get player
00C0: MULU.W     #192,D0
00C6: MOVEA.L    (A0),A0
00CA: MOVE.W     10(A0,D0.L),D7       ; D7 = direction

; Get search area based on direction
00CE: MOVEA.L    -8584(A5),A0
; ... calculate search area pointer using direction ...
00E6: PEA        -24180(A0)           ; Push search area at A5-24180

; Setup drawing rectangles
00EA: PEA        -266(A6)             ; Local rect buffer
00EE: MOVE.W     #$200E,-(A7)         ; Push coordinates
00F2: A9EB                            ; SetRect trap
00F6: PEA        -266(A6)
00FA: MOVE.W     #$0002,-(A7)
00FE: A9EB                            ; InsetRect trap

; Check direction type
011A: CMPI.W     #1,D7
011E: BNE.S      $0138                ; Not direction 1

; Direction 1 - specific handling
0120: CLR.W      -(A7)
0122: MOVE.L     12(A6),-(A7)         ; Push params
0126: MOVE.L     8(A6),-(A7)
012A: JSR        2754(A5)             ; JT[2754] - search function
012E: MOVEA.L    D0,A4                ; A4 = result
0134: BRA.W      $01CA

; Other directions - general handling
0138: LEA        -256(A6),A0          ; Local 256-byte buffer
013C: MOVE.L     A0,-7452(A5)         ; Store buffer pointer

; Clear buffer
0140: PEA        $0100.W              ; 256 bytes
0144: PEA        -256(A6)
0148: JSR        426(A5)              ; JT[426] - memset

; Validate direction bounds
015C: CMPI.W     #19,10(A0,D0.L)      ; Direction < 19?
0162: LEA        16(A7),A7
0164: BCS.S      $016A
0166: JSR        418(A5)              ; JT[418] - bounds_error

; Build position array based on direction
016A: MOVEQ      #0,D5                ; D5 = count
016C: MOVE.W     D5,D6                ; D6 = position
016E: BRA.S      $0196

0170: CMPI.W     #256,D6              ; Wrap at 256
0174: BCS.S      $017E
0176: MOVE.W     D6,D0
0178: SUBI.W     #256,D0              ; D0 = D6 - 256
017C: MOVE.W     D0,D6

017E: LEA        -256(A6),A4
0182: ADDA.W     D6,A4                ; Index into buffer
0184: TST.B      (A4)                 ; Already set?
0186: BNE.S      $018C
0188: JSR        418(A5)              ; Error if conflict
018C: MOVE.B     #1,(A4)              ; Mark position
0190: ADDQ.W     #1,D5                ; count++
0192: ADDI.W     #17,D6               ; Next diagonal position

0196: ; ... continue based on direction count ...

; Perform search in area
01B6: PEA        642(A5)              ; Push constant
01BA: MOVE.L     8(A6),-(A7)          ; Push param
01BE: JSR        2130(A5)             ; JT[2130] - search
01C2: LEA        -23056(A5),A4        ; A4 = g_dawg_field
01C8: CLR.W      -23220(A5)           ; Clear result count

01CA: MOVE.L     A4,D0                ; Return result
01CE: MOVEM.L    (SP)+,D5/D6/D7/A4
01D4: UNLK       A6
01D6: RTS
```

### Function 0x01E6 - Play Sound
```asm
01E6: LINK       A6,#0
01EA: CLR.L      -(A7)                ; Push NULL (channel)
01EC: MOVE.W     #5,-(A7)             ; Push sound resource ID
01F0: A949                            ; GetResource trap
01F4: MOVE.W     8(A6),-(A7)          ; Push sound param
01F8: MOVE.B     11(A6),-(A7)         ; Push async flag
01FC: A945                            ; SndPlay trap
01FE: UNLK       A6
0200: RTS
```

**C equivalent**:
```c
void play_sound(short param, char async_flag) {
    Handle snd = GetResource('snd ', 5);
    SndPlay(NULL, snd, async_flag);
}
```

## Window Data Structure Details

| Offset | Size | Purpose |
|--------|------|---------|
| 768 | 2 | Toggle state (0 or non-zero) |
| 770 | 2 | Current player (0 or 1) |
| 10 + n*192 | 2 | Player n's direction (at offset 10 within 192-byte player block) |

## Player Data Block (192 bytes each)

| Offset | Size | Purpose |
|--------|------|---------|
| 10 | 2 | Move direction |
| ... | ... | Other player data |

## Direction Values

| Value | Meaning |
|-------|---------|
| 1-19 | Normal board positions/directions |
| 20+ | Toggle modes (special operations) |

## Global Variables

| Offset | Type | Name | Purpose |
|--------|------|------|---------|
| A5-7452 | long | flag_array_ptr | Pointer to 256-byte flag array |
| A5-7454 | short | cycle_counter | Counter (0-255) |
| A5-8584 | long | g_window_handle | Main window handle |
| A5-23056 | - | g_dawg_field | DAWG search field |
| A5-23220 | short | result_count | Search result count |
| A5-24180 | - | search_area_data | Search area data |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | bounds_check - Error handler |
| 426 | memset - Clear memory |
| 2114 | update_function |
| 2130 | search - Search in area |
| 2754 | direction_search - Direction-specific search |

## Toolbox Traps

| Trap | Purpose |
|------|---------|
| A945 | SndPlay - Play sound |
| A949 | GetResource - Load resource |
| A9EB | SetRect / InsetRect - Rectangle operations |

## Confidence: HIGH

Clear direction management patterns:
- Player state tracking via 192-byte player blocks
- Direction toggle logic with SEQ/NEG.B idiom
- Position calculation with modular arithmetic (wrap at 256)
- Sound playback using Mac Sound Manager
- UI update coordination through jump table calls
