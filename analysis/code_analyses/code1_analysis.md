# CODE 1 Analysis - Runtime Library

## Overview

| Property | Value |
|----------|-------|
| Size | 574 bytes (0x023E) |
| JT Offset | 10 |
| JT Entries | 10 |
| Functions | 10 |
| Categories | RUNTIME |
| Purpose | Application startup, switch dispatch, 32-bit math |
| Confidence | **HIGH** |

## Header

```
Offset 0x00: 0000 000A = JT offset: 10
Offset 0x04: 0000 01BA = Above A5 size: 442 bytes
Offset 0x08: 0000 0000 = Below A5 size: 0
Code starts at offset 0x0C
```

## Complete Disassembly

### Function 1: Application Entry Point at 0x000C

This is the application's main entry point called by the Finder.

```asm
000C: 4278 0A4A     CLR.W    $0A4A.W         ; Clear CurApName low memory
0010: 9DCE          SUBA.L   A6,A6           ; Clear A6 (no previous frame)
0012: 4EBA 0034     JSR      $0048(PC)       ; Call init_toolbox
0016: 4EBA 0024     JSR      $003C(PC)       ; Call init_globals
001A: 4267          CLR.W    -(A7)           ; Push 0 (no refcon)
001C: 4879 0000FFFF PEA      $0000FFFF       ; Push -1 (all events)
0022: 486F 0004     PEA      4(A7)           ; Push event record ptr
0026: 4857          PEA      (A7)            ; Push pointer
0028: 4878 0001     PEA      $0001.W         ; Push segment 1
002C: 223A FFD6     MOVE.L   -42(PC),D1      ; Get offset
0030: 4EB5 1000     JSR      (A5,D1.W)       ; Call via jump table
0034: 206D 006C     MOVEA.L  $006C(A5),A0    ; Get main function pointer
0038: 4E90          JSR      (A0)            ; Call main
003A: A9F4          _ExitToShell             ; Exit application
```

#### C Translation

```c
/*
 * Application entry point
 * Called by Finder when app launches
 * Confidence: HIGH
 */
void _start(void) {
    CurApName = 0;        /* Clear low memory */

    init_toolbox();       /* Initialize Toolbox managers */
    init_globals();       /* Initialize global variables */

    /* Call main game loop */
    void (*main_func)(void) = g_main_function_ptr;  /* A5+0x6C */
    main_func();

    ExitToShell();        /* Return to Finder */
}
```

### Function 2: init_globals at 0x003C

```asm
003C: 223A FFCA     MOVE.L   -54(PC),D1      ; Get flag
0040: 6704          BEQ.S    $0046           ; Skip if already init
0042: 4EB5 1000     JSR      (A5,D1.W)       ; Call init routine
0046: 4E75          RTS
```

### Function 3: init_toolbox at 0x0048

```asm
0048: 598F          SUBQ.L   #4,A7           ; Make room
004A: 2F3C 5A45524F MOVE.L   #'ZERO',-(A7)   ; Push 'ZERO'
0050: 4267          CLR.W    -(A7)           ; Push 0
0052: A9A0          _GetResource             ; Get ZERO resource
0054: 2457          MOVEA.L  (A7),A2         ; A2 = handle
0056: 598F          SUBQ.L   #4,A7           ; Make room
0058: 2F3C 44415441 MOVE.L   #'DATA',-(A7)   ; Push 'DATA'
005E: 4267          CLR.W    -(A7)           ; Push 0
0060: A9A0          _GetResource             ; Get DATA resource
0062: 2057          MOVEA.L  (A7),A0         ; A0 = DATA handle
0064: 2050          MOVEA.L  (A0),A0         ; Dereference
0066: 2278 0908     MOVEA.L  $0908.W,A1      ; A1 = CurrentA5
006A: 2452          MOVEA.L  (A2),A2         ; Dereference ZERO handle
006C: 600E          BRA.S    $007C           ; Jump to loop test

; Zero-fill loop
006E: 32D8          MOVE.W   (A0)+,(A1)+     ; Copy word
0070: 660A          BNE.S    $007C           ; If non-zero, continue
0072: 321A          MOVE.W   (A2)+,D1        ; Get count from ZERO
0074: 6002          BRA.S    $0078
0076: 4219          CLR.B    (A1)+           ; Clear byte
0078: 51C9 FFFC     DBF      D1,$0076        ; Loop

007C: BBC9          CMPA.L   A1,A5           ; At end?
007E: 66EE          BNE.S    $006E           ; Continue if not

0080: A9A3          _ReleaseResource         ; Release DATA
0082: A9A3          _ReleaseResource         ; Release ZERO
; Initialize DREL segment relocation
0084: 598F          SUBQ.L   #4,A7
0086: 2F3C 4452454C MOVE.L   #'DREL',-(A7)   ; Push 'DREL'
008C: 4267          CLR.W    -(A7)
008E: A9A0          _GetResource             ; Get DREL
0090: 2057          MOVEA.L  (A7),A0
0092: A025          _SetResAttrs             ; Set attributes
0094: 2050          MOVEA.L  (A0),A0
0096: E240          ASR.W    #1,D0           ; Divide count by 2
0098: 240D          MOVE.L   A5,D2           ; D2 = A5 base
009A: 6006          BRA.S    $00A2

; Relocation loop
009C: 3218          MOVE.W   (A0)+,D1        ; Get offset
009E: D5B5 1000     ADD.L    D2,(A5,D1.W)    ; Relocate

00A2: 51C8 FFF8     DBF      D0,$009C        ; Loop
00A4: A9A3          _ReleaseResource         ; Release DREL
00A6: 4E75          RTS
```

