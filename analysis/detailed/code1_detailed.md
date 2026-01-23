# CODE 1 Detailed Analysis - Runtime Initialization & Math Library

## Overview

| Property | Value |
|----------|-------|
| Size | 574 bytes |
| JT Offset | 0 |
| JT Entries | 10 |
| Functions | ~8 |
| Purpose | **Runtime initialization, division routines, math support** |

## Architecture Role

CODE 1 is loaded at startup and contains:
1. Application initialization code (THINK C runtime startup)
2. 32-bit division routines (signed and unsigned)
3. Table-driven dispatch routines for switch statements

## Key Functions

### Function 0x0000-0x0042 - Application Entry Point

The first 8 bytes are header data, not code:
```asm
0000: 000001BA      ; Header: above A5 size = 0x01BA (442 bytes)
0004: 00000000      ; Header: below A5 size (or flags)
0008: CLR.W      $0A4A.W     ; Clear low memory (CurApName?)
```

Main entry continues:
```asm
000E: JSR        52(PC)       ; Call init_toolbox at 0x0044
0012: JSR        36(PC)       ; Call init_globals at 0x0038
0016: CLR.W      -(A7)        ; Push 0 (return value placeholder)
0018: PEA        $0000FFFF    ; Push -1 or flags
001E: PEA        4(A7)        ; Push address of return placeholder
0022: PEA        (A7)         ; Push stack frame pointer
0024: PEA        $0001.W      ; Push 1 (argc?)
0028: ...                     ; Setup continues
002C: JSR        0(A5,D1.W)   ; Jump table call to main init
0030: MOVEA.L    108(A5),A0   ; Get main() function pointer from A5+108
0034: JSR        (A0)         ; Call the main application code
0042: RTS                     ; Return (cleanup handled elsewhere)
```

**Purpose**: This is the THINK C runtime startup code that initializes the application environment before calling the main program.

### Function 0x0044-0x00A4 - Toolbox Initialization

```asm
0044: ...
004C: CLR.W      -(A7)        ; Parameter
004E: A9A0                    ; _InitDialogs trap
...
005A: CLR.W      -(A7)
005C: A9A0                    ; _InitMenus trap
...
0080: ...
008A: A9A3                    ; _FlushEvents trap
...
00A4: RTS
```

This function calls standard Mac Toolbox initialization traps.

### Functions 0x00A6-0x00CE - Switch Statement Dispatch

These implement compiler-generated switch statement handlers:

```asm
; 0x00A6 - Word-value dispatch (linear search)
00A6: MOVEA.L    (A7)+,A0     ; Get return address (points to dispatch table)
00A8: MOVE.W     (A0)+,D1     ; Get case count
00AA: MOVE.W     (A0)+,D2     ; Get case value
00AC: CMP.W      (A0)+,D0     ; Compare against selector (in D0)
00AE: DBEQ       D1,$00AA     ; Loop until match or exhausted
00B2: TST.W      D2
00B4: BEQ.S      $00B4        ; Infinite loop on error (should not happen)
00B6: JMP        -4(A0,D2.W)  ; Jump to handler via offset

; 0x00BA - Variant for different table format
00BA: MOVEA.L    (A7)+,A0
00BC: MOVE.W     (A0)+,D1
00BE: MOVE.W     (A0)+,D2
00C0: CMP.W      (A0)+,D0
00C2: DBEQ       D1,$00BE
00C6: TST.W      D2
00C8: BEQ.S      $00C8
00CA: JMP        -6(A0,D2.W)  ; Different offset calculation

; 0x00CE - Range dispatch (for sequential case values)
00CE: MOVEA.L    (A7)+,A0
00D0: MOVE.W     (A0)+,D1     ; Get minimum value
00D2: MOVE.W     (A0)+,D2     ; Get maximum value
00D4: CMP.W      D2,D0        ; Check upper bound
00D6: BGT.S      $00E2        ; Too big - use default
00D8: SUB.W      D1,D0        ; Subtract minimum
00DA: BLT.S      $00E2        ; Too small - use default
00DC: ADD.W      D0,D0        ; Index * 2 (word table)
00DE: LEA        2(A0,D0.W),A0 ; Point to entry
00E2: MOVE.W     (A0),D0      ; Get jump offset
00E4: BEQ.S      $00E4        ; Error if zero
00E6: JMP        0(A0,D0.W)   ; Jump to handler
```

