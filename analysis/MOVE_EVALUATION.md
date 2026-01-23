# Maven Move Evaluation System

## Overview

Maven's move evaluation system determines the value of each potential move by combining multiple factors. The evaluation is **not** just the raw tile score - it incorporates sophisticated heuristics to assess the strategic value of the remaining rack (the "leave").

## Evaluation Formula

```
Total Move Value = Base Score + Leave Value + Position Adjustment
```

Where:
- **Base Score** = Tile points + Premium square multipliers + Bingo bonus (if applicable)
- **Leave Value** = Sum of single-tile values + 2-tile synergy adjustments + Q-related penalties/bonuses
- **Position Adjustment** = Defensive/offensive considerations based on board state

---

## 1. Base Score Calculation

### Tile Points

Standard Scrabble tile values:
| Letter | Points | Count |
|--------|--------|-------|
| A, E, I, O, U, L, N, S, T, R | 1 | varies |
| D, G | 2 | 4, 3 |
| B, C, M, P | 3 | 2, 2, 2, 2 |
| F, H, V, W, Y | 4 | 2, 2, 2, 2, 2 |
| K | 5 | 1 |
| J, X | 8 | 1, 1 |
| Q, Z | 10 | 1, 1 |
| ? (blank) | 0 | 2 |

### Premium Square Multipliers

Calculated in CODE 32 using the board arrays:
- **g_state1** (A5-17154): Letter positions (17x17 grid)
- **g_state2** (A5-16610): Multiplier information (34 bytes per row)

```c
// From CODE 32 at 0x01CC-0x01F0
score *= word_multiplier;  // 2x or 3x for double/triple word
letter_score *= letter_multiplier;  // 2x or 3x for double/triple letter
```

### Bingo Bonus

From CODE 32 at 0x0328:
```asm
0328: CMPI.W     #$0007,-20010(A5)    ; g_tile_count == 7?
032E: BNE.S      $0336
0330: MOVE.W     #$1388,D0            ; 5000 point bingo bonus!
```

**Bingo bonus = 5000 points** for using all 7 tiles from the rack.

---

## 2. Leave Value System

The leave value represents the strategic worth of tiles remaining on the rack after making a move. Maven uses a pre-computed table-based system stored in Mac resources.

### Resource Files

| Resource | Size | Purpose |
|----------|------|---------|
| ESTR | 536 bytes | Pattern strings (null-terminated) |
| EXPR | 96 bytes | Base experience/leave values (80-bit SANE floats) |
| MUL? | 224 bytes | Blank tile adjustments |
| MULa-MULz | 224 bytes each | Per-letter adjustments |

### Pattern Categories (from ESTR)

The ESTR resource defines 100+ patterns for leave evaluation:

#### Single Letter Patterns
```
?, a, b, c, d, e, f, g, h, i, j, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
```

#### Duplicate Letter Patterns
```
?? (two blanks)
aa, aaa, aaaa, aaaaa
bb, cc, ch, ck, dd, ddd, dddd
ee, eee, eeee, eeeee, eeeeee
ff, gg, ggg, hh
ii, iii, iiii, iiiii
ll, lll, llll, mm
nn, nnn, nnnn
oo, ooo, oooo, ooooo
pp, rr, rrr, rrrr
ss, sss, ssss
tt, ttt, tttt
uu, uuu, uuuu, vv, ww
yy
```

#### Q-Related Patterns (special handling)
```
qu          ; Q with U (good)
adiq        ; Vowel-heavy with Q
adq         ; Q + A + D (QADI potential)
aiq         ; Q pattern
aq          ; Q + A
aqt         ; Q + A + T
```

#### Suffix/Prefix Patterns
```
gin, flu, ily, ino, inot, ity
osu, otu, eiv, eiz
amn, emn, boy
bel, ery, ary, fiy
elss, enss, imu
```

#### Vowel/Consonant Balance
```
aeiou       ; All vowels (usually bad)
iu, uw      ; Vowel pairs
ory, dio, eir, de, dei
his, aeit, er, est, eist
```

#### Consonant Groups
```
bgjkf       ; Hard consonants
mpxhwy      ; Consonant mix
udlnrst     ; Common consonants
jx          ; J and X together
dg, fhkwvy, bcmp, lnrtsu
fhwyx, dgbmp, fhkjwyx
```

### Data Format (Confirmed via CODE 32 analysis)

Each MUL resource is 224 bytes containing up to **8 records of 28 bytes each**, one per copy count (1 copy, 2 copies, etc.):

