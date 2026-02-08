# CODE 32 Detailed Analysis - Core Move Scoring, Leave Evaluation, and V/C Balance

## Overview

| Property | Value |
|----------|-------|
| Size | 2,320 bytes (resource) / 6,464 bytes (QEMU memory dump) |
| JT Offset | 2384 (0x0950) |
| JT Entries | 13 |
| Functions | ~20 (large module) |
| Purpose | **Core move scoring with leave value adjustments and vowel/consonant balance** |

## System Role

**Category**: Scoring Engine + Leave Evaluation + VCB
**Function**: Move Evaluation with Per-Tile Leave Values and V/C Balance

This is the central scoring module that:
1. Evaluates base tile scores with letter/word multipliers
2. Applies bingo bonus (5000 centipoints = 50 points)
3. Applies per-tile MUL leave values via binomial weighting (SANE FP)
4. Computes vowel/consonant balance via algorithmic V/C-parameterized calculation
5. Tracks best positions for move generation

**Scale Note**: All scores in CENTIPOINTS (1/100 of a point).

## Architecture Role

CODE 32 coordinates with:
- **CODE 15**: Loads MUL resources (leave value tables per tile)
- **CODE 39**: Letter combination synergy scoring
- **CODE 45**: Move ranking
- **CODE 35**: Simulation engine (uses same scoring)

---

## Function 0x0000 - Main Move Evaluation (Frame: 324 bytes)

### Annotated Disassembly

```asm
;======================================================================
; evaluate_move - Main move evaluation function
; Frame: 324 bytes
; Parameters: 8(A6) = move_ptr, 12(A6) = opponent_rack
; Returns: D0 = total score in centipoints
;======================================================================
0x0000: 4E56 FEBC    LINK    A6,#-324
0x0004: 48E7 1F38    MOVEM.L D3-D7/A2-A4,-(SP)

; Clear position tracking globals
0x0008: 426D BCFA    CLR.W   -17158(A5)          ; g_best_col = 0
0x000C: 426D BCF8    CLR.W   -17160(A5)          ; g_best_col2 = 0
0x0010: 426D BCF6    CLR.W   -17162(A5)          ; g_best_row = 0
0x0014: 426D BCF4    CLR.W   -17164(A5)          ; g_best_row2 = 0
0x0018: 426D B1D6    CLR.W   -20010(A5)          ; g_tile_count = 0

; Get move word pointer (move_ptr + 32)
0x001C: 7020         MOVEQ   #32,D0
0x001E: D0AE 0008    ADD.L   8(A6),D0            ; D0 = move_ptr + 32
0x0022: 2840         MOVEA.L D0,A4               ; A4 = &move->word[0]
0x0024: 4A14         TST.B   (A4)                ; empty move?
0x0026: 6606         BNE.S   0x002E              ; continue if non-empty
0x0028: 7000         MOVEQ   #0,D0               ; return 0
0x002A: 6000 0618    BRA.W   0x0646              ; → epilogue

; Load rack pointer and initialize letter counts
0x002E: 246D 99D2    MOVEA.L -26158(A5),A2       ; A2 = g_rack
; ... (letter count initialization loop)
; ... (opponent rack adjustment loop)
; ... (board position setup with 17x17 arrays)

; === SCORING LOOP ===
; For each tile in the word:
;   - Check board occupancy
;   - Apply letter/word multipliers
;   - Accumulate cross-word scores
;   - Track best positions

; BINGO BONUS CHECK at 0x0328:
0x0328: 0C6D 0007 B1D6  CMPI.W  #7,-20010(A5)   ; g_tile_count == 7?
0x032E: 6606             BNE.S   0x0336           ; skip if not bingo
0x0330: 303C 1388        MOVE.W  #$1388,D0        ; D0 = 5000 (50 pts)
0x0334: 6002             BRA.S   0x0338
0x0336: 7000             MOVEQ   #0,D0            ; no bonus

; Add bingo to score, then leave evaluation...

; EPILOGUE:
0x0646: 4CDF 1CF8        MOVEM.L (SP)+,D3-D7/A2-A4
0x064A: 4E5E             UNLK    A6
0x064C: 4E75             RTS
```

### C Decompilation

```c
/* evaluate_move - Score a proposed move including all adjustments
 *
 * Parameters:
 *   move_ptr: Pointer to 34-byte Move structure
 *   opponent_rack: String of opponent's known tiles
 * Returns: Total score in centipoints, or 0 if invalid
 */
long evaluate_move(Move *move_ptr, char *opponent_rack) {
    /* Stack frame: 324 bytes */
    short letter_counts[128];       /* -256(A6) */
    long  accumulated_score;        /* -324(A6) */
    long  cross_word_total;         /* -320(A6) */
    long  best_score_1, best_score_2; /* -314(A6), -310(A6) */

    /* Clear position tracking */
    g_best_col = g_best_col2 = 0;
    g_best_row = g_best_row2 = 0;
    g_tile_count = 0;

    char *word = (char *)move_ptr + 32;
    if (*word == 0) return 0;       /* empty move */

    /* Initialize letter counts from rack */
    for (char *p = g_rack; *p; p++)
        letter_counts[(unsigned char)*p] = 0;
    for (char *p = opponent_rack; *p; p++)
        letter_counts[(unsigned char)*p]++;

    /* Board position setup (17x17 grid) */
    int row = move_ptr->row;
    char *board = &g_board_letters[row * 17];
    short *scores = &g_board_scores[row * 34];

    accumulated_score = 1;  /* multiplicative identity */
    cross_word_total = 0;

    /* Score each tile in the word */
    for (int col = 0; word[col]; col++) {
        if (board[col] == 0) {
            /* Placing new tile */
            int val = g_letter_values[col];
            accumulated_score *= val;           /* JT[66] */
            g_tile_count++;

            if (g_tile_count >= 8 || g_tile_count <= 0)
                bounds_error();                 /* JT[418] */

            /* Cross-word scoring and multiplier application */
            /* ... (complex logic with word multipliers) ... */

            /* Update best position tracking */
            update_best_positions(col, accumulated_score);
        }
        /* else: existing tile on board, add to score without multipliers */
    }

    /* Bingo bonus: 50 points for using all 7 tiles */
    short bingo = (g_tile_count == 7) ? 5000 : 0;

    long final_score = accumulated_score + cross_word_total + bingo;

    /* Leave evaluation applied elsewhere in pipeline */
    return final_score;
}
```

---

## Function 0x08B8 - Initialize Scoring Context (Frame: 136 bytes)

### Annotated Disassembly

```asm
;======================================================================
; init_scoring_context - Set up working buffers and tile distribution
; Frame: 136 bytes
; Parameters: 8(A6) = &local_26 (output), 12(A6) = &local_18 (output)
;             16(A6) = &local_20 (output), 20(A6) = &local_22 (output)
; Fills output pointers with tile distribution parameters
;======================================================================
0x08B8: 4E56 FF78    LINK    A6,#-136
0x08BC: 48E7 0338    MOVEM.L D6-D7/A2-A4,-(SP)
0x08C0: 2E2E 000C    MOVE.L  12(A6),D7
0x08C4: 286E 0010    MOVEA.L 16(A6),A4

; Increment scoring counter
0x08C8: 52AD B1DC    ADDQ.L  #1,-20004(A5)       ; g_score_counter++
0x08CC: 2B6D B1DC B1D8  MOVE.L -20004(A5),-20008(A5) ; save as threshold

; Clear working buffers (256 bytes each)
0x08D2: 4878 0100    PEA     #256
0x08D6: 486D BBF4    PEA     -17420(A5)           ; g_work_buffer
0x08DA: 4EAD 01AA    JSR     426(A5)              ; memset(buf, 0, 256)

0x08DE: 4878 0100    PEA     #256
0x08E2: 486D CCFC    PEA     -13060(A5)           ; g_secondary_buffer
0x08E6: 4EAD 01AA    JSR     426(A5)              ; memset(buf, 0, 256)

; Clear leave index
0x08EA: 426D CCFA    CLR.W   -13062(A5)           ; g_leave_index = 0

; Call sub-initialization, populate tile distribution parameters
; ... (writes to output pointers passed via 8/12/16/20(A6))
```

### C Decompilation

```c
/* init_scoring_context - Prepare for leave evaluation pass
 *
 * Fills output parameters with tile distribution info:
 *   out_local26: counter value
 *   out_local18: distribution param 1
 *   out_local20: distribution param 2
 *   out_local22: distribution param 3
 */
void init_scoring_context(long *out_local26, long *out_local18,
                          short *out_local20, short *out_local22) {
    g_score_counter++;
    g_score_counter_prev = g_score_counter;

    memset(g_work_buffer, 0, 256);          /* JT[426] */
    memset(g_secondary_buffer, 0, 256);     /* JT[426] */
    g_leave_index = 0;

    /* Sub-initialization populates tile distribution from bag state */
    /* ... fills *out_local20, *out_local22, etc. ... */
}
```

---

## Function 0x09D8 - Leave Orchestrator (Frame: 40 bytes)

### Annotated Disassembly

