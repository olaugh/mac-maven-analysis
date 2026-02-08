# CODE 32 Analysis - Core Move Scoring, Leave Evaluation, and V/C Balance

## Overview

| Property | Value |
|----------|-------|
| Size | **2,320 bytes** (resource) / **6,464 bytes** (QEMU memory dump) |
| JT Offset | 2384 (0x0950) |
| JT Entries | 13 |
| Functions | ~20 (large module) |
| Categories | CORE_AI, SCORING, LEAVE_EVAL, VCB |
| Purpose | Complete move scoring with binomial-weighted leave evaluation and vowel/consonant balance |
| Confidence | **HIGH** |

**NOTE**: The resource file (2,320 bytes) contains only a portion of the code. The full 6,464-byte
image from a QEMU memory dump was used for analysis. The disassembler mangles SANE A9EB trap
sequences and some indexed addressing; critical sections were decoded manually from raw hex.

## System Role

CODE 32 is the central scoring module that:
1. Evaluates base tile scores with letter/word multipliers
2. Scores cross-words formed by placed tiles
3. Applies bingo bonus (5000 centipoints = 50 points for using all 7 tiles)
4. Computes **binomial-weighted leave values** using MUL resources and SANE FP
5. Computes **vowel/consonant balance** adjustments algorithmically (NOT via VCBh resource)
6. Tracks best positions for move generation

**Related CODE resources**:
- CODE 15: Loads MUL resources (leave value tables per tile)
- CODE 35: Full score/leave calculation (simulation engine)
- CODE 39: Letter combination synergy scoring
- CODE 45: Move ranking

## Functions

| Offset | Frame | Name | Purpose |
|--------|-------|------|---------|
| 0x0000 | 324 | `evaluate_move` | Main move evaluation (base scoring, bingo, position tracking) |
| 0x064C | 0 | `filter_positions` | Filter board positions by bitmask |
| 0x08B8 | 136 | `init_scoring_context` | Initialize scoring buffers and tile distribution params |
| 0x09D8 | 40 | `leave_orchestrator` | **Leave evaluation orchestrator: iterates ESTR patterns, counts V/C/blanks** |
| 0x0BFC | 6 | `cached_vc_leave` | **Cached V/C leave calculator with 256-byte hash table** |
| 0x0CC0 | 4 | `blank_dispatcher` | **Blank-assignment dispatcher: tries V/C assignments for blanks** |
| 0x0DAC | 272 | `core_vc_calculator` | **Core V/C-parameterized leave calculator (nested-loop probability)** |
| 0x0EF6 | varies | (unknown) | Related to leave integration |
| **0x1406** | **50** | `binomial_leave` | **Per-tile binomial-weighted leave calculation (SANE FP)** |
| 0x1648 | 0 | `tile_string_helper` | String/tile classification helper |
| 0x18E8 | varies | (unknown) | Called before V/C calculation |

## Architecture: Leave Evaluation Pipeline

```
evaluate_move (0x0000)
  └─ init_scoring_context (0x08B8)
       ├─ Fills tile distribution params (local_20, local_22, etc.)
       └─ Sets up working buffers
  └─ leave_orchestrator (0x09D8)
       ├─ For each of 128 ESTR patterns:
       │   ├─ Classify each letter: vowel/consonant/blank (JT[2002])
       │   ├─ Compute cross-check score from A5-27630
       │   ├─ Call tile_string_helper (0x1648)
       │   ├─ Q-without-U penalty check (search for 'q' in pattern)
       │   └─ blank_dispatcher (0x0CC0)
       │        ├─ 2 blanks: try 3 V/C combos, take best
       │        ├─ 1 blank: try 2 V/C combos, average
       │        └─ 0 blanks: direct call
       │        └── cached_vc_leave (0x0BFC)
       │              ├─ Cache lookup: A5-2712[consonant*32 + vowel*4]
       │              └─ Cache miss: core_vc_calculator(V,C,...) - core_vc_calculator(0,0,...)
       │                   └── core_vc_calculator (0x0DAC)
       │                        ├─ Copy MUL adj values into 256-byte local array
       │                        ├─ Nested loop over tile draws
       │                        └─ Return V/C-weighted leave value
       └─ binomial_leave (0x1406)
            ├─ Per-tile hypergeometric-weighted average
            ├─ Uses SANE 80-bit extended precision
            └─ Pascal's triangle for C(n,k) coefficients
```

## Key Discovery: Vowel/Consonant Balance

**Maven's V/C balance is computed algorithmically, NOT via the VCBh resource.**

The VCBh resource exists but is accessed via the FRST handle at A5-10904, which is all zeros.
The actual V/C mechanism is a chain of four functions in CODE 32:

### 1. Leave Orchestrator (0x09D8, frame=40)

Iterates 128 ESTR letter patterns. For each pattern:
- Classifies letters as vowel/consonant/blank using JT[2002]
- Computes cross-check scores from per-letter value table at A5-27630
- Delegates to the blank dispatcher with V/C/blank counts

