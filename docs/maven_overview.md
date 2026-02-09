# Maven: A Classic Macintosh Scrabble AI -- Reverse Engineering Overview

## 1. What Maven Is

Maven is a Scrabble AI program for the Classic Macintosh, created by Brian Sheppard in the early 1990s. It is widely regarded as one of the strongest Scrabble programs ever written, and its algorithms and evaluation techniques influenced a generation of competitive Scrabble software.

Sheppard, a computer scientist and competitive Scrabble player, designed Maven to play at an expert-to-world-champion level. The program participated in and won notable events, including defeating human Scrabble champions. Sheppard later published academic work on Maven's algorithms, particularly its pre-endgame and endgame search techniques, which became foundational references in the field of computer Scrabble.

Maven was distributed as a Classic Mac application (file type `APPL`, creator code `MAVN`). The version under analysis here contains its game logic in 68000 machine code stored across 55 CODE resources in the application's resource fork, while the dictionary data (a dual-section DAWG) occupies the 1,070,788-byte data fork.

---

## 2. Technical Architecture

### Platform

Maven targets the Classic Macintosh (System 6/7 era). Key platform characteristics:

- **Processor**: Motorola 68000 family, big-endian byte order
- **Memory model**: A5-relative global addressing. Register A5 serves as the application globals base pointer; all global variables are accessed as signed 16-bit displacements from A5 (e.g., `MOVE.W -8602(A5),D0`)
- **Stack frames**: Standard LINK/UNLK convention with A6 as frame pointer. Parameters at positive offsets from A6, locals at negative offsets
- **Floating point**: Apple SANE (Standard Apple Numerics Environment) library via the A9EB trap (`_FP68K`), providing 80-bit extended precision arithmetic. Maven uses SANE for binomial coefficient calculations in its leave evaluation system
- **Inter-segment calls**: A jump table (JT) in CODE 0 dispatches calls between CODE segments. Each CODE resource exports functions at specific JT offsets (e.g., `JSR 418(A5)` calls the assertion handler in CODE 11)
- **Mac Toolbox**: Extensive use of Toolbox traps for window management, event handling, menus, QuickDraw drawing, dialog boxes, resource management, and file I/O

### Application Structure

```
maven2 (application file)
  |
  +-- Data Fork (1,070,788 bytes)
  |     Dual-section DAWG dictionary
  |
  +-- Resource Fork
        +-- CODE 0..54    (55 segments, ~112 KB total executable code)
        +-- MUL a..z, ?   (27 resources: per-tile leave value tables)
        +-- ESTR 0        (130 pattern strings for synergy scoring)
        +-- PATB 0        (18,104 bytes: pattern-to-value mapping table)
        +-- EXPR 0        (8,960 bytes: 320 pre-computed synergy records)
        +-- MENU, DLOG, DITL, WIND, WDEF, PICT, STR#, ...  (UI resources)
```

### Code Scale

The 55 CODE resources contain approximately 112 KB of 68000 machine code, implementing roughly 550 functions total. CODE 0 is the jump table (not executable code); it contains 3,584 bytes of dispatch entries mapping JT offsets to CODE segment + function offset pairs. The remaining 54 segments range from 42 bytes (CODE 54, a tiny utility) to 13,718 bytes (CODE 21, the main UI and display module).

---

## 3. CODE Resource Breakdown

The following categorization is based on detailed hex-verified disassembly of key modules and cross-reference analysis of all 55 CODE segments.

### 3.1 Core Game Engine

| CODE | Size | Functions | Role |
|------|------|-----------|------|
| 3 | 4,390 | 16 | **Move generation coordinator**. Central search engine implementing the Appel-Jacobson algorithm. Manages the make-move/search/unmake-move cycle, alternates between across and down directions, coordinates DAWG traversal and cross-check validation. Uses a setjmp/longjmp-style coroutine mechanism (MOVEM register save/restore) for search state management. |
| 37 | 5,344 | 18 | **Cross-check generation and DAWG traversal**. Computes 32-bit letter masks for each board position indicating which letters can legally be placed there based on perpendicular word constraints. Implements the core Appel-Jacobson left-extension and right-extension logic. |
| 30 | 3,492 | 22 | **Alpha-beta search tree manager** (pre-endgame engine). Manages a pool of 32-byte search nodes with alpha/beta bounds, negamax window inversion, node allocation via free list, tree pruning, and coroutine-based search suspension. Sentinel value of -200,000,000 centipoints represents negative infinity. |
| 15 | 3,568 | 20 | **DAWG access and resource initialization**. Contains the `walk_to_child` function that traverses the DAWG. Also loads and initializes MUL, ESTR, PATB, and EXPR resources during startup. |
| 11 | 4,478 | 31 | **Game controller and event dispatcher**. The "central nervous system" containing the main event loop, callback/dispatch system, menu management, lexicon state machine, and word validation. Registers 55 command handlers during initialization. |