```asm
;======================================================================
; leave_orchestrator - Iterate ESTR patterns, classify V/C, compute leave
; Frame: 40 bytes
; Called from evaluate_move pipeline
; Uses: ESTR patterns at A5-17156 (128 entries)
;       Letter values at A5-27630
;       JT[2002] for vowel classification
;======================================================================
0x09D8: 4E56 FFD8    LINK    A6,#-40
0x09DC: 48E7 1F38    MOVEM.L D3-D7/A2-A4,-(SP)

; Initialize tile distribution parameters
0x09E0: 486E FFEA    PEA     -22(A6)              ; &local_22
0x09E4: 486E FFEC    PEA     -20(A6)              ; &local_20
0x09E8: 486E FFEE    PEA     -18(A6)              ; &local_18
0x09EC: 486E FFE6    PEA     -26(A6)              ; &local_26
0x09F0: 4EBA FEC6    JSR     0x08B8               ; init_scoring_context

; Setup string helper
0x09F4: 486E FFE2    PEA     -30(A6)              ; &local_30
0x09F8: 2F2D 93BC    MOVE.L  -27716(A5),-(SP)     ; string data ptr
0x09FC: 4EBA 0CBE    JSR     0x16BC               ; string setup

; Read configuration
0x0A00: 122D CE75    MOVE.B  -12683(A5),D1        ; config byte
0x0A04: 4881         EXT.W   D1
0x0A06: C3C0         MULS.W  D0,D1
0x0A08: 48C1         EXT.L   D1
0x0A0A: 93AE FFE6    SUB.L   D1,-26(A6)           ; adjust counter

; Main loop setup
0x0A0E: 7C7F         MOVEQ   #127,D6              ; D6 = 127 (128 patterns)
0x0A10: 49ED BCF2    LEA     -17166(A5),A4        ; A4 = ESTR pattern base
0x0A14: 41ED CCF8    LEA     -13064(A5),A0        ; A0 = ESTR record base
0x0A18: 2E08         MOVE.L  A0,D7                ; D7 = record pointer
0x0A1A: 4FEF 0018    LEA     24(SP),SP            ; clean stack (6 longs)
0x0A1E: 6000 01CE    BRA.W   0x0BEE               ; → loop test

;=== PATTERN LOOP BODY ===
; Clear V/C/blank counters
0x0A22: 426E FFE0    CLR.W   -32(A6)              ; blank_count = 0
0x0A26: 426E FFDE    CLR.W   -34(A6)              ; consonant_count = 0
0x0A2A: 426E FFDC    CLR.W   -36(A6)              ; vowel_count = 0

; Setup for letter classification
0x0A2E: 47ED CDFC    LEA     -12804(A5),A3        ; A3 = pattern string table
0x0A32: 45EE FFF0    LEA     -16(A6),A2           ; A2 = cross-check buffer
0x0A36: 7800         MOVEQ   #0,D4                ; D4 = 0 (letter counter)
0x0A38: 41ED 99D6    LEA     -26154(A5),A0
0x0A3C: 2D48 FFD8    MOVE.L  A0,-40(A6)           ; save for later
0x0A40: 6056         BRA.S   0x0A98               ; → inner loop test

;--- Letter classification inner loop ---
0x0A42: 206E FFD8    MOVEA.L -40(A6),A0           ; A0 = data ptr
0x0A46: 2006         MOVE.L  D6,D0
0x0A48: 48C0         EXT.L   D0
0x0A4A: C090         AND.L   D0,D0                ; pattern index check
0x0A4C: 6742         BEQ.S   0x0A90               ; skip if no match

; Classify this letter
0x0A4E: 14C5         MOVE.B  D5,(A2)+             ; store letter in buffer
0x0A50: 3F05         MOVE.W  D5,-(SP)             ; push letter
0x0A52: 4EAD 07D2    JSR     2002(A5)             ; JT[2002]: is_vowel(letter)
0x0A56: 4A40         TST.W   D0                   ; vowel?
0x0A58: 548F         ADDQ.L  #2,SP
0x0A5A: 6706         BEQ.S   0x0A62               ; if 0 → not vowel

; It's a vowel
0x0A5C: 526E FFDC    ADDQ.W  #1,-36(A6)           ; vowel_count++
0x0A60: 6010         BRA.S   0x0A72               ; continue

; Check if blank
0x0A62: 0C45 003F    CMPI.W  #$3F,D5              ; D5 == '?' (0x3F)?
0x0A66: 6706         BEQ.S   0x0A6E               ; → blank handler

; It's a consonant
0x0A68: 526E FFDE    ADDQ.W  #1,-34(A6)           ; consonant_count++
0x0A6C: 6004         BRA.S   0x0A72               ; continue

; It's a blank
0x0A6E: 526E FFE0    ADDQ.W  #1,-32(A6)           ; blank_count++

; Accumulate cross-check score
0x0A72: 102B 0001    MOVE.B  1(A3),D0             ; letter from pattern
0x0A76: 4880         EXT.W   D0
0x0A78: B045         CMP.W   D5,D0                ; match letter?
0x0A7A: 6614         BNE.S   0x0A90               ; skip if no match

; Add letter's point value to cross-check score
0x0A7C: 204D         MOVEA.L A5,A0
0x0A7E: 2004         MOVE.L  D4,D0
0x0A80: 48C0         EXT.L   D0
0x0A82: E588         LSL.L   #2,D0
0x0A84: D1C0         ADDA.L  D0,A0
0x0A86: 2006         MOVE.L  D6,D0
0x0A88: 48C0         EXT.L   D0
0x0A8A: C0A8 99DA    AND.L   -26150(A0),D0        ; masked value
0x0A8E: 6710         BEQ.S   0x0AA0

; Next letter in pattern
0x0A90: 5244         ADDQ.W  #1,D4                ; letter counter++
0x0A92: 58AE FFD8    ADDQ.L  #4,-40(A6)           ; advance data ptr
0x0A96: 528B         ADDQ.L  #1,A3                ; next pattern byte
0x0A98: 1A13         MOVE.B  (A3),D5              ; D5 = next letter
0x0A9A: 4885         EXT.W   D5
0x0A9C: 4A45         TST.W   D5                   ; end of pattern?
0x0A9E: 66A2         BNE.S   0x0A42               ; loop if not

; End of letter classification
0x0AA0: 4A45         TST.W   D5                   ; any letters found?
0x0AA2: 6600 0144    BNE.W   0x0BE8               ; skip to next pattern

; Null-terminate cross-check buffer
0x0AA6: 4212         CLR.B   (A2)

; --- Compute leave_size = 7 - strlen(pattern) ---
0x0AA8: 302D CCFA    MOVE.W  -13062(A5),D0        ; g_leave_index
0x0AAC: 526D CCFA    ADDQ.W  #1,-13062(A5)        ; g_leave_index++
0x0AB0: 204D         MOVEA.L A5,A0
0x0AB2: D0C0         ADDA.W  D0,A0
0x0AB4: D0C0         ADDA.W  D0,A0
0x0AB6: 3146 CCFC    MOVE.W  D6,-13060(A0)        ; store pattern index

; Cross-check score computation
0x0ABA: 2047         MOVEA.L D7,A0
0x0ABC: 4250         CLR.W   (A0)                 ; clear score slot
0x0ABE: 45EE FFF0    LEA     -16(A6),A2           ; A2 = cross-check buffer
0x0AC2: 6010         BRA.S   0x0AD4               ; → loop test

; Sum letter values for cross-check score
0x0AC4: 204D         MOVEA.L A5,A0
0x0AC6: D0C5         ADDA.W  D5,A0
0x0AC8: D0C5         ADDA.W  D5,A0
0x0ACA: 3028 9412    MOVE.W  -27630(A0),D0        ; letter value from table
0x0ACE: 2047         MOVEA.L D7,A0
0x0AD0: D150         ADD.W   D0,(A0)              ; accumulate score
0x0AD2: 528A         ADDQ.L  #1,A2                ; next letter
0x0AD4: 1A12         MOVE.B  (A2),D5
0x0AD6: 4885         EXT.W   D5
0x0AD8: 4A45         TST.W   D5
0x0ADA: 66E8         BNE.S   0x0AC4               ; loop

; --- Compute D4 = min(unseen-7, 7-pattern_length) ---
0x0ADC: 486E FFF0    PEA     -16(A6)              ; push cross-check str
0x0AE0: 4EAD 0DC2    JSR     3522(A5)             ; strlen
0x0AE4: 7807         MOVEQ   #7,D4
0x0AE6: 9840         SUB.W   D0,D4               ; D4 = 7 - strlen
0x0AE8: 76F9         MOVEQ   #-7,D3
0x0AEA: D66D CF06    ADD.W   -12538(A5),D3        ; D3 = unseen - 7
0x0AEE: B644         CMP.W   D4,D3
0x0AF0: 588F         ADDQ.L  #4,SP
0x0AF2: 6C04         BGE.S   0x0AF8
0x0AF4: 3003         MOVE.W  D3,D0                ; D0 = min
0x0AF6: 6002         BRA.S   0x0AFA
0x0AF8: 3004         MOVE.W  D4,D0
0x0AFA: 3800         MOVE.W  D0,D4               ; D4 = min(unseen-7, 7-len)

; --- String/tile helper ---
0x0AFC: 486E FFE2    PEA     -30(A6)
0x0B00: 486E FFF0    PEA     -16(A6)
0x0B04: 4EBA 0B42    JSR     0x1648               ; tile_string_helper
0x0B08: 3600         MOVE.W  D0,D3               ; D3 = result
0x0B0A: 508F         ADDQ.L  #8,SP
0x0B0C: 6700 00A2    BEQ.W   0x0BB0               ; skip if result == 0

; Threshold check
0x0B10: 206E FFE2    MOVEA.L -30(A6),A0
0x0B14: 2010         MOVE.L  (A0),D0
0x0B16: B0AD B1D8    CMP.L   -20008(A5),D0        ; vs threshold
0x0B1A: 6E00 0094    BGT.W   0x0BB0               ; skip if above threshold

; --- Q-without-U penalty check ---
0x0B1E: 3F3C 0071    MOVE.W  #$71,-(SP)           ; push 'q'
0x0B22: 486E FFF0    PEA     -16(A6)
0x0B26: 4EAD 0DBA    JSR     3514(A5)             ; search for 'q'
0x0B2A: 4A80         TST.L   D0
0x0B2C: 5C8F         ADDQ.L  #6,SP
0x0B2E: 6738         BEQ.S   0x0B68               ; 'q' not found → skip

; Q found: check for U companion
0x0B30: 2F2D 93BC    MOVE.L  -27716(A5),-(SP)
0x0B34: 486E FFF0    PEA     -16(A6)
0x0B38: 4EAD 0DB2    JSR     3506(A5)             ; strcmp (check for 'u')
0x0B3C: 4A40         TST.W   D0
0x0B3E: 508F         ADDQ.L  #8,SP
0x0B40: 6622         BNE.S   0x0B64               ; U found → skip penalty

; Q without U: compute penalty via division
0x0B42: 306D CF06    MOVEA.W -12538(A5),A0        ; unseen count
0x0B46: 2F08         MOVE.L  A0,-(SP)
0x0B48: 306D CF06    MOVEA.W -12538(A5),A0
0x0B4C: 202E FFE6    MOVE.L  -26(A6),D0           ; counter
0x0B50: 9088         SUB.L   A0,D0
0x0B52: 2F00         MOVE.L  D0,-(SP)
0x0B54: 4EAD 005A    JSR     90(A5)               ; JT[90]: divide
0x0B58: 3600         MOVE.W  D0,D3               ; D3 = penalty
0x0B5A: 0C43 FF9C    CMPI.W  #-100,D3
0x0B5E: 6F3A         BLE.S   0x0B9A               ; clamp to -100
0x0B60: 769C         MOVEQ   #-100,D3
0x0B62: 6036         BRA.S   0x0B9A

; ... (more Q handling paths) ...

; --- Call 0x18E8 helper, then blank_dispatcher ---
0x0BAA: 3F03         MOVE.W  D3,-(SP)
0x0BAC: 3F06         MOVE.W  D6,-(SP)
0x0BAE: 4EBA 0D34    JSR     0x18E4               ; pre-VCB helper
0x0BB2: 588F         ADDQ.L  #4,SP

; Push parameters for blank_dispatcher
0x0BB4: 3F04         MOVE.W  D4,-(SP)             ; total (draw count)
0x0BB6: 3F2E FFEA    MOVE.W  -22(A6),-(SP)        ; local_22
0x0BBA: 3F2E FFEC    MOVE.W  -20(A6),-(SP)        ; local_20
0x0BBE: 3F2E FFE0    MOVE.W  -32(A6),-(SP)        ; blank_count
0x0BC2: 3F2E FFDE    MOVE.W  -34(A6),-(SP)        ; consonant_count
0x0BC6: 3F2E FFDC    MOVE.W  -36(A6),-(SP)        ; vowel_count
0x0BCA: 4EBA 00F4    JSR     0x0CC0               ; blank_dispatcher

; Accumulate result
0x0BCE: D154         ADD.W   D0,(A4)              ; add to pattern score

; Advance to next ESTR pattern
0x0BD0: 306D CF06    MOVEA.W -12538(A5),A0
; ... update pattern pointers ...

; === LOOP TEST ===
0x0BEE: 4A46         TST.W   D6                   ; more patterns?
0x0BF0: 6600 FE2E    BNE.W   0x0A22               ; loop body
0x0BF4: 5346         SUBQ.W  #1,D6                ; D6--
0x0BF6: 6C00 FE28    BGE.W   0x0A22               ; continue if >= 0

; Epilogue
0x0BFA: 4CDF 1CF8    MOVEM.L (SP)+,D3-D7/A2-A4
0x0BFE: 4E5E         UNLK    A6
0x0C00: 4E75         RTS
```

### C Decompilation