Key offsets in orchestrator's frame:
| Local | Offset | Purpose |
|-------|--------|---------|
| vowel_count | -36(A6) | Count of vowels in pattern |
| consonant_count | -34(A6) | Count of consonants in pattern |
| blank_count | -32(A6) | Count of blanks ('?') in pattern |
| local_30 | -30(A6) | Pointer from string helper |
| local_26 | -26(A6) | Counter (from init_scoring_context) |
| local_22 | -22(A6) | Tile distribution param (from init) |
| local_20 | -20(A6) | Tile distribution param (from init) |
| local_18 | -18(A6) | Tile distribution param (from init) |
| cross_check | -16(A6) | Cross-check score string |

### 2. Blank-Assignment Dispatcher (0x0CC0, frame=4)

Handles blank tiles by trying all possible V/C assignments:

```c
long blank_dispatcher(short vowel, short consonant, short blank_count,
                      short local_20, short local_22, short total) {
    if (blank_count == 2) {
        // Try all 3 combinations, return best
        long r1 = cached_vc_leave(vowel,   consonant+2, local_20, local_22, total);
        long r2 = cached_vc_leave(vowel+1, consonant+1, local_20, local_22, total);
        long r3 = cached_vc_leave(vowel+2, consonant,   local_20, local_22, total);
        return max(r1, max(r2, r3));
    }
    if (blank_count == 1) {
        // Average of 2 combinations
        long r1 = cached_vc_leave(vowel,   consonant+1, local_20, local_22, total);
        long r2 = cached_vc_leave(vowel+1, consonant,   local_20, local_22, total);
        return (r1 + r2) / 2;
    }
    // No blanks: direct call
    return cached_vc_leave(vowel, consonant, local_20, local_22, total);
}
```

### 3. Cached V/C Leave Calculator (0x0BFC, frame=6)

Maintains a 256-byte cache at A5-2712, indexed by `[consonant*32 + vowel*4]`:

```c
long cached_vc_leave(short vowel, short consonant, short local_20,
                     short local_22, short total) {
    if (vowel == 0 && consonant == 0) return 0;

    // Cap total at 7 (rack size)
    if (vowel + consonant + total > 7)
        total = 7 - vowel - consonant;

    // Check cache (keyed by local_20, local_22 match)
    long* cache = &g_vc_cache[consonant * 32 + vowel * 4];
    if (cache_valid) return *cache;

    // Cache miss: compute relative value
    long actual  = core_vc_calculator(vowel, consonant, local_20, local_22, total);
    long baseline = core_vc_calculator(0, 0, local_20, local_22, total);
    *cache = actual - baseline;
    return *cache;
}
```

### 4. Core V/C Calculator (0x0DAC, frame=272)

The actual computation. Uses a 256-byte local array (8 rows × 32 bytes).

**Phase 1**: Copies MUL adj values (offset 24) for tile `total_tiles` into the local array in reverse order:
```c
for (i = 0; i <= total_tiles; i++) {
    local_256[(total_tiles - i) * 4] = MUL_handles[total_tiles][i * 28 + 24];
}
```

**Phase 2**: Nested loop computes V/C-weighted combination of leave values:
- Outer: D7 from (total-1) downto leave_size (= vowel + consonant)
- Inner: D3 from consonant upward, while D3 <= D7 - vowel
- Each iteration multiplies and divides values from the local array, accumulating results
- Uses JT[66] (multiply) and JT[90] (divide)

**Return**: Reads final result from local_256 array at index based on vowel+consonant.

This nested loop effectively marginalizes over all ways to partition draws into vowels and consonants, computing the expected leave value for the specific V/C ratio.

### Why E is Preferred Over AE

The cache table indexed by `[consonant*32 + vowel*4]`:
- Leave E (1 vowel, 0 consonants): `cache[0*32 + 1*4]` = `cache[4]`
- Leave AE (2 vowels, 0 consonants): `cache[0*32 + 2*4]` = `cache[8]`

These store **different** values because the V/C-parameterized calculation at 0x0DAC produces different results for different V/C ratios. Having 2 vowels and 0 consonants in the leave is penalized more heavily than 1 vowel and 0 consonants, because the probability of drawing a balanced rack from the bag is worse.

## Per-Tile Binomial-Weighted Leave Calculation (0x1406)

### Algorithm

The leave value for each tile type is computed as a **hypergeometric-weighted average**
across possible tile counts, NOT a simple per-tile lookup.

**Formula:**
```
result = Σ(MUL[i+1].adj - MUL[0].adj) / Σ(C(n,i) × C(m,j-i))
```

Where:
- `MUL[k].adj` = offset-24 (int32 centipoints) of the k-th 28-byte MUL record
- `C(n,k)` = binomial coefficients from Pascal's triangle table
- Record 0 is the baseline; records 1-7 are per-count adjustments

### Data Structures

**Binomial coefficient table** (A5-2448, allocated on first call):
- 8080 bytes = 101 entries × 80 bytes
- Each entry = 8 × 10-byte SANE extended values
- `entry[n][k] = C(n,k)` built via Pascal's triangle recurrence
- Initialized: slot 0 = 1.0 (C(n,0) = 1), slots 1-7 = 0

