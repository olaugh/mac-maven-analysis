# CODE 18 Detailed Analysis - Move Description Formatting & Board Position Evaluation

## Overview

| Property | Value |
|----------|-------|
| Size | 4,460 bytes (code) + 4 byte header = 4,464 total |
| JT Offset | 816 |
| JT Entries | 4 |
| Functions | 15 (LINK A6) + additional leaf functions |
| Purpose | **Move description formatting, score display, board position evaluation** |
| Confidence | **HIGH** |

## Module Purpose

CODE 18 is the move description and position evaluation module. It handles:
1. Formatting move descriptions for display (word + coordinates + direction)
2. Handling special move types (pass, exchange, challenge, forfeit, resign, etc.)
3. Score/percentage formatting
4. Board position analysis for move display
5. Cross-check based position evaluation with bidirectional scoring

This is a substantial module at 4,460 bytes, containing both UI formatting functions and core position evaluation logic.

## Function Map

| Offset | Frame | Size | Regs Saved | Purpose |
|--------|-------|------|------------|---------|
| 0x0000 | -24 | 0x94 | A3/A4 | Format move to display string |
| 0x0094 | -164 | 0x510 | D3-D7 | Format score description (special moves) |
| 0x05A2 | 0 | 0x112 | D6/D7/A4 | Format score with percentage |
| 0x06B4 | 0 | 0x6C | -- | Format directional comparison |
| 0x0720 | 0 | 0x1DA | D4-D7/A3/A4 | Validate adjacent positions |
| 0x08FA | -546 | 0xA4 | D6 | Format position description (row/column) |
| 0x099E | 0 | 0x18 | -- | Check word validity wrapper |
| 0x09B6 | -256 | 0xDC | D7/D6/A3/A4/A2 | Score comparison with buffers |
| 0x0A92 | -534 | 0x14A | D4-D7/A3/A4 | Cross-check position analysis |
| 0x0BDC | 0 | 0x7C | D4-D7/A3/A4 | Process move candidates (callback) |
| 0x0C58 | 0 | 0x62 | D7/A4 | Score threshold categorization |
| 0x0CBA | 0 | 0x14 | -- | Push to score display (wrapper) |
| 0x0CCE | 0 | 0x10 | -- | Push to score buffer (wrapper) |
| 0x0CDE | -132 | 0xFC | A3/A4 | Handle record from move list |
| 0x0DDA | -6772 | 0x190 | D4-D7/A3/A4 | Main board position evaluator |

**Non-LINK functions (leaf):**

| Offset | Size | Purpose |
|--------|------|---------|
| 0x005E (approx) | -- | Entry at 0x0000 is LINK; various inline helpers |

## Function-by-Function Analysis

### Function 0x0000 - Format Move to Display String
**Hex verification:** `4E56 FFE8 48E7 0018` = LINK A6,#-24; MOVEM.L A3/A4,-(SP)

```
Parameters: 8(A6)=output buffer, 12(A6)=move data, 16(A6)=context
Returns: D0 = output buffer pointer
```

Checks move data at offset 32 for blank flag. If blank, calls JT[3506] (strcmp) to compare move data variants, then uses sprintf (JT[2066]) with either format string at A5-5678 or A5-5674.

If no blank: checks byte 0 of move data. If zero, copies "no play" string (A5-5668) via JT[3490] (strcpy). Otherwise, checks direction at offset 32 of context. For vertical: calls JT[2026] to get coordinates, sprintf formats with A5-5660. For horizontal: strcpy from A5-5648.

```c
char* format_move_to_string(char *output, MoveData *move, void *context) {
    if (move->blank_flag) {  /* offset 32 */
        if (compare(move, move, context, move) == 0)
            sprintf(output, g_fmt_str_1 /* A5-5678 */, ...);
        else
            sprintf(output, g_fmt_str_2 /* A5-5674 */, ...);
        return output;
    }
    if (move->word[0] == 0) {
        strcpy(output, "no play" /* A5-5668 */);
        return output;
    }
    if (((char*)context)[32]) {
        strcpy(output, g_horiz_str /* A5-5648 */);
    } else {
        short coords = get_coordinates(move);  /* JT[2026] */
        sprintf(output, g_vert_fmt /* A5-5660 */, coords);
    }
    return output;
}
```

### Function 0x0094 - Format Score Description (Special Moves)
**Hex verification:** `4E56 FF5C 48E7 1F00` = LINK A6,#-164; MOVEM.L D3-D7,-(SP)

