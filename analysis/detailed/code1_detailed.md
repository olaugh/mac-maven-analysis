# CODE 1 Detailed Analysis - Runtime Initialization & Math Library

## Overview

| Property | Value |
|----------|-------|
| Size | 574 bytes |
| JT Offset | 0 |
| JT Entries | 10 |
| Functions | ~8 |
| Purpose | **Runtime initialization, division routines, math support** |


## System Role

**Category**: Core System
**Function**: Init/Cleanup

Application initialization and cleanup routines
## Architecture Role

CODE 1 is loaded at startup and contains:
1. Application initialization code
2. 32-bit division routines (signed and unsigned)
3. Runtime support for the C compiler

## Key Functions

### Function 0x0000-0x0042 - Application Entry Point
```asm
0000: 000001BA      ORI.B      #$01BA,D0      ; Header data
0008: CLR.W      $0A4A.W                      ; Clear low memory
000E: JSR        52(PC)                       ; Initialize something
0012: JSR        36(PC)                       ; Initialize something else
0016: CLR.W      -(A7)                        ; Push 0
0018: PEA        $0000FFFF                    ; Push -1/0xFFFF
001E: PEA        4(A7)                        ; Push stack address
0022: PEA        (A7)                         ; Push stack address
0024: PEA        $0001.W                      ; Push 1
002C: JSR        0(A5,D1.W)                   ; Jump table call
0030: MOVEA.L    108(A5),A0                   ; Get function pointer
0034: JSR        (A0)                         ; Call main routine
0042: RTS
```

**Purpose**: This is the C runtime startup code that initializes the application environment before calling the main program.

### Functions 0x00EA-0x01A2 - Division Support Routines

These are 32-bit arithmetic routines for signed/unsigned division:

```asm
; 0x00EA - Unsigned 32-bit division setup
00EA: MOVE.L     4(A7),D0        ; Get dividend
00EE: MOVE.L     D1,4(A7)        ; Save D1
00F2: MOVE.L     8(A7),D1        ; Get divisor
00F6: MOVE.L     (A7)+,4(A7)     ; Adjust stack
00FA: MOVEM.L    D2/D3/D4/D5,-(SP)  ; Save registers
...
011C: MOVE.L     (A7)+,D1
011E: RTS

; 0x0120 - Signed 32-bit division (quotient)
0120: MOVE.L     4(A7),D0
...
0134: JSR        156(PC)         ; Call division core
...
013E: RTS

; 0x0140 - Signed 32-bit division (remainder)
0140: MOVE.L     4(A7),D0
...
0154: JSR        124(PC)         ; Call division core
0158: MOVE.L     D1,D0           ; Return remainder
...
0160: RTS
```

### Function 0x01A4-0x0238 - Division Core Algorithm
```asm
; Handle signs for signed division
01A4: TST.L      D0              ; Test dividend sign
01A6: BPL.S      $01C4           ; If positive, skip
01A8: TST.L      D1              ; Test divisor sign
01AA: BPL.S      $01B8
01AC: NEG.L      D0              ; Negate both
01AE: NEG.L      D1
01B0: JSR        32(PC)          ; Do unsigned division
01B4: NEG.L      D1              ; Negate remainder
01B6: RTS

; Unsigned division core at 0x01D2
01D2: MOVE.L     #$0000FFFF,D7   ; 16-bit mask
01D8: CMP.L      D0,D1           ; Compare divisor to dividend
01DA: BLS.S      $01E2           ; If divisor <= dividend, do divide
01DC: MOVE.L     D0,D1           ; Else: quotient=0, remainder=dividend
01DE: MOVEQ      #0,D0
01E0: RTS

01E2: CMP.L      D7,D0           ; Check if fits in 16 bits
01E4: BHI.S      $01F2
01E6: DIVU.W     D1,D0           ; 16-bit divide
01E8: SWAP       D0
01EA: MOVE.W     D0,D1           ; D1 = remainder
01EC: CLR.W      D0
01EE: SWAP       D0              ; D0 = quotient
01F0: RTS

01F2: ... ; Long division for large numbers
```

**C equivalent**:
```c
typedef struct {
    long quotient;
    long remainder;
} divmod_result;

divmod_result divmod_signed(long dividend, long divisor) {
    int neg_q = 0, neg_r = 0;

    if (dividend < 0) {
        dividend = -dividend;
        neg_q = !neg_q;
        neg_r = 1;
    }
    if (divisor < 0) {
        divisor = -divisor;
        neg_q = !neg_q;
    }

    divmod_result r = divmod_unsigned(dividend, divisor);
    if (neg_q) r.quotient = -r.quotient;
    if (neg_r) r.remainder = -r.remainder;
    return r;
}
```

### Dispatch Tables (0x00A6-0x00E8)

These are table-driven dispatch routines for optimized case handling:

```asm
; 0x00A6 - Word dispatch
00A6: MOVEA.L    (A7)+,A0        ; Get return address (points to table)
00A8: MOVE.W     (A0)+,D1        ; Get count
00AA: MOVE.W     (A0)+,D2        ; Get value to compare
00AC: CMP.W      (A0)+,D0        ; Compare with D0
00AE: DBEQ       D1,$00AA        ; Loop until match or done
00B2: TST.W      D2
00B4: BEQ.S      $00B4           ; Error: infinite loop if no match
00B6: JMP        -4(A0,D2.W)     ; Jump to handler

; 0x00CE - Signed range dispatch
00CE: MOVEA.L    (A7)+,A0
00D0: MOVE.W     (A0)+,D1        ; Get min
00D2: MOVE.W     (A0)+,D2        ; Get max
00D4: CMP.W      D2,D0           ; Check if in range
00D6: BGT.S      $00E2           ; Too big
00D8: SUB.W      D1,D0           ; Subtract min
00DA: BLT.S      $00E2           ; Too small
00DC: ADD.W      D0,D0           ; Index * 2
00DE: LEA        2(A0,D0.W),A0   ; Point to entry
00E2: MOVE.W     (A0),D0         ; Get offset
00E4: BEQ.S      $00E4           ; Error if zero
00E6: JMP        0(A0,D0.W)      ; Jump to handler
```

## Compiler Runtime Functions

CODE 1 provides standard C runtime support:

| Offset | Purpose |
|--------|---------|
| 0x00EA | Unsigned 32-bit division |
| 0x0120 | Signed 32-bit division (quotient) |
| 0x0140 | Signed 32-bit division (remainder) |
| 0x0162 | Combined divide/modulo |
| 0x0182 | Modulo only |
| 0x01A4 | Sign handling |
| 0x01D2 | Unsigned core |

## Why This Matters

The 68000 CPU doesn't have 32-bit division instructions (only DIVU/DIVS for 32÷16→16). CODE 1 implements full 32-bit division in software, which is essential for:
- Score calculations
- Search depth management
- Time calculations

## Jump Table Mapping

| JT Offset | Function | Purpose |
|-----------|----------|---------|
| ~66-74 | Various | Runtime entry points |

## Confidence: HIGH

This is standard 68K C runtime code. The patterns are unmistakable:
- Stack setup/teardown
- Register save/restore with MOVEM
- Division algorithm with sign handling
- Table-driven dispatch
