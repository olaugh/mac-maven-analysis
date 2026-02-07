# Maven Leave Value System - Complete Analysis

## Overview

Maven evaluates rack leaves (tiles remaining after a play) using a multi-component system that combines:
1. **Per-tile values** from MUL resources (27 resources: MULa-MULz plus MUL?)
2. **Vowel count adjustments** from VCB resources (VCBh contains actual data)
3. **Synergy patterns** from ESTR resource (130 patterns, values computed at runtime by CODE 39)

All leave adjustments are stored in **centipoints** (1/100 of a point).

---

## 1. MUL Resources (Per-Tile Leave Values)

### Structure

Each MUL resource (MULa through MULz, plus MUL? for blanks) contains **8 records of 28 bytes each**, indexed by the count of that tile on the rack (0-7 copies).

**Record Format (28 bytes):**
| Offset | Size | Type | Description |
|--------|------|------|-------------|
| 0-7 | 8 | IEEE 754 double (big-endian) | Expected turn score from simulation |
| 8-15 | 8 | IEEE 754 double (big-endian) | Secondary value (purpose unclear) |
| 16-19 | 4 | uint32 (big-endian) | Simulation sample count |
| 20-23 | 4 | int32 (big-endian) | Unknown |
| 24-27 | 4 | int32 (big-endian) | **Leave adjustment in centipoints** |

### Loading

MUL resources are loaded by CODE 15 at offset 0x0C62-0x0C8A:
- Loop iterates 27 times (0x001B)
- Resource handles stored at A5-10868 (array of 27 4-byte handles)
- Resource type constructed as 'MUL' + letter character

### Usage: Binomial-Weighted Leave Calculation

CODE 32 function at offset 0x1406 computes leave values using a **binomial-coefficient-weighted average** across all possible tile counts. This is NOT a simple per-tile lookup.

#### Algorithm Overview

1. **Build binomial coefficient table** (one-time, stored at A5-2448):
   - 8080-byte buffer: 101 entries × 80 bytes (8 × 10-byte SANE extended)
   - Each `entry[n][k] = C(n,k)` built via Pascal's triangle recurrence
   - `entry[i][j] = entry[i-1][j] + entry[i-1][j-1]`

2. **For each tile type on rack**, compute weighted leave adjustment:
```c
// Parameters: letter (D5), tile_count (D6), unseen_count (param at 12(A6))
// A2 = MUL data pointer for this letter
// A4 = &binom[unseen_count], A3 = &binom[tile_count]

long baseline = MUL_record[0].adj;  // Record 0 = "have 0 of this tile"
extended sum_weights = 0.0;
extended sum_adj = 0.0;

for (int i = start; i <= end; i++) {
    // Binomial weight: C(unseen, i) * C(tile_count, D3-i)
    extended weight = binom[unseen][i] * binom[tile_count][D3-i];
    sum_weights += weight;

    // Relative adjustment: value with (i+1) tiles minus baseline
    long relative_adj = MUL_record[i+1].adj - baseline;
    sum_adj += (extended)relative_adj;
}
// Result = adj_sum / weight_total (normalize by binomial convolution)
return (long)(sum_adj / sum_weights);
```

3. **Key indexed addressing** at 0x15BE accesses per-count records:
```asm
; D0 = (D4+1) * 28  (record index × record size)
2032 0818     MOVE.L (24,A2,D0.L),D0  ; MUL_data[(D4+1)*28 + 24]
90AE FFDC     SUB.L  -36(A6),D0       ; Subtract record 0 baseline
```

**Sign Convention:** The final adjustment is **subtracted** from the move score, so:
- Negative raw value = bonus (good tile to keep)
- Positive raw value = penalty (bad tile to keep)

### Extracted Single-Tile Values (count=1)

