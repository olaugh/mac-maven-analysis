# CODE 39 Detailed Analysis - Letter Combination Scoring

## Overview

| Property | Value | Verified |
|----------|-------|----------|
| Size | 1788 bytes (1784 code + 4 header) | YES |
| JT Offset | 2608 | YES |
| JT Entries | 4 | YES |
| Functions | 5 | YES |
| Purpose | **Letter combination scoring for leave evaluation** | YES |

## System Role

**Category**: Scoring
**Function**: Letter Combinations

CODE 39 implements the letter synergy scoring component of Maven's leave evaluation system. It uses a massive 9632-byte stack frame for exhaustive letter combination analysis.

**Related CODE resources**:
- CODE 32 (leave calculation - consumes synergy scores)
- CODE 42 (rack analysis - provides rack data)
- CODE 2 (initialization - allocates score tables)

---

## Function Summary (Binary Verified)

| Offset | Frame | Registers | Name |
|--------|-------|-----------|------|
| 0x0000 | 22 | D3-D7/A2-A4 | init_letter_pair_search |
| 0x018C | 9632 | D3-D7/A2-A4 | full_combination_analysis |
| 0x0516 | 0 | D7/A4 | get_pair_scores |
| 0x0572 | 20 | D3-D7/A2-A4 | extended_score_calculation |
| 0x0688 | 0 | D6/D7/A4 | combined_score_wrapper |

---

## Global Variables (Verified by Pattern Matching)

### Score Tables (Allocated by CODE 2, 2304 bytes each)

| Offset | Hex | Name | Occurrences |
|--------|-----|------|-------------|
| A5-12532 | CF0C | g_horiz_scores1 | 6 |
| A5-12528 | CF10 | g_horiz_scores2 | 4 |
| A5-12524 | CF14 | g_horiz_scores3 | 3 |
| A5-12520 | CF18 | g_vert_scores1 | 3 |
| A5-12516 | CF1C | g_vert_scores2 | 6 |
| A5-12512 | CF20 | g_vert_scores3 | 3 |

### Letter Pair Data

| Offset | Hex | Name | Occurrences |
|--------|-----|------|-------------|
| A5-13060 | CCFC | g_letter_pair_table | 2 |
| A5-13062 | CCFA | g_letter_pair_count | 2 |

### Results Arrays

| Offset | Hex | Name | Occurrences |
|--------|-----|------|-------------|
| A5-22696 | A758 | g_results_score | 2 |
| A5-22698 | A756 | g_results_array | 4 |

---

## Function 0x0000 - init_letter_pair_search

### Binary Verification
```
File offset 0x0004: 4E56 FFEA = LINK A6,#-22
File offset 0x0008: 48E7 1F38 = MOVEM.L D3-D7/A2-A4,-(SP)
```

### Verified Disassembly
```asm
; void init_letter_pair_search(int8 param1, char* rack, int16 position,
;                              int32* out1, int32* out2)
; Stack: 8(A6)=param1, 12(A6)=rack, 16(A6)=position,
;        20(A6)=out1, 24(A6)=out2

0000: 4E56 FFEA      LINK     A6,#-22
0004: 48E7 1F38      MOVEM.L  D3-D7/A2-A4,-(SP)

; Initialize rack via JT[3522]
0008: 2F2E 000C      MOVE.L   12(A6),-(SP)       ; push rack
000C: 4EAD 0DC2      JSR      3522(A5)           ; init_rack_info(rack)
0010: 204D           MOVEA.L  A5,A0
0012: E588           LSL.L    #2,D0
0014: D1C0           ADDA.L   D0,A0

; Set processed flag mask
0016: 3A3C 0080      MOVE.W   #$0080,D5          ; D5 = PROCESSED_FLAG
001A: 9A68 99D8      SUBA.W   -26152(A0),D5      ; adjust for rack

; Clear output pointers
001E: 206E 0018      MOVEA.L  24(A6),A0          ; A0 = out2
0022: 4290           CLR.L    (A0)               ; *out2 = 0
0024: 226E 0014      MOVEA.L  20(A6),A1          ; A1 = out1
0028: 4291           CLR.L    (A1)               ; *out1 = 0

; Setup letter iteration
002A: 7019           MOVEQ    #25,D0             ; 26 letters (0-25)
002C: D0AE 0008      ADD.L    8(A6),D0           ; add param1
0030: 2840           MOVEA.L  D0,A4              ; A4 = letter pointer

; Get cross-check for current letter
0038: 3F3C 007F      MOVE.W   #$007F,-(SP)       ; mask
003C: 4EAD 09AA      JSR      2474(A5)           ; get_crosscheck()
0040: 8045           OR.W     D5,D0              ; set processed flag
0042: 3D40 FFF2      MOVE.W   D0,-14(A6)         ; store combined_mask

; Initialize loop counter
0046: 7C00           MOVEQ    #0,D6              ; D6 = 0
0048: 306E 0010      MOVE.W   16(A6),D0          ; D0 = position
004C: D1C8           ADDA.L   A0,A0
004E: 2D48 FFEE      MOVE.L   A0,-18(A6)         ; store position ptr

; Load letter pair table
0058: 45ED CCFC      LEA      -13060(A5),A2      ; A2 = g_letter_pair_table
005C: D4C6           ADDA.W   D6,A2              ; index into table
005E: D4C6           ADDA.W   D6,A2              ; *2 for word entries

; === MAIN LOOP ===
loop_start:
0066: 3612           MOVE.W   (A2),D3            ; D3 = entry
0068: 3005           MOVE.W   D5,D0              ; D0 = processed flag
006A: C043           AND.W    D3,D0              ; test processed bit
006C: B045           CMP.W    D5,D0
006E: 6600 0108      BNE.W    loop_continue      ; skip if processed

; Check results array for this entry
0072: 204D           MOVEA.L  A5,A0
0074: 2003           MOVE.L   D3,D0
0076: 48C0           EXT.L    D0
0078: E588           LSL.L    #2,D0              ; *4 for long entries
007A: D1C0           ADDA.L   D0,A0
007C: 4AA8 A756      TST.L    -22698(A0)         ; g_results_array[entry]
0080: 6700 00F6      BEQ.W    loop_continue      ; skip if no result

; Get cross-check value for this pair
0084: 3F12           MOVE.W   (A2),-(SP)         ; push entry
0086: 3F3C 007F      MOVE.W   #$007F,-(SP)       ; push mask
008A: 4EAD 09AA      JSR      2474(A5)           ; get_crosscheck()
008E: 8045           OR.W     D5,D0              ; set processed
0090: 3600           MOVE.W   D0,D3              ; D3 = cross_val | PROCESSED

; Calculate score table index
00A4: 7012           MOVEQ    #18,D0             ; ESTR record size
00A6: C1C3           MULU     D3,D0              ; idx = entry * 18
00AA: D0AD CF0C      ADD.L    -12532(A5),D0      ; add g_horiz_scores1 base

; Look up in score tables and compare
00CE: 4EAD 09B2      JSR      2482(A5)           ; compare_scores()
00D2: 3600           MOVE.W   D0,D3
00D4: 0C43 007F      CMPI.W   #$007F,D3          ; check for max
00DA: 6632           BNE.S    not_max

; Handle maximum score case
00FA: 206D CF1C      MOVEA.L  -12516(A5),A0      ; g_vert_scores2
00FE: 41E8 08EE      LEA      2286(A0),A0        ; fixed offset

not_max:
; Update output pointers if better
010E: 206E 0014      MOVEA.L  20(A6),A0          ; out1
...

loop_continue:
017A: 548A           ADDQ.L   #2,A2              ; next entry (word)
017C: BC6D CCFA      CMP.W    -13062(A5),D6      ; vs g_letter_pair_count
0180: 6D00 FEE4      BLT.W    loop_start         ; continue loop

; Return
0184: 4CDF 1CF8      MOVEM.L  (SP)+,D3-D7/A2-A4
0188: 4E5E           UNLK     A6
018A: 4E75           RTS
```