### 3.2 Scoring and Evaluation

| CODE | Size | Functions | Role |
|------|------|-----------|------|
| 32 | 6,464 | ~20 | **Leave evaluation engine**. Core scoring module computing per-tile MUL leave values via binomial weighting (SANE FP), vowel/consonant balance through an algorithmic V/C-parameterized calculation, ESTR/PATB/EXPR pattern synergy scoring, and Q-without-U penalties. All scores in centipoints (1/100 of a point). |
| 35 | 3,276 | 7 | **Full move scoring**. Computes complete move evaluation: word score with letter/word multipliers, cross-word scores, 50-point bingo bonus for using all 7 tiles, Q/QU synergy, per-letter leave contributions. Contains heavy SANE floating-point usage (22 A9EB traps) for extended-precision score calculations. |
| 36 | 9,102 | 15 | **Move evaluation coordinator and caching pipeline**. The heart of the move evaluation system, tying together word scoring (CODE 35), leave evaluation (CODE 32), letter synergy (CODE 39), and cross-check scoring. Manages score caching for endgame optimization and multi-rack evaluation with blanks and positional weighting. |
| 39 | 1,784 | 5 | **Letter combination synergy scoring**. Pre-computes per-position score tables (6 tables of 2,304 bytes each) that are populated for each board position during move generation. These are working buffers, not static data. |

### 3.3 Board and Game State

| CODE | Size | Functions | Role |
|------|------|-----------|------|
| 7 | 2,872 | 21 | **Board and rack state management**. Manages the 17x17 board grid, rack contents, tile bag, and game state transitions. |
| 5 | 204 | 1 | **DAWG header parsing**. Reads the 12-byte DAWG file header and computes S1/S2 base pointers. Stores field1 (56,630) at A5-15506 and field2 (122,166) at A5-8588. |
| 2 | 750 | 5 | **Arithmetic utilities**. Provides 32-bit multiply (JT[66]) and divide (JT[90]) via inter-segment calls. |
| 14 | 2,766 | 20 | **DAWG-heavy processing**. Supports dictionary lookup and validation operations. |
| 22 | 2,056 | 10 | **DAWG-heavy processing**. Board state analysis with significant DAWG interaction. |
| 31 | 2,510 | 14 | **Search buffer management**. Setup and teardown of search state buffers used by the move generation pipeline. |

### 3.4 Search and AI Strategy

| CODE | Size | Functions | Role |
|------|------|-----------|------|
| 29 | 686 | 8 | **Pre-endgame search support**. Works with CODE 30 for alpha-beta search node management. |
| 40 | 624 | 4 | **Search orchestration**. Higher-level search control calling into CODE 28, 29, 44, 45. |
| 44 | 424 | 4 | **Search dispatch**. Routes between pre-endgame (CODE 30) and move generation (CODE 37) paths. |
| 45 | 1,122 | 5 | **Move ranking and selection**. Final move selection from the candidate list produced by the search. |
| 28 | 664 | 3 | **Scoring pipeline integration**. Bridges move scoring (CODE 35/36) with leave evaluation (CODE 32) and synergy (CODE 39). |
| 38 | 374 | 4 | **Score table utilities**. Support functions for the scoring tables managed by CODE 39. |

### 3.5 UI and Display

| CODE | Size | Functions | Role |
|------|------|-----------|------|
| 21 | 13,718 | 53 | **Main UI and display** (largest CODE resource). Board rendering, move display, game state visualization, score display. Heavy QuickDraw usage. |
| 46 | 2,904 | 25 | **Custom window manager**. WDEF-style windowing system with 3D border drawing (Mac OS 7 "platinum" look), region-based hit testing, window ordering, activation management. Contains 120+ Toolbox trap calls -- the most QuickDraw-intensive module. |
| 17 | 2,618 | 34 | **UI drawing utilities**. Text rendering, score formatting, string display. |
| 48 | 1,092 | 18 | **TextEdit controls**. Text input fields for the game interface. |
| 49 | 546 | 3 | **Clipboard/scrap management**. Copy/paste support. |
| 47 | 908 | 11 | **UI support**. Additional interface utilities. |
| 12 | 2,722 | 22 | **Game display management**. Coordinates rendering across multiple windows. |
| 51 | 236 | 6 | **UI utilities**. Small helper functions for display. |
| 52 | 938 | 13 | **General utilities** including memcpy (JT[3466]), global data copy (JT[3490]), buffer comparison (JT[3506]), and strlen (JT[3522]). Called by nearly every other module. |

