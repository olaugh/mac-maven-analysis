# CODE 32 Leave Calculation Analysis

## Location in CODE 32

The leave value calculation is a complete function at offset **0x1406** within CODE 32 (from the 6464-byte QEMU memory dump). Frame size: 50 bytes.

## Algorithm: Binomial-Weighted Leave Average

The function computes a **hypergeometric-weighted average** of per-tile-count leave adjustments. It does NOT simply look up a single value.

### Parameters

| Parameter | Register | Description |
|-----------|----------|-------------|
| 8(A6) | D5 | Tile letter (ASCII, converted to 0-26 index) |
| 10(A6) | D6 | Tile distribution count |
| 12(A6) | - | Unseen tile count (used for binomial lookup) |

Early checks:
- If D6 < 7: return 0 (no leave adjustment needed)
- If tile == '?': letter index = 0 (blank)
- Otherwise: letter index = tile - 96 (a=1, b=2, ..., z=26)

### Step 1: Binomial Coefficient Table (0x143A-0x1504)

Allocates and fills an 8080-byte buffer (stored at A5-2448):
- **101 entries × 80 bytes** per entry
- Each entry = 8 × 10-byte SANE extended values
- Initialized: `entry[n][0] = 1.0`, `entry[n][1..7] = 0.0`

Built using Pascal's triangle recurrence:
```
entry[i][j] = entry[i-1][j] + entry[i-1][j-1]
```
Result: `entry[n][k] = C(n,k)` (binomial coefficient) in 80-bit SANE extended precision.

### Step 2: Load MUL Data (0x154E-0x156E)

```asm
; Compute array index from letter
204D      MOVEA.L A5,A0
2005      MOVE.L  D5,D0           ; letter index
48C0      EXT.L   D0
E588      LSL.L   #2,D0           ; × 4 (pointer size)
D1C0      ADDA.L  D0,A0           ; A0 = A5 + index*4
2468 D58C MOVEA.L -10868(A0),A2   ; A2 = MUL_handles[letter] (for indexed access)
; ... (same computation for A0)
2068 D58C MOVEA.L -10868(A0),A0   ; A0 = MUL_handles[letter] (for baseline)
2D68 0018 FFDC MOVE.L 24(A0),-36(A6) ; baseline = MUL_record[0].adj
```

### Step 3: Main Weighted Average Loop (0x1578-0x1600)

Two SANE extended accumulators:
- **local_30** (-30(A6)): Sum of binomial weights
- **local_20** (-20(A6)): Sum of relative leave adjustments

```asm
; Loop body (D4 = tile count iterator):
; --- Binomial weight computation ---
3003      MOVE.W  D3,D0
9044      SUB.W   D4,D0            ; D0 = D3 - D4
C1FC 000A MULS.W  #10,D0           ; offset into 10-byte SANE array
; Copy binom[param_n][D4] to local_46
; FMULX: local_46 *= binom[D6][D3-D4]
;   = C(param_n, D4) × C(D6, D3-D4)
; FADDX: local_30 += product (accumulate weight)

; --- Leave adjustment ---
7001      MOVEQ   #1,D0
D044      ADD.W   D4,D0            ; D0 = D4 + 1
C1FC 001C MULS.W  #28,D0           ; D0 = (D4+1) × 28 (record offset)
2032 0818 MOVE.L  (24,A2,D0.L),D0  ; D0 = MUL_data[(D4+1)*28 + 24]
                                    ;     = MUL_record[D4+1].leave_adj
90AE FFDC SUB.L   -36(A6),D0       ; D0 -= baseline (record 0)
                                    ; = RELATIVE adjustment
; FL2X: convert D0 to SANE extended
; FADDX: local_20 += extended(relative_adj)

; Loop increment:
5244      ADDQ.W  #1,D4            ; D4++
```

**Key indexed addressing** at 0x15BE:
```
2032 0818 = MOVE.L (24,A2,D0.L),D0
```
Extension word 0x0818: D0.L index, displacement 24 (= offset within 28-byte record).
Effective: `MUL_data[(D4+1)*28 + 24]` = offset-24 of MUL record (D4+1).

### Step 4: Post-Loop Normalization (0x1604-0x163A)

```asm
; Divide: adj_sum / weight_sum → weighted average
486E FFE2 PEA     -30(A6)          ; source: weight sum
486E FFEC PEA     -20(A6)          ; dest: adj sum
3F3C 0006 MOVE.W  #$0006,-(SP)     ; FDIVX
A9EB      _FP68K                    ; local_20 /= local_30

; Convert SANE extended result to 32-bit integer
; Copy local_20 → local_50
; FX2L ($2810): convert extended to long integer
; D0 = local_40 → return value in centipoints
```

### Result

```
leave_value = Σ(MUL[i+1].adj - MUL[0].adj) / Σ(C(n,i) × C(m,j-i))
```

Where:
- `i` iterates over possible tile counts
- `MUL[k].adj` = leave adjustment for having k copies of this tile (offset 24)
- `C(n,k)` = binomial coefficients from the Pascal's triangle table
- The denominator is a Vandermonde convolution: `Σ C(n,i)×C(m,j-i) = C(n+m,j)`

## SANE Operations Summary

| Offset | Opcode | Operation | Purpose |
|--------|--------|-----------|---------|
| 0x14DC | $0000 | FADDX | Pascal's triangle: C(i,j) = C(i-1,j) + C(i-1,j-1) |
| 0x159A | $0004 | FMULX | Binomial weight: C(n,i) × C(m,j-i) |
| 0x15B4 | $0000 | FADDX | Accumulate weight sum |
| 0x15E4 | $2804 | FL2X | Convert integer adj to extended |
| 0x15F0 | $0000 | FADDX | Accumulate adj sum |
| 0x1610 | $0006 | FDIVX | Normalize: adj_sum / weight_sum |
| 0x162C | $0016 | (convert) | Round/normalize result |
| 0x163A | $2810 | FX2L | Convert extended to long integer |

## MUL Record Access Pattern

The function accesses **multiple MUL records**, not just record 0:

| Record | Meaning | Example (Blank) |
|--------|---------|-----------------|
| 0 | Baseline (0 copies) | -515 (-5.15 pts) |
| 1 | Have 1 copy | +2440 (+24.40 pts) |
| 2 | Have 2 copies | +3851 (+38.51 pts) |
| 3+ | Have 3+ copies | 0 (if tile count < 3) |

**Relative adjustments** (subtracting baseline):
| Record | Relative (Blank) | Relative (S) | Relative (Q) |
|--------|------------------|--------------|--------------|
| 1 | +2955 (+29.55 pts) | +1058 (+10.58 pts) | -967 (-9.67 pts) |
| 2 | +4366 (+43.66 pts) | +1147 (+11.47 pts) | N/A |

## Scale Problem: RESOLVED

The previously reported "scale problem" (blank = +5.15 pts from record 0 vs expected +25 pts) was a misunderstanding:
- Record 0 adj = -515 is the **baseline** (having 0 blanks)
- The actual leave value comes from the **binomial-weighted average** of per-count adjustments
- The FMULX is multiplying **binomial coefficients**, not a scalar factor

## Global References

| Global | Offset | Purpose |
|--------|--------|---------|
| MUL handles array | A5-10868 | 27 pointers to per-letter MUL data |
| Binomial table | A5-2448 | 8080-byte C(n,k) table (allocated on first call) |
| JT[418] | 418(A5) | bounds_error (allocation failure handler) |
| JT[1666] | 1666(A5) | Memory allocation (NewPtr) |
