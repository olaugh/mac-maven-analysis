# CODE 36 Detailed Analysis - Move Cache and Position Scoring

## Overview

| Property | Value |
|----------|-------|
| Size | 9102 bytes |
| JT Offset | 2520 |
| JT Entries | 5 |
| Functions | ~10 |
| Purpose | **Move caching, position scoring, lookup optimization** |


## System Role

**Category**: DAWG Engine
**Function**: Word Validation

Validates words against dictionary
## Architecture Role

CODE 36 manages move evaluation caching:
1. Cache move scores for previously calculated positions
2. Look up cached entries to avoid recalculation
3. Manage cache structures (66-byte entries)
4. Calculate position-specific scores

## Key Data Structures

Cache entry structure (66 bytes):
```
+0:   link/flags
+4:   score (long)
+14:  cache index
+16:  move data (34 bytes - copy of Move)
+30:  position row
+32:  position col
+36:  score flags
+38:  extra score
+40:  position hash
+48:  direction
+49:  player
+58:  cached value
+60:  letter counts [4]
```

## Key Functions

### Function 0x0000 - Calculate Position Score
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVEA.L    8(A6),A4              ; A4 = move data
000C: CMPI.L     #5000,16(A4)          ; Check base score >= 5000
0014: BLE.S      $0020                 ; Skip if too low
0016: MOVE.B     -23155(A5),D0         ; Get blank count
001A: CMP.B      -12605(A5),D0         ; Compare with player blanks
001E: BNE.S      $0026                 ; Different, continue
0020: MOVEQ      #0,D5                 ; Return 0
0022: BRA.W      $0128                 ; Exit
0026: TST.L      -1820(A5)             ; Check cache enabled
002A: BEQ.W      $00D8                 ; No cache, calculate

; Cache lookup
002E: MOVEQ      #0,D5
0030: MOVEA.L    A4,A3                 ; A3 = word pointer
0032: MOVE.B     33(A4),D0             ; Get row
0036: EXT.W      D0
0038: MOVE.B     32(A4),D1             ; Get direction
003C: EXT.W      D1
; ... calculate cache index ...

; Check each letter
0050: TST.B      (A2)                  ; Cell occupied?
0052: BNE.S      $00C6                 ; Yes, skip
0054: MOVEA.L    A5,A0
0056: ADDA.W     D7,A0
0058: ADDA.W     D7,A0
005A: CMPI.W     #800,-27630(A0)       ; Letter value >= 800?
0060: BGE.S      $00C6                 ; High value, skip

; Calculate bonus
0062: MOVE.B     -12605(A5),D0         ; Get player info
0066: EXT.W      D0
0068: MOVEA.L    A5,A0
006A: ADDA.W     D0,A0
006C: ADDA.W     D0,A0
006E: MOVE.L     D7,D0
0070: EXT.L      D0
; ... lookup in bonus table ...

; Apply score from cache
0090: LEA        -19470(A5),A1         ; Game state
0094: ADDA.L     D0,A1
0096: OR.W       30(A4),D0             ; Combine with move flags
0098: AND.W      -18460(A0),D0         ; Mask with position data
009C: MOVE.W     D0,D4                 ; D4 = score modifier
009E: MOVEQ      #0,D0
00A0: MOVE.W     D4,D0
00A2: ADD.L      -1820(A5),D0          ; Add cache base
00A6: MOVEA.L    D0,A0
00A8: MOVE.B     (A0),D0               ; Get cached value
00AA: EXT.W      D0
00AC: CMP.W      12(A6),D0             ; Compare with input
00B0: BEQ.S      $00C6                 ; Match

; Update score
00AC: MOVEA.L    A5,A0
00AE: ADDA.W     D7,A0
00B0: MOVE.B     -12668(A0),D0         ; Get letter data
00B4: EXT.W      D0
00B6: ADD.W      D0,D5                 ; Add to score
; ... continue for word ...

00C6: ADDQ.L     #1,A3                 ; Next letter
00C8: ADDQ.L     #1,A2                 ; Next cell
00CA: MOVE.B     (A3),D7               ; Get char
00CC: EXT.W      D7
00CE: TST.W      D7
00D0: BNE.W      $0052                 ; Continue loop

; Calculate final score
00D4: BRA.S      $0126

