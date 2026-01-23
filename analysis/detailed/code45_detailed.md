# CODE 45 Detailed Analysis - Move Evaluation and Ranking

## Overview

| Property | Value |
|----------|-------|
| Size | 1122 bytes |
| JT Offset | 2752 |
| JT Entries | 4 |
| Functions | 5 |
| Purpose | **Evaluate moves, compare scores, rank move candidates** |


## System Role

**Category**: Scoring
**Function**: Move Ranking

Ranks moves by value, maintains top-10 lists

**Related CODE resources**:
- CODE 32 (scoring)
- CODE 43 (move list)

**Scale Note**: Score tables initialized to -200,000,000 centipoints.
## Architecture Role

CODE 45 provides move evaluation and ranking:
1. Score comparison and range checking
2. Move candidate ranking by multiple criteria
3. Best move selection with tie-breaking
4. Search result initialization and cleanup

## Key Functions

### Function 0x0000 - Primary Move Evaluator
```asm
0000: LINK       A6,#-12              ; frame=12
0004: MOVEM.L    D6/D7/A3/A4,-(SP)    ; save regs
0008: MOVEA.L    8(A6),A4             ; A4 = move candidate

; Check for single tile special case
000C: CMPI.W     #$0001,-20010(A5)    ; g_tile_count == 1?
0012: BNE.S      $002A                ; No - continue
0014: CMPI.B     #$0F,32(A4)          ; Row > 15?
001A: BLE.S      $002A                ; No - continue

; Single tile validation
001C: MOVE.L     A4,-(A7)
001E: JSR        2762(A5)             ; JT[2762] - validate single tile
0022: TST.W      D0
0024: MOVE.B     A7,(A4)
0026: BEQ.W      $01A6                ; Invalid - return

; Check move flags
002A: TST.W      28(A4)               ; Flags field
002E: BEQ.S      $0050                ; No flags - continue

; Compare with current best
0030: MOVE.L     16(A4),D0            ; Main score
0034: MOVE.W     -23074(A5),(A0)      ; g_dawg_ptr
0038: BLE.W      $01A6                ; Score not better - return

; Copy move to dawg_info (best move)
003C: LEA        -23090(A5),A0        ; g_dawg_info destination
0040: LEA        (A4),A1              ; Source move
0042: MOVEQ      #7,D0                ; 8 longwords = 32 bytes
0044: MOVE.L     (A1)+,(A0)+          ; Copy loop
0046: DBF        D0,$0044
004A: MOVE.W     (A1)+,(A0)+          ; Plus 2 bytes = 34 total
004C: BRA.W      $01A6                ; Return

; Get score ranges from tables
0050: MOVE.L     -1580(A5),-8(A6)     ; Range 1 low bound
0056: MOVE.L     -1540(A5),-12(A6)    ; Range 2 low bound

; Call evaluation function
005C: PEA        -4(A6)               ; Result storage
0060: PEA        -2(A6)               ; Result storage
0064: PEA        -12(A6)              ; Range 2
0068: PEA        -8(A6)               ; Range 1
006C: MOVE.L     A4,-(A7)             ; Move candidate
006E: JSR        2090(A5)             ; JT[2090] - evaluate
0072: TST.W      D0                   ; Check result
0074: LEA        20(A7),A7
0078: BNE.W      $01A6                ; Failed - return

; Initialize score counters
007C: MOVEQ      #0,D7                ; Counter 1 = 0
007E: LEA        -1616(A5),A3         ; Score table 1

; Count scores in range 1
0082: BRA.S      $0088
0084: MOVEA.B    D7,A1
0086: MOVE.B     A3,(A4)
0088: MOVEA.W    -12540(A5),A7        ; g_entry_count
008C: BGE.S      $0096                ; Done
008E: MOVE.L     -8(A6),D0            ; Range bound
0092: MOVE.W     (A3),(A0)            ; Compare
0094: BLE.S      $0084                ; In range - count

; Count scores in range 2
0096: MOVEQ      #0,D6                ; Counter 2 = 0
0098: LEA        -1576(A5),A3         ; Score table 2

009C: BRA.S      $00A2
009E: MOVEA.B    D6,A1
00A0: MOVE.B     A3,(A4)
00A2: MOVEA.W    -12540(A5),A6        ; g_entry_count
00A6: BGE.S      $00B0                ; Done
00A8: MOVE.L     -12(A6),D0           ; Range bound
00AC: MOVE.W     (A3),(A0)            ; Compare
00AE: BLE.S      $009E                ; In range - count

; Check if need to update scores
00B0: CMPI.W     #$000A,-12540(A5)    ; Entry count >= 10?
00B6: BCC.S      $00BC                ; Yes - skip
00B8: MOVEA.B    -12540(A5),A1        ; Increment count

; Update range 1 scores if < 10 entries
00BC: CMPI.W     #$000A,D7            ; Counter 1 >= 10?
00C0: BCC.S      $00FA                ; Yes - skip update

00C2: MOVE.L     D7,D0
00C4: EXT.L      D0
...
00DE: MOVE.L     A3,-(A7)
00E0: MOVEA.L    A5,A0
00E2: MOVE.L     D7,D0
00E4: EXT.L      D0
...
00EA: PEA        -1612(A0)            ; Score table address
00EE: JSR        3466(A5)             ; JT[3466] - update table
00F2: MOVE.L     -8(A6),(A3)          ; Store new bound
00F6: LEA        12(A7),A7

; Update range 2 scores if < 10 entries
00FA: CMPI.W     #$000A,D6            ; Counter 2 >= 10?
00FE: BCC.S      $0138                ; Yes - skip update

0100: MOVE.L     D6,D0
0102: EXT.L      D0
...
0128: PEA        -1572(A0)            ; Score table address
012C: JSR        3466(A5)             ; JT[3466] - update table
0130: MOVE.L     -12(A6),(A3)         ; Store new bound
0134: LEA        12(A7),A7

; Check position (row 0 = center)
0138: TST.B      32(A4)               ; Row == 0?
013C: BNE.S      $0172                ; No - calculate score

; First move (row 0) - get comparison scores
013E: MOVE.L     -12504(A5),-(A7)     ; Score comparison
0142: JSR        2122(A5)             ; JT[2122] - get score
0146: MOVE.W     D0,D6                ; Save result
0148: MOVE.L     -12500(A5),(A7)      ; Second comparison
014C: JSR        2122(A5)             ; JT[2122]
0150: MOVEA.B    D0,A6                ; D0 - D6
0152: MOVEA.W    D6,A0
...
0162: MOVEA.W    D6,A0
...
016C: MOVE.L     A0,-8(A6)            ; Store result
0170: BRA.S      $017E

; Calculate move score
0172: MOVE.L     16(A4),D7            ; Main score
0176: MOVE.B     -8(A6),...           ; Adjust by range
017C: ...

; Store component scores in move structure
017E: ...
0182: MOVE.L     A0,20(A4)            ; Component score
0186: MOVEA.W    -4(A6),A0
018A: MOVE.L     A0,24(A4)            ; Bonus score

; Calculate final ranking
018E: MOVE.L     -8(A6),D0
0192: NEG.L      D0                   ; Negate for comparison
0194: MOVE.L     D0,-(A7)
0196: MOVE.L     -12(A6),D0
019A: NEG.L      D0
019C: MOVE.L     D0,-(A7)
019E: MOVE.L     A4,-(A7)
01A0: JSR        2210(A5)             ; JT[2210] - rank move

01A4: ...
01AA: UNLK       A6
01AC: RTS
```

