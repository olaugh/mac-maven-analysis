# CODE 39 Detailed Analysis - Letter Combination Scoring

## Overview

| Property | Value |
|----------|-------|
| Size | 1,788 bytes (4-byte header + 1,784 bytes of code) |
| JT Offset | 0x0A30 (2608) |
| JT Entries | 4 |
| Functions | 5 |
| SANE Traps | 0 (pure integer arithmetic) |
| Purpose | **Letter combination scoring for leave evaluation** |

CODE 39 implements Maven's letter synergy scoring system. Unlike CODE 32 which
uses SANE floating-point for binomial-weighted MUL calculations, CODE 39 is
entirely integer/word arithmetic. It evaluates how well groups of letters work
together at specific board positions, producing synergy scores that feed into
the overall leave evaluation. The centerpiece is function 0x018C with its
9,632-byte stack frame -- the largest in Maven.

**Coordinates with**: CODE 32 (consumes synergy scores), CODE 2 (allocates
score tables), CODE 11/32/44/52 (via jump table).

---

## Function Table

| Code Offset | Frame Size | Registers Saved | Name | Purpose |
|-------------|-----------|-----------------|------|---------|
| 0x0000 | 22 | D3-D7/A2-A4 | `find_best_pair_score` | Search pairs for best position score |
| 0x018C | 9,632 | D3-D7/A2-A4 | `analyze_combinations` | Full multi-pass combination analysis |
| 0x0516 | 0 | D7/A4 | `lookup_pair_scores` | Read scores from ESTR tables |
| 0x0572 | 20 | D3-D7/A2-A4 | `score_pair_of_pairs` | Dual-pair scoring with synergy walk |
| 0x0688 | 0 | D6/D7/A4 | `adjusted_pair_score` | Wrapper with alternate-table adjustment |

---

## Data Structures

### ESTR Record (18 bytes)

Each of the six score tables contains 128 ESTR records (128 x 18 = 2,304 bytes).
The record stores a base value, seven synergy bonus fields (one for each possible
draw count 1-7), and a position multiplier.

```c
typedef struct {
    int16_t value;          /* +0:  Base score value (centipoints) */
    int16_t synergy[7];     /* +2:  Synergy bonuses for drawing 1-7 tiles */
    int16_t position_mult;  /* +16: Position-dependent multiplier */
} ESTRRecord;  /* 18 bytes total */
```

The code consistently uses `MOVEQ #18,D0; MULU pair,D0` to compute byte offsets
into these tables, and accesses offset +16 for the `position_mult` field.

### Score Tables (6 tables, 2,304 bytes each)

Tables are allocated by CODE 2 at startup and populated at runtime. They come
in two sets of three, selected by play direction:

```
Direction != 0 (horizontal):
    table_a = g_score_table1 (A5-12532)
    table_b = g_score_table2 (A5-12528)
    table_c = g_score_table3 (A5-12524)

Direction == 0 (vertical):
    table_a = g_score_table4 (A5-12520)
    table_b = g_score_table5 (A5-12516)
    table_c = g_score_table6 (A5-12512)
```

### Letter Pair Encoding

Letter pairs are stored as 16-bit values in `g_letter_pair_table`:

```
Bits 0-6:  Pair index (0-127), indexes into ESTR tables
Bit 7:     Processed flag (0x80), set after pair has been scored
```

```c
#define PROCESSED_FLAG  0x0080
#define PAIR_INDEX_MASK 0x007F
```

---

## Global Variables

### Score Table Pointers

| A5 Offset | Hex | Name | Purpose |
|-----------|-----|------|---------|
| A5-12532 | CF0C | `g_score_table1` | Horizontal table A (or primary set) |
| A5-12528 | CF10 | `g_score_table2` | Horizontal table B |
| A5-12524 | CF14 | `g_score_table3` | Horizontal table C |
| A5-12520 | CF18 | `g_score_table4` | Vertical table A (or alternate set) |
| A5-12516 | CF1C | `g_score_table5` | Vertical table B |
| A5-12512 | CF20 | `g_score_table6` | Vertical table C |

### Letter Pair Data

| A5 Offset | Hex | Name | Purpose |
|-----------|-----|------|---------|
| A5-13060 | CCFC | `g_letter_pair_table` | Array of 16-bit pair entries |
| A5-13062 | CCFA | `g_letter_pair_count` | Number of pairs in table |
| A5-13318 | CBFA | `g_pair_base_scores` | Base score array indexed by pair |

### Results Arrays

| A5 Offset | Hex | Name | Purpose |
|-----------|-----|------|---------|
| A5-22696 | A758 | `g_results_score` | Score results (int16 per pair) |
| A5-22698 | A756 | `g_results_array` | Results flags (int32 per pair) |

