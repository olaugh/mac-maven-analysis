# CODE 39 Detailed Analysis - Letter Combination Scoring

## Overview

| Property | Value |
|----------|-------|
| Size | 1784 bytes |
| JT Offset | 2608 |
| JT Entries | 4 |
| Functions | 5 |
| Purpose | **Generate and score letter pair/triple combinations for move evaluation** |


## System Role

**Category**: Scoring
**Function**: Letter Combinations

Letter pair synergy scoring (9632-byte stack frame)

**Related CODE resources**:
- CODE 32 (scoring)
- CODE 42 (rack analysis)
## Architecture Role

CODE 39 handles multi-letter combination analysis:
1. Generate all valid letter pair combinations
2. Calculate combined scores for letter groups
3. Support both hook-before and hook-after orientations
4. Provide score tables for different board positions

## Key Functions

### Function 0x0000 - Initialize Letter Pair Search
```asm
0000: LINK       A6,#-22              ; frame=22
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Initialize rack information
0008: MOVE.L     12(A6),-(A7)         ; Push rack
000C: JSR        3522(A5)             ; JT[3522] - init rack info
0010: MOVEA.L    A5,A0
...

; Set up mask value (0x0080 - indicates processed)
0016: MOVE.W     #$0080,D5            ; D5 = processed flag
001A: SUBA.B     -26152(A0),A5        ; Adjust for rack size

; Clear output pointers
001E: MOVEA.L    24(A6),A0            ; Output ptr 1
0022: CLR.L      (A0)
0024: MOVEA.L    20(A6),A1            ; Output ptr 2
0028: CLR.L      (A1)

; Setup iteration
002A: MOVEQ      #25,D0               ; 26 letters
002C: ADD.B      8(A6),(A0)           ; Initialize from param
0030: MOVEA.L    D0,A4
0032: MOVE.B     (A4),D0              ; Get letter
0034: EXT.W      D0
0036: MOVE.W     D0,(A7)

; Get cross-check mask
0038: MOVE.W     #$007F,-(A7)         ; Mask for letter bits
003C: JSR        2474(A5)             ; JT[2474] - get cross-check
0040: OR.W       D5,D0                ; Set processed flag
0042: MOVE.W     D0,-14(A6)           ; Store combined mask

; Initialize loop counter
0046: MOVEQ      #0,D6                ; D6 = counter
0048: MOVEA.W    16(A6),A0            ; Position
...

; Main loop through letter pair table
0058: LEA        -13060(A5),A2        ; A2 = g_letter_pair_table
005C: ADDA.W     D6,A2                ; Index into table
...

; Check if already processed
0066: MOVE.W     (A2),D3              ; Get entry
0068: MOVE.W     D5,D0
006A: AND.W      D3,D0                ; Check processed bit
006C: ...
006E: BNE.W      $017A                ; Skip if processed

; Check results array
0072: MOVEA.L    A5,A0
...
007C: TST.L      -22698(A0)           ; Check g_results_array[index]
0080: BEQ.W      $017A                ; Skip if no result

; Process this letter pair
0084: MOVE.W     (A2),-(A7)           ; Push entry
0086: MOVE.W     #$007F,-(A7)         ; Push mask
008A: JSR        2474(A5)             ; JT[2474] - get cross value
008E: OR.W       D5,D0                ; Set processed
0090: MOVE.W     D0,D3                ; D3 = processed entry
0092: MOVE.B     (A4),D4              ; D4 = current letter
0094: EXT.W      D4
0096: MOVE.W     D4,D0
0098: OR.W       D3,D0                ; Combine
009A: ...
009E: BEQ.S      $00A4                ; Check validity
00A0: JSR        418(A5)              ; JT[418] - error

; Look up score values
00A4: MOVEQ      #18,D0
00A6: AND.L      D3,A0                ; Mask for lookup index
00A8: ADD.B      -12532(A5),(A0)      ; Add from score table 1
00AC: ADD.B      -18(A6),(A0)         ; Add local value
00B0: MOVEA.L    D0,A0

; Get score from results array
00B4: MOVE.W     (A2),D0
00B6: EXT.L      D0
00B8: ...
00BC: MOVE.W     -22696(A1),D4        ; g_results_array score
00C0: SUB.B      (A0),A4              ; Adjust

; Compare scores and update best
00C2: MOVE.W     D5,-(A7)
00C4: MOVE.W     D3,-20(A6)           ; Store for later
00C8: MOVE.W     D3,-(A7)
00CA: MOVE.W     -14(A6),-(A7)        ; Push combined mask
00CE: JSR        2482(A5)             ; JT[2482] - compare scores
00D2: MOVE.W     D0,D3
00D4: CMPI.W     #$007F,D3            ; Check for max
00D8: ...
00DA: BNE.S      $010E                ; Not max - continue

; Handle maximum score case
00DC: MOVEQ      #18,D0
00DE: AND.L      -20(A6),A0
00E2: ADD.B      -12528(A5),(A0)      ; Add from score table 2
00E6: MOVEA.L    D0,A0
00E8: MOVE.W     16(A6),D0            ; Get position
00EC: ADDA.W     D0,A0
00EE: MOVE.W     0(A0,D0.W),-22(A6)   ; Look up position score
00F4: TST.W      -22(A6)
00F8: BLE.S      $010E                ; Skip if not positive

; Update with better score
00FA: MOVEA.L    -12516(A5),A0        ; Score table 3
00FE: LEA        2286(A0),A0          ; Offset into table
0102: ADD.B      -18(A6),$3010.W      ; (Complex score calc)
...

; Update output pointers
010E: MOVEA.L    20(A6),A0            ; Output ptr
0112: MOVEA.W    D4,A1
0114: CMP.L      (A0),...
...
011E: MOVE.L     A0,(A1)              ; Store result

; Continue with next entry
...
017A: ADD.B      A2,(A2)              ; Increment table pointer
017C: CMP.W      -13062(A5),A6        ; Check bounds
0180: BLT.W      $0068                ; Loop

0184: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
0188: UNLK       A6
018A: RTS
```

