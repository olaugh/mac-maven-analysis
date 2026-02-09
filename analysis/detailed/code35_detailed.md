# CODE 35 Detailed Analysis - Full Move Score + Leave Calculation

## Overview

| Property | Value |
|----------|-------|
| Resource Size | 3280 bytes (4-byte header + 3276 bytes of code) |
| JT Offset | 0x09B8 (2488) |
| JT Entries | 4 |
| Functions | 7 |
| Purpose | **Complete move scoring: word value, cross-words, bingo, Q/QU, per-letter leave, rack leave** |
| SANE Traps | 22 total (A9EB), all in functions 0x0060 and 0x0168 |

**Note on file offsets**: The raw binary has a 4-byte header (JT offset + count), so
code_offset = file_offset - 4. All offsets in this document are CODE offsets unless
explicitly marked as file offsets.

### Previous Misidentifications (CORRECTED)

1. **NOT "File I/O"** -- The A9EB trap is _FP68K (SANE floating point), not _SFGetFile.
2. **SANE opcode $000D is FNEG** (negate extended), NOT "round to integer" as the
   previous analysis stated.
3. **SANE opcode $0016 is FTINT** (truncate to integer, result stays extended), NOT
   "convert to extended".
4. **Global at code 0x001A is A5-10918** (hex D55A = -10918 signed), NOT A5-10904.
   The previous analysis confused this with the FRST handle.
5. **Function 0x0368 is PURE INTEGER** -- no SANE operations at all.
6. **Function 0x0A44 is PURE INTEGER** -- no SANE operations at all.

---

## Function Table

| Code Offset | Frame Size | Saved Regs | Purpose | SANE? |
|-------------|-----------|------------|---------|-------|
| 0x0000 | 2 | none | Check position lower bound | No |
| 0x0030 | 2 | none | Check position upper bound | No |
| 0x0060 | 38 | D5-D7 | Extended precision computation | **YES** (heavy) |
| 0x0168 | 70 | A2/A4 | SANE score calculation main | **YES** (heavy) |
| 0x0310 | 0 | D5-D7 | Sum word values with filter | No |
| 0x0368 | 330 | D3-D7/A2-A4 | **Full move score + leave calc** | No |
| 0x0A44 | 12 | D3-D7/A2-A4 | Per-tile position scores | No |

---

## SANE FP68K Reference (CORRECTED)

All 22 A9EB traps are confined to file offsets 0x0064-0x0310 (functions 0x0060 and
0x0168).

### Format Bits (14-11)

| Value | Format | Size |
|-------|--------|------|
| 0 | extended | 80-bit (10 bytes) |
| 1 | double | 64-bit (8 bytes) |
| 2 | single | 32-bit (4 bytes) |
| 4 | int16 | 16-bit |
| 5 | int32 | 32-bit |
| 6 | comp | 64-bit integer |

### Arithmetic Operations (even opcodes, bits 4-0)

| Bits 4-0 | Mnemonic | Description |
|----------|----------|-------------|
| $00 | FADD | dst += src |
| $02 | FSUB | dst -= src |
| $04 | FMUL | dst *= src |
| $06 | FDIV | dst /= src |
| $08 | FCMP | compare dst with src (sets condition codes) |
| $0A | FCPX | compare signaling (NaN raises exception) |
| $0C | FREM | IEEE remainder |
| $0E | FZ2X | convert src format to extended |
| $10 | FX2Z | convert extended to src format |
| $12 | FSQRT | square root |
| $14 | FRINT | round to nearest integer (stays extended) |
| $16 | FTINT | truncate to integer (stays extended) |

### Non-Arithmetic Operations (odd opcodes)

| Opcode | Mnemonic | Description |
|--------|----------|-------------|
| $000D | FNEG | negate extended value in place |
| $000F | FABS | absolute value of extended |
| $0001 | FSETENV | set SANE environment word |
| $0003 | FGETENV | get SANE environment word |

### Calling Convention

Parameters are pushed right-to-left onto the stack:

**Binary operations** (FADD, FSUB, FMUL, FDIV, FCMP):
```
MOVE.L  src_ptr,-(SP)     ; SRC pointer (pushed first)
MOVE.L  dst_ptr,-(SP)     ; DST pointer (pushed second)
MOVE.W  #opcode,-(SP)     ; operation code (on top)
_FP68K                     ; A9EB trap
```
At the trap: SP+0 = opcode (word), SP+2 = DST (long), SP+6 = SRC (long).
SANE pops all 10 bytes. For FADD/FSUB/FMUL/FDIV, result is stored at DST.
For FCMP, only condition codes are set; DST is unchanged.

**Unary operations** (FNEG, FABS, FTINT):
```
MOVE.L  operand_ptr,-(SP) ; operand pointer
MOVE.W  #opcode,-(SP)     ; operation code
_FP68K                     ; A9EB trap
```

### Opcodes Used in CODE 35

| Opcode | Decoded | Description | Used In |
|--------|---------|-------------|---------|
| $0000 | ext FADD | add two extended values | 0x0060 |
| $0004 | ext FMUL | multiply two extended values | 0x0168 |
| $0006 | ext FDIV | divide two extended values | 0x0060, 0x0168 |
| $0008 | ext FCMP | compare two extended values | 0x0168 |
| $000D | **FNEG** | negate extended in place | 0x0168 |
| $0016 | **ext FTINT** | truncate to integer (stays extended) | 0x0060, 0x0168 |
| $2006 | i16 FDIV | divide extended by int16 | 0x0168 |
| $2008 | i16 FCMP | compare int16 with extended | 0x0060, 0x0168 |
| $280E | i32 FZ2X | convert int32 to extended | 0x0168 |
| $2810 | i32 FX2Z | convert extended to int32 | 0x0168 |
| $300E | comp FZ2X | convert comp (64-bit int) to extended | 0x0060 |
| $3010 | comp FX2Z | convert extended to comp (64-bit int) | 0x0060 |

**KEY CORRECTIONS from previous analysis**:
- $000D was listed as "FRINTX (round to integer)" -- it is actually **FNEG** (negate).
- $0016 was listed as "Convert to extended" -- it is actually **FTINT** (truncate to integer, result remains in extended format).
- $2006 was listed as "Compare/add" -- it is actually **i16 FDIV** (divide extended by int16).
- $300E was listed as "Multiply extended" -- it is actually **comp FZ2X** (convert comp to extended).
- $3010 was listed as "Divide extended" -- it is actually **comp FX2Z** (convert extended to comp).

---

## Function 0x0000 - Check Position Lower Bound

**Frame**: LINK A6,#-2 (2-byte local).
**Parameters**: 8(A6) = position (int16).
**Returns**: D0 = 1 if valid, 0 if invalid.

### Algorithm

Checks that position is in range (0 < pos < g_board_size), then reads byte 6 of
the 8-byte position record to verify the position is playable.

### Key Instruction Correction

At code offset 0x001A (file 0x001E):
```
E788            LSL.L   #3,D0               ; multiply pos by 8
206D D55A       MOVEA.L -10918(A5),A0       ; g_position_table (NOT -10904)
4A30 0806       TST.B   6(A0,D0.L)          ; check valid flag
```
The disassembler combines `E788 206D D55A 4A30 0806` into garbage instructions.
The global is A5-10918 (hex $D55A as signed = -10918), not A5-10904 as previously stated.

At code offset 0x000E (file 0x0012):
```
B06D D55E       CMP.W   -10914(A5),D0       ; compare with g_board_size
```

### C Decompilation