The largest function in the module (0x510 bytes). This is a massive switch/case over move type codes:

```
Parameters: 8(A6)=score_type(word), 10(A6)=score_value, 12(A6)=outcome_flag
Returns: D0 = pointer to description string
```

**Move type dispatch table (verified from hex):**

| Hex Code | Decimal | Check Instruction | String Offset | Meaning |
|----------|---------|-------------------|---------------|---------|
| 0x4E20 | 20000 | `0C47 4E20` at 0x00B4 | A5-5636/-5592/-5554 | Game end (won/ahead/behind) |
| 0x8001 | -32767 | `0C47 8001` at 0x00E2 | A5-5516 | Pass |
| 0xFFFF | -1 | `0C47 FFFF` at 0x00F2 | A5-5510 | Forfeit |
| 0xFFFE | -2 | `0C47 FFFE` at 0x0102 | A5-5486 | Exchange tiles |
| 0xFFE0 | -32 | `0C47 FFE0` at 0x0112 | A5-5462 | Timeout |
| 0xFFDF | -33 | `0C47 FFDF` at 0x0122 | A5-5446 | Overtime |
| 0xFFFD | -3 | `0C47 FFFD` at 0x0132 | A5-5430/-5366 | Challenge (won/lost) |
| 0x07DA | 2010 | `0C47 07DA` at 0x0152 | A5-5338 | Resign |
| 0xFFFC | -4 | `0C47 FFFC` at 0x0162 | A5-5316 | End game |
| 0xFFFB-0xFFE1 | -5 to -31 | Range check at 0x0172 | A5-5280 | Letter exchange |

For letter exchange range: calculates letter index as (-5 - code), looks up letter in tile table (A5-26158 via `206D 99D2`), uses JT[3562] (tolower), and formats with direction indicator (A5-5260 "across" or A5-5256 "down").

For regular scores (none of the special codes), the code enters a complex word-parsing loop starting at 0x0206 that reads DAWG entries from g_dawg_base (A5-11960 via `206D D55A`), extracts letter/row/column data, tracks min/max bounds, and formats with coordinates.

```c
char* format_score_description(short score_type, short score_value, short outcome_flag) {
    char local_buf[164];
    if (score_type == 0) bounds_error();  /* JT[418] */
    setup_rect(local_buf);  /* JT[2394] */

    if (score_type == 0x4E20) {  /* Game end */
        if (outcome_flag) return "won";      /* A5-5636 */
        if (score_value > 0) return "ahead"; /* A5-5592 */
        return "behind";                      /* A5-5554 */
    }
    if (score_type == (short)0x8001) return "pass";      /* A5-5516 */
    if (score_type == (short)0xFFFF) return "forfeit";   /* A5-5510 */
    if (score_type == (short)0xFFFE) return "exchange";  /* A5-5486 */
    if (score_type == (short)0xFFE0) return "time";      /* A5-5462 */
    if (score_type == (short)0xFFDF) return "overtime";  /* A5-5446 */
    if (score_type == (short)0xFFFD) {
        return outcome_flag ? "challenge won" : "challenge lost";
    }
    if (score_type == 0x07DA) return "resign";  /* A5-5338 */
    if (score_type == (short)0xFFFC) return "end";  /* A5-5316 */

    /* Letter exchange range -5..-31 */
    if (score_type <= (short)0xFFFB && score_type >= (short)0xFFE1) {
        return format_letter_exchange(score_type, score_value);
    }

    /* Regular score: parse DAWG entries for word/position */
    return format_regular_move(score_type);
}
```

### Function 0x05A2 - Format Score with Percentage
**Hex verification:** `4E56 0000 48E7 0308` = LINK A6,#0; MOVEM.L D6/D7/A4,-(SP)

```
Parameters: 8(A6) = score (word)
Returns: D0 = formatted string pointer
```

Calculates percentage via DIVS/MULS pattern at 0x05B2: `81FC 0064` = DIVS #100,D0; `C1FC 0064` = MULS #100,D0. The remainder is used to determine percentage category.

Threshold checks produce descriptive strings at various A5 offsets. The function handles negative scores and has multiple return paths for different percentage ranges:
- < 2% and score > 1: returns A5-4936 ("low")
- 0-9: A5-4930
- 10-29: A5-4922
- 30-49: A5-4844
- 50-74: A5-4842
- 75+: A5-4806