### Other

| A5 Offset | Hex | Name | Purpose |
|-----------|-----|------|---------|
| A5-26152 | 99D8 | `g_crosscheck_table` | Cross-check bitmask table |
| A5-12496 | CF30 | `g_alt_score_data` | Alternate scoring data (used in pass 4) |

---

## Jump Table Calls

| JT Offset | Name | Purpose |
|-----------|------|---------|
| 418 | `bounds_error()` | Runtime validation trap |
| 2474 | `get_crosscheck(entry, mask)` | Get cross-check bitmask for a letter pair |
| 2482 | `compare_scores(flag, val, mask)` | Compare scores against threshold |
| 2730 | `init_position(position)` | Initialize board position data |
| 3522 | `init_rack_info(rack)` | Initialize rack letter information |

---

## Function 0x0000 - find_best_pair_score

### Purpose

Given a board position and rack, iterates through all letter pairs in
`g_letter_pair_table`. For each unprocessed pair that has a nonzero result
in `g_results_array`, looks up its scores from the ESTR tables and tracks
the best score found. Returns the best score and best pair via output
pointers.

### Key Hex-Verified Sequences

```
File+0x04: 4E56 FFEA           LINK A6,#-22
File+0x08: 48E7 1F38           MOVEM.L D3-D7/A2-A4,-(SP)
File+0x10: 4EAD 0DC2           JSR 3522(A5)          ; init_rack_info()
File+0x16: E588                LSL.L #2,D0            ; (disasm merges with next)
File+0x18: D1C0                ADDA.L D0,A0
File+0x1A: 3A3C 0080           MOVE.W #$0080,D5       ; PROCESSED_FLAG
File+0x1E: 9A68 99D8           SUB.W -26152(A0),D5    ; crosscheck adjust
File+0x5C: 45ED CCFC           LEA -13060(A5),A2      ; g_letter_pair_table
File+0x80: 4AA8 A756           TST.L -22698(A0)       ; g_results_array[pair]
File+0xA8: 7012                MOVEQ #18,D0
File+0xAA: C1C3                MULU D3,D0             ; pair * 18
File+0xAC: D0AD CF0C           ADD.L g_score_table1,D0
File+0xD2: 4EAD 09B2           JSR 2482(A5)           ; compare_scores()
```

### C Decompilation

```c
/*
 * find_best_pair_score - Find the best-scoring letter pair for a position
 *
 * Iterates through all letter pairs, skipping already-processed ones.
 * For each valid pair with a nonzero result, computes its score from
 * the ESTR tables and updates the output pointers if it beats the
 * current best. Also tracks an alternate best score.
 */
void find_best_pair_score(int8_t param1, char *rack, int16_t position,
                          int16_t tiles_to_draw,
                          int32_t *best_score, int32_t *best_pair,
                          int32_t *alt_score, int32_t *alt_pair)
{
    init_rack_info(rack);

    /* Compute crosscheck-adjusted processing flag */
    int16_t proc_flag = PROCESSED_FLAG - g_crosscheck_table[/* derived */];

    *best_score = 0;
    *best_pair = 0;

    int16_t combined_mask = get_crosscheck(0x007F) | proc_flag;
    int32_t position_offset = position * 2;

    for (int i = 0; i < g_letter_pair_count; i++) {
        int16_t entry = g_letter_pair_table[i];

        if ((entry & proc_flag) == proc_flag)
            continue;  /* already processed */
        if (g_results_array[entry] == 0)
            continue;  /* no result */

        int16_t cross_val = get_crosscheck(entry & 0x7F) | proc_flag;

        /* Validate and look up ESTR score */
        int32_t table_offset = (int32_t)cross_val * 18;
        int16_t score1 = g_results_score[entry];
        int16_t raw_score = *(int16_t *)((char *)g_score_table1
                             + table_offset + position_offset) - score1;

        int16_t cmp_result = compare_scores(proc_flag, cross_val, combined_mask);

        if (cmp_result == 0x7F) {
            /* Max pair case: look up from table2 + table5[127] bonus */
            int16_t pos_val = *(int16_t *)((char *)g_score_table2
                               + table_offset + position);
            if (pos_val > 0) {
                int16_t bonus = *(int16_t *)((char *)g_score_table5
                                 + 2286 + position_offset);
                int16_t adj_score = (bonus + pos_val) * 2;
                if (adj_score > *best_pair)
                    *best_pair = adj_score;
            }
        }

        /* Standard path: combine table1 score with results data */
        int32_t d7_ptr = (int32_t)g_score_table1 + (int32_t)cross_val * 18;
        int16_t draw_score = g_results_array[entry].field_at_10;
        int16_t alt_cand = g_results_score[entry] + draw_score
                         - /* table adjustment */;

        if (alt_cand > *alt_pair) {
            *alt_score = cmp_result;
            *alt_pair = alt_cand;
        }
    }
}
```

