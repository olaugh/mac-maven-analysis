# CODE 45 Detailed Analysis - Move Ranking and Best Move Selection

## Overview

| Property | Value |
|----------|-------|
| Size | 1122 bytes |
| JT Offset | 2752 |
| JT Entries | 4 |
| Functions | 5 |
| Purpose | **Move ranking system - maintains top 10 best moves** |

## System Role

**Category**: AI/Scoring
**Function**: Move Ranking

Ranks candidate moves by value, maintains top-10 best move lists for AI decision making.

**Related CODE resources**:
- CODE 32 (score calculation)
- CODE 43 (move generation)
- CODE 44 (move validation)

## Architecture Role

CODE 45 implements Maven's move ranking algorithm:
1. Evaluate candidate moves against score ranges
2. Maintain two parallel score tables (10 entries each)
3. Track best moves with multi-criteria ranking
4. Support tie-breaking between equivalent moves

## Critical Data Structures

### Score Tables (A5-1616 and A5-1576)
Each table holds 10 long values (40 bytes), initialized to -200,000,000 (0xF4143E00):
```c
// Score ranking tables
long g_score_table1[10];  // A5-1616 to A5-1576
long g_score_table2[10];  // A5-1576 to A5-1536
```

### Move Entry Structure (34 bytes)
```c
struct MoveEntry {
    char move_data[16];    // 0-15: Word placement data
    long main_score;       // 16-19: Primary score value
    long component_score;  // 20-23: Score component breakdown
    long bonus_score;      // 24-27: Bonus points (bingo, etc.)
    short flags;           // 28-29: Status flags (0x7F = special)
    short position;        // 30-31: Board position encoded
    char row;              // 32: Row index (0-14, 0=first move)
    char column;           // 33: Column index
};
```

## Key Functions

### Function 0x0000 - Primary Move Evaluator
**Purpose**: Evaluate a candidate move and submit for ranking

```asm
0000: LINK       A6,#-12              ; frame=12 bytes local
0004: MOVEM.L    D6/D7/A3/A4,-(SP)    ; save registers
0008: MOVEA.L    8(A6),A4             ; A4 = move candidate pointer

; Special case: Single tile on first move
000C: CMPI.W     #$0001,-20010(A5)    ; g_tile_count == 1?
0012: BNE.S      $002A                ; No - continue normal
0014: CMPI.B     #$0F,32(A4)          ; Row > 15 (invalid)?
001A: BLE.S      $002A                ; Valid row
001C: MOVE.L     A4,-(A7)
001E: JSR        2762(A5)             ; JT[2762] - validate_single_tile
0022: TST.W      D0
0026: BEQ.W      $01A6                ; Invalid - return early

; Check move flags for special handling
002A: TST.W      28(A4)               ; Move flags field
002E: BEQ.S      $0050                ; No flags - normal eval

; Flagged move - compare with current best
0030: MOVE.L     16(A4),D0            ; Get main score
0034: CMP.L      -23074(A5),D0        ; Compare with g_best_score
0038: BLE.W      $01A6                ; Not better - skip

; Update best move storage (34-byte copy)
003C: LEA        -23090(A5),A0        ; g_dawg_info destination
0040: LEA        (A4),A1              ; Source move
0042: MOVEQ      #7,D0                ; 8 longwords = 32 bytes
0044: MOVE.L     (A1)+,(A0)+          ; Copy loop
0046: DBF        D0,$0044
004A: MOVE.W     (A1)+,(A0)+          ; Plus 2 bytes = 34 total
004C: BRA.W      $01A6                ; Done

; Normal evaluation path
0050: MOVE.L     -1580(A5),-8(A6)     ; range1_low = g_score_range1
0056: MOVE.L     -1540(A5),-12(A6)    ; range2_low = g_score_range2

; Call evaluation function
005C: PEA        -4(A6)               ; &result1
0060: PEA        -2(A6)               ; &result2
0064: PEA        -12(A6)              ; &range2
0068: PEA        -8(A6)               ; &range1
006C: MOVE.L     A4,-(A7)             ; move candidate
006E: JSR        2090(A5)             ; JT[2090] - evaluate_ranges
0072: TST.W      D0
0078: BNE.W      $01A6                ; Failed evaluation

; Count entries in score table 1
007C: MOVEQ      #0,D7                ; count1 = 0
007E: LEA        -1616(A5),A3         ; A3 = g_score_table1
; ... count loop until count >= g_entry_count or score out of range

; Count entries in score table 2
0096: MOVEQ      #0,D6                ; count2 = 0
0098: LEA        -1576(A5),A3         ; A3 = g_score_table2
; ... similar count loop

; Update tables if not full (< 10 entries)
00B0: CMPI.W     #$000A,-12540(A5)    ; g_entry_count >= 10?
00BC: CMPI.W     #$000A,D7            ; count1 >= 10?
00C0: BCC.S      $00FA                ; Skip update
; ... update table 1 with new score
00EE: JSR        3466(A5)             ; JT[3466] - update_table

00FA: CMPI.W     #$000A,D6            ; count2 >= 10?
00FE: BCC.S      $0138                ; Skip update
; ... update table 2
012C: JSR        3466(A5)             ; JT[3466] - update_table

; Calculate final ranking scores
0138: TST.B      32(A4)               ; Row == 0 (first move)?
013C: BNE.S      $0172                ; No - use calculated scores
; First move uses comparison function
013E: MOVE.L     -12504(A5),-(A7)     ; g_compare1
0142: JSR        2122(A5)             ; JT[2122] - get_score
; ... calculate component scores

; Submit for ranking with negated scores (lower = better)
018E: MOVE.L     -8(A6),D0            ; range1
0192: NEG.L      D0                   ; Negate for ranking
0194: MOVE.L     D0,-(A7)
019A: NEG.L      D0                   ; range2 also negated
019C: MOVE.L     D0,-(A7)
019E: MOVE.L     A4,-(A7)             ; move
01A0: JSR        2210(A5)             ; JT[2210] - rank_move

01AA: UNLK       A6
01AC: RTS
```