Final formatting at 0x0694 uses sprintf (JT[2066]) with format strings at A5-4952 or A5-4954.

```c
char* format_score_with_percentage(short score) {
    short whole = (score / 100) * 100;
    short remainder = score - whole;
    if (remainder < 0 || remainder >= 100) bounds_error();

    if (remainder < 2 && score > 1) return g_low_str;  /* A5-4936 */

    short abs_score = (score < 0) ? -score : score;
    if (abs_score < 10)  return g_str_a;   /* A5-4930 */
    if (abs_score < 30)  return g_str_b;   /* A5-4922 */
    if (abs_score < 50)  return g_str_c;   /* A5-4844 */

    /* ... more thresholds ... */

    long pct = (long)remainder * 100;
    char *suffix = (pct == 1) ? g_singular : g_plural;
    sprintf(g_output, g_fmt, pct, suffix, ...);
    return g_output;
}
```

### Function 0x06B4 - Format Directional Comparison
**Hex verification:** `4E56 0000 4A6E 0008` = LINK A6,#0; TST.W 8(A6)

```
Parameters: 8(A6) = flag
Returns: D0 = string pointer
```

Short function that calls JT[1458] and JT[82] for setup, then uses a switch-like dispatch:
- If param < 0: calls JT[1458], then dispatches on JT[82] result via 3-way branch
- Returns one of A5-4804, A5-4806, or A5-4842

### Function 0x0720 - Validate Adjacent Positions
**Hex verification:** `4E56 0000 48E7 0F18` = LINK A6,#0; MOVEM.L D4-D7/A3/A4,-(SP)

```
Parameters: 8(A6)=position1(word), 10(A6)=position2(word)
Returns: D0 = 0 or 1 (validation result)
```

This is a critical function (0x1DA bytes) that validates adjacent board positions using the DAWG. It performs extensive checking through the DAWG structure at A5-11960 (`206D D55A`), checking letters at positions with `4A30 0806` (TST.B 6(A0,D0.L)) pattern.

The function:
1. Validates input positions are non-zero and within bounds (`BE6D D55E` = CMP.W A5-10914,D7)
2. Checks if DAWG entries at given positions have letters
3. Performs linked-list traversal through DAWG entries checking letter/row/column matches
4. Returns 1 if positions are validly adjacent, 0 otherwise

Contains nested loops at 0x080C and 0x0890 that walk DAWG entry chains comparing letter bytes at offsets 6 and 7 (row/column within 4-byte DAWG entries).

```c
short validate_adjacent(short pos1, short pos2) {
    if (pos1 == 0 || pos2 == 0) bounds_error();
    if (pos1 < 0 || pos1 >= g_dawg_count) bounds_error();

    long *dawg = g_dawg_base;  /* A5-11960 */

    /* Check if pos1 entry has letter data */
    if (dawg[pos1] & 0xFF == 0) {
        /* Follow next-pointer chain */
        short next = (short)(dawg[pos1] >> 16);
        next += g_dawg_offset;
        if (check_letter_match(next, g_tile_table) == 0) {
            short letter_val = dawg[pos1] & 0xFF;
            if (letter_val == -5 + g_dawg_base[pos1])
                return 1;
        }
    }
    /* ... extensive validation logic ... */
    return result;
}
```

### Function 0x08FA - Format Position Description
**Hex verification:** `4E56 FDDE 2F06` = LINK A6,#-546; MOVE.L D6,-(SP)

Large stack frame (-546 bytes) for position formatting buffers. Calls the percentage formatter at 0x05A2 (via BSR), then uses sprintf (JT[2066]) with multiple format strings at A5-4916 and A5-4870.

### Function 0x099E - Check Word Validity (Wrapper)
**Hex verification:** `4E56 0000 3F2E 0008` = LINK A6,#0; MOVE.W 8(A6),-(SP)

Tiny wrapper (0x18 bytes): pushes parameter, calls JT[2546], converts result to boolean via `57C0 4400 4880` (Scc/NEG/EXT pattern).

### Function 0x09B6 - Score Comparison with Buffers
**Hex verification:** `4E56 FF00 48E7 0318` = LINK A6,#-256; MOVEM.L D7/D6/A3/A4,-(SP)

Parameters from 8(A6) and 0x18(A6). Compares two score records by computing difference and checking against thresholds. Uses A5-8549 and A5-8570 as comparison buffer addresses. Calls JT[2066] (sprintf) for formatted output.