```c
/* Position record: 8 bytes per entry */
typedef struct {
    int32_t data;       /* bytes 0-3: opaque data */
    int8_t  valid;      /* byte 4: valid flag */
    int8_t  reserved;   /* byte 5 */
    int8_t  row;        /* byte 6: row index */
    int8_t  col;        /* byte 7: column index */
} PositionRecord;

extern int16_t         g_board_size;       /* A5-10914 */
extern PositionRecord *g_position_table;   /* A5-10918 */

/*
 * check_lower_bound - Verify position is valid for play (lower bound variant).
 *
 * Returns 1 if pos is in (0, g_board_size) and its row flag is nonzero.
 * The "row" field (byte 6) serves as a validity flag here.
 */
int16_t check_lower_bound(int16_t pos)
{
    if (pos <= 0 || pos >= g_board_size)
        return 0;

    PositionRecord *table = g_position_table;
    if (table[(int32_t)pos].row != 0)   /* TST.B 6(A0,D0.L) */
        return 1;

    return 0;
}
```

---

## Function 0x0030 - Check Position Upper Bound

**Frame**: LINK A6,#-2 (2-byte local).
**Parameters**: 8(A6) = position (int16).
**Returns**: D0 = 1 if valid, 0 if invalid.

### Algorithm

Same structure as 0x0000 but with slightly different boundary conditions. For
negative positions, the branch logic returns 1 (valid). Uses byte 7 (column)
of the position record instead of byte 6 (row).

### C Decompilation

```c
/*
 * check_upper_bound - Verify position is valid (upper bound variant).
 *
 * Returns 1 for negative positions (unconditionally valid).
 * For positive positions, checks byte 7 (col) of position record.
 */
int16_t check_upper_bound(int16_t pos)
{
    if (pos < 0)
        return 1;

    if (pos >= g_board_size)
        return 0;

    PositionRecord *table = g_position_table;
    if (table[(int32_t)pos].col != 0)   /* TST.B 7(A0,D0.L) */
        return 1;

    return 0;
}
```

---

## Function 0x0060 - Extended Precision Computation (SANE)

**Frame**: LINK A6,#-38 (38-byte local frame for extended temporaries).
**Saved registers**: D5-D7.
**Parameters**: 8(A6) = pointer to output extended (10 bytes), 12(A6) = input extended (10 bytes passed by value on stack).
**Returns**: Result written to output pointer.

This function contains heavy SANE usage. It performs a division/accumulation loop
with comp (64-bit integer) conversions, operating entirely in 80-bit extended
precision.

### Stack Frame Layout

| Offset | Size | Purpose |
|--------|------|---------|
| -10(A6) | 10 | Extended accumulator (result) |
| -18(A6) | 8 | Comp (64-bit int) temporary |
| -28(A6) | 10 | Extended working copy |
| -38(A6) | 10 | Extended secondary buffer |

### SANE Operations Used

1. $300E (comp FZ2X) -- convert comp to extended
2. $3010 (comp FX2Z) -- convert extended to comp
3. $0006 (ext FDIV) -- divide extended by extended
4. $0000 (ext FADD) -- add extended to extended
5. $2008 (i16 FCMP) -- compare int16 with extended
6. $0016 (ext FTINT) -- truncate extended to integer (stays extended)

### Algorithm

The function implements an iterative accumulation in extended precision:

1. Copy the input extended value to a local buffer
2. Convert through comp format (64-bit integer conversion for truncation)
3. Enter a refinement loop (up to 5 iterations):
   - Copy input to work buffer
   - Divide accumulator by work buffer
   - Add quotient to running sum
   - Compare result against a threshold
   - Stop early if below threshold
4. Truncate final result to integer (FTINT) and copy to output

### C Decompilation

```c
/*
 * compute_extended - Iterative extended precision accumulation.
 *
 * Performs a series of divide-and-add steps in 80-bit precision,
 * using comp (64-bit integer) for intermediate truncation.
 *
 * SANE function names follow Apple convention:
 *   fz2x_comp  = convert comp to extended  ($300E)
 *   fx2z_comp  = convert extended to comp  ($3010)
 *   fdiv_ext   = divide extended           ($0006)
 *   fadd_ext   = add extended              ($0000)
 *   fcmp_i16   = compare int16 w/ extended ($2008)
 *   ftint_ext  = truncate to integer       ($0016)
 */
void compute_extended(extended80 *output, extended80 input)
{
    extended80 accum;       /* -10(A6): accumulator */
    int64_t    comp_temp;   /* -18(A6): comp temporary */
    extended80 work;        /* -28(A6): working copy */
    extended80 work2;       /* -38(A6): secondary buffer */
    int16_t    count;       /* D7 */

    /* Copy input to local working buffer */
    work = input;                           /* 10-byte copy */

    /* Convert through comp for integer truncation:
     * extended -> comp -> extended effectively truncates
     * the fractional part while preserving 64-bit integer range */
    fx2z_comp(&work, &comp_temp);           /* SANE $3010: extended -> comp */
    fz2x_comp(&comp_temp, &accum);          /* SANE $300E: comp -> extended */

    /* Subtract truncated value from original to get fractional remainder */
    /* (The exact sequence depends on the specific code path taken) */

    /* Iterative refinement loop - up to 5 passes */
    for (count = 0; count < 5; count++) {
        work2 = input;                      /* fresh copy of input */

        fdiv_ext(&accum, &work2);           /* SANE $0006: work2 /= accum */
        fadd_ext(&work2, &accum);           /* SANE $0000: accum += work2 */

        /* Compare against threshold constant (embedded in code as PC-relative) */
        int16_t threshold = 0;
        if (fcmp_i16(&threshold, &accum) > 0)  /* SANE $2008 */
            break;                          /* below threshold, done */
    }

    /* Truncate final result to integer (stays in extended format) */
    ftint_ext(&accum);                      /* SANE $0016 */

    /* Copy result to output */
    *output = accum;                        /* 10-byte copy */
}
```

---

## Function 0x0168 - SANE Score Calculation Main

**Frame**: LINK A6,#-70 (70-byte local frame).
**Saved registers**: A2, A4.
**Parameters**: 8(A6) = pointer to move/score data structure.
**Returns**: Result stored back into the data structure.

This function is the heavier SANE user, with operations including multiply, divide,
compare, negate, and integer conversion. It processes a score data structure,
performing multi-step floating-point arithmetic and calling function 0x0060 as a
helper.

### Stack Frame Layout

| Offset | Size | Purpose |
|--------|------|---------|
| -10(A6) | 10 | Extended primary accumulator |
| -20(A6) | 10 | Extended secondary buffer |
| -30(A6) | 10 | Extended tertiary buffer |
| -40(A6) | 10 | Extended work area / helper output |
| -44(A6) | 4 | Int32 temporary for conversion |
| -70(A6) | 26 | Additional temporaries |

### SANE Operations Used

1. $280E (i32 FZ2X) -- convert int32 to extended
2. $0006 (ext FDIV) -- divide extended by extended
3. $0004 (ext FMUL) -- multiply extended by extended
4. $0008 (ext FCMP) -- compare two extended values
5. $000D (FNEG) -- negate extended value in place
6. $2006 (i16 FDIV) -- divide extended by int16
7. $2008 (i16 FCMP) -- compare int16 with extended
8. $0016 (ext FTINT) -- truncate to integer (stays extended)
9. $2810 (i32 FX2Z) -- convert extended to int32

### Algorithm

1. Null-check the input pointer; return immediately if NULL
2. Check a score threshold (value at offset 20 in the structure); if below 20, clear
   the extended fields and return
