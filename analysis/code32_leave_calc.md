# CODE 32 Leave Calculation Analysis

## Location in CODE 32

The leave value calculation begins at offset **0x156A** within CODE 32.

## Key Instructions

```
Offset  Bytes         Instruction              Comment
------  -----         -----------              -------
0x156A  2068 d58c     MOVEA.L -10868(A0),A0   ; Dereference MUL handle from A5-10868
0x156E  2d68 0018 ffdc MOVE.L 24(A0),-36(A6)  ; Load offset-24 value to local var
...
0x15C4  90ae ffdc     SUB.L   -36(A6),D0      ; SUBTRACT leave adjustment from D0!
```

## Sign Interpretation

The code **subtracts** the leave adjustment value, which explains the inverted signs in the MUL data:

| Tile | Offset-24 | Operation | Effect |
|------|-----------|-----------|--------|
| Blank | -515 | D0 - (-515) | D0 + 515 = **bonus** |
| S | -337 | D0 - (-337) | D0 + 337 = **bonus** |
| Q | +88 | D0 - (+88) | D0 - 88 = **penalty** |

So **negative values in offset-24 = bonuses**, **positive values = penalties**.

The values are in centipoints (1/100 of a point):
- Blank: +5.15 points bonus
- S: +3.37 points bonus
- Q: -0.88 points penalty

## Scale Problem

The calculated values are still too small:
- Blank should be ~+25 points, not +5.15
- This suggests additional calculations occur elsewhere

## SANE Floating Point Operations

The surrounding code uses SANE FP:

```
0x159A  3f3c 0004     MOVE.W  #4,-(SP)    ; Opcode 4 = FMULX (multiply)
0x159E  a9eb          FP68K               ; Call SANE

0x15B4  4267          CLR.W   -(SP)       ; Opcode 0 = FADDX (add)
0x15B6  a9eb          FP68K               ; Call SANE

0x15E4  3f3c 2804     MOVE.W  #$2804,-(SP) ; Opcode $2804 = FL2X (long to extended)
0x15E8  a9eb          FP68K               ; Call SANE
```

## Hypothesis: Multi-Factor Formula

The full leave calculation likely combines:
1. Single-tile leave adjustments (from MUL offset-24)
2. Pattern bonuses/penalties (from ESTR patterns)
3. Multiplied by tile counts or other factors
4. Converted via FL2X to floating point

The FMULX (multiply) at 0x159E suggests the leave adjustment is scaled by something,
which could explain the small values being multiplied up to expected ranges.

## Global Reference

The MUL handle is accessed via:
- A5-10868 (0xD58C) = Pointer to MUL resource handles array
- Each tile letter has its own MUL resource indexed by the tile code