### Function 0x0A92 - Cross-Check Position Analysis
**Hex verification:** `4E56 FDEA 48E7 1F38` = LINK A6,#-534; MOVEM.L D4-D7/A3/A4,-(SP)

Large function performing bidirectional cross-check analysis. Parameters at 8(A6) and multiple additional params.

Inner loops iterate through letter positions (0x10 and 0x20 offsets from base), calling through function pointer at 0x28(A6) via `4E90` (JSR (A0)). Tracks match counts in D5, iterates with D6 as counter, uses D4 for address manipulation.

When no matches (D5==0): calls sprintf with format at A5-8576 and buffers at A5-8570/A5-8549.

Otherwise processes results through two branches based on D3 (flag from 0x30(A6)):
- If D3 positive: uses A5-8549 as primary, A5+offset buffers
- If D3 negative: uses A5-8570 as primary

Each branch calls the recursive position evaluator at 0x0BDC.

### Function 0x0BDC - Process Move Candidates (Callback)
**Hex verification:** `4E56 0000 48E7 1F38` = LINK A6,#0; MOVEM.L D4-D7/A3/A4,-(SP)

Initial value `3E3C 8001` = MOVEQ #-32767 (0x8001) into D7 - this is the "worst score" sentinel.

Iterates through candidate list at 0x000C(param): loop checks entries via function pointer call `4E90`, compares scores. If score beats D7, updates best-so-far. Uses A5-8549 and A5-8570 buffer offsets.

When D7 != 0x8001 (found a valid candidate), calls function at 0x0B90 (PC-relative) to store result.

### Function 0x0C58 - Score Threshold Categorization
**Hex verification:** `4E56 0000 48E7 0108` = LINK A6,#0; MOVEM.L D7/A4,-(SP)

```
Parameters: 8(A6)=unused, 10(A6)=score difference (word)
Returns: D0 = category string pointer, also calls display function
```

Threshold dispatch at verified hex offsets:
- `0C47 07D0` (2000): A5-4742
- `0C47 03E8` (1000): A5-4720
- `0C47 01F4` (500): A5-4700
- `0C47 00FA` (250): A5-4678

If score < 250, checks 8(A6) flag: returns A5-4654 or A5-4628.

If result pointer is non-NULL, calls display function at 0x0CBA.

### Function 0x0CBA - Push to Score Display
**Hex verification:** `4E56 0000 2F2E 0008 2F2D DEB0` = LINK; push 8(A6); push A5-8528; JSR JT[1962]

Simple wrapper: pushes parameter and A5-8528 (g_display_ptr), calls JT[1962].

### Function 0x0CCE - Push to Score Buffer
**Hex verification:** `4E56 0000 2F2E 0008 4EAD 077A` = LINK; push 8(A6); JSR JT[1914]

Simple wrapper: pushes parameter, calls JT[1914].

### Function 0x0CDE - Handle Record from Move List
**Hex verification:** `4E56 FF7C 48E7 0038` = LINK A6,#-132; MOVEM.L A3/A4/A5,-(SP)

Accesses move list data via handle chain: A5-10312 (`4A6D D76A` = TST.W A5-10390). Gets handle from 0x00CA(param), calls JT[2826] (GetHandleSize) and JT[74] (divide by 6) to get record count.

Performs CopyBits operations (A029 at 0x0D2E, 0x0D44) and EqualRect checks. Calls sprintf (JT[2066]) with buffers at A5-8549 and A5-8570, format at A5-4586.

Final section performs ScrollRect (A86B at 0x0DC2) and ValidRect (A947 at 0x0DC8) operations for display update.

### Function 0x0DDA - Main Board Position Evaluator
**Hex verification:** `4E56 E58C 48E7 1F38` = LINK A6,#-6772; MOVEM.L D4-D7/A3/A4,-(SP)

This is the most complex function with a massive 6,772-byte stack frame. The large frame accommodates multiple 1024-byte working buffers for cross-check computation.