```c
/* leave_orchestrator - Iterate ESTR patterns and compute V/C-parameterized leaves
 *
 * For each of 128 ESTR patterns:
 *   1. Classify letters as vowel/consonant/blank
 *   2. Compute cross-check scores from letter values
 *   3. Handle Q-without-U penalty
 *   4. Call blank_dispatcher with V/C/blank counts
 *   5. Accumulate into pattern scores
 */
void leave_orchestrator(void) {
    /* Stack frame: 40 bytes */
    short vowel_count;      /* -36(A6) */
    short consonant_count;  /* -34(A6) */
    short blank_count;      /* -32(A6) */
    long  local_30;         /* -30(A6): from string helper */
    long  local_26;         /* -26(A6): counter */
    short local_22;         /* -22(A6): tile distribution param */
    short local_20;         /* -20(A6): tile distribution param */
    short local_18;         /* -18(A6): tile distribution param */
    char  cross_check[16];  /* -16(A6): letter buffer */

    /* Initialize tile distribution from bag state */
    init_scoring_context(&local_26, &local_18, &local_20, &local_22);

    /* Setup string data */
    string_setup(&local_30, g_string_data);    /* JSR 0x16BC */

    /* Read and apply configuration adjustment */
    short config = (short)g_config_byte;    /* A5-12683 */
    local_26 -= config * some_factor;

    /* Iterate 128 ESTR patterns (D6 = 127 downto 0) */
    short *pattern_base = g_estr_patterns;      /* A5-17166 */
    short *record_base = g_estr_records;        /* A5-13064 */

    for (int pat = 127; pat >= 0; pat--) {
        /* Clear V/C/blank counters */
        vowel_count = consonant_count = blank_count = 0;

        /* Classify each letter in this pattern */
        char *pattern_str = &g_pattern_strings[pat];
        int letter_idx = 0;
        char *out = cross_check;

        for (char ch = *pattern_str; ch != 0; ch = *++pattern_str) {
            *out++ = ch;    /* copy to buffer */

            if (is_vowel(ch))           /* JT[2002] */
                vowel_count++;
            else if (ch == '?')         /* 0x3F = blank */
                blank_count++;
            else
                consonant_count++;

            letter_idx++;
        }
        *out = 0;  /* null-terminate */

        /* Compute number of tiles to draw */
        short pattern_len = strlen(cross_check);    /* JT[3522] */
        short draw_count = 7 - pattern_len;
        short unseen_avail = g_unseen_count - 7;
        draw_count = MIN(draw_count, unseen_avail);

        /* String/tile helper */
        short helper_result = tile_string_helper(&local_30, cross_check);
        if (helper_result == 0) continue;

        /* Threshold check */
        if (*(long*)local_30 > g_score_counter_prev) continue;

        /* Q-without-U penalty */
        if (strnchr(cross_check, 'q')) {
            if (!has_u_companion(cross_check)) {
                /* Compute Q penalty: (counter - unseen) / unseen */
                short penalty = (local_26 - g_unseen_count) / g_unseen_count;
                penalty = MAX(penalty, -100);   /* clamp */
                helper_result = penalty;
            }
        }

        /* Call pre-VCB helper */
        pre_vcb_helper(pat, helper_result);     /* JSR 0x18E4 */

        /* Compute V/C-weighted leave value */
        short vc_result = blank_dispatcher(
            vowel_count, consonant_count, blank_count,
            local_20, local_22, draw_count
        );

        /* Accumulate into pattern score */
        *pattern_base += vc_result;
    }
}
```

---

## Function 0x0BFC - Cached V/C Leave Calculator (Frame: 6 bytes)

### Annotated Disassembly

```asm
;======================================================================
; cached_vc_leave - Look up or compute V/C-parameterized leave value
; Frame: 6 bytes
; Parameters: 8(A6) = vowel, 10(A6) = consonant, 12(A6) = local_20,
;             14(A6) = local_22, 16(A6) = total
; Returns: D0 = relative V/C leave value
; Cache: 256 bytes at A5-2712, indexed [consonant*32 + vowel*4]
;======================================================================
0x0BFC: 4E56 FFFA    LINK    A6,#-6
0x0C00: 48E7 1F08    MOVEM.L D3-D7/A4,-(SP)
0x0C04: 3C2E 0008    MOVE.W  8(A6),D6             ; D6 = vowel
0x0C08: 3A2E 000A    MOVE.W  10(A6),D5            ; D5 = consonant
0x0C0C: 382E 000C    MOVE.W  12(A6),D4            ; D4 = local_20
0x0C10: 3E2E 000E    MOVE.W  14(A6),D7            ; D7 = local_22

; Bounds check
0x0C14: 4A6E 0010    TST.W   16(A6)               ; test total
0x0C18: 6C04         BGE.S   0x0C1E
0x0C1A: 4EAD 01A2    JSR     418(A5)              ; bounds_error

; Cap total at 7 - V - C
0x0C1E: 3006         MOVE.W  D6,D0                ; D0 = vowel
0x0C20: D045         ADD.W   D5,D0                ; D0 = V + C
0x0C22: D06E 0010    ADD.W   16(A6),D0            ; D0 = V + C + total
0x0C26: 5F40         SUBQ.W  #7,D0                ; D0 -= 7
0x0C28: 6F0A         BLE.S   0x0C34               ; skip if <= 7
0x0C2A: 7007         MOVEQ   #7,D0                ; cap at 7
0x0C2C: 9046         SUB.W   D6,D0                ; 7 - V
0x0C2E: 9045         SUB.W   D5,D0                ; 7 - V - C
0x0C30: 3D40 0010    MOVE.W  D0,16(A6)            ; total = 7 - V - C

; Early return if both V=0 and C=0
0x0C34: 4A45         TST.W   D5                   ; consonant?
0x0C36: 6608         BNE.S   0x0C40               ; non-zero → continue
0x0C38: 4A46         TST.W   D6                   ; vowel?
0x0C3A: 6604         BNE.S   0x0C40               ; non-zero → continue
0x0C3C: 7000         MOVEQ   #0,D0                ; return 0
0x0C3E: 6078         BRA.S   0x0CB8               ; → epilogue

; Compute cache index: consonant*32 + vowel*4
0x0C40: 3044         MOVEA.W D4,A0                ; A0 = local_20
0x0C42: B1ED F668    CMPA.L  -2456(A5),A0         ; cache key match?
0x0C46: 6608         BNE.S   0x0C50               ; miss
0x0C48: 3047         MOVEA.W D7,A0                ; A0 = local_22
0x0C4A: B1ED F66C    CMPA.L  -2452(A5),A0         ; second key match?
0x0C4E: 671A         BEQ.S   0x0C6A               ; hit → use cached

; Cache miss: clear cache and store new keys
0x0C50: 4878 0100    PEA     #256
0x0C54: 486D F568    PEA     -2712(A5)            ; g_vc_cache
0x0C58: 4EAD 01AA    JSR     426(A5)              ; memset(cache, 0, 256)
0x0C5C: 3044         MOVEA.W D4,A0
0x0C5E: 2B48 F668    MOVE.L  A0,-2456(A5)         ; store key1
0x0C62: 3247         MOVEA.W D7,A1
0x0C64: 2B49 F66C    MOVE.L  A1,-2452(A5)         ; store key2
0x0C68: 508F         ADDQ.L  #8,SP

; Compute cache offset
0x0C6A: 2005         MOVE.L  D5,D0                ; D0 = consonant
0x0C6C: 48C0         EXT.L   D0
0x0C6E: EB88         LSL.L   #5,D0                ; D0 = consonant * 32
0x0C70: 49ED F568    LEA     -2712(A5),A4         ; A4 = cache base
0x0C74: D08C         ADD.L   A4,D0
0x0C76: 2206         MOVE.L  D6,D1                ; D1 = vowel
0x0C78: 48C1         EXT.L   D1
0x0C7A: E589         LSL.L   #2,D1                ; D1 = vowel * 4
0x0C7C: D280         ADD.L   D0,D1
0x0C7E: 2841         MOVEA.L D1,A4                ; A4 = &cache[C*32 + V*4]

; Check if already computed (non-zero)
0x0C80: 4A94         TST.L   (A4)                 ; cached value?
0x0C82: 6632         BNE.S   0x0CB6               ; hit → return it

; Cache miss: call core_vc_calculator twice
; Call 1: actual(vowel, consonant, local_20, local_22, total)
0x0C84: 3605         MOVE.W  D5,D3                ; D3 = consonant
0x0C86: D646         ADD.W   D6,D3                ; D3 += vowel (for total param?)
0x0C88: D66E 0010    ADD.W   16(A6),D3            ; D3 += total
0x0C8C: 3F03         MOVE.W  D3,-(SP)             ; push adjusted total
0x0C8E: 3F07         MOVE.W  D7,-(SP)             ; push local_22
0x0C90: 3F04         MOVE.W  D4,-(SP)             ; push local_20
0x0C92: 3F05         MOVE.W  D5,-(SP)             ; push consonant
0x0C94: 3F06         MOVE.W  D6,-(SP)             ; push vowel
0x0C96: 4EBA 0114    JSR     0x0DAC               ; core_vc_calculator(V,C,...)
0x0C9A: 2D40 FFFA    MOVE.L  D0,-6(A6)            ; save result1

; Call 2: baseline(0, 0, local_20, local_22, total)
0x0C9E: 3E83         MOVE.W  D3,(SP)              ; overwrite top = total
0x0CA0: 3F07         MOVE.W  D7,-(SP)             ; push local_22
0x0CA2: 3F04         MOVE.W  D4,-(SP)             ; push local_20
0x0CA4: 42A7         CLR.L   -(SP)                ; push 0,0 (V=0, C=0)
0x0CA6: 4EBA 0104    JSR     0x0DAC               ; core_vc_calculator(0,0,...)

; Relative value = actual - baseline
0x0CAA: 222E FFFA    MOVE.L  -6(A6),D1            ; D1 = result1
0x0CAE: 9280         SUB.L   D0,D1                ; D1 = result1 - baseline
0x0CB0: 2881         MOVE.L  D1,(A4)              ; cache = relative value
0x0CB2: 4FEF 0012    LEA     18(SP),SP            ; clean 9 words

; Return cached value
0x0CB6: 2014         MOVE.L  (A4),D0              ; D0 = cached value

; Epilogue
0x0CB8: 4CDF 10F8    MOVEM.L (SP)+,D3-D7/A4
0x0CBC: 4E5E         UNLK    A6
0x0CBE: 4E75         RTS
```

### C Decompilation

```c
/* Cache at A5-2712: 256 bytes, indexed by [consonant*32 + vowel*4] */
long g_vc_cache[64];            /* A5-2712 */
long g_vc_cache_key1;           /* A5-2456 */
long g_vc_cache_key2;           /* A5-2452 */

long cached_vc_leave(short vowel, short consonant,
                     short local_20, short local_22, short total) {
    if (total < 0)
        bounds_error();

    /* Cap total so V + C + total <= 7 */
    if (vowel + consonant + total > 7)
        total = 7 - vowel - consonant;

    /* Both zero: return 0 (this is the baseline case) */
    if (consonant == 0 && vowel == 0)
        return 0;

    /* Invalidate cache if distribution params changed */
    if (local_20 != g_vc_cache_key1 || local_22 != g_vc_cache_key2) {
        memset(g_vc_cache, 0, 256);
        g_vc_cache_key1 = local_20;
        g_vc_cache_key2 = local_22;
    }

    /* Cache lookup */
    long *entry = &g_vc_cache[(consonant * 32 + vowel * 4) / 4];
    if (*entry != 0)
        return *entry;

    /* Cache miss: compute relative value */
    short tile_total = vowel + consonant + total;
    long actual  = core_vc_calculator(vowel, consonant, local_20, local_22, tile_total);
    long baseline = core_vc_calculator(0, 0, local_20, local_22, tile_total);
    *entry = actual - baseline;
    return *entry;
}
```

---

## Function 0x0CC0 - Blank-Assignment Dispatcher (Frame: 4 bytes)

### Annotated Disassembly

