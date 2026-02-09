# CODE 36 Detailed Analysis - Move Evaluation and Caching Coordinator

## Overview

| Property | Value |
|----------|-------|
| Size | 9102 bytes (9106 with 4-byte file header) |
| JT Offset | 2520 |
| JT Entries | 5 |
| Functions | 15 (including 1 without LINK frame) |
| Purpose | **Move evaluation coordinator: scoring, leave eval, caching pipeline** |

## System Role

**Category**: Move Evaluation Engine
**Function**: Central move scoring and caching coordinator

CODE 36 is the **heart of Maven's move evaluation pipeline**. It coordinates:
1. Position-based score calculation (cross-check penalties, premium squares)
2. Leave value integration (via CODE 32)
3. Score caching for endgame search optimization
4. Multi-rack evaluation with blanks, bingos, and positional weighting
5. Direction-dependent scoring (vertical vs horizontal)

This is not a simple cache module -- it is the **move evaluation dispatcher** that ties together word scoring (CODE 35), leave evaluation (CODE 32), letter synergy (CODE 39), and cross-check scoring into a unified move ranking system.

## Architecture

### Call Graph

CODE 36 makes JT calls to 26 distinct targets and is called by the search engine (likely CODE 40/44). Its internal call structure is:

```
0x180C (full_evaluate) ─── main entry point for complete evaluation
  ├── 0x163E (setup_board_state)
  ├── 0x1336 (count_letter_adjustments)
  ├── 0x14CC (sort_and_organize_cache)
  ├── 0x17C2 (build_position_list)
  ├── 0x1710 (accumulate_scores) ──── called 10+ times per direction
  │     └── JT[2714] (external score function)
  ├── 0x16CE (iterate_move_list) ──── wrapper calling 0x1710
  ├── 0x178C (iterate_score_list) ─── wrapper calling 0x17C2
  ├── 0x1136 (manage_cache_results) ── endgame cache layer
  │     └── 0x091A (evaluate_move)
  │           ├── 0x0000 (position_score)
  │           └── JT[2498] (CODE 32 leave eval)
  └── 0x0188/0x04D6/0x06DA (cache_store variants)
        └── 0x1372 (cache_search_insert)
```

### Jump Table Usage

| JT Offset | Count | Purpose |
|-----------|-------|---------|
| 66 | 23 | 32-bit multiply (LMUL) |
| 74 | 1 | Score threshold check |
| 90 | 21 | 32-bit divide (LDIV) |
| 418 | 17 | bounds_error assertion |
| 426 | 7 | memset (zero-fill) |
| 1658 | 1 | External: setup/init |
| 1666 | 1 | External: allocate cache memory |
| 1674 | 1 | External: free cache memory |
| 1682 | 1 | External: get rack value |
| 2114 | 1 | External: store best move |
| 2130 | 2 | External: submit candidate move |
| 2298 | 1 | External: begin score phase |
| 2306 | 1 | External: end score phase |
| 2354 | 1 | External: check if move valid |
| 2370 | 2 | External: prepare scoring (CODE 35/39) |
| 2378 | 2 | External: finalize scoring |
| 2386 | 4 | External: restore rack state |
| 2394 | 1 | External: get rack size |
| 2410 | 9 | External: restore game state |
| 2418 | 3 | External: save game state |
| 2426 | 1 | External: clear score tables |
| 2466 | 1 | External: evaluate position quality |
| 2490 | 1 | External: generate best move |
| 2498 | 7 | External: CODE 32 leave evaluation |
| 2522 | 1 | External: CODE 35 score computation |
| 2602-2618 | 3 | External: score table setup (CODE 39) |
| 2706-2746 | 3 | External: cache/list operations |
| 3466 | 3 | memmove |
| 3482 | 2 | memset with pattern |
| 3490-3522 | 5 | External: dictionary/word operations |

## Key Data Structures

### Move Data Structure (34 bytes)

The move structure used throughout CODE 36 appears at offset A3 or A4:

```c
typedef struct Move {
    char     word[16];       /* +0:  letters in the word (null-terminated) */
    int32_t  base_score;     /* +16: raw tile score (before multipliers) */
    int32_t  total_score;    /* +20: accumulated total score */
    int32_t  bonus_score;    /* +24: cross-word and premium bonuses */
    uint16_t flags;          /* +28: move flags (bitmask) */
    uint16_t position;       /* +30: encoded board position (row*17+col) */
    uint8_t  direction;      /* +32: 0=vertical, nonzero=horizontal */
    uint8_t  row;            /* +33: starting row */
} Move;  /* 34 bytes total */
```

### Cache Entry Structure (66 bytes)

```c
typedef struct CacheEntry {
    struct CacheEntry* next;  /* +0:  linked list pointer */
    int32_t  score;           /* +4:  composite evaluation score */
    uint8_t  reserved[6];     /* +8:  padding/unused */
    int16_t  list_index;      /* +14: position in sorted list */
    /* Embedded move copy (34 bytes): */
    char     word[16];        /* +16: word letters */
    int32_t  base_score;      /* +32: raw score */
    int32_t  total_score;     /* +36: total score */
    int32_t  bonus_score;     /* +40: bonus score */
    uint16_t flags;           /* +44: move flags */
    uint16_t position;        /* +46: board position */
    uint8_t  direction;       /* +48: 0=vert, else=horiz */
    uint8_t  row;             /* +49: starting row */
    /* End of embedded move */
    int32_t  position_hash;   /* +50: cached position hash (for lookup) */
    uint16_t score_flags;     /* +54: NOT(position) mask for cache keying */
    int16_t  cross_score;     /* +56: cross-word score adjustment */
    int16_t  modifier;        /* +58: leave value modifier */
    uint8_t  tiles_placed;    /* +60: number of tiles from rack */
    uint8_t  rack_count[4];   /* +61: letter counts for 4 tracked positions */
    uint8_t  pad;             /* +65: padding to 66 bytes */
} CacheEntry;
```

### Score Tables (A5-relative globals)

The code references multiple word-indexed score tables at deep negative A5 offsets:

