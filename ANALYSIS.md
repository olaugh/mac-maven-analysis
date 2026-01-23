# Maven Reverse Engineering Analysis

## Project Overview
Maven is a classic Macintosh Scrabble engine created by Brian Sheppard. This document tracks the reverse engineering progress.

## File Structure

### Main Application
- **maven2** (1,070,788 bytes) - Data fork containing the DAWG dictionary
- **maven2.1.rdump** (1,045,969 bytes) - Resource fork dump (DeRez format) containing:
  - 53 CODE resources (96,054 bytes total) - 68000 machine code
  - UI resources (MENU, DITL, STR, etc.)
  - Data resources (CFIG, EXPR, MUL*, VCB*, ESTR, etc.)

### Resource Types Identified

#### Executable Code
- **CODE 0-54**: 68000 machine code segments
- Total: ~96KB of executable code

#### Configuration & Data
- **CFIG**: Board configuration (1,088 bytes) - appears to contain board multiplier positions
- **EXPR**: "experience" resource (96 bytes) - contains floating-point rack leave values
- **MULa-MULz, MUL?**: Letter multiplier tables (224 bytes each) - leave value contributions per letter
- **VCBa-VCBh**: Vowel Count Balance tables (224 bytes each) - VCBa-VCBg are zeros, VCBh contains vowel count adjustments (0-7 vowels)
- **ESTR**: Pattern strings (536 bytes) - rack leave pattern definitions

#### Leave Heuristics
The ESTR resource contains pattern strings for rack evaluation:
- Single/double/triple letter patterns: "a", "aa", "aaa", "ee", "eee", etc.
- Common suffixes: "gin", "flu", "ily", "ino", "inot", "ity", etc.
- Letter groups: "aeiou" (vowels), "mpfhxwy", "mpdglnrtsu", etc.

The MUL* resources contain 80-bit extended precision floating point values
representing the leave value contributions for each letter pattern combination.

## DAWG Dictionary Structure

### Header (0x00-0x0F)
```
Offset 0x00: 0x0000dd36 (56,630) - Section 1 size (reversed words, overflow)
Offset 0x04: 0x0001dd36 (122,166) - Cumulative size (Section 1 + Section 2)
Offset 0x08: 0x00023844 (145,476) - unknown
Offset 0x0C: 0x00000300 (768) - possibly data offset
```

### Two-Section Structure (Heavily Overlapping)
The DAWG contains **two overlapping sections** for efficient cross-check computation:

| Section | Entries | Size | Purpose |
|---------|---------|------|---------|
| Shared suffix pool | 0-999 | ~1,000 | Common word endings used by both DAWGs |
| Section 1 | 0-56,629 | 56,630 | **Reversed words** - for hook-BEFORE checking |
| Section 2 | 56,630-122,165 | 65,536 | **Forward words** - for hook-AFTER checking |

**Key insight: The sections heavily overlap.** Analysis shows:
- 986 of the first 1000 entries are referenced by BOTH sections
- Section 2 is not self-contained: 57% of its children point to the shared pool (0-999), and 43% point into Section 1 (1000-56629)
- 0% of Section 2 children point within Section 2 itself

Section 2 functions as an "alternate entry layer" - forward word traversals start in Section 2 but quickly descend into Section 1's suffix structure. This clever design minimizes memory usage by sharing all common word endings.

**Why two entry points?** Without a reversed DAWG, computing cross-checks (what letters can legally extend existing words) would require brute-force testing all 26 letters A-Z.

**Note:** The reversed/forward DAWGs may also be used for main word generation (extending left/right from an anchor square), not just cross-set computation. This hasn't been confirmed in the code yet.

**Size note**: Section 2 being exactly 65,536 (2^16) indicates it maxed out a 16-bit index. It only needs to store the unique "front parts" of forward words since it shares all suffixes with Section 1.

### Letter Index (0x10-0x77)
26 entries, one for each letter a-z:
```
Format: [ptr_hi][ptr_lo][flags][letter]
Example for 'a': 00 a9 48 61 -> ptr=0x00a9, flags=0x48, letter='a'
```

### DAWG Nodes (0x400+)
Each node is 4 bytes:
```
Byte 0-1: Child pointer (16-bit, big-endian)
Byte 2:   Flags
Byte 3:   Letter (ASCII: 'a'=0x61, 'z'=0x7a, '?'=0x3f)
```

### Flag Interpretation (partially decoded)
- Bit 0: End-of-word marker
- Bit 1: Last sibling marker
- Bits 2-7: Unknown (possibly part of extended pointer)

### Statistics
- File size: 1,070,788 bytes
- DAWG nodes: ~267,000 (estimated)
- Letter frequency at byte position 3 (confirming structure):
  - 'e': 29,834 nodes
  - 'i': 30,202 nodes
  - 's': 24,608 nodes
  - 'a': 21,814 nodes

## Endgame Algorithm
Not yet analyzed. Likely in CODE resources 36-37 based on complexity and size.

## Move Generation
The DAWG structure appears to be designed for efficient move generation:
- Letter index provides quick access to words starting with each letter
- Shared suffix nodes reduce memory usage
- Flag bits allow marking valid words and sibling relationships

## Tools Created

### extract_resources.py
Extracts all resources from the .rdump file into individual binary files.

### parse_dawg.py / analyze_dawg.py
Analyzes the DAWG header and node structure.

### dawg_traverse.py / dawg_reversed.py
Attempts to extract words from the DAWG (work in progress).

## Documentation

See the `analysis/` directory for detailed documentation:

- **ANALYSIS_SUMMARY.md** - High-level summary of all findings
- **LEAVE_VALUES.md** - Complete leave value system documentation
- **MOVE_EVALUATION.md** - Move scoring algorithm details
- **CODE_RESOURCE_MAP.md** - CODE resource classification and relationships
- **detailed/codeN_detailed.md** - Per-CODE detailed analysis (53 files)
- **disasm/codeN_disasm.asm** - Disassembly output (53 files)

## Tools

- **leave_eval.py** - Interactive leave value evaluator using extracted Maven data
- **extract_resources.py** - Extract resources from .rdump file
- **analyze_dawg.py** - DAWG dictionary structure analysis

## Next Steps

1. **Extract ESTR synergy values** via runtime debugging (values computed by CODE 39)
2. **Complete endgame analysis** (CODE 36-37 are large and complex)
3. **Understand VCB application** for partial racks (disassembly incomplete)
4. **Document Monte Carlo simulation** system (CODE 35, 50)

## References
- Maven was created by Brian Sheppard in the 1980s
- Uses DAWG dictionary format (can be configured for any word list; our emulator version uses OSWI from 2000)
- Classic Macintosh 68000 application architecture
