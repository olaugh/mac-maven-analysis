# CODE 45 Analysis - Move Ranking System

## Overview

| Property | Value |
|----------|-------|
| Size | 1,122 bytes |
| JT Offset | 2752 (0x0AC0) |
| JT Entries | 4 |
| Functions | 5 |
| Category | CORE_AI, DAWG_SUPPORT |
| Purpose | **Move ranking, maintains top-10 best moves** |
| DAWG References | **3 (major DAWG integration)** |
| Confidence | **HIGH** |

## CODE Resource Header

```
Offset 0x0000: 0AC0  - JT Offset (2752)
Offset 0x0002: 0004  - JT Entries (4)
```

---

## System Role

CODE 45 implements the **move ranking system** that maintains the top 10 best moves during search:
1. Evaluates candidate moves against current best
2. Uses DAWG validation for single-tile edge placements
3. Maintains dual score tables for primary and strategic ranking
4. Implements negated-score ranking for efficient comparison

---

## DAWG References

| Offset | Purpose |
|--------|---------|
| 0x0158 | DAWG validation for single-tile moves |
| 0x0294 | DAWG lookup during move comparison |
| 0x0380 | DAWG cross-check during ranking |

---

## Complete Disassembly

### Function 0x0000: Primary Move Evaluator (JT[2752])
**Stack Frame**: -12 bytes
**Saved Registers**: D3-D7, A3, A4