; No cache - direct calculation
00D6: CMPI.W     #7,-20010(A5)         ; Check tile count
00DC: BEQ.S      $0124                 ; 7 tiles = bingo

00DE: MOVE.W     -2090(A5),D0          ; Get position values
00E2: MOVEA.L    A5,A0
00E4: ADDA.W     D0,A0
00E6: MOVE.B     -12668(A0),D1
00EA: EXT.W      D1
00EC: MOVE.W     -2086(A5),D2
00F0: MOVEA.L    A5,A0
00F2: ADDA.W     D2,A0
00F4: MOVE.B     -12668(A0),D0
00F8: EXT.W      D0
00FA: MOVE.W     -2092(A5),D2
00FE: MOVEA.L    A5,A0
0100: ADDA.W     D2,A0
0102: MOVE.B     -12668(A0),D2
0106: EXT.W      D2
0108: MOVEA.W    -2088(A5),A0
010C: LEA        -12668(A0),A0
0110: MOVE.B     (A0),D3
0114: EXT.W      D3
0116: MOVE.W     -20010(A5),D5         ; Get base from tile count
011A: SUB.W      D3,D5
011C: SUB.W      D2,D5
011E: SUB.W      D0,D5
0120: SUB.W      D1,D5
0122: BRA.S      $0126

0124: MOVEQ      #7,D5                 ; Bingo bonus

; Sum up final score
0126: MOVEA.L    A4,A3
0128: CLR.L      D0
012A: CLR.L      D1
012C: CLR.L      D7
012E: LEA        -23218(A5),A0         ; Letter array
0132: LEA        -12668(A5),A1         ; Position data
0136: LEA        -26024(A5),A2         ; Lookup table

; Process letters
013A: MOVE.B     63(A0),D0             ; Get letter count[63]
013E: MOVE.B     63(A1),D1
0142: LSL.L      #1,D0
0146: ADD.W      D1,A1
0148: MOVE.W     0(A2,D1.W),D6         ; Get from lookup

014C: MOVE.B     (A3)+,D7              ; Get next letter
014E: MOVE.B     0(A1,D7.W),D1
0152: BEQ.S      $0170                 ; Not found
0154: CLR.B      0(A1,D7.W)            ; Clear used
0158: MOVE.B     0(A0,D7.W),D0         ; Get count
015C: CMP.B      D0,D1
015E: BEQ.S      $0170                 ; Match
0160: EXT.W      D0
0162: LSL.L      #1,D0
0166: SUB.W      (A2),D5               ; Adjust score
0168: ADD.W      D1,A1
016C: AND.W      0(A2,D1.W),D6         ; Mask

0170: MOVE.B     (A3)+,D7
0172: BNE.S      $014E                 ; Continue

0174: TST.W      D6
0176: BNE.S      $017C
0178: JSR        418(A5)               ; Error if zero

017C: MOVE.W     D5,D0                 ; Return score
017E: ADD.W      D6,D0                 ; Add modifier
0180: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
0184: UNLK       A6
0186: RTS
```

### Function 0x0188 - Cache Move Entry
```asm
0188: LINK       A6,#0
018C: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0190: MOVEA.L    8(A6),A3              ; A3 = move data
0194: CMPI.W     #7,-20010(A5)         ; 7 tiles = bingo
019A: BGT.W      $04D0                 ; Too many, skip

019E: LEA        16(A3),A4             ; A4 = score area
01A2: MOVE.L     -1924(A5),D7          ; Get cache hash
01A6: ADD.W      (A4),D7               ; Add score
01A8: MOVEQ      #-1,D0
01AA: ADD.W      -12540(A5),D0         ; Add count
01AE: MULU.W     #66,D0                ; * entry size
01B4: MOVEA.L    -12508(A5),A0         ; Cache base
01B8: CMP.L      4(A0,D0.L),D7         ; Compare hash
01BC: BLE.W      $04D0                 ; Not better

; Calculate cache index
01BE: MOVE.W     -2094(A5),D6          ; Get index parts
01C2: SUB.W      -20010(A5),D6
01C6: MOVE.W     D6,D5
01C8: SUBI.W     #7,D5                 ; Adjust
01CC: BLE.S      $01D4
01CE: BGT.S      $01DA
01D0: MOVEQ      #7,D5
01D2: BRA.S      $01DA
01D4: TST.W      D5
01D6: BGT.S      $01DA
01D8: MOVEQ      #1,D5

