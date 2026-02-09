# CODE 14 Detailed Analysis - Move Selection & Search Coordination

## Overview

| Property | Value |
|----------|-------|
| Size | 2,766 bytes (code) + 4 byte header = 2,770 total |
| JT Offset | 624 |
| JT Entries | 14 |
| Functions | 20 (LINK A6) |
| Purpose | **Move selection, score comparison, search coordination, move list management** |
| Confidence | **HIGH** |

## Module Purpose

CODE 14 is the AI move selection and search coordination module. It:
1. Copies rack letters to working buffers for move generation
2. Coordinates the full-board search process across all positions
3. Compares candidate moves by computing total scores (base + bonus + extra)
4. Categorizes score differences with thresholds (200, 500 points)
5. Manages move candidate data structures (34-byte move records)
6. Handles handle-based move list storage with 6-byte records
7. Performs per-position board analysis with cross-check integration
8. Contains the move list display and scrolling subsystem

With 14 JT entries, this is one of the most externally-connected CODE resources in Maven.

## Function Map

| Offset | Frame | Size | Regs Saved | Purpose |
|--------|-------|------|------------|---------|
| 0x0000 | 0 | 0x2E | D7/A3/A4 | Copy rack letters to buffer |
| 0x002E | -4 | 0xEA | -- | Main search coordinator |
| 0x0118 | 0 | 0x6A | D5-D7/A3/A4 | Compare two moves by score |
| 0x0182 | -16 | 0x158 | D5-D7/A2/A3/A4 | Process move candidate |
| 0x02DA | 0 | 0x28 | -- | Update record index |
| 0x0302 | 0 | 0x18 | -- | Set window title (A91A) |
| 0x031A | -- | 0x14 | -- | Clear display state (leaf) |
| 0x032E | -8 | 0x3A | -- | Convert global-to-local coordinates |
| 0x0368 | 0 | 0x38 | -- | Check valid board position |
| 0x03A0 | -- | 0x0C | -- | Init move list pointer |
| 0x03AC | -4 | 0x26 | -- | Get handle record count (size/6) |
| 0x03D2 | 0 | 0x3E | A4 | Get record from handle by index |
| 0x0410 | 0 | 0x18 | -- | Store move attribute |
| 0x0428 | 0 | 0x1E | -- | Set move entry at index |
| 0x0446 | -10 | 0xBA | D6/D7/A4 | Get move record for list entry |
| 0x0500 | -4 | 0x6E | D7 | Process move list selection |
| 0x056E | -168 | 0x1CC | D3-D7/A2/A3/A4 | Main move list entry processor |
| 0x073A | -8 | 0x3E | -- | Scroll/offset calculation |
| 0x0778 | -60 | 0x1B8 | D4-D7/A3/A4 | Board position analyzer (main) |
| 0x0930 | -12 | 0xE8 | D7/A3/A4 | Insert move into list |
| 0x0A18 | -4 | 0x5E | D7/A4 | Scroll rect and update display |

## Function-by-Function Analysis

### Function 0x0000 - Copy Rack Letters to Buffer
**Hex verification:** `4E56 0000 48E7 0118` = LINK A6,#0; MOVEM.L D7/A3/A4,-(SP)

```asm
0008: MOVEA.L 8(A6),A4       ; A4 = destination buffer
000C: MOVEQ   #0,D7          ; D7 = index
000E: LEA     -8664(A5),A3   ; A3 = g_rack (A5-8664)
0012: BRA.S   $001C
0014: MOVE.B  1(A3),(A4)+    ; copy letter byte (offset 1 in rack entry)
0018: ADDQ.W  #1,D7
001A: ADDQ.L  #8,A3          ; next rack entry (8 bytes)
001C: TST.W   (A3)           ; tile_value != 0?
001E: BNE.S   $0014          ; continue
0020: CLR.B   (A4)           ; null terminate
0022: MOVE.L  8(A6),D0       ; return buffer ptr
```

The letter is at offset 1 within each 8-byte rack entry (the low byte of the 16-bit tile_value).

```c
char* copy_rack_to_buffer(char *dest) {
    RackEntry *rack = g_rack;  /* A5-8664 */
    int i = 0;
    while (rack->tile_value != 0) {
        dest[i++] = rack->letter;  /* byte at offset 1 */
        rack++;                     /* +8 bytes */
    }
    dest[i] = '\0';
    return dest;
}
```

### Function 0x002E - Main Search Coordinator
**Hex verification:** `4E56 FFFC 4EBA 0A40` = LINK A6,#-4; BSR init_search