---

## Function 0x018C - analyze_combinations

### Purpose

The main analysis function and heart of CODE 39. Uses a massive 9,632-byte stack
frame to perform exhaustive multi-pass letter combination scoring. Operates in
five phases:

1. **Collect** valid (unprocessed) letter pairs from the global table
2. **Generate** all pairwise combinations that have nonzero results
3. **Initialize** base scores from ESTR tables
4. **Extend** scores iteratively for 3, 4, 5, ... letter combinations
5. **Aggregate** final scores back to per-pair results

### Key Hex-Verified Sequences

```
File+0x190: 4E56 DA60           LINK A6,#-9632     (9632-byte frame!)
File+0x194: 48E7 1F38           MOVEM.L D3-D7/A2-A4,-(SP)

; Direction-based table selection
File+0x198: 4A6E 0008           TST.W 8(A6)        ; test direction
File+0x19C: 6714                BEQ.S use_vert      ; 0 = vertical
File+0x19E: 2D6D CF0C DA84     MOVE.L g_score_table1,-9596(A6)
File+0x1A4: 2D6D CF10 DA76     MOVE.L g_score_table2,-9610(A6)
File+0x1AA: 2D6D CF14 DA7C     MOVE.L g_score_table3,-9604(A6)
File+0x1B2: 2D6D CF18 DA84     MOVE.L g_score_table4,-9596(A6) ; (vert path)

; Pass 1 validation
File+0x1FA: 707F                MOVEQ #127,D0
File+0x1FC: 8044                OR.W D4,D0
File+0x1FE: 0C40 007F           CMPI.W #$007F,D0  ; entry must fit in 7 bits
File+0x204: 4EAD 01A2           JSR 418(A5)        ; bounds_error() if not

; Pass 4 iteration control
File+0x2EC: 3D7C 0001 DA74     MOVE.W #1,-9612(A6)  ; changed = true
File+0x2F2: 3D7C 0001 DA6A     MOVE.W #1,-9622(A6)  ; depth = 1
File+0x3F0: 4A6E DA60           TST.W -9632(A6)      ; synergy_delta check

; Epilogue
File+0x512: 4CDF 1CF8           MOVEM.L (SP)+,D3-D7/A2-A4
File+0x516: 4E5E                UNLK A6
File+0x518: 4E75                RTS
```

### Stack Frame Layout (9,632 bytes)

| Offset | Hex | Size | Name |
|--------|-----|------|------|
| -9632 | DA60 | 2 | `synergy_delta` - improvement in current iteration |
| -9626 | DA66 | 4 | `threshold` - score threshold for improvement |
| -9622 | DA6A | 2 | `depth` - current combination depth (1-based) |
| -9620 | DA6C | 4 | `ptr_table_c` - pointer into table_c |
| -9616 | DA70 | 4 | `ptr_table_a` - pointer into table_a |
| -9612 | DA74 | 2 | `changed` - did this pass improve? |
| -9610 | DA76 | 4 | `table_b` - selected table B pointer |
| -9606 | DA7A | 2 | `pair_count` - valid pairs from pass 1 |
| -9604 | DA7C | 4 | `table_c` - selected table C pointer |
| -9596 | DA84 | 4 | `table_a` - selected table A pointer |
| -9592 | DA88 | 4 | `depth_base` - advancing with depth |
| -9588 | DA8C | 4 | `combo_results_ptr` |
| -9584 | DA90 | 4 | `pairs_scan_ptr` |
| -9580 | DA94 | 4 | `depth_offset` |
| -9576 | DA98 | ~512 | `combo_ptrs[128]` - per-pair combo groups |
| -9060 | DC9C | ~8800 | `combinations` - pair combo records |
| -260 | FEFC | 260 | `valid_pairs[130]` - valid pair indices |

### C Decompilation

