# Maven Leave Value System - Complete Analysis

## Overview

Maven evaluates rack leaves (tiles remaining after a play) using a multi-component system that combines:
1. **Per-tile values** from MUL resources (27 resources: MULa-MULz plus MUL?)
2. **Vowel count adjustments** from VCB resources (VCBh contains actual data)
3. **Synergy patterns** from ESTR resource (130 patterns, values computed at runtime by CODE 39)

All leave adjustments are stored in **centipoints** (1/100 of a point).

---

## 1. MUL Resources (Per-Tile Leave Values)

### Structure

Each MUL resource (MULa through MULz, plus MUL? for blanks) contains **8 records of 28 bytes each**, indexed by the count of that tile on the rack (0-7 copies).

**Record Format (28 bytes):**
| Offset | Size | Type | Description |
|--------|------|------|-------------|
| 0-7 | 8 | IEEE 754 double (big-endian) | Expected turn score from simulation |
| 8-15 | 8 | IEEE 754 double (big-endian) | Secondary value (purpose unclear) |
| 16-19 | 4 | uint32 (big-endian) | Simulation sample count |
| 20-23 | 4 | int32 (big-endian) | Unknown |
| 24-27 | 4 | int32 (big-endian) | **Leave adjustment in centipoints** |

### Loading

MUL resources are loaded by CODE 15 at offset 0x0C62-0x0C8A:
- Loop iterates 27 times (0x001B)
- Resource handles stored at A5-10868 (array of 27 4-byte handles)
- Resource type constructed as 'MUL' + letter character

### Usage

CODE 32 at offset 0x156A-0x15C4 applies MUL adjustments:
```asm
; Load MUL handle for tile
2468 D58C     MOVEA.L -10868(A0),A2    ; Get handle array base
2068 D58C     MOVEA.L -10868(A0),A0    ; Dereference handle
2D68 0018 FFDC MOVE.L 24(A0),-36(A6)   ; Load offset-24 to local var

; Later, apply adjustment
90AE FFDC     SUB.L -36(A6),D0         ; SUBTRACT from accumulator
```

**Sign Convention:** The adjustment is **subtracted**, so:
- Negative raw value = bonus (good tile to keep)
- Positive raw value = penalty (bad tile to keep)

### Extracted Single-Tile Values (count=1)

| Tile | Raw Adj | Points | Assessment |
|------|---------|--------|------------|
| ? (blank) | +2440 | +24.40 | Excellent |
| S | +721 | +7.21 | Excellent |
| X | +419 | +4.19 | Very good |
| Z | +359 | +3.59 | Very good |
| E | +299 | +2.99 | Good |
| R | +245 | +2.45 | Good |
| A | +220 | +2.20 | Good |
| N | +199 | +1.99 | Good |
| D | +188 | +1.88 | Good |
| T | +148 | +1.48 | Moderate |
| I | +150 | +1.50 | Moderate |
| H | +136 | +1.36 | Moderate |
| L | +122 | +1.22 | Moderate |
| O | +26 | +0.26 | Neutral |
| G | +11 | +0.11 | Neutral |
| C | +1 | +0.01 | Neutral |
| U | -88 | -0.88 | Slight penalty |
| Y | -68 | -0.68 | Slight penalty |
| P | -117 | -1.17 | Penalty |
| M | -130 | -1.30 | Penalty |
| K | -134 | -1.34 | Penalty |
| B | -163 | -1.63 | Penalty |
| F | -202 | -2.02 | Penalty |
| W | -294 | -2.94 | Penalty |
| J | -369 | -3.69 | Bad |
| V | -498 | -4.98 | Bad |
| Q | -879 | -8.79 | Very bad |

### Multi-Copy Diminishing Returns

Keeping duplicate tiles generally has diminishing value:

| Tile | 1 copy | 2 copies | 3 copies | 4 copies |
|------|--------|----------|----------|----------|
| E | +2.99 | +3.78 | +1.11 | -2.38 |
| S | +7.21 | +11.90 | +12.60 | N/A |
| Blank | +24.40 | +39.18 | N/A | N/A |
| A | +2.20 | +1.67 | -2.56 | -7.32 |

---

## 2. VCB Resources (Vowel Count Balance)

### Structure

Eight VCB resources exist (VCBa through VCBh), but **only VCBh contains actual data** - VCBa through VCBg are all zeros and may be placeholders or runtime buffers.

VCBh uses the same 28-byte record format as MUL resources, with 8 records indexed by vowel count (0-7 vowels).

### Loading

VCB resources are loaded by CODE 15 at offset 0x0C3A-0x0C54:
- Loop iterates 8 times
- Resource handles stored at A5-10900 (array of 8 4-byte handles)
- Resource type constructed as 'VCB' + letter ('a' through 'h')

### VCBh Vowel Count Adjustments

| Vowels | Raw Adj | Points | Assessment |
|--------|---------|--------|------------|
| 0 | -756 | -7.56 | Poor (all consonants) |
| 1 | -273 | -2.73 | Suboptimal |
| 2 | -19 | -0.19 | Okay |
| 3 | +23 | +0.23 | Good |
| 4 | +368 | +3.68 | Optimal |
| 5 | +134 | +1.34 | Good |
| 6 | -281 | -2.81 | Suboptimal |
| 7 | -1238 | -12.38 | Poor (all vowels) |

**Observation:** The optimal vowel count is 4 vowels in a 7-tile rack (approximately 57% vowels).

### Usage