This is the primary search entry point. Sequence:
1. `4EBA 0A40` -- PC-relative call to init function
2. `4EAD 043A` -- JT[1082] setup phase 1
3. `4EAD 03FA` -- JT[1018] setup phase 2
4. `486D C366` -- PEA A5-15514 (g_field_14)
5. `4EBA FFBC` -- Copy rack to buffer (calls function 0x0000)
6. `4EAD 06AA` -- JT[1706] start search
7. `486D 02B2` -- PEA 690(A5) (search context)
8. `486E FFFC` -- PEA -4(A6) (local result pointer)
9. `4EAD 06BA` -- JT[1722] coordinate search

After search, performs standard bounds check (`0C6D 0008 A386`) and DAWG comparison (`2F2D A222 / 2F2D 93AC / 4EAD 0DB2` = push A5-24030, push A5-27732, JT[3506] strcmp).

On mismatch, calls internal error handler. On success, clears A5-19486 (`42AD B3E2`) and calls JT[1714] for cleanup.

```c
void coordinate_move_search(void) {
    long local_result;
    init_search_internal();      /* PC-relative */
    setup_phase_1();             /* JT[1082] */
    setup_phase_2();             /* JT[1018] */
    copy_rack_to_buffer(g_field_14);  /* A5-15514 */
    start_search();              /* JT[1706] */
    coordinate_search(690, &local_result);  /* JT[1722] */

    /* Bounds validation */
    if (g_bounds_counter >= 8 || g_bounds_counter < 0)
        bounds_error();          /* JT[418] */

    /* DAWG integrity check */
    if (strcmp(g_compare_ptr, g_dawg_ptr) != 0)
        handle_mismatch();

    g_search_result = 0;         /* A5-19486 */
    cleanup_search();            /* JT[1714] */
    finalize();                  /* JT[1730] */
}
```

### Function 0x0118 - Compare Two Moves by Score
**Hex verification:** `4E56 0000 48E7 0718` = LINK A6,#0; MOVEM.L D5/D6/D7/A3/A4,-(SP)

```asm
0120: MOVEA.L 8(A6),A4       ; A4 = move1
0124: MOVEA.L 12(A6),A3      ; A3 = move2
; Total score for move1
0128: MOVE.L  20(A4),D7      ; base_score
012C: ADD.L   16(A4),D7      ; + bonus_score
0130: ADD.L   24(A4),D7      ; + extra_score (leave value)
; Total score for move2
0134: MOVE.L  20(A3),D6      ; base_score
0138: ADD.L   16(A3),D6      ; + bonus_score
013C: ADD.L   24(A3),D6      ; + extra_score
; Compare
0140: CMP.L   D6,D7
0142: BGT.S   $0174          ; move1 > move2 -> "significant"
0144: CMP.L   D7,D6
0146: BNE.S   $0150          ; not equal
0148: LEA     -7426(A5),A0   ; "equal" (A5-7426)
014E: BRA.S   $017A
; Difference
0150: MOVE.L  D6,D5
0152: SUB.L   D7,D5          ; diff = score2 - score1
0154: CMPI.L  #200,D5        ; <= 200?
015A: BGT.S   $0164
015C: LEA     -7420(A5),A0   ; "close" (A5-7420)
0162: BRA.S   $017A
0164: CMPI.L  #500,D5        ; <= 500?
016A: BGT.S   $0174
016C: LEA     -7414(A5),A0   ; "moderate" (A5-7414)
0172: BRA.S   $017A
0174: LEA     -7410(A5),A0   ; "significant" (A5-7410)
```

Verified threshold values from hex:
- `0000 00C8` = 200 at offset 0x0156
- `0000 01F4` = 500 at offset 0x0166

```c
char* compare_moves(MoveData *move1, MoveData *move2) {
    long score1 = move1->base_score + move1->bonus_score + move1->extra_score;
    long score2 = move2->base_score + move2->bonus_score + move2->extra_score;

    if (score1 > score2) return "significant";  /* A5-7410 */
    if (score1 == score2) return "equal";        /* A5-7426 */

    long diff = score2 - score1;
    if (diff <= 200)  return "close";     /* A5-7420 */
    if (diff <= 500)  return "moderate";  /* A5-7414 */
    return "significant";                  /* A5-7410 */
}
```

### Function 0x0182 - Process Move Candidate
**Hex verification:** `4E56 FFF0 48E7 0738` = LINK A6,#-16; MOVEM.L D5/D6/D7/A2/A3/A4,-(SP)