### Speculative C Decompilation
```c
/*
 * init_letter_pair_search - Initialize letter pair scoring iteration
 *
 * Iterates through the letter pair table, checking each pair against
 * the results array. For valid pairs, calculates scores using the
 * ESTR score tables and updates output pointers with best scores.
 *
 * Parameters:
 *   param1   - Initial parameter (added to letter index)
 *   rack     - Player's rack letters
 *   position - Board position being evaluated
 *   out1     - Output pointer for first score
 *   out2     - Output pointer for second score
 */
void init_letter_pair_search(int8_t param1, char* rack, int16_t position,
                             int32_t* out1, int32_t* out2)
{
    /* Local variables: 22 bytes */
    int16_t combined_mask;      /* -14(A6) */
    void*   position_ptr;       /* -18(A6) */

    const uint16_t PROCESSED_FLAG = 0x0080;

    /* Initialize rack information */
    init_rack_info(rack);  /* JT[3522] */

    /* Clear outputs */
    *out1 = 0;
    *out2 = 0;

    /* Get initial cross-check value */
    combined_mask = get_crosscheck(0x007F) | PROCESSED_FLAG;

    /* Iterate through letter pair table */
    for (int i = 0; i < g_letter_pair_count; i++) {
        uint16_t entry = g_letter_pair_table[i];

        /* Skip if already processed */
        if (entry & PROCESSED_FLAG) {
            continue;
        }

        /* Skip if no result for this pair */
        if (g_results_array[entry] == 0) {
            continue;
        }

        /* Get cross-check value for this pair */
        int16_t cross_val = get_crosscheck(entry & 0x7F) | PROCESSED_FLAG;

        /* Calculate score table index (entry * 18 bytes per ESTR record) */
        int idx = cross_val * 18;

        /* Look up and compare scores from tables */
        int16_t cmp = compare_scores(PROCESSED_FLAG, cross_val, combined_mask);

        if (cmp == 0x7F) {
            /* Maximum score case - use alternate table */
            int16_t alt_score = g_vert_scores2[2286 / 18].value;
            /* Update outputs */
        }

        /* Update output pointers if this score is better */
        /* ... */
    }
}
```

---

## Function 0x018C - full_combination_analysis

### Binary Verification
```
File offset 0x0190: 4E56 DA60 = LINK A6,#-9632  (MASSIVE frame!)
File offset 0x0194: 48E7 1F38 = MOVEM.L D3-D7/A2-A4,-(SP)
```

The **9632-byte stack frame** is the largest in Maven, used for exhaustive letter combination enumeration.

