# CODE 3 Revised Analysis: Insights from CODE 7 and CODE 11

## New Understanding

After analyzing CODE 7 (board/rack state) and CODE 11 (game controller), several aspects of CODE 3 become clearer:

### 1. The 34-byte Structure is g_dawg_info (NOT a search state)

**Previous understanding**: The 34-byte structure was speculated to be a "search state" used in loops.

**Corrected understanding**: The 34-byte structure is `g_dawg_info` (at A5-23090), a DAWG header/info structure that contains:
- Section offsets and sizes
- Configuration data for the DAWG traversal
- Copied as 8 longs + 1 word = 34 bytes

Evidence from CODE 3:
```asm
0A82: PEA        -23090(A5)      ; push g_dawg_info
0A86: JSR        2370(A5)        ; call setup_params()
```

This matches CODE 11's pattern:
```c
// From CODE 11 analysis
setup_params(1, g_current_ptr, g_dawg_info);  // JSR 2370(A5)
```

### 2. Two-Buffer System Explains the Dual DAWG Sections

**Key insight**: The two buffers (`g_field_14` and `g_field_22`) correspond to the two DAWG sections:

| Buffer | Global Offset | Paired DAWG Size | DAWG Section | Purpose |
|--------|---------------|------------------|--------------|---------|
| g_field_14 | A5-15514 | g_size1 (56630) | Section 1 | **Reversed words** (suffix matching) |
| g_field_22 | A5-15522 | g_size2 (65536) | Section 2 | **Forward words** (prefix matching) |

Evidence from CODE 3 (0x0AEE-0x0B50):
```asm
; Test which buffers are active
0AEE: TST.B      -15522(A5)      ; test g_field_22
0AF2: BEQ.S      $0B1A           ; if zero, skip to test g_field_14
0AF4: TST.B      -15514(A5)      ; test g_field_14
...
; When using g_field_22, add g_size2:
0AA4: MOVE.L     -23074(A5),D0   ; D0 = g_dawg_ptr
0AA8: ADD.L      -15502(A5),D0   ; D0 += g_size2 (65536)
...
; When using g_field_14, add g_size1:
0AB6: MOVE.L     -23074(A5),D0   ; D0 = g_dawg_ptr
0ABA: ADD.L      -15506(A5),D0   ; D0 += g_size1 (56630)
```

### 3. g_current_ptr (A5-15498) Tracks Active Buffer

The game dynamically switches between horizontal and vertical word searches by changing `g_current_ptr`:

```asm
0A7E: MOVE.L     -15498(A5),-(A7)  ; get current buffer
...
0AB0: MOVE.L     A0,-15498(A5)     ; set current = g_field_22
...
0AC2: MOVE.L     A0,-15498(A5)     ; set current = g_field_14
```

This explains why Scrabble AI needs two DAWG sections:
- **Horizontal moves**: Use forward DAWG (section 2) with g_field_22
- **Vertical moves**: Use reversed DAWG (section 1) with g_field_14

### 4. The Value 46 Relates to Board Position Encoding

At 0x0070:
```asm
0070: MOVEQ      #46,D0          ; D0 = 46
0072: MULS       D4,D0           ; D0 = 46 * max_iter
```

**New hypothesis**: 46 may relate to:
- Board position + tile data structure (15 board positions × 3 bytes each + overhead = ~46)
- Or an extended cell structure for move scoring

This needs further investigation, but it's likely NOT about DAWG entry size.

### 5. Revised Data Flow Understanding

Based on CODE 7 and CODE 11 analysis, CODE 3's main function flow is:

```c
void dawg_search(SearchContext *ctx) {
    // Setup using the 34-byte g_dawg_info structure
    DawgInfo *info = &g_dawg_info;  // A5-23090

    // Get current active buffer (horizontal or vertical)
    void *current_buffer = g_current_ptr;  // A5-15498

    // Calculate DAWG base address based on which buffer is active
    long dawg_offset;
    if (current_buffer == &g_field_22) {
        // Forward DAWG for horizontal words
        dawg_offset = g_dawg_ptr + g_size2;  // section 2
    } else {
        // Reversed DAWG for vertical words
        dawg_offset = g_dawg_ptr + g_size1;  // section 1
    }

    // Setup search parameters
    setup_params(1, current_buffer, info);  // JSR 2370(A5)

    // Perform DAWG traversal...
    // The 34-byte structure is copied/manipulated during search

    // Process results
    process_dawg(flags, info);  // JSR 362(A5)
}
```

### 6. Still Uncertain: Actual 4-byte DAWG Entry Access

The main remaining question is where the actual 4-byte DAWG entry access occurs. The 34-byte copies are moving header/info data, not individual entries.

The actual entry traversal likely happens in:
- Jump table function at 362(A5) - `process_dawg()`
- Or within the main loop that processes the 34-byte state

**Looking for patterns like**:
```asm
; 4-byte entry access (×4 indexing)
LSL.L  #2,Dn      ; multiply index by 4
MOVE.L 0(An,Dn),Dm ; load 4-byte entry
```

These patterns may be in the functions called via the jump table, not in CODE 3 directly.

## Confidence Levels (Revised)

| Aspect | Previous | Revised | Notes |
|--------|----------|---------|-------|
| 34-byte structure purpose | LOW | **HIGH** | Confirmed as g_dawg_info |
| Two-buffer system | UNKNOWN | **HIGH** | Horizontal/vertical word directions |
| DAWG section pairing | UNKNOWN | **HIGH** | field_14↔size1, field_22↔size2 |
| g_current_ptr role | UNKNOWN | **HIGH** | Tracks active search direction |
| Value 46 meaning | LOW | MEDIUM | Likely board position related |
| 4-byte entry access | MEDIUM | LOW | Still need to locate actual entry traversal |

## Key Jump Table Functions to Investigate

From CODE 3's use patterns:
| Offset | Called With | Likely Purpose |
|--------|-------------|----------------|
| 362(A5) | g_dawg_info | **DAWG traversal** - likely contains entry access |
| 2370(A5) | current_ptr, g_dawg_info | Setup search parameters |
| 2122(A5) | g_field_14 or g_field_22 | Buffer comparison/scoring |
| 2346(A5) | - | Check search result |
| 1258(A5) | - | Post-search cleanup |

## Next Steps

1. **Find function at JT offset 362** - This is where actual DAWG entry access likely occurs
2. **Trace the 4-byte entry pattern** - Look for `×4` indexing in related CODE resources
3. **Map the jump table** - Determine which CODE resource implements each JT offset
