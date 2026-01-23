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

**Category**: Dictionary/DAWG
**Function**: Core DAWG Traversal Engine

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

---

## Speculative C Translation

### Data Structures

```c
/*
 * DAWG Node Structure (Directed Acyclic Word Graph)
 *
 * A DAWG is a compressed dictionary representation.
 * Each node represents a letter, with edges to child nodes.
 *
 * Node encoding (speculative - typically 4 bytes):
 *   - Letter (5 bits or 1 byte)
 *   - End-of-word flag (1 bit)
 *   - Last-child flag (1 bit)
 *   - Child pointer (21-26 bits)
 */
typedef struct DAWGNode {
    /* uncertain: exact bit packing */
    unsigned int letter : 5;      /* The letter at this node */
    unsigned int is_word_end : 1; /* This completes a valid word */
    unsigned int is_last_child : 1; /* Last sibling at this level */
    unsigned int child_offset : 25; /* Pointer to first child */
} DAWGNode;

/*
 * DAWG Info Structure - 34 bytes
 * This is the g_dawg_info structure copied to local storage
 */
typedef struct DAWGInfo {
    void* root_ptr;           /* +0: Root of DAWG tree */
    void* current_node;       /* +4: Current position in tree */
    char current_word[16];    /* +8: Word being built */
    short word_length;        /* +24: Current word length */
    short flags;              /* +26: Search flags */
    long score;               /* +28: Accumulated score */
    short extra;              /* +32: Extra data */
} DAWGInfo;

#define DAWG_INFO_SIZE  34
#define SEARCH_LIMIT    127

/* Global variables */
void* g_state_ptr;            /* A5-2770: Current state pointer */
void* g_end_ptr;              /* A5-11980: End comparison pointer */
void* g_secondary_ptr;        /* A5-11976: Secondary pointer */
short g_secondary_counter;    /* A5-11974: Counter */
short g_failed_flag;          /* A5-12540: Search failed indicator */
char g_work_buffer[256];      /* A5-17420: 256-byte work buffer */
short g_search_limit;         /* A5-23026: Maximum search depth */
char g_dawg_field[340];       /* A5-23056: DAWG result field */
char g_dawg_info[34];         /* A5-23090: DAWG configuration */
short g_counter_index;        /* A5-23674: Counter/index value */
void* g_common_ptr;           /* A5-24026: Common data pointer */
void* g_primary_ptr;          /* A5-24030: Primary pointer */
void* g_base_ptr;             /* A5-25752: Base pointer */
```

### Function 0x0000 - Quick Validity Check

```c
/*
 * is_valid_state - Quick check if search state is valid
 *
 * Returns: 1 if valid and should continue, 0 to stop
 */
int is_valid_state(void) {
    /* Compare state pointer with end pointer */
    if (g_state_ptr == g_end_ptr) {
        return 0;  /* At end - stop */
    }

    /* Check byte at offset 26 in state structure */
    char* state = (char*)g_state_ptr;
    if (state[26] == 0) {
        return 1;  /* Flags clear - continue */
    }

    return 0;  /* Flags set - stop */
}
```

### Function 0x001C - Setup Common State

```c
/*
 * setup_common_state - Initialize common pointers for search
 *
 * Returns: 1 on success
 */
int setup_common_state(void) {
    /* Copy base pointer to primary */
    g_primary_ptr = g_base_ptr;  /* A5-24030 = A5-25752 */

    /* Manipulate counter */
    /* uncertain: exact manipulation of A5-23674 */

    /* Get common pointer */
    void* common = &g_common_ptr;  /* A5-24026 */

    /* uncertain: additional setup */

    return 1;
}
```

### Function 0x004A - Main Search with Comparison