**MUL record** (28 bytes, 8 per tile):
- Offset 24-27: int32 leave adjustment in centipoints (ONLY field used at runtime)
- Records indexed by tile count: 0=baseline, 1-7=per-count values

### SANE Operations (7 traps in binomial_leave function)

| Offset | Opcode | Operation | Purpose |
|--------|--------|-----------|---------|
| 0x14DC | $0000 | FADDX | Pascal's triangle: C(i,j) = C(i-1,j) + C(i-1,j-1) |
| 0x159A | $0004 | FMULX | Binomial weight: C(n,i) × C(m,j-i) |
| 0x15B4 | $0000 | FADDX | Accumulate weight sum |
| 0x15E4 | $2804 | FL2X | Convert integer adj to extended |
| 0x15F0 | $0000 | FADDX | Accumulate adj sum |
| 0x1610 | $0006 | FDIVX | Normalize: adj_sum / weight_sum |
| 0x163A | $2810 | FX2L | Convert extended result to long integer |

## Verified Constants

| Offset | Value | Meaning |
|--------|-------|---------|
| 0x0328 | 7 | Bingo tile count threshold |
| 0x0330 | 0x1388 = 5000 | Bingo bonus in centipoints (50 points) |
| 0x0C2A | 7 | Max rack size (V+C+blank capped at 7) |
| 0x0C30 | 7 | Same cap in leave calculation |
| 0x1438 | 0x1F90 = 8080 | Binomial coefficient table size |

## Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| $A9EB | _FP68K | SANE floating-point operations (7 calls in binomial_leave) |

## Jump Table Calls

| Offset | Count | Purpose |
|--------|-------|---------|
| 66(A5) | ~14 | 32-bit multiply (heavy use for table indexing) |
| 90(A5) | ~3 | 32-bit divide |
| 418(A5) | ~10 | Bounds check / error handler |
| 426(A5) | 2 | memset |
| 1666(A5) | 1 | NewPtr (allocate binomial table) |
| 2002(A5) | 1 | is_vowel classifier (returns non-0 for vowel) |
| 3506(A5) | 1 | strcmp |
| 3514(A5) | 1 | strncmp / search |
| 3522(A5) | 2 | strlen |

## Global Variables

| Offset | Name | Size | Description |
|--------|------|------|-------------|
| A5-2448 | g_binom_table | 4 | Binomial coefficient table ptr (8080 bytes, allocated) |
| A5-2712 | g_vc_cache | 256 | V/C leave cache [consonant*32 + vowel*4] |
| A5-10868 | g_mul_handles | 108 | Array of 27 MUL resource pointers (a-z + blank) |
| A5-10900 | g_mul_handles_alt | 108 | Secondary MUL handle array (used by 0x0DAC) |
| A5-12538 | g_unseen_count | 2 | Number of unseen tiles in bag |
| A5-13318 | g_cross_scores | ~256 | Cross-check score accumulator |
| A5-17158 | g_best_col | 2 | Best column position |
| A5-17160 | g_best_col2 | 2 | Second best column |
| A5-17162 | g_best_row | 2 | Best row position |
| A5-17164 | g_best_row2 | 2 | Second best row |
| A5-20004 | g_score_counter | 4 | Scoring operation counter |
| A5-20008 | g_score_counter_prev | 4 | Previous counter (threshold) |
| A5-20010 | g_tile_count | 2 | Tiles placed in current move |
| A5-26158 | g_rack | 4 | Pointer to current rack string |
| A5-27630 | g_letter_values | 256 | Per-letter point values |

## MUL Record Examples

| Tile | Record 0 (baseline) | Record 1 (1 copy) | Relative |
|------|---------------------|--------------------|----------|
| ? (blank) | -515 (-5.15 pts) | +2440 (+24.40 pts) | +29.55 pts |
| S | -337 (-3.37 pts) | +721 (+7.21 pts) | +10.58 pts |
| E | -219 (-2.19 pts) | +299 (+2.99 pts) | +5.18 pts |
| Q | +88 (+0.88 pts) | -879 (-8.79 pts) | -9.67 pts |

Number of populated records matches tile frequency in the game (blank=2, S=4, Q=1, etc.).

## Confidence

| Aspect | Status |
|--------|--------|
| File size | VERIFIED (2,320 resource / 6,464 memory) |
| Bingo bonus (5000 = 50pts) | VERIFIED |
| Binomial-weighted leave algorithm | VERIFIED (manual hex decode) |
| Indexed MUL record access (all 8 records) | VERIFIED (extension word 0x0818) |
| Pascal's triangle construction | VERIFIED (FADDX recurrence) |
| SANE operations catalog | VERIFIED |
| VCB mechanism (algorithmic, not VCBh resource) | VERIFIED (manual hex decode) |
| Blank-assignment dispatcher logic | VERIFIED |
| V/C cache table structure | VERIFIED |
| Core V/C calculator (0x0DAC) outer structure | VERIFIED |
| Core V/C calculator (0x0DAC) inner computation | PARTIALLY VERIFIED |
| Detailed analysis | `analysis/detailed/code32_detailed.md` |
| Leave calculation details | `analysis/code32_leave_calc.md` |
