# CODE 40 Detailed Analysis - Move Caching and Validation

## Overview

| Property | Value |
|----------|-------|
| Size | 624 bytes |
| JT Offset | 2640 |
| JT Entries | 4 |
| Functions | 4 |
| Purpose | **Cache move results, validate moves, manage move history** |


## System Role

**Category**: Game Logic
**Function**: Rack Letters

Rack letter utilities
## Architecture Role

CODE 40 provides move caching functionality:
1. Cache validated move results for reuse
2. Store move scores in lookup tables
3. Manage move comparison and replacement
4. Support search optimization through caching

## Key Functions

### Function 0x0000 - Cache Move Result
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A3/A4,-(SP)

; Get move candidate
0008: MOVEA.L    8(A6),A4             ; A4 = move struct

; Validate move
000C: MOVE.L     A4,-(A7)
000E: JSR        2762(A5)             ; JT[2762] - validate move
0012: TST.W      D0
0014: ADDQ       #4,A7                ; (Pop argument)
0016: BEQ.S      $008E                ; Invalid - skip caching

; Check if move already has score
0018: TST.L      20(A4)               ; move->cached_score
001C: BEQ.S      $0022                ; Not cached - continue
001E: JSR        418(A5)              ; JT[418] - error (duplicate)

; Get score and player ID
0022: MOVE.L     16(A4),D7            ; D7 = move->score
0026: MOVE.W     30(A4),D0            ; Get player ID
002A: EXT.L      D0
002C: ...

; Index into results array
0030: LEA        -22698(A5),A0        ; A0 = g_results_array
0034: ADD.B      A3,$BE90.W
0038: BLE.S      $006C                ; Skip if index <= 0

; Update primary cache entry
003A: MOVEA.L    A5,A0
003C: MOVE.W     30(A4),D0            ; Player ID
0040: EXT.L      D0
...

; Copy score to secondary cache
0052: MOVE.L     -22698(A0),-12496(A1) ; g_results_array -> g_cache

; Store move score in primary array
0058: MOVEA.L    A5,A0
005A: MOVE.W     30(A4),D0
005E: EXT.L      D0
...
0064: MOVE.L     16(A4),-22698(A0)    ; Store score

006A: BRA.S      $0088

; Alternative cache path (for secondary results)
006C: LEA        -12496(A5),A0        ; A0 = g_cache
0070: ADD.B      A3,$BE90.W
0074: BLE.S      $0088                ; Skip if index <= 0

; Store in secondary cache only
0076: MOVEA.L    A5,A0
0078: MOVE.W     30(A4),D0
007C: EXT.L      D0
...
0082: MOVE.L     16(A4),-12496(A0)    ; Store in g_cache

; Finalize caching
0088: MOVE.L     A4,-(A7)
008A: JSR        2114(A5)             ; JT[2114] - finalize cache

008E: MOVEM.L    -12(A6),D7/A3/A4
0094: UNLK       A6
0096: RTS
```

**C equivalent**:
```c
void cache_move_result(Move* move) {
    if (!validate_move(move)) {
        return;  // Invalid move
    }

    if (move->cached_score != 0) {
        error();  // Already cached
    }

    int score = move->score;
    int player_id = move->player_id;

    int idx = calculate_index(player_id);

    if (idx > 0) {
        // Cache in both primary and secondary
        g_cache[idx] = g_results_array[idx];
        g_results_array[idx] = score;
    } else if (secondary_idx > 0) {
        // Cache in secondary only
        g_cache[secondary_idx] = score;
    }

    finalize_cache(move);
}
```

### Function 0x0098 - Initialize Move Search
```asm
0098: LINK       A6,#0
009C: MOVE.L     D7,-(A7)

; Initialize search context
009E: MOVE.L     8(A6),-(A7)
00A2: JSR        2810(A5)             ; JT[2810] - init search
00A6: CLR.L      -19486(A5)           ; Clear callback pointer

; Set search callback
00AA: PEA        2682(A5)             ; Push callback address
00AE: JSR        2618(A5)             ; JT[2618] - set callback

; Initialize DAWG search area
00B2: PEA        $0154.W              ; Size = 340 bytes
00B6: PEA        -23056(A5)           ; g_dawg_search_area
00BA: MOVE.L     16(A6),-(A7)         ; Push parameter
00BE: JSR        3466(A5)             ; JT[3466] - memcpy