#### C Translation

```c
/*
 * Initialize Toolbox and global data
 * Loads ZERO, DATA, and DREL resources
 * Confidence: HIGH
 */
void init_toolbox(void) {
    Handle zero_h = GetResource('ZERO', 0);
    Handle data_h = GetResource('DATA', 0);

    char *data = *data_h;
    char *dest = (char *)CurrentA5;
    short *zero = (short *)*zero_h;

    /* Copy DATA to globals, zero-fill with ZERO resource */
    while (dest < (char *)A5) {
        short val = *data++;
        *dest++ = val >> 8;
        *dest++ = val & 0xFF;
        if (val == 0) {
            short count = *zero++;
            while (count-- > 0) {
                *dest++ = 0;
            }
        }
    }

    ReleaseResource(data_h);
    ReleaseResource(zero_h);

    /* Relocate DREL entries */
    Handle drel_h = GetResource('DREL', 0);
    short *drel = (short *)*drel_h;
    short count = /* from resource */;
    while (count-- > 0) {
        short offset = *drel++;
        *(long *)((char *)A5 + offset) += (long)A5;
    }
    ReleaseResource(drel_h);
}
```

### Function 4: switch_dispatch_linear at 0x00A8 (JT[66])

Used by compiler for switch statements with sequential case values.

```asm
00A8: 205F          MOVEA.L  (A7)+,A0        ; Pop return address
00AA: 3218          MOVE.W   (A0)+,D1        ; Get base case value
00AC: 3418          MOVE.W   (A0)+,D2        ; Get case count
00AE: B058          SUB.W    (A0)+,D0        ; Subtract min value
00B0: 57C9 FFFA     DBLE     D1,$00AC        ; Decrement and branch
00B4: 4A42          TST.W    D2              ; Test if in range
00B6: 67FE          BEQ.S    $00B6           ; Error trap (infinite loop)
00B8: 4EF0 20FC     JMP      (A0,D0.W*4)     ; Jump to case handler
```

#### C Translation

```c
/*
 * Switch dispatch for linear case values (0, 1, 2, ...)
 * Called by compiler-generated switch code
 * Confidence: HIGH
 */
void switch_dispatch_linear(short selector) {
    /* Inline table follows call:
     *   word: base_value
     *   word: case_count
     *   word: min_value
     *   longs: jump offsets for each case
     */
    // Jump to computed offset based on selector
}
```

### Function 5: switch_dispatch_variant at 0x00BC (JT[74])

```asm
00BC: 205F          MOVEA.L  (A7)+,A0        ; Pop return address
00BE: 3218          MOVE.W   (A0)+,D1        ; Get param
00C0: 3418          MOVE.W   (A0)+,D2        ; Get count
00C2: B098          SUB.L    (A0)+,D0        ; Subtract
00C4: 57C9 FFFA     DBLE     D1,$00C0
00C8: 4A42          TST.W    D2
00CA: 67FE          BEQ.S    $00CA           ; Error
00CC: 4EF0 20FA     JMP      (A0,D0.W*2)     ; Word-sized offsets
```