### Function 0x00EA-0x011E - 32-bit Unsigned Multiply

```asm
00EA: MOVE.L     4(A7),D0     ; Get first operand
00EE: MOVE.L     D1,4(A7)     ; Save D1 on stack
00F2: MOVE.L     8(A7),D1     ; Get second operand
00F6: MOVE.L     (A7)+,4(A7)  ; Adjust stack
00FA: MOVEM.L    D2/D3/D4/D5,-(SP)  ; Save work registers
00FE: MOVE.L     D0,D2        ; Copy operands
0100: MOVE.L     D1,D3
0102: SWAP       D2           ; Split into high/low words
0104: MULU.W     D3,A2        ; Multiply low * low
0106: MOVE.L     D0,D4
0108: MOVE.L     D1,D5
010A: SWAP       D5
010C: MULU.W     D5,A4        ; Cross multiply
010E: ADD.L      D4,D2        ; Combine results
0110: SWAP       D2
0112: CLR.W      D2
0114: MULU.W     D1,A0
0116: ADD.L      D2,D0        ; Final result in D0
0118: MOVEM.L    (SP)+,D2/D3/D4/D5  ; Restore
011C: MOVE.L     (A7)+,D1
011E: RTS
```

### Functions 0x0120-0x01A2 - 32-bit Division Routines

```asm
; 0x0120 - Signed division, return quotient in D0
0120: MOVE.L     4(A7),D0     ; Get dividend
0124: MOVE.L     D1,4(A7)     ; Save D1
0128: MOVE.L     8(A7),D1     ; Get divisor
012C: MOVE.L     (A7)+,4(A7)  ; Adjust stack
0130: MOVEM.L    D2/D3/D7,-(SP)  ; Save registers
0134: JSR        156(PC)      ; Call sign handler at 0x01A4
0138: MOVEM.L    (SP)+,D2/D3/D7
013C: MOVE.L     (A7)+,D1
013E: RTS

; 0x0140 - Signed division, return remainder in D0
0140: MOVE.L     4(A7),D0
...
0154: JSR        124(PC)      ; Call sign handler
0158: MOVE.L     D1,D0        ; Return remainder (was in D1)
...
0160: RTS

; 0x0162 - Combined quotient/remainder (returns both)
0162: MOVE.L     4(A7),D0
...
0176: JSR        44(PC)       ; Call divmod
...
0180: RTS

; 0x0182 - Modulo only (signed)
0182: MOVE.L     4(A7),D0
...
0196: JSR        12(PC)
019A: MOVE.L     D1,D0        ; Return remainder
...
01A2: RTS
```

### Function 0x01A4-0x01D0 - Sign Handling for Division

```asm
01A4: TST.L      D0           ; Test dividend sign
01A6: BPL.S      $01C4        ; If positive, check divisor only
01A8: TST.L      D1           ; Dividend negative, test divisor
01AA: BPL.S      $01B8        ; Divisor positive: negate dividend only

; Both negative: negate both, quotient positive, remainder negative
01AC: NEG.L      D0           ; Negate dividend
01AE: NEG.L      D1           ; Negate divisor
01B0: JSR        32(PC)       ; Call unsigned divide at 0x01D2
01B4: NEG.L      D1           ; Negate remainder
01B6: RTS

; Dividend negative, divisor positive: negate both results
01B8: NEG.L      D0           ; Negate dividend
01BA: JSR        22(PC)       ; Call unsigned divide
01BE: NEG.L      D0           ; Negate quotient
01C0: NEG.L      D1           ; Negate remainder
01C2: RTS

; Dividend positive, check divisor
01C4: TST.L      D1           ; Test divisor sign
01C6: BPL.S      $01D2        ; Both positive: proceed directly

; Dividend positive, divisor negative: negate divisor and quotient
01C8: NEG.L      D1           ; Negate divisor
01CA: JSR        6(PC)        ; Call unsigned divide
01CE: NEG.L      D0           ; Negate quotient
01D0: RTS
```

