# Maven CODE 3: Annotated Disassembly with C Translation

## Compiler Identification

**Probable Compiler**: THINK C 5.x or Symantec C++ 6.x

**Evidence**:
- LINK A6,#-n prologue pattern (standard Mac)
- MOVEM.L saves D3-D7/A2-A4 (THINK C convention)
- A5 for global data (QuickDraw globals)
- JSR d(A5) for inter-segment calls via jump table

**CODE Resource Header**:
```
JT offset: 112 (0x70)
JT entries: 6
Code size: 4390 bytes
```

---

## Function 0x0000: Main DAWG Search Function

This is the largest function with a 2282-byte stack frame, suggesting it's
a major search or enumeration routine.

### Prologue

```asm
0000: 4E56F716      LINK       A6,#-2282
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
```

```c
/*
 * Speculative function signature:
 * void dawg_search(SearchContext *ctx)
 *
 * Stack frame: 2282 bytes of locals
 * Saved registers: D3-D7, A2-A4 (all callee-saved)
 */
void dawg_search(SearchContext *ctx) {
    char locals[2282];  // -2282(A6) to -1(A6)
    // Compiler saves D3-D7, A2-A4
```

### Parameter Access

```asm
0008: 7018          MOVEQ      #24,D0
000A: D0AE0008      ADD.L      8(A6),D0        ; D0 = param + 24
000E: 2840          MOVEA.L    D0,A4           ; A4 = &param->field_24
0010: 2C2C002A      MOVE.L     42(A4),D6       ; D6 = param->field_24->field_42
0014: 206E0008      MOVEA.L    8(A6),A0        ; A0 = param
0018: 0C680040000C  CMPI.W     #64,12(A0)      ; if (param->field_12 > 64)
001E: 6F04          BLE.S      $0024
0020: 4EAD01A2      JSR        418(A5)         ;     call_bounds_check()
```

```c
    SearchContext *param = ctx;  // 8(A6)

    // UNCERTAIN: What is field_24? Possibly pointer to DAWG data
    DawgData *dawg = (DawgData *)((char*)param + 24);  // A4
    long count = dawg->some_count;  // field_42, stored in D6

    if (param->max_depth > 64) {  // field_12
        bounds_check();  // via A5 jump table at offset 418
    }
```

### Buffer Initialization

```asm
0024: 2F06          MOVE.L     D6,-(A7)        ; push count
0026: 486D902C      PEA        -28628(A5)      ; push global buffer address
002A: 486EFFC1      PEA        -63(A6)         ; push local buffer
002E: 4EAD0812      JSR        2066(A5)        ; call init_function
0032: 1D40FFC0      MOVE.B     D0,-64(A6)      ; store result
```

```c
    // Call initialization with global at A5-28628 and local at -63(A6)
    char result = init_function(locals + 2219, global_buffer, count);
    locals[-64] = result;  // Actually at -64(A6)
```

### Loop Setup

```asm
0044: 6602          BNE.S      $0048
0046: 7C01          MOVEQ      #1,D6           ; if D6==0, D6=1
0048: 7A00          MOVEQ      #0,D5           ; D5 = 0 (loop counter)
004A: 206E0008      MOVEA.L    8(A6),A0
004E: 3828000C      MOVE.W     12(A0),D4       ; D4 = param->field_12
0052: 48780002      PEA        $0002.W         ; push 2
0056: 2F06          MOVE.L     D6,-(A7)        ; push count
0058: 4EAD005A      JSR        90(A5)          ; call via jump table
005C: 2D40F71A      MOVE.L     D0,-2278(A6)    ; store result
```

```c
    if (count == 0) {
        count = 1;  // Ensure at least one iteration
    }
    int i = 0;  // D5 = loop counter
    short max_iter = param->field_12;  // D4

    long base_offset = some_calc(count, 2);  // Result to local at -2278
```

### Main Loop

```asm
0060: 7222          MOVEQ      #34,D1          ; D1 = 34 (ENTRY SIZE!)
                                               ; NOTE: This is 34 bytes, not 4!
0064: 47EEF740      LEA        -2240(A6),A3    ; A3 = local array base
006C: 600000B8      BRA.W      $0128           ; Jump to loop test
```

```c
    // IMPORTANT: Entry size is 34 bytes, not 4!
    // This is NOT the DAWG entry size but a search state structure
    #define STATE_SIZE 34

    SearchState *states = (SearchState *)&locals[-2240];  // A3
    // goto loop_test;
```