### Verified Disassembly
```asm
; void full_combination_analysis(int16 direction, void* position)
; Stack: 8(A6)=direction, 10(A6)=position

018C: 4E56 DA60      LINK     A6,#-9632          ; MASSIVE stack frame!
0190: 48E7 1F38      MOVEM.L  D3-D7/A2-A4,-(SP)

; Check direction flag for table selection
0194: 4A6E 0008      TST.W    8(A6)              ; test direction
0198: 6714           BEQ.S    use_vert_tables    ; if 0, use vertical

; === HORIZONTAL: direction != 0 ===
use_horiz_tables:
019A: 2D6D CF0C DA84 MOVE.L   -12532(A5),-9596(A6)  ; local1 = g_horiz_scores1
01A0: 2D6D CF10 DA76 MOVE.L   -12528(A5),-9610(A6)  ; local2 = g_horiz_scores2
01A6: 2D6D CF14 DA7C MOVE.L   -12524(A5),-9604(A6)  ; local3 = g_horiz_scores3
01AC: 6012           BRA.S    tables_selected

; === VERTICAL: direction == 0 ===
use_vert_tables:
01AE: 2D6D CF18 DA84 MOVE.L   -12520(A5),-9596(A6)  ; local1 = g_vert_scores1
01B4: 2D6D CF1C DA76 MOVE.L   -12516(A5),-9610(A6)  ; local2 = g_vert_scores2
01BA: 2D6D CF20 DA7C MOVE.L   -12512(A5),-9604(A6)  ; local3 = g_vert_scores3

tables_selected:
; Initialize position and rack
01C0: 2F2E 000A      MOVE.L   10(A6),-(SP)       ; push position
01C4: 4EAD 0AAA      JSR      2730(A5)           ; init_position() JT[2730]
01C8: 2EAE 000A      MOVE.L   10(A6),(SP)        ; reuse stack slot
01CC: 4EAD 0DC2      JSR      3522(A5)           ; init_rack_info() JT[3522]

; Setup processed mask
01D0: 204D           MOVEA.L  A5,A0
01D6: 303C 0080      MOVE.W   #$0080,D0          ; PROCESSED_FLAG
01DE: 3D40 DA74      MOVE.W   D0,-9612(A6)       ; store mask

; Initialize pair counter
01E2: 7600           MOVEQ    #0,D3
01E4: 3D43 DA7A      MOVE.W   D3,-9606(A6)       ; pair_count = 0

; === PASS 1: Collect valid letter pairs ===
01E8: 45ED CCFC      LEA      -13060(A5),A2      ; A2 = g_letter_pair_table
01EC: D4C3           ADDA.W   D3,A2
01EE: D4C3           ADDA.W   D3,A2              ; *2 for word entries

pass1_loop:
01F4: 3812           MOVE.W   (A2),D4            ; D4 = entry
01F6: 707F           MOVEQ    #127,D0
01F8: 8044           OR.W     D4,D0
01FA: 0C40 007F      CMPI.W   #$007F,D0          ; validate entry
01FE: 6704           BEQ.S    pass1_valid
0200: 4EAD 01A2      JSR      418(A5)            ; bounds_error()

pass1_valid:
0204: 302E DA74      MOVE.W   -9612(A6),D0       ; D0 = processed_mask
0208: C044           AND.W    D4,D0              ; test processed bit
020A: B06E DA74      CMP.W    -9612(A6),D0
020E: 6612           BNE.S    pass1_next         ; skip if processed

; Store valid pair
0210: 302E DA7A      MOVE.W   -9606(A6),D0       ; D0 = pair_count
0214: 526E DA7A      ADDQ.W   #1,-9606(A6)       ; pair_count++
021C: 3144 FEFC      MOVE.W   D4,-260(A0)        ; valid_pairs[count] = entry

pass1_next:
0222: 5243           ADDQ.W   #1,D3              ; i++
0224: 548A           ADDQ.L   #2,A2              ; next entry
0226: B66D CCFA      CMP.W    -13062(A5),D3      ; vs g_letter_pair_count
022A: 6DC8           BLT.S    pass1_loop

; === PASS 2: Generate pair combinations ===
022C: 45EE DC9C      LEA      -9060(A6),A2       ; combination buffer
0230: 7600           MOVEQ    #0,D3              ; outer counter
0232: 47EE FEFC      LEA      -260(A6),A3        ; valid_pairs array
0236: 41EE DA98      LEA      -9576(A6),A0       ; results pointers
023A: 2D48 DA88      MOVE.L   A0,-9592(A6)

pass2_outer:
0240: 206E DA88      MOVEA.L  -9592(A6),A0
0244: 208A           MOVE.L   A2,(A0)            ; store combo ptr
0246: 3813           MOVE.W   (A3),D4            ; D4 = pair1
0248: 3A03           MOVE.W   D3,D5              ; inner counter

pass2_inner:
0256: 2047           MOVEA.L  D7,A0
0258: 3C10           MOVE.W   (A0),D6            ; D6 = pair2
025A: 3004           MOVE.W   D4,D0
025C: 8046           OR.W     D6,D0              ; combine pairs
0260: 6626           BNE.S    pass2_inner_next   ; skip if invalid

; Check results array
0262: 204D           MOVEA.L  A5,A0
026C: 4AA8 A756      TST.L    -22698(A0)         ; g_results_array
0270: 6716           BEQ.S    pass2_inner_next   ; skip if no result

; Store valid combination
0272: 3F06           MOVE.W   D6,-(SP)
0274: 3F04           MOVE.W   D4,-(SP)
0276: 4EAD 09AA      JSR      2474(A5)           ; get_crosscheck()
027A: 806E DA74      OR.W     -9612(A6),D0       ; set processed
027E: 3480           MOVE.W   D0,(A2)            ; store combo
0280: 3546 0002      MOVE.W   D6,2(A2)           ; store pair2
0284: 588A           ADDQ.L   #4,A2              ; advance combo ptr

pass2_inner_next:
028C: B66E DA7A      CMP.W    -9606(A6),D3       ; vs pair_count
0290: 6DC4           BLT.S    pass2_inner

0292: 5243           ADDQ.W   #1,D3              ; outer++
029A: B66E DA7A      CMP.W    -9606(A6),D3
029E: 6DA0           BLT.S    pass2_outer

; === PASS 3: Calculate base scores ===
02B6: 3812           MOVE.W   (A2),D4            ; get combination
02B8: 7012           MOVEQ    #18,D0             ; ESTR record size
02BA: C1C4           MULU     D4,D0              ; idx = entry * 18

; Add scores from three tables
02C0: 204B           MOVEA.L  A3,A0
02C2: D1EE DA84      ADDA.L   -9596(A6),A0       ; + table1 base
02C6: 4250           CLR.W    (A0)               ; clear result
02C8: 204B           MOVEA.L  A3,A0
02CA: D1EE DA7C      ADDA.L   -9604(A6),A0       ; + table3 base
02CE: 4250           CLR.W    (A0)
02D0: 204D           MOVEA.L  A5,A0
02D2: D0C4           ADDA.W   D4,A0
02D4: D0C4           ADDA.W   D4,A0
02D6: 224B           MOVEA.L  A3,A1
02D8: D3EE DA76      ADDA.L   -9610(A6),A1       ; + table2 base
02DC: 32A8 CBFA      MOVE.W   -13318(A0),(A1)    ; copy score

; === PASS 4+: Extended scoring iterations ===
02E8: 3D7C 0001 DA74 MOVE.W   #1,-9612(A6)       ; reset mask
02EE: 3D7C 0001 DA6A MOVE.W   #1,-9622(A6)       ; iteration = 1
02F4: 7002           MOVEQ    #2,D0
02F6: 2D40 DA88      MOVE.L   D0,-9592(A6)       ; max_depth = 2

; Extended iteration loops (complex nested scoring)
; ... (many nested loops for 3, 4, 5, 6, 7 letter combinations)

; Final aggregation
049C: 7600           MOVEQ    #0,D3
049E: 3E2E DA6A      MOVE.W   -9622(A6),D7       ; iteration count
04A2: 48C7           EXT.L    D7
04A4: DE87           ADD.L    D7,(SP)            ; add to running total
04A6: 45EE FEFC      LEA      -260(A6),A2        ; valid_pairs

; Final score calculation
04B0: 3812           MOVE.W   (A2),D4
04B2: 7012           MOVEQ    #18,D0
04B4: C1C4           MULU     D4,D0
...

; Return
050E: 4CDF 1CF8      MOVEM.L  (SP)+,D3-D7/A2-A4
0512: 4E5E           UNLK     A6
0514: 4E75           RTS
```