**C equivalent**:
```c
void init_letter_pair_search(void* param1, char* rack, int position,
                             int* out1, int* out2) {
    init_rack_info(rack);

    *out1 = 0;
    *out2 = 0;

    uint16_t mask = 0x0080;  // Processed flag

    for (int i = 0; i < g_letter_pair_count; i++) {
        uint16_t entry = g_letter_pair_table[i];

        // Skip if already processed
        if (entry & mask) continue;

        // Skip if no result for this pair
        if (g_results_array[i] == 0) continue;

        // Calculate combined score
        int cross_val = get_cross_check(entry, 0x7F);
        cross_val |= mask;  // Mark processed

        // Look up scores from multiple tables
        int idx = (cross_val * 18) & 0xFFFF;
        int score = g_score_table1[idx] + g_score_table2[idx];

        // Compare and update best scores
        int cmp = compare_scores(mask, cross_val, combined_mask);

        if (cmp == 0x7F) {
            // Found maximum - update tables
            score += g_position_scores[position];
        }

        // Update output if better
        if (score > *out1) {
            *out1 = score;
        }
    }
}
```

### Function 0x018C - Full Combination Analysis
```asm
018C: LINK       A6,#-9632            ; frame=9632 (LARGE!)
0190: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Check direction flag
0194: TST.W      8(A6)
0198: BEQ.S      $01AE

; Horizontal setup - use first set of tables
019A: MOVE.L     -12532(A5),-9596(A6) ; Copy score table 1
01A0: MOVE.L     -12528(A5),-9610(A6) ; Copy score table 2
01A6: MOVE.L     -12524(A5),-9604(A6) ; Copy score table 3
01AC: BRA.S      $01C0

; Vertical setup - use second set of tables
01AE: MOVE.L     -12520(A5),-9596(A6) ; Copy score table 4
01B4: MOVE.L     -12516(A5),-9610(A6) ; Copy score table 5
01BA: MOVE.L     -12512(A5),-9604(A6) ; Copy score table 6

; Initialize search
01C0: MOVE.L     10(A6),-(A7)         ; Push position
01C4: JSR        2730(A5)             ; JT[2730] - init position
01C8: MOVE.L     10(A6),(A7)
01CC: JSR        3522(A5)             ; JT[3522] - init rack

; Setup iteration
01D0: MOVEA.L    A5,A0
...
01D6: MOVE.W     #$0080,D0            ; Processed mask
...
01DE: MOVE.W     D0,-9612(A6)         ; Store mask

; Clear combination counter
01E2: MOVEQ      #0,D3
01E4: MOVE.W     D3,-9606(A6)

; Iterate through letter pair table
01E8: LEA        -13060(A5),A2        ; Letter pair table
01EC: ADD.W      D3,A2
...

; First pass - collect valid pairs
01F4: MOVE.W     (A2),D4              ; Get entry
01F6: MOVEQ      #127,D0
01F8: OR.W       D4,D0
01FA: CMPI.W     #$007F,D0            ; Check valid
01FE: BEQ.S      $0204
0200: JSR        418(A5)              ; Error

0204: MOVE.W     -9612(A6),D0
0208: AND.W      D4,D0                ; Check processed
020A: ...
020E: BNE.S      $0222                ; Skip if processed

; Store valid pair index
0210: MOVE.W     -9606(A6),D0
0214: ...
021C: MOVE.W     D4,-260(A0)          ; Store in local array
0222: ...                             ; Increment counter
0226: CMP.W      -13062(A5),A3        ; Check bounds
022A: BLT.S      $01F4                ; Continue loop

; Second pass - generate combinations
022C: LEA        -9060(A6),A2         ; Combination buffer
0230: MOVEQ      #0,D3
0232: LEA        -260(A6),A3          ; Valid pairs array
0236: LEA        -9576(A6),A0         ; Results array
023A: MOVE.L     A0,-9592(A6)
023E: BRA.S      $029A

; Nested loop for pair combinations
0240: MOVEA.L    -9592(A6),A0
0244: MOVE.L     A2,(A0)              ; Store result pointer

0246: MOVE.W     (A3),D4              ; Get first pair
0248: MOVE.W     D3,D5                ; Counter
024A: LEA        -260(A6),A1          ; Second pairs array
...

; Inner loop - combine pairs
0256: MOVEA.L    D7,A0
0258: MOVE.W     (A0),D6              ; Get second pair
025A: MOVE.W     D4,D0
025C: OR.W       D6,D0                ; Combine
025E: ...
0260: BNE.S      $0288                ; Skip invalid

; Check results array for this combination
0262: MOVEA.L    A5,A0
...
026C: TST.L      -22698(A0)           ; g_results_array
0270: BEQ.S      $0288                ; Skip if no result

; Store valid combination
0272: MOVE.W     D6,-(A7)
0274: MOVE.W     D4,-(A7)
0276: JSR        2474(A5)             ; JT[2474]
027A: OR.W       -9612(A6),D0
027E: MOVE.W     D0,(A2)              ; Store combined value
0280: MOVE.W     D6,2(A2)             ; Store second pair
0284: ...                             ; Advance pointer

0288: ...                             ; Increment inner counter
028C: CMP.W      -9606(A6),A5
0290: BLT.S      $0256                ; Inner loop

0292: ...                             ; Increment outer counter
029A: CMP.W      -9606(A6),A3
029E: BLT.S      $0240                ; Outer loop

; Third pass - calculate scores for combinations
...
02B6: MOVE.W     (A2),D4              ; Get combination
02B8: MOVEQ      #18,D0
02BA: AND.L      D4,A0                ; Index
02BC: MOVEA.L    D0,A3
02BE: MOVEA.L    A3,A0
02C0: ADD.B      -9596(A6),...        ; Add from score table
02C6: MOVEA.L    A3,A0
02C8: ADD.B      -9604(A6),...        ; Add from position table
02CE: MOVEA.L    A5,A0
02D0: ADD.W      D4,A0
02D2: ADD.W      D4,A0
02D4: MOVEA.L    A3,A1
02D6: ADD.B      -9610(A6),...        ; Add from table 2
...

; Fourth pass - extended scoring
02E8: MOVE.W     #$0001,-9612(A6)     ; Reset mask
02EE: MOVE.W     #$0001,-9622(A6)     ; Counter
02F4: MOVEQ      #2,D0
02F6: MOVE.L     D0,-9592(A6)
02FA: BRA.W      $0496

; Complex nested iteration for multi-letter combinations
02FE: CLR.W      -9612(A6)            ; Clear mask
0302: MOVEQ      #0,D3
...

; (Many more nested loops calculating scores
;  for 3, 4, 5, 6, 7 letter combinations)
...

; Final score aggregation
049C: MOVEQ      #0,D3
049E: MOVE.W     -9622(A6),D7
04A2: EXT.L      D7
04A4: ADD.L      D7,(A7)
04A6: LEA        -260(A6),A2
...

04B0: MOVE.W     (A2),D4
04B2: MOVEQ      #18,D0
04B4: AND.L      D4,A0
04B6: MOVEA.L    D0,A3
04B8: MOVEA.L    A3,A0
04BA: ADD.B      -9596(A6),...        ; Final score calculation
...

050E: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
0512: UNLK       A6
0514: RTS
```