### Function 0x01D2-0x023E - Unsigned Division Core

```asm
01D2: MOVE.L     #$0000FFFF,D7 ; 16-bit mask for optimization
01D8: CMP.L      D1,D0        ; Compare divisor to dividend
01DA: BLS.S      $01E2        ; If divisor <= dividend, do division
01DC: MOVE.L     D0,D1        ; quotient = 0, remainder = dividend
01DE: MOVEQ      #0,D0
01E0: RTS

; Check if we can use fast 16-bit divide
01E2: CMP.L      D7,D0        ; Does dividend fit in 16 bits?
01E4: BHI.S      $01F2        ; No, use long division
01E6: DIVU.W     D1,D0        ; Fast path: 32/16 divide
01E8: SWAP       D0           ; High word has remainder
01EA: MOVE.W     D0,D1        ; D1 = remainder
01EC: CLR.W      D0
01EE: SWAP       D0           ; D0 = quotient
01F0: RTS

; Long division algorithm for large numbers
01F2: CMP.L      D7,D1        ; Does divisor fit in 16 bits?
01F4: BHI.S      $0210        ; No, use shift-subtract
; ... optimized path for small divisor ...

0210: MOVE.L     D0,D2        ; Save dividend
0212: MOVE.L     D1,D3        ; Save divisor
; Normalize and use shift-subtract algorithm
0214: LSR.L      #1,D0
0216: LSR.L      #1,D1
0218: CMP.L      D7,D1        ; Keep shifting until divisor fits
021A: BHI.S      $0214
; ... continue algorithm ...
```

## C Equivalent

```c
// Division with sign handling
long divide_signed(long dividend, long divisor) {
    int negate_quotient = 0;
    int negate_remainder = 0;

    if (dividend < 0) {
        dividend = -dividend;
        negate_quotient = 1;
        negate_remainder = 1;
    }
    if (divisor < 0) {
        divisor = -divisor;
        negate_quotient = !negate_quotient;
    }

    long quotient, remainder;
    divide_unsigned(dividend, divisor, &quotient, &remainder);

    if (negate_quotient) quotient = -quotient;
    if (negate_remainder) remainder = -remainder;
    return quotient;  // or remainder depending on entry point
}
```

## Jump Table Mapping

| JT Offset | Function | Purpose |
|-----------|----------|---------|
| 66(A5) | 0x00EA | 32-bit multiply |
| 74(A5) | 0x00A6 | Switch dispatch |
| 82(A5) | 0x00BA | Switch dispatch variant |
| 90(A5) | 0x0120 | Signed division (quotient) |
| 98(A5) | 0x0140 | Signed division (remainder) |
| 106(A5) | 0x0162 | Divmod |

## Why This Matters

The 68000 CPU only has:
- MULU/MULS: 16x16 -> 32 multiply
- DIVU/DIVS: 32/16 -> 16q,16r divide

CODE 1 implements full 32-bit arithmetic essential for:
- Score calculations with large values
- Time/tick calculations
- Memory size calculations
- Any arithmetic on longs

## Confidence: HIGH

This is standard 68K C runtime code (THINK C pattern). The signatures are unmistakable:
- Stack parameter passing convention
- Register save/restore with MOVEM
- Division algorithm with sign handling
- Table-driven dispatch for switch statements

---

## Speculative C Translation

