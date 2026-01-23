# CODE 44 Detailed Analysis - Move Search and Validation Wrapper

## Overview

| Property | Value |
|----------|-------|
| Size | 424 bytes |
| JT Offset | 2720 |
| JT Entries | 4 |
| Functions | 4 |
| Purpose | **Coordinate move search, dispatch to appropriate search functions** |


## System Role

**Category**: User Interface
**Function**: Score Display

Score display formatting
## Architecture Role

CODE 44 provides move search coordination:
1. Dispatch search based on rack size
2. Validate move candidates
3. Manage search callbacks
4. Handle special cases (single tile, edge positions)

## Key Functions

### Function 0x0000 - Main Search Dispatcher
```asm
0000: LINK       A6,#-128             ; frame=128
0004: MOVEM.L    D7/A4,-(SP)

; Get search context
0008: MOVEA.L    8(A6),A4             ; A4 = context

; Initialize search
000C: MOVE.L     A4,-(A7)
000E: JSR        2410(A5)             ; JT[2410] - setup search

; Get validity mask
0012: PEA        -128(A6)             ; Local buffer
0016: JSR        2394(A5)             ; JT[2394] - get validity mask
001A: MOVE.W     D0,D7                ; D7 = rack letter count

; Check rack size
001C: CMPI.W     #$0011,D7            ; >= 17 letters?
0020: ADDQ       #8,A7
0022: BCS.S      $0052                ; No - normal search

; Full board state - use special callback
0024: MOVE.W     #$0220,-(A7)         ; Flag = 0x220
0028: PEA        -17154(A5)           ; g_state1
002C: JSR        3450(A5)             ; JT[3450] - check board

0030: TST.W      D0
0032: ADDQ       #6,A7
0034: BEQ.S      $003E                ; Board empty

; Set callback for occupied board
0036: LEA        2770(A5),A0          ; Callback address
003A: MOVE.L     A0,D0
003C: BRA.S      $0040

003E: MOVEQ      #0,D0                ; No callback

0040: MOVE.L     D0,-19486(A5)        ; Store callback ptr

; Call extended search
0044: PEA        2114(A5)             ; Post-processor
0048: MOVE.L     A4,-(A7)             ; Context
004A: JSR        2130(A5)             ; JT[2130] - extended search
004E: ADDQ       #8,A7
0050: BRA.S      $0072                ; Done

; Normal rack size search
0052: CMPI.W     #8,D7                ; < 8 letters?
0056: BGE.S      $0066                ; No - medium search

; Small rack - simple search
0058: MOVE.L     12(A6),-(A7)         ; Push param
005C: MOVE.L     A4,-(A7)             ; Push context
005E: JSR        2202(A5)             ; JT[2202] - small search
0062: ADDQ       #8,A7
0064: BRA.S      $0072                ; Done

; Medium/large rack - complex search
0066: MOVE.W     16(A6),-(A7)         ; Push level
006A: MOVE.L     A4,-(A7)             ; Push context
006C: JSR        2586(A5)             ; JT[2586] - complex search
0070: ADDQ       #6,A7

; Return results
0072: LEA        -23056(A5),A0        ; g_dawg_search_area
0076: MOVE.L     A0,D0
0078: MOVEM.L    (SP)+,D7/A4
007C: UNLK       A6
007E: RTS
```

**C equivalent**:
```c
Move* main_search_dispatcher(SearchContext* ctx, void* param, int level) {
    char validity_mask[128];

    setup_search(ctx);
    int rack_count = get_validity_mask(validity_mask);

    if (rack_count >= 17) {
        // Full/complex board state
        int has_tiles = check_board(g_state1, 0x220);

        if (has_tiles) {
            g_callback_ptr = &occupied_board_callback;
        } else {
            g_callback_ptr = NULL;
        }

        extended_search(ctx, &post_processor);
    }
    else if (rack_count < 8) {
        // Small rack - simple algorithm
        small_search(ctx, param);
    }
    else {
        // Medium/large rack - complex algorithm
        complex_search(ctx, level);
    }

    return g_dawg_search_area;
}
```

