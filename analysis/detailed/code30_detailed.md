# CODE 30 Detailed Analysis - Alpha-Beta Search Tree Manager

## Overview

| Property | Value |
|----------|-------|
| Size | 3,492 bytes (code) + 4 byte header |
| JT Offset | 2168 |
| JT Entries | 12 |
| Functions | 22 (15 with LINK, 7 leaf/internal) |
| Purpose | **Alpha-beta search tree management with coroutine state save/restore** |
| Confidence | **HIGH** |

## System Role

CODE 30 is the **search tree manager** for Maven's pre-endgame alpha-beta engine. It is NOT a DAWG traversal engine (the earlier analysis was incorrect). CODE 30 manages a pool of 32-byte search nodes organized as an alpha-beta game tree, with a novel coroutine-style state save/restore mechanism (setjmp/longjmp pattern) for suspending and resuming search.

Key responsibilities:
1. Search node pool management (allocation, free-list, initialization)
2. Alpha-beta bound propagation (negamax window inversion)
3. Tree pruning to reclaim nodes when pool is exhausted
4. Score scaling (centipoints to/from base points, factor of 100)
5. Board state save/restore for speculative move evaluation
6. Coroutine state stack for suspending/resuming search positions
7. Integration with move generation (DAWG-based expansion) and scoring pipelines

## Architecture

### Disassembler Corrections

The automated disassembler mangles several recurring instruction patterns in this module. The corrected decodings are:

| Hex Pattern | Disassembler Output | Correct Decoding |
|-------------|-------------------|------------------|
| `EB88` | `ASL.B D5,D0` or similar | `LSL.L #5,D0` (multiply by 32) |
| `D0AD xxxx` | `MOVE.L A0,...` | `ADD.L xxxx(A5),D0` |
| `C1FC xxxx` | `ANDA.L #...` | `MULS.W #xxxx,D0` |
| `C1ED xxxx` | `ANDA.L xxxx(A5),A0` | `MULS.W xxxx(A5),D0` |
| `81FC xxxx` | `ORA.L #...` | `DIVS.W #xxxx,D0` |
| `526D xxxx` | `MOVEA.B ...` | `ADDQ.W #1,xxxx(A5)` |
| `536D xxxx` | `MOVE.B ...` | `SUBQ.W #1,xxxx(A5)` |
| `588F` | `MOVE.B A7,(A4)` | `ADDQ.L #4,A7` (stack cleanup) |
| `508F` | `MOVE.B A7,(A0)` | `ADDQ.L #8,A7` (stack cleanup) |
| `5C8F` | `MOVE.B A7,(A6)` | `ADDQ.L #6,A7` (stack cleanup) |
| `48D0 DEF8` | `DC.W $48D0` | `MOVEM.W DEF8,(A0)` (save regs) |
| `4CD8 DEF8` | `DC.W $4CD8` | `MOVEM.W (A0)+,DEF8` (restore regs) |
| `4ED1` | misread | `JMP (A1)` |
| `9A88` | various | `SUB.L A0,D5` |
| `B0AD xxxx` | `MOVE.W ...,(A0)` | `CMP.L xxxx(A5),D0` |
| `B9ED xxxx` | `MOVE.W ...` | `CMPA.L xxxx(A5),A4` |
| `B1EE xxxx` | `MOVE.W ...` | `CMPA.L xxxx(A6),A0` |
| `EA80` | `MOVE.L D0,(A5)` | `ASR.L #5,D0` (divide by 32) |

### Node Addressing Idiom

The most frequent pattern in this module (15 occurrences) is the node address calculation:

```asm
; Convert node index (word) to node pointer
MOVE.L  Dn,D0          ; D0 = node index (from sibling/child field)
EXT.L   D0             ; sign-extend to long
LSL.L   #5,D0          ; D0 = index * 32 (node size)
ADD.L   -11980(A5),D0  ; D0 += g_node_base
MOVEA.L D0,An          ; An = pointer to node
```

This computes: `node_ptr = g_node_base + index * 32`.

### Coroutine State Save/Restore (setjmp/longjmp)

CODE 30 implements a coroutine mechanism using a stack of 44-byte entries at `g_state_stack` (A5-24026). Each entry stores 11 registers (22 bytes via MOVEM.W) plus additional state.

**Save (inline, like setjmp):**
```asm
MOVE.W  -23674(A5),D0      ; D0 = stack_depth (old value)
ADDQ.W  #1,-23674(A5)      ; stack_depth++
MULS.W  #44,D0             ; offset = old_depth * 44
LEA     -24026(A5),A0      ; A0 = g_state_stack base
ADD.L   A0,D0              ; D0 = &entry[old_depth]
MOVEA.L D0,A0              ; A0 = entry pointer
MOVEQ   #0,D0              ; D0 = 0 ("first call" marker)
LEA     6(PC),A1           ; A1 = continuation address (after MOVEM)
MOVEM.W DEF8,(A0)          ; save D3-D7,A1-A4,A6,A7 to entry
; falls through to continuation with D0=0
TST.W   D0
BNE.S   <restored_path>    ; NOT taken (D0=0 = first call)
; ... first-call code path ...
```

**Restore (function at 0x001C, like longjmp):**
```asm
SUBQ.W  #1,-23674(A5)      ; stack_depth--
MOVEQ   #44,D0
MULS.W  -23674(A5),D0      ; offset = new_depth * 44
LEA     -24026(A5),A0
ADD.L   A0,D0
MOVEA.L D0,A0              ; A0 = &entry[new_depth]
MOVEQ   #1,D0              ; D0 = 1 ("restored" marker)
; always branches to:
MOVEM.W (A0)+,DEF8         ; restore D3-D7,A1-A4,A6,A7
JMP     (A1)               ; jump to saved continuation
; arrives at same TST.W D0 / BNE.S
; D0=1 -> BNE taken -> restored code path
```

