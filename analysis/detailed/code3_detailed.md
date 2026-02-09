# CODE 3 Detailed Analysis - Move Generator / DAWG Search Coordinator

## Overview

| Property | Value |
|----------|-------|
| Size | 4,390 bytes (+ 4-byte file header) |
| JT Offset | 112 |
| JT Entries | 6 |
| Functions | 16 |
| Purpose | **Central move generation engine and DAWG search coordinator** |

## System Role

**Category**: Core AI Engine
**Function**: Move Generation Coordinator

CODE 3 is the heart of Maven's move generation system. It implements the full pipeline
for finding legal Scrabble moves: iterating over board positions, coordinating DAWG
traversal in both board directions (across/down), managing cross-check constraints,
and executing the make-move/search/unmake-move pattern used in iterative deepening.

**Related CODE resources** (22 total called via JT):
- CODE 2, 4, 9, 10, 11, 14, 17, 20, 21, 27, 29, 30, 31, 32, 34, 36, 37, 39, 47, 48, 51, 52

This touches nearly every other CODE resource, confirming CODE 3 as the central
coordinator of the AI search.

---

## Disassembler Reliability Warning

The disassembler output for CODE 3 is **extensively mangled**. Common misdecodings:

| Hex Pattern | Disassembler Says | Actually Is |
|-------------|-------------------|-------------|
| `C1FC xxxx` | `ANDA.L #imm,A0` | `MULS.W #imm,D0` |
| `C3C5` | `ANDA.L D5,A1` | `MULS.W D5,D1` |
| `D1CA` | `MOVE.B A2,$xxxx.W` | `ADDA.W A2,A0` |
| `D7ED xxxx` | `MOVE.B ...` | `ADDA.L d16(A5),A3` |
| `DA85` | `MOVE.B D5,(A5)` | `ADD.L D5,D5` |
| `D28B` | `MOVE.B A3,(A1)` | `ADD.L A3,D1` |
| `48D0 mask` | various garbage | `MOVEM.L regs,(A0)` |
| `4CD8 mask` | `DC.W $4CD8` | `MOVEM.L (A0)+,regs` |
| `5C8F` | `MOVE.B A7,(A6)` | `ADDQ.L #6,A7` (stack cleanup) |
| `508F` | `MOVE.B A7,(A0)` | `ADDQ.L #8,A7` (stack cleanup) |
| `548F` | `MOVE.B A7,(A2)` | `ADDQ.L #2,A7` (stack cleanup) |
| `588F` | `MOVE.B A7,(A4)` | `ADDQ.L #4,A7` (stack cleanup) |
| `526D xxxx` | `MOVEA.B ...,A1` | `ADDQ.W #1,d16(A5)` |
| `536D xxxx` | `MOVE.B ...,imm(A1)` | `SUBQ.W #1,d16(A5)` |

All analysis below is based on **raw hex verification**, not disassembler output.

---

## Key Data Structures

### DAWGInfo (34 bytes)

Used throughout CODE 3 as the primary search state descriptor. Copied with an
optimized 8-long + 1-word loop (`MOVEQ #7,D0; MOVE.L (A1)+,(A0)+; DBF; MOVE.W`).

```c
typedef struct DAWGInfo {
    long  field_00;       /* +0:  DAWG base pointer or state */
    long  field_04;       /* +4:  callback/vtable pointer (checked non-null) */
    long  field_08;       /* +8:  iteration parameter */
    short field_0C;       /* +12: max depth / count field */
    short field_0E;       /* +14: offset/index used for data_copy */
    long  field_10;       /* +16: DAWG section component (used in bounds check) */
    long  field_14;       /* +20: DAWG section component */
    long  field_18;       /* +24: DAWG section component */
    short field_1A_pad;   /* +26: padding/unused? */
    short field_1C_pad;   /* +28: padding/unused? */
    short field_1E_pad;   /* +30: padding/unused? */
    short field_20;       /* +32: final word - flag field */
} DAWGInfo;  /* Total: 34 bytes */
```

Fields at offsets +10, +16, +22 of the object pointed to by `g_dawg_ptr2` (A5-11972)
are frequently tested. These appear to represent search mode flags:
- **field_0A (+10)**: Dictionary/wordlist selector (drives debug logging)
- **field_10 (+16)**: "Has DAWG traversal" flag (controls JT[362] calls)
- **field_16 (+22)**: "Has two-direction search" flag (controls cross-check pair)

### SearchEntry (46 bytes)

The parameter structure passed to the main search function (0x0000) contains an
array of 46-byte entries starting at offset +24. Each entry contains:

```c
typedef struct SearchEntry {
    DAWGInfo info;        /* +0:  34-byte DAWG info (copied to search stack) */
    long     field_22;    /* +34: score/value field (used in division) */
    long     field_26;    /* +38: additional data */
    long     field_2A;    /* +42: used in debug output */
} SearchEntry;  /* Total: 46 bytes */
```

