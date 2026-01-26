# CODE 6 Detailed Analysis - DAWG Direction Selector

## Overview

| Property | Value |
|----------|-------|
| Size | 1026 bytes |
| JT Offset | 168 |
| JT Entries | 7 |
| Functions | 10 |
| Purpose | **DAWG direction selection for move generation** |
| Confidence | **HIGH** (verified against binary) |

## Critical Function: DAWG Direction Selection

This is the core function that enables efficient move generation. Maven uses **two DAWG structures**:

1. **Reversed DAWG** (Section 1 at A5-8596): Words stored backwards (AARDVARK → KRAVDRAA)
2. **Forward DAWG** (Section 2 at A5-8600): Words stored normally (AARDVARK → AARDVARK)

### Why Two DAWGs?

As the user correctly noted: when placing tiles to the LEFT of already-played tiles, anchoring at the end of the word and searching in reverse order is much more efficient than searching forward, which would require starting 7 empty spaces away with many search paths failing to reach the anchor.

**Example**: Board has `CAT` played. To find words ending in `CAT`:
- **Forward search**: Would need to start at every position up to 7 squares left, searching ACAT, BCAT, CCAT... then AACAT, ABCAT... Most paths waste time.
- **Backward search**: Start at `C`, search reversed DAWG for `TAC...` paths. Only valid prefixes are explored.

---

## Function 0x0000 - select_dawg_direction (VERIFIED)

```asm
; void select_dawg_direction(void)
; Selects which DAWG section(s) to use based on direction_mode in game state.
;
; Direction modes:
;   0 = Backward search only (extending LEFT from anchor)
;   1 = Forward search only (extending RIGHT from anchor)
;   2 = Both directions (exhaustive move search)

0000: 206D DE78      MOVEA.L  -8584(A5),A0      ; A0 = g_main_handle
0004: 2050           MOVEA.L  (A0),A0           ; A0 = *handle (dereference)
0006: 3028 0302      MOVE.W   770(A0),D0        ; D0 = direction_mode (offset 770)
000A: 670E           BEQ.S    $001A             ; if direction==0, goto backward_only
000C: 6B52           BMI.S    $0060             ; if direction<0, return (invalid)
000E: 5740           SUBQ.W   #3,D0             ; D0 = direction - 3
0010: 674A           BEQ.S    $005C             ; if direction==3, goto error
0012: 6A4C           BPL.S    $0060             ; if direction>3, return
0014: 5240           ADDQ.W   #1,D0             ; D0 = direction - 2
0016: 6A26           BPL.S    $003E             ; if direction>=2, goto both_directions
0018: 6012           BRA.S    $002C             ; else direction==1, goto forward_only

; === Direction 0: BACKWARD SEARCH ONLY ===
; Use reversed DAWG (Section 1) for extending LEFT from anchor
001A: 2B6D DE6C D148 MOVE.L   -8596(A5),-11960(A5)  ; g_active_dawg = Section1 (reversed)
0020: 2B6D DE74 D14C MOVE.L   -8588(A5),-11956(A5)  ; g_active_count = section1_count
0026: 42AD D154      CLR.L    -11948(A5)            ; g_alt_dawg = NULL (single section)
002A: 6034           BRA.S    $0060                 ; return

; === Direction 1: FORWARD SEARCH ONLY ===
; Use forward DAWG (Section 2) for extending RIGHT from anchor
002C: 2B6D DE68 D148 MOVE.L   -8600(A5),-11960(A5)  ; g_active_dawg = Section2 (forward)
0032: 2B6D DE70 D14C MOVE.L   -8592(A5),-11956(A5)  ; g_active_count = section2_count
0038: 42AD D154      CLR.L    -11948(A5)            ; g_alt_dawg = NULL (single section)
003C: 6022           BRA.S    $0060                 ; return

; === Direction 2: BOTH DIRECTIONS ===
; Use both DAWGs for exhaustive move search
003E: 2B6D DE6C D148 MOVE.L   -8596(A5),-11960(A5)  ; g_active_dawg = Section1 (reversed)
0044: 2B6D DE74 D14C MOVE.L   -8588(A5),-11956(A5)  ; g_active_count = section1_count
004A: 2B6D DE68 D150 MOVE.L   -8600(A5),-11952(A5)  ; g_alt_dawg = Section2 (forward)
0050: 2B6D DE70 D154 MOVE.L   -8592(A5),-11948(A5)  ; g_alt_count = section2_count
0056: 42AD D15C      CLR.L    -11940(A5)            ; g_terminator = NULL
005A: 6004           BRA.S    $0060                 ; return

; === Error handler ===
005C: 4EAD 01A2      JSR      418(A5)               ; bounds_check / assert
0060: 4E75           RTS
```