### 3.6 File I/O and Application Framework

| CODE | Size | Functions | Role |
|------|------|-----------|------|
| 0 | 3,564 | -- | **Jump table**. Not executable code; contains 3,584 bytes of inter-segment dispatch entries. |
| 1 | 574 | 10 | **Application startup**. Initialization sequence. |
| 4 | 108 | 2 | **Startup stub**. Minimal entry point. |
| 9 | 3,940 | 48 | **System utilities**. Memory management, resource handling, error reporting. 37 JT entries -- one of the most exported modules. |
| 16 | 1,894 | 9 | **File dialog management**. Standard File Package wrappers. |
| 24 | 6,786 | 25 | **File save/load**. Game state serialization and deserialization. |
| 50 | 1,174 | 1 | **File dialog support**. Additional file I/O utilities. |
| 13 | 512 | 5 | **File dialogs with DAWG**. Dictionary file open/save. |

### 3.7 Remaining Modules

| CODE | Size | Functions | Role |
|------|------|-----------|------|
| 6 | 1,026 | 9 | DAWG support |
| 8 | 2,326 | 3 | DAWG-heavy processing |
| 10 | 138 | 4 | Small utility (3 functions) |
| 18 | 4,460 | 15 | General purpose with DAWG access |
| 19 | 382 | 12 | General purpose |
| 20 | 3,398 | 21 | General purpose with DAWG access |
| 23 | 608 | 12 | String/data utilities |
| 25 | 200 | 1 | Small utility |
| 27 | 662 | 5 | General purpose with DAWG access |
| 34 | 1,388 | 10 | General purpose (heavily called via JT) |
| 41 | 660 | 8 | System utilities |
| 42 | 734 | 3 | Small module |
| 43 | 1,486 | 5 | Score-related utilities |
| 53 | 106 | 1 | Tiny utility |
| 54 | 42 | 1 | Tiny utility (smallest CODE resource) |

---

## 4. Data Structures

### 4.1 The DAWG (Directed Acyclic Word Graph)

Maven's dictionary is stored as a dual-section DAWG in the application's data fork (1,070,788 bytes). Each DAWG entry is a 32-bit big-endian value with the following bit layout:

```
Bits 0-7:    Letter code (ASCII lowercase, 'a'=0x61 through 'z'=0x7A)
Bit 8:       End-of-word (EOW) flag
Bit 9:       Last-sibling flag
Bits 10-31:  Child node index (22 bits, unsigned)
```

#### File Layout

```
Offset        Size         Content
0             12           Header: three 32-bit values
12            488,664      Section 1 (S1): 122,166 entries (sentinel + letter index + data)
488,676       104          S1 letter index copy (26 entries)
488,780       581,904      Section 2 (S2): 145,476 entries (sentinel + letter index + data)
1,070,684     104          S2 letter index copy (26 entries)
```

The 12-byte header contains:
- Offset 0: `56,630` -- S1 data size field (stored at A5-15506)
- Offset 4: `122,166` -- total S1 entries including header (stored at A5-8588)
- Offset 8: `145,476` -- total S2 entries (stored at A5-8592)

Each section begins with a sentinel entry (`0x00000300`: null letter, last-sibling=1, child=0) followed by a 26-entry letter index (a-z). The child pointer in each letter index entry points to the root sibling group for that letter's subtree.

#### Section 2: Forward OSW Dictionary

S2 is a standard forward DAWG. Words are looked up left-to-right starting from the letter index. Validation against reference word lists shows:

| Reference | Match Rate |
|-----------|-----------|
| OSW (Official Scrabble Words) | 99.4% (121,168 / 121,905) |
| TWL (Tournament Word List) | 76.4% (shared words only) |
| 2-letter words (OSW) | 100% (105/105) |

S2 is the primary dictionary, corresponding to OSW (international Scrabble rules).