```c
/*
 * analyze_combinations - Exhaustive letter combination scoring
 *
 * The core of Maven's synergy analysis. Enumerates all valid letter pair
 * combinations for a given board position, then iteratively extends
 * scoring to longer combinations (3, 4, ... letters) until no further
 * improvement is found.
 *
 * Parameters:
 *   direction - 0 = vertical, nonzero = horizontal
 *   position  - Board position data (passed to init functions)
 */
void analyze_combinations(int16_t direction, int32_t position)
{
    /* Select score tables based on play direction */
    ESTRRecord *table_a, *table_b, *table_c;

    if (direction != 0) {
        table_a = g_score_table1;  /* horizontal set */
        table_b = g_score_table2;
        table_c = g_score_table3;
    } else {
        table_a = g_score_table4;  /* vertical set */
        table_b = g_score_table5;
        table_c = g_score_table6;
    }

    init_position(position);
    init_rack_info(position);

    /* Compute processed mask from crosscheck table */
    int16_t proc_mask = 0x0080 - g_crosscheck_table[/* derived index */];

    /*====================================================================
     * PASS 1: Collect valid letter pairs
     *
     * Scan g_letter_pair_table, keeping only entries that:
     *   - Have all bits within 0x7F (valid pair index)
     *   - Are NOT already marked as processed (bit 7 clear)
     *====================================================================*/
    int16_t pair_count = 0;
    int16_t valid_pairs[130];

    for (int i = 0; i < g_letter_pair_count; i++) {
        int16_t entry = g_letter_pair_table[i];

        /* Validate: entry OR 0x7F must equal 0x7F */
        if ((entry | 0x7F) != 0x7F) {
            bounds_error();
        }

        /* Skip if already processed */
        if ((entry & proc_mask) == proc_mask)
            continue;

        valid_pairs[pair_count++] = entry;
    }

    /*====================================================================
     * PASS 2: Generate pairwise combinations
     *
     * For each pair of valid pairs (i, j), test whether their OR
     * combination has a nonzero entry in g_results_array. If so,
     * compute the crosscheck value and store the combination.
     *====================================================================*/
    int16_t combinations[4400];  /* combo records at -9060(A6) */
    int32_t combo_ptrs[128];     /* per-outer-pair combo list heads */
    int combo_idx = 0;

    for (int i = 0; i < pair_count; i++) {
        int16_t pair1 = valid_pairs[i];
        combo_ptrs[i] = (int32_t)&combinations[combo_idx];

        for (int j = i; j < pair_count; j++) {
            int16_t pair2 = valid_pairs[j];
            int16_t combined = pair1 | pair2;

            /* Skip if combined pair has no results */
            if (g_results_array[combined] == 0)
                continue;

            /* Compute crosscheck and store combination */
            int16_t cross = get_crosscheck(pair1, pair2);
            cross |= proc_mask;

            combinations[combo_idx++] = cross;
            combinations[combo_idx++] = pair2;
        }
    }

    /* Store sentinel for last combo group */
    combo_ptrs[pair_count] = (int32_t)&combinations[combo_idx];

    /*====================================================================
     * PASS 3: Initialize base scores from ESTR tables
     *
     * For each valid pair, look up its base scores from all three
     * selected tables. table_a and table_c get cleared; table_b
     * gets the base score from g_pair_base_scores.
     *====================================================================*/
    for (int i = 0; i < pair_count; i++) {
        int16_t pair = valid_pairs[i];
        int32_t offset = (int32_t)pair * 18;

        /* Clear table_a and table_c entries */
        *(int16_t *)((char *)table_a + offset) = 0;
        *(int16_t *)((char *)table_c + offset) = 0;

        /* Copy base score to table_b */
        *(int16_t *)((char *)table_b + offset) =
            g_pair_base_scores[pair];  /* A5-13318 */
    }

    /*====================================================================
     * PASS 4: Iterative combination extension
     *
     * Starting at depth=1, iterate until no improvement or depth > 7.
     * For each pair, copy previous depth's scores forward, then scan
     * all combinations looking for synergy improvements.
     *====================================================================*/
    int16_t changed = 1;
    int16_t depth = 1;
    int32_t depth_base = 2;

    while (changed) {
        changed = 0;

        for (int i = 0; i < pair_count; i++) {
            int16_t pair = valid_pairs[i];
            int32_t off = (int32_t)pair * 18;

            int16_t *pa = (int16_t *)((char *)table_a + off + depth * 2);
            int16_t *pb = (int16_t *)((char *)table_b + off + depth * 2);
            int16_t *pc = (int16_t *)((char *)table_c + off + depth * 2);

            /* Propagate previous depth's scores */
            *pa = *(pa - 1);
            *pb = *(pb - 1);
            if (*(pb - 1) != 0) {
                *pa += *(pb - 2);
                *pb -= *(pb - 2);
            }

            /* Scan this pair's combinations for improvements */
            int16_t *combo = (int16_t *)combo_ptrs[i];
            int16_t *combo_end = (int16_t *)combo_ptrs[i + 1];

            while (combo < combo_end) {
                int16_t cross = combo[0];
                int16_t pair2 = combo[1];
                int32_t c_off = (int32_t)cross * 18;

                int16_t syn_a = *(int16_t *)((char *)table_a + c_off + depth_base * 2);
                int16_t delta = g_results_array[pair2].synergy[depth];
                int16_t candidate = syn_a + delta;

                if (candidate > *pa) {
                    /* Improvement found: update all three tables */
                    int16_t syn_c = *(int16_t *)((char *)table_c + c_off + depth * 2);
                    int16_t alt = g_alt_score_data[pair2];
                    *pc = (syn_c + delta > alt) ? pair2 : alt;
                    *pa = candidate;
                    /* Update pb and threshold accordingly */
                }
                combo += 2;
            }

            /* Set changed if any table entry differs from previous depth */
            if (*pa != *(pa - 1) || *pc != *(pc - 1) || *pb != *(pb - 2))
                changed = 1;
        }

        depth++;
        depth_base++;
    }

    /*====================================================================
     * PASS 5: Final aggregation
     *
     * Walk through valid_pairs one more time. For each pair, copy the
     * accumulated scores at the final depth back into the ESTR tables.
     * This makes the results visible to the caller via the score table
     * pointers.
     *====================================================================*/
    for (int i = 0; i < pair_count; i++) {
        int16_t pair = valid_pairs[i];
        int32_t offset = (int32_t)pair * 18;

        int16_t *ptr_a = (int16_t *)((char *)table_a + offset + depth * 2);
        int16_t *ptr_b = (int16_t *)((char *)table_b + offset + depth * 2);
        int16_t *ptr_c = (int16_t *)((char *)table_c + offset + depth * 2);

        int16_t final_depth = depth;

        /* Copy scores across remaining synergy slots up to slot 9 */
        while (final_depth < 9) {
            *ptr_a = *(ptr_a - 1);
            *ptr_b = *(ptr_b - 1);
            *ptr_c = *(ptr_c - 1);
            final_depth++;
            ptr_a++;
            ptr_b++;
            ptr_c++;
        }
    }
}
```