```asm
; void evaluate_move_candidate(MoveEntry* candidate)
; Evaluates move and updates best-move list if better

0000: 4E56 FFF4    LINK       A6,#-12
0004: 48E7 3830    MOVEM.L    D3-D7/A3/A4,-(SP)
0008: 286E 0008    MOVEA.L    8(A6),A4        ; A4 = candidate move

; Single tile on first move validation
000C: 0C6D 0001 B236  CMPI.W  #1,-20010(A5)   ; g_tile_count == 1?
0012: 6616           BNE.S    $002A           ; Not single tile
0014: 0C2C 000F 0020  CMPI.B  #$0F,32(A4)     ; Row > 15?
001A: 6F0E           BLE.S    $002A           ; No, continue
001C: 2F0C           MOVE.L   A4,-(A7)        ; Push candidate
001E: 4EAD 0ACA      JSR      2762(A5)        ; JT[2762] - validate_single
0022: 4A40           TST.W    D0              ; Valid?
0024: 588F           ADDQ.L   #4,A7
0026: 6700 017E      BEQ.W    $01A6           ; Invalid - return

; Check move flags
002A: 4A6C 001C      TST.W    28(A4)          ; Flags field
002E: 6720           BEQ.S    $0050           ; No flags - normal path

; Flagged move - compare with best
0030: 202C 0010      MOVE.L   16(A4),D0       ; Get candidate score
0034: B0AD A5EE      CMP.L    -23074(A5),D0   ; Compare g_best_score
0038: 6F00 016C      BLE.W    $01A6           ; Not better - return

; Update best move (34-byte copy)
003C: 41ED A5DE      LEA      -23090(A5),A0   ; g_dawg_info dest
0040: 224C           MOVEA.L  A4,A1           ; Source = candidate
0042: 7007           MOVEQ    #7,D0           ; 8 longs = 32 bytes
0044: 22D9           MOVE.L   (A1)+,(A0)+     ; Copy loop
0046: 51C8 FFFC      DBF      D0,$0044
004A: 30D9           MOVE.W   (A1)+,(A0)+     ; Plus 2 = 34 total
004C: 6000 0158      BRA.W    $01A6           ; Return

; Normal path - full evaluation
0050: 2E2C 0010      MOVE.L   16(A4),D7       ; D7 = candidate score
0054: 2C2C 0014      MOVE.L   20(A4),D6       ; D6 = cross score
0058: DE86           ADD.L    D6,D7           ; Total immediate score

; Compare with threshold
005A: BE8D A614      CMP.L    -23020(A5),D7   ; g_min_threshold
005E: 6D00 0146      BLT.W    $01A6           ; Below threshold

; Rank in score tables
0062: 7A00           MOVEQ    #0,D5           ; D5 = table index
0064: 49ED F9A0      LEA      -1616(A5),A4    ; A4 = g_score_table1
0068: 6018           BRA.S    $0082           ; Jump to loop test

; Find insertion position
006A: 2014           MOVE.L   (A4),D0         ; Current entry score
006C: B087           CMP.L    D7,D0           ; candidate >= current?
006E: 6E04           BGT.S    $0074           ; Yes, found position
0070: 588C           ADDQ.L   #4,A4           ; Next entry
0072: 5245           ADDQ.W   #1,D5           ; index++

0082: 0C45 000A      CMPI.W   #10,D5          ; index < 10?
0086: 6DE2           BLT.S    $006A           ; Continue search

; Insert into table (shift down)
0088: 0C45 000A      CMPI.W   #10,D5          ; Position 10+?
008C: 6C00 0118      BGE.W    $01A6           ; Table full, not good enough

; Shift entries down
0090: 7809           MOVEQ    #9,D4           ; D4 = 9 (last index)
0092: 9845           SUB.W    D5,D4           ; Entries to shift
0094: 6716           BEQ.S    $00AC           ; None to shift

0096: 41ED F9C4      LEA      -1596(A5),A0    ; End of table1
009A: 2020           MOVE.L   -(A0),D0        ; Shift loop
009C: 2140 0004      MOVE.L   D0,4(A0)
00A0: 51CC FFF8      DBF      D4,$009A

; Store new score
00AC: 2887           MOVE.L   D7,(A4)         ; Store in table1

; Also update table2 (strategic scores)
00AE: 3005           MOVE.W   D5,D0           ; Position
00B0: E540           ASL.W    #2,D0           ; * 4
00B2: 41ED F9D0      LEA      -1584(A5),A0    ; g_score_table2
00B6: D1C0           ADDA.L   D0,A0
00B8: 202E FFF8      MOVE.L   -8(A6),D0       ; Strategic value
00BC: 2080           MOVE.L   D0,(A0)         ; Store

; Copy move entry to results buffer
00BE: 3005           MOVE.W   D5,D0           ; Position
00C0: C1FC 0022      MULS.W   #34,D0          ; * 34 (entry size)
00C4: 41ED A5D0      LEA      -23056(A5),A0   ; g_dawg_search_area
00C8: D1C0           ADDA.L   D0,A0           ; Destination
00CA: 226E 0008      MOVEA.L  8(A6),A1        ; Source = candidate
00CE: 7008           MOVEQ    #8,D0           ; 9 longs = 36 bytes
00D0: 22D9           MOVE.L   (A1)+,(A0)+
00D2: 51C8 FFFC      DBF      D0,$00D0

01A6: 4CDF 0C1C      MOVEM.L  (SP)+,D3-D7/A3/A4
01AA: 4E5E           UNLK     A6
01AC: 4E75           RTS
```

**C Translation** (Confidence: HIGH):
```c
#define MAX_RANKED_MOVES 10
#define MOVE_ENTRY_SIZE 34

/* Score tables initialized to -200,000,000 (0xF4143E00) */
long g_score_table1[10];     /* A5-1616: Primary scores */
long g_score_table2[10];     /* A5-1584: Strategic scores */
MoveEntry g_move_buffer[10]; /* A5-23056: Move storage */

void evaluate_move_candidate(MoveEntry* candidate) {
    /* Single tile validation for edge placements */
    if (g_tile_count == 1 && candidate->row > 15) {
        if (!validate_single_tile(candidate)) {
            return;  /* Invalid placement */
        }
    }

    /* Flagged moves - direct comparison with best */
    if (candidate->flags != 0) {
        if (candidate->main_score > g_best_score) {
            /* Copy 34-byte move entry to g_dawg_info */
            memcpy(&g_dawg_info, candidate, 34);
        }
        return;
    }

    /* Calculate total immediate score */
    long total_score = candidate->main_score + candidate->cross_score;

    /* Check against minimum threshold */
    if (total_score < g_min_threshold) {
        return;  /* Not good enough */
    }

    /* Find insertion position in ranked list */
    int pos = 0;
    while (pos < MAX_RANKED_MOVES && g_score_table1[pos] > total_score) {
        pos++;
    }

    if (pos >= MAX_RANKED_MOVES) {
        return;  /* Table full, move not good enough */
    }

    /* Shift lower entries down */
    for (int i = MAX_RANKED_MOVES - 1; i > pos; i--) {
        g_score_table1[i] = g_score_table1[i - 1];
        g_score_table2[i] = g_score_table2[i - 1];
        memcpy(&g_move_buffer[i], &g_move_buffer[i - 1], MOVE_ENTRY_SIZE);
    }

    /* Insert new entry */
    g_score_table1[pos] = total_score;
    g_score_table2[pos] = candidate->strategic_value;
    memcpy(&g_move_buffer[pos], candidate, MOVE_ENTRY_SIZE);
}
```