Register mask DEF8 saves: D3, D4, D5, D6, D7, A1, A2, A3, A4, A6, A7 (11 registers, 22 bytes). D0 is intentionally excluded so it can carry the first-call/restored discriminator. A0 is excluded because it serves as the entry pointer. A5 is excluded because it is the global base (never changes).

---

## 32-Byte Search Node Structure

Each node in the search tree pool occupies 32 bytes:

| Offset | Size | Field | Purpose |
|--------|------|-------|---------|
| +0 | word | `alpha` | Alpha bound (lower score bound, centipoints) |
| +2 | word | `beta` | Beta bound (upper score bound, centipoints) |
| +4 | word | `child` | Index of first child node (0 = leaf) |
| +6 | word | `next` | Index of next sibling (0 = last in chain) |
| +8 | word | reserved | |
| +10 | word | `score` | Evaluation score (centipoints) |
| +12 | long | `move_ref` | Reference to associated move/position data |
| +16 | byte | `is_terminal` | Terminal/leaf flag |
| +17-23 | 7 bytes | reserved | |
| +24 | byte | `depth_info` | Depth-related field |
| +25 | byte | `limit` | Search depth limit (127 = maximum) |
| +26 | byte | `flag_done` | Done/pruned flag (checked by `is_valid_node`) |
| +27 | byte | `field_1B` | Position data |
| +28 | byte | `field_1C` | Direction/constraint flag |
| +29 | byte | `field_1D` | Position data |
| +30 | byte | `in_progress` | Currently being processed (set 1 during traversal) |
| +31 | byte | padding | |

The `create_mirror_node` function confirms the alpha-beta interpretation:
```c
mirror->alpha = -parent->beta;   // negamax window inversion
mirror->beta  = -parent->alpha;
```

Sentinel value: `0xF4143E00` = -200,000,000 decimal (= -2,000,000 points in centipoints), used as negative infinity for alpha-beta bounds initialization.

---

## Function Map

| Offset | End | Size | Frame | Name | Purpose |
|--------|-----|------|-------|------|---------|
| 0x0000 | 0x001A | 28 | none | `is_valid_node` | Check if g_current_node is valid for continued search |
| 0x001C | 0x0048 | 46 | 0 | `restore_coroutine` | Pop state stack and resume saved execution (longjmp) |
| 0x004A | 0x00F2 | 170 | 0 | `push_and_compare` | Save coroutine state, compare nodes, handle search step |
| 0x00F4 | 0x0148 | 86 | none | `init_node_pool` | Zero all nodes, build free list |
| 0x014A | 0x0660 | 1304 | 1766 | `generate_moves` | Main move generation/alpha-beta search orchestrator |
| 0x0662 | 0x06CA | 106 | none | `scale_scores_div` | Divide all board scores by 100 (centipointsto points) |
| 0x06CC | 0x0728 | 94 | none | `scale_scores_mul` | Multiply all board scores by 100 (points to centipoints) |
| 0x072A | 0x079E | 118 | 0 | `find_in_subtree` | Search subtree for node matching position criteria |
| 0x07A0 | 0x07EC | 78 | 4 | `create_mirror_node` | Create negamax opponent node (negate+swap alpha/beta) |
| 0x07EE | 0x07F6 | 10 | none | `clear_child` | Clear current node's child pointer |
| 0x07F8 | 0x08B8 | 194 | 8 | `evaluate_position` | Compute position score using board lookup + find_in_subtree |
| 0x08BA | 0x091E | 102 | 0 | `find_best_leaf` | Find best-scoring leaf in a subtree |
| 0x0920 | 0x09C0 | 162 | 0 | `update_bounds` | Minimax bound propagation across children |
| 0x09C2 | 0x0A96 | 214 | 0 | `prune_subtree` | Alpha-beta pruning: remove nodes below cutoff |
| 0x0A98 | 0x0AC0 | 42 | 4 | `free_node` | Return node to free list |
| 0x0AC2 | 0x0AF2 | 50 | none | `update_all_nodes` | Iterate all allocated nodes, call update_bounds |
| 0x0AF4 | 0x0B40 | 78 | 0 | `set_node_letter` | Set evaluation parameter on a node's children |
| 0x0B42 | 0x0BB6 | 118 | none | `alloc_node` | Allocate node from free list (prunes if empty) |
| 0x0BB8 | 0x0C1C | 102 | 0 | `link_child` | Link a new child node to a parent |
| 0x0C1E | 0x0CCC | 176 | 0 | `insert_move` | Insert a move into the search tree as a node |
| 0x0CCE | 0x0D60 | 148 | 0 | `extract_move` | Extract/copy move data from search node back to move struct |
| 0x0D62 | 0x0DA2 | 66 | 0 | `iterate_children` | Call function pointer on each child of current node |

---

## Function-by-Function Analysis

### 0x0000: is_valid_node (28 bytes, no frame)

Checks whether the global current search node (`g_current_node` at A5-2770) is valid for continued processing.

```c
/* Returns 1 if node is valid and should continue processing, 0 otherwise */
int is_valid_node(void) {
    if (g_current_node == g_node_base)  // reached sentinel/root
        return 0;
    if (g_current_node->flag_done == 0) // not yet pruned/finished
        return 1;
    return 0;
}
```

**Hex verification:** `202D F52E` = MOVE.L -2770(A5),D0; `B0AD D134` = CMP.L -11980(A5),D0; `670A` = BEQ.S; `4A28 001A` = TST.B 26(A0).

---

### 0x001C: restore_coroutine (46 bytes, LINK #0)

The "longjmp" half of the coroutine mechanism. Pops the state stack and resumes execution at the saved continuation point.

```c
/* Restore saved coroutine state (longjmp equivalent) */
void restore_coroutine(void) {
    g_saved_node = g_alt_node;          // A5-24030 = A5-25752
    g_stack_depth--;                     // A5-23674
    StateEntry* entry = &g_state_stack[g_stack_depth];
    // Restore 11 registers from entry, jump to saved continuation
    // D0 = 1 (restored marker) - discriminates from first-call path
}
```