```asm
;======================================================================
; blank_dispatcher - Try all V/C assignments for blank tiles
; Frame: 4 bytes
; Parameters: 8(A6) = vowel, 10(A6) = consonant, 12(A6) = blank_count,
;             14(A6) = local_20, 16(A6) = local_22, 18(A6) = total
; Returns: D0 = best (2 blanks) or average (1 blank) leave value
;======================================================================
0x0CC0: 4E56 FFFC    LINK    A6,#-4
0x0CC4: 48E7 1F00    MOVEM.L D3-D7,-(SP)
0x0CC8: 3C2E 0008    MOVE.W  8(A6),D6             ; D6 = vowel
0x0CCC: 382E 000E    MOVE.W  14(A6),D4            ; D4 = local_20
0x0CD0: 3A2E 0010    MOVE.W  16(A6),D5            ; D5 = local_22

; Check blank count
0x0CD4: 0C6E 0002 000C  CMPI.W #2,12(A6)          ; blank_count == 2?
0x0CDA: 6662         BNE.S   0x0D3E

;=== 2 BLANKS: try 3 combinations, take best ===
; Combo 1: both blanks as consonants
0x0CDC: 3F2E 0012    MOVE.W  18(A6),-(SP)         ; push total
0x0CE0: 3F05         MOVE.W  D5,-(SP)             ; push local_22
0x0CE2: 3F04         MOVE.W  D4,-(SP)             ; push local_20
0x0CE4: 7002         MOVEQ   #2,D0
0x0CE6: D06E 000A    ADD.W   10(A6),D0            ; D0 = consonant + 2
0x0CEA: 3F00         MOVE.W  D0,-(SP)             ; push consonant+2
0x0CEC: 3F06         MOVE.W  D6,-(SP)             ; push vowel
0x0CEE: 4EBA FF0C    JSR     0x0BFC               ; cached_vc_leave(V, C+2, ...)
0x0CF2: 2E00         MOVE.L  D0,D7                ; D7 = result1

; Combo 2: one blank each
; ... (push vowel+1, consonant+1) ...
0x0D00: 4EBA FEF0    JSR     0x0BFC               ; cached_vc_leave(V+1, C+1, ...)
0x0D04: 2600         MOVE.L  D0,D3                ; D3 = result2

; Take max of result1 and result2
0x0D06: BE83         CMP.L   D3,D7
0x0D08: 4FEF 0012    LEA     18(SP),SP
0x0D0C: 6C02         BGE.S   0x0D10
0x0D0E: 2E03         MOVE.L  D3,D7                ; D7 = max(r1, r2)

; Combo 3: both blanks as vowels
; ... (push vowel+2, consonant) ...
0x0D24: 4EBA FECE    JSR     0x0BFC               ; cached_vc_leave(V+2, C, ...)
0x0D28: 2600         MOVE.L  D0,D3                ; D3 = result3

; Take max of current best and result3
0x0D2A: BE83         CMP.L   D3,D7
0x0D2C: 4FEF 000A    LEA     10(SP),SP
0x0D30: 6C68         BGE.S   0x0D9A
0x0D32: 2E03         MOVE.L  D3,D7                ; D7 = max(max(r1,r2), r3)
0x0D34: 6064         BRA.S   0x0D9A               ; → return D7

;=== 1 BLANK: try 2 combinations, average ===
0x0D3E: 0C6E 0001 000C  CMPI.W #1,12(A6)          ; blank_count == 1?
0x0D44: 6644         BNE.S   0x0D8A

; Combo 1: blank as consonant
; ... (push vowel, consonant+1) ...
0x0D54: 4EBA FEA2    JSR     0x0BFC               ; cached_vc_leave(V, C+1, ...)
0x0D58: 2E00         MOVE.L  D0,D7                ; D7 = result1

; Combo 2: blank as vowel
; ... (push vowel+1, consonant) ...
0x0D6C: 4EBA FE8A    JSR     0x0BFC               ; cached_vc_leave(V+1, C, ...)
0x0D70: 2600         MOVE.L  D0,D3                ; D3 = result2

; Average: (result1 + result2) / 2
; Not shown: D7 = (D7 + D3) >> 1

;=== 0 BLANKS: direct call ===
0x0D8A: 3F2E 0012    MOVE.W  18(A6),-(SP)
0x0D8E: 3F05         MOVE.W  D5,-(SP)
0x0D90: 3F04         MOVE.W  D4,-(SP)
0x0D92: 3F2E 000A    MOVE.W  10(A6),-(SP)         ; consonant
0x0D96: 3F06         MOVE.W  D6,-(SP)             ; vowel
0x0D98: 4EBA FE62    JSR     0x0BFC               ; direct call

; Return
0x0D9A: 2007         MOVE.L  D7,D0                ; D0 = result
; ... (clean stack, epilogue) ...
0x0DA4: 4CDF 00F8    MOVEM.L (SP)+,D3-D7
0x0DA8: 4E5E         UNLK    A6
0x0DAA: 4E75         RTS
```

### C Decompilation

```c
long blank_dispatcher(short vowel, short consonant, short blank_count,
                      short local_20, short local_22, short total) {
    if (blank_count == 2) {
        /* Try all 3 blank-to-V/C assignments, return best */
        long r1 = cached_vc_leave(vowel,   consonant+2, local_20, local_22, total);
        long r2 = cached_vc_leave(vowel+1, consonant+1, local_20, local_22, total);
        long best = (r1 >= r2) ? r1 : r2;
        long r3 = cached_vc_leave(vowel+2, consonant,   local_20, local_22, total);
        return (best >= r3) ? best : r3;
    }
    if (blank_count == 1) {
        /* Average of 2 assignments */
        long r1 = cached_vc_leave(vowel,   consonant+1, local_20, local_22, total);
        long r2 = cached_vc_leave(vowel+1, consonant,   local_20, local_22, total);
        return (r1 + r2) / 2;
    }
    /* No blanks */
    return cached_vc_leave(vowel, consonant, local_20, local_22, total);
}
```

---

## Function 0x0DAC - Core V/C Calculator (Frame: 272 bytes)

### Annotated Disassembly

```asm
;======================================================================
; core_vc_calculator - Compute V/C-parameterized leave value
; Frame: 272 bytes (256-byte local array + 16 bytes locals)
; Parameters: 8(A6) = vowel, 10(A6) = consonant, 12(A6) = local_20,
;             14(A6) = local_22, 16(A6) = total_tiles
; Returns: D0 = leave value (read from local array)
;
; The 256-byte array at -256(A6) is organized as 8 rows × 32 bytes.
; Each row corresponds to a possible tile count (0-7).
;======================================================================
0x0DAC: 4E56 FEF0    LINK    A6,#-272
0x0DB0: 48E7 1F38    MOVEM.L D3-D7/A2-A4,-(SP)
0x0DB4: 3C2E 0010    MOVE.W  16(A6),D6            ; D6 = total_tiles
0x0DB8: 7E00         MOVEQ   #0,D7                ; D7 = 0

; Compute MUL handle pointer
0x0DBA: 2006         MOVE.L  D6,D0
0x0DBC: 48C0         EXT.L   D0
0x0DBE: E588         LSL.L   #2,D0                ; D0 = total * 4
0x0DC0: 49ED D56C    LEA     -10900(A5),A4        ; A4 = MUL handles base
0x0DC4: D08C         ADD.L   A4,D0
0x0DC6: 2840         MOVEA.L D0,A4                ; A4 = &MUL_handles[total]

; Initialize A3 = record offset, A2 = local array
0x0DC8: 4878 001C    PEA     #28
0x0DCC: 2F07         MOVE.L  D7,-(SP)             ; 0
0x0DCE: 4EAD 0042    JSR     66(A5)               ; 0 * 28 = 0
0x0DD2: 2640         MOVEA.L D0,A3                ; A3 = 0 (MUL offset)
0x0DD4: 2007         MOVE.L  D7,D0
0x0DD6: EB88         LSL.L   #5,D0                ; D0 = 0 * 32
0x0DD8: 45EE FF00    LEA     -256(A6),A2          ; A2 = local_256 base
0x0DDC: D08A         ADD.L   A2,D0
0x0DDE: 2440         MOVEA.L D0,A2                ; A2 = &local_256[0*32]

; === PHASE 1: Copy MUL adj values into local array (reversed) ===
0x0DE0: 601A         BRA.S   0x0DFC               ; → loop test
; Loop body:
0x0DE2: 2014         MOVE.L  (A4),D0              ; D0 = MUL handle (deref)
0x0DE4: 3046         MOVEA.W D6,A0                ; A0 = total
0x0DE6: 91C7         SUBA.L  D7,A0                ; A0 = total - D7
0x0DE8: 2208         MOVE.L  A0,D1                ; D1 = total - D7
0x0DEA: E589         LSL.L   #2,D1                ; D1 *= 4 (long index)
0x0DEC: 25B3 0818 1800  MOVE.L (24,A3,D0.L),(0,A2,D1.L)
;   Reads: MUL_data[D7*28 + 24] (leave adj for record D7)
;   Writes: local_256[(total-D7)*4]
;   Extension words: 0818 = D0.L+24, 1800 = D1.L+0
0x0DF2: 5287         ADDQ.L  #1,D7                ; D7++
0x0DF4: 47EB 001C    LEA     28(A3),A3            ; A3 += 28 (next record)
0x0DF8: 45EA 0020    LEA     32(A2),A2            ; A2 += 32 (next row)
; Loop test:
0x0DFC: 3046         MOVEA.W D6,A0                ; A0 = total
0x0DFE: B1C7         CMPA.L  D7,A0                ; total vs D7
0x0E00: 6CE0         BGE.S   0x0DE2               ; while D7 <= total

; === PHASE 2: Setup outer loop ===
0x0E02: 2E06         MOVE.L  D6,D7                ; D7 = total
0x0E04: 5347         SUBQ.W  #1,D7                ; D7 = total - 1
0x0E06: 48C7         EXT.L   D7
0x0E08: 3C2E 000A    MOVE.W  10(A6),D6            ; D6 = consonant
0x0E0C: DC6E 0008    ADD.W   8(A6),D6             ; D6 = V + C = leave_size
0x0E10: 6000 00BA    BRA.W   0x0ECC               ; → outer loop test

; === OUTER LOOP: D7 from (total-1) downto leave_size ===
0x0E14: 362E 000A    MOVE.W  10(A6),D3            ; D3 = consonant (inner start)
0x0E18: 48C3         EXT.L   D3
0x0E1A: 306E 0008    MOVEA.W 8(A6),A0             ; A0 = vowel
0x0E1E: 2007         MOVE.L  D7,D0
0x0E20: 9088         SUB.L   A0,D0                ; D0 = D7 - vowel
0x0E22: 2D40 FEFC    MOVE.L  D0,-260(A6)          ; local_260 = D7 - vowel
0x0E26: 306E 000C    MOVEA.W 12(A6),A0            ; A0 = local_20
0x0E2A: 91C7         SUBA.L  D7,A0                ; A0 = local_20 - D7
0x0E2C: 2D48 FEF8    MOVE.L  A0,-264(A6)          ; local_264 = local_20 - D7
0x0E30: 2203         MOVE.L  D3,D1
0x0E32: EB89         LSL.L   #5,D1                ; D1 = consonant * 32
0x0E34: 49EE FF00    LEA     -256(A6),A4          ; A4 = local_256 base
0x0E38: D28C         ADD.L   A4,D1
0x0E3A: 2841         MOVEA.L D1,A4                ; A4 = &local_256[consonant*32]
0x0E3C: 6000 0084    BRA.W   0x0EC2               ; → inner loop test

; === INNER LOOP: D3 from consonant upward while D3 <= D7-vowel ===
0x0E40: 306E 000E    MOVE.W  14(A6),D0            ; D0 = local_22
; ... (complex arithmetic with clamping, multiplications via JT[66],
;      divisions via JT[90], storing results into local_256 array) ...

; Inner loop increment:
0x0EBC: 5283         ADDQ.L  #1,D3                ; D3++
0x0EBE: 49EC 0020    LEA     32(A4),A4            ; A4 += 32 (next row)
; Inner test:
0x0EC2: B6AE FEFC    CMP.L   -260(A6),D3          ; D3 vs (D7-vowel)
0x0EC6: 6F00 FF78    BLE.W   0x0E40               ; while D3 <= limit

; Outer loop decrement:
0x0ECA: 5387         SUBQ.L  #1,D7                ; D7--
; Outer test:
0x0ECC: 3046         MOVEA.W D6,A0                ; A0 = leave_size
0x0ECE: B1C7         CMPA.L  D7,A0
0x0ED0: 6F00 FF42    BLE.W   0x0E14               ; while D7 >= leave_size

; === RETURN: Read result from local array ===
0x0ED4: 302E 000A    MOVE.W  10(A6),D0            ; D0 = consonant
0x0ED8: 48C0         EXT.L   D0
0x0EDA: EB88         LSL.L   #5,D0                ; D0 = consonant * 32
0x0EDC: D08E         ADD.L   A6,D0
0x0EDE: 2040         MOVEA.L D0,A0                ; A0 = A6 + consonant*32
0x0EE0: 302E 0008    MOVE.W  8(A6),D0             ; D0 = vowel
0x0EE4: 48C0         EXT.L   D0
0x0EE6: E588         LSL.L   #2,D0                ; D0 = vowel * 4
0x0EE8: D1C0         ADDA.L  D0,A0
0x0EEA: 2028 FF00    MOVE.L  -256(A0),D0          ; D0 = local_256[C*32 + V*4]

; Epilogue
0x0EEE: 4CDF 1CF8    MOVEM.L (SP)+,D3-D7/A2-A4
0x0EF2: 4E5E         UNLK    A6
0x0EF4: 4E75         RTS
```