#### Section 1: Reversed Cross-Check DAWG

S1 stores reversed word fragments used during move generation for cross-check computation. When placing a tile at a board position, Maven must verify that perpendicular letters form valid words. S1 enables this by:

1. Looking up the last letter of the cross-word fragment
2. Walking backward through the reversed DAWG
3. The EOW flag indicates valid cross-check positions (not necessarily complete dictionary words)

S1's letter index child pointers span the full 0-122,165 range -- there is no boundary at 56,630 despite that value appearing in the header.

#### DAWG Traversal (CODE 15, `walk_to_child`)

```c
while (target_letter != '\0') {
    uint32_t entry = dawg_base[current_pos];
    char entry_letter = (char)(entry & 0xFF);
    if (entry_letter == target_letter) {
        uint32_t child_pos = entry >> 10;
        if (child_pos == 0) break;        // dead end
        current_pos = child_pos;
        advance_to_next_letter();
    } else if (entry & 0x200) {           // bit 9 = last sibling
        return 0;                          // letter not found
    } else {
        current_pos++;                     // try next sibling
    }
}
```

The traversal uses a single base pointer (`g_dawg_base_ptr` at A5-11960) which is set to either S1 or S2 base before invocation. There is no boundary check within the traversal function.

#### Lexicon Modes

Maven supports three dictionary modes, managed by a state machine in CODE 11:

| Mode | Name | Dictionary |
|------|------|------------|
| 1 | NA/TWL | Tournament Word List (North America) |
| 2 | UK/OSW | Official Scrabble Words (International) |
| 3 | Both/SOWPODS | Combined TWL + OSW |

A 14-entry validation table at A5-24244 (4 bytes per entry: condition, required mode, result, padding) implements the TWL/OSW word filtering. Maven does not maintain separate DAWGs for TWL and OSW; instead, the SOWPODS DAWG contains all words, and per-word flags combined with the validation table determine which words are valid for each mode.

### 4.2 MUL Resources (Per-Tile Leave Values)

Maven stores 27 MUL resources (one for each letter a-z plus the blank `?`). Each MUL contains 8 records of 28 bytes:

```c
typedef struct {
    uint8_t  sane_extended_1[10];   // SANE 80-bit: weighted sum
    uint8_t  sane_extended_2[10];   // SANE 80-bit: weighted adjustment
    uint32_t combination_count;     // binomial combinations evaluated
    int16_t  centipoints;           // leave adjustment at offset 24
} MulRecord;  // 28 bytes
```

All 8 records per tile are used, indexed by the number of that tile remaining (0-7). Record 0 is the baseline (0 copies remaining), and records 1-7 represent relative adjustments for each tile count.

The leave calculation formula (implemented in CODE 32 at function 0x1406) is a binomial-weighted average:

```
result = SUM(MUL[i+1].adj - MUL[0].adj) / SUM(C(n,i) * C(m,j-i))
```

where C(n,k) is the binomial coefficient, looked up from a pre-computed table of 101 entries x 8 slots x 10-byte SANE extended values (8,080 bytes at A5-2448). The final leave value is subtracted from the move score.

### 4.3 ESTR / PATB / EXPR (Pattern Synergy Scoring)

Maven's leave evaluation includes a pattern-matching component that captures letter combination synergies. Three resources form this pipeline:

**ESTR** (536 bytes): A pool of 130 null-terminated ASCII strings representing letter patterns, sorted lexicographically. Patterns include:
- Single letters (26): a, b, c, ..., z
- Blank patterns (2): ?, ??
- Duplicate penalties (41): aa, bb, ..., zz, aaa, aaaa, ...
- Digraph synergies (4): ch, ck, ht, hw
- Q-without-U patterns (6): aq, adq, aqt, aiq, adiq, diq
- Q-with-U (2): qu, qt
- Suffix/word patterns (20): gin (=ING potential), flu, ily, osu (=OUS), ...
- V/C letter groups (19): aeio, lnrtsu, bcmp, fhkwvy, aeiou, ...

A space-saving trick: seven letters (g, h, k, q, t, u, w) share strings by pointing to the second byte of a two-character string, exploiting the null terminator (e.g., pattern "k" points to byte 63 of "ck\0").

**PATB** (18,104 bytes): An 8-byte entry table mapping ESTR patterns to EXPR record indices:

```c
typedef struct {
    uint32_t string_offset;  // byte offset into ESTR pool
    uint16_t letter_id;      // EXPR record index
    uint8_t  flag_byte;      // 0 for EXPR entries, non-zero for blank dispatch
    uint8_t  reserved;
} PatbEntry;
```

Section 1 (entries 0-112): leave pattern-to-EXPR mappings. Section 2 (entries 113+): blank expansion dispatch tables for the V/C optimizer.

**EXPR** (8,960 bytes): 320 records of 28 bytes each (same format as MUL). The centipoints field at offset 26 provides the synergy value. Key values:

| Pattern | Centipoints | Meaning |
|---------|-------------|---------|
| ? (blank) | +2,791 | Blank tile is worth ~28 points in leave |
| qu | +1,067 | Q+U together: +10.67 point synergy |
| s | +794 | S is the best single letter to hold |
| gin | +532 | ING-potential: +5.32 points |
| q (alone) | -861 | Q without U: -8.61 point penalty |
| vv | -1,178 | Double V: -11.78 point penalty |
| iii | -1,031 | Triple I: -10.31 point penalty |

### 4.4 Board Representation

Maven uses a 17x17 grid for the Scrabble board (15x15 playing area plus 1-cell border on each side for boundary detection). Two parallel arrays hold board state:

- **g_state1** (A5-17154, 544 bytes): Letter grid. Each byte holds the letter at that position (0 = empty). Accessed as `g_state1[row * 17 + col]` using `MULS.W #17,D0`.
- **g_state2** (A5-16610, 1,088 bytes): Score grid. 32 rows x 17 words with a stride of 34 bytes. Stores pre-computed score multiplier information for each position.

Both arrays are saved to and restored from the stack frame during the make-move/search/unmake-move cycle (544 + 1,088 = 1,632 bytes copied per search level).

An anchor square table at A5-10388 (289 bytes = 17x17) tracks which board positions are valid anchor points for move generation.

### 4.5 Search Nodes (Alpha-Beta Tree)

CODE 30 manages a pool of 32-byte search nodes for the pre-endgame engine:

```c
typedef struct SearchNode {
    int16_t  alpha;         // +0:  lower score bound (centipoints)
    int16_t  beta;          // +2:  upper score bound (centipoints)
    int16_t  child;         // +4:  index of first child node (0 = leaf)
    int16_t  next;          // +6:  index of next sibling (0 = last)
    int16_t  reserved;      // +8
    int16_t  score;         // +10: evaluation score
    int32_t  move_ref;      // +12: reference to associated move data
    int8_t   is_terminal;   // +16: terminal/leaf flag
    int8_t   pad[7];        // +17-23
    int8_t   depth_info;    // +24
    int8_t   limit;         // +25: search depth limit (127 = max)
    int8_t   flag_done;     // +26: pruned/finished flag
    int8_t   field_1B;      // +27: position data
    int8_t   field_1C;      // +28: direction/constraint
    int8_t   field_1D;      // +29: position data
    int8_t   in_progress;   // +30: currently being processed
    int8_t   pad2;          // +31
} SearchNode;  // 32 bytes
```

Node addressing: `node_ptr = g_node_base + index * 32`, computed via `LSL.L #5,D0` (shift left 5 = multiply by 32). This pattern appears 15 times in CODE 30.

Nodes are allocated from a free list (head at A5-2766). When the pool is exhausted, the tree is pruned to reclaim nodes.

---

## 5. The Appel-Jacobson Move Generation Algorithm

Maven implements a variant of the Appel-Jacobson algorithm for enumerating all legal Scrabble moves on a given board state. The implementation spans CODE 3 (coordinator), CODE 37 (cross-checks and DAWG traversal), and CODE 15 (DAWG walking).

### Algorithm Overview

1. **Identify anchor squares**: For each empty position adjacent to an existing tile, mark it as an anchor in the 17x17 anchor table (`g_lookup_tbl` at A5-10388). On an empty board, only the center square is an anchor.

2. **Generate cross-check sets**: For each anchor, CODE 37 computes a 32-bit bitmask indicating which letters can legally be placed there. This is determined by walking the DAWG to check which letters form valid perpendicular words given the tiles already on the board above and below (or left and right of) the position.

3. **Left-extend prefixes**: For each anchor, generate all valid prefixes by walking leftward through already-placed tiles and extending through the DAWG.

4. **Right-extend to complete words**: For each prefix, extend rightward through the DAWG, constrained at each position by the cross-check set. When the end-of-word flag is reached and the word connects to existing tiles, record it as a legal move.