### Function 0x0080 - Process Move List
```asm
0080: LINK       A6,#0
0084: MOVEM.L    D7/A2/A3/A4,-(SP)

; Get search criteria
0088: MOVEA.L    8(A6),A2             ; A2 = search criteria

; Setup iteration
008C: LEA        -23056(A5),A4        ; A4 = move list
0090: MOVEQ      #34,D0
0092: AND.L      -12540(A5),A0        ; Entry count * 34
0096: LEA        -23056(A5),A3        ; End pointer
009A: ADD.B      A3,(A0)
009C: MOVEA.L    D0,A3

; Get comparison value
009E: MOVE.L     20(A2),D7            ; Base score
00A2: ADD.L      16(A2),(A7)          ; Add main score
00A6: ADD.L      24(A2),(A7)          ; Add bonus
00AA: BRA.S      $00DC                ; Start loop

; Compare moves
00AC: MOVE.L     A4,-(A7)             ; Push current move
00AE: MOVE.L     A2,-(A7)             ; Push criteria
00B0: JSR        3506(A5)             ; JT[3506] - compare
00B4: TST.W      D0
00B6: ADDQ       #8,A7
00B8: BNE.S      $00D8                ; Different - next

; Calculate current move score
00BA: MOVE.L     16(A4),D0            ; Main score
00BE: ADD.L      20(A4),D0            ; Add component
00C2: ADD.L      24(A4),D0            ; Add bonus
00C6: CMP.L      D0,D7                ; Compare with target
00C8: BLT.S      $00CE                ; Current is better
00CA: MOVEQ      #0,D0                ; Return 0 (use existing)
00CC: BRA.S      $00E2

; Found better - process it
00CE: MOVE.L     A4,-(A7)
00D0: JSR        152(PC)              ; Process better move
00D4: ADDQ       #4,A7
00D6: BRA.S      $00E0

; Next entry
00D8: LEA        34(A4),A4            ; Advance 34 bytes

; Check if more entries
00DC: CMP.L      A4,A3                ; At end?
00DE: BHI.S      $00AC                ; No - continue

00E0: MOVEQ      #1,D0                ; Return 1 (found)
00E2: MOVEM.L    (SP)+,D7/A2/A3/A4
00E6: UNLK       A6
00E8: RTS
```

**C equivalent**:
```c
int process_move_list(MoveSearch* criteria) {
    Move* moves = g_dawg_search_area;
    Move* end = moves + (g_entry_count * 34);

    int target_score = criteria->base_score +
                       criteria->main_score +
                       criteria->bonus;

    while (moves < end) {
        int match = compare_moves(criteria, moves);

        if (match == 0) {
            // Same position - compare scores
            int current_score = moves->main_score +
                               moves->component +
                               moves->bonus;

            if (current_score > target_score) {
                // Found better move
                process_better_move(moves);
                return 1;
            }
            return 0;  // Existing is better
        }

        moves += 34;  // Next entry
    }

    return 1;  // Processed all
}
```

### Function 0x00EA - Validate Single Move
```asm
00EA: LINK       A6,#0
00EE: MOVEM.L    D7/A3/A4,-(SP)

; Get move candidate
00F2: MOVEA.L    8(A6),A4             ; A4 = move

; Check for single tile placement
00F6: CMPI.W     #1,-20010(A5)        ; g_tile_count == 1?
00FC: BNE.S      $0148                ; No - use callback

; Single tile - check edge positions
00FE: CMPI.B     #$0F,32(A4)          ; Row > 15?
0104: BLE.S      $0148                ; No - use callback

; Get position info
0106: MOVE.B     32(A4),D7            ; Row
010A: MOVE.B     33(A4),D0            ; Column
010E: EXT.W      D0

; Calculate board index
0110: MOVE.B     D7,D1
0112: EXT.W      D1
0114: AND.L      #$001147ED,A1        ; Index calculation
...
011E: MOVEA.W    D0,A3
0120: ADD.B      A3,(A1)
0122: MOVEA.L    D1,A3                ; A3 = board ptr

; Find end of adjacent tiles
0124: BRA.S      $0128
0126: ADDQ       #1,A3                ; Next position
0128: TST.B      (A3)
012A: BNE.S      $0126                ; Continue while occupied

; Check boundaries
012C: CMPI.B     #$10,D7              ; At row 16?
0130: BEQ.S      $0138
0132: TST.B      -17(A3)              ; Check above
0136: BNE.S      $0144                ; Has adjacent - valid

0138: CMPI.B     #$1E,D7              ; At row 30?
013C: BEQ.S      $0148
013E: TST.B      17(A3)               ; Check below
0142: BEQ.S      $0148                ; No adjacent - use callback

0144: MOVEQ      #0,D0                ; Invalid position
0146: BRA.S      $0162

; Use callback validation
0148: TST.L      -19486(A5)           ; Callback set?
014C: BEQ.S      $0160                ; No - accept

; Call validation callback
014E: MOVE.L     A4,-(A7)
0150: MOVEA.L    -19486(A5),A0        ; Get callback
0154: JSR        (A0)                 ; Call validator
0156: TST.W      D0
0158: ADDQ       #4,A7
015A: BNE.S      $0160                ; Valid
015C: MOVEQ      #0,D0                ; Invalid
015E: BRA.S      $0162

0160: MOVEQ      #1,D0                ; Valid

0162: MOVEM.L    (SP)+,D7/A3/A4
0166: UNLK       A6
0168: RTS
```

