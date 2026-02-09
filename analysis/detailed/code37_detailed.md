# CODE 37 Detailed Analysis - Cross-Check Generation and Move Generation

## Overview

| Property | Value |
|----------|-------|
| Size | 5344 bytes |
| JT Offset | 2560 (0x0A00) |
| JT Entries | 4 |
| Functions | 18 (15 with LINK frames, 3 leaf/inner subroutines) |
| Purpose | **Cross-check generation, DAWG traversal, Appel-Jacobson move generation** |
| Confidence | HIGH (hex-verified) |

## Architecture Role

CODE 37 is a core module in Maven's move generation pipeline. It implements:

1. **Cross-check set generation** -- determining which letters can legally be placed at each board position based on perpendicular word constraints
2. **DAWG traversal** -- walking the Directed Acyclic Word Graph to validate words and find valid letter extensions
3. **Appel-Jacobson move generation** -- the main algorithm for enumerating all legal moves on the board, including leftward prefix extension and rightward suffix extension
4. **Board state management** -- maintaining the board representation and position tracking structures used during move generation

This module is called by CODE 36 (the move generation orchestrator) and calls into CODE 35 (scoring), CODE 32 (leave evaluation), and various utility functions through the jump table.

## DAWG Node Format (Hex-Verified)

Each DAWG entry occupies **4 bytes** in memory. The code indexes the DAWG array using `ASL.L #2,D0` (multiply by 4), confirmed at multiple locations (0x025E, 0x0384, 0x0432, etc.).

```
Bits 0-7:   Letter code (1-26 for a-z)
Bit 8:      End-of-word (EOW) flag
Bit 9:      Last-sibling flag
Bits 10-31: Child pointer (22 bits)
```

Extraction patterns in hex:
- **Letter**: `MOVE.B Dn,Dm` or `AND #$FF` -- low byte
- **EOW test**: `0807 0008` = `BTST #8,D7` or `0803 0008` = `BTST #8,D3`
- **Last-sibling test**: `0807 0009` = `BTST #9,D7` or `0805 0009` = `BTST #9,D5`
- **Child pointer**: `720A E2A8` = `MOVEQ #10,D1; ASR.L D1,D0` (shift right 10 bits)

**Important correction**: The existing analysis stated DAWG entries were 8 bytes with `LSL.L #3` indexing. This is WRONG for DAWG access. The `ASL.L #3` (`E788`) pattern appears only for the **letter-set table** at A5-11960, which has 8-byte entries. DAWG nodes use `ASL.L #2` (`E588`) for 4-byte entries.

## Disassembler Error Catalog

The automated disassembler consistently mangles several instruction patterns. All corrections below are hex-verified:

| Hex | Disassembler Output | Correct Decode |
|-----|---------------------|----------------|
| `E588` | Part of mangled multi-word | `ASL.L #2,D0` (= LSL.L #2,D0) |
| `E788` | Part of mangled multi-word | `ASL.L #3,D0` (= LSL.L #3,D0) |
| `E2A8` | Part of mangled multi-word | `ASR.L D1,D0` (D1=shift count) |
| `E3A8` | Part of mangled multi-word | `ASL.L D1,D0` (D1=shift count) |
| `EA87` | Mangled | `ASR.L #5,D7` |
| `EA8F` | Mangled | `LSR.L #5,D7` |
| `E58A` | Mangled | `ASL.L #2,D2` |
| `E589` | Mangled | `ASL.L #2,D1` |
| `C1FC 0011` | `ANDA.L #$001141ED,A0` | `MULS.W #17,D0` |
| `C1C5` | `ANDA.L D5,A0` | `MULS.W D5,D0` |
| `C1C6` | `ANDA.L D6,A0` | `MULS.W D6,D0` |
| `C1C3` | `ANDA.L D3,A0` | `MULS.W D3,D0` |
| `C3C5` | `ANDA.L D5,A1` | `MULS.W D5,D1` |
| `CDC5` | `ANDA.L D5,A6` | `MULS.W D5,D6` |
| `D1C0` | Part of mangled | `ADDA.L D0,A0` |
| `D3C0` | Part of mangled | `ADDA.L D0,A1` |
| `D0C4` | Mangled as `MOVE.B` | `ADDA.W D4,A0` |
| `D0C5` | Mangled | `ADDA.W D5,A0` |
| `D0C6` | Mangled | `ADDA.W D6,A0` |
| `D4C3` | Mangled | `ADDA.W D3,A2` |
| `D8C0` | Mangled | `ADDA.W D0,A4` |
| `D6C0` | Mangled | `ADDA.W D0,A3` |
| `D7CC` | Mangled | `ADDA.L A4,A3` |
| `D5CC` | Mangled | `ADDA.L A4,A2` |
| `D9C7` | Mangled | `ADDA.L D7,A4` |
| `DC89` | Mangled | `ADDA.W A1,A6` |
| `99CC` | Mangled | `SUBA.L A4,A4` |
| `5C8F` | `MOVE.B A7,(A6)` | `ADDQ.L #6,A7` |
| `588F` | `MOVE.B A7,(A4)` | `ADDQ.L #4,A7` |
| `508F` | `MOVE.B A7,(A0)` | `ADDQ.L #8,A7` |
| `548F` | `MOVE.B A7,(A2)` | `ADDQ.L #2,A7` |
| `5247` | `MOVEA.B D7,A1` | `ADDQ.W #1,D7` |
| `5244` | `MOVEA.B D4,A1` | `ADDQ.W #1,D4` |
| `5243` | `MOVEA.B D3,A1` | `ADDQ.W #1,D3` |
| `5246` | `MOVEA.B D6,A1` | `ADDQ.W #1,D6` |
| `5314` | `MOVE.B (A4),-(A1)` | `SUBQ.B #1,(A4)` |
| `5213` | `MOVE.B (A3),D1` | `ADDQ.B #1,(A3)` |
| `5313` | `MOVE.B (A3),-(A1)` | `SUBQ.B #1,(A3)` |
| `52AD xxxx` | Mangled | `ADDQ.L #1,d16(A5)` |
| `53AD xxxx` | Mangled | `SUBQ.L #1,d16(A5)` |

The root cause is the disassembler not recognizing `ASL`/`ASR`/`LSL`/`LSR`, `MULS.W`, and `ADDA` as complete 2-byte instructions, causing it to consume the following instruction as an operand.

---

## Function-by-Function Analysis

### Function 0x0000 (210 bytes) -- init_cross_checks

**Frame**: LINK A6,#-96 (96-byte local buffer for 31 word entries + padding)
**Saves**: D7/A3/A4
**Confidence**: HIGH

#### Hex-Verified Disassembly
```
0000: 4E56 FFA0       LINK    A6,#-96
0004: 48E7 0118       MOVEM.L D7/A3/A4,-(SP)
0008: 3F3C 0220       MOVE.W  #544,-(A7)          ; 544 = 17*32
000C: 486D BCFE       PEA     -17154(A5)           ; g_state1
0010: 4EAD 0D7A       JSR     3450(A5)             ; JT[3450] = memcmp
0014: 4A40            TST.W   D0
0016: 5C8F            ADDQ.L  #6,A7                ; clean stack (2+4 params)
0018: 6700 008C       BEQ.W   $00A8                ; no changes, skip to init_array

001C: 486E FFA0       PEA     -96(A6)              ; local buffer
0020: 2F2E 0008       MOVE.L  8(A6),-(A7)          ; input param
0024: 4EBA 00AC       JSR     172(PC)              ; => 0x00D2 setup_board_context

0028: 3B7C 0007 BCFC  MOVE.W  #7,-17156(A5)        ; g_row_counter = 7
002E: 7022            MOVEQ   #34,D0
0030: 2E80            MOVE.L  D0,(A7)              ; reuse stack: size=34
0032: 486D D60E       PEA     -10738(A5)           ; position_data_1
0036: 4EAD 01AA       JSR     426(A5)              ; JT[426] = memset (clear 34 bytes)
003A: 7022            MOVEQ   #34,D0
003C: 2E80            MOVE.L  D0,(A7)
003E: 486D D630       PEA     -10704(A5)           ; position_data_2
0042: 4EAD 01AA       JSR     426(A5)              ; memset

0046: 206D D5FA       MOVEA.L -10758(A5),A0        ; g_move_ptr
004A: 117C 0008 0020  MOVE.B  #8,32(A0)            ; move.direction = 8 (horizontal)
0050: 70FF            MOVEQ   #-1,D0
0052: D0AD D5FA       ADD.L   -10758(A5),D0        ; D0 = g_move_ptr - 1
0056: 2B40 D606       MOVE.L  D0,-10746(A5)        ; g_word_cursor = move_ptr - 1

005A: 41ED BD86       LEA     -17018(A5),A0        ; board_base + 136
005E: 2B48 D5FE       MOVE.L  A0,-10754(A5)        ; g_board_row_ptr
0062: 3EBC 0008       MOVE.W  #8,(A7)              ; push 8
0066: 4EBA 07E2       JSR     2018(PC)             ; => 0x084A (setup_anchor_row)

006A: 41ED 961A       LEA     -27110(A5),A0        ; g_letter_data
006E: 2B48 D602       MOVE.L  A0,-10750(A5)        ; g_letter_data_ptr

0072: 7E00            MOVEQ   #0,D7                ; index = 0
0074: 49ED D148       LEA     -11960(A5),A4        ; g_dawg_table
0078: 4FEF 0010       LEA     16(A7),A7            ; clean stack

; Main DAWG table loop
007C: 2B54 D140       MOVE.L  (A4),-11968(A5)      ; g_dawg_base = table[index]
0080: 3B47 D548       MOVE.W  D7,-10936(A5)        ; g_dict_index = index
0084: 204D            MOVEA.L A5,A0
0086: 2007            MOVE.L  D7,D0
0088: 48C0            EXT.L   D0
008A: E788            ASL.L   #3,D0                ; *8 (letter-set table is 8-byte entries)
008C: D1C0            ADDA.L  D0,A0
008E: 2B68 D14C D144  MOVE.L  -11956(A0),-11964(A5) ; g_dawg_root = letterset[index].root
0094: 6734            BEQ.S   $00CA                ; null root => done

0096: 2F2D D144       MOVE.L  -11964(A5),-(A7)     ; push root node
009A: 4EBA 01AE       JSR     430(PC)              ; => 0x024A (traverse_and_gen)
009E: 588F            ADDQ.L  #4,A7                ; clean stack
00A0: 5247            ADDQ.W  #1,D7                ; index++
00A2: 508C            ADDQ.L  #4,A4                ; next dawg_table entry (+4)
00A4: 60D6            BRA.S   $007C

00A6: 7E01            MOVEQ   #1,D7                ; D7 = 1 (for array init)

; Initialize word array with -1
00A8: 47EE FFC4       LEA     -60(A6),A3           ; local array at frame-60
00AC: 6008            BRA.S   $00B6
00AE: 36BC FFFF       MOVE.W  #$FFFF,(A3)          ; mark invalid
00B2: 5247            ADDQ.W  #1,D7
00B4: 548B            ADDQ.L  #2,A3                ; next word entry
00B6: 0C47 001F       CMPI.W  #31,D7
00BA: 6DF2            BLT.S   $00AE

00BC: 2F2E 0008       MOVE.L  8(A6),-(A7)
00C0: 486E FFC2       PEA     -62(A6)              ; word array base
00C4: 4EBA 06EC       JSR     1772(PC)             ; => 0x07B2 (process_row_words)
00C8: 508F            ADDQ.L  #8,A7

00CA: 4CDF 1880       MOVEM.L (SP)+,D7/A3/A4
00CE: 4E5E            UNLK    A6
00D0: 4E75            RTS
```

#### C Decompilation
```c
void init_cross_checks(void *input_data) {
    int16_t word_array[31];  /* -96(A6), 62 bytes used */

    /* Check if board state changed (compare 544 bytes = 17*32) */
    if (memcmp(g_state1, input_data, 544) != 0) {
        setup_board_context(input_data, &word_array);

        g_row_counter = 7;
        memset(g_position_data_1, 0, 34);
        memset(g_position_data_2, 0, 34);

        g_move_ptr->direction = 8;  /* horizontal */
        g_word_cursor = (uint8_t*)g_move_ptr - 1;
        g_board_row_ptr = &g_state1[136];  /* row 8 = center */

        setup_anchor_row(8);
        g_letter_data_ptr = g_letter_data;

        /* Traverse each dictionary's DAWG */
        for (int i = 0; ; i++) {
            g_dawg_base = g_dawg_table[i];
            g_dict_index = i;
            g_dawg_root = g_letterset_table[i].root;
            if (g_dawg_root == 0) break;
            traverse_and_gen(g_dawg_root);
        }
    }

    /* Initialize word position array */
    for (int i = 1; i < 31; i++)
        word_array[i] = -1;

    process_row_words(&word_array, input_data);
}
```

---

### Function 0x00D2 (60 bytes) -- setup_board_context

**Frame**: LINK A6,#0
**Confidence**: HIGH

#### Hex-Verified Disassembly
```
00D2: 4E56 0000       LINK    A6,#0
00D6: 4878 0080       PEA     $0080              ; 128 bytes
00DA: 486D CE84       PEA     -12668(A5)         ; g_cross_info (128 bytes)
00DE: 4EAD 01AA       JSR     426(A5)            ; memset (clear)

00E2: 2B6E 000C D5FA  MOVE.L  12(A6),-10758(A5)  ; g_move_ptr = param2
00E8: 7022            MOVEQ   #34,D0
00EA: 2E80            MOVE.L  D0,(A7)            ; size = 34
00EC: 2F2E 000C       MOVE.L  12(A6),-(A7)       ; move_ptr
00F0: 4EAD 01AA       JSR     426(A5)            ; memset (clear 34 bytes)

00F4: 4878 0080       PEA     $0080              ; 128
00F8: 486D A54E       PEA     -23218(A5)         ; g_letter_counts (source)
00FC: 486D D678       PEA     -10632(A5)         ; g_rack_counts (dest)
0100: 4EAD 0D8A       JSR     3466(A5)           ; JT[3466] = memmove

0104: 2B6E 0008 D674  MOVE.L  8(A6),-10636(A5)   ; g_rack_storage = param1
010A: 4E5E            UNLK    A6
010C: 4E75            RTS
```

#### C Decompilation
```c
void setup_board_context(char *rack, uint8_t *move_struct) {
    memset(g_cross_info, 0, 128);
    g_move_ptr = move_struct;
    memset(move_struct, 0, 34);
    memmove(g_rack_counts, g_letter_counts, 128);
    g_rack_storage = rack;
}
```

---

### Function 0x010E (316 bytes) -- generate_cross_check_sets

**Frame**: LINK A6,#-4
**Saves**: D3/D4/D5/D6/D7/A2/A3/A4
**Confidence**: HIGH

This is the cross-check generation function. For each board position, it computes a 32-bit mask indicating which letters can be legally placed there based on perpendicular word constraints.

#### Hex-Verified Key Sequences

At 0x0150-0x015C (row offset calculation):
```
0150: 70FF            MOVEQ   #-1,D0             ; D0 = -1
0152: D044            ADD.W   D4,D0              ; D0 = row - 1
0154: C1FC 0011       MULS.W  #17,D0             ; D0 = (row-1) * 17
0158: 41ED BCFE       LEA     -17154(A5),A0      ; A0 = g_state1
015C: D088            ADD.L   A0,D0              ; D0 = &state1[(row-1)*17]
```

At 0x01A0-0x01AC (letter mask lookup):
```
01A0: 204D            MOVEA.L A5,A0
01A2: 48C0            EXT.L   D0
01A4: E588            ASL.L   #2,D0              ; *4 (32-bit mask entries)
01A6: D1C0            ADDA.L  D0,A0
01A8: 26A8 9852       MOVE.L  -26542(A0),(A3)    ; crosscheck = letter_masks[letter]
```

At 0x01AE-0x01BC (adjacent cell check):
```
01AE: 3043            MOVEA.W D3,A0              ; A0 = col
01B0: 4A30 6800       TST.B   (0,A0,D6.L)       ; cell_above[col]
01B4: 660E            BNE.S   has_adjacent
01B6: 3043            MOVEA.W D3,A0
01B8: 4A30 7800       TST.B   (0,A0,D7.L)       ; cell_below[col]
01BC: 6606            BNE.S   has_adjacent
```

#### C Decompilation
```c
void generate_cross_check_sets(void) {
    int16_t cross_row, cross_col;  /* -2(A6), -4(A6) */

    /* Validate row buffer is different from board */
    if (memcmp(g_empty_row, g_state1, 17) == 0)
        bounds_error();

    int row = 1;                           /* D4 */
    CrossCheckRow *cc = g_crosschecks;     /* A4 = A5-22118 */
    uint32_t board_ptr = (uint32_t)&g_state1[17]; /* D5, skip border row */

    for (row = 1; row < 31; row++) {
        /* Get pointer to row above */
        uint32_t row_above;  /* D6 */
        if (row == 1 || row == 16)
            row_above = (uint32_t)g_empty_row;  /* boundary: all empty */
        else
            row_above = (uint32_t)&g_state1[(row - 1) * 17];

        g_board_row_ptr = (uint8_t*)board_ptr;

        /* Get pointer to row below */
        uint32_t row_below;  /* D7 */
        if (row == 15 || row == 30)
            row_below = (uint32_t)g_empty_row;
        else
            row_below = (uint32_t)&g_state1[(row + 1) * 17];

        uint32_t *cc_ptr = &cc->columns[0];  /* A3 = A4+4 */

        for (int col = 1; col < 16; col++) {  /* D3 */
            uint8_t *cell = g_board_row_ptr + col;

            if (*cell != 0) {
                /* Occupied: cross-check = that letter's mask */
                uint8_t letter = *cell;
                *cc_ptr = g_letter_masks[letter];  /* indexed by letter*4 from A5-26542 */
            }
            else if (((uint8_t*)row_above)[col] == 0 &&
                     ((uint8_t*)row_below)[col] == 0) {
                /* No adjacent perpendicular letters: all valid */
                *cc_ptr = 0xFFFFFFFF;
            }
            else {
                /* Has perpendicular neighbor: compute from DAWG */
                calc_position(row, col, &cross_row, &cross_col);  /* JT[2338] */

                uint8_t *cross_ptr = &g_state1[cross_row * 17 + cross_col - 1];

                /* Scan backward to find start of cross-word */
                while (*cross_ptr != 0) cross_ptr--;
                cross_ptr++;  /* first letter */

                *cc_ptr = 0;

                /* Get valid letters from DAWG */
                char *valid = find_valid_letters(cross_ptr, g_rack + 1);
                while (*valid != 0) {
                    uint8_t vl = *valid++;
                    *cc_ptr |= g_letter_masks[vl];
                }
            }
            cc_ptr++;
        }

        cc++;           /* +68 bytes */
        board_ptr += 17;
    }
}
```

---

### Function 0x024A (286 bytes) -- traverse_and_gen

**Frame**: LINK A6,#0
**Saves**: D4/D5/D6/D7/A3/A4
**Confidence**: HIGH

This is the recursive DAWG traversal used during initialization. It walks the DAWG, checking each word against rack availability and board constraints.

#### Hex-Verified Key Sequences

DAWG node access at 0x025A-0x0268:
```
025A: 52AE 0008       ADDQ.L  #1,8(A6)           ; advance node index
025E: E588            ASL.L   #2,D0              ; *4 (DAWG 4-byte entries)
0260: D0AD D140       ADD.L   -11968(A5),D0      ; + g_dawg_base
0264: 2040            MOVEA.L D0,A0
0266: 2E10            MOVE.L  (A0),D7            ; D7 = DAWG node
```

Character validation at 0x0274-0x0282:
```
0274: 7000            MOVEQ   #0,D0
0276: 1010            MOVE.B  (A0),D0            ; letter code
0278: 224D            MOVEA.L A5,A1
027A: D3C0            ADDA.L  D0,A1
027C: 4A29 FBD8       TST.B   -1064(A1)          ; g_char_class[letter]
0280: 6B04            BMI.S   valid              ; negative = valid letter
0282: 4EAD 01A2       JSR     418(A5)            ; bounds_error
```

Rack count check at 0x0286-0x0296:
```
0286: 1006            MOVE.B  D6,D0              ; letter
0288: 4880            EXT.W   D0
028A: 49ED D678       LEA     -10632(A5),A4      ; g_rack_counts
028E: D8C0            ADDA.W  D0,A4              ; &rack_counts[letter]
0290: 4A14            TST.B   (A4)               ; count available?
0292: 6700 00B0       BEQ.W   $0346              ; no: try blank or skip
0296: 5314            SUBQ.B  #1,(A4)            ; consume letter
```

Child pointer extraction at 0x032C-0x033A:
```
032C: 720A            MOVEQ   #10,D1
032E: E2A8            ASR.L   D1,D0              ; >>10 = child pointer
0330: 670E            BEQ.S   no_children
0332: 2007            MOVE.L  D7,D0
0334: 720A            MOVEQ   #10,D1
0336: E2A8            ASR.L   D1,D0              ; >>10 again for push
0338: 2F00            MOVE.L  D0,-(A7)
033A: 4EBA FF0E       JSR     -242(PC)           ; recursive call to 0x024A
```

Blank tile fallback at 0x0344-0x034A:
```
0344: 49ED D6B7       LEA     -10569(A5),A4      ; g_blank_count
0348: 4A14            TST.B   (A4)               ; blank available?
034A: 6600 FF4A       BNE.W   $0298              ; yes: try with blank (goto EOW check)
```

#### C Decompilation
```c
void traverse_and_gen(uint32_t node_index) {
    g_word_cursor++;

    uint32_t node = g_dawg_base[node_index];  /* 4-byte access */
    uint8_t letter = node & 0xFF;             /* D6 */
    *g_word_cursor = letter;

    /* Validate character */
    if (g_char_class[letter] >= 0)
        bounds_error();

    int8_t *count_ptr = &g_rack_counts[letter];  /* A4 */

    if (*count_ptr == 0) {
        /* Letter not in rack - try blank */
        count_ptr = &g_blank_count;
        if (*count_ptr == 0)
            goto check_last;
        /* Fall through to EOW check with blank */
    } else {
        (*count_ptr)--;  /* consume from rack */
    }

    /* Check end-of-word */
    if (node & 0x100) {  /* bit 8 = EOW */
        uint32_t word_len = g_word_cursor - g_move_ptr;
        int16_t start = 8 - word_len;

        while (start <= 8) {
            g_move_ptr[33] = start;  /* row position */
            *(uint32_t*)(g_move_ptr + 24) = 0;  /* clear score */

            int16_t pos = start;
            uint8_t *wp = g_move_ptr;
            while (*wp != 0) {
                if (is_playable(*wp)) {  /* JT[2002] */
                    /* Check all 4 constraint arrays */
                    if (g_constraint_a[pos] > 1 ||
                        g_constraint_b[pos] > 1 ||
                        g_constraint_c[pos] > 1 ||
                        g_constraint_d[pos] > 1) {
                        (*(uint32_t*)(g_move_ptr + 24))--;  /* decrement = add anchor */
                    }
                }
                pos++;
                wp++;
            }

            handle_valid_word();  /* PC-relative call to 0x0E42 */
            *(uint32_t*)(g_move_ptr + 24) = 0;
            start++;
        }
    }

    /* Recurse into children */
    uint32_t child = node >> 10;
    if (child != 0)
        traverse_and_gen(child);

    (*count_ptr)++;  /* restore rack count */

check_last:
    if (!(node & 0x200))  /* bit 9 = last sibling */
        traverse_and_gen(node_index + 1);  /* next sibling */

    *g_word_cursor = 0;  /* backtrack */
    g_word_cursor--;
}
```

---

### Function 0x0368 (98 bytes) -- dawg_lookup

**Frame**: LINK A6,#0
**Saves**: D5/D6/D7
**Confidence**: HIGH

Traverses the DAWG for a null-terminated word string. Returns the child pointer of the final matching node, or -1 if not found.

#### Hex-Verified Key Sequences

```
0368: 4E56 0000       LINK    A6,#0
036C: 48E7 0700       MOVEM.L D5/D6/D7,-(SP)
0370: 206E 0008       MOVEA.L 8(A6),A0          ; word pointer
0374: 1E10            MOVE.B  (A0),D7            ; first letter
0376: 6606            BNE.S   $037E
0378: 202D D144       MOVE.L  -11964(A5),D0      ; empty word => return root
037C: 6044            BRA.S   $03C2

037E: 2C2D D144       MOVE.L  -11964(A5),D6      ; D6 = current node index
0382: 2006            MOVE.L  D6,D0
0384: E588            ASL.L   #2,D0              ; *4
0386: D0AD D140       ADD.L   -11968(A5),D0      ; + dawg_base
038A: 2040            MOVEA.L D0,A0
038C: 2A10            MOVE.L  (A0),D5            ; D5 = node

038E: BE05            CMP.B   D5,D7              ; compare letter
0390: 661E            BNE.S   $03B0              ; no match

; Match found
0392: 2C05            MOVE.L  D5,D6
0394: 700A            MOVEQ   #10,D0
0396: E0A6            ASR.L   D0,D6              ; D6 = child = node >> 10

039C: 206E 0008       MOVEA.L 8(A6),A0
03A0: 1E10            MOVE.B  (A0),D7            ; next letter
03A2: 6604            BNE.S   $03A8              ; more letters
03A4: 2006            MOVE.L  D6,D0              ; end of word: return child
03A6: 601A            BRA.S   $03C2

03A8: 4A86            TST.L   D6
03AA: 66D6            BNE.S   $0382              ; continue if child != 0
03AC: 70FF            MOVEQ   #-1,D0             ; no child: return -1
03AE: 6012            BRA.S   $03C2

; No match - check sibling
03B0: 0805 0009       BTST    #9,D5              ; last sibling?
03B4: 6604            BNE.S   $03BA              ; yes: not found
03B6: BE05            CMP.B   D5,D7              ; D7 >= D5.letter?
03B8: 6C04            BGE.S   $03BE              ; yes: try next
03BA: 70FF            MOVEQ   #-1,D0             ; not found
03BC: 6004            BRA.S   $03C2
03BE: 5286            ADDQ.L  #1,D6              ; next sibling
03C0: 60C0            BRA.S   $0382

03C2: 4CDF 00E0       MOVEM.L (SP)+,D5/D6/D7
03C6: 4E5E            UNLK    A6
03C8: 4E75            RTS
```

#### C Decompilation
```c
int32_t dawg_lookup(char *word) {
    uint8_t target = *word;
    if (target == 0)
        return g_dawg_root;

    uint32_t idx = g_dawg_root;  /* D6 */

    while (1) {
        uint32_t node = g_dawg_base[idx];  /* D5 */

        if ((node & 0xFF) == target) {
            /* Match: descend to child */
            idx = node >> 10;
            word++;
            target = *word;
            if (target == 0)
                return idx;       /* end of word: return child ptr */
            if (idx == 0)
                return -1;        /* dead end */
            continue;
        }

        /* No match: try sibling */
        if (node & 0x200)         /* last sibling */
            return -1;
        if ((node & 0xFF) > target)
            return -1;            /* passed target (sorted) */
        idx++;
    }
}
```

---

### Function 0x03CA (268 bytes) -- find_valid_letters

**Frame**: LINK A6,#-14
**Saves**: D3/D4/D5/D6/D7/A2/A3/A4
**Confidence**: HIGH

Given a cross-word prefix and suffix (before/after the target position), finds all letters that complete a valid word when inserted at the target position. Used by cross-check generation.

#### Key Hex Sequences

```
03CA: 4E56 FFF2       LINK    A6,#-14
03D2: 266E 0008       MOVEA.L 8(A6),A3          ; prefix (cross-word text)
03D6: 246E 000C       MOVEA.L 12(A6),A2         ; suffix letters to check
03DA: 2D4B FFFC       MOVE.L  A3,-4(A6)         ; save prefix
03DE: 2D4A FFF8       MOVE.L  A2,-8(A6)         ; save suffix
03E2: 49ED F90E       LEA     -1778(A5),A4      ; result buffer (A4 = write ptr)
03E6: 426E FFF6       CLR.W   -10(A6)           ; dict_counter = 0
03EA: 41ED D148       LEA     -11960(A5),A0     ; g_dawg_table
03EE: 2D48 FFF2       MOVE.L  A0,-14(A6)        ; table_ptr
```

DAWG lookup call at 0x041C-0x0428:
```
041C: 2F0B            MOVE.L  A3,-(A7)          ; push prefix
041E: 4EBA FF48       JSR     -184(PC)          ; => 0x0368 (dawg_lookup)
0422: 2C00            MOVE.L  D0,D6             ; D6 = node after prefix
0424: 4A86            TST.L   D6
0426: 588F            ADDQ.L  #4,A7
0428: 6F00 0090       BLE.W   $04BC             ; prefix not found: next dict
```

Letter match and EOW check at 0x0446-0x0456:
```
0446: B803            CMP.B   D3,D4             ; node_letter == expected?
0448: 6658            BNE.S   $04A2             ; no match
044A: 4A13            TST.B   (A3)              ; has suffix?
044C: 660A            BNE.S   $0458             ; yes: check children
044E: 0803 0008       BTST    #8,D3             ; EOW?
0452: 674C            BEQ.S   $04A0             ; no: skip
0454: 18C3            MOVE.B  D3,(A4)+          ; store valid letter
```

#### C Decompilation
```c
char *find_valid_letters(char *prefix, char *suffix_letters) {
    char *result = g_valid_letters_buf;  /* A5-1778 */
    char *rp = result;

    for (int dict = 0; ; dict++) {
        g_dawg_base = g_dawg_table[dict];
        g_dict_index = dict;
        g_dawg_root = g_letterset_table[dict].root;
        if (g_dawg_root == 0) break;

        /* Traverse prefix */
        int32_t node_idx = dawg_lookup(prefix);
        if (node_idx <= 0) continue;

        /* Skip to end of prefix */
        while (*prefix) prefix++;

        /* Get node at prefix end */
        uint32_t node = g_dawg_base[node_idx];
        uint8_t expected = *suffix_letters;

        /* Check each DAWG sibling against expected letters */
        while (1) {
            uint8_t nl = node & 0xFF;

            if (nl == expected) {
                if (*prefix == 0) {
                    /* No suffix: check EOW */
                    if (node & 0x100)
                        *rp++ = nl;
                } else {
                    /* Has suffix: verify child path matches */
                    uint32_t child = node >> 10;
                    if (child != 0) {
                        /* Walk children to match suffix */
                        /* ... recursive child matching ... */
                    }
                }
                suffix_letters++;
                expected = *suffix_letters;
            }

            if (node & 0x200) break;  /* last sibling */
            node_idx++;
            node = g_dawg_base[node_idx];
        }

        /* Reset for next dictionary */
        prefix = saved_prefix;
        suffix_letters = saved_suffix;
    }

    *rp = 0;  /* null-terminate */
    return result;
}
```

---

### Function 0x04D6 (48 bytes) -- cross_check_mask_diff

**Frame**: LINK A6,#0
**Confidence**: HIGH

Computes a set-difference between two cross-check masks. The formula `~(mask1-1) & (mask2-1)` effectively computes "letters valid in mask2 but not in mask1" when masks use a specific encoding.

#### Complete Hex-Verified Disassembly
```
04D6: 4E56 0000       LINK    A6,#0
04DA: 204D            MOVEA.L A5,A0
04DC: 302E 000A       MOVE.W  10(A6),D0          ; param2 (row2)
04E0: 48C0            EXT.L   D0
04E2: E588            ASL.L   #2,D0              ; *4
04E4: D1C0            ADDA.L  D0,A0              ; A0 = A5 + row2*4
04E6: 224D            MOVEA.L A5,A1
04E8: 302E 0008       MOVE.W  8(A6),D0           ; param1 (row1)
04EC: 48C0            EXT.L   D0
04EE: E588            ASL.L   #2,D0              ; *4
04F0: D3C0            ADDA.L  D0,A1              ; A1 = A5 + row1*4
04F2: 70FF            MOVEQ   #-1,D0
04F4: D0A9 99D6       ADD.L   -26154(A1),D0      ; D0 = table1[row1] + 0xFFFFFFFF
04F8: 4680            NOT.L   D0                  ; D0 = ~(table1[row1] - 1)
04FA: 72FF            MOVEQ   #-1,D1
04FC: D2A8 99DA       ADD.L   -26150(A0),D1      ; D1 = table2[row2] - 1
0500: C081            AND.L   D1,D0              ; D0 = ~(t1-1) & (t2-1)
0502: 4E5E            UNLK    A6
0504: 4E75            RTS
```

#### C Decompilation
```c
/* Two arrays at A5-26154 and A5-26150, each indexed by row*4 */
uint32_t cross_check_mask_diff(int16_t row1, int16_t row2) {
    uint32_t mask1 = g_xcheck_array_a[row1];  /* A5-26154 + row1*4 */
    uint32_t mask2 = g_xcheck_array_b[row2];  /* A5-26150 + row2*4 */
    return ~(mask1 - 1) & (mask2 - 1);
}
```

---

### Function 0x0506 (62 bytes) -- scan_leftward_extent

**Frame**: LINK A6,#0
**Saves**: D6/D7/A4
**Confidence**: HIGH

Scans leftward from a given column position in a board row, counting empty cells. Returns the column position where a sufficient number of empty cells have been found, used to determine how far left a word prefix can extend.

#### Hex-Verified Disassembly
```
0506: 4E56 0000       LINK    A6,#0
050A: 48E7 0308       MOVEM.L D6/D7/A4,-(SP)
050E: 3C2E 000A       MOVE.W  10(A6),D6          ; col (scans leftward)
0512: 7011            MOVEQ   #17,D0
0514: C1EE 0008       MULS.W  8(A6),D0           ; row * 17
0518: 49ED BCFE       LEA     -17154(A5),A4      ; g_state1
051C: D08C            ADD.L   A4,D0              ; D0 = &state1[row*17]
051E: 2840            MOVEA.L D0,A4              ; A4 = row base address
0520: 7E00            MOVEQ   #0,D7              ; empty_count = 0
0522: 600A            BRA.S   $052E

0524: 4A34 6000       TST.B   (0,A4,D6.W)       ; test cell at [row][col]
0528: 6602            BNE.S   $052C              ; occupied: skip count
052A: 5247            ADDQ.W  #1,D7              ; empty_count++
052C: 5346            SUBQ.W  #1,D6              ; col--
052E: 4A46            TST.W   D6
0530: 6706            BEQ.S   $0538              ; col == 0: done
0532: BE6E 000C       CMP.W   12(A6),D7          ; empty_count < limit?
0536: 6DEC            BLT.S   $0524              ; yes: continue scanning

0538: 7001            MOVEQ   #1,D0
053A: D046            ADD.W   D6,D0              ; return col + 1
053C: 4CDF 10C0       MOVEM.L (SP)+,D6/D7/A4
0540: 4E5E            UNLK    A6
0542: 4E75            RTS
```

#### C Decompilation
```c
int16_t scan_leftward_extent(int16_t row, int16_t col, int16_t limit) {
    uint8_t *row_base = &g_state1[row * 17];
    int empty_count = 0;

    while (col > 0 && empty_count < limit) {
        if (row_base[col] == 0)
            empty_count++;
        col--;
    }
    return col + 1;
}
```

---

### Function 0x0544 (622 bytes) -- generate_moves_for_anchor

**Frame**: LINK A6,#-88
**Saves**: D3/D4/D5/D6/D7/A2/A3/A4
**Confidence**: MEDIUM-HIGH

This is a large function that generates moves for a specific anchor square. It handles both directions of play and manages cross-check lookups for perpendicular words.

#### Key Parameters
- 8(A6) = A4 = move structure pointer
- 12(A6) = board context pointer
- 16(A6) = word buffer
- 20(A6) = string to measure (length capped at 7)

#### Key Hex Sequences

String length call at 0x0550:
```
0550: 2F2E 0014       MOVE.L  20(A6),-(A7)
0554: 4EAD 0DC2       JSR     3522(A5)           ; JT[3522] = strlen
0558: 3A00            MOVE.W  D0,D5              ; D5 = length
055A: 0C45 0007       CMPI.W  #7,D5
055E: 588F            ADDQ.L  #4,A7
0560: 6F02            BLE.S   ok
0562: 7A07            MOVEQ   #7,D5              ; cap at 7
```

Board position computation at 0x0570:
```
0564: 182C 0021       MOVE.B  33(A4),D4          ; D4 = move row
0568: 4884            EXT.W   D4
056A: 1C2C 0020       MOVE.B  32(A4),D6          ; D6 = move direction
056E: 4886            EXT.W   D6
0570: 7011            MOVEQ   #17,D0
0572: C1C6            MULS.W  D6,D0              ; 17 * direction
0574: 41ED BCFE       LEA     -17154(A5),A0      ; g_state1
0578: D088            ADD.L   A0,D0              ; base + 17*direction
057A: 3044            MOVEA.W D4,A0
057C: D088            ADD.L   A0,D0              ; + row offset
057E: 2D40 FFB0       MOVE.L  D0,-80(A6)         ; board_ptr = &state1[dir*17 + row]
```

The function calls `scan_leftward_extent` (0x0506 via PC-relative at 0x05A2), `cross_check_mask_diff` (0x04D6 via PC-relative at 0x05AA), and `calc_position` (JT[2338]) to build move candidates.

It also calls:
- JT[2370] = setup_scoring at 0x0770
- JT[2378] = cleanup_scoring at 0x07A4
- JT[2410] = commit_score at 0x0764, 0x0778
- JT[3450] = memcmp at 0x0784

---

### Function 0x07B2 (86 bytes) -- process_row_words

**Frame**: LINK A6,#-66
**Saves**: D6/D7/A4
**Confidence**: MEDIUM-HIGH

Processes word placements for a row, iterating through positions 0-30 and calling into the main move evaluation pipeline.

#### Hex-Verified Disassembly
```
07B2: 4E56 FFBE       LINK    A6,#-66            ; 66-byte local buffer
07B6: 48E7 0308       MOVEM.L D6/D7/A4,-(SP)
07BA: 4EBA 066E       JSR     1646(PC)           ; => 0x0E2A (check_interrupt)
07BE: 486E FFBE       PEA     -66(A6)            ; local buffer
07C2: 2F2E 000C       MOVE.L  12(A6),-(A7)       ; input param
07C6: 4EBA F90A       JSR     -1782(PC)          ; => 0x00D2 (setup_board_context)
07CA: 486E FFE0       PEA     -32(A6)
07CE: 4EBA 05B2       JSR     1458(PC)           ; => 0x0D82 (build_rack_mask)
07D2: 2E00            MOVE.L  D0,D7              ; D7 = rack letter mask
07D4: 7C00            MOVEQ   #0,D6              ; row = 0
07D6: 99CC            SUBA.L  A4,A4              ; A4 = 0
07D8: 4FEF 000C       LEA     12(A7),A7          ; clean stack

; Loop over 31 positions
07DC: 204C            MOVEA.L A4,A0
07DE: D1EE 0008       ADDA.L  8(A6),A0           ; A0 = base + offset
07E2: 3F10            MOVE.W  (A0),-(A7)         ; push word entry
07E4: 486E FFE0       PEA     -32(A6)            ; local buffer
07E8: 2F07            MOVE.L  D7,-(A7)           ; rack mask
07EA: 3F06            MOVE.W  D6,-(A7)           ; position
07EC: 4EBA 0198       JSR     408(PC)            ; => 0x0988 (gen_moves_at_pos)
07F0: 4FEF 000C       LEA     12(A7),A7
07F4: 5246            ADDQ.W  #1,D6              ; position++
07F6: 548C            ADDQ.L  #2,A4              ; offset += 2
07F8: 0C46 001F       CMPI.W  #31,D6
07FC: 6DDE            BLT.S   $07DC

07FE: 4CDF 10C0       MOVEM.L (SP)+,D6/D7/A4
0802: 4E5E            UNLK    A6
0804: 4E75            RTS
```

#### C Decompilation
```c
void process_row_words(int16_t *word_array, void *context) {
    uint8_t local_buf[66];

    check_interrupt();
    setup_board_context(context, local_buf);
    uint32_t rack_mask = build_rack_mask(local_buf + 34);

    for (int16_t pos = 0; pos < 31; pos++) {
        gen_moves_at_pos(pos, rack_mask, local_buf + 34, word_array[pos]);
    }
}
```

---

### Function 0x0808 (66 bytes) -- validate_word_placement

**Frame**: LINK A6,#0
**Saves**: D7/A2/A3/A4
**Confidence**: HIGH

Validates that a word placement is consistent with the current board state by walking through the board row and the candidate word simultaneously.

#### Hex-Verified Disassembly
```
0808: 4E56 0000       LINK    A6,#0
080C: 48E7 0138       MOVEM.L D7/A2/A3/A4,-(SP)
0810: 7011            MOVEQ   #17,D0
0812: C1EE 0008       MULS.W  8(A6),D0           ; row * 17
0816: 2840            MOVEA.L D0,A4              ; temp offset
0818: 47ED BCFE       LEA     -17154(A5),A3      ; g_state1
081C: D7CC            ADDA.L  A4,A3              ; A3 = &state1[row*17]
081E: 528B            ADDQ.L  #1,A3              ; skip border (col 1)
0820: 45ED 97B2       LEA     -26702(A5),A2      ; g_word_buffer
0824: D5CC            ADDA.L  A4,A2              ; A2 = &word_buf[row*17]
0826: 528A            ADDQ.L  #1,A2              ; skip border
0828: 6012            BRA.S   $083C

082A: 4A13            TST.B   (A3)               ; board cell
082C: 660A            BNE.S   $0838              ; occupied: OK
082E: 0C07 0001       CMPI.B  #1,D7              ; word letter == 1 (empty marker)?
0832: 6704            BEQ.S   $0838              ; yes: OK
0834: 7000            MOVEQ   #0,D0              ; FAIL
0836: 600A            BRA.S   $0842

0838: 528B            ADDQ.L  #1,A3              ; next board cell
083A: 528A            ADDQ.L  #1,A2              ; next word letter
083C: 1E12            MOVE.B  (A2),D7            ; D7 = current word letter
083E: 66EA            BNE.S   $082A              ; loop while non-zero
0840: 7001            MOVEQ   #1,D0              ; SUCCESS

0842: 4CDF 1C80       MOVEM.L (SP)+,D7/A2/A3/A4
0846: 4E5E            UNLK    A6
0848: 4E75            RTS
```

#### C Decompilation
```c
int16_t validate_word_placement(int16_t row) {
    uint8_t *board = &g_state1[row * 17 + 1];
    uint8_t *word = &g_word_buffer[row * 17 + 1];

    while (*word != 0) {
        if (*board == 0 && *word != 1)
            return 0;  /* board empty but word has real letter: fail */
        board++;
        word++;
    }
    return 1;  /* all positions OK */
}
```

---

### Function 0x084A (210 bytes) -- setup_anchor_row

**Frame**: LINK A6,#-14
**Saves**: D3/D4/D5/D6/D7/A2/A3/A4
**Confidence**: MEDIUM-HIGH

Initializes anchor square data for a given row. Anchor squares are positions adjacent to existing tiles where new words can begin.

#### Key Hex Sequences

Board check at 0x0864-0x086C:
```
0864: 204D            MOVEA.L A5,A0
0866: D0C5            ADDA.W  D5,A0              ; A0 = A5 + row
0868: 4A28 F92E       TST.B   -1746(A0)          ; g_board_occupied[row]
086C: 660C            BNE.S   $087A              ; row has tiles
```

If no tiles in row, calls `scan_leftward_extent` at 0x0870:
```
086E: 3F05            MOVE.W  D5,-(A7)
0870: 4EBA FF96       JSR     -106(PC)           ; => 0x0808 (validate_word_placement)
```

Anchor initialization loop (0x0882-0x088A):
```
087A: 47ED A14C       LEA     -24244(A5),A3      ; anchor array 1
087E: 45ED 9F4E       LEA     -24754(A5),A2      ; anchor array 2
0882: 6006            BRA.S   $088A
0884: 34BC 0001       MOVE.W  #1,(A2)            ; mark as anchor
0888: 548A            ADDQ.L  #2,A2
088A: B7CA            CMPA.L  A2,A3              ; compare pointers
088C: 62F6            BHI.S   $0884              ; loop while A3 > A2
```

When the row has no occupied tiles (0x0890-0x0906), the function fills in the cross-check lookup tables using MULS.W for row/column offset calculations.

---

### Function 0x091C (108 bytes) -- accumulate_scores

**Frame**: LINK A6,#0
**Saves**: D7/A2/A3/A4
**Confidence**: MEDIUM

Accumulates tile scores along rows by walking through score and position arrays. Uses A5-10670 (tile scores), A5-10668 (score accumulator), A5-16610 (g_state2, score grid), A5-10636 (rack pointer), A5-10738 (position data 1), A5-10704 (position data 2).

#### Key Hex Sequences

Score accumulation loop at 0x0942-0x094E:
```
0942: 3014            MOVE.W  (A4),D0            ; source score
0944: D052            ADD.W   (A2),D0            ; + accumulated
0946: 3680            MOVE.W  D0,(A3)            ; store result
0948: 548C            ADDQ.L  #2,A4              ; next source
094A: 548B            ADDQ.L  #2,A3              ; next dest
094C: 548A            ADDQ.L  #2,A2              ; next accumulator
094E: BE8B            CMP.W   A3,D7              ; reached end?
0950: 62F0            BHI.S   $0942              ; continue
```

Three accumulation passes run through different arrays (forward, reverse, and combined).

---

### Function 0x0988 (1018 bytes) -- gen_moves_at_pos

**Frame**: LINK A6,#-116
**Saves**: D3/D4/D5/D6/D7/A2/A3/A4
**Confidence**: MEDIUM

The second largest function. Generates all legal moves at a specific board position. This is the inner loop of the Appel-Jacobson algorithm.

#### Parameters
- 8(A6) = D5 = row/position
- 10(A6) = unused alignment
- 12(A6) = cross-check data pointer
- 14(A6) = rack info
- 18(A6) = flag (if 0, skip entirely)

#### Key Hex Sequences

Early exit at 0x0994:
```
0994: 4A6E 0012       TST.W   18(A6)             ; flag parameter
0998: 6700 03E0       BEQ.W   $0D7C              ; if 0, return immediately
```

Position data initialization (0x099C-0x09DC):
```
099C: 4878 0022       PEA     34                 ; 34 bytes
09A0: 486D D60E       PEA     -10738(A5)         ; position_data_1
09A4: 4EAD 01AA       JSR     426(A5)            ; memset(0)
09A8: 7022            MOVEQ   #34,D0
09AA: 2E80            MOVE.L  D0,(A7)
09AC: 486D D630       PEA     -10704(A5)         ; position_data_2
09B0: 4EAD 01AA       JSR     426(A5)            ; memset(0)
09B4: 7044            MOVEQ   #68,D0
09B6: 2E80            MOVE.L  D0,(A7)
09B8: 486E FFB8       PEA     -72(A6)            ; local cross-check buffer (68 bytes)
09BC: 4EAD 01AA       JSR     426(A5)            ; memset(0)
```

Board row pointer calculation at 0x09C0-0x09F0:
```
09C0: 7011            MOVEQ   #17,D0
09C2: 2E80            MOVE.L  D0,(A7)
09C4: 7011            MOVEQ   #17,D0
09C6: C1C5            MULS.W  D5,D0              ; row * 17
09C8: 204D            MOVEA.L A5,A0
09CA: D1C0            ADDA.L  D0,A0              ; A0 = A5 + row*17
09CC: 4868 9592       PEA     -27246(A0)         ; board data at this row
09D0: 486E FFA6       PEA     -90(A6)            ; local buffer
09D4: 4EAD 0D8A       JSR     3466(A5)           ; memmove (copy 17 bytes of row)
```

Row-above/below calculation using MULS.W #17 pattern at 0x0A0A:
```
0A0A: 70FF            MOVEQ   #-1,D0
0A0C: D045            ADD.W   D5,D0              ; row - 1
0A0E: C1FC 0011       MULS.W  #17,D0             ; (row-1) * 17
0A12: 41ED BCFE       LEA     -17154(A5),A0      ; g_state1
0A16: D088            ADD.L   A0,D0              ; &state1[(row-1)*17]
```

The function includes a complex inner loop that:
1. Iterates through columns 1-15 (0x0A84-0x0BCE)
2. Checks if cells are occupied (letter lookup via `MOVE.B (0,A0,D3.W),D4`)
3. For occupied cells, stores the letter mask from g_letter_masks
4. For empty cells, checks adjacent rows and computes cross-checks from the DAWG
5. When cross-checks indicate valid moves exist, calls into the DAWG traversal to generate actual moves (0x0BDA calls `dawg_lookup`, 0x0CB4 calls `traverse_and_gen`)

The function uses JT[2330] (board position lookup) and JT[2338] (calc_position) extensively.

---

### Function 0x0D82 (192 bytes) -- build_rack_mask

**Frame**: LINK A6,#0
**Saves**: D5/D6/D7/A4
**Confidence**: HIGH

Builds a 32-bit letter availability mask from the player's rack. If a blank tile is present, also generates the full valid-word letter set from the DAWG.

#### Hex-Verified Disassembly (Key Parts)

```
0D82: 4E56 0000       LINK    A6,#0
0D86: 48E7 0708       MOVEM.L D5/D6/D7/A4,-(SP)
0D8A: 286E 0008       MOVEA.L 8(A6),A4           ; result pointer
0D8E: 7E00            MOVEQ   #0,D7              ; result mask = 0

0D90: 102D D6B7       MOVE.B  -10569(A5),D0      ; g_blank_count
0D94: 4880            EXT.W   D0
0D96: 3B40 BCFC       MOVE.W  D0,-17156(A5)      ; g_row_counter = blank_count
0D9A: 6744            BEQ.S   $0DE0              ; no blank: simple path

; Blank path: all letters are potentially valid
0D9C: 7C61            MOVEQ   #97,D6             ; 'a' = 97
0D9E: 6016            BRA.S   $0DB6

0DA0: 204D            MOVEA.L A5,A0
0DA2: D0C6            ADDA.W  D6,A0
0DA4: 1A28 D678       MOVE.B  -10632(A0),D5      ; g_rack_counts[letter]
0DA8: 4A05            TST.B   D5
0DAA: 6708            BEQ.S   $0DB4              ; count = 0: skip
0DAC: 1005            MOVE.B  D5,D0
0DAE: 4880            EXT.W   D0
0DB0: D16D BCFC       ADD.W   D0,-17156(A5)      ; total += count
0DB4:                 (next iteration)
0DB6: 0C46 007A       CMPI.W  #122,D6            ; 'z' = 122
0DBA: 6FE4            BLE.S   $0DA0

; Call JT[3490] to copy rack for blank handling
0DBC: 206D 99D2       MOVEA.L -26158(A5),A0      ; g_rack
0DC0: 4868 0001       PEA     1(A0)              ; rack + 1
0DC4: 2F0C            MOVE.L  A4,-(A7)           ; result buffer
0DC6: 4EAD 0DA2       JSR     3490(A5)           ; JT[3490] = copy_rack

0DCA: 7EFF            MOVEQ   #-1,D7             ; mask = all bits
0DCC: DE AD 9A3E      ADD.L   -26050(A5),D7      ; adjust mask
0DD0: 202D 9A3A       MOVE.L  -26054(A5),D0
0DD4: C087            AND.L   D7,D0              ; D0 = final mask
0DD6: 508F            ADDQ.L  #8,A7
0DD8: 6638            BNE.S   $0E12
0DDA: 4EAD 01A2       JSR     418(A5)            ; bounds_error
0DDE: 6032            BRA.S   $0E12

; No-blank path: build mask from actual rack letters only
0DE0: 7C61            MOVEQ   #97,D6             ; 'a'
0DE2: 6026            BRA.S   $0E0A

0DE4: 204D            MOVEA.L A5,A0
0DE6: D0C6            ADDA.W  D6,A0
0DE8: 1A28 D678       MOVE.B  -10632(A0),D5      ; count for this letter
0DEC: 4A05            TST.B   D5
0DEE: 6718            BEQ.S   $0E08              ; not in rack: skip

0DF0: 1005            MOVE.B  D5,D0
0DF2: 4880            EXT.W   D0
0DF4: D16D BCFC       ADD.W   D0,-17156(A5)      ; total += count
0DF8: 18C6            MOVE.B  D6,(A4)+           ; *result++ = letter
0DFA: 204D            MOVEA.L A5,A0
0DFC: 2006            MOVE.L  D6,D0
0DFE: 48C0            EXT.L   D0
0E00: E588            ASL.L   #2,D0              ; *4
0E02: D1C0            ADDA.L  D0,A0
0E04: 8EA8 9852       OR.L    -26542(A0),D7      ; mask |= letter_masks[letter]

0E08: 5246            ADDQ.W  #1,D6              ; next letter
0E0A: 0C46 007A       CMPI.W  #122,D6
0E0E: 6FD4            BLE.S   $0DE4

0E10: 4214            CLR.B   (A4)               ; null-terminate result
0E12: 0C6D 0007 BCFC  CMPI.W  #7,-17156(A5)      ; cap total at 7
0E18: 6F06            BLE.S   $0E20
0E1A: 3B7C 0007 BCFC  MOVE.W  #7,-17156(A5)
0E20: 2007            MOVE.L  D7,D0              ; return mask
0E22: 4CDF 10E0       MOVEM.L (SP)+,D5/D6/D7/A4
0E26: 4E5E            UNLK    A6
0E28: 4E75            RTS
```

#### C Decompilation
```c
uint32_t build_rack_mask(char *result_buf) {
    uint32_t mask = 0;
    int16_t blank_count = g_blank_count;
    g_row_counter = blank_count;

    if (blank_count > 0) {
        /* Has blank: all letters potentially valid */
        for (int c = 'a'; c <= 'z'; c++) {
            int8_t count = g_rack_counts[c];
            if (count > 0)
                g_row_counter += count;
        }
        copy_rack(result_buf, g_rack + 1);  /* JT[3490] */
        mask = 0xFFFFFFFF;
        /* Additional mask computation from A5-26050/26054 */
    } else {
        /* No blank: only rack letters */
        for (int c = 'a'; c <= 'z'; c++) {
            int8_t count = g_rack_counts[c];
            if (count > 0) {
                g_row_counter += count;
                *result_buf++ = c;
                mask |= g_letter_masks[c];
            }
        }
        *result_buf = 0;
    }

    if (g_row_counter > 7)
        g_row_counter = 7;

    return mask;
}
```

---

### Function 0x0E2A (24 bytes, no LINK) -- check_interrupt

**No frame** (leaf function)
**Confidence**: HIGH

Checks if a user interrupt callback should be fired by comparing the Mac Toolbox `Ticks` global ($016A) against a stored deadline.

```
0E2A: 4AAD A38A       TST.L   -23670(A5)         ; g_interrupt_proc
0E2E: 6710            BEQ.S   $0E40              ; no callback: return
0E30: 2038 016A       MOVE.L  $016A.W,D0         ; Ticks (Mac global)
0E34: B0AD A38E       CMP.L   -23666(A5),D0      ; g_interrupt_deadline
0E38: 6F06            BLE.S   $0E40              ; not yet: return
0E3A: 206D A38A       MOVEA.L -23670(A5),A0      ; callback address
0E3E: 4E90            JSR     (A0)               ; call it
0E40: 4E75            RTS
```

---

### Function 0x0E42 (1296 bytes) -- evaluate_and_record_move

**Frame**: LINK A6,#-16
**Saves**: D4/D5/D6/D7/A2/A3/A4
**Confidence**: MEDIUM

The largest function in CODE 37. Called when a valid word placement has been found. It evaluates the move's score including:
- Base tile scores (from g_state2 / score grid)
- Premium square multipliers
- Cross-word scores
- Bingo bonus (all 7 tiles = 50 points)
- Leave value adjustment
- Recording the move via callback

#### Key Hex Sequences

Initial setup at 0x0E4A:
```
0E4A: 206D D5FA       MOVEA.L -10758(A5),A0      ; g_move_ptr
0E4E: 1C28 0021       MOVE.B  33(A0),D6          ; D6 = row position
0E52: 4886            EXT.W   D6
0E54: 7800            MOVEQ   #0,D4              ; D4 = score accumulator = 0
0E56: 42AE FFFC       CLR.L   -4(A6)             ; local score = 0
```

Duplicate move check via JT[802] at 0x0E5C:
```
0E5A: 2F08            MOVE.L  A0,-(A7)
0E5C: 4EAD 0322       JSR     802(A5)            ; JT[802] = check_duplicate
0E60: 588F            ADDQ.L  #4,A7
0E62: 4A40            TST.W   D0
0E64: 6600 04E4       BNE.W   $134C              ; duplicate: skip
```

Interrupt check (inlined) at 0x0E68:
```
0E68: 4AAD A38A       TST.L   -23670(A5)         ; same as check_interrupt
0E6C: 6710            BEQ.S   $0E7E
0E6E: 2038 016A       MOVE.L  $016A.W,D0
0E72: B0AD A38E       CMP.L   -23666(A5),D0
0E76: 6F06            BLE.S   $0E7E
0E78: 206D A38A       MOVEA.L -23670(A5),A0
0E7C: 4E90            JSR     (A0)
```

Score computation at 0x0EB2-0x0ECC:
```
0EB2: 4280            CLR.L   D0
0EB4: 3007            MOVE.W  D7,D0              ; word_index
0EB6: D040            ADD.W   D0,D0              ; *2 (word entries)
0EB8: 41ED 9412       LEA     -27630(A5),A0      ; g_tile_scores
0EBC: 3A30 0000       MOVE.W  (0,A0,D0.W),D5    ; tile_score[letter]
```

Premium square handling at 0x0ECE-0x0EE4:
```
0ECE: 6714            BEQ.S   $0EE4              ; no premium
0ED0: 48C5            EXT.L   D5
0ED2: 0C00 0002       CMPI.B  #2,D0              ; premium type
0ED6: 6D08            BLT.S   $0EE0              ; type 1: word multiplier
0ED8: 6704            BEQ.S   $0EDE              ; type 2: letter multiplier
0EDA: DBAE FFFC       ADD.L   D5,-4(A6)          ; type 3: add to score
0EDE: DA85            ADD.L   D5,D5              ; double letter value
0EE0: DBAE FFFC       ADD.L   D5,-4(A6)          ; add to base score
```

Blank tile handling at 0x0F0A-0x0F2A checks A5-12605 for blank presence and adjusts scoring.

Bingo bonus at 0x0FD0-0x0FEA:
```
0FD0: 302D B1D6       MOVE.W  -20010(A5),D0      ; tiles_placed count
0FD4: B06D BCFC       CMP.W   -17156(A5),D0      ; == total rack tiles?
0FD8: 661E            BNE.S   $0FFA              ; no bingo
0FDA: 206D D5FA       MOVEA.L -10758(A5),A0
0FDE: 317C 0001 001C  MOVE.W  #1,28(A0)          ; set bingo flag
0FE4: 0C6D 0007 B1D6  CMPI.W  #7,-20010(A5)      ; exactly 7 tiles?
0FEA: 6614            BNE.S   $0FFA
0FEC: 302D 9A56       MOVE.W  -26026(A5),D0      ; bingo bonus (50)
0FF0: 48C0            EXT.L   D0
0FF2: D1AE FFFC       ADD.L   D0,-4(A6)          ; add bonus to score
```

Leave evaluation call via JT[66] at 0x0FA0:
```
0F9C: 2F08            MOVE.L  A0,-(A7)           ; tile info
0F9E: 2F04            MOVE.L  D4,-(A7)           ; accumulated
0FA0: 4EAD 0042       JSR     66(A5)             ; JT[66] = evaluate_leave
```

Final move recording at 0x1326-0x1332:
```
131E: 206D D5FA       MOVEA.L -10758(A5),A0
1322: 216E FFFC 0010  MOVE.L  -4(A6),16(A0)      ; store final score
1328: 2F2D D5FA       MOVE.L  -10758(A5),-(A7)
132C: 206D D674       MOVEA.L -10636(A5),A0      ; callback function
1330: 4E90            JSR     (A0)               ; call move_recorder(move_ptr)
```

Post-recording cleanup at 0x1336-0x134A:
```
1332: 588F            ADDQ.L  #4,A7
1334: 422D CEC3       CLR.B   -12605(A5)         ; clear blank flag
1338: 266D D5FA       MOVEA.L -10758(A5),A3
133C: 41ED CE84       LEA     -12668(A5),A0      ; g_cross_info
1340: 1E1B            MOVE.B  (A3)+,D7
1342: 4887            EXT.W   D7
1344: 4230 7000       CLR.B   (0,A0,D7.W)        ; clear cross-info for each letter
1348: 1E1B            MOVE.B  (A3)+,D7
134A: 66F6            BNE.S   $1340              ; loop until null
```

---

### Function 0x1352 (146 bytes) -- extend_right_wrapper

**Frame**: LINK A6,#0
**Saves**: D6/D7/A3/A4
**Confidence**: HIGH

A LINK wrapper that passes control to the inner `extend_right` subroutine at 0x1370. The wrapper preserves registers and sets up parameters.

```
1352: 4E56 0000       LINK    A6,#0
1356: 48E7 0318       MOVEM.L D6/D7/A3/A4,-(SP)
135A: 3C2E 000C       MOVE.W  12(A6),D6          ; direction flag
135E: 2F2E 0008       MOVE.L  8(A6),-(A7)        ; DAWG node
1362: 4EBA 000C       JSR     12(PC)             ; => 0x1370 (extend_right)
1366: 4CEE 18C0 FFF0  MOVEM.L -16(A6),D6/D7/A3/A4
136C: 4E5E            UNLK    A6
136E: 4E75            RTS
```

#### Inner subroutine 0x1370 -- extend_right (no LINK)

**Saves**: D6/D7/A3/A4 (from stack)
**Confidence**: MEDIUM-HIGH

The core rightward extension of the Appel-Jacobson algorithm. Reads DAWG nodes and extends the current word rightward, checking cross-checks and rack availability.

Key pattern at 0x1378-0x138E:
```
1370: 48E7 0318       MOVEM.L D6/D7/A3/A4,-(SP)
1374: 2E2F 0014       MOVE.L  20(A7),D7          ; DAWG node from stack
1378: 5346            SUBQ.W  #1,D6              ; decrement direction counter
137A: EA87            ASR.L   #5,D7              ; shift right 5 to extract...
137C: EA87            ASR.L   #5,D7              ; ...total 10 bits (child ptr)
137E: E58F            ASL.L   #2,D7              ; *4 for DAWG index
1380: 286D D140       MOVEA.L -11968(A5),A4      ; g_dawg_base
1384: D9C7            ADDA.L  D7,A4              ; A4 = &dawg[child]
1386: 2E1C            MOVE.L  (A4)+,D7           ; D7 = DAWG node, A4 advances
```

Wait -- `EA87 EA87 E58F` decodes as: ASR.L #5,D7; ASR.L #5,D7; ASL.L #2,D7. That is: D7 >>= 10, then D7 <<= 2. Net effect: (node >> 10) << 2 = (node >> 10) * 4. This extracts the child pointer and converts to a byte offset in one sequence. Elegant.

The node's child pointer field check:
```
1388: 203C FFFF FC00  MOVE.L  #$FFFFFC00,D0      ; mask = ~0x3FF
138E: C087            AND.L   D7,D0              ; child bits (10-31)
1390: 6744            BEQ.S   $13D6              ; no child: done
```

Rack availability check:
```
1392: 1007            MOVE.B  D7,D0              ; letter
1394: 4880            EXT.W   D0
1396: 47ED D678       LEA     -10632(A5),A3      ; g_rack_counts
139A: D6C0            ADDA.W  D0,A3              ; &rack_counts[letter]
139C: 4A13            TST.B   (A3)               ; available?
139E: 6608            BNE.S   $13A8              ; yes
13A0: 47ED D6B7       LEA     -10569(A5),A3      ; g_blank_count
13A4: 4A13            TST.B   (A3)               ; blank available?
13A6: 672E            BEQ.S   $13D6              ; no: skip
```

Recursive call and letter placement:
```
13A8: 206D D606       MOVEA.L -10746(A5),A0      ; g_word_cursor
13AC: 52AD D606       ADDQ.L  #1,-10746(A5)      ; cursor++
13B0: 1087            MOVE.B  D7,(A0)            ; *cursor = letter
13B2: 5313            SUBQ.B  #1,(A3)            ; consume from rack
13B4: 0247 FEFF       ANDI.W  #$FEFF,D7          ; clear EOW bit for child call
13B8: 246D D6F8       MOVEA.L -10504(A5),A2      ; cross-check ptr
13BC: 2F07            MOVE.L  D7,-(A7)
13BE: 6100 0042       BSR.W   $1404              ; => extend_left (inner)
13C2: 588F            ADDQ.L  #4,A7
13C4: 4A46            TST.W   D6                 ; still extending?
13C6: 6708            BEQ.S   $13D0
13C8: 2F07            MOVE.L  D7,-(A7)
13CA: 6100 FFA4       BSR.W   $1372              ; => extend_right (recursive)
13CE: 588F            ADDQ.L  #4,A7
```

Backtrack and sibling iteration:
```
13D0: 5213            ADDQ.B  #1,(A3)            ; restore rack count
13D2: 53AD D606       SUBQ.L  #1,-10746(A5)      ; cursor--
13D6: 0807 0009       BTST    #9,D7              ; last sibling?
13DA: 67AA            BEQ.S   $1386              ; no: next sibling (A4 already advanced)
13DC: 5246            ADDQ.W  #1,D6              ; restore direction counter
13DE: 4CDF 18C0       MOVEM.L (SP)+,D6/D7/A3/A4
13E2: 4E75            RTS
```

---

### Function 0x13E4 (252 bytes) -- extend_left_wrapper

**Frame**: LINK A6,#0
**Saves**: D5/D6/D7/A2/A3/A4
**Confidence**: HIGH

Wrapper for the inner `extend_left` subroutine at 0x1402.

```
13E4: 4E56 0000       LINK    A6,#0
13E8: 48E7 0738       MOVEM.L D5/D6/D7/A2/A3/A4,-(SP)
13EC: 246E 000C       MOVEA.L 12(A6),A2           ; word pointer/suffix
13F0: 2F2E 0008       MOVE.L  8(A6),-(A7)        ; DAWG node
13F4: 4EBA 000C       JSR     12(PC)             ; => 0x1402 (extend_left)
13F8: 4CEE 1CE0 FFE8  MOVEM.L -24(A6),D5/D6/D7/A2/A3/A4
13FE: 4E5E            UNLK    A6
1400: 4E75            RTS
```

#### Inner subroutine 0x1402 -- extend_left (no LINK)

**Saves**: D5/D6/D7/A2/A3/A4
**Confidence**: MEDIUM-HIGH

The leftward extension of Appel-Jacobson. Reads letters from the word pointer (A2) and matches them against DAWG nodes, extending the prefix leftward.

Key entry at 0x1402:
```
1402: 48E7 0738       MOVEM.L D5/D6/D7/A2/A3/A4,-(SP)
1406: 2E2F 001C       MOVE.L  28(A7),D7          ; DAWG node from stack
140A: 1A1A            MOVE.B  (A2)+,D5           ; next letter from word (leftward)
140C: 6740            BEQ.S   $144E              ; end of prefix
```

DAWG child extraction (same ASR-ASR-ASL pattern):
```
140E: EA8F            LSR.L   #5,D7
1410: EA8F            LSR.L   #5,D7              ; >>10 total (using LSR this time)
1412: E58F            ASL.L   #2,D7              ; *4
1414: 286D D140       MOVEA.L -11968(A5),A4      ; g_dawg_base
1418: D9C7            ADDA.L  D7,A4              ; A4 = &dawg[child]
141A: 2E1C            MOVE.L  (A4)+,D7           ; D7 = node, A4 advances
```

**Note**: 0x140E uses `EA8F` = LSR.L #5,D7 (logical shift right) instead of `EA87` = ASR.L #5,D7 (arithmetic shift right) used in extend_right. Both achieve the same result since DAWG child pointers are unsigned 22-bit values.

Letter matching:
```
141C: 0807 0009       BTST    #9,D7              ; last sibling?
1420: 6604            BNE.S   $1426              ; yes: check match
1422: BE05            CMP.B   D5,D7              ; node_letter vs target
1424: 6DF4            BLT.S   $141A              ; too small: next sibling
1426: BE05            CMP.B   D5,D7              ; exact match?
1428: 6600 00AE       BNE.W   $14DA              ; no: done
```

EOW handling when prefix consumed:
```
144E: 0807 0008       BTST    #8,D7              ; EOW?
1452: 6722            BEQ.S   $1476              ; no: just descend
1454: 206D D606       MOVEA.L -10746(A5),A0      ; g_word_cursor
1458: 4210            CLR.B   (A0)               ; terminate word
145A: 202D D606       MOVE.L  -10746(A5),D0
145E: 90AD D5FA       SUB.L   -10758(A5),D0      ; word length
1462: 220A            MOVE.L  A2,D1
1464: 92AD D60A       SUB.L   -10742(A5),D1      ; prefix length
1468: 9200            SUB.B   D0,D1              ; adjust
146A: 206D D5FA       MOVEA.L -10758(A5),A0
146E: 1141 0021       MOVE.B  D1,33(A0)          ; set start position
1472: 4EBA F9CE       JSR     -1586(PC)          ; => 0x0E42 (evaluate_and_record_move)
```

Cross-check extension (when continuing past anchor):
```
1476: EA8F            LSR.L   #5,D7              ; child >>10 again
1478: EA8F            LSR.L   #5,D7
147A: 675C            BEQ.S   $14D8              ; no child: done

147C: 206D D6FC       MOVEA.L -10500(A5),A0      ; cross-check data
1480: 2C10            MOVE.L  (A0),D6            ; cross-check mask
1482: 6754            BEQ.S   $14D8              ; no valid letters: done

1484: E58F            ASL.L   #2,D7              ; *4
1486: 286D D140       MOVEA.L -11968(A5),A4
148A: D9C7            ADDA.L  D7,A4              ; &dawg[child]
148C: 2E1C            MOVE.L  (A4)+,D7           ; load node
```

Cross-check filtering:
```
148E: 4280            CLR.L   D0
1490: 1007            MOVE.B  D7,D0              ; letter
1492: 0400 0061       SUBI.B  #$61,D0            ; subtract 'a'
1496: 0106            BTST    D0,D6              ; test bit in cross-check mask
1498: 6738            BEQ.S   $14D2              ; not valid: skip
```

This is the key cross-check test: the letter code minus 'a' gives a bit position in the 32-bit cross-check mask. If that bit is set, the letter is valid at this position.

---

## Global Variable Reference Table

| A5 Offset | Size | Name | Purpose |
|-----------|------|------|---------|
| -1064 | 256B | g_char_class | Character classification table (negative = valid letter) |
| -1714 | 17B | g_empty_row | All-zeros row buffer for boundary comparisons |
| -1778 | 64B | g_valid_letters_buf | Result buffer for find_valid_letters |
| -10500 | 4B | g_xcheck_ptr | Pointer to current cross-check entry |
| -10504 | 4B | g_xcheck_data_ptr | Pointer to cross-check data |
| -10569 | 1B | g_blank_count | Number of blank tiles in rack |
| -10632 | 128B | g_rack_counts | Per-letter count from rack (indexed by ASCII) |
| -10636 | 4B | g_rack_storage | Saved rack pointer / move callback |
| -10668 | 2B | g_score_accum_2 | Score accumulator (second pass) |
| -10670 | 2B | g_score_accum_1 | Score accumulator (first pass) |
| -10704 | 34B | g_position_data_2 | Position tracking array 2 |
| -10738 | 34B | g_position_data_1 | Position tracking array 1 |
| -10742 | 4B | g_prefix_base | Base pointer for prefix calculation |
| -10746 | 4B | g_word_cursor | Current write position in word buffer |
| -10750 | 4B | g_letter_data_ptr | Letter data pointer |
| -10754 | 4B | g_board_row_ptr | Current board row pointer |
| -10758 | 4B | g_move_ptr | Pointer to current move structure |
| -10936 | 2B | g_dict_index | Current dictionary index (0-based) |
| -11960 | 32B | g_dawg_table | Array of DAWG base pointers (up to 8 dictionaries) |
| -11964 | 4B | g_dawg_root | Root node index for current dictionary |
| -11968 | 4B | g_dawg_base | Base address of current DAWG data |
| -12605 | 1B | g_blank_flag | Whether current move uses blank tile |
| -12668 | 128B | g_cross_info | Cross-word information for each letter |
| -16610 | 544B | g_state2 | Board score grid (17x32) |
| -17018 | -- | g_board_base+136 | Board offset (row 8) |
| -17137 | -- | g_state1+17 | First playable row of board |
| -17154 | 544B | g_state1 | Board letter grid (17x32, includes borders) |
| -17156 | 2B | g_row_counter | Tile count / row counter |
| -19487 | 1B | g_blank_letter_2 | Second blank tile assignment |
| -19488 | 1B | g_blank_letter_1 | First blank tile assignment |
| -20010 | 2B | g_tiles_placed | Number of tiles placed in current move |
| -22118 | 2108B | g_crosschecks | Cross-check array (31 rows x 68 bytes) |
| -23218 | 128B | g_letter_counts | Master letter count array |
| -23670 | 4B | g_interrupt_proc | User interrupt callback (or NULL) |
| -23666 | 4B | g_interrupt_deadline | Ticks deadline for interrupt |
| -24244 | -- | g_anchor_array_1 | Anchor square array (high) |
| -24754 | -- | g_anchor_array_2 | Anchor square array (low) |
| -24788 | -- | g_position_scores | Position score table |
| -26026 | 2B | g_bingo_bonus | Bingo bonus value (typically 50) |
| -26050 | 4B | g_rack_mask_adj | Rack mask adjustment value |
| -26054 | 4B | g_rack_mask_base | Rack mask base value |
| -26150 | -- | g_xcheck_array_b | Cross-check mask array B |
| -26154 | -- | g_xcheck_array_a | Cross-check mask array A |
| -26158 | 4B | g_rack | Pointer to player's rack |
| -26542 | 256B | g_letter_masks | 32-bit letter mask table (indexed by letter*4) |
| -26702 | -- | g_word_buffer | Word placement buffer |
| -27110 | -- | g_letter_data | Letter data base |
| -27127 | -- | g_constraint_a | Position constraint array A |
| -27093 | -- | g_constraint_c | Position constraint array C |
| -26583 | -- | g_constraint_b | Position constraint array B |
| -26549 | -- | g_constraint_d | Position constraint array D |
| -27246 | -- | g_board_data | Board data (offset from A5+row*17) |
| -27630 | -- | g_tile_scores | Tile score values (word-indexed) |

## Jump Table Reference

| JT Offset | Function | Called From |
|-----------|----------|------------|
| 66 | evaluate_leave (CODE 1 dispatch -> CODE 32) | 0x0E42 (evaluate_and_record_move) |
| 418 | bounds_error | 0x010E, 0x024A, 0x0544, 0x0988, 0x0E42 |
| 426 | memset | 0x0000, 0x00D2, 0x0544, 0x0988 |
| 802 | check_duplicate_move | 0x0E42 |
| 2002 | is_playable | 0x024A |
| 2330 | board_position_lookup | 0x0988 |
| 2338 | calc_position | 0x010E, 0x0544, 0x0988 |
| 2370 | setup_scoring | 0x0544 |
| 2378 | cleanup_scoring | 0x0544 |
| 2410 | commit_score | 0x0544 |
| 3450 | memcmp | 0x0000, 0x0544 |
| 3466 | memmove | 0x00D2, 0x0988 |
| 3490 | copy_rack | 0x0D82 |
| 3522 | strlen | 0x0544 |

## Cross-Check Generation Algorithm

The cross-check algorithm (function 0x010E) works as follows:

1. **For each row** (1 through 30, skipping border rows 0 and 31):
   - Get pointers to the row above and below. Border rows use an all-zeros buffer.
   - **For each column** (1 through 15):
     - If the cell is **occupied**: the cross-check mask is the single letter's mask (only that letter valid)
     - If the cell is **empty with no perpendicular neighbors**: mask = 0xFFFFFFFF (all letters valid)
     - If the cell is **empty with perpendicular neighbor(s)**: scan to find the start of the cross-word, then call `find_valid_letters()` to query the DAWG for which letters complete valid perpendicular words. OR each valid letter's mask into the cross-check.

2. **Cross-check masks** are 32-bit values stored in 68-byte row structures. Bit N being set means letter N is valid at that position.

3. **The extend_left function** (0x1402) tests cross-checks at 0x1496:
   ```
   SUBI.B  #$61,D0    ; letter - 'a'
   BTST    D0,D6      ; test bit in cross-check mask
   ```
   This confirms the cross-check mask uses bit positions 0-25 for letters a-z.

## Appel-Jacobson Move Generation

The Appel-Jacobson algorithm is split across several functions:

1. **init_cross_checks** (0x0000): Entry point. Checks if board changed, regenerates cross-checks and anchor squares if needed.

2. **process_row_words** (0x07B2): Iterates over all 31 positions in a row, calling gen_moves_at_pos for each.

3. **gen_moves_at_pos** (0x0988): For a single anchor position, sets up the DAWG root and calls extend_right and extend_left.

4. **extend_right** (0x1370): Extends the current partial word rightward through the DAWG. For each matching node, checks rack availability and cross-checks, then recurses. When EOW is found, the move is evaluated.

5. **extend_left** (0x1402): Extends leftward from the anchor. Reads letters from the existing word buffer (placed tiles) and matches against DAWG nodes. When the prefix is consumed, if EOW is set, calls evaluate_and_record_move.

6. **evaluate_and_record_move** (0x0E42): Computes the full score (tile values, premiums, cross-words, bingo bonus, leave value) and records the move via a callback function.

## Function Summary Table

| Offset | Size | Name | Confidence |
|--------|------|------|------------|
| 0x0000 | 210 | init_cross_checks | HIGH |
| 0x00D2 | 60 | setup_board_context | HIGH |
| 0x010E | 316 | generate_cross_check_sets | HIGH |
| 0x024A | 286 | traverse_and_gen | HIGH |
| 0x0368 | 98 | dawg_lookup | HIGH |
| 0x03CA | 268 | find_valid_letters | HIGH |
| 0x04D6 | 48 | cross_check_mask_diff | HIGH |
| 0x0506 | 62 | scan_leftward_extent | HIGH |
| 0x0544 | 622 | generate_moves_for_anchor | MEDIUM-HIGH |
| 0x07B2 | 86 | process_row_words | MEDIUM-HIGH |
| 0x0808 | 66 | validate_word_placement | HIGH |
| 0x084A | 210 | setup_anchor_row | MEDIUM-HIGH |
| 0x091C | 108 | accumulate_scores | MEDIUM |
| 0x0988 | 1018 | gen_moves_at_pos | MEDIUM |
| 0x0D82 | 192 | build_rack_mask | HIGH |
| 0x0E42 | 1296 | evaluate_and_record_move | MEDIUM |
| 0x1352 | 146 | extend_right_wrapper + inner | HIGH |
| 0x13E4 | 252 | extend_left_wrapper + inner | MEDIUM-HIGH |

## Key Corrections from Hex Verification

1. **DAWG entry size is 4 bytes, not 8.** The code uses `ASL.L #2,D0` (E588) for DAWG indexing. The `ASL.L #3,D0` (E788) pattern is used only for the letter-set table at A5-11960 which has 8-byte entries.

2. **The disassembler's mangled MULS.W instructions** (`C1FC 0011`, `C1C5`, etc.) were consistently misread as `ANDA.L`. All verified as `MULS.W`.

3. **Stack cleanup instructions** (`508F`, `588F`, `5C8F`, `548F`) were consistently misread as `MOVE.B` operations. These are `ADDQ.L #n,A7` for stack cleanup after function calls.

4. **The child pointer extraction uses register-counted shifts** (`720A E2A8` = `MOVEQ #10,D1; ASR.L D1,D0`) at function boundaries, but the inner recursive subroutines use a more compact double-immediate-shift pattern (`EA87 EA87 E58F` = `ASR.L #5,D7; ASR.L #5,D7; ASL.L #2,D7`) that combines extraction and byte-offset conversion.

5. **Cross-check bit testing** uses `SUBI.B #$61,D0; BTST D0,D6` where $61 = 'a', confirming letter codes are ASCII lowercase.

6. **The function count is 18** (15 LINK-framed functions plus 3 inner subroutines at 0x0E2A, 0x1370, and 0x1402), not "~10" as the original analysis stated.