**C equivalent (simplified)**:
```c
void full_combination_analysis(int direction, void* position) {
    // 9632-byte stack frame for temporary storage
    int local_scores[2400];      // Score cache
    int valid_pairs[65];         // Valid pair indices
    int combinations[2048];      // Combination results

    // Select tables based on direction
    int* score_table1, *score_table2, *score_table3;
    if (direction) {
        score_table1 = g_horiz_scores1;
        score_table2 = g_horiz_scores2;
        score_table3 = g_horiz_scores3;
    } else {
        score_table1 = g_vert_scores1;
        score_table2 = g_vert_scores2;
        score_table3 = g_vert_scores3;
    }

    init_position(position);
    init_rack(position);

    // Pass 1: Collect valid letter pairs
    int pair_count = 0;
    for (int i = 0; i < g_letter_pair_count; i++) {
        uint16_t entry = g_letter_pair_table[i];
        if (!(entry & 0x80)) {  // Not processed
            valid_pairs[pair_count++] = entry;
        }
    }

    // Pass 2: Generate all valid pair combinations
    int combo_count = 0;
    for (int i = 0; i < pair_count; i++) {
        for (int j = 0; j < pair_count; j++) {
            uint16_t combined = valid_pairs[i] | valid_pairs[j];
            if (g_results_array[combined]) {
                combinations[combo_count++] = combined;
            }
        }
    }

    // Pass 3: Calculate base scores
    for (int i = 0; i < combo_count; i++) {
        int idx = (combinations[i] * 18) & 0xFFFF;
        local_scores[i] = score_table1[idx] +
                          score_table2[idx] +
                          score_table3[idx];
    }

    // Pass 4+: Extended scoring for longer combinations
    // (Complex iterative refinement of scores)
    ...
}
```

### Function 0x0516 - Get Pair Scores
```asm
0516: LINK       A6,#0
051A: MOVEM.L    D7/A4,-(SP)

; Clear output
051E: MOVEA.L    10(A6),A0
0522: CLR.W      (A0)

; Calculate index from pair
0524: MOVEQ      #18,D0
0526: AND.L      8(A6),A0             ; Pair value * 18
052A: MOVEA.L    D0,A4

; Look up in score table 3
052C: MOVE.L     -12524(A5),D0        ; g_horiz_scores3
0530: MOVEA.L    14(A6),A1            ; Output ptr
0534: MOVE.W     16(A4,D0.L),(A1)     ; Store score

; Look up in score table 2
0538: MOVEQ      #18,D0
053A: AND.L      8(A6),A0
053E: MOVEA.L    -12528(A5),A0        ; g_horiz_scores2
0542: MOVE.W     16(A0,D0.L),D7       ; Get score

; Handle zero case - use table 5 instead
0546: TST.W      D7
0548: BNE.S      $0550
054A: MOVE.W     D7,D0
054C: NEG.W      D0
054E: BRA.S      $0558

0550: MOVEA.L    -12516(A5),A0        ; g_vert_scores2
0554: MOVE.W     2286(A0),D0

; Combine scores
0558: MOVEA.L    -12516(A5),A0
055C: MOVE.L     -12532(A5),D1        ; g_horiz_scores1
0560: MOVE.W     2286(A0),D2
0564: ADD.B      16(A4,D1.L),A2
0568: ADD.B      D2,A0

056A: MOVEM.L    (SP)+,D7/A4
056E: UNLK       A6
0570: RTS
```

**C equivalent**:
```c
int get_pair_scores(uint16_t pair, int* score_out1, int* score_out2) {
    *score_out1 = 0;

    int idx = (pair * 18) & 0xFFFF;
    *score_out2 = g_horiz_scores3[idx + 16];

    int score2 = g_horiz_scores2[idx + 16];
    int base_score;

    if (score2 == 0) {
        base_score = -score2;  // Use negated
    } else {
        base_score = g_vert_scores2[2286];
    }

    return g_horiz_scores1[idx + 16] + g_vert_scores2[2286] + base_score;
}
```