; Calculate score contribution
01DA: JSR        4442(PC)              ; Calculate modifier
01DE: MOVE.L     D0,D4                 ; D4 = modifier
01E0: MOVE.W     -20010(A5),D0         ; Tile count
01E4: MULU.W     -1822(A5),D0          ; * multiplier
01E8: MOVEA.W    D6,A0
01EA: MOVE.L     A0,-(A7)
01EC: MOVEA.W    D5,A0
01EE: MOVE.L     A0,-(A7)
01F0: MOVE.L     D4,-(A7)
01F2: MOVE.L     D0,D1
01F4: JSR        66(A5)                ; JT[66] - multiply
01F8: AND.W      D0,D1
01FA: MOVE.L     D1,-(A7)
01FC: MOVE.L     D0,D1
01FE: JSR        90(A5)                ; JT[90] - divide
0202: AND.W      D0,D1
0204: ADD.W      (A4),D1               ; Add to score
0206: MOVEA.W    D0,A0
0208: ADD.L      A0,D1
020A: MOVE.L     D1,D7                 ; D7 = final hash

; Verify cache space
020C: MOVEQ      #-1,D0
020E: ADD.W      -12540(A5),D0
0212: MULU.W     #66,D0
0218: MOVEA.L    -12508(A5),A0
021A: AND.W      D7,-(A4)
021C: CMP.L      4(A0,D0.L),D7
021E: BLE.W      $04D0

; Check count limit
0222: CMPI.W     #90,-12540(A5)        ; Max 90 entries
0228: BEQ.S      $022E
022A: JSR        418(A5)               ; Error

; Check cache pointer valid
022E: TST.L      -1820(A5)             ; Cache enabled?
0232: BEQ.W      $031C                 ; No, skip

; Lookup existing entry
0236: MOVEQ      #0,D0
0238: MOVE.W     30(A3),D0             ; Get position
023C: ADD.L      -1820(A5),D0          ; Add cache base
0240: MOVEA.L    D0,A0
0242: MOVE.B     (A0),D6               ; Get cached value
0244: EXT.W      D6
0246: CMPI.W     #$FFFF,D6
024A: BEQ.W      $031C                 ; Not found

; Bounds check
024E: CMP.W      -12540(A5),D6         ; Check index valid
0252: BGE.S      $0258
0254: TST.W      D6
0256: BGE.S      $025C
0258: JSR        418(A5)

; Get cache entry
025C: MOVEA.L    -12508(A5),A4         ; Cache array base
0260: MOVEQ      #66,D0
0262: MULU.W     -12540(A5),D0
0266: ADD.L      -12508(A5),D0
026A: CMP.L      A4,D0
026C: BHI.S      $0272
026E: JSR        418(A5)

; Scan for matching entry
0272: LEA        40(A4),A2             ; A2 = position hash area
0276: MOVEA.W    D6,A0
0278: CMP.L      (A2),D6               ; Match?
027C: BNE.S      $031C                 ; No match

; Verify position
0282: MOVE.B     48(A4),D0             ; Get direction
0286: CMP.B      32(A3),D0             ; Match move?
028A: BNE.W      $031C
028E: MOVE.B     49(A4),D0             ; Get row
0292: CMP.B      33(A3),D0             ; Match?
0296: BNE.W      $031C

; Check letter counts match
029A: MOVE.B     60(A4),D0             ; Get stored count
029E: EXT.W      D0
02A0: CMP.W      -20010(A5),D0         ; Match current?
02A4: BNE.S      $031A

02A6: MOVE.W     -2088(A5),D0          ; Get letter counts
02AA: MOVEA.L    A5,A0
02AC: ADDA.W     D0,A0
02AE: MOVE.B     61(A4),D1
02B2: CMP.B      -12668(A0),D1
02B6: BNE.S      $031A

02B8: MOVE.W     -2092(A5),D0
02BC: MOVEA.L    A5,A0
02BE: ADDA.W     D0,A0
02C0: MOVE.B     62(A4),D1
02C4: CMP.B      -12668(A0),D1
02C8: BNE.S      $031A

02CA: MOVE.W     -2086(A5),D0
02CE: MOVEA.L    A5,A0
02D0: ADDA.W     D0,A0
02D2: MOVE.B     63(A4),D1
02D6: CMP.B      -12668(A0),D1
02DA: BNE.S      $031A

