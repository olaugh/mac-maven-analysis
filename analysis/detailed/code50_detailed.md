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

**Category**: Simulation
**Function**: Result Storage

Heavy FP (25 calls), stores simulation results via ChangedResource

**Related CODE resources**:
- CODE 35 (FP statistics)
- CODE 15 (MUL resources)

**Scale Note**: Converts FP statistics to integer centipoints for storage.
## Architecture Role

CODE 50 formats game moves for display:
1. Generate standard move notation
2. Format scores and timing
3. Create history list entries
4. Handle special move indicators (bingo, exchange, pass)

## Mac Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| A9EB | StringToNum | Convert string to number |
| A9AF | ReleaseResource | Release resource |

## Key Functions

### Function 0x0000 - Format Move History Entry
```asm
0000: LINK       A6,#-66              ; frame=66
0004: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVE.L     8(A6),D6             ; D6 = move index
000C: MOVE.L     12(A6),D5            ; D5 = player (0 or 1)

; Get game state handle
0010: MOVE.L     -8584(A5),-(A7)      ; g_game_state
0014: JSR        1514(A5)             ; JT[1514] - HLock
0018: MOVEA.L    D0,A4                ; A4 = state ptr

; Get move score
001E: MOVEA.L    -8584(A5),A0
0022: MOVEA.L    (A0),A0
0024: MOVE.W     770(A0),D0           ; Get field offset
0028: ...                             ; Complex offset calculation

; Get player score 1
002A: PEA        -8504(A5)            ; g_score_buffer1
002E: ...
0034: JSR        842(A5)              ; JT[842] - format score

; Get player score 2
0034: MOVEA.L    -8584(A5),A0
0038: MOVEA.L    (A0),A0
003A: MOVE.W     770(A0),D0
003E: ...
0044: PEA        -23312(A5)           ; g_score_buffer2
004A: JSR        842(A5)              ; JT[842]

; Get move data
004E: MOVEA.L    -8584(A5),A0
0052: MOVEA.L    (A0),A0
0054: MOVE.W     770(A0),D0
...

; Try to find existing history entry
005E: ...
0062: CLR.L      (A7)                 ; Clear
0064: MOVE.L     #$48495354,-(A7)     ; 'HIST' type
0068: CLR.W      -(A7)
006A: A9A0                            ; _GetScrap (find)
006E: MOVEA.L    (A7)+,A3             ; A3 = handle
0070: MOVE.L     A3,D0
0074: BNE.S      $0090                ; Found

; Create new history resource
0076: MOVEQ      #0,D0
0078: A122                            ; _NewHandle
007A: MOVEA.L    A0,A3
007C: MOVE.L     A0,D0
007E: BEQ.S      $0090                ; Failed

; Add to resource file
0080: MOVE.L     A3,-(A7)
0082: MOVE.L     #$48495354,-(A7)     ; 'HIST'
0088: CLR.W      -(A7)
008A: MOVE.L     -3512(A5),-(A7)      ; Resource file
008E: A9AB                            ; _AddResource

; Initialize history entry
0094: ...
0098: JSR        418(A5)              ; JT[418] - error check

; Lock handle
009C: CLR.L      -(A7)
009E: MOVE.L     A3,-(A7)
00A0: JSR        2826(A5)             ; JT[2826] - HLock
00A4: MOVE.L     (A7)+,D7             ; D7 = pointer

; Resize for 8 bytes
00A6: ...
00A8: PEA        $0008.W
00AC: MOVE.L     A3,-(A7)
00AE: JSR        1482(A5)             ; JT[1482] - resize

; Store move index
00B4: ...
00BC: JSR        418(A5)              ; Error check

00CC: MOVE.L     D7,D0
00CE: EXT.L      D0
00D0: ...
00D4: PEA        $0064.W              ; 100 max
00D8: MOVE.L     D6,-(A7)             ; Move index
00DA: JSR        90(A5)               ; JT[90] - format number
00DE: ...
00E0: ...

; Store player score
00E4: PEA        $0064.W
00E8: MOVE.L     D5,-(A7)             ; Player
00EA: JSR        90(A5)               ; JT[90]
00EE: ...

; Get move word from game state
00F4: MOVEA.L    -8584(A5),A0
00F8: MOVEA.L    (A0),A0
00FA: MOVE.W     770(A0),D0
...
; Format word letters
...

; Format position notation
0162: PEA        -36(A6)              ; Buffer
0166: PEA        -46(A6)              ; Destination
016A: MOVE.W     #$200E,-(A7)         ; Format code
016E: A9EB                            ; _StringToNum

; Copy word to buffer
0170: ...
0178: LEA        -56(A6),A1
017A: ...

; Format row/column
018A: ...
019A: PEA        752(PC)              ; Constant string
019E: PEA        -10(A1)
01A2: MOVE.W     #$0006,-(A7)
01A6: A9EB                            ; _StringToNum

; Check for bingo (all 7 tiles)
01B6: ...
01C2: A9EB                            ; _StringToNum

; Check move score sign
01C4: BGE.S      $01FE                ; Score >= 0

; Format negative (exchange or pass)
01FE: ...
; Many more formatting steps
...

; Check if win/loss
02FA: MOVE.W     D6,(A5)              ; Compare indices
02FC: BGE.S      $0366                ; Not end
02FE: TST.W      768(A4)              ; Check game over flag
0302: BEQ.S      $0338                ; Not over

; Check who won
0304: MOVEA.L    -8584(A5),A0
0308: MOVEA.L    (A0),A0
030A: MOVE.W     770(A0),D0
...
; Compare final scores
...

; Format win/loss indicator
0332: JSR        634(A5)              ; JT[634] - format result

; Format final notation string
0338: ...
0352: A9EB                            ; _StringToNum

; Check for other player
0366: ...
0368: BNE.S      $0396                ; Not equal

; Format leading notation
036A: ...
0384: A9EB                            ; _StringToNum

; Release and return
03F6: MOVEA.L    -8584(A5),A0
03FA: MOVEA.L    (A0),A0
...

; Copy final result
0406: ...
0410: LEA        0(A4,D0.L),A1
...
041C: ...

; Format score differential
0426: ...
0432: A9EB                            ; _StringToNum

; Final cleanup
046E: JSR        810(A5)              ; JT[810] - HUnlock
0472: MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4
0476: UNLK       A6
0478: RTS
```