; Save search state
00C2: MOVE.W     -12540(A5),D7        ; D7 = saved state

; Perform horizontal search
00C6: MOVE.L     8(A6),(A7)
00CA: MOVE.W     #$0001,-(A7)         ; Direction = horizontal
00CE: JSR        2650(A5)             ; JT[2650] - search

; Initialize for vertical search
00D2: MOVE.L     12(A6),(A7)
00D6: JSR        2810(A5)             ; JT[2810] - init

; Clear cache
00DA: PEA        $0E00.W              ; Size = 3584 bytes
00DE: MOVE.L     -11984(A5),-(A7)     ; Cache buffer
00E2: JSR        426(A5)              ; JT[426] - memset

; Set vertical callback
00E6: PEA        2674(A5)             ; Vertical callback
00EA: JSR        2618(A5)             ; JT[2618]

; Perform vertical search
00EE: MOVE.L     12(A6),(A7)
00F2: CLR.W      -(A7)                ; Direction = vertical
00F4: JSR        2650(A5)             ; JT[2650] - search

; Process results
00F8: MOVE.L     -11984(A5),(A7)      ; Cache buffer
00FC: JSR        2106(A5)             ; JT[2106] - process
0100: MOVE.L     D0,(A7)
0102: JSR        2746(A5)             ; JT[2746] - finalize

0106: MOVE.W     D7,D0                ; Return saved state
0108: MOVE.L     -4(A6),D7
010C: UNLK       A6
010E: RTS
```

**C equivalent**:
```c
int init_move_search(void* horiz_ctx, void* vert_ctx, void* dawg_data) {
    init_search(horiz_ctx);
    g_callback_ptr = NULL;

    set_callback(callback_2682);

    // Copy DAWG search data
    memcpy(g_dawg_search_area, dawg_data, 340);

    int saved_state = g_search_state;

    // Horizontal search
    search(horiz_ctx, HORIZONTAL);

    // Initialize vertical
    init_search(vert_ctx);

    // Clear cache (3584 bytes)
    memset(g_cache_buffer, 0, 0x0E00);

    set_callback(callback_2674);

    // Vertical search
    search(vert_ctx, VERTICAL);

    // Process and finalize
    void* results = process_cache(g_cache_buffer);
    finalize_results(results);

    return saved_state;
}
```

### Function 0x0110 - Extended Cache with Debug Info
```asm
0110: LINK       A6,#0
0114: MOVEM.L    D6/D7/A3/A4,-(SP)

; Get move candidate
0118: MOVEA.L    8(A6),A4
011C: CLR.L      -19486(A5)           ; Clear debug ptr

; Validate move
0120: MOVE.L     A4,-(A7)
0122: JSR        2762(A5)             ; JT[2762] - validate
0126: TST.W      D0
0128: ADDQ       #4,A7
012A: BEQ.W      $01F6                ; Invalid - skip

; Get move info
012E: MOVE.L     16(A4),D7            ; D7 = score
0132: MOVE.W     30(A4),D0            ; Player ID
0136: EXT.L      D0
...
013C: MOVE.W     30(A4),D6            ; D6 = player ID

; Check primary results array
0140: LEA        -22698(A5),A0        ; g_results_array
0144: ADD.B      A3,$BE90.W
0148: BLE.S      $01A8                ; Skip if invalid index

; Calculate cache offset
014A: MOVEQ      #28,D0
014C: AND.L      D6,A0                ; Mask player ID
014E: ADD.B      -11984(A5),(A0)      ; Add cache base
0152: MOVEA.L    D0,A3                ; A3 = cache offset

; Copy move data to cache
0154: MOVEQ      #28,D0
0156: AND.L      30(A4),A0
015A: MOVEA.L    -11984(A5),A0
015E: LEA        14(A0,D0.L),A0       ; Destination
0162: LEA        (A3),A1              ; Source

; Copy 14 bytes of move data
0164: MOVE.L     (A1)+,(A0)+          ; 4 bytes
0166: MOVE.L     (A1)+,(A0)+          ; 4 bytes
0168: MOVE.L     (A1)+,(A0)+          ; 4 bytes
016A: MOVE.W     (A1)+,(A0)+          ; 2 bytes

; Update cache entry
016C: MOVE.L     A4,-(A7)
016E: MOVE.L     A3,-(A7)
0170: JSR        2098(A5)             ; JT[2098] - update cache