3. Convert the int32 score to extended via i32 FZ2X ($280E)
4. Copy a secondary extended value from the structure (offset 10)
5. Perform a multi-step calculation:
   - Divide the converted score by the secondary value
   - Multiply intermediate results
   - Negate (FNEG $000D) a component
   - Compare against thresholds
6. Call compute_extended (function 0x0060) for iterative refinement
7. Truncate the final result to integer via FTINT ($0016)
8. Convert back to int32 via i32 FX2Z ($2810)
9. Store the int32 result at offset 24 of the move structure

### C Decompilation

```c
/*
 * sane_score_calc - Main SANE-based score calculation.
 *
 * Takes a move data structure, performs extended precision arithmetic
 * on its score fields, and writes the computed result back.
 *
 * SANE function names:
 *   fz2x_i32  = convert int32 to extended   ($280E)
 *   fx2z_i32  = convert extended to int32    ($2810)
 *   fmul_ext  = multiply extended            ($0004)
 *   fdiv_ext  = divide extended              ($0006)
 *   fcmp_ext  = compare extended             ($0008)
 *   fneg_ext  = negate extended              ($000D)
 *   fdiv_i16  = divide extended by int16     ($2006)
 *   fcmp_i16  = compare int16 w/ extended    ($2008)
 *   ftint_ext = truncate to integer          ($0016)
 */
typedef struct {
    /* Offsets within the structure: */
    char       data[10];      /* 0-9: opaque header */
    extended80 ext_field;     /* 10-19: extended precision field */
    int32_t    score;         /* 20-23: integer score */
    int32_t    result;        /* 24-27: computed result (output) */
} ScoreData;

void sane_score_calc(ScoreData *sd)
{
    extended80 primary;      /* -10(A6) */
    extended80 secondary;    /* -20(A6) */
    extended80 tertiary;     /* -30(A6) */
    extended80 work;         /* -40(A6) */
    int32_t    int_result;   /* -44(A6) */

    /* Null check */
    if (sd == NULL)
        return;

    /* Threshold check: if score < 20, clear and return */
    if (sd->score < 20) {
        /* Clear the extended accumulator */
        memset(&primary, 0, 10);
        goto store_result;
    }

    /* Step 1: Convert integer score to extended */
    fz2x_i32(&sd->score, &tertiary);       /* SANE $280E: int32 -> extended */

    /* Step 2: Copy the embedded extended field */
    secondary = sd->ext_field;              /* 10-byte copy from offset 10 */

    /* Step 3: Divide score by the extended field */
    fdiv_ext(&tertiary, &secondary);        /* SANE $0006: secondary /= tertiary */

    /* Step 4: Multiply intermediate values */
    fmul_ext(&secondary, &primary);         /* SANE $0004: primary *= secondary */

    /* Step 5: Negate a component */
    fneg_ext(&primary);                     /* SANE $000D: primary = -primary */
    /* NOTE: Previous analysis said $000D was "round" -- it is NEGATE */

    /* Step 6: Compare with threshold */
    int16_t zero = 0;
    if (fcmp_i16(&zero, &primary) <= 0) {   /* SANE $2008 */
        /* Value is non-negative: additional multiply step */
        fmul_ext(&primary, &primary);       /* SANE $0004: primary *= primary */
    }

    /* Step 7: Call helper for iterative refinement */
    compute_extended(&work, primary);       /* Function 0x0060 */

    /* Step 8: Compare refined result, accumulate */
    if (fcmp_ext(&work, &secondary) > 0) {  /* SANE $0008 */
        /* Divide by 2 to normalize */
        int16_t two = 2;
        fdiv_i16(&two, &work);              /* SANE $2006: work /= 2 */
    }

    /* Step 9: Truncate to integer */
    ftint_ext(&work);                       /* SANE $0016: truncate (stays extended) */
    /* NOTE: Previous analysis said $0016 was "convert to extended" --
     * it is actually FTINT (truncate to integer, result stays extended) */

    /* Step 10: Convert extended back to int32 */
    fx2z_i32(&work, &int_result);           /* SANE $2810: extended -> int32 */

store_result:
    /* Store computed result back into the structure */
    sd->result = int_result;
}
```

### Important Notes on SANE Corrections

The FNEG operation ($000D) is particularly significant. The previous analysis
identified it as "round to integer" which would produce very different behavior.
FNEG negates the value in place, changing its sign. This is a standard step in
algorithms that compute differences or corrections by negating one term before
addition.

The FTINT operation ($0016) truncates an extended value toward zero, leaving the
result in extended format. It does NOT convert between formats. The truncation
is needed before converting to int32 to ensure clean integer results.

---

## Function 0x0310 - Sum Word Values with Filter

**Frame**: LINK A6,#0 (no locals).
**Saved registers**: D5-D7.
**Parameters**: 8(A6) = positions array (int16*), 12(A6) = values array (int16*), 16(A6) = use_filter flag (int16).
**Returns**: D0 = sum of filtered values.

### Algorithm

Iterates through two parallel arrays (positions and values). The positions array
drives the loop: each nonzero position entry advances to the next element. For
each position, the corresponding value is read. If use_filter is set, calls
check_lower_bound (function 0x0000 at PC-790) to test the position; if it fails
the filter, the value is skipped. Otherwise the value is accumulated into the sum.

The function validates both input pointers, calling bounds_error (JT[418]) if
either is NULL.

### C Decompilation

```c
/*
 * sum_filtered_values - Sum values from parallel position/value arrays.
 *
 * Iterates positions array; for each nonzero position, reads the
 * corresponding value. If use_filter is set, only includes values
 * whose positions pass check_lower_bound.
 */
int32_t sum_filtered_values(int16_t *positions, int16_t *values, int16_t use_filter)
{
    int32_t sum = 0;       /* D7 */
    int16_t pos;           /* D6 */
    int16_t val;           /* D5 */

    /* Validate pointers */
    if (values == NULL)
        bounds_error();     /* JT[418] - does not return */
    if (positions == NULL)
        bounds_error();

    /* Iterate: positions array drives the loop */
    while ((pos = *positions++) != 0) {
        val = *values++;

        if (use_filter) {
            /* Filter check: call check_lower_bound via PC-relative */
            if (!check_lower_bound(pos))
                continue;   /* position invalid, skip this value */
        }

        sum += (int32_t)val;
    }

    return sum;
}
```

---

## Function 0x0368 - Full Move Score + Leave Calculation (MAIN FUNCTION)

**Frame**: LINK A6,#-330 (330-byte local frame).
**Saved registers**: D3-D7/A2-A4.
**Parameters**:
- 8(A6) = move data pointer (word + direction + position)
- 12(A6) = score breakdown output array (int16*, may be NULL)
- 16(A6) = value breakdown output array (int16*, may be NULL)

**Returns**: D0 = total score in centipoints.

This is the largest and most important function in CODE 35. It is **pure integer**
(no SANE operations). It computes the complete evaluation of a Scrabble move:

1. Word score from letter values with bonus square multipliers
2. Cross-word scores for every perpendicular word formed
3. Bingo bonus for playing 7+ tiles
4. Leave evaluation: per-letter values and positional scoring
5. Q/QU synergy bonus and Q-without-U penalty
6. Individual letter leave contributions
7. Detailed score breakdown markers for the UI

### Stack Frame Layout