### Function 0x0572 - Extended Score Calculation
```asm
0572: LINK       A6,#-20              ; frame=20
0576: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Set up index from parameters
057A: MOVEQ      #18,D0
057C: AND.L      8(A6),A0             ; First pair
0580: MOVEA.L    D0,A4
0582: MOVEA.L    A4,A3
0584: ADD.B      -12528(A5),...       ; Add from table 2

058A: AND.L      10(A6),A0            ; Second pair
058E: MOVEA.L    D0,A2

; Get table pointers
0590: MOVE.L     -12516(A5),D7        ; g_vert_scores2
0594: ADD.B      A2,(A7)
0596: MOVE.L     -12532(A5),D6        ; g_horiz_scores1
...

; Look up multiple scores
05B0: MOVE.W     (A1),D4              ; Get pair value
05BC: MOVE.W     16(A1),D3            ; Get offset value
05C0: MOVE.B     (A4),D0
05C2: MOVEA.L    D0,A4

; Handle zero case
05CC: TST.W      D3
05CE: BEQ.S      $05D4
05D0: MOVE.W     D3,D0
05D2: BRA.S      $05D8
05D4: MOVE.W     D5,D0
05D6: NEG.W      D0                   ; Negate if zero

; Store results
05D8: ADD.B      D0,A4
05DA: MOVEA.L    12(A6),A0            ; Output 1
05DE: MOVE.W     16(A4),(A0)

05E2: MOVEA.L    -16(A6),A1
05E6: MOVEA.L    16(A6),A0            ; Output 2
05EA: MOVE.W     16(A1),(A0)

; Loop through score adjustments
05EE: MOVEQ      #7,D5                ; 7 iterations
05F0: MOVEA.W    #$000E,A2            ; Offset
05F4: BRA.W      $067A

; Inner scoring loop
05F8: TST.W      0(A2,D7.L)           ; Check table entry
05FC: BNE.S      $0630                ; Skip if non-zero

; Calculate adjusted score
05FE: MOVEA.L    A3,A0
0600: ADD.B      A2,$3010.W
0604: ADD.B      D0,A0
0606: MOVEA.L    A2,A0
0608: ADD.B      -20(A6),$3632.W
...

; Update best if better
0618: MOVE.W     D3,D4
061A: MOVEA.L    A4,A0
061C: ADD.B      A2,...
0620: MOVEA.L    12(A6),A1
0624: MOVE.W     (A0),(A1)            ; Store new best
...

0630: MOVEA.L    A3,A0
0632: ADD.B      A2,$4A50.W
0636: BNE.S      $0674                ; Skip if non-zero

; Similar scoring for other direction
0638: MOVEA.W    D5,A0
063A: LEA        -2(A0,D5.W),A0
063E: MOVE.L     A0,-12(A6)
...

; Loop continuation
0674: SUB.W      #1,D5                ; Decrement counter
0678: TST.W      D5
067A: BGT.W      $05F8                ; Continue loop

; Return best score
067E: MOVE.W     D4,D0
0680: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
0684: UNLK       A6
0686: RTS
```