| Tile | Raw Adj | Points | Assessment |
|------|---------|--------|------------|
| ? (blank) | +2440 | +24.40 | Excellent |
| S | +721 | +7.21 | Excellent |
| X | +419 | +4.19 | Very good |
| Z | +359 | +3.59 | Very good |
| E | +299 | +2.99 | Good |
| R | +245 | +2.45 | Good |
| A | +220 | +2.20 | Good |
| N | +199 | +1.99 | Good |
| D | +188 | +1.88 | Good |
| T | +148 | +1.48 | Moderate |
| I | +150 | +1.50 | Moderate |
| H | +136 | +1.36 | Moderate |
| L | +122 | +1.22 | Moderate |
| O | +26 | +0.26 | Neutral |
| G | +11 | +0.11 | Neutral |
| C | +1 | +0.01 | Neutral |
| U | -88 | -0.88 | Slight penalty |
| Y | -68 | -0.68 | Slight penalty |
| P | -117 | -1.17 | Penalty |
| M | -130 | -1.30 | Penalty |
| K | -134 | -1.34 | Penalty |
| B | -163 | -1.63 | Penalty |
| F | -202 | -2.02 | Penalty |
| W | -294 | -2.94 | Penalty |
| J | -369 | -3.69 | Bad |
| V | -498 | -4.98 | Bad |
| Q | -879 | -8.79 | Very bad |

### Multi-Copy Diminishing Returns

Keeping duplicate tiles generally has diminishing value:

| Tile | 1 copy | 2 copies | 3 copies | 4 copies |
|------|--------|----------|----------|----------|
| E | +2.99 | +3.78 | +1.11 | -2.38 |
| S | +7.21 | +11.90 | +12.60 | N/A |
| Blank | +24.40 | +39.18 | N/A | N/A |
| A | +2.20 | +1.67 | -2.56 | -7.32 |

---

## 2. VCB Resources (Vowel Count Balance)

### Structure

Eight VCB resources exist (VCBa through VCBh), but **only VCBh contains actual data** - VCBa through VCBg are all zeros and may be placeholders or runtime buffers.

VCBh uses the same 28-byte record format as MUL resources, with 8 records indexed by vowel count (0-7 vowels).

### Loading

VCB resources are loaded by CODE 15 at offset 0x0C3A-0x0C54:
- Loop iterates 8 times
- Resource handles stored at A5-10900 (array of 8 4-byte handles)
- Resource type constructed as 'VCB' + letter ('a' through 'h')

### VCBh Vowel Count Adjustments

| Vowels | Raw Adj | Points | Assessment |
|--------|---------|--------|------------|
| 0 | -756 | -7.56 | Poor (all consonants) |
| 1 | -273 | -2.73 | Suboptimal |
| 2 | -19 | -0.19 | Okay |
| 3 | +23 | +0.23 | Good |
| 4 | +368 | +3.68 | Optimal |
| 5 | +134 | +1.34 | Good |
| 6 | -281 | -2.81 | Suboptimal |
| 7 | -1238 | -12.38 | Poor (all vowels) |

**Observation:** The optimal vowel count is 4 vowels in a 7-tile rack (approximately 57% vowels).

### Usage

CODE 32 accesses VCB handles at A5-10904 and A5-10908 (offsets within the handle array). The exact application logic is unclear from the partially-corrupted disassembly, but it appears to be applied based on the vowel count of the leave.

---

## 3. ESTR Resource (Synergy Patterns)

### Structure

The ESTR resource (536 bytes) contains 130 null-terminated pattern strings used for combination/synergy scoring.

### Pattern Categories

**Single letters (base reference):**
```
?, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
```

**Duplicate letter patterns:**
```
??, aa, aaa, aaaa, aaaaa
bb, cc, dd, ddd, dddd
ee, eee, eeee, eeeee, eeeeee
ff, gg, ggg, hh
ii, iii, iiii, iiiii
ll, lll, llll, mm
nn, nnn, nnnn
oo, ooo, oooo, ooooo
pp, rr, rrr, rrrr
ss, sss, ssss
tt, ttt, tttt
uu, uuu, uuuu, vv, ww, yy
```

**Consonant digraphs:**
```
ch, ck
```

**Q-related patterns:**
```
qu     - Q with U (traditional synergy)
aq     - Q + A (QAT hook potential)
aiq    - Q + A + I (QI playable, QAID potential)
adq    - Q + A + D (QADI potential)
aqt    - Q + A + T (QAT potential)
adiq   - Q + A + D + I (multiple Q-without-U words)
```

**Suffix/prefix patterns:**
```
gin, flu, ily, ino, inot, ity
osu, otu, eiv, eiz
amn, emn, boy, bel, ery, ary, fiy
elss, enss, imu
```

**Vowel/consonant balance:**
```
aeiou  - All five vowels
iu, uw - Vowel pairs
```