The UNLK/RTS at the end of this function are unreachable since `JMP (A1)` transfers control to the saved continuation address.

---

### 0x004A: push_and_compare (170 bytes, LINK #0)

Saves the current search state via the coroutine mechanism, then either initializes a new search position or compares the current state with a reference.

```c
int push_and_compare(void* search_ctx) {
    int result = 0;
    JT_init_search(search_ctx);              // JT[2810]
    g_search_limit = 127;                     // A5-23026

    // Bounds-check stack depth (0..7)
    assert(g_stack_depth >= 0 && g_stack_depth < 8);

    // Compute state entry pointer
    StateEntry* entry = &g_state_stack[g_stack_depth++];

    // === SAVE (setjmp) ===
    // D0=0 path (first call): fall through
    // D0=1 path (restored): jump to end

    if (/* first call (D0==0) */) {
        if (/* position empty */) {
            JT_empty_handler(/*constant*/);   // JT[2618]
        } else {
            int cmp = JT_compare(g_saved_node, g_alt_node);  // JT[3506]
            if (cmp == 0) {
                result = 1;  // nodes match -> new position needed
            } else {
                // Update state for continued search
                // Restore coroutine: decrement depth, restore regs
            }
        }
    }
    return result;
}
```

---

### 0x00F4: init_node_pool (86 bytes, no frame)

Zeroes the entire node pool and builds a free list by linking each node's `next` field to the following node's index.

```c
void init_node_pool(void) {
    assert(g_node_base != NULL);
    memset(g_node_base, 0, g_node_count * 32);  // clear all nodes
    g_free_index = 1;                             // head of free list

    // Build free list: node[i].next = i+1, last.next = 0
    int i = g_node_field - 1;
    node_at(i)->next = 0;                         // last node: end of list
    while (--i >= 0) {
        node_at(i)->next = i + 1;                 // link to successor
    }
}
```

**Hex verification:** `EB88` = LSL.L #5,D0 (index * 32); `4270 0806` = CLR.W 6(A0,D0.L) (clear next field at +6).

---

### 0x014A: generate_moves (1304 bytes, LINK #-1766)

This is the central orchestrator function for Maven's pre-endgame search. With a 1766-byte stack frame, it:

1. **Saves DAWG configuration** locally (34 bytes from g_dawg_info)
2. **Copies board state** to local buffers (544 + 1088 = 1632 bytes)
3. **Runs the alpha-beta search loop**, iterating through candidate moves
4. **Tracks best moves** using alpha/beta bounds with the -200M sentinel
5. **Expands moves** using DAWG-based word generation
6. **Restores state** after each speculative evaluation

#### Local Frame Layout (1766 bytes)

| Offset | Size | Purpose |
|--------|------|---------|
| FP-1766 | 4 | Temp storage |
| FP-1762 | 4 | State pointer (JT[1690] init) |
| FP-1758 | 2 | DAWG flag |
| FP-1756 | 2 | Saved g_board_orient (A5-19470) |
| FP-1754 | 34 | Local copy of g_dawg_info |
| FP-1720 | 30 | Search state / move buffer |
| FP-1690 | 2 | Score accumulator |
| FP-1686 | 4 | Track: worst beta score |
| FP-1682 | 4 | Track: worst alpha score |
| FP-1678 | 4 | Track: best alpha score |
| FP-1674 | 4 | Swap temp |
| FP-1670 | 4 | Current iteration node pointer |
| FP-1666 | 4 | Best node (alpha criterion) |
| FP-1662 | 4 | Best node (beta criterion) |
| FP-1658 | 4 | Best move reference |
| FP-1654 | 4 | Saved g_node_base |
| FP-1650 | 1088 | g_state2 copy (32 rows x 17 words) |
| FP-562 | 544 | g_state1 copy (17 rows x 32 bytes) |
| FP-18 | 4 | Saved A4 (cross-check buffer) |
| FP-10 | 4 | Saved A2 (search context) |
| FP-2 | 2 | Iteration counter |

#### Pseudocode (simplified)