---

## Function 0x0516 - lookup_pair_scores

### Purpose

Simple table lookup: given a pair index, reads the `position_mult` field
(offset +16) from ESTR records in multiple score tables. Returns a combined
score. If table2's value is zero, falls back to a fixed offset (2286) in
table5.

### Key Hex-Verified Sequences

```
File+0x51A: 4E56 0000           LINK A6,#0        (no locals)
File+0x51E: 48E7 0108           MOVEM.L D7/A4,-(SP)
File+0x528: 7012                MOVEQ #18,D0
File+0x52A: C1EE 0008           MULU 8(A6),D0     ; pair * 18 -> byte offset
File+0x538: 32B4 0810           MOVE.W 16(A4,D0.L),(A1)  ; table3[pair].position_mult -> *out2
File+0x546: 3E30 0810           MOVE.W 16(A0,D0.L),D7    ; table2[pair].position_mult
File+0x54A: 4A47                TST.W D7           ; branch on zero
File+0x54C: 6706                BEQ.S fallback
File+0x550: 4440                NEG.W D0           ; negate table2 value
File+0x558: 3028 08EE           MOVE.W 2286(A0),D0  ; fallback: table5[127]
File+0x564: 3428 08EE           MOVE.W 2286(A0),D2  ; table5[127].value
File+0x568: D474 1810           ADD.W 16(A4,D1.L),D2  ; + table1[pair].pos_mult
File+0x56E: D042                ADD.W D2,D0          ; return sum
```

### C Decompilation

```c
/*
 * lookup_pair_scores - Look up score components for a letter pair
 *
 * Reads position_mult (offset 16) from multiple ESTR tables and
 * combines them. If table2 returns zero, uses a fallback value
 * from a fixed position in table5 (entry 127).
 *
 * Parameters:
 *   pair - Letter pair index (0-127)
 *   out1 - Output: first score component (int16*, cleared to 0)
 *   out2 - Output: second score component (int16*)
 *
 * Returns:
 *   D0 = combined score from all tables
 */
int16_t lookup_pair_scores(uint16_t pair, int16_t *out1, int16_t *out2)
{
    *out1 = 0;

    int32_t byte_offset = (int32_t)pair * 18;

    /* Read position multiplier from table3 */
    *out2 = ((ESTRRecord *)((char *)g_score_table3 + byte_offset))->position_mult;

    /* Read position multiplier from table2 */
    int16_t table2_val = ((ESTRRecord *)((char *)g_score_table2 + byte_offset))->position_mult;

    int16_t base;
    if (table2_val != 0) {
        base = -table2_val;
    } else {
        /* Fallback: use entry 127 from table5 (offset 2286 = 127*18) */
        base = *(int16_t *)((char *)g_score_table5 + 2286);
    }

    /* Combine: table5[127].value + table1[pair].position_mult + base */
    int16_t t5_val = *(int16_t *)((char *)g_score_table5 + 2286);
    int16_t t1_val = ((ESTRRecord *)((char *)g_score_table1 + byte_offset))->position_mult;

    return base + t5_val + t1_val;
}
```