| Offset | Size | Description |
|--------|------|-------------|
| A5-17420 | ~2000 | Primary position score table (word-indexed by position*2) |
| A5-13318 | ~2000 | Secondary position score table |
| A5-26152 | ~2000 | Cross-check score table (indexed by rack_size) |
| A5-25748 | ~2000 | Score variant table (with blank+vowel) |
| A5-25492 | ~2000 | Score variant table (no blanks, no vowels) |
| A5-25364 | ~2000 | Score variant table (blank, no special vowel) |
| A5-25236 | ~2000 | Score variant table (special vowel, no blank) |
| A5-25108 | ~2000 | Score variant table (special vowel + blank) |
| A5-24852 | ~2000 | Score variant table (has vowel letterX) |
| A5-24832 | ~2000 | Score variant table (base lookup) |
| A5-24812 | ~2000 | Score variant table (extended) |

These tables are pre-computed per board position by CODE 39 and stored at A5-relative addresses. They represent the marginal value of placing a tile at each position given the current board state.

### Key Global Variables

| Offset | Type | Name | Description |
|--------|------|------|-------------|
| A5-1812 | int32 | g_best_score | Best score found so far |
| A5-1816 | int32 | g_cache_mem_size | Cache memory allocation size |
| A5-1820 | ptr | g_cache_ptr | Cache lookup table (NULL if disabled) |
| A5-1822 | int16 | g_score_multiplier | Multiplier for leave integration |
| A5-1838 | int16[8] | g_score_per_rack | Per-rack-size score thresholds |
| A5-1840 | int16 | g_score_threshold | Current minimum viable score |
| A5-1842 | int16 | g_has_special_vowel | Flag: rack has tracked vowel |
| A5-1844 | int16 | g_rack_tiles_left | Tiles remaining in rack after play |
| A5-1846 | int16 | g_rack_size_adj | Adjusted rack size (usually 7) |
| A5-1848 | int16 | g_rack_full_size | Full rack size before play |
| A5-1852 | ptr | g_bingo_cache | Pointer to 7-tile play cache |
| A5-1920 | int32 | g_worst_cache_score | Worst score in cache (for eviction) |
| A5-1924 | int32 | g_cache_hash_base | Hash base value for cache keying |
| A5-1928 | ptr | g_sorted_list_tail | Tail of sorted move list |
| A5-1932 | ptr | g_secondary_list | Secondary sorted list |
| A5-1936 | ptr | g_primary_list | Primary sorted list |
| A5-1938 | int16 | g_blank_adj_value | Blank tile score adjustment |
| A5-1958 | int16 | g_vowel_adj_value | Special vowel adjustment |
| A5-2058 | arr | g_letter_adj_table | Per-letter adjustment lookup |
| A5-2060 | int16 | g_current_depth | Current search depth/iteration |
| A5-2064 | ptr | g_position_buffer | Position evaluation buffer |
| A5-2084 | arr | g_scoring_workspace | Workspace for score computation |
| A5-2086 | int16 | g_tracked_letter[0] | 1st tracked high-value letter |
| A5-2088 | int16 | g_tracked_letter[1] | 2nd tracked high-value letter |
| A5-2090 | int16 | g_tracked_letter[2] | 3rd tracked high-value letter |
| A5-2092 | int16 | g_tracked_letter[3] | 4th tracked high-value letter |
| A5-2094 | int16 | g_rack_size | Number of tiles in rack |
| A5-11980 | ptr | g_rack_data_copy | Copy of rack data for restoration |
| A5-12508 | ptr | g_cache_array | Pointer to cache entry array |
| A5-12540 | int16 | g_cache_count | Number of entries in cache |
| A5-12555 | byte | g_has_letterX | Whether rack has letterX (vowel) |
| A5-12551 | byte | g_has_letterY | Whether rack has letterY (consonant) |
| A5-12605 | byte | g_player_blank_count | Player's blank tile count |
| A5-12668 | arr | g_letter_placed | Per-letter placement tracking |
| A5-17154 | arr | g_board_letters | 17x17 board letter grid |
| A5-18460 | arr | g_position_mask | Position bitmask table |
| A5-19470 | arr | g_game_state | Game state buffer |
| A5-20010 | int16 | g_tiles_placed | Tiles placed in current move |
| A5-23040 | int32 | g_score_bound | Score pruning bound |
| A5-23056 | arr | g_best_move | Best move found (34-byte Move) |
| A5-23101 | byte | g_has_vowelY | Has specific tracked vowel |
| A5-23105 | byte | g_has_consonantX | Has specific tracked consonant |
| A5-23155 | byte | g_total_blank_count | Total blanks in game |
| A5-23218 | arr | g_rack_letters | Rack letter count array (128 bytes) |
| A5-23224 | ptr | g_rack_data | Pointer to full rack state |
| A5-23490 | int16 | g_endgame_flag | Whether in endgame mode |
| A5-26024 | arr | g_score_lookup | Score lookup table |
| A5-27434 | int16 | g_value_threshold | Letter value threshold |
| A5-27630 | arr | g_letter_values | Per-letter point values (word-indexed) |
| A5-27708 | ptr | g_leave_table | Leave evaluation table pointer |
| A5-27712 | ptr | g_synergy_table | Letter synergy table pointer |

## Disassembler Errors

The disassembler consistently mangles these multi-word instruction patterns:

1. **MULS.W #imm,Dn** (`C_FC xxxx`): Decoded as `ANDA.L #imm,An`. Occurs at 0x003E, 0x01AE, 0x0212, etc. The pattern `C1FC 0042` is MULS.W #66,D0 (entry size calculation), and `C3FC 0011` is MULS.W #17,D1 (board row stride).

2. **ADDA.W Dn,An** (`D0C0`-`D0C7`, `D2C0`-`D2C7`, etc.): Decoded as `MOVE.B Dn/An,(An)+`. The idiom `ADDA.W D0,A0; ADDA.W D0,A0` (doubling an index and adding to base) appears throughout for word-indexed table access.

3. **ADD.L An,Dn** and **ADD.L Dn,An** (`D28A`, `D5CA`, `D1CA`, etc.): Various ADD forms decoded incorrectly as MOVE.B.