```c
void* generate_moves(void* search_ctx) {
    // Save DAWG info locally (34 bytes)
    DAWGInfo local_dawg;
    memcpy(&local_dawg, &g_dawg_info, 34);
    short dawg_flag = 0;

    JT_init_state(&local_state);                    // JT[1690]
    memset(g_dawg_field, 0, 340);                   // JT[426]

    // Initial search attempt
    if (!push_and_compare(search_ctx)) {
        g_failed_flag = 1;
        return &g_dawg_field;  // early exit
    }

    // Scale scores: divide by 100 (centipoints -> points)
    scale_scores_div();
    init_node_pool();
    memset(g_work_buffer, 0, 256);

    // Select cross-check buffer (hook-before or hook-after)
    void* cross_buf;
    if (g_field_22 == search_ctx)
        cross_buf = g_field_14;
    else if (g_field_14 == search_ctx)
        cross_buf = g_field_22;
    else
        error();

    // Initialize scoring tables
    JT_setup_buffer(cross_buf);                     // JT[2410]
    JT_setup_params(cross_buf);                     // JT[2386]
    JT_setup_buffer(search_ctx);                    // JT[2410]
    JT_setup_params(search_ctx);                    // JT[2386]

    // Save board state to local frame
    memcpy(local_state1, g_state1, 544);            // JT[3466]
    memcpy(local_state2, g_state2, 1088);           // JT[3466]
    saved_orient = g_board_orient;

    // Save search context pointers
    JT_save_context(search_ctx, &saved1);           // JT[3490]
    JT_save_context(cross_buf, &saved2);            // JT[3490]
    saved_node_base = g_node_base;

    // === COROUTINE SAVE (setjmp) ===
    // First-call path (D0=0) continues below
    // Restored path (D0!=0) jumps to post_loop

    // ---- MAIN SEARCH LOOP ----
    iteration_count = 0;
    g_current_node = saved_node_base;
    iter_node = saved_node_base;

    while (g_current_node != NULL) {
        // is_valid_node check
        if (g_current_node != g_node_base) {
            iteration_count++;
            assert(iteration_count < 200);  // safety limit
            iter_node = g_current_node;

            // Set up scoring context
            JT_setup_buffer(search_ctx);            // JT[2410]
            JT_setup_more();                        // JT[2434]
            extract_move(g_current_node, &local_move);
            JT_prepare_scoring(search_ctx, &local_move, score);  // JT[2370]
            JT_score_position(score);               // JT[2450]
            JT_save_context(score, search_ctx);     // JT[3490]

            // Swap contexts for opponent's perspective
            swap(search_ctx, cross_buf);
        }

        // Advance to next: find_best_leaf and get sibling
        g_current_node = find_best_leaf(g_current_node);
    }

    // Restore iteration pointer
    g_current_node = iter_node;

    // Bounds validation
    assert(g_current_node >= g_node_base);
    assert(g_current_node < g_node_base + g_node_count * 32);

    // Final scoring pass
    JT_final_score(cross_buf, search_ctx);          // JT[2802]
    update_bounds(g_node_base);
    best_move = find_best_leaf(g_node_base);

    // Track best/worst scores with -200M sentinel
    long min_beta = -200000000, max_alpha = -200000000;
    long min_alpha = -200000000;

    // Iterate children of root, track extremes
    short child_idx = g_node_base->child;
    while (child_idx) {
        Node* child = node_at(child_idx);
        short s10 = child->score;    // EXT.L
        short s0 = child->alpha;     // field0
        short s2 = child->beta;      // field2

        if (best_move != NULL) {
            if (s0 > max_alpha) {
                best_alpha_ptr = iter_node;
                max_alpha = s0;
            }
        }
        if (s2 > min_alpha || (s2 == min_alpha && s0 > min_beta)) {
            best_beta_ptr = iter_node;
            min_alpha = s2;
            min_beta = s0;
        }

        child_idx = child->next;
    }

    // Select best move: prefer alpha, fall back to beta or best_move
    if (best_move == best_beta_ptr) {
        if (saved_node_base == best_move) {
            if (best_alpha_ptr)
                new_base = best_alpha_ptr;
            else
                new_base = best_move;
        }
    } else {
        new_base = best_move;
    }

    // Restore board state from local frame
    memcpy(g_state1, local_state1, 544);
    memcpy(g_state2, local_state2, 1088);

    // Restore context pointers
    // ... swap back A2/A4 ...

    // Check DAWG flag and limit
    if (dawg_flag == 0) dawg_flag = g_position_limit;  // A5-2764
    if (g_position_limit + dawg_flag <= g_node_count) {
        // Budget check: enough room for expansion?
        JT_check_budget(&local_state);              // JT[1698]
        if (budget < param3) {
            // Expand best move's subtree via DAWG
            // ... DAWG-based move expansion loop ...
        }
    }

    // Clean up and return
    JT_init_search(search_ctx);                     // JT[2810]
    g_failed_flag = 0;
    g_best_score = 0;

    // Second pass: iterate children, expand via DAWG
    child_idx = g_node_base->child;
    while (child_idx) {
        Node* child = node_at(child_idx);
        // ... DAWG lookup and move insertion ...
        extract_move(g_current_node, &g_dawg_info);
        if (dawg_flag && !g_dawg_info.done) {
            // Score comparison with JT[2122]
            // Update DAWG pointers (g_dawg_ptr, g_sect1_off, g_sect2_off)
            // Insert into search tree
        }
        JT_process_dawg(&g_dawg_info);              // JT[2322]
        JT_store_result(&g_dawg_info);              // JT[2114]
        child_idx = child->next;
    }

    // Restore state via coroutine mechanism or direct return
    // Restore g_dawg_info from local copy
    memcpy(&g_dawg_info, &local_dawg, 34);
    g_board_orient = saved_orient;
    scale_scores_mul();  // restore centipoint scaling

    return &g_dawg_field;
}
```

---

### 0x0662: scale_scores_div (106 bytes, no frame)

Divides all score values by 100, converting from centipoints to base points. Operates on three data areas: the 32x17 score grid (g_state2), a 128-entry score array (A5-27630), and a single extra score value (A5-26026).

```c
void scale_scores_div(void) {
    // 32x17 score grid: 32 rows, 17 columns, stride 34 bytes
    short* row = (short*)g_state2;  // A5-16610
    for (int r = 0; r < 32; r++) {
        for (int c = 0; c < 17; c++) {
            row[c] /= 100;
        }
        row = (short*)((char*)row + 34);  // advance by row stride
    }
    // 128-entry score array
    short* arr = (short*)(A5 - 27630);
    for (int i = 0; i < 128; i++) {
        arr[i] /= 100;
    }
    // Single extra score
    g_extra_score /= 100;  // A5-26026
}
```

**Hex verification:** `81FC 0064` = DIVS.W #100,D0; `0C46 0011` = CMPI.W #17,D6 (column count); `0C47 0020` = CMPI.W #32,D7 (row count); `49EC 0022` = LEA 34(A4),A4 (row stride).

---

### 0x06CC: scale_scores_mul (94 bytes, no frame)

The inverse of `scale_scores_div`: multiplies all scores by 100 to restore centipoint representation. Same iteration structure, using MULS.W instead of DIVS.W.

```c
void scale_scores_mul(void) {
    short* row = (short*)g_state2;
    for (int r = 0; r < 32; r++) {
        for (int c = 0; c < 17; c++) {
            row[c] = (short)(row[c] * 100);
        }
        row = (short*)((char*)row + 34);
    }
    for (int i = 0; i < 128; i++) {
        g_array128[i] = (short)(g_array128[i] * 100);
    }
    g_extra_score = (short)(g_extra_score * 100);
}
```

**Hex verification:** `7064` = MOVEQ #100,D0; `C1D0` = MULS.W (A0),D0.

---

### 0x072A: find_in_subtree (118 bytes, LINK #0)