```c
/* CODE 1 - Speculative C Translation */
/* Runtime Initialization & Math Library */

/*============================================================
 * Application Entry Point (0x0000-0x0042)
 * Called by the Segment Loader after CODE 0 sets up A5 world
 *============================================================*/

/* This is compiler-generated startup code, not user-written */
void _start(void) {
    /* Header data at 0x0000-0x0007 is parsed by loader */
    /* Above A5 size: 0x01BA (442 bytes) */
    /* Below A5 size: 0x0000 */

    *(short*)0x0A4A = 0;   /* Clear low-memory global (CurApName?) */

    init_toolbox();         /* JSR 52(PC) - initialize Mac Toolbox */
    init_globals();         /* JSR 36(PC) - zero application globals */

    /* Set up C runtime environment */
    short return_value = 0;
    /* Push argc/argv equivalent for main() */

    /* Call through jump table to initialization routine */
    typedef void (*init_func_t)(void);
    init_func_t init = (init_func_t)(*(long*)(A5 + 108));  /* uncertain */

    /* Call main application */
    typedef void (*main_func_t)(void);
    main_func_t app_main = *(main_func_t*)(g_globals + 108);
    app_main();
}

/*============================================================
 * Toolbox Initialization (0x0044-0x00A4)
 * Standard Mac startup sequence
 *============================================================*/
void init_toolbox(void) {
    /* Standard Toolbox initialization sequence */
    InitGraf(&qd.thePort);   /* uncertain - not visible in disasm */
    InitFonts();
    InitWindows();
    InitMenus();             /* A9A0 trap at 0x005C */
    TEInit();
    InitDialogs(NULL);       /* A9A0 trap at 0x004E */

    FlushEvents(everyEvent, 0);  /* A9A3 trap at 0x008A */
    InitCursor();
}

/*============================================================
 * Switch Statement Dispatch (0x00A6-0x00CE)
 * Compiler-generated helper for switch statements
 *============================================================*/

/* 0x00A6 - Linear search dispatch (for sparse case values) */
/* Called via BSR from switch statement, table follows call */
void __switch_linear(void) {
    /* Called with: D0 = selector value */
    /* Return address points to dispatch table */

    /* Table format:
     *   word: case_count
     *   word: default_offset
     *   repeated: word case_value, word handler_offset
     */

    /* Example C equivalent for what this enables: */
    /*
     * switch (selector) {  // selector in D0
     *   case 5: goto handler_5;
     *   case 100: goto handler_100;
     *   case 203: goto handler_203;
     *   default: goto default_handler;
     * }
     */
}

/* 0x00CE - Range dispatch (for dense sequential cases) */
void __switch_range(void) {
    /* Called with: D0 = selector value */

    /* Table format:
     *   word: min_value
     *   word: max_value
     *   word[max-min+1]: handler_offsets
     *   word: default_offset
     */

    /* C equivalent:
     * if (selector < min || selector > max) goto default;
     * goto jump_table[selector - min];
     */
}

/*============================================================
 * 32-bit Unsigned Multiply (0x00EA-0x011E)
 * JT offset: 66(A5)
 *============================================================*/
unsigned long multiply_32bit(unsigned long a /* 4(A7) */,
                              unsigned long b /* 8(A7) */) {
    /*
     * 68000 only has 16x16->32 multiply (MULU/MULS)
     * This implements: (ah*2^16 + al) * (bh*2^16 + bl)
     *                = ah*bh*2^32 + (ah*bl + al*bh)*2^16 + al*bl
     *
     * Since we only need 32-bit result, ah*bh term overflows and is ignored
     */

    unsigned short a_high = (unsigned short)(a >> 16);  /* SWAP D2 */
    unsigned short a_low  = (unsigned short)(a & 0xFFFF);
    unsigned short b_high = (unsigned short)(b >> 16);  /* SWAP D5 */
    unsigned short b_low  = (unsigned short)(b & 0xFFFF);

    unsigned long result = (unsigned long)a_low * b_low;           /* low * low */
    result += ((unsigned long)a_high * b_low) << 16;   /* cross product 1 */
    result += ((unsigned long)a_low * b_high) << 16;   /* cross product 2 */
    /* a_high * b_high would overflow 32 bits, ignored */

    return result;  /* D0 */
}

/*============================================================
 * Signed Division - Quotient (0x0120-0x013E)
 * JT offset: 90(A5)
 *============================================================*/
long divide_signed_quotient(long dividend /* D0 */, long divisor /* D1 */) {
    long quotient, remainder;
    divide_with_sign_handling(dividend, divisor, &quotient, &remainder);
    return quotient;  /* D0 */
}

/*============================================================
 * Signed Division - Remainder (0x0140-0x0160)
 * JT offset: 98(A5)
 *============================================================*/
long divide_signed_remainder(long dividend, long divisor) {
    long quotient, remainder;
    divide_with_sign_handling(dividend, divisor, &quotient, &remainder);
    return remainder;  /* Moved from D1 to D0 at 0x0158 */
}

/*============================================================
 * Sign Handling for Division (0x01A4-0x01D0)
 * Converts signed division to unsigned, adjusts result signs
 *============================================================*/
void divide_with_sign_handling(long dividend /* D0 */,
                                long divisor /* D1 */,
                                long *quotient_out,
                                long *remainder_out) {
    int negate_quotient = 0;
    int negate_remainder = 0;

    /* Handle negative dividend */
    if (dividend < 0) {              /* TST.L D0; BPL.S $01C4 */
        dividend = -dividend;         /* NEG.L D0 */
        negate_quotient = 1;
        negate_remainder = 1;

        if (divisor < 0) {           /* TST.L D1; BPL.S $01B8 */
            /* Both negative: quotient positive, remainder negative */
            divisor = -divisor;       /* NEG.L D1 */
            negate_quotient = 0;      /* Quotient stays positive */
        }
        /* else: dividend neg, divisor pos -> both results negative */
    } else {
        /* Dividend positive */
        if (divisor < 0) {           /* TST.L D1; BPL.S $01D2 */
            divisor = -divisor;       /* NEG.L D1 */
            negate_quotient = 1;      /* Quotient negative */
        }
        /* else: both positive -> both results positive */
    }

    /* Call unsigned division core */
    unsigned long uquot, urem;
    divide_unsigned((unsigned long)dividend, (unsigned long)divisor,
                    &uquot, &urem);

    *quotient_out = negate_quotient ? -(long)uquot : (long)uquot;
    *remainder_out = negate_remainder ? -(long)urem : (long)urem;
}

/*============================================================
 * Unsigned Division Core (0x01D2-0x023E)
 * Implements 32-bit / 32-bit -> 32-bit quotient, 32-bit remainder
 *============================================================*/
void divide_unsigned(unsigned long dividend /* D0 */,
                      unsigned long divisor /* D1 */,
                      unsigned long *quotient_out,
                      unsigned long *remainder_out) {

    const unsigned long WORD_MASK = 0x0000FFFF;  /* D7 */

    /* Quick check: divisor > dividend means quotient = 0 */
    if (divisor > dividend) {        /* CMP.L D1,D0; BLS.S $01E2 */
        *quotient_out = 0;            /* MOVEQ #0,D0 */
        *remainder_out = dividend;    /* MOVE.L D0,D1 */
        return;
    }

    /* Fast path: if dividend fits in 16 bits, use DIVU */
    if (dividend <= WORD_MASK) {     /* CMP.L D7,D0; BHI.S $01F2 */
        /* 32/16 divide using hardware instruction */
        unsigned long temp = dividend / (unsigned short)divisor;  /* DIVU.W */
        *quotient_out = temp & 0xFFFF;
        *remainder_out = dividend % (unsigned short)divisor;
        return;
    }

    /* Medium path: if divisor fits in 16 bits */
    if (divisor <= WORD_MASK) {      /* CMP.L D7,D1; BHI.S $0210 */
        /* Optimized 32/16 divide with 32-bit dividend */
        /* ... uses two DIVU instructions ... */
        /* uncertain about exact algorithm */
        return;
    }

    /* Slow path: full 32/32 shift-and-subtract */
    /* Normalize by right-shifting both until divisor fits in 16 bits */
    unsigned long d0_copy = dividend;  /* D2 */
    unsigned long d1_copy = divisor;   /* D3 */

    while (divisor > WORD_MASK) {    /* CMP.L D7,D1; BHI.S $0214 */
        dividend >>= 1;               /* LSR.L #1,D0 */
        divisor >>= 1;                /* LSR.L #1,D1 */
    }

    /* Now divisor fits, do approximation and correct */
    /* ... complex correction logic follows ... */
    /* uncertain about exact implementation details */
}
```