4. **SUB.W Dn,Dn** (`9A40`-`9A43`): Decoded as `MOVEA.B Dn,An`. The sequence `9A43; 9A42; 9A40; 9A41` at 0x011A is `SUB.W D3,D5; SUB.W D2,D5; SUB.W D0,D5; SUB.W D1,D5`.

5. **CMP.L d(An,Xn),Dn** (`BEB0 0804`): Complex indexed addressing decoded as separate instructions. The pattern at 0x01B6 is `CMP.L 4(A0,D0.L),D7`.

6. **MULU.W d(An),Dn** (`C1ED xxxx`): Decoded as `ANDA.L d(An),An`. At 0x01E4: `C1ED F8E2` is `MULU.W -1822(A5),D0`.

7. **ADD.W (An),D7** (`DE94`): Decoded as `MOVE.B (An),(A7)`.

8. **CMP.W Dn,Dn** (`BC45`, `B843`, etc.): Often decoded incorrectly with wrong mode bits.

9. **ADDQ.L #1,An** (`528A`, `528B`): Decoded as `MOVE.B An,(An)`.

10. **LSR.W #n,Dn** (`EE46`): At 0x0C66, `EE46 = LSR.W #7,D6` is decoded as `MOVEA.L D6,A7`.

11. **SUB.L An,Dn** (`9C88`, `9C84`): Decoded as `MOVE.B An,(An)`.

12. **CMP.B Dn,Dn** (`B200`, `B62A`, etc.): Sometimes decoded with wrong operand size.

## Function Analysis

### Function 0x0000: calc_position_score (392 bytes)

**Purpose**: Calculates the positional component of a move's score, accounting for which tiles are played from the rack versus already on the board.

**Parameters**:
- 8(A6) = Move* move_data
- 12(A6) = int16 comparison_value

**Returns**: D0 = position score adjustment

**Algorithm**:
1. Early exit if base_score <= 5000 or blanks match (no positional advantage)
2. If cache enabled: iterate through word letters, checking each position
   - For each unoccupied cell: look up position value, check if cached
   - If not cached or different from comparison value: add letter adjustment
3. If cache disabled: directly compute from 4 tracked letter positions
   - Special case: 7-tile bingo gets fixed score of 7
   - Otherwise: tiles_placed - sum(position_data[tracked_letters])
4. Final aggregation: process all word letters against rack contents
   - Compare placed counts vs rack counts
   - Apply score lookup adjustments for discrepancies

```c
int16_t calc_position_score(Move* move, int16_t comparison)
{
    int16_t score = 0;

    if (move->base_score <= 5000)
        return 0;
    if (g_total_blank_count == g_player_blank_count)
        return 0;

    if (g_cache_ptr != NULL) {
        /* Cache-assisted path */
        int16_t row = move->row;
        int16_t dir = move->direction;
        /* D1 = row, multiply by 17, add board base */
        int32_t idx = row;
        idx *= 17;          /* MULS.W #17,D1 */
        char* board = g_board_letters;  /* LEA -17154(A5),A2 */
        board += idx;
        board += dir;       /* A2 = &g_board_letters[row*17 + dir] */

        char* wp = move->word;
        int16_t ch = *wp;
        while (ch != 0) {
            if (*board == 0) {  /* cell unoccupied */
                if (g_letter_values[ch*2] < 800) {
                    /* Look up position mask */
                    int16_t player_off = g_player_blank_count;
                    int32_t hash_idx = ch;
                    hash_idx <<= 1;
                    /* Complex lookup through game state + position mask */
                    int16_t combined = NOT(move->flags) | g_game_state[...];
                    combined &= g_position_mask[...];
                    int16_t cached = *(g_cache_ptr + combined);
                    if (cached != comparison) {
                        score += g_letter_placed[ch];
                    }
                    /* Also store comparison value back */
                    *(g_cache_ptr + combined) = comparison;
                }
            }
            wp++; board++;
            ch = *wp;
        }
    } else {
        /* Direct calculation path */
        if (g_tiles_placed == 7) {
            score = 7;  /* bingo: all tiles placed */
        } else {
            /* Score = tiles_placed - sum of 4 tracked letter adjustments */
            int16_t v0 = g_letter_placed[g_tracked_letter[2]];
            int16_t v1 = g_letter_placed[g_tracked_letter[0]];
            int16_t v2 = g_letter_placed[g_tracked_letter[3]];
            int16_t v3 = g_letter_placed[g_tracked_letter[1]];
            score = g_tiles_placed - v3 - v2 - v1 - v0;
        }
    }

    /* Final letter-by-letter aggregation */
    char* wp = move->word;
    int16_t modifier = 0;
    int8_t c63 = g_rack_letters[63];     /* blank sentinel */
    int8_t p63 = g_letter_placed[63];
    modifier = g_score_lookup[p63];       /* base modifier */

    while (*wp != 0) {
        int8_t placed = g_letter_placed[*wp];
        if (placed != 0) {
            g_letter_placed[*wp] = 0;     /* mark as consumed */
            int8_t count = g_rack_letters[*wp];
            if (count != placed) {
                score -= g_score_lookup[0];
                modifier &= g_score_lookup[count*2 + placed];
            }
        }
        wp++;
    }

    assert(modifier != 0);  /* JT[418] if zero */
    return score + modifier;
}
```

### Function 0x0188: cache_store_primary (846 bytes)

**Purpose**: Stores a move evaluation into the primary move cache. Implements score-based replacement with hash lookup for duplicate detection.

**Parameters**: 8(A6) = Move* move

**Algorithm**:
1. Skip if tiles_placed > 7
2. Compute composite hash: hash_base + base_score (via ADD.L from score at offset 16)
3. Compare hash against worst entry in cache (last entry by sorted order)
4. If not better, exit immediately
5. Compute adjusted index: (rack_size - tiles_placed), clamped to [1, 7]
6. Call 0x1336 (letter adjustment helper) to get modifier
7. Calculate final score: base + (tiles_placed * multiplier * modifier / adjusted_index)
8. Recheck against worst cache entry
9. Assert cache count == 90 (cache must be full for replacement)
10. If cache lookup table exists:
    - Look up by position field (offset 30 in move)
    - Verify: direction, row, tiles_placed, 4 tracked letter counts
    - If match found and new score is better: update in place
    - If match found but not better: exit