**C equivalent**:
```c
int validate_single_move(Move* move) {
    // Check for single tile edge case
    if (g_tile_count != 1) {
        goto use_callback;
    }

    if (move->row <= 15) {
        goto use_callback;
    }

    // Single tile at edge - check adjacency
    int row = move->row;
    int col = move->col;

    char* board = &g_state1[row * 17 + col];

    // Find end of horizontal word
    while (*board) {
        board++;
    }

    // Check vertical adjacency
    if (row != 16) {
        if (board[-17] != 0) {  // Has tile above
            return 0;  // Invalid for single tile
        }
    }

    if (row != 30) {
        if (board[17] != 0) {  // Has tile below
            return 0;  // Invalid for single tile
        }
    }

use_callback:
    if (g_callback_ptr == NULL) {
        return 1;  // Valid
    }

    // Call validation callback
    return g_callback_ptr(move);
}
```

### Function 0x016A - Shift Move Entry
```asm
016A: LINK       A6,#-4               ; frame=4
016E: MOVE.L     A4,-(A7)

; Decrement entry count
0170: SUBQ.W     #1,-12540(A5)        ; g_entry_count--

; Calculate entry position
0172: MOVEQ      #34,D0
0176: AND.L      -12540(A5),A0
017A: LEA        -23056(A5),A4        ; Move array base
017E: ADD.B      A4,(A0)
0180: MOVEA.L    D0,A4

; Copy 34 bytes (move entry)
0182: BRA.S      $0196

0184: MOVEA.L    8(A6),A0             ; Source (insertion point)
0188: LEA        -34(A0),A1           ; Destination (one back)
018C: MOVEQ      #7,D0
018E: MOVE.L     (A0)+,(A1)+          ; Copy loop
0190: DBF        D0,$018E             ; 8 longwords = 32 bytes
0194: MOVE.W     (A0)+,(A1)+          ; Plus 2 bytes = 34 total

; Check if more to copy
0196: MOVEQ      #34,D0
0198: ADD.L      8(A6),D0
...
01A2: MOVEA.L    (A7)+,A4
01A4: UNLK       A6
01A6: RTS
```

**C equivalent**:
```c
void shift_move_entry(Move* insertion_point) {
    g_entry_count--;

    Move* end = &g_dawg_search_area[g_entry_count];

    // Shift all entries after insertion point back by one
    while (insertion_point < end) {
        // Copy 34 bytes from next to current
        memcpy(insertion_point - 1, insertion_point, 34);
        insertion_point++;
    }
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-12540 | g_entry_count - Number of move entries |
| A5-17154 | g_state1 - Board letter array |
| A5-19486 | g_callback_ptr - Validation callback |
| A5-20010 | g_tile_count - Tiles in current move |
| A5-23056 | g_dawg_search_area - Move result array |
| A5+2114 | Post-processor callback address |
| A5+2770 | Occupied board callback address |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 2130 | Extended search |
| 2202 | Small rack search |
| 2394 | Get validity mask |
| 2410 | Setup search |
| 2586 | Complex search |
| 3450 | Check board state |
| 3506 | Compare moves |

## Search Dispatch Logic

| Rack Size | Search Method | JT Call |
|-----------|---------------|---------|
| < 8 | Simple search | 2202 |
| 8-16 | Complex search | 2586 |
| >= 17 | Extended search | 2130 |

## Move Entry Structure (34 bytes)

| Offset | Size | Field |
|--------|------|-------|
| 0-15 | 16 | Move data |
| 16 | 4 | Main score |
| 20 | 4 | Component score |
| 24 | 4 | Bonus score |
| 28 | 2 | Flags |
| 30 | 2 | Position |
| 32 | 1 | Row |
| 33 | 1 | Column |

## Validation Rules

Single tile moves have special validation:
1. Must check vertical adjacency
2. Cannot be placed at row edges without adjacent tiles
3. Uses callback for complex cases

## Confidence: HIGH

Clear search dispatch and validation logic:
- Rack size-based algorithm selection
- Move comparison by score
- Single tile edge case handling
- Callback-based extensibility
