# CODE 5 Detailed Analysis - Game State Setup

## Overview

| Property | Value |
|----------|-------|
| Size | 204 bytes |
| JT Offset | 160 |
| JT Entries | 1 |
| Functions | 1 |
| Purpose | **Game state initialization, board setup** |


## System Role

**Category**: Core System
**Function**: Init Helper

Initialization support routines
## Architecture Role

CODE 5 contains a single large function that:
1. Validates parameters
2. Initializes board buffers (g_field_14, g_field_22)
3. Sets up game mode
4. Configures which player goes first

## Key Function

### Function 0x0000 - Initialize Game State
```asm
; From disassembly:
0000: 4E56FB80      LINK       A6,#-1152            ; Large frame (1152 bytes)
0004: 2F2E000C      MOVE.L     12(A6),-(A7)         ; Push param2
0008: 2F2E0008      MOVE.L     8(A6),-(A7)          ; Push param1
000C: 4EAD054A      JSR        1354(A5)             ; JT[1354] - validate params
0010: 4A40          TST.W      D0
0012: 508F          ADDQ.L     #8,A7                ; Clean stack
0014: 670E          BEQ.S      $0024                ; If invalid, show error
0016: 3F3C03FF      MOVE.W     #$03FF,-(A7)         ; Push error code 1023 (0x3FF)
001A: 4EAD058A      JSR        1418(A5)             ; JT[1418] - show error dialog
001E: 4A40          TST.W      D0
0020: 548F          ADDQ.L     #2,A7                ; Clean stack
0022: 6606          BNE.S      $002A                ; If OK clicked, continue
0024: 7000          MOVEQ      #0,D0                ; Return 0 (failure)
0026: 600000A0      BRA.W      $00CA                ; Jump to return

; Initialization sequence
002A: 4EAD0292      JSR        658(A5)              ; JT[658] - init_subsystem
002E: 2F2E0008      MOVE.L     8(A6),-(A7)          ; Push param1
0032: 486DC366      PEA        -15514(A5)           ; Push &g_field_14
0036: 4EAD0DA2      JSR        3490(A5)             ; JT[3490] - copy_to_global
003A: 2EAE000C      MOVE.L     12(A6),(A7)          ; Replace with param2
003E: 486DC35E      PEA        -15522(A5)           ; Push &g_field_22
0042: 4EAD0DA2      JSR        3490(A5)             ; Copy to g_field_22

0046: 4EAD0552      JSR        1362(A5)             ; JT[1362] - state_update
004A: 2B6E0010C372  MOVE.L     16(A6),-15502(A5)   ; g_size2 = param3
0050: 2B6E0014C36E  MOVE.L     20(A6),-15506(A5)   ; g_size1 = param4

0056: 4EAD04EA      JSR        1258(A5)             ; JT[1258] - post_search_init
005A: 4EAD03FA      JSR        1018(A5)             ; JT[1018] - some init

; Copy 17x17 lookup table (289 bytes = 0x121)
005E: 48780121      PEA        $0121.W              ; Push 289 (17x17)
0062: 486DD76C      PEA        -10388(A5)           ; Push g_lookup_tbl (dest)
0066: 486DD88D      PEA        -10099(A5)           ; Push source
006A: 4EAD0D8A      JSR        3466(A5)             ; JT[3466] - memcpy

; Check who goes first (param at offset 24)
006E: 4A6E0018      TST.W      24(A6)               ; param5 (computer_first)
0072: 4FEF0018      LEA        24(A7),A7            ; Clean stack
0076: 6722          BEQ.S      $009A                ; If 0, human goes first

; Computer goes first path
0078: 41EDC366      LEA        -15514(A5),A0        ; A0 = &g_field_14
007C: 2B48C376      MOVE.L     A0,-15498(A5)        ; g_current_ptr = g_field_14
0080: 486DC366      PEA        -15514(A5)           ; Push g_field_14
0084: 4EAD0962      JSR        2402(A5)             ; JT[2402] - process buffer
0088: 486DC35E      PEA        -15522(A5)           ; Push g_field_22
008C: 4EAD0962      JSR        2402(A5)             ; Process other buffer
0090: 3B7C0003DE64  MOVE.W     #$0003,-8604(A5)     ; g_game_mode = 3 (computer's turn)
0096: 508F          ADDQ.L     #8,A7                ; Clean stack
0098: 6020          BRA.S      $00BA                ; Jump to final setup

; Human goes first path
009A: 41EDC35E      LEA        -15522(A5),A0        ; A0 = &g_field_22
009E: 2B48C376      MOVE.L     A0,-15498(A5)        ; g_current_ptr = g_field_22
00A2: 486DC35E      PEA        -15522(A5)           ; Push g_field_22
00A6: 4EAD0962      JSR        2402(A5)             ; Process buffer
00AA: 486DC366      PEA        -15514(A5)           ; Push g_field_14
00AE: 4EAD0962      JSR        2402(A5)             ; Process other buffer
00B2: 3B7C0002DE64  MOVE.W     #$0002,-8604(A5)     ; g_game_mode = 2 (human's turn)
00B8: 508F          ADDQ.L     #8,A7                ; Clean stack

; Final setup
00BA: 4EAD0552      JSR        1362(A5)             ; JT[1362] - state_update
00BE: 4EAD012A      JSR        298(A5)              ; JT[298] - final init
00C2: 426DD9AE      CLR.W      -9810(A5)            ; Clear g_some_flag
00C6: 7001          MOVEQ      #1,D0                ; Return 1 (success)
00C8: 4E5E          UNLK       A6
00CA: 4E75          RTS
```