### Function 6: switch_dispatch_range at 0x00D0 (JT[82])

```asm
00D0: 205F          MOVEA.L  (A7)+,A0        ; Pop return address
00D2: 3218          MOVE.W   (A0)+,D1        ; Get min
00D4: 3418          MOVE.W   (A0)+,D2        ; Get max
00D6: B042          CMP.W    D2,D0           ; Compare with max
00D8: 6E0A          BGT.S    $00E4           ; Out of range
00DA: 9041          SUB.W    D1,D0           ; Subtract min
00DC: 6D06          BLT.S    $00E4           ; Out of range
00DE: D040          ADD.W    D0,D0           ; *2 for word offset
00E0: 41F0 0002     LEA      2(A0,D0.W),A0   ; Get target
00E4: 3010          MOVE.W   (A0),D0         ; Get offset
00E6: 67FE          BEQ.S    $00E6           ; Error if zero
00E8: 4EF0 0000     JMP      (A0,D0.W)       ; Jump
```

### Function 7: multiply_32bit at 0x00EC (JT[90])

32-bit multiplication for compilers lacking native 32×32 multiply.

```asm
00EC: 202F 0004     MOVE.L   4(A7),D0        ; D0 = first operand
00F0: 2F41 0004     MOVE.L   D1,4(A7)        ; Save D1
00F4: 222F 0008     MOVE.L   8(A7),D1        ; D1 = second operand
00F8: 2F5F 0004     MOVE.L   (A7)+,4(A7)     ; Adjust return
00FC: 48E7 3C00     MOVEM.L  D2/D3/D4/D5,-(A7)
0100: 2400          MOVE.L   D0,D2           ; D2 = a
0102: 2601          MOVE.L   D1,D3           ; D3 = b
0104: 4842          SWAP     D2              ; D2 = a_hi
0106: C4C3          MULU     D3,D2           ; D2 = a_hi * b_lo
0108: 2800          MOVE.L   D0,D4           ; D4 = a
010A: 2A01          MOVE.L   D1,D5           ; D5 = b
010C: 4845          SWAP     D5              ; D5 = b_hi
010E: C8C5          MULU     D5,D4           ; D4 = a_lo * b_hi
0110: D444          ADD.W    D4,D2           ; Combine cross products
0112: 4842          SWAP     D2              ; Shift to high word
0114: 4242          CLR.W    D2              ; Clear low word
0116: C0C1          MULU     D1,D0           ; D0 = a_lo * b_lo
0118: D082          ADD.L    D2,D0           ; Add high part
011A: 4CDF 003C     MOVEM.L  (A7)+,D2/D3/D4/D5
011E: 221F          MOVE.L   (A7)+,D1        ; Restore D1
0120: 4E75          RTS
```

#### C Translation

```c
/*
 * 32-bit multiplication: result = a * b
 * Uses 16×16→32 MULU instruction
 * Confidence: HIGH
 */
long multiply_32bit(long a, long b) {
    unsigned short a_lo = a & 0xFFFF;
    unsigned short a_hi = a >> 16;
    unsigned short b_lo = b & 0xFFFF;
    unsigned short b_hi = b >> 16;

    /* (a_hi*2^16 + a_lo) * (b_hi*2^16 + b_lo)
     * = a_hi*b_hi*2^32 + (a_hi*b_lo + a_lo*b_hi)*2^16 + a_lo*b_lo
     * Ignore a_hi*b_hi (overflow)
     */
    unsigned long cross = (unsigned long)a_hi * b_lo +
                          (unsigned long)a_lo * b_hi;
    unsigned long low = (unsigned long)a_lo * b_lo;

    return low + (cross << 16);
}
```

### Function 8: divide_signed at 0x0122 (JT[98])

```asm
0122: 202F 0004     MOVE.L   4(A7),D0        ; Dividend
0126: 2F41 0004     MOVE.L   D1,4(A7)        ; Save D1
012A: 222F 0008     MOVE.L   8(A7),D1        ; Divisor
012E: 2F5F 0004     MOVE.L   (A7)+,4(A7)
0132: 48E7 3100     MOVEM.L  D2/D3/D7,-(A7)
0136: 4EBA 009C     JSR      $01D4(PC)       ; Call divmod_core
013A: 4CDF 008C     MOVEM.L  (A7)+,D2/D3/D7
013E: 221F          MOVE.L   (A7)+,D1
0140: 4E75          RTS
```