Searches a subtree for a node matching specific position criteria. Takes a node pointer, target position, and search flags as parameters.

```c
Node* find_in_subtree(Node* root, long target_pos, short flags) {
    if (flags == 2) return NULL;                  // skip flag
    if (root->move_ref == target_pos) return root; // direct match

    short child_idx = root->child;
    short depth = 1 + (short)flags;               // search depth

    while (child_idx != 0) {
        Node* child = node_at(child_idx);
        short match = (child->flag_done == 0) ? depth : 0;
        Node* result = find_in_subtree(child, target_pos, match);  // recursive
        if (result != NULL)
            return result;
        child_idx = child->next;
    }
    return NULL;
}
```

---

### 0x07A0: create_mirror_node (78 bytes, LINK #-4)

Creates a negamax opponent node by allocating a new node, linking it as a child of the current node, and setting its alpha/beta bounds to the negation of the parent's (with swap).

```c
void create_mirror_node(void) {
    Node* mirror = alloc_node();
    if (mirror == NULL) return;

    mirror->limit = 127;                          // 0x7F = max depth
    link_child(g_current_node, mirror);

    // Negamax window inversion: opponent's (alpha,beta) = (-beta,-alpha)
    mirror->alpha = -(g_current_node->beta);
    mirror->beta  = -(g_current_node->alpha);

    assert(g_current_node->child != 0);           // must have children now
}
```

**Hex verification:** `197C 007F 0019` = MOVE.B #$7F,25(A4); `4440` = NEG.W D0 (negate score); `3880` = MOVE.W D0,(A4) and `3940 0002` = MOVE.W D0,2(A4).

---

### 0x07EE: clear_child (10 bytes, no frame)

Tiny helper that clears the child pointer of the current search node.

```c
void clear_child(void) {
    g_current_node->child = 0;
}
```

---

### 0x07F8: evaluate_position (194 bytes, LINK #-8)

Evaluates a board position by computing hash-like lookups into the board state and finding matching nodes in the search tree.

```c
Node* evaluate_position(void* ctx, long row_pos, long col_pos) {
    long hash1 = JT_hash_position(g_state1, row_pos);   // JT[3442]
    long val1 = JT_transform(ctx);                        // JT[3522]
    long hash2 = JT_hash_position(ctx, col_pos);          // JT[3442]
    long val2 = JT_transform(col_pos);                     // JT[3522]
    long hash3 = JT_hash_position(col_pos);                // JT[3442]

    long combined = hash1 + hash2 + hash3;
    JT_accumulate(combined);                               // JT[2594]

    if (combined == 0) combined = 1;  // avoid zero

    Node* found = find_in_subtree(g_node_base, combined, 0);
    if (found == NULL) {
        g_current_node->move_ref = combined;
        return NULL;
    }

    // Copy fields from found node to current node
    g_current_node->move_ref = combined;
    g_current_node->child = found->child;
    g_current_node->beta = found->beta;
    g_current_node->alpha = found->alpha;

    // Check for terminal: if child==0 and beta==alpha, return 0
    if (g_current_node->child == 0) {
        if (g_current_node->beta == g_current_node->alpha)
            return NULL;
    }
    return found;
}
```

---

### 0x08BA: find_best_leaf (102 bytes, LINK #0)

Traverses children of a node to find the one with the best (most negative for opponent, or most positive) evaluation score.

```c
Node* find_best_leaf(Node* root) {
    short use_terminal = (root != g_node_base) ?
        (root->is_terminal == 0 ? 1 : 0) : 0;

    long best_score = -200000000;  // sentinel
    Node* best = NULL;

    short child_idx = root->child;
    while (child_idx != 0) {
        Node* child = node_at(child_idx);
        long child_score = (long)child->score;
        // ... scoring logic with SUB for relative comparison ...
        if (child_score > best_score) {
            if (use_terminal == 0 || child->is_terminal == 0) {
                best_score = child_score;
                best = child;
            }
        }
        child_idx = child->next;
    }
    return best;
}
```

---

### 0x0920: update_bounds (162 bytes, LINK #0)

Propagates minimax bounds up the tree. After a child's evaluation completes, this function updates the parent's alpha/beta bounds based on all children's scores.

```c
void update_bounds(Node* node) {
    // Validate node is within pool
    assert(node >= g_node_base && node < g_node_base + g_node_count * 32);

    short child_idx = node->child;
    if (child_idx == 0) return;         // leaf: nothing to propagate
    if (node->in_progress) return;      // avoid re-entry
    node->in_progress = 1;

    long best_alpha = -200000000;
    long best_beta = best_alpha;

    while (child_idx != 0) {
        Node* child = node_at(child_idx);
        assert(child->next != 0 || /* last */);
        update_bounds(child);           // recursive

        long c_score = (long)child->score;
        long c_alpha = (long)(child->alpha);
        long c_beta  = (long)(child->beta);

        // Track minimum (worst-case for opponent = best for us in negamax)
        if (c_alpha < best_beta)
            best_beta = c_alpha;
        if (c_beta < best_alpha)
            best_alpha = c_beta;

        child_idx = child->next;
    }

    assert(best_beta <= 0);  // scores should be non-positive after negation
    node->beta = (short)best_beta;
    node->alpha = (short)best_alpha;
    node->in_progress = 0;
}
```

---

### 0x09C2: prune_subtree (214 bytes, LINK #0)

Alpha-beta pruning: removes nodes whose bounds prove they cannot affect the final result. Reclaims pruned nodes by returning them to the free list.