**C equivalent**:
```c
void primary_move_evaluator(Move* move) {
    int range1_low, range2_low;
    int count1, count2;
    int result1, result2;

    // Single tile special case
    if (g_tile_count == 1 && move->row > 15) {
        if (!validate_single_tile(move)) {
            return;  // Invalid
        }
    }

    // Check if flagged as special
    if (move->flags != 0) {
        if (move->main_score > g_dawg_ptr) {
            // Copy to best move storage
            memcpy(g_dawg_info, move, 34);
        }
        return;
    }

    // Get score range bounds
    range1_low = g_score_range1_low;  // A5-1580
    range2_low = g_score_range2_low;  // A5-1540

    // Evaluate move against ranges
    if (evaluate_move(move, &range1_low, &range2_low,
                      &result1, &result2) != 0) {
        return;  // Failed evaluation
    }

    // Count entries in each score range
    count1 = count_in_range(g_score_table1, range1_low);
    count2 = count_in_range(g_score_table2, range2_low);

    // Update tables if not full
    if (count1 < 10) {
        update_score_table(g_score_table1, range1_low);
    }
    if (count2 < 10) {
        update_score_table(g_score_table2, range2_low);
    }

    // Calculate component scores
    if (move->row == 0) {
        // First move - use comparison scores
        int score1 = get_score(g_compare_score1);
        int score2 = get_score(g_compare_score2);
        move->component = score1;
        move->bonus = score2 - score1;
    } else {
        // Regular move calculation
        move->component = calculate_component(move->main_score, range1_low);
        move->bonus = calculate_bonus(result2);
    }

    // Submit for ranking
    rank_move(move, -range1_low, -range2_low);
}
```