### Stack Frame Layout (9632 bytes)

| Offset | Size | Name | Purpose |
|--------|------|------|---------|
| -9596 | 4 | score_table1 | Local copy of selected table 1 |
| -9604 | 4 | score_table3 | Local copy of selected table 3 |
| -9610 | 4 | score_table2 | Local copy of selected table 2 |
| -9612 | 2 | processed_mask | Current processing mask |
| -9606 | 2 | pair_count | Number of valid pairs found |
| -9622 | 2 | iteration_counter | Extended scoring iteration |
| -9592 | 4 | results_ptr | Pointer to results storage |
| -9576 | ~8500 | results_storage | Combination results |
| -9060 | ~8800 | combination_buffer | Pair combinations |
| -260 | 260 | valid_pairs | Array of valid pair indices |

### Speculative C Decompilation
```c
/*
 * full_combination_analysis - Exhaustive letter combination scoring
 *
 * This is Maven's most memory-intensive function, using a 9632-byte
 * stack frame to enumerate and score all valid letter combinations.
 *
 * The algorithm has multiple passes:
 *   Pass 1: Collect valid (unprocessed) letter pairs
 *   Pass 2: Generate all pairwise combinations
 *   Pass 3: Calculate base scores from ESTR tables
 *   Pass 4+: Iteratively refine scores for longer combinations
 *
 * Parameters:
 *   direction - 0 for vertical (hook-before), non-zero for horizontal (hook-after)
 *   position  - Board position data
 */
void full_combination_analysis(int16_t direction, void* position)
{
    /* MASSIVE stack frame: 9632 bytes */
    ESTRRecord* table1;              /* -9596: Selected score table 1 */
    ESTRRecord* table2;              /* -9610: Selected score table 2 */
    ESTRRecord* table3;              /* -9604: Selected score table 3 */
    uint16_t    processed_mask;      /* -9612: Processing flag */
    uint16_t    pair_count;          /* -9606: Valid pairs found */
    uint16_t    iteration;           /* -9622: Iteration counter */
    void*       results_ptr;         /* -9592: Results pointer */
    int32_t     results_storage[2125]; /* -9576: ~8500 bytes */
    uint16_t    combinations[2200];  /* -9060: ~8800 bytes */
    uint16_t    valid_pairs[130];    /* -260: Valid pair indices */

    /*
     * Select score tables based on direction
     *
     * Horizontal (hook-after): Letters placed AFTER anchor
     *   - Uses horiz tables at A5-12524, A5-12528, A5-12532
     *
     * Vertical (hook-before): Letters placed BEFORE anchor
     *   - Uses vert tables at A5-12512, A5-12516, A5-12520
     */
    if (direction != 0) {
        /* Horizontal - hook-after */
        table1 = g_horiz_scores1;  /* A5-12532 */
        table2 = g_horiz_scores2;  /* A5-12528 */
        table3 = g_horiz_scores3;  /* A5-12524 */
    } else {
        /* Vertical - hook-before */
        table1 = g_vert_scores1;   /* A5-12520 */
        table2 = g_vert_scores2;   /* A5-12516 */
        table3 = g_vert_scores3;   /* A5-12512 */
    }

    /* Initialize position and rack */
    init_position(position);    /* JT[2730] */
    init_rack_info(position);   /* JT[3522] */

    processed_mask = 0x0080;

    /*
     * PASS 1: Collect valid letter pairs
     *
     * Iterate through g_letter_pair_table, filtering out:
     * - Already processed pairs (bit 0x80 set)
     * - Invalid entries
     */
    pair_count = 0;
    for (int i = 0; i < g_letter_pair_count; i++) {
        uint16_t entry = g_letter_pair_table[i];

        /* Validate entry format */
        if ((entry | 0x7F) != 0x7F) {
            bounds_error();  /* JT[418] */
        }

        /* Skip if processed */
        if (entry & processed_mask) {
            continue;
        }

        valid_pairs[pair_count++] = entry;
    }

    /*
     * PASS 2: Generate pair combinations
     *
     * Nested loops create all valid pairwise combinations.
     * Each combination is validated against g_results_array.
     */
    int combo_count = 0;
    for (int i = 0; i < pair_count; i++) {
        uint16_t pair1 = valid_pairs[i];

        for (int j = 0; j < pair_count; j++) {
            uint16_t pair2 = valid_pairs[j];
            uint16_t combined = pair1 | pair2;

            /* Check if valid combination exists in results */
            if (g_results_array[combined] == 0) {
                continue;
            }

            /* Get cross-check value */
            int16_t cross_val = get_crosscheck(pair1, 0x7F);
            cross_val |= processed_mask;

            /* Store combination */
            combinations[combo_count * 2] = cross_val;
            combinations[combo_count * 2 + 1] = pair2;
            combo_count++;
        }
    }

    /*
     * PASS 3: Calculate base scores
     *
     * For each combination, sum scores from all three tables.
     * Index = entry * 18 (ESTR record size)
     */
    for (int i = 0; i < combo_count; i++) {
        uint16_t combo = combinations[i * 2];
        int idx = combo * 18;

        results_storage[i] = table1[idx / 18].value +
                             table2[idx / 18].value +
                             table3[idx / 18].value;
    }

    /*
     * PASS 4+: Extended scoring
     *
     * Iteratively refine scores for combinations of 3, 4, 5, 6, 7 letters.
     * Each iteration adds synergy bonuses from additional table fields.
     */
    iteration = 1;
    while (iteration <= 7) {  /* Max rack size */
        processed_mask = 0;

        for (int i = 0; i < combo_count; i++) {
            uint16_t combo = combinations[i * 2];
            int idx = combo * 18;

            /* Add iteration-specific synergy bonus */
            results_storage[i] += table1[idx / 18].synergy[iteration - 1] +
                                  table2[idx / 18].synergy[iteration - 1];
        }

        iteration++;
    }

    /*
     * Final aggregation
     *
     * Combine all scores and update output structures
     */
    for (int i = 0; i < pair_count; i++) {
        uint16_t pair = valid_pairs[i];
        int idx = pair * 18;

        int final_score = table1[idx / 18].value +
                          table2[idx / 18].position_mult +
                          table3[idx / 18].position_mult;

        /* Store final results */
        /* ... */
    }
}
```