```c
void prune_subtree(Node* node) {
    assert(node == g_current_node);
    assert(node->in_progress == 0);
    node->in_progress = 1;

    if (node->field_1C) {
        assert(node->child == 0);  // shouldn't have children if constrained
    }

    long threshold = -200000000;  // sentinel

    // First pass: find minimum beta among children
    short child_idx = node->child;
    while (child_idx != 0) {
        Node* child = node_at(child_idx);
        long c_beta = (long)(child->beta);
        if (c_beta < threshold)
            threshold = c_beta;
        child_idx = child->next;
    }

    // Second pass: prune children with alpha above threshold
    short* link_ptr = &node->child;
    while (*link_ptr != 0) {
        Node* child = node_at(*link_ptr);
        long c_score = (long)child->score;
        long c_alpha = (long)(child->alpha);

        if (c_score > threshold ||
            (c_score == threshold && child->alpha != child->beta)) {
            // Keep: update link and check child's subtree
            short next_idx = child->next;
            if (next_idx < 0 || next_idx >= g_node_count)
                error();
            *link_ptr = child->next;
            // ... further processing ...
        } else if (child->beta == 0) {
            // Trivial: clear child's children
            child->child = 0;
        } else {
            // Prune: recursively free subtree
            prune_subtree(child);
        }
        link_ptr = &child->next;
    }
    node->in_progress = 0;
}
```

---

### 0x0A98: free_node (42 bytes, LINK #-4)

Returns a node to the free list by clearing it and prepending it to the free chain.

```c
void free_node(Node* node) {
    memset(node, 0, 32);                           // JT[426]
    node->next = g_free_index;                     // link to old head
    g_free_index = (node - g_node_base) >> 5;      // new head = node index
    // Note: ASR.L #5 = divide byte offset by 32
}
```

**Hex verification:** `4878 0020` = PEA $20 (32 bytes); `316D F532 0006` = MOVE.W g_free_index,6(A0); `91ED D134` = SUBA.L g_node_base,A0; `EA80` = ASR.L #5,D0.

---

### 0x0AC2: update_all_nodes (50 bytes, no frame)

Iterates through all allocated nodes (from g_node_base through g_node_base + g_node_count*32) and calls `update_bounds` on each non-in-progress node.

```c
void update_all_nodes(void) {
    Node* end = g_node_base + g_node_count * 32;
    Node* node = g_node_base;
    while (node < end) {
        if (!node->in_progress)
            free_node(node);            // reclaim unvisited nodes
        node = (Node*)((char*)node + 32);
    }
}
```

---

### 0x0AF4: set_node_letter (78 bytes, LINK #0)

Sets a parameter value (typically a letter index for DAWG lookup) on a node and recursively propagates to all descendants.

```c
void set_node_letter(Node* node, short letter) {
    if (node->in_progress + 30 == letter)   // already set check
        return;

    node->in_progress_byte = letter;        // +30 offset
    short child_idx = node->child;
    while (child_idx != 0) {
        Node* child = node_at(child_idx);
        set_node_letter(child, letter);      // recursive
        child_idx = child->next;
    }
}
```

---

### 0x0B42: alloc_node (118 bytes, no frame)

Allocates a search node from the free list. If the free list is empty, triggers pruning to reclaim nodes, then retries.

```c
Node* alloc_node(void) {
    if (g_free_index == 0) {
        // Free list empty: prune tree to reclaim nodes
        prune_subtree(g_node_base);
        set_node_letter(g_node_base, 1);
        JT_recalculate();                       // JT[2594]
        update_all_nodes();
        set_node_letter(g_node_base, 0);

        if (g_free_index == 0)
            return NULL;                         // still no free nodes
    }

    // Bounds check
    assert(g_free_index >= 0 && g_free_index < g_node_count);

    Node* node = node_at(g_free_index);
    g_free_index = node->next;                   // pop from free list
    memset(node, 0, 32);                         // JT[426]
    return node;
}
```

---

### 0x0BB8: link_child (102 bytes, LINK #0)

Links a child node into a parent's child chain. Validates the child index and computes the relative offset for the parent's child pointer.

```c
void link_child(Node* parent, Node* child) {
    short* child_ptr = &parent->child;   // +4 offset
    short child_idx = *child_ptr;

    // Validate existing child index
    assert(child_idx >= 0 && child_idx < g_node_count);

    // Verify child is in pool
    short existing_offset = *child_ptr;
    assert(node_at(existing_offset) != NULL);

    // Set child's sibling to current child
    child->next = *child_ptr;

    // Validate new child is within pool bounds
    assert(child >= g_node_base && child < g_node_base + g_node_count * 32);

    // Compute child's index and store
    *child_ptr = (child - g_node_base) >> 5;
}
```

---

### 0x0C1E: insert_move (176 bytes, LINK #0)

Inserts a move into the search tree by allocating a node, copying position/score data from the move structure, and building a board-row string representation in the node's data area.

```c
void insert_move(Node* move_src, long low_bound, long high_bound,
                 short alpha_val, short beta_val) {
    Node* new_node = alloc_node();
    if (new_node == NULL) return;

    assert(low_bound <= high_bound);

    // Copy position metadata from move source to new node
    new_node->field_1D = move_src[23];     // 0x17
    new_node->depth_info = move_src[27];   // 0x1B
    new_node->field_1C = move_src[29];     // 0x1D
    new_node->beta = alpha_val;            // set bounds
    new_node->alpha = beta_val;

    link_child(g_current_node, new_node);

    // Copy score/position fields
    new_node->score = move_src[18];        // 0x12
    new_node->flag_done = move_src[32];    // 0x20
    new_node->field_1B = move_src[33];     // 0x21
    new_node->limit = move_src[31];        // 0x1F

    // Build board row string in node's data area (offset +16)
    short row = move_src[33];              // row index
    short col = move_src[32];              // col index
    short board_offset = row * 17 + col;   // MULS.W #17
    char* board_ptr = g_state1 + board_offset;
    char* dest = &new_node->data[16];      // node + 16

    // Copy non-zero letters from board to node, interleaving with source
    Node* src_node = move_src;
    while (*src_node) {
        if (*board_ptr == 0)
            *dest++ = *src_node;
        src_node++;
    }
    *dest = 0;  // null terminate

    assert(g_current_node->child != 0);
}
```

**Hex verification:** `CFFC 0011` = MULS.W #17,D7 (board width multiplication); `41ED BCFE` = LEA g_state1,A0.

---