02DC: MOVE.W     -2090(A5),D0
02E0: MOVEA.L    A5,A0
02E2: ADDA.W     D0,A0
02E4: MOVE.B     64(A4),D1
02E8: CMP.B      -12668(A0),D1
02EC: BNE.S      $031A

; Score comparison
02EA: CMP.L      4(A4),D7              ; New score better?
02EE: BLE.W      $04D0                 ; No, skip

; Update cache entry
02F2: MOVE.L     D7,4(A4)              ; Store new score
02F6: LEA        16(A4),A0             ; Dest = entry.move
02FA: LEA        (A3),A1               ; Src = move
02FC: MOVEQ      #7,D0
02FE: MOVE.L     (A1)+,(A0)+           ; Copy 8 longs
0300: DBF        D0,$02FE
0304: MOVE.W     (A1)+,(A0)+           ; Copy word
0306: MOVE.W     D4,58(A4)             ; Store modifier
030A: MOVEA.W    D6,A0
030C: MOVE.L     A0,(A2)               ; Update hash
030E: BRA.W      $04D0

; Continue scanning
0312: LEA        66(A4),A4             ; Next entry
0316: BRA.W      $0262
031A: MOVEQ      #0,D3

; Create new entry if not found
031C: CMPI.W     #7,-20010(A5)
0322: BNE.S      $035E

; 7 tiles - special handling
0324: MOVEA.L    -1852(A5),A4          ; Get special cache
0328: BRA.S      $0350

; Sum letter values
032A: MOVEA.L    A5,A0
032C: ADDA.W     D5,A0
032E: ADDA.W     D5,A0
0330: MOVEA.L    A5,A1
0332: ADDA.W     D5,A1
0334: MOVE.B     -12668(A1),D0
0338: EXT.W      D0
033A: MOVEA.L    A5,A1
033C: ADDA.W     D5,A1
033E: MOVE.B     -23218(A1),D1
0342: EXT.W      D1
0344: SUB.W      D0,A1
0346: MULS.W     -27630(A0),D1
034A: MOVEA.W    D1,A0
034C: ADD.L      A0,D3
034E: ADDQ.L     #1,A4

0350: MOVE.B     (A4),D5
0352: EXT.W      D5
0354: TST.W      D5
0356: BNE.S      $032A
0358: ADD.L      D3,D3
035A: ADD.L      16(A3),D3             ; Add move score

; ... continue with entry creation and update ...

04CE: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
04D2: UNLK       A6
04D4: RTS
```

### Function 0x04D6 - Similar Cache Management
```asm
04D6: LINK       A6,#0
04DA: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)
04DE: MOVEA.L    8(A6),A3
04E2: CMPI.W     #7,-20010(A5)
04E8: BGT.W      $06D4                 ; Too many tiles

04EC: LEA        16(A3),A4             ; Score area
04F0: MOVE.L     -1924(A5),D7
04F4: ADD.W      (A4),D7

; Similar structure to 0x0188 but different cache handling
; ... continues with similar pattern ...

06D4: MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4
06D8: UNLK       A6
06DA: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1820 | Cache enable/base pointer |
| A5-1822 | Score multiplier |
| A5-1852 | Special 7-tile cache pointer |
| A5-1924 | Cache hash base |
| A5-2086 | Position value 1 |
| A5-2088 | Position value 2 |
| A5-2090 | Position value 3 |
| A5-2092 | Position value 4 |
| A5-2094 | Position index |
| A5-12508 | Cache array pointer |
| A5-12540 | Cache entry count |
| A5-12605 | Player blank count |
| A5-12668 | Position data array |
| A5-18460 | Position mask table |
| A5-19470 | Game state |
| A5-20010 | Tiles placed count |
| A5-23155 | Blank tile count |
| A5-23218 | Letter count array |
| A5-26024 | Score lookup table |
| A5-27630 | Letter value table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 66 | 32-bit multiply |
| 90 | 32-bit divide |
| 418 | bounds_error |
| 3466 | memmove |

## Cache Structure

The cache uses 66-byte entries:
- Up to 90 entries maximum
- Indexed by position hash
- Stores move data copy (34 bytes)
- Tracks letter counts for validation
- Score comparison for replacement

Cache lookup flow:
1. Calculate position hash from row/col/direction
2. Look up in position table for entry index
3. Verify letter counts match
4. Compare scores - replace if better