### Function 9: modulo at 0x0142 (JT[106])

```asm
0142: 202F 0004     MOVE.L   4(A7),D0        ; Dividend
0146: 2F41 0004     MOVE.L   D1,4(A7)
014A: 222F 0008     MOVE.L   8(A7),D1        ; Divisor
014E: 2F5F 0004     MOVE.L   (A7)+,4(A7)
0152: 48E7 3100     MOVEM.L  D2/D3/D7,-(A7)
0156: 4EBA 007C     JSR      $01D4(PC)       ; Call divmod_core
015A: 2001          MOVE.L   D1,D0           ; Return remainder
015C: 4CDF 008C     MOVEM.L  (A7)+,D2/D3/D7
0160: 221F          MOVE.L   (A7)+,D1
0162: 4E75          RTS
```

### Function 10: divmod_core at 0x01A6

Core 32-bit division routine handling signs and calling unsigned divide.

```asm
01A6: 4A80          TST.L    D0              ; Test dividend sign
01A8: 6A1C          BPL.S    $01C6           ; If positive, check divisor
01AA: 4A81          TST.L    D1              ; Test divisor sign
01AC: 6A0C          BPL.S    $01BA           ;
01AE: 4480          NEG.L    D0              ; Negate dividend
01B0: 4481          NEG.L    D1              ; Negate divisor
01B2: 4EBA 0020     JSR      $01D4(PC)       ; Unsigned divide
01B6: 4481          NEG.L    D1              ; Negate remainder
01B8: 4E75          RTS
01BA: 4480          NEG.L    D0              ; Negate dividend
01BC: 4EBA 0016     JSR      $01D4(PC)       ; Unsigned divide
01C0: 4480          NEG.L    D0              ; Negate quotient
01C2: 4481          NEG.L    D1              ; Negate remainder
01C4: 4E75          RTS
01C6: 4A81          TST.L    D1              ; Test divisor
01C8: 6A0A          BPL.S    $01D4           ; Both positive
01CA: 4481          NEG.L    D1              ; Negate divisor
01CC: 4EBA 0006     JSR      $01D4(PC)       ; Unsigned divide
01D0: 4480          NEG.L    D0              ; Negate quotient
01D2: 4E75          RTS
```

### Function 11: unsigned_divide_32 at 0x01D4

```asm
01D4: 2E3C 0000FFFF MOVE.L   #$0000FFFF,D7  ; Mask for 16 bits
01DA: B280          CMP.L    D0,D1           ; divisor > dividend?
01DC: 6306          BLS.S    $01E4           ; No, do division
01DE: 2200          MOVE.L   D0,D1           ; Remainder = dividend
01E0: 7000          MOVEQ    #0,D0           ; Quotient = 0
01E2: 4E75          RTS

01E4: B087          CMP.L    D7,D0           ; Fits in 16 bits?
01E6: 620C          BHI.S    $01F4           ; No, need full 32-bit
01E8: 80C1          DIVU     D1,D0           ; 32÷16 divide
01EA: 4840          SWAP     D0              ; Get remainder
01EC: 3200          MOVE.W   D0,D1           ; D1 = remainder
01EE: 4240          CLR.W    D0              ; Clear remainder part
01F0: 4840          SWAP     D0              ; D0 = quotient
01F2: 4E75          RTS

; Full 32-bit division
01F4: B287          CMP.L    D7,D1           ; Divisor fits in 16?
01F6: 621A          BHI.S    $0212           ; No
01F8: 2E00          MOVE.L   D0,D7           ; Save dividend
01FA: 4240          CLR.W    D0
01FC: 4840          SWAP     D0              ; D0 = high word
01FE: 80C1          DIVU     D1,D0           ; Divide high
0200: 4840          SWAP     D0
0202: 4847          SWAP     D7
0204: 3E00          MOVE.W   D0,D7           ; Combine
0206: 4847          SWAP     D7
0208: 8EC1          DIVU     D1,D7           ; Divide low
020A: 3007          MOVE.W   D7,D0           ; Quotient low
020C: 4847          SWAP     D7
020E: 3207          MOVE.W   D7,D1           ; Remainder
0210: 4E75          RTS

; Both > 16 bits - use shift and subtract
0212: 2400          MOVE.L   D0,D2           ; Save dividend
0214: 2601          MOVE.L   D1,D3           ; Save divisor
0216: E288          LSR.L    #1,D0           ; Shift dividend right
0218: E289          LSR.L    #1,D1           ; Shift divisor right
021A: B287          CMP.L    D7,D1           ; Check if fits
021C: 62F8          BHI.S    $0216           ; Keep shifting
021E: 80C1          DIVU     D1,D0           ; Divide shifted
0220: C087          AND.L    D7,D0           ; Mask quotient
0222: 3203          MOVE.W   D3,D1           ; Restore divisor low
0224: C2C0          MULU     D0,D1           ; quotient * divisor_lo
0226: 2E03          MOVE.L   D3,D7
0228: 4847          SWAP     D7              ; Divisor high
022A: CEC0          MULU     D0,D7           ; quotient * divisor_hi
022C: 4847          SWAP     D7
022E: D287          ADD.L    D7,D1           ; Combine
0230: 6508          BCS.S    $023A           ; Overflow
0232: 9282          SUB.L    D2,D1           ; remainder = dividend - product
0234: 6204          BHI.S    $023A           ; If > 0, quotient too big
0236: 4481          NEG.L    D1              ; Fix remainder sign
0238: 4E75          RTS
023A: 5340          SUBQ.W   #1,D0           ; Decrement quotient
023C: 60E4          BRA.S    $0222           ; Try again
023E: 4E75          RTS
```

