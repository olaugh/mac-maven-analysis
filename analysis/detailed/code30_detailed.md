# CODE 30 Detailed Analysis - DAWG Traversal Engine

## Overview

| Property | Value |
|----------|-------|
| Size | 3,492 bytes |
| JT Offset | 2168 |
| JT Entries | 12 |
| Functions | 15 |
| Purpose | **Core DAWG traversal and word matching** |


## System Role

**Category**: Scoring
**Function**: Position Scoring

Position-based score calculation
## Architecture Role

CODE 30 appears to be the **actual DAWG traversal engine** - it:
1. Copies g_dawg_info to local storage for search
2. Manages word matching state
3. Tracks position in the DAWG tree
4. Uses large local buffers for search states

## Key Functions

### Function 0x0000 - Quick Validity Check
```asm
0000: MOVE.L     -2770(A5),D0     ; D0 = some_ptr
0004: CMP.L      -11980(A5),D0    ; compare with another ptr
0008: BEQ.S      $0014            ; if equal, return 0
000A: MOVEA.L    -2770(A5),A0     ; A0 = some_ptr
000E: TST.B      26(A0)           ; check byte at offset 26
0012: BEQ.S      $0018            ; if zero, return 1
0014: MOVEQ      #0,D0
0016: BRA.S      $001A
0018: MOVEQ      #1,D0
001A: RTS
```

**C equivalent**:
```c
int is_valid_state(void) {
    void* ptr = *(void**)(A5-2770);
    if (ptr == *(void**)(A5-11980)) return 0;
    if (((char*)ptr)[26] == 0) return 1;
    return 0;
}
```

### Function 0x001C - Setup Common State
```asm
001C: LINK       A6,#0
0020: MOVE.L     -25752(A5),-24030(A5)  ; copy pointer
0026: ... manipulate A5-23674 ...
0030: LEA        -24026(A5),A0    ; A0 = g_common
0034: ...
0038: MOVEQ      #1,D0            ; return 1
...
0048: RTS
```

**Purpose**: Initialize common state pointers.

### Function 0x004A - Main Search with Comparison
```asm
004A: LINK       A6,#0
004E: MOVE.L     D7,-(A7)         ; save D7
0050: MOVEQ      #0,D7            ; D7 = 0 (result)
0052: MOVE.L     8(A6),-(A7)      ; push param
0056: JSR        2810(A5)         ; call init function

; Set up search limit
005A: MOVE.W     #$007F,-23026(A5) ; limit = 127

; Validate bounds
0060: CMPI.W     #8,-23674(A5)    ; if value >= 8
0068: BCC.S      $0070            ; skip
006A: TST.W      -23674(A5)       ; if value < 0
006E: BGE.S      $0074            ; skip
0070: JSR        418(A5)          ; bounds_error()

; Calculate offset
0074: MOVE.W     -23674(A5),D0
0078: ...
0082: ...

; Check if empty - call different path
0094: BNE.S      $00A6
0096: PEA        2258(A5)         ; push constant
009A: JSR        2618(A5)         ; call empty_handler
...
00A4: BRA.S      $00EC

; Non-empty path - compare
00A6: MOVE.L     -24030(A5),-(A7) ; push ptr1
00AA: MOVE.L     -25752(A5),-(A7) ; push ptr2
00AE: JSR        3506(A5)         ; call compare()
00B2: TST.W      D0
00B6: BNE.S      $00BC
00B8: MOVEQ      #1,D7            ; result = 1 (different)
00BA: BRA.S      $00EC

; Same - update state
00BC: TST.W      -23674(A5)
00C0: BGT.S      $00C6
00C2: JSR        418(A5)          ; bounds_error
00C6: ... update state ...

00EC: MOVE.W     D7,D0            ; return result
00EE: MOVE.L     (A7)+,D7
00F0: UNLK       A6
00F2: RTS
```

**C equivalent**:
```c
int search_with_compare(void* param) {
    int result = 0;

    init_function(param);
    g_search_limit = 127;

    // Bounds check
    if (g_counter >= 8 || g_counter < 0) {
        bounds_error();
    }

    // Calculate offset...

    if (is_empty()) {
        empty_handler(2258);
    } else {
        if (compare(g_ptr1, g_ptr2) == 0) {
            result = 1;  // Different
        } else {
            // Update state for match...
        }
    }
    return result;
}
```