**Consonant clusters:**
```
bgjkf, mpxhwy, udlnrst, jx
dg, fhkwvy, bcmp, lnrtsu
fhwyx, dgbmp, fhkjwyx
```

### Value Computation

**Important:** ESTR only stores the pattern strings, not their values. The synergy values are computed at runtime by CODE 39 using the six score tables at A5-12512 through A5-12532.

CODE 39 uses a 9632-byte stack frame for exhaustive letter combination analysis:
1. Collects valid letter pairs from rack
2. Generates all pair combinations
3. Looks up scores from direction-specific tables (hook-before/hook-after)
4. Applies multi-letter combination bonuses

---

## 4. Total Leave Evaluation

### Formula

```
Total Leave Value = Sum(MUL adjustments for each tile) + VCBh adjustment for vowel count + Synergy adjustments
```

### Example: Evaluating "SATIRE"

1. **MUL adjustments (per-tile):**
   - S (1 copy): +721 centipoints
   - A (1 copy): +220 centipoints
   - T (1 copy): +148 centipoints
   - I (1 copy): +150 centipoints
   - R (1 copy): +245 centipoints
   - E (1 copy): +299 centipoints
   - **Subtotal: +1783 centipoints = +17.83 points**

2. **VCBh adjustment:**
   - Vowel count = 3 (A, I, E)
   - VCBh[3] = +23 centipoints = +0.23 points

3. **Synergy (computed by CODE 39):**
   - Would check patterns like SATIRE letter combinations
   - Values computed at runtime, not stored

4. **Total: ~+18.06 points** (MUL + VCB only)

### Code Reference

The leave evaluation REPL (`leave_eval.py`) demonstrates this calculation using extracted MUL and VCB data.

---

## 5. Resource Loading Summary

| Resource | A5 Offset | Count | Purpose |
|----------|-----------|-------|---------|
| MULa-MULz, MUL? | A5-10868 | 27 handles | Per-tile leave adjustments |
| VCBa-VCBh | A5-10900 | 8 handles | Vowel count adjustments (only h has data) |
| ESTR | Loaded separately | 1 | Pattern strings for synergy |
| EXPR | A5-10908 | 1 | Base experience values |

---

## 6. Critical Discovery: VCB May Not Be Used

**IMPORTANT:** Detailed disassembly analysis reveals that Maven accesses the **FRST** resource (A5-10904), not VCBh (A5-10872), for leave adjustments. The FRST resource is **all zeros** on disk.

### Evidence

From CODE 32, CODE 35, and CODE 3 disassembly:
```asm
; CODE 35 at 0x03B6-0x03BE:
03B6: JSR        66(A5)              ; Multiply D0 by 28
03BA: MOVEA.L    -10904(A5),A0       ; Load FRST handle (NOT VCBh!)
03BE: MOVE.L     24(A0,D0.L),D3      ; Get leave adjustment (always 0)
```

The handle array layout in memory:
```
A5-10908: EXPR resource handle
A5-10904: FRST resource handle (224 bytes, all zeros)
A5-10900: VCBa handle (start of VCB array)
A5-10896: VCBb handle
...
A5-10872: VCBh handle (the only one with real data)
```

### CONFIRMED: FRST is All Zeros at Runtime

**Verified via QEMU GDB debugging (2026-01-23):**

Connected to Maven running in QEMU and read FRST memory directly at runtime:
```
=== FRST: Disk vs Memory ===
Disk all zeros: True
Memory all zeros: True
```

This disproves the hypothesis that FRST is computed at runtime. Maven genuinely does NOT apply vowel count adjustments during normal gameplay - the FRST resource remains all zeros.

**VCBh data exists but is not used:**
```
=== VCBh: Disk vs Memory ===
Vowels   Disk       Memory     Match
0        -756       -757       ~1 diff
1        -1015      -1016      ~1 diff
2        -713       -713       Yes
3        23         23         Yes
4        368        368        Yes
5        11         11         Yes
6        -605       -605       Yes
7        -1238      -1238      Yes
```

VCBh values are loaded into memory but the code accesses FRST (zeros) instead.

### Current Status

- **MUL values:** Used and working (offset 24 only)
- **VCB adjustment:** NOT applied (FRST is zeros)
- **Synergy (ESTR/CODE 39):** Score tables are working buffers, dynamically populated per position

