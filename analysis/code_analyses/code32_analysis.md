# CODE 32 Analysis - Core Move Scoring and Leave Value Calculation

## Overview

| Property | Value |
|----------|-------|
| Size | **2,320 bytes** (resource) / **6,464 bytes** (QEMU memory dump) |
| JT Offset | 2384 (0x0950) |
| JT Entries | 13 |
| Functions | ~20 (large module) |
| Categories | CORE_AI, SCORING, LEAVE_EVAL |
| Purpose | Complete move scoring with binomial-weighted leave evaluation |
| Confidence | **HIGH** |

**NOTE**: The resource file (2,320 bytes) contains only a portion of the code. The full 6,464-byte
image from a QEMU memory dump was used for the leave calculation analysis. The disassembler
mangles SANE A9EB trap sequences; critical sections were decoded manually from raw hex.

## System Role

CODE 32 is the central scoring module that:
1. Evaluates base tile scores with letter/word multipliers
2. Scores cross-words formed by placed tiles
3. Applies bingo bonus (5000 centipoints = 50 points for using all 7 tiles)
4. Computes **binomial-weighted leave values** using MUL resources and SANE FP
5. Tracks best positions for move generation

**Related CODE resources**:
- CODE 15: Loads MUL resources (leave value tables per tile)
- CODE 35: Full score/leave calculation (simulation engine)
- CODE 39: Letter combination synergy scoring
- CODE 45: Move ranking

## Functions

| Offset | Frame | Purpose |
|--------|-------|---------|
| 0x0000 | 324 | Main move evaluation (base scoring, bingo, position tracking) |
| 0x064C | varies | Filter positions by mask |
| 0x08B8 | varies | Initialize scoring context |
| 0x0B42 | varies | Apply leave value to move score |
| **0x1406** | **50** | **Binomial-weighted leave calculation (SANE FP)** |
| 0x1648 | 0 | String/tile helper |

## Verified Constants

| Offset | Value | Meaning |
|--------|-------|---------|
| 0x0330 | 0x1388 = 5000 | Bingo bonus in centipoints (50 points) |
| 0x0328 | 7 | Bingo tile count threshold |
| 0x1438 | 0x1F90 = 8080 | Binomial coefficient table size (allocated) |

## Key Function: Binomial-Weighted Leave Calculation (0x1406)

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

### Key Instruction: Indexed MUL Record Access (0x15BE)

```asm
; D0 = (D4+1) * 28  (from MULS.W #28,D0 at 0x15BA)
2032 0818    MOVE.L  (24,A2,D0.L),D0
```

Extension word `0818` decodes as:
- D/A=0 (Data reg), Reg=0 (D0), W/L=1 (Long), Scale=×1, Displacement=0x18=24
- Effective: `A2 + (D4+1)*28 + 24` = MUL record (D4+1), offset 24

### SANE Operations (7 traps in leave function)

| Offset | Opcode | Operation | Purpose |
|--------|--------|-----------|---------|
| 0x14DC | $0000 | FADDX | Pascal's triangle: C(i,j) = C(i-1,j) + C(i-1,j-1) |
| 0x159A | $0004 | FMULX | Binomial weight: C(n,i) × C(m,j-i) |
| 0x15B4 | $0000 | FADDX | Accumulate weight sum |
| 0x15E4 | $2804 | FL2X | Convert integer adj to extended |
| 0x15F0 | $0000 | FADDX | Accumulate adj sum |
| 0x1610 | $0006 | FDIVX | Normalize: adj_sum / weight_sum |
| 0x163A | $2810 | FX2L | Convert extended result to long integer |

## Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| $A9EB | _FP68K | SANE floating-point operations (7 calls in leave function) |

## Jump Table Calls

| Offset | Count | Purpose |
|--------|-------|---------|
| 66(A5) | 14 | 32-bit multiply (heavy use for table indexing) |
| 90(A5) | - | 32-bit divide |
| 418(A5) | 10 | Bounds check / error handler |
| 426(A5) | 2 | memset |
| 1666(A5) | 1 | NewPtr (allocate binomial table) |
| 3522(A5) | 2 | strlen |

## Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-2448 | g_binom_table | Binomial coefficient table (8080 bytes, allocated) |
| A5-10868 | g_mul_handles | Array of 27 MUL resource pointers (a-z + blank) |
| A5-17158 | g_best_col | Best column position |
| A5-17160 | g_best_col2 | Second best column |
| A5-17162 | g_best_row | Best row position |
| A5-17164 | g_best_row2 | Second best row |
| A5-20010 | g_tile_count | Tiles placed in current move |

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
| Loop bounds / parameter semantics | PARTIALLY VERIFIED |
| Detailed analysis | `analysis/detailed/code32_detailed.md` |
| Leave calculation details | `analysis/code32_leave_calc.md` |