### Loop Body (0x0070 - 0x0126)

```asm
; Loop iteration - processes one search state
0070: 702E          MOVEQ      #46,D0          ; D0 = 46
0072: C1C4          MULS       D4,D0           ; D0 = 46 * max_iter
0074: 2440          MOVEA.L    D0,A2           ; A2 = offset
0076: 204C          MOVEA.L    A4,A0           ; A0 = dawg pointer

; Copy 34 bytes (8 longs + 1 word)
007C: 7007          MOVEQ      #7,D0           ; copy 8 longs
007E: 22D8          MOVE.L     (A0)+,(A1)+
0080: 51C8FFFC      DBF        D0,$007E        ; loop 8 times
0084: 32D8          MOVE.W     (A0)+,(A1)+     ; copy final word
```

```c
    while (/* condition at 0x0128 */) {
        // Calculate offset into some array
        long offset = 46 * max_iter;  // UNCERTAIN: what is 46?

        // Copy 34 bytes from dawg data to local
        memcpy(dest, dawg, 34);  // 8 longs + 1 word = 34 bytes
```

### DAWG Field Access (Critical Section)

```asm
009A: 2E00          MOVE.L     D0,D7           ; D7 = some value
009C: 2007          MOVE.L     D7,D0
009E: 90AB0014      SUB.L      20(A3),D0       ; D0 -= state->field_20
00A2: 90AB0010      SUB.L      16(A3),D0       ; D0 -= state->field_16
00A6: 27400018      MOVE.L     D0,24(A3)       ; state->field_24 = D0
```

```c
        // DAWG offset calculation
        // Fields at 16, 20, 24 match DAWG header fields!
        long adjusted = value - states->offset_0x14 - states->offset_0x10;
        states->computed = adjusted;  // field_24 = offset 0x18
```

### Loop Increment

```asm
00BC: 45EA0022      LEA        34(A2),A2       ; A2 += 34 (ENTRY SIZE)
```

```c
        // Advance to next state (34 bytes per state)
        current_state += STATE_SIZE;
```

### Loop Test

```asm
00C0: 202A0010      MOVE.L     16(A2),D0       ; D0 = state->field_10
00C4: D0AA0014      ADD.L      20(A2),D0       ; D0 += state->field_14
00C8: D0AA0018      ADD.L      24(A2),D0       ; D0 += state->field_18
00CC: B087          CMP.L      D7,D0           ; compare with limit
00CE: 6EE2          BGT.S      $00B2           ; if > limit, continue
```

```c
        // Loop condition: sum of three fields > limit
        long sum = states->f10 + states->f14 + states->f18;
    } while (sum > limit);
```

### Epilogue

```asm
0142: 4EAD0672      JSR        1650(A5)        ; final call
0146: 4CEE          DC.W       $4CEE           ; MOVEM.L (restore)
014C: 4E5E          UNLK       A6
014E: 4E75          RTS
```

```c
    finalize();
    // Compiler restores saved registers
    return;
}
```

---

## Function 0x0150: Query Function

Short function that checks various global flags.

```asm
0150: 3F3C0121      MOVE.W     #$0121,-(A7)    ; push 289
0154: 486DD76C      PEA        -10388(A5)      ; push global address
0158: 4EAD0D7A      JSR        3450(A5)        ; call lookup
015C: 4A40          TST.W      D0              ; test result
015E: 5C8F          ADDQ.L     #6,A7           ; clean stack
0160: 670A          BEQ.S      $016C           ; if zero, skip
0162: 4A6DDE28      TST.W      -8664(A5)       ; test global flag 1
0166: 6604          BNE.S      $016C
0168: 7001          MOVEQ      #1,D0           ; return 1
016A: 6030          BRA.S      $019C
016C: 4A6DD9AE      TST.W      -9810(A5)       ; test global flag 2
0170: 6704          BEQ.S      $0176
0172: 7000          MOVEQ      #0,D0           ; return 0
```

```c
/*
 * Boolean query_state(void)
 * Checks various global flags and returns status
 */
int query_state(void) {
    int result = lookup_table(global_at_A5_10388, 289);

    if (result != 0 && global_flag_8664 == 0) {
        return 1;
    }
    if (global_flag_9810 != 0) {
        return 0;
    }
    // ... more flag checks follow
}
```

---

## Function 0x019E: DAWG Bounds Validation

This is the bounds check function called from the main search.

