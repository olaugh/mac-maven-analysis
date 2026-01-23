# CODE 50 Detailed Analysis - Move History and Notation

## Overview

| Property | Value |
|----------|-------|
| Size | 1174 bytes |
| JT Offset | 3544 |
| JT Entries | 1 |
| Functions | 1 (large) |
| Purpose | **Format move notation for history display** |


## System Role

**Category**: Game State
**Function**: History Formatting

Formats game moves for history display using standard Scrabble notation.

**Related CODE resources**:
- CODE 35 (FP statistics)
- CODE 15 (MUL resources)

## Architecture Role

CODE 50 formats game moves for display:
1. Generate standard move notation
2. Format scores and timing
3. Create history list entries
4. Handle special move indicators (bingo, exchange, pass)

## Mac Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| A9EB | Pack7/SANE | Floating-point operations |
| A9A0 | GetScrap | Get scrap data (clipboard) |
| A9AB | AddResource | Add resource to file |
| A9AA | WriteResource | Write resource data |
| A9AF | ReleaseResource | Release resource |
| A999 | ChangedResource | Mark resource as changed |
| A994 | GetResInfo | Get resource info |
| A122 | NewHandle | Allocate new handle |

## Key Function

### Function 0x0000 - Format Move History Entry
```asm
; Entry - frame=66 bytes of local storage
0000: LINK       A6,#-66
0004: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVE.L     8(A6),D6             ; D6 = move index
000C: MOVE.L     12(A6),D5            ; D5 = player (0 or 1)

; Get game state handle
0010: MOVE.L     -8584(A5),-(A7)      ; g_game_state
0014: JSR        1514(A5)             ; JT[1514] - HLock
0018: MOVEA.L    D0,A4                ; A4 = locked state ptr

; Get field from state at offset 770
001A: MOVEA.L    -8584(A5),A0
001E: MOVEA.L    (A0),A0
0020: MOVE.W     770(A0),D0           ; Get move count or index

; Format player scores
002A: ... (format score to g_score_buffer1)
0030: JSR        842(A5)              ; JT[842] - format score
0034: MOVEA.L    -8584(A5),A0
...
004A: JSR        842(A5)              ; JT[842] - format score 2

; Find or create HIST resource
0062: MOVE.L     #$48495354,-(A7)     ; 'HIST' type
0068: CLR.W      -(A7)                ; ID 0
006A: A9A0                            ; _GetScrap
...
0074: BNE.S      $0090                ; Found existing

; Create new history handle
0076: MOVEQ      #0,D0
0078: A122                            ; _NewHandle (size 0)
007A: MOVEA.L    A0,A3
...

; Add to resource file
0080: MOVE.L     A3,-(A7)             ; Handle
0082: MOVE.L     #$48495354,-(A7)     ; 'HIST'
0088: CLR.W      -(A7)                ; ID 0
008A: MOVE.L     -3512(A5),-(A7)      ; g_res_file refnum
008E: A9AB                            ; _AddResource

; Lock handle for writing
009C: CLR.L      -(A7)
009E: MOVE.L     A3,-(A7)
00A0: JSR        2826(A5)             ; JT[2826] - HLock

; Resize for 8 more bytes
00A8: PEA        $0008.W              ; 8 bytes per entry
00AC: MOVE.L     A3,-(A7)
00AE: JSR        1482(A5)             ; JT[1482] - SetHandleSize

; Format move number
00D4: PEA        $0064.W              ; max 100
00D8: MOVE.L     D6,-(A7)             ; move index
00DA: JSR        90(A5)               ; JT[90] - NumToString

; Format player number
00E4: PEA        $0064.W
00E8: MOVE.L     D5,-(A7)             ; player
00EA: JSR        90(A5)               ; JT[90]

; Get move data from state at offset 770
00F4: MOVEA.L    -8584(A5),A0
00F8: MOVEA.L    (A0),A0
00FA: MOVE.W     770(A0),D0

; Copy 10-byte move entry (4+4+2 bytes)
0144: LEA        0(A4,D0.L),A1        ; Source
0146: MOVE.L     (A1)+,(A0)+          ; 4 bytes
0148: MOVE.L     (A1)+,(A0)+          ; 4 bytes
014A: MOVE.W     (A1)+,(A0)+          ; 2 bytes

; Multiple SANE (A9EB) calls for formatting
0162: PEA        -24180(A0)           ; Source buffer
0166: PEA        -36(A6)              ; Dest buffer
016A: MOVE.W     #$200E,-(A7)         ; SANE operation
016E: A9EB                            ; _Pack7 (SANE)
...

; Check for game over
02FE: TST.W      768(A4)              ; g_game_over flag
0302: BEQ.S      $0338                ; Not over

; Compare final scores
0304: MOVEA.L    -8584(A5),A0
...
032E: MOVE.W     D1,-(A7)
0330: CLR.L      -(A7)
0332: JSR        634(A5)              ; JT[634] - format result

; Final cleanup
046E: JSR        810(A5)              ; JT[810] - HUnlock
0472: MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4
0476: UNLK       A6
0478: RTS
```