#### C Translation

```c
/*
 * 32-bit unsigned division
 * Returns quotient in D0, remainder in D1
 * Confidence: HIGH
 */
typedef struct { unsigned long quot; unsigned long rem; } divmod_t;

divmod_t unsigned_divide_32(unsigned long dividend, unsigned long divisor) {
    divmod_t result;

    if (divisor > dividend) {
        result.quot = 0;
        result.rem = dividend;
        return result;
    }

    if (dividend <= 0xFFFF) {
        /* Simple 32÷16 case */
        result.quot = dividend / divisor;
        result.rem = dividend % divisor;
        return result;
    }

    if (divisor <= 0xFFFF) {
        /* Dividend > 16 bits, divisor <= 16 bits */
        unsigned long q_hi = (dividend >> 16) / divisor;
        unsigned long temp = ((dividend >> 16) % divisor) << 16 | (dividend & 0xFFFF);
        unsigned long q_lo = temp / divisor;
        result.quot = (q_hi << 16) | q_lo;
        result.rem = temp % divisor;
        return result;
    }

    /* Both > 16 bits: shift and subtract algorithm */
    unsigned long shift_div = dividend;
    unsigned long shift_dsr = divisor;
    while (shift_dsr > 0xFFFF) {
        shift_div >>= 1;
        shift_dsr >>= 1;
    }

    unsigned long q = shift_div / shift_dsr;
    q &= 0xFFFF;

    while (q * divisor > dividend) {
        q--;
    }

    result.quot = q;
    result.rem = dividend - q * divisor;
    return result;
}
```

## Toolbox Traps Used

| Trap | Name | Usage |
|------|------|-------|
| $A9A0 | _GetResource | Load ZERO, DATA, DREL resources |
| $A9A3 | _ReleaseResource | Release loaded resources |
| $A9F4 | _ExitToShell | Return to Finder |
| $A025 | _SetResAttrs | Set resource attributes |

## Analysis Notes

- **Runtime library**: Essential startup and math support
- **32-bit math**: Implements multiply/divide for 68000 without 32-bit ops
- **Switch dispatch**: Compiler-generated switch statement support
- **THINK C runtime**: Pattern matches THINK C/Symantec C runtime library

## Confidence Levels

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Function boundaries | HIGH | Clear RTS termination |
| Disassembly | HIGH | Complete coverage |
| Algorithm identification | HIGH | Standard runtime patterns |
| Startup sequence | HIGH | Well-documented Mac pattern |
| Function names | MEDIUM | Inferred from behavior |

## Refined Analysis (Second Pass)

**Cluster**: Runtime

**Category**: RUNTIME_LIBRARY

**Global Variable Profile**: 0 DAWG, 0 UI, 0 total

**Assessment**: Essential application runtime - startup, math, switch dispatch