---

## Function 0x0516 - get_pair_scores

### Binary Verification
```
File offset 0x051A: 4E56 0000 = LINK A6,#0
File offset 0x051E: 48E7 0108 = MOVEM.L D7/A4,-(SP)
```

### Verified Disassembly
```asm
; int16 get_pair_scores(uint16 pair, int16* out1, int16* out2)
; Stack: 8(A6)=pair, 10(A6)=out1, 14(A6)=out2

0516: 4E56 0000      LINK     A6,#0
051A: 48E7 0108      MOVEM.L  D7/A4,-(SP)

; Clear first output
051E: 206E 000A      MOVEA.L  10(A6),A0          ; A0 = out1
0522: 4250           CLR.W    (A0)               ; *out1 = 0

; Calculate index = pair * 18
0524: 7012           MOVEQ    #18,D0             ; ESTR record size
0526: C1EE 0008      MULU     8(A6),D0           ; idx = pair * 18
052A: 2840           MOVEA.L  D0,A4              ; A4 = idx

; Look up in horiz_scores3
052C: 202D CF14      MOVE.L   -12524(A5),D0      ; D0 = g_horiz_scores3
0530: 226E 000E      MOVEA.L  14(A6),A1          ; A1 = out2
0534: 32B4 0810      MOVE.W   16(A4,D0.L),(A1)   ; *out2 = table[idx+16]

; Look up in horiz_scores2
0538: 7012           MOVEQ    #18,D0
053A: C1EE 0008      MULU     8(A6),D0
053E: 206D CF10      MOVEA.L  -12528(A5),A0      ; A0 = g_horiz_scores2
0542: 3E30 0810      MOVE.W   16(A0,D0.L),D7     ; D7 = table[idx+16]

; Handle zero case - use vert_scores2 instead
0546: 4A47           TST.W    D7
0548: 6706           BEQ.S    use_vert           ; if zero, branch
054A: 3007           MOVE.W   D7,D0
054C: 4440           NEG.W    D0                 ; negate
054E: 6008           BRA.S    combine

use_vert:
0550: 206D CF1C      MOVEA.L  -12516(A5),A0      ; A0 = g_vert_scores2
0554: 3028 08EE      MOVE.W   2286(A0),D0        ; fixed offset 2286

combine:
; Combine scores from multiple tables
0558: 206D CF1C      MOVEA.L  -12516(A5),A0      ; g_vert_scores2
055C: 222D CF0C      MOVE.L   -12532(A5),D1      ; g_horiz_scores1
0560: 3428 08EE      MOVE.W   2286(A0),D2
0564: D474           ADD.W    (A4),D2            ; add from A4
0566: 1810           MOVE.B   (A0),D4
0568: D042           ADD.W    D2,D0              ; accumulate

056A: 4CDF 1080      MOVEM.L  (SP)+,D7/A4
056E: 4E5E           UNLK     A6
0570: 4E75           RTS
```