### Function 0x01AE - Simple Move Callback
```asm
01AE: LINK       A6,#0
01B2: MOVEM.L    D6/D7/A4,-(SP)
01B6: MOVEA.L    8(A6),A4             ; A4 = move

; Get single comparison score
01BA: MOVE.L     12(A6),-(A7)         ; Score parameter
01BE: JSR        2122(A5)             ; JT[2122] - get score
01C2: MOVEA.B    D0,A0
01C4: EXT.L      D0
01C6: MOVE.L     D0,D7                ; D7 = score

; Clear component, set bonus to 1
01C8: CLR.L      20(A4)               ; Component = 0
01CC: MOVEQ      #1,D0
01CE: MOVE.L     D0,24(A4)            ; Bonus = 1

; Rank with negated score
01D2: MOVE.L     D7,D6
01D4: NEG.L      D6                   ; Negate
01D6: MOVE.L     D6,(A7)
01D8: MOVE.L     D6,-(A7)             ; Same for both
01DA: MOVE.L     A4,-(A7)             ; Move
01DC: JSR        2210(A5)             ; JT[2210] - rank

01E0: MOVEM.L    -12(A6),D6/D7/A4
01E6: UNLK       A6
01E8: RTS
```

**C equivalent**:
```c
void simple_move_callback(Move* move, int score_param) {
    int score = get_score(score_param);

    move->component = 0;
    move->bonus = 1;

    // Rank with negated score (lower is better)
    rank_move(move, -score, -score);
}
```