## Local Variables (Stack Frame)

| Offset | Size | Purpose |
|--------|------|---------|
| -2(A6) | 2 | Temp word |
| -8(A6) | 4 | Temp long |
| -10(A6) | 10 | Extended precision buffer |
| -36(A6) | 10 | Extended precision buffer 2 |
| -46(A6) | 10 | Extended precision buffer 3 |
| -48(A6) | 2 | Score differential |
| -56(A6) | 10 | Extended precision buffer 4 |
| -66(A6) | 10 | Extended precision buffer 5 |

## SANE Operations Used

| Code | Operation |
|------|-----------|
| 0x0002 | FX2I - Extended to Integer |
| 0x0006 | FI2X - Integer to Extended |
| 0x0008 | FL2X - Long to Extended |
| 0x000D | FX2S - Extended to String |
| 0x0016 | FSUBX - Subtract Extended |
| 0x1004 | FCPXX - Compare Extended |
| 0x100E | FSUB with mode |
| 0x200E | FADD with mode |
| 0x2002 | FX2I variant |
| 0x2004 | FI2X variant |
| 0x2008 | FL2X variant |
| 0x2010 | FADDX variant |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3512 | g_res_file - Resource file reference |
| A5-8504 | g_score_buffer1 - Score format buffer |
| A5-8584 | g_game_state - Game state handle |
| A5-23312 | g_score_buffer2 - Second score buffer |

## Game State Structure (partial)

| Offset | Type | Purpose |
|--------|------|---------|
| 768 | Word | Game over flag |
| 770 | Word | Move count or current index |
| 770+N*10 | 10 bytes | Move entry N |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 90 | NumToString wrapper |
| 418 | Error handler |
| 634 | Format result string |
| 810 | HUnlock |
| 842 | Format score |
| 1482 | SetHandleSize |
| 1514 | HLock |
| 2826 | HLock (alternate entry) |

## Resource Types

| Code | ASCII | Purpose |
|------|-------|---------|
| 0x48495354 | 'HIST' | History entries |

## Move Notation Format

Standard Scrabble notation:
- Move number: "1. "
- Word played: "QUARTZ"
- Position: "H8" (horizontal) or "8H" (vertical)
- Score: "+92"
- Bingo indicator: "*" for 7-tile bonus
- Exchange: "(exchange)"
- Pass: "(pass)"
- Game end: "WIN" or "LOSS by N"

## History Entry Structure

Each entry is 8 bytes stored in 'HIST' resource:
```c
struct HistoryEntry {
    int16_t move_number;
    int16_t player;
    int16_t score;
    int16_t flags;  // bingo, exchange, pass indicators
};
```

## C Equivalent

```c
void format_move_history(int move_index, int player) {
    char buffer[66];

    GameState** stateH = g_game_state;
    HLock((Handle)stateH);
    GameState* state = *stateH;

    // Get current scores
    format_score(state->player1Score, g_score_buffer1);
    format_score(state->player2Score, g_score_buffer2);

    // Find or create history resource
    Handle histH = GetResource('HIST', 0);
    if (!histH) {
        histH = NewHandle(0);
        AddResource(histH, 'HIST', 0, NULL);
    }

    HLock(histH);

    // Resize for new entry (8 bytes per entry)
    SetHandleSize(histH, GetHandleSize(histH) + 8);

    // Get move data
    MoveData* move = &state->moves[move_index];

    // Format move notation with SANE extended precision
    // for accurate score calculations
    Extended scoreExt;
    FI2X(move->score, &scoreExt);
    // ... formatting operations ...

    // Check for game over
    if (state->gameOver) {
        // Compare final scores and format result
        if (state->player1Score > state->player2Score) {
            format_result(player == 0 ? "WIN" : "LOSS", diff);
        } else {
            format_result(player == 1 ? "WIN" : "LOSS", diff);
        }
    }

    HUnlock(histH);
    HUnlock((Handle)stateH);
}
```

## Confidence: HIGH

Clear move history formatting patterns:
- Standard Scrabble notation
- SANE floating-point for accurate score calculations
- Score tracking for both players
- Win/loss determination
- Resource-based storage with 'HIST' type