### Function 0x0688 - Combined Score Wrapper
```asm
0688: LINK       A6,#0
068C: MOVEM.L    D6/D7/A4,-(SP)

; Get parameters
0690: MOVE.W     10(A6),D6            ; Direction
0694: MOVE.L     16(A6),-(A7)         ; Output 2
0698: MOVE.L     12(A6),-(A7)         ; Output 1
069C: MOVE.W     D6,-(A7)             ; Direction
069E: MOVE.W     8(A6),-(A7)          ; Pair value
06A2: JSR        -306(PC)             ; Call function 0x0572

06A6: MOVE.W     D0,D7                ; Save result

; Calculate index
06A8: MOVEQ      #18,D0
06AA: AND.L      D6,A0
06AC: ADD.B      -12516(A5),(A0)      ; g_vert_scores2

06B0: MOVEA.L    D0,A4

; Look up in multiple tables
06B2: MOVEQ      #18,D0
06B4: AND.L      D6,A0
06B6: MOVEA.L    -12512(A5),A0        ; g_vert_scores3
06BA: MOVEQ      #18,D1
06BC: AND.L      D6,A1
06BE: MOVEA.L    -12520(A5),A1        ; g_vert_scores1

; Combine scores
06C2: MOVE.W     (A4),D2
06C4: ADD.B      D2,A2
06C6: ADD.B      16(A1,D1.L),A2
06CA: CMP.W      16(A0,D0.L),A2

06CE: LEA        12(A7),A7
06D2: BNE.S      $06EE                ; Skip if not equal

; Handle equal case
06D4: MOVEQ      #18,D0
06D6: AND.L      8(A6),A0
06DA: MOVEA.L    -12532(A5),A0        ; g_horiz_scores1
06DE: MOVE.W     (A4),D1
06E0: ADD.B      D1,A1
06E2: ADD.B      16(A0,D0.L),A1
06E6: SUB.B      D7,A1
06E8: MOVEA.L    12(A6),A1
06EC: MOVE.W     D1,(A1)              ; Store result

06EE: MOVE.W     D7,D0
06F0: MOVEM.L    (SP)+,D6/D7/A4
06F4: UNLK       A6
06F6: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-12512 | g_vert_scores3 - Vertical position scores |
| A5-12516 | g_vert_scores2 - Vertical letter scores |
| A5-12520 | g_vert_scores1 - Vertical base scores |
| A5-12524 | g_horiz_scores3 - Horizontal position scores |
| A5-12528 | g_horiz_scores2 - Horizontal letter scores |
| A5-12532 | g_horiz_scores1 - Horizontal base scores |
| A5-13060 | g_letter_pair_table - Letter pair lookup |
| A5-13062 | g_letter_pair_count - Number of pairs |
| A5-22696 | g_results_array_score - Score component |
| A5-22698 | g_results_array - Valid combination results |
| A5-26152 | Rack size adjustment |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 2474 | Get cross-check value |
| 2482 | Compare scores |
| 2730 | Initialize position |
| 3522 | Initialize rack information |

## Data Structures

**Letter Pair Table** (at A5-13060):
- Array of 16-bit entries
- Each entry encodes two letters
- High bit (0x80) marks as processed
- Lower 7 bits encode letter indices

**Score Tables** (6 tables):
- 3 for hook-after (A5-12524, A5-12528, A5-12532)
- 3 for hook-before (A5-12512, A5-12516, A5-12520)
- Each provides different score components:
  - Table 1: Base letter values
  - Table 2: Letter combination bonuses
  - Table 3: Position-based multipliers

**Results Array** (at A5-22698):
- 512 bytes of combination results
- Non-zero indicates valid combination
- Used for quick validity lookup

## Algorithm

Multi-letter combination scoring:
1. Enumerate all valid letter pairs from current rack
2. Generate combinations of pairs (2, 3, 4... letters)
3. For each combination:
   - Look up base scores from direction-specific tables
   - Add position multipliers
   - Add letter combination bonuses
4. Track best scores for each position
5. Return optimal scoring information

## Stack Usage

The large 9632-byte stack frame in function 0x018C:
- ~2400 entries for local scores (4 bytes each)
- 260 bytes for valid pairs array
- 2048+ bytes for combination storage
- Additional working buffers

This represents the most memory-intensive function in Maven, used for exhaustive move generation.

## ESTR Pattern and Synergy Tables

The six score tables at A5-12512 to A5-12532 implement **ESTR (Extended Score Table Record) patterns** for letter synergy evaluation:

**Table Structure** (18-byte records indexed by letter pair):
```
Offset 0-1:   Base value
Offset 2-3:   Synergy bonus 1
Offset 4-5:   Synergy bonus 2
...
Offset 16-17: Position multiplier
```

**Letter Synergy Computation**:
The tables encode pre-computed synergy values for common letter combinations:
- High-value combinations (QU, ING, TION, etc.) have positive synergy
- Conflicting combinations (multiple high-point tiles) have negative synergy
- Position-dependent adjustments for premium squares

**Horizontal vs Vertical Tables**:
- Tables 1-3 (A5-12524 to A5-12532): Used for hook-after cross-checks
- Tables 4-6 (A5-12512 to A5-12520): Used for hook-before cross-checks
- Distinction important because row/column premium square patterns differ

## Data Flow

```
Rack Letters → Letter Pair Table → Valid Pairs Filter
                                         ↓
                              Pair Combinations Generator
                                         ↓
                              Score Table Lookups (6 tables)
                                         ↓
                              Results Array (A5-22698)
                                         ↓
                              Best Score Selection
```

## Integration with Other CODE Resources

- **CODE 32**: Consumes synergy scores for move evaluation
- **CODE 42**: Provides rack analysis that feeds into pair generation
- **CODE 36**: Uses results for cache optimization

## Confidence: MEDIUM-HIGH

Complex score calculation logic with:
- Clear separation of hook-after/hook-before tables (confirmed by direction parameter check)
- Systematic pair enumeration with 0x80 processed flag
- Multi-pass scoring algorithm (4+ passes visible in function 0x018C)
- ESTR pattern lookup using 18-byte indexed records
- Direction-aware table selection at offset 0x019A-0x01BA

Some disassembly artifacts (garbled instructions at complex addressing modes) but overall algorithm flow is well-understood.

---

## Speculative C Translation

### Header File (code39_synergy.h)

```c
/*
 * CODE 39 - Letter Combination Scoring (Synergy Tables)
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * This module generates and scores letter pair/triple combinations
 * for move evaluation. Uses the massive 9632-byte stack frame for
 * exhaustive combination enumeration.
 */

#ifndef CODE39_SYNERGY_H
#define CODE39_SYNERGY_H

#include <stdint.h>
#include <stdbool.h>

/*
 * ESTR (Extended Score Table Record) - 18 bytes per entry
 * Used for letter synergy lookup
 */
typedef struct ESTREntry {
    int16_t base_value;         /* +0: Base synergy value */
    int16_t synergy_bonus1;     /* +2: First synergy bonus */
    int16_t synergy_bonus2;     /* +4: Second synergy bonus */
    int16_t synergy_bonus3;     /* +6: Third synergy bonus */
    int16_t synergy_bonus4;     /* +8: Fourth synergy bonus */
    int16_t synergy_bonus5;     /* +10: Fifth synergy bonus */
    int16_t synergy_bonus6;     /* +12: Sixth synergy bonus */
    int16_t synergy_bonus7;     /* +14: Seventh synergy bonus */
    int16_t position_mult;      /* +16: Position multiplier */
} ESTREntry;

/* Score table pointers (6 tables total) */
typedef struct ScoreTables {
    ESTREntry* horiz_base;      /* A5-12532: Horizontal base scores */
    ESTREntry* horiz_letter;    /* A5-12528: Horizontal letter bonuses */
    ESTREntry* horiz_position;  /* A5-12524: Horizontal position mults */
    ESTREntry* vert_base;       /* A5-12520: Vertical base scores */
    ESTREntry* vert_letter;     /* A5-12516: Vertical letter bonuses */
    ESTREntry* vert_position;   /* A5-12512: Vertical position mults */
} ScoreTables;