; Copy to secondary locations
0174: MOVEA.L    A5,A0
0176: MOVE.W     30(A4),D0
...
018C: MOVE.L     -22698(A0),-12496(A1)

; Store score in results array
0192: MOVEA.L    A5,A0
...
019E: MOVE.L     16(A4),-22698(A0)

01A4: ADDQ       #8,A7
01A6: BRA.S      $01DA

; Secondary cache path
01A8: LEA        -12496(A5),A0
01AC: ADD.B      A3,$BE90.W
01B0: BLE.S      $01DA

; Store in secondary cache
01B2: MOVEA.L    A5,A0
01B4: MOVE.W     30(A4),D0
...
01BE: MOVE.L     16(A4),-12496(A0)

; Copy debug info
01C4: MOVE.L     A4,-(A7)
01C6: MOVEQ      #28,D0
01C8: AND.L      30(A4),A0
01CC: MOVEA.L    -11984(A5),A0
01D0: PEA        14(A0,D0.L)
01D4: JSR        2098(A5)             ; JT[2098]
01D8: ADDQ       #8,A7

; Check for move flags
01DA: TST.W      28(A4)               ; Check flags
01DE: BEQ.S      $01E6
01E0: MOVEQ      #20,D0
01E2: MOVE.L     D0,20(A4)            ; Set cached flag

; Set debug callback
01E6: LEA        2690(A5),A0          ; Debug callback
01EA: MOVE.L     A0,-19486(A5)

; Finalize
01EE: MOVE.L     A4,-(A7)
01F0: JSR        2114(A5)             ; JT[2114]

01F4: MOVEM.L    -16(A6),D6/D7/A3/A4
01FA: UNLK       A6
01FC: RTS
```

### Function 0x01FE - Find Cached Move
```asm
01FE: LINK       A6,#0
0202: MOVEM.L    A2/A3/A4,-(SP)

; Get search parameters
0206: MOVEA.L    8(A6),A2             ; A2 = search criteria
020A: LEA        -23056(A5),A4        ; A4 = cache array
020E: LEA        30(A2),A3            ; A3 = search position

; Loop through cache entries
0212: BRA.S      $0256

; Compare cache entry
0214: MOVE.W     30(A4),D0            ; Cache position
0218: CMP.W      (A3),A0              ; Compare with search
021A: BNE.S      $0252                ; No match - next

; Compare player and direction
021C: MOVE.B     32(A4),D0            ; Cache player
0220: CMP.B      32(A2),D0            ; Search player
0224: BNE.S      $0252                ; No match

0226: MOVE.B     33(A4),D0            ; Cache direction
022A: CMP.B      33(A2),D0            ; Search direction
022E: BNE.S      $0252                ; No match

; Found matching entry - compare scores
0230: MOVE.L     16(A4),D0            ; Cache score
0234: ADD.L      20(A4),D0            ; Add bonus
0238: MOVE.L     16(A2),D1            ; Search score
023C: ADD.L      20(A2),D1            ; Add bonus
0240: CMP.L      D0,D1                ; Compare total
0242: BLE.S      $024E                ; Search <= cache - use cache

; Search is better - invalidate cache entry
0244: MOVE.L     A4,-(A7)
0246: JSR        2778(A5)             ; JT[2778] - invalidate
024A: ADDQ       #4,A7
024C: BRA.S      $0266                ; Return 1 (found better)

024E: MOVEQ      #0,D0                ; Return 0 (cache is better)
0250: BRA.S      $0268

; Next cache entry
0252: LEA        34(A4),A4            ; Advance 34 bytes

; Check if more entries
0256: MOVEQ      #34,D0
0258: AND.L      -12540(A5),A0        ; Get entry count
025C: LEA        -23056(A5),A0        ; Base address
0260: ADD.B      A0,(A0)
0262: CMP.L      A4,A0                ; Compare pointers
0264: BHI.S      $0214                ; More entries - continue