### Speculative C Decompilation
```c
/*
 * get_pair_scores - Get score components for a letter pair
 *
 * Looks up scores from multiple ESTR tables and combines them.
 * Uses a fixed offset (2286) for alternate lookups when the
 * primary lookup returns zero.
 *
 * Parameters:
 *   pair - Letter pair value (0-127)
 *   out1 - Output for first score component
 *   out2 - Output for second score component
 *
 * Returns:
 *   Combined score value
 */
int16_t get_pair_scores(uint16_t pair, int16_t* out1, int16_t* out2)
{
    int idx = pair * 18;  /* ESTR record size */

    *out1 = 0;

    /* Get position multiplier from horiz_scores3 */
    *out2 = g_horiz_scores3[idx / 18].position_mult;  /* offset 16 */

    /* Get letter score from horiz_scores2 */
    int16_t letter_score = g_horiz_scores2[idx / 18].position_mult;

    int16_t base_score;
    if (letter_score == 0) {
        /* Use fixed offset in vert_scores2 */
        base_score = g_vert_scores2[2286 / 18].value;
    } else {
        base_score = -letter_score;  /* Negate */
    }

    /* Combine scores */
    int16_t combined = g_horiz_scores1[idx / 18].position_mult +
                       g_vert_scores2[2286 / 18].value +
                       base_score;

    return combined;
}
```

---

## Function 0x0572 - extended_score_calculation

### Binary Verification
```
File offset 0x0576: 4E56 FFEC = LINK A6,#-20
File offset 0x057A: 48E7 1F38 = MOVEM.L D3-D7/A2-A4,-(SP)
```

### Verified Disassembly
```asm
; int16 extended_score_calculation(uint16 pair1, uint16 pair2,
;                                  int16* out1, int16* out2)
; Stack: 8(A6)=pair1, 10(A6)=pair2, 12(A6)=out1, 16(A6)=out2

0572: 4E56 FFEC      LINK     A6,#-20
0576: 48E7 1F38      MOVEM.L  D3-D7/A2-A4,-(SP)

; Calculate indices for both pairs
057A: 7012           MOVEQ    #18,D0
057C: C1EE 0008      MULU     8(A6),D0           ; idx1 = pair1 * 18
0580: 2840           MOVEA.L  D0,A4              ; A4 = idx1

0588: 7012           MOVEQ    #18,D0
058A: C1EE 000A      MULU     10(A6),D0          ; idx2 = pair2 * 18
058E: 2440           MOVEA.L  D0,A2              ; A2 = idx2

; Load table pointers
0590: 2E2D CF1C      MOVE.L   -12516(A5),D7      ; D7 = g_vert_scores2
0596: 2C2D CF0C      MOVE.L   -12532(A5),D6      ; D6 = g_horiz_scores1

; Setup for indexed table access
05A0: 204A           MOVEA.L  A2,A0
05A2: D1ED CF18      ADDA.L   -12520(A5),A0      ; A0 = g_vert_scores1 + idx2
05A6: 2D48 FFEC      MOVE.L   A0,-20(A6)

; Get initial values
05B0: 3429 0010      MOVE.W   16(A1),D2          ; offset 16 value
05BC: 3A2B 0010      MOVE.W   16(A3),D5

; Store initial outputs
05DA: 206E 000C      MOVEA.L  12(A6),A0          ; out1
05DE: 30AC 0010      MOVE.W   16(A4),(A0)        ; *out1 = table[idx1+16]

05E2: 226E FFF0      MOVEA.L  -16(A6),A1
05E6: 206E 0010      MOVEA.L  16(A6),A0          ; out2
05EA: 30A9 0010      MOVE.W   16(A1),(A0)        ; *out2 = table[idx2+16]

; 7-iteration refinement loop
05EE: 7A07           MOVEQ    #7,D5              ; 7 iterations
05F0: 347C 000E      MOVEA.W  #14,A2             ; offset = 14

iteration_loop:
05F8: 4A72 7800      TST.W    0(A2,D7.L)         ; check vert_scores2[offset]
05FC: 6632           BNE.S    skip_update1       ; skip if non-zero

; Update score if better
05FE: 204B           MOVEA.L  A3,A0
0618: 3803           MOVE.W   D3,D4              ; save best
061A: 204C           MOVEA.L  A4,A0
0620: 226E 000C      MOVEA.L  12(A6),A1          ; out1
0624: 3290           MOVE.W   (A0),(A1)          ; update *out1

skip_update1:
0630: 204B           MOVEA.L  A3,A0
0636: 663C           BNE.S    skip_update2       ; skip if non-zero

; Similar update for second pair
0638: 345C           MOVEA.W  (A4)+,A2
...

skip_update2:
0674: 5345           SUBQ.W   #1,D5              ; decrement counter
0678: 4A45           TST.W    D5
067A: 6E00 FF7C      BGT.W    iteration_loop     ; continue if > 0

; Return best score
067E: 3004           MOVE.W   D4,D0
0680: 4CDF 1CF8      MOVEM.L  (SP)+,D3-D7/A2-A4
0684: 4E5E           UNLK     A6
0686: 4E75           RTS
```