```
Record format (28 bytes per copy count):
  Bytes 0-7:   IEEE 754 double (big-endian) - expected turn score with N copies
  Bytes 8-15:  Secondary double (often garbage/unused)
  Bytes 16-19: Unsigned int - simulation count (number of samples)
  Bytes 20-23: Signed int - (purpose unclear)
  Bytes 24-27: Signed int - LEAVE ADJUSTMENT VALUE (loaded by CODE 32 at offset 0x156A)
```

The signed integer at **offset 24** is the key leave adjustment value, used in SANE FP operations (FMULX, FADDX).

**Observed values for single-tile leaves (offset 24):**
| Letter | Adjustment | Interpretation |
|--------|------------|----------------|
| Blank (?) | -515 | Strong bonus (keep the blank) |
| S | -337 | Strong bonus |
| E | -219 | Moderate bonus |
| R | -85 | Small bonus |
| Q | +88 | Small penalty |
| V | +68 | Small penalty |

**Scale: Centipoints (1/100 of a point)**

Like the bingo bonus (5000 centipoints = 50 points), leave adjustments are stored in centipoints:
- Blank: -515 = **-5.15 points** (bonus to keep)
- S: -337 = **-3.37 points**
- E: -219 = **-2.19 points**
- Q: +88 = **+0.88 points** (penalty)

Note: Values appear inverted from traditional notation (negative = good, positive = bad).

---

## 3. Letter Combination Scoring (CODE 39)

CODE 39 (1784 bytes) handles multi-letter combination analysis with a massive 9632-byte stack frame.

### Score Tables

Six parallel tables for directional scoring:

| Offset | Table | Purpose |
|--------|-------|---------|
| A5-12532 | g_horiz_scores1 | Horizontal base letter scores |
| A5-12528 | g_horiz_scores2 | Horizontal letter combination bonuses |
| A5-12524 | g_horiz_scores3 | Horizontal position multipliers |
| A5-12520 | g_vert_scores1 | Vertical base letter scores |
| A5-12516 | g_vert_scores2 | Vertical letter combination bonuses |
| A5-12512 | g_vert_scores3 | Vertical position multipliers |

### Letter Pair Table

Located at **A5-13060**, this table contains pre-computed letter pair values:
- 16-bit entries encoding two letters
- High bit (0x80) marks as "processed"
- Count stored at A5-13062

### Algorithm (simplified)

```c
// From CODE 39 function 0x018C
void full_combination_analysis(int direction, void* position) {
    // Select tables based on direction
    int* scores1 = direction ? g_horiz_scores1 : g_vert_scores1;
    int* scores2 = direction ? g_horiz_scores2 : g_vert_scores2;
    int* scores3 = direction ? g_horiz_scores3 : g_vert_scores3;

    // Pass 1: Collect valid letter pairs from rack
    for (int i = 0; i < g_letter_pair_count; i++) {
        if (!(g_letter_pair_table[i] & 0x80)) {
            valid_pairs[pair_count++] = entry;
        }
    }

    // Pass 2: Generate all valid pair combinations
    for (int i = 0; i < pair_count; i++) {
        for (int j = 0; j < pair_count; j++) {
            uint16_t combined = valid_pairs[i] | valid_pairs[j];
            if (is_valid_combination(combined)) {
                combinations[combo_count++] = combined;
            }
        }
    }

    // Pass 3: Score each combination using all three tables
    for (int i = 0; i < combo_count; i++) {
        int idx = combinations[i] * 18;
        total_score = scores1[idx] + scores2[idx] + scores3[idx];
    }
}
```

---

## 4. Rack Analysis (CODE 42)

CODE 42 (734 bytes) analyzes the current rack for letter availability and scoring.

### Global Variables

| Offset | Name | Purpose |
|--------|------|---------|
| A5-1666 | g_letter_count | Total letter point values in rack |
| A5-1668 | g_blank_count | Number of blanks (bitmask) |
| A5-1696 | g_letter_buffer | Filtered letters for evaluation |
| A5-26024 | g_letter_scores | Point value lookup table |
| A5-26158 | g_rack | Current player's rack |

### Recursive Evaluation

CODE 42 uses recursion to evaluate all possible letter combinations:

```c
int recursive_evaluate(int* scores, uint16_t filter,
                       char* work_buf, char* letters,
                       int depth, int max_depth) {
    // Base case: max depth reached
    if (depth == max_depth) {
        if (filter != 0) return 0;  // Invalid
        return calculate_final_score(work_buf);
    }

    // Sum remaining letter values
    int sum = 0;
    for (char* p = letters; *p; p++) {
        sum += scores[*p];
    }

    // Pruning: not enough potential value
    if (sum < (max_depth - depth)) {
        return 0;
    }

    // Try each letter placement
    int best = 0;
    for (each valid letter) {
        int result = recursive_evaluate(scores, updated_filter,
                                        work_buf + 1, letters + 1,
                                        depth + 1, max_depth);
        if (result > best) best = result;
    }

    return best;
}
```

---

## 5. Move Ranking (CODE 45)

CODE 45 (1122 bytes) maintains ranking tables for the best moves found.

### Score Tables

Two parallel 10-entry tables track the best scores:

| Offset | Table | Purpose |
|--------|-------|---------|
| A5-1616 | g_score_table1 | Primary score ranking (10 entries) |
| A5-1576 | g_score_table2 | Secondary score ranking (10 entries) |

Both tables initialized to **-200,000,000** (0xF4143E00):

```asm
; From CODE 45 at 0x0362
0362: MOVE.L     #$F4143E00,D0        ; -200000000
0368: MOVE.L     D0,(A2)              ; Store in table 2
036A: MOVEA.L    D7,A0
036C: MOVE.L     D0,(A0)              ; Store in table 1
```

### Comparison Variables

| Offset | Purpose |
|--------|---------|
| A5-12500 | g_compare2 - Second move for comparison |
| A5-12504 | g_compare1 - First move for comparison |
| A5-12540 | g_entry_count - Current entry count |

### Move Entry Structure (34 bytes)

| Offset | Size | Field |
|--------|------|-------|
| 0-15 | 16 | Move data (word, position) |
| 16 | 4 | Main score |
| 20 | 4 | Component score (leave value) |
| 24 | 4 | Bonus score |
| 28 | 2 | Flags (0x7F = special) |
| 30 | 2 | Position index |
| 32 | 1 | Row |
| 33 | 1 | Column |

---

## 6. Position Tracking (CODE 32)

CODE 32 maintains the best positions found during move generation:

| Offset | Variable | Purpose |
|--------|----------|---------|
| A5-17158 | g_best_col | Best column position |
| A5-17160 | g_best_col2 | Second best column |
| A5-17162 | g_best_row | Best row position |
| A5-17164 | g_best_row2 | Second best row |
| A5-20010 | g_tile_count | Tiles placed in current move |

---

## 7. Pre-Endgame Timing

Maven adjusts evaluation based on tiles remaining in the bag. Key indicators:

### Bag State Tracking

- **A5-20010**: Current tile count
- Cross-reference with total tile count (100 - tiles on board - tiles in racks)

### Timing Heuristics (inferred)

1. **Early game (50+ tiles in bag)**:
   - Prioritize rack balance and bingo potential
   - Leave value weights are high

2. **Mid game (20-50 tiles in bag)**:
   - Balance between scoring and leave
   - Position becomes more important

3. **Pre-endgame (7-20 tiles in bag)**:
   - Tracking opponent's likely tiles
   - Setup moves for endgame
   - Q/Z plays become critical if not played

4. **Endgame (0 tiles in bag)**:
   - Full tree search (separate system)
   - Leave value irrelevant (no draws)

---

## 8. Q Without U Handling

Special patterns in ESTR for Q situations:

```
qu    - Q with U (traditional synergy)
aqt   - Q + A + T → can spell QAT (bonus)
adiq  - Q + A + D + I → can spell QADI, QAID (bonus)
adq   - Q + A + D → QADI with board I (bonus)
aiq   - Q + A + I → QI playable, QAID potential (bonus)
aq    - Q + A → QAT/QADI hookable (bonus)
```

These patterns are **bonuses** for having Q-compatible letters that enable Q-without-U words like QI, QAT, QADI, QAID, QOPH, etc. The key insight is that A is critical for Q playability, while I and T provide additional options.

---

## 9. Floating Point Operations

Maven uses Apple SANE (Standard Apple Numerics Environment) for precise calculations:

### SANE Traps (A9EB)

| Opcode | Operation | Usage |
|--------|-----------|-------|
| 0 | FADDX | Add extended |
| 2 | FSUBX | Subtract extended |
| 4 | FMULX | Multiply extended |
| 6 | FDIVX | Divide extended |
| 8 | FCMPX | Compare extended |
| 22 | FRINTX | Round to integer |
| 0x3010 | FX2I | Extended to integer |