0266: MOVEQ      #1,D0                ; Return 1 (not found/replaced)
0268: MOVEM.L    (SP)+,A2/A3/A4
026C: UNLK       A6
026E: RTS
```

**C equivalent**:
```c
int find_cached_move(MoveSearch* search) {
    Move* cache = g_dawg_search_area;
    int entry_count = g_entry_count;

    for (int i = 0; i < entry_count; i++) {
        Move* cached = &cache[i];

        // Check position match
        if (cached->position != search->position)
            continue;

        // Check player match
        if (cached->player != search->player)
            continue;

        // Check direction match
        if (cached->direction != search->direction)
            continue;

        // Found match - compare scores
        int cache_total = cached->score + cached->bonus;
        int search_total = search->score + search->bonus;

        if (search_total > cache_total) {
            // New move is better - invalidate cache
            invalidate_cache_entry(cached);
            return 1;
        } else {
            // Cache has equal or better score
            return 0;
        }
    }

    return 1;  // Not found in cache
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-11984 | Cache buffer pointer |
| A5-12496 | g_cache - Secondary move cache |
| A5-12540 | Cache entry count |
| A5-19486 | Debug/callback pointer |
| A5-22698 | g_results_array - Primary move results |
| A5-23056 | g_dawg_search_area - DAWG search buffer |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 426 | memset |
| 2098 | Update cache entry |
| 2106 | Process cache buffer |
| 2114 | Finalize cache operation |
| 2618 | Set search callback |
| 2650 | Perform directional search |
| 2746 | Finalize results |
| 2762 | Validate move |
| 2778 | Invalidate cache entry |
| 2810 | Initialize search context |
| 3466 | memcpy |

## Cache Entry Structure

Each cache entry is 34 bytes:
| Offset | Size | Field |
|--------|------|-------|
| 0 | 4 | Reserved |
| 4 | 4 | Reserved |
| 8 | 4 | Reserved |
| 12 | 2 | Reserved |
| 14 | 4 | Data field 1 |
| 18 | 4 | Data field 2 |
| 22 | 4 | Data field 3 |
| 26 | 2 | Data field 4 |
| 28 | 2 | Flags |
| 30 | 2 | Position |
| 32 | 1 | Player ID |
| 33 | 1 | Direction |

## Caching Strategy

1. **Validation**: Check if move is legal before caching
2. **Deduplication**: Error if move already cached
3. **Two-level cache**:
   - Primary (g_results_array): Best moves per position
   - Secondary (g_cache): Alternative moves
4. **Score comparison**: Replace cache entry if new move scores higher
5. **Direction-specific**: Separate handling for horizontal/vertical

## Integration with CODE 43 and 44

CODE 40 is the caching layer between search and validation:

1. **CODE 44 → CODE 40 Flow**:
   - CODE 44 dispatches search based on rack size
   - CODE 40 caches validated moves from search
   - Cache entries reused by subsequent searches

2. **CODE 43 → CODE 40 Flow**:
   - CODE 43 generates cross-check masks
   - CODE 40's g_dawg_search_area (A5-23056) receives results
   - Shared 34-byte entry structure

## Shared Global Variables

| Offset | CODE 40 | CODE 43 | CODE 44 | Purpose |
|--------|---------|---------|---------|---------|
| A5-12496 | Write | Read | - | Secondary cache |
| A5-12540 | Read/Write | Read | Read/Write | Entry count |
| A5-22698 | Write | Read | - | Results array |
| A5-23056 | Read/Write | Write | Read | DAWG search area |

## Cache Sizes

- g_dawg_search_area: 340 bytes (0x154) for initial copy
- Cache buffer: 3584 bytes (0x0E00) cleared per search
- Entry size: 34 bytes (consistent with CODE 44)

## Search Callback System

Callbacks registered at A5+2682 and A5+2674:
- Horizontal search uses A5+2682
- Vertical search uses A5+2674
- Debug callback at A5+2690

## Confidence: MEDIUM-HIGH

Clear caching patterns with:
- Two-level cache hierarchy (primary at A5-22698, secondary at A5-12496)
- Score-based replacement policy (compare at offsets 16 and 20)
- Position/player/direction matching (offsets 30, 32, 33)
- Callback system for search phases (JT[2618] sets callback)
- 14-byte partial copy in function 0x0110 (4+4+4+2 bytes)

Some disassembly artifacts (garbled indexed addressing) but overall structure is clear.

---

## Speculative C Translation

### Header File (code40_move_cache.h)

```c
/*
 * CODE 40 - Move Caching and Validation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * Provides two-level caching for validated moves:
 * - Primary cache (g_results_array): Best moves per position
 * - Secondary cache (g_cache): Alternative moves
 */

#ifndef CODE40_MOVE_CACHE_H
#define CODE40_MOVE_CACHE_H

#include <stdint.h>
#include <stdbool.h>

/* Move search result structure (34 bytes) */
typedef struct MoveEntry {
    uint8_t  data1[4];          /* +0: Reserved */
    uint8_t  data2[4];          /* +4: Reserved */
    uint8_t  data3[4];          /* +8: Reserved */
    uint16_t data4;             /* +12: Reserved */
    int32_t  field1;            /* +14: Data field 1 */
    int32_t  field2;            /* +18: Data field 2 (14-byte copy region) */
    int32_t  field3;            /* +22: Data field 3 */
    int16_t  field4;            /* +26: Data field 4 */
    uint16_t flags;             /* +28: Move flags */
    uint16_t position;          /* +30: Encoded board position */
    uint8_t  player_id;         /* +32: Player identifier */
    uint8_t  direction;         /* +33: Move direction */
} MoveEntry;

/* Move structure with scores (34 bytes) */
typedef struct Move {
    uint8_t  word[16];          /* +0: Word letters */
    int32_t  score;             /* +16: Base score */
    int32_t  cached_score;      /* +20: Cached/component score */
    int32_t  bonus;             /* +24: Bonus score */
    uint16_t flags;             /* +28: Move flags */
    uint16_t position;          /* +30: Encoded position */
    uint8_t  direction;         /* +32: Direction */
    uint8_t  row;               /* +33: Starting row */
} Move;

/*
 * Global variables (A5-relative)
 */
extern uint8_t*   g_cache_buffer;         /* A5-11984: Cache buffer pointer */
extern int32_t*   g_secondary_cache;      /* A5-12496: Secondary cache */
extern uint16_t   g_entry_count;          /* A5-12540: Cache entry count */
extern void*      g_callback_ptr;         /* A5-19486: Debug/callback pointer */
extern int32_t*   g_results_array;        /* A5-22698: Primary results */
extern MoveEntry* g_dawg_search_area;     /* A5-23056: Search buffer (340 bytes) */

/* Function prototypes */
void cache_move_result(Move* move);
int init_move_search(void* horiz_ctx, void* vert_ctx, void* dawg_data);
void cache_move_with_debug(Move* move);
int find_cached_move(Move* search);

#endif /* CODE40_MOVE_CACHE_H */
```

### Implementation File (code40_move_cache.c)

```c
/*
 * CODE 40 - Move Caching and Validation Implementation
 * Maven Scrabble AI - Speculative Reconstruction
 *
 * Two-level cache hierarchy for move search optimization:
 * 1. Primary (g_results_array): Current best for each position
 * 2. Secondary (g_secondary_cache): Alternative/previous best
 */

#include "code40_move_cache.h"
#include <string.h>

/* External JT functions */
extern int validate_move(Move* move);                     /* JT[2762] */
extern void finalize_cache(Move* move);                   /* JT[2114] */
extern void init_search(void* ctx);                       /* JT[2810] */
extern void set_callback(void* callback);                 /* JT[2618] */
extern void search_direction(void* ctx, int direction);   /* JT[2650] */
extern void* process_cache_buffer(void* buffer);          /* JT[2106] */
extern void finalize_results(void* results);              /* JT[2746] */
extern void update_cache_entry(void* entry, Move* move);  /* JT[2098] */
extern void invalidate_entry(Move* entry);                /* JT[2778] */
extern void bounds_error(void);                           /* JT[418] */
extern void memset_jt(void* dest, int val, size_t size);  /* JT[426] */
extern void memcpy_jt(void* dest, void* src, size_t sz);  /* JT[3466] */

/* Search direction constants */
#define DIRECTION_VERTICAL   0
#define DIRECTION_HORIZONTAL 1

/* Cache buffer size */
#define CACHE_BUFFER_SIZE    0x0E00  /* 3584 bytes */
#define DAWG_SEARCH_SIZE     0x0154  /* 340 bytes */

/*
 * cache_move_result - Function at 0x0000
 *
 * Caches a validated move result in the appropriate cache level.
 * Primary cache stores best score per position.
 * Secondary cache stores previous best.
 *
 * Parameters:
 *   move - Move to cache
 */
void cache_move_result(Move* move)
{
    int32_t score;
    int16_t player_id;
    int32_t cache_index;

    /* Validate move first */
    if (!validate_move(move)) {
        return;  /* Invalid move - don't cache */
    }

    /* Check if already cached (prevent duplicates) */
    if (move->cached_score != 0) {
        bounds_error();  /* Already cached - error */
    }

    score = move->score;
    player_id = move->position;  /* Position used as index */

    /*
     * Calculate index into results array
     * uncertain - exact index calculation from player_id
     */
    cache_index = player_id & 0xFFFF;  /* Mask to 16 bits */

    /* Check if primary cache should be updated */
    if (g_results_array[cache_index] > 0) {
        /* Has existing primary entry */

        /* Save current primary to secondary */
        g_secondary_cache[cache_index] = g_results_array[cache_index];

        /* Store new score in primary */
        g_results_array[cache_index] = score;
    } else {
        /* Check secondary cache */
        if (g_secondary_cache[cache_index] > 0) {
            /* Store in secondary only */
            g_secondary_cache[cache_index] = score;
        }
    }

    /* Finalize caching operation */
    finalize_cache(move);
}

/*
 * init_move_search - Function at 0x0098
 *
 * Initializes a complete move search, running both
 * horizontal and vertical searches with appropriate callbacks.
 *
 * Parameters:
 *   horiz_ctx - Horizontal search context
 *   vert_ctx - Vertical search context
 *   dawg_data - DAWG search data to copy (340 bytes)
 *
 * Returns:
 *   Saved search state
 */
int init_move_search(void* horiz_ctx, void* vert_ctx, void* dawg_data)
{
    int saved_state;

    /* Initialize horizontal search */
    init_search(horiz_ctx);

    /* Clear callback pointer */
    g_callback_ptr = NULL;

    /* Set horizontal search callback */
    /* Callback at A5+2682 */
    set_callback((void*)0x2682);  /* uncertain - actual address */

    /* Copy DAWG search data (340 bytes) */
    memcpy_jt(g_dawg_search_area, dawg_data, DAWG_SEARCH_SIZE);

    /* Save current state */
    saved_state = g_entry_count;

    /* Perform horizontal search */
    search_direction(horiz_ctx, DIRECTION_HORIZONTAL);

    /* Initialize vertical search */
    init_search(vert_ctx);

    /* Clear cache buffer (3584 bytes) */
    memset_jt(g_cache_buffer, 0, CACHE_BUFFER_SIZE);

    /* Set vertical search callback */
    /* Callback at A5+2674 */
    set_callback((void*)0x2674);  /* uncertain - actual address */

    /* Perform vertical search */
    search_direction(vert_ctx, DIRECTION_VERTICAL);

    /* Process and finalize results */
    void* results = process_cache_buffer(g_cache_buffer);
    finalize_results(results);

    return saved_state;
}

/*
 * cache_move_with_debug - Function at 0x0110
 *
 * Extended cache function that includes debug information.
 * Copies 14 bytes of move data to cache entry.
 *
 * Parameters:
 *   move - Move to cache with debug info
 */
void cache_move_with_debug(Move* move)
{
    int32_t score;
    int16_t player_id;
    int32_t cache_index;
    uint8_t* cache_dest;

    /* Clear callback pointer */
    g_callback_ptr = NULL;

    /* Validate move */
    if (!validate_move(move)) {
        return;
    }

    score = move->score;
    player_id = move->position;

    /* Calculate cache offset */
    cache_index = (player_id * 28) & 0xFFFF;  /* uncertain */

    /* Check primary array */
    if (g_results_array[cache_index] > 0) {
        /* Calculate destination in cache buffer */
        cache_dest = g_cache_buffer + cache_index + 14;

        /*
         * Copy 14 bytes of move data
         * This is 4+4+4+2 = 14 bytes
         */
        uint32_t* dest32 = (uint32_t*)cache_dest;
        uint32_t* src32 = (uint32_t*)&move->field1;  /* uncertain offset */

        *dest32++ = *src32++;  /* 4 bytes */
        *dest32++ = *src32++;  /* 4 bytes */
        *dest32++ = *src32++;  /* 4 bytes */
        *(uint16_t*)dest32 = *(uint16_t*)src32;  /* 2 bytes */

        /* Update cache entry */
        update_cache_entry(cache_dest, move);

        /* Copy to secondary cache */
        g_secondary_cache[cache_index] = g_results_array[cache_index];

        /* Store new score */
        g_results_array[cache_index] = score;
    } else {
        /* Secondary cache path */
        if (g_secondary_cache[cache_index] > 0) {
            g_secondary_cache[cache_index] = score;

            /* Also update cache entry */
            cache_dest = g_cache_buffer + cache_index + 14;
            update_cache_entry(cache_dest, move);
        }
    }

    /* Check move flags */
    if (move->flags != 0) {
        /* Set cached flag indicator */
        move->cached_score = 20;  /* Magic value indicating cached */
    }

    /* Set debug callback */
    /* Debug callback at A5+2690 */
    g_callback_ptr = (void*)0x2690;  /* uncertain */

    /* Finalize */
    finalize_cache(move);
}

/*
 * find_cached_move - Function at 0x01FE
 *
 * Searches the cache for a matching move entry.
 * If found, compares scores and may invalidate cache entry.
 *
 * Parameters:
 *   search - Move search criteria
 *
 * Returns:
 *   0 if cache entry is equal or better
 *   1 if not found or search entry is better (cache invalidated)
 */
int find_cached_move(Move* search)
{
    MoveEntry* cache = g_dawg_search_area;
    MoveEntry* end;
    int32_t search_total, cache_total;

    /* Calculate end of cache array */
    int entry_size = sizeof(MoveEntry);  /* 34 bytes */
    end = (MoveEntry*)((uint8_t*)cache + (g_entry_count * entry_size));

    /* Calculate search move's total score */
    search_total = search->score + search->cached_score + search->bonus;

    /*
     * Iterate through cache entries
     */
    while (cache < end) {
        /* Compare position */
        if (cache->position != search->position) {
            goto next_entry;
        }

        /* Compare player */
        if (cache->player_id != search->direction) {  /* uncertain field mapping */
            goto next_entry;
        }

        /* Compare direction */
        if (cache->direction != search->row) {  /* uncertain */
            goto next_entry;
        }

        /*
         * Found matching entry - compare scores
         */
        cache_total = *(int32_t*)&cache->field1    /* offset 14 -> score at 16 */
                    + *(int32_t*)&cache->field2    /* offset 18 -> cached at 20 */
                    + *(int32_t*)&cache->field3;   /* offset 22 -> bonus at 24 */

        if (search_total > cache_total) {
            /* Search has better score - invalidate cache entry */
            invalidate_entry((Move*)cache);
            return 1;  /* Continue searching */
        } else {
            /* Cache entry is equal or better */
            return 0;  /* Use cached */
        }

    next_entry:
        cache++;  /* Advance 34 bytes */
    }

    return 1;  /* Not found in cache */
}
```

### Key Algorithmic Notes

```
TWO-LEVEL CACHE:
================
Primary (g_results_array at A5-22698):
- Best score for each board position
- Updated when better move found
- Previous best saved to secondary

Secondary (g_secondary_cache at A5-12496):
- Previous best score per position
- Used for alternative move suggestions
- Also updated when primary changes

CACHE ENTRY MATCHING:
=====================
Three fields must match for cache hit:
- Position (offset 30): Encoded board position
- Player ID (offset 32): Current player
- Direction (offset 33): 0=vertical, 8=horizontal

SCORE COMPARISON:
=================
Total score = base_score (16) + cached_score (20) + bonus (24)
- 12 bytes of score information per entry
- Replacement occurs only if new score is strictly better

CALLBACK SYSTEM:
================
Callbacks registered via JT[2618]:
- A5+2682: Horizontal search callback
- A5+2674: Vertical search callback
- A5+2690: Debug callback

Stored in g_callback_ptr (A5-19486) during search.

14-BYTE PARTIAL COPY:
=====================
Function 0x0110 copies 14 bytes (4+4+4+2):
- Maps to fields 1-4 in MoveEntry
- Excludes word letters and initial reserved bytes
- Includes score components and flags

ENTRY SIZE:
===========
34 bytes per entry:
- 14 bytes: Reserved/word data
- 12 bytes: Score components (3 x 4 bytes)
- 2 bytes: Flags
- 2 bytes: Position
- 2 bytes: Player/Direction
- 2 bytes: Padding/alignment

INTEGRATION:
============
CODE 40 bridges search and validation:
- Receives results from CODE 43/44 searches
- Stores in g_dawg_search_area (340 bytes = 10 entries)
- Primary/secondary arrays likely much larger
```