Process:
1. Reads handle chain: 0x00CA offset -> deref -> deref -> copy 34 bytes (8 longs + 1 word) of move data
2. Reads second entry via `7006 C1ED D76A` = MULS.W A5-10390 pattern (multiply by record index)
3. Calls JT[1018] for setup, JT[754] for DAWG access
4. Calls JT[2530] to compute cross-check data into local buffers
5. Calls JT[426] (memset) with size 0x0400 (1024) to clear working buffers
6. Enters triple nested evaluation loop (three calls to the same evaluator function at different offsets)
7. Uses format strings at A5-4568, A5-4544, A5+2546 for three different analysis phases
8. Final sprintf (JT[2066]) combines results
9. Calls A873 (GlobalToLocal), A928 (InvalRect) for display
10. Calls JT[3130] and JT[3098] for cleanup

## Toolbox Traps

| Offset | Trap | Name | Context |
|--------|------|------|---------|
| 0x0D2E | A029 | _CopyBits | Copy display bits |
| 0x0D44 | A029 | _CopyBits | Copy display bits |
| 0x0D88 | A02A | _CopyMask | Copy with mask |
| 0x0D9E | A02A | _CopyMask | Copy with mask |
| 0x0DC2 | A86B | _ScrollRect | Scroll display area |
| 0x0DC8 | A947 | _ValidRect | Validate display rectangle |
| 0x1146 | A873 | _GlobalToLocal | Coordinate conversion |
| 0x1150 | A928 | _InvalRect | Invalidate for redraw |

## Key Global Variables

| Offset | Type | Purpose |
|--------|------|---------|
| A5-26158 | long | Tile table pointer |
| A5-11960 | long | DAWG base pointer |
| A5-10914 | short | DAWG entry count/limit |
| A5-10390 | short | Record index for move list |
| A5-8570 | char[] | Cross-check buffer 1 (A5-8549 label) |
| A5-8549 | char[] | Cross-check buffer 2 |
| A5-8528 | long | Display pointer |
| A5-5774 | char[96] | Output string buffer |
| A5-5678..-5160 | strings | Move description string table |
| A5-4952..-4628 | strings | Score/percentage string table |

## JT Call Summary

| JT Offset | Count | Purpose |
|-----------|-------|---------|
| 74 | 1 | Integer division |
| 82 | 1 | Unknown utility |
| 90 | 2 | Calculation helper |
| 418 | 4 | Bounds check / assertion |
| 426 | 2 | memset (clear buffers) |
| 754 | 1 | DAWG access |
| 1018 | 1 | Setup function |
| 1458 | 2 | Display setup |
| 1914 | 1 | Score buffer push |
| 1962 | 2 | Score display push |
| 2026 | 2 | Get coordinates |
| 2066 | 16 | sprintf (most-called) |
| 2362 | 1 | Unknown |
| 2394 | 1 | SetRect wrapper |
| 2530 | 2 | Cross-check computation |
| 2546 | 1 | Word validity check |
| 2826 | 1 | GetHandleSize |
| 3098 | 1 | Cleanup function |
| 3130 | 1 | Cleanup function |
| 3490 | 2 | strcpy |
| 3506 | 1 | strcmp |
| 3514 | 2 | String function |
| 3522 | 1 | strlen |
| 3562 | 2 | tolower |

## Architecture Notes

- The module's 4 JT entries (at offset 816) make 4 functions externally callable
- Heavy use of sprintf (JT[2066]) - 16 calls - confirms formatting role
- A5-5774 is a shared 96-byte output buffer used by most format functions
- The DAWG base at A5-11960 is accessed via `206D D55A` throughout
- CopyBits/CopyMask traps indicate this module directly updates the display
- The -6772 byte stack frame in function 0x0DDA is the largest in the codebase

## String Table Summary

The module contains an extensive string table referenced via A5-relative addressing, spanning approximately A5-5774 to A5-4628. This includes:
- Move type names: "pass", "forfeit", "exchange", "time", "overtime", "resign", "end"
- Game state: "won", "ahead", "behind", "challenge won", "challenge lost"
- Direction: "across", "down"
- Format strings for coordinates, scores, percentages
- Formatting templates: "no play", various sprintf format patterns

## Confidence Assessment

- **Function boundaries**: HIGH - all 15 LINK/UNLK pairs verified in hex
- **Special move codes**: HIGH - all CMPI.W immediate values verified
- **String table**: HIGH - A5-relative LEA instructions point to consistent string region
- **DAWG access pattern**: HIGH - `206D D55A` + `E788` (LSL.L #2) is standard DAWG indexing
- **Toolbox traps**: HIGH - trap codes verified against Inside Macintosh
- **Cross-check evaluator**: MEDIUM - complex nested loops, exact buffer layout uncertain