### Speculative C Decompilation
```c
/*
 * extended_score_calculation - Calculate scores for pair of letter pairs
 *
 * Used for multi-letter combination evaluation. Iterates through
 * 7 synergy bonus fields, updating outputs when better scores found.
 *
 * Parameters:
 *   pair1 - First letter pair
 *   pair2 - Second letter pair
 *   out1  - Output for first score
 *   out2  - Output for second score
 *
 * Returns:
 *   Best score found
 */
int16_t extended_score_calculation(uint16_t pair1, uint16_t pair2,
                                   int16_t* out1, int16_t* out2)
{
    /* Local variables: 20 bytes */
    void* table_ptr;  /* -20(A6) */

    int idx1 = pair1 * 18;
    int idx2 = pair2 * 18;

    ESTRRecord* entry1 = &g_horiz_scores2[idx1 / 18];
    ESTRRecord* entry2 = &g_vert_scores1[idx2 / 18];

    /* Get initial values from position_mult field (offset 16) */
    *out1 = entry1->position_mult;
    *out2 = entry2->position_mult;

    int16_t best_score = entry1->value;

    /*
     * Iterate through 7 synergy bonus fields
     *
     * Each field represents additional synergy for combinations
     * of that many letters (2-8 letters total).
     */
    for (int i = 7; i > 0; i--) {
        /* Check if vert_scores2 entry at offset i is zero */
        int16_t* vert_ptr = (int16_t*)((char*)g_vert_scores2 + idx1 + (i * 2));

        if (*vert_ptr == 0) {
            /* Calculate adjusted score */
            int16_t adj_score = entry1->position_mult + /* adjustment */;

            if (adj_score > best_score) {
                best_score = adj_score;
                *out1 = g_horiz_scores1[idx1 / 18].synergy[i - 1];
            }
        }

        /* Similar check for second pair */
        int16_t* horiz_ptr = (int16_t*)((char*)g_horiz_scores1 + idx2 + (i * 2));

        if (*horiz_ptr == 0) {
            /* Update second output if better */
            /* ... */
        }
    }

    return best_score;
}
```

---

## Function 0x0688 - combined_score_wrapper

### Binary Verification
```
File offset 0x068C: 4E56 0000 = LINK A6,#0
File offset 0x0690: 48E7 0308 = MOVEM.L D6/D7/A4,-(SP)
```

### Verified Disassembly
```asm
; int16 combined_score_wrapper(uint16 pair, uint16 direction,
;                              int16* out1, int16* out2)
; Stack: 8(A6)=pair, 10(A6)=direction, 12(A6)=out1, 16(A6)=out2

0688: 4E56 0000      LINK     A6,#0
068C: 48E7 0308      MOVEM.L  D6/D7/A4,-(SP)

; Get direction parameter
0690: 3C2E 000A      MOVE.W   10(A6),D6          ; D6 = direction

; Call extended_score_calculation
0694: 2F2E 0010      MOVE.L   16(A6),-(SP)       ; push out2
0698: 2F2E 000C      MOVE.L   12(A6),-(SP)       ; push out1
069C: 3F06           MOVE.W   D6,-(SP)           ; push direction
069E: 3F2E 0008      MOVE.W   8(A6),-(SP)        ; push pair
06A2: 4EBA FECE      JSR      -306(PC)           ; call 0x0572

06A6: 3E00           MOVE.W   D0,D7              ; D7 = result

; Calculate direction index
06A8: 7012           MOVEQ    #18,D0
06AA: C1C6           MULU     D6,D0              ; idx = direction * 18
06AE: D0AD CF1C      ADD.L    -12516(A5),D0      ; + g_vert_scores2
06B2: 2840           MOVEA.L  D0,A4              ; A4 = ptr

; Look up in multiple tables
06B6: 206D CF20      MOVEA.L  -12512(A5),A0      ; A0 = g_vert_scores3
06BA: 7012           MOVEQ    #18,D0
06BC: C1C6           MULU     D6,D0
06BE: 226D CF18      MOVEA.L  -12520(A5),A1      ; A1 = g_vert_scores1

; Combine values
06C2: 3414           MOVE.W   (A4),D2            ; D2 = vert_scores2[dir]
06C4: D442           ADD.W    D2,D2              ; *2
06C6: D471 1810      ADD.W    16(A1,D1.L),D2     ; + vert_scores1[16]
06CA: B470 0810      CMP.W    16(A0,D0.L),D2     ; vs vert_scores3[16]

06CE: 4FEF 000C      LEA      12(SP),SP          ; clean stack
06D2: 661A           BNE.S    return             ; if not equal, return

; Equal case - calculate alternate
06D4: 7012           MOVEQ    #18,D0
06D6: C1EE 0008      MULU     8(A6),D0           ; idx = pair * 18
06DA: 206D CF0C      MOVEA.L  -12532(A5),A0      ; A0 = g_horiz_scores1
06DE: 3214           MOVE.W   (A4),D1
06E0: D241           ADD.W    D1,D1
06E2: D270 0810      ADD.W    16(A0,D0.L),D1     ; + horiz_scores1[16]
06E6: 9247           SUB.W    D7,D1              ; - previous result
06E8: 226E 000C      MOVEA.L  12(A6),A1          ; out1
06EC: 3281           MOVE.W   D1,(A1)            ; *out1 = alternate

return:
06EE: 3007           MOVE.W   D7,D0              ; return saved result
06F0: 4CDF 10C0      MOVEM.L  (SP)+,D6/D7/A4
06F4: 4E5E           UNLK     A6
06F6: 4E75           RTS
```