11. If no match or no cache table:
    - For 7-tile plays: use bingo cache, compute letter value sum
    - For regular plays: gather 4 tracked letter counts
    - Call 0x1372 to find insertion point
    - Copy move data (34 bytes via 8 MOVE.L + 1 MOVE.W loop)
    - Store metadata: tiles count, tracked letter counts, score hash
    - Set position hash (NOT of position field) for score_flags
    - Call 0x0000 to compute cross-score adjustment
    - Update cache lookup table entry

```c
void cache_store_primary(Move* move)
{
    if (g_tiles_placed > 7) return;

    int32_t* score_ptr = &move->base_score;
    int32_t hash = g_cache_hash_base + *score_ptr;

    /* Quick check: can this beat the worst cached entry? */
    int32_t worst_offset = (g_cache_count - 1) * 66;
    CacheEntry* worst = (CacheEntry*)((char*)g_cache_array + worst_offset);
    if (hash <= worst->score) return;

    /* Compute leave adjustment index */
    int16_t adj = g_rack_size - g_tiles_placed;
    adj -= 7;
    if (adj <= 0) adj = (adj == 0) ? 7 : 1;

    /* Get leave modifier from letter analysis */
    int32_t modifier = count_letter_adjustments();  /* PC-relative 0x1336 */

    /* Integrate leave value */
    int32_t tiles_score = g_tiles_placed;
    tiles_score *= g_score_multiplier;      /* MULU.W */
    /* Stack-based 32-bit math: push adj, push tiles_score, push modifier */
    int32_t combined = (modifier * tiles_score) / adj;
    combined += *score_ptr;
    hash = combined;

    /* Recheck after full calculation */
    if (hash <= worst->score) return;
    assert(g_cache_count == 90);  /* cache must be full */

    /* Try to find existing entry via cache lookup */
    if (g_cache_ptr != NULL) {
        int8_t idx = g_cache_ptr[move->position];
        if (idx != -1) {
            /* Validate matching entry */
            CacheEntry* entry = &g_cache_array[idx];
            /* Check position hash, direction, row, all 5 counts */
            if (/* all match */ && hash > entry->score) {
                /* Update in place */
                entry->score = hash;
                memcpy(&entry->word, move, 34);  /* 8 longs + 1 word */
                entry->modifier = modifier;
                return;
            }
        }
    }

    /* Create new entry (or find insertion point) */
    /* ... calls 0x1372 for sorted insertion ... */
    /* ... fills all cache entry fields ... */

    /* Update cache lookup table */
    if (g_cache_ptr != NULL) {
        entry->position_hash = move->position;
        g_cache_ptr[move->position] = (int8_t)(entry_index);
    }
}
```

### Function 0x04D6: cache_store_secondary (516 bytes)

**Purpose**: Secondary cache store variant. Nearly identical structure to 0x0188 but validates against a different set of tracked letters. Used for the second search pass (different letter tracking context).

Key differences from 0x0188:
- Validates entry letter counts at offsets 61-64 against A2 (a different entry pointer) rather than A4
- Has an assertion path at 0x0616-0x0622 (bounds_error if match fails validation)
- Does not have the bingo (7-tile) special path
- Updates cache lookup table differently

### Function 0x06DA: cache_store_with_threshold (576 bytes)

**Purpose**: Third cache store variant that adds threshold-based filtering. Includes additional score comparison against g_worst_cache_score (A5-1920) and handles the case where the cache is not yet full.

Key additions over 0x0188:
- At entry: if cache count == 90, compares hash against g_worst_cache_score and exits if not better
- When cache is not full (count < 90): uses ADDQ.W #1 to grow the cache
- After insertion: updates g_worst_cache_score via `MOVE.L 4(last_entry),-1920(A5)`
- Contains the same bingo scoring path (letter value sum * 2 + base_score)

### Function 0x091A: evaluate_move (2076 bytes, frame=-24)

**Purpose**: The **main evaluation dispatcher**. Takes a move candidate and a game state, computes the full composite score including positional value, cross-word scores, leave evaluation, and blank/bingo adjustments.

**Parameters**:
- 8(A6) = Move* move (A4)
- 12(A6) = GameState* state (A3)

**Returns**: D0 = composite evaluation score (D6 at exit)

**Frame variables**:
- -6(A6): adjusted tiles remaining
- -10(A6): position score table lookup
- -14(A6): cross-score base
- -18(A6): intermediate calculation
- -24(A6): accumulated adjustment

**Algorithm overview**:

The function has two major paths selected by direction:

```c
int32_t evaluate_move(Move* move, GameState* state)
{
    move->total_score = 0;  /* CLR.L 20(A4) */

    if (move->direction == 0) {
        /* VERTICAL path (falls through from 0x0936) */
        goto vertical_eval;
    } else {
        /* HORIZONTAL path (branches to 0x0C46) */
        goto horizontal_eval;
    }
}
```

#### Vertical Path (0x0936-0x0C40)

1. **Position lookup** (0x0936-0x094A):
   - Compute position*2 index, look up in score_table_2 (A5-17420)
   - Store result in local -10(A6)

2. **Base score computation** (0x094C-0x095E):
   - D6 = initial score from position lookup
   - Subtract cross_score_base (32(A3)) and bonus_score (36(A3))
   - D4 = tiles_placed from state (60(A3))

3. **Rack size clamping** (0x0960-0x097E):
   - Compare tiles with rack_tiles_left (A5-1844)
   - D5 = min(rack_tiles_left, tiles_placed)
   - Compute adjusted remaining = rack_tiles_left - tiles_placed

4. **Cross-check letter iteration** (0x0988-0x09BA):
   - Iterate through word in state, skip 'q' (0x71) and cells matching adjacent
   - For each letter: compute value adjustment via g_letter_values lookup
   - Accumulate into D4

