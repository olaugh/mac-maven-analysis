# CODE Analysis Audit Results

## Summary

This audit verified CODE resource analyses against actual binary files to identify errors and over-extrapolations.

**Audit Date**: 2026-01-26
**Files Checked**: CODE 0-54 (55 resources)

---

## Verification Methodology

1. **Size verification**: Compare `ls -la` output to claimed sizes
2. **Function boundaries**: Count LINK A6,#displacement patterns
3. **Global variables**: Pattern match A5-relative offset bytes in binary
4. **Algorithm claims**: Verify specific instruction sequences

---

## Critical Findings

### Files With Major Size Discrepancies

| CODE | Claimed | Actual | Difference | Status |
|------|---------|--------|------------|--------|
| **8** | 2326 | 944 | -1382 | **INVALID** - Analysis fabricated |
| **15** | 3568 | 1168 | -2400 | **INVALID** - Wrong file analyzed? |
| **21** | 13718 | 176 | -13542 | **TRUNCATED** - Binary corrupted |
| **20** | 3398 | 2592 | -806 | **ERROR** - Needs re-analysis |
| **34** | 1388 | 1264 | -124 | **ERROR** - Needs re-analysis |
| **41** | 660 | 128 | -532 | **ERROR** - Needs re-analysis |

### Consistent 4-Byte Discrepancy

Most analyses exclude the 4-byte CODE resource header. This is a documentation error, not an analysis error. Actual sizes = claimed + 4 in these cases.

---

## Detailed Results by CODE

### CODE 0 - Jump Table
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | VERIFIED | 3568 bytes (header values correct) |
| Entry format | VERIFIED | 8-byte entries confirmed |
| Header values | VERIFIED | Above A5=3584, Below A5=28654 |

### CODE 1 - Runtime Library
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | VERIFIED | Special startup segment |
| Entry point | VERIFIED | 0x0C: CLR.W $0A4A.W |
| Init calls | VERIFIED | JSR patterns at expected offsets |

### CODE 2 - Resource/Window Management
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 754 bytes (was 750) |
| Functions | VERIFIED | 5 LINK patterns match |
| Global vars | VERIFIED | All 8 claimed offsets found |
| Toolbox traps | VERIFIED | All 12 traps confirmed |

### CODE 3 - Core DAWG/AI
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 4394 bytes (was 4390) |
| Functions | VERIFIED | 16 LINK patterns match |
| Algorithm | SPECULATIVE | "Core DAWG/AI" purpose unverified |

### CODE 4 - Random Number Generator
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 112 bytes (was 108) |
| Functions | VERIFIED | 2 LINK + 1 MOVEM prologue |
| LFSR | **VERIFIED** | All instructions confirmed |
| GCD | **VERIFIED** | Loop structure confirmed |

### CODE 5 - Dictionary Initialization
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 208 bytes (was 204) |
| Functions | VERIFIED | 1 LINK pattern |
| Global vars | VERIFIED | A5-8604, A5-15522, etc. |
| C translation | SPECULATIVE | Logic inferred |

### CODE 6 - DAWG Direction Selector
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 1030 bytes (was 1026) |
| Functions | VERIFIED | 9 LINK patterns |
| Algorithm | **VERIFIED** | Direction switching confirmed |

### CODE 7 - Board State Management
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 2876 bytes (was 2872) |
| Functions | VERIFIED | 21 LINK patterns |
| Lexicon modes | **VERIFIED** | MOVE.W #8/#6/#1 to A5-8604 |
| Menu handler | SPECULATIVE | Interpretation inferred |

### CODE 8 - DAWG Support
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **INVALID** | 944 bytes actual vs 2326 claimed |
| Functions | **INVALID** | 2 found vs 3 claimed |
| Global vars | **INVALID** | A5-23090, A5-23074 NOT in binary |
| Analysis | **FABRICATED** | Must be rewritten |

### CODE 9 - Unknown
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 3944 bytes (was 3940) |
| Functions | VERIFIED | 48 LINK patterns |
| Toolbox traps | VERIFIED | A873 (EqualPt), A95B (SetCRefCon) |