```c
/*
 * search_with_compare - Search DAWG with string comparison
 *
 * @param search_param: Parameter for search initialization
 * Returns: 1 if match found, 0 otherwise
 */
int search_with_compare(void* search_param) {
    int result = 0;

    /* Initialize for search */
    init_search_function(search_param);  /* JT[2810] */

    /* Set search limit */
    g_search_limit = SEARCH_LIMIT;  /* 127 */

    /* Bounds check on counter */
    if (g_counter_index >= 8 || g_counter_index < 0) {
        bounds_error();  /* JT[418] */
    }

    /* Calculate offset from counter */
    /* uncertain: exact calculation */

    /* Check if current position is empty */
    if (is_empty_position()) {
        /* Empty - call empty handler */
        empty_handler(CONSTANT_2258);  /* JT[2618] */
        return result;
    }

    /* Non-empty - compare strings */
    int cmp = strcmp(g_primary_ptr, g_base_ptr);  /* JT[3506] */

    if (cmp == 0) {
        /* Strings match */
        result = 1;
    } else {
        /* Different - update state */
        if (g_counter_index <= 0) {
            bounds_error();  /* JT[418] */
        }

        /* uncertain: state update logic */
    }

    return result;
}
```

### Function 0x014A - Main Traversal (Core DAWG Walker)

This is the heart of the DAWG traversal - the largest function with 1766 bytes of local variables.

```c
/*
 * main_dawg_traversal - Core DAWG tree walking function
 *
 * @param search_param: Search parameter/constraint
 * Returns: Pointer to result field, or NULL on failure
 *
 * This function:
 * 1. Copies g_dawg_info to local storage for thread safety
 * 2. Clears working buffers
 * 3. Walks the DAWG tree matching letters
 * 4. Builds up valid words
 * 5. Returns results in g_dawg_field
 */
void* main_dawg_traversal(void* search_param) {
    /*
     * Large local buffer layout:
     *   -1766 to -1762: 4 bytes - unknown
     *   -1762 to -1758: 4 bytes - state pointer
     *   -1758 to -1754: 4 bytes - counter
     *   -1754 to -1720: 34 bytes - local copy of g_dawg_info
     *   -1720 to 0: ~1720 bytes - search state stack, word buffer, etc.
     */
    char local_buffer[1766];
    DAWGInfo* local_dawg_info = (DAWGInfo*)&local_buffer[1766 - 34];
    short* state_counter = (short*)&local_buffer[1766 - 38];
    void** state_ptr = (void**)&local_buffer[1766 - 42];

    /* Copy g_dawg_info to local storage (34 bytes) */
    /* This allows recursive/nested searches without corrupting global state */
    memcpy(local_dawg_info, g_dawg_info, DAWG_INFO_SIZE);

    /* Clear state */
    *state_counter = 0;

    /* Initialize state pointer */
    init_state_pointer(state_ptr);  /* JT[1690] */

    /* Clear DAWG field result area (340 bytes = 10 moves * 34 bytes) */
    memset(g_dawg_field, 0, 340);  /* JT[426] */

    /* Run internal search */
    int found = internal_dawg_search(search_param);  /* PC-relative call */

    if (!found) {
        /* Search found nothing - set failure flag and return */
        g_failed_flag = 1;
        return g_dawg_field;
    }

    /* Process results */
    process_dawg_results();    /* PC-relative call at +1220 */
    finalize_search();         /* PC-relative call at -174 */

    /* Clear work buffer (256 bytes) */
    memset(g_work_buffer, 0, 256);  /* JT[426] */

    /* Continue with extended processing... */
    /* uncertain: remaining ~400 lines of code */

    return g_dawg_field;
}
```

### DAWG Traversal Helper Functions

