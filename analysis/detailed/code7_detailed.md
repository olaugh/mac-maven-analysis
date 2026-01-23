# CODE 7 Detailed Analysis - Board State Management

## Overview

| Property | Value |
|----------|-------|
| Size | 2,872 bytes |
| JT Offset | 224 |
| JT Entries | 13 |
| Functions | 21 |
| Purpose | **Board state, rack management, game state transitions** |

## Architecture Role

CODE 7 manages the core game state including:
1. The two board buffers (g_field_14, g_field_22)
2. Game state structures (g_state1, g_state2)
3. State transitions (new game, load game)
4. Current buffer selection (g_current_ptr)

## Key Functions

### Function 0x0000 - Initialize/Switch to Field_14
```asm
0000: LINK       A6,#0
0004: MOVE.W     8(A6),-(A7)      ; push param
0008: JSR        1410(PC)         ; call local setup
000C: LEA        -15514(A5),A0    ; A0 = &g_field_14
0010: MOVE.L     A0,-15498(A5)    ; g_current_ptr = g_field_14
0014: TST.B      (A0)             ; test first byte
0018: BEQ.S      $001E            ; if zero...
001A: MOVEQ      #8,D0            ; D0 = 8 (loaded game mode)
001C: BRA.S      $0020
001E: MOVEQ      #0,D0            ; D0 = 0 (new game mode)
0020: MOVE.W     D0,-8604(A5)     ; g_game_mode = D0
0024: JSR        1034(A5)         ; JT[1034]
0028: JSR        1258(A5)         ; JT[1258] - post-search init
002C: JSR        1362(A5)         ; JT[1362] - state update
0030: JSR        658(A5)          ; JT[658] - init subsystem
0034: UNLK       A6
0036: RTS
```

**C equivalent**:
```c
void init_board_state(int param) {
    local_setup(param);
    g_current_ptr = &g_field_14;

    if (g_field_14[0] != 0) {
        g_game_mode = 8;  // Loaded game
    } else {
        g_game_mode = 0;  // New game
    }

    call_1034();
    post_search_init();
    state_update();
    init_subsystem();
}
```

### Function 0x0038 - Complex Game State Handler
```asm
0038: LINK       A6,#-2           ; small frame
003C: MOVEM.L    D3-D7/A2-A4,-(SP)
0040: MOVEA.L    8(A6),A3         ; A3 = param (game data ptr)
0044: MOVE.W     14(A6),D3        ; D3 = param3
0048: MOVE.W     12(A6),D0        ; D0 = param2 (action code)
004C: BEQ.S      $00C6            ; if 0, goto load
004E: BMI.W      $02E4            ; if negative, goto cleanup

; Action code > 0: Handle various states
006C: MOVEA.L    A3,A4            ; A4 = game data
006E: PEA        $0220.W          ; push 544
0072: PEA        -17154(A5)       ; push g_state1
0076: JSR        426(A5)          ; memset(g_state1, 0, 544)
007A: PEA        $0440.W          ; push 1088
007E: PEA        -16610(A5)       ; push g_state2
0082: JSR        426(A5)          ; memset(g_state2, 0, 1088)
0086: PEA        6(A4)            ; push &data->field_6
008A: PEA        -15514(A5)       ; push g_field_14
008E: JSR        3490(A5)         ; copy to g_field_14
0092: PEA        14(A4)           ; push &data->field_14
0096: PEA        -15522(A5)       ; push g_field_22
009A: JSR        3490(A5)         ; copy to g_field_22
009E: TST.W      2(A4)            ; check data->field_2
00A6: BEQ.S      $00B0
00A8: LEA        -15514(A5),A0    ; use g_field_14
00AC: MOVE.L     A0,D0
00AE: BRA.S      $00B6
00B0: LEA        -15522(A5),A0    ; use g_field_22
00B4: MOVE.L     A0,D0
00B6: MOVE.L     D0,-15498(A5)    ; g_current_ptr = selected
00BA: CLR.L      -15502(A5)       ; g_size2 = 0
00BE: CLR.L      -15506(A5)       ; g_size1 = 0
```

**Purpose**: This is the main game state transition handler:
- Action 0: Load saved game
- Action > 0: Various game actions
- Action < 0: Cleanup

### Function 0x00C6 - Load Game State
```asm
00C6: MOVEA.L    A3,A4
00C8: PEA        $0110.W          ; push 272
00CC: PEA        -17154(A5)       ; push g_state1
00D0: MOVE.L     A4,-(A7)         ; push source
00D2: JSR        1658(A5)         ; copy function
; Then set up 17x17 board grid
00D6: MOVEQ      #17,D0
00D8: MOVE.L     D0,(A7)
00DA: PEA        -17154(A5)
00DE: JSR        426(A5)          ; clear first 17 bytes
00E2: MOVEQ      #16,D4           ; outer loop: 16 rows
00E4: LEA        -16882(A5),A3    ; A3 = board data
; Nested loop copies 17x17 grid
```

**Purpose**: Load game from saved state, reconstructing the 17×17 board.

## State Structures

### g_state1 (A5-17154)
- Size: 544 bytes (0x220)
- Contains: Primary board state
- Layout: 17 × 32 = 544 (17 rows × 32 bytes each)

### g_state2 (A5-16610)
- Size: 1088 bytes (0x440)
- Contains: Extended board state
- Layout: 32 × 34 = 1088 (34-byte entries × 32)

### Board Grid
- Location: A5-16882
- Size: 17 × 17 = 289 bytes
- Contains: Tile placement data

## Buffer Selection Logic

```c
void select_buffer(GameData* data) {
    if (data->field_2 != 0) {
        g_current_ptr = &g_field_14;  // Vertical
    } else {
        g_current_ptr = &g_field_22;  // Horizontal
    }
    g_size1 = 0;  // Clear sizes initially
    g_size2 = 0;
}
```

## Game Data Structure (Offset from A4)

| Offset | Size | Purpose |
|--------|------|---------|
| 0 | 2 | Unknown |
| 2 | 2 | Direction flag (0=horiz, else=vert) |
| 6 | 8 | Field_14 data |
| 14 | 8 | Field_22 data |
| 280 | 8 | More field_14 data |
| 288 | 4 | Size 2 value |
| 292 | 4 | Size 1 value |
| 298 | 1 | Some byte |

## Global Variables

| Offset | Name | Size | Purpose |
|--------|------|------|---------|
| A5-17154 | g_state1 | 544 | Primary state buffer |
| A5-16882 | board_grid | 289 | 17×17 board |
| A5-16610 | g_state2 | 1088 | Extended state |
| A5-15522 | g_field_22 | ? | Horizontal buffer |
| A5-15514 | g_field_14 | ? | Vertical buffer |
| A5-15506 | g_size1 | 4 | Section 1 size |
| A5-15502 | g_size2 | 4 | Section 2 size |
| A5-15498 | g_current_ptr | 4 | Active buffer |
| A5-8604 | g_game_mode | 2 | Game state |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 426(A5) | memset |
| 658(A5) | init_subsystem |
| 1034(A5) | Unknown |
| 1258(A5) | post_search_init |
| 1362(A5) | state_update |
| 1658(A5) | copy function |
| 3490(A5) | copy to global |

## Confidence: HIGH

The board management patterns are clear:
- 17×17 grid (standard Scrabble plus borders)
- Two buffer system for h/v directions
- State machine with clear transitions
- Size clearing on new game