---

## 7. Score Table Architecture (CODE 39 Synergy System)

### Score Table Lifecycle

The 6 synergy score tables follow a clear lifecycle:

| Step | Code | What Happens |
|------|------|-------------|
| **Allocation** | CODE 2, JT[1666] | `NewPtr(2304)` × 6 = 13,824 bytes total |
| **Population** | CODE 39, Pass 3+ | Dynamically filled per board position |
| **Usage** | CODE 39, all passes | Read during combination scoring |
| **Scope** | Per-position | Recomputed for each position being evaluated |

### Key Insight: Tables Are Working Buffers

The 6 score tables at A5-12512 through A5-12532 are **NOT pre-loaded from resources**. They are working buffers that CODE 39 populates dynamically during each position evaluation:

```asm
; Pass 3 in full_combination_analysis (CODE 39 at 0x02B6):
02B6: MOVE.W  (A2),D4              ; Get entry from valid_pairs
02B8: MOVEQ   #18,D0               ; 18 bytes per ESTR record
02BA: MULU    D4,D0                ; index = entry * 18
; Clear table1 and table3 entries:
02C0: ADDA.L  -9596(A6),A0         ; A0 = table1 + offset
02C4: CLR.W   (A0)                 ; table1[entry].value = 0
02C8: ADDA.L  -9604(A6),A0         ; A0 = table3 + offset
02CC: CLR.W   (A0)                 ; table3[entry].value = 0
; Copy from cross-check data into table2:
02D6: ADDA.L  -9610(A6),A1         ; A1 = table2 + offset
02DA: MOVE.W  -13318(A0),(A1)      ; table2[entry] = cross_check_score
```

The source data comes from the cross-check score array near A5-13318, which is populated by the move generation system before CODE 39 is called.

### Direction-Specific Tables

CODE 39 selects different table sets based on move direction:
- **Horizontal (hook-after):** g_horiz_scores1/2/3 (A5-12532, A5-12528, A5-12524)
- **Vertical (hook-before):** g_vert_scores1/2/3 (A5-12520, A5-12516, A5-12512)

### ESTR Record Layout (18 bytes)

```c
typedef struct {
    int16_t value;           /* +0:  Base synergy value */
    int16_t synergy[7];      /* +2:  Seven synergy bonus fields (one per rack size) */
    int16_t position_mult;   /* +16: Position multiplier */
} ESTRRecord;  /* Total: 18 bytes, 128 records per table */
```

---

## 8. MUL Record Format (Revised)

### Confirmed Fields

CODE 32 only reads **offset 24** from MUL records:
```asm
MOVEA.L -10868(A0),A0        ; Dereference MUL handle
MOVE.L  24(A0),-36(A6)       ; Load ONLY offset 24
SUB.L   -36(A6),D0           ; Subtract from score
```

### Revised Record Interpretation

| Offset | Size | Type | Purpose | Confidence |
|--------|------|------|---------|------------|
| 0-7 | 8 | IEEE 754 double (BE) | Expected turn score from simulation | HIGH |
| 8-15 | 8 | Unknown | Simulation metadata (NOT reliably IEEE double) | LOW |
| 16-19 | 4 | Unknown | Simulation metadata (values 1-4 billion, NOT sample counts) | LOW |
| 20-23 | 4 | int32 (BE) | Likely simulation sample count (values: 25-55K range) | MEDIUM |
| 24-27 | 4 | int32 (BE) | **Leave adjustment in centipoints (USED AT RUNTIME)** | VERY HIGH |

### Analysis of "Secondary Double" (offset 8-15)

Testing multiple interpretations of the secondary field:
- **IEEE 754 double**: Some records decode to ±0.0 or -0.0 (reasonable), others produce astronomical garbage (e.g., 4.77×10¹¹ for blank record 0)
- **SANE 80-bit extended at [0:10]**: Produces huge numbers (10⁹ to 10¹¹), worse than IEEE
- **SANE 80-bit extended at [8:18]**: Mixed results (some ±0, some ∞)

**Conclusion**: The secondary field is likely simulation metadata in a format we haven't identified (possibly SANE 80-bit extended with padding, or a compound multi-field structure). It is NOT used at runtime by CODE 32.

### Scale Problem: RESOLVED