5. **Leave value computation** (0x09D6-0x0A96):
   - Complex multi-step calculation using JT[66] (multiply) and JT[90] (divide)
   - Accounts for tiles_placed, rack_size, and letter distribution
   - If rack has special blank tiles: uses different score table variants
   - Calls JT[90] for final division to normalize

6. **Special vowel/consonant paths** (0x0A9A-0x0C36):
   - Multiple branches based on:
     - g_has_special_vowel (A5-1842)
     - g_has_letterY (A5-12551)
     - g_has_consonantX (A5-12555)
     - g_total_blank_count vs g_player_blank_count
   - Each path selects a different score table for position-based adjustment
   - Some paths call JT[2498] (CODE 32 leave evaluation)
   - Adjustment of -300 or -1200 for bingo penalties/bonuses

7. **Final score assembly** (0x0C34-0x0C40):
   - Apply remaining adjustments to D6
   - Store into appropriate score tables

#### Horizontal Path (0x0C44-0x112E)

Mirrors the vertical path but with different table offsets and position calculations. Notable differences:

1. **Bingo fast path** (0x0C44-0x0C7C):
   - If state has exactly 7 tiles and rack_size - 7 >= tiles_placed:
   - Quick score from position table, shifted right by 7 (LSR.W #7,D6)
   - Subtract secondary table value
   - Skip the full evaluation

2. **Cross-word bonus handling** (0x0C90-0x0C9E):
   - Checks bonus_score (36(A3)), and if nonzero AND not in endgame, subtracts from D6

3. **Bingo penalties** (0x0CCE-0x0CEE):
   - If blank counts differ and full rack size == 7: subtract 1200 (-$4B0 = bingo+blank)
   - Otherwise: subtract 300 (-$12C = standard bingo penalty)

4. **Rack balance bonus** (0x0F16-0x1038):
   - If has_special_vowel and certain conditions met:
   - Computes a rack balance adjustment via multiple score table lookups
   - May add +1200 (ADDI.L #$4B0) for balanced racks

5. **Multiple letter-specific adjustments** (0x1038-0x110E):
   - Complex branching based on which special letters are present
   - Each combination selects a different score table pair
   - Some paths include JT[2498] leave evaluation calls

### Function 0x1136: manage_cache_results (512 bytes, frame=-454)

**Purpose**: Post-search cache management. Iterates through sorted move lists, evaluates each candidate through the full scoring pipeline (calls 0x091A), and tracks the best result.

**Frame variables**:
- -362(A6): position evaluation buffer (large)
- -364(A6): flag indicating current state
- -368(A6): pointer to current position data
- -372(A6): best score so far
- -442(A6): counter 1
- -446(A6): counter 2
- -450(A6): sentinel value (200,000,000 = 0x0BEBC200)
- -454(A6): sentinel value

**Algorithm**:
1. Initialize counters and sentinel values (200M = "worst possible")
2. Set up position evaluation buffer
3. Load primary list (A5-1936) and secondary list (A5-1932)
4. Loop through both lists simultaneously (sorted merge):
   - Compare scores between primary and secondary
   - Pick the better candidate
   - Call JT[2722] for validation
   - If valid: evaluate cross-score, compute hash, compare with best
   - Call 0x091A to get full evaluation score
   - Track best score in -372(A6)
5. After processing all candidates:
   - Handle position scores with position_values multiplied by hash
   - Call JT[2114] to store best move
   - Update g_best_score (A5-1812)

### Function 0x1336: count_letter_adjustments (60 bytes, no LINK)

**Purpose**: Fast helper that computes a letter-by-letter adjustment value by comparing rack contents against placement counts.

**Algorithm**:
```c
int32_t count_letter_adjustments(void)
{
    /* A4 = g_bingo_cache, A3 = g_letter_adj_table */
    char* bingo = g_bingo_cache;   /* A5-1852 */
    char* adj = g_letter_adj_table; /* A5-2058 */
    int32_t result = 0;

    while (1) {
        int8_t letter = *bingo++;
        if (letter == 0) break;

        int16_t rack_count = g_rack_letters[letter];
        int16_t placed_count = g_letter_placed[letter];
        int16_t diff = rack_count - placed_count;
        if (diff != 0) {
            /* Adjust letter index and look up in adj table */
            int16_t idx = letter - 63;
            result += adj[idx] * diff;   /* MULS via indexed lookup */
        }
    }
    return result;
}
```

### Function 0x1372: cache_search_insert (346 bytes, frame=-66)

**Purpose**: Searches the cache for an entry matching the given move and inserts/updates as needed. Uses a 66-byte local buffer for temporary entry storage during sorted insertion.

**Parameters**:
- 8(A6) = cache_array pointer
- 12(A6) = score hash (D7)
- 16(A6) = Move* move (A3)
- Additional params on stack: 4 tracked letter counts

**Algorithm**:
1. Compute entry offset: 66 * cache_count + cache_base
2. Compute board position index: row * 17 + direction (MULS.W #17)
3. Look up in cross-reference table (A5-2262 relative)
4. If found: verify direction (offset 48), row (49), tiles_placed (60), and all 4 tracked letter counts (61-64)
5. If all match: compare scores
   - If existing score is better, return existing entry
   - Otherwise: copy current entry to local buffer, shift entries down, write new entry
6. If not found: scan linearly through entries
   - Compare direction, row, all validation fields
   - Insert in sorted position (shift higher-scoring entries up)
7. Return pointer to the entry (new or existing)

The sorted insertion uses three copy loops (16 longs + 1 word = 66 bytes each):
- Copy existing entry to local buffer
- Shift entries in array
- Copy local buffer to final position

### Function 0x14CC: cache_sort_reorganize (370 bytes, frame=-66)

**Purpose**: Reorganizes the cache after evaluation, sorting entries and computing final scores. Also handles the position lookup table update.

**Parameters**: 8(A6) = cache_array_offset

**Algorithm**:
1. If cache_count == 0, return NULL
2. For each entry (D5 loop counter):
   - Set up entry metadata: clear bytes 8-9, set direction/row from move at offset
   - Call JT[3522] for word hash
   - Look up score multiplier table at A5-1838
   - Call JT[2370] for full score calculation
   - Compute final entry score from CODE 35 result
3. Sort entries by score (insertion sort using 66-byte swaps)
4. For each sorted entry:
   - Check score against threshold (A5-1840)
   - If below threshold, mark as dead
   - Compute leave contribution: tiles_placed * multiplier / (66 * count)
   - Store final values
5. Clear the last entry (sentinel)
6. Return final cache pointer

### Function 0x163E: setup_board_state (144 bytes)

**Purpose**: Initializes board state and letter tracking for a new move evaluation. Sets up the g_letter_placed array and counts tiles from rack.

**Algorithm**:
1. Compute board position: row*17 + direction (MULS.W #17)
2. Initialize g_tiles_placed = 0
3. Zero-fill g_letter_placed (128 bytes via JT[426])
4. Walk through move letters:
   - If board cell is empty: increment g_tiles_placed
     - Look up rack vs board: if letter not in rack, assertion error
     - Increment g_player_blank_count if appropriate
   - If board cell occupied: increment g_letter_placed[letter]

### Function 0x16CE: iterate_word_list (66 bytes, frame=-2)

**Purpose**: Linked-list iterator that calls function 0x1710 for each node with score > 0.

```c
int16_t iterate_word_list(int32_t param1, int32_t param2, int16_t score,
                          int32_t param4, CacheEntry* list)
{
    CacheEntry* node = list;
    while (node != NULL) {
        if (node->direction > 0) {  /* offset 48 */
            score = accumulate_scores(param1, param2, score,
                                       node->score_flags, param4);
        }
        node = node->next;
    }
    return score;
}
```

### Function 0x1710: accumulate_scores (124 bytes)

**Purpose**: Accumulates position-specific scores for a set of board positions. Handles the per-position score lookup and optional leave evaluation integration.

**Parameters**:
- 8(A6) = Move* move (A3)
- 12(A6) = base pointer
- 16(A6) = current score (D6)
- 22(A6) = additional parameter (D7, can be -1 for sentinel)

**Algorithm**:
1. If additional param == -1 ($FFFF): return current score unchanged
2. Compute board position from score * 2
3. Look up in position table, add to accumulator
4. Walk through remaining positions, comparing against threshold
5. If any position exceeds threshold:
   - Call JT[2714] for external score evaluation
   - Add result to base pointer at offset 12(A6)
   - Increment D6

### Function 0x178C: iterate_score_list (54 bytes, frame=-4)

**Purpose**: Linked-list iterator for score accumulation. Calls 0x17C2 for each node.

```c
int32_t iterate_score_list(int32_t param1, int16_t param2,
                           int32_t param3, CacheEntry* list)
{
    CacheEntry* node = list;
    while (node != NULL) {
        param3 = build_position_list(param1, param2, param3, node);
        node = node->next;
    }
    return param3;
}
```

### Function 0x17C2: build_position_list (74 bytes)

**Purpose**: Builds a list of position values for scoring, filtering by score threshold.

**Algorithm**:
1. Store node pointer at offset 50 of output structure
2. Iterate through positions (D7 = counter, A3 = stride of 2)
3. For each position: look up score from node's score_flags table
4. If score != 0 and below threshold: add to output list
5. Write terminator (0) at end of list

### Function 0x180C: full_evaluate (2946 bytes, frame=-12974)

**Purpose**: The **top-level evaluation entry point**. Performs complete move evaluation for a board position including multi-pass scoring, caching, bingo detection, and result accumulation.

This is Maven's most complex single function. The massive 12974-byte stack frame accommodates:
- 90 cache entries x 66 bytes = 5940 bytes
- Position lookup buffers = ~4000 bytes
- Move data copies and workspace = ~3000 bytes

**Parameters**:
- 8(A6) = Move* initial_move (A4)
- 12(A6) = int16 mode_flag

**Frame layout**:
```
Offset      Size    Purpose
-12974      4       board row-1 pointer
-12970      4       board row+1 pointer
-12966      62      per-cell adjacency flags
-12904      362     evaluation workspace
-12542      362     position lookup buffer
-6240       5940    local cache array (90 x 66 bytes)
-300        34      move data working copy
-270        2       best score result
-266        4       scoring workspace
-262        38      sorted letter list
-230        32      bingo candidate data
-180        16      word data buffer
-164        128     rack letter availability
-101        1       blank count in current rack
-36         36      score phase data
```

**Algorithm** (simplified):

```c
Move* full_evaluate(Move* initial_move, int16_t mode)
{
    /* Phase 0: Initialize */
    JT_restore_state(initial_move);                   /* JT[2410] */
    g_rack_size = JT_get_rack_size(local_buffer);     /* JT[2394] */
    g_rack_data_copy = g_rack_data;                   /* save rack */

    /* Early exit: high-value opening check */
    if (mode == 0) {
        int32_t rack_value = JT_get_rack_value();     /* JT[1682] */
        int16_t blank_count = g_total_blank_count;
        int16_t local_blanks = local_buffer[-101];
        int16_t total = blank_count + local_blanks;
        if (g_total_blank_count != 0) total += 1;

        /* Compute threshold: total * 18 * multiplier */
        int32_t threshold = total;
        threshold *= 18;               /* MULS.W D3,D0; actually MULS #18 */
        threshold += A5;               /* add globals base */
        int16_t table_val = score_table[g_rack_size * 2];
        threshold *= 8224;             /* MULS.W #$2020 */

        if (JT_score_check(threshold) > 1700) {   /* JT[74] */
            /* Strong opening: submit directly */
            JT_submit_move(initial_move);              /* JT[2130] */
            return &g_best_move;
        }
    }

    /* Phase 1: Analyze rack composition */
    g_cache_hash_base = 0;
    char* sorted_letters = A5_sorted_rack;            /* A5-26158 */

    for each letter in sorted_rack {
        /* Compute per-letter hash contribution */
        int16_t score_adj = score_table_2[letter*2];
        if (score_adj > 0) {
            /* Look up in local buffer, multiply by letter value */
            int16_t local_count = local_buffer[letter];
            int16_t rack_count = g_rack_letters[letter];
            int32_t contribution = g_letter_values[letter*2] * local_count;
            g_cache_hash_base += contribution;

            /* Check for multi-tile positions */
            if (local_buffer[letter] > 1) {
                /* Store secondary letter and recalculate */
                /* ... handles 2+ of same tile ... */
            }
        }
    }

    /* Phase 2: Set up tracked letters */
    /* Clear all 4 tracked letter slots */
    g_tracked_letter[0..3] = 0;

    /* Walk sorted letter list, identify top 4 by value */
    for each letter with local_buffer[letter] > 0 {
        /* Shift existing tracked letters down */
        g_tracked_letter[0] = g_tracked_letter[1];
        g_tracked_letter[1] = g_tracked_letter[2];
        g_tracked_letter[2] = g_tracked_letter[3];
        g_tracked_letter[3] = letter;
    }

    /* Validate: must have at least 1 tracked letter */
    assert(g_tracked_letter[0] != 0);

    /* Prune low-value tracked letters if rack > 10 or > 13 */
    if (g_rack_size > 10) {
        if (g_letter_values[g_tracked_letter[2]*2] < g_value_threshold)
            g_tracked_letter[0..2] = 0;
    }
    if (g_rack_size > 13) {
        if (g_letter_values[g_tracked_letter[1]*2] <= g_value_threshold)
            g_tracked_letter[0..1] = 0;
    }

    /* Phase 3: Configure scoring parameters */
    /* Check for 'q' (0x71) in rack */
    JT_check_letter(0x71, initial_move);              /* JT[3514] */
    /* Set g_score_multiplier based on presence */
    g_score_multiplier = has_q ? -500 : 0;  /* $FE0C or 0 */
    /* Adjust for rack size */
    g_score_multiplier = (g_rack_size - 7) * g_score_multiplier;
    g_has_special_vowel = (has_special_vowel);

    /* Copy rack to letter array */
    memmove(g_rack_letters, local_buffer, 128);       /* JT[3466] */

    /* Phase 4: Initialize cache and score tables */
    g_cache_array = &local_cache[-6240];  /* point to local frame */
    g_cache_count = 0;
    g_worst_cache_score = 0xF4143E00;     /* sentinel: very bad */
    JT_save_state();                                  /* JT[2418] */

    /* Set up bingo cache */
    JT_setup_scoring(local_buffer, local_bingo);      /* JT[2706] */
    g_bingo_cache = &local_bingo;
    JT_init_score_tables();                           /* JT[2618] */

    /* Phase 5: Initialize per-position cache entries */
    for (int i = 0; i < g_cache_count; i++) {
        CacheEntry* e = &g_cache_array[i];
        e->cross_score = 0;
        e->position_hash = 0;
        e->score_flags = -1;  /* 0xFFFF */
    }

    /* Allocate and initialize cache lookup table */
    g_cache_mem_size = score_table[g_rack_size * 2];
    g_cache_ptr = JT_alloc_cache(g_cache_mem_size);   /* JT[1666] */
    if (g_cache_ptr != NULL) {
        JT_fill_cache(g_cache_ptr, 0xFFFF, g_cache_mem_size); /* JT[3482] */
    }

    /* Initialize per-cell adjacency flags */
    memset(local_cell_flags, 0, 62);                  /* JT[426] */

    /* Phase 6: Build position evaluation data */
    for (int i = 0; i < g_cache_count; i++) {
        /* Get direction and row from cache entry */
        int8_t dir = g_cache_array[i*66 + 48];  /* direction */
        int8_t row = g_cache_array[i*66 + 49];  /* row */

        /* Compute board indices */
        int16_t stride = 17;
        stride *= dir;
        char* board = g_board_letters;
        /* Check adjacent cells for cross-word opportunities */
        /* ... complex adjacency analysis ... */

        /* Store position score in cell flags */
        int16_t pos_score = score_table[row * 2];
        local_cell_flags[dir * 2] |= pos_score;
    }

    /* Phase 7: Pre-compute per-direction score tables */
    for (int dir = 0; dir < 8; dir++) {
        int16_t adjusted_rack = g_rack_size - dir;
        /* ... compute score thresholds per rack size ... */
    }
    g_score_threshold = g_score_per_rack[0];
    g_rack_size_adj = 7;
    g_rack_full_size = 7;
    g_rack_tiles_left = g_rack_size - 7;

    /* Set up sorted move lists */
    g_primary_list = cache_sort_reorganize(g_cache_array);  /* 0x14CC */
    JT_sort_moves();                                  /* JT[2746] */
    /* Link tail pointers */

    /* Phase 8: Multi-pass evaluation */
    /* First pass: full rack (7 tiles) */
    g_position_buffer = &local_pos_buf;
    int16_t depth = iterate_and_score(...);  /* 0x1710 via 0x16CE */

    /* Additional passes for tracked letters */
    if (g_tracked_letter[3] != 0) { /* pass with 4th letter excluded */ }
    if (g_tracked_letter[2] != 0) { /* pass with 3rd letter excluded */ }
    if (g_tracked_letter[1] != 0) { /* pass with 2nd letter excluded */ }
    if (g_tracked_letter[0] != 0) { /* pass with 1st letter excluded */ }

    /* Phase 9: Combine primary and secondary results */
    /* ... calls 0x16CE and 0x178C for list iteration ... */

    /* Phase 10: Per-candidate detailed evaluation */
    int16_t candidate_count = ...;
    for (int i = 0; i < candidate_count; i++) {
        /* Copy move data to working copy */
        memcpy(local_move, &g_best_move[i], 34);

        /* Check for valid word */
        if (!local_move.direction) continue;

        /* Check pruning bound */
        if (mode == 0 && i > 0) {
            if (local_move.total + local_move.bonus < g_score_bound)
                continue;  /* pruned */
        }

        /* Full scoring with 90-entry local cache */
        g_cache_count = 90;
        g_cache_array = &local_cache_2;
        /* Initialize all entries to worst score */

        /* Reset cache lookup */
        if (g_cache_ptr) {
            JT_fill_cache(g_cache_ptr, 0xFFFF, g_cache_mem_size);
        }

        /* Run full scoring pipeline */
        JT_restore_state(initial_move);               /* JT[2410] */
        JT_save_state();                              /* JT[2418] */

        /* Generate and score all moves for this position */
        JT_generate_moves(initial_move, local_move, ...);  /* JT[2610] */
        JT_restore_state(initial_move);               /* JT[2410] */
        JT_prepare_scoring(initial_move, local_move); /* JT[2370] */

        /* Score phase */
        JT_begin_scoring(local_score);                /* JT[2298] */
        g_secondary_list = cache_sort_reorganize(g_cache_array); /* 0x14CC */
        JT_end_scoring(local_score);                  /* JT[2306] */
        JT_finalize_scoring(initial_move);            /* JT[2378] */

        /* Multi-pass re-evaluation with updated data */
        /* ... same 5-pass structure as Phase 8 ... */

        /* Combine results from both lists */
        /* ... iterate_word_list + iterate_score_list ... */

        /* Final: manage results through 0x1136 */
    }

    /* Phase 11: Cleanup */
    if (g_cache_ptr != NULL) {
        JT_free_cache(g_cache_ptr);                   /* JT[1674] */
        g_cache_ptr = NULL;
    }

    return &g_best_move;
}
```

## The Move Evaluation Pipeline

### Overview

Maven's move evaluation proceeds in stages, managed by CODE 36:

```
Board Position
     |
     v
[Phase 1] Rack Analysis
  - Sort rack letters by value
  - Identify top 4 "tracked" letters (most valuable)
  - Compute hash base from letter distribution
  - Check for Q (heavy penalty: -500 per tile)
     |
     v
[Phase 2] Score Table Setup
  - CODE 39 pre-computes position-specific score tables
  - 6+ tables covering different letter/blank combinations
  - Tables indexed by board position (word-sized entries)
     |
     v
[Phase 3] Candidate Generation
  - Generate legal moves (external CODE segments)
  - Store in 66-byte cache entries (max 90)
  - Sort by preliminary score
     |
     v
[Phase 4] Multi-Pass Evaluation
  - Pass 0: Evaluate with all tracked letters
  - Pass 1-4: Re-evaluate excluding each tracked letter
  - Each pass updates score tables and thresholds
  - Linked-list iteration through candidates
     |
     v
[Phase 5] Detailed Re-Evaluation
  - For each remaining candidate:
    - Full 90-entry cache with position lookup
    - Complete scoring with cross-words
    - Leave evaluation (CODE 32)
    - Score = base_score + cross_score + leave_adj + position_adj
     |
     v
[Phase 6] Result Selection
  - Compare against best known score
  - Apply pruning bounds
  - Submit best move to game engine
```

### Scoring Formula

The composite score for a move is approximately:

```
score = base_tile_score
      + cross_word_bonus
      + bingo_bonus (if 7 tiles placed)
      + position_value (from pre-computed tables)
      - leave_penalty (from CODE 32)
      + blank_adjustment
      + vowel_consonant_balance
      + letter_synergy (from CODE 39)
```

The critical insight is that Maven evaluates moves **relative to the tiles remaining in the rack** (the "leave"). A move that scores well but leaves a terrible rack is penalized. The 5-pass evaluation with tracked letter exclusion allows Maven to accurately model the marginal value of each high-value tile.

### Cache Architecture

The caching system has three layers:

1. **Position lookup table** (g_cache_ptr): Byte-indexed by position hash, maps to cache entry index. Enables O(1) lookup for previously scored positions. Filled with 0xFF (invalid) between uses.

2. **66-byte entry cache** (g_cache_array, max 90 entries): Stores complete move data plus evaluation metadata. Sorted by score for quick pruning. Entry validation checks 7 fields (direction, row, tiles_placed, 4 tracked letter counts).

3. **Bingo cache** (g_bingo_cache): Separate cache for 7-tile plays, which have special scoring (letter value sum * 2 + base_score).

The cache replacement policy is **score-based**: a new entry replaces the worst existing entry only if its composite score is higher. The validation fields prevent stale cache hits when the rack composition changes between search iterations.

### Direction-Dependent Scoring

The function 0x091A implements separate vertical (0x0936) and horizontal (0x0C44) evaluation paths because:

1. **Cross-word scores** differ by direction (perpendicular words formed)
2. **Position values** are direction-specific (different premium squares affected)
3. **Bingo detection** has a fast path for horizontal 7-tile plays using pre-shifted tables

The vertical path is the "fallthrough" default, suggesting vertical moves may be slightly more common or were implemented first.

### Constants and Thresholds

| Value | Meaning |
|-------|---------|
| 5000 | Minimum base_score for position scoring eligibility |
| 800 | Letter value threshold for "high value" classification |
| 90 | Maximum cache entries (0x5A) |
| 66 | Cache entry size in bytes (0x42) |
| 17 | Board row stride (17x17 grid including borders) |
| 7 | Standard rack size / bingo tile count |
| 1200 | Bingo+blank penalty/bonus adjustment |
| 300 | Standard bingo penalty adjustment |
| 1700 | Early-exit score threshold (opening moves) |
| 200,000,000 | Sentinel "worst possible" score (0x0BEBC200) |
| -500 ($FE0C) | Q-without-U score multiplier penalty |
| 8224 ($2020) | Multiplication constant for threshold calculation |

## Confidence Assessment

**HIGH confidence**: Function boundaries, call graph, cache entry structure, general evaluation pipeline.

**MEDIUM confidence**: Exact scoring formula details, specific score table assignments, some local variable roles in the massive 0x180C function.

**LOW confidence**: Precise semantics of the 10+ score tables at A5-24000 to A5-27000 range, the exact letter-tracking algorithm in the multi-pass evaluation, and the pruning heuristics.

The disassembler output is heavily mangled (10+ systematic error patterns documented above), requiring careful manual hex verification for every multi-word instruction. The analysis above was verified against raw hex for all critical instruction sequences.