---

## Function 0x0572 - score_pair_of_pairs

### Purpose

Computes synergy scores for two letter pairs simultaneously. Uses a 7-iteration
loop that walks through the synergy fields (offsets +2 through +14) of the ESTR
records, comparing scores from different tables and updating outputs whenever a
better score is found. This captures how two groups of letters interact across
draw scenarios.

### Key Hex-Verified Sequences

```
File+0x576: 4E56 FFEC           LINK A6,#-20
File+0x57A: 48E7 1F38           MOVEM.L D3-D7/A2-A4,-(SP)

; Compute byte offsets and build 6 table+pair pointer combinations
File+0x57E: 7012                MOVEQ #18,D0
File+0x580: C1EE 0008           MULU 8(A6),D0      ; pair1 * 18
File+0x584: 2840                MOVEA.L D0,A4      ; A4 = offset1
File+0x588: D7ED CF10           ADDA.L g_score_table2,A3  ; A3 -> table2[pair1]
File+0x590: C1EE 000A           MULU 10(A6),D0     ; pair2 * 18
File+0x596: 2E2D CF1C           MOVE.L g_score_table5,D7
File+0x59A: DE8A                ADD.L A2,D7         ; D7 = table5 + offset2

; Initial score = table1[p1].pos - table4[p2].pos - table2[p1].pos
File+0x5C2: 3829 0010           MOVE.W 16(A1),D4   ; table1[pair1].position_mult
File+0x5C6: 9868 0010           SUB.W 16(A0),D4    ; - table4[pair2].position_mult
File+0x5CA: 9845                SUB.W D5,D4         ; - table2[pair1].position_mult

; 7-iteration synergy walk (offset 14 down to 2)
File+0x5F4: 7A07                MOVEQ #7,D5         ; 7 iterations
File+0x5F6: 347C 000E           MOVEA.W #14,A2      ; start at synergy[6]
File+0x5FE: 4A72 7800           TST.W 0(A2,D7.L)    ; table5[pair2].synergy[i]
File+0x67A: 5345                SUBQ.W #1,D5         ; next iteration
File+0x67C: 558A                SUBQ.L #2,A2         ; previous field

File+0x684: 3004                MOVE.W D4,D0         ; return best score
```

### Stack Frame Layout (20 bytes)

| Offset | Hex | Size | Name |
|--------|-----|------|------|
| -20 | FFEC | 4 | `ptr_table4_pair2` (table4 + offset2) |
| -16 | FFF0 | 4 | `ptr_table3_pair1` (table3 + offset1) |
| -12 | FFF4 | 4 | `ptr_table6_pair2` (used in second check) |

### C Decompilation