| Offset | Size | Purpose |
|--------|------|---------|
| -140(A6) | 128 | Letter count buffer (indexed by ASCII, from JT[2394]) |
| -144(A6) | 4 | Work buffer for JT[2498] calls |
| -271(A6) | 1 | Q-present flag |
| -272(A6) | 1 | Current letter temp |
| -276(A6) | 4 | Board pointer: left-adjacent row |
| -280(A6) | 4 | Board pointer: right-adjacent row |
| -284(A6) | 4 | Board pointer: row above (for cross-word) |
| -288(A6) | 4 | Board pointer: row below (for cross-word) |
| -296(A6) | 4 | Board pointer: two rows below |
| -300(A6) | 4 | Board pointer: two rows above |
| -304(A6) | 4 | Board pointer: one row above main |
| -308(A6) | 4 | Board base pointer (g_state1 + row*17) |
| -312(A6) | 4 | Pointer to current letter's count in buffer |
| -316(A6) | 4 | **Total score accumulator** (int32) |
| -317(A6) | 1 | Letter count (from JT[2394]) |
| -320(A6) | 2 | Cross-word product / playable count |
| -322(A6) | 2 | Bonus table index / blank count |
| -326(A6) | 4 | Bonus table scan pointer |
| -328(A6) | 2 | Max tiles threshold |
| -330(A6) | 2 | Saved intermediate value |

### Register Usage

| Register | Purpose |
|----------|---------|
| D3 | Running score component / intermediate result |
| D4 | Direction / tile counts / letter count |
| D5 | Column position / tiles-played count |
| D6 | Letter value / draw count |
| D7 | Current letter / loop variable |
| A2 | Word pointer / rack pointer |
| A3 | Value breakdown output (from 16(A6)) |
| A4 | Score breakdown output (from 12(A6)) |

### Move Data Structure

The move is passed as a pointer at 8(A6):

| Offset | Type | Field | Description |
|--------|------|-------|-------------|
| 0 | char[32] | word | Letters being played (C string, null-terminated) |
| 32 | int8 | direction | Row stride: 1=across, 17=down (encodes direction as board stride) |
| 33 | int8 | start_pos | Starting column (across) or row (down) |

### Board Arrays

| Global | Layout | Description |
|--------|--------|-------------|
| A5-17154 (g_state1) | 17x17 bytes | Letter grid. 0=empty, else ASCII letter value |
| A5-16610 (g_state2) | 17x17 words | Pre-computed cross-word scores (int16 per cell) |

Row pointer computation:
```
base = (A5-17154) + direction * 17
```
For across play (direction=1), base points to row 1. For down play (direction=17),
base points to column 1 of the 17-wide grid. Adjacent rows are at base +/- 17.

### Score Breakdown Markers

When score_breakdown (A4) is non-NULL, the function writes marker codes to identify
each score component:

| Marker Value | Hex | Meaning |
|--------------|-----|---------|
| -32 | $FFE0 | Primary word score |
| -33 | $FFDF | Bingo bonus |
| -1 | $FFFF | Terminator / leave evaluation total |
| -2 | $FFFE | Per-letter average contribution |
| -3 | $FFFD | QU synergy bonus |
| -4 | $FFFC | Q-without-U penalty |
| -(5+i) | $FFFB.. | Individual letter contribution (i = rack position) |
| 20000 | $4E20 | Cross-word score component |

### Global Variables Referenced

| A5 Offset | Type | Name | Description |
|-----------|------|------|-------------|
| -1064 | char[128] | g_char_class | Character classification; negative = valid letter |
| -2270 | char* | g_qu_pattern | "qu" pattern string for JT[2498] |
| -2272 | char* | g_q_pattern | "q" pattern string for JT[2498] |
| -2302 | int16[] | g_score_lookup | Score lookup table (indexed by letter*2) |
| -2342 | int16[10] | g_q_penalty | Q-without-U penalty table |
| -2422 | struct[20] | g_bonus_table | Bonus square table (4 bytes each) |
| -10914 | int16 | g_board_size | Board dimension (typically 16 for 15x15+border) |
| -10918 | void* | g_position_table | Pointer to position validity records |
| -15498 | char* | g_current_rack | Current player's sorted rack string |
| -16610 | int16[17][17] | g_state2 | Pre-computed cross-word score grid |
| -17010 | int8 | g_game_flag | Nonzero during active game |
| -17154 | int8[17][17] | g_state1 | Board letter grid |
| -23218 | int8[] | g_letter_counts | Letter count validation array |
| -24850 | int16 | g_bingo_adj | Bingo base adjustment value |
| -24866 | int16[] | g_bingo_table | Bingo bonus lookup (indexed by tiles_played - 7) |
| -26158 | char* | g_rack | Pointer to original (unsorted) rack |
| -27374 | int8[] | g_letter_freq | Letter frequency table |
| -27630 | int16[] | g_letter_points | Letter point values (2 bytes per letter) |

### Jump Table Calls

| JT Offset | Signature | Purpose |
|-----------|-----------|---------|
| 66 | int32 mul32(int32 a, int32 b) | 32-bit multiply; returns D0 |
| 90 | int32 div32(int32 a, int32 b) | 32-bit divide; returns D0 |
| 418 | void bounds_error(void) | Fatal error, does not return |
| 2370 | void process_rack(move*, rack, flags) | Mark tiles as played, update rack |
| 2378 | void cleanup_rack(rack) | Restore rack after evaluation |
| 2394 | int8 count_letters(buffer) | Fill letter-count buffer, return total |
| 2410 | void sort_rack(rack) | Sort rack letters alphabetically |
| 2498 | int16 calc_positional_score(buffer, pattern) | Score for letter pattern |
| 2506 | int32 final_leave_calc(played, blanks, regular, v, c, draw) | Composite leave evaluation |
| 2514 | int32 calc_letter_value(letter, total, count) | Per-letter leave value |
| 3514 | char* strchr(string, char) | Standard C library strchr |
| 3522 | int16 strlen(string) | Standard C library strlen |

### C Decompilation