**C equivalent**:
```c
void format_move_history(int move_index, int player) {
    Handle gameState = g_game_state;
    char buffer[66];
    char notation[32];

    HLock(gameState);
    GameState* state = *gameState;

    // Get current scores
    int score1 = format_score(state->player1Score, g_score_buffer1);
    int score2 = format_score(state->player2Score, g_score_buffer2);

    // Find or create history resource
    Handle histH = GetResource('HIST', 0);
    if (!histH) {
        histH = NewHandle(0);
        AddResource(histH, 'HIST', 0, g_res_file);
    }

    HLock(histH);

    // Resize for new entry
    SetHandleSize(histH, GetHandleSize(histH) + 8);

    // Get move data
    MoveData* move = &state->moves[move_index];

    // Format move number
    NumToString(move_index + 1, notation);
    strcat(notation, ". ");

    // Format word played
    if (move->score >= 0) {
        // Normal move - format word and position
        char word[16];
        get_move_word(state, move_index, word);

        // Format position (e.g., "H8" or "8H")
        char pos[4];
        int row = move->row;
        int col = move->col;

        if (move->direction == HORIZONTAL) {
            pos[0] = 'A' + col;
            NumToString(row + 1, pos + 1);
        } else {
            NumToString(row + 1, pos);
            pos[strlen(pos)] = 'A' + col;
        }

        strcat(notation, word);
        strcat(notation, " ");
        strcat(notation, pos);

        // Add score
        char scoreStr[8];
        NumToString(move->score, scoreStr);
        strcat(notation, " +");
        strcat(notation, scoreStr);

        // Check for bingo bonus
        if (move->tilesPlayed == 7) {
            strcat(notation, "*");  // Bingo indicator
        }
    } else if (move->score == -1) {
        // Exchange
        strcat(notation, "(exchange)");
    } else {
        // Pass
        strcat(notation, "(pass)");
    }

    // Check for game end
    if (move_index == state->totalMoves - 1 && state->gameOver) {
        // Add win/loss indicator
        if (state->player1Score > state->player2Score) {
            strcat(notation, player == 0 ? " WIN" : " LOSS");
        } else {
            strcat(notation, player == 1 ? " WIN" : " LOSS");
        }

        // Add final score differential
        int diff = abs(state->player1Score - state->player2Score);
        char diffStr[8];
        NumToString(diff, diffStr);
        strcat(notation, " by ");
        strcat(notation, diffStr);
    }

    // Store notation in history
    memcpy(*histH + move_index * 8, notation, 8);

    HUnlock(histH);
    HUnlock(gameState);
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3512 | g_res_file - Resource file reference |
| A5-8504 | g_score_buffer1 - Score format buffer |
| A5-8584 | g_game_state - Game state handle |
| A5-23312 | g_score_buffer2 - Second score buffer |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | Multiply/offset calculation |
| 90 | NumToString |
| 418 | Error handler |
| 634 | Format result string |
| 810 | HUnlock |
| 842 | Format score |
| 1482 | SetHandleSize |
| 1514 | HLock |
| 2826 | HLock |

## Resource Types

| Code | Type |
|------|------|
| HIST | 0x48495354 - History entries |

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

## Confidence: HIGH

Clear move history formatting patterns:
- Standard Scrabble notation
- Score tracking for both players
- Win/loss determination
- Resource-based storage