### Speculative C Decompilation
```c
/*
 * combined_score_wrapper - Wrapper combining multiple score lookups
 *
 * Calls extended_score_calculation, then performs additional
 * lookups and comparisons to potentially update output.
 *
 * Parameters:
 *   pair      - Letter pair value
 *   direction - Direction index (affects which tables used)
 *   out1      - Output for first score
 *   out2      - Output for second score
 *
 * Returns:
 *   Combined score from extended calculation
 */
int16_t combined_score_wrapper(uint16_t pair, uint16_t direction,
                               int16_t* out1, int16_t* out2)
{
    /* Call extended calculation */
    int16_t result = extended_score_calculation(pair, direction, out1, out2);

    /* Calculate direction-based index */
    int dir_idx = direction * 18;

    ESTRRecord* vert3 = &g_vert_scores3[dir_idx / 18];
    ESTRRecord* vert1 = &g_vert_scores1[dir_idx / 18];
    ESTRRecord* vert2 = &g_vert_scores2[dir_idx / 18];

    /* Combine values from vertical tables */
    int16_t combined = vert2->value * 2 + vert1->position_mult;

    /* Compare to vert_scores3 position multiplier */
    if (combined == vert3->position_mult) {
        /* Equal case - calculate alternate score */
        int pair_idx = pair * 18;
        ESTRRecord* horiz1 = &g_horiz_scores1[pair_idx / 18];

        int16_t alternate = vert2->value * 2 +
                            horiz1->position_mult -
                            result;

        *out1 = alternate;
    }

    return result;
}
```

---

## Data Structures

### ESTR Record (18 bytes)

Based on the code's use of 18-byte indexing and offset 16 access:

```c
typedef struct {
    int16_t value;           /* +0:  Base synergy value */
    int16_t synergy[7];      /* +2:  Seven synergy bonus fields */
    int16_t position_mult;   /* +16: Position multiplier */
} ESTRRecord;  /* Total: 18 bytes */
```

### Score Table Layout

Each of the 6 score tables contains 128 ESTR records (2304 bytes):

```c
/* Table allocation (CODE 2) */
g_horiz_scores1 = NewPtr(2304);  /* 128 * 18 bytes */
g_horiz_scores2 = NewPtr(2304);
g_horiz_scores3 = NewPtr(2304);
g_vert_scores1  = NewPtr(2304);
g_vert_scores2  = NewPtr(2304);
g_vert_scores3  = NewPtr(2304);
```

### Letter Pair Encoding

Letter pairs are encoded as 16-bit values:
- Bits 0-6: Letter pair index (0-127)
- Bit 7: Processed flag (0x80)

```c
#define PROCESSED_FLAG  0x0080
#define PAIR_MASK       0x007F
```

---

## Algorithm Summary

### Multi-Pass Combination Scoring

```
INPUT: Rack letters, board position, direction (horiz/vert)

PASS 1 - COLLECT PAIRS:
  For each entry in g_letter_pair_table:
    If not processed (bit 0x80 clear):
      Add to valid_pairs array

PASS 2 - GENERATE COMBINATIONS:
  For each pair1 in valid_pairs:
    For each pair2 in valid_pairs:
      combined = pair1 | pair2
      If g_results_array[combined] != 0:
        Store combination with cross-check value

PASS 3 - CALCULATE BASE SCORES:
  For each combination:
    index = entry * 18
    score = table1[index].value +
            table2[index].value +
            table3[index].value

PASS 4+ - EXTENDED SCORING:
  For iteration = 1 to 7:
    For each combination:
      Add synergy bonus from iteration field

OUTPUT: Scores stored in results arrays
```

---

## Integration with Leave Evaluation

CODE 39's synergy scores feed into CODE 32's leave calculation:

```
Total Leave Value =
    Sum(MUL per-tile values) +
    VCB vowel adjustment (currently disabled - FRST is zeros) +
    CODE 39 synergy scores
```

---

## Open Questions

### Score Table Population

The 6 score tables are allocated by CODE 2 but the code that populates them with actual synergy values has NOT been found:

| Step | Code | Status |
|------|------|--------|
| Allocation | CODE 2, JT[1666] | VERIFIED |
| Population | Unknown | NOT FOUND |
| Usage | CODE 39 (read-only) | VERIFIED |

Possibilities:
1. Tables computed lazily on first use
2. Populated by unidentified initialization code
3. Tables remain zero (synergy scoring disabled)

### ESTR Pattern Mapping

The ESTR resource contains 130 pattern strings, but score tables have 128 entries. The mapping between patterns and table indices is unclear.

---

## Confidence Assessment

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Function boundaries | HIGH | LINK/UNLK/RTS verified |
| Stack frame sizes | HIGH | From LINK displacements |
| Global variables | HIGH | Pattern matching verified |
| Instruction decode | MEDIUM-HIGH | Some complex addressing unclear |
| Algorithm structure | MEDIUM-HIGH | Multi-pass confirmed |
| C translations | MEDIUM | Structure verified, details speculative |
| Data flow | LOW | Table population unknown |
