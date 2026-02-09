# CODE 35 Analysis - Full Score/Leave Calculation

## Overview

| Property | Value |
|----------|-------|
| Size | 3276 bytes |
| JT Offset | 2488 |
| JT Entries | 4 |
| Functions | ~8 |
| Categories | SCORING, LEAVE_EVAL |
| Purpose | Complete move scoring with SANE FP leave evaluation |
| Confidence | HIGH |

**NOTE**: Previously miscategorized as "File I/O" / "DAWG_MINOR". The A9EB trap is _FP68K (SANE floating point), NOT _SFGetFile.

## System Role

CODE 35 is the comprehensive score calculation function that combines:
1. Base word scoring with cross-words and bonus squares
2. Bingo bonus (7+ letters)
3. Q/QU special handling
4. Per-tile rack leave evaluation using MUL resources
5. SANE extended precision (80-bit) arithmetic for precise calculations

**Related CODE resources**:
- CODE 32 (runtime consumer of leave values)
- CODE 39 (letter combination synergy scoring)
- CODE 42 (rack analysis)
- CODE 50 (stores results)

**Key insight**: Header note states it "computes FP averages from simulation, results stored as centipoints in MUL resources" - implying CODE 35 was used to PRE-COMPUTE the MUL resource data via simulation.

## Functions

| Offset | Frame | Purpose |
|--------|-------|---------|
| 0x0000 | 2 | Check position lower bound |
| 0x0030 | 2 | Check position upper bound |
| 0x0060 | 38 | Calculate extended precision product (SANE) |
| 0x0168 | 70 | Score calculation main (SANE) |
| 0x0310 | 0 | Sum word values with filtering |
| 0x0368 | 330 | **Full score calculation** (word + cross + bingo + Q + leave) |
| 0x0A44 | 12 | Calculate per-tile position scores |

## Toolbox Traps Used

| Trap | Name | Purpose |
|------|------|---------|
| $A9EB | _FP68K | SANE floating-point operations |

## SANE Operations Used

| Code | Operation |
|------|-----------|
| 0x0002 | FADDX (add extended) |
| 0x0004 | FMULX (multiply extended) |
| 0x0006 | FDIVX (divide extended) |
| 0x0008 | FCMPX (compare extended) |
| 0x000D | FRINTX (round to integer) |
| 0x0016 | Convert to extended |
| 0x2006 | Compare/add |
| 0x2008 | Compare |
| 0x280E | Move extended |
| 0x2810 | Extended to integer |
| 0x300E | Multiply extended |
| 0x3010 | Divide extended |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-1064 | g_char_class | Character classification table |
| A5-2270 | g_qu_string | "qu" pattern string |
| A5-2342 | g_q_penalty | Q-without-U penalty table |
| A5-2422 | g_bonus_table | Bonus square table (20 entries × 4 bytes) |
| A5-10904 | g_frst_handle | **FRST resource (all zeros) - NOT VCBh** |
| A5-10908 | g_expr_handle | EXPR resource handle |
| A5-10914 | g_board_size | Board dimension |
| A5-15498 | g_current_rack | Current player's rack string |
| A5-16610 | g_state2 | Score grid (17×17×2) |
| A5-17010 | g_game_flag | Game state flag |
| A5-17154 | g_state1 | Letter grid (17×17) |
| A5-23218 | g_letter_counts | Letter frequency array |
| A5-24850 | g_bingo_adj | Bingo adjustment value |
| A5-24866 | g_bingo_table | Bingo bonus lookup table |
| A5-26158 | g_rack | Player's rack pointer |
| A5-27374 | g_letter_primes | Letter prime values |
| A5-27630 | g_letter_points | Letter point values |

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 66(A5) | 32-bit multiply |
| 90(A5) | 32-bit divide |
| 418(A5) | bounds_error |
| 2002(A5) | is_letter_playable |
| 2370(A5) | process_rack |
| 2378(A5) | cleanup_rack |
| 2394(A5) | get_letter_info |
| 2410(A5) | setup_evaluation |
| 2498(A5) | calculate_letter_score |
| 2506(A5) | final_score_calculation |
| 2514(A5) | calculate_letter_value |
| 3514(A5) | strchr |
| 3522(A5) | strlen |

## Score Calculation Flow (Function 0x0368)

1. **Initialize**: Setup rack and letter counts via JT[2394], JT[2410]
2. **Word score**: Calculate base word value with letter/word multipliers
3. **Cross-words**: Score perpendicular words formed by placed tiles
4. **Bonus squares**: Apply DL/TL/DW/TW multipliers from bonus table
5. **Bingo bonus**: Add bonus for using 7+ tiles (from g_bingo_table)
6. **Leave evaluation**: Per-tile scoring for remaining rack
7. **Q handling**: Special bonus for QU together, penalty for Q without U
8. **Individual letters**: Score each remaining tile via JT[2498], JT[2514]
9. **Finalize**: JT[2378] cleanup, return total in centipoints

## Score Breakdown Markers

The function outputs detailed score breakdowns using marker values:
| Marker | Meaning |
|--------|---------|
| 20000 | Word score section |
| -1 | Terminator |
| -2 | Per-letter average |
| -3 | QU bonus |
| -4 | Q penalty |
| -5 to -11 | Individual letter contributions |
| -32 | Primary score |
| -33 | Bingo bonus |

## Key Discovery: FRST Access

At offset 0x03BA:
```asm
MOVEA.L -10904(A5),A0     ; Load FRST handle (NOT VCBh!)
MOVE.L  24(A0,D0.L),D3    ; Read offset 24 (always 0 - FRST is all zeros)
```

This confirms FRST (all zeros) is used instead of VCBh for vowel count adjustments, effectively disabling that component.

## Calls Functions In

CODE 2, 11, 23, 31, 32, 52

## Confidence: HIGH

- SANE operations clearly identified
- Scoring algorithm matches standard Scrabble rules
- FRST access confirmed via QEMU debugging
- Detailed analysis in `analysis/detailed/code35_detailed.md`