**C equivalent**:
```c
void evaluate_and_rank_move(MoveEntry* move) {
    long range1_low, range2_low;
    short result1, result2;
    int count1, count2;

    // Single tile validation for opening move
    if (g_tile_count == 1 && move->row > 15) {
        if (!validate_single_tile(move)) {
            return;
        }
    }

    // Special flagged moves update best directly
    if (move->flags != 0) {
        if (move->main_score > g_best_score) {
            memcpy(&g_dawg_info, move, 34);
        }
        return;
    }

    // Normal evaluation
    range1_low = g_score_range1;
    range2_low = g_score_range2;

    if (evaluate_ranges(move, &range1_low, &range2_low,
                        &result1, &result2) != 0) {
        return;
    }

    // Count current entries in range
    count1 = count_in_range(g_score_table1, range1_low);
    count2 = count_in_range(g_score_table2, range2_low);

    // Update tables if not full
    if (g_entry_count < 10) {
        g_entry_count++;
    }
    if (count1 < 10) {
        update_score_table(g_score_table1, count1, range1_low);
    }
    if (count2 < 10) {
        update_score_table(g_score_table2, count2, range2_low);
    }

    // Calculate component scores
    if (move->row == 0) {
        // First move - use comparison scores
        int score1 = get_score(g_compare1);
        int score2 = get_score(g_compare2);
        move->component_score = score1;
        move->bonus_score = score2 - score1;
    } else {
        move->component_score = calculate_component(move->main_score);
        move->bonus_score = result2;
    }

    // Submit for ranking (negated for min-heap behavior)
    rank_move(move, -range1_low, -range2_low);
}
```

### Function 0x01AE - Simple Ranking Callback
**Purpose**: Rank a move with simplified scoring (used for quick evaluations)

```asm
01AE: LINK       A6,#0
01B2: MOVEM.L    D6/D7/A4,-(SP)
01B6: MOVEA.L    8(A6),A4             ; move
01BA: MOVE.L     12(A6),-(A7)         ; score_param
01BE: JSR        2122(A5)             ; get_score
01C6: MOVE.L     D0,D7                ; save score

; Set minimal scores
01C8: CLR.L      20(A4)               ; component = 0
01CC: MOVEQ      #1,D0
01CE: MOVE.L     D0,24(A4)            ; bonus = 1

; Rank with same score for both criteria
01D4: NEG.L      D6
01D8: MOVE.L     D6,-(A7)             ; -score twice
01DA: MOVE.L     A4,-(A7)
01DC: JSR        2210(A5)             ; rank_move

01E6: UNLK       A6
01E8: RTS
```