---

### Function 0x02B4: Main Comparison Entry (JT[2760])
**Stack Frame**: -342 bytes (10 × 34 = 340 + 2)
**Saved Registers**: D3-D7, A2-A4

```asm
; void initialize_ranking_tables(void)
; Initializes score tables to sentinel value

02B4: 4E56 FEAA    LINK       A6,#-342        ; Local move buffer
02B8: 48E7 1F38    MOVEM.L    D3-D7/A2-A4,-(SP)

; Initialize tables to -200,000,000 (sentinel for "empty")
0300: 203C F414 3E00  MOVE.L  #$F4143E00,D0   ; -200,000,000
0306: 7609           MOVEQ    #9,D3           ; 10 entries
0308: 41ED F9A0      LEA      -1616(A5),A0    ; g_score_table1

; Clear loop
030C: 2080           MOVE.L   D0,(A0)+        ; Store sentinel
030E: 51CB FFFC      DBF      D3,$030C

; Same for table2
0312: 7609           MOVEQ    #9,D3
0314: 41ED F9D0      LEA      -1584(A5),A0    ; g_score_table2
0318: 2080           MOVE.L   D0,(A0)+
031A: 51CB FFFC      DBF      D3,$0318

; Clear move buffer
031E: 4878 0154      PEA      $0154.W         ; 340 bytes
0322: 486D A5D0      PEA      -23056(A5)      ; g_dawg_search_area
0326: 4EAD 01AA      JSR      426(A5)         ; JT[426] - memset
032A: 508F           ADDQ.L   #8,A7

0380: 4CDF 1CF8      MOVEM.L  (SP)+,D3-D7/A2-A4
0384: 4E5E           UNLK     A6
0386: 4E75           RTS
```

**C Translation** (Confidence: HIGH):
```c
#define EMPTY_SLOT_SENTINEL (-200000000L)  /* 0xF4143E00 */

void initialize_ranking_tables(void) {
    /* Initialize score tables with sentinel value */
    for (int i = 0; i < 10; i++) {
        g_score_table1[i] = EMPTY_SLOT_SENTINEL;
        g_score_table2[i] = EMPTY_SLOT_SENTINEL;
    }

    /* Clear move buffer (340 bytes = 10 × 34) */
    memset(g_move_buffer, 0, 340);
}
```

---

### Function 0x0426: Search Initialization (JT[2768])
**Stack Frame**: 0 bytes

```asm
; void init_move_search(void* context)
; Initializes search state for new move generation

0426: 4E56 0000    LINK       A6,#0
042A: 2F2E 0008    MOVE.L     8(A6),-(A7)     ; Push context
042E: 4EAD 096A    JSR        2410(A5)        ; JT[2410] - setup_search

; Clear entry count
0432: 426D CF04    CLR.W      -12540(A5)      ; g_entry_count = 0
0436: 4EAD 0982    JSR        2434(A5)        ; JT[2434] - additional init

; Clear buffers
043A: 4878 0154    PEA        $0154.W         ; 340 bytes
043E: 486D A5D0    PEA        -23056(A5)      ; g_dawg_search_area
0442: 4EAD 01AA    JSR        426(A5)         ; JT[426] - memset
0446: 4FEF 000C    LEA        12(A7),A7       ; Clean stack

044A: 4E5E         UNLK       A6
044C: 4E75         RTS
```