### Function 0x014A - Main Traversal (Large Frame)
```asm
014A: LINK       A6,#-1766        ; 1766 bytes of locals!
014E: MOVEM.L    D5-D7/A2-A4,-(SP)

; Copy 34-byte g_dawg_info to local
0152: LEA        -1754(A6),A0     ; dest = local buffer
0156: LEA        -23090(A5),A1    ; src = g_dawg_info
015A: MOVEQ      #7,D0            ; 8 longs
015C: MOVE.L     (A1)+,(A0)+
015E: DBF        D0,$015C
0162: MOVE.W     (A1)+,(A0)+      ; + 1 word = 34 bytes

; Clear state
0164: CLR.W      -1758(A6)
0168: PEA        -1762(A6)
016C: JSR        1690(A5)         ; init something

; Clear 340 bytes of g_dawg_field area
0170: PEA        $0154.W          ; push 340
0174: PEA        -23056(A5)       ; push g_dawg_field (g_dawg_?)
0178: JSR        426(A5)          ; memset(g_dawg_field, 0, 340)

; Call search function
017C: MOVE.L     8(A6),(A7)       ; push param
0180: JSR        -312(PC)         ; call local function
0184: TST.W      D0
018A: BNE.S      $019C

; If search failed, set flag and return early
018C: MOVE.W     #1,-12540(A5)    ; set flag
0192: LEA        -23056(A5),A0    ; return g_dawg_field
0196: MOVE.L     A0,D0
0198: BRA.W      $065C            ; jump to epilogue

; Search succeeded - continue processing
019C: JSR        1220(PC)         ; call processing
01A0: JSR        -174(PC)         ; call another function

; Clear 256 bytes
01A4: PEA        $0100.W          ; push 256
01A8: PEA        -17420(A5)       ; push buffer
01AC: JSR        426(A5)          ; memset
```

**Purpose**: This is the main DAWG traversal function. It:
1. Copies g_dawg_info to local storage (34 bytes)
2. Clears working buffers (340 bytes, 256 bytes)
3. Performs search via local function calls
4. Returns pointer to result (g_dawg_field)

**C equivalent**:
```c
void* main_traversal(void* param) {
    char local_dawg_info[34];
    char other_locals[1766 - 34];

    // Copy DAWG info to local
    memcpy(local_dawg_info, &g_dawg_info, 34);

    state_var = 0;
    init_something(&local_var);

    // Clear working area
    memset(&g_dawg_field, 0, 340);

    // Perform search
    if (!do_search(param)) {
        g_failed_flag = 1;
        return &g_dawg_field;  // Return early
    }

    // Process results
    process_results();
    another_function();

    memset(buffer_17420, 0, 256);
    // ... continue processing ...
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-2770 | State pointer |
| A5-11980 | Comparison pointer |
| A5-11976 | Related pointer |
| A5-11974 | Counter |
| A5-12540 | Failed flag |
| A5-17420 | 256-byte buffer |
| A5-23026 | Search limit (127) |
| A5-23056 | g_dawg_field (340 bytes) |
| A5-23090 | g_dawg_info (34 bytes) |
| A5-23674 | Counter/index |
| A5-24026 | g_common |
| A5-24030 | Pointer |
| A5-25752 | Pointer |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418(A5) | bounds_error |
| 426(A5) | memset |
| 1690(A5) | init_state |
| 2618(A5) | empty_handler |
| 2810(A5) | init_function |
| 3506(A5) | compare |

## Local Buffer Layout (Function 0x014A)

```
-1766 to -1762: 4 bytes - unknown
-1762 to -1758: 4 bytes - state pointer
-1758 to -1754: 4 bytes - counter
-1754 to -1720: 34 bytes - local copy of g_dawg_info
-1720 to 0: ~1720 bytes - working storage
```

## Key Insight

CODE 30 is where the **actual DAWG tree walking** happens. The large local buffers (~1766 bytes) store:
- The current search state
- Path through the DAWG tree
- Intermediate results

The flow is:
1. Copy g_dawg_info (configuration)
2. Clear working buffers
3. Walk the DAWG tree
4. Compare found words with constraints
5. Return results in g_dawg_field

## Confidence: HIGH

The structure is clear:
- Large frame for search state
- 34-byte g_dawg_info copy
- Multiple nested searches (PC-relative calls)
- Compare and bounds checking
- Result returned via global pointer