```c
/*
 * score_pair_of_pairs - Compute synergy score for two letter pairs
 *
 * Evaluates how two letter pairs interact across all six score tables.
 * Walks through 7 synergy fields in descending order. When a table
 * entry at a synergy level is zero (indicating an available slot),
 * attempts to improve the running best score.
 *
 * Parameters:
 *   pair1 - First letter pair index
 *   pair2 - Second letter pair index
 *   out1  - Output: score for pair1's contribution (int16*)
 *   out2  - Output: score for pair2's contribution (int16*)
 *
 * Returns:
 *   D0 = best combined synergy score
 */
int16_t score_pair_of_pairs(uint16_t pair1, uint16_t pair2,
                            int16_t *out1, int16_t *out2)
{
    int32_t off1 = (int32_t)pair1 * 18;
    int32_t off2 = (int32_t)pair2 * 18;

    /* Build pointers to each table+pair combination */
    ESTRRecord *t1_p1 = (ESTRRecord *)((char *)g_score_table1 + off1);
    ESTRRecord *t2_p1 = (ESTRRecord *)((char *)g_score_table2 + off1);
    ESTRRecord *t3_p1 = (ESTRRecord *)((char *)g_score_table3 + off1);
    ESTRRecord *t4_p2 = (ESTRRecord *)((char *)g_score_table4 + off2);
    ESTRRecord *t5_p2 = (ESTRRecord *)((char *)g_score_table5 + off2);
    ESTRRecord *t6_p2 = (ESTRRecord *)((char *)g_score_table6 + off2);

    /* Compute initial combined score:
     *   table1[pair1].pos - table4[pair2].pos - table2[pair1].pos */
    int16_t best = t1_p1->position_mult
                 - t4_p2->position_mult
                 - t2_p1->position_mult;

    /* Determine initial base from table5 */
    int16_t t5_pos = t5_p2->position_mult;
    if (t5_pos != 0) {
        best += t5_pos;
    } else {
        best += -t2_p1->position_mult;
    }

    /* Initialize outputs from table6 and table3 position_mult */
    *out1 = t6_p2->position_mult;
    *out2 = t3_p1->position_mult;

    /*
     * Walk synergy fields from index 6 down to 0.
     * Synergy field i is at byte offset (i+1)*2 = 2..14 within the record.
     * We use A2 as a byte offset, starting at 14 and decrementing by 2.
     *
     * For each synergy level, check two conditions:
     *   1) If table5[pair2].synergy[i] == 0: attempt to improve via pair1
     *   2) If table2[pair1].synergy[i] == 0: attempt to improve via pair2
     */
    for (int syn_offset = 14; syn_offset >= 2; syn_offset -= 2) {

        /* Check first direction: pair2's slot is empty in table5 */
        if (*(int16_t *)((char *)t5_p2 + syn_offset) == 0) {
            int16_t t2_syn = *(int16_t *)((char *)t2_p1 + syn_offset);
            int16_t doubled = t2_syn + t2_syn;

            int16_t t4_syn = *(int16_t *)((char *)t4_p2 + syn_offset);
            int16_t candidate = doubled - t4_syn - t2_syn;

            if (candidate > best) {
                best = candidate;
                *out1 = *(int16_t *)((char *)t2_p1 + syn_offset);  /* via A4+A2 */
                *out2 = *(int16_t *)((char *)t3_p1 + syn_offset);  /* via local */
            }
        }

        /* Check second direction: pair1's slot is empty in table2 */
        if (*(int16_t *)((char *)t2_p1 + syn_offset) == 0) {
            /* Symmetric computation using table6 */
            int16_t t6_syn = *(int16_t *)((char *)t6_p2 + syn_offset);
            int16_t t5_syn = *(int16_t *)((char *)t5_p2 + syn_offset);
            int16_t candidate = t5_syn + t5_syn + t6_syn;

            if (candidate < best) {  /* note: opposite comparison direction */
                best = candidate;
                *out1 = *(int16_t *)((char *)t6_p2 + syn_offset);
                *out2 = *(int16_t *)((char *)t3_p1 + syn_offset);
            }
        }
    }

    return best;
}
```

---

## Function 0x0688 - adjusted_pair_score

### Purpose