### Function 0x01EA - Multi-Phase Move Evaluation
```asm
01EA: LINK       A6,#-6               ; frame=6
01EE: MOVEM.L    A3/A4,-(SP)
01F2: MOVEA.L    8(A6),A4             ; A4 = move context

; Initialize evaluation
01F6: JSR        2594(A5)             ; JT[2594] - init

; Get base score
01FA: MOVE.W     8(A4),D0             ; Position score
01FE: ...

; Check various flags
0206: ...
020A: TST.B      29(A4)               ; Error flag?
020E: BEQ.S      $0214
0210: JSR        418(A5)              ; JT[418] - error handler

; Phase 1: Standard evaluation
0214: TST.B      26(A4)               ; Skip flag?
0218: BNE.S      $0246                ; Yes - skip phase 1

021A: JSR        2226(A5)             ; JT[2226] - check condition
021E: TST.W      D0
0220: BEQ.S      $0246                ; Condition not met

; Get comparison scores
0222: MOVE.L     -12500(A5),-(A7)     ; g_compare2
0226: JSR        2122(A5)             ; JT[2122]
022A: MOVE.W     D0,-6(A6)            ; Save score 1

022E: MOVE.L     -12504(A5),(A7)      ; g_compare1
0232: JSR        2122(A5)             ; JT[2122]
0236: MOVE.W     -6(A6),D1            ; Get score 1
023A: MOVEA.B    D0,A1                ; Score 2
023C: MOVE.W     D1,(A4)              ; Store diff
023E: MOVE.W     D1,2(A4)
...
0244: BRA.S      $02AC                ; Done

; Phase 2: Alternative evaluation
0246: TST.B      28(A4)               ; Alt flag?
024A: BNE.S      $02AC                ; Skip
024C: TST.B      24(A4)               ; Another flag?
0250: BNE.S      $02AC
0252: TST.W      4(A4)                ; Score threshold?
0256: BNE.S      $02AC

; Check for special processing
0258: TST.B      26(A4)               ; Need callback?
025C: BNE.S      $0282                ; Yes

; Standard scoring
025E: MOVE.L     -12500(A5),-(A7)     ; g_compare2
0262: JSR        2122(A5)             ; JT[2122]
0266: MOVE.W     D0,-6(A6)
026A: MOVE.L     -12504(A5),(A7)      ; g_compare1
026E: JSR        2122(A5)             ; JT[2122]
0272: MOVE.W     -6(A6),D1
0276: MOVEA.B    D0,A1
0278: MOVE.W     D1,(A4)
027A: MOVE.W     D1,2(A4)
...
0280: BRA.S      $02AC

; Callback-based evaluation
0282: JSR        2282(A5)             ; JT[2282] - get callback
0286: MOVEA.L    D0,A3                ; A3 = callback context
0288: MOVE.L     A3,D0
028A: BEQ.S      $02AC                ; No callback

; Set up and execute callback
028C: MOVE.B     #$7F,25(A3)          ; Set flag
0292: MOVE.L     A3,-(A7)             ; Callback context
0294: MOVE.L     A4,-(A7)             ; Move
0296: JSR        2250(A5)             ; JT[2250] - execute

; Store negated scores
029A: MOVE.W     2(A4),D0
029E: NEG.W      D0
02A0: MOVE.W     D0,(A3)              ; Negated score 1
02A2: MOVE.W     (A4),D0
02A4: NEG.W      D0
02A6: MOVE.W     D0,2(A3)             ; Negated score 2
02AA: ...

02AC: MOVEM.L    (SP)+,A3/A4
02B0: UNLK       A6
02B2: RTS
```

**C equivalent**:
```c
void multi_phase_evaluation(MoveContext* ctx) {
    int score1, score2;

    init_evaluation();

    if (ctx->error_flag) {
        error_handler();
    }

    if (!ctx->skip_phase1) {
        if (check_condition()) {
            // Phase 1 scoring
            score1 = get_score(g_compare2);
            score2 = get_score(g_compare1);
            ctx->result1 = score2 - score1;
            ctx->result2 = score2 - score1;
            return;
        }
    }

    if (!ctx->alt_flag && !ctx->other_flag && ctx->threshold == 0) {
        if (!ctx->need_callback) {
            // Standard scoring
            score1 = get_score(g_compare2);
            score2 = get_score(g_compare1);
            ctx->result1 = score2 - score1;
            ctx->result2 = score2 - score1;
        } else {
            // Callback-based scoring
            CallbackContext* callback = get_callback();
            if (callback) {
                callback->flag = 0x7F;
                execute_callback(ctx, callback);
                callback->neg_score1 = -ctx->result2;
                callback->neg_score2 = -ctx->result1;
            }
        }
    }
}
```

