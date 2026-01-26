# CODE Analysis Audit Results

## Summary

This audit verified CODE resource analyses against actual binary files to identify hallucinations and over-extrapolations.

---

## Verified Analyses

### CODE 0 - Jump Table
| Aspect | Status | Notes |
|--------|--------|-------|
| Header values | ✅ VERIFIED | Above A5=3584, Below A5=28654, JT size=3552, JT offset=32 |
| Entry format | ✅ VERIFIED | 8-byte entries with offset/3F3C/segment/A9F0 pattern |
| File size | ⚠️ MINOR ERROR | Claimed 3564, actual 3568 bytes |

### CODE 1 - Runtime Library
| Aspect | Status | Notes |
|--------|--------|-------|
| Header format | ✅ VERIFIED | Special startup segment header |
| Entry point (0x0C) | ✅ VERIFIED | 4278 0A4A (CLR.W $0A4A.W) |
| init_toolbox call | ✅ VERIFIED | JSR $0048(PC) at 0x12 |
| Math routines | ✅ VERIFIED | MULU instructions at ~0x100 |

### CODE 10 - UI Utilities
| Aspect | Status | Notes |
|--------|--------|-------|
| File size | ✅ VERIFIED | 142 bytes |
| Header | ✅ VERIFIED | JT offset 352, 3 entries |
| All instructions | ✅ VERIFIED | Every byte matches analysis |
| Toolbox traps | ✅ VERIFIED | A949, A946, A9B6, A9B7 at correct offsets |

### CODE 32 - Leave Calculation
| Aspect | Status | Notes |
|--------|--------|-------|
| File size | ✅ CORRECTED | Was 6,464, actual 2,320 bytes |
| Bingo bonus | ✅ VERIFIED | 0x1388 (5000 centipoints = 50 pts) at 0x0334 |
| tiles_played check | ✅ VERIFIED | CMPI.W #7,-20010(A5) at 0x032C |
| Vowel counting | ❌ REMOVED | Was fabricated - not found in binary |
| Q-without-U penalty | ❌ REMOVED | Was fabricated - not found in binary |

### CODE 45 - Move Evaluation
| Aspect | Status | Notes |
|--------|--------|-------|
| Sentinel value | ✅ VERIFIED | F4143E00 (-200,000,000) at offset 0x0360 |

### CODE 54 - Memory Utility
| Aspect | Status | Notes |
|--------|--------|-------|
| File size | ✅ VERIFIED | 46 bytes (42 code + 4 header) |
| All instructions | ✅ VERIFIED | Every byte matches |
| Function purpose | ❌ CORRECTED | Was "string_equal", actually "is_region_zero" |

---

## Errors Found and Corrected

### Critical Errors

1. **CODE 32 - Fabricated Algorithm Details**
   - WRONG: Claimed explicit vowel counting loop
   - WRONG: Claimed Q-without-U penalty code
   - WRONG: File size (6,464 vs actual 2,320)
   - FIX: Rewrote analysis with only verified disassembly

2. **CODE 54 - Wrong Function Interpretation**
   - WRONG: Claimed function was "string_equal" comparing two strings
   - ACTUAL: Function is "is_region_zero" checking if memory contains only zeros
   - Evidence: Second parameter is WORD (MOVEA.W), not pointer
   - FIX: Corrected function name, C translation, and purpose

### Minor Errors

1. **CODE 0 - File Size**
   - Claimed: 3564 bytes
   - Actual: 3568 bytes
   - Difference: 4 bytes (insignificant)

---

## Lessons Learned

1. **Always verify against binary** - Disassembly must match actual bytes
2. **Don't extrapolate algorithm details** - Only document what's provably in the code
3. **Instruction operand types matter** - MOVEA.W vs MOVEA.L reveals function signatures
4. **Be honest about unknowns** - "Unknown purpose" is better than fabrication
5. **File sizes are easy to verify** - `ls -la` should be first step

---

## Remaining Work

The following analyses should be spot-checked:
- CODE 2-9: Need verification
- CODE 11-14: Need verification
- CODE 15-31: Need verification
- CODE 33-53: Need verification

Priority: Any analysis claiming specific algorithm details (loops, formulas, penalties) should be verified or marked as speculation.