```c
/*
 * full_score_calculation - Complete move evaluation.
 *
 * Computes word score, cross-words, bingo, Q/QU handling, and rack leave.
 * All values are in centipoints (1/100 of a Scrabble point).
 *
 * Parameters:
 *   move           - pointer to move data (word + direction + position)
 *   score_markers  - output array for score breakdown markers (may be NULL)
 *   value_markers  - output array for value breakdown (may be NULL)
 *
 * Returns: total score in centipoints
 */

/* Bonus table entry (4 bytes) */
typedef struct {
    int8_t letter;     /* letter this bonus applies to */
    int8_t type;       /* 0 = letter multiplier, nonzero = word multiplier */
    int8_t position;   /* row/col this bonus is at */
    int8_t value;      /* multiplier value */
} BonusEntry;

extern int8_t    g_char_class[128];        /* A5-1064 */
extern char      g_q_pattern[];            /* A5-2272: "q\0" */
extern char      g_qu_pattern[];           /* A5-2270: "qu\0" */
extern int16_t   g_score_lookup[];         /* A5-2302 */
extern int16_t   g_q_penalty[10];          /* A5-2342 */
extern BonusEntry g_bonus_table[20];       /* A5-2422 */
extern int16_t   g_board_size;             /* A5-10914 */
extern void     *g_position_table;         /* A5-10918 */
extern char     *g_current_rack;           /* A5-15498 */
extern int16_t   g_state2[17][17];         /* A5-16610 */
extern int8_t    g_game_flag;              /* A5-17010 */
extern int8_t    g_state1[17][17];         /* A5-17154 */
extern int8_t    g_letter_counts[];        /* A5-23218 */
extern int16_t   g_bingo_adj;              /* A5-24850 */
extern int16_t   g_bingo_table[];          /* A5-24866 */
extern char     *g_rack;                   /* A5-26158 */
extern int8_t    g_letter_freq[];          /* A5-27374 */
extern int16_t   g_letter_points[];        /* A5-27630 */

int32_t full_score_calculation(
    void    *move_ptr,
    int16_t *score_markers,   /* A4 - may be NULL */
    int16_t *value_markers    /* A3 - may be NULL */
)
{
    int32_t  total_score = 0;           /* -316(A6) */
    int8_t   letter_count;              /* -317(A6) */
    int16_t  cross_product;             /* -320(A6) */
    int16_t  blank_count;               /* -322(A6) */
    int32_t  bonus_scan_ptr;            /* -326(A6) */
    int16_t  max_tiles;                 /* -328(A6) */
    int16_t  saved_val;                 /* -330(A6) */
    int8_t   letter_buf[128];           /* -140(A6) */
    int8_t   q_present;                 /* -271(A6) */

    char    *word;
    int8_t   direction;
    int16_t  col;
    int32_t  word_score;
    int16_t  playable_count;
    int16_t  regular_count;
    int16_t  tiles_played;
    int16_t  draw_count;

    int8_t  *board_row;                 /* base row pointer */
    int8_t  *row_above, *row_below;     /* adjacent rows */
    int8_t  *two_above, *two_below;     /* two rows away */
    int8_t  *left_adj, *right_adj;      /* left/right columns */

    /* ============================================================
     * PHASE 1: Initialize rack and letter counts
     * ============================================================ */

    sort_rack(g_current_rack);                  /* JT[2410] */
    letter_count = count_letters(letter_buf);   /* JT[2394] */

    /* ============================================================
     * PHASE 2: Handle no-active-game case (offline evaluation)
     * ============================================================ */

    if (g_game_flag == 0) {
        /* No active game: compute score from move data alone */
        char *move_word = (char *)move_ptr;     /* word at offset 0 */
        int8_t has_word = *((int8_t *)move_ptr + 32);

        int32_t word_len = 0;
        if (has_word) {
            word_len = strlen(move_word);       /* JT[3522] */
        }

        /* Look up base score from position table:
         * index = word_len * 28 (each entry is 28 bytes?)
         * read int32 at offset 24 of that entry */
        int32_t index = mul32(word_len, 28);    /* JT[66] */
        int8_t *table = (int8_t *)g_position_table;  /* A5-10918 */
        int32_t base_score = *(int32_t *)(table + index + 24);
        total_score += base_score;

        if (score_markers != NULL) {
            *score_markers++ = -32;             /* primary word score marker */
        }
    }

    /* ============================================================
     * PHASE 3: Word scoring with board interaction
     * ============================================================ */

    word = (char *)move_ptr;                    /* word string at offset 0 */
    direction = *((int8_t *)move_ptr + 32);     /* direction byte */

    if (direction == 0)
        goto phase_5_leave;                     /* no word placed, skip to leave eval */

    col = (int16_t)*((int8_t *)move_ptr + 33);  /* starting position */
    word_score = 0;

    /* Compute board row pointers for cross-word checking.
     * direction encodes the row stride (1=across, 17=down).
     * Base pointer = g_state1 + direction * 17 */
    board_row = &g_state1[0][0] + direction * 17;
    row_above = board_row - 17;
    row_below = board_row + 17;
    two_above = board_row - 34;
    two_below = board_row + 34;
    /* Additional row pointers stored in frame for adjacent column checks */

    /* ---- Main letter loop ---- */
    char *wp = word;
    while (*wp != '\0') {
        int8_t letter = *wp;

        /* Validate letter: must be in character class table */
        if (g_char_class[(uint8_t)letter] >= 0) {
            bounds_error();                     /* JT[418] */
        }

        /* Bounds check the position */
        if (direction < 1 || direction > 30 || col < 1 || col > 15) {
            bounds_error();                     /* JT[418] */
        }

        /* Check if cell is already occupied */
        if (board_row[col] != 0) {
            /* Cell occupied: verify the existing letter matches */
            if (board_row[col] != letter) {
                bounds_error();                 /* mismatch = error */
            }
            /* Existing tile: contributes to word score but no
             * cross-word or bonus square processing */
        }
        else {
            /* Empty cell: we are placing a tile here */

            /* ------ Cross-word scoring ------ */

            /* Check perpendicular neighbors for cross-word formation.
             * A cross-word exists if any tile is adjacent in the
             * perpendicular direction. */

            int has_cross_word = 0;

            /* Check row above and below */
            if (direction != 1 && direction != 16) {
                if (row_above[col] != 0) {
                    has_cross_word = 1;
                } else {
                    /* Check two rows away to detect if there's a word
                     * that this tile extends */
                    int8_t above_val = two_above[col];
                    int8_t below_val = two_below[col];
                    cross_product = (int16_t)above_val * (int16_t)below_val;
                    if (cross_product != 0)
                        has_cross_word = 1;
                }
            }

            /* Check columns left and right */
            if (direction != 2 && direction != 17) {
                if (left_adj[col] != 0)
                    has_cross_word = 1;
            }
            if (direction != 15 && direction != 30) {
                if (right_adj[col] != 0)
                    has_cross_word = 1;
            }

            if (has_cross_word) {
                /* Score the cross-word from pre-computed g_state2 grid */
                /* The cross-word value is read from g_state2 at the
                 * corresponding position, multiplied by any bonus */
            }

            /* ------ Bonus square check ------ */

            /* Scan the 20-entry bonus table for matching position */
            int16_t letter_val = (int16_t)letter;
            for (int b = 0; b < 20; b++) {
                BonusEntry *be = &g_bonus_table[b];
                if (be->type != 0)
                    continue;               /* skip word multipliers */
                if ((int16_t)be->position != cross_product)
                    continue;               /* position mismatch */
                if ((int16_t)be->letter != letter_val)
                    continue;               /* letter mismatch */

                /* Apply bonus: subtract bonus value from score component */
                word_score -= (int16_t)be->value;
                break;
            }
        }

        wp++;
        col++;
    }
    /* ---- End main letter loop ---- */

    /* Add word score to total */
    if (word_score != 0) {
        total_score += word_score;
        if (score_markers != NULL) {
            *score_markers++ = 20000;           /* cross-word marker */
        }
    }

    /* ============================================================
     * PHASE 4: Process rack (mark played tiles)
     * ============================================================ */

phase_5_leave:

    process_rack(move_ptr, g_current_rack, 0);  /* JT[2370] */

    /* Count remaining rack tiles by category */
    playable_count = 0;
    regular_count = 0;
    blank_count = 0;

    char *rack_scan = g_current_rack;
    while (*rack_scan != '\0') {
        int16_t ch = (int16_t)(int8_t)*rack_scan;

        if (is_letter_playable(ch)) {           /* JT[2002] */
            playable_count++;
        } else if (ch == '?') {
            blank_count++;
        } else {
            regular_count++;
        }
        rack_scan++;
    }

    /* Calculate draw count: 7 minus all categorized tiles */
    draw_count = 7 - playable_count - regular_count - blank_count;

    /* Cap draw count */
    max_tiles = letter_count - 1;
    if (draw_count > max_tiles) {
        if (letter_count <= 7)
            draw_count = 0;
        else
            draw_count = max_tiles;
    }

    /* ============================================================
     * PHASE 5: Composite leave evaluation via JT[2506]
     * ============================================================ */

    /* Call the main leave evaluation function.
     * This integrates per-tile MUL values, binomial weighting,
     * and V/C balance into a single leave score. */
    int32_t leave_score = final_leave_calc(
        playable_count,     /* tiles that can be played */
        blank_count,        /* blank tiles remaining */
        regular_count,      /* regular tiles remaining */
        tiles_played,       /* vowels? (unclear parameter mapping) */
        0,                  /* consonants? */
        draw_count          /* tiles to draw */
    );                                          /* JT[2506] */

    total_score += leave_score;

    if (score_markers != NULL) {
        *score_markers++ = -1;                  /* terminator / leave marker */
    }

    /* ============================================================
     * PHASE 6: Bingo bonus
     * ============================================================ */

    /* Temporarily adjust letter count if word was placed */
    int8_t has_word = *((int8_t *)move_ptr + 32);
    if (has_word)
        letter_count--;

    if (letter_count > 7 && letter_count < 17) {
        /* Bingo: played 7 or more tiles from rack.
         * Look up bonus from table indexed by (letter_count - 7).
         * The table is at g_bingo_table with 2-byte entries.
         * Adjusted by g_bingo_adj base value. */
        int16_t bingo_idx = letter_count;
        int16_t bonus = g_bingo_table[bingo_idx];
        bonus -= g_bingo_adj;
        total_score += (int32_t)bonus;

        if (score_markers != NULL) {
            *score_markers++ = -33;             /* bingo bonus marker */
        }
    }

    /* Restore letter count */
    if (has_word)
        letter_count++;

    /* ============================================================
     * PHASE 7: Per-letter leave values
     * ============================================================ */

    int32_t letter_leave = 0;
    q_present = 0;

    char *rack_ptr = g_rack;
    while (*rack_ptr != '\0') {
        int16_t ch = (int16_t)(int8_t)*rack_ptr;

        /* Validate letter range */
        if (ch < 0 || ch >= 128 || letter_buf[ch] >= 0) {
            bounds_error();                     /* JT[418] */
        }

        /* Skip if this letter has zero count in buffer */
        if (letter_buf[ch] == 0) {
            rack_ptr++;
            continue;
        }

        /* Skip Q: handled separately in phase 8 */
        if (ch == 'q') {        /* ASCII 113 */
            q_present = 1;
            rack_ptr++;
            continue;
        }

        /* Calculate positional score for this letter pattern */
        int16_t pos_score = calc_positional_score(
            letter_buf, &letter_buf[ch]         /* JT[2498] */
        );

        /* Multiply by letter's count and accumulate */
        int8_t count = letter_buf[ch];
        letter_leave += (int32_t)(pos_score * (int16_t)count);

        rack_ptr++;
    }

    /* ============================================================
     * PHASE 7b: Q solo contribution
     * ============================================================ */

    if (q_present) {
        /* Calculate Q's positional score using "q" pattern */
        int16_t q_score = calc_positional_score(
            letter_buf, g_q_pattern              /* JT[2498] */
        );

        /* Look up Q's base value from score table */
        int16_t q_base = g_score_lookup['q'];
        letter_leave += (int32_t)(q_score + q_base);
    }

    /* ============================================================
     * PHASE 7c: Per-letter average normalization
     * ============================================================ */

    /* Scale leave by draw count: multiply by (7 - rack_length) */
    int16_t rack_len = strlen(g_current_rack);   /* JT[3522] */
    draw_count = 7 - rack_len;

    letter_leave = mul32(letter_leave, (int32_t)draw_count);  /* JT[66] */

    /* Add letter_count as rounding term, then divide by letter_count */
    letter_leave += (int32_t)letter_count;
    letter_leave = div32(letter_leave, (int32_t)letter_count); /* JT[90] */

    total_score += letter_leave;

    if (score_markers != NULL) {
        *score_markers++ = -2;                  /* per-letter average marker */
    }

    /* ============================================================
     * PHASE 8: QU synergy bonus
     * ============================================================ */

    /* Check if rack contains both Q and U */
    if (strchr(g_current_rack, 'u') != NULL) {  /* JT[3514] */
        if (q_present) {
            /* QU synergy: calculate combined score for "qu" pattern */
            int16_t qu_score = calc_positional_score(
                letter_buf, g_qu_pattern         /* JT[2498] */
            );

            /* Subtract the Q-alone score to get the synergy delta */
            int16_t q_base = g_score_lookup['q'];
            int32_t qu_bonus = (int32_t)(qu_score - q_base);

            /* Scale by draw count and normalize by letter count */
            qu_bonus = mul32(qu_bonus, (int32_t)draw_count);    /* JT[66] */
            qu_bonus += (int32_t)letter_count;
            qu_bonus = div32(qu_bonus, (int32_t)letter_count);  /* JT[90] */

            total_score += qu_bonus;

            if (score_markers != NULL) {
                *score_markers++ = -3;          /* QU synergy marker */
            }
        }
    }

    /* ============================================================
     * PHASE 9: Q-without-U penalty
     * ============================================================ */

    if (strchr(g_current_rack, 'q') != NULL) {  /* JT[3514] */
        if (strchr(g_current_rack, 'u') == NULL) {
            /* Q without U: apply penalty from lookup table.
             * Table is indexed by (draw_count * 10 + letter_count_index).
             * This penalty reflects the likelihood of NOT drawing a U. */
            int16_t penalty_idx = draw_count * 10;
            int16_t q_penalty = g_q_penalty[penalty_idx + letter_count];
            total_score += (int32_t)q_penalty;  /* penalty is negative */

            if (score_markers != NULL) {
                *score_markers++ = -4;          /* Q penalty marker */
            }
        }
    }

    /* ============================================================
     * PHASE 10: Individual letter leave contributions
     * ============================================================ */

    rack_scan = g_current_rack;
    while (*rack_scan != '\0') {
        int16_t ch = (int16_t)(int8_t)*rack_scan;

        /* Skip duplicate letters (rack is sorted, so duplicates are adjacent) */
        if (*rack_scan == *(rack_scan + 1)) {
            rack_scan++;
            continue;
        }

        /* Get this letter's count in the rack */
        int16_t count = (int16_t)letter_buf[ch];

        /* Calculate individual letter leave value */
        int32_t val = calc_letter_value(ch, letter_count, count);  /* JT[2514] */

        /* Get letter's base frequency value */
        int8_t freq = g_letter_freq[ch];
        int16_t freq_adj = (int16_t)freq - 1;

        /* Calculate differential: value for this letter minus baseline */
        int32_t baseline = calc_letter_value('a' - 1, ch, 0);     /* JT[2514] */
        val -= baseline;

        total_score += val;

        /* Write marker for this letter's contribution */
        if (score_markers != NULL) {
            /* Marker encodes rack position: -(5 + position_in_rack) */
            char *pos_in_rack = strchr(g_rack, (char)ch);  /* JT[3514] */
            int16_t offset = (int16_t)(pos_in_rack - g_rack);
            *score_markers++ = -(5 + offset);
        }

        rack_scan++;
    }

    /* ============================================================
     * PHASE 11: Final accumulation via helper
     * ============================================================ */

    /* Call sum_filtered_values (function 0x0310) for per-tile position
     * scoring, passing the score and value marker arrays. */
    int32_t position_score = sum_filtered_values(
        score_markers, value_markers, 0
    );                                          /* PC-relative call to 0x0310 */
    total_score += position_score;

    /* ============================================================
     * PHASE 12: Validate remaining rack and cleanup
     * ============================================================ */

    /* Verify all remaining rack letters are valid */
    rack_scan = g_current_rack;
    while (*rack_scan != '\0') {
        int16_t ch = (int16_t)(int8_t)*rack_scan;
        if (g_letter_counts[ch] <= 0) {
            bounds_error();                     /* JT[418] */
        }
        rack_scan++;
    }

    /* Cleanup: restore rack state */
    cleanup_rack(g_current_rack);               /* JT[2378] */
    sort_rack(g_current_rack);                  /* JT[2410] */

    return total_score;
}
```