/*
 * Global variables (A5-relative)
 */
extern ScoreTables  g_score_tables;
extern uint16_t*    g_letter_pair_table;  /* A5-13060: Letter pair entries */
extern uint16_t     g_letter_pair_count;  /* A5-13062: Number of pairs */
extern int32_t*     g_results_array;      /* A5-22698: Combination results */
extern int16_t*     g_results_score;      /* A5-22696: Result scores */
extern uint8_t      g_rack_size_adj;      /* A5-26152: Rack size adjustment */

/* Processed flag for letter pair entries */
#define PAIR_PROCESSED_FLAG  0x0080

/* Function prototypes */
void init_letter_pair_search(void* param, char* rack, int position,
                            int32_t* out1, int32_t* out2);
void full_combination_analysis(int direction, void* position);
int get_pair_scores(uint16_t pair, int16_t* score_out1, int16_t* score_out2);
int extended_score_calculation(uint16_t pair1, uint16_t pair2,
                              int16_t* out1, int16_t* out2);
int combined_score_wrapper(uint16_t pair, uint16_t direction,
                          int16_t* out1, int16_t* out2);

#endif /* CODE39_SYNERGY_H */
```

### Implementation File (code39_synergy.c)

```c
/*
 * CODE 39 - Letter Combination Scoring Implementation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * This is the most memory-intensive function in Maven, using
 * a 9632-byte stack frame for exhaustive move generation.
 *
 * Key concepts:
 * - Letter pairs encode two letters in a 16-bit value
 * - 0x80 bit marks pairs as processed
 * - 6 score tables (3 horiz + 3 vert) provide synergy values
 * - Multi-pass algorithm for combination generation
 */

#include "code39_synergy.h"

/* External JT functions */
extern void init_rack_info(char* rack);              /* JT[3522] */
extern int16_t get_crosscheck_value(uint16_t entry, uint16_t mask); /* JT[2474] */
extern int compare_scores(uint16_t a, uint16_t b, uint16_t c);      /* JT[2482] */
extern void init_position_for_scoring(void* pos);    /* JT[2730] */
extern void bounds_error(void);                       /* JT[418] */

/*
 * Local stack frame structure for full_combination_analysis
 * Total: 9632 bytes
 */
typedef struct CombinationFrame {
    int32_t local_scores[2400];      /* Score cache (9600 bytes) */
    uint16_t valid_pairs[65];        /* Valid pair indices (130 bytes) */
    int16_t score_table1_local;      /* -9596: Local copy */
    int16_t score_table2_local;      /* -9610: Local copy */
    int16_t score_table3_local;      /* -9604: Local copy */
    uint16_t pair_count;             /* -9606: Valid pair count */
    uint16_t processed_mask;         /* -9612: Processing mask */
    uint16_t counter1;               /* -9622: Iteration counter */
    int32_t results_ptr;             /* -9592: Results array pointer */
    /* Additional working buffers */
} CombinationFrame;

/*
 * init_letter_pair_search - Function at 0x0000
 *
 * Initializes letter pair search, finding valid pairs from
 * the current rack and calculating their scores.
 *
 * Parameters:
 *   param - Initial parameter (uncertain purpose)
 *   rack - Player's rack letters
 *   position - Board position being evaluated
 *   out1, out2 - Output score pointers
 */
void init_letter_pair_search(void* param, char* rack, int position,
                            int32_t* out1, int32_t* out2)
{
    uint16_t processed_mask = PAIR_PROCESSED_FLAG;
    int16_t combined_mask;
    int i;

    /* Initialize rack information */
    init_rack_info(rack);

    /* Adjust for rack size */
    /* uncertain - A5-26152 adjustment */

    /* Clear output pointers */
    *out1 = 0;
    *out2 = 0;

    /*
     * Iterate through letter pair table
     */
    for (i = 0; i < g_letter_pair_count; i++) {
        uint16_t entry = g_letter_pair_table[i];

        /* Skip if already processed */
        if (entry & processed_mask) {
            continue;
        }

        /* Skip if no result for this pair */
        if (g_results_array[i] == 0) {
            continue;
        }

        /* Get cross-check value for this entry */
        int16_t cross_val = get_crosscheck_value(entry, 0x7F);
        cross_val |= processed_mask;  /* Mark as processed */

        /* Extract letter from entry */
        int letter = entry & 0x7F;  /* uncertain - low 7 bits */

        /* Validate combination */
        if ((cross_val | letter) == 0) {
            bounds_error();
        }

        /*
         * Look up scores from multiple tables
         * Index = entry * 18 (ESTR record size)
         */
        int idx = (cross_val * 18) & 0xFFFF;  /* uncertain scaling */

        int score1 = g_score_tables.horiz_base[idx / 18].base_value;
        int score2 = g_score_tables.horiz_letter[idx / 18].base_value;

        /* Get result array score component */
        int16_t result_score = g_results_score[i];

        /*
         * Compare scores and determine best
         */
        int cmp = compare_scores(processed_mask, cross_val, combined_mask);

        if (cmp == 0x7F) {
            /* Maximum score case - add position component */
            int pos_score = g_score_tables.horiz_position[idx / 18].position_mult;

            if (pos_score > 0) {
                /* Update with position-enhanced score */
                /* uncertain - complex score table interaction */
            }
        }

        /* Update outputs if better */
        if (score1 + score2 > *out1) {
            *out1 = score1 + score2;
        }
    }
}