### 0x0CCE: extract_move (148 bytes, LINK #0)

The inverse of `insert_move`: copies data from a search tree node back into a move/state structure for evaluation or reporting.

```c
void extract_move(Node* move_dst, Node* src_node) {
    // Copy node's data pointer via JT[66] (memory allocation)
    move_dst->data_ptr = src_node->score;
    long ptr = JT_alloc(100, move_dst->data_ptr);     // JT[66]
    move_dst->data_ptr = ptr;

    // Copy metadata back
    move_dst[32] = src_node->flag_done;    // row
    move_dst[33] = src_node->field_1B;     // col
    move_dst[25] = src_node->limit;
    move_dst[30] = 0;                       // clear word
    move_dst[24] = 0;                       // clear long
    move_dst[20] = 0;                       // clear long
    move_dst[28] = src_node->field_1C;     // flags

    // Reconstruct board row from node data and current board
    short row = move_dst[33];
    short col = move_dst[32];
    short offset = row * 17 + col;
    char* board = g_state1 + offset;
    char* node_data = &src_node->data[16];

    // Interleave: copy from node_data where board is 0, else from board
    char* dest = move_dst + 16;             // data area
    while (*board || *node_data) {
        if (*node_data == 0)
            *dest++ = *board;
        else
            *dest++ = *node_data;
        node_data++;
        board++;
    }
    *dest = 0;
}
```

---

### 0x0D62: iterate_children (66 bytes, LINK #0)

Generic child iteration with a function pointer callback. Calls the provided function on each child of the current node.

```c
void iterate_children(void (*callback)(Node*)) {
    short idx = g_current_node->child;
    while (idx != 0) {
        Node* child = node_at(idx);
        callback(child);                      // JSR (A0)
        assert(idx != child->next);           // no self-loop
        idx = child->next;
    }
}
```

**Hex verification:** `206E 0008` = MOVEA.L 8(A6),A0 (function pointer param); `4E90` = JSR (A0) (indirect call).

---

## Global Variable Reference

| A5 Offset | Name | Type | Purpose |
|-----------|------|------|---------|
| A5-2766 | `g_free_index` | word | Head of node free list (index into pool) |
| A5-2770 | `g_current_node` | long (ptr) | Pointer to current search node |
| A5-11974 | `g_node_field` | word | Node pool upper bound for free list init |
| A5-11976 | `g_node_count` | long | Number of nodes in pool |
| A5-11980 | `g_node_base` | long (ptr) | Base address of 32-byte node pool |
| A5-12540 | `g_failed_flag` | word | Search failure indicator |
| A5-15514 | `g_field_14` | long (ptr) | Cross-check buffer (hook-before) |
| A5-15522 | `g_field_22` | long (ptr) | Cross-check buffer (hook-after) |
| A5-16610 | `g_state2` | 1088 bytes | Score grid (32 rows x 17 words, stride 34) |
| A5-17154 | `g_state1` | 544 bytes | Letter grid (17 rows x 32 bytes) |
| A5-17420 | `g_work_buffer` | 256 bytes | Scratch buffer |
| A5-19470 | `g_board_orient` | word | Board orientation flag |
| A5-19486 | `g_best_score` | long | Best score accumulator |
| A5-23026 | `g_search_limit` | word | Maximum search depth (typically 127) |
| A5-23056 | `g_dawg_field` | 340 bytes | Result field (10 x 34-byte move entries) |
| A5-23058 | `g_dawg_done` | byte | DAWG completion flag |
| A5-23066 | `g_sect2_off` | long | DAWG section 2 offset |
| A5-23070 | `g_sect1_off` | long | DAWG section 1 offset |
| A5-23074 | `g_dawg_ptr` | long (ptr) | Main DAWG data pointer |
| A5-23090 | `g_dawg_info` | 34 bytes | DAWG info/configuration structure |
| A5-23674 | `g_stack_depth` | word | Coroutine state stack depth |
| A5-24026 | `g_state_stack` | 352 bytes | Coroutine state stack (8 x 44-byte entries) |
| A5-24030 | `g_saved_node` | long (ptr) | Saved node pointer for coroutine |
| A5-25752 | `g_alt_node` | long (ptr) | Alternate/comparison node pointer |
| A5-26026 | `g_extra_score` | word | Extra score value (scaled with board) |
| A5-27630 | `g_score_array` | 256 bytes | 128-entry score array (words) |
| A5-27732 | `g_buffer1` | long (ptr) | Additional buffer pointer |
| A5-2764 | `g_position_limit` | word | Position limit for DAWG expansion |

---

## Jump Table Cross-Reference

| JT Offset | Called From | Count | Likely Purpose |
|-----------|------------|-------|----------------|
| JT[66] | 0x0540, 0x0CEE | 2 | Memory allocation (NewPtr or similar) |
| JT[418] | 22 locations | 22 | Assertion failure / bounds error handler |
| JT[426] | 0x010C, 0x0178, 0x01AC, 0x0AA4, 0x0BAC | 5 | memset (clear memory) |
| JT[1690] | 0x016C | 1 | Initialize search state |
| JT[1698] | 0x046A | 1 | Check search budget/limit |
| JT[2114] | 0x056E | 1 | Store best move result |
| JT[2122] | 0x051E, 0x0528 | 2 | Score comparison / evaluation |
| JT[2322] | 0x0566 | 1 | Process DAWG result |
| JT[2370] | 0x02D6 | 1 | Prepare scoring context |
| JT[2386] | 0x01EC, 0x01FC | 2 | Setup cross-check parameters |
| JT[2410] | 0x01E6, 0x01F4, 0x02B8 | 3 | Setup search buffer |
| JT[2434] | 0x02BC | 1 | Additional search init |
| JT[2450] | 0x02DE | 1 | Score position |
| JT[2594] | 0x0844, 0x0B5E | 2 | Recalculate / accumulate scores |
| JT[2618] | 0x009A | 1 | Handle empty position |
| JT[2802] | 0x033C | 1 | Final score computation |
| JT[2810] | 0x0056, 0x04C4 | 2 | Initialize search context |
| JT[3442] | 0x0808, 0x081E, 0x0834 | 3 | Hash/lookup position in board |
| JT[3466] | 6 locations | 6 | memcpy (copy memory) |
| JT[3490] | 7 locations | 7 | Save/restore context to/from pointer |
| JT[3506] | 0x00AE, 0x0592 | 2 | Compare two node pointers |
| JT[3522] | 0x0814, 0x082A | 2 | Transform/convert position value |