```c
/*
 * traverse_to_letter - Move to child node for given letter
 *
 * @param current: Current DAWG node
 * @param letter: Letter to find
 * Returns: Child node for letter, or NULL if not found
 */
DAWGNode* traverse_to_letter(DAWGNode* current, char letter) {
    /* uncertain: exact node structure and traversal */

    if (current == NULL) {
        return NULL;
    }

    /* Get first child */
    DAWGNode* child = get_first_child(current);

    /* Search siblings for matching letter */
    while (child != NULL) {
        if (get_letter(child) == letter) {
            return child;  /* Found it */
        }

        if (child->is_last_child) {
            break;  /* No more siblings */
        }

        child = get_next_sibling(child);
    }

    return NULL;  /* Letter not found */
}

/*
 * is_complete_word - Check if current node marks end of valid word
 */
int is_complete_word(DAWGNode* node) {
    return node->is_word_end;
}

/*
 * build_word_recursive - Recursively build words from DAWG
 *
 * @param node: Current DAWG node
 * @param word_buffer: Buffer to build word into
 * @param depth: Current recursion depth
 * @param rack: Available letters (rack + board)
 * @param callback: Function to call for each valid word
 */
void build_word_recursive(DAWGNode* node,
                          char* word_buffer,
                          int depth,
                          char* rack,
                          void (*callback)(char* word)) {
    if (node == NULL || depth > g_search_limit) {
        return;
    }

    /* Add this letter to word */
    word_buffer[depth] = get_letter(node);
    word_buffer[depth + 1] = '\0';

    /* Check if this is a complete valid word */
    if (is_complete_word(node)) {
        callback(word_buffer);
    }

    /* Get first child for deeper traversal */
    DAWGNode* child = get_first_child(node);

    /* Try each child that we have letters for */
    while (child != NULL) {
        char needed_letter = get_letter(child);

        if (has_letter(rack, needed_letter)) {
            /* Remove letter from rack temporarily */
            remove_letter(rack, needed_letter);

            /* Recurse */
            build_word_recursive(child, word_buffer, depth + 1,
                                 rack, callback);

            /* Restore letter */
            add_letter(rack, needed_letter);
        }

        if (child->is_last_child) {
            break;
        }
        child = get_next_sibling(child);
    }
}
```

### Search State Management

```c
/*
 * The search uses a large stack frame to maintain state:
 *
 * 1. Local copy of g_dawg_info prevents corruption during
 *    nested searches (e.g., checking cross-words while
 *    building main word)
 *
 * 2. Word buffer accumulates letters as we traverse
 *
 * 3. State stack tracks position in DAWG for backtracking
 *
 * 4. Results stored in g_dawg_field (340 bytes = 10 moves)
 */
typedef struct SearchState {
    DAWGNode* node;           /* Current DAWG position */
    int rack_index;           /* Which rack letter we're using */
    int word_length;          /* Letters placed so far */
    long accumulated_score;   /* Score for this path */
} SearchState;

#define MAX_SEARCH_DEPTH 15   /* Max word length */

/*
 * Stack-based iterative traversal (alternative to recursion)
 */
void iterative_dawg_search(void* constraint) {
    SearchState stack[MAX_SEARCH_DEPTH];
    int stack_top = 0;

    /* Initialize with root */
    stack[0].node = get_dawg_root();
    stack[0].rack_index = 0;
    stack[0].word_length = 0;
    stack[0].accumulated_score = 0;

    while (stack_top >= 0) {
        SearchState* current = &stack[stack_top];

        /* Try next letter/child */
        DAWGNode* next_child = try_next_child(current);

        if (next_child != NULL) {
            /* Push new state */
            stack_top++;
            stack[stack_top].node = next_child;
            stack[stack_top].word_length = current->word_length + 1;
            /* ... copy other state ... */
        } else {
            /* Pop - backtrack */
            stack_top--;
        }

        /* Check for valid word at current position */
        if (is_complete_word(current->node)) {
            record_valid_word(current);
        }
    }
}
```

### Usage in Move Generation

```c
/*
 * DAWG is used throughout move generation:
 *
 * 1. Word Validation: Check if a word exists in dictionary
 *    - Traverse DAWG following letters
 *    - Word exists if we reach end-of-word marker
 *
 * 2. Word Generation: Find all words makeable from rack
 *    - Start at root, try each rack letter
 *    - Recursively build all valid words
 *
 * 3. Anchor Search: Find words through anchor squares
 *    - Pre-traverse DAWG for prefix before anchor
 *    - Continue traversal using rack letters
 *
 * 4. Cross-Check: Verify perpendicular words are valid
 *    - Build cross-word from board letters + placed tile
 *    - Traverse DAWG to verify
 */
int validate_word(char* word) {
    DAWGNode* node = get_dawg_root();

    for (char* p = word; *p; p++) {
        node = traverse_to_letter(node, *p);
        if (node == NULL) {
            return 0;  /* No path for this letter */
        }
    }

    return is_complete_word(node);
}
```