### Algorithm Summary

The function is structured as a 12-phase pipeline:

| Phase | Description | Score Component |
|-------|-------------|-----------------|
| 1 | Initialize rack, count letters | (setup) |
| 2 | Offline mode: base score from position table | total += base |
| 3 | Walk word: letter values, cross-words, bonus squares | word_score |
| 4 | Mark played tiles in rack | (setup) |
| 5 | Composite leave evaluation | total += leave |
| 6 | Bingo bonus for 7+ tiles | total += bingo |
| 7 | Per-letter leave values with normalization | total += letter_leave |
| 7b | Q solo pattern score | (part of 7) |
| 7c | Normalize by draw count / letter count | (part of 7) |
| 8 | QU synergy bonus | total += qu_bonus |
| 9 | Q-without-U penalty | total += penalty |
| 10 | Individual unique letter contributions | total += per_letter |
| 11 | Position-based accumulation via helper | total += pos_score |
| 12 | Validate rack, cleanup | (teardown) |

---

## Function 0x0A44 - Per-Tile Position Scores

**Frame**: LINK A6,#-12 (12-byte local frame).
**Saved registers**: D3-D7/A2-A4.
**Parameters**:
- 8(A6) = positions output array (int16*, may be NULL)
- 12(A6) = values output array (int16*, may be NULL)