5. **Score and evaluate**: Each legal move passes through the scoring pipeline (CODE 35 for base score, CODE 32 for leave evaluation, CODE 39 for synergy scoring, CODE 36 for final ranking).

### Maven's Implementation Details

The search in CODE 3 operates in both directions simultaneously, alternating between across and down. Two 8-byte cross-check buffers manage this:

- **g_field_14** (A5-15514): "hook-before" cross-check data (across direction)
- **g_field_22** (A5-15522): "hook-after" cross-check data (down direction)

A `g_current_ptr` (A5-15498) tracks which direction is currently active and toggles after each position.

The core search function (CODE 3 at 0x069E) uses a 6,512-byte stack frame containing six rotating 1,024-byte buffers for pipelining search results. It implements a setjmp/longjmp-style mechanism using `MOVEM.L` to save/restore 11 registers (44 bytes per context) to a stack of 8 slots at A5-24026. This allows the search to exit from deep recursion without explicit stack unwinding:

```asm
; Save (like setjmp): D0=0 on first call
MOVEM.L DEF8,(A0)       ; save D3-D7,A1-A4,A6,A7
TST.W   D0
BNE.S   restored_path    ; D0=0: continue; D0=1: search done

; Restore (like longjmp): sets D0=1
MOVEM.L (A0)+,DEF8      ; restore all registers
JMP     (A1)             ; jump to saved continuation
```

The make-move/search/unmake-move pattern in CODE 3 (function 0x02C2) saves the entire board state (544 bytes of letters + 1,088 bytes of scores + cross-check data) to its 1,808-byte stack frame, makes a tentative move, searches for continuations, then restores the board.

### Cross-Check Generation (CODE 37)

CODE 37's cross-check generator (function 0x010E, 316 bytes) iterates over board positions, computing for each one which letters would form valid perpendicular words. The computation indexes the DAWG with `ASL.L #2,D0` (4-byte DAWG entries), checking adjacent cells using the pattern:

```asm
TST.B   (0,A0,D6.L)     ; check cell above
BNE.S   has_adjacent
TST.B   (0,A0,D7.L)     ; check cell below
```

The result is a 32-bit letter mask stored per position, consulted during move generation to prune invalid letter placements.

---

## 6. The Pre-Endgame Search Engine

When few tiles remain in the bag, Maven switches from greedy single-move evaluation to a look-ahead search that considers multiple future turns. This is implemented as an alpha-beta search in CODE 30.

### Search Tree Structure

The engine maintains a pool of 32-byte nodes (described in Section 4.5). The root node represents the current game position; child nodes represent possible moves and the opponent's responses.

### Negamax with Alpha-Beta Pruning

Maven uses the negamax formulation of minimax, where scores are always from the perspective of the player to move. When creating a node for the opponent's turn, the alpha and beta bounds are negated and swapped:

```c
mirror->alpha = -(parent->beta);    // negamax inversion
mirror->beta  = -(parent->alpha);
```

The sentinel value -200,000,000 (centipoints, i.e., -2,000,000 points) serves as negative infinity for bound initialization.

### Score Scaling

Board scores are stored internally in centipoints. Before search, `scale_scores_div` divides all scores by 100 for efficient integer arithmetic. After search, `scale_scores_mul` restores the original precision. Both functions iterate the 32x17 score grid, a 128-entry score array, and a single extra score value.

### Coroutine Mechanism

The search uses the same coroutine-style state save/restore as the move generator: a stack of up to 8 entries at A5-24026, each holding 44 bytes of state (11 registers saved via MOVEM.W with mask DEF8). D0 serves as the discriminator: 0 = first call (continue searching), 1 = restored (search complete).

### Node Pool Management

When the free list is empty, the engine calls `prune_subtree` to perform alpha-beta cutoff pruning -- removing nodes whose bounds prove they cannot affect the final result. Freed nodes return to the pool. If pruning fails to reclaim any nodes, the search terminates with the best result found so far.

The main search function (0x014A, 1,304 bytes with a 1,766-byte stack frame) orchestrates the entire process: saving DAWG configuration, copying board state, running the search loop with up to 200 iterations (safety-limited), tracking best moves by alpha and beta criteria, and restoring state after completion.

---

## 7. The Leave Evaluation Pipeline