Large function (0x158 bytes) that evaluates a candidate move:
1. Validates candidate via PC-relative call at 0x018E
2. Sets up buffers via JT[2410] and JT[2386] on g_field_14
3. Iterates rack entries checking played tiles:
```asm
01A8: MOVEQ   #0,D7          ; count = 0
01AA: LEA     -8664(A5),A4   ; rack
01B0: BRA.S   $01CC
01B2: TST.W   2(A4)          ; played flag?
01B6: BEQ.S   $01C8          ; skip if not played
; Update letter counts
01B8: LEA     -23218(A5),A3  ; letter count array
; Index and decrement
01C8: ADDQ.W  #1,D7
01CA: ADDQ.L  #8,A4          ; next tile
01CC: MOVE.W  (A4),D6
01CE: BNE.S   $01B2          ; loop
```
4. Compares with existing best via JT[3506]
5. Stores as new best if better

### Function 0x02DA - Update Record Index
**Hex verification:** `4E56 0000 302D D76A` = LINK A6,#0; MOVE.W A5-10390,D0

Compares current record index (A5-10390) with parameter 8(A6). If different, calls JT[1082] to update, stores new value.

### Function 0x0302 - Set Window Title
**Hex verification:** `4E56 0000 2F2D DEB8` = LINK A6,#0; push A5-8520 (window ptr)

Calls A91A (_SetWTitle) trap with window pointer from A5-8520.

### Function 0x032E - Convert Global-to-Local Coordinates
**Hex verification:** `4E56 FFF8 206E 0008` = LINK A6,#-8; MOVEA.L 8(A6),A0

Copies 8 bytes (point/rect) from parameter to local, applies `700C C1EE 000C` (multiply by 12) for coordinate transformation, then calls A873 (_GlobalToLocal) and A928 (_InvalRect).

### Function 0x0368 - Check Valid Board Position
**Hex verification:** `4E56 0000 41ED C366` = LINK A6,#0; LEA A5-15514,A0

Checks g_field_14 against limit values. Calls JT[1282] for validation, checks A5-9810 flag. Returns 0 or 1.

```c
short check_valid_position(void) {
    if (g_field_14[0] == 0) return 0;
    if (!validate_position()) {  /* JT[1282] */
        if (g_validation_flag == 0) return 1;
        return 0;
    }
    return 0;
}
```

### Function 0x03AC - Get Handle Record Count
**Hex verification:** `4E56 FFFC 42A7 206D DEB8` = LINK A6,#-4; CLR.L -(A7); MOVEA.L A5-8520,A0

Gets handle from window data at offset 0x00CA (202 decimal), calls JT[2826] (GetHandleSize), divides by 6 via JT[74].

```c
long get_record_count(void) {
    Handle h = *(Handle*)((char*)g_window_ptr + 202);
    long size = GetHandleSize(h);  /* JT[2826] */
    return size / 6;               /* JT[74] */
}
```

### Function 0x03D2 - Get Record from Handle by Index
**Hex verification:** `4E56 0000 2F0C 7006 C1EE 0008` = LINK; push A4; p = 6 * param