### C Decompilation

```c
/* core_vc_calculator - Compute leave value parameterized by V/C balance
 *
 * Uses a 256-byte local array (8×32) to compute the expected leave value
 * considering all possible ways to draw tiles into a rack with the given
 * vowel/consonant composition.
 *
 * The nested loop marginalizes over tile draws:
 *   - Outer loop: total remaining tiles from (total-1) down to leave_size
 *   - Inner loop: consonant count from initial up to (D7 - vowel)
 *   - Each iteration combines MUL leave adjustments weighted by draw probability
 */
long core_vc_calculator(short vowel, short consonant,
                        short local_20, short local_22,
                        short total_tiles) {
    /* 256-byte local array: 8 rows × 32 bytes (8 longs per row) */
    long local_256[8][8];       /* -256(A6) */
    long local_260;             /* -260(A6): D7 - vowel (inner limit) */
    long local_264;             /* -264(A6): local_20 - D7 */
    long local_fef0;            /* -272(A6): working value */

    /* Phase 1: Copy MUL adj values into local array in REVERSE order */
    void *mul_handle = g_mul_handles_alt[total_tiles];
    char *mul_data = *(char **)mul_handle;

    for (int i = 0; i <= total_tiles; i++) {
        long adj = *(long *)(mul_data + i * 28 + 24);  /* MUL record i, offset 24 */
        local_256[i][(total_tiles - i)] = adj;          /* reversed position */
    }

    /* Phase 2: Nested loop over tile draws */
    short leave_size = vowel + consonant;

    for (long d7 = total_tiles - 1; d7 >= leave_size; d7--) {
        long vc_limit = d7 - vowel;    /* max consonant count */
        long draw_offset = local_20 - d7;

        for (long d3 = consonant; d3 <= vc_limit; d3++) {
            /* Compute clamped draw parameters */
            long d4 = local_22 - d3 + consonant;  /* approximate */
            if (d4 < 0) d4 = 0;

            long d5 = d3 + draw_offset;
            d5 += vowel;   /* adjusted for vowel count */
            if (d5 < 0) d5 = 0;

            /* Combine values via multiply and divide */
            long index1 = d7 - d3;
            long product1 = local_256[d3 + 1][index1];  /* from row d3+1 */
            product1 *= (d4 + d5);                       /* JT[66] */

            long product2 = local_256[index1][d5];       /* from row index1 */
            product2 *= d5;                              /* JT[66] */

            long combined = product1 * product2;         /* MULS.W */
            combined += product1;
            combined = combined / divisor;               /* JT[90] */

            /* Store into local array */
            local_256[d3][index1] = combined;
        }
    }

    /* Return result for the requested V/C balance */
    return local_256[consonant][vowel];
}
```

**Note**: The inner loop computation is only partially decoded. The exact arithmetic
(which values multiply, which divide) needs further verification via QEMU tracing.
The overall structure — nested loops writing into the local_256 array, final read at
`[consonant][vowel]` — is verified.

---

## Function 0x1406 - Binomial-Weighted Leave Calculation (Frame: 50 bytes)

### Annotated Disassembly

```asm
;======================================================================
; binomial_leave - Per-tile leave value using hypergeometric weighting
; Frame: 50 bytes
; Parameters: 8(A6) = tile_letter (ASCII), 10(A6) = tile_count,
;             12(A6) = unseen_count
; Returns: D0 = leave adjustment in centipoints
; Uses: SANE 80-bit extended precision via A9EB trap
;       Pascal's triangle table at A5-2448 (8080 bytes, allocated)
;       MUL resource handles at A5-10868
;======================================================================
0x1406: 4E56 FFCE    LINK    A6,#-50
0x140A: 48E7 1F38    MOVEM.L D3-D7/A2-A4,-(SP)

; D6 = tile_count
0x140E: 3C2E 000A    MOVE.W  10(A6),D6
; Early exit if tile_count < 7
0x1412: 0C46 0007    CMPI.W  #7,D6
0x1416: 6C06         BGE.S   0x141E
0x1418: 7000         MOVEQ   #0,D0                ; return 0
0x141A: 6000 0228    BRA.W   0x1644               ; → epilogue

; Convert letter to index
0x141E: 302E 0008    MOVE.W  8(A6),D0
0x1422: 0C40 003F    CMPI.W  #$3F,D0              ; blank?
0x1426: 6604         BNE.S   0x142C
0x1428: 7A00         MOVEQ   #0,D5                ; blank = index 0
0x142A: 6006         BRA.S   0x1432
0x142C: 5140         SUBQ.W  #0,D0                ; (nop or subtract)
0x142E: 9040         SUB.W   D0,D0                ; ??? - likely: letter - 96
; Actually: D5 = tile_letter - 96 (a=1..z=26)

; === Allocate binomial table if needed ===
0x1432: 4AAD F670    TST.L   -2448(A5)            ; g_binom_table?
0x1436: 6600 00CE    BNE.W   0x1506               ; already allocated

; Allocate 8080 bytes
0x143A: 2F3C 0000 1F90  MOVE.L #8080,-(SP)        ; 0x1F90 = 8080
0x1440: 4EAD 0682    JSR     1666(A5)             ; NewPtr(8080)
0x1444: 2B40 F670    MOVE.L  D0,-2448(A5)         ; g_binom_table = ptr
0x1448: 588F         ADDQ.L  #4,SP
0x144A: 4AAD F670    TST.L   -2448(A5)            ; allocation ok?
0x144E: 6604         BNE.S   0x1454
0x1450: 4EAD 01A2    JSR     418(A5)              ; bounds_error

; Initialize slot 0 of all entries to 1.0, slots 1-7 to 0
; ... (init loops with SANE extended 1.0 = $3FFF $8000 0000 0000 0000) ...

; Build Pascal's triangle via FADDX recurrence
; entry[i][j] = entry[i-1][j] + entry[i-1][j-1]
; ... (nested loop with FADDX at 0x14DC) ...

; === Main weighted-average loop ===
; Setup accumulators
0x150E: 42AE FFEE    CLR.L   -18(A6)              ; clear local_30 (weight)
0x1512: 426E FFEC    CLR.W   -20(A6)
0x1516: 42AE FFE8    CLR.L   -24(A6)              ; (extended zeros)
0x151A: 42AE FFE4    CLR.L   -28(A6)

; Compute loop bounds
; D4 = max tile count index
; D3 = min(6, D6-7)
; ...

; Loop body:
; --- Weight = C(unseen, D4) × C(D6, D3-D4) ---
0x1584: 43F4 D800    LEA     (0,A4,D7.L),A1      ; binom[unseen][D4]
; Copy to local_46
; ...
0x1596: 43F3 D800    LEA     (0,A3,D0.L),A1      ; binom[D6][D3-D4]
; FMULX:
0x159A: 486E FFD2    PEA     -46(A6)              ; source
0x159E: 486E FFD2    PEA     -46(A6)              ; dest (self-multiply??)
; Actually: different local for source, same pattern
0x15A2: 3F3C 0004    MOVE.W  #$0004,-(SP)         ; FMULX
0x15A6: A9EB         _FP68K

; Accumulate weight:
; FADDX: local_30 += product
0x15B0: 486E FFE2    PEA     -30(A6)
0x15B4: 3F3C 0000    MOVE.W  #$0000,-(SP)         ; FADDX
0x15B8: A9EB         _FP68K

; --- Leave adjustment = MUL[D4+1].adj - MUL[0].adj ---
0x15BA: C1FC 001C    MULS.W  #28,D0               ; D0 = (D4+1) * 28
0x15BE: 2032 0818    MOVE.L  (24,A2,D0.L),D0      ; MUL[(D4+1)*28 + 24]
0x15C2: 90AE FFDC    SUB.L   -36(A6),D0           ; -= baseline

; FL2X: convert to extended
0x15E0: 486E FFCE    PEA     -50(A6)
0x15E4: 3F3C 2804    MOVE.W  #$2804,-(SP)         ; FL2X
0x15E8: A9EB         _FP68K

; FADDX: accumulate adj sum
0x15EC: 486E FFEC    PEA     -20(A6)
0x15F0: 3F3C 0000    MOVE.W  #$0000,-(SP)         ; FADDX
0x15F4: A9EB         _FP68K

; Loop increment: D4++, D7 += 10
; ... (continue loop) ...

; === Post-loop: normalize ===
; FDIVX: adj_sum / weight_sum
0x1608: 486E FFE2    PEA     -30(A6)              ; weight sum
0x160C: 486E FFEC    PEA     -20(A6)              ; adj sum (result dest)
0x1610: 3F3C 0006    MOVE.W  #$0006,-(SP)         ; FDIVX
0x1614: A9EB         _FP68K

; Convert to integer
; Copy, round ($0016), FX2L ($2810)
0x163A: 3F3C 2810    MOVE.W  #$2810,-(SP)         ; FX2L
0x163E: A9EB         _FP68K

; Read result and return
0x1640: 202E FFD8    MOVE.L  -40(A6),D0           ; D0 = integer centipoints

; Epilogue
0x1644: 4CDF 1CF8    MOVEM.L (SP)+,D3-D7/A2-A4
0x1648: 4E5E         UNLK    A6
0x164A: 4E75         RTS
```

### C Decompilation

```c
/* Binomial coefficient table: 101 entries × 8 SANE extended values */
extended *g_binom_table;    /* A5-2448: allocated on first call */

/* Per-tile binomial-weighted leave value
 *
 * Computes expected leave contribution for one tile type using
 * hypergeometric distribution weights (binomial coefficients).
 *
 * Formula: result = Σ(adj[i+1] - adj[0]) / Σ(C(n,i) × C(m,j-i))
 *
 * The denominator is a Vandermonde identity: Σ C(n,i)×C(m,j-i) = C(n+m,j)
 * Using SANE 80-bit extended avoids overflow for large C(100,k).
 */
long binomial_leave(short tile_letter, short tile_count, short unseen_count) {
    extended local_46;      /* -46(A6): working SANE value */
    long     baseline;      /* -36(A6): MUL record 0 adj */
    extended weight_sum;    /* -30(A6): Σ C(n,i)×C(m,j-i) */
    extended adj_sum;       /* -20(A6): Σ (adj[i+1] - adj[0]) */

    /* Early exit for small tile counts */
    if (tile_count < 7)
        return 0;

    /* Letter index: blank=0, a=1, ..., z=26 */
    short letter_idx;
    if (tile_letter == '?')
        letter_idx = 0;
    else
        letter_idx = tile_letter - 96;

    /* One-time: build Pascal's triangle table */
    if (g_binom_table == NULL) {
        g_binom_table = (extended *)NewPtr(8080);
        if (g_binom_table == NULL)
            bounds_error();

        /* Initialize C(n,0) = 1 for all n; C(0,k>0) = 0 */
        for (int n = 0; n < 101; n++) {
            g_binom_table[n * 8 + 0] = 1.0;
            for (int k = 1; k < 8; k++)
                g_binom_table[n * 8 + k] = 0.0;
        }

        /* Pascal's triangle: C(n,k) = C(n-1,k) + C(n-1,k-1) */
        for (int n = 1; n < 101; n++) {
            for (int k = 1; k < 8; k++) {
                g_binom_table[n * 8 + k] =
                    g_binom_table[(n-1) * 8 + k] +
                    g_binom_table[(n-1) * 8 + (k-1)];
            }
        }
    }

    /* Get MUL data for this letter */
    char *mul_data = *(char **)g_mul_handles[letter_idx];
    baseline = *(long *)(mul_data + 24);    /* Record 0, offset 24 */

    /* Accumulate weighted leave values */
    weight_sum = 0.0;
    adj_sum = 0.0;

    short max_k = MIN(6, tile_count - 7);
    extended *binom_unseen = &g_binom_table[unseen_count * 8];
    extended *binom_count  = &g_binom_table[tile_count * 8];

    for (short k = 0; k <= unseen_count && k <= max_k; k++) {
        /* Weight = C(unseen, k) × C(tile_count, max_k - k) */
        extended weight = binom_unseen[k] * binom_count[max_k - k];
        weight_sum += weight;

        /* Relative adjustment = record[k+1].adj - baseline */
        long adj = *(long *)(mul_data + (k + 1) * 28 + 24);
        adj -= baseline;

        adj_sum += (extended)adj;
    }

    /* Normalize: weighted average */
    adj_sum /= weight_sum;

    /* Convert to integer centipoints and return */
    return (long)adj_sum;
}
```

