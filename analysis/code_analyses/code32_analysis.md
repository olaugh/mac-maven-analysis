# CODE 32 Analysis - Leave Calculation

## Overview

| Property | Value |
|----------|-------|
| Size | **2,320 bytes** (VERIFIED) |
| JT Offset | 2384 (0x0950) |
| JT Entries | 13 |
| Category | CORE_AI, SCORING |
| Confidence | **MEDIUM** - key constants verified, algorithm partially understood |

---

## Verified Disassembly

### Function 0x0004: Main Entry
**Stack Frame**: -324 bytes (VERIFIED: `LINK A6,#-324`)
**Saved Registers**: D3-D7, A2-A4

```asm
; Function prologue
0004: 4E56 FEBC    LINK     A6,#-324          ; 324-byte local frame
0008: 48E7 1F38    MOVEM.L  D3-D7/A2-A4,-(SP) ; Save registers

; Initialize counters to zero
000C: 426D BCFA    CLR.W    -17158(A5)        ; Counter 1
0010: 426D BCF8    CLR.W    -17160(A5)        ; Counter 2
0014: 426D BCF6    CLR.W    -17162(A5)        ; Counter 3
0018: 426D BCF4    CLR.W    -17164(A5)        ; Counter 4
001C: 426D B1D6    CLR.W    -20010(A5)        ; tiles_played = 0
```

### Bingo Bonus Check at 0x032C (VERIFIED)

```asm
0328: 4EAD 01A2    JSR      418(A5)           ; bounds_check
032C: 0C6D 0007 B1D6  CMPI.W #7,-20010(A5)   ; tiles_played == 7?
0332: 6606         BNE.S    $033A             ; No → skip bonus
0334: 303C 1388    MOVE.W   #$1388,D0         ; D0 = 5000 ★ BINGO BONUS
0338: 6002         BRA.S    $033C             ; Skip zero case
033A: 7000         MOVEQ    #0,D0             ; D0 = 0 (no bonus)
```

**CONFIRMED**: Bingo bonus = **5000 centipoints** (0x1388) = **50 points**

### Additional Check for 8 Tiles at 0x0138

```asm
0138: 0C6D 0008 B1D6  CMPI.W #8,-20010(A5)   ; tiles_played == 8?
```

Purpose unclear - possibly validation or edge case handling.

### Function Epilogue at 0x0648

```asm
0648: 4CDF 1CF8    MOVEM.L  (SP)+,D3-D7/A2-A4 ; Restore registers
064C: 4E5E         UNLK     A6
064E: 4E75         RTS
```

---

## Jump Table Calls (VERIFIED)

| JT Offset | Count | Known Purpose |
|-----------|-------|---------------|
| 66(A5) | 14 | Multiply (CODE 1) |
| 418(A5) | 10 | Bounds check / error |
| 426(A5) | 2 | memset |
| 794(A5) | 1 | Unknown |
| 2338(A5) | 1 | Unknown |
| 2386(A5) | 1 | Unknown |
| 2394(A5) | 1 | Setup function |
| 3522(A5) | 2 | strlen |

The heavy use of JT[66] (multiply, 14 calls) indicates table indexing is central to the algorithm.

---

## Global Variables (VERIFIED)

| Offset | Initialized To | Purpose |
|--------|----------------|---------|
| A5-17158 | 0 | Counter 1 |
| A5-17160 | 0 | Counter 2 |
| A5-17162 | 0 | Counter 3 |
| A5-17164 | 0 | Counter 4 |
| A5-20010 | 0 | **tiles_played** (compared with 7 and 8) |

---

## What We Don't Know

The detailed leave evaluation algorithm is not fully understood. The code likely:
1. Uses the VCB resources (VCBa-VCBh) for vowel/consonant balance lookups
2. Indexes into precomputed tables (hence all the multiply calls)
3. Combines multiple factors beyond just bingo bonus

**I cannot confirm**:
- ❌ Specific vowel-counting logic
- ❌ Q-without-U penalty
- ❌ Detailed scoring formula
- ❌ How VCB resources are accessed

---

## Summary

| Aspect | Status |
|--------|--------|
| File size (2,320 bytes) | ✅ VERIFIED |
| Stack frame (-324) | ✅ VERIFIED |
| Bingo bonus (5000 = 50pts) | ✅ VERIFIED |
| tiles_played at A5-20010 | ✅ VERIFIED |
| JT call list | ✅ VERIFIED |
| Detailed algorithm | ❓ NEEDS MORE WORK |