Maven's move evaluation goes far beyond simple tile scoring. After computing the base word score, it applies a sophisticated leave evaluation that estimates the value of the tiles remaining on the rack after a play. This pipeline has three independent channels that are combined for the final score.

### 7.1 MUL Per-Tile Leave Values

For each tile type (a-z plus blank), Maven looks up the MUL resource to determine how valuable it is to retain copies of that tile. The calculation uses binomial weighting in SANE 80-bit extended precision:

1. For each tile type in the leave, read its MUL record indexed by the count of that tile remaining in the bag
2. Look up binomial coefficients C(n,i) from a pre-computed table (8,080 bytes at A5-2448)
3. Compute a weighted average: `SUM(MUL[i].adjustment) / SUM(C(n,i) * C(m,j-i))`
4. The result is subtracted from the move score

The binomial weighting accounts for the probability of drawing specific tile combinations, making the leave evaluation context-sensitive to the current bag contents.

### 7.2 ESTR/PATB/EXPR Pattern Synergy

The leave orchestrator (CODE 32, function 0x09D8) iterates through 128 ESTR patterns and checks whether each pattern is a multiset subset of the current leave. For each matching pattern:

1. **Letter classification**: Each letter is classified as vowel, consonant, or blank using JT[2002] (`is_vowel`)
2. **Cross-check scoring**: Letter point values are summed from the per-letter value table at A5-27630
3. **Q-without-U penalty**: If the leave contains Q but not U, a penalty is computed as `(counter - unseen) / unseen`, clamped to -100 centipoints minimum
4. **EXPR lookup**: The pattern's synergy value (centipoints) is retrieved via binary search from the EXPR resource
5. **Accumulation**: Results flow into two independent output buffers:
   - `g_work_buffer` (A5-17420): EXPR synergy values per pattern
   - `g_estr_patterns` (A5-17166): V/C balance values per pattern

### 7.3 Vowel/Consonant Balance

Maven computes a V/C balance adjustment through an algorithmic chain rather than a static table lookup:

```
0x09D8 (orchestrator) -> 0x0CC0 (blank_dispatcher) -> 0x0BFC (cached) -> 0x0DAC (core)
```

The V/C cache (256 bytes at A5-2712) is indexed by `[consonant * 32 + vowel * 4]`, storing previously computed balance values. For leaves containing blanks, the dispatcher tries multiple vowel/consonant assignment combinations:
- 2 blanks: try 3 V/C combinations, take the best
- 1 blank: try 2 V/C combinations, take the average
- 0 blanks: compute directly

The V/C balance captures the principle that a well-balanced rack (mix of vowels and consonants) is more likely to form playable words than an unbalanced one.

### 7.4 Bingo Bonus

A 50-point bonus (5,000 centipoints) is awarded for using all 7 tiles from the rack. This is checked at CODE 32 offset 0x0328:

```asm
CMPI.W  #7,-20010(A5)    ; g_tile_count == 7?
BNE.S   no_bonus
MOVE.W  #$1388,D0         ; 5000 centipoints = 50 points
```

### 7.5 Score Pipeline Integration

CODE 36 (9,102 bytes) serves as the central coordinator, combining all scoring channels:

1. **Position score** (CODE 36 function 0x0000): Positional component accounting for premium squares and tile placement
2. **Leave evaluation** (CODE 32 via JT[2498]): Per-tile MUL values + pattern synergies + V/C balance
3. **Word score** (CODE 35 via JT[2522]): Base tile scores with letter/word multipliers and cross-word contributions
4. **Synergy tables** (CODE 39 via JT[2602-2618]): Pre-computed per-position synergy adjustments

A caching system (66-byte cache entries with linked-list chaining) avoids recomputing scores for positions that have already been evaluated during the current search iteration. Cache entries store the complete move data (34 bytes), position hash, cross-word adjustment, leave modifier, and tile placement counts.

---

## Appendix: Key Global Variables

The following A5-relative globals appear throughout the codebase and form the backbone of Maven's runtime state:

| A5 Offset | Size | Purpose |
|-----------|------|---------|
| A5-8588 | 4 | S1 total entries (122,166) |
| A5-8592 | 4 | S2 total entries (145,476) |
| A5-8596 | 4 | S1 base pointer (data + 12) |
| A5-8602 | 2 | Lexicon validation state |
| A5-8604 | 2 | Lexicon mode (0-5) |
| A5-10388 | 289 | Anchor square table (17x17) |
| A5-10908 | 4 | EXPR resource handle |
| A5-10912 | 4 | ESTR string pool pointer |
| A5-10918 | 4 | PATB entry table pointer |
| A5-11960 | varies | DAWG letter-set table (8-byte entries) |
| A5-11968 | 4 | Current DAWG base pointer |
| A5-11972 | 4 | Current search context pointer |
| A5-11976 | 4 | Alpha-beta node pool count |
| A5-11980 | 4 | Alpha-beta node pool base address |
| A5-13060 | varies | Secondary scoring buffer |
| A5-15498 | 4 | Active direction buffer pointer |
| A5-15502 | 4 | DAWG section 2 traversal size |
| A5-15506 | 4 | DAWG section 1 size (56,630) |
| A5-15514 | 8 | Cross-check buffer: hook-before (across) |
| A5-15522 | 8 | Cross-check buffer: hook-after (down) |
| A5-16610 | 1088 | Board score grid (17x17 x 4) |
| A5-17154 | 544 | Board letter grid (17x17 + padding) |
| A5-17166 | 256 | ESTR pattern scores (V/C channel) |
| A5-17420 | 256 | Work buffer (EXPR synergy channel) |
| A5-19470 | 2 | Board orientation flag |
| A5-20010 | 2 | Tiles placed in current move |
| A5-23026 | 2 | Search depth limit (typically 127) |
| A5-23056 | 34 | Best move found (34-byte Move structure) |
| A5-23074 | 4 | Main DAWG data pointer |
| A5-23090 | 34 | Current DAWG info/configuration |
| A5-23218 | 128 | Rack letter count array |
| A5-23674 | 2 | Coroutine state stack depth (0-7) |
| A5-24026 | 352 | Coroutine state stack (8 x 44 bytes) |
| A5-24244 | 56 | Word validation table (14 x 4 bytes) |
| A5-26158 | 4 | Rack data pointer |
| A5-27630 | varies | Per-letter point value table |
| A5-27716 | 4 | String data pointer |

---

## Appendix: Inter-Segment Call Graph

The following shows which CODE resources call into which others via the jump table. This reveals the architecture's layered structure, with utility modules (CODE 9, 11, 52) at the bottom, game engine modules (CODE 3, 30, 37) in the middle, and evaluation modules (CODE 32, 35, 36, 39) forming a tightly interconnected scoring subsystem.

**Most-called modules** (by number of callers):
- CODE 11 (game controller): called by 42 other modules
- CODE 52 (utilities): called by 38 other modules
- CODE 9 (system utilities): called by 22 other modules
- CODE 32 (leave evaluation): called by 20 other modules
- CODE 34 (general purpose): called by 14 other modules

**Most-calling modules** (by number of callees):
- CODE 3 (move generator): calls 22 other modules
- CODE 21 (main UI): calls 19 other modules
- CODE 22 (DAWG processing): calls 14 other modules
- CODE 15 (DAWG access): calls 17 other modules
- CODE 11 (game controller): calls 17 other modules

---

## Appendix: Disassembler Challenges

The 68000 disassembly of Maven is complicated by systematic misdecodings in common instruction patterns. The automated disassembler used for initial analysis consistently mangles:

| Hex Pattern | Correct Instruction | Disassembler Output |
|-------------|-------------------|-------------------|
| `C1FC xxxx` | `MULS.W #imm,D0` | `ANDA.L #imm,A0` |
| `E588` / `E788` | `ASL.L #2,D0` / `ASL.L #3,D0` | Part of multi-word garbage |
| `D1C0` / `D3C0` | `ADDA.L D0,A0` / `ADDA.L D0,A1` | Various `MOVE.B` forms |
| `588F` / `508F` / `5C8F` | `ADDQ.L #4/8/6,A7` (stack cleanup) | `MOVE.B A7,(An)` |
| `526D xxxx` | `ADDQ.W #1,d16(A5)` | `MOVEA.B ...,A1` |
| `48D0 DEF8` | `MOVEM.L regs,(A0)` | `DC.W $48D0` |
| `4CD8 DEF8` | `MOVEM.L (A0)+,regs` | `DC.W $4CD8` |

All detailed analyses in this project are based on raw hex verification rather than disassembler output. The MULS.W instruction is particularly critical -- it is used for structure indexing (e.g., `MULS.W #17,D0` for board row access, `MULS.W #44,D0` for coroutine state indexing, `MULS.W #46,D0` for search entry indexing).