/*
 * full_combination_analysis - Function at 0x018C
 *
 * Performs exhaustive analysis of all letter combinations.
 * Uses the massive 9632-byte stack frame for working storage.
 *
 * This is a multi-pass algorithm:
 * Pass 1: Collect valid letter pairs
 * Pass 2: Generate pair combinations
 * Pass 3: Calculate base scores
 * Pass 4+: Extended scoring for longer combinations
 *
 * Parameters:
 *   direction - 0=vertical, non-zero=horizontal
 *   position - Board position data
 */
void full_combination_analysis(int direction, void* position)
{
    /* Allocate massive stack frame */
    int32_t local_scores[2400];
    uint16_t valid_pairs[65];
    uint16_t combinations[1024];  /* 2048 bytes / 2 */

    ESTREntry* score_table1;
    ESTREntry* score_table2;
    ESTREntry* score_table3;

    int pair_count;
    int combo_count;
    int i, j;
    uint16_t processed_mask = PAIR_PROCESSED_FLAG;

    /*
     * Select score tables based on direction
     */
    if (direction) {
        /* Horizontal - use horiz tables */
        score_table1 = g_score_tables.horiz_base;
        score_table2 = g_score_tables.horiz_letter;
        score_table3 = g_score_tables.horiz_position;
    } else {
        /* Vertical - use vert tables */
        score_table1 = g_score_tables.vert_base;
        score_table2 = g_score_tables.vert_letter;
        score_table3 = g_score_tables.vert_position;
    }

    /* Initialize position and rack */
    init_position_for_scoring(position);
    init_rack_info((char*)position);  /* uncertain - position contains rack? */

    /*
     * PASS 1: Collect valid letter pairs
     * Filter out processed pairs and those without results
     */
    pair_count = 0;

    for (i = 0; i < g_letter_pair_count; i++) {
        uint16_t entry = g_letter_pair_table[i];

        /* Validate entry format */
        if ((entry | 0x7F) != 0x7F) {
            bounds_error();
        }

        /* Skip if processed */
        if (entry & processed_mask) {
            continue;
        }

        /* Store valid pair */
        valid_pairs[pair_count++] = entry;
    }

    /*
     * PASS 2: Generate all pair combinations
     * Nested loops create pairwise combinations
     */
    combo_count = 0;

    for (i = 0; i < pair_count; i++) {
        uint16_t pair1 = valid_pairs[i];

        for (j = 0; j < pair_count; j++) {
            uint16_t pair2 = valid_pairs[j];

            /* Combine pairs */
            uint16_t combined = pair1 | pair2;

            /* Check if result exists for combination */
            /* uncertain - indexing into results array */
            if (g_results_array[combined & 0x1FF] == 0) {
                continue;
            }

            /* Get cross-check value */
            int16_t cross_val = get_crosscheck_value(pair1, 0x7F);
            cross_val |= processed_mask;

            /* Store combination */
            combinations[combo_count * 2] = cross_val;
            combinations[combo_count * 2 + 1] = pair2;
            combo_count++;
        }
    }

    /*
     * PASS 3: Calculate base scores for combinations
     */
    for (i = 0; i < combo_count; i++) {
        uint16_t combo = combinations[i * 2];
        int idx = (combo * 18) & 0xFFFF;  /* ESTR index */

        /* Sum scores from all three tables */
        local_scores[i] = score_table1[idx / 18].base_value
                        + score_table2[idx / 18].base_value
                        + score_table3[idx / 18].position_mult;
    }

    /*
     * PASS 4+: Extended scoring for longer combinations
     * Iteratively refine scores for 3, 4, 5, 6, 7 letter combos
     */
    int iteration_mask = 1;
    int iteration_counter = 1;
    int max_iterations = 7;  /* Max rack size */

    while (iteration_counter <= max_iterations) {
        /* Clear mask for new iteration */
        iteration_mask = 0;

        /* Process combinations at this depth */
        for (i = 0; i < combo_count; i++) {
            uint16_t combo = combinations[i * 2];
            int idx = (combo * 18) & 0xFFFF;

            /* Add next level scores */
            local_scores[i] += score_table1[idx / 18].synergy_bonus1
                             + score_table2[idx / 18].synergy_bonus1
                             + score_table3[idx / 18].synergy_bonus1;

            /* uncertain - complex iteration logic */
        }

        iteration_counter++;
        iteration_mask <<= 1;
    }

    /*
     * Final aggregation
     * Update valid_pairs with final scores
     */
    for (i = 0; i < pair_count; i++) {
        uint16_t pair = valid_pairs[i];
        int idx = (pair * 18) & 0xFFFF;

        /* Calculate final score */
        int final_score = score_table1[idx / 18].base_value
                        + score_table2[idx / 18].position_mult
                        + score_table3[idx / 18].position_mult;

        /* Store in appropriate output location */
        /* uncertain - where results are stored */
    }
}

/*
 * get_pair_scores - Function at 0x0516
 *
 * Gets the score components for a letter pair.
 *
 * Parameters:
 *   pair - Letter pair value
 *   score_out1 - Output for first score component
 *   score_out2 - Output for second score component
 *
 * Returns:
 *   Combined score value
 */
int get_pair_scores(uint16_t pair, int16_t* score_out1, int16_t* score_out2)
{
    int idx = (pair * 18) & 0xFFFF;

    *score_out1 = 0;

    /* Look up in position table (table 3) */
    *score_out2 = g_score_tables.horiz_position[idx / 18].position_mult;

    /* Get letter table value (table 2) */
    int16_t letter_score = g_score_tables.horiz_letter[idx / 18].base_value;

    int base_score;
    if (letter_score == 0) {
        /* Use negated value */
        base_score = 0;  /* -0 = 0 */
    } else {
        /* Use vertical table 2 at fixed offset */
        base_score = g_score_tables.vert_letter[2286 / 18].base_value;
    }

    /* Combine scores */
    int result = g_score_tables.horiz_base[idx / 18].base_value
               + g_score_tables.vert_letter[2286 / 18].base_value
               + base_score;

    return result;
}