The "scale problem" (blank = +5.15 pts from record 0 vs expected +25 pts) is now fully explained:

**Record 0 (-515 centipoints) is the BASELINE, not the leave value itself.** The actual leave value depends on the weighted average across all possible tile counts:

| Record | Adj (centipoints) | Meaning | Relative to baseline |
|--------|-------------------|---------|---------------------|
| 0 | -515 | Have 0 blanks | 0 (baseline) |
| 1 | +2440 | Have 1 blank | +2955 (+29.55 pts) |
| 2 | +3851 | Have 2 blanks | +4366 (+43.66 pts) |

The binomial-coefficient normalization at CODE 32 offset 0x1604 (FDIVX) divides the accumulated adjustments by the combinatorial weight sum, producing the correct expected leave value.

The FMULX at offset 0x159A multiplies **binomial coefficients** (not a "scale factor"), computing `C(n,i) * C(m,j-i)` for the hypergeometric distribution of tile draws.

**This is the same tile distribution model described in Brian Sheppard's publications on Maven** - using the hypergeometric distribution to compute expected leave values given the unseen tile pool.

---

## 9. Known Unknowns

1. **~~Why FRST is all zeros~~:** CONFIRMED - FRST is vestigial or intentionally disabled.

2. **~~Score table population~~:** RESOLVED - Tables are working buffers populated by CODE 39 per-position, not from resources.

3. **MUL secondary field (offset 8-15):** Format unknown. Not IEEE 754 double for all records. Not used at runtime.

4. **MUL field at offset 16-19:** Values in billions range - purpose unknown. Not used at runtime.

5. **MUL field at offset 20-23:** Likely simulation sample count (values 25-55K). Not used at runtime.

6. **~~SANE scaling factor in CODE 32:~~** RESOLVED - The FMULX at 0x159A multiplies binomial coefficients `C(n,i) * C(m,j-i)`, not a scalar. The FDIVX at 0x1604 divides by the total binomial weight. Together they compute a hypergeometric-weighted average.

7. **Cross-check score source (A5-13318):** The initial data that CODE 39 copies into score tables comes from a 256-byte cross-check score array. How this array is populated by the move generation system is not fully traced.

---

## 10. Implementation Notes

### For Reimplementation

1. Load all 27 MUL resources and extract offset-24 values for all 8 records per tile
2. Build a binomial coefficient table: `C(n,k)` for n=0..100, k=0..7
3. For each tile type on rack, compute the binomial-weighted average:
   - Sum relative adjustments `(MUL[i+1].adj - MUL[0].adj)` for valid tile counts
   - Divide by `Σ C(unseen_count, i) * C(rack_count, j-i)` (hypergeometric normalization)
4. **Do NOT apply VCBh adjustment** (Maven uses FRST which is zeros)
5. The synergy scoring (CODE 39) is position-dependent and requires the full move generation context
6. A simplified implementation using only MUL per-tile values (record 1) captures reasonable accuracy; the full binomial weighting captures the game-state-dependent accuracy

### Confidence Level

- **MUL offset 24 values:** VERY HIGH (confirmed by CODE 32 disassembly + QEMU)
- **VCBh NOT being used:** HIGH (FRST access confirmed in disassembly + QEMU)
- **Score tables = working buffers:** HIGH (CODE 39 writes confirmed in disassembly)
- **ESTR pattern strings:** HIGH (directly readable from resource)
- **MUL fields 0-7 (double):** MEDIUM-HIGH (consistent reasonable values)
- **MUL fields 8-23:** LOW (format uncertain, not used at runtime)

---

## Appendix: Raw Data Files

- MUL resources: `/Volumes/T7/retrogames/oldmac/maven_re/resources/MUL*/0_0.bin`
- VCB resources: `/Volumes/T7/retrogames/oldmac/maven_re/resources/VCB*/0_0.bin`
- ESTR patterns: `/Volumes/T7/retrogames/oldmac/maven_re/resources/ESTR/0_pattern_strings.bin`
- Leave evaluator: `/Volumes/T7/retrogames/oldmac/maven_re/leave_eval.py`
- QEMU debug tool: `/Volumes/T7/retrogames/oldmac/maven_re/qemu_debug.py`
- MUL format analysis: `/Volumes/T7/retrogames/oldmac/maven_re/analyze_mul_detailed.py`