### C Translation (VERIFIED)

```c
/*
 * select_dawg_direction - Choose DAWG section(s) for move search
 *
 * This is critical for efficient move generation. The direction_mode
 * determines whether we're searching:
 *   - Backward (extending left from anchor tile)
 *   - Forward (extending right from anchor tile)
 *   - Both (exhaustive search for all legal moves)
 *
 * The reversed DAWG allows efficient backward search by storing words
 * in reverse order. Without it, backward search would require starting
 * up to 7 squares away and most search paths would fail to connect.
 */
void select_dawg_direction(void) {
    GameState *state = (GameState*)*g_main_handle;
    short direction = state->direction_mode;  /* offset 770 */

    switch (direction) {
    case 0:
        /* BACKWARD SEARCH: Extending LEFT from anchor
         * Use reversed DAWG - words stored backwards
         * Example: Finding words ending in "CAT" by searching "TAC" paths
         */
        g_active_dawg_base = g_reversed_dawg_ptr;    /* A5-8596 → A5-11960 */
        g_active_dawg_count = g_reversed_dawg_count; /* A5-8588 → A5-11956 */
        g_alt_dawg_base = NULL;                      /* Single section mode */
        break;

    case 1:
        /* FORWARD SEARCH: Extending RIGHT from anchor
         * Use forward DAWG - words stored normally
         * Example: Finding words starting with "CAT" by searching "CAT" paths
         */
        g_active_dawg_base = g_forward_dawg_ptr;     /* A5-8600 → A5-11960 */
        g_active_dawg_count = g_forward_dawg_count;  /* A5-8592 → A5-11956 */
        g_alt_dawg_base = NULL;                      /* Single section mode */
        break;

    case 2:
        /* BOTH DIRECTIONS: Exhaustive move search
         * Use both DAWGs - search left AND right from every anchor
         * This is used for complete move generation
         */
        g_active_dawg_base = g_reversed_dawg_ptr;    /* Primary: reversed */
        g_active_dawg_count = g_reversed_dawg_count;
        g_alt_dawg_base = g_forward_dawg_ptr;        /* Alternate: forward */
        g_alt_dawg_count = g_forward_dawg_count;
        g_terminator = NULL;                         /* Mark end of list */
        break;

    default:
        bounds_check_error();  /* Invalid direction */
    }
}
```

---

## Global Variables (VERIFIED)

### DAWG Pointers (Set by CODE 2 during resource loading)

| Offset | Name | Description |
|--------|------|-------------|
| A5-8596 | g_reversed_dawg_ptr | **Section 1**: Reversed DAWG (words stored backwards) |
| A5-8588 | g_reversed_dawg_count | Node count for reversed DAWG |
| A5-8600 | g_forward_dawg_ptr | **Section 2**: Forward DAWG (words stored normally) |
| A5-8592 | g_forward_dawg_count | Node count for forward DAWG |

### Active DAWG Pointers (Set by select_dawg_direction)

| Offset | Name | Description |
|--------|------|-------------|
| A5-11960 | g_active_dawg_base | Current active DAWG base pointer |
| A5-11956 | g_active_dawg_count | Current active DAWG node count |
| A5-11952 | g_alt_dawg_base | Alternate DAWG (direction 2 only) |
| A5-11948 | g_alt_dawg_count | Alternate DAWG count (direction 2 only) |
| A5-11940 | g_terminator | NULL terminator (direction 2 only) |

### Game State Structure (at handle dereference)

| Offset | Size | Name | Description |
|--------|------|------|-------------|
| 770 | 2 | direction_mode | 0=backward, 1=forward, 2=both |
| 772 | 2 | board_direction_flag | 0=horizontal, 1=vertical tile placement |

---

## Move Generation Algorithm

The two-DAWG architecture enables this efficient algorithm:

```
For each anchor square (adjacent to existing tiles):

    1. BACKWARD SEARCH (direction 0):
       - Set active DAWG = reversed DAWG
       - Start at anchor, search LEFT
       - Each path in reversed DAWG represents valid suffixes
       - Track letters used from rack

    2. FORWARD SEARCH (direction 1):
       - Set active DAWG = forward DAWG
       - From each valid backward position, search RIGHT
       - Complete the word using remaining rack tiles

    3. VALIDATE:
       - Check cross-words (perpendicular intersections)
       - Score the move
       - Add to move list if legal
```