/*
 * extended_score_calculation - Function at 0x0572
 *
 * Calculates extended scores for a pair of letter pairs,
 * used for multi-letter combination evaluation.
 *
 * Parameters:
 *   pair1 - First letter pair
 *   pair2 - Second letter pair
 *   out1, out2 - Output score pointers
 *
 * Returns:
 *   Best score found
 */
int extended_score_calculation(uint16_t pair1, uint16_t pair2,
                              int16_t* out1, int16_t* out2)
{
    int idx1 = (pair1 * 18) & 0xFFFF;
    int idx2 = (pair2 * 18) & 0xFFFF;

    ESTREntry* entry1 = &g_score_tables.horiz_letter[idx1 / 18];
    ESTREntry* entry2 = &g_score_tables.vert_letter[idx2 / 18];

    int32_t vert_base = (int32_t)g_score_tables.vert_letter;
    int32_t horiz_base = (int32_t)g_score_tables.horiz_base;

    /* Get initial values */
    int16_t val1 = entry1->base_value;
    int16_t val2 = entry2->base_value;

    /* Handle zero case */
    int16_t adjusted;
    if (val2 == 0) {
        adjusted = -val2;  /* Negate (still 0) */
    } else {
        adjusted = val1;
    }

    /* Store initial results */
    *out1 = entry1->position_mult;
    *out2 = entry2->position_mult;

    /*
     * Iterate through synergy bonuses (7 iterations)
     */
    int best_score = val1;
    int iteration;

    for (iteration = 7; iteration > 0; iteration--) {
        /* Check if table entry at current offset is zero */
        if (((int16_t*)((char*)vert_base + idx1))[iteration] == 0) {
            /* Calculate adjusted score */
            int adj_score = entry1->position_mult + adjusted;

            if (adj_score > best_score) {
                best_score = adj_score;
                *out1 = ((int16_t*)((char*)horiz_base + idx1))[iteration];
            }
        }

        /* Similar check for second pair */
        if (((int16_t*)((char*)horiz_base + idx2))[iteration] == 0) {
            /* Similar adjustment for second pair */
            /* uncertain - exact calculation */
        }
    }

    return best_score;
}

/*
 * combined_score_wrapper - Function at 0x0688
 *
 * Wrapper function that combines multiple score lookups
 * for a letter pair with direction consideration.
 *
 * Parameters:
 *   pair - Letter pair value
 *   direction - Direction index
 *   out1, out2 - Output score pointers
 *
 * Returns:
 *   Combined score
 */
int combined_score_wrapper(uint16_t pair, uint16_t direction,
                          int16_t* out1, int16_t* out2)
{
    /* Call extended calculation */
    int result = extended_score_calculation(pair, direction, out1, out2);

    /* Calculate index for direction */
    int dir_idx = (direction * 18) & 0xFFFF;

    ESTREntry* vert_pos = &g_score_tables.vert_position[dir_idx / 18];
    ESTREntry* vert_base = &g_score_tables.vert_base[dir_idx / 18];
    ESTREntry* horiz_base = &g_score_tables.horiz_base[(pair * 18) / 18];

    /* Get values from multiple tables */
    int16_t val1 = vert_pos->base_value;
    int16_t val2 = vert_base->base_value;

    /* Combine */
    int combined = val1 + val2 + horiz_base->position_mult;

    /* Check if equal to position table */
    if (combined != vert_pos->position_mult) {
        return result;
    }

    /* Equal case - calculate alternate */
    int alt_score = horiz_base->base_value + val1 - result;
    *out1 = alt_score;

    return result;
}
```

### Key Algorithmic Notes

```
STACK FRAME (9632 bytes):
=========================
The massive stack frame contains:
- local_scores[2400]: 9600 bytes for score caching
- valid_pairs[65]: ~130 bytes for pair indices
- combinations[~1000]: ~2000 bytes for pair combinations
- Various local variables and counters

This is the most memory-intensive function in Maven.

ESTR (Extended Score Table Record):
===================================
18-byte records indexed by letter pair value:
+0-1:   Base value
+2-15:  Seven synergy bonus values (one per rack position)
+16-17: Position multiplier

Six tables (3 horizontal + 3 vertical) provide:
- Base scores for letter combinations
- Letter-specific synergy bonuses
- Position-dependent multipliers

LETTER PAIR ENCODING:
=====================
16-bit values encoding two letters:
- Bits 0-6: First letter (0-63)
- Bit 7: Processed flag (0x80)
- Bits 8-14: Second letter
- Bit 15: Additional flag

MULTI-PASS ALGORITHM:
=====================
Pass 1: Filter valid pairs from g_letter_pair_table
Pass 2: Generate pairwise combinations (O(n^2))
Pass 3: Calculate base scores from tables
Pass 4-7: Iteratively add synergy bonuses for depth 3-7

DIRECTION HANDLING:
===================
- direction=0: Use vertical tables (hook-before)
- direction!=0: Use horizontal tables (hook-after)

This distinction matters because premium square
patterns differ by orientation.

SYNERGY CONCEPTS:
=================
High synergy combinations (positive bonuses):
- QU (Q+U together)
- ING, TION, NESS (common endings)
- High-frequency letter pairs (TH, HE, IN, ER)

Low synergy combinations (negative or zero):
- Multiple high-point tiles (Q+X+Z)
- Duplicate vowels or consonants
- Rare letter combinations

INTEGRATION:
============
- Feeds scores to CODE 32's move evaluation
- Uses rack analysis from CODE 42
- Results cached by CODE 36
```