### Function 0x02B4 - Main Comparison/Ranking Function
```asm
02B4: LINK       A6,#-342             ; frame=342 (large buffer)
02B8: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
02BC: MOVEA.L    8(A6),A3             ; A3 = move 1
02C0: MOVEA.L    12(A6),A4            ; A4 = move 2

; Initial comparison
02C4: MOVE.L     A4,-(A7)
02C6: MOVE.L     A3,-(A7)
02C8: CLR.L      -(A7)
02CA: JSR        2274(A5)             ; JT[2274] - compare moves
02CE: TST.L      D0
02D0: LEA        12(A7),A7
02D4: BNE.W      $041E                ; Not equal - done

; Perform detailed comparison
02D8: PEA        -340(A6)             ; Buffer
02DC: MOVE.L     A4,-(A7)
02DE: MOVE.L     A3,-(A7)
02E0: JSR        2698(A5)             ; JT[2698] - detailed compare
02E4: MOVE.W     D0,D6                ; D6 = result
02E6: TST.W      D6
02E8: LEA        12(A7),A7
02EC: BNE.S      $0344                ; Different - process

; Check if condition met
02EE: JSR        2226(A5)             ; JT[2226]
02F2: TST.W      D0
02F4: BEQ.S      $0336                ; Not met

; Set up move entry
02F6: PEA        $0022.W              ; 34 bytes
02FA: PEA        -340(A6)             ; Buffer
02FE: JSR        426(A5)              ; JT[426] - clear/init

0302: MOVE.W     #$007F,-310(A6)      ; Set flag = 0x7F

; Get scores and rank
0308: MOVE.L     A3,(A7)
030A: JSR        2122(A5)             ; JT[2122]
030E: MOVE.W     D0,-342(A6)          ; Save score 1

0312: MOVE.L     A4,(A7)
0314: JSR        2122(A5)             ; JT[2122]
0318: MOVE.W     -342(A6),D5          ; Get score 1
031C: MOVEA.B    D0,A5                ; Score 2
031E: MOVEA.W    D5,A0
0320: MOVE.L     A0,(A7)
0322: MOVEA.W    D5,A0
0324: MOVE.L     A0,-(A7)
0326: PEA        -340(A6)             ; Move entry
032A: JSR        2210(A5)             ; JT[2210] - rank
032E: LEA        16(A7),A7
0332: BRA.W      $041E                ; Done

; Call alternative handler
0336: MOVE.L     A4,-(A7)
0338: MOVE.L     A3,-(A7)
033A: JSR        2218(A5)             ; JT[2218]
033E: ...
0340: BRA.W      $041E

; Process different moves
0344: MOVE.L     A3,-(A7)
0346: JSR        222(PC)              ; Local function
034A: MOVE.L     A3,-12500(A5)        ; g_compare2 = move1
034E: MOVE.L     A4,-12504(A5)        ; g_compare1 = move2

; Initialize score tables
0352: MOVEQ      #0,D5
0354: LEA        -1576(A5),A2         ; Score table 2
0358: LEA        -1616(A5),A0         ; Score table 1
035C: MOVE.L     A0,D7
...
; Initialize 10 entries to large negative
0362: MOVE.L     #$F4143E00,D0        ; -200000000
0368: MOVE.L     D0,(A2)              ; Store in table 2
036A: MOVEA.L    D7,A0
036C: MOVE.L     D0,(A0)              ; Store in table 1
036E: ...
0374: CMPI.W     #$000A,D5            ; 10 entries?
0378: BCS.S      $0362                ; Continue init

; Clear dawg_info
037A: PEA        $0022.W              ; 34 bytes
037E: PEA        -23090(A5)           ; g_dawg_info
0382: JSR        426(A5)              ; JT[426] - clear
0386: CLR.L      -19486(A5)           ; g_callback_ptr = NULL

; Process moves
038A: MOVEQ      #0,D5
038C: LEA        -340(A6),A2          ; Buffer
0390: ...
0392: BRA.S      $03A8

0394: MOVE.L     A2,-(A7)
0396: JSR        2322(A5)             ; JT[2322] - process move
039A: MOVE.L     A2,(A7)
039C: JSR        -926(PC)             ; Call function 0x0000
03A0: ...
03A4: LEA        34(A2),A2            ; Next move entry
03A8: ...                             ; Loop while D5 < D6

; Check for special case
03AC: CMPI.W     #$000A,D6            ; 10 moves?
03B0: BNE.S      $03C0
03B2: JSR        2234(A5)             ; JT[2234]
03B6: PEA        2794(A5)             ; Callback address
03BA: JSR        2618(A5)             ; JT[2618]
03BE: ...

; Finalize ranking
03C0: PEA        $0022.W              ; 34 bytes
03C4: PEA        -340(A6)
03C8: JSR        426(A5)              ; JT[426]

03CC: MOVE.W     #$007F,-310(A6)      ; Flag = 0x7F
03D2: PEA        -340(A6)
03D6: JSR        -984(PC)             ; Final evaluation

; Check dawg_info result
03DA: TST.W      -23062(A5)           ; g_dawg_info flags
03DE: LEA        12(A7),A7
03E2: BEQ.S      $03F0                ; Not set

; Copy result
03E4: MOVE.L     A4,-(A7)
03E6: PEA        -23090(A5)           ; g_dawg_info
03EA: JSR        -574(PC)             ; Copy result
03EE: ...

; Final processing
03F0: MOVE.L     A4,-(A7)
03F2: MOVE.L     A3,-(A7)
03F4: JSR        2154(A5)             ; JT[2154] - finalize
03F8: MOVE.L     A4,(A7)
03FA: MOVE.L     A3,-(A7)
03FC: JSR        2178(A5)             ; JT[2178] - commit

; Verify results match
0400: ...                             ; Compare -12500 and -12504
0406: ...
040A: ...
0410: JSR        418(A5)              ; JT[418] - error if mismatch

; Call completion callback
0414: PEA        2786(A5)             ; A5+2786 callback
0418: JSR        2242(A5)             ; JT[2242] - complete
041C: ...
0422: UNLK       A6
0424: RTS
```