The main search indexes into this array via `D4 * 46` (MULS.W #46,D0).

### SearchContext (44 bytes, in g_common)

Entries in `g_common` (A5-24026) are **44-byte register snapshots**, saved and
restored via MOVEM.L with mask 0xDEF8. This mask selects 11 registers:

For register-to-memory (MOVEM.L regs,(A0)): A7, A6, A4, A3, A2, A1, D7, D6, D5, D4, D3
= 11 registers x 4 bytes = 44 bytes.

The `g_search_index` (A5-23674) tracks how many search contexts are active (0-7 max,
validated with assertions). Each new search context:
1. Increments `g_search_index`
2. Multiplies by 44 to compute offset: `MULS.W #44,D0`
3. Indexes into `g_common` array base at A5-24026
4. Saves all active registers with `MOVEM.L` (48D0 DEF8)

The restore path uses `4CD8 DEF8` (MOVEM.L (A0)+,regs) to reload all registers
and jumps directly to the saved A0 (via JMP (A1) after the LEA 6(PC),A1 setup).
This implements a **setjmp/longjmp-like mechanism** for search state save/restore.

---

## Function Map

| Offset | Size | Frame | Purpose |
|--------|------|-------|---------|
| 0x0000 | 334 | -2282 | Main search entry: iterates SearchEntry array, manages search stack |
| 0x0150 | 78 | (inline) | Board position validity check (standalone, called as subroutine) |
| 0x019E | 60 | 0 | Validate DAWG section bounds |
| 0x01DA | 138 | -128 | Setup with type dispatch (0-7, 8-16, 17+) |
| 0x0264 | 94 | -2968 | Initialize search state buffer, dispatch to 0x069E or 0x0C54 |
| 0x02C2 | 988 | -1808 | Board state save/restore wrapper ("make/search/unmake") |
| 0x069E | 1462 | -6512 | **Core search loop**: board iteration, cross-checks, DAWG traversal |
| 0x0C54 | 446 | -1652 | Alternate search: save/restore with different entry point |
| 0x0E12 | 12 | 0 | Trampoline: calls 0x0150 (inline validity check) |
| 0x0E1E | 160 | -128 | Window/resource setup for file-based search |
| 0x0EBE | 36 | 0 | Set resource attributes and file type |
| 0x0EE2 | 26 | 0 | Open search file with resource fork |
| 0x0EFC | 108 | -2 | Event dispatch loop for search window |
| 0x0F68 | 308 | -516 | File-based search initialization (reads DAWG from resource fork) |
| 0x109C | 84 | -132 | Helper: format string and call search dispatch |
| 0x10F0 | 36 | -2 | Open file dialog (TEXT type, SFGetFile) |
| 0x1114 | 18 | 0 | Simple dispatch: calls JT with parameter |

---

## Detailed Function Analysis

### Function 0x0000 - Main Search Entry Point (334 bytes)

**Verified from hex at file offset 0x0004.**

```
0000: 4E56 F716    LINK    A6,#-2282
0004: 48E7 1F38    MOVEM.L D3-D7/A2-A4,-(SP)
0008: 7018         MOVEQ   #24,D0
000A: D0AE 0008    ADD.L   8(A6),D0        ; D0 = param + 24
000E: 2840         MOVEA.L D0,A4           ; A4 = param + 24 (entry array base)
0010: 2C2C 002A    MOVE.L  42(A4),D6       ; D6 = first entry's field_42
0014: 206E 0008    MOVEA.L 8(A6),A0        ; A0 = param
0018: 0C68 0040 000C  CMPI.W #64,12(A0)    ; assert(param->count <= 64)
001E: 6F04         BLE.S   ok
0020: 4EAD 01A2    JSR     JT[418]         ; assertion_failure()
```

**Frame layout** (2282 bytes):
- `-2282(A6)` to `-2279(A6)`: loop control / division result (4 bytes)
- `-2278(A6)` to `-2275(A6)`: accumulated offset (4 bytes)
- `-2274(A6)` to `-2241(A6)`: 34-byte DAWGInfo copy buffer
- `-2240(A6)` to `0(A6)`: search stack - 65 entries x 34 bytes = 2210 bytes
- `-63(A6)` to `0(A6)`: overlapping string buffer for sprintf

**Algorithm:**
```c
void main_search(SearchParams *params) {
    SearchEntry *entries = (SearchEntry *)((char*)params + 24);  // A4
    long divisor = entries[0].field_2A;   // D6 - iteration count/divisor

    assert(params->field_0C <= 64);  // max search depth

    // Format debug string
    sprintf(local_str, g_format_buffer, divisor);
    init_function(local_str);         // JT[674]

    if (divisor == 0) divisor = 1;    // prevent divide-by-zero

    short num_entries = params->field_0C;  // D4 - loop count
    short iteration = 0;                    // D5 - current index

    // Compute half-iterations for progress: -2278(A6) = divisor / 2
    long half = divide(divisor, 2);    // JT[90]

    // Initialize search stack pointer
    // A3 = &search_stack[D5] = -2240(A6) + D5 * 34

    // Main loop: iterate through all search entries
    for (D4 = num_entries - 1; D4 >= 0; D4--) {
        // Index into parameter's 46-byte entry array
        // A0 = entries + D4 * 46
        // A1 = search_stack[iteration]

        // Copy 34 bytes from entry to search stack
        copy_34bytes(/*dst*/ A1, /*src*/ A0);

        // Compute: field_34 value from entry + accumulated offset
        // offset = entries[D4].field_22 + accumulated / divisor
        long val = divide(entries[D4].field_22 + accumulated, divisor);

        // Store result: search_stack[iteration].field_18 = val
        // Also track: val - stack[iter].field_14 - stack[iter].field_10

        // Validate: accumulated offset > 0 (assertion)
        // Advance to next 34-byte entry in stack

        // Copy current best back to local buffer
        copy_34bytes(local_info, /*src*/ current_stack_entry);

        // Advance D5, D4, A3
        iteration++;
    }

    // After loop: copy results to output
    copy_buffer(g_buffer2, search_stack, params->field_0C);  // JT[666]
    finalize();   // JT[1650]
}
```

The MULS.W instructions that the disassembler mangles are critical:
- `MULS.W D5,D1` at 0x0062 (hex C3C5): computes `D5 * 34` for search stack indexing
- `MULS.W D4,D0` at 0x0072 (hex C1C4): computes `D4 * 46` for entry array indexing

### Function 0x0150 - Board Position Validity Check (78 bytes, inline)

This is a standalone subroutine within the address range of function 0x0000 but
entered via direct BSR/JSR. It checks whether a board position is valid for move
placement.

```
0150: 3F3C 0121    MOVE.W  #289,-(A7)     ; 289 = 17*17
0154: 486D D76C    PEA     g_lookup_tbl   ; A5-10388
0158: 4EAD 0D7A    JSR     JT[3450]       ; check_table(g_lookup_tbl, 289)
015C: 4A40         TST.W   D0
015E: 5C8F         ADDQ.L  #6,A7          ; clean stack
0160: 670A         BEQ.S   check_flag1    ; if table empty, check flag
0162: 4A6D DE28    TST.W   -8664(A5)      ; flag_8664
0166: 6604         BNE.S   check_flag1
0168: 7001         MOVEQ   #1,D0          ; return 1 (valid)
016A: 6030         BRA.S   return
016C: 4A6D D9AE    TST.W   -9810(A5)      ; flag_9810
0170: 6704         BEQ.S   try_more
0172: 7000         MOVEQ   #0,D0          ; return 0 (invalid)
0174: 6026         BRA.S   return
0176: 4EAD 02AA    JSR     JT[682]        ; check_1()
017A: 4A40         TST.W   D0
017C: 6604         BNE.S   fail
017E: 7000         MOVEQ   #0,D0
0180: 601A         BRA.S   return
0182: 4EAD 093A    JSR     JT[2362]       ; check_2()
0186: 4A40         TST.W   D0
0188: 6704         BEQ.S   try_3
018A: 7000         MOVEQ   #0,D0
018C: 600E         BRA.S   return
018E: 4EAD 0502    JSR     JT[1282]       ; check_3()
0192: 4A40         TST.W   D0
0194: 6704         BEQ.S   success
0196: 7000         MOVEQ   #0,D0
0198: 6002         BRA.S   return
019A: 7001         MOVEQ   #1,D0          ; return 1 (valid)
019C: 4E75         RTS
```

```c
short is_position_valid(void) {
    // Check if lookup table has any anchors
    if (check_table(g_lookup_tbl, 289) && !flag_8664)
        return 1;  // table has entries and no override flag

    if (flag_9810) return 0;  // disabled

    // Chain of validation checks - all must pass
    if (!check_1()) return 0;
    if (check_2())  return 0;
    if (check_3())  return 0;

    return 1;  // all checks passed
}
```

This function determines whether the current board state has valid positions for
move generation. The 289-byte `g_lookup_tbl` represents a 17x17 board where each
byte indicates whether that position is an anchor square.

### Function 0x019E - Validate DAWG Bounds (60 bytes)

**Fully verified from hex.** Checks that loaded DAWG data is large enough.

```c
void validate_dawg_bounds(DAWGInfo *header) {
    // Calculate expected total from header fields
    long expected = header->field_10 + header->field_14 + header->field_18;

    // Calculate actual loaded total from globals
    long loaded = g_dawg_ptr + g_sect1_off + g_sect2_off;

    if (loaded < expected) {
        // Copy 34-byte header to global for error reporting
        copy_34bytes(&g_dawg_info, header);
    }
}
```

### Function 0x01DA - Setup with Type Dispatch (138 bytes)

Determines search type and dispatches accordingly. The type ranges map to
different dictionary/search modes:

```c
void setup_with_type_dispatch(void *param) {
    char local_buf[128];

    setup_buffer(param);              // JT[2410]
    byte type = get_search_type(local_buf);  // JT[2394]

    if (type < 8) {
        // Type 0-7: Standard dictionary search
        SearchContext *ctx = g_dawg_ptr2;
        if (ctx->field_14 != 0) {
            data_copy(param, (void*)ctx->field_0E);  // JT[2202]
        }
    } else if (type > 7 && type < 17) {
        // Type 8-16: Special cross-check mode
        SearchContext *ctx = g_dawg_ptr2;
        if (ctx->field_12 != 0) {
            special_handler(param, 0);  // JT[2586]
        }
    } else {
        // Type 17+: Default handler with constant offset
        default_handler(A5+2114, param);  // JT[2130]
    }

    // Always copy g_dawg_field -> g_dawg_info (34 bytes)
    copy_34bytes(&g_dawg_info, &g_dawg_field);
}
```

The type values likely correspond to: 0-7 = TWL dictionary entries, 8-16 = OSW
entries, 17+ = combined/special modes. This aligns with Maven's dual DAWG
architecture (S1 = TWL cross-check, S2 = forward OSW).

### Function 0x0264 - Initialize Search State Buffer (94 bytes)

Allocates a large local buffer, initializes search state, then dispatches to
either the core search (0x069E) or alternate search (0x0C54).

```c
void init_search_state(void) {
    char buf[2968];  // 0xB98 bytes

    memset(buf, 0, 2968);             // JT[426]
    init_search_local(buf);            // PC-relative call to 0x0F68

    // Ensure minimum iteration count of 1
    if (*(short*)(buf + 8) <= 0)
        *(short*)(buf + 8) = 1;

    // Shift left and check lookup table
    // (The hex E3EE F470 at 0x028C is ASL.W #1,-2960(A6))

    if (is_position_valid()) {
        // Valid board state - use core search
        core_search(buf);              // PC-relative to 0x069E
    } else {
        // Fallback - use alternate search
        alternate_search(buf);         // PC-relative to 0x0C54
    }
}
```

The 2968-byte buffer holds a SearchParams structure that gets populated by
`init_search_local` (function at 0x0F68, which reads DAWG data from the
resource fork file).

### Function 0x02C2 - Board State Save/Restore (988 bytes) **CRITICAL**

This is the **make-move / search / unmake-move** pattern that is fundamental to
Scrabble AI move generation. It saves the entire board state, makes a tentative
move, searches for continuations, then restores the board.

**Frame layout** (1808 bytes):
- `-1808(A6)`: pointer to g_field_14 (hook-before buffer)
- `-1804(A6)`: across_count accumulator
- `-1800(A6)`: stored field value
- `-1796(A6)`: pointer to g_field_22 (hook-after buffer)
- `-1792(A6)`: down_count accumulator
- `-1788(A6)`: additional counter
- `-1784(A6)`: saved g_field_22 state (8 bytes)
- `-1776(A6)`: saved g_field_14 state (8 bytes)
- `-1768(A6)`: saved g_state2 (1088 bytes = 17x17x2)
- `-680(A6)`:  saved g_state1 (544 bytes = 17x17)
- `-136(A6)`:  sprintf buffer

**Full verified hex sequence at function start:**
```
02C2: 4E56 F8F0    LINK    A6,#-1808
02C6: 48E7 1F38    MOVEM.L D3-D7/A2-A4,-(SP)
02CA: 282E 000C    MOVE.L  12(A6),D4       ; D4 = second parameter
02CE: 206D D13C    MOVEA.L g_dawg_ptr2,A0
02D2: 4AA8 0004    TST.L   4(A0)           ; check callback pointer
02D6: 6710         BEQ.S   skip_callback
02D8: 2F2D D13C    MOVE.L  g_dawg_ptr2,-(SP)
02DC: 206D D13C    MOVEA.L g_dawg_ptr2,A0
02E0: 2068 0004    MOVEA.L 4(A0),A0        ; A0 = callback function pointer
02E4: 4E90         JSR     (A0)            ; call pre-search callback
02E6: 588F         ADDQ.L  #4,A7

; --- SAVE BOARD STATE ---
02E8: 4878 0220    PEA     $0220           ; 544 = 17*17 + 255
02EC: 486D BCFE    PEA     g_state1        ; source: board letters
02F0: 486E FD58    PEA     -680(A6)        ; dest: local save
02F4: 4EAD 0D8A    JSR     JT[3466]        ; memcpy(local, g_state1, 544)

02F8: 4878 0440    PEA     $0440           ; 1088 = 17*17*4
02FC: 486D BF1E    PEA     g_state2        ; source: board scores
0300: 486E F918    PEA     -1768(A6)       ; dest: local save
0304: 4EAD 0D8A    JSR     JT[3466]        ; memcpy(local, g_state2, 1088)

0308: 486D C366    PEA     g_field_14      ; source: hook-before
030C: 486E F910    PEA     -1776(A6)       ; dest: local save
0310: 4EAD 0DA2    JSR     JT[3490]        ; copy_global(local, g_field_14)

0314: 486D C35E    PEA     g_field_22      ; source: hook-after
0318: 486E F908    PEA     -1784(A6)       ; dest: local save
031C: 4EAD 0DA2    JSR     JT[3490]        ; copy_global(local, g_field_22)
```

```c
short search_with_save_restore(void *param, long search_mode) {
    // Save all board state to local frame
    char saved_state1[544];   // board letters
    char saved_state2[1088];  // board scores
    long saved_field14[2];    // hook-before
    long saved_field22[2];    // hook-after

    // Optional pre-search callback
    SearchContext *ctx = g_dawg_ptr2;
    if (ctx->field_04 != NULL)
        ctx->field_04(ctx);  // virtual call

    memcpy(saved_state1, g_state1, 544);
    memcpy(saved_state2, g_state2, 1088);
    copy_global(saved_field14, &g_field_14);
    copy_global(saved_field22, &g_field_22);

    void *across_ptr = &g_field_14;  // -1808(A6)
    void *down_ptr   = &g_field_22;  // -1796(A6)

    short counter = 0;  // D6
    long D5 = search_mode * 2;  // ADD.L D5,D5 doubles it

    // A4 = D6 * 46 into entry array (via MULS)

    // --- MAIN SEARCH LOOP ---
    for (counter = 0; counter < ctx->field_0C; counter++) {
        long across_score = 0;  // -1792(A6)
        long down_score   = 0;  // -1804(A6)
        long total_score  = 0;  // -1788(A6)

        // A3 = entries[counter] + 24 (into DAWG data area)
        // A3 += g_dawg_ptr2 (adjust to absolute address)
        // A2 = A3 (save copy)

        // If two-direction search enabled:
        if (ctx->field_16 != 0) {
            memset(g_lookup_tbl, 0, 289);     // clear 17x17 anchor table
            memset(A5_minus_10099, 0, 289);   // clear secondary table
            init_anchors(A5+1026);             // JT[1066]
            state_update();                     // JT[1362]
            reset_something();                  // JT[1306]
            set_max_depth(120);                 // JT[1746] with value 120
        }

        // Set up across-direction search
        setup_buffer(across_ptr);              // JT[2410]
        setup_params(A2, across_ptr, 0);       // JT[2370]

        // If DAWG traversal available:
        if (ctx->field_16 != 0) {
            dawg_traverse(A2, 0x00010000);     // JT[362] - DAWG walk
            post_traverse();                    // JT[1234]
        }

        // Accumulate across direction score
        across_score += entries[counter].field_10;
        down_score = entries[counter].field_14;

        // Save current buffer state, set up for down-direction
        copy_global(param_8, down_ptr);        // JT[3490]

        // If debug logging enabled (field_0A != 0):
        if (ctx->field_0A != 0) {
            data_function(down_ptr);           // JT[1346]
            sprintf(local_str, format, down_ptr, A5_minus_28632);
            log_function(ctx->field_0A, local_str, strlen);  // JT[1754]
            // Call local scoring function
            score_position(A2);                // PC-relative call
        }

        // Process across direction
        process_buffer(across_ptr);            // JT[2402]

        // Inner loop: iterate board positions in down direction
        // A3 = down_ptr, A2 = across_ptr
        short pos = 0;  // D3
        while (true) {
            // If two-direction mode:
            if (ctx->field_16 != 0) {
                // Save g_field_14 to local
                copy_global(local_field14, &g_field_14);
                // Set g_field_14 from current down pointer
                copy_global(&g_field_14, (A3));
                state_update();                // JT[1362]
                // Restore g_field_14
                copy_global(&g_field_14, local_field14);
                call_1250();                   // JT[1250]
                post_traverse();               // JT[1234]
                set_max_depth(120);            // JT[1746]
            }

            // Set current buffer pointer
            g_current_ptr = *(A3);             // A5-15498

            // Recursive call to setup_with_type_dispatch
            setup_with_type_dispatch(*(A3));    // PC-relative -> 0x01DA

            // Set up cross-check parameters
            setup_params(g_dawg_info, *(A3), 0);  // JT[2370]
            process_buffer(*(A3));                  // JT[2402]

            // If debug logging:
            if (ctx->field_0A != 0) {
                score_position(g_dawg_info);   // PC-relative
            }

            // If DAWG traversal:
            if (ctx->field_16 != 0) {
                dawg_traverse(g_dawg_info, 0x00010000);  // JT[362]
            }

            // Update DAWG pointers
            g_dawg_ptr += entries[counter].field_04;

            // Swap A2 and A3 (across <-> down pointers)
            // advance_search();               // JT[1738]

            // Check iteration limit
            pos++;
            if (pos < ctx->field_08) {
                // Check result
                if (!check_result())           // JT[2346]
                    continue;                  // keep iterating
            }

            // Check for termination
            if (!check_result())               // JT[2346]
                break;

            // Accumulate scores based on direction
            if (*(down_ptr) == 0) {
                // Only across direction active
                across_score += buffer_compare(across_ptr);  // JT[2122]
            } else if (*(across_ptr) == 0) {
                // Only down direction active
                down_score += buffer_compare(down_ptr);      // JT[2122]
            } else {
                // Both directions active
                across_score += buffer_compare(across_ptr);  // JT[2122]
                down_score += buffer_compare(down_ptr);      // JT[2122]
            }

            // Compute total and multiply
            long total = down_score - across_score;
            long product = multiply(search_mode, total);  // JT[66]
            // Add to running total in DAWG context

            // Debug logging for down direction
            if (ctx->field_0A != 0) {
                long ratio = divide(100, down_score - across_score);  // JT[90]
                sprintf(str, format, ratio);
                log_function(ctx->field_0A, str, strlen);  // JT[1754]
            }

            // Determine which direction pointer to adjust
            if (down_score > across_score) {
                g_size2 += g_dawg_ptr;
                // use g_field_22
            } else if (down_score < across_score) {
                g_size1 += g_dawg_ptr;
                // use g_field_14
            } else {
                // Equal - adjust both
                // use g_field_22
            }
        }

        // --- RESTORE BOARD STATE ---
        memcpy(g_state1, saved_state1, 544);
        memcpy(g_state2, saved_state2, 1088);
        copy_global(&g_field_14, saved_field14);
        copy_global(&g_field_22, saved_field22);

        // Advance counter, check bounds
        counter++;
        // A4 += 46 (next entry)
        // Compare counter < ctx->field_0C, loop back to 0x0346
    }

    // Post-loop: restore g_field_22
    copy_global(&g_field_22, saved_field22);

    // Final processing
    if (ctx->field_10 != 0) {
        // Check completion status
        if (ctx->field_42 > some_threshold) {
            // Save result to g_common via MOVEM pattern
            g_buffer1 = saved_value;
            g_search_index--;
            // ... MOVEM.L (A0)+,regs; JMP (A1)
            return 1;
        }
    }
    return 0;
}
```

**Key insight**: The board state save/restore at 0x02E8-0x031C and 0x060A-0x0638
forms a "sandwich" around the search code. The inner loop at 0x0344-0x0640 performs
the actual move generation, iterating through board positions and accumulating
scores in both across and down directions.

### Function 0x069E - Core Search Loop (1462 bytes) **THE BIG ONE**

This is the central move generation function. It implements the board-traversal
algorithm that finds all legal Scrabble moves.

**Frame layout** (6512 bytes):
- `-6512(A6)` to `-6385(A6)`: saved A5-23218 state (128 bytes)
- `-6384(A6)`: across_only count
- `-6380(A6)`: down_only count
- `-6376(A6)`: unused counter
- `-6372(A6)`: total_positions
- `-6368(A6)`: total_both count
- `-6364(A6)`: total_iter count
- `-6360(A6)`: accumulated score
- `-6224(A6)`: current direction pointer (initially g_field_22)
- `-6208(A6)`: saved g_dawg_ptr
- `-6204(A6)`: saved sprintf result
- `-6200(A6)`: iteration counter (0 to limit)
- `-6198(A6)`: buffer pointer (rotated)
- `-6194(A6)` to `-6174(A6)`: six buffer pointers (rotated circularly)
- `-6162(A6)` to `-1042(A6)`: six 1024-byte buffers (6 x 1024 = 6144 bytes)
- `-18(A6)`: board position loop counter
- `-16(A6)`: saved g_field_14 state

```c
void core_search(void *param) {
    // Store parameter as global context
    g_dawg_ptr2 = param;  // A5-11972

    SearchContext *ctx = g_dawg_ptr2;

    // If dictionary selector is set, compute hash and log
    if (ctx->field_0A != 0) {
        short hash = compute_hash();           // PC-relative to 0x10F0 area
        ctx->field_0A = hash;
        select_dictionary(hash);               // JT[1434]
    }

    // Clear result accumulator
    A5_minus_19486 = 0;

    // Validate lookup table
    if (!check_table(g_lookup_tbl, 289))       // JT[3450]
        assertion_failure();                    // JT[418]

    // Validate search index in range [0, 8)
    if (g_search_index >= 8 || g_search_index < 0)
        assertion_failure();                    // JT[418]

    // --- SAVE SEARCH CONTEXT ---
    short saved_index = g_search_index;
    g_search_index++;
    long offset = saved_index * 44;            // MULS.W #44,D0
    void *entry = (char*)g_common + offset;    // A5-24026 + offset

    // Store tag and save registers
    *(long*)entry = 0;                         // clear tag
    // LEA 6(PC),A1 sets return address
    // MOVEM.L DEF8,(A0) saves 11 registers (44 bytes) to entry
    // After MOVEM, check if this is a restore (D0 != 0 -> exit)
    if (restored) goto epilogue;

    // --- INITIALIZE SEARCH STATE ---
    void *current_dir = &g_field_22;           // -6224(A6)

    // Clear all counters
    long accumulated_score = 0;  // -6360(A6)
    long total_iters = 0;        // -6364(A6)
    long total_both = 0;         // -6368(A6)
    long across_only = 0;        // -6384(A6)
    long down_only = 0;          // -6380(A6)
    long total_unused = 0;       // -6376(A6)
    long total_positions = 0;    // -6372(A6)

    // If two-direction mode:
    if (ctx->field_16 != 0) {
        memset(g_lookup_tbl, 0, 289);      // clear anchor table
        memset(A5_minus_10099, 0, 289);     // clear secondary table
        reset_something();                   // JT[1306]
    }

    // Clear board and cross-check data
    memset(g_state1, 0, 544);              // clear letter grid
    memset(g_state2, 0, 1088);             // clear score grid
    memset(&g_field_14, 0, 8);             // clear hook-before
    memset(&g_field_22, 0, 8);             // clear hook-after
    g_size2 = 0;                            // A5-15502
    g_size1 = 0;                            // A5-15506

    // Select active direction buffer
    if (&g_field_22 != current_dir) {
        g_current_ptr = &g_field_14;
    } else {
        g_current_ptr = &g_field_22;
    }
    current_dir = g_current_ptr;

    // Initialize both direction buffers
    process_buffer(&g_field_14);            // JT[2402]
    process_buffer(&g_field_22);            // JT[2402]

    // Set up six 1024-byte rotating buffers
    void *buffers[6];
    buffers[0] = local_buf_0;  // -6162(A6)
    buffers[1] = local_buf_1;  // -5138(A6)
    buffers[2] = local_buf_2;  // -4114(A6)
    buffers[3] = local_buf_3;  // -3090(A6)
    buffers[4] = local_buf_4;  // -2066(A6)
    buffers[5] = local_buf_5;  // -1042(A6)

    short iteration = 0;  // -6200(A6)

    // If two-direction mode: set up initial cross-checks
    if (ctx->field_16 != 0) {
        copy_global(saved_f14, &g_field_14);
        copy_global(&g_field_14, g_current_ptr);
        state_update();                     // JT[1362]
        call_962();                         // JT[962]
        copy_global(&g_field_14, saved_f14);
    }

    finalize();                             // JT[1650]
    advance_search();                       // JT[1738]

    // --- MAIN BOARD ITERATION LOOP ---
    setup_with_type_dispatch(g_current_ptr);  // call to 0x01DA

    if (check_2())                          // JT[2362]
        goto cleanup;                       // search complete early

    // Validate both direction buffers
    assert(count_entries(&g_field_22) - 1 == 0);  // JT[3522]
    assert(count_entries(&g_field_14) - 1 == 0);  // JT[3522]

    // Clear g_dawg_info and set sentinel
    memset(&g_dawg_info, 0, 34);
    g_dawg_ptr = 0xFFFF8001;  // sentinel value = -32767

    // --- POSITION LOOP ---
    for (iteration = 0; iteration < board_limit; iteration++) {

        // Check abort flag
        if (!A5_minus_17010) {
            // ... (skipped when no abort)
        } else {
            // BOARD POSITION PROCESSING
            // Compute: A0 = A5 + iteration * 34
            //   (indexes into a 34-byte-per-position array)

            // Check if position has a tile: field at (A0)+A610 offset
            // (A610 as signed = approximately -23024, so A5-23024+iter*34)
            // This accesses pre-computed per-position cross-check data

            if (position_has_tile) {
                // Position occupied: check cross-word validity
                if (cross_check_valid) {
                    // Valid cross-word: add score contribution
                    // field_a608 += 100 (base cross-word bonus)
                }

                if (has_adjacent_tile) {
                    // Adjacent tiles: compute cross-check score
                    count = cross_check_score();  // JT[3522]
                }
            } else {
                // Empty position: potential anchor square
                // score = 0
            }

            // Compute total contribution
            // multiply(28, score)            // JT[66] with constant 28 = 0x1C

            // Access DAWG leaf data from A5-10904 area
            // leaf_value = *(long*)(g_frst_handle + iteration * 34 + 24)

            // Update position's accumulated score
        }

        // Update cross-check information for this position
        // Push two zero args + position data + call JT[2530]
        // This populates the cross-check bitmask for the position

        // Compute DAWG bounds for position
        // sum = g_dawg_ptr + g_sect1_off
        // Check against position data
        // If within S1: use TWL cross-check
        // If within S2: use OSW cross-check

        // If total exceeds bounds: copy 34-byte info to g_dawg_info
        copy_34bytes(&g_dawg_info, position_entry);
    }

    // --- POST-ITERATION ---

    // Debug logging (if field_0A set)
    if (ctx->field_0A != 0) {
        data_function(g_current_ptr);         // JT[1346]
        sprintf(str, format, g_current_ptr, buffer);
        log_function(ctx->field_0A, str, len);  // JT[1754]
        score_position(g_dawg_info);           // PC-relative
    }

    // Pass results through rotating buffers
    // Copy 128 bytes from A5-23218 to local buffer
    memcpy(local_6512, A5_minus_23218, 128);  // JT[3466]

    // Rotate buffer pointers (circular shift of 6 pointers)
    void *temp = buffers[0];
    buffers[0] = buffers[1];
    buffers[1] = buffers[2];
    buffers[2] = temp;
    // (similar rotation for buffers[3..5])

    // Set up for next iteration
    setup_params(g_dawg_info, g_current_ptr, 0);  // JT[2370]
    iteration++;
    g_current_ptr = updated_value;
    process_buffer(g_current_ptr);                 // JT[2402]

    // Switch direction: toggle between g_field_14 and g_field_22
    if (&g_field_14 == g_current_ptr) {
        g_size2 += g_dawg_ptr;
        g_current_ptr = &g_field_22;
    } else {
        g_size1 += g_dawg_ptr;
        g_current_ptr = &g_field_14;
    }

    // If DAWG traversal enabled:
    if (ctx->field_16 != 0) {
        dawg_traverse(g_dawg_info, 0x00010000);  // JT[362]
        post_traverse_2();                        // JT[1258]
    }

    // Check for search termination
    if (!check_result())                          // JT[2346]
        goto position_loop;                       // continue iterating

    // Handle size tracking for both directions
    if (g_field_22 != 0 && g_field_14 != 0) {
        // Both directions have data
        g_size1 -= count_entries(&g_field_22);    // JT[2122]
        g_size2 -= count_entries(&g_field_14);    // JT[2122]
    } else if (g_field_14 != 0) {
        g_size1 += count_entries(&g_field_14);    // JT[2122]
    } else {
        assert(g_field_22 != 0);
        g_size2 += count_entries(&g_field_22);    // JT[2122]
    }

    // Accumulate statistics
    total_positions += g_size1;
    total_unused += g_size2;
    accumulated_score += g_size1 * g_size2;
    total_both += iteration;
    total_iters++;

    // Branch based on size comparison
    if (g_size2 < g_size1) {
        down_only++;
        goto position_loop;
    }
    if (g_size1 < g_size2) {
        across_only++;
        goto position_loop;
    }
    across_only++;
    down_only++;
    goto position_loop;

epilogue:
    // --- RESTORE SEARCH CONTEXT ---
    g_search_index--;

    // Restore from g_common if available
    if (compare(saved_buffer, g_buffer1))  {    // JT[3506]
        assert(g_search_index > 0);
        g_buffer1 = saved_value;
        g_search_index--;
        // MOVEM.L (A0)+,regs to restore
        // JMP (A1) to resume
        return 1;
    }

    // Full cleanup: clear everything
    memset(g_state1, 0, 544);
    memset(g_state2, 0, 1088);
    memset(&g_field_14, 0, 8);
    memset(&g_field_22, 0, 8);
    g_size2 = 0;
    g_size1 = 0;

    if (ctx->field_0A != 0)
        restore_dictionary(ctx->field_0A);  // PC-relative

    // Final cleanup calls
    call_1034();              // JT[1034]
    state_update();           // JT[1362]
    post_traverse_2();        // JT[1258]
    call_962();               // JT[962]
    finalize_search();        // JT[1714]
}
```

**Key observations about the core search:**

1. **Six rotating 1024-byte buffers** are used to accumulate search results. These
   are cyclically rotated after each board position is processed, implementing a
   pipeline where results from previous iterations feed into current processing.

2. **Direction alternation**: The search alternates between across (g_field_14) and
   down (g_field_22) directions. The `g_current_ptr` (A5-15498) tracks which
   direction is currently active. After each position, the active direction swaps.

3. **Statistics tracking**: Seven counters track search performance:
   - across_only: positions where only across moves exist
   - down_only: positions where only down moves exist
   - total_positions, total_both, total_iters, accumulated_score, total_unused

4. **setjmp/longjmp pattern**: The MOVEM.L save at the start and the corresponding
   restore at the epilogue implement a non-local jump for search termination. When
   the search finds a result or exhausts possibilities, it can jump directly to
   cleanup without unwinding the entire call stack.

### Function 0x0C54 - Alternate Search Function (446 bytes)

Very similar structure to 0x069E but smaller (1652-byte frame vs 6512-byte frame).
This appears to be a simplified search for positions where only one direction
needs to be checked (e.g., the first move when the board is empty).

Key differences from 0x069E:
- Saves board state to local (like 0x02C2 pattern)
- Has the same search index validation and MOVEM save
- Checks `ctx->field_10` for a different code path (JT[2626] vs JT[2634])
- Has a virtual callback: `if (ctx->field_04) ctx->field_04(ctx)`
- Same epilogue pattern with MOVEM restore and JMP

```c
void alternate_search(void *param) {
    g_dawg_ptr2 = param;
    call_1706();                          // JT[1706] - alternate init

    SearchContext *ctx = g_dawg_ptr2;
    if (ctx->field_0A != 0) {
        short hash = compute_hash();
        ctx->field_0A = hash;
        select_dictionary(hash);          // JT[1434]
    }

    A5_minus_19486 = 0;

    // Save board state
    char saved_state1[544], saved_state2[1088];
    long saved_f14[2], saved_f22[2];
    memcpy(saved_state1, g_state1, 544);
    memcpy(saved_state2, g_state2, 1088);
    copy_global(saved_f14, &g_field_14);
    copy_global(saved_f22, &g_field_22);
    long saved_current = g_current_ptr;

    // Validate and save search context (same MOVEM pattern)
    assert(g_search_index >= 0 && g_search_index < 8);
    // MOVEM.L DEF8,(A0) saves 44 bytes

    // Different dispatch based on ctx->field_10
    if (ctx->field_10 != 0) {
        // Mode with DAWG data
        init_dawg_search(A5+186);         // JT[2626]
        if (ctx->field_04 != NULL) {
            ctx->field_04(ctx);           // virtual callback
        }
    } else {
        // Mode without DAWG
        init_simple_search(A5+186);       // JT[2634]
    }

    g_search_index--;

    // Check for saved result
    if (compare(saved, g_buffer1)) {
        // ... MOVEM restore pattern (same as 0x069E)
    }

    // Restore board state
    memcpy(g_state1, saved_state1, 544);
    memcpy(g_state2, saved_state2, 1088);
    copy_global(&g_field_14, saved_f14);
    copy_global(&g_field_22, saved_f22);
    g_current_ptr = saved_current;

    // Verify restore integrity
    assert(&g_field_14 == g_current_ptr);  // must match!

    setup_buffer(g_current_ptr);           // JT[2410]
    call_2458();                           // JT[2458]

    if (ctx->field_0A != 0)
        restore_dictionary(ctx->field_0A);

    if (ctx->field_16 != 0) {
        call_1034();
        state_update();
    }

    finalize_search();                     // JT[1714]
}
```

### Function 0x0E12 - Trampoline (12 bytes)

Simply wraps a call to the validity check:

```c
void trampoline(void) {
    is_position_valid();  // JSR -3272(PC) = call to 0x0150
}
```

### Function 0x0E1E - Window/Resource Setup (160 bytes)

Sets up a search dialog window with multiple GetResource calls. The hex shows
repeated patterns of `A963` (Mac Toolbox _GetResource trap) with different
resource type codes:

```c
void setup_search_window(void) {
    char local_buf[128];

    // Get multiple resources by type code
    void *r1 = get_named_resource(g_file_ref, 4);   // JT[1522] type 4
    _SetResAttrs(0, 3);                               // A963 trap
    void *r2 = get_named_resource(g_file_ref, 3);   // type 3
    _SetResAttrs(0, 2);
    void *r3 = get_named_resource(g_file_ref, 10);  // type 10
    _SetResAttrs(0, 8);
    void *r4 = get_named_resource(g_file_ref, 8);   // type 8
    A4 = r4;
    _SetResAttrs(0);

    // Initialize search with g_field_14
    setup_buffer(&g_field_14);                        // JT[2410]

    // Get search type
    short type = get_search_type(local_buf);          // JT[2394]
    short flag = (type > 12) ? 255 : 0;

    // Show dialog
    _ParamText(flag);                                  // A95D trap
    // ... dialog handling

    // Restore from A4
    A4 = saved;
}
```

### Function 0x0EBE - Set Resource Attributes (36 bytes)

```c
void set_resource_attrs(void *rsrc, long data) {
    set_resource_data(rsrc, data);                    // JT[3338]
    // Set reference from global
    *(long*)stack = A5_minus_24074;
    set_resource_type(rsrc, 5);                       // JT[3282]
}
```

### Function 0x0EE2 - Open Search File (26 bytes)

Opens a resource file for search data:

```c
void open_search_file(void) {
    // Open resource with specific type
    _SFGetFile(0, A5+146, A5_minus_24034, 0x03F7);   // JT[3218]
}
```

The constant 0x03F7 = 1015 is likely a file type filter.

### Function 0x0EFC - Event Dispatch Loop (108 bytes)

Handles events for the search dialog window. Uses a jump table with 12 cases
(0-11), dispatching different event types:

```c
void event_dispatch(void *file_ref) {
    g_file_ref = file_ref;    // A5-28552
    open_search_file();        // call to 0x0EBE

    while (true) {
        short event_type;
        // _GetNextEvent or _WaitNextEvent
        _ModalDialog(A5+3210, &event_type);   // A991 trap

        if (event_type > 11) continue;  // ignore unknown events

        // Jump table dispatch (12 entries at 0x0F50)
        switch (event_type) {
            case 0: trampoline(); break;              // -> 0x0150
            case 1: open_search_file(); break;        // -> 0x0EBE
            case 2: /* fall through to case 5 */
            case 3: /* fall through */
            case 4: /* fall through */
            case 5:
                get_named_resource(g_file_ref, event_type);
                call_1490();                          // JT[1490]
                break;
            // ... other cases
        }
    }
}
```

The jump table at 0x0F50 contains signed 16-bit offsets:
```
0F50: FFBA FFDA FFE6 FFE6 FFE6 FFBA FFE0 FFBA FFE6 FFBA FFE6 FFFC
```

### Function 0x0F68 - File-Based Search Initialization (308 bytes)

Reads DAWG data from a resource file and initializes the search parameter structure.
This populates the SearchParams structure that gets passed to the main search.

```c
void init_from_file(SearchParams *params) {
    // Read various fields from resource
    params->field_12 = get_word_resource(g_file_ref, 4);   // JT[1506]
    params->field_14 = get_word_resource(g_file_ref, 3);
    params->field_0A = get_word_resource(g_file_ref, 2);
    params->field_10 = get_word_resource(g_file_ref, 8);
    params->field_16 = get_word_resource(g_file_ref, 10);

    // Read string data
    get_string_resource(&local_buf, g_file_ref, 5);  // JT[1602]
    sscanf(local_buf, format, &params->field_08);    // JT[2074]

    // Read iteration count
    long iters = get_long_resource(g_file_ref, 7);   // JT[490]

    // Validate board
    if (!check_table(g_lookup_tbl, 289))             // JT[3450]
        return;  // empty board
    if (flag_8664)
        goto setup_dawg;

    // Get DAWG data handle
    long dawg_handle = get_dawg_handle(0, A5_minus_8520->field_CA);  // JT[2826]
    local_var = dawg_handle;

    // Get size and cap at 64
    short depth = get_size(dawg_handle, 6);          // JT[74]
    if (depth > 64) depth = 64;

    // Set up parameter structure
    params->field_0E = 120;      // 0x78 - max score? time limit?
    params->field_0C = depth;    // capped at 64
    *(long*)params = 200000000;  // 0x0BEBC200 - score threshold
    params->field_04 = A5 + 178; // pointer to callback table

    // Iterate through DAWG entries
    short d4 = 0;
    short d7 = 0;  // entry count
    while (d7 < depth) {
        // Load DAWG entry from handle
        // entry = ***dawg_handle  (triple dereference for Mac handle)
        void *entry_ptr = *(void**)dawg_handle;
        entry_ptr = *(void**)entry_ptr;
        void *dawg_entry = *(void**)(entry_ptr + d4 * 4 + 2);
        A2 = *(void**)dawg_entry;

        // Set up entry fields
        // A0 = A3 + 24 (offset into 46-byte entry)
        // Copy values including total size
        long total = entry->field_10 + entry->field_14 + entry->field_18;
        *(long*)(entry + 0x22) = total;  // store in field_34 of 46-byte entry

        d4++;
        // A3 += 46 (next entry)
        d7++;
    }
}
```

### Function 0x109C - Helper with Format String (84 bytes)

```c
void format_and_dispatch(void *param) {
    char local_buf[128];

    short flag = (param->field_20 != 0) ? -4 : 0;

    // Format with sprintf
    sprintf(local_buf, A5_minus_28478, param, param, flag);  // JT[2066]
    local_ptr = (void*)D0;

    // Dispatch search
    CLR.W (A7);  // push 0
    call_search(param->field_0C, local_ptr, local_buf);  // JT[2866]

    // Verify result
    assert(result != 0);
}
```

### Function 0x10F0 - Open File Dialog (36 bytes)

```c
short open_file_dialog(void) {
    short vRefNum;
    // SFGetFile with type filter 'TEXT'
    _SFPutFile('TEXT', 1, &vRefNum, 0, A5_minus_28526);  // JT[3378]
    return vRefNum;
}
```

### Function 0x1114 - Simple Dispatch (18 bytes)

```c
void simple_dispatch(short param) {
    call_function(0, param);  // JT[2850] with 0 as first arg
}
```

---

## Mapping to Appel-Jacobson Algorithm

Maven's CODE 3 implements a variant of the Appel-Jacobson move generation
algorithm. Here is the mapping:

### Standard Appel-Jacobson:
1. Find anchor squares
2. For each anchor, generate all left parts (prefixes)
3. Extend each prefix rightward through the DAWG
4. Cross-checks constrain which letters can go at each position

### Maven's Implementation:

| A-J Concept | Maven Implementation |
|-------------|---------------------|
| Anchor squares | `g_lookup_tbl` (A5-10388, 289 bytes = 17x17) |
| Cross-check sets | `g_field_14` (hook-before) + `g_field_22` (hook-after) |
| DAWG traversal | JT[362] = CODE 15 DAWG walk |
| Left extension | across_ptr direction in 0x02C2 loop |
| Right extension | down_ptr direction in 0x02C2 loop |
| Board state | `g_state1` (letters) + `g_state2` (scores) |
| Make/unmake move | 0x02C2 save/restore sandwich |
| Move scoring | `buffer_compare` JT[2122], `multiply` JT[66] |
| Iterative deepening | 0x0000's search stack with 65 x 34-byte entries |

### Two-Direction Search

Maven searches both across and down simultaneously, alternating between directions.
The flag at `ctx->field_16` (offset +22 in the context) controls whether two-direction
search is active:

- **field_16 != 0**: Full two-direction search with cross-checks
  - Clear and rebuild anchor tables each iteration
  - Use DAWG traversal (JT[362]) for both directions
  - Track separate across/down scores

- **field_16 == 0**: Single-direction search (used for simpler cases)
  - Skip anchor table operations
  - Skip DAWG traversal calls
  - Only one score accumulator needed

### Cross-Check Mechanism

The two-buffer system implements cross-checks:

- **g_field_14** (A5-15514): "Hook-before" cross-check data. For across moves,
  this contains the set of valid letters looking at the column above and below
  each position.

- **g_field_22** (A5-15522): "Hook-after" cross-check data. For down moves,
  this contains the set of valid letters looking at the row left and right of
  each position.

These are 8-byte structures (likely a pointer + count or a bitmask pair).
The `copy_global` (JT[3490]) and `process_buffer` (JT[2402]) calls manage
these cross-check sets.

During the search:
1. The current direction's cross-checks are loaded
2. Letters are tested against both the DAWG path and the cross-check set
3. If a letter passes both tests, it's a valid placement
4. The other direction's cross-checks are updated to reflect the new tile

---

## The setjmp/longjmp Pattern

A distinctive feature of CODE 3 is the **register snapshot mechanism** used for
search context management. This appears in both 0x069E and 0x0C54:

```
; Save context (like setjmp):
302D A386        MOVE.W  g_search_index,D0
526D A386        ADDQ.W  #1,g_search_index
C1FC 002C        MULS.W  #44,D0
41ED A226        LEA     g_common,A0
D088             ADD.L   A0,D0
2040             MOVEA.L D0,A0           ; A0 -> 44-byte slot
7000             MOVEQ   #0,D0           ; tag = 0 (save mode)
43FA 0006        LEA     6(PC),A1        ; A1 = return address
48D0 DEF8        MOVEM.L regs,(A0)       ; save 11 registers = 44 bytes
4A40             TST.W   D0              ; was this a restore?
6600 xxxx        BNE     epilogue        ; yes -> exit search
```

The restore path (at the epilogue) looks like:
```
536D A386        SUBQ.W  #1,g_search_index
702C             MOVEQ   #44,D0
C1ED A386        MULS.W  g_search_index,D0
41ED A226        LEA     g_common,A0
D088             ADD.L   A0,D0
2040             MOVEA.L D0,A0           ; A0 -> saved slot
7001             MOVEQ   #1,D0           ; tag = 1 (restore mode)
4A40             TST.W   D0
6602             BNE.S   +2              ; always taken
7001             MOVEQ   #1,D0
4CD8 DEF8        MOVEM.L (A0)+,regs      ; restore 11 registers
4ED1             JMP     (A1)            ; jump to saved return address
```

This implements a coroutine-like mechanism: when the search needs to be suspended
or terminated, it restores the saved register snapshot and jumps back to the
point after the original save. The D0 register serves as the discriminator:
D0=0 means "just saved" (continue), D0=1 means "restored" (exit to cleanup).

This is functionally identical to C's `setjmp`/`longjmp` and allows the search
to exit from deep recursion without explicit stack unwinding.

---

## Global Variable Reference

| Offset | Size | Name | Description |
|--------|------|------|-------------|
| A5-28632 | 4 | | Format string pointer for debug logging |
| A5-28628 | ~64 | g_format_buffer | sprintf format buffer |
| A5-28584 | ~64 | | Another format buffer |
| A5-28552 | 4 | g_file_ref | Resource file reference |
| A5-28546 | ~64 | | Format string for sscanf |
| A5-27732 | ~300 | g_buffer1 | Saved search state buffer |
| A5-24074 | 4 | | Resource reference data |
| A5-24034 | 4 | | Resource reference data |
| A5-24030 | 4 | | Saved search state value |
| A5-24026 | 352 | g_common | 8 x 44-byte search context snapshots |
| A5-23674 | 2 | g_search_index | Current search depth (0-7) |
| A5-23218 | 128 | | State buffer (copied to 6512-byte frame) |
| A5-23090 | 34 | g_dawg_info | Current 34-byte DAWG search descriptor |
| A5-23074 | 4 | g_dawg_ptr | DAWG base data pointer |
| A5-23070 | 4 | g_sect1_off | Section 1 offset in DAWG |
| A5-23066 | 4 | g_sect2_off | Section 2 offset in DAWG |
| A5-23056 | 34 | g_dawg_field | Source template for DAWG info copies |
| A5-19486 | 4 | | Result accumulator (cleared at search start) |
| A5-17154 | 544 | g_state1 | Board letter grid (17x17 + padding) |
| A5-17010 | 1 | | Abort flag (checked in position loop) |
| A5-16610 | 1088 | g_state2 | Board score grid (17x17 x 4) |
| A5-15522 | 8 | g_field_22 | Hook-after / down-direction cross-check |
| A5-15514 | 8 | g_field_14 | Hook-before / across-direction cross-check |
| A5-15506 | 4 | g_size1 | DAWG section 1 traversal size |
| A5-15502 | 4 | g_size2 | DAWG section 2 traversal size |
| A5-15498 | 4 | g_current_ptr | Active direction buffer pointer |
| A5-11972 | 4 | g_dawg_ptr2 | Current search context pointer |
| A5-10904 | 4 | g_frst_handle | FRST data handle (pre-computed leaf data) |
| A5-10388 | 289 | g_lookup_tbl | Anchor squares (17x17 board bitmap) |
| A5-10099 | 289 | | Secondary board table (used in 2-dir mode) |
| A5-9810 | 2 | | Validity flag (disables search if set) |
| A5-8664 | 2 | | Override flag (skips anchor check) |
| A5-8520 | 4 | | Application globals handle |

---

## Jump Table Reference

| JT Offset | JT Index | Called From | Purpose |
|-----------|----------|-------------|---------|
| 66 | | 0x0592, 0x0912 | `multiply()` - 32-bit multiply |
| 74 | | 0x1028 | `get_size()` - get resource size |
| 90 | | 0x0058, 0x0096, 0x05B6 | `divide()` - 32-bit divide |
| 362 | | 0x03C6, 0x04E2, 0x0ADA | `dawg_traverse()` - DAWG walk (CODE 15) |
| 418 | | multiple | `assertion_failure()` |
| 426 | | 0x0270, 0x0370, many | `memset()` - clear buffers |
| 490 | | 0x0FEE | `get_long_resource()` |
| 666 | | 0x013E | `copy_buffer()` - copy search results |
| 674 | | 0x003A | `init_function()` |
| 682 | | 0x0176 | `check_1()` - validity check chain |
| 962 | | 0x0832, 0x0C48 | Cross-check initialization |
| 1034 | | 0x0C3C, 0x0E02 | Pre-finalize cleanup |
| 1066 | | 0x0384 | `init_anchors()` - populate anchor table |
| 1234 | | 0x03CE, 0x0482 | `post_traverse()` - after DAWG walk |
| 1250 | | 0x047E | Post-traverse variant |
| 1258 | | 0x0ADE, 0x0C44 | `post_traverse_2()` |
| 1282 | | 0x018E | `check_3()` - validity check chain |
| 1306 | | 0x038C, 0x0762 | `reset_something()` |
| 1346 | | 0x03FA, 0x09E6 | `data_function()` - direction data setup |
| 1362 | | 0x0388, 0x046E, 0x082E, 0x0C40, 0x0E06 | `state_update()` |
| 1434 | | 0x06C6, 0x0C80 | `select_dictionary()` |
| 1490 | | 0x0F44 | Event handler dispatch |
| 1506 | | 0x0F7C-0x0FBC | `get_word_resource()` - read word from resource |
| 1522 | | 0x0E2C-0x0E76 | `get_named_resource()` |
| 1602 | | 0x0FD0 | `get_string_resource()` |
| 1650 | | 0x0142, 0x0846 | `finalize()` |
| 1706 | | 0x0C5E | Alternate search init |
| 1714 | | 0x0C50, 0x0E0A | `finalize_search()` |
| 1738 | | 0x04FC, 0x084A | `advance_search()` |
| 1746 | | 0x0394, 0x048A | `set_max_depth()` |
| 1754 | | 0x0420, 0x05DA, 0x0A0E | `log_function()` - debug logging |
| 2066 | | 0x002E, 0x040A, 0x05C4, 0x09F6 | `sprintf()` |
| 2074 | | 0x0FE0 | `sscanf()` |
| 2122 | | 0x053C, 0x055C, 0x056C, 0x0AFE, 0x0B0C, etc. | `count_entries()` / `buffer_compare()` |
| 2130 | | 0x0244 | Default handler for type 17+ |
| 2202 | | 0x0214 | `data_copy()` |
| 2346 | | 0x050C, 0x0516, 0x0AE4 | `check_result()` - termination check |
| 2362 | | 0x0182, 0x0856 | `check_2()` - validity/completion check |
| 2370 | | 0x03AC, 0x04A4, 0x0A86 | `setup_params()` |
| 2394 | | 0x01F0, 0x0E8E | `get_search_type()` |
| 2402 | | 0x0436, 0x04AA, 0x0A92, 0x07CA, 0x07D2 | `process_buffer()` |
| 2410 | | 0x01E8, 0x039E, 0x0DD6 | `setup_buffer()` |
| 2530 | | 0x0A32 | Cross-check bitmask population |
| 2586 | | 0x0236 | Special handler for type 8-16 |
| 2626 | | 0x0D0E | DAWG search init (with DAWG) |
| 2634 | | 0x0D34 | Simple search init (without DAWG) |
| 2826 | | 0x1018 | `get_dawg_handle()` |
| 3218 | | 0x0EF4 | `_SFGetFile()` wrapper |
| 3282 | | 0x0EDA | Set resource type |
| 3338 | | 0x0ECA | Set resource data |
| 3378 | | 0x1106 | `_SFPutFile()` wrapper |
| 3450 | | 0x0158, 0x0298, 0x06D8, 0x0FFA | `check_table()` - validate 289-byte table |
| 3466 | | 0x02F4, 0x0304, 0x0614, 0x0624, many | `memcpy()` |
| 3490 | | 0x0310, 0x0318, many | `copy_global()` - save/restore global state |
| 3506 | | 0x0BAE, 0x0D48 | Buffer comparison for context restore |
| 3522 | | 0x0866, 0x0878 | `count_entries()` - count buffer entries |

---

## Search Pipeline Summary

```
                    ┌──────────────────────────┐
                    │  init_search_state       │
                    │  (0x0264)                │
                    │  - allocate 2968 bytes   │
                    │  - read from resource    │
                    │  - check board validity  │
                    └────────────┬─────────────┘
                                 │
                    ┌────────────┴─────────────┐
                    │                          │
              valid board?              empty/invalid?
                    │                          │
                    v                          v
        ┌───────────────────┐     ┌──────────────────┐
        │  core_search      │     │ alternate_search  │
        │  (0x069E)         │     │ (0x0C54)          │
        │  - 6512-byte frame│     │ - 1652-byte frame │
        │  - full 2-dir     │     │ - single dir      │
        │  - 6 rotating bufs│     │ - simpler path    │
        └────────┬──────────┘     └──────────────────┘
                 │
    ┌────────────┼────────────────────────┐
    │            │                        │
    v            v                        v
┌────────┐ ┌──────────────┐ ┌──────────────────────┐
│ anchor │ │ search_with  │ │ setup_with_type      │
│ check  │ │ save_restore │ │ dispatch (0x01DA)    │
│(0x0150)│ │ (0x02C2)     │ │ - type 0-7: TWL     │
└────────┘ │ - save board │ │ - type 8-16: OSW    │
           │ - make move  │ │ - type 17+: default │
           │ - search     │ └──────────────────────┘
           │ - unmake     │
           └──────┬───────┘
                  │
                  v
        ┌─────────────────┐
        │ dawg_traverse   │
        │ JT[362] CODE 15 │
        │ - walk DAWG     │
        │ - match letters │
        │ - cross-check   │
        └─────────────────┘
```

---

## Confidence Levels

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Function boundaries | **VERIFIED** | All 16 LINK/UNLK pairs confirmed in hex |
| Frame sizes | **VERIFIED** | LINK immediate operands confirmed |
| 34-byte DAWGInfo copy pattern | **VERIFIED** | DBF loop with 7+word confirmed |
| 44-byte MOVEM context saves | **VERIFIED** | DEF8 mask = 11 registers x 4 |
| Board state save/restore | **VERIFIED** | memcpy sizes 544/1088 match 17x17 |
| setjmp/longjmp pattern | **VERIFIED** | MOVEM save/restore with PC-relative return |
| MULS.W instruction decoding | **VERIFIED** | C1FC=MULS #imm, C3C5=MULS D5,D1 |
| Type dispatch ranges | **HIGH** | 0-7, 8-16, 17+ clearly visible in branch logic |
| Direction alternation | **HIGH** | g_field_14/g_field_22 swap pattern clear |
| Appel-Jacobson mapping | **MEDIUM** | Core concepts match but details approximate |
| Individual JT function purposes | **MEDIUM** | Based on usage context, not code inspection |
| Inner loop position processing | **LOW** | Heavily mangled disassembly in 0x08A4-0x09D8 |
| File I/O functions (0x0E1E-0x1114) | **MEDIUM** | Mac Toolbox traps partially decoded |

---

## Open Questions

1. **What exactly are the 8-byte cross-check structures?** g_field_14 and g_field_22
   are 8 bytes each. Are these pointer+count pairs, or bit-packed cross-check sets?

2. **What is the sentinel value 0xFFFF8001 (-32767)?** Written to g_dawg_ptr at
   0x0892, this likely marks the DAWG info as "uninitialized" or "no valid word".

3. **What do the six rotating 1024-byte buffers hold?** They're allocated in the
   6512-byte frame of 0x069E and cyclically rotated. Likely hold intermediate
   move lists or scoring data for the pipeline.

4. **What is the per-position 34-byte array at the A610/A5F0/A608 offsets?**
   The inner loop of 0x069E indexes with `iteration * 34` into an array that
   holds pre-computed cross-check data per board position.

5. **What distinguishes the core search (0x069E) from the alternate (0x0C54)?**
   The alternate search is invoked when `is_position_valid()` returns false.
   It may handle the opening move (empty board) or endgame scenarios differently.