---

## Internal Call Graph

```
generate_moves (0x014A)
 |-- push_and_compare (0x004A)
 |    |-- JT[2810] init_search
 |    |-- JT[2618] empty_handler
 |    |-- JT[3506] compare
 |    '-- restore_coroutine (0x001C)  [longjmp]
 |
 |-- scale_scores_div (0x0662)
 |-- init_node_pool (0x00F4)
 |-- scale_scores_mul (0x06CC)
 |
 |-- find_best_leaf (0x08BA)
 |-- update_bounds (0x0920)
 |    '-- update_bounds (recursive)
 |
 |-- extract_move (0x0CCE)
 |    '-- JT[66] alloc
 |
 |-- insert_move (0x0C1E)
 |    |-- alloc_node (0x0B42)
 |    |    |-- prune_subtree (0x09C2)
 |    |    |    '-- prune_subtree (recursive)
 |    |    |-- set_node_letter (0x0AF4, recursive)
 |    |    |-- update_all_nodes (0x0AC2)
 |    |    |    '-- free_node (0x0A98)
 |    |    '-- JT[2594] recalculate
 |    '-- link_child (0x0BB8)
 |
 |-- create_mirror_node (0x07A0)
 |    |-- alloc_node (0x0B42)
 |    '-- link_child (0x0BB8)
 |
 |-- evaluate_position (0x07F8)
 |    |-- JT[3442] hash_position (x3)
 |    |-- JT[3522] transform (x2)
 |    |-- JT[2594] accumulate
 |    '-- find_in_subtree (0x072A, recursive)
 |
 '-- iterate_children (0x0D62)
      '-- callback via JSR (A0)
```

---

## Algorithm Description

### Pre-Endgame Alpha-Beta Search

CODE 30 implements a **pre-endgame search** for Scrabble AI. In the pre-endgame phase (when few tiles remain in the bag), Maven looks ahead multiple moves to find the optimal play considering the opponent's likely responses.

The algorithm works as follows:

1. **Node Pool**: A fixed-size pool of 32-byte nodes is allocated at startup. Nodes are managed via a free list (field +6 = next pointer). When the pool is exhausted, the tree is pruned to reclaim nodes.

2. **Alpha-Beta Framework**: Each node stores alpha (lower bound) and beta (upper bound) in centipoints. The `create_mirror_node` function performs the standard negamax window inversion (`(-beta, -alpha)`) when switching perspective between players.

3. **Score Scaling**: Board scores are stored internally in centipoints (hundredths of a point). Before search, `scale_scores_div` converts to base points for efficient integer arithmetic. After search, `scale_scores_mul` restores centipoint precision.

4. **Coroutine Mechanism**: The search uses a coroutine-style state save/restore (setjmp/longjmp pattern) to suspend and resume search at arbitrary points. The state stack holds up to 8 entries of 44 bytes each (22 bytes of register state + 22 bytes of additional data).

5. **Board State Preservation**: The main function copies 1632 bytes of board state (letters + scores) to its stack frame before speculative evaluation, restoring it afterward.

6. **Move Expansion**: Candidate moves are generated using the DAWG dictionary and inserted into the search tree via `insert_move`. Each move records its board position, score, and a string representation of the word formed.

7. **Pruning**: When the node pool fills up, `prune_subtree` removes branches that cannot affect the result (alpha-beta cutoff), returning freed nodes to the pool.

### Sentinel Value

The constant `0xF4143E00` = -200,000,000 is used as negative infinity for initializing alpha-beta bounds. In centipoints, this represents -2,000,000 points, effectively infinite since real Scrabble scores never approach this magnitude.

---

## Confidence Assessment

| Aspect | Confidence | Evidence |
|--------|-----------|---------|
| Function boundaries | **HIGH** | LINK/UNLK/RTS patterns verified against hex |
| Node structure (32 bytes) | **HIGH** | LSL.L #5 pattern appears 15 times consistently |
| Alpha-beta search | **HIGH** | Negamax inversion confirmed by `create_mirror_node` |
| Coroutine mechanism | **HIGH** | MOVEM.W save/restore + JMP(A1) pattern at 6 locations |
| Free list management | **HIGH** | Allocation/deallocation patterns clear |
| Score scaling (x100) | **HIGH** | DIVS.W/MULS.W #100 with grid dimensions verified |
| Field layout (nodes) | **MEDIUM** | Consistent access patterns but some fields uncertain |
| Main function flow | **MEDIUM** | Complex control flow, some branches unclear |
| JT function purposes | **LOW** | Based on call context, not direct verification |
| Variable naming | **LOW** | Speculative based on usage patterns |

---

## Key Corrections from Previous Analysis

1. **Not DAWG traversal**: CODE 30 is the alpha-beta search tree manager, not a DAWG walker. It uses DAWG results (via JT calls to other modules) but does not traverse the DAWG itself.

2. **32-byte nodes, not 34**: The node structure is 32 bytes (LSL.L #5 = multiply by 32), not 34 as previously speculated.

3. **44-byte state entries, not arbitrary**: The coroutine state entries are exactly 44 bytes (MULS.W #44), containing 22 bytes of register data plus 22 bytes of additional state.

4. **Score scaling factor 100**: Board scores are scaled by 100 (centipoints), not by some other factor. This matches the MUL resource format where scores are stored as centipoints.

5. **Sentinel -200M**: The "negative infinity" constant is exactly -200,000,000, a clean decimal value that avoids overflow in 32-bit arithmetic.