**C equivalent**:
```c
void compare_and_rank_moves(Move* move1, Move* move2) {
    Move buffer[10];  // 340 bytes = 10 * 34
    int result;

    // Quick comparison
    result = compare_moves(move1, move2, 0);
    if (result != 0) return;  // Different

    // Detailed comparison
    int diff_count = detailed_compare(move1, move2, buffer);

    if (diff_count == 0) {
        // Identical moves - check condition
        if (check_condition()) {
            // Create ranking entry
            clear_buffer(&buffer[0], 34);
            buffer[0].flags = 0x7F;

            int score1 = get_score(move1);
            int score2 = get_score(move2);
            rank_move(&buffer[0], score1, score1);
        } else {
            // Alternative handling
            alt_handler(move1, move2);
        }
        return;
    }

    // Different moves - full comparison
    local_init(move1);
    g_compare2 = move1;
    g_compare1 = move2;

    // Initialize score tables to large negative
    for (int i = 0; i < 10; i++) {
        g_score_table1[i] = -200000000;
        g_score_table2[i] = -200000000;
    }

    // Clear best move storage
    memset(g_dawg_info, 0, 34);
    g_callback_ptr = NULL;

    // Process each differing move
    for (int i = 0; i < diff_count; i++) {
        process_move(&buffer[i]);
        primary_move_evaluator(&buffer[i]);
    }

    // Special handling for 10 moves
    if (diff_count == 10) {
        special_handler();
        special_callback(callback_2794);
    }

    // Final ranking
    clear_buffer(&buffer[0], 34);
    buffer[0].flags = 0x7F;
    final_evaluation(&buffer[0]);

    // Copy best result if found
    if (g_dawg_info.flags != 0) {
        copy_result(g_dawg_info, move2);
    }

    // Finalize
    finalize(move1, move2);
    commit_result(move1, move2);

    // Verify
    if (g_compare2 != move1 || g_compare1 != move2) {
        error_handler();
    }

    // Complete
    completion_callback(callback_2786);
}
```