```asm
019E: 4E560000      LINK       A6,#0           ; no locals
01A2: 2F0C          MOVE.L     A4,-(A7)        ; save A4
01A4: 286E0008      MOVEA.L    8(A6),A4        ; A4 = parameter
01A8: 202C0010      MOVE.L     16(A4),D0       ; D0 = param->field_10
01AC: D0AC0014      ADD.L      20(A4),D0       ; D0 += param->field_14
01B0: 222DA5DE      MOVE.L     -23074(A5),D1   ; D1 = global_dawg_ptr
01B4: D2ADA5E2      ADD.L      -23070(A5),D1   ; D1 += global_offset_1
01B8: D2ADA5E6      ADD.L      -23066(A5),D1   ; D1 += global_offset_2
01BC: D0AC0018      ADD.L      24(A4),D0       ; D0 += param->field_18
01C0: B280          CMP.L      D0,D1           ; compare loaded vs expected
01C2: 6C10          BGE.S      $01D4           ; if OK, skip
```

```c
/*
 * void validate_dawg_bounds(DawgHeader *hdr)
 * Compares header size fields with loaded DAWG size
 */
void validate_dawg_bounds(DawgHeader *hdr) {
    // Sum header size fields
    long expected = hdr->size_0x10 + hdr->size_0x14 + hdr->size_0x18;

    // Sum global size values
    // A5-23074 = main DAWG pointer
    // A5-23070, A5-23066 = additional offsets
    long loaded = g_dawg_ptr + g_offset1 + g_offset2;

    if (loaded < expected) {
        // Copy header to global structure (error handling?)
        memcpy(&g_dawg_info, hdr, 34);
    }
}
```

---

## Key Data Structures (Speculative)

```c
/*
 * Search State Structure - 34 bytes
 * Used in main search loop
 */
typedef struct SearchState {
    // Offsets based on disassembly field accesses
    char unknown_0x00[16];    // 0x00-0x0F
    long offset_0x10;         // 0x10: DAWG offset/size 1
    long offset_0x14;         // 0x14: DAWG offset/size 2
    long offset_0x18;         // 0x18: DAWG offset/size 3
    char unknown_0x1C[6];     // 0x1C-0x21
} SearchState;  // Total: 34 bytes (0x22)

/*
 * DAWG Header Structure
 * First 32 bytes of maven2 file
 */
typedef struct DawgHeader {
    long size1;               // 0x00: 56630
    long size2;               // 0x04: 122166
    long size3;               // 0x08: 145476
    long reserved;            // 0x0C: 768
    // Letter index follows at 0x10
} DawgHeader;

/*
 * DAWG Entry - 4 bytes
 * Stored at file offset 0x0410+
 */
typedef struct DawgEntry {
    unsigned short ptr;       // Child pointer (index into groups)
    unsigned char flags;      // Bit 7: word, Bit 0: last sibling
    char letter;              // ASCII letter (a-z)
} DawgEntry;

/*
 * Global Variables (via A5)
 */
// A5-23074: DawgEntry *g_dawg_entries;
// A5-23070: long g_section1_size;
// A5-23066: long g_section2_size;
// A5-15506: long g_dawg_size1;  // = 56630
// A5-15502: long g_dawg_size2;  // = 65536
// A5-11972: void *g_dawg_data;
```

---

## Confidence Levels

| Section | Confidence | Notes |
|---------|------------|-------|
| Function boundaries | HIGH | LINK/UNLK/RTS patterns clear |
| Register usage | HIGH | Standard Mac C conventions |
| Stack frame sizes | HIGH | Directly from LINK offsets |
| Parameter passing | MEDIUM | 8(A6) is first param, standard |
| Loop structures | MEDIUM | DBF and branch patterns clear |
| Field offsets | MEDIUM | Consistent with DAWG header |
| Structure sizes | LOW | 34-byte state is unusual |
| Variable purposes | LOW | Speculative based on context |
| Function names | LOW | Entirely speculative |

---

## Open Questions

1. **Why 34-byte structure?** DAWG entries are 4 bytes. The 34-byte structure
   appears to be a search state, not a DAWG entry.

2. **Multiple size fields**: The three fields at 0x10, 0x14, 0x18 match the
   DAWG header. Are they being validated or used for offset calculations?

3. **Jump table offsets**: Many JSR d(A5) calls. Need to map these to
   actual function addresses to understand call graph.

4. **The value 46**: Appears in multiplication. Might be related to
   board size (15x3?) or some internal constant.

5. **Global at A5-28628**: Large negative offset suggests a substantial
   global data area. Might be the main game state structure.