**Returns**: D0 = total accumulated score.

This function iterates every board position from 1 to g_board_size-1, checking
the position validity table. For each valid position with a tile on the board,
it computes a score contribution based on the letter value and cross-word
context.

### Stack Frame Layout

| Offset | Size | Purpose |
|--------|------|---------|
| -4(A6) | 4 | (padding/unused) |
| -8(A6) | 4 | (padding/unused) |
| -10(A6) | 4 | Total score accumulator (int32) |
| -12(A6) | 2 | Current letter value (int16) |

### Register Usage

| Register | Purpose |
|----------|---------|
| D3 | Running tile score for current position |
| D4 | Row index for current position |
| D5 | Column index for current position |
| D6 | Temporary for cross-word calculations |
| D7 | Position loop counter (1 to g_board_size-1) |
| A2 | Unused (saved but not used) |
| A3 | Value output pointer (from 12(A6)) |
| A4 | Position output pointer (from 8(A6)) |

### Position Record Format

Each position record is 8 bytes (accessed via g_position_table at A5-10918):

| Byte Offset | Type | Description |
|-------------|------|-------------|
| 0-3 | int32 | Opaque data |
| 4 | int8 | Valid flag (nonzero = valid position) |
| 5 | int8 | Reserved |
| 6 | int8 | Row index into board grid |
| 7 | int8 | Column index into board grid |

### Algorithm

For each valid position with a tile:
1. Read the letter from g_state1[row][col]
2. If g_state2[row][col] is nonzero, use that as the cross-word context score
3. Otherwise, look up the letter's point value from g_letter_points
4. For Q tiles: if the word containing Q has length > 1, divide score by 2
   (Q's 10 points are halved when it forms part of a longer word, reflecting
   that QU is effectively a single unit)
5. Write position index and score to output arrays (if non-NULL)
6. Accumulate into total

### C Decompilation

```c
/*
 * calc_per_tile_scores - Score each tile on the board by position.
 *
 * Iterates all valid board positions, computes per-tile contribution
 * scores, and optionally writes position/value arrays for the UI.
 *
 * Parameters:
 *   positions_out  - array to receive position indices (may be NULL)
 *   values_out     - array to receive per-tile scores (may be NULL)
 *
 * Returns: total of all per-tile scores
 */
int32_t calc_per_tile_scores(int16_t *positions_out, int16_t *values_out)
{
    int32_t  total = 0;        /* -10(A6) */
    int16_t  letter_val;       /* -12(A6) */
    int16_t  pos;              /* D7: loop counter */
    int32_t  tile_score;       /* D3 */
    int16_t  row, col;         /* D4, D5 */

    for (pos = 1; pos < g_board_size; pos++) {
        /* Read position record (8 bytes per entry) */
        int8_t *rec = (int8_t *)g_position_table + (int32_t)pos * 8;

        /* Check valid flag at byte 4 */
        if (rec[4] == 0)
            continue;           /* invalid position, skip */

        /* Extract row and column */
        row = (int16_t)(int8_t)rec[6];
        col = (int16_t)(int8_t)rec[7];

        /* Read letter at this board position */
        int8_t letter = g_state1[row][col];
        letter_val = (int16_t)letter;

        if (letter_val == 0)
            continue;           /* empty cell, skip */

        /* Start with base tile score */
        tile_score = 0;

        /* Check pre-computed cross-word score in g_state2 */
        int16_t cross_score = g_state2[row][col];
        if (cross_score != 0) {
            /* Use pre-computed cross-word value */
            tile_score = (int32_t)cross_score;
        } else {
            /* No cross-word: use letter's point value */
            int16_t points = g_letter_points[(uint8_t)letter];
            tile_score = (int32_t)points;
        }

        /* Special handling for Q (ASCII 113) */
        if (letter == 'q') {
            /* Check word length at this position.
             * Uses position record to find the word string,
             * then calls strlen. */
            int8_t *word_rec = (int8_t *)g_position_table + (int32_t)pos * 8;
            /* The word pointer is at offset 8 in the extended record */
            char *word_str = *(char **)(word_rec + 8);
            int16_t word_len = strlen(word_str);    /* JT[3522] */

            if (word_len > 1) {
                /* Q in a multi-letter word: halve its contribution.
                 * This accounts for Q+U being treated as a unit. */
                tile_score = div32(tile_score, 2);  /* JT[90] */
            }
        }

        /* Write to output arrays if provided */
        if (positions_out != NULL) {
            *positions_out++ = pos;
        }
        if (values_out != NULL) {
            *values_out++ = (int16_t)tile_score;
        }

        /* Accumulate */
        total += tile_score;
    }

    /* Null-terminate output arrays */
    if (positions_out != NULL)
        *positions_out = 0;
    if (values_out != NULL)
        *values_out = 0;

    return total;
}
```

---

## Data Structures

### Move Data (passed to function 0x0368)

```
Offset  Size    Type        Field
------  ----    ----        -----
0       32      char[32]    word        - Letters being played (C string)
32      1       int8        direction   - Row stride (1=across, 17=down)
33      1       int8        start_pos   - Starting column or row
```

The direction field encodes the board traversal stride directly: for across play
the stride is 1 (adjacent columns), for down play the stride is 17 (next row in
the 17-wide grid).

### Board Grid (g_state1 at A5-17154)

17x17 byte grid (289 bytes). Row 0 and column 0 are borders (always 0). The
playable area is rows 1-15, columns 1-15. Each byte is either 0 (empty) or the
ASCII value of the placed letter.

### Score Grid (g_state2 at A5-16610)

17x17 word grid (578 bytes). Each cell contains a pre-computed cross-word score
value in centipoints. Zero means no cross-word exists at that position. These
values are populated by CODE 39 during move generation.

### Position Record Table (g_position_table at A5-10918)

Variable-length array of 8-byte records:

```
Offset  Size    Field
------  ----    -----
0       4       opaque data (possibly tile ID or flags)
4       1       valid flag (nonzero = playable position)
5       1       reserved
6       1       row index (into 17x17 grid)
7       1       column index (into 17x17 grid)
```

Indexed from 1 to g_board_size-1. Position 0 is unused.

### Bonus Square Table (g_bonus_table at A5-2422)

20 entries of 4 bytes each:

```
Offset  Size    Field
------  ----    -----
0       1       letter (which letter this bonus applies to)
1       1       type (0=letter bonus, nonzero=word bonus)
2       1       position (row or column)
3       1       value (multiplier amount)
```

### Score Breakdown Marker Array

The score_markers output array uses sentinel values to delimit score components
in the UI display:

```
[markers...]  -32     = primary word score follows
[markers...]  20000   = cross-word score follows
[markers...]  -1      = leave evaluation total
[markers...]  -33     = bingo bonus follows
[markers...]  -2      = per-letter average
[markers...]  -3      = QU synergy bonus
[markers...]  -4      = Q-without-U penalty
[markers...]  -(5+i)  = individual letter at rack position i
[markers...]  0       = array terminator
```

---

## Score Calculation Pipeline

The complete flow from move input to final centipoint score:

```
                    +------------------+
                    |   Move Input     |
                    | word + dir + pos |
                    +--------+---------+
                             |
                    +--------v---------+
                    |  Initialize Rack |  JT[2410] sort_rack
                    |  Count Letters   |  JT[2394] count_letters
                    +--------+---------+
                             |
              +--------------+--------------+
              |                             |
     +--------v---------+         +--------v---------+
     | Game Active?      |         | Offline Mode     |
     | Walk board tiles  |         | Score from table |
     | Cross-word check  |         | A5-10918 lookup  |
     | Bonus squares     |         +--------+---------+
     +--------+---------+                   |
              |                             |
              +------>-------<--------------+
                             |
                    +--------v---------+
                    | Process Rack     |  JT[2370]
                    | Mark played tiles|
                    +--------+---------+
                             |
                    +--------v---------+
                    | Leave Evaluation |  JT[2506]
                    | Binomial weight  |
                    | V/C balance      |
                    +--------+---------+
                             |
                    +--------v---------+
                    | Bingo Check      |
                    | 7+ tiles bonus   |  g_bingo_table
                    +--------+---------+
                             |
                    +--------v---------+
                    | Per-Letter Leave |
                    | Normalize by     |
                    | draw count       |  JT[2498], JT[66], JT[90]
                    +--------+---------+
                             |
                    +--------v---------+
                    | Q/QU Handling    |
                    | QU synergy bonus |
                    | Q-alone penalty  |  g_q_penalty
                    +--------+---------+
                             |
                    +--------v---------+
                    | Individual Letter|
                    | Leave Values     |  JT[2514]
                    +--------+---------+
                             |
                    +--------v---------+
                    | Position Scores  |
                    | sum_filtered     |  Fn 0x0310
                    +--------+---------+
                             |
                    +--------v---------+
                    | Validate & Clean |  JT[2378], JT[2410]
                    +--------+---------+
                             |
                    +--------v---------+
                    | Return Total     |
                    | (centipoints)    |
                    +------------------+
```

---

## Integration with Other CODE Resources

### Callers of CODE 35

| Resource | Function | How CODE 35 is Called |
|----------|----------|---------------------|
| CODE 32 | evaluate_move | Calls full_score_calculation for detailed breakdown |
| CODE 39 | generate_moves | Calls calc_per_tile_scores for position evaluation |
| CODE 45 | rank_moves | Uses score breakdown markers for display |

### Functions CODE 35 Calls (via Jump Table)

| JT Offset | Likely CODE | Function |
|-----------|-------------|----------|
| 66 | CODE 2 | 32-bit multiply |
| 90 | CODE 2 | 32-bit divide |
| 418 | CODE 11 | bounds_error (fatal) |
| 2370 | CODE 31 | process_rack |
| 2378 | CODE 31 | cleanup_rack |
| 2394 | CODE 31 | count_letters |
| 2410 | CODE 31 | sort_rack |
| 2498 | CODE 32 | calc_positional_score |
| 2506 | CODE 32 | final_leave_calc |
| 2514 | CODE 32 | calc_letter_value |
| 3514 | CODE 52 | strchr |
| 3522 | CODE 52 | strlen |

### Shared Global State

CODE 35 reads and writes several globals shared with the scoring system:

- **g_state1** (A5-17154) and **g_state2** (A5-16610): Board state populated by
  CODE 39 during move generation. CODE 35 reads these but does not modify them.

- **g_current_rack** (A5-15498): The sorted rack string. CODE 35 modifies this
  temporarily (via JT[2370] process_rack and JT[2378] cleanup_rack) to track
  which tiles have been played.

- **g_position_table** (A5-10918): Position validity records populated during
  board setup. Read-only from CODE 35's perspective.

- **g_bingo_table** (A5-24866): Pre-computed bingo bonus values. These are likely
  set during game initialization.

### Relationship to CODE 32

CODE 35 and CODE 32 share the same scoring vocabulary (centipoints, leave values,
V/C balance) but serve different roles:

- **CODE 32** is the runtime move evaluator called during AI move search. It uses
  simplified integer arithmetic for speed.
- **CODE 35** provides a more detailed breakdown with optional SANE floating-point
  precision (functions 0x0060 and 0x0168) for simulation or analysis purposes.

Both call the same leave evaluation function (JT[2506]) and letter value function
(JT[2514]), ensuring consistency between the fast evaluator and the detailed
analysis path.

---

## Confidence Assessment

| Component | Confidence | Notes |
|-----------|------------|-------|
| Function boundaries | HIGH | Verified from LINK/UNLK pairs in raw hex |
| SANE opcode decode | **HIGH (CORRECTED)** | Cross-referenced with Apple Numerics Manual |
| Function 0x0000/0x0030 | HIGH | Simple boundary checks, clearly decoded |
| Function 0x0060 | MEDIUM | SANE sequence is complex; exact algorithm uncertain |
| Function 0x0168 | MEDIUM | Multi-step SANE; some parameter mappings uncertain |
| Function 0x0310 | HIGH | Simple loop with clear control flow |
| Function 0x0368 | HIGH (structure) / MEDIUM (details) | Overall pipeline is clear; some field offsets and JT parameter mappings are approximate |
| Function 0x0A44 | HIGH | Clear iteration pattern with position table |
| Global identification | HIGH | Offsets verified against CODE 32 analysis |
| Score marker values | HIGH | Verified from immediate values in hex |

### Key Remaining Uncertainties

1. **SANE functions 0x0060/0x0168**: The exact mathematical algorithm (what is being
   computed) is uncertain. The SANE operations are correctly decoded, but the
   relationship between the input structure fields and the computed result needs
   further investigation. These may be related to simulation statistics or
   expected-value calculations.

2. **Function 0x0368 cross-word scoring**: The exact mechanics of how cross-word
   values are extracted from g_state2 and combined with bonus multipliers involve
   several nested conditions. The high-level flow is clear but some branch
   conditions in the inner loop may be approximate.

3. **Position record extended fields**: Function 0x0A44 references what appears to
   be a word string pointer at offset 8 of the position record, suggesting the
   records may be larger than 8 bytes or there is a secondary table. This needs
   verification.

4. **Parameter mapping for JT[2506]**: The six parameters pushed to the
   final_leave_calc function are read from local variables, but the exact semantic
   mapping (which parameter is vowels vs consonants vs played tiles) may be
   imprecise.