Multiplies parameter by 6 (`7006 C1EE 0008` = MOVEQ #6,D0; MULS.W 8(A6),D0 -- actually this is MULS.W on the param), dereferences handle chain, validates record type (`0C11 0002` = CMPI.B #2,(A1)), calls JT[1514].

### Function 0x0446 - Get Move Record for List Entry
**Hex verification:** `4E56 FFF6 48E7 0308` = LINK A6,#-10; MOVEM.L D6/D7/A4,-(SP)

Gets record count, iterates through records calling JT[338] to format each entry. Uses `3F06 / 2F2D DEB8 / 4EAD 0152` pattern.

### Function 0x0500 - Process Move List Selection
**Hex verification:** `4E56 FFFC 2F07 42A7` = LINK A6,#-4; MOVE.L D7,-(SP); CLR.L

Gets handle info, checks record index against A5-10390. If within range and valid, calls JT[3074] for display. Handles scroll display via A91D (_HiliteControl) trap.

### Function 0x056E - Main Move List Entry Processor
**Hex verification:** `4E56 FF58 48E7 1F38` = LINK A6,#-168; MOVEM.L D3-D7/A2/A3/A4,-(SP)

The most complex function (0x1CC bytes). Processes a move list entry for detailed analysis:

1. Copies 34-byte move structure via block copy:
```asm
059C: MOVEA.L (A0),A0        ; deref handle
0598: MOVEA.L 2(A0),A0       ; get data ptr
059C: MOVEA.L (A0),A0        ; deref again
; Block copy 34 bytes (8 longs + 1 word)
059E: MOVEQ   #7,D0
05A0: MOVE.L  (A0)+,(A1)+    ; 8 iterations
05A2: DBF     D0,$05A0
05A4: MOVE.W  (A0)+,(A1)+    ; final 2 bytes
```

2. Calculates total score:
```asm
05B8: MOVE.L  20(A3),D4      ; base_score
05BC: ADD.L   16(A3),D4      ; + bonus_score
05C0: ADD.L   24(A3),D4      ; + extra_score
```

3. Gets record count and iterates through entries, calling scoring functions

4. Formats results using sprintf (JT[2066])

5. Performs display update with GlobalToLocal (A873), InvalRect (A928)

### Function 0x0778 - Board Position Analyzer
**Hex verification:** `4E56 FFC4 48E7 1F38` = LINK A6,#-60; MOVEM.L D4-D7/A3/A4,-(SP)

Second most complex function (0x1B8 bytes). Performs per-position board analysis:

1. Validates position with A873 (GlobalToLocal), checks against A5-8520 (window ptr)
2. Gets handle and record data via standard handle chain
3. Copies 34-byte move structure (same block-copy pattern)
4. Checks for special position types (blank presence at offset 0x20)
5. Iterates through rack entries matching against board state
6. When blank found, searches letter positions using nested loops
7. Computes cross-check scores with A5-17268 and A5-17308 offsets
8. Calls JT[1378] and JT[1370] for scoring
9. Uses tolower (JT[3562]) for letter comparison
10. Final display update via JT[3466], JT[1482]

### Function 0x0930 - Insert Move into List
**Hex verification:** `4E56 FFF4 48E7 0118` = LINK A6,#-12; MOVEM.L D7/A3/A4,-(SP)

Inserts a move record at the appropriate position in the sorted move list. Validates record index, computes handle size, performs bounds checking, then calls A928 (InvalRect) and handles list reordering via JT[66].

### Function 0x0A18 - Scroll Rect and Update Display
**Hex verification:** `4E56 FFFC 48E7 0108` = LINK A6,#-4; MOVEM.L D7/A4,-(SP)

Gets record count, checks against A5-10390 (current index). Uses alternate display buffer at A5-7316 (`49ED E36C`) or A5-3504 (`286D F250`). Performs A86B (ScrollRect) and A947 (ValidRect) for display update.

## Move Data Structure (34 bytes)

Verified from block-copy pattern (8 longs + 1 word = 34 bytes):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 2 | flags |
| 2 | 2 | row |
| 4 | 2 | column |
| 6 | 2 | direction |
| 8 | 8 | word (null-terminated) |
| 16 | 4 | bonus_score |
| 20 | 4 | base_score |
| 24 | 4 | extra_score (leave value) |
| 28 | 2 | tile_count |
| 30 | 4 | placement_data |

Total score = base_score + bonus_score + extra_score (verified at 0x0128-0x0130)

## Score Comparison Thresholds

| Difference | Category | String Offset |
|------------|----------|---------------|
| 0 | Equal | A5-7426 |
| 1-200 | Close | A5-7420 |
| 201-500 | Moderate | A5-7414 |
| 501+ | Significant | A5-7410 |

## Toolbox Traps

| Offset | Trap | Name | Context |
|--------|------|------|---------|
| 0x030E | A91A | _SetWTitle | Set window title |
| 0x0358 | A873 | _GlobalToLocal | Coordinate conversion |
| 0x035E | A928 | _InvalRect | Invalidate rect |
| 0x0398 | A38E | _InitApplZone? | Zone init |
| 0x0440 | A02A | _CopyMask | Copy with mask |
| 0x04AC | A023 | _DisposeHandle | Dispose handle |
| 0x04C6 | A024 | _GetHandleSize | Get size |
| 0x04EA | A873 | _GlobalToLocal | Coordinate conversion |
| 0x04F4 | A928 | _InvalRect | Invalidate rect |
| 0x054C | A91D | _HiliteControl | Highlight control |
| 0x0586 | A8D4 | _InvalRgn | Invalidate region |
| 0x06A6 | A893 | _MoveTo | Move pen |
| 0x06AA | A89D | _Line? | Draw line |
| 0x06BC | A892 | _Line | Draw relative line |
| 0x0708 | A893 | _MoveTo | Move pen |
| 0x070E | A884 | _DrawString | Draw text |
| 0x0748 | A873 | _GlobalToLocal | Coordinate conversion |
| 0x0772 | A8A4 | _InsetRect? | Inset rectangle |
| 0x093E | A873 | _GlobalToLocal | Coordinate conversion |
| 0x0988 | A928 | _InvalRect | Invalidate rect |
| 0x09C8 | A023 | _DisposeHandle | Dispose handle |
| 0x09FC | A02A | _CopyMask | Copy with mask |
| 0x0A64 | A86B | _ScrollRect | Scroll rectangle |
| 0x0A68 | A947 | _ValidRect | Validate rect |
| 0x0A7C | A91A | _SetWTitle | Set window title |
| 0x0A92 | A873 | _GlobalToLocal | Coordinate conversion |
| 0x0A9C | A8A3 | _InsetRect | Inset rectangle |

## Key Global Variables

| Offset | Type | Name | Purpose |
|--------|------|------|---------|
| A5-27732 | long | g_dawg_ptr | Main DAWG pointer |
| A5-24030 | long | g_compare_ptr | DAWG comparison pointer |
| A5-23674 | short | g_bounds_counter | Bounds checking counter |
| A5-23218 | char[27] | g_letter_counts | Available letter counts |
| A5-19486 | long | g_search_result | Search result storage |
| A5-17308 | -- | g_cross_score_1 | Cross-check score buffer |
| A5-17268 | -- | g_cross_score_2 | Cross-check score buffer |
| A5-15514 | char[] | g_field_14 | General purpose buffer (board) |
| A5-15498 | long | g_field_limit | Field limit value |
| A5-10390 | short | g_record_index | Current record index |
| A5-9810 | short | g_validation_flag | Position validation flag |
| A5-8664 | struct[7] | g_rack | Player's rack entries |
| A5-8520 | long | g_window_ptr | Window data pointer |
| A5-7426..-7410 | strings | g_comparison_strs | Comparison category strings |

## JT Call Summary

| JT Offset | Count | Purpose |
|-----------|-------|---------|
| 66 | 2 | Common utility |
| 74 | 4 | Integer division |
| 338 | 2 | Format entry |
| 418 | 4 | Bounds check / assertion |
| 434 | 1 | Unknown setup |
| 1018 | 1 | Setup phase 2 |
| 1082 | 2 | Setup phase 1 |
| 1282 | 1 | Validate position |
| 1370 | 1 | Scoring function |
| 1378 | 1 | Scoring function |
| 1482 | 1 | Display update |
| 1514 | 2 | Record access |
| 1642 | 1 | Unknown |
| 1706 | 1 | Start search |
| 1714 | 1 | Cleanup search |
| 1722 | 1 | Coordinate search |
| 1730 | 1 | Finalize |
| 1738 | 1 | Init add word |
| 2386 | 2 | Setup buffer 2 |
| 2410 | 1 | Setup buffer 1 |
| 2442 | 1 | Unknown |
| 2466 | 1 | Unknown |
| 2754 | 1 | Allocation |
| 2826 | 5 | GetHandleSize |
| 3074 | 1 | Display function |
| 3098 | 1 | Cleanup |
| 3130 | 1 | Cleanup |
| 3426 | 2 | Unknown |
| 3466 | 1 | Unknown |
| 3490 | 2 | strcpy |
| 3506 | 3 | strcmp |
| 3522 | 2 | strlen |
| 3538 | 1 | String function |
| 3562 | 1 | tolower |

## Architecture Notes

- 14 JT entries is the highest among these four modules, indicating central role
- 5 calls to GetHandleSize (JT[2826]) confirm heavy handle-based data management
- The 34-byte move structure is consistently accessed with the same block-copy pattern
- Three-component score calculation (base + bonus + extra) appears at multiple locations
- The module bridges word search (CODE 12), DAWG access (CODE 15), and UI display
- Global at A5-15514 (g_field_14) serves as the primary working buffer for rack/board state
- Record size of 6 bytes for the move list (handle_size / 6) suggests compact move encoding

## Confidence Assessment

- **Function boundaries**: HIGH - all 20 LINK instructions verified
- **Score calculation**: HIGH - three-component addition verified at byte level
- **Comparison thresholds**: HIGH - 200 and 500 as 32-bit immediates verified
- **Move structure**: HIGH - 34-byte copy pattern (8 longs + 1 word) consistent
- **Handle management**: HIGH - GetHandleSize/divide-by-6 pattern repeated
- **Rack structure**: HIGH - 8-byte stride, letter at offset 1, played flag at offset 2
- **Board analysis (0x0778)**: MEDIUM - complex function, exact cross-check scoring logic uncertain