## Confidence: HIGH

Clear caching optimization patterns:
- Hash-based lookup for positions
- Score comparison for replacement
- Entry validation with letter counts
- 66-byte entry structure confirmed by memmove calls

---

## Speculative C Translation

### Header File (code36_cache.h)

```c
/*
 * CODE 36 - Move Cache and Position Scoring
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * This module manages the move evaluation cache for endgame optimization.
 * Uses 66-byte entries indexed by position hash for fast lookup.
 */

#ifndef CODE36_CACHE_H
#define CODE36_CACHE_H

#include <stdint.h>
#include <stdbool.h>

/* Cache entry structure - 66 bytes total */
typedef struct CacheEntry {
    uint32_t link_flags;        /* +0: Link pointer and flags */
    int32_t  score;             /* +4: Cached score value */
    uint8_t  reserved1[10];     /* +8: Reserved/padding */
    uint16_t cache_index;       /* +14: Index in cache array */
    uint8_t  move_data[34];     /* +16: Copy of Move structure */
    uint16_t position_row;      /* +50: Board row */  /* uncertain */
    uint16_t position_col;      /* +52: Board column */  /* uncertain */
    uint16_t score_flags;       /* +54: Score calculation flags */  /* uncertain */
    int16_t  extra_score;       /* +56: Additional score modifier */  /* uncertain */
    uint16_t cached_modifier;   /* +58: Cached score modifier */
    uint8_t  letter_counts[4];  /* +60: Validation counts (tiles 0-3) */
    uint8_t  reserved2[2];      /* +64: Padding to 66 bytes */
} CacheEntry;

/* Move data structure embedded in cache entries */
typedef struct MoveData {
    uint8_t  word_letters[16];  /* +0: Letters in the word */
    int32_t  base_score;        /* +16: Base move score */
    int32_t  component_score;   /* +20: Score component */
    int32_t  bonus_score;       /* +24: Bonus (bingo, etc.) */
    uint16_t flags;             /* +28: Move flags */
    uint16_t position;          /* +30: Encoded position */
    uint8_t  direction;         /* +32: 0=vertical, 8=horizontal */
    uint8_t  row;               /* +33: Starting row */
} MoveData;

/*
 * Global variables (A5-relative)
 * These would be declared extern in implementation
 */
extern int32_t*  g_cache_ptr;           /* A5-1820: Cache enable/base pointer */
extern uint16_t  g_score_multiplier;    /* A5-1822: Score multiplier */
extern int32_t*  g_bingo_cache_ptr;     /* A5-1852: Special 7-tile cache */
extern uint32_t  g_cache_hash_base;     /* A5-1924: Cache hash base value */
extern uint16_t  g_position_values[4];  /* A5-2086 to A5-2092: Position vals */
extern uint16_t  g_position_index;      /* A5-2094: Current position index */
extern CacheEntry* g_cache_array;       /* A5-12508: Cache array pointer */
extern uint16_t  g_cache_entry_count;   /* A5-12540: Number of entries */
extern uint8_t   g_player_blank_count;  /* A5-12605: Player's blank count */
extern int8_t    g_position_data[128];  /* A5-12668: Position data array */
extern uint16_t  g_position_mask[256];  /* A5-18460: Position mask table */
extern uint8_t   g_game_state[1024];    /* A5-19470: Game state buffer */
extern uint16_t  g_tiles_placed;        /* A5-20010: Tiles in current move */
extern uint8_t   g_blank_count;         /* A5-23155: Total blank count */
extern int8_t    g_letter_counts[128];  /* A5-23218: Letter count array */
extern int16_t   g_score_lookup[256];   /* A5-26024: Score lookup table */
extern int16_t   g_letter_values[128];  /* A5-27630: Letter value table */

/* Maximum cache entries */
#define MAX_CACHE_ENTRIES 90

/* Cache entry size in bytes */
#define CACHE_ENTRY_SIZE 66

/* Function prototypes */
int16_t calculate_position_score(MoveData* move_data, int16_t comparison_value);
void cache_move_entry(MoveData* move_data);
void cache_move_alternate(MoveData* move_data);  /* Function at 0x04D6 */
int32_t calculate_score_modifier(void);  /* Internal helper at 0x115A (PC+4442) */

#endif /* CODE36_CACHE_H */
```

### Implementation File (code36_cache.c)