**C equivalent**:
```c
int setup_game_state(void* board1, void* board2,
                     long size2, long size1,
                     int computer_first) {
    // Validate parameters
    if (!validate_params(board1, board2)) {
        if (!show_error_dialog(0x3FF)) {
            return 0;  // User cancelled or error
        }
    }

    // Initialize subsystems
    init_subsystem();

    // Copy board data to global buffers
    copy_to_global(&g_field_14, board1);
    copy_to_global(&g_field_22, board2);

    state_update();

    // Store sizes
    g_size2 = size2;
    g_size1 = size1;

    post_search_init();
    some_init();

    // Copy 17x17 lookup table
    memcpy(&g_lookup_tbl, source, 289);

    // Set up turn order
    if (computer_first) {
        g_current_ptr = &g_field_14;
        process_buffer(&g_field_14);
        process_buffer(&g_field_22);
        g_game_mode = 3;  // Computer's turn
    } else {
        g_current_ptr = &g_field_22;
        process_buffer(&g_field_22);
        process_buffer(&g_field_14);
        g_game_mode = 2;  // Human's turn
    }

    state_update();
    final_init();
    g_some_flag = 0;  // A5-9810

    return 1;  // Success
}
```

## Global Variables Modified

| Offset | Name | Purpose |
|--------|------|---------|
| A5-15514 | g_field_14 | Hook-before board buffer |
| A5-15522 | g_field_22 | Hook-after board buffer |
| A5-15506 | g_size1 | Size of section 1 |
| A5-15502 | g_size2 | Size of section 2 |
| A5-15498 | g_current_ptr | Pointer to active buffer |
| A5-10388 | g_lookup_tbl | 17×17 lookup table |
| A5-8604 | g_game_mode | Current game state |
| A5-9810 | g_flag | Some game flag |

## Game Mode Values

| Value | Meaning |
|-------|---------|
| 0 | New game (idle) |
| 2 | Human's turn |
| 3 | Computer's turn |
| 8 | Loaded game |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 298 | Final initialization |
| 658 | init_subsystem |
| 1018 | Some initialization |
| 1258 | post_search_init |
| 1354 | Validate parameters |
| 1362 | state_update |
| 1418 | Error dialog |
| 2402 | Process board buffer |
| 3466 | memcpy |
| 3490 | copy_to_global |

## Parameter Layout

```c
int setup_game_state(
    void* board1,        // 8(A6)  - First board data
    void* board2,        // 12(A6) - Second board data
    long  size2,         // 16(A6) - Size for section 2
    long  size1,         // 20(A6) - Size for section 1
    int   computer_first // 24(A6) - Non-zero = computer first
);
```

## Confidence: HIGH

The function flow is clear:
- Parameter validation
- Board buffer initialization
- Turn order setup based on parameter
- Game mode assignment
- Standard return pattern