### Function 0x02B4 - Main Move Comparison/Ranking Entry
**Purpose**: Compare two moves and perform full ranking analysis

This is the main entry point, allocating 342 bytes for a buffer of 10 move entries:
```asm
02B4: LINK       A6,#-342             ; 10 * 34 = 340 + 2 padding
```

Key operations:
1. Quick compare two moves
2. If identical, check special conditions
3. If different, initialize score tables to -200,000,000
4. Process each differing move through primary evaluator
5. Copy best result to output

### Function 0x0426 - Search Area Initialization
**Purpose**: Initialize ranking system for new search

```asm
0426: LINK       A6,#0
042A: MOVE.L     8(A6),-(A7)
042E: JSR        2410(A5)             ; setup_search

0432: CLR.W      -12540(A5)           ; g_entry_count = 0
0436: JSR        2434(A5)             ; additional_init

; Clear buffers
043A: PEA        $0154.W              ; 340 bytes (10 moves)
043E: PEA        -23056(A5)           ; g_dawg_search_area
0442: JSR        426(A5)              ; memset

0446: PEA        $0200.W              ; 512 bytes
044A: PEA        -22698(A5)           ; results buffer
044E: JSR        426(A5)

0452: PEA        $0200.W              ; 512 bytes
0456: PEA        -12496(A5)           ; cache buffer
045A: JSR        426(A5)

045E: UNLK       A6
0460: RTS
```

## Global Variables

| Offset | Size | Purpose |
|--------|------|---------|
| A5-1540 | 4 | g_score_range2_low - Range 2 threshold |
| A5-1576 | 40 | g_score_table2 - Second score table (10 longs) |
| A5-1580 | 4 | g_score_range1_low - Range 1 threshold |
| A5-1616 | 40 | g_score_table1 - First score table (10 longs) |
| A5-12496 | 512 | Move cache buffer |
| A5-12500 | 4 | g_compare2 - Second comparison move pointer |
| A5-12504 | 4 | g_compare1 - First comparison move pointer |
| A5-12540 | 2 | g_entry_count - Current entries in tables |
| A5-19486 | 4 | g_callback_ptr - Validation callback pointer |
| A5-20010 | 2 | g_tile_count - Tiles in current move |
| A5-22698 | 512 | Results buffer |
| A5-23056 | 340 | g_dawg_search_area - Move storage (10 entries) |
| A5-23062 | 2 | g_dawg_info.flags - Best move flags |
| A5-23074 | 4 | g_best_score - Current best score |
| A5-23090 | 34 | g_dawg_info - Best move entry |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 426 | memset - clear memory |
| 2090 | Evaluate move against score ranges |
| 2122 | Get score value from context |
| 2154 | Finalize comparison |
| 2178 | Commit ranking result |
| 2210 | Rank move in priority queue |
| 2218 | Alternative handler |
| 2226 | Check evaluation condition |
| 2234 | Special case handler |
| 2242 | Completion callback |
| 2274 | Quick move comparison |
| 2322 | Process move entry |
| 2410 | Setup search context |
| 2434 | Additional initialization |
| 2698 | Detailed move comparison |
| 2762 | Validate single tile move |
| 3466 | Update score table entry |

## Algorithm Notes

### Score Table Initialization
The magic value 0xF4143E00 = -200,000,000 in decimal ensures any valid Scrabble score will be greater, making the tables effectively empty initially.

### Negated Scores for Ranking
Scores are negated before ranking because the ranking system likely uses a min-heap or sorted list where smaller values have higher priority. Negating means the highest positive score becomes the most negative, thus highest priority.

### Two-Table Design
Using two parallel score tables allows:
- Primary scoring by raw points
- Secondary scoring by strategic value (word length, position, etc.)
- Tie-breaking between moves with equal raw scores

## Confidence: HIGH

The move ranking patterns are clear:
- Well-defined 34-byte move structure
- Consistent table management with 10 entries
- Score comparison and update logic
- Standard priority-based ranking approach
