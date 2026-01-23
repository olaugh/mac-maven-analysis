# Maven Reverse Engineering - Analysis Summary

## Project Status

This document summarizes the reverse engineering analysis of Maven, a classic Macintosh Scrabble engine created by Brian Sheppard.

## Key Findings

### 1. Leave Value System

Maven evaluates rack leaves using a sophisticated multi-component system:

**MUL Resources (Per-Tile Values)**
- 27 resources (MULa-MULz, MUL?) containing pre-computed leave adjustments
- Each resource has 8 records of 28 bytes, indexed by tile count (0-7)
- Leave adjustment at offset 24 in centipoints (1/100 of a point)
- Best tiles: Blank (+24.40), S (+7.21), X (+4.19), Z (+3.59)
- Worst tiles: Q (-8.79), V (-4.98), J (-3.69)

**VCB Resources (Vowel Count Balance)**
- 8 resources (VCBa-VCBh), but only VCBh contains actual data
- Indexed by vowel count (0-7)
- Optimal at 4 vowels (+3.68 pts), worst at 7 vowels (-12.38 pts)

**ESTR Patterns (Synergies)**
- 130 pattern strings defining tile combinations
- Values computed at runtime by CODE 39
- Includes Q-without-U patterns (aq, aiq, aqt, etc.)

### 2. CODE Resource Organization

53 CODE resources organized into functional subsystems:

| Category | CODEs | Purpose |
|----------|-------|---------|
| Core System | 0-1, 11 | Segment loader, initialization |
| DAWG/Dictionary | 3, 15, 36 | Word lookup and validation |
| Move Scoring | 32, 39, 45 | Score calculation and ranking |
| Simulation | 35, 50, 24 | Monte Carlo leave value generation |
| UI | 6, 8, 21, 49 | Windows, menus, clipboard |

### 3. Key Global Variables (A5 Offsets)

| Offset | Purpose |
|--------|---------|
| A5-10868 | MUL resource handles (27 entries) |
| A5-10900 | VCB resource handles (8 entries) |
| A5-17154 | Board state - letter positions (17x17) |
| A5-16610 | Board state - multipliers (17x17x2) |
| A5-26158 | Current player's rack |
| A5-12512 to A5-12532 | Synergy score tables |

### 4. Scale Conventions

- All values in centipoints (divide by 100 for points)
- Bingo bonus: 5000 centipoints = 50 points
- Leave adjustment sign: positive = good tile, negative = bad tile
- CODE 32 SUBTRACTS adjustments (positive values reduce move score)

## Documentation Files

| File | Contents |
|------|----------|
| ANALYSIS.md | Project overview and file structure |
| LEAVE_VALUES.md | Complete leave value system documentation |
| MOVE_EVALUATION.md | Move scoring algorithm details |
| CODE_RESOURCE_MAP.md | CODE resource classification |
| analysis/detailed/codeN_detailed.md | Per-CODE detailed analysis (53 files) |
| analysis/disasm/codeN_disasm.asm | Disassembly output (53 files) |

## Tools Created

| Tool | Purpose |
|------|---------|
| leave_eval.py | Interactive leave value evaluator using extracted data |
| extract_resources.py | Extract resources from .rdump file |
| analyze_dawg.py | DAWG dictionary structure analysis |

## Confidence Levels

- **MUL structure and values**: HIGH (confirmed by CODE 32 analysis)
- **VCBh vowel adjustments**: MEDIUM-HIGH (data extracted, usage unclear)
- **ESTR patterns**: HIGH (directly readable strings)
- **ESTR synergy values**: LOW (computed at runtime, not stored)
- **Endgame algorithm**: LOW (CODE 36-37, complex and not fully analyzed)

## Future Work

1. Extract ESTR synergy values via runtime debugging
2. Complete endgame analysis (CODE 36-37)
3. Understand VCB application for partial racks
4. Document Monte Carlo simulation system (CODE 35)