### Function 0x0426 - Search Area Initialization
```asm
0426: LINK       A6,#0
042A: MOVE.L     8(A6),-(A7)          ; Parameter
042E: JSR        2410(A5)             ; JT[2410] - setup search

; Clear entry count
0432: CLR.W      -12540(A5)           ; g_entry_count = 0

; Initialize structures
0436: JSR        2434(A5)             ; JT[2434] - additional init

; Clear search area (340 bytes = 10 moves)
043A: PEA        $0154.W              ; 340 bytes
043E: PEA        -23056(A5)           ; g_dawg_search_area
0442: JSR        426(A5)              ; JT[426] - memset

; Clear results area (512 bytes)
0446: PEA        $0200.W              ; 512 bytes
044A: PEA        -22698(A5)           ; A5-22698 results
044E: JSR        426(A5)              ; JT[426]

; Clear cache (512 bytes)
0452: PEA        $0200.W              ; 512 bytes
0456: PEA        -12496(A5)           ; A5-12496 cache
045A: JSR        426(A5)              ; JT[426]

045E: UNLK       A6
0460: RTS
```

**C equivalent**:
```c
void search_area_init(void* param) {
    setup_search(param);
    g_entry_count = 0;
    additional_init();

    // Clear move storage (10 entries * 34 bytes)
    memset(g_dawg_search_area, 0, 340);

    // Clear results buffer
    memset(g_results_buffer, 0, 512);

    // Clear cache
    memset(g_move_cache, 0, 512);
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1540 | g_score_range2_low - Range 2 lower bound |
| A5-1576 | g_score_table2 - Score table 2 (10 entries) |
| A5-1580 | g_score_range1_low - Range 1 lower bound |
| A5-1612 | Score table 1 alternate |
| A5-1616 | g_score_table1 - Score table 1 (10 entries) |
| A5-12496 | g_move_cache - Move cache (512 bytes) |
| A5-12500 | g_compare2 - Comparison move 2 pointer |
| A5-12504 | g_compare1 - Comparison move 1 pointer |
| A5-12540 | g_entry_count - Current entry count |
| A5-19486 | g_callback_ptr - Validation callback |
| A5-20010 | g_tile_count - Tiles in current move |
| A5-22698 | Results buffer (512 bytes) |
| A5-23056 | g_dawg_search_area - Move results (340 bytes) |
| A5-23062 | g_dawg_info flags word |
| A5-23074 | g_dawg_ptr - Current DAWG pointer |
| A5-23090 | g_dawg_info - Best move storage (34 bytes) |
| A5+2786 | Completion callback address |
| A5+2794 | Special case callback address |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 426 | Memory clear/init (memset) |
| 2090 | Evaluate move against ranges |
| 2122 | Get score value |
| 2154 | Finalize comparison |
| 2178 | Commit result |
| 2210 | Rank move by score |
| 2218 | Alternative handler |
| 2226 | Check condition |
| 2234 | Special handler |
| 2242 | Completion callback |
| 2250 | Execute callback |
| 2274 | Compare moves |
| 2282 | Get callback context |
| 2322 | Process move |
| 2410 | Setup search |
| 2434 | Additional initialization |
| 2594 | Initialize evaluation |
| 2618 | Special callback |
| 2698 | Detailed move comparison |
| 2762 | Validate single tile |
| 3466 | Update score table |

## Score Table Structure

Each score table holds 10 entries for tracking best scores:
- Initialized to -200000000 (very negative)
- Updated as better moves are found
- Used for move ranking and selection

## Move Entry Structure (34 bytes)

| Offset | Size | Field |
|--------|------|-------|
| 0-15 | 16 | Move data |
| 16 | 4 | Main score |
| 20 | 4 | Component score |
| 24 | 4 | Bonus score |
| 28 | 2 | Flags (0x7F = special) |
| 30 | 2 | Position |
| 32 | 1 | Row |
| 33 | 1 | Column |

## Confidence: HIGH

Clear move evaluation and ranking patterns:
- Score range-based filtering
- Multi-phase evaluation with callbacks
- Large comparison buffer for 10 moves
- Negated scores for ranking (lower = better)