CODE 32 accesses VCB handles at A5-10904 and A5-10908 (offsets within the handle array). The exact application logic is unclear from the partially-corrupted disassembly, but it appears to be applied based on the vowel count of the leave.

---

## 3. ESTR Resource (Synergy Patterns)

### Structure

The ESTR resource (536 bytes) contains 130 null-terminated pattern strings used for combination/synergy scoring.

### Pattern Categories

**Single letters (base reference):**
```
?, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
```

**Duplicate letter patterns:**
```
??, aa, aaa, aaaa, aaaaa
bb, cc, dd, ddd, dddd
ee, eee, eeee, eeeee, eeeeee
ff, gg, ggg, hh
ii, iii, iiii, iiiii
ll, lll, llll, mm
nn, nnn, nnnn
oo, ooo, oooo, ooooo
pp, rr, rrr, rrrr
ss, sss, ssss
tt, ttt, tttt
uu, uuu, uuuu, vv, ww, yy
```

**Consonant digraphs:**
```
ch, ck
```

**Q-related patterns:**
```
qu     - Q with U (traditional synergy)
aq     - Q + A (QAT hook potential)
aiq    - Q + A + I (QI playable, QAID potential)
adq    - Q + A + D (QADI potential)
aqt    - Q + A + T (QAT potential)
adiq   - Q + A + D + I (multiple Q-without-U words)
```

**Suffix/prefix patterns:**
```
gin, flu, ily, ino, inot, ity
osu, otu, eiv, eiz
amn, emn, boy, bel, ery, ary, fiy
elss, enss, imu
```

**Vowel/consonant balance:**
```
aeiou  - All five vowels
iu, uw - Vowel pairs
```

**Consonant clusters:**
```
bgjkf, mpxhwy, udlnrst, jx
dg, fhkwvy, bcmp, lnrtsu
fhwyx, dgbmp, fhkjwyx
```

### Value Computation

**Important:** ESTR only stores the pattern strings, not their values. The synergy values are computed at runtime by CODE 39 using the six score tables at A5-12512 through A5-12532.

CODE 39 uses a 9632-byte stack frame for exhaustive letter combination analysis:
1. Collects valid letter pairs from rack
2. Generates all pair combinations
3. Looks up scores from direction-specific tables (hook-before/hook-after)
4. Applies multi-letter combination bonuses

---

## 4. Total Leave Evaluation

### Formula

```
Total Leave Value = Sum(MUL adjustments for each tile) + VCBh adjustment for vowel count + Synergy adjustments
```

### Example: Evaluating "SATIRE"

1. **MUL adjustments (per-tile):**
   - S (1 copy): +721 centipoints
   - A (1 copy): +220 centipoints
   - T (1 copy): +148 centipoints
   - I (1 copy): +150 centipoints
   - R (1 copy): +245 centipoints
   - E (1 copy): +299 centipoints
   - **Subtotal: +1783 centipoints = +17.83 points**

2. **VCBh adjustment:**
   - Vowel count = 3 (A, I, E)
   - VCBh[3] = +23 centipoints = +0.23 points

3. **Synergy (computed by CODE 39):**
   - Would check patterns like SATIRE letter combinations
   - Values computed at runtime, not stored

4. **Total: ~+18.06 points** (MUL + VCB only)

### Code Reference

The leave evaluation REPL (`leave_eval.py`) demonstrates this calculation using extracted MUL and VCB data.

---

## 5. Resource Loading Summary

| Resource | A5 Offset | Count | Purpose |
|----------|-----------|-------|---------|
| MULa-MULz, MUL? | A5-10868 | 27 handles | Per-tile leave adjustments |
| VCBa-VCBh | A5-10900 | 8 handles | Vowel count adjustments (only h has data) |
| ESTR | Loaded separately | 1 | Pattern strings for synergy |
| EXPR | A5-10908 | 1 | Base experience values |

---

## 6. Known Unknowns

1. **VCB scaling for partial racks:** The disassembly is too corrupted to determine if/how Maven scales VCB adjustments for leaves smaller than 7 tiles.

2. **ESTR synergy values:** The actual numeric values for synergy patterns are computed at runtime, not stored in resources. Extracting them would require runtime debugging or more complete disassembly of CODE 39.

3. **Secondary double in MUL records:** The purpose of the double at offset 8-15 is unclear.

4. **Unknown int in MUL records:** The int32 at offset 20-23 is not understood.

---

## 7. Implementation Notes

### For Reimplementation

1. Load all 27 MUL resources and extract offset-24 values for each tile count
2. Load VCBh resource and extract offset-24 values for vowel count 0-7
3. Sum per-tile adjustments based on tile counts in leave
4. Add VCBh adjustment based on vowel count
5. For full accuracy, would need to reimplement CODE 39's synergy calculation

### Confidence Level

- **MUL structure and values:** HIGH (confirmed by CODE 32 analysis)
- **VCBh values:** MEDIUM-HIGH (data extracted but usage logic unclear)
- **ESTR pattern strings:** HIGH (directly readable)
- **ESTR synergy values:** LOW (computed at runtime, not extracted)

---

## Appendix: Raw Data Files

- MUL resources: `/Volumes/T7/retrogames/oldmac/maven_re/resources/MUL*/0_0.bin`
- VCB resources: `/Volumes/T7/retrogames/oldmac/maven_re/resources/VCB*/0_0.bin`
- ESTR patterns: `/Volumes/T7/retrogames/oldmac/maven_re/resources/ESTR/0_pattern_strings.bin`
- Leave evaluator: `/Volumes/T7/retrogames/oldmac/maven_re/leave_eval.py`