---

## Score Calculation Algorithm

```
1. INITIALIZATION
   - Clear position tracking globals
   - Count available letters from rack and opponent's rack
   - Set up 17×17 board array pointers

2. TILE SCORING
   For each tile in move word:
   - Look up letter value
   - Apply letter multipliers (DL=2×, TL=3×)
   - Apply word multipliers (DW=2×, TW=3×)
   - Score perpendicular cross-words
   - Increment tile count

3. BINGO BONUS
   If 7 tiles placed: +5000 centipoints (50 points)

4. LEAVE EVALUATION (ORCHESTRATOR)
   For each of 128 ESTR patterns:
   a. Classify letters as V/C/blank
   b. Compute cross-check score
   c. Handle Q-without-U penalty
   d. Call blank_dispatcher → cached_vc_leave → core_vc_calculator
   e. Accumulate V/C-adjusted leave values

5. PER-TILE LEAVE (BINOMIAL)
   For each tile type in leave:
   - Hypergeometric-weighted average of MUL adjustments
   - Uses SANE 80-bit precision for large binomial coefficients

6. FINAL SCORE
   raw_score - leave_adjustment → final move score in centipoints
```

---

## Function 0x1648 - Tile String Helper (Frame: 0 bytes)

### Annotated Disassembly (manually decoded from raw hex)

```asm
;======================================================================
; tile_string_helper - Look up EXPR value for pattern, add binomial
;   correction for single-letter patterns
; Frame: 0 bytes
; Parameters: 8(A6) = cross_check (pattern string, sorted lowercase)
;             12(A6) = &local_30 (output pointer, receives entry address)
; Returns: D0 = EXPR value (multi-letter) or EXPR+binomial correction (single)
;          Returns 0 if pattern not found in EXPR binary search table
;======================================================================
0x1648: 4E56 0000    LINK    A6,#0
0x164C: 48E7 0108    MOVEM.L D7/A4,-(SP)
0x1650: 286E 0008    MOVEA.L 8(A6),A4         ; A4 = cross_check string

; Call binary search for this pattern
0x1654: 2F2E 000C    MOVE.L  12(A6),-(SP)     ; push &local_30
0x1658: 2F0C         MOVE.L  A4,-(SP)         ; push cross_check
0x165A: 4EBA 0060    JSR     0x16BC           ; binary_search_expr(cross_check, &local_30)
0x165E: 3E00         MOVE.W  D0,D7            ; D7 = EXPR value (0 if not found)

; Get pattern length
0x1660: 2E8C         MOVE.L  A4,(SP)          ; reuse stack slot for strlen param
0x1662: 4EAD 0DC2    JSR     3522(A5)         ; JT[3522] = strlen(cross_check)
0x1666: 5380         SUBQ.L  #1,D0            ; D0 = strlen - 1
0x1668: 508F         ADDQ.L  #8,SP            ; clean stack (2 longs from 0x16BC call)
0x166A: 6646         BNE.S   0x16B2           ; if len > 1 → multi-letter, return D7

; === SINGLE-LETTER PATH ===
; For single-letter patterns, add binomial correction:
;   D7 += binomial_leave(letter, g_unseen_count, dist_count)
;   D7 -= binomial_leave(letter, 96, orig_count - 1)

; Look up current unseen count for this letter
0x166C: 1014         MOVE.B  (A4),D0          ; D0 = letter
0x166E: 4880         EXT.W   D0
0x1670: 204D         MOVEA.L A5,A0            ; A0 = A5
0x1672: D0C0         ADDA.W  D0,A0            ; A0 = A5 + letter
0x1674: 1028 CE04    MOVE.B  -12796(A0),D0    ; D0 = g_dist_table[letter] (current unseen per tile)
0x1678: 4880         EXT.W   D0

; Call 1: binomial_leave(letter, g_unseen_count, dist_count)
0x167A: 3F00         MOVE.W  D0,-(SP)         ; push dist_count
0x167C: 3F2D CF06    MOVE.W  -12538(A5),-(SP) ; push g_unseen_count (total unseen, ~93)
0x1680: 1014         MOVE.B  (A4),D0          ; letter again
0x1682: 4880         EXT.W   D0
0x1684: 3F00         MOVE.W  D0,-(SP)         ; push letter
0x1686: 4EBA FD7E    JSR     0x1406           ; binomial_leave(letter, unseen, dist_count)
0x168A: DE40         ADD.W   D0,D7            ; D7 += result

; Look up original bag count for this letter
0x168C: 1014         MOVE.B  (A4),D0          ; letter
0x168E: 4880         EXT.W   D0
0x1690: 204D         MOVEA.L A5,A0            ; A0 = A5
0x1692: D0C0         ADDA.W  D0,A0            ; A0 = A5 + letter
0x1694: 1028 9512    MOVE.B  -27374(A0),D0    ; D0 = g_orig_dist[letter] (original bag count)
0x1698: 4880         EXT.W   D0

; Call 2: binomial_leave(letter, 96, orig_count - 1)
0x169A: 5340         SUBQ.W  #1,D0            ; D0 = orig_count - 1
0x169C: 3E80         MOVE.W  D0,(SP)          ; overwrite letter slot with (orig_count-1)
0x169E: 3F3C 0060    MOVE.W  #96,-(SP)        ; push 96 (baseline unseen)
0x16A2: 1014         MOVE.B  (A4),D0          ; letter
0x16A4: 4880         EXT.W   D0
0x16A6: 3F00         MOVE.W  D0,-(SP)         ; push letter
0x16A8: 4EBA FD5C    JSR     0x1406           ; binomial_leave(letter, 96, orig_count-1)
0x16AC: 9E40         SUB.W   D0,D7            ; D7 -= baseline result
0x16AE: 4FEF 000A    LEA     10(SP),SP        ; clean stack (5 words = 10 bytes)

; === RETURN ===
0x16B2: 3007         MOVE.W  D7,D0            ; D0 = final value
0x16B4: 4CDF 1080    MOVEM.L (SP)+,D7/A4
0x16B8: 4E5E         UNLK    A6
0x16BA: 4E75         RTS
```

### C Decompilation

```c
/* tile_string_helper - Look up pattern in EXPR table with binomial correction
 *
 * For multi-letter patterns: returns EXPR value directly (0 if not found).
 * For single-letter patterns: returns EXPR value + binomial correction
 *   that adjusts for actual vs baseline tile distribution.
 *
 * The binomial correction is:
 *   + binomial_leave(letter, g_unseen_count, current_dist_count)
 *   - binomial_leave(letter, 96, original_bag_count - 1)
 *
 * With a full bag (start of game), g_unseen_count ≈ 93 and
 * current_dist ≈ original_bag, so the correction is small.
 * As tiles are played, the correction adjusts for changed distribution.
 *
 * Returns 0 for patterns not in EXPR table → orchestrator SKIPS them.
 */
short tile_string_helper(char *cross_check, long **out_entry_ptr) {
    short D7 = binary_search_expr(cross_check, out_entry_ptr);  /* 0x16BC */

    short len = strlen(cross_check);                  /* JT[3522] */
    if (len > 1) {
        /* Multi-letter pattern: return EXPR value directly */
        return D7;
    }

    /* Single-letter pattern: add binomial correction */
    char letter = cross_check[0];

    /* Current distribution count for this letter */
    short dist_count = g_dist_table[(unsigned char)letter];    /* A5-12796 */

    /* Correction for actual game state */
    D7 += binomial_leave(letter, g_unseen_count, dist_count);

    /* Subtract baseline expectation (full-bag reference: 96 tiles, count-1) */
    short orig_count = g_orig_dist[(unsigned char)letter];     /* A5-27374 */
    D7 -= binomial_leave(letter, 96, orig_count - 1);

    return D7;
}
```

---

## Function 0x16BC - EXPR Binary Search / Pattern Table Builder (Frame: 0 bytes)

### Annotated Disassembly (manually decoded from raw hex)