A thin wrapper around `score_pair_of_pairs`. After getting the dual-pair score,
it performs an additional cross-table comparison. If a specific condition holds
(the combined score from tables 4, 5, and 6 matches table 6's position_mult),
it computes an alternate score from table 1 and stores it in out1.

### Key Hex-Verified Sequences

```
File+0x68C: 4E56 0000           LINK A6,#0         (no locals)
File+0x690: 48E7 0308           MOVEM.L D6/D7/A4,-(SP)
File+0x6A6: 4EBA FECE           JSR *-306           ; PC-relative call to 0x0572
File+0x6AA: 3E00                MOVE.W D0,D7        ; save result

; Check: table5[pair2].value*2 + table4[pair2].pos_mult == table6[pair2].pos_mult?
File+0x6C4: 3414                MOVE.W (A4),D2      ; table5[pair2].value
File+0x6C6: D442                ADD.W D2,D2         ; *2
File+0x6C8: D471 1810           ADD.W 16(A1,D1.L),D2  ; + table4.pos_mult
File+0x6CC: B470 0810           CMP.W 16(A0,D0.L),D2  ; vs table6.pos_mult
File+0x6D4: 661A                BNE.S done

; Equal case: alternate = table5.val*2 + table1[pair1].pos_mult - result
File+0x6E4: D270 0810           ADD.W 16(A0,D0.L),D1  ; + table1[pair1].pos_mult
File+0x6E8: 9247                SUB.W D7,D1            ; - original result
File+0x6EE: 3281                MOVE.W D1,(A1)         ; *out1 = alternate
```

### C Decompilation

```c
/*
 * adjusted_pair_score - Score two pairs with cross-table adjustment
 *
 * Calls score_pair_of_pairs, then checks whether the vertical table
 * scores are in a specific configuration. If table5[pair2].value*2 +
 * table4[pair2].position_mult equals table6[pair2].position_mult,
 * computes an alternate score that replaces out1.
 *
 * Parameters:
 *   pair1 - First letter pair index
 *   pair2 - Second letter pair index
 *   out1  - Output: score for pair1 (may be adjusted)
 *   out2  - Output: score for pair2
 *
 * Returns:
 *   D0 = score from score_pair_of_pairs (unmodified)
 */
int16_t adjusted_pair_score(uint16_t pair1, uint16_t pair2,
                            int16_t *out1, int16_t *out2)
{
    int16_t result = score_pair_of_pairs(pair1, pair2, out1, out2);

    int32_t off2 = (int32_t)pair2 * 18;
    int32_t off1 = (int32_t)pair1 * 18;

    ESTRRecord *t4_p2 = (ESTRRecord *)((char *)g_score_table4 + off2);
    ESTRRecord *t5_p2 = (ESTRRecord *)((char *)g_score_table5 + off2);
    ESTRRecord *t6_p2 = (ESTRRecord *)((char *)g_score_table6 + off2);

    /* Check: does 2*table5.value + table4.position_mult == table6.position_mult? */
    int16_t combined = t5_p2->value * 2 + t4_p2->position_mult;

    if (combined == t6_p2->position_mult) {
        /* Compute alternate score from table1 */
        ESTRRecord *t1_p1 = (ESTRRecord *)((char *)g_score_table1 + off1);

        int16_t alternate = t5_p2->value * 2
                          + t1_p1->position_mult
                          - result;

        *out1 = alternate;
    }

    return result;
}
```

---

## Algorithm Summary

### Multi-Pass Combination Scoring

CODE 39 evaluates letter group synergies through six phases:

```
1. TABLE SELECTION: Pick 3 of 6 tables based on direction (horiz=1/2/3, vert=4/5/6)
2. PAIR COLLECTION: Filter g_letter_pair_table to valid unprocessed pairs (0-127)
3. COMBINATION GEN: For all pair_i|pair_j with nonzero g_results_array, store combos
4. BASE INIT: Clear table_a/c, copy g_pair_base_scores into table_b
5. ITERATE: depth=1..7, propagate scores forward, check combinations for improvement
6. PROPAGATE: Copy final-depth scores to remaining ESTR synergy slots (up to 9)
```

The tables are updated in-place; the caller reads results via the table pointers.

### Stack Budget

The 9,632-byte frame accommodates: 130 valid pairs (260 bytes), up to ~2,200
combination records (8,800 bytes), and 128 group pointers (512 bytes). Worst
case: 130 * 130 = 16,900 combination checks, 7 depth iterations.

---

## Fixed Offset 2286

The constant 2286 = 127 * 18 (the last of 128 ESTR entries). Entry 127 serves
as a fallback/sentinel value -- when a table lookup returns zero, the code reads
from this fixed position instead.

---

## Integration with CODE 32 Leave Calculation

CODE 39's synergy scores are one of three leave evaluation components:

```
Total Leave Value = MUL per-tile values (CODE 32, SANE FP)
                  + V/C balance (CODE 32, algorithmic)
                  + Letter synergy (CODE 39, integer)
```

The flow: CODE 2 allocates the six score tables at startup. For each position
evaluation, CODE 32 calls `analyze_combinations` (0x018C) to populate them,
then reads synergy values as part of the total leave score. Individual pairs
are accessed via `lookup_pair_scores` (0x0516) and `adjusted_pair_score`
(0x0688). Tables are working buffers, repopulated per position and direction.

---

## Disassembler Error Notes

The existing disassembly (code39_disasm.asm) contains numerous errors where the
disassembler merges separate instructions into nonsensical indexed addressing.

| Raw Hex | Correct Decode | Disassembler Error |
|---------|----------------|---------------------|
| E588 D1C0 | LSL.L #2,D0; ADDA.L D0,A0 | MOVE.L A0,-64(A2,A5.W) |
| C1C3 | MULU D3,D0 | ANDA.L D3,A0 |
| D4C6 | ADDA.W D6,A2 | MOVE.B D6,(A2)+ |
| 5C8F | ADDQ.L #6,SP | MOVE.B A7,(A6) |

The `E588 D1C0` pattern appears 6+ times and is always misread. All hex
sequences in this analysis are verified directly from the raw binary.

---

## Confidence Assessment

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Function boundaries | HIGH | All 5 LINK/UNLK/RTS sequences verified from hex |
| Stack frame sizes | HIGH | Directly from LINK displacement values |
| Register save masks | HIGH | MOVEM.L bit masks decoded from hex |
| Global variable offsets | HIGH | A5-relative displacements verified across functions |
| ESTR record layout | HIGH | 18-byte stride confirmed by MULU #18 pattern |
| Table selection logic | HIGH | Direction branch and 6 table copies verified |
| Multi-pass algorithm | HIGH | Loop structure and branch targets verified |
| Pass 4 inner scoring | MEDIUM | Complex nested loops; general flow clear, exact score formula approximate |
| Function 0x0000 parameters | MEDIUM | Stack layout inferred from access patterns |
| C decompilations | MEDIUM | Structure matches hex; exact variable semantics partly inferred |
| Fixed offset 2286 meaning | HIGH | 127 * 18 = 2286, entry 127 as sentinel/fallback |