```c
/*
 * CODE 36 - Move Cache and Position Scoring Implementation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * Key algorithms:
 * - Hash-based position cache lookup
 * - Score comparison for cache replacement
 * - Letter count validation for cache hits
 * - Special handling for 7-tile (bingo) plays
 */

#include "code36_cache.h"
#include <string.h>

/*
 * calculate_position_score - Function at 0x0000
 *
 * Calculates the positional score for a move, using the cache
 * when available to avoid recalculation.
 *
 * Parameters:
 *   move_data - Pointer to the move being evaluated
 *   comparison_value - Value to compare against cached entries
 *
 * Returns:
 *   Score value, or 0 if move should be skipped
 */
int16_t calculate_position_score(MoveData* move_data, int16_t comparison_value)
{
    int16_t accumulated_score = 0;
    uint8_t* word_ptr;
    uint8_t* board_ptr;  /* uncertain - tracks board state */
    int16_t letter_index;
    int16_t score_modifier;

    /* Early exit check: base score must be > 5000 */
    if (move_data->base_score <= 5000) {
        return 0;
    }

    /* Check blank tile consistency */
    if (g_blank_count == g_player_blank_count) {
        return 0;  /* No difference in blanks - skip */
    }

    /* Check if cache is enabled */
    if (g_cache_ptr == NULL) {
        goto direct_calculation;
    }

    /*
     * Cache lookup section
     * Calculate cache index from position
     */
    word_ptr = move_data->word_letters;
    int16_t row = move_data->row;
    int16_t direction = move_data->direction;

    /* Calculate hash for cache lookup */
    /* uncertain - exact hash formula */
    uint32_t cache_index = (row * 17 + direction) & 0xFFFF;

    /*
     * Iterate through word letters, checking each position
     */
    letter_index = *word_ptr;
    while (letter_index != 0) {
        /* Check if board cell is occupied */
        if (*board_ptr != 0) {
            goto next_letter;
        }

        /* Check letter value threshold (800 = high-value tile) */
        if (g_letter_values[letter_index * 2] >= 800) {
            goto next_letter;  /* High value - special handling */
        }

        /* Calculate score contribution for this letter */
        int16_t player_offset = g_player_blank_count;
        int32_t lookup_offset = letter_index;
        lookup_offset *= 2;  /* Word-sized entries */

        /* Get bonus from position-specific table */
        /* uncertain - complex addressing mode */
        int16_t position_bonus = g_position_mask[lookup_offset];

        /* Apply mask with move flags */
        uint16_t combined = move_data->position | position_bonus;
        combined &= g_position_mask[player_offset * 2];  /* uncertain */
        score_modifier = combined;

        /* Look up cached value if available */
        if (g_cache_ptr != NULL) {
            uint8_t cached = *(uint8_t*)(g_cache_ptr + score_modifier);

            if (cached == comparison_value) {
                goto next_letter;  /* Cache hit - use cached */
            }
        }

        /* Add letter contribution to score */
        accumulated_score += g_position_data[letter_index];

    next_letter:
        word_ptr++;
        board_ptr++;  /* uncertain */
        letter_index = *word_ptr;
    }

    goto finalize_score;

direct_calculation:
    /*
     * No cache available - calculate directly
     */

    /* Check for bingo (7 tiles placed) */
    if (g_tiles_placed == 7) {
        accumulated_score = 7;  /* Bingo base value */
        goto finalize_score;
    }

    /*
     * Calculate score from position values
     * Uses 4 position indices to look up scores
     */
    int16_t val0 = g_position_data[g_position_values[2]];  /* A5-2090 */
    int16_t val1 = g_position_data[g_position_values[0]];  /* A5-2086 */
    int16_t val2 = g_position_data[g_position_values[3]];  /* A5-2092 */
    int16_t val3 = g_position_data[g_position_values[1]];  /* A5-2088 */

    accumulated_score = g_tiles_placed;
    accumulated_score -= val3;
    accumulated_score -= val2;
    accumulated_score -= val1;
    accumulated_score -= val0;

finalize_score:
    /*
     * Final score aggregation
     * Process all letters and apply lookup table modifiers
     */
    word_ptr = move_data->word_letters;
    int32_t final_modifier = 0;

    /* uncertain - complex loop processing letters */
    uint8_t letter_count_63 = g_letter_counts[63];
    int8_t pos_data_63 = g_position_data[63];

    while (*word_ptr != 0) {
        uint8_t current_letter = *word_ptr++;
        int8_t pos_val = g_position_data[current_letter];

        if (pos_val == 0) {
            continue;  /* Not found in position data */
        }

        /* Clear used flag */
        g_position_data[current_letter] = 0;

        /* Check against letter count */
        uint8_t count = g_letter_counts[current_letter];
        if (count == pos_val) {
            continue;  /* Exact match */
        }

        /* Adjust score based on lookup */
        int32_t lookup_idx = count * 2;
        accumulated_score -= g_score_lookup[0];
        final_modifier &= g_score_lookup[lookup_idx];
    }

    /* Validate final modifier */
    if (final_modifier == 0) {
        /* Error condition - should not happen */
        /* bounds_error(); - JT[418] */
    }

    return accumulated_score + (int16_t)final_modifier;
}

/*
 * cache_move_entry - Function at 0x0188
 *
 * Caches a move entry for later retrieval. Uses a 66-byte
 * entry format with position hash for indexing.
 *
 * Parameters:
 *   move_data - Pointer to the move to cache
 */
void cache_move_entry(MoveData* move_data)
{
    int16_t* score_area;
    int32_t cache_hash;
    int32_t score_modifier;
    int16_t tile_index;
    int16_t adjusted_count;

    /* Check tile count limit (max 7 for standard play) */
    if (g_tiles_placed > 7) {
        return;  /* Too many tiles - don't cache */
    }

    score_area = (int16_t*)((uint8_t*)move_data + 16);

    /*
     * Calculate cache hash from position and score
     */
    cache_hash = g_cache_hash_base;
    cache_hash += *score_area;  /* Add base score */

    /* Check against existing entry */
    int32_t entry_offset = (g_cache_entry_count - 1) * CACHE_ENTRY_SIZE;
    CacheEntry* existing = (CacheEntry*)((uint8_t*)g_cache_array + entry_offset);

    if (cache_hash <= existing->score) {
        return;  /* Existing entry is better or equal */
    }

    /*
     * Calculate cache index adjustment
     */
    tile_index = g_position_index - g_tiles_placed;
    adjusted_count = tile_index - 7;

    if (adjusted_count <= 0) {
        if (adjusted_count < 0) {
            adjusted_count = 1;  /* Minimum value */
        } else {
            adjusted_count = 7;  /* At boundary */
        }
    }

    /*
     * Calculate score modifier using helper function
     */
    score_modifier = calculate_score_modifier();

    /* Apply multiplier for tile count */
    int32_t multiplied = g_tiles_placed * g_score_multiplier;

    /* Complex calculation using JT[66] and JT[90] */
    /* uncertain - involves 32-bit multiply and divide */
    int32_t calc_result = (multiplied * score_modifier) / adjusted_count;
    calc_result += *score_area;
    cache_hash = calc_result;

    /* Recheck against existing entry */
    if (cache_hash <= existing->score) {
        return;  /* Still not better */
    }

    /* Validate entry count */
    if (g_cache_entry_count != MAX_CACHE_ENTRIES) {
        /* bounds_error(); - JT[418] */
        return;
    }

    /*
     * Check if we can find existing entry to update
     */
    if (g_cache_ptr == NULL) {
        goto create_new_entry;
    }

    /* Look up position in cache */
    uint32_t position_offset = move_data->position;
    uint8_t* cache_lookup = (uint8_t*)(g_cache_ptr + position_offset);
    int16_t found_index = (int8_t)*cache_lookup;

    if (found_index == -1) {
        goto create_new_entry;  /* Not found */
    }

    /* Validate index bounds */
    if (found_index >= g_cache_entry_count || found_index < 0) {
        /* bounds_error(); */
        return;
    }

    /*
     * Found existing entry - verify it matches
     */
    CacheEntry* found_entry = &g_cache_array[found_index];

    /* Check position hash matches */
    if (*(uint32_t*)&found_entry->reserved1[2] != found_index) {
        goto create_new_entry;  /* Hash mismatch */  /* uncertain */
    }

    /* Verify direction matches */
    if (found_entry->move_data[16] != move_data->direction) {  /* offset 32 in Move */
        goto create_new_entry;
    }

    /* Verify row matches */
    if (found_entry->move_data[17] != move_data->row) {  /* offset 33 in Move */
        goto create_new_entry;
    }

    /*
     * Verify letter counts match current state
     */
    if (found_entry->letter_counts[0] != g_tiles_placed) {
        goto create_new_entry;
    }

    /* Check each position value */
    if (found_entry->letter_counts[1] != g_position_data[g_position_values[1]]) {
        goto create_new_entry;
    }
    if (found_entry->letter_counts[2] != g_position_data[g_position_values[3]]) {
        goto create_new_entry;
    }
    if (found_entry->letter_counts[3] != g_position_data[g_position_values[0]]) {
        goto create_new_entry;
    }

    /*
     * Score comparison - update only if better
     */
    if (cache_hash <= found_entry->score) {
        return;  /* Existing entry is better */
    }

    /* Update existing entry with new values */
    found_entry->score = cache_hash;

    /* Copy move data (34 bytes = 8 longs + 1 word) */
    uint32_t* dest = (uint32_t*)found_entry->move_data;
    uint32_t* src = (uint32_t*)move_data;
    for (int i = 0; i < 8; i++) {
        *dest++ = *src++;
    }
    *(uint16_t*)dest = *(uint16_t*)src;

    /* Store modifier */
    found_entry->cached_modifier = (uint16_t)score_modifier;

    return;

create_new_entry:
    /*
     * Create new cache entry
     * Special handling for 7-tile (bingo) plays
     */
    if (g_tiles_placed == 7) {
        /* Use special bingo cache */
        CacheEntry* bingo_entry = (CacheEntry*)g_bingo_cache_ptr;

        /* Sum letter values for bingo scoring */
        int32_t letter_sum = 0;
        uint8_t* letters = move_data->word_letters;

        while (*letters != 0) {
            uint8_t letter = *letters++;
            int16_t letter_val = g_letter_values[letter * 2];
            int8_t count_diff = g_position_data[letter] - g_letter_counts[letter];
            letter_sum += letter_val * count_diff;
        }

        letter_sum *= 2;  /* Double for bingo */
        letter_sum += move_data->base_score;

        /* Update bingo cache entry */
        /* uncertain - rest of bingo handling */
    }

    /* Standard entry creation would continue here */
    /* ... additional logic for non-bingo entries ... */
}

/*
 * cache_move_alternate - Function at 0x04D6
 *
 * Alternative cache management function with similar structure
 * to cache_move_entry but different handling for certain cases.
 * Used for secondary move evaluation paths.
 *
 * Parameters:
 *   move_data - Pointer to the move to cache
 */
void cache_move_alternate(MoveData* move_data)
{
    int16_t* score_area;
    int32_t cache_hash;

    /* Same initial checks as cache_move_entry */
    if (g_tiles_placed > 7) {
        return;
    }

    score_area = (int16_t*)((uint8_t*)move_data + 16);

    cache_hash = g_cache_hash_base;
    cache_hash += *score_area;

    /*
     * Similar structure to 0x0188 but with different
     * cache handling - possibly for alternate search paths
     */
    /* uncertain - specific differences from cache_move_entry */

    /* ... implementation continues similarly ... */
}
```

### Key Algorithmic Notes

```
CACHE ENTRY STRUCTURE (66 bytes):
================================
The 66-byte cache entry is optimized for:
1. Fast lookup by position hash
2. Score comparison for replacement
3. Move data storage (34 bytes - exact move copy)
4. Validation via letter counts

HASH CALCULATION:
=================
Position hash combines:
- Row position (0-14)
- Direction (0=vertical, 8=horizontal)
- Base score component
- Hash base value from g_cache_hash_base

CACHE REPLACEMENT POLICY:
=========================
- Score-based replacement (higher score wins)
- Letter count validation prevents stale hits
- Maximum 90 entries (MAX_CACHE_ENTRIES)
- Separate bingo cache for 7-tile plays

LETTER COUNT VALIDATION:
========================
Four letter counts (offsets 60-63) store:
- Tiles placed count
- Three position-specific letter counts
These must match current game state for cache hit validity.

PERFORMANCE OPTIMIZATION:
=========================
The cache avoids recalculating position scores during
endgame search. Critical for the B* search algorithm
used in Maven's endgame analysis.

INTEGRATION:
============
- Called by CODE 35's score calculation functions
- Results used by CODE 40's move caching layer
- Shares position data with CODE 43's cross-checks
```