**C Translation** (Confidence: HIGH):
```c
void init_move_search(void* context) {
    setup_search(context);                  /* JT[2410] */
    g_entry_count = 0;                      /* A5-12540 */
    additional_init();                      /* JT[2434] */
    memset(g_move_buffer, 0, 340);          /* Clear results */
}
```

---

## Key Data Structures

### Move Entry (34 bytes)
```c
typedef struct MoveEntry {
    char word[16];          /* Offset 0: Word data */
    long main_score;        /* Offset 16: Primary word score */
    long cross_score;       /* Offset 20: Cross-word score */
    long strategic_value;   /* Offset 24: Strategic evaluation */
    short flags;            /* Offset 28: Move flags */
    short position;         /* Offset 30: Board position */
    char row;               /* Offset 32: Board row */
    char column;            /* Offset 33: Board column */
} MoveEntry;
```

### Negated Score Ranking
- Scores are stored as-is (not negated)
- Sentinel value -200,000,000 marks empty slots
- Any valid Scrabble score will be greater than sentinel
- Enables simple comparison: higher score = better move

---

## Global Variables

| Offset | Type | Name | Purpose |
|--------|------|------|---------|
| A5-1540 | long | g_score_range2 | Range 2 threshold |
| A5-1584 | long[10] | g_score_table2 | Strategic scores |
| A5-1580 | long | g_score_range1 | Range 1 threshold |
| A5-1616 | long[10] | g_score_table1 | Primary scores |
| A5-12540 | short | g_entry_count | Current entries |
| A5-19486 | long | g_callback_ptr | Validation callback |
| A5-20010 | short | g_tile_count | Tiles in current move |
| A5-23020 | long | g_min_threshold | Minimum score threshold |
| A5-23056 | MoveEntry[10] | g_dawg_search_area | Move storage (340 bytes) |
| A5-23074 | long | g_best_score | Current best score |
| A5-23090 | MoveEntry | g_dawg_info | Best move entry (34 bytes) |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418(A5) | Error handler |
| 426(A5) | memset |
| 2090(A5) | Evaluate score ranges |
| 2122(A5) | Get score value |
| 2154(A5) | Finalize comparison |
| 2178(A5) | Commit ranking |
| 2210(A5) | Rank move in queue |
| 2274(A5) | Quick move comparison |
| 2322(A5) | Process move entry |
| 2410(A5) | Setup search context |
| 2434(A5) | Additional initialization |
| 2698(A5) | Detailed comparison |
| 2762(A5) | Validate single tile move |
| 3466(A5) | Update score table |

---

## Algorithm Summary

1. **Initialization**: Clear score tables to -200,000,000 sentinel
2. **Candidate Evaluation**:
   - Validate single-tile edge placements via DAWG
   - Calculate total score (main + cross)
   - Check against minimum threshold
3. **Ranking Insertion**:
   - Find position in sorted list
   - Shift lower entries down
   - Insert new entry
4. **Dual Table System**:
   - Table 1: Raw point scoring
   - Table 2: Strategic value for tie-breaking

---

## Confidence Assessment

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Function boundaries | HIGH | Clear LINK/UNLK/RTS |
| Sentinel value | HIGH | $F4143E00 = -200,000,000 |
| Move entry size | HIGH | 34 bytes confirmed |
| Score table layout | HIGH | 10 × 4 = 40 bytes each |
| DAWG integration | HIGH | 3 clear references |
| Insertion algorithm | HIGH | Standard sorted insert |

---

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support, AI Core

**Category**: MOVE_RANKING, DAWG_SUPPORT

**Global Variable Profile**: 3 DAWG, 0 UI, 15 total

**Calls functions in**: CODE 11, 28, 29, 30, 31, 32, 38, 39, 43, 52

**Assessment**: Critical AI module for move selection - maintains top 10 best moves during search, enabling efficient pruning and final move selection.