```asm
;======================================================================
; binary_search_expr - Build and search EXPR pattern table
; Frame: 0 bytes
; Parameters: 8(A6) = search string (or init data on first call)
;             12(A6) = output pointer (receives &entry.value_field)
; Returns: D0 = EXPR-derived leave value (word), or 0 if not found
;
; First call: builds sorted binary search table from ESTR entries:
;   - Phase 1: Count entries with non-zero word@4 and zero byte@6
;   - Allocate 10-byte buffer entries for each qualifying entry
;   - Phase 2: Populate entries (string ptr, value field, letter_id)
;   - Phase 3: Sort by string comparison (insertion sort)
;   - Phase 4: Final validation
; Subsequent calls: binary search the pre-built table
;
; ESTR 8-byte entry structure (at g_estr_entries, A5-10918):
;   offset 0-1: flags word
;   offset 2-3: string offset into g_estr_strings (A5-10912)
;   offset 4-5: status word (non-zero = has EXPR data)
;   offset 6:   flag byte (must be 0 for EXPR entries)
;   offset 7:   reserved
;
; 10-byte buffer entry (allocated, at g_expr_table, A5-2444):
;   offset 0-3: pointer to sorted pattern string
;   offset 4-7: value field (initially 0, written by orchestrator)
;   offset 8-9: letter_id (from ESTR entry word@4, for MUL indexing)
;======================================================================
0x16BC: 4E56 0000    LINK    A6,#0
0x16C0: 48E7 1F38    MOVEM.L D3-D7/A2-A4,-(SP)

; Check if already initialized
0x16C4: 4AAD F674    TST.L   -2444(A5)        ; g_expr_table ptr?
0x16C8: 6600 01A4    BNE.W   0x186E           ; → main search path

; === INITIALIZATION (first call only) ===

; Validate state
0x16CC: 4A6D F682    TST.W   -2430(A5)        ; g_expr_count must be 0
0x16D0: 6704         BEQ.S   0x16D6
0x16D2: 4EAD 01A2    JSR     418(A5)          ; bounds_error

; --- Phase 1: Count qualifying ESTR entries ---
0x16D6: 7C01         MOVEQ   #1,D6            ; D6 = 1 (start from entry 1)
0x16D8: 387C 0008    MOVEA.W #8,A4            ; A4 = 8 (byte offset, stride=8)
0x16DC: 601A         BRA.S   0x16F8           ; → loop test

; Phase 1 loop body
0x16DE: 264C         MOVEA.L A4,A3            ; A3 = current offset
0x16E0: D7ED D55A    ADDA.L  -10918(A5),A3    ; A3 = &estr_entries[current]
0x16E4: 4A6B 0004    TST.W   4(A3)            ; test entry.status_word
0x16E8: 670A         BEQ.S   0x16F4           ; if 0 → skip (no EXPR data)
0x16EA: 4A2B 0006    TST.B   6(A3)            ; test entry.flag_byte
0x16EE: 6604         BNE.S   0x16F4           ; if non-zero → skip
0x16F0: 526D F682    ADDQ.W  #1,-2430(A5)     ; g_expr_count++ (qualifying entry)

; Phase 1 increment
0x16F4: 5246         ADDQ.W  #1,D6            ; D6++ (entry counter)
0x16F6: 508C         ADDQ.L  #8,A4            ; A4 += 8 (next 8-byte entry)

; Phase 1 test
0x16F8: BC6D D55E    CMP.W   -10914(A5),D6    ; D6 < g_estr_entry_count?
0x16FC: 6DE0         BLT.S   0x16DE           ; loop

; --- Allocate buffer: 10 bytes per qualifying entry ---
0x16FE: 700A         MOVEQ   #10,D0
0x1700: C1ED F682    MULS.W  -2430(A5),D0     ; D0 = 10 * g_expr_count
0x1704: 2F00         MOVE.L  D0,-(SP)         ; push size
0x1706: 4EAD 0682    JSR     1666(A5)         ; JT[1666] = NewPtr
0x170A: 2B40 F674    MOVE.L  D0,-2444(A5)     ; g_expr_table = allocated ptr

; Save count, reset for Phase 2
0x170E: 3A2D F682    MOVE.W  -2430(A5),D5     ; D5 = total qualifying entries
0x1712: 48C5         EXT.L   D5
0x1714: 426D F682    CLR.W   -2430(A5)        ; reset counter = 0
0x1718: 7C01         MOVEQ   #1,D6            ; D6 = 1 (restart from entry 1)
0x171A: 387C 0008    MOVEA.W #8,A4            ; A4 = 8 (restart offset)
0x171E: 588F         ADDQ.L  #8,SP            ; clean stack from NewPtr call

; --- Phase 2: Populate buffer entries ---
0x1720: 6064         BRA.S   0x1786           ; → loop test

; Phase 2 loop body
0x1722: 264C         MOVEA.L A4,A3            ; A3 = current offset
0x1724: D7ED D55A    ADDA.L  -10918(A5),A3    ; A3 = &estr_entries[current]
0x1728: 4A6B 0004    TST.W   4(A3)            ; test entry.status_word
0x172C: 6754         BEQ.S   0x1782           ; if 0 → skip (not qualifying)
0x172E: 4A2B 0006    TST.B   6(A3)            ; test entry.flag_byte
0x1732: 664E         BNE.S   0x1782           ; if non-zero → skip

; Qualifying entry: compute string pointer
0x1734: 306B 0002    MOVEA.W 2(A3),A0         ; A0 = entry.string_offset
0x1738: 700A         MOVEQ   #10,D0
0x173A: C1ED F682    MULS.W  -2430(A5),D0     ; D0 = 10 * current_index
0x173E: D1ED D560    ADDA.L  -10912(A5),A0    ; A0 = g_estr_strings + offset = string ptr
0x1742: D0AD F674    ADD.L   -2444(A5),D0     ; D0 = g_expr_table + 10*index
0x1746: 2240         MOVEA.L D0,A1            ; A1 = &buffer_entry
0x1748: 2288         MOVE.L  A0,(A1)          ; buffer[0-3] = string pointer

; Validate string is sorted (each byte >= previous)
0x174A: 2448         MOVEA.L A0,A2            ; A2 = string ptr for validation
0x174C: 600C         BRA.S   0x175A           ; → validation loop test
0x174E: 1012         MOVE.B  (A2),D0          ; D0 = current byte
0x1750: B02A FFFF    CMP.B   -1(A2),D0        ; compare with previous byte
0x1754: 6C04         BGE.S   0x175A           ; ok if >= (sorted)
0x1756: 4EAD 01A2    JSR     418(A5)          ; bounds_error (not sorted!)
0x175A: 528A         ADDQ.L  #1,A2            ; A2++
0x175C: 4A12         TST.B   (A2)             ; null terminator?
0x175E: 66EE         BNE.S   0x174E           ; loop while not null

; Clear value field, copy letter_id
0x1760: 700A         MOVEQ   #10,D0
0x1762: C1ED F682    MULS.W  -2430(A5),D0     ; D0 = 10 * index
0x1766: D0AD F674    ADD.L   -2444(A5),D0     ; D0 = &buffer_entry
0x176A: 2E00         MOVE.L  D0,D7            ; save in D7
0x176C: 2047         MOVEA.L D7,A0
0x176E: 42A8 0004    CLR.L   4(A0)            ; buffer[4-7] = 0 (value field)
0x1772: 202D D55A    MOVE.L  -10918(A5),D0    ; D0 = estr_entries base
0x1776: 2047         MOVEA.L D7,A0
0x1778: 3174 0804 0008  MOVE.W (4,A4,D0.L),8(A0)  ; buffer[8-9] = estr_entry.word@4

; Increment
0x177E: 526D F682    ADDQ.W  #1,-2430(A5)     ; g_expr_count++

; Phase 2 increment/test
0x1782: 5246         ADDQ.W  #1,D6            ; D6++
0x1784: 508C         ADDQ.L  #8,A4            ; A4 += 8
0x1786: BC6D D55E    CMP.W   -10914(A5),D6    ; D6 < entry_count?
0x178A: 6D96         BLT.S   0x1722           ; loop

; ... Phase 3: Insertion sort by string comparison ...
; (sorts buffer entries by their string pointers using strcmp)
; ... Phase 4: Validation ...

; === MAIN SEARCH PATH (0x186E) ===
; Binary search the sorted table

0x186E: 7A00         MOVEQ   #0,D5            ; D5 = 0 (low bound)
0x1870: 7CFF         MOVEQ   #-1,D6           ; D6 = count - 1 (high bound)
0x1872: DC6D F682    ADD.W   -2430(A5),D6     ; D6 = g_expr_count - 1
0x1876: 206E 000C    MOVEA.L 12(A6),A0        ; A0 = output pointer
0x187A: 4290         CLR.L   (A0)             ; *output = NULL (default)
0x187C: 6054         BRA.S   0x18D2           ; → loop test

; --- Binary search loop body ---
0x187E: 3806         MOVE.W  D6,D4            ; D4 = high
0x1880: D845         ADD.W   D5,D4            ; D4 = low + high
0x1882: E244         ASR.W   #1,D4            ; D4 = (low + high) / 2 = mid

; Compute buffer entry address
0x1884: 700A         MOVEQ   #10,D0
0x1886: C1C4         MULS.W  D4,D0            ; D0 = mid * 10
0x1888: D0AD F674    ADD.L   -2444(A5),D0     ; D0 = &buffer[mid]
0x188C: 2040         MOVEA.L D0,A0

; Compare search string with entry's string
0x188E: 2F10         MOVE.L  (A0),-(SP)       ; push buffer[mid].string_ptr
0x1890: 2F2E 0008    MOVE.L  8(A6),-(SP)      ; push search_string
0x1894: 4EAD 0DB2    JSR     3506(A5)         ; JT[3506] = strcmp
0x1898: 3600         MOVE.W  D0,D3            ; D3 = strcmp result
0x189A: 4A43         TST.W   D3
0x189C: 508F         ADDQ.L  #8,SP            ; clean stack
0x189E: 6624         BNE.S   0x18C4           ; not equal → adjust bounds

; --- MATCH FOUND ---
; Store pointer to value field in output
0x18A0: 700A         MOVEQ   #10,D0
0x18A2: C1C4         MULS.W  D4,D0            ; D0 = mid * 10
0x18A4: D0AD F674    ADD.L   -2444(A5),D0     ; D0 = &buffer[mid]
0x18A8: 2840         MOVEA.L D0,A4            ; A4 = &buffer[mid]
0x18AA: 41EC 0004    LEA     4(A4),A0         ; A0 = &buffer[mid].value_field
0x18AE: 226E 000C    MOVEA.L 12(A6),A1        ; A1 = output pointer
0x18B2: 2288         MOVE.L  A0,(A1)          ; *output = &buffer[mid].value_field

; Read EXPR-derived value: MUL_data[letter_id * 28 + 26]
0x18B4: 701C         MOVEQ   #28,D0           ; 28 bytes per MUL record
0x18B6: C1EC 0008    MULS.W  8(A4),D0         ; D0 = 28 * buffer[mid].letter_id
0x18BA: 206D D564    MOVEA.L -10908(A5),A0    ; A0 = g_mul_data_ptr
0x18BE: 3030 081A    MOVE.W  (26,A0,D0.L),D0  ; D0 = MUL_data[letter_id*28 + 26]
0x18C2: 6014         BRA.S   0x18D8           ; → return (skip not-found path)

; --- NOT MATCHED: adjust search bounds ---
0x18C4: 4A43         TST.W   D3               ; strcmp result sign
0x18C6: 6C06         BGE.S   0x18CE           ; if search >= entry → go right
0x18C8: 7CFF         MOVEQ   #-1,D6           ; D6 = -1
0x18CA: DC44         ADD.W   D4,D6            ; D6 = mid - 1 (narrow left)
0x18CC: 6004         BRA.S   0x18D2           ; → loop test
0x18CE: 7A01         MOVEQ   #1,D5            ; D5 = 1
0x18D0: DA44         ADD.W   D4,D5            ; D5 = mid + 1 (narrow right)

; --- Loop test ---
0x18D2: BA46         CMP.W   D6,D5            ; low vs high
0x18D4: 6FA8         BLE.S   0x187E           ; if low <= high, continue search

; --- NOT FOUND ---
0x18D6: 7000         MOVEQ   #0,D0            ; return 0

; --- Epilogue ---
0x18D8: 4CDF 1CF8    MOVEM.L (SP)+,D3-D7/A2-A4
0x18DC: 4E5E         UNLK    A6
0x18DE: 4E75         RTS
```

### C Decompilation

```c
/* Globals for EXPR pattern table */
long  *g_estr_entries;          /* A5-10918: 8-byte ESTR entry array */
short  g_estr_entry_count;      /* A5-10914: number of ESTR entries */
long  *g_estr_strings;          /* A5-10912: ESTR string data base */
long  *g_mul_data_ptr;          /* A5-10908: pointer to MUL leave data */
char  *g_expr_table;            /* A5-2444: allocated 10-byte entry table */
short  g_expr_count;            /* A5-2430: number of entries in expr_table */

/* 8-byte ESTR entry structure (loaded from resource) */
typedef struct {
    short flags;                /* +0: flags word */
    short string_offset;        /* +2: offset into g_estr_strings */
    short status_word;          /* +4: non-zero = has EXPR data */
    char  flag_byte;            /* +6: must be 0 for EXPR entries */
    char  reserved;             /* +7 */
} ESTREntry;                    /* 8 bytes */

/* 10-byte buffer entry (built by binary_search_expr) */
typedef struct {
    char *string_ptr;           /* +0: pointer to sorted pattern string */
    long  value_field;          /* +4: working value (initially 0) */
    short letter_id;            /* +8: MUL letter index (from ESTR status_word) */
} ExprEntry;                    /* 10 bytes */

/* binary_search_expr - Build and search EXPR pattern table
 *
 * On first call: scans ESTR entries, builds sorted binary search table
 * of patterns that have EXPR data (status_word != 0 && flag_byte == 0).
 * Table entries are 10 bytes: {string_ptr, value_field, letter_id}.
 *
 * On match: returns word at MUL_data[letter_id * 28 + 26], which is
 * the low word of the MUL record[0] leave adjustment for that letter.
 * Also stores &entry.value_field into *out_ptr for orchestrator use.
 *
 * On miss: returns 0.
 */
short binary_search_expr(char *search_string, long **out_ptr) {
    /* One-time initialization */
    if (g_expr_table == NULL) {
        if (g_expr_count != 0)
            bounds_error();

        /* Phase 1: Count qualifying ESTR entries */
        ESTREntry *entries = (ESTREntry *)g_estr_entries;
        for (int i = 1; i < g_estr_entry_count; i++) {
            if (entries[i].status_word != 0 && entries[i].flag_byte == 0)
                g_expr_count++;
        }

        /* Allocate 10-byte buffer entries */
        g_expr_table = (char *)NewPtr(10 * g_expr_count);

        short total = g_expr_count;
        g_expr_count = 0;  /* reset for Phase 2 */

        /* Phase 2: Populate buffer entries */
        for (int i = 1; i < g_estr_entry_count; i++) {
            if (entries[i].status_word == 0 || entries[i].flag_byte != 0)
                continue;

            ExprEntry *buf = (ExprEntry *)(g_expr_table + 10 * g_expr_count);

            /* Compute string pointer from offset */
            char *str = (char *)g_estr_strings + entries[i].string_offset;
            buf->string_ptr = str;

            /* Validate string is sorted (each char >= previous) */
            for (char *p = str + 1; *p; p++) {
                if (*p < *(p - 1))
                    bounds_error();  /* pattern not sorted! */
            }

            /* Clear value field, copy letter_id */
            buf->value_field = 0;
            buf->letter_id = entries[i].status_word;

            g_expr_count++;
        }

        /* Phase 3: Insertion sort by string comparison */
        /* (sorts buffer entries so binary search works) */
        /* ... omitted: standard insertion sort using strcmp ... */

        /* Phase 4: Validation */
        /* ... omitted: verify sort order and consistency ... */
    }

    /* === Binary search === */
    short low = 0;
    short high = g_expr_count - 1;
    *out_ptr = NULL;

    while (low <= high) {
        short mid = (low + high) / 2;
        ExprEntry *entry = (ExprEntry *)(g_expr_table + 10 * mid);

        int cmp = strcmp(search_string, entry->string_ptr);  /* JT[3506] */

        if (cmp == 0) {
            /* Found: store value_field pointer for orchestrator */
            *out_ptr = &entry->value_field;

            /* Return EXPR-derived value from MUL data */
            /* MUL records are 28 bytes; offset 26 = low word of adj at offset 24 */
            short *mul = (short *)g_mul_data_ptr;
            return mul[entry->letter_id * 14 + 13];  /* 28*id+26 as word index */
        }

        if (cmp < 0)
            high = mid - 1;     /* search string < entry → go left */
        else
            low = mid + 1;      /* search string > entry → go right */
    }

    return 0;  /* not found */
}
```