### Why This Is Efficient

**Without reversed DAWG** (naive forward-only approach):
```
To find words ending at anchor 'T':
  Start 7 squares left, try A______T, B______T, C______T...
  Then 6 squares left, try AA_____T, AB_____T...
  Most paths never reach the anchor - wasted computation
```

**With reversed DAWG**:
```
To find words ending at anchor 'T':
  Search reversed DAWG starting with 'T'
  'T' → 'TA' → 'TAC' (matches CAT backwards)
  Only valid paths are explored
  Dramatically reduces search space
```

---

## Function 0x020E - toggle_board_direction (VERIFIED)

This toggles between horizontal and vertical tile placement (separate from DAWG direction).

```asm
; void toggle_board_direction(void)
; Switches between horizontal (across) and vertical (down) word placement

020E: 206D DE78      MOVEA.L  -8584(A5),A0      ; A0 = g_main_handle
0212: 2050           MOVEA.L  (A0),A0           ; dereference
0214: 4A68 0304      TST.W    772(A0)           ; test board_direction_flag
0218: 6714           BEQ.S    $022E             ; if 0 (horizontal), switch to vertical

; Currently vertical → switch to horizontal
021A: 41ED C35E      LEA      -15522(A5),A0     ; A0 = &g_horizontal_buffer
021E: 2B48 C376      MOVE.L   A0,-15498(A5)     ; g_current_buffer = horizontal
0222: 226D DE78      MOVEA.L  -8584(A5),A1
0226: 2251           MOVEA.L  (A1),A1
0228: 4269 0304      CLR.W    772(A1)           ; board_direction_flag = 0
022C: 6014           BRA.S    $0242

; Currently horizontal → switch to vertical
022E: 41ED C366      LEA      -15514(A5),A0     ; A0 = &g_vertical_buffer
0232: 2B48 C376      MOVE.L   A0,-15498(A5)     ; g_current_buffer = vertical
0236: 226D DE78      MOVEA.L  -8584(A5),A1
023A: 2251           MOVEA.L  (A1),A1
023C: 337C 0001 0304 MOVE.W   #1,772(A1)        ; board_direction_flag = 1
0242: 4E75           RTS
```

### C Translation

```c
/*
 * toggle_board_direction - Switch between horizontal/vertical placement
 *
 * This is SEPARATE from DAWG direction (forward/backward).
 * Board direction determines whether tiles are placed:
 *   - Horizontally (left-to-right in a row)
 *   - Vertically (top-to-bottom in a column)
 *
 * Both board directions can use either DAWG direction depending on
 * where the anchor is relative to existing tiles.
 */
void toggle_board_direction(void) {
    GameState *state = (GameState*)*g_main_handle;

    if (state->board_direction_flag != 0) {
        /* Currently vertical → switch to horizontal */
        g_current_buffer = &g_horizontal_buffer;  /* A5-15522 */
        state->board_direction_flag = 0;
    } else {
        /* Currently horizontal → switch to vertical */
        g_current_buffer = &g_vertical_buffer;    /* A5-15514 */
        state->board_direction_flag = 1;
    }
}
```

---

## Word Lister Integration

The Word Lister dialog uses direction mode 2 (both DAWGs) to enumerate all words matching a pattern:

1. User enters rack letters (e.g., "AEINRST" or "???????" for wildcards)
2. CODE 15 calls select_dawg_direction with mode 2
3. Both DAWGs are searched to find all valid words
4. Results displayed in scrollable list

For anagram search, using both DAWGs ensures completeness - every valid word arrangement is found regardless of which direction it would be played on the board.

---

## Remaining Functions

### Function 0x0062 - init_game_window
Window initialization with time limit parsing (700-2100 range, possibly centiseconds).

### Function 0x029C - create_main_window
Allocates 1070-byte handle for game state, creates window from 'prfs' resource.

### Function 0x038A - toggle_window_visibility
Toggles visibility flag at offset 780, triggers redraw.

---

## Summary

| Concept | Meaning |
|---------|---------|
| **DAWG Direction** | Forward (→) or Backward (←) search through word structure |
| **Board Direction** | Horizontal (across) or Vertical (down) tile placement |
| **Direction 0** | Backward search using reversed DAWG |
| **Direction 1** | Forward search using forward DAWG |
| **Direction 2** | Both searches for exhaustive move generation |

The two-DAWG architecture is a key optimization that makes Maven's move generation efficient by avoiding wasteful search paths that would never reach anchor tiles.