### 80-bit Extended Precision

```
Format: [2-byte exponent][8-byte mantissa]
Bias: 16383
Range: approximately 3.4 × 10^-4932 to 1.1 × 10^4932
Precision: ~18 decimal digits
```

---

---

## 10. Extracted Leave Value Tables

See **LEAVE_VALUES.md** for comprehensive documentation.

### MUL Record Structure (28 bytes each)

| Offset | Size | Type | Description |
|--------|------|------|-------------|
| 0 | 8 | double | Expected turn score with N copies (~10-11 range) |
| 8 | 8 | double | Secondary value (purpose unclear) |
| 16 | 4 | uint32 | Simulation count (sample size) |
| 20 | 4 | int32 | Unknown |
| 24 | 4 | int32 | **Leave adjustment in centipoints** |

### Leave Adjustment Values (Offset 24)

**Single-tile values (1 copy on rack) - in centipoints:**

| Letter | Raw Adj | Points | Assessment |
|--------|---------|--------|------------|
| Blank (?) | +2440 | +24.40 | Excellent (keep) |
| S | +721 | +7.21 | Excellent |
| X | +419 | +4.19 | Very good |
| Z | +359 | +3.59 | Very good |
| E | +299 | +2.99 | Good |
| R | +245 | +2.45 | Good |
| A | +220 | +2.20 | Good |
| Q | -879 | -8.79 | Very bad (play it) |
| V | -498 | -4.98 | Bad |
| J | -369 | -3.69 | Bad |

**Sign Convention:** Positive raw values = good tiles to keep, negative = bad tiles (play them).

### VCB Vowel Count Balance (from VCBh resource)

| Vowels | Adjustment | Points | Assessment |
|--------|------------|--------|------------|
| 0 | -756 | -7.56 | Poor (all consonants) |
| 3 | +23 | +0.23 | Good |
| 4 | +368 | +3.68 | Optimal |
| 7 | -1238 | -12.38 | Poor (all vowels) |

### CODE 32 Usage (offsets 0x156A and 0x15C4)
```asm
; At 0x156A - Load leave adjustment
2068 d58c       MOVEA.L -10868(A0),A0   ; Load MUL data ptr from handle
2d68 0018 ffdc  MOVE.L  24(A0),-36(A6)  ; Load offset-24 to local var

; At 0x15C4 - Apply leave adjustment
90ae ffdc       SUB.L   -36(A6),D0      ; SUBTRACT adjustment from D0
```

**Key finding:** The adjustment is **subtracted** from the score accumulator, so:
- Positive offset-24 (e.g., S=+721) → subtracted → reduces move score (incentivizes keeping)
- Negative offset-24 (e.g., Q=-879) → subtracted → increases move score (incentivizes playing)

---

## 11. Pattern-Based Leave Adjustments

The ESTR resource defines 130 patterns for synergy adjustments:

### High-Value Patterns (inferred)
- **Suffix tiles**: -ING, -LY, -TION compatible letters
- **S-hook potential**: Letters that work well with S
- **Bingo tiles**: SATINE, RETINA letter combinations

### Penalty Patterns
- **Too many vowels**: aeiou (all 5 vowels = inflexible)
- **Duplicate consonants**: Too many of same letter
- **Awkward combinations**: jx (both high-point, hard to use together)

### Bonus Patterns
- **Q-without-U enablers**: aqt, adiq, adq, aiq, aq (enable QAT, QADI, etc.)
- **Suffix-friendly**: gin, ily, ity (common endings)

### Example Pattern Strings
```
Suffix-friendly: gin, flu, ily, ino, inot, ity, osu, otu
Vowel combos:    eiv, eiz, amn, emn, aeiou
Consonant groups: bgjkf, mpxhwy, udlnrst, lnrtsu
Q-related:       qu, adiq, adq, aiq, aq, aqt
```

---

## Summary

Maven's move evaluation is a sophisticated multi-factor system:

1. **Base scoring** is standard Scrabble rules with 5000-point bingo
2. **Leave values** use pre-computed tables from MUL resources
3. **Combination scoring** evaluates letter synergies via CODE 39's massive function
4. **Recursive analysis** in CODE 42 explores all letter placements
5. **Ranking** maintains top 10 moves for comparison
6. **Position tracking** enables best-move selection
7. **SANE floats** provide high-precision arithmetic

The system is designed for speed (pre-computed tables) while maintaining strategic depth (complex leave evaluation).