### EXPR Resource Structure

The EXPR resource is 96 bytes. When accessed as 28-byte records with the leave
adjustment at offset 24 (same layout as MUL records), it yields:

| Record | Offset 24 (int32) | Value |
|--------|-------------------|-------|
| 0 | -878 cp | -8.78 pts |
| 1 | +2791 cp | +27.91 pts |
| 2 | +875 cp | +8.75 pts |
| 3 | (partial, 12 bytes only) | — |

The mapping from ESTR patterns to EXPR record indices depends on the runtime
ESTR 8-byte entry structure (status_word field), which is loaded by CODE 15
and cannot be determined from static analysis alone. QEMU tracing is needed
to observe which patterns map to which records.

The +2791 cp value is consistent with QU synergy (expert Scrabble value for
the Q-U combination benefit is typically 15-30 points = 1500-3000 cp).

---

## Function 0x18E4 - Pre-VCB Helper / Pattern Tree Propagator (Frame: 0 bytes)

### Annotated Disassembly (manually decoded from raw hex)

```asm
;======================================================================
; pre_vcb_helper - Store tile_string_helper result and propagate through
;   pattern tree via recursive calls
; Frame: 0 bytes
; Parameters: 8(A6) = pattern_index, 10(A6) = value (D3 from orchestrator)
; Uses: g_score_counter at A5-20004 for visited-check
;       g_work_buffer at A5-17420 for per-pattern accumulator
;       Child pattern table at A5-26154 (7 entries × 4 bytes per pattern)
;======================================================================
0x18E4: 4E56 0000    LINK    A6,#0
0x18E8: 48E7 0308    MOVEM.L D6-D7/A4,-(SP)
0x18EC: 3E2E 0008    MOVE.W  8(A6),D7         ; D7 = pattern_index

; Compute address in visited-check table
0x18F0: 2007         MOVE.L  D7,D0
0x18F2: 48C0         EXT.L   D0
0x18F4: E588         LSL.L   #2,D0            ; D0 = index * 4
0x18F6: 49ED B1E0    LEA     -20000(A5),A4    ; A4 = visit table base
0x18FA: D08C         ADD.L   A4,D0
0x18FC: 2840         MOVEA.L D0,A4            ; A4 = &visit_table[index]
0x18FE: 2014         MOVE.L  (A4),D0          ; D0 = visit_table[index]
0x1900: B0AD B1DC    CMP.L   -20004(A5),D0    ; already visited this round?
0x1904: 6736         BEQ.S   0x193C           ; if yes → return (prevent re-visit)

; Mark as visited
0x1906: 28AD B1DC    MOVE.L  -20004(A5),(A4)  ; visit_table[index] = g_score_counter

; Store value into per-pattern accumulator
0x190A: 302E 000A    MOVE.W  10(A6),D0        ; D0 = value (tile_string_helper result)
0x190E: 204D         MOVEA.L A5,A0
0x1910: D0C7         ADDA.W  D7,A0            ; A0 = A5 + index
0x1912: D0C7         ADDA.W  D7,A0            ; A0 = A5 + 2*index (word array)
0x1914: D168 BBF4    ADD.W   D0,-17420(A0)    ; g_work_buffer[index] += value

; Propagate through 7 child patterns
0x1918: 7C00         MOVEQ   #0,D6            ; D6 = 0 (child counter)
0x191A: 49ED 99D6    LEA     -26154(A5),A4    ; A4 = child_table base

; Child propagation loop
0x191E: 6016         BRA.S   0x1936           ; → loop test
0x1920: 3F2E 000A    MOVE.W  10(A6),-(SP)     ; push value
0x1924: 302C 0002    MOVE.W  2(A4),D0         ; D0 = child_table[D6].pattern_ref
0x1928: 8047         OR.W    D7,D0            ; D0 = pattern_index | child_ref
0x192A: 3F00         MOVE.W  D0,-(SP)         ; push combined_index
0x192C: 4EBA FFB6    JSR     0x18E4           ; RECURSIVE: pre_vcb_helper(combined, value)
0x1930: 588F         ADDQ.L  #4,SP            ; clean stack (2 words)
0x1932: 5246         ADDQ.W  #1,D6            ; D6++
0x1934: 588C         ADDQ.L  #4,A4            ; A4 += 4 (next child entry)

; Loop test
0x1936: 0C46 0007    CMPI.W  #7,D6            ; D6 < 7?
0x193A: 6DE4         BLT.S   0x1920           ; loop

; Epilogue
0x193C: 4CDF 10C0    MOVEM.L (SP)+,D6-D7/A4
0x1940: 4E5E         UNLK    A6
0x1942: 4E75         RTS
```

### C Decompilation

```c
/* Pattern visit tracking table */
long g_visit_table[128];        /* A5-20000: 128 longs, one per pattern */

/* pre_vcb_helper - Store EXPR value and propagate through pattern tree
 *
 * Each pattern has 7 "child" patterns in a lookup table at A5-26154.
 * Child indices are OR'd with the parent index to form composite pattern IDs.
 * The visit table (checked against g_score_counter) prevents infinite recursion.
 *
 * The value from tile_string_helper is added to g_work_buffer[pattern_index],
 * then the same value is recursively propagated to all 7 child patterns.
 * This builds a per-pattern scoring tree where parent EXPR values cascade
 * to child patterns.
 *
 * NOTE: g_work_buffer values are consumed SEPARATELY from the V/C balance
 * computed by blank_dispatcher. The EXPR channel (g_work_buffer) and V/C
 * channel (pattern_base from orchestrator) are independent scoring components.
 */
void pre_vcb_helper(short pattern_index, short value) {
    /* Check if already visited this scoring round */
    if (g_visit_table[pattern_index] == g_score_counter)
        return;  /* already processed */

    /* Mark as visited */
    g_visit_table[pattern_index] = g_score_counter;

    /* Accumulate value into per-pattern buffer */
    g_work_buffer[pattern_index] += value;

    /* Propagate to 7 child patterns */
    short *child_table = (short *)(-26154 + (long)A5);
    for (int i = 0; i < 7; i++) {
        short child_ref = child_table[i * 2 + 1];  /* word at offset 2 */
        short combined = pattern_index | child_ref;
        pre_vcb_helper(combined, value);            /* recursive call */
    }
}
```

---

## Board Layout

17×17 arrays with border cells:
- **g_board_letters** (A5-17154): Letter codes (0=empty, ASCII otherwise)
- **g_board_scores** (A5-16610): Score values (word-sized, 34 bytes/row)

```c
int board_idx = row * 17 + col;
char letter = g_board_letters[board_idx];
short score = g_board_scores[row * 34 + col * 2];
```

---

## Global Variables (Complete)

| Offset | Name | Size | Purpose |
|--------|------|------|---------|
| A5-2448 | g_binom_table | 4 (ptr) | Binomial coefficient table (8080 bytes, allocated) |
| A5-2452 | g_vc_cache_key2 | 4 | V/C cache key 2 (local_22) |
| A5-2456 | g_vc_cache_key1 | 4 | V/C cache key 1 (local_20) |
| A5-2712 | g_vc_cache | 256 | V/C leave cache [C*32+V*4] |
| A5-10868 | g_mul_handles | 108 | 27 MUL resource ptrs (a-z + blank) |
| A5-10900 | g_mul_handles_alt | 108 | Secondary MUL handle array |
| A5-12538 | g_unseen_count | 2 | Unseen tiles in bag |
| A5-12683 | g_config_byte | 1 | Configuration byte |
| A5-12804 | g_pattern_strings | ~256 | ESTR pattern string table |
| A5-13060 | g_secondary_buffer | 256 | Scoring work buffer |
| A5-13062 | g_leave_index | 2 | Leave evaluation index |
| A5-13064 | g_estr_records | ~2304 | ESTR record base (18 bytes each) |
| A5-13318 | g_cross_scores | ~256 | Cross-check score accumulator |
| A5-16610 | g_board_scores | 578 | 17×17 score grid (word entries) |
| A5-17154 | g_board_letters | 289 | 17×17 letter grid |
| A5-17158 | g_best_col | 2 | Best column position |
| A5-17160 | g_best_col2 | 2 | Second best column |
| A5-17162 | g_best_row | 2 | Best row position |
| A5-17164 | g_best_row2 | 2 | Second best row |
| A5-17166 | g_estr_patterns | ~256 | ESTR pattern score base |
| A5-17420 | g_work_buffer | 256 | Scoring work buffer |
| A5-20004 | g_score_counter | 4 | Scoring operation counter |
| A5-20008 | g_score_counter_prev | 4 | Previous counter (threshold) |
| A5-20010 | g_tile_count | 2 | Tiles placed in current move |
| A5-26154 | (data ptr) | 4 | Letter classification data |
| A5-26158 | g_rack | 4 | Pointer to current rack string |
| A5-27630 | g_letter_values | 256 | Per-letter point values |
| A5-27716 | g_string_data | 4 | String data pointer |

## Jump Table Calls (Complete)

| JT Offset | Purpose | Used by |
|-----------|---------|---------|
| 66(A5) | 32-bit multiply | Scoring, table indexing (throughout) |
| 90(A5) | 32-bit divide | Q penalty, 0x0DAC inner loop |
| 418(A5) | Bounds check / error | Multiple validation points |
| 426(A5) | memset | Buffer clearing in 0x08B8, 0x0BFC |
| 1666(A5) | NewPtr | Binomial table allocation |
| 2002(A5) | is_vowel | Letter classification in orchestrator |
| 3506(A5) | strcmp | Q/U checking |
| 3514(A5) | strnchr/search | Q search in pattern |
| 3522(A5) | strlen | Pattern length |

## Confidence Levels

| Component | Confidence | Notes |
|-----------|------------|-------|
| Bingo bonus (5000) | **VERY HIGH** | Explicit constant 0x1388 at 0x0330 |
| Tile count check (==7) | **VERY HIGH** | CMPI.W #7 at 0x0328 |
| Binomial-weighted leave | **VERY HIGH** | Manually decoded from raw hex |
| Indexed MUL record access | **VERY HIGH** | Extension word 0x0818 verified |
| Pascal's triangle | **HIGH** | FADDX recurrence confirmed |
| VCB: orchestrator V/C counting | **HIGH** | JT[2002] call + branch structure verified |
| VCB: blank dispatcher | **HIGH** | 3 combos for 2 blanks, 2 for 1, verified |
| VCB: cache table structure | **HIGH** | `C*32 + V*4` indexing, 256-byte clear |
| VCB: core calculator outer loops | **HIGH** | Nested loop bounds verified |
| VCB: core calculator inner math | **MEDIUM** | Partially decoded, needs QEMU tracing |
| Position tracking | **HIGH** | Clear global variable updates |
| Cross-word scoring | **MEDIUM** | Complex nested loops |
| Move structure layout | **MEDIUM** | Inferred from offset patterns |