### CODE 10 - UI Utilities
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | VERIFIED | 142 bytes exact |
| Functions | VERIFIED | 4 LINK patterns |
| All traps | **VERIFIED** | A949, A946, A9B6, A9B7 |

### CODE 11 - Game Controller
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED | 4482 bytes (was 4478) |
| Functions | NEEDS REVIEW | 31 found vs 29 claimed |
| Offset error | **ERROR** | A5-8604 is 0xDE64, not 0xDE74 |
| Validation offset | **ERROR** | Function at 0x111E, not 0x111C |

### CODE 12-14 - Various
| CODE | Size | Functions | Status |
|------|------|-----------|--------|
| 12 | CORRECTED +4 | VERIFIED (23) | SPECULATIVE purpose |
| 13 | CORRECTED +4 | VERIFIED (5) | File I/O verified |
| 14 | CORRECTED +4 | VERIFIED (20) | SPECULATIVE |

### CODE 15 - Word Lister
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **MAJOR ERROR** | 1168 bytes actual vs 3568 claimed |
| Functions | **ERROR** | 11 found vs 20 claimed |
| JT Header | VERIFIED | Offset=736, Entries=5 |
| Trap A887 | NOT FOUND | Claimed but absent |

### CODE 16-19 - Various
| CODE | Size | Functions | Status |
|------|------|-----------|--------|
| 16 | CORRECTED +4 | VERIFIED (9) | SPECULATIVE |
| 17 | CORRECTED +4 | VERIFIED (34) | A887 trap verified |
| 18 | CORRECTED +4 | VERIFIED (15) | SPECULATIVE |
| 19 | CORRECTED +4 | VERIFIED (12) | SPECULATIVE |

### CODE 20 - Unknown
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **ERROR** | 2592 bytes vs 3398 claimed |
| Functions | NEEDS REVIEW | 17-18 vs 21 claimed |

### CODE 21 - Main Event Loop
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **CRITICAL** | 176 bytes vs 13718 claimed |
| Binary | **TRUNCATED** | File appears corrupted |
| Analysis | **INVALID** | Cannot be 53 functions in 176 bytes |

### CODE 22-31 - Various
| CODE | Size | Functions | Status |
|------|------|-----------|--------|
| 22 | VERIFIED | VERIFIED (10) | SPECULATIVE |
| 23 | VERIFIED | VERIFIED (12) | SPECULATIVE |
| 24 | VERIFIED | VERIFIED (26) | SFGetFile verified |
| 25 | VERIFIED | VERIFIED (1) | SPECULATIVE |
| 27 | VERIFIED | VERIFIED (5) | SPECULATIVE |
| 28 | VERIFIED | VERIFIED (3) | SPECULATIVE |
| 29 | VERIFIED | VERIFIED (8) | SPECULATIVE |
| 30 | VERIFIED | VERIFIED (15) | SPECULATIVE |
| 31 | VERIFIED | VERIFIED (14) | SPECULATIVE |

### CODE 32 - Leave Calculation
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **EXACT** | 2320 bytes |
| Functions | VERIFIED | 6 LINK patterns |
| Stack frame | **VERIFIED** | LINK A6,#-324 at 0x04 |
| Bingo check | **VERIFIED** | CMPI.W #7 at 0x32C |
| Bonus 5000 | **VERIFIED** | 0x1388 at 0x330 |
| tiles_played | **VERIFIED** | A5-20010 (B1D6) found |

### CODE 33 - Missing
No analysis file exists.

### CODE 34 - Unknown
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **ERROR** | 1264 bytes vs 1388 claimed |
| Functions | NEEDS REVIEW | Mismatched RTS count |

### CODE 35 - File Operations
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | CORRECTED +4 | 3280 bytes |
| Functions | NEEDS REVIEW | 7 vs 5 claimed |
| SFGetFile | **VERIFIED** | A9EB trap found |

### CODE 36-40 - Various
| CODE | Size | Functions | Status |
|------|------|-----------|--------|
| 36 | CORRECTED +4 | VERIFIED (14) | SPECULATIVE |
| 37 | CORRECTED +4 | VERIFIED (18) | SPECULATIVE |
| 38 | CORRECTED +4 | VERIFIED (4) | A5-15522 verified |
| 39 | CORRECTED +4 | VERIFIED (5) | **Detailed analysis verified** |
| 40 | CORRECTED +4 | VERIFIED (4) | DAWG offsets found |

### CODE 41 - Buffer Operations
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **ERROR** | 128 bytes vs 660 claimed |
| Functions | **ERROR** | 2 vs 8 claimed |

### CODE 42-53 - Various
| CODE | Size | Functions | Status |
|------|------|-----------|--------|
| 42 | CORRECTED +4 | VERIFIED (3) | SPECULATIVE |
| 43 | CORRECTED +4 | VERIFIED (5) | SPECULATIVE |
| 44 | CORRECTED +4 | VERIFIED (4) | SPECULATIVE |
| 45 | CORRECTED +4 | VERIFIED (5) | Globals verified |
| 46 | CORRECTED +4 | VERIFIED (23) | SPECULATIVE |
| 47 | CORRECTED +4 | VERIFIED (11) | SPECULATIVE |
| 48 | CORRECTED +4 | VERIFIED (18) | SPECULATIVE |
| 49 | CORRECTED +4 | VERIFIED (3) | SPECULATIVE |
| 50 | CORRECTED +4 | VERIFIED (1) | SPECULATIVE |
| 51 | CORRECTED +4 | VERIFIED (6) | SPECULATIVE |
| 52 | CORRECTED +4 | VERIFIED (13) | SPECULATIVE |
| 53 | CORRECTED +4 | VERIFIED (1) | SPECULATIVE |

### CODE 54 - Memory Utility
| Aspect | Status | Notes |
|--------|--------|-------|
| Size | **VERIFIED** | 46 bytes (42 code + 4 header) |
| All bytes | **VERIFIED** | Complete disassembly matches |
| C translation | **VERIFIED** | is_region_zero logic correct |

---

## Algorithms Fully Verified

1. **CODE 4**: LFSR random number generator - all instructions confirmed
2. **CODE 4**: Euclidean GCD - loop structure confirmed
3. **CODE 6**: DAWG direction selection - switching logic confirmed
4. **CODE 32**: Bingo bonus check - CMPI.W #7, value 5000 confirmed
5. **CODE 39**: Score table access - 18-byte ESTR indexing confirmed
6. **CODE 54**: is_region_zero - complete byte-for-byte match

---

## Analyses Requiring Rewrite

| CODE | Issue | Action Required |
|------|-------|-----------------|
| **8** | Size mismatch, fabricated globals | Complete rewrite |
| **15** | Size mismatch, wrong function count | Complete rewrite |
| **21** | Binary truncated/corrupted | Re-extract and rewrite |
| **20** | Size mismatch | Verify and correct |
| **34** | Size mismatch | Verify and correct |
| **41** | Size mismatch | Verify and correct |

---

## Lessons Learned

1. **Always verify against binary** - Disassembly must match actual bytes
2. **Don't extrapolate algorithm details** - Only document what's provably in the code
3. **Instruction operand types matter** - MOVEA.W vs MOVEA.L reveals function signatures
4. **Be honest about unknowns** - "Unknown purpose" is better than fabrication
5. **File sizes are easy to verify** - `ls -la` should be first step
6. **4-byte header is real** - CODE resources include JT offset + entry count
7. **Mark speculation clearly** - Most purpose claims are inferences, not facts

---

## Statistics

- **Total CODE resources**: 55 (0-54)
- **Size verified exact**: 4 (CODE 0, 10, 32, 54)
- **Size corrected (+4 header)**: 41
- **Size major errors**: 6 (CODE 8, 15, 20, 21, 34, 41)
- **Algorithms fully verified**: 6
- **Analyses needing rewrite**: 6
- **Analyses marked SPECULATIVE**: ~40
